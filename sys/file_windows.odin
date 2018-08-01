/*
 *  @Name:     file_windows
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    hoej@northwolfprod.com
 *  @Creation: 29-10-2017 20:14:21
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 01-08-2018 23:10:11 UTC+1
 *  
 *  @Description:
 *  
 */

package brew_sys;

import "core:fmt";
import "core:strings";
import "core:sys/win32";

import util "shared:libbrew/util";

DiskEntry :: struct {
    name     : string,
    creation : DateTime,
    modified : DateTime,
    type_    : string,
    dir      : bool,
    size     : int,

    hidden   : bool,
    system   : bool,
}

move_file :: proc(src, dest : string, force := false) -> bool {
    flags : u32 = win32.MOVEFILE_WRITE_THROUGH | win32.MOVEFILE_COPY_ALLOWED;
    if force {
        flags |= win32.MOVEFILE_REPLACE_EXISTING;
    }
    src_wc := odin_to_wchar_string(src); defer free(src_wc);
    dst_wc := odin_to_wchar_string(dest); defer free(dst_wc);
    res := win32.move_file_ex_w(src_wc, dst_wc, flags);
    return bool(res);
}

copy_file :: proc(src, dest : string, force := false) -> bool {
    src_wc := odin_to_wchar_string(src); defer free(src_wc);
    dst_wc := odin_to_wchar_string(dest); defer free(dst_wc);
    res := win32.copy_file_w(src_wc, dst_wc, win32.Bool(!force));
    return bool(res);
}

delete_file :: proc(path : string) -> bool {
    wc_str := odin_to_wchar_string(path); defer free(wc_str);
    res := win32.delete_file_w(wc_str);
    return bool(res);
}

is_path_valid :: proc(str : string) -> bool {
    wc_str := odin_to_wchar_string(str); defer free(wc_str);
    attr := win32.get_file_attributes_w(wc_str);
    return i32(attr) != win32.INVALID_FILE_ATTRIBUTES;
}

is_directory :: proc(str : string) -> bool {
    wc_str := odin_to_wchar_string(str); defer free(wc_str);
    attr := win32.get_file_attributes_w(wc_str);
    result := i32(attr) != win32.INVALID_FILE_ATTRIBUTES;
    if result {
        result = (attr & win32.FILE_ATTRIBUTE_DIRECTORY) == win32.FILE_ATTRIBUTE_DIRECTORY;
    }

    return result;
}

create_directory :: proc(name : string) -> bool {
    wc_str := odin_to_wchar_string(name); defer free(wc_str);
    res := win32.create_directory_w(wc_str, nil);
    return bool(res);
}

get_all_entries_in_directory :: proc(path : string) -> []DiskEntry {
    buf : [1024]byte;
    if(path[len(path)-1] != '*') {
        path = fmt.bprintf(buf[:], "%s*", path);
    }

    wc_path := odin_to_wchar_string(path); defer free(wc_path);

    find_data := win32.Find_Data_W{};
    file_handle := win32.find_first_file_w(wc_path, &find_data);

    result := make([]DiskEntry, _count_entries_from_find_handle(file_handle, &find_data));

    file_handle = win32.find_first_file_w(wc_path, &find_data);
    i := 0;
    if file_handle != win32.INVALID_HANDLE {
        if !_skip_dot_check(&find_data) {
            result[i] = _make_disk_entry_from_find_data(find_data);
            i += 1;
        }
        for win32.find_next_file_w(file_handle, &find_data) == true {
            if _skip_dot_check(&find_data) {
                continue;
            }

            result[i] = _make_disk_entry_from_find_data(find_data);
            i += 1;
        }
    }

    win32.find_close(file_handle); 

    return result;
}

_make_disk_entry_from_find_data :: proc(data : win32.Find_Data_W) -> DiskEntry {
    result := DiskEntry{};
    tmp := wchar_to_odin_string(win32.Wstring(&data.file_name[0]));
    tmp = tmp[:util.clen(tmp)];
    result.name = strings.new_string(tmp);
    result.modified = filetime_to_datetime(data.last_write_time);
    result.size = int(data.file_size_low) | int(data.file_size_high) << 32;

    is_set :: proc(v, t : u32) -> bool {
        return v & t == t;
    }

    result.dir    = is_set(data.file_attributes, win32.FILE_ATTRIBUTE_DIRECTORY);
    result.hidden = is_set(data.file_attributes, win32.FILE_ATTRIBUTE_HIDDEN); // Not being set???
    result.system = is_set(data.file_attributes, win32.FILE_ATTRIBUTE_SYSTEM); // Not being set???

    return result;
}

_count_entries_from_find_handle :: proc(handle : win32.Handle, find_data : ^win32.Find_Data_W) -> int {
    count := 0;
    if handle != win32.INVALID_HANDLE {
        if !_skip_dot_check(find_data) {
            count += 1;
        }
        for win32.find_next_file_w(handle, find_data) {
            if _skip_dot_check(find_data) {
                continue;
            }
            count += 1;
        }
    }

    return count;
}

_skip_dot_check :: proc(find_data : ^win32.Find_Data_W) -> bool {
    buf : [1024]byte;
    str := wchar_to_odin_string_from_buf(buf[:], win32.Wstring(&find_data.file_name[0]));
    return str == ".\x00" || str == "..\x00"; 
}

//NOTE(Hoej): skips . and ..
//TODO(Hoej): Full path doesn't really mean full path atm
//            It really just means prepend dir_path to the filename
//NOTE(Hoej): Only ASCII
get_all_entries_strings_in_directory :: proc(dir_path : string, full_path : bool = false) -> []string {
    path_buf : [win32.MAX_PATH]u8;

    if(dir_path[len(dir_path)-1] != '/' && dir_path[len(dir_path)-1] != '\\') {
        dir_path = fmt.bprintf(path_buf[:], "%s%r", dir_path, '\\');
    }
    fmt.bprintf(path_buf[:], "%s%r", dir_path, '*');

    find_data := win32.Find_Data_A{};
    file_handle := win32.find_first_file_a(cstring(&path_buf[0]), &find_data);

    skip_dot :: proc(c_str : []u8) -> bool {
        len := len(cstring(&c_str[0]));
        f := string(c_str[:len]);

        return f == "." || f == ".."; 
    }

    copy_file_name :: proc(c_str : cstring, path : string, full_path : bool) -> string {
        if !full_path {
            str := string(c_str);
            return strings.new_string(str);
        } else {
            pathBuf := make([]u8, win32.MAX_PATH);
            return fmt.bprintf(pathBuf[:], "%s%s", path, string(c_str));
        }
    }

    count := 0;
    //Count 
    if file_handle != win32.INVALID_HANDLE {
        if !skip_dot(find_data.file_name[:]) {
            count += 1;
        } 

        for win32.find_next_file_a(file_handle, &find_data) == true {
            if skip_dot(find_data.file_name[:]) {
                continue;
            }
            count += 1;
        }
    }

    //copy file names
    result := make([]string, count);
    i := 0;
    file_handle = win32.find_first_file_a(cstring(&path_buf[0]), &find_data);
    if file_handle != win32.INVALID_HANDLE {
        if !skip_dot(find_data.file_name[:]) {
            result[i] = copy_file_name(cstring(&find_data.file_name[0]), dir_path, full_path);
            i += 1;
        } 

        for win32.find_next_file_a(file_handle, &find_data) == true {
            if skip_dot(find_data.file_name[:]) {
                continue;
            }
            result[i] = copy_file_name(cstring(&find_data.file_name[0]), dir_path, full_path);
            i += 1;
        }
    }

    win32.find_close(file_handle); 
    return result;
}

get_file_size :: proc(path : string) -> int {
    wc_str := odin_to_wchar_string(path); defer free(wc_str);
    out : i64;
    h := win32.create_file_w(wc_str, 
                             win32.FILE_GENERIC_READ, 
                             win32.FILE_SHARE_READ | win32.FILE_SHARE_WRITE, 
                             nil, 
                             win32.OPEN_EXISTING, 
                             win32.FILE_ATTRIBUTE_NORMAL,
                             nil);
    win32.get_file_size_ex(h, &out);
    win32.close_handle(h);
    return int(out);
}