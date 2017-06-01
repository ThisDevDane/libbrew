/*
 *  @Name:     libbrew
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    hjortshoej@handmade.network
 *  @Creation: 31-05-2017 22:01:38
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 01-06-2017 02:07:13
 *  
 *  @Description:
 *      SDL like library to easy development 
 */

 /*
 TODO list
    [X] Window Creation
    [X] Get Input from message queue
    [ ] Handle Unicode in window title and such.
    [ ] Make an OpenGL Contxt
    [ ] Traverse File Directory
    [ ] Maybe handle file I/O or just use os.odin?
    [ ] Provide mechanism to hot-reload DLLs
 */

#import "fmt.odin";
#import "strings.odin";
#import win32 "sys/windows.odin";

#load "libbrew_keys_win.odin" when ODIN_OS == "windows";

AppHandle :: win32.Hinstance;
WndHandle :: win32.Hwnd;

Msg :: union {
    NotTranslated {},
    QuitMessage {
        Code : int,
    },
    KeyDown {
        Key : VirtualKey,
        PrevDown : bool,
    },    
    KeyUp {
        Key : VirtualKey,
    },
}

get_app_handle :: proc() -> AppHandle {
    return AppHandle(win32.get_module_handle_a(nil));
}

create_window :: proc(app : AppHandle, title : string, width, height : int) -> WndHandle {
    wndClass : win32.WndClassExA;
    wndClass.size = size_of(win32.WndClassExA);
    wndClass.style = win32.CS_OWNDC|win32.CS_HREDRAW|win32.CS_VREDRAW;
    wndClass.wndproc = _window_proc;
    wndClass.instance = win32.Hinstance(app);
    class_buf : [256+6]byte;
    fmt.bprintf(class_buf[..], "%s_class\x00", title);
    wndClass.class_name = &class_buf[0];

    if win32.register_class_ex_a(&wndClass) == 0 {
        panic("LibBrew: Could not register window class");
    }

    WINDOW_STYLE :: win32.WS_OVERLAPPEDWINDOW|win32.WS_VISIBLE;
    rect := win32.Rect{0, 0, i32(width), i32(height)};
    win32.adjust_window_rect(&rect, WINDOW_STYLE, 0);

    title_buf : [256+1]byte;
    fmt.bprintf(title_buf[..], "%s\x00", title);

    handle := win32.create_window_ex_a(0,
                                       wndClass.class_name,
                                       &title_buf[0],
                                       WINDOW_STYLE,
                                       win32.CW_USEDEFAULT,
                                       win32.CW_USEDEFAULT,
                                       rect.right,
                                       rect.bottom,
                                       nil, nil,
                                       wndClass.instance,
                                       nil);

    if handle == nil {
        panic("LibBrew: Couldn't create window");
    }

    return WndHandle(handle);
}

poll_message :: proc(msg : ^Msg) -> bool {
    w_msg : win32.Msg;
    if win32.peek_message_a(&w_msg, nil, 0, 0, win32.PM_REMOVE) == win32.TRUE {
        match w_msg.message {
            case win32.WM_QUIT : {
                l_msg := Msg.QuitMessage{};
                l_msg.Code = int(w_msg.wparam);
                msg^ = l_msg;
                return true;
            }

            case win32.WM_KEYDOWN : {
                w_key := win32.KeyCode(w_msg.wparam);
                match w_key {
                    case win32.KeyCode.Menu : {
                        extended := bool((w_msg.lparam >> 24) & 1);
                        w_key = extended ? win32.KeyCode.Rmenu : win32.KeyCode.Lmenu; 
                    }

                    case win32.KeyCode.Control : {
                        extended := bool((w_msg.lparam >> 24) & 1);
                        w_key = extended ? win32.KeyCode.Rcontrol : win32.KeyCode.Lcontrol; 
                    }

                    case win32.KeyCode.Shift : {
                        sc := u32(w_msg.lparam & 0x00ff0000) >> 16;
                        w_key = win32.KeyCode(win32.map_virtual_key(sc, win32.MAPVK_VSC_TO_VK_EX));
                    }
                }

                l_msg := Msg.KeyDown{};
                l_msg.Key = VirtualKey(w_key);
                l_msg.PrevDown = bool((w_msg.lparam >> 30) & 1);
                msg^ = l_msg;
            }

            case win32.WM_SYSKEYDOWN : {
                w_key := win32.KeyCode(w_msg.wparam);
                if w_key == win32.KeyCode.Menu {
                    extended := bool((w_msg.lparam >> 24) & 1);
                    w_key = extended ? win32.KeyCode.Rmenu : win32.KeyCode.Lmenu; 
                }
                l_msg := Msg.KeyDown{};
                l_msg.Key = VirtualKey(w_key);
                l_msg.PrevDown = bool((w_msg.lparam >> 30) & 1);
                msg^ = l_msg;
                return true;
            }

            case win32.WM_KEYUP : {
                w_key := win32.KeyCode(w_msg.wparam);
                match w_key {
                    case win32.KeyCode.Menu : {
                        extended := bool((w_msg.lparam >> 24) & 1);
                        w_key = extended ? win32.KeyCode.Rmenu : win32.KeyCode.Lmenu; 
                    }

                    case win32.KeyCode.Control : {
                        extended := bool((w_msg.lparam >> 24) & 1);
                        w_key = extended ? win32.KeyCode.Rcontrol : win32.KeyCode.Lcontrol; 
                    }

                    case win32.KeyCode.Shift : {
                        sc := u32(w_msg.lparam & 0x00ff0000) >> 16;
                        w_key = win32.KeyCode(win32.map_virtual_key(sc, win32.MAPVK_VSC_TO_VK_EX));
                    }
                }

                l_msg := Msg.KeyUp{};
                l_msg.Key = VirtualKey(w_key);
                msg^ = l_msg;
            }

            case win32.WM_SYSKEYUP : {
                w_key := win32.KeyCode(w_msg.wparam);
                if w_key == win32.KeyCode.Menu {
                    extended := bool((w_msg.lparam >> 24) & 1);
                    w_key = extended ? win32.KeyCode.Rmenu : win32.KeyCode.Lmenu; 
                }
                l_msg := Msg.KeyUp{};
                l_msg.Key = VirtualKey(w_key);
                msg^ = l_msg;
                return true;
            }

            case : {
                l_msg := Msg.NotTranslated{};
                msg^ = l_msg;
            }
        }

        win32.translate_message(&w_msg);
        win32.dispatch_message_a(&w_msg);
        return true;
    } else {
        return false;
    }
}
/* Example of multi window handling
    for libbrew.poll_thread_message(&message) {
        match msg in message {
            case libbrew.Msg.QuitMessage : {
                fmt.println(msg.Code);
                break main_loop;
            }
        }
    }
    for libbrew.poll_window_message(wndHandle, &message) {
        match msg in message {
    }
}*/
poll_thread_message :: proc(msg : ^Msg) -> bool {
    THREAD_NULL_MSG :: win32.Hwnd(int(-1));
    w_msg : win32.Msg;
    if win32.peek_message_a(&w_msg, THREAD_NULL_MSG, 0, 0, win32.PM_REMOVE) == win32.TRUE {
        match w_msg.message {
            case win32.WM_QUIT : {
                l_msg := Msg.QuitMessage{};
                l_msg.Code = int(w_msg.wparam);
                msg^ = l_msg;
            }
        }

        return true;
    } else {
        return false;
    }
}

poll_window_message :: proc(wnd : WndHandle, msg : ^Msg) -> bool {
    w_msg : win32.Msg;
    if win32.peek_message_a(&w_msg, win32.Hwnd(wnd), 0, 0, win32.PM_REMOVE) == win32.TRUE {
        match w_msg.message {
        }

        win32.translate_message(&w_msg);
        win32.dispatch_message_a(&w_msg);
        return true;
    } else {
        return false;
    }
}

sleep :: proc(ms : int) {
    win32.sleep(i32(ms));
}

_window_proc :: proc(hwnd: win32.Hwnd, 
                    msg: u32, 
                    wparam: win32.Wparam, 
                    lparam: win32.Lparam) -> win32.Lresult #cc_c {
    match(msg) {    
        case win32.WM_CLOSE : {
            win32.destroy_window(hwnd);
            return 0;
        }   
        case win32.WM_DESTROY : {
            win32.post_message(nil, win32.WM_QUIT, 0, 0); //TODO Don't do it this way, since then we can't handle multiple windows that can open or close.
            return 0;
        }

/*        case win32.WM_SIZE : {
            return 0;
        }*/

        case : {
            return win32.def_window_proc_a(hwnd, msg, wparam, lparam);
        }
    }
}