/*
 *  @Name:     ini
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    hjortshoej@handmade.network
 *  @Creation: 10-07-2017 01:14:14
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 22-09-2017 22:02:10
 *  
 *  @Description:
 *      Simple parsing for Ini files.
 *      Headers and key names can only be ASCII, value strings can have utf8 characters.
 */


import "core:fmt.odin";
import "core:utf8.odin";
import "libbrew.odin";


IniValue :: union {string, f64, int}

IniHeader :: struct {
    Keys : map[string]IniValue,
}

parse :: proc(str_ : string) -> (map[string]IniHeader, bool) {
    str, _ := _skip_leading_whitespace(str_);
    idx := 0;
    result : map[string]IniHeader;

    inHeader := false; 
    current_header : string;
    for idx < len(cast([]u8)str) {
        r, len := utf8.decode_rune(str[idx..]);
        if _is_newline(r) {
            idx += len;
            fmt.println("\\n");
            continue;
        }

        if r == '[' {
            //fmt.println(str[idx..]);
            header_name, offset := _consume_header(str[idx+1..]);
            idx += offset;
            fmt.printf("Header name = %s", header_name);
            inHeader = true;
            result[header_name] = IniHeader{};
            current_header = header_name;
            continue;
        }

        if _is_whitespace(r) {
            _, offset := _skip_leading_whitespace(str[idx..]);
            idx += offset;
            continue;
        }

        if !inHeader {
            return nil, false;
        }

        key, offset := _consume_key(str[idx..]);
        fmt.printf("Key = (%s)", key);
        idx += offset; 
        libbrew.sleep(3);
    }   
   
    fmt.println("DONE PARSING");
    return nil, true;
}

_consume_key :: proc(str : string) -> (string, int) {
    pos := 0;
    for pos < len(str) {
        r, len := utf8.decode_rune(str[pos..]);
        if r == '\n' {
            break;
        }
        pos += len;
        libbrew.sleep(3);
    }

    return str[..pos], pos;
}

_consume_header :: proc(str : string) -> (string, int) {
    pos := 0;
    for pos < len(str) {
        r, len := utf8.decode_rune(str[pos..]);
        if r == ']' {
            break;
        }
        pos += len;
        libbrew.sleep(3);
    }

    return str[..pos], pos;
}

_skip_leading_whitespace :: proc(str : string) -> (string, int)  {
    pos := 0;
    for pos < len(str) {
        r, len := utf8.decode_rune(str[pos..]);
        if !_is_whitespace(r) {
            break;
        }
        pos += len;
        libbrew.sleep(3);
    }

    return str[pos..], pos;
}

_is_whitespace :: proc(r : rune) -> bool {
    match r {
        case '\n' : {
            return true;
        }
        case '\r' : {
            return true;
        }
        case ' '  : {
            return true;
        }
        case '\t' : {
            return true;
        }
    }

    return false;
}

_is_newline :: proc(str : rune) -> bool {
    return str == '\r' || str == '\n';
}