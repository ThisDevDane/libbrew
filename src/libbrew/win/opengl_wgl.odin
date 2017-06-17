/*
 *  @Name:     opengl_wgl
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    hjortshoej@handmade.network
 *  @Creation: 10-06-2017 17:25:48
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 15-06-2017 21:22:22
 *  
 *  @Description:
 *  
 */

import win32 "sys/windows.odin";
import wgl "sys/wgl.odin";

type Attrib struct {
    type_  : i32,
    value : i32,
}

type AccelerationArbValues enum i32 {
    NoAccelerationArb      = 0x2025,
    GenericAccelerationArb = 0x2026,
    FullAccelerationArb    = 0x2027,
}

type PixelTypeArbValues enum i32 {
    RgbaArb = 0x202B,
    ColorindexArb = 0x202C,
}

type ContextFlagsArbValues enum i32 {
    DebugBitArb = 0x0001,
    ForwardCompatibleBitArb = 0x0002,
}

type ContextProfileMaskArbValues enum i32 {
    CoreProfileBitArb = 0x00000001,
    CompatibilityProfileBitArb = 0x00000002,
}

proc draw_to_window_arb(value : bool) -> Attrib {
    var res : Attrib;
    res.type_ = 0x2001;
    res.value = i32(value);
    return res;
}

proc double_buffer_arb (value : bool) -> Attrib {
    var res : Attrib;
    res.type_ = 0x2011;
    res.value = i32(value);
    return res;
}

proc support_opengl_arb(value : bool) -> Attrib {
    var res : Attrib;
    res.type_ = 0x2010;
    res.value = i32(value);
    return res;
}

proc acceleration_arb  (value : AccelerationArbValues) -> Attrib {
    var res : Attrib;
    res.type_ = 0x2003;
    res.value = i32(value);
    return res;
}

proc pixel_type_arb    (value : PixelTypeArbValues) -> Attrib {
    var res : Attrib;
    res.type_ = 0x2013;
    res.value = i32(value);
    return res;
}

proc color_bits_arb(value : i32) -> Attrib {
    var res : Attrib;
    res.type_ = 0x2014;
    res.value = value;
    return res;
}

proc alpha_bits_arb(value : i32) -> Attrib {
    var res : Attrib;
    res.type_ = 0x201B;
    res.value = value;
    return res;
}

proc depth_bits_arb(value : i32) -> Attrib {
    var res : Attrib;
    res.type_ = 0x2022;
    res.value = value;
    return res;
}

proc framebuffer_srgb_capable_arb(value : bool) -> Attrib {
    var res : Attrib;
    res.type_ = 0x20A9;
    res.value = i32(value);
    return res;
}

proc context_major_version_arb(value : i32) -> Attrib {
    var res : Attrib;
    res.type_ = 0x2091;
    res.value = value;
    return res;
}

proc context_minor_version_arb(value : i32) -> Attrib {
    var res : Attrib;
    res.type_ = 0x2092;
    res.value = value;
    return res;
}

proc context_flags_arb(value : ContextFlagsArbValues) -> Attrib {
    var res : Attrib;
    res.type_ = 0x2094;
    res.value =i32(value);
    return res;
}

proc context_profile_mask_arb(value : ContextProfileMaskArbValues) -> Attrib {
    var res : Attrib;
    res.type_ = 0x9126;
    res.value = i32(value);
    return res;
}

proc prepare_attrib_array(attribList : []Attrib) -> [dynamic]i32 {
    var array :[dynamic]i32;
    for attr in attribList {
        append(array, attr.type_);
        append(array, attr.value);
    }

    append(array, 0);
    return array;
}
type CreateContextAttribsARB proc(hdc : win32.Hdc, 
                                      shareContext : wgl.Hglrc, 
                                      attribList : ^i32) -> wgl.Hglrc #cc_c;
type ChoosePixelFormatARB    proc(hdc : win32.Hdc, 
                                      piAttribIList : ^i32, 
                                      pfAttribFList : ^f32, 
                                      nMaxFormats : u32, 
                                      piFormats : ^i32, 
                                      nNumFormats : ^u32) -> win32.Bool #cc_c;
type SwapIntervalEXT         proc(interval : i32) -> bool #cc_c;
type GetExtensionsStringARB  proc(win32.Hdc) -> ^u8 #cc_c;

var create_context_attribs : CreateContextAttribsARB;
var choose_pixel_format    : ChoosePixelFormatARB;
var swap_interval          : SwapIntervalEXT;
var get_extensions_string  : GetExtensionsStringARB;