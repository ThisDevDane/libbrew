/*
 *  @Name:     misc
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    hjortshoej@handmade.network
 *  @Creation: 01-06-2017 02:26:49
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 28-01-2018 23:10:43 UTC+1
 *  
 *  @Description:
 *  
 */

import "core:fmt.odin";
import win32 "core:sys/windows.odin";

AppHandle :: win32.Hinstance;
LibHandle :: win32.Hmodule;

TimeData :: struct {
    _pf_freq : i64,
    _pf_old : i64,
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

get_proc_address :: proc "cdecl"(lib : LibHandle, name : string) -> proc "cdecl"(){
    buf : [256]u8;
    c_str := fmt.bprintf(buf[..], "%s\x00", name);
    return proc "cdecl"()(win32.get_proc_address(win32.Hmodule(lib), &c_str[0]));
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

Week_Day :: enum {
    Monday = 0,
    Tuesday,
    Wednesday,
    Thursday,
    Friday,
    Saturday,
    Sunday,
}

Month :: enum {
    January = 0,
    February,
    March,
    April,
    May,
    June,
    July,
    August,
    September,
    October,
    November,
    December,
}

Datetime :: struct {
    day_of_week : Week_Day,
    day         : int,
    month       : Month,
    year        : int,

    hour        : int,
    minute      : int,
    second      : int,
    millisecond : int,
}

unix_to_datetime :: proc(unixtime : int)  -> Datetime {
    filetime := win32.Filetime{};
    systime := win32.Systemtime{};
    

    ll := (unixtime * 10000000) + 116444736000000000;
    filetime.lo = u32(ll);
    filetime.hi = u32(ll >> 32);
    win32.file_time_to_system_time(&filetime, &systime);
    using systime;
    return Datetime{
        Week_Day(day_of_week),
        int(day),
        Month(month),
        int(year),
        int(hour),
        int(minute),
        int(second),
        int(millisecond)
    };
}

filetime_to_datetime :: proc(ft : win32.Filetime) -> Datetime {
    st := win32.Systemtime{};
    win32.file_time_to_system_time(&ft, &st);
    using st;
    return Datetime{
        Week_Day(day_of_week),
        int(day),
        Month(month),
        int(year),
        int(hour),
        int(minute),
        int(second),
        int(millisecond)
    };
}