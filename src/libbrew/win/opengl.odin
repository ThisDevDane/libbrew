/*
 *  @Name:     opengl
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    hjortshoej@handmade.network
 *  @Creation: 10-06-2017 16:57:06
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 02-07-2017 01:06:30
 *  
 *  @Description:
 *  
 */

import "fmt.odin";
import "strings.odin";
import "sys/wgl.odin";
import win32 "sys/windows.odin";

import "window.odin";

import_load "opengl_wgl.odin";

GlContext :: wgl.Hglrc;

_string_data :: proc(s: string) -> ^u8 #inline { return &s[0]; }

gl_get_proc_address :: proc(name : string) -> proc() #cc_c {
    buf : [256]u8;
    c_str := fmt.bprintf(buf[..], "%s\x00", name);
    return wgl.get_proc_address(&c_str[0]);
}

create_gl_context :: proc(wnd_handle : window.WndHandle, major, minor : int) -> GlContext {
    extensions : map[string]rawptr;
    extensions["wglChoosePixelFormatARB"]    = &choose_pixel_format;
    extensions["wglCreateContextAttribsARB"] = &create_context_attribs;
    extensions["wglGetExtensionsStringARB"]  = &get_extensions_string;
    extensions["wglSwapIntervalEXT"]         = &swap_interval;

    attribs : [dynamic]Attrib;
    append(attribs, draw_to_window_arb(true),
                    acceleration_arb(AccelerationArbValues.FullAccelerationArb),
                    support_opengl_arb(true),
                    double_buffer_arb(false),
                    pixel_type_arb(PixelTypeArbValues.RgbaArb),
                    color_bits_arb(24),
                    alpha_bits_arb(8),
                    depth_bits_arb(24),
                    framebuffer_srgb_capable_arb(true));

    return create_gl_context(wnd_handle, major, minor, extensions, attribs[..], true, true);
}

//TODO Clean this up and understand it better
create_gl_context :: proc(handle : window.WndHandle, 
                         major, minor : int, 
                         requested_extensions : map[string]rawptr,
                         attribs : []Attrib,
                         core, debug : bool) -> GlContext {

    wndHandle := win32.create_window_ex_a(0, 
                       _string_data("STATIC\x00"), 
                       _string_data("Opengl Loader\x00"), 
                       win32.WS_OVERLAPPED, 
                       win32.CW_USEDEFAULT, win32.CW_USEDEFAULT, win32.CW_USEDEFAULT, win32.CW_USEDEFAULT,
                       nil, nil, nil, nil);
    
    if wndHandle == nil {
        panic("Could not create opengl loader window");
    }

    legacy_context := _create_legacy_context(window.WndHandle(handle));
    dc := win32.get_dc(win32.Hwnd(wndHandle));
    {
        set_proc_address :: proc(p: rawptr, name : string) #inline { 
            res := gl_get_proc_address(name);
            assert(res != nil);
            p = rawptr(res);
        }

        for val, key in requested_extensions {
            set_proc_address(val, key);
        }
    }
    wgl.make_current(nil, nil);
    wgl.delete_context(legacy_context);
    win32.release_dc(win32.Hwnd(wndHandle), dc);
    win32.destroy_window(wndHandle);

    dc = win32.get_dc(win32.Hwnd(handle));

    format : i32;
    formats : u32;
    attrib_array := prepare_attrib_array(attribs[..]); defer free(attrib_array);

    success := choose_pixel_format(dc, &attrib_array[0], nil, 1, &format, &formats);
    if (success == win32.TRUE) && (formats == 0) {
        panic("Couldn't find suitable pixel format");
    }

    pfd : win32.PixelFormatDescriptor;
    pfd.version = 1;
    pfd.size = size_of(win32.PixelFormatDescriptor);
    win32.describe_pixel_format(dc, format, size_of(win32.PixelFormatDescriptor), &pfd);
    win32.set_pixel_format(dc, format, &pfd);

    create_attribs : [dynamic]Attrib;
    append(create_attribs, context_major_version_arb(i32(major)),
                           context_minor_version_arb(i32(minor)));

    if core {
        append(create_attribs, context_profile_mask_arb(ContextProfileMaskArbValues.CoreProfileBitArb));
    } else {
        append(create_attribs, context_profile_mask_arb(ContextProfileMaskArbValues.CompatibilityProfileBitArb));
    }
    if debug {
        append(create_attribs, context_flags_arb(ContextFlagsArbValues.DebugBitArb));
    }

    create_attrib_array := prepare_attrib_array(create_attribs[..]);

    ctx := create_context_attribs(dc, nil, &create_attrib_array[0]);
    assert(ctx != nil);
    wgl.make_current(dc, ctx);
    win32.release_dc(win32.Hwnd(handle), dc);
    return GlContext(ctx);
}


_create_legacy_context :: proc(handle : window.WndHandle) -> wgl.Hglrc {
    dc := win32.get_dc(win32.Hwnd(handle));

    pfd := win32.PixelFormatDescriptor{};
    pfd.size = size_of(win32.PixelFormatDescriptor);
    pfd.version = 1;
    pfd.flags = win32.PFD_DRAW_TO_WINDOW | win32.PFD_SUPPORT_OPENGL | win32.PFD_DOUBLEBUFFER;
    pfd.color_bits = 32;
    pfd.alpha_bits = 8;
    pfd.depth_bits = 24;
    format := win32.choose_pixel_format(dc, &pfd);

    win32.describe_pixel_format(dc, format, size_of(win32.PixelFormatDescriptor), &pfd);

    win32.set_pixel_format(dc, format, &pfd);

    ctx := wgl.create_context(dc);

    assert(ctx != nil);
    wgl.make_current(dc, ctx);
    win32.release_dc(win32.Hwnd(handle), dc);

    return ctx;
}