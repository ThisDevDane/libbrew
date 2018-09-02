/*
 *  @Name:     brew
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    fyoucon@gmail.com
 *  @Creation: 01-08-2018 23:30:42 UTC+1
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 26-08-2018 20:28:45 UTC+1
 *  
 *  @Description:
 *  
 */
package brew

import "core:math";

import sys    "shared:libbrew/sys";
import        "shared:libbrew/gl";
import        "shared:libbrew/imgui";
import        "shared:odin-imgui";

Simple_Window :: struct {
    app   : sys.AppHandle,
    wnd   : sys.WndHandle,
    glctx : sys.Gl_Context,

    new_frame_state : brew_imgui.FrameState,
    dear_state      : brew_imgui.State,

    running    : bool,
    shift_down : bool,

    time_data : sys.TimeData,

    clear_color : math.Vec4
}

create_simple_window :: proc(title : string, width := 1280, height := 720) -> ^Simple_Window {
    result      := new(Simple_Window);
    result.app   = sys.get_app_handle();
    result.wnd   = sys.create_window(result.app, title, width, height);
    result.glctx = sys.create_gl_context(result.wnd, 4, 5);

    gl.load_functions();
    result.clear_color = {0.10, 0.10, 0.10, 1};
    gl.clear_color(result.clear_color);

    brew_imgui.init(&result.dear_state, result.wnd, brew_imgui.brew_style, true);

    result.running    = true;
    result.shift_down = false;
    result.time_data  = sys.create_time_data();

    return result;  
}

set_clear_color :: proc(wnd : ^Simple_Window, color : math.Vec4) {
    wnd.clear_color = color;
    gl.clear_color(wnd.clear_color);
}

is_app_running :: proc(wnd : ^Simple_Window) -> bool {
    return wnd.running;
}

simple_end_frame :: proc(simple_wnd : ^Simple_Window) {
    brew_imgui.render_proc(&simple_wnd.dear_state, true, 0, 0);
    sys.swap_buffers(simple_wnd.wnd);
}

simple_new_frame :: proc(using simple_wnd: ^Simple_Window) {
    message : sys.Msg;
    new_frame_state.mouse_wheel = 0;
    for sys.poll_message(&message) {
        switch msg in message {
            case sys.MsgQuitMessage : running = false;
            case sys.MsgChar        : imgui.gui_io_add_input_character(u16(msg.char));
            case sys.MsgWindowFocus : new_frame_state.window_focus = msg.enter_focus;
            case sys.MsgMouseWheel  : new_frame_state.mouse_wheel  = msg.distance;

            case sys.MsgKey : {
                switch msg.key {
                    case sys.VirtualKey.Lshift : shift_down = msg.down;
                    case sys.VirtualKey.Escape : if msg.down && shift_down do running = false;
                }
            }

            case sys.MsgMouseButton : {
                switch msg.key {
                    case sys.VirtualKey.LMouse : new_frame_state.left_mouse  = msg.down;
                    case sys.VirtualKey.RMouse : new_frame_state.right_mouse = msg.down;
                }
            }

            case sys.MsgMouseMove : {
                new_frame_state.mouse_x = msg.x;
                new_frame_state.mouse_y = msg.y;
            }

            case sys.MsgSizeChange : {
                new_frame_state.window_width  = msg.width;
                new_frame_state.window_height = msg.height;
                gl.viewport(0, 0, i32(msg.width), i32(msg.height));
                gl.scissor (0, 0, i32(msg.width), i32(msg.height));
            }
        }
    }

    dt := sys.time(&time_data);
    new_frame_state.deltatime = f32(dt);
    gl.clear(gl.ClearFlags.COLOR_BUFFER | gl.ClearFlags.DEPTH_BUFFER);
    brew_imgui.begin_new_frame(&new_frame_state);
}