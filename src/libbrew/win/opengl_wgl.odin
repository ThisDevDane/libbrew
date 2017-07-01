/*
 *  @Name:     opengl_wgl
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    hjortshoej@handmade.network
 *  @Creation: 10-06-2017 17:25:48
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 02-07-2017 01:07:25
 *  
 *  @Description:
 *  
 */

import win32 "sys/windows.odin";
import wgl "sys/wgl.odin";

Attrib :: struct {
    type_  : i32,
    value : i32,
}

AccelerationArbValues :: enum i32 {
    NoAccelerationArb      = 0x2025,
    GenericAccelerationArb = 0x2026,
    FullAccelerationArb    = 0x2027,
}

PixelTypeArbValues :: enum i32 {
    RgbaArb = 0x202B,
    ColorindexArb = 0x202C,
}

ContextFlagsArbValues :: enum i32 {
    DebugBitArb = 0x0001,
    ForwardCompatibleBitArb = 0x0002,
}

ContextProfileMaskArbValues :: enum i32 {
    CoreProfileBitArb = 0x00000001,
    CompatibilityProfileBitArb = 0x00000002,
}

draw_to_window_arb :: proc(value : bool) -> Attrib {
    res : Attrib;
    res.type_ = 0x2001;
    res.value = i32(value);
    return res;
}

double_buffer_arb :: proc (value : bool) -> Attrib {
    res : Attrib;
    res.type_ = 0x2011;
    res.value = i32(value);
    return res;
}

support_opengl_arb :: proc(value : bool) -> Attrib {
    res : Attrib;
    res.type_ = 0x2010;
    res.value = i32(value);
    return res;
}

acceleration_arb :: proc  (value : AccelerationArbValues) -> Attrib {
    res : Attrib;
    res.type_ = 0x2003;
    res.value = i32(value);
    return res;
}

pixel_type_arb :: proc    (value : PixelTypeArbValues) -> Attrib {
    res : Attrib;
    res.type_ = 0x2013;
    res.value = i32(value);
    return res;
}

color_bits_arb :: proc(value : i32) -> Attrib {
    res : Attrib;
    res.type_ = 0x2014;
    res.value = value;
    return res;
}

alpha_bits_arb :: proc(value : i32) -> Attrib {
    res : Attrib;
    res.type_ = 0x201B;
    res.value = value;
    return res;
}

depth_bits_arb :: proc(value : i32) -> Attrib {
    res : Attrib;
    res.type_ = 0x2022;
    res.value = value;
    return res;
}

framebuffer_srgb_capable_arb :: proc(value : bool) -> Attrib {
    res : Attrib;
    res.type_ = 0x20A9;
    res.value = i32(value);
    return res;
}

context_major_version_arb :: proc(value : i32) -> Attrib {
    res : Attrib;
    res.type_ = 0x2091;
    res.value = value;
    return res;
}

context_minor_version_arb :: proc(value : i32) -> Attrib {
    res : Attrib;
    res.type_ = 0x2092;
    res.value = value;
    return res;
}

context_flags_arb :: proc(value : ContextFlagsArbValues) -> Attrib {
    res : Attrib;
    res.type_ = 0x2094;
    res.value =i32(value);
    return res;
}

context_profile_mask_arb :: proc(value : ContextProfileMaskArbValues) -> Attrib {
    res : Attrib;
    res.type_ = 0x9126;
    res.value = i32(value);
    return res;
}

prepare_attrib_array :: proc(attribList : []Attrib) -> [dynamic]i32 {
    array :[dynamic]i32;
    for attr in attribList {
        append(array, attr.type_);
        append(array, attr.value);
    }

    append(array, 0);
    return array;
}
CreateContextAttribsARB : proc(hdc : win32.Hdc, 
                                      shareContext : wgl.Hglrc, 
                                      attribList : ^i32) -> wgl.Hglrc #cc_c;
ChoosePixelFormatARB    : proc(hdc : win32.Hdc, 
                                      piAttribIList : ^i32, 
                                      pfAttribFList : ^f32, 
                                      nMaxFormats : u32, 
                                      piFormats : ^i32, 
                                      nNumFormats : ^u32) -> win32.Bool #cc_c;
SwapIntervalEXT         : proc(interval : i32) -> bool #cc_c;
GetExtensionsStringARB  : proc(win32.Hdc) -> ^u8 #cc_c;

create_context_attribs : CreateContextAttribsARB;
choose_pixel_format    : ChoosePixelFormatARB;
swap_interval          : SwapIntervalEXT;
get_extensions_string  : GetExtensionsStringARB;