/*
 *  @Name:     example
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    hjortshoej@handmade.network
 *  @Creation: 31-05-2017 21:57:56
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 29-07-2017 03:43:01
 *  
 *  @Description:
 *      Example for LibBrew
 */
 import (
    "fmt.odin";
    "os.odin";
    "strings.odin";
    brew "libbrew/libbrew.odin";
    "libbrew/gl.odin";
    imgui "libbrew/brew_imgui.odin";
    //"libbrew/ini.odin";
)

main :: proc() {
    fmt.println(cast(^u8)cast(rawptr)cast(int)32512);
    fmt.println(brew.IDC_ARROW);

//    os.exit(0);

/*    text_buf, b := os.read_entire_file("test.ini");
    ini_text := string(text_buf);

    ini_, _ := ini.parse(ini_text);  
    fmt.println(ini_); */


    fmt.println("Program Start...");
    app_handle := brew.get_app_handle();
    width, height := 1280, 720;
    fmt.println("Creating Window...");
    wnd_handle := brew.create_window(app_handle, "LibBrew Example", true, 100, 100, width, height);
    fmt.println("Creating GL Context...");
    glCtx      := brew.create_gl_context(wnd_handle, 3, 3);
    fmt.println("Load GL Functions...");
    gl.load_functions();

    dear_state := new(imgui.State);
    fmt.println("Initialize Dear ImGui...");
    imgui.init(dear_state, wnd_handle);

    brew.swap_interval(-1);
    gl.clear_color(41/255.0, 57/255.0, 84/255.0, 1);

    message : brew.Msg;
    mpos_x : int;
    mpos_y : int;
    prev_lm_down : bool;
    lm_down : bool;
    rm_down : bool;
    add_data : bool = false;
    scale_by_max : bool = false;
    frame_list      := make_frame_time_list(100);
    time_data       := brew.create_time_data();
    i               := 0;
    dragging        := false;
    sizing_x        := false;
    sizing_y        := false;
    maximized       := false;
    shift_down      := false;
    new_frame_state := imgui.FrameState{};

    fmt.println("Entering Main Loop...");
main_loop: 
    for {
        prev_lm_down = lm_down ? true : false;
        for brew.poll_message(&message) {
            match msg in message {
                case brew.MsgQuitMessage : {
                    break main_loop;
                }

                case brew.MsgKey : {
                    match msg.key {
                        case brew.VirtualKey.Escape : {
                            if msg.down == true && shift_down {
                                break main_loop;
                            }
                        }

                        case brew.VirtualKey.Lshift : {
                            shift_down = msg.down;
                        }
                    }
                }

                case brew.MsgMouseButton : {
                    match msg.key {
                        case brew.VirtualKey.LMouse : {
                            lm_down = msg.down;
                        }

                        case brew.VirtualKey.RMouse : {
                            rm_down = msg.down;
                        }
                    }
                }

                case brew.MsgWindowFocus : {
                    new_frame_state.window_focus = msg.enter_focus;
                }

                /*case brew.Msg.MouseMove : {
                    mpos_x = msg.x;
                    mpos_y = msg.y;
                }*/

                case brew.MsgSizeChange : {
                    width = msg.width;
                    height = msg.height;
                    gl.viewport(0, 0, i32(width), i32(height));
                    gl.scissor( 0, 0, i32(width), i32(height));
                }
            }
        }
        dt := brew.time(&time_data);
        mpos_x, mpos_y = brew.get_mouse_pos(wnd_handle);
        new_frame_state.deltatime = f32(dt);
        new_frame_state.mouse_x = mpos_x;
        new_frame_state.mouse_y = mpos_y;
        new_frame_state.window_width = width;
        new_frame_state.window_height = height;
        new_frame_state.left_mouse = lm_down;
        new_frame_state.right_mouse = rm_down;

        gl.clear(gl.ClearFlags.COLOR_BUFFER);

        imgui.begin_new_frame(&new_frame_state);

        imgui.begin_main_menu_bar();
        {
            imgui.begin_menu("LibBrew Example  |###WindowTitle", false);
            if imgui.is_item_clicked(0) {
                dragging = true;
                if imgui.is_mouse_double_clicked(0) {
                    dragging = false;
                    if !maximized {
                        brew.maximize_window(wnd_handle);
                        maximized = true;
                    } else {
                        brew.restore_window(wnd_handle);
                        maximized = false;
                    }
                }
            }
            if imgui.begin_menu("Misc###LibbrewMain") {
                imgui.menu_item(label = "LibBrew Info", enabled = false);
                imgui.menu_item(label = "OpenGL Info", enabled = false);
                imgui.separator();
                imgui.menu_item("Toggle Fullscreen", "Alt+Enter", false);
                if imgui.menu_item("Exit", "LShift + Esc") {
                    break main_loop;
                }
                imgui.end_menu();
            }
        }
        imgui.end_main_menu_bar();

        if imgui.is_mouse_down(0) && dragging {
            d := imgui.get_mouse_drag_delta();
            x, y := brew.get_window_pos(wnd_handle);
            brew.set_window_pos(wnd_handle, x + int(d.x), y + int(d.y));
            if maximized && d.x != 0 && d.y != 0 {
                maximized = false;
                brew.restore_window(wnd_handle);
            }
        } else {
            dragging = false;
        }


        if add_data {
            add_frame_time(frame_list, f32(dt) * 1000);
        }

        if imgui.begin_panel("TEST##1", imgui.Vec2{0, 19}, imgui.Vec2{f32(width/2), f32(height-19)}) {
            defer imgui.end();
            when true {
                imgui.text("<%d, %d>", mpos_x, mpos_y);
                imgui.text("<%d, %d>", width, height);
                imgui.checkbox("Record Data", &add_data);            
                imgui.checkbox("Scale by max value", &scale_by_max);            
                size := imgui.get_window_size();
                imgui.plot_histogram("##FrameTimes", frame_list.values, 
                                     frame_list.min_value - 10, 
                                     scale_by_max ? frame_list.max_value + 5 : 33.3333, 
                                     imgui.Vec2{size.x - 15, 200});
                imgui.text("Lowest FrameRate: %f", 1.0 / (frame_list.max_value / 1000) );
                imgui.text("Highest FrameRate: %f", 1.0 / (frame_list.min_value / 1000) ); 
            }
            
        }

        if imgui.begin_panel("TEST##2", imgui.Vec2{f32(width/2), 19}, imgui.Vec2{f32(width/2), f32(height-19)}) {
            defer imgui.end();
            //imgui.text(ini_text);
        }

        is_between :: proc(v, min, max : int) -> bool #inline {
            return v >= min && v <= max;
        }

        if lm_down && !prev_lm_down { 
            if is_between(mpos_x, width-4, width+4) {
                sizing_x = true;
            }

            if is_between(mpos_y, height-4, height+4) {
                sizing_y = true;
            }
        }

        new_w : int;
        new_h : int;
       
        if (sizing_x || sizing_y) && lm_down {
            new_w = sizing_x ? mpos_x+2 : width;
            new_h = sizing_y ? mpos_y+2 : height;
            brew.set_window_size(wnd_handle, new_w+2, new_h+2);
        } else {
            sizing_x = false;
            sizing_y = false;
        }

        imgui.show_test_window(nil);

        imgui.render_proc(dear_state, width, height);
        brew.swap_buffers(wnd_handle);
        //brew.sleep(1);
    }

    imgui.shutdown();
    fmt.println("Ending Application...");
}

FrameTimeList :: struct {
    max_value : f32;
    max_value_write_pos : int;
    min_value : f32;
    min_value_write_pos : int;
    values : []f32;
    write_head : int;
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
        for i := 0; i < len(list.values); i += 1 {
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
        for i := 0; i < len(list.values); i += 1 {
            if list.values[i] < min {
                min = list.values[i];
                min_pos = i;
            }
        }

        list.min_value = min;
        list.min_value_write_pos = min_pos;
    }

    if list.write_head < len(list.values)-1 {
        list.write_head += 1;
    } else {
        list.write_head = 0;
    }
}