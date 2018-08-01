/*
 *  @Name:     struct_editor
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    fyoucon@gmail.com
 *  @Creation: 26-07-2018 23:43:52 UTC+1
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 01-08-2018 23:23:05 UTC+1
 *  
 *  @Description:
 *  
 */

package brew_imgui_util

import "core:runtime";
import "core:fmt";
import "core:mem";

import "shared:odin-imgui";

_get_name :: proc(data : any) -> string {
    info := type_info_of(data.typeid);
    switch ti in info.variant {
        case runtime.Type_Info_Named : return ti.name;
        case                         : return "WEE";
    }
}

print_value :: proc(data : any) {
    imgui.text("%s", _get_name(data));
    if imgui.is_item_hovered() {
        imgui.begin_tooltip();
        imgui.text("Type: %v", type_info_of(data.typeid));
        imgui.text("Ptr: %p", data.data);
        imgui.text("Size: %d bytes", type_info_of(data.typeid).size);
        imgui.end_tooltip();
    }
    imgui.next_column();
    imgui.text("%v", data);
    imgui.next_column();
}

struct_editor :: proc(data : any, read_only : bool) {
    _ti := runtime.type_info_base(type_info_of(data.typeid));
    ti, is_struct := _ti.variant.(runtime.Type_Info_Struct);

    imgui.begin("Struct Editor");
    if !is_struct {
        imgui.text("You did not pass a struct to the editor...");
    } else {
        imgui.columns(2);
        for i in 0..len(ti.names)-1 {
            if read_only {
                print_value(data);
            } else {
                //edit_value(&f);
            }
        }
    }
    imgui.end();
}