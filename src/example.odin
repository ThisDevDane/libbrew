/*
 *  @Name:     example
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    hjortshoej@handmade.network
 *  @Creation: 31-05-2017 21:57:56
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 10-06-2017 22:43:43
 *  
 *  @Description:
 *      Example for LibBrew
 */
#import "fmt.odin";
#import "strings.odin";
#import "libbrew/libbrew.odin";
#import "libbrew/gl.odin";
#import imgui "libbrew/dear_imgui.odin";

main :: proc() {
    app_handle := libbrew.get_app_handle();
    wnd_handle := libbrew.create_window(app_handle, "LibBrew Example", 1280, 720);
    glCtx      := libbrew.create_gl_context(wnd_handle, 3, 3);
    gl.load_functions();

    dear_state := new(imgui.State);
    imgui.init(dear_state);


    libbrew.swap_interval(-1);
    gl.clear_color(41/255.0, 57/255.0, 84/255.0, 1);
    width, height := libbrew.get_window_size(wnd_handle);
    gl.viewport(0, 0, i32(width), i32(height));
    gl.scissor(0, 0, i32(width), i32(height));

    message : libbrew.Msg;
    window_focus : bool;
    mpos_x : int;
    mpos_y : int;
    lm_down : bool;
    rm_down : bool;

main_loop: 
    for {
        for libbrew.poll_message(&message) {
            match msg in message {
                case libbrew.Msg.QuitMessage : {
                    break main_loop;
                }

                case libbrew.Msg.KeyDown : {
                    match msg.key {
                        case libbrew.VirtualKey.Escape : {
                            break main_loop;
                        }
                    }
                }

                case libbrew.Msg.MouseButton : {
                    match msg.key {
                        case libbrew.VirtualKey.LMouse : {
                            lm_down = msg.down;
                        }

                        case libbrew.VirtualKey.RMouse : {
                            rm_down = msg.down;
                        }
                    }
                }

                case libbrew.Msg.WindowFocus : {
                    window_focus = msg.enter_focus;
                }

                case libbrew.Msg.MouseMove : {
                    mpos_x = msg.x;
                    mpos_y = msg.y;
                }
            }
        }

        gl.clear(gl.ClearFlags.COLOR_BUFFER);

        imgui.begin_new_frame(0, 
                              width, height,
                              window_focus,
                              mpos_x, mpos_y,
                              lm_down, rm_down);
        imgui.show_test_window(nil);

        imgui.render_proc(dear_state, width, height);

        libbrew.swap_buffers(wnd_handle);
        libbrew.sleep(1);
    }
}