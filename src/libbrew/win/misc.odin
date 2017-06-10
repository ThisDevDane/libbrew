/*
 *  @Name:     misc
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    hjortshoej@handmade.network
 *  @Creation: 01-06-2017 02:26:49
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 10-06-2017 17:52:11
 *  
 *  @Description:
 *  
 */

#import "fmt.odin";
#import win32 "sys/windows.odin";

AppHandle :: win32.Hinstance;
LibHandle :: win32.Hmodule;

get_app_handle :: proc() -> AppHandle {
    return AppHandle(win32.get_module_handle_a(nil));
}

sleep :: proc(ms : int) {
    win32.sleep(i32(ms));
}

load_library :: proc(name : string) -> LibHandle {
    buf : [256]u8;
    c_str := fmt.bprintf(buf[..], "%s\x00", name);
    h := win32.load_library_a(&c_str[0]);
    return LibHandle(h);
}

free_library :: proc(lib : LibHandle) {
    win32.free_library(win32.Hmodule(lib));
}

get_proc_address :: proc(lib : LibHandle, name : string) -> proc() #cc_c {
    buf : [256]u8;
    c_str := fmt.bprintf(buf[..], "%s\x00", name);
    return win32.get_proc_address(win32.Hmodule(lib), &c_str[0]);
}