/*
 *  @Name:     opengl_wgl_windows
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    hjortshoej@handmade.network
 *  @Creation: 10-06-2017 17:25:48
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 05-08-2018 20:05:31 UTC+1
 *  
 *  @Description:
 *  
 */

package brew_sys;

import "core:sys/win32";

Attrib :: struct {
    type_  : i32,
    value : i32,
}

AccelerationArbValues :: enum i32 {
    NoAccelerationArb          = 0x2025,
    GenericAccelerationArb     = 0x2026,
    FullAccelerationArb        = 0x2027,
}

PixelTypeArbValues :: enum i32 {
    RgbaArb                    = 0x202B,
    ColorindexArb              = 0x202C,
}

ContextFlagsArbValues :: enum i32 {
    DebugBitArb                = 0x00000001,
    ForwardCompatibleBitArb    = 0x00000002,
}

ContextProfileMaskArbValues :: enum i32 {
    CoreProfileBitArb          = 0x00000001,
    CompatibilityProfileBitArb = 0x00000002,
}

draw_to_window_arb :: proc(value : bool) -> Attrib {
    res : Attrib;
    res.type_= 0x2001; //WGL_DRAW_TO_WINDOW_ARB
    res.value = i32(value);
    return res;
}

double_buffer_arb :: proc (value : bool) -> Attrib {
    res : Attrib;
    res.type_ = 0x2011; //WGL_DOUBLE_BUFFER_ARB
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

prepare_attrib_array :: proc(attribList : []Attrib, location := #caller_location) -> [dynamic]i32 {
    array :[dynamic]i32;
    for attr in attribList {
        append(array = &array, args = []i32{attr.type_}, loc = location);
        append(array = &array, args = []i32{attr.value}, loc = location);
    }

    append(array = &array, args = []i32{0}, loc = location);
    return array;
}
CreateContextAttribsARB :: proc "cdecl"(hdc : win32.Hdc, 
                                      shareContext : win32.Hglrc, 
                                      attribList : ^i32) -> win32.Hglrc;
ChoosePixelFormatARB    :: proc "cdecl"(hdc : win32.Hdc, 
                                      piAttribIList : ^i32, 
                                      pfAttribFList : ^f32, 
                                      nMaxFormats : u32, 
                                      piFormats : ^i32, 
                                      nNumFormats : ^u32) -> win32.Bool;
SwapIntervalEXT         :: proc "cdecl"(interval : i32) -> bool;
GetExtensionsStringARB  :: proc "cdecl"(win32.Hdc) -> ^u8;

create_context_attribs : CreateContextAttribsARB;
choose_pixel_format    : ChoosePixelFormatARB;
swap_interval          : SwapIntervalEXT;
get_extensions_string  : GetExtensionsStringARB;