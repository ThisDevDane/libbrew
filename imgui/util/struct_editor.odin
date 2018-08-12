/*
 *  @Name:     struct_editor
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    fyoucon@gmail.com
 *  @Creation: 26-07-2018 23:43:52 UTC+1
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 05-08-2018 21:16:19 UTC+1
 *  
 *  @Description:
 *  
 */

package brew_imgui_util

import "core:runtime";
import "core:fmt";
import "core:mem";
import "core:strings";

import "shared:odin-imgui";
import "shared:libbrew/util";

_internal_string_buffer := [4096]byte{};

_get_name :: proc(data : any) -> string {
    info := type_info_of(data.typeid);
    switch ti in info.variant {
        case runtime.Type_Info_Named : return ti.name;
        case                         : return "<non-named>";
    }
}

_print_tooltip :: proc(data : any) {
    imgui.begin_tooltip();
    imgui.text("Type: %v", type_info_of(data.typeid));
    imgui.text("Ptr: %p", data.data);
    imgui.text("Size: %d bytes", type_info_of(data.typeid).size);
    imgui.end_tooltip();
}

edit_value :: proc(data : any) {
    imgui.push_id(data.data); defer imgui.pop_id();
    ti := runtime.type_info_base(type_info_of(data.typeid));

    switch t in ti.variant {
        case runtime.Type_Info_Boolean : {
            ptr := cast(^bool)data.data;
            imgui.checkbox("##checkbox", ptr);
        }

        //TODO(Hoej): Actually be able to live change array members, maybe even delete and add.
        case runtime.Type_Info_Array : {
            str := fmt.aprintf("Count = %d of %v", t.count, t.elem); defer delete(str);
            if imgui.collapsing_header(str) {
                imgui.begin_child("##child", imgui.Vec2{0, 200}); defer imgui.end_child();
                for i in 0..t.count-1 {
                    ptr := uintptr(data.data) + uintptr(i*t.elem_size);
                    imgui.text("%#v", any{rawptr(ptr), t.elem.id});
                }
            }
        }

        case runtime.Type_Info_Slice : {
            slice := cast(^mem.Raw_Slice)data.data;
            str := fmt.aprintf("Count = %d of %v", slice.len, t.elem); defer delete(str);
            if imgui.collapsing_header(str) {
                imgui.begin_child("##child", imgui.Vec2{0, 200}); defer imgui.end_child();
                for i in 0..slice.len-1 {
                    ptr := uintptr(slice.data) + uintptr(i*t.elem_size);
                    imgui.text("%#v", any{rawptr(ptr), t.elem.id});
                }
            }
        }

        case runtime.Type_Info_Integer : {
            size := ti.size;
            signed := t.signed;
            v : i32;
            disable := false;
            if !signed {
                imgui.text("%v, Unsupported; %v", data, ti);
                return;
            }
            switch size {
                case 1  : {
                    d := data.(i8);
                    v = i32(d);
                }
                
                case 2 : {
                    d := data.(i16);
                    v = i32(d);
                }
                
                case 4 : {
                    d := data.(i32);
                    v = i32(d);
                }
                
                case 8 :
                    d := cast(^i64)data.data;
                    v = i32(d^);
                case : {
                    disable = true;
                }
            }
                
            if disable do imgui.text("Unsupported; %v", ti);
            else {
                if imgui.input_int("##int", &v) {
                    switch size {
                        case 1  : {
                            ptr := cast(^i8)data.data;
                            ptr^ = i8(v);
                        }

                        case 2  : {
                            ptr := cast(^i16)data.data;
                            ptr^ = i16(v);
                        }

                        case 4  : {
                            ptr := cast(^i32)data.data;
                            ptr^ = i32(v);
                        }

                        case 8 :
                            ptr := cast(^i64)data.data;
                            ptr^ = i64(v);
                    }
                }
            }
        }
        
        case runtime.Type_Info_Float : {
            switch ti.size {
                case 4 : {
                    ptr := cast(^f32)data.data;
                    imgui.input_float("##float", ptr);
                }

                case 8 : {
                    v_ptr := cast(^f64)data.data;
                    v := f32(v_ptr^);
                    if imgui.input_float("##float", &v) {
                        v_ptr^ = f64(v);
                    }
                }
                
                case : {
                    imgui.text("Unsupported; %v", ti);
                }
            }
        }
        
        case runtime.Type_Info_String : {
            buf := _internal_string_buffer;
            defer mem.zero(&buf[0], len(buf));
            
            fmt.bprint(buf[:], data.(string));

            if imgui.input_text("##text", buf[:]) {
                buf_str := string(buf[:brew_util.clen(string(buf[:]))]);
                ptr := cast(^string)data.data;
                ptr^ = strings.new_string(buf_str);
            }
        }

        /*case runtime.Type_Info_Struct : {
            print_struct(data);
        }*/

        case : {
            imgui.text("%#v", data);
        }
    }
    //case runtime.Type_Info_Rune:       fmt_arg(fi, v, verb);
    //case runtime.Type_Info_Float:      fmt_arg(fi, v, verb);
    //case runtime.Type_Info_Complex:    fmt_arg(fi, v, verb);
}

print_struct :: proc(data : any) {
    _ti := runtime.type_info_base(type_info_of(data.typeid));
    ti, _ := _ti.variant.(runtime.Type_Info_Struct);

    imgui.text("Struct Name: %s", _get_name(data));
    if imgui.is_item_hovered() {
        _print_tooltip(data);
    }
    imgui.columns(2);

    for name, idx in ti.names {
        a := any{rawptr(uintptr(data.data) +ti.offsets[idx]), 
                 ti.types[idx].id};
        imgui.text("%v", name);
            if imgui.is_item_hovered() {
            _print_tooltip(a);
        }
        imgui.next_column();
        edit_value(a);
        imgui.next_column();
    }
}

struct_editor :: proc(data : any, read_only : bool) {
    _ti := runtime.type_info_base(type_info_of(data.typeid));
    ti, is_struct := _ti.variant.(runtime.Type_Info_Struct);
    str := fmt.aprintf("Struct Editor: %s", _get_name(data));
    imgui.begin(str);
    if !is_struct {
        imgui.text("You did not pass a struct to the editor...");
    } else {
        print_struct(data);
    }
    imgui.columns(1);
    if imgui.collapsing_header("Fmt print") {
        imgui.text("%#v", data);
    }
    imgui.separator();
    imgui.end();
}