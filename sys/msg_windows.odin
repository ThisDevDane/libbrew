/*
 *  @Name:     msg_windows
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    hjortshoej@handmade.network
 *  @Creation: 01-06-2017 02:24:23
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 15-06-2018 16:18:59 UTC+1
 *  
 *  @Description:
 *  
 */

package brew_sys;

import "core:fmt";
import "core:sys/win32";

window_resized    := false;
window_new_width  : int;
window_new_height : int;


//TODO(Hoej): Remove Msg prefix from union members
Msg :: union {
    MsgNotTranslated,
    MsgQuitMessage,
    MsgKey,  
    MsgWindowFocus,
    MsgKeyboardFocus,
    MsgMouseMove,
    MsgMouseButton,
    MsgSizeChange,
    MsgChar,
    MsgMouseWheel,
}

MsgNotTranslated :: struct {};
MsgQuitMessage :: struct {
    code : int,
}

MsgKey :: struct {
    key       : VirtualKey,
    down      : bool,
    prev_down : bool,
}   

MsgWindowFocus :: struct {
    enter_focus : bool,
}

MsgKeyboardFocus :: struct {
    enter_focus : bool,
}

MsgMouseMove :: struct {
    x : int,
    y : int,
}

MsgMouseButton :: struct {
    key          : VirtualKey,
    down         : bool,
    double_click : bool,
}

MsgSizeChange :: struct {
    width  : int,
    height : int,
}

MsgChar :: struct {
    char : rune,
}

MsgMouseWheel :: struct {
    distance : int,
}

poll_message :: proc(msg : ^Msg) -> bool {
    if window_resized {
        window_resized = false;
        l_msg := MsgSizeChange{window_new_width, window_new_height};
        msg^ = l_msg;
        return true;
    }

    w_msg : win32.Msg;
    if win32.peek_message_a(&w_msg, nil, 0, 0, win32.PM_REMOVE) == true {
        switch w_msg.message {
            case win32.WM_QUIT : {
                l_msg := MsgQuitMessage{
                    code = int(w_msg.wparam)
                };
                msg^ = l_msg;
                return true;
            }

            case win32.WM_CLOSE : {
                l_msg := MsgQuitMessage{
                    code = int(w_msg.wparam)
                };
                msg^ = l_msg;
                return true;
            }

            case win32.WM_MOUSEMOVE : {
                l_msg := MsgMouseMove{
                    x = int(win32.LOWORD_L(w_msg.lparam)),
                    y = int(win32.HIWORD_L(w_msg.lparam))
                };
                msg^ = l_msg;
            }

            case win32.WM_CHAR : {
                l_msg := MsgChar{
                    char = rune(w_msg.wparam)
                };
                msg^ = l_msg;
            }

            case win32.WM_KEYDOWN : {
                w_key := win32.Key_Code(w_msg.wparam);
                switch w_key {
                    case win32.Key_Code.Menu : {
                        extended := bool((w_msg.lparam >> 24) & 1);
                        w_key = extended ? win32.Key_Code.Rmenu : win32.Key_Code.Lmenu; 
                    }

                    case win32.Key_Code.Control : {
                        extended := bool((w_msg.lparam >> 24) & 1);
                        w_key = extended ? win32.Key_Code.Rcontrol : win32.Key_Code.Lcontrol; 
                    }

                    case win32.Key_Code.Shift : {
                        sc := u32(w_msg.lparam & 0x00ff0000) >> 16;
                        w_key = win32.Key_Code(win32.map_virtual_key_a(sc, win32.MAPVK_VSC_TO_VK_EX));
                    }
                }

                l_msg := MsgKey{
                    key = VirtualKey(w_key),
                    down = true,
                    prev_down = bool((w_msg.lparam >> 30) & 1),
                };
                msg^ = l_msg;
            }

            case win32.WM_SYSKEYDOWN : {
                w_key := win32.Key_Code(w_msg.wparam);
                if w_key == win32.Key_Code.Menu {
                    extended := bool((w_msg.lparam >> 24) & 1);
                    w_key = extended ? win32.Key_Code.Rmenu : win32.Key_Code.Lmenu; 
                }
                l_msg := MsgKey{
                    key = VirtualKey(w_key),
                    down = true,
                    prev_down = bool((w_msg.lparam >> 30) & 1)
                };
                msg^ = l_msg;
                return true;
            }

            case win32.WM_KEYUP : {
                w_key := win32.Key_Code(w_msg.wparam);
                switch w_key {
                    case win32.Key_Code.Menu : {
                        extended := bool((w_msg.lparam >> 24) & 1);
                        w_key = extended ? win32.Key_Code.Rmenu : win32.Key_Code.Lmenu; 
                    }

                    case win32.Key_Code.Control : {
                        extended := bool((w_msg.lparam >> 24) & 1);
                        w_key = extended ? win32.Key_Code.Rcontrol : win32.Key_Code.Lcontrol; 
                    }

                    case win32.Key_Code.Shift : {
                        sc := u32(w_msg.lparam & 0x00ff0000) >> 16;
                        w_key = win32.Key_Code(win32.map_virtual_key_a(sc, win32.MAPVK_VSC_TO_VK_EX));
                    }
                }

                l_msg := MsgKey{
                    key = VirtualKey(w_key),
                    down = false,
                    prev_down = false,
                };
                msg^ = l_msg;
            }

            case win32.WM_SYSKEYUP : {
                w_key := win32.Key_Code(w_msg.wparam);
                if w_key == win32.Key_Code.Menu {
                    extended := bool((w_msg.lparam >> 24) & 1);
                    w_key = extended ? win32.Key_Code.Rmenu : win32.Key_Code.Lmenu; 
                }
                l_msg := MsgKey{
                    key = VirtualKey(w_key),
                    down = false,
                    prev_down = false,
                };
                return true;
            }

            case win32.WM_LBUTTONDOWN : {
                l_msg := MsgMouseButton{
                    key = VirtualKey.LMouse,
                    down = true,
                    double_click = false,
                };
                msg^ = l_msg;
            }

            case win32.WM_LBUTTONUP : {
                l_msg := MsgMouseButton{
                    key = VirtualKey.LMouse,
                    down = false,
                    double_click = false,
                };
                msg^ = l_msg;
            }

            case win32.WM_LBUTTONDBLCLK : {
                l_msg := MsgMouseButton{
                    key = VirtualKey.LMouse,
                    down = true,
                    double_click = true,
                };
                msg^ = l_msg;
            }

            case win32.WM_RBUTTONDOWN : {
                l_msg := MsgMouseButton{
                    key = VirtualKey.RMouse,
                    down = true,
                    double_click = false,
                };
                msg^ = l_msg;
            }

            case win32.WM_RBUTTONUP : {
                l_msg := MsgMouseButton{
                    key = VirtualKey.RMouse,
                    down = false,
                    double_click = false,
                };
                msg^ = l_msg;
            }

            case win32.WM_RBUTTONDBLCLK : {
                l_msg := MsgMouseButton{
                    key = VirtualKey.RMouse,
                    down = true,
                    double_click = true,
                };
                msg^ = l_msg;
            }

            case win32.WM_MBUTTONDOWN : {
                l_msg := MsgMouseButton{
                    key = VirtualKey.MMouse,
                    down = true,
                    double_click = false,
                };
                msg^ = l_msg;
            }

            case win32.WM_MBUTTONUP : {
                l_msg := MsgMouseButton{
                    key = VirtualKey.MMouse,
                    down = false,
                    double_click = false,
                };
                msg^ = l_msg;
            }

            case win32.WM_MBUTTONDBLCLK : {
                l_msg := MsgMouseButton{
                    key = VirtualKey.MMouse,
                    down = true,
                    double_click = true,
                };
                msg^ = l_msg;
            }

            case win32.WM_MOUSEWHEEL : {
                WHEEL_DELTA :: 120;

                l_msg := MsgMouseWheel {
                    int(cast(i16)win32.HIWORD_W(w_msg.wparam)) / WHEEL_DELTA,
                };
                msg^ = l_msg;
            }

            case WINDOW_FOCUS : {
                l_msg := MsgWindowFocus{
                    enter_focus = bool(w_msg.wparam)
                };
                msg^ = l_msg;
            }

            case KEYBOARD_FOCUS : {
                l_msg := MsgKeyboardFocus{
                    enter_focus = bool(w_msg.wparam)
                };
                msg^ = l_msg;
            }

            case : {
                l_msg := MsgNotTranslated{};
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
        switch msg in message {
            case libbrew.Msg.QuitMessage : {
                fmt.println(msg.Code);
                break main_loop;
            }
        }
    }
    for libbrew.poll_window_message(wndHandle, &message) {
        switch msg in message {
    }
}*/
/*//TODO: ALL OF IT
poll_thread_message :: proc(msg : ^Msg) -> bool {
    THREAD_NULL_MSG :: win32.Hwnd(int(-1));
    w_msg : win32.Msg;
    if win32.peek_message_a(&w_msg, THREAD_NULL_MSG, 0, 0, win32.PM_REMOVE) == win32.TRUE {
        switch w_msg.message {
            case win32.WM_QUIT : {
                l_msg := MsgQuitMessage{
                    code = int(w_msg.wparam)
                };
                msg^ = l_msg;
            }
        }

        return true;
    } else {
        return false;
    }
}
//TODO: ALL OF IT
poll_window_message :: proc(wnd : libbrew.WndHandle, msg : ^Msg) -> bool {
    w_msg : win32.Msg;
    if win32.peek_message_a(&w_msg, win32.Hwnd(wnd), 0, 0, win32.PM_REMOVE) == win32.TRUE {
        switch w_msg.message {
        }

        win32.translate_message(&w_msg);
        win32.dispatch_message_a(&w_msg);
        return true;
    } else {
        return false;
    }
}*/