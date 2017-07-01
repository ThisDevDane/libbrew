/*
 *  @Name:     window
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    hjortshoej@handmade.network
 *  @Creation: 01-06-2017 02:25:37
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 02-07-2017 01:05:25
 *  
 *  @Description:
 *  
 */

import "fmt.odin";
import win32 "sys/windows.odin";

import "misc.odin";
import "msg_user.odin";
import lib_msg "msg.odin";

WndHandle :: win32.Hwnd;

MAKEINTRESOURCEA :: proc(i : u16) -> ^u8 #inline {
    return ^u8(rawptr(int(u16(i))));
}

IDC_ARROW : win32.Hcursor = win32.Hcursor(MAKEINTRESOURCEA(32512));


create_window :: proc(app : misc.AppHandle, title : string, popup_window : bool, width, height : int) -> WndHandle {
    return create_window(app, title, popup_window, win32.CW_USEDEFAULT, win32.CW_USEDEFAULT, width, height);
}
create_window :: proc(app : misc.AppHandle, title : string, popup_window : bool, x, y, width, height : int) -> WndHandle {
    wndClass : win32.WndClassExA;
    wndClass.size = size_of(win32.WndClassExA);
    wndClass.style = win32.CS_OWNDC|win32.CS_HREDRAW|win32.CS_VREDRAW;
    wndClass.wnd_proc = _window_proc;
    //wndClass.cursor = IDC_ARROW;
    wndClass.instance = win32.Hinstance(app);
    class_buf : [256+6]u8;
    fmt.bprintf(class_buf[..], "%s_class\x00", title);
    wndClass.class_name = &class_buf[0];

    if win32.register_class_ex_a(&wndClass) == 0 {
        fmt.println(win32.get_last_error());
        panic("LibBrew: Could not register window class");
    }

    WINDOW_STYLE : u32 = popup_window ? win32.WS_POPUPWINDOW : win32.WS_OVERLAPPEDWINDOW;
    WINDOW_STYLE |= win32.WS_VISIBLE;
    rect := win32.Rect{0, 0, i32(width), i32(height)};
    win32.adjust_window_rect(&rect, WINDOW_STYLE, 0);

    title_buf : [256+1]u8;
    fmt.bprintf(title_buf[..], "%s\x00", title);

    handle := win32.create_window_ex_a(0,
                                       wndClass.class_name,
                                       &title_buf[0],
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

set_window_size :: proc(handle : WndHandle, width, height : int) {
    set_window_size(handle, width, height, true);
}

set_window_size :: proc(handle : WndHandle, width, height : int, safe_min_max : bool) {
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
            //TODO Don't do it this way, since then we can't handle multiple windows that can open or close.
            win32.post_message(nil, win32.WM_QUIT, 0, 0); 
            return 0;
        }

        case win32.WM_ACTIVATEAPP  : {
            win32.post_message(nil, msg_user.WINDOW_FOCUS, u32(wparam), 0);
            return 0;
        }

        case win32.WM_ACTIVATE  : {
            //TODO
            //win32.post_message(nil, msg_user.FOCUS, 0, 0);
            return 0;
        }

        case win32.WM_KILLFOCUS  : {
            win32.post_message(nil, msg_user.KEYBOARD_FOCUS, 0, 0);
            return 0;
        }

        case win32.WM_SETFOCUS  : {
            win32.post_message(nil, msg_user.KEYBOARD_FOCUS, 0, 1);
            return 0;
        }

        case win32.WM_SIZE : {
            lib_msg.window_resized = true;
            lib_msg.window_new_width  = int(win32.LOWORD(lparam));
            lib_msg.window_new_height = int(win32.HIWORD(lparam));
            return 0;
        }

        case : {
            return win32.def_window_proc_a(hwnd, msg, wparam, lparam);
        }
    }
}