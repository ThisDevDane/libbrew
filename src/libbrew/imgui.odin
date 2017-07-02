/*
 *  @Name:     imgui
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    hjortshoej@handmade.network
 *  @Creation: 10-05-2017 21:11:30
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 02-07-2017 16:07:52
 *  
 *  @Description:
 *      Wrapper for Dear ImGui.
 */
foreign_library "cimgui.lib";
import "fmt.odin";
import "strings.odin"; //@TODO(Hoej): remove the need for

DrawIdx   :: u16;
Wchar     :: u16;
TextureID :: rawptr;
GuiId     :: u32;
Cstring   :: ^u8; // Just for clarity

GuiTextEditCallbackData :: struct #ordered {
    event_flag      : GuiInputTextFlags,
    flags           : GuiInputTextFlags,
    user_data       : rawptr,
    read_only       : bool,
    event_char      : Wchar,
    event_key       : GuiKey,
    buf             : Cstring,
    buf_text_len    : i32,
    buf_size        : i32,
    buf_dirty       : bool,
    cursor_pos      : i32,
    selection_start : i32,
    selection_end   : i32,
}

GuiSizeConstraintCallbackData :: struct #ordered {
    user_date    : rawptr,
    pos          : Vec2,
    current_size : Vec2,
    desired_size : Vec2,
}

DrawCmd :: struct #ordered {
    elem_count         : u32,
    clip_rect          : Vec4,
    texture_id         : TextureID,
    user_callback      : draw_callback,
    user_callback_data : rawptr,
}

Vec2 :: struct #ordered {
    x : f32,
    y : f32,
}

Vec4 :: struct #ordered {
    x : f32,
    y : f32,
    z : f32,
    w : f32,
}

DrawVert :: struct #ordered {
    pos : Vec2,
    uv  : Vec2,
    col : u32,
}

DrawData :: struct #ordered {
    valid           : bool,
    cmd_lists       : ^^DrawList,
    cmd_lists_count : i32,
    total_vtx_count : i32,
    total_idx_count : i32,
}

Font ::       struct #ordered {}
GuiStorage :: struct #ordered {}
GuiContext :: struct #ordered {}
FontAtlas ::  struct #ordered {}
DrawList ::   struct #ordered {}

FontConfig :: struct #ordered {
    font_data                : rawptr,
    font_data_size           : i32,
    font_data_owned_by_atlas : bool,
    font_no                  : i32,
    size_pixels              : f32,
    over_sample_h            : i32, 
    over_sample_v            : i32,
    pixel_snap_h             : bool,
    glyph_extra_spacing      : Vec2,
    glyph_ranges             : ^Wchar,
    merge_mode               : bool,
    merge_glyph_center_v     : bool,
    name                     : [32]u8,
    dest_font                : ^Font,
};

GuiStyle :: struct #ordered {
    alpha                     : f32,
    window_padding            : Vec2,
    window_min_size           : Vec2,
    window_rounding           : f32,
    window_title_align        : GuiAlign,
    child_window_rounding     : f32,
    frame_padding             : Vec2,
    frame_rounding            : f32,
    item_spacing              : Vec2,
    item_inner_spacing        : Vec2,
    touch_extra_padding       : Vec2,
    indent_spacing            : f32,
    columns_min_spacing       : f32,
    scrollbar_size            : f32,
    scrollbar_rounding        : f32,
    grab_min_size             : f32,
    grab_rounding             : f32,
    display_window_padding    : Vec2,
    display_safe_area_padding : Vec2,
    anti_aliased_lines        : bool,
    anti_aliased_shapes       : bool,
    curve_tesselation_tol     : f32,
    colors                    : [GuiCol.COUNT]Vec4,
}

GuiIO :: struct #ordered {
    display_size                : Vec2,
    delta_time                  : f32,
    ini_saving_rate             : f32,
    ini_file_name               : Cstring,
    log_file_name               : Cstring,
    mouse_double_click_time     : f32,
    mouse_double_click_max_dist : f32,
    mouse_drag_threshold        : f32,
    key_map                     : [GuiKey.COUNT]i32,
    key_repeat_delay            : f32,
    key_repear_rate             : f32,
    user_data                   : rawptr,
    fonts                       : ^FontAtlas, 
    font_global_scale           : f32,
    font_allow_user_scaling     : bool,
    display_framebuffer_scale   : Vec2,
    display_visible_min         : Vec2,
    display_visible_max         : Vec2,
    word_movement_uses_alt_key  : bool,
    shortcuts_use_super_key     : bool,
    double_click_selects_word   : bool,
    multi_select_uses_super_key : bool,

    render_draw_list_fn         : proc(data : ^DrawData)              #cc_c,
    get_clipboard_text_fn       : proc() -> Cstring                   #cc_c,
    set_clipboard_text_fn       : proc(text : Cstring)                #cc_c,
    mem_alloc_fn                : proc(sz : u64 /*size_t*/) -> rawptr #cc_c,
    mem_free_fn                 : proc(ptr : rawptr)                  #cc_c,
    ime_set_input_screen_pos_fn : proc(x : i32, y : i32)              #cc_c,

    ime_window_handle           : rawptr,
    mouse_pos                   : Vec2,
    mouse_down                  : [5]bool,
    mouse_wheel                 : f32,
    mouse_draw_cursor           : bool,
    key_ctrl                    : bool,
    key_shift                   : bool,
    key_alt                     : bool,
    key_super                   : bool,
    keys_down                   : [512]bool,
    input_characters            : [16 + 1]Wchar,
    want_mouse_capture          : bool,
    want_keyboard_capture       : bool,
    want_text_input             : bool,
    framerate                   : f32,
    metrics_allics              : i32,
    metrics_render_vertices     : i32,
    metrics_render_indices      : i32,
    metrics_active_windows      : i32,
    mouse_pos_prev              : Vec2,
    mouse_delta                 : Vec2,
    mouse_clicked               : [5]bool,
    mouse_clicked_pos           : [5]Vec2,
    mouse_clicked_time          : [5]f32,
    mouse_double_clicked        : [5]bool,
    mouse_released              : [5]bool,
    mouse_down_onwed            : [5]bool,
    mouse_down_durations        : [5]f32,
    mouse_down_duration_prev    : [5]f32,
    mouse_drag_max_distance_Sqr : [5]f32,
    keys_down_duration          : [512]f32,
    keys_down_duration_prev     : [512]f32,
}

gui_text_edit_callback       :: proc(data : ^GuiTextEditCallbackData) -> i32 #cc_c;
gui_size_constraint_callback :: proc(data : ^GuiSizeConstraintCallbackData) #cc_c;
draw_callback                :: proc(parent_list : ^DrawList, cmd : ^DrawCmd) #cc_c;

GuiWindowFlags :: enum i32 {
    NoTitleBar                = 1 << 0,
    NoResize                  = 1 << 1,
    NoMove                    = 1 << 2,
    NoScrollbar               = 1 << 3,
    NoScrollWithMouse         = 1 << 4,
    NoCollapse                = 1 << 5,
    AlwaysAutoResize          = 1 << 6,
    ShowBorders               = 1 << 7,
    NoSavedSettings           = 1 << 8,
    NoInputs                  = 1 << 9,
    MenuBar                   = 1 << 10,
    HorizontalScrollbar       = 1 << 11,
    NoFocusOnAppearing        = 1 << 12,
    NoBringToFrontOnFocus     = 1 << 13,
    AlwaysVerticalScrollbar   = 1 << 14,
    AlwaysHorizontalScrollbar = 1 << 15,
    AlwaysUseWindowPadding    = 1 << 16
}

GuiInputTextFlags :: enum i32 {
    CharsDecimal              = 1 << 0,
    CharsHexadecimal          = 1 << 1,
    CharsUppercase            = 1 << 2,
    CharsNoBlank              = 1 << 3,
    AutoSelectAll             = 1 << 4,
    EnterReturnsTrue          = 1 << 5,
    CallbackCompletion        = 1 << 6,
    CallbackHistory           = 1 << 7,
    CallbackAlways            = 1 << 8,
    CallbackCharFilter        = 1 << 9,
    AllowTabInput             = 1 << 10,
    CtrlEnterForNewLine       = 1 << 11,
    NoHorizontalScroll        = 1 << 12,
    AlwaysInsertMode          = 1 << 13,
    ReadOnly                  = 1 << 14,
    Password                  = 1 << 15
}

GuiTreeNodeFlags :: enum i32 {
    Selected                  = 1 << 0,
    Framed                    = 1 << 1,
    AllowOverlapMode          = 1 << 2,
    NoTreePushOnOpen          = 1 << 3,
    NoAutoOpenOnLog           = 1 << 4,
    DefaultOpen               = 1 << 5,
    OpenOnDoubleClick         = 1 << 6,
    OpenOnArrow               = 1 << 7,
    Leaf                      = 1 << 8,
    Bullet                    = 1 << 9,
    CollapsingHeader          = Framed | NoAutoOpenOnLog
}

GuiSelectableFlags :: enum {
    DontClosePopups           = 1 << 0,
    SpanAllColumns            = 1 << 1,
    AllowDoubleClick          = 1 << 2
}

GuiKey :: enum i32 {
    Tab,
    LeftArrow,
    RightArrow,
    UpArrow,
    DownArrow,
    PageUp,
    PageDown,
    Home,
    End,
    Delete,
    Backspace,
    Enter,
    Escape,
    A,
    C,
    V,
    X,
    Y,
    Z,
    COUNT
}

GuiCol :: enum i32 {
    Text,
    TextDisabled,
    WindowBg,
    ChildWindowBg,
    PopupBg,
    Border,
    BorderShadow,
    FrameBg,
    FrameBgHovered,
    FrameBgActive,
    TitleBg,
    TitleBgCollapsed,
    TitleBgActive,
    MenuBarBg,
    ScrollbarBg,
    ScrollbarGrab,
    ScrollbarGrabHovered,
    ScrollbarGrabActive,
    ComboBg,
    CheckMark,
    SliderGrab,
    SliderGrabActive,
    Button,
    ButtonHovered,
    ButtonActive,
    Header,
    HeaderHovered,
    HeaderActive,
    Column,
    ColumnHovered,
    ColumnActive,
    ResizeGrip,
    ResizeGripHovered,
    ResizeGripActive,
    CloseButton,
    CloseButtonHovered,
    CloseButtonActive,
    PlotLines,
    PlotLinesHovered,
    PlotHistogram,
    PlotHistogramHovered,
    TextSelectedBg,
    ModalWindowDarkening,
    COUNT
}

GuiStyleVar :: enum i32 {
    Alpha,
    WindowPadding,
    WindowRounding,
    WindowMinSize,
    ChildWindowRounding,
    FramePadding,
    FrameRounding,
    ItemSpacing,
    ItemInnerSpacing,
    IndentSpacing,
    GrabMinSize
}

GuiAlign :: enum i32 {
    Left     = 1 << 0,
    Center   = 1 << 1,
    Right    = 1 << 2,
    Top      = 1 << 3,
    VCenter  = 1 << 4,
    Default  = Left | Top
}

GuiColorEditMode :: enum i32 {
    UserSelect           = -2,
    UserSelectShowButton = -1,
    RGB                  = 0,
    HSV                  = 1,
    HEX                  = 2
}

GuiMouseCursor :: enum i32 {
    Arrow = 0,
    TextInput,
    Move,
    ResizeNS,
    ResizeEW,
    ResizeNESW,
    ResizeNWSE,
    Count_
}

GuiSetCond :: enum i32 {
    Always        = 1 << 0,
    Once          = 1 << 1,
    FirstUseEver  = 1 << 2,
    Appearing     = 1 << 3
}

///////////////////////// Odin UTIL /////////////////////////

_LABEL_BUF_SIZE        :: 4096;
_TEXT_BUF_SIZE         :: 4096;
_DISPLAY_FMT_BUF_SIZE  :: 256;
_MISC_BUF_SIZE         :: 1024;


#thread_local _text_buf        : [_TEXT_BUF_SIZE       ]u8;
#thread_local _label_buf       : [_LABEL_BUF_SIZE      ]u8;
#thread_local _display_fmt_buf : [_DISPLAY_FMT_BUF_SIZE]u8;
#thread_local _misc_buf        : [_MISC_BUF_SIZE       ]u8;

_make_text_string :: proc       (fmt_: string, args: ..any) -> Cstring {
    s := fmt.bprintf(_text_buf[..], fmt_, ..args);
    _text_buf[len(s)] = 0;
    return &_text_buf[0];
}

_make_label_string :: proc      (label : string) -> Cstring {
    s := fmt.bprintf(_label_buf[..], "%s", label);
    _label_buf[len(s)] = 0;
    return &_label_buf[0];
}

_make_display_fmt_string :: proc(display_fmt : string) -> Cstring {
    s := fmt.bprintf(_display_fmt_buf[..], "%s", display_fmt);
    _display_fmt_buf[len(s)] = 0;
    return &_display_fmt_buf[0];
}

_make_misc_string :: proc       (misc : string) -> Cstring {
    s := fmt.bprintf(_misc_buf[..], "%s", misc);
    _misc_buf[len(s)] = 0;
    return &_misc_buf[0];
}

//////////////////////// Functions ////////////////////////
foreign cimgui {
    get_io :: proc             () -> ^GuiIO      #link_name "igGetIO" ---;
    get_style :: proc          () -> ^GuiStyle   #link_name "igGetStyle" ---;
    get_draw_data :: proc      () -> ^DrawData   #link_name "igGetDrawData" ---;
    new_frame :: proc          ()                #link_name "igNewFrame" ---;
    render :: proc             ()                #link_name "igRender" ---;
    shutdown :: proc           ()                #link_name "igShutdown" ---;
    show_user_guide :: proc    ()                #link_name "igShowUserGuide" ---;
    show_style_editor :: proc  (ref : ^GuiStyle) #link_name "igShowStyleEditor" ---;
    show_test_window :: proc   (opened : ^bool)  #link_name "igShowTestWindow" ---;
    show_metrics_window :: proc(opened : ^bool)  #link_name "igShowMetricsWindow" ---;
}


///////////// Window
begin :: proc                          (name : string, open : ^bool = nil, flags : GuiWindowFlags = 0) -> bool {
    return im_begin(_make_label_string(name), open, flags);
}
begin_child :: proc                    (str_id : string) -> bool {
    return begin_child(str_id, Vec2{0, 0}, false, GuiWindowFlags(0));
}
begin_child :: proc                    (str_id : string, size : Vec2, border : bool, extra_flags : GuiWindowFlags) -> bool {
    return im_begin_child(_make_label_string(str_id), size, border, extra_flags);
}
    
foreign cimgui {
    im_begin :: proc                       (name : Cstring, p_open : ^bool, flags : GuiWindowFlags) -> bool                     #link_name "igBegin" ---;
    im_begin_child :: proc                 (str_id : Cstring, size : Vec2, border : bool, extra_flags : GuiWindowFlags) -> bool #link_name "igBeginChild" ---;
    begin_child_ex :: proc                 (id : GuiId, size : Vec2, border : bool, extra_flags : GuiWindowFlags) -> bool       #link_name "igBeginChildEx" ---;
    end :: proc                            ()                                                                                   #link_name "igEnd" ---;
    end_child :: proc                      ()                                                                                   #link_name "igEndChild" ---;
    get_content_region_max :: proc         (out : ^Vec2)                                                                        #link_name "igGetContentRegionMax" ---;
    get_content_region_avail :: proc       (out : ^Vec2)                                                                        #link_name "igGetContentRegionAvail" ---;
    get_content_region_avail_width :: proc () -> f32                                                                            #link_name "igGetContentRegionAvailWidth" ---;
    get_window_content_region_min :: proc  (out : ^Vec2)                                                                        #link_name "igGetWindowContentRegionMin" ---;
    get_window_content_region_max :: proc  (out : ^Vec2)                                                                        #link_name "igGetWindowContentRegionMax" ---;
    get_window_content_region_width :: proc() -> f32                                                                            #link_name "igGetWindowContentRegionWidth" ---;
    get_window_draw_list :: proc           () -> ^DrawList                                                                      #link_name "igGetWindowDrawList" ---;
    get_window_pos :: proc                 (out : ^Vec2)                                                                        #link_name "igGetWindowPos" ---;
    get_window_size :: proc                (out : ^Vec2)                                                                        #link_name "igGetWindowSize" ---;
    get_window_width :: proc               () -> f32                                                                            #link_name "igGetWindowWidth" ---;
    get_window_height :: proc              () -> f32                                                                            #link_name "igGetWindowHeight" ---;
    is_window_collapsed :: proc            () -> bool                                                                           #link_name "igIsWindowCollapsed" ---;
    set_window_font_scale :: proc          (scale : f32)                                                                        #link_name "igSetWindowFontScale" ---;
}

get_window_size :: proc                () -> Vec2 {
    out : Vec2;
    get_window_size(&out);
    return out;
}
get_window_pos :: proc                 () -> Vec2 {
    out : Vec2;
    get_window_pos(&out);
    return out;
}

set_window_collapsed :: proc            (name : string, collapsed : bool, cond : GuiSetCond) {
    im_set_window_collapsed(_make_label_string(name), collapsed, cond);
}
set_window_size :: proc                 (name : string, size : Vec2, cond : GuiSetCond) {
    im_set_window_size(_make_label_string(name), size, cond);
}
set_window_focus :: proc                (name : string) {
    im_set_window_focus(_make_label_string(name));
}
set_window_pos_by_name :: proc          (name : string, pos : Vec2, cond : GuiSetCond) {
    im_set_window_pos_by_name(_make_label_string(name), pos, cond);
}
foreign cimgui {
    im_set_window_collapsed :: proc(name : Cstring, collapsed : bool, cond : GuiSetCond) #link_name "igSetWindowCollapsed2" ---;
    im_set_window_size :: proc(name : Cstring, size : Vec2, cond : GuiSetCond)           #link_name "igSetWindowSize2" ---;
    im_set_window_focus :: proc(name : Cstring)                                          #link_name "igSetWindowFocus2" ---;
    im_set_window_pos_by_name :: proc(name : Cstring, pos : Vec2, cond : GuiSetCond)     #link_name "igSetWindowPosByName" ---;
}

foreign cimgui {
    set_next_window_pos :: proc             (pos : Vec2, cond : GuiSetCond)                                                                                   #link_name "igSetNextWindowPos" ---;
    set_next_window_pos_center :: proc      (cond : GuiSetCond)                                                                                               #link_name "igSetNextWindowPosCenter" ---;
    set_next_window_size :: proc            (size : Vec2, cond : GuiSetCond)                                                                                  #link_name "igSetNextWindowSize" ---;
    set_next_window_size_constraints :: proc(size_min : Vec2, size_max : Vec2, custom_callback : gui_size_constraint_callback, custom_callback_data : rawptr) #link_name "igSetNextWindowSizeConstraints" ---;
    set_next_window_content_size :: proc    (size : Vec2)                                                                                                     #link_name "igSetNextWindowContentSize" ---;
    set_next_window_content_width :: proc   (width : f32)                                                                                                     #link_name "igSetNextWindowContentWidth" ---;
    set_next_window_collapsed :: proc       (collapsed : bool, cond : GuiSetCond)                                                                             #link_name "igSetNextWindowCollapsed" ---;
    set_next_window_focus :: proc           ()                                                                                                                #link_name "igSetNextWindowFocus" ---;
    set_window_pos :: proc                  (pos : Vec2, cond : GuiSetCond)                                                                                   #link_name "igSetWindowPos" ---;
    set_window_size :: proc                 (size : Vec2, cond : GuiSetCond)                                                                                  #link_name "igSetWindowSize" ---;
    set_window_collapsed :: proc            (collapsed : bool, cond : GuiSetCond)                                                                             #link_name "igSetWindowCollapsed" ---;
    set_window_focus :: proc                ()                                                                                                                #link_name "igSetWindowFocus" ---;

    get_scroll_x :: proc           () -> f32                           #link_name "igGetScrollX" ---;
    get_scroll_y :: proc           () -> f32                           #link_name "igGetScrollY" ---;
    get_scroll_max_x :: proc       () -> f32                           #link_name "igGetScrollMaxX" ---;
    get_scroll_max_y :: proc       () -> f32                           #link_name "igGetScrollMaxY" ---;
    set_scroll_x :: proc           (scroll_x : f32)                    #link_name "igSetScrollX" ---;
    set_scroll_y :: proc           (scroll_y : f32)                    #link_name "igSetScrollY" ---;
    set_scroll_here :: proc        (center_y_ratio : f32)              #link_name "igSetScrollHere" ---;
    set_scroll_from_pos_y :: proc  (pos_y : f32, center_y_ratio : f32) #link_name "igSetScrollFromPosY" ---;
    set_keyboard_focus_here :: proc(offset : i32)                      #link_name "igSetKeyboardFocusHere" ---;

    set_state_storage :: proc      (tree : ^GuiStorage) #link_name "igSetStateStorage" ---;
    get_state_storage :: proc      () -> ^GuiStorage    #link_name "igGetStateStorage" ---;

    // Parameters stacks (shared)
    push_font :: proc                  (font : ^Font)                         #link_name "igPushFont" ---;
    pop_font :: proc                   ()                                     #link_name "igPopFont" ---;
    push_style_color :: proc           (idx : GuiCol, col : Vec4)             #link_name "igPushStyleColor" ---;
    pop_style_color :: proc            (count : i32)                          #link_name "igPopStyleColor" ---;
    push_style_var :: proc             (idx : GuiStyleVar, val : f32)         #link_name "igPushStyleVar" ---;
    push_style_var_vec :: proc         (idx : GuiStyleVar, val : Vec2)        #link_name "igPushStyleVarVec" ---;
    pop_style_var :: proc              (count : i32)                          #link_name "igPopStyleVar" ---;
    get_font :: proc                   () -> ^Font                            #link_name "igGetFont" ---;
    get_font_size :: proc              () -> f32                              #link_name "igGetFontSize" ---;
    get_font_tex_uv_white_pixel :: proc(pOut : ^Vec2)                         #link_name "igGetFontTexUvWhitePixel" ---;
    get_color_u32 :: proc              (idx : GuiCol, alpha_mul : f32) -> u32 #link_name "igGetColorU32" ---;
    get_color_u32_vec :: proc          (col : ^Vec4) -> u32                   #link_name "igGetColorU32Vec" ---;

    // Parameters stacks (current window)
    push_item_width :: proc          (item_width : f32) #link_name "igPushItemWidth" ---;
    pop_item_width :: proc           ()                 #link_name "igPopItemWidth" ---;
    calc_item_width :: proc          () -> f32          #link_name "igCalcItemWidth" ---;
    push_text_wrap_pos :: proc       (wrap_pos_x : f32) #link_name "igPushTextWrapPos" ---;
    pop_text_wrap_pos :: proc        ()                 #link_name "igPopTextWrapPos" ---;
    push_allow_keyboard_focus :: proc(v : bool)         #link_name "igPushAllowKeyboardFocus" ---;
    pop_allow_keyboard_focus :: proc ()                 #link_name "igPopAllowKeyboardFocus" ---;
    push_button_repeat :: proc       (repeat : bool)    #link_name "igPushButtonRepeat" ---;
    pop_button_repeat :: proc        ()                 #link_name "igPopButtonRepeat" ---;

    // Layout
    separator :: proc                         ()                                      #link_name "igSeparator" ---;
    same_line :: proc                         (pos_x : f32 = 0, spacing_w : f32 = -1) #link_name "igSameLine" ---;
    new_line :: proc                          ()                                      #link_name "igNewLine" ---;
    spacing :: proc                           ()                                      #link_name "igSpacing" ---;
    dummy :: proc                             (size : ^Vec2)                          #link_name "igDummy" ---;
    indent :: proc                            (indent_w : f32 = 0.0)                  #link_name "igIndent" ---;
    unindent :: proc                          (indent_w : f32 = 0.0)                  #link_name "igUnindent" ---;
    begin_group :: proc                       ()                                      #link_name "igBeginGroup" ---;
    end_group :: proc                         ()                                      #link_name "igEndGroup" ---;
    get_cursor_pos :: proc                    (pOut : ^Vec2)                          #link_name "igGetCursorPos" ---;
    get_cursor_pos_x :: proc                  () -> f32                               #link_name "igGetCursorPosX" ---;
    get_cursor_pos_y :: proc                  () -> f32                               #link_name "igGetCursorPosY" ---;
    set_cursor_pos :: proc                    (local_pos : Vec2)                      #link_name "igSetCursorPos" ---;
    set_cursor_pos_x :: proc                  (x : f32)                               #link_name "igSetCursorPosX" ---;
    set_cursor_pos_y :: proc                  (y : f32)                               #link_name "igSetCursorPosY" ---;
    get_cursor_start_pos :: proc              (pOut : ^Vec2)                          #link_name "igGetCursorStartPos" ---;
    get_cursor_screen_pos :: proc             (pOut : ^Vec2)                          #link_name "igGetCursorScreenPos" ---;
    set_cursor_screen_pos :: proc             (pos : Vec2)                            #link_name "igSetCursorScreenPos" ---;
    align_first_text_height_to_widgets :: proc()                                      #link_name "igAlignFirstTextHeightToWidgets" ---;
    get_text_line_height :: proc              () -> f32                               #link_name "igGetTextLineHeight" ---;
    get_text_line_height_with_spacing :: proc () -> f32                               #link_name "igGetTextLineHeightWithSpacing" ---;
    get_items_line_height_with_spacing :: proc() -> f32                               #link_name "igGetItemsLineHeightWithSpacing" ---;
}
get_cursor_pos :: proc                    () -> Vec2 {
    out : Vec2;
    get_cursor_pos(&out);
    return out;
}
get_cursor_start_pos :: proc              () -> Vec2 {
    out : Vec2;
    get_cursor_start_pos(&out);
    return out;
}
get_cursor_screen_pos :: proc             () -> Vec2 {
    out : Vec2;
    get_cursor_screen_pos(&out);
    return out;
}

//Columns
columns :: proc          (count : i32, id : string = "", border : bool = true) {
    im_columns(count, _make_label_string(id), border);
}
foreign cimgui {
    im_columns :: proc(count : i32, id : Cstring, border : bool)  #link_name "igColumns" ---;
    next_column :: proc      ()                                   #link_name "igNextColumn" ---;
    get_column_index :: proc () -> i32                            #link_name "igGetColumnIndex" ---;
    get_column_offset :: proc(column_index : i32) -> f32          #link_name "igGetColumnOffset" ---;
    set_column_offset :: proc(column_index : i32, offset_x : f32) #link_name "igSetColumnOffset" ---;
    get_column_width :: proc (column_index : i32) -> f32          #link_name "igGetColumnWidth" ---;
    get_columns_count :: proc() -> i32                            #link_name "igGetColumnsCount" ---;

    // ID scopes
    // If you are creating widgets in a loop you most likely want to push a unique identifier so ImGui can differentiate them
    // You can also use "##extra" within your widget name to distinguish them from each others (see 'Programmer Guide')
    //@TODO(Hoej): Figure out what to do here
    push_id_str :: proc      (str_id : Cstring)                                #link_name "igPushIdStr" ---;
    push_id_str_range :: proc(str_begin : Cstring, str_end : Cstring)          #link_name "igPushIdStrRange" ---;
    get_id_str :: proc       (str_id : Cstring) -> GuiId                       #link_name "igGetIdStr" ---;
    get_id_str_range :: proc (str_begin : Cstring, str_end : Cstring) -> GuiId #link_name "igGetIdStrRange" ---;

    push_id_ptr :: proc      (ptr_id : rawptr)          #link_name "igPushIdPtr" ---;
    push_id_int :: proc      (int_id : i32)             #link_name "igPushIdInt" ---;
    pop_id :: proc           ()                         #link_name "igPopId" ---;
    get_id_ptr :: proc       (ptr_id : rawptr) -> GuiId #link_name "igGetIdPtr" ---;
}

/////// Text
text :: proc           (fmt_: string, args: ..any) {
    im_text(_make_text_string(fmt_, ..args));
}
text_colored :: proc   (col : Vec4, fmt_: string, args: ..any) {
    im_text_colored(col, _make_text_string(fmt_, ..args));
}
text_disabled :: proc  (fmt_: string, args: ..any) {
    im_text_disabled(_make_text_string(fmt_, ..args));
}
text_wrapped :: proc   (fmt_: string, args: ..any) {
    im_text_wrapped(_make_text_string(fmt_, ..args));
}
label_text :: proc     (label : string, fmt_ : string, args : ..any) {
    im_label_text(_make_label_string(label), _make_text_string(fmt_, ..args));
}
bullet_text :: proc    (fmt_: string, args: ..any) {
    im_bullet_text(_make_text_string(fmt_, ..args));
}
foreign cimgui {
    im_text :: proc         (fmt: ^u8) #cc_c                  #link_name "igText" ---; 
    im_text_colored :: proc (col : Vec4, fmt_ : ^u8) #cc_c    #link_name "igTextColored" ---;
    im_text_disabled :: proc(fmt_ : ^u8)                      #link_name "igTextDisabled" ---;
    im_text_wrapped :: proc (fmt: ^u8)                        #link_name "igTextWrapped" ---;
    im_label_text :: proc   (label : Cstring, fmt_ : Cstring) #link_name "igLabelText" ---;
    im_bullet_text :: proc  (fmt_ : Cstring)                  #link_name "igBulletText" ---;

    TextUnformatted :: proc(text : Cstring, text_end : Cstring) #link_name "igTextUnformatted" ---;
    bullet :: proc         ()                                   #link_name "igBullet" ---;
}

//@TODO(Hoej): Figure out what to do here.


///// Buttons
button :: proc          (label : string) -> bool {
    return button(label, Vec2{0, 0}); //TODO Ask Bill if it's intentional that this can't be a default parameter
}
button :: proc          (label : string, size : Vec2) -> bool {
    foreign cimgui im_button :: proc (label : Cstring, size : Vec2) -> bool #link_name "igButton" ---;
    return im_button(_make_label_string(label), size);
}
small_button :: proc    (label : string) -> bool {
    foreign cimgui im_small_button :: proc(label : Cstring) -> bool #link_name "igSmallButton" ---;
    return im_small_button(_make_label_string(label));
}
invisible_button :: proc(str_id : string, size : Vec2) -> bool {
    foreign cimgui im_invisible_button :: proc(str_id : Cstring, size : Vec2) -> bool #link_name "igInvisibleButton" ---;
    return im_invisible_button(_make_label_string(str_id), size);
}
foreign cimgui image_button :: proc(user_texture_id : TextureID, size : Vec2, uv0 : Vec2, uv1 : Vec2, frame_padding : i32, bg_col : Vec4, tint_col : Vec4) -> bool #link_name "igImageButton" ---;

image :: proc             (user_texture_id : TextureID, size : Vec2) {
    image(user_texture_id, size, Vec2{0, 0}, Vec2{1, 1}, Vec4{1, 1, 1, 1}, Vec4{0, 0, 0, 0}); //TODO Ask Bill if it's intentional that this can't be a default parameter
}
foreign cimgui image :: proc(user_texture_id : TextureID, size : Vec2, uv0 : Vec2, uv1 : Vec2, tint_col : Vec4, border_col : Vec4) #link_name "igImage" ---;

checkbox :: proc          (label : string, v : ^bool) -> bool {
    foreign cimgui im_checkbox :: proc(label : Cstring, v : ^bool) -> bool #link_name "igCheckbox" ---;
    return im_checkbox(_make_label_string(label), v);
}
checkbox_flags :: proc    (label : string, flags : ^u32, flags_value : u32) -> bool {
    foreign cimgui im_checkbox_flags :: proc(label : Cstring, flags : ^u32, flags_value : u32) -> bool #link_name "igCheckboxFlags" ---;
    return im_checkbox_flags(_make_label_string(label), flags, flags_value);
}

radio_buttons_bool :: proc(label : string, active : bool) -> bool {
    foreign cimgui im_radio_buttons_bool :: proc(label : Cstring, active : bool) -> bool #link_name "igRadioButtonBool" ---;
    return im_radio_buttons_bool(_make_label_string(label), active);
}
radio_button :: proc      (label : string, v : ^i32, v_button : i32) -> bool {
    foreign cimgui im_radio_button :: proc(label : Cstring, v : ^i32, v_button : i32) -> bool #link_name "igRadioButton" ---;
    return im_radio_button(_make_label_string(label), v, v_button);
}

combo :: proc             (label : string, current_item : ^i32, items : []string, height_in_items : i32 = -1) -> bool {
    foreign cimgui im_combo :: proc(label : Cstring, current_item : ^i32, items : ^^u8, items_count : i32, height_in_items : i32) -> bool #link_name "igCombo" ---;

    data := make([]^u8, len(items)); defer free(data);
    for item, idx in items {
        data[idx] = strings.new_c_string(item);
    } //@TODO(Hoej): Change this to stack buffers.

    return im_combo(_make_label_string(label), current_item, &data[0], i32(len(items)), height_in_items); 
}
//@TODO(Hoej): Get this shit straight
foreign cimgui combo2 :: proc(label : Cstring, current_item : ^i32, items_separated_by_zeros : Cstring, height_in_items : i32) -> bool #link_name "igCombo2" ---;
foreign cimgui combo3 :: proc(label : Cstring, current_item : ^i32, items_getter : proc(data : rawptr, idx : i32, out_text : ^^u8) -> bool #cc_c, data : rawptr, items_count : i32, height_in_items : i32) -> bool #link_name "igCombo3" ---;
foreign cimgui color_button :: proc(col : Vec4, small_height : bool, outline_border : bool) -> bool #link_name "igColorButton" ---;

color_edit :: proc        (label : string, col : ^[3]f32) -> bool {
    foreign cimgui im_color_edit3 :: proc(label : Cstring, col : ^f32) -> bool #link_name "igColorEdit3" ---;
    return im_color_edit3(_make_label_string(label), &col[0]);    
}
color_edit :: proc        (label : string, col : ^[4]f32) -> bool {
    foreign cimgui im_color_edit4 :: proc(label : Cstring, col : ^f32) -> bool #link_name "igColorEdit4" ---;
    return im_color_edit4(_make_label_string(label), &col[0]);    
}

foreign cimgui color_edit_mode ::  proc(mode : GuiColorEditMode) #link_name "igColorEditMode" ---;
//@TODO(Hoej): Get this shit straight
foreign cimgui plot_lines :: proc(label : Cstring, values : ^f32, values_count : i32, values_offset : i32, overlay_text : Cstring, scale_min : f32, scale_max : f32, graph_size : Vec2, stride : i32) #link_name "igPlotLines" ---;
foreign cimgui plot_lines2 :: proc(label : Cstring, values_getter : proc(data : rawptr, idx : i32) -> f32, data : rawptr, values_count : i32, values_offset : i32, overlay_text : Cstring, scale_min : f32, scale_max : f32, graph_size : Vec2) #link_name "igPlotLines2" ---;

//TODO figure out what if this can't be replaced with default params
plot_histogram :: proc    (label : string, values : []f32, scale_min : f32, scale_max : f32, graph_size : Vec2) {
    plot_histogram(label, values, "\x00", scale_min, scale_max, graph_size, size_of(f32));
}
plot_histogram :: proc    (label : string, values : []f32, overlay_text : string, scale_min : f32, scale_max : f32, graph_size : Vec2) {
    plot_histogram(label, values, overlay_text, scale_min, scale_max, graph_size, size_of(f32));
}
plot_histogram :: proc    (label : string, values : []f32, overlay_text : string, scale_min : f32, scale_max : f32, graph_size : Vec2, stride : i32) {
    foreign cimgui im_plot_histogram :: proc(label : Cstring, values : ^f32, values_count : i32, values_offset : i32, overlay_text : Cstring, scale_min : f32, scale_max : f32, graph_size : Vec2, stride : i32) #link_name "igPlotHistogram" ---;

    im_plot_histogram(_make_label_string(label), &values[0], i32(len(values)), 0, _make_misc_string(overlay_text), scale_min, scale_max, graph_size, stride);
}

foreign cimgui plot_histogram2 :: proc(label : Cstring, values_getter : proc(data : rawptr, idx : i32) -> f32, data : rawptr, values_count : i32, values_offset : i32, overlay_text : Cstring, scale_min : f32, scale_max : f32, graph_size : Vec2) #link_name "igPlotHistogram2" ---;

progress_bar :: proc      (fraction : f32, size_arg : ^Vec2, overlay : string = "") {
    foreign cimgui im_progress_bar :: proc(fraction : f32, size_arg : ^Vec2, overlay : Cstring) #link_name "igProgressBar" ---;
    im_progress_bar(fraction, size_arg, _make_misc_string(overlay));
}


// Widgets: Sliders (tip: ctrl+click on a slider to input text)
slider_float :: proc(label : string, v : ^f32, v_min : f32, v_max : f32, display_format : string, power : f32) -> bool {
    return im_slider_float(_make_label_string(label), v, v_min, v_max, _make_display_fmt_string(display_format), power);
}
slider_float :: proc(label : string, v : ^[2]f32, v_min : f32, v_max : f32, display_format : string, power : f32) -> bool {
    return im_slider_float2(_make_label_string(label), &v[0], v_min, v_max, _make_display_fmt_string(display_format), power);
}
slider_float :: proc(label : string, v : ^[3]f32, v_min : f32, v_max : f32, display_format : string, power : f32) -> bool {
    return im_slider_float2(_make_label_string(label), &v[0], v_min, v_max, _make_display_fmt_string(display_format), power);
}
slider_float :: proc(label : string, v : ^[4]f32, v_min : f32, v_max : f32, display_format : string, power : f32) -> bool {
    return im_slider_float2(_make_label_string(label), &v[0], v_min, v_max, _make_display_fmt_string(display_format), power);
}

slider_angle :: proc(label : string, v_rad : ^f32, v_degrees_min : f32, v_degrees_max : f32) -> bool {
    return im_slider_angle(_make_label_string(label),v_rad, v_degrees_min, v_degrees_max);
}

slider_int :: proc(label : string, v : ^i32, v_min : i32, v_max : i32, display_format : string) -> bool {
    return im_slider_int(_make_label_string(label), v, v_min, v_max, _make_display_fmt_string(display_format));
}
slider_int :: proc(label : string, v : ^[2]i32, v_min : i32, v_max : i32, display_format : string) -> bool {
    return im_slider_int2(_make_label_string(label), &v[0], v_min, v_max, _make_display_fmt_string(display_format));
}
slider_int :: proc(label : string, v : ^[3]i32, v_min : i32, v_max : i32, display_format : string) -> bool {
    return im_slider_int3(_make_label_string(label), &v[0], v_min, v_max, _make_display_fmt_string(display_format));
}
slider_int :: proc(label : string, v : ^[4]i32, v_min : i32, v_max : i32, display_format : string) -> bool {
    return im_slider_int4(_make_label_string(label), &v[0], v_min, v_max, _make_display_fmt_string(display_format));
}

vslider_float :: proc(label : string, size : Vec2, v : ^f32, v_min : f32 , v_max : f32, display_format : string, power : f32) -> bool {
    return im_vslider_float(_make_label_string(label), size, v, v_min, v_max, _make_display_fmt_string(display_format), power);
}

vslider_int :: proc(label : string, size : Vec2, v : ^i32, v_min : i32, v_max : i32, display_format : string) -> bool {
    return im_vslider_int(_make_label_string(label), size, v, v_min, v_max, _make_display_fmt_string(display_format));
}


// Widgets: Drags (tip: ctrl+click on a drag box to input text)
drag_float :: proc(label : string, v : ^f32, v_speed : f32, v_min : f32, v_max : f32, display_format : string, power : f32) {
    im_drag_float(_make_label_string(label), v, v_speed, v_min, v_max, _make_display_fmt_string(display_format), power);
}
drag_float :: proc(label : string, v : ^[2]f32, v_speed : f32, v_min : f32, v_max : f32, display_format : string, power : f32) -> bool {
    return im_drag_float2(_make_label_string(label), &v[0], v_speed, v_min, v_max, _make_display_fmt_string(display_format), power);
}
drag_float :: proc(label : string, v : ^[3]f32, v_speed : f32, v_min : f32, v_max : f32, display_format : string, power : f32) -> bool {
    return im_drag_float3(_make_label_string(label), &v[0], v_speed, v_min, v_max, _make_display_fmt_string(display_format), power);
}
drag_float :: proc(label : string, v : ^[4]f32, v_speed : f32, v_min : f32, v_max : f32, display_format : string, power : f32) -> bool {
    return im_drag_float4(_make_label_string(label), &v[0], v_speed, v_min, v_max, _make_display_fmt_string(display_format), power);
}

drag_float_range :: proc(label : string, v_current_min, v_current_max : ^f32, v_speed, v_min, v_max : f32, display_format, display_format_max : string, power : f32) -> bool {
    id  := _make_label_string(label);
    df  := _make_display_fmt_string(display_format);
    mdf := _make_misc_string(display_format_max);
    return im_drag_float_range(id, v_current_min, v_current_max, v_speed, v_min, v_max, df, mdf, power);
}

drag_int :: proc(label : string, v : ^i32, v_speed : f32, v_min : i32, v_max : i32, display_format : string) {
    im_drag_int(_make_label_string(label), v, v_speed, v_min, v_max, _make_display_fmt_string(display_format));
}
drag_int :: proc(label : string, v : ^[2]i32, v_speed : f32, v_min : i32, v_max : i32, display_format : string) {
    im_drag_int2(_make_label_string(label), &v[0], v_speed, v_min, v_max, _make_display_fmt_string(display_format));
}
drag_int :: proc(label : string, v : ^[3]i32, v_speed : f32, v_min : i32, v_max : i32, display_format : string) {
    im_drag_int3(_make_label_string(label), &v[0], v_speed, v_min, v_max, _make_display_fmt_string(display_format));
}
drag_int :: proc(label : string, v : ^[4]i32, v_speed : f32, v_min : i32, v_max : i32, display_format : string) {
    im_drag_int4(_make_label_string(label), &v[0], v_speed, v_min, v_max, _make_display_fmt_string(display_format));
}

drag_int_range :: proc(label : string, v_current_min, v_current_max : ^i32, v_speed, v_min, v_max : i32, display_format, display_format_max : string) -> bool {
    id  := _make_label_string(label);
    df  := _make_display_fmt_string(display_format);
    mdf := _make_misc_string(display_format_max);
    return im_drag_int_range(id, v_current_min, v_current_max, v_speed, v_min, v_max, df, mdf);
}

// Widgets: Input
input_text :: proc          (label : string, buf : []u8, flags : GuiInputTextFlags, callback : gui_text_edit_callback, user_data : rawptr) -> bool {
    return im_input_text(_make_label_string(label), &buf[0], u64(len(buf)), flags, callback, user_data);
}
input_text_multiline :: proc(label : string, buf : []u8, size : Vec2, flags : GuiInputTextFlags, callback : gui_text_edit_callback, user_data : rawptr) -> bool {
    return im_input_text_multiline(_make_label_string(label), &buf[0], u64(len(buf)), size, flags, callback, user_data);
}

input_float :: proc(label : string, v : ^f32, step : f32, step_fast : f32, decimal_precision : i32, extra_flags : GuiInputTextFlags) -> bool {
    return im_input_float(_make_label_string(label), v, step, step_fast, decimal_precision, extra_flags);
}
input_float :: proc(label : string, v : ^[2]f32, decimal_precision : i32, extra_flags : GuiInputTextFlags) -> bool {
    return im_input_float2(_make_label_string(label), &v[0], decimal_precision, extra_flags);
}
input_float :: proc(label : string, v : ^[3]f32, decimal_precision : i32, extra_flags : GuiInputTextFlags) -> bool {
    return im_input_float3(_make_label_string(label), &v[0], decimal_precision, extra_flags);
}
input_float :: proc(label : string, v : ^[4]f32, decimal_precision : i32, extra_flags : GuiInputTextFlags) -> bool {
    return im_input_float4(_make_label_string(label), &v[0], decimal_precision, extra_flags);
}

input_int :: proc (label : string, v : ^i32, step : i32, step_fast : i32, extra_flags : GuiInputTextFlags) -> bool {
    return im_input_int(_make_label_string(label), v, step, step_fast, extra_flags);
}
input_int :: proc(label : string, v : ^[2]i32, extra_flags : GuiInputTextFlags) -> bool {
    return im_input_int2(_make_label_string(label), &v[0], extra_flags);
}
input_int :: proc(label : string, v : ^[3]i32, extra_flags : GuiInputTextFlags) -> bool {
    return im_input_int3(_make_label_string(label), &v[0], extra_flags);
}
input_int :: proc(label : string, v : ^[4]i32, extra_flags : GuiInputTextFlags) -> bool {
    return im_input_int4(_make_label_string(label), &v[0], extra_flags);
}

foreign cimgui {
    im_slider_float :: proc (label : Cstring, v : ^f32, v_min : f32, v_max : f32, display_format : Cstring, power : f32) -> bool #link_name "igSliderFloat" ---;
    im_slider_float2 :: proc(label : Cstring, v : ^f32, v_min : f32, v_max : f32, display_format : Cstring, power : f32) -> bool #link_name "igSliderFloat2" ---;
    im_slider_float3 :: proc(label : Cstring, v : ^f32, v_min : f32, v_max : f32, display_format : Cstring, power : f32) -> bool #link_name "igSliderFloat3" ---;
    im_slider_float4 :: proc(label : Cstring, v : ^f32, v_min : f32, v_max : f32, display_format : Cstring, power : f32) -> bool #link_name "igSliderFloat4" ---;
    im_slider_angle :: proc (label : Cstring, v_rad : ^f32, v_degrees_min : f32, v_degrees_max : f32) -> bool                    #link_name "igSliderAngle" ---;
    
    im_slider_int :: proc (label : Cstring, v : ^i32, v_min : i32, v_max : i32, display_format : Cstring) -> bool #link_name "igSliderInt" ---;
    im_slider_int2 :: proc(label : Cstring, v : ^i32, v_min : i32, v_max : i32, display_format : Cstring) -> bool #link_name "igSliderInt2" ---;
    im_slider_int3 :: proc(label : Cstring, v : ^i32, v_min : i32, v_max : i32, display_format : Cstring) -> bool #link_name "igSliderInt3" ---;
    im_slider_int4 :: proc(label : Cstring, v : ^i32, v_min : i32, v_max : i32, display_format : Cstring) -> bool #link_name "igSliderInt4" ---;
    
    im_vslider_float :: proc(label : Cstring, size : Vec2, v : ^f32, v_min : f32 , v_max : f32, display_format : Cstring, power : f32) -> bool #link_name "igVSliderFloat" ---;
    im_vslider_int :: proc  (label : Cstring, size : Vec2, v : ^i32, v_min : i32, v_max : i32, display_format : Cstring) -> bool               #link_name "igVSliderInt" ---;
    
    im_drag_float :: proc      (label : Cstring, v : ^f32, v_speed : f32, v_min : f32, v_max : f32, display_format : Cstring, power : f32)                                            #link_name "igDragFloat" ---;
    im_drag_float2 :: proc     (label : Cstring, v : ^f32, v_speed : f32, v_min : f32, v_max : f32, display_format : Cstring, power : f32) -> bool                                    #link_name "igDragFloat2" ---;
    im_drag_float3 :: proc     (label : Cstring, v : ^f32, v_speed : f32, v_min : f32, v_max : f32, display_format : Cstring, power : f32) -> bool                                    #link_name "igDragFloat3" ---;
    im_drag_float4 :: proc     (label : Cstring, v : ^f32, v_speed : f32, v_min : f32, v_max : f32, display_format : Cstring, power : f32) -> bool                                    #link_name "igDragFloat4" ---;
    im_drag_float_range :: proc(label : Cstring, v_current_min, v_current_max : ^f32, v_speed, v_min, v_max : f32, display_format, display_format_max : Cstring, power : f32) -> bool #link_name "igDragFloatRange2" ---;
    
    im_drag_int :: proc      (label : Cstring, v : ^i32, v_speed : f32, v_min : i32, v_max : i32, display_format : Cstring)                                            #link_name "igDragInt" ---;
    im_drag_int2 :: proc     (label : Cstring, v : ^i32, v_speed : f32, v_min : i32, v_max : i32, display_format : Cstring)                                            #link_name "igDragInt2" ---;
    im_drag_int3 :: proc     (label : Cstring, v : ^i32, v_speed : f32, v_min : i32, v_max : i32, display_format : Cstring)                                            #link_name "igDragInt3" ---;
    im_drag_int4 :: proc     (label : Cstring, v : ^i32, v_speed : f32, v_min : i32, v_max : i32, display_format : Cstring)                                            #link_name "igDragInt4" ---;
    im_drag_int_range :: proc(label : Cstring, v_current_min, v_current_max : ^i32, v_speed, v_min, v_max : i32, display_format, display_format_max : Cstring) -> bool #link_name "igDragIntRange2" ---;
    
    im_input_text :: proc          (label : Cstring, buf : Cstring, buf_size : u64 /*size_t*/, flags : GuiInputTextFlags, callback : gui_text_edit_callback, user_data : rawptr) -> bool              #link_name "igInputText" ---;
    im_input_text_multiline :: proc(label : Cstring, buf : Cstring, buf_size : u64 /*size_t*/, size : Vec2, flags : GuiInputTextFlags, callback : gui_text_edit_callback, user_data : rawptr) -> bool #link_name "igInputTextMultiline" ---;
    
    im_input_float :: proc (label : Cstring, v : ^f32, step : f32, step_fast : f32, decimal_precision : i32, extra_flags : GuiInputTextFlags) -> bool #link_name "igInputFloat" ---;
    im_input_float2 :: proc(label : Cstring, v : ^f32, decimal_precision : i32, extra_flags : GuiInputTextFlags) -> bool                              #link_name "igInputFloat2" ---;
    im_input_float3 :: proc(label : Cstring, v : ^f32, decimal_precision : i32, extra_flags : GuiInputTextFlags) -> bool                              #link_name "igInputFloat3" ---;
    im_input_float4 :: proc(label : Cstring, v : ^f32, decimal_precision : i32, extra_flags : GuiInputTextFlags) -> bool                              #link_name "igInputFloat4" ---;
    
    im_input_int :: proc (label : Cstring, v : ^i32, step : i32, step_fast : i32, extra_flags : GuiInputTextFlags) -> bool #link_name "igInputInt" ---;
    im_input_int2 :: proc(label : Cstring, v : ^i32, extra_flags : GuiInputTextFlags) -> bool                              #link_name "igInputInt2" ---;
    im_input_int3 :: proc(label : Cstring, v : ^i32, extra_flags : GuiInputTextFlags) -> bool                              #link_name "igInputInt3" ---;
    im_input_int4 :: proc(label : Cstring, v : ^i32, extra_flags : GuiInputTextFlags) -> bool                              #link_name "igInputInt4" ---;
}

// Widgets: Trees
tree_node :: proc(label : string) -> bool {
    foreign cimgui im_tree_node :: proc (label : Cstring) -> bool #link_name "igTreeNode" ---;
    return im_tree_node(_make_label_string(label));
}
tree_node :: proc(str_id : string, fmt_ : string, args : ..any) -> bool {
    foreign cimgui im_tree_node_str :: proc (str_id : Cstring, fmt_ : ^u8) -> bool #link_name "igTreeNodeStr" ---;
    return im_tree_node_str(_make_label_string(str_id), _make_text_string(fmt_, ..args));
}
tree_node :: proc(ptr_id : rawptr, fmt_ : string, args : ..any) -> bool {
    foreign cimgui im_tree_node_ptr :: proc (ptr_id : rawptr, fmt_ : ^u8) -> bool #link_name "igTreeNodePtr" ---;
    return im_tree_node_ptr(ptr_id, _make_text_string(fmt_, ..args));
}
tree_node_ex :: proc(label : string, flags : GuiTreeNodeFlags) -> bool {
    foreign cimgui im_tree_node_ex :: proc (label : Cstring, flags : GuiTreeNodeFlags) -> bool #link_name "igTreeNodeEx" ---;
    return im_tree_node_ex(_make_label_string(label), flags);
}
tree_node_ex :: proc(str_id : string, flags : GuiTreeNodeFlags, fmt_ : string, args : ..any) -> bool {
    foreign cimgui im_tree_node_ex_str :: proc (str_id : Cstring, flags : GuiTreeNodeFlags, fmt_ : ^u8) -> bool #link_name "igTreeNodeExStr" ---;
    return im_tree_node_ex_str(_make_label_string(str_id), flags, _make_text_string(fmt_, ..args));
}
tree_node_ex :: proc(ptr_id : rawptr, flags : GuiTreeNodeFlags, fmt_ : string, args : ..any) -> bool {
    foreign cimgui im_tree_node_ex_ptr :: proc (ptr_id : rawptr, flags : GuiTreeNodeFlags, fmt_ : ^u8) -> bool #link_name "igTreeNodeExPtr" ---;
    return im_tree_node_ex_ptr(ptr_id, flags, _make_text_string(fmt_, ..args));
}
tree_push_str :: proc(str_id : string) {
    foreign cimgui im_tree_push_str :: proc (str_id : Cstring) #link_name "igTreePushStr" ---;
    im_tree_push_str(_make_label_string(str_id));
}

foreign cimgui {
    tree_push_ptr :: proc(ptr_id : rawptr) #link_name "igTreePushPtr" ---;
    tree_pop :: proc() #link_name "igTreePop" ---;
    tree_advance_to_label_pos :: proc() #link_name "igTreeAdvanceToLabelPos" ---;
    get_tree_node_to_label_spacing :: proc() -> f32 #link_name "igGetTreeNodeToLabelSpacing" ---;
    set_next_tree_node_open :: proc(opened : bool, cond : GuiSetCond) #link_name "igSetNextTreeNodeOpen" ---;
}

collapsing_header :: proc(label : string, flags : GuiTreeNodeFlags = 0) -> bool {
    foreign cimgui im_collapsing_header :: proc(label : Cstring, flags : GuiTreeNodeFlags) -> bool #link_name "igCollapsingHeader" ---;
    return im_collapsing_header(_make_label_string(label), flags);
}

collapsing_header_ex :: proc(label : string, p_open : ^bool, flags : GuiTreeNodeFlags) -> bool {
    foreign cimgui im_collapsing_header_ex :: proc(label : Cstring, p_open : ^bool, flags : GuiTreeNodeFlags) -> bool #link_name "igCollapsingHeaderEx" ---;
    return im_collapsing_header_ex(_make_label_string(label), p_open, flags);
}

// Widgets: Selectable / Lists
selectable :: proc(label : string, selected : bool, flags : GuiSelectableFlags, size : Vec2) -> bool {
    foreign cimgui im_selectable :: proc(label : Cstring, selected : bool, flags : GuiSelectableFlags, size : Vec2) -> bool #link_name "igSelectable" ---;
    return im_selectable(_make_label_string(label), selected, flags, size);
}

selectable_ex :: proc(label : string, p_selected : ^bool, flags : GuiSelectableFlags, size : Vec2) -> bool {
    foreign cimgui im_selectable_ex :: proc(label : Cstring, p_selected : ^bool, flags : GuiSelectableFlags, size : Vec2) -> bool #link_name "igSelectableEx" ---;
    return im_selectable_ex(_make_label_string(label), p_selected, flags, size);
}

//@TODO(Hoej): Figure this shit out
foreign cimgui list_box :: proc(label : Cstring, current_item : ^i32, items : ^^u8, items_count : i32, height_in_items : i32) -> bool #link_name "igListBox" ---;
foreign cimgui list_box :: proc(label : Cstring, current_item : ^i32, items_getter : proc(data : rawptr, idx : i32, out_text : ^^u8) -> bool #cc_c, data : rawptr, items_count : i32, height_in_items : i32) -> bool #link_name "igListBox2" ---;

list_box_header :: proc(label : string, size : Vec2) -> bool {
    foreign cimgui im_list_box_header :: proc(label : Cstring, size : Vec2) -> bool #link_name "igListBoxHeader" ---;
    return im_list_box_header(_make_label_string(label), size);
}
list_box_header :: proc(label : string, items_count : i32, height_in_items : i32) -> bool {
    foreign cimgui im_list_box_header :: proc(label : Cstring, items_count : i32, height_in_items : i32) -> bool #link_name "igListBoxHeader2" ---;
    return im_list_box_header(_make_label_string(label), items_count, height_in_items);
}
foreign cimgui list_box_footer :: proc() #link_name "igListBoxFooter" ---;

// Widgets: Value() Helpers. Output single value in "name: value" format (tip: freely declare your own within the ImGui namespace!)
value :: proc(prefix : string, b : bool) {
    foreign cimgui im_value_bool :: proc(prefix : Cstring, b : bool) #link_name "igValueBool" ---;
    im_value_bool(_make_label_string(prefix), b);
}
value :: proc(prefix : string, v : i32) {
    foreign cimgui im_value_int :: proc(prefix : Cstring, v : i32) #link_name "igValueInt" ---;
    im_value_int(_make_label_string(prefix), v);
}
value :: proc(prefix : string, v : u32) {
    foreign cimgui im_value_uint :: proc(prefix : Cstring, v : u32) #link_name "igValueUInt" ---;
    im_value_uint(_make_label_string(prefix), v);
}
value :: proc(prefix : string, v : f32, format : string) {
    foreign cimgui im_value_float :: proc(prefix : Cstring, v : f32, float_format : Cstring) #link_name "igValueFloat" ---;
    im_value_float(_make_label_string(prefix), v, _make_misc_string(format));
}
value :: proc(prefix : string, v : Vec4) {
    foreign cimgui im_value_color :: proc(prefix : Cstring, v : Vec4) #link_name "igValueColor" ---;
    im_value_color(_make_label_string(prefix), v);
}

// Tooltip
set_tooltip :: proc(fmt_ : string, args : ..any) {
    foreign cimgui im_set_tooltip :: proc(fmt : ^u8) #link_name "igSetTooltip" ---; 
    im_set_tooltip(_make_text_string(fmt_, ..args));
}
foreign cimgui begin_tooltip :: proc() #link_name "igBeginTooltip" ---;
foreign cimgui end_tooltip :: proc  () #link_name "igEndTooltip" ---;

foreign cimgui {
    // Widgets: Menus
    begin_main_menu_bar :: proc() -> bool #link_name "igBeginMainMenuBar" ---;
    end_main_menu_bar :: proc  () #link_name "igEndMainMenuBar" ---;
    begin_menu_bar :: proc     () -> bool #link_name "igBeginMenuBar" ---;
    end_menu_bar :: proc       () #link_name "igEndMenuBar" ---;
}

begin_menu :: proc(label : string, enabled : bool = true) -> bool {
    foreign cimgui im_begin_menu :: proc(label : Cstring, enabled : bool) -> bool #link_name "igBeginMenu" ---;
    return im_begin_menu(_make_label_string(label), enabled);
}

foreign cimgui end_menu :: proc() #link_name "igEndMenu" ---;

menu_item :: proc(label : string, shortcut : string = "", selected : bool = false, enabled : bool = true) -> bool  {
    foreign cimgui im_menu_item :: proc(label : Cstring, shortcut : Cstring, selected : bool, enabled : bool) -> bool #link_name "igMenuItem" ---;   
    return im_menu_item(_make_label_string(label), _make_misc_string(shortcut), selected, enabled);
}

menu_item_ptr :: proc(label : string, shortcut : string, selected : ^bool, enabled : bool) -> bool  {
    foreign cimgui im_menu_item_ptr :: proc(label : Cstring, shortcut : Cstring, p_selected : ^bool, enabled : bool) -> bool #link_name "igMenuItemPtr" ---;
    return im_menu_item_ptr(_make_label_string(label), _make_misc_string(shortcut), selected, enabled);
}

// Popup
open_popup :: proc(str_id : string) {
    foreign cimgui im_open_popup :: proc(str_id : Cstring) #link_name "igOpenPopup" ---;
    im_open_popup(_make_label_string(str_id));
}

begin_popup :: proc(str_id : string) -> bool {
    foreign cimgui im_begin_popup :: proc(str_id : Cstring) -> bool #link_name "igBeginPopup" ---;
    return im_begin_popup(_make_label_string(str_id));
}

begin_popup_modal :: proc(name : string, open : ^bool, extra_flags : GuiWindowFlags) -> bool {
    foreign cimgui im_begin_popup_modal :: proc(name : Cstring, p_open : ^bool, extra_flags : GuiWindowFlags) -> bool #link_name "igBeginPopupModal" ---;
    return im_begin_popup_modal(_make_label_string(name), open, extra_flags);
}

begin_popup_context_item :: proc(str_id : string, mouse_button : i32) -> bool {
    foreign cimgui im_begin_popup_context_item :: proc(str_id : Cstring, mouse_button : i32) -> bool #link_name "igBeginPopupContextItem" ---;
    return im_begin_popup_context_item(_make_label_string(str_id), mouse_button);
}
begin_popup_context_window :: proc(also_over_items : bool, str_id : string, mouse_button : i32) -> bool {
    foreign cimgui im_begin_popup_context_window :: proc(also_over_items : bool, str_id : Cstring, mouse_button : i32) -> bool #link_name "igBeginPopupContextWindow" ---;
    return im_begin_popup_context_window(also_over_items, _make_label_string(str_id), mouse_button);
}
begin_popup_context_void :: proc(str_id : string, mouse_button : i32) -> bool {
    foreign cimgui im_begin_popup_context_void :: proc(str_id : Cstring, mouse_button : i32) -> bool #link_name "igBeginPopupContextVoid" ---;
    return im_begin_popup_context_void(_make_label_string(str_id), mouse_button);
}
foreign cimgui end_popup :: proc() #link_name "igEndPopup" ---;
foreign cimgui close_current_popup :: proc() #link_name "igCloseCurrentPopup" ---;

foreign cimgui {
    // Logging: all text output from interface is redirected to tty/file/clipboard. Tree nodes are automatically opened.
    log_to_tty :: proc(max_depth : i32) #link_name "igLogToTTY" ---;
    log_to_file :: proc(max_depth : i32, filename : Cstring) #link_name "igLogToFile" ---;
    log_to_clipboard :: proc(max_depth : i32) #link_name "igLogToClipboard" ---;
    log_finish :: proc() #link_name "igLogFinish" ---;
    log_buttons :: proc() #link_name "igLogButtons" ---;
}
log_text :: proc(fmt_ : string, args : ..any) {
    foreign cimgui im_log_text :: proc(fmt_ : ^u8) #link_name "igLogText" ---;
    im_log_text(_make_text_string(fmt_, ..args));
}

// Clipping
foreign cimgui push_clip_rect :: proc(clip_rect_min : Vec2, clip_rect_max : Vec2, intersect_with_current_clip_rect : bool) #link_name "igPushClipRect" ---;
foreign cimgui pop_clip_rect :: proc() #link_name "igPopClipRect" ---;

foreign cimgui {
    // Utilities
    is_item_hovered :: proc                    () -> bool                                                                                                 #link_name "igIsItemHovered" ---;
    is_item_hovered_rect :: proc               () -> bool                                                                                                 #link_name "igIsItemHoveredRect" ---;
    is_item_active :: proc                     () -> bool                                                                                                 #link_name "igIsItemActive" ---;
    is_item_clicked :: proc                    (mouse_button : i32) -> bool                                                                               #link_name "igIsItemClicked" ---;
    is_item_visible :: proc                    () -> bool                                                                                                 #link_name "igIsItemVisible" ---;
    is_any_item_hovered :: proc                () -> bool                                                                                                 #link_name "igIsAnyItemHovered" ---;
    is_any_item_active :: proc                 () -> bool                                                                                                 #link_name "igIsAnyItemActive" ---;
    get_item_rect_min :: proc                  (pOut : ^Vec2)                                                                                             #link_name "igGetItemRectMin" ---;
    get_item_rect_max :: proc                  (pOut : ^Vec2)                                                                                             #link_name "igGetItemRectMax" ---;
    get_item_rect_size :: proc                 (pOut : ^Vec2)                                                                                             #link_name "igGetItemRectSize" ---;
    set_item_allow_overlap :: proc             ()                                                                                                         #link_name "igSetItemAllowOverlap" ---;
    is_window_hovered :: proc                  () -> bool                                                                                                 #link_name "igIsWindowHovered" ---;
    is_window_focused :: proc                  () -> bool                                                                                                 #link_name "igIsWindowFocused" ---;
    is_root_window_focused :: proc             () -> bool                                                                                                 #link_name "igIsRootWindowFocused" ---;
    is_root_window_or_any_child_focused :: proc() -> bool                                                                                                 #link_name "igIsRootWindowOrAnyChildFocused" ---;
    is_root_window_or_any_child_hovered :: proc() -> bool                                                                                                 #link_name "igIsRootWindowOrAnyChildHovered" ---;
    is_rect_visible :: proc                    (item_size : Vec2) -> bool                                                                                 #link_name "igIsRectVisible" ---;
    is_pos_hovering_any_window :: proc         (pos : Vec2) -> bool                                                                                       #link_name "igIsPosHoveringAnyWindow" ---;
    get_time :: proc                           () -> f32                                                                                                  #link_name "igGetTime" ---;
    get_frame_count :: proc                    () -> i32                                                                                                  #link_name "igGetFrameCount" ---;
    get_style_col_name :: proc                 (idx : GuiCol) -> Cstring                                                                                 #link_name "igGetStyleColName" ---;
    calc_item_rect_closest_point :: proc       (pOut : ^Vec2, pos : Vec2 , on_edge : bool, outward : f32)                                                 #link_name "igCalcItemRectClosestPoint" ---;
    //@TODO(Hoej): Figure that shit out
    calc_text_size :: proc                     (pOut : ^Vec2, text : Cstring, text_end : Cstring, hide_text_after_double_hash : bool, wrap_width : f32) #link_name "igCalcTextSize" ---;
    calc_list_clipping :: proc                 (items_count : i32, items_height : f32, out_items_display_start : ^i32, out_items_display_end : ^i32)      #link_name "igCalcListClipping" ---;
}

foreign cimgui begin_child_frame :: proc(id : GuiId, size : Vec2, extra_flags : GuiWindowFlags) -> bool #link_name "igBeginChildFrame" ---;
foreign cimgui end_child_frame :: proc  ()                                                              #link_name "igEndChildFrame" ---;

foreign cimgui {
    color_convert_u32_to_float4 :: proc(pOut : ^Vec4 , in_ : u32)                                            #link_name "igColorConvertU32ToFloat4" ---;
    color_convert_float4_to_u32 :: proc(in_ : Vec4) -> u32                                                   #link_name "igColorConvertFloat4ToU32" ---;
    color_convert_rgb_to_hsv :: proc   (r : f32, g : f32, b : f32, out_h : ^f32, out_s : ^f32, out_v : ^f32) #link_name "igColorConvertRGBtoHSV" ---;
    color_convert_hsv_to_rgb :: proc   (h : f32, s : f32, v : f32, out_r : ^f32, out_g : ^f32, out_b : ^f32) #link_name "igColorConvertHSVtoRGB" ---;
}
foreign cimgui {
    get_key_index :: proc                         (key : GuiKey) -> i32                              #link_name "igGetKeyIndex" ---;
    is_key_Down :: proc                           (key_index : i32) -> bool                          #link_name "igIsKeyDown" ---;
    is_key_Pressed :: proc                        (key_index : i32, repeat : bool) -> bool           #link_name "igIsKeyPressed" ---;
    is_key_Released :: proc                       (key_index : i32) -> bool                          #link_name "igIsKeyReleased" ---;
    is_mouse_down :: proc                         (button : i32) -> bool                             #link_name "igIsMouseDown" ---;
    is_mouse_clicked :: proc                      (button : i32, repeat : bool) -> bool              #link_name "igIsMouseClicked" ---;
    is_mouse_double_clicked :: proc               (button : i32) -> bool                             #link_name "igIsMouseDoubleClicked" ---;
    is_mouse_released :: proc                     (button : i32) -> bool                             #link_name "igIsMouseReleased" ---;
    is_mouse_hovering_window :: proc              () -> bool                                         #link_name "igIsMouseHoveringWindow" ---;
    is_mouse_hovering_any_window :: proc          () -> bool                                         #link_name "igIsMouseHoveringAnyWindow" ---;
    is_mouse_hovering_rect :: proc                (r_min : Vec2, r_max : Vec2, clip : bool) -> bool  #link_name "igIsMouseHoveringRect" ---;
    is_mouse_dragging :: proc                     (button : i32, lock_threshold : f32) -> bool       #link_name "igIsMouseDragging" ---;
    get_mouse_pos :: proc                         (pOut : ^Vec2)                                     #link_name "igGetMousePos" ---;
    get_mouse_pos_on_opening_current_popup :: proc(pOut : ^Vec2)                                     #link_name "igGetMousePosOnOpeningCurrentPopup" ---;
    get_mouse_drag_delta :: proc                  (pOut : ^Vec2, button : i32, lock_threshold : f32) #link_name "igGetMouseDragDelta" ---;
    reset_mouse_drag_delta :: proc                (button : i32)                                     #link_name "igResetMouseDragDelta" ---;
    get_mouse_cursor :: proc                      () -> GuiMouseCursor                               #link_name "igGetMouseCursor" ---;
    set_mouse_cursor :: proc                      (type_ : GuiMouseCursor)                           #link_name "igSetMouseCursor" ---;
    capture_keyboard_from_app :: proc             (capture : bool)                                   #link_name "igCaptureKeyboardFromApp" ---;
    capture_mouse_from_app :: proc                (capture : bool)                                   #link_name "igCaptureMouseFromApp" ---;
}
get_mouse_pos :: proc       () -> Vec2 {
    out : Vec2;
    get_mouse_pos(&out);
    return out;
}
get_mouse_drag_delta :: proc(button : i32 = 0, lock_threshold : f32 = -1.0) -> Vec2 {
    out : Vec2;
    get_mouse_drag_delta(&out, button, lock_threshold);
    return out;
}

foreign cimgui {
    // Helpers functions to access functions pointers in  ::GetIO()
    mem_alloc :: proc         (sz : u64 /*size_t*/) -> rawptr #link_name "igMemAlloc" ---;
    mem_free :: proc          (ptr : rawptr)                  #link_name "igMemFree" ---;
    //@TODO(Hoej): Figure out if these should be wrapped
    get_clipboard_text :: proc() -> Cstring                   #link_name "igGetClipboardText" ---;
    set_clipboard_text :: proc(text : Cstring)                #link_name "igSetClipboardText" ---;
}

foreign cimgui {
    // Internal state access - if you want to share ImGui state between modules (e.g. DLL) or allocate it yourself
    get_version :: proc        () -> Cstring                                                                                     #link_name "igGetVersion" ---;
    create_context :: proc     (malloc_fn : proc(size : u64 /*size_t*/) -> rawptr, free_fn : proc(data : rawptr)) -> ^GuiContext #link_name "igCreateContext" ---;
    destroy_context :: proc    (ctx : ^GuiContext)                                                                               #link_name "igDestroyContext" ---;
    get_current_context :: proc() -> ^GuiContext                                                                                 #link_name "igGetCurrentContext" ---;
    set_current_context :: proc(ctx : ^GuiContext)                                                                               #link_name "igSetCurrentContext" ---;
}

////////////////////////////////////// Misc    ///////////////////////////////////////////////
foreign cimgui {
    font_config_default_constructor :: proc(config : ^FontConfig) #link_name "ImFontConfig_DefaultConstructor" ---;
    gui_io_add_input_character :: proc(c : u16)                   #link_name "ImGuiIO_AddInputCharacter" ---;
    gui_io_add_input_characters_utf8 :: proc(utf8_chars : ^u8)    #link_name "ImGuiIO_AddInputCharactersUTF8" ---;
    gui_io_clear_input_characters :: proc()                       #link_name "ImGuiIO_ClearInputCharacters" ---;
//////////////////////////////// FontAtlas  //////////////////////////////////////////////
    font_atlas_get_text_data_as_rgba32 :: proc                   (atlas : ^FontAtlas, out_pixels : ^^u8, out_width : ^i32, out_height : ^i32, out_bytes_per_pixel : ^i32) #link_name "ImFontAtlas_GetTexDataAsRGBA32" ---;
    font_atlas_get_text_data_as_alpha8 :: proc                   (atlas : ^FontAtlas, out_pixels : ^^u8, out_width : ^i32, out_height : ^i32, out_bytes_per_pixel : ^i32) #link_name "ImFontAtlas_GetTexDataAsAlpha8" ---;
    font_atlas_set_text_id :: proc                               (atlas : ^FontAtlas, tex : rawptr)                                                                       #link_name "ImFontAtlas_SetTexID" ---;
    font_atlas_add_font_ :: proc                                 (atlas : ^FontAtlas, font_cfg : ^FontConfig ) -> ^Font                                                   #link_name "ImFontAtlas_AddFont" ---;
    font_atlas_add_font_default :: proc                          (atlas : ^FontAtlas, font_cfg : ^FontConfig ) -> ^Font                                                   #link_name "ImFontAtlas_AddFontDefault" ---;

    font_atlas_add_font_from_memory_ttf :: proc                  (atlas : ^FontAtlas, ttf_data : rawptr, ttf_size : i32, size_pixels : f32, font_cfg : ^FontConfig, glyph_ranges : ^Wchar) -> ^Font                       #link_name "ImFontAtlas_AddFontFromMemoryTTF" ---;
    font_atlas_add_font_from_memory_compressed_ttf :: proc       (atlas : ^FontAtlas, compressed_ttf_data : rawptr, compressed_ttf_size : i32, size_pixels : f32, font_cfg : ^FontConfig, glyph_ranges : ^Wchar) -> ^Font #link_name "ImFontAtlas_AddFontFromMemoryCompressedTTF" ---;
    font_atlas_add_font_from_memory_compressed_base85_ttf :: proc(atlas : ^FontAtlas, compressed_ttf_data_base85 : Cstring, size_pixels : f32, font_cfg : ^FontConfig, glyph_ranges : ^Wchar) -> ^Font                    #link_name "ImFontAtlas_AddFontFromMemoryCompressedBase85TTF" ---;
    font_atlas_clear_tex_data :: proc                            (atlas : ^FontAtlas)                                                                                                                                     #link_name "ImFontAtlas_ClearTexData" ---;
    font_atlas_clear :: proc                                     (atlas : ^FontAtlas)                                                                                                                                     #link_name "ImFontAtlas_Clear" ---;
}
font_atlas_add_font_from_file_ttf :: proc                    (atlas : ^FontAtlas, filename : string, size_pixels : f32, font_cfg : ^FontConfig, glyph_ranges : ^Wchar) -> ^Font {
    foreign cimgui im_font_atlas_add_font_from_file_ttf :: proc(atlas : ^FontAtlas, filename : Cstring, size_pixels : f32, font_cfg : ^FontConfig, glyph_ranges : ^Wchar) -> ^Font #link_name "ImFontAtlas_AddFontFromFileTTF" ---;
    return im_font_atlas_add_font_from_file_ttf(atlas, _make_misc_string(filename), size_pixels, font_cfg, glyph_ranges);
}
//////////////////////////////// DrawList  //////////////////////////////////////////////
foreign cimgui {
    draw_list_get_vertex_buffer_size :: proc(list : ^DrawList) -> i32                #link_name "ImDrawList_GetVertexBufferSize" ---;
    draw_list_get_vertex_ptr :: proc        (list : ^DrawList, n : i32) -> ^DrawVert #link_name "ImDrawList_GetVertexPtr" ---;
    draw_list_get_index_buffer_size :: proc (list : ^DrawList) -> i32                #link_name "ImDrawList_GetIndexBufferSize" ---;
    draw_list_get_index_ptr :: proc         (list : ^DrawList, n : i32) -> ^DrawIdx  #link_name "ImDrawList_GetIndexPtr" ---;
    draw_list_get_cmd_size :: proc          (list : ^DrawList) -> i32                #link_name "ImDrawList_GetCmdSize" ---;
    draw_list_get_cmd_ptr :: proc           (list : ^DrawList, n : i32) -> ^DrawCmd  #link_name "ImDrawList_GetCmdPtr" ---;

    draw_list_clear :: proc                     (list : ^DrawList)                                                                                      #link_name "ImDrawList_Clear" ---;
    draw_list_clear_free_memory :: proc         (list : ^DrawList)                                                                                      #link_name "ImDrawList_ClearFreeMemory" ---;
    draw_list_push_clip_rect :: proc            (list : ^DrawList, clip_rect_min : Vec2, clip_rect_max : Vec2, intersect_with_current_clip_rect : bool) #link_name "ImDrawList_PushClipRect" ---;
    draw_list_push_clip_rect_full_screen :: proc(list : ^DrawList)                                                                                      #link_name "ImDrawList_PushClipRectFullScreen" ---;
    draw_list_pop_clip_rect :: proc             (list : ^DrawList)                                                                                      #link_name "ImDrawList_PopClipRect" ---;
    draw_list_push_texture_id :: proc           (list : ^DrawList, texture_id : TextureID)                                                              #link_name "ImDrawList_PushTextureID" ---;
    draw_list_pop_texture_id :: proc            (list : ^DrawList)                                                                                      #link_name "ImDrawList_PopTextureID" ---;

    // Primitives
    draw_list_add_line :: proc                   (list : ^DrawList, a : Vec2, b : Vec2, col : u32, thickness : f32)                                                       #link_name "ImDrawList_AddLine" ---;
    draw_list_add_rect :: proc                   (list : ^DrawList, a : Vec2, b : Vec2, col : u32, rounding : f32, rounding_corners : i32, thickness : f32)               #link_name "ImDrawList_AddRect" ---;
    draw_list_add_rect_filled :: proc            (list : ^DrawList, a : Vec2, b : Vec2, col : u32, rounding : f32, rounding_corners : i32)                                #link_name "ImDrawList_AddRectFilled" ---;
    draw_list_add_rect_filled_multi_color :: proc(list : ^DrawList, a : Vec2, b : Vec2, col_upr_left : u32, col_upr_right : u32, col_bot_right : u32, col_bot_left : u32) #link_name "ImDrawList_AddRectFilledMultiColor" ---;
    draw_list_add_quad :: proc                   (list : ^DrawList, a : Vec2, b : Vec2, c : Vec2, d : Vec2, col : u32, thickness : f32)                                   #link_name "ImDrawList_AddQuad" ---;
    draw_list_add_quad_filled :: proc            (list : ^DrawList, a : Vec2, b : Vec2, c : Vec2, d : Vec2, col : u32)                                                    #link_name "ImDrawList_AddQuadFilled" ---;
    draw_list_add_triangle :: proc               (list : ^DrawList, a : Vec2, b : Vec2, c : Vec2, col : u32, thickness : f32)                                             #link_name "ImDrawList_AddTriangle" ---;
    draw_list_add_triangle_filled :: proc        (list : ^DrawList, a : Vec2, b : Vec2, c : Vec2, col : u32)                                                              #link_name "ImDrawList_AddTriangleFilled" ---;
    draw_list_add_circle :: proc                 (list : ^DrawList, centre : Vec2, radius : f32, col : u32, num_segments : i32, thickness : f32)                          #link_name "ImDrawList_AddCircle" ---;
    draw_list_add_circle_filled :: proc          (list : ^DrawList, centre : Vec2, radius : f32, col : u32, num_segments : i32)                                           #link_name "ImDrawList_AddCircleFilled" ---;

    //@TODO(Hoej); Figure that shit out
    draw_list_add_text :: proc                   (list : ^DrawList, pos : Vec2, col : u32, text_begin : Cstring, text_end : Cstring)                                                                              #link_name "ImDrawList_AddText" ---;
    draw_list_add_text_ext :: proc               (list : ^DrawList, font : ^Font, font_size : f32, pos : Vec2, col : u32, text_begin : Cstring, text_end : Cstring, wrap_width : f32, cpu_fine_clip_rect : ^Vec4) #link_name "ImDrawList_AddTextExt" ---;

    draw_list_add_image :: proc                  (list : ^DrawList, user_texture_id : TextureID, a : Vec2, b : Vec2, uv0 : Vec2, uv1 : Vec2, col : u32)               #link_name "ImDrawList_AddImage" ---;
    draw_list_add_poly_line :: proc              (list : ^DrawList, points : ^Vec2, num_points : i32, col : u32, closed : bool, thickness : f32, anti_aliased : bool) #link_name "ImDrawList_AddPolyline" ---;
    draw_list_add_convex_poly_filled :: proc     (list : ^DrawList, points : ^Vec2, num_points : i32, col : u32, anti_aliased : bool)                                 #link_name "ImDrawList_AddConvexPolyFilled" ---;
    draw_list_add_bezier_curve :: proc           (list : ^DrawList, pos0 : Vec2, cp0 : Vec2, cp1 : Vec2, pos1 : Vec2, col : u32, thickness : f32, num_segments : i32) #link_name "ImDrawList_AddBezierCurve" ---;

    // Stateful path API, add points then finish with PathFill() or PathStroke()
    draw_list_path_clear :: proc                  (list : ^DrawList)                                                                            #link_name "ImDrawList_PathClear" ---;
    draw_list_path_line_to :: proc                (list : ^DrawList, pos : Vec2)                                                                #link_name "ImDrawList_PathLineTo" ---;
    draw_list_path_line_to_merge_duplicate :: proc(list : ^DrawList, pos : Vec2)                                                                #link_name "ImDrawList_PathLineToMergeDuplicate" ---;
    draw_list_path_fill :: proc                   (list : ^DrawList, col : u32)                                                                 #link_name "ImDrawList_PathFill" ---;
    draw_list_path_stroke :: proc                 (list : ^DrawList, col : u32, closed : bool, thickness : f32)                                 #link_name "ImDrawList_PathStroke" ---;
    draw_list_path_arc_to :: proc                 (list : ^DrawList, centre : Vec2, radius : f32, a_min : f32, a_max : f32, num_segments : i32) #link_name "ImDrawList_PathArcTo" ---;
    draw_list_path_arc_to_fast :: proc            (list : ^DrawList, centre : Vec2, radius : f32, a_min_of_12 : i32, a_max_of_12 : i32)         #link_name "ImDrawList_PathArcToFast" ---; // Use precomputed angles for a 12 steps circle
    draw_list_path_bezier_curve_to :: proc        (list : ^DrawList, p1 : Vec2, p2 : Vec2, p3 : Vec2, num_segments : i32)                       #link_name "ImDrawList_PathBezierCurveTo" ---;
    draw_list_path_rect :: proc                   (list : ^DrawList, rect_min : Vec2, rect_max : Vec2, rounding : f32, rounding_corners : i32)  #link_name "ImDrawList_PathRect" ---;

    // Channels
    draw_list_channels_split :: proc      (list : ^DrawList, channels_count : i32) #link_name "ImDrawList_ChannelsSplit" ---;
    draw_list_channels_merge :: proc      (list : ^DrawList)                       #link_name "ImDrawList_ChannelsMerge" ---;
    draw_list_channels_set_current :: proc(list : ^DrawList, channel_index : i32)  #link_name "ImDrawList_ChannelsSetCurrent" ---;

    // Advanced
    // Your rendering function must check for 'UserCallback' in ImDrawCmd and call the function instead of rendering triangles.
    draw_list_add_callback :: proc     (list : ^DrawList, callback : draw_callback, callback_data : rawptr)                                                     #link_name "ImDrawList_AddCallback" ---;
    // This is useful if you need to forcefully create a new draw call(to allow for dependent rendering / blending). Otherwise primitives are merged into the same draw-call as much as possible
    draw_list_add_draw_cmd :: proc     (list : ^DrawList)                                                                                                       #link_name "ImDrawList_AddDrawCmd" ---;
    // Internal helpers
    draw_list_prim_reserve :: proc     (list : ^DrawList, idx_count : i32, vtx_count : i32)                                                                     #link_name "ImDrawList_PrimReserve" ---;
    draw_list_prim_rect :: proc        (list : ^DrawList, a : Vec2, b : Vec2, col : u32)                                                                        #link_name "ImDrawList_PrimRect" ---;
    draw_list_prim_rectuv :: proc      (list : ^DrawList, a : Vec2, b : Vec2, uv_a : Vec2, uv_b : Vec2, col : u32)                                              #link_name "ImDrawList_PrimRectUV" ---;
    draw_list_prim_quaduv :: proc      (list : ^DrawList,a : Vec2, b : Vec2, c : Vec2, d : Vec2, uv_a : Vec2, uv_b : Vec2, uv_c : Vec2, uv_d : Vec2, col : u32) #link_name "ImDrawList_PrimQuadUV" ---;
    draw_list_prim_writevtx :: proc    (list : ^DrawList, pos : Vec2, uv : Vec2, col : u32)                                                                     #link_name "ImDrawList_PrimWriteVtx" ---;
    draw_list_prim_writeidx :: proc    (list : ^DrawList, idx : DrawIdx)                                                                                        #link_name "ImDrawList_PrimWriteIdx" ---;
    draw_list_prim_vtx :: proc         (list : ^DrawList, pos : Vec2, uv : Vec2, col : u32)                                                                     #link_name "ImDrawList_PrimVtx" ---;
    draw_list_update_clip_rect :: proc (list : ^DrawList)                                                                                                       #link_name "ImDrawList_UpdateClipRect" ---;
    draw_list_update_texture_id :: proc(list : ^DrawList)                                                                                                       #link_name "ImDrawList_UpdateTextureID" ---;
}