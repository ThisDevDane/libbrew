/*
 *  @Name:     window_windows
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    hjortshoej@handmade.network
 *  @Creation: 01-06-2017 02:25:37
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 01-08-2018 23:11:53 UTC+1
 *  
 *  @Description:
 *  
 */

package brew_sys;

foreign import kernel32 "system:kernel32.lib";
import "core:fmt";
import "core:strings";
import "core:sys/win32";

WndHandle :: win32.Hwnd;

MAKEINTRESOURCEA :: inline proc(i : u16) -> cstring {
    return cast(cstring)(cast(^u8)(rawptr(uintptr(int(u16(i))))));
}

IDC_ARROW    := win32.load_cursor_a(nil, MAKEINTRESOURCEA(32512));
IDC_IBEAM    := win32.load_cursor_a(nil, MAKEINTRESOURCEA(32513));
IDC_SIZENESW := win32.load_cursor_a(nil, MAKEINTRESOURCEA(32513));
IDC_SIZENS   := win32.load_cursor_a(nil, MAKEINTRESOURCEA(32513));
IDC_SIZENWSE := win32.load_cursor_a(nil, MAKEINTRESOURCEA(32513));
IDC_SIZEWE   := win32.load_cursor_a(nil, MAKEINTRESOURCEA(32513));

Window_Style :: enum u32 {
    Resizeable  = win32.WS_THICKFRAME,
    Minimizable = win32.WS_MINIMIZEBOX,
    Maximizable = win32.WS_MAXIMIZEBOX,
    HasTitlebar = win32.WS_CAPTION,
    ThinBorder  = win32.WS_BORDER,



    NormalWindow = win32.WS_OVERLAPPED | HasTitlebar | Resizeable | Minimizable | Maximizable | win32.WS_SYSMENU,
    NonresizeableWindow =  win32.WS_OVERLAPPED | HasTitlebar | Minimizable | win32.WS_SYSMENU,
    NoChromaWindow = win32.WS_POPUP | ThinBorder | win32.WS_SYSMENU,
}  

create_window :: proc[create_window1, create_window2, create_window3];

create_window1 :: proc(app : AppHandle, title : string, popup_window : bool, width, height : int) -> WndHandle {
    return create_window(app, title, popup_window, win32.CW_USEDEFAULT, win32.CW_USEDEFAULT, width, height);
}
create_window2 :: proc(app : AppHandle, title : string, popup_window : bool, x, y, width, height : int) -> WndHandle {
    wndClass := _register_class(app, title);

    WINDOW_STYLE : u32 = popup_window ? win32.WS_POPUPWINDOW : win32.WS_OVERLAPPEDWINDOW;
    WINDOW_STYLE |= win32.WS_VISIBLE;
    rect := win32.Rect{0, 0, i32(width), i32(height)};
    win32.adjust_window_rect(&rect, WINDOW_STYLE, false);

    title_buf : [256+1]u8;
    fmt.bprintf(title_buf[:], "%s\x00", title);

    handle := win32.create_window_ex_a(0,
                                       wndClass.class_name,
                                       cstring(&title_buf[0]),
                                       WINDOW_STYLE,
                                       i32(x),
                                       i32(y),
                                       rect.right - rect.left,
                                       rect.bottom - rect.top,
                                       nil, nil,
                                       wndClass.instance,
                                       nil);

    if handle == nil {
        panic("LibBrew: Couldn't create window");
    }

    return WndHandle(handle);
}

create_window3 :: proc(app : AppHandle, title : string, width : int, height : int, style := Window_Style.NormalWindow) -> WndHandle {
    wndClass := _register_class(app, title);

    WINDOW_STYLE : u32 = u32(style);
    WINDOW_STYLE |= win32.WS_VISIBLE;
    rect := win32.Rect{0, 0, i32(width), i32(height)};
    win32.adjust_window_rect(&rect, WINDOW_STYLE, false);

    title_buf : [256+1]u8;
    fmt.bprintf(title_buf[:], "%s\x00", title);

    handle := win32.create_window_ex_a(0,
                                       wndClass.class_name,
                                       cstring(&title_buf[0]),
                                       WINDOW_STYLE,
                                       win32.CW_USEDEFAULT,
                                       win32.CW_USEDEFAULT,
                                       rect.right - rect.left,
                                       rect.bottom - rect.top,
                                       nil, nil,
                                       wndClass.instance,
                                       nil);

    if handle == nil {
        err := win32.get_last_error();
        panic(fmt.aprintf("LibBrew(%d): Couldn't create window\n", err));
    }

    return WndHandle(handle);
}

_register_class :: proc(app : AppHandle, title : string) -> win32.Wnd_Class_Ex_A {
    wndClass : win32.Wnd_Class_Ex_A;
    wndClass.size = size_of(win32.Wnd_Class_Ex_A);
    wndClass.style = win32.CS_OWNDC|win32.CS_HREDRAW|win32.CS_VREDRAW;
    wndClass.wnd_proc = _window_proc;
    //FIXME: Since this doesn't work, err 87, then we should just try and do LoadCursor() SetCursor()
    wndClass.cursor = IDC_ARROW;
    wndClass.instance = win32.Hinstance(app);
    class_buf := make([]u8, 256+6);
    fmt.bprintf(class_buf[:], "%s_class\x00", title);
    wndClass.class_name = cstring(&class_buf[0]);


    LR_DEFAULTSIZE :: 0x00000040;
    icon := cast(win32.Hicon) win32.load_image_a(wndClass.instance, MAKEINTRESOURCEA(6123), 1, 0, 0, LR_DEFAULTSIZE);
    wndClass.icon = icon;

    if win32.register_class_ex_a(&wndClass) == 0 {
        err := win32.get_last_error();
        panic(fmt.aprintf("LibBrew(%d): Couldn't create class", err));
    }

    return wndClass;
}

get_client_size :: proc(handle : WndHandle) -> (int, int) {
    rect : win32.Rect;
    win32.get_client_rect(win32.Hwnd(handle), &rect);
    return int(rect.right), int(rect.bottom); 
}

get_window_rect :: proc(handle : WndHandle) -> (int, int, int, int) {
    rect : win32.Rect;
    win32.get_window_rect(win32.Hwnd(handle), &rect);
    return int(rect.left), int(rect.top), int(rect.right), int(rect.bottom); 
}

set_window_size :: proc[set_window_size_not_safe, set_window_size_safe];

set_window_size_not_safe :: proc(handle : WndHandle, width, height : int) {
    set_window_size(handle, width, height, true);
}

set_window_size_safe :: proc(handle : WndHandle, width, height : int, safe_min_max : bool) {
    new_w : int = width; 
    new_h : int = height;
    if safe_min_max {
        new_w = width < 150 ? 150 : width;
        new_h = height < 45 ? 45 : height;
    }
    win32.set_window_pos(win32.Hwnd(handle), nil, 
                         0, 0,
                         i32(new_w), i32(new_h), 
                         win32.SWP_NOMOVE | win32.SWP_NOZORDER);
}

get_window_pos :: proc(handle : WndHandle) -> (int, int) {
    rect : win32.Rect;
    win32.get_window_rect(win32.Hwnd(handle), &rect);
    return int(rect.left), int(rect.top);
}

set_window_pos :: proc(handle : WndHandle, new_x, new_y : int) {
    win32.set_window_pos(win32.Hwnd(handle), nil, 
                         i32(new_x), i32(new_y), 
                         0 , 0, 
                         win32.SWP_NOSIZE | win32.SWP_NOZORDER);
}

get_mouse_pos :: proc(handle : WndHandle) -> (int, int) {
    p : win32.Point;
    win32.get_cursor_pos(&p);
    win32.screen_to_client(win32.Hwnd(handle), &p);
    return int(p.x), int(p.y);
}

maximize_window :: proc(handle : WndHandle) {
    win32.show_window(win32.Hwnd(handle), 3);
}

restore_window :: proc(handle : WndHandle) {
    win32.show_window(win32.Hwnd(handle), 9);
}

swap_buffers :: proc(wnd : WndHandle) {
    dc := win32.get_dc(win32.Hwnd(wnd));
    win32.swap_buffers(dc);
    win32.release_dc(win32.Hwnd(wnd), dc);
}

_window_proc :: proc "cdecl"(hwnd: win32.Hwnd, 
                     msg: u32, 
                     wparam: win32.Wparam, 
                     lparam: win32.Lparam) -> win32.Lresult {
    switch msg {    
        case win32.WM_CLOSE : {
            win32.destroy_window(hwnd);
            return 0;
        }   
        case win32.WM_DESTROY : {
            //FIXME Don't do it this way, since then we can't handle multiple windows that can open or close.
            win32.post_message(nil, win32.WM_QUIT, 0, 0); 
            return 0;
        }

        case win32.WM_ACTIVATEAPP  : {
            win32.post_message(nil, WINDOW_FOCUS, u32(wparam), 0);
            return 0;
        }

        case win32.WM_ACTIVATE  : {
            //TODO Handle WM_ACTIVE
            //win32.post_message(nil, msg_user.FOCUS, 0, 0);
            return 0;
        }

        case win32.WM_KILLFOCUS  : {
            win32.post_message(nil, KEYBOARD_FOCUS, 0, 0);
            return 0;
        }

        case win32.WM_SETFOCUS  : {
            win32.post_message(nil, KEYBOARD_FOCUS, 0, 1);
            return 0;
        }

        case win32.WM_SIZE : {
            window_resized = true;
            window_new_width  = int(win32.LOWORD_L(lparam));
            window_new_height = int(win32.HIWORD_L(lparam));
            return 0;
        }

        case : {
            return win32.def_window_proc_a(hwnd, msg, wparam, lparam);
        }
    }
}