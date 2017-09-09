/*
 *  @Name:     misc
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    hjortshoej@handmade.network
 *  @Creation: 01-06-2017 02:26:49
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 09-09-2017 23:25:35
 *  
 *  @Description:
 *  
 */

import "core:fmt.odin";
import win32 "core:sys/windows.odin";

AppHandle :: win32.Hinstance;
LibHandle :: win32.Hmodule;

TimeData :: struct {
    _pf_freq : i64;
    _pf_old : i64;
}

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
    return proc() #cc_c(win32.get_proc_address(win32.Hmodule(lib), &c_str[0]));
}

create_time_data :: proc() -> TimeData {
    res : TimeData;

    win32.query_performance_frequency(&res._pf_freq);
    win32.query_performance_counter(&res._pf_old);

    return res;
}

time :: proc(data : ^TimeData) -> f64 {
    result  : f64;

    newTime : i64;
    win32.query_performance_counter(&newTime);
    result = f64((newTime - data._pf_old));
    data._pf_old = newTime;
    result /= f64(data._pf_freq);

    return result;
}