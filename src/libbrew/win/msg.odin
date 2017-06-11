/*
 *  @Name:     msg
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    hjortshoej@handmade.network
 *  @Creation: 01-06-2017 02:24:23
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 10-06-2017 22:59:53
 *  
 *  @Description:
 *  
 */

#import "fmt.odin";
#import win32 "sys/windows.odin";

#import "../libbrew.odin";
#import "msg_user.odin";

Msg :: union {
    NotTranslated {},
    QuitMessage {
        code : int,
    },
    Key {
        key : libbrew.VirtualKey,
        down : bool,
        prev_down : bool,
    },    
    WindowFocus {
        enter_focus : bool,
    },
    KeyboardFocus {
        enter_focus : bool,
    },
    MouseMove {
        x : int,
        y : int,
    },
    MouseButton {
        key : libbrew.VirtualKey,
        down : bool,
        double_click : bool,
    }
}

poll_message :: proc(msg : ^Msg) -> bool {
    w_msg : win32.Msg;
    if win32.peek_message_a(&w_msg, nil, 0, 0, win32.PM_REMOVE) == win32.TRUE {
        match w_msg.message {
            case win32.WM_QUIT : {
                l_msg := Msg.QuitMessage{};
                l_msg.code = int(w_msg.wparam);
                msg^ = l_msg;
                return true;
            }

            case win32.WM_MOUSEMOVE : {
                l_msg := Msg.MouseMove{};
                l_msg.x = int(win32.LOWORD(w_msg.lparam));
                l_msg.y = int(win32.HIWORD(w_msg.lparam));
                msg^ = l_msg;
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

                l_msg := Msg.Key{};
                l_msg.key = libbrew.VirtualKey(w_key);
                l_msg.down = true;
                l_msg.prev_down = bool((w_msg.lparam >> 30) & 1);
                msg^ = l_msg;
            }

            case win32.WM_SYSKEYDOWN : {
                w_key := win32.KeyCode(w_msg.wparam);
                if w_key == win32.KeyCode.Menu {
                    extended := bool((w_msg.lparam >> 24) & 1);
                    w_key = extended ? win32.KeyCode.Rmenu : win32.KeyCode.Lmenu; 
                }
                l_msg := Msg.Key{};
                l_msg.key = libbrew.VirtualKey(w_key);
                l_msg.down = true;
                l_msg.prev_down = bool((w_msg.lparam >> 30) & 1);
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

                l_msg := Msg.Key{};
                l_msg.key = libbrew.VirtualKey(w_key);
                l_msg.down = false;
                l_msg.prev_down = false;
                msg^ = l_msg;
            }

            case win32.WM_SYSKEYUP : {
                w_key := win32.KeyCode(w_msg.wparam);
                if w_key == win32.KeyCode.Menu {
                    extended := bool((w_msg.lparam >> 24) & 1);
                    w_key = extended ? win32.KeyCode.Rmenu : win32.KeyCode.Lmenu; 
                }
                l_msg := Msg.Key{};
                l_msg.key = libbrew.VirtualKey(w_key);
                l_msg.down = false;
                l_msg.prev_down = false;
                return true;
            }

            case win32.WM_LBUTTONDOWN : {
                l_msg := Msg.MouseButton{};
                l_msg.key = libbrew.VirtualKey.LMouse;
                l_msg.down = true;
                l_msg.double_click = false;
                msg^ = l_msg;
            }

            case win32.WM_LBUTTONUP : {
                l_msg := Msg.MouseButton{};
                l_msg.key = libbrew.VirtualKey.LMouse;
                l_msg.down = false;
                l_msg.double_click = false;
                msg^ = l_msg;
            }

            case win32.WM_LBUTTONDBLCLK : {
                l_msg := Msg.MouseButton{};
                l_msg.key = libbrew.VirtualKey.LMouse;
                l_msg.down = true;
                l_msg.double_click = true;
                msg^ = l_msg;
            }

            case win32.WM_RBUTTONDOWN : {
                l_msg := Msg.MouseButton{};
                l_msg.key = libbrew.VirtualKey.RMouse;
                l_msg.down = true;
                l_msg.double_click = false;
                msg^ = l_msg;
            }

            case win32.WM_RBUTTONUP : {
                l_msg := Msg.MouseButton{};
                l_msg.key = libbrew.VirtualKey.RMouse;
                l_msg.down = false;
                l_msg.double_click = false;
                msg^ = l_msg;
            }

            case win32.WM_RBUTTONDBLCLK : {
                l_msg := Msg.MouseButton{};
                l_msg.key = libbrew.VirtualKey.RMouse;
                l_msg.down = true;
                l_msg.double_click = true;
                msg^ = l_msg;
            }

            case win32.WM_MBUTTONDOWN : {
                l_msg := Msg.MouseButton{};
                l_msg.key = libbrew.VirtualKey.MMouse;
                l_msg.down = true;
                l_msg.double_click = false;
                msg^ = l_msg;
            }

            case win32.WM_MBUTTONUP : {
                l_msg := Msg.MouseButton{};
                l_msg.key = libbrew.VirtualKey.MMouse;
                l_msg.down = false;
                l_msg.double_click = false;
                msg^ = l_msg;
            }

            case win32.WM_MBUTTONDBLCLK : {
                l_msg := Msg.MouseButton{};
                l_msg.key = libbrew.VirtualKey.MMouse;
                l_msg.down = true;
                l_msg.double_click = true;
                msg^ = l_msg;
            }

            case msg_user.WINDOW_FOCUS : {
                l_msg := Msg.WindowFocus{};
                l_msg.enter_focus = bool(w_msg.wparam);
                msg^ = l_msg;
            }

            case msg_user.KEYBOARD_FOCUS : {
                l_msg := Msg.KeyboardFocus{};
                l_msg.enter_focus = bool(w_msg.wparam);
                msg^ = l_msg;
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
                l_msg.code = int(w_msg.wparam);
                msg^ = l_msg;
            }
        }

        return true;
    } else {
        return false;
    }
}

poll_window_message :: proc(wnd : libbrew.WndHandle, msg : ^Msg) -> bool {
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