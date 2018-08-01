/*
 *  @Name:     string_util
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    hoej@northwolfprod.com
 *  @Creation: 28-10-2017 17:21:23
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 01-08-2018 23:20:18 UTC+1
 *  
 *  @Description:
 *  
 */

package brew_util;

import "core:unicode/utf8";
import "core:fmt";
import "core:mem";
import "core:strings";

replace :: proc(str: string, old, new: rune) -> string {
    new_str := make([]byte, 4*len(str));
    i := 0;
    for r in str {
        c := r;
        if c == old {
            c = new;
        }
        buf, n := utf8.encode_rune(c);
        copy(new_str[i:], buf[:n]);
        i += n;
    }
    return string(new_str[:i]);
}

get_last_extension :: proc(str : string) -> string {
    last_dot := -1;
    for r, i in str {
        if r == '.' {
            last_dot = i;
        }
    }

    if last_dot != -1 {
        return str[last_dot:];
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
        return str[:last_dot];
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
                extension_str = str[i:];
            }
            dot_count += 1;
        }
    }

    exts := make([]string, dot_count);
    s := 0;
    for r, i in extension_str {
        if r == '.' {
            for c, j in extension_str[i+1:] {
                if c == '.' || j == len(extension_str[i+1:])-1{
                    fmt.println(extension_str[i:(i+j)-1], i, j);
                    exts[s] = extension_str[i:(i+j)-1];
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
            return str[:i];
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
        return str[last_slash+1:];
    } else {
        return str;
    }
}

to_second_last_rune :: proc(str : string, test : rune) -> (string, bool) {
    before := -1;
    last := -1;
    for r, i in str {
        if r == test {
            before = last;
            last = i;
        }
    }

    return str[:before+1], before != -1;
}

remove_first_from_file :: proc(str : string, test : rune) -> string {
    for r, i in str {
        if r == test  {
            return str[i:];
        }
    }

    return str;
}

get_upto_first_from_file :: proc(str : string, test : rune) -> (string, bool) {
    for r, i in str {
        if r == test  {
            return str[:i], true;
        }
    }

    return str, false;
}

//@COPYPASTE(Hoej): from strings.new_string, in case new_string would suddenly not null-terminate
null_terminate_odin_string :: proc(s : string) -> string {
    c := make([]byte, len(s)+1);
    copy(c, cast([]byte)s);
    c[len(s)] = 0;
    return string(c[:len(s)]);
}

get_line_and_remainder :: proc(str : string) -> (string, string) {
    for r, i in str {
        if r == '\n' {
            return str[:i-1], str[i+1:];
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
            return str[:i], str[i+1:];
        }
    }

    return str, "";
} 

split_by :: proc(str : string, r : rune) -> []string {
    result : [dynamic]string;
    n := 0;
    i := 0;
    slen := len(str) - 1;
    
    for r_, idx in str {
        if r_ == r || idx == slen {
            if idx == slen {
                append(&result, str[i:idx+1]);
            } else {
                append(&result, str[i:idx]);
            }
            i = idx + 1;
            n += 1;
        }
    }

    return result[:];
}

str_from_buf :: proc(buf : []byte) -> string {
    fat_str := string(buf[:]);
    length := clen(fat_str);
    return fat_str[:length];
}

clen :: proc(str : string) -> int {
    for r, i in str {
        if r == '\x00' {
            return i;
        }
    }

    return len(str);
}