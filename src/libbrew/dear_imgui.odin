/*
 *  @Name:     dear_imgui
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    hjortshoej@handmade.network
 *  @Creation: 10-06-2017 18:33:45
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 02-07-2017 01:04:40
 *  
 *  @Description:
 *  
 */

import_load "imgui.odin";
import "fmt.odin";
import "libbrew.odin";
import "gl.odin";
//#import "math.odin";
//#import "main.odin";
//#import gl_util "gl_util.odin";

State :: struct {
    //Misc
    mouse_wheel_delta : i32,

    //Render
    main_program      : gl.Program,
    vbo_handle        : gl.VBO,
    ebo_handle        : gl.EBO,
    vao_handle        : gl.VAO,
}


FrameState :: struct {
    deltatime     : f32,
    window_width  : int,
    window_height : int,
    window_focus  : bool,
    mouse_x       : int,
    mouse_y       : int,
    left_mouse    : bool,
    right_mouse   : bool,
}


set_style :: proc() {
    style := get_style();

    style.window_rounding = 1.0;
    style.child_window_rounding  = 1.0;
    style.frame_rounding = 1.0;
    style.grab_rounding = 1.0;

    style.scrollbar_size = 12.0;

    style.colors[GuiCol.Text]                  = Vec4{1.00, 1.00, 1.00, 1.00};
    style.colors[GuiCol.TextDisabled]          = Vec4{0.63, 0.63, 0.63, 1.00};
    style.colors[GuiCol.WindowBg]              = Vec4{0.23, 0.23, 0.23, 0.98};
    style.colors[GuiCol.ChildWindowBg]         = Vec4{0.20, 0.20, 0.20, 1.00};
    style.colors[GuiCol.PopupBg]               = Vec4{0.25, 0.25, 0.25, 0.96};
    style.colors[GuiCol.Column]                = Vec4{0.18, 0.18, 0.18, 0.98};
    style.colors[GuiCol.Border]                = Vec4{0.18, 0.18, 0.18, 0.98};
    style.colors[GuiCol.BorderShadow]          = Vec4{0.00, 0.00, 0.00, 0.04};
    style.colors[GuiCol.FrameBg]               = Vec4{0.00, 0.00, 0.00, 0.29};
    style.colors[GuiCol.TitleBg]               = Vec4{0.25, 0.25, 0.25, 0.98};
    style.colors[GuiCol.TitleBgCollapsed]      = Vec4{0.12, 0.12, 0.12, 0.49};
    style.colors[GuiCol.TitleBgActive]         = Vec4{0.33, 0.33, 0.33, 0.98};
    style.colors[GuiCol.MenuBarBg]             = Vec4{0.11, 0.11, 0.11, 0.42};
    style.colors[GuiCol.ScrollbarBg]           = Vec4{0.00, 0.00, 0.00, 0.08};
    style.colors[GuiCol.ScrollbarGrab]         = Vec4{0.27, 0.27, 0.27, 1.00};
    style.colors[GuiCol.ScrollbarGrabHovered]  = Vec4{0.78, 0.78, 0.78, 0.40};
    style.colors[GuiCol.CheckMark]             = Vec4{0.78, 0.78, 0.78, 0.94};
    style.colors[GuiCol.SliderGrab]            = Vec4{0.78, 0.78, 0.78, 0.94};
    style.colors[GuiCol.Button]                = Vec4{0.42, 0.42, 0.42, 0.60};
    style.colors[GuiCol.ButtonHovered]         = Vec4{0.78, 0.78, 0.78, 0.40};
    style.colors[GuiCol.Header]                = Vec4{0.31, 0.31, 0.31, 0.98};
    style.colors[GuiCol.HeaderHovered]         = Vec4{0.78, 0.78, 0.78, 0.40};
    style.colors[GuiCol.HeaderActive]          = Vec4{0.80, 0.50, 0.50, 1.00};
    style.colors[GuiCol.TextSelectedBg]        = Vec4{0.65, 0.35, 0.35, 0.26};
    style.colors[GuiCol.ModalWindowDarkening]  = Vec4{0.20, 0.20, 0.20, 0.35};
}

init :: proc(state : ^State, wnd_handle : libbrew.WndHandle) {
    io := get_io();
    io.ime_window_handle = wnd_handle;
    //io.RenderDrawListsFn = RenderProc;
/*    n := "imgui.ini\x00";
    io.ini_file_name = &n[0];
*/
    io.key_map[GuiKey.Tab]        = i32(libbrew.VirtualKey.Tab);
    io.key_map[GuiKey.LeftArrow]  = i32(libbrew.VirtualKey.Left);
    io.key_map[GuiKey.RightArrow] = i32(libbrew.VirtualKey.Right);
    io.key_map[GuiKey.UpArrow]    = i32(libbrew.VirtualKey.Up);
    io.key_map[GuiKey.DownArrow]  = i32(libbrew.VirtualKey.Down);
    io.key_map[GuiKey.PageUp]     = i32(libbrew.VirtualKey.Next);
    io.key_map[GuiKey.PageDown]   = i32(libbrew.VirtualKey.Prior);
    io.key_map[GuiKey.Home]       = i32(libbrew.VirtualKey.Home);
    io.key_map[GuiKey.End]        = i32(libbrew.VirtualKey.End);
    io.key_map[GuiKey.Delete]     = i32(libbrew.VirtualKey.Delete);
    io.key_map[GuiKey.Backspace]  = i32(libbrew.VirtualKey.Back);
    io.key_map[GuiKey.Enter]      = i32(libbrew.VirtualKey.Return);
    io.key_map[GuiKey.Escape]     = i32(libbrew.VirtualKey.Escape);
    io.key_map[GuiKey.A]          = 'A';
    io.key_map[GuiKey.C]          = 'C';
    io.key_map[GuiKey.V]          = 'V';
    io.key_map[GuiKey.X]          = 'X';
    io.key_map[GuiKey.Y]          = 'Y';
    io.key_map[GuiKey.Z]          = 'Z';

    vertexShaderString ::
        `#version 330
        uniform mat4 ProjMtx;
        in vec2 Position;
        in vec2 UV;
        in vec4 Color;
        out vec2 Frag_UV;
        out vec4 Frag_Color;
        void main()
        {
           Frag_UV = UV;
           Frag_Color = Color;
           gl_Position = ProjMtx * vec4(Position.xy,0,1);
        }`;

    fragmentShaderString :: 
        `#version 330
        uniform sampler2D Texture;
        in vec2 Frag_UV;
        in vec4 Frag_Color;
        out vec4 Out_Color;
        void main()
        {
           Out_Color = Frag_Color * texture( Texture, Frag_UV.st);
        }`;


    state.main_program    = gl.create_program();
    vertex_shader := gl.create_shader(gl.ShaderTypes.Vertex);
    gl.shader_source(vertex_shader, vertexShaderString);
    gl.compile_shader(vertex_shader);

    fragment_shader := gl.create_shader(gl.ShaderTypes.Fragment);
    gl.shader_source(fragment_shader, fragmentShaderString);
    gl.compile_shader(fragment_shader);
   
    gl.attach_shader(state.main_program, vertex_shader);
    state.main_program.Vertex = vertex_shader;
    gl.attach_shader(state.main_program, fragment_shader);
    state.main_program.Fragment = fragment_shader;
    gl.link_program(state.main_program);
    state.main_program.Uniforms["Texture"] = gl.get_uniform_location(state.main_program, "Texture");    
    state.main_program.Uniforms["ProjMtx"] = gl.get_uniform_location(state.main_program, "ProjMtx");

    state.main_program.Attributes["Position"] = gl.get_attrib_location(state.main_program, "Position");    
    state.main_program.Attributes["UV"]       = gl.get_attrib_location(state.main_program, "UV");    
    state.main_program.Attributes["Color"]    = gl.get_attrib_location(state.main_program, "Color");    

    state.vbo_handle = gl.VBO(gl.gen_buffer());
    state.ebo_handle = gl.EBO(gl.gen_buffer());
    state.vao_handle = gl.gen_vertex_array();

    gl.bind_buffer(state.vbo_handle);
    gl.bind_buffer(state.ebo_handle);
    gl.bind_vertex_array(state.vao_handle);

    gl.enable_vertex_attrib_array(u32(state.main_program.Attributes["Position"]));
    gl.enable_vertex_attrib_array(u32(state.main_program.Attributes["UV"]));
    gl.enable_vertex_attrib_array(u32(state.main_program.Attributes["Color"]));

    gl.vertex_attrib_pointer(u32(state.main_program.Attributes["Position"]),   2, gl.VertexAttribDataType.Float, false, size_of(DrawVert), rawptr(int(offset_of(DrawVert, pos))));
    gl.vertex_attrib_pointer(u32(state.main_program.Attributes["UV"]),         2, gl.VertexAttribDataType.Float, false, size_of(DrawVert), rawptr(int(offset_of(DrawVert, uv))));
    gl.vertex_attrib_pointer(u32(state.main_program.Attributes["Color"]),      4, gl.VertexAttribDataType.UByte, true,  size_of(DrawVert), rawptr(int(offset_of(DrawVert, col))));
    
    //CreateFont
    pixels : ^u8;
    width : i32;
    height : i32;
    bytePer : i32;
    font_atlas_get_text_data_as_rgba32(io.fonts, &pixels, &width, &height, &bytePer);
    tex := gl.gen_texture();
    gl.bind_texture(gl.TextureTargets.Texture2D, tex);
    gl.tex_parameteri(gl.TextureTargets.Texture2D, gl.TextureParameters.MinFilter, gl.TextureParametersValues.Linear);
    gl.tex_parameteri(gl.TextureTargets.Texture2D, gl.TextureParameters.MagFilter, gl.TextureParametersValues.Linear);
    gl.tex_image2d(gl.TextureTargets.Texture2D, 0, gl.InternalColorFormat.RGBA, 
                  width, height, gl.PixelDataFormat.RGBA, 
                  gl.Texture2DDataType.UByte, pixels);
    font_atlas_set_text_id(io.fonts, rawptr(uint(tex)));

    set_style();
}

begin_new_frame :: proc(new_state : ^FrameState) {
    io := get_io();
    io.display_size.x = f32(new_state.window_width);
    io.display_size.y = f32(new_state.window_height);

    if new_state.window_focus {
        io.mouse_pos.x = f32(new_state.mouse_x);
        io.mouse_pos.y = f32(new_state.mouse_y);
        io.mouse_down[0] = new_state.left_mouse;
        io.mouse_down[1] = new_state.right_mouse;;
        /*
        io.mouse_wheel = f32(ctx.imgui_state.mouse_wheel_delta); 

        io.key_ctrl =  win32.is_key_down(win32.KeyCode.Lcontrol) || win32.is_key_down(win32.KeyCode.Rcontrol);
        io.key_shift = win32.is_key_down(win32.KeyCode.Lshift)   || win32.is_key_down(win32.KeyCode.Rshift);
        io.key_alt =   win32.is_key_down(win32.KeyCode.Lmenu)    || win32.is_key_down(win32.KeyCode.Rmenu);
        io.key_super = win32.is_key_down(win32.KeyCode.Lwin)     || win32.is_key_down(win32.KeyCode.Rwin);

        for i in 0..257 {
            io.keys_down[i] = win32.is_key_down(win32.KeyCode(i));
        }*/
    } else {
        io.mouse_down[0] = false;
        io.mouse_down[1] = false;
        io.key_ctrl  = false;  
        io.key_shift = false; 
        io.key_alt   = false;   
        io.key_super = false;

        for i in 0..256 { 
            io.keys_down[i] = false;
        }
    }
    
   // ctx.imgui_state.mouse_wheel_delta = 0;
    io.delta_time = new_state.deltatime;
    new_frame();
}
 
render_proc :: proc(state : ^State, window_width, window_height : int) {
    render();
    data := get_draw_data();

    io := get_io();
    
    io.display_size.x = f32(window_width);
    io.display_size.y = f32(window_height);

    width  := i32(io.display_size.x * io.display_framebuffer_scale.x);
    height := i32(io.display_size.y * io.display_framebuffer_scale.y);
    if height == 0 || width == 0 {
        return;
    }
    //draw_data->ScaleClipRects(io.DisplayFramebufferScale);

    //@TODO(Hoej): BACKUP STATE!
    lastViewport : [4]i32;
    lastScissor  : [4]i32;
    gl.get_integer(gl.GetIntegerNames.Viewport, lastViewport[..]);
    gl.get_integer(gl.GetIntegerNames.ScissorBox, lastScissor[..]);

    gl.enable(gl.Capabilities.Blend);
    gl.blend_func(gl.BlendFactors.SrcAlpha, gl.BlendFactors.OneMinusSrcAlpha);
    gl.blend_equation(gl.BlendEquations.FuncAdd);
    gl.disable(gl.Capabilities.CullFace);
    gl.disable(gl.Capabilities.DepthTest);
    gl.enable(gl.Capabilities.ScissorTest);
    gl.active_texture(gl.TextureUnits.Texture0);

    gl.viewport(0, 0, width, height);
    ortho_projection := [4][4]f32
    {
        { 2.0 / io.display_size.x,   0.0,                        0.0,    0.0 },
        { 0.0,                      2.0 / -io.display_size.y,    0.0,    0.0 },
        { 0.0,                      0.0,                        -1.0,   0.0 },
        { -1.0,                     1.0,                        0.0,    1.0 },
    };

    gl.use_program(state.main_program);
    gl.uniform(state.main_program.Uniforms["Texture"], 0);
    gl._uniform_matrix4fv(state.main_program.Uniforms["ProjMtx"], 1, 0, &ortho_projection[0][0]);
    gl.bind_vertex_array(state.vao_handle);

    newList := slice_ptr(data.cmd_lists, data.cmd_lists_count);
    for n : i32 = 0; n < data.cmd_lists_count; n += 1 {
        list := newList[n];
        idxBufferOffset : ^DrawIdx = nil;

        gl.bind_buffer(state.vbo_handle);
        gl.buffer_data(gl.BufferTargets.Array, i32(draw_list_get_vertex_buffer_size(list) * size_of(DrawVert)), draw_list_get_vertex_ptr(list, 0), gl.BufferDataUsage.StreamDraw);

        gl.bind_buffer(state.ebo_handle);
        gl.buffer_data(gl.BufferTargets.ElementArray, i32(draw_list_get_index_buffer_size(list) * size_of(DrawIdx)), draw_list_get_index_ptr(list, 0), gl.BufferDataUsage.StreamDraw);

        for j : i32 = 0; j < draw_list_get_cmd_size(list); j += 1 {
            cmd := draw_list_get_cmd_ptr(list, j);
            gl.bind_texture(gl.TextureTargets.Texture2D, gl.Texture(uint(cmd.texture_id)));
            gl.scissor(i32(cmd.clip_rect.x), height - i32(cmd.clip_rect.w), i32(cmd.clip_rect.z - cmd.clip_rect.x), i32(cmd.clip_rect.w - cmd.clip_rect.y));
            gl.draw_elements(gl.DrawModes.Triangles, i32(cmd.elem_count), gl.DrawElementsType.UShort, idxBufferOffset);
            idxBufferOffset += cmd.elem_count;
        }
    }

    //TODO: Restore state
    gl.scissor(lastScissor[0], lastScissor[1], lastScissor[2], lastScissor[3]);
    gl.viewport(lastViewport[0], lastViewport[1], lastViewport[2], lastViewport[3]);
}

begin_panel :: proc(label : string, pos, size : Vec2) -> bool {
    set_next_window_pos(pos, GuiSetCond.Always);
    set_next_window_size(size, GuiSetCond.Always);
    return begin(label, nil, GuiWindowFlags.NoTitleBar            | 
                             GuiWindowFlags.NoMove                | 
                             GuiWindowFlags.NoResize              |
                             GuiWindowFlags.NoBringToFrontOnFocus | 
                             GuiWindowFlags.ShowBorders);
}