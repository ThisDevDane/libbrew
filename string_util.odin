/*
 *  @Name:     string_util
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    hoej@northwolfprod.com
 *  @Creation: 28-10-2017 17:21:23
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 29-11-2017 00:22:56
 *  
 *  @Description:
 *  
 */

import "core:fmt.odin";
import "core:strings.odin";

get_last_extension :: proc(str : string) -> string {
    last_dot := -1;
    for r, i in str {
        if r == '.' {
            last_dot = i;
        }
    }

    if last_dot != -1 {
        return str[last_dot..];
    } else {
        return "";
    }
}

remove_last_extension :: proc(str : string) -> string {
    last_dot := -1;
    for r, i in str {
        if r == '.' {
            last_dot = i;
        }
    }
    
    if last_dot != -1 {
        return str[..last_dot];
    } else {
        return str;
    }
}

//TODO(Hoej): Doens't work
get_all_extensions :: proc(str : string) -> []string {
    dot_count := 0;
    extension_str : string;
    extension_str_wod : string;
    for r, i in str {
        if r == '.' {
            if dot_count == 0 {
                extension_str = str[i..];
            }
            dot_count += 1;
        }
    }

    exts := make([]string, dot_count);
    s := 0;
    for r, i in extension_str {
        if r == '.' {
            for c, j in extension_str[i+1..] {
                if c == '.' || j == len(extension_str[i+1..])-1{
                    fmt.println(extension_str[i...i+j], i, j);
                    exts[s] = extension_str[i...i+j];
                    s += 1;
                }
            }
        }
    }

    return exts;
}

remove_all_extensions :: proc(str : string) -> string {
    for r, i in str {
        if r == '.' {
            return str[..i];
        }
    }

    return str;
}

remove_path_from_file :: proc(str : string) -> string {
    last_slash := -1;
    for r, i in str {
        if r == '\\' || r == '/' {
            last_slash = i;
        }
    }
    
    if last_slash != -1 {
        return str[last_slash+1..];
    } else {
        return str;
    }
}

null_terminate_odin_string :: proc(str : string) -> string {
    return strings.new_string(str);
}

get_c_string_length :: proc(c_str : ^u8) -> int {
    if c_str == nil {
        return 0;
    }

    len := 0;
    for (c_str+len)^ != 0 {
        len += 1;
    }

    return len;
}

get_line_and_remainder :: proc(str : string) -> (string, string) {
    for r, i in str {
        if r == '\n' {
            return str[...i], str[i+1...];
        }
    }

    return str, "";
}

get_line_count :: proc(str : string) -> int {
    i := 1;
    for r in str {
        if r == '\n' {
            i += 1;
        }
    }

    return i;
}

split_first :: proc(str : string, r : rune) -> (string, string) {
    for r_, i in str {
        if r_ == r {
            return str[..i], str[i+1..];
        }
    }

    return str, "";
} 