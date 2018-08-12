/*
 *  @Name:     misc_windows
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    hjortshoej@handmade.network
 *  @Creation: 01-06-2017 02:26:49
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 07-08-2018 21:07:58 UTC+1
 *  
 *  @Description:
 *  
 */

package brew_sys;

import "core:fmt";
import "core:sys/win32";

AppHandle :: win32.Hinstance;
LibHandle :: win32.Hmodule;

//BUG(Hoej): sub-processes don't aggregate up their errors
execute_system_command :: proc(fmt_ : string, args : ..any) -> int {
    exit_code : u32;

    su := win32.Startup_Info{};
    su.cb = size_of(win32.Startup_Info);
    pi := win32.Process_Information{};
    cmd := fmt.aprintf(fmt_, ..args);
    
    if win32.create_process_w(nil, odin_to_wchar_string(cmd), nil, nil, false, 0, nil, nil, &su, &pi) {
        win32.wait_for_single_object(pi.process, win32.INFINITE);
        win32.get_exit_code_process(pi.process, &exit_code);
        win32.close_handle(pi.process);
        win32.close_handle(pi.thread);
    } else {
        fmt.printf_err("Failed to execute:\n\t%s\n", cmd);
        return -1;
    }
    

    return int(exit_code);
}

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
    c_str := fmt.bprintf(buf[:], "%s\x00", name);
    h := win32.load_library_a(cstring(&c_str[0]));
    return LibHandle(h);
}

free_library :: proc(lib : LibHandle) {
    win32.free_library(win32.Hmodule(lib));
}

get_proc_address :: proc "cdecl"(lib : LibHandle, name : string) -> proc "cdecl"(){
    buf : [256]u8;
    c_str := fmt.bprintf(buf[:], "%s\x00", name);
    return proc "cdecl"()(win32.get_proc_address(win32.Hmodule(lib), cstring(&c_str[0])));
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

DateTime :: struct {
    day_of_week : Week_Day,
    day         : int,
    month       : Month,
    year        : int,

    hour        : int,
    minute      : int,
    second      : int,
    millisecond : int,
}

unix_to_datetime :: proc(unixtime : int)  -> DateTime {
    filetime := win32.Filetime{};
    systime := win32.Systemtime{};
    

    ll := (unixtime * 10000000) + 116444736000000000;
    filetime.lo = u32(ll);
    filetime.hi = u32(ll >> 32);
    win32.file_time_to_system_time(&filetime, &systime);
    using systime;
    return DateTime{
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

filetime_to_datetime :: proc(ft : win32.Filetime) -> DateTime {
    st := win32.Systemtime{};
    win32.file_time_to_system_time(&ft, &st);
    using st;
    return DateTime{
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

odin_to_wchar_string :: proc(str : string) -> win32.Wstring {
    olen := i32(len(str) * size_of(byte));
    wlen := win32.multi_byte_to_wide_char(win32.CP_UTF8, 0, cstring(&str[0]), olen, nil, 0);
    buf := make([]u16, int(wlen * size_of(u16) + 1));
    ptr := win32.Wstring(&buf[0]);
    win32.multi_byte_to_wide_char(win32.CP_UTF8, 0, cstring(&str[0]), olen, ptr, wlen);

    return ptr;
}

wchar_to_odin_string :: proc(wc_str : win32.Wstring, wlen : i32 = -1) -> string {
    olen := win32.wide_char_to_multi_byte(win32.CP_UTF8, 0, wc_str, wlen, 
                                          nil, 0, 
                                          nil, nil);

    buf := make([]byte, int(olen));
    win32.wide_char_to_multi_byte(win32.CP_UTF8, 0, wc_str, wlen, 
                                  cstring(&buf[0]), olen, 
                                  nil, nil);

    return string(buf[:olen]);
}

wchar_to_odin_string_from_buf :: proc(buf : []byte, wc_str : win32.Wstring, wlen : i32 = -1) -> string {
    olen := win32.wide_char_to_multi_byte(win32.CP_UTF8, 0, wc_str, wlen, 
                                          nil, 0, 
                                          nil, nil);

    win32.wide_char_to_multi_byte(win32.CP_UTF8, 0, wc_str, wlen, 
                                  cstring(&buf[0]), olen, 
                                  nil, nil);

    return string(buf[:olen]);
}