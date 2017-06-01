/*
 *  @Name:     window
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    hjortshoej@handmade.network
 *  @Creation: 01-06-2017 02:25:37
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 01-06-2017 02:36:12
 *  
 *  @Description:
 *  
 */

#import "fmt.odin";
#import win32 "sys/windows.odin";

#import "../libbrew.odin";

WndHandle :: win32.Hwnd;

create_window :: proc(app : libbrew.AppHandle, title : string, width, height : int) -> WndHandle {
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

      /*case win32.WM_SIZE : {
            return 0;
        }*/

        case : {
            return win32.def_window_proc_a(hwnd, msg, wparam, lparam);
        }
    }
}