/*
 *  @Name:     catalog
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    fyoucon@gmail.com
 *  @Creation: 29-10-2017 21:45:51
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 12-08-2018 22:41:04 UTC+1
 *  
 *  @Description:
 *  
 */

package main;

import "core:os";
import "core:fmt";
import "core:strings";
import "core:thread";
import "core:mem";
import "core:sync";
import "core:hash";

import win32 "core:sys/win32"; //FIXME

import     "shared:libbrew/gl";
import sys "shared:libbrew/sys";
import     "shared:libbrew/util";

import console "shared:libbrew/console";

Asset_Kind :: enum {
    Texture,
    Sound,
    ShaderSource,
    Font,
    Model3D,
    Meta,
    TextAsset,
    Unknown,
}

_extensions_to_types : map[string]Asset_Kind;
created_catalogs : [dynamic]^Catalog;

Catalog :: struct {
    name : string,
    path : string,

    items      : map[string]^Asset,
    items_kind : map[Asset_Kind]int,

    files_in_catalog : int,
    max_size         : int,
    current_size     : int,

    _notify_thread : ^thread.Thread,
}

Change_Type :: enum {
    Modify,
    Add,
    Remove,
}

Change_Notification :: struct {
    change : Change_Type,
    asset_id : string,
    catalog : ^Catalog,
}

_change_mutex : sync.Mutex;
_change_queue : [dynamic]Change_Notification;

setup_mutex :: proc() {
    sync.mutex_init(&_change_mutex);
}

handle_changes :: proc() {
    //TODO(Hoej): Use try locks instead.
    sync.mutex_lock(&_change_mutex);
    qlen := len(_change_queue);
    sync.mutex_unlock(&_change_mutex);
    
    for qlen > 0{
        sync.mutex_lock(&_change_mutex);
        noti := dyna_util.pop_front(&_change_queue);
        qlen -= 1;
        sync.mutex_unlock(&_change_mutex);
        
        //handle
        asset := find(noti.catalog, noti.asset_id);
        switch a in asset.derived {
            case ^Shader : {
                _reload_shader(a, noti.catalog);
            }
        }
    }
}

add_default_extensions :: proc() {
    add_extensions(Asset_Kind.Texture, ".png", ".bmp", ".PNG", ".jpg", ".jpeg");
    add_extensions(Asset_Kind.Sound, ".ogg");
    add_extensions(Asset_Kind.ShaderSource, ".vs", ".vert", ".glslv");
    add_extensions(Asset_Kind.ShaderSource, ".fs", ".frag", ".glslf");
    add_extensions(Asset_Kind.Font, ".ttf");
    add_extensions(Asset_Kind.Model3D, ".obj");
}

add_extensions :: proc(kind : Asset_Kind, exts : ..string) {
    for e in exts {
        _extensions_to_types[e] = kind;
    }
}

create :: proc(name : string, path : string) -> ^Catalog {
    add_texture :: proc(asset : ^Asset) {
        texture := new(Texture);
        err := stbi.info(&asset.info.path[0], &texture.width, &texture.height, &texture.comp);
        if err == 0 {
            console.logf_error("asset %s could not be opened or is not a recognized format by stb_image", asset.file_name);
        }
        texture.asset = asset;
        asset.derived = texture;
    }

    add_shader :: proc(asset : ^Asset) {
        shader := new(Shader);

        //TODO(@Hoej): Fix this, this is bad
        switch string_util.get_last_extension(asset.path) {
            case ".vs" : { shader.type_ = gl.ShaderTypes.Vertex; }
            case ".glslv" : { shader.type_ = gl.ShaderTypes.Vertex; }
            case ".vert" : { shader.type_ = gl.ShaderTypes.Vertex; }

            case ".fs" : { shader.type_ = gl.ShaderTypes.Fragment; }
            case ".frag" : { shader.type_ = gl.ShaderTypes.Fragment; }
            case ".glslf" : { shader.type_ = gl.ShaderTypes.Fragment; }
        }
        shader.asset = asset;
        asset.derived = shader;
    }

    add_text_asset :: proc(asset : ^Asset) {
        text_asset := new(TextAsset);
        text_asset.extension = string_util.get_last_extension(asset.info.path);
        text_asset.asset = asset;
        asset.derived = text_asset;
    }

    add_font :: proc(asset : ^Asset) {
        font := new(Font);
        font.asset = asset;
        asset.derived = font;
    }

    add_model_3d :: proc(asset : ^Asset) {
        model := new(Model_3d);
        model.asset = asset;
        asset.derived = model;
    }

    if file.is_directory(path) {
        res := new(Catalog);
        res.name = name;
        res.path = path;

        entries := file.get_all_entries_in_directory(path, true);
        res.files_in_catalog = len(entries);

        for entry_path in entries {
            if file.is_directory(entry_path) do continue;
            ext := string_util.get_last_extension(entry_path);

            asset := new(Asset);

            info := Asset_Info{};
            //NOTE(Hoej): Looks funny but is correct, first removes the extension but the path is still there
            //            so the second one removes it
            asset.info.file_name = string_util.remove_last_extension(entry_path);
            asset.info.file_name = string_util.remove_path_from_file(asset.info.file_name);
            asset.info.path = entry_path;
            asset.info.size += file.get_file_size(entry_path);
            res.max_size += asset.info.size;            
            if val, ok := _extensions_to_types[ext]; ok {
                switch val {
                    case Asset_Kind.Texture: {
                        add_texture(asset);
                    }

                    case Asset_Kind.ShaderSource: {
                        add_shader(asset);
                    }

                    case Asset_Kind.TextAsset: {
                        add_text_asset(asset);
                    }

                    case Asset_Kind.Model3D: {
                        add_model_3d(asset);
                    }
                }
                res.items_kind[val] += 1;
            } else {
                res.items_kind[Asset_Kind.Unknown] += 1;
                free(asset);
                continue;
            }
            
            val, exists := res.items[asset.info.file_name];
            if exists {
                console.logf_warning("(%s catalog) Asset id: %s already exists, overwriting...\n%s vs %s", res.name, 
                                                                                                        asset.info.file_name, 
                                                                                                        val.info.path, 
                                                                                                        asset.info.path);
                free(val); 
            }

            res.items[asset.info.file_name] = asset;
        }

        append(&created_catalogs, res);
        
        _setup_notification(res);
        
        return res;
    } else {
        console.logf_error("(%s catalog) %s is either not a folder or does not exists.", name, path);
        return nil;
    }
}

find :: proc[find_typed, find_untyped];

find_typed :: proc(catalog : ^Catalog, id_str : string, T : type) -> ^T {
    ptr := find(catalog, id_str);
    if ptr != nil {
        res, ok := ptr.derived.(^T);
        if ok {
            return res;
        } else {
            return nil;
        }
    } else {
        return nil;       
    }
}

find_untyped :: proc(catalog : ^Catalog, id_str : string) -> ^Asset {
    asset, ok := catalog.items[id_str];

    if ok {
        switch b in asset.derived {
            case ^Texture : {
                _load_texture(b, catalog);
            }

            case ^Shader : {
                _load_shader(b, catalog);
            }

            case ^Shader : {
                _load_shader(b, catalog);
            }

            case ^Model_3d : {
                _load_model_3d(b, catalog);
            }

            case : 
                //TODO(Hoej): Make better error message
                console.logf_warning("(%s Catalog) System does not know how to load '%s' of type %T", catalog.name, id_str, b);
        }

        return asset;
    }
    console.logf_error("(%s Catalog) Could not find an asset named '%s'", catalog.name, id_str);
    return nil;
}

_load_model_3d :: proc(model : ^Model_3d, cat : ^Catalog) {
    if !model.info.loaded {
        text, ok := os.read_entire_file(model.info.path); defer free(text);
        if ok {
            asset := model.asset;
            model^ = obj.parse(string(text), cat.path);
            model.asset = asset;
            model.info.loaded = true;
        } else {
            console.logf_error("(%s Catalog) Could not read %s", cat.name, model.file_name);
        }
    } 
}

_load_texture :: proc(texture : ^Texture, cat : ^Catalog) {
    if !texture.info.loaded {
        //TODO(Hoej): Probably shouldn't keep this around. Should free it.
        texture.data = stbi.load(&texture.info.path[0], &texture.width, &texture.height, &texture.comp, 0);
        if texture.data != nil {
            texture.info.loaded = true;
            cat.current_size += texture.info.size;
        } else {
            console.logf_error("Image %s could not be loaded by stb_image", texture.info.file_name);
        }
    }

    if texture.gl_id == 0 && texture.info.loaded {
        texture.gl_id = gl.gen_texture();
        append(&debug_info.ogl.textures, texture.gl_id);
        prev_id := gl.get_integer(gl.GetIntegerNames.TextureBinding2D);
        gl.bind_texture(gl.TextureTargets.Texture2D, texture.gl_id);
        format : gl.PixelDataFormat;
        switch texture.comp {
            case 1 : {
                format = gl.PixelDataFormat.Red;
            }

            case 2 : {
                format = gl.PixelDataFormat.RG;
            }

            case 3 : {
                format = gl.PixelDataFormat.RGB;
            }

            case 4 : {
                format = gl.PixelDataFormat.RGBA;
            }
        }
        gl.tex_image2d(gl.TextureTargets.Texture2D, 0,              gl.InternalColorFormat.RGBA,
                       texture.width,               texture.height, format, 
                       gl.Texture2DDataType.UByte,  texture.data); 
        gl.generate_mipmap(gl.MipmapTargets.Texture2D);

        gl.tex_parameteri(gl.TextureTargets.Texture2D, gl.TextureParameters.MinFilter, gl.TextureParametersValues.LinearMipmapLinear);
        gl.tex_parameteri(gl.TextureTargets.Texture2D, gl.TextureParameters.MagFilter, gl.TextureParametersValues.Linear);

        gl.tex_parameteri(gl.TextureTargets.Texture2D, gl.TextureParameters.WrapS, gl.TextureParametersValues.ClampToEdge);
        gl.tex_parameteri(gl.TextureTargets.Texture2D, gl.TextureParameters.WrapT, gl.TextureParametersValues.ClampToEdge);

        gl.bind_texture(gl.TextureTargets.Texture2D, gl.Texture(prev_id));
    }
}

_load_shader :: proc(shader : ^Shader, cat : ^Catalog) {
    if !shader.info.loaded {
        data, success := os.read_entire_file(shader.info.path);
        if success {
            shader.data = data;
            shader.source = strings.to_odin_string(&shader.data[0]);

            shader.info.loaded = true;
            cat.current_size += shader.info.size;
            shader.fnv64_hash = hash.fnv64(shader.data);
        } else {
            console.logf_error("%s could not be read from disk", shader.info.file_name);
        }
    }

    if shader.gl_id == 0 && shader.info.loaded {
        success := gl_util.create_and_compile_shader(shader);
        if !success {
            console.logf_error("Shader %s could not be compiled", shader.info.file_name);
        }
    }
}

_reload_shader :: proc(shader : ^Shader, cat : ^Catalog) {
    if !shader.info.loaded {
        return;
    }
    data, success := os.read_entire_file(shader.info.path);
    if len(data) == len(shader.data) {
        checksum := hash.fnv64(data);
        if shader.fnv64_hash == checksum {
            return;
        }
    }

    cat.current_size -= shader.info.size;
    if success {
        shader.data = data;
        shader.fnv64_hash = hash.fnv64(shader.data);
        shader.source = strings.to_odin_string(&shader.data[0]);
        cat.current_size += shader.info.size;
    } else {
         console.logf_error("%s could not be read from disk", shader.info.file_name);
         return;
    }

    console.logf("(%s catalog) Re-compiling %s shader", cat.name, shader.file_name);
    ok := gl_util.compile_shader(shader);
    if ok {
        gl.link_program(shader.program);
    }
}

_load_font :: proc(font : ^Font, cat : ^Catalog) {
    if !font.loaded {
        data, ok := os.read_entire_file(font.path);
        if ok {
            font.data = data;
        } else {
            console.logf_error("Could not load font %s", font.file_name);
        }
    }
}

_setup_notification :: proc(cat : ^Catalog) {
    cstr := strings.new_c_string(cat.path); defer free(cstr);
    dirh := win32.create_file_a(cstr, win32.FILE_GENERIC_READ, win32.FILE_SHARE_READ | win32.FILE_SHARE_DELETE | win32.FILE_SHARE_WRITE, nil, 
                                win32.OPEN_EXISTING, win32.FILE_FLAG_BACKUP_SEMANTICS, nil);
    if dirh == win32.INVALID_HANDLE {
        console.logf_error("(%s catalog) Could not open directory at.", cat.name, cat.path);
        return;
    }
    
    _payload :: struct {
        dir_handle : win32.Handle,
        cat        : ^Catalog,
        buf        : rawptr,
        buf_len    : u32,
    }

    p := new(_payload);
    p.dir_handle = dirh;
    p.cat = cat;
    p.buf = alloc(4096);
    p.buf_len = 4096;

    _proc :: proc(thread : ^thread.Thread) -> int {
        using p := cast(^_payload)thread.data;
        for {
            out : u32;
            ok := win32.read_directory_changes_w(dir_handle, buf, buf_len, false,
                                                  win32.FILE_NOTIFY_CHANGE_LAST_WRITE | win32.FILE_NOTIFY_CHANGE_FILE_NAME, 
                                                  &out, nil, nil);
            if ok {
                c := cast(^win32.File_Notify_Information)buf;
                for c != nil {
                    wlen := int(c.file_name_length) / size_of(u16);
                    wstr := &c.file_name[0];
                    req := win32.wide_char_to_multi_byte(win32.CP_UTF8, 0, 
                                            wstr, i32(wlen),
                                            nil, 0, 
                                            nil, nil);
                    asset_id := "N/A";
                    if req != 0 {
                        buf := make([]byte, req);
                        ok := win32.wide_char_to_multi_byte(win32.CP_UTF8, 0, 
                                                      wstr, i32(wlen),
                                                      &buf[0], i32(len(buf)), 
                                                      nil, nil);
                        str := string(buf[:]);
                        asset_id = string_util.remove_last_extension(str);
                    } 

                    switch c.action {
                        case win32.FILE_ACTION_ADDED : {
                        }

                        case win32.FILE_ACTION_REMOVED : {
                        }

                        case win32.FILE_ACTION_MODIFIED : {
                            
                            noti := Change_Notification{};
                            noti.change = Change_Type.Modify;
                            noti.asset_id = asset_id;
                            noti.catalog = cat;
                            _push_change(noti);
                        }                                                
                    }

                    if c.next_entry_offset == 0 {
                        c = nil;
                    } else {
                        c = cast(^win32.File_Notify_Information)(cast(^byte)c + c.next_entry_offset);
                    }
                }
            } else {
                console.log(win32.get_last_error());
                break;
            }
        }

        win32.close_handle(dir_handle);
        free(p);
        return 0;
    }

    cat._notify_thread = thread.create(_proc);
    cat._notify_thread.data = p;
    thread.start(cat._notify_thread);
}

_push_change :: proc(noti : Change_Notification) -> bool {
    sync.mutex_lock(&_change_mutex);
    already := false;
    for c in _change_queue {
        if c.asset_id == noti.asset_id &&
           c.change == noti.change {
            already = true;
            break;
        }
    }
        
    if !already do append(&_change_queue, noti);

    sync.mutex_unlock(&_change_mutex);
    return !already;
}