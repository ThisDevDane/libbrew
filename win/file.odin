/*
 *  @Name:     file
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    hoej@northwolfprod.com
 *  @Creation: 29-10-2017 20:14:21
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 11-12-2017 03:32:19
 *  
 *  @Description:
 *  
 */

import       "core:fmt.odin";
import       "core:strings.odin";
import win32 "core:sys/windows.odin";

import "mantle:libbrew/string_util.odin";


/*does_file_or_dir_exists :: proc(str : string) -> bool {
    str = string_util.null_terminate_odin_string(str); defer free(str); //TODO(Hoej): Do a copy into a buffer instead
    retval := win32.path_file_exists_a(&str[0]);
    return retval == win32.TRUE;
}*/

is_directory :: proc(str : string) -> bool {
    str = string_util.null_terminate_odin_string(str); defer free(str); //TODO(Hoej): Do a copy into a buffer instead
    attr := win32.get_file_attributes_a(&str[0]);
    result := i32(attr) != win32.INVALID_FILE_ATTRIBUTES;
    if result {
        result = (attr & win32.FILE_ATTRIBUTE_DIRECTORY) == win32.FILE_ATTRIBUTE_DIRECTORY;
    }

    return result;
}

//NOTE(Hoej): skips . and ..
//TODO(Hoej): Full path doesn't really mean full path atm
//            It really just means prepend dir_path to the filename
get_all_entries_in_directory :: proc(dir_path : string, full_path : bool = false) -> []string {
    path_buf : [win32.MAX_PATH]u8;

    if(dir_path[len(dir_path)-1] != '/' && dir_path[len(dir_path)-1] != '\\') {
        dir_path = fmt.bprintf(path_buf[..], "%s%r", dir_path, '\\');
    }
    fmt.bprintf(path_buf[..], "%s%r", dir_path, '*');

    find_data := win32.Find_Data{};
    file_handle := win32.find_first_file_a(&path_buf[0], &find_data);

    skip_dot :: proc(c_str : []u8) -> bool {
        len := string_util.get_c_string_length(&c_str[0]);
        f := string(c_str[..len]);

        return f == "." || f == ".."; 
    }

    copy_file_name :: proc(c_str : ^u8, path : string, full_path : bool) -> string {
        if !full_path {
            str := strings.to_odin_string(c_str);
            return strings.new_string(str);
        } else {
            pathBuf := make([]u8, win32.MAX_PATH);
            return fmt.bprintf(pathBuf[..], "%s%s", path, strings.to_odin_string(c_str));
        }
    }

    count := 0;
    //Count 
    if file_handle != win32.INVALID_HANDLE {
        if !skip_dot(find_data.file_name[..]) {
            count += 1;
        } 

        for win32.find_next_file_a(file_handle, &find_data) == win32.TRUE {
            if skip_dot(find_data.file_name[..]) {
                continue;
            }
            count += 1;
        }
    }

    //copy file names
    result := make([]string, count);
    i := 0;
    file_handle = win32.find_first_file_a(&path_buf[0], &find_data);
    if file_handle != win32.INVALID_HANDLE {
        if !skip_dot(find_data.file_name[..]) {
            result[i] = copy_file_name(&find_data.file_name[0], dir_path, full_path);
            i += 1;
        } 

        for win32.find_next_file_a(file_handle, &find_data) == win32.TRUE {
            if skip_dot(find_data.file_name[..]) {
                continue;
            }
            result[i] = copy_file_name(&find_data.file_name[0], dir_path, full_path);
            i += 1;
        }
    }

    win32.find_close(file_handle); 
    return result;
}

get_file_size :: proc(path : string) -> int {
    path_ := string_util.null_terminate_odin_string(path);
    out : i64;
    h := win32.create_file_a(&path_[0], 
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