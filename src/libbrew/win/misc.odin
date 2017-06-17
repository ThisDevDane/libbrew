/*
 *  @Name:     misc
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    hjortshoej@handmade.network
 *  @Creation: 01-06-2017 02:26:49
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 15-06-2017 21:23:47
 *  
 *  @Description:
 *  
 */

import "fmt.odin";
import win32 "sys/windows.odin";

type AppHandle win32.Hinstance;
type LibHandle win32.Hmodule;

type TimeData struct {
    _pf_freq : i64,
    _pf_old : i64,
}

proc get_app_handle() -> AppHandle {
    return AppHandle(win32.get_module_handle_a(nil));
}

proc sleep(ms : int) {
    win32.sleep(i32(ms));
}

proc load_library(name : string) -> LibHandle {
    var buf : [256]u8;
    var c_str = fmt.bprintf(buf[..], "%s\x00", name);
    var h = win32.load_library_a(&c_str[0]);
    return LibHandle(h);
}

proc free_library(lib : LibHandle) {
    win32.free_library(win32.Hmodule(lib));
}

proc get_proc_address(lib : LibHandle, name : string) -> proc() #cc_c {
    var buf : [256]u8;
    var c_str = fmt.bprintf(buf[..], "%s\x00", name);
    return win32.get_proc_address(win32.Hmodule(lib), &c_str[0]);
}

proc create_time_data() -> TimeData {
    var res : TimeData;

    win32.query_performance_frequency(&res._pf_freq);
    win32.query_performance_counter(&res._pf_old);

    return res;
}

proc time(data : ^TimeData) -> f64 {
    var result  : f64;

    var newTime : i64;
    win32.query_performance_counter(&newTime);
    result = f64((newTime - data._pf_old));
    data._pf_old = newTime;
    result /= f64(data._pf_freq);

    return result;
}