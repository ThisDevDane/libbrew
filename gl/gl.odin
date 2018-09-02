/*
 *  @Name:     gl
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    hjortshoej@handmade.network
 *  @Creation: 10-06-2017 17:40:33
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 02-09-2018 19:09:01 UTC+1
 *  
 *  @Description:
 *  
 */

package gl;

foreign import lib "system:opengl32.lib"
import "core:fmt";
import "core:strings";
import "core:math";

import sys "shared:libbrew/sys";

// Types
VAO          :: distinct u32;
VBO          :: distinct u32;
EBO          :: distinct u32;
BufferObject :: distinct u32;
Texture      :: distinct u32;
Shader       :: distinct u32; 

Program :: struct {
    id         : u32,
    vertex     : Shader,
    fragment   : Shader,
    uniforms   : map[string]Uniform,
    attributes : map[string]Attrib,
}

Uniform :: struct {
    location : i32,
    name     : string,
    size     : i32,
    type_    : UniformTypes,
}

Attrib :: struct {
    location : i32,
    name     : string,
    size     : i32,
    type_    : AttribTypes,
}

Opengl_Vars :: struct {
    ctx                 : sys.Gl_Context,

    version_major_max   : i32,
    version_major_cur   : i32,
    version_minor_max   : i32,
    version_minor_cur   : i32,
    version_string      : string,
    glsl_version_string : string,

    vendor_string       : string,
    renderer_string     : string,

    context_flags       : i32,

    num_extensions      : i32,
    extensions          : [dynamic]string,
    num_wgl_extensions  : i32,
    wgl_extensions      : [dynamic]string,
}

DebugMessageCallbackProc :: proc "cdecl"(source : DebugSource, type_ : DebugType, id : i32, severity : DebugSeverity, length : i32, message : cstring, userParam : rawptr);

// API 

depth_func :: proc(func : DepthFuncs) {
    if _depth_func != nil {
        _depth_func(i32(func));
    } else {
        fmt.printf("%s ins't loaded! \n", #procedure);
    }
}

generate_mipmap :: proc(target : MipmapTargets) {
    if _generate_mipmap != nil {
        _generate_mipmap(i32(target));
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}

polygon_mode :: proc(face : PolygonFace, mode : PolygonModes) {
    if _polygon_mode != nil {
        _polygon_mode(i32(face), i32(mode));
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}

debug_message_control :: proc(source : DebugSource, type_ : DebugType, severity : DebugSeverity, count : i32, ids : ^u32, enabled : bool) {
    if _debug_message_control != nil {
        _debug_message_control(i32(source), i32(type_), i32(severity), count, ids, enabled);
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}

debug_message_callback :: proc(callback : DebugMessageCallbackProc, userParam : rawptr) {
    if _debug_message_callback != nil {
        _debug_message_callback(callback, userParam);
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}

clear_color :: proc[
    clear_color_vec4,
    gl_clear_color
];

clear_color_vec4 :: proc(color : math.Vec4) {
    if _clear_color != nil {
        _clear_color(color[0], color[1], color[2], color[3]);
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }  
}

gl_clear_color :: proc (red : f32, green : f32, blue : f32, alpha : f32) {
    if _clear_color != nil {
        _clear_color(red, green, blue, alpha);
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }     
}


clear :: proc(mask : ClearFlags) {
    _clear(i32(mask));
}

buffer_data :: proc[buffer_data_slice_u32, buffer_data_slice_f32, buffer_data_ptr]; 
buffer_data_slice_f32 :: proc(target : BufferTargets, data : []f32, usage : BufferDataUsage) {
    if _buffer_data != nil {
        _buffer_data(i32(target), i32(size_of(data[0]) * len(data)), &data[0], i32(usage));
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }     
}



buffer_data_slice_u32 :: proc(target : BufferTargets, data : []u32, usage : BufferDataUsage) {
    if _buffer_data != nil {
        _buffer_data(i32(target), i32(size_of(data[0]) * len(data)), &data[0], i32(usage));
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }     
}


buffer_data_ptr :: proc(target : BufferTargets, size : i32, data : rawptr, usage : BufferDataUsage) {
    if _buffer_data != nil {
        _buffer_data(i32(target), size, data, i32(usage));
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }     
}

gen_vbo :: proc() -> VBO {
    bo := gen_buffer();
    return VBO(bo);
}

gen_ebo :: proc() -> EBO {
    bo := gen_buffer();
    return EBO(bo);
}

gen_buffer :: proc() -> BufferObject {
    if _gen_buffers != nil {
        res : BufferObject;
        _gen_buffers(1, cast(^u32)&res);
        return res;
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
        return 0;
    }      
}

gen_buffers :: proc(n : i32) -> []BufferObject {
    if _gen_buffers != nil {
        res := make([]BufferObject, int(n));
        _gen_buffers(n, cast(^u32)&res[0]);
        return res;
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
        return nil;
    }       
}

bind_buffer :: proc[bind_buffer_vbo, bind_buffer_ebo, bind_buffer_legacy];

bind_buffer_legacy :: proc(target : BufferTargets, buffer : BufferObject) {
    if _bind_buffer != nil {
        _bind_buffer(i32(target), u32(buffer));
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }       
}


bind_buffer_vbo :: proc(vbo : VBO) {
    bind_buffer(BufferTargets.Array, BufferObject(vbo));
}

bind_buffer_ebo :: proc(ebo : EBO) {
    bind_buffer(BufferTargets.ElementArray, BufferObject(ebo));
     
}

bind_frag_data_location :: proc(program : Program, colorNumber : u32, name : string) {
    if _bind_frag_data_location != nil {
        c := strings.new_cstring(name);
        _bind_frag_data_location(program.id, colorNumber, c);
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);      
    }
}

gen_vertex_array :: proc() -> VAO {
    if _gen_vertex_arrays != nil {
        res : VAO;
        _gen_vertex_arrays(1, cast(^u32)&res);
        return res;
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }  

    return 0;
}

gen_vertex_arrays :: proc(count : i32) -> []VAO {
    if _gen_vertex_arrays != nil {
        res := make([]VAO, int(count));
        _gen_vertex_arrays(count, (^u32)(&res[0]));
        return res;
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }  

    return nil;
}

enable_vertex_attrib_array :: proc[enable_vertex_attrib_array_u, enable_vertex_attrib_array_v];
enable_vertex_attrib_array_u :: proc(attrib : Attrib) do enable_vertex_attrib_array_v(attrib.location);
enable_vertex_attrib_array_v :: proc(index : i32) {
    if _enable_vertex_attrib_array != nil {
        _enable_vertex_attrib_array(u32(index));
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }       
}

vertex_attrib_pointer :: proc[vertex_attrib_pointer_u, vertex_attrib_pointer_v];
vertex_attrib_pointer_u :: proc(attrib : Attrib, size : int, type_ : VertexAttribDataType, normalized : bool, stride : u32, offset_pointer : uintptr = nil) {
    vertex_attrib_pointer_v(attrib.location, size, type_, normalized, stride, offset_pointer);
}
vertex_attrib_pointer_v :: proc(index : i32, size : int, type_ : VertexAttribDataType, normalized : bool, stride : u32, offset_pointer : uintptr = nil) {
    if _vertex_attrib_pointer != nil {
        _vertex_attrib_pointer(u32(index), i32(size), i32(type_), normalized, stride, rawptr(offset_pointer));
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }       
}

bind_vertex_array :: proc(buffer : VAO) {
    if _bind_vertex_array != nil {
        _bind_vertex_array(u32(buffer));
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }    
}
delete_vertex_array :: proc(buffer : ^VAO) {
    if _delete_vertex_arrays != nil {
        _delete_vertex_arrays(1, cast(^u32)buffer);
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }      
}



uniform :: proc[uniform1i_u,
                uniform1i_v, 
                uniform2i_u, 
                uniform2i_v, 
                uniform3i_u, 
                uniform3i_v, 
                uniform4i_u, 
                uniform4i_v, 
                uniform1f_u, 
                uniform1f_v, 
                uniform2f_u, 
                uniform2f_v, 
                uniform3f_u, 
                uniform3f_v, 
                uniform4f_u, 
                uniform4f_v, 
                uniform_vec4_u,
                uniform_vec4_v,
                uniform_matrix4_u,
                uniform_matrix4_v];

uniform1i_u :: proc(program : ^Program, uni : string, v0 : i32) 
{
    if uni, ok := program.uniforms[uni]; ok {
        uniform1i_v(uni.location, v0);
    } else {
        fmt.printf("Uniform %s is not present in program!!!", uni);
    }
}
uniform1i_v :: proc(loc : i32, v0 : i32) {
    if _uniform1i != nil {
        _uniform1i(loc, v0);
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}

uniform2i_u :: proc(program : ^Program, uni : string, v0, v1 : i32) 
{
    if uni, ok := program.uniforms[uni]; ok {
        uniform2i_v(uni.location, v0, v1);
    } else {
        fmt.printf("Uniform %s is not present in program!!!", uni);
    }
}
uniform2i_v :: proc(loc: i32, v0, v1: i32) {
    if _uniform2i != nil {
        _uniform2i(loc, v0, v1);
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}

uniform3i_u :: proc(program : ^Program, uni : string, v0, v1, v2: i32) 
{
    if uni, ok := program.uniforms[uni]; ok {
        uniform3i_v(uni.location, v0, v1, v2);
    } else {
        fmt.printf("Uniform %s is not present in program!!!", uni);
    }
}
uniform3i_v :: proc(loc : i32, v0, v1, v2: i32) {
    if _uniform3i != nil {
        _uniform3i(loc, v0, v1, v2);
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}

uniform4i_u :: proc(program : ^Program, uni : string, v0, v1, v2, v3: i32) 
{
    if uni, ok := program.uniforms[uni]; ok {
        uniform4i_v(uni.location, v0, v1, v2, v3);
    } else {
        fmt.printf("Uniform %s is not present in program!!!", uni);
    }
}
uniform4i_v :: proc(loc : i32, v0, v1, v2, v3: i32) {
    if _uniform4i != nil {
        _uniform4i(loc, v0, v1, v2, v3);
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}

uniform1f_u :: proc(program : ^Program, uni : string, v0: f32) 
{
    if uni, ok := program.uniforms[uni]; ok {
        uniform1f_v(uni.location, v0);
    } else {
        fmt.printf("Uniform %s is not present in program!!!", uni);
    }
}
uniform1f_v :: proc(loc : i32, v0: f32) {
    if _uniform1f != nil {
        _uniform1f(loc, v0);
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}

uniform2f_u :: proc(program : ^Program, uni : string, v0, v1: f32) 
{
    if uni, ok := program.uniforms[uni]; ok {
        uniform2f_v(uni.location, v0, v1);
    } else {
        fmt.printf("Uniform %s is not present in program!!!", uni);
    }
}
uniform2f_v :: proc(loc : i32, v0, v1: f32) {
    if _uniform2f != nil {
        _uniform2f(loc, v0, v1);
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}

uniform3f_u :: proc(program : ^Program, uni : string, v0, v1, v2: f32) 
{
    if uni, ok := program.uniforms[uni]; ok {
        uniform3f_v(uni.location, v0, v1, v2);
    } else {
        fmt.printf("Uniform %s is not present in program!!!", uni);
    }
}
uniform3f_v :: proc(loc : i32, v0, v1, v2: f32) {
    if _uniform3f != nil {
        _uniform3f(loc, v0, v1, v2);
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}

uniform4f_u :: proc(program : ^Program, uni : string, v0, v1, v2, v3: f32) 
{
    if uni, ok := program.uniforms[uni]; ok {
        uniform4f_v(uni.location, v0, v1, v2, v3);
    } else {
        fmt.printf("Uniform %s is not present in program!!!", uni);
    }
}
uniform4f_v :: proc(loc : i32, v0, v1, v2, v3: f32) {
    if _uniform4f != nil {
        _uniform4f(loc, v0, v1, v2, v3);
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}

uniform_vec4_u :: proc(program : ^Program, uni : string, v: math.Vec4) 
{
    if uni, ok := program.uniforms[uni]; ok {
        uniform_vec4_v(uni.location, v);
    } else {
        fmt.printf("Uniform %s is not present in program!!!", uni);
    }
}
uniform_vec4_v :: proc(loc : i32, v: math.Vec4) {
    uniform(loc, v[0], v[1], v[2], v[3]);
}

uniform_matrix4_u :: proc(program : ^Program, uni : string, matrix : math.Mat4, transpose := false)
{
    if uni, ok := program.uniforms[uni]; ok {
        uniform_matrix4_v(uni.location, matrix, transpose);
    } else {
        fmt.printf("Uniform %s is not present in program!!!", uni);
    }
}

uniform_matrix4_v :: proc(loc : i32, matrix : math.Mat4, transpose := false) {
    if _uniform_matrix4fv != nil {
        _uniform_matrix4fv(loc, 1, i32(transpose), (^f32)(&matrix));
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}

get_uniform_location :: proc(program : Program, name : string) -> i32{
    if _get_uniform_location != nil {
        str := strings.new_cstring(name); defer delete(str);
        res := _get_uniform_location(u32(program.id), str);
        return res;
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
        return 0;
    }
}

get_attrib_location :: proc(program : Program, name : string) -> i32 {
    if _get_attrib_location != nil {
        str := strings.new_cstring(name); defer delete(str);
        res := _get_attrib_location(u32(program.id), str);
        return res;
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
        return 0;
    }
}

draw_elements :: proc(mode : DrawModes, count : int, type_ : DrawElementsType, indices : rawptr) {
    if _draw_elements != nil {
        _draw_elements(i32(mode), i32(count), i32(type_), indices);
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }    
}

draw_arrays :: proc(mode : DrawModes, first : int, count : int) {
    if _draw_arrays != nil {
        _draw_arrays(i32(mode), i32(first), i32(count));
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }    
}

use_program :: proc(program : Program) {
    if _use_program != nil {
        _use_program(program.id);
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}

link_program :: proc(program : Program) {
    if _link_program != nil {
        _link_program(program.id);
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}

tex_image2d :: proc(target : TextureTargets, lod : i32, internalFormat : InternalColorFormat,
                   width : i32, height : i32, format : PixelDataFormat, type_ : Texture2DDataType,
                   data : rawptr) {
    _tex_image2d(i32(target), lod, i32(internalFormat), width, height, 0,
                i32(format), i32(type_), data);
}

tex_parameteri :: proc (target : TextureTargets, pname : TextureParameters, param : TextureParametersValues) {
    _tex_parameteri(i32(target), i32(pname), i32(param));
}

bind_texture :: proc(target : TextureTargets, texture : Texture) {
    _bind_texture(i32(target), u32(texture));
}

active_texture :: proc(texture : TextureUnits) {
    if _active_texture != nil {
        _active_texture(i32(texture));
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}

gen_texture :: proc() -> Texture {
    res := gen_textures(1);
    return res[0];
}

gen_textures :: proc(count : i32) -> []Texture {
    res := make([]Texture, int(count));
    _gen_textures(count, (^u32)(&res[0]));
    return res;
}

blend_equation_separate :: proc(modeRGB : BlendEquations, modeAlpha : BlendEquations) {
    if _blend_equation_separate != nil {
        _blend_equation_separate(i32(modeRGB), i32(modeAlpha));
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }    
}

blend_equation :: proc(mode : BlendEquations) {
    if _blend_equation != nil {
        _blend_equation(i32(mode));
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}

blend_func :: proc(sfactor : BlendFactors, dfactor : BlendFactors) {
    if _blend_func != nil {
        _blend_func(i32(sfactor), i32(dfactor));
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}

get_shader_value :: proc(shader : Shader, name : GetShaderNames) -> i32 {
    if _get_shaderiv != nil {
        res : i32;
        _get_shaderiv(u32(shader), i32(name), &res);
        return res;
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }

    return 0;
}
//_get_shader_info_log        : proc(shader : u32, maxLength : i32, length : ^i32, infolog : ^u8)  
get_shader_info_log :: proc(shader : Shader) -> string {
    if _get_shader_info_log != nil {
        logSize := get_shader_value(shader, GetShaderNames.InfoLogLength);
        logBytes := make([]u8, int(logSize));
        _get_shader_info_log(u32(shader), logSize, &logSize, &logBytes[0]);
        return string(logBytes);
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
        return "<ERR>";
    }
}

get_program_value :: proc(program : Program, name : GetProgramNames) -> i32 {
    if _get_programiv != nil {
        res : i32;
        _get_programiv(program.id, i32(name), &res);
        return res;
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }

    return 0;
}

get_active_uniform :: proc (program : Program, index : uint) -> Uniform {
     if _get_active_uniform != nil {
        type_ : u32;
        size : i32;
        buf : [1024]byte;
        out_len : u32;
        _get_active_uniform(program.id, u32(index), len(buf), &out_len, &size, &type_, cstring(&buf[0]));
        name := strings.new_string(string(buf[:out_len]));
        
        result := Uniform {
            get_uniform_location(program, name),
            name,
            size,
            UniformTypes(type_),
        };
        return result;
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }

    return Uniform{};
}

get_uniform_by_name :: proc(program : Program, name : string) -> Uniform {
    loc := get_uniform_location(program, name);
    return Uniform{location = loc, name = name};
}

get_active_uniform_name :: proc(program : Program, index : uint) -> string {
    if _get_active_uniform_name != nil {
        buf : [1024]byte;
        out_len : u32;
        _get_active_uniform_name(program.id, u32(index), len(buf), &out_len, cstring(&buf[0]));
        str := string(buf[:out_len]);
        return strings.new_string(str);
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }

    return "<ERR>";
}

//type_ should be an enum
get_active_attrib :: proc (program : Program, index : uint) -> Attrib {
     if _get_active_attrib != nil {
        type_ : u32;
        size : i32;
        buf : [1024]byte;
        out_len : u32;
        _get_active_attrib(program.id, u32(index), len(buf), &out_len, &size, &type_, cstring(&buf[0]));
        name := strings.new_string(string(buf[:out_len]));
        
        result := Attrib {
            get_attrib_location(program, name),
            name,
            size,
            AttribTypes(type_),
        };

        return result;
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }

    return Attrib{};
}

get_attrib_by_name :: proc(program : Program, name : string) -> Attrib {
    loc := get_attrib_location(program, name);
    return Attrib{location = loc, name = name};
}


get_string :: proc[get_string_single, get_string_index];

get_string_index :: proc(name : GetStringNames, index : u32) -> string {
    if _get_stringi != nil {
        res := _get_stringi(i32(name), index);
        return string(cstring(res));
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
        return "nil";
    }
}

get_string_single :: proc(name : GetStringNames) -> string {
    if _get_string != nil {
        res := _get_string(i32(name));
        return string(cstring(res));
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
    return "nil";
}

get_integer :: proc[get_integer_single, get_integer_slice];

get_integer_single :: proc(name : GetIntegerNames) -> i32 {
    if _get_integerv != nil { 
        res : i32;
        _get_integerv(i32(name), &res);
        return res;
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
        return 0;
    }
}

get_integer_slice :: proc(name : GetIntegerNames, res : []i32) {
    if _get_integerv != nil { 
        _get_integerv(i32(name), &res[0]);
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}

enable :: proc (cap : Capabilities) {
    if _enable != nil {
        _enable(i32(cap));
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}

disable :: proc (cap : Capabilities) {
    if _disable != nil {
        _disable(i32(cap));
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}

attach_shader :: proc(program : Program, shader : Shader) {
    if _attach_shader != nil {
        _attach_shader(program.id, u32(shader));
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}

create_program :: proc() -> Program {
    if _create_program != nil {
        id := _create_program();
        res : Program;
        res.id = id;

        return res;
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }

    return Program{};
}

shader_source :: proc[shader_source_str, shader_source_slice];

//TODO(Hoej): since shader_source(shader, []string) does a mem alloc maybe we should just do the work here instead
//            instead of relying on it.
shader_source_str :: proc(obj : Shader, str : string) {
    array : [1]string;
    array[0] = str;
    shader_source(obj, array[:]);
}

shader_source_slice :: proc(obj : Shader, strs : []string) {
    if _shader_source != nil {
        newStrs := make([]cstring, len(strs)); defer delete(newStrs);
        lengths := make([]i32, len(strs)); defer delete(lengths);
        for s, i in strs {
            c := &(([]u8)(s))[0];
            newStrs[i] = (cstring)(c);
            lengths[i] = i32(len(s));
        }
        _shader_source(u32(obj), u32(len(strs)), &newStrs[0], &lengths[0]);
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}

create_shader :: proc(type_ : ShaderTypes) -> Shader {
    if _create_shader != nil {
        res := _create_shader(i32(type_));
        return Shader(res);
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
        return Shader{};
    }
}

compile_shader :: proc(obj : Shader) {
    if _compile_shader != nil {
        _compile_shader(u32(obj));
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}

delete_shader :: proc(obj : Shader) {
    if _delete_shader != nil {
        _delete_shader(u32(obj));
    } else {
        fmt.printf("%s isn't loaded! \n", #procedure);
    }
}

// Functions
    // Function variables
    _buffer_data                : proc "c"(target : i32, size : i32, data : rawptr, usage : i32);
    _bind_buffer                : proc "c"(target : i32, buffer : u32);
    _gen_buffers                : proc "c"(n : i32, buffer : ^u32);
    _gen_vertex_arrays          : proc "c"(count: i32, buffers: ^u32);
    _enable_vertex_attrib_array : proc "c"(index: u32);
    _vertex_attrib_pointer      : proc "c"(index: u32, size: i32, type_: i32, normalized: bool, stride: u32, pointer: rawptr);
    _bind_vertex_array          : proc "c"(buffer: u32);
    _delete_vertex_arrays       : proc "c"(n: i32, buffer : ^u32);
    _uniform1i                  : proc "c"(loc : i32, v0: i32);
    _uniform2i                  : proc "c"(loc : i32, v0 : i32, v1 : i32);
    _uniform3i                  : proc "c"(loc : i32, v0 : i32, v1, v2 : i32);
    _uniform4i                  : proc "c"(loc : i32, v0 : i32, v1, v2 : i32, v3: i32);
    _uniform1f                  : proc "c"(loc : i32, v0 : f32);
    _uniform2f                  : proc "c"(loc : i32, v0 : f32, v1 : f32);
    _uniform3f                  : proc "c"(loc : i32, v0 : f32, v1 : f32, v2 : f32);
    _uniform4f                  : proc "c"(loc : i32, v0 : f32, v1 : f32, v2 : f32, v3 : f32);
    _uniform_matrix4fv          : proc "c"(loc : i32, count: u32, transpose: i32, value: ^f32);
    _get_uniform_location       : proc "c"(program : u32, name : cstring) -> i32;
    _get_attrib_location        : proc "c"(program : u32, name : cstring) -> i32;
    _draw_elements              : proc "c"(mode: i32, count : i32, type_ : i32, indices : rawptr);
    _draw_arrays                : proc "c"(mode: i32, first : i32, count : i32);
    _use_program                : proc "c"(program: u32);
    _link_program               : proc "c"(program: u32);
    _active_texture             : proc "c"(texture: i32);
    _blend_equation_separate    : proc "c"(modeRGB : i32, modeAlpha : i32);
    _blend_equation             : proc "c"(mode : i32);
    _attach_shader              : proc "c"(program, shader: u32);
    _create_program             : proc "c"() -> u32;
    _shader_source              : proc "c"(shader: u32, count: u32, str: ^cstring, length: ^i32);
    _create_shader              : proc "c"(shader_type: i32) -> u32;
    _compile_shader             : proc "c"(shader: u32);
    _delete_shader              : proc "c"(shader: u32);
    _debug_message_control      : proc "c"(source : i32, type_ : i32, severity : i32, count : i32, ids : ^u32, enabled : bool);
    _debug_message_callback     : proc "c"(callback : DebugMessageCallbackProc, userParam : rawptr);
    _get_shaderiv               : proc "c"(shader : u32, pname : i32, params : ^i32);
    _get_shader_info_log        : proc "c"(shader : u32, maxLength : i32, length : ^i32, infolog : ^u8);
    _get_programiv              : proc "c"(program : u32, pname : i32, params : ^i32);
    _get_active_uniform         : proc "c"(program : u32, index : u32, buf_size : u32, length : ^u32, size : ^i32, type_ : ^u32, name : cstring);
    _get_active_uniform_name    : proc "c"(program : u32, index : u32, buf_size : u32, length : ^u32, name : cstring);
    _get_active_attrib          : proc "c"(program : u32, index : u32, buf_size : u32, length : ^u32, size : ^i32, type_ : ^u32, name : cstring);
    _get_stringi                : proc "c"(name : i32, index : u32) -> ^u8;
    _bind_frag_data_location    : proc "c"(program : u32, colorNumber : u32, name : cstring);
    _polygon_mode               : proc "c"(face : i32, mode : i32);
    _generate_mipmap            : proc "c"(target : i32);
    _enable                     : proc "c"(cap: i32);
    _depth_func                 : proc "c"(func: i32);
    _get_string                 : proc "c"(name : i32) -> ^u8;
    _tex_image2d                : proc "c"(target, level, internal_format, width, height, border, format, _type: i32, data: rawptr);
    _tex_parameteri             : proc "c"(target, pname, param: i32);
    _bind_texture               : proc "c"(target: i32, texture: u32);
    _gen_textures               : proc "c"(count: i32, result: ^u32);
    _blend_func                 : proc "c"(sfactor : i32, dfactor: i32);
    _get_integerv               : proc "c"(name: i32, v: ^i32);
    _disable                    : proc "c"(cap: i32);
    _clear                      : proc "c"(mask: i32);
     
    viewport                    : proc "c"(x : i32, y : i32, width : i32, height : i32);
    scissor                     : proc "c"(x : i32, y : i32, width : i32, height : i32);
    _clear_color                 : proc "c"(red : f32, green : f32, blue : f32, alpha : f32);

get_info :: proc(vars : ^Opengl_Vars) {
    vars.version_major_cur =   get_integer(GetIntegerNames.MajorVersion);
    vars.version_minor_cur =   get_integer(GetIntegerNames.MinorVersion);
    vars.context_flags =       get_integer(GetIntegerNames.ContextFlags);
    vars.num_extensions =      get_integer(GetIntegerNames.NumExtensions);
    
    vars.version_string =      get_string(GetStringNames.Version);
    vars.glsl_version_string = get_string(GetStringNames.ShadingLanguageVersion);
    vars.vendor_string =       get_string(GetStringNames.Vendor);
    vars.renderer_string =     get_string(GetStringNames.Renderer);

    reserve(&vars.extensions, int(vars.num_extensions));
    for i in 0..vars.num_extensions {
        ext := get_string(GetStringNames.Extensions, u32(i));
        append(&vars.extensions, ext);
    }
}

set_proc_address :: #type /*inline*/ proc(lib : rawptr, p: rawptr, name: string);
load_library     :: #type proc(name : string) -> rawptr;
free_library     :: #type proc(lib : rawptr);

set_proc :: inline proc(lib_ : rawptr, p: rawptr, name: string) {
    lib := sys.LibHandle(lib_);
    res := sys.wgl_get_proc_address(name);
    if res == nil {
        res = sys.get_proc_address(lib, name);
    }
    if res == nil {
        fmt.println("Couldn't load:", name);
    }

    (^rawptr)(p)^ = rawptr(res);
}

load_lib :: proc(str : string) -> rawptr {
    return rawptr(sys.load_library(str));
}

free_lib :: proc(lib : rawptr) {
    sys.free_library(sys.LibHandle(lib));
}

load_functions :: proc(set_proc : set_proc_address = set_proc, 
                       load_lib : load_library = load_lib, 
                       free_lib : free_library = free_lib) {
    lib := load_lib("opengl32.dll"); defer free_lib(lib);
    //TODO(Hoej): How??? 
    //debug_info.lib_address = int(rawptr(lib));

    set_proc(lib, &_draw_elements,              "glDrawElements"           );
    set_proc(lib, &_draw_arrays,                "glDrawArrays"             );
    set_proc(lib, &_bind_vertex_array,          "glBindVertexArray"        );
    set_proc(lib, &_delete_vertex_arrays,       "glDeleteVertexArrays"     );
    set_proc(lib, &_vertex_attrib_pointer,      "glVertexAttribPointer"    );
    set_proc(lib, &_enable_vertex_attrib_array, "glEnableVertexAttribArray");
    set_proc(lib, &_gen_vertex_arrays,          "glGenVertexArrays"        );
    set_proc(lib, &_buffer_data,                "glBufferData"             );
    set_proc(lib, &_bind_buffer,                "glBindBuffer"             );
    set_proc(lib, &_gen_buffers,                "glGenBuffers"             );
    set_proc(lib, &_debug_message_control,      "glDebugMessageControlARB" );
    set_proc(lib, &_debug_message_callback,     "glDebugMessageCallbackARB");
    set_proc(lib, &_get_shaderiv,               "glGetShaderiv"            );
    set_proc(lib, &_get_shader_info_log,        "glGetShaderInfoLog"       );
    set_proc(lib, &_get_programiv,              "glGetProgramiv"           );
    set_proc(lib, &_get_active_uniform,         "glGetActiveUniform"       );
    set_proc(lib, &_get_active_uniform_name,    "glGetActiveUniformName"   );
    set_proc(lib, &_get_active_attrib,          "glGetActiveAttrib"        );
    set_proc(lib, &_get_programiv,              "glGetProgramiv"           );
    set_proc(lib, &_get_stringi,                "glGetStringi"             );
    set_proc(lib, &_blend_equation,             "glBlendEquation"          );
    set_proc(lib, &_blend_equation_separate,    "glBlendEquationSeparate"  );
    set_proc(lib, &_compile_shader,             "glCompileShader"          );
    set_proc(lib, &_create_shader,              "glCreateShader"           );
    set_proc(lib, &_shader_source,              "glShaderSource"           );
    set_proc(lib, &_attach_shader,              "glAttachShader"           ); 
    set_proc(lib, &_create_program,             "glCreateProgram"          );
    set_proc(lib, &_link_program,               "glLinkProgram"            );
    set_proc(lib, &_use_program,                "glUseProgram"             );
    set_proc(lib, &_active_texture,             "glActiveTexture"          );
    set_proc(lib, &_uniform1i,                  "glUniform1i"              );
    set_proc(lib, &_uniform2i,                  "glUniform2i"              );
    set_proc(lib, &_uniform3i,                  "glUniform3i"              );
    set_proc(lib, &_uniform4i,                  "glUniform4i"              );
    set_proc(lib, &_uniform1f,                  "glUniform1f"              );
    set_proc(lib, &_uniform2f,                  "glUniform2f"              );
    set_proc(lib, &_uniform3f,                  "glUniform3f"              );
    set_proc(lib, &_uniform4f,                  "glUniform4f"              );
    set_proc(lib, &_uniform_matrix4fv,          "glUniformMatrix4fv"       );
    set_proc(lib, &_get_uniform_location,       "glGetUniformLocation"     );
    set_proc(lib, &_get_attrib_location,        "glGetAttribLocation"      );
    set_proc(lib, &_polygon_mode,               "glPolygonMode"            );
    set_proc(lib, &_generate_mipmap,            "glGenerateMipmap"         );
    set_proc(lib, &_enable,                     "glEnable"                 );
    set_proc(lib, &_depth_func,                 "glDepthFunc"              );
    set_proc(lib, &_bind_frag_data_location,    "glBindFragDataLocation"   );
    set_proc(lib, &_get_string,                 "glGetString"              );
    set_proc(lib, &_tex_image2d,                "glTexImage2D"             );
    set_proc(lib, &_tex_parameteri,             "glTexParameteri"          );
    set_proc(lib, &_bind_texture,               "glBindTexture"            );
    set_proc(lib, &_gen_textures,               "glGenTextures"            );
    set_proc(lib, &_blend_func,                 "glBlendFunc"              );
    set_proc(lib, &_get_integerv,               "glGetIntegerv"            );
    set_proc(lib, &_disable,                    "glDisable"                );
    set_proc(lib, &_clear,                      "glClear"                  );
    set_proc(lib, &viewport,                    "glViewport"               );
    set_proc(lib, &_clear_color,                "glClearColor"             );
    set_proc(lib, &scissor,                     "glScissor"                );
}