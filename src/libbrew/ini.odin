/*
 *  @Name:     ini
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    hjortshoej@handmade.network
 *  @Creation: 10-07-2017 01:14:14
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 10-07-2017 01:53:50
 *  
 *  @Description:
 *      Simple parsing for Ini files
 */

import (
    "fmt.odin";
    "utf8.odin";
    "libbrew.odin";
)

IniValue :: union {
    Name : string,
    String{
        Value : string,
    },
    Float{
        Value : f64,
    },
    Integer{
        Value : int,
    }
}

IniHeader :: struct {
    Keys : map[string]IniValue,
}

parse :: proc(text_ : string) -> map[string]IniHeader {
    text := []u8(text_);
    last : int = 0;
    byte_count : int = 4;
    r : rune;
    for {
        r, byte_count = utf8.decode_rune(text[last..last+byte_count]);
        last += byte_count;
        fmt.println(len(text), ":", last, r);
        libbrew.sleep(3);
        if last >= len(text) {
            break;
        }
    }


    return nil;
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