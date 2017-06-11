/*
 *  @Name:     example
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    hjortshoej@handmade.network
 *  @Creation: 31-05-2017 21:57:56
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 11-06-2017 02:09:26
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
    imgui.init(dear_state, wnd_handle);


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
    add_data : bool = false;
    scale_by_max : bool = false;
    frame_list := make_frame_time_list(100);
    time_data := libbrew.create_time_data();

main_loop: 
    for {
        for libbrew.poll_message(&message) {
            match msg in message {
                case libbrew.Msg.QuitMessage : {
                    break main_loop;
                }

                case libbrew.Msg.Key : {
                    match msg.key {
                        case libbrew.VirtualKey.Escape : {
                            if msg.down == true {
                                break main_loop;
                            }
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
        dt := libbrew.time(&time_data);

        gl.clear(gl.ClearFlags.COLOR_BUFFER);

        imgui.begin_new_frame(dt, 
                              width, height,
                              window_focus,
                              mpos_x, mpos_y,
                              lm_down, rm_down);

        imgui.begin_main_menu_bar();
        {
            if imgui.begin_menu("Misc") {
                imgui.menu_item("LibBrew Info");
                imgui.menu_item("OpenGL Info");
                imgui.separator();
                imgui.menu_item("Toggle Fullscreen", "Alt+Enter");
                if imgui.menu_item("Exit", "Esc") {
                    break main_loop;
                }
                imgui.end_menu();
            }
        }
        imgui.end_main_menu_bar();
        if add_data {
            add_frame_time(frame_list, f32(dt) * 1000);
        }
        if imgui.begin("TEST") {
            imgui.checkbox("Record Data", &add_data);            
            imgui.checkbox("Scale by max value", &scale_by_max);            
            size := imgui.get_window_size();
            imgui.plot_histogram("##FrameTimes", frame_list.values, 0, scale_by_max ? frame_list.max_value : 33.3333, imgui.Vec2{size.x - 15, 200});
            imgui.text("Lowest FrameRate: %f", 1.0 / (frame_list.max_value / 1000) );
            imgui.text("Highest FrameRate: %f", 1.0 / (frame_list.min_value / 1000) );
            imgui.end();
        }
        

        imgui.show_metrics_window(nil);

        imgui.render_proc(dear_state, width, height);

        libbrew.swap_buffers(wnd_handle);
        libbrew.sleep(1);
    }
}

FrameTimeList :: struct {
    max_value : f32,
    max_value_write_pos : int,
    min_value : f32,
    min_value_write_pos : int,
    values : []f32,
    write_head : int,
}

make_frame_time_list :: proc(size : int) -> ^FrameTimeList {
    result := new(FrameTimeList);
    result.values = make([]f32, size);
    result.max_value = 0;
    result.min_value = 100000;
    result.write_head = 0;
    return result;
}

add_frame_time :: proc(list : ^FrameTimeList, value : f32) {
    list.values[list.write_head] = value;

    if list.values[list.write_head] > list.max_value {
        list.max_value = list.values[list.write_head];
        list.max_value_write_pos = list.write_head;
    }

    if list.max_value_write_pos == list.write_head {
        max : f32 = 0;
        max_pos := 0;
        for i := 0; i < len(list.values); i++ {
            if list.values[i] > max {
                max = list.values[i];
                max_pos = i;
            }
        }

        list.max_value = max;
        list.max_value_write_pos = max_pos;
    }

    if list.min_value_write_pos == list.write_head {
        min : f32 = 100000;
        min_pos := 0;
        for i := 0; i < len(list.values); i++ {
            if list.values[i] < min {
                min = list.values[i];
                min_pos = i;
            }
        }

        list.min_value = min;
        list.min_value_write_pos = min_pos;
    }

    if list.write_head < len(list.values)-1 {
        list.write_head++;
    } else {
        list.write_head = 0;
    }
}