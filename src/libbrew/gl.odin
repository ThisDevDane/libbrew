/*
 *  @Name:     gl
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    hjortshoej@handmade.network
 *  @Creation: 10-06-2017 17:40:33
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 15-06-2017 21:33:06
 *  
 *  @Description:
 *  
 */

foreign_system_library lib "opengl32.lib" when ODIN_OS == "WINDOWS";
import "fmt.odin";
import "strings.odin";
import "math.odin";

import "libbrew.odin";

import_load "gl_enums.odin";

const {
    TRUE  = 1;
    FALSE = 0;
}

// Types
type VAO u32;
type VBO u32;
type EBO u32;
type BufferObject u32;
type Texture u32;
type Shader u32; 

type Program struct {
    ID         : u32,
    Vertex     : Shader,
    Fragment   : Shader,
    Uniforms   : map[string]i32,
    Attributes : map[string]i32,
}

type DebugMessageCallbackProc proc(source : DebugSource, type_ : DebugType, id : i32, severity : DebugSeverity, length : i32, message : ^u8, userParam : rawptr) #cc_c;

// API 

proc depth_func(func : DepthFuncs) {
    if _depth_func != nil {
        _depth_func(i32(func));
    } else {
        fmt.printf("%s ins't loaded! \n", #procedure);
    }
}

proc generate_mipmap(target : MipmapTargets) {
    if _generate_mipmap != nil {
        _generate_mipmap(i32(target));
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}

proc polygon_mode(face : PolygonFace, mode : PolygonModes) {
    if _polygon_mode != nil {
        _polygon_mode(i32(face), i32(mode));
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}

proc debug_message_control(source : DebugSource, type_ : DebugType, severity : DebugSeverity, count : i32, ids : ^u32, enabled : bool) {
    if _debug_message_control != nil {
        _debug_message_control(i32(source), i32(type_), i32(severity), count, ids, enabled);
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}

proc debug_message_callback(callback : DebugMessageCallbackProc, userParam : rawptr) {
    if _debug_message_callback != nil {
        _debug_message_callback(callback, userParam);
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}


proc clear(mask : ClearFlags) {
    _clear(i32(mask));
}

proc buffer_data(target : BufferTargets, data : []f32, usage : BufferDataUsage) {
    if _buffer_data != nil {
        _buffer_data(i32(target), size_of(data), &data[0], i32(usage));
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }     
}

proc buffer_data(target : BufferTargets, data : []u32, usage : BufferDataUsage) {
    if _buffer_data != nil {
        _buffer_data(i32(target), size_of(data), &data[0], i32(usage));
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }     
}


proc buffer_data(target : BufferTargets, size : i32, data : rawptr, usage : BufferDataUsage) {
    if _buffer_data != nil {
        _buffer_data(i32(target), size, data, i32(usage));
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }     
}

proc gen_vbo() -> VBO {
    var bo = gen_buffer();
    return VBO(bo);
}

proc gen_ebo() -> EBO {
    var bo = gen_buffer();
    return EBO(bo);
}

proc gen_buffer() -> BufferObject {
    if _gen_buffers != nil {
        var res : BufferObject;
        _gen_buffers(1, ^u32(&res));
        return res;
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
        return 0;
    }      
}

proc gen_buffers(n : i32) -> []BufferObject {
    if _gen_buffers != nil {
        var res = make([]BufferObject, n);
        _gen_buffers(n, ^u32(&res[0]));
        return res;
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
        return nil;
    }       
}

proc bind_buffer(target : BufferTargets, buffer : BufferObject) {
    if _bind_buffer != nil {
        _bind_buffer(i32(target), u32(buffer));
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }       
}

proc bind_buffer(vbo : VBO) {
    bind_buffer(BufferTargets.Array, BufferObject(vbo));
}

proc bind_buffer(ebo : EBO) {
    bind_buffer(BufferTargets.ElementArray, BufferObject(ebo));
     
}

proc bind_frag_data_location(program : Program, colorNumber : u32, name : string) {
    if _bind_frag_data_location != nil {
        var c = strings.new_c_string(name);
        _bind_frag_data_location(program.ID, colorNumber, c);
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);      
    }
}

proc gen_vertex_array() -> VAO {
    if _gen_vertex_arrays != nil {
        var res : VAO;
        _gen_vertex_arrays(1, ^u32(&res));
        return res;
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }  

    return 0;
}

proc gen_vertex_arrays(count : i32) -> []VAO {
    if _gen_vertex_arrays != nil {
        var res = make([]VAO, count);
        _gen_vertex_arrays(count, ^u32(&res[0]));
        return res;
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }  

    return nil;
}

proc enable_vertex_attrib_array(index : u32) {
    if _enable_vertex_attrib_array != nil {
        _enable_vertex_attrib_array(index);
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }       
}

proc vertex_attrib_pointer(index : u32, size : i32, type_ : VertexAttribDataType, normalized : bool, stride : u32, pointer : rawptr) {
    if _vertex_attrib_pointer != nil {
        _vertex_attrib_pointer(index, size, i32(type_), normalized, stride, pointer);
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }       
}


proc bind_vertex_array(buffer : VAO) {
    if _bind_vertex_array != nil {
        _bind_vertex_array(u32(buffer));
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }    
}

proc uniform(loc : i32, v0 : i32) {
    if _uniform1i != nil {
        _uniform1i(loc, v0);
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}

proc uniform(loc: i32, v0, v1: i32) {
    if _uniform2i != nil {
        _uniform2i(loc, v0, v1);
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}

proc uniform(loc: i32, v0, v1, v2: i32) {
    if _uniform3i != nil {
        _uniform3i(loc, v0, v1, v2);
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}

proc uniform(loc: i32, v0, v1, v2, v3: i32) {
    if _uniform4i != nil {
        _uniform4i(loc, v0, v1, v2, v3);
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}

proc uniform(loc: i32, v0: f32) {
    if _uniform1f != nil {
        _uniform1f(loc, v0);
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}

proc uniform(loc: i32, v0, v1: f32) {
    if _uniform2f != nil {
        _uniform2f(loc, v0, v1);
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}

proc uniform(loc: i32, v0, v1, v2: f32) {
    if _uniform3f != nil {
        _uniform3f(loc, v0, v1, v2);
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}

proc uniform(loc: i32, v0, v1, v2, v3: f32) {
    if _uniform4f != nil {
        _uniform4f(loc, v0, v1, v2, v3);
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}

proc uniform(loc: i32, v: math.Vec4) {
    uniform(loc, v.x, v.y, v.z, v.w);
}

proc uniform_matrix4fv(loc : i32, matrix : math.Mat4, transpose : bool) {
    if _uniform_matrix4fv != nil {
        _uniform_matrix4fv(loc, 1, i32(transpose), ^f32(&matrix));
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}

proc get_uniform_location(program : Program, name : string) -> i32{
    if _get_uniform_location != nil {
        var str = strings.new_c_string(name); defer free(str);
        var res = _get_uniform_location(u32(program.ID), str);
        return res;
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
        return 0;
    }
}

proc get_attrib_location(program : Program, name : string) -> i32 {
    if _get_attrib_location != nil {
        var str = strings.new_c_string(name); defer free(str);
        var res = _get_attrib_location(u32(program.ID), str);
        return res;
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
        return 0;
    }
}

proc draw_elements(mode : DrawModes, count : i32, type_ : DrawElementsType, indices : rawptr) {
    if _draw_elements != nil {
        _draw_elements(i32(mode), count, i32(type_), indices);
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }    
}

proc draw_arrays(mode : DrawModes, first : i32, count : i32) {
    if _draw_arrays != nil {
        _draw_arrays(i32(mode), first, count);
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }    
}

proc use_program(program : Program) {
    if _use_program != nil {
        _use_program(program.ID);
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}

proc link_program(program : Program) {
    if _link_program != nil {
        _link_program(program.ID);
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}

proc tex_image2d(target : TextureTargets, lod : i32, internalFormat : InternalColorFormat,
                   width : i32, height : i32, format : PixelDataFormat, type_ : Texture2DDataType,
                   data : rawptr) {
    _tex_image2d(i32(target), lod, i32(internalFormat), width, height, 0,
                i32(format), i32(type_), data);
}

proc tex_parameteri (target : TextureTargets, pname : TextureParameters, param : TextureParametersValues) {
    _tex_parameteri(i32(target), i32(pname), i32(param));
}

proc bind_texture(target : TextureTargets, texture : Texture) {
    _bind_texture(i32(target), u32(texture));
}

proc active_texture(texture : TextureUnits) {
    if _active_texture != nil {
        _active_texture(i32(texture));
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}

proc gen_texture() -> Texture {
    var res = gen_textures(1);
    return res[0];
}

proc gen_textures(count : i32) -> []Texture {
    var res = make([]Texture, count);
    _gen_textures(count, ^u32(&res[0]));
    return res;
}

proc blend_equation_separate(modeRGB : BlendEquations, modeAlpha : BlendEquations) {
    if _blend_equation_separate != nil {
        _blend_equation_separate(i32(modeRGB), i32(modeAlpha));
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }    
}

proc blend_equation(mode : BlendEquations) {
    if _blend_equation != nil {
        _blend_equation(i32(mode));
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}

proc blend_func(sfactor : BlendFactors, dfactor : BlendFactors) {
    if _blend_func != nil {
        _blend_func(i32(sfactor), i32(dfactor));
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}

proc get_shader_value(shader : Shader, name : GetShaderNames) -> i32 {
    if _get_shaderiv != nil {
        var res : i32;
        _get_shaderiv(u32(shader), i32(name), &res);
        return res;
    } else {

    }

    return 0;
}

proc get_string(name : GetStringNames, index : u32) -> string {
    if _get_stringi != nil {
        var res = _get_stringi(i32(name), index);
        return strings.to_odin_string(res);
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
        return "nil";
    }
}

proc get_string(name : GetStringNames) -> string {
    if _get_string != nil {
        var res = _get_string(i32(name));
        return strings.to_odin_string(res);
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
    return "nil";
}

proc get_integer(name : GetIntegerNames) -> i32 {
    if _get_integerv != nil { 
        var res : i32;
        _get_integerv(i32(name), &res);
        return res;
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
        return 0;
    }
}

proc get_integer(name : GetIntegerNames, res : []i32) {
    if _get_integerv != nil { 
        _get_integerv(i32(name), &res[0]);
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}

proc enable (cap : Capabilities) {
    if _enable != nil {
        _enable(i32(cap));
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}

proc disable (cap : Capabilities) {
    if _disable != nil {
        _disable(i32(cap));
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}

proc attach_shader(program : Program, shader : Shader) {
    if _attach_shader != nil {
        _attach_shader(program.ID, u32(shader));
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}

proc create_program() -> Program {
    if _create_program != nil {
        var id = _create_program();
        var res : Program;
        res.ID = id;

        return res;
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }

    return Program{};
}

proc shader_source(obj : Shader, str : string) {
    var array : [1]string;
    array[0] = str;
    shader_source(obj, array[..]);
}

proc shader_source(obj : Shader, strs : []string) {
    if _shader_source != nil {
        var newStrs = make([]^u8, len(strs)); defer free(newStrs);
        var lengths = make([]i32, len(strs)); defer free(lengths);
        for s, i in strs {
            newStrs[i] = &([]u8(s))[0];
            lengths[i] = i32(len(s));
        }
        _shader_source(u32(obj), u32(len(strs)), &newStrs[0], &lengths[0]);
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}

proc create_shader(type_ : ShaderTypes) -> Shader {
    if _create_shader != nil {
        var res = _create_shader(i32(type_));
        return Shader(res);
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
        return Shader{};
    }
}

proc compile_shader(obj : Shader) {
    if _compile_shader != nil {
        _compile_shader(u32(obj));
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}

// Functions
    // Function variables
    var _buffer_data                : proc(target: i32, size: i32, data: rawptr, usage: i32)                                        #cc_c;
    var _bind_buffer                : proc(target : i32, buffer : u32)                                                              #cc_c;
    var _gen_buffers                : proc(n : i32, buffer : ^u32)                                                                  #cc_c;
    var _gen_vertex_arrays          : proc(count: i32, buffers: ^u32)                                                               #cc_c;
    var _enable_vertex_attrib_array : proc(index: u32)                                                                              #cc_c;
    var _vertex_attrib_pointer      : proc(index: u32, size: i32, type_: i32, normalized: bool, stride: u32, pointer: rawptr)        #cc_c;
    var _bind_vertex_array          : proc(buffer: u32)                                                                             #cc_c;
    var _uniform1i                  : proc(loc: i32, v0: i32)                                                                       #cc_c;
    var _uniform2i                  : proc(loc: i32, v0, v1: i32)                                                                   #cc_c;
    var _uniform3i                  : proc(loc: i32, v0, v1, v2: i32)                                                               #cc_c;
    var _uniform4i                  : proc(loc: i32, v0, v1, v2, v3: i32)                                                           #cc_c;
    var _uniform1f                  : proc(loc: i32, v0: f32)                                                                       #cc_c;
    var _uniform2f                  : proc(loc: i32, v0, v1: f32)                                                                   #cc_c;
    var _uniform3f                  : proc(loc: i32, v0, v1, v2: f32)                                                               #cc_c;
    var _uniform4f                  : proc(loc: i32, v0, v1, v2, v3: f32)                                                           #cc_c;
    var _uniform_matrix4fv          : proc(loc: i32, count: u32, transpose: i32, value: ^f32)                                       #cc_c;
    var _get_uniform_location       : proc(program: u32, name: ^u8) -> i32                                                        #cc_c;
    var _get_attrib_location        : proc(program: u32, name: ^u8) -> i32                                                        #cc_c;
    var _draw_elements              : proc(mode: i32, count: i32, type_: i32, indices: rawptr)                                      #cc_c;
    var _draw_arrays                : proc(mode: i32, first : i32, count : i32)                                                     #cc_c;
    var _use_program                : proc(program: u32)                                                                            #cc_c;
    var _link_program               : proc(program: u32)                                                                            #cc_c;
    var _active_texture             : proc(texture: i32)                                                                            #cc_c;
    var _blend_equation_separate    : proc(modeRGB : i32, modeAlpha : i32)                                                          #cc_c;
    var _blend_equation             : proc(mode : i32)                                                                              #cc_c;
    var _attach_shader              : proc(program, shader: u32)                                                                    #cc_c;
    var _create_program             : proc() -> u32                                                                                 #cc_c;
    var _shader_source              : proc(shader: u32, count: u32, str: ^^u8, length: ^i32)                                      #cc_c;
    var _create_shader              : proc(shader_type: i32) -> u32                                                                 #cc_c;
    var _compile_shader             : proc(shader: u32)                                                                             #cc_c;
    var _debug_message_control      : proc(source : i32, type_ : i32, severity : i32, count : i32, ids : ^u32, enabled : bool)       #cc_c;
    var _debug_message_callback     : proc(callback : DebugMessageCallbackProc, userParam : rawptr)                                 #cc_c;
    var _get_shaderiv               : proc(shader : u32, pname : i32, params : ^i32)                                                #cc_c;
    var _get_shader_info_log        : proc(shader : u32, maxLength : i32, length : ^i32, infolog : ^u8)                           #cc_c;
    var _get_stringi                : proc(name : i32, index : u32) -> ^u8                                                        #cc_c;
    var _bind_frag_data_location    : proc(program : u32, colorNumber : u32, name : ^u8)                                          #cc_c;
    var _polygon_mode               : proc(face : i32, mode : i32)                                                                  #cc_c;
    var _generate_mipmap            : proc(target : i32)                                                                            #cc_c;
    var _enable                     : proc(cap: i32)                                                                                #cc_c;
    var _depth_func                 : proc(func: i32)                                                                               #cc_c;
    var _get_string                 : proc(name : i32) -> ^u8                                                                     #cc_c;
    var _tex_image2d                : proc(target, level, internal_format, width, height, border, format, _type: i32, data: rawptr) #cc_c;
    var _tex_parameteri             : proc(target, pname, param: i32)                                                               #cc_c;
    var _bind_texture               : proc(target: i32, texture: u32)                                                               #cc_c;
    var _gen_textures               : proc(count: i32, result: ^u32)                                                                #cc_c;
    var _blend_func                 : proc(sfactor : i32, dfactor: i32)                                                             #cc_c;
    var _get_integerv               : proc(name: i32, v: ^i32)                                                                      #cc_c;
    var _disable                    : proc(cap: i32)                                                                                #cc_c;
    var _clear                      : proc(mask: i32)                                                                               #cc_c;
     
    var viewport                    : proc(x : i32, y : i32, width : i32, height : i32)                                             #cc_c;
    var clear_color                 : proc(red : f32, green : f32, blue : f32, alpha : f32)                                         #cc_c;
    var scissor                     : proc(x : i32, y : i32, width : i32, height : i32)                                             #cc_c;

proc load_functions() {
    var lib = libbrew.load_library("opengl32.dll"); defer libbrew.free_library(lib);

    proc set_proc_address(lib : libbrew.LibHandle, p: rawptr, name: string) #inline {

        var res = libbrew.gl_get_proc_address(name);
        if res == nil {
            res = libbrew.get_proc_address(lib, name);
        }   

        if res == nil {
            fmt.println("Couldn't load:", name);
        }

        ^(proc() #cc_c)(p)^ = res;
    }

    set_proc_address(lib, &_draw_elements,              "glDrawElements"           );
    set_proc_address(lib, &_draw_arrays,                "glDrawArrays"             );
    set_proc_address(lib, &_bind_vertex_array,          "glBindVertexArray"        );
    set_proc_address(lib, &_vertex_attrib_pointer,      "glVertexAttribPointer"    );
    set_proc_address(lib, &_enable_vertex_attrib_array, "glEnableVertexAttribArray");
    set_proc_address(lib, &_gen_vertex_arrays,          "glGenVertexArrays"        );
    set_proc_address(lib, &_buffer_data,                "glBufferData"             );
    set_proc_address(lib, &_bind_buffer,                "glBindBuffer"             );
    set_proc_address(lib, &_gen_buffers,                "glGenBuffers"             );
    set_proc_address(lib, &_debug_message_control,      "glDebugMessageControlARB" );
    set_proc_address(lib, &_debug_message_callback,     "glDebugMessageCallbackARB");
    set_proc_address(lib, &_get_shaderiv,               "glGetShaderiv"            );
    set_proc_address(lib, &_get_shader_info_log,        "glGetShaderInfoLog"       );
    set_proc_address(lib, &_get_stringi,                "glGetStringi"             );
    set_proc_address(lib, &_blend_equation,             "glBlendEquation"          );
    set_proc_address(lib, &_blend_equation_separate,    "glBlendEquationSeparate"  );
    set_proc_address(lib, &_compile_shader,             "glCompileShader"          );
    set_proc_address(lib, &_create_shader,              "glCreateShader"           );
    set_proc_address(lib, &_shader_source,              "glShaderSource"           );
    set_proc_address(lib, &_attach_shader,              "glAttachShader"           ); 
    set_proc_address(lib, &_create_program,             "glCreateProgram"          );
    set_proc_address(lib, &_link_program,               "glLinkProgram"            );
    set_proc_address(lib, &_use_program,                "glUseProgram"             );
    set_proc_address(lib, &_active_texture,             "glActiveTexture"          );
    set_proc_address(lib, &_uniform1i,                  "glUniform1i"              );
    set_proc_address(lib, &_uniform2i,                  "glUniform2i"              );
    set_proc_address(lib, &_uniform3i,                  "glUniform3i"              );
    set_proc_address(lib, &_uniform4i,                  "glUniform4i"              );
    set_proc_address(lib, &_uniform1f,                  "glUniform1f"              );
    set_proc_address(lib, &_uniform2f,                  "glUniform2f"              );
    set_proc_address(lib, &_uniform3f,                  "glUniform3f"              );
    set_proc_address(lib, &_uniform4f,                  "glUniform4f"              );
    set_proc_address(lib, &_uniform_matrix4fv,          "glUniformMatrix4fv"       );
    set_proc_address(lib, &_get_uniform_location,       "glGetUniformLocation"     );
    set_proc_address(lib, &_get_attrib_location,        "glGetAttribLocation"      );
    set_proc_address(lib, &_polygon_mode,               "glPolygonMode"            );
    set_proc_address(lib, &_generate_mipmap,            "glGenerateMipmap"         );
    set_proc_address(lib, &_enable,                     "glEnable"                 );
    set_proc_address(lib, &_depth_func,                 "glDepthFunc"              );
    set_proc_address(lib, &_bind_frag_data_location,    "glBindFragDataLocation"   );
    set_proc_address(lib, &_get_string,                 "glGetString"              );
    set_proc_address(lib, &_tex_image2d,                "glTexImage2D"             );
    set_proc_address(lib, &_tex_parameteri,             "glTexParameteri"          );
    set_proc_address(lib, &_bind_texture,               "glBindTexture"            );
    set_proc_address(lib, &_gen_textures,               "glGenTextures"            );
    set_proc_address(lib, &_blend_func,                 "glBlendFunc"              );
    set_proc_address(lib, &_get_integerv,               "glGetIntegerv"            );
    set_proc_address(lib, &_disable,                    "glDisable"                );
    set_proc_address(lib, &_clear,                      "glClear"                  );
    set_proc_address(lib, &viewport,                    "glViewport"               );
    set_proc_address(lib, &clear_color,                 "glClearColor"             );
    set_proc_address(lib, &scissor,                     "glScissor"                );
}