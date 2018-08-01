/*
 *  @Name:     opengl_windows
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    hjortshoej@handmade.network
 *  @Creation: 10-06-2017 16:57:06
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 01-08-2018 23:11:30 UTC+1
 *  
 *  @Description:
 *  
 */

package brew_sys;

import "core:fmt";
import "core:strings";
import "core:sys/win32";

Gl_Context :: win32.Hglrc;

_string_data :: inline proc(s: string) -> ^u8 { return &s[0]; }

wgl_get_proc_address :: proc "cdecl"(name : string) -> proc "cdecl"() {
    buf : [256]u8;
    c_str := fmt.bprintf(buf[:], "%s\x00", name);
    return cast(proc "cdecl"())win32.get_gl_proc_address(cstring(&c_str[0]));
}

create_gl_context :: proc[create_gl_context_min, create_gl_context_ext];

create_gl_context_min :: proc(wnd_handle : WndHandle, major, minor : int) -> Gl_Context {
    extensions : map[string]rawptr;
    extensions["wglChoosePixelFormatARB"]    = &choose_pixel_format;
    extensions["wglCreateContextAttribsARB"] = &create_context_attribs;
    extensions["wglGetExtensionsStringARB"]  = &get_extensions_string;
    extensions["wglSwapIntervalEXT"]         = &swap_interval;

    attribs : [dynamic]Attrib;
    append(&attribs, draw_to_window_arb(true),
                     acceleration_arb(AccelerationArbValues.FullAccelerationArb),
                     support_opengl_arb(true),
                     double_buffer_arb(false),
                     pixel_type_arb(PixelTypeArbValues.RgbaArb),
                     color_bits_arb(24),
                     alpha_bits_arb(8),
                     depth_bits_arb(24),
                     framebuffer_srgb_capable_arb(true));

    ctx := create_gl_context(wnd_handle, major, minor, extensions, attribs[:], false, true);
    delete(attribs);
    return ctx;
}

//TODO Clean this up and understand it better
create_gl_context_ext :: proc(handle : WndHandle, 
                          major, minor : int, 
                          requested_extensions : map[string]rawptr,
                          attribs : []Attrib,
                          core, debug : bool) -> Gl_Context {
    wndHandle := win32.create_window_ex_a(0, 
                       cast(cstring)_string_data("STATIC\x00"), 
                       cast(cstring)_string_data("Opengl Loader\x00"), 
                       win32.WS_OVERLAPPED, 
                       win32.CW_USEDEFAULT, win32.CW_USEDEFAULT, win32.CW_USEDEFAULT, win32.CW_USEDEFAULT,
                       nil, nil, nil, nil);
    
    if wndHandle == nil {
        panic("Could not create opengl loader window");
    }

    legacy_context := _create_legacy_context(WndHandle(handle));
    dc := win32.get_dc(win32.Hwnd(wndHandle));
    {
        set_proc_address :: inline proc(p: rawptr, name : string) { 
            res := wgl_get_proc_address(name);
            assert(res != nil);
            (^rawptr)(p)^ = rawptr(res);
        }

        for key, val in requested_extensions {
            set_proc_address(val, key);
        }
    }
    win32.make_current(nil, nil);
    win32.delete_context(legacy_context);
    win32.release_dc(win32.Hwnd(wndHandle), dc);
    win32.destroy_window(wndHandle);

    dc = win32.get_dc(win32.Hwnd(handle));

    format : i32;
    formats : u32;
    attrib_array := prepare_attrib_array(attribs[:]); defer delete(attrib_array);
    success := choose_pixel_format(dc, &attrib_array[0], nil, 1, &format, &formats);

    if (success == true) && (formats == 0) {
        panic("Couldn't find suitable pixel format");
    }

    pfd : win32.Pixel_Format_Descriptor;
    pfd.version = 1;
    pfd.size = size_of(win32.Pixel_Format_Descriptor);

    win32.describe_pixel_format(dc, format, size_of(win32.Pixel_Format_Descriptor), &pfd);

    win32.set_pixel_format(dc, format, &pfd);

    create_attribs : [dynamic]Attrib; defer delete(create_attribs);
    append(&create_attribs, context_major_version_arb(i32(major)),
                            context_minor_version_arb(i32(minor)));

    if core {
        append(&create_attribs, context_profile_mask_arb(ContextProfileMaskArbValues.CoreProfileBitArb));
    } else {
        append(&create_attribs, context_profile_mask_arb(ContextProfileMaskArbValues.CompatibilityProfileBitArb));
    }
    
    if debug {
        append(&create_attribs, context_flags_arb(ContextFlagsArbValues.DebugBitArb));
    }

    create_attrib_array := prepare_attrib_array(create_attribs[:]); defer delete(create_attrib_array);

    ctx := create_context_attribs(dc, nil, &create_attrib_array[0]);
    assert(ctx != nil);
    win32.make_current(dc, ctx);
    win32.release_dc(win32.Hwnd(handle), dc);
    return Gl_Context(ctx);
}


_create_legacy_context :: proc(handle : WndHandle) -> win32.Hglrc {
    dc := win32.get_dc(win32.Hwnd(handle));

    pfd := win32.Pixel_Format_Descriptor{};
    pfd.size = size_of(win32.Pixel_Format_Descriptor);
    pfd.version = 1;
    pfd.flags = win32.PFD_DRAW_TO_WINDOW | win32.PFD_SUPPORT_OPENGL | win32.PFD_DOUBLEBUFFER;
    pfd.color_bits = 32;
    pfd.alpha_bits = 8;
    pfd.depth_bits = 24;
    format := win32.choose_pixel_format(dc, &pfd);

    win32.describe_pixel_format(dc, format, size_of(win32.Pixel_Format_Descriptor), &pfd);

    win32.set_pixel_format(dc, format, &pfd);

    ctx := win32.create_context(dc);

    assert(ctx != nil);
    win32.make_current(dc, ctx);
    win32.release_dc(win32.Hwnd(handle), dc);

    return ctx;
}