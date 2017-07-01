/*
 *  @Name:     imgui
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    hjortshoej@handmade.network
 *  @Creation: 10-05-2017 21:11:30
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 17-06-2017 13:50:14
 *  
 *  @Description:
 *      Wrapper for Dear ImGui.
 */
foreign_library "cimgui.lib";
import "fmt.odin";
import "strings.odin"; //@TODO(Hoej): remove the need for

type DrawIdx   u16;
type Wchar     u16;
type TextureID rawptr;
type GuiId     u32;
type Cstring   ^u8; // Just for clarity

type GuiTextEditCallbackData struct #ordered {
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

type GuiSizeConstraintCallbackData struct #ordered {
    user_date    : rawptr,
    pos          : Vec2,
    current_size : Vec2,
    desired_size : Vec2,
}

type DrawCmd struct #ordered {
    elem_count         : u32,
    clip_rect          : Vec4,
    texture_id         : TextureID,
    user_callback      : draw_callback,
    user_callback_data : rawptr,
}

type Vec2 struct #ordered {
    x : f32,
    y : f32,
}

type Vec4 struct #ordered {
    x : f32,
    y : f32,
    z : f32,
    w : f32,
}

type DrawVert struct #ordered {
    pos : Vec2,
    uv  : Vec2,
    col : u32,
}

type DrawData struct #ordered {
    valid           : bool,
    cmd_lists       : ^^DrawList,
    cmd_lists_count : i32,
    total_vtx_count : i32,
    total_idx_count : i32,
}

type Font       struct #ordered {}
type GuiStorage struct #ordered {}
type GuiContext struct #ordered {}
type FontAtlas  struct #ordered {}
type DrawList   struct #ordered {}

type FontConfig struct #ordered {
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

type GuiStyle struct #ordered {
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

type GuiIO struct #ordered {
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

type gui_text_edit_callback       proc(data : ^GuiTextEditCallbackData) -> i32 #cc_c;
type gui_size_constraint_callback proc(data : ^GuiSizeConstraintCallbackData) #cc_c;
type draw_callback                proc(parent_list : ^DrawList, cmd : ^DrawCmd) #cc_c;

type GuiWindowFlags enum i32 {
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

type GuiInputTextFlags enum i32 {
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

type GuiTreeNodeFlags enum i32 {
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

type GuiSelectableFlags enum {
    DontClosePopups           = 1 << 0,
    SpanAllColumns            = 1 << 1,
    AllowDoubleClick          = 1 << 2
}

type GuiKey enum i32 {
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

type GuiCol enum i32 {
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

type GuiStyleVar enum i32 {
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

type GuiAlign enum i32 {
    Left     = 1 << 0,
    Center   = 1 << 1,
    Right    = 1 << 2,
    Top      = 1 << 3,
    VCenter  = 1 << 4,
    Default  = Left | Top
}

type GuiColorEditMode enum i32 {
    UserSelect           = -2,
    UserSelectShowButton = -1,
    RGB                  = 0,
    HSV                  = 1,
    HEX                  = 2
}

type GuiMouseCursor enum i32 {
    Arrow = 0,
    TextInput,
    Move,
    ResizeNS,
    ResizeEW,
    ResizeNESW,
    ResizeNWSE,
    Count_
}

type GuiSetCond enum i32 {
    Always        = 1 << 0,
    Once          = 1 << 1,
    FirstUseEver  = 1 << 2,
    Appearing     = 1 << 3
}

///////////////////////// Odin UTIL /////////////////////////

const {
    _LABEL_BUF_SIZE        = 4096;
    _TEXT_BUF_SIZE         = 4096;
    _DISPLAY_FMT_BUF_SIZE  = 256;
    _MISC_BUF_SIZE         = 1024;
}

#thread_local var _text_buf        : [_TEXT_BUF_SIZE       ]u8;
#thread_local var _label_buf       : [_LABEL_BUF_SIZE      ]u8;
#thread_local var _display_fmt_buf : [_DISPLAY_FMT_BUF_SIZE]u8;
#thread_local var _misc_buf        : [_MISC_BUF_SIZE       ]u8;

proc _make_text_string       (fmt_: string, args: ..any) -> Cstring {
    var s = fmt.bprintf(_text_buf[..], fmt_, ..args);
    _text_buf[len(s)] = 0;
    return &_text_buf[0];
}

proc _make_label_string      (label : string) -> Cstring {
    var s = fmt.bprintf(_label_buf[..], "%s", label);
    _label_buf[len(s)] = 0;
    return &_label_buf[0];
}

proc _make_display_fmt_string(display_fmt : string) -> Cstring {
    var s = fmt.bprintf(_display_fmt_buf[..], "%s", display_fmt);
    _display_fmt_buf[len(s)] = 0;
    return &_display_fmt_buf[0];
}

proc _make_misc_string       (misc : string) -> Cstring {
    var s = fmt.bprintf(_misc_buf[..], "%s", misc);
    _misc_buf[len(s)] = 0;
    return &_misc_buf[0];
}

//////////////////////// Functions ////////////////////////
foreign cimgui {
    proc get_io             () -> ^GuiIO      #link_name "igGetIO";
    proc get_style          () -> ^GuiStyle   #link_name "igGetStyle";
    proc get_draw_data      () -> ^DrawData   #link_name "igGetDrawData";
    proc new_frame          ()                #link_name "igNewFrame";
    proc render             ()                #link_name "igRender";
    proc shutdown           ()                #link_name "igShutdown";
    proc show_user_guide    ()                #link_name "igShowUserGuide";
    proc show_style_editor  (ref : ^GuiStyle) #link_name "igShowStyleEditor";
    proc show_test_window   (opened : ^bool)  #link_name "igShowTestWindow";
    proc show_metrics_window(opened : ^bool)  #link_name "igShowMetricsWindow";
}


///////////// Window
proc begin                          (name : string, open : ^bool = nil, flags : GuiWindowFlags = 0) -> bool {
    return im_begin(_make_label_string(name), open, flags);
}
proc begin_child                    (str_id : string) -> bool {
    return begin_child(str_id, Vec2{0, 0}, false, GuiWindowFlags(0));
}
proc begin_child                    (str_id : string, size : Vec2, border : bool, extra_flags : GuiWindowFlags) -> bool {
    return im_begin_child(_make_label_string(str_id), size, border, extra_flags);
}
    
foreign cimgui {
    proc im_begin                       (name : Cstring, p_open : ^bool, flags : GuiWindowFlags) -> bool                     #link_name "igBegin";
    proc im_begin_child                 (str_id : Cstring, size : Vec2, border : bool, extra_flags : GuiWindowFlags) -> bool #link_name "igBeginChild";
    proc begin_child_ex                 (id : GuiId, size : Vec2, border : bool, extra_flags : GuiWindowFlags) -> bool       #link_name "igBeginChildEx";
    proc end                            ()                                                                                   #link_name "igEnd";
    proc end_child                      ()                                                                                   #link_name "igEndChild";
    proc get_content_region_max         (out : ^Vec2)                                                                        #link_name "igGetContentRegionMax";
    proc get_content_region_avail       (out : ^Vec2)                                                                        #link_name "igGetContentRegionAvail";
    proc get_content_region_avail_width () -> f32                                                                            #link_name "igGetContentRegionAvailWidth";
    proc get_window_content_region_min  (out : ^Vec2)                                                                        #link_name "igGetWindowContentRegionMin";
    proc get_window_content_region_max  (out : ^Vec2)                                                                        #link_name "igGetWindowContentRegionMax";
    proc get_window_content_region_width() -> f32                                                                            #link_name "igGetWindowContentRegionWidth";
    proc get_window_draw_list           () -> ^DrawList                                                                      #link_name "igGetWindowDrawList";
    proc get_window_pos                 (out : ^Vec2)                                                                        #link_name "igGetWindowPos";
    proc get_window_size                (out : ^Vec2)                                                                        #link_name "igGetWindowSize";
    proc get_window_width               () -> f32                                                                            #link_name "igGetWindowWidth";
    proc get_window_height              () -> f32                                                                            #link_name "igGetWindowHeight";
    proc is_window_collapsed            () -> bool                                                                           #link_name "igIsWindowCollapsed";
    proc set_window_font_scale          (scale : f32)                                                                        #link_name "igSetWindowFontScale";
}

proc get_window_size                () -> Vec2 {
    var out : Vec2;
    get_window_size(&out);
    return out;
}
proc get_window_pos                 () -> Vec2 {
    var out : Vec2;
    get_window_pos(&out);
    return out;
}

proc set_window_collapsed            (name : string, collapsed : bool, cond : GuiSetCond) {
    im_set_window_collapsed(_make_label_string(name), collapsed, cond);
}
proc set_window_size                 (name : string, size : Vec2, cond : GuiSetCond) {
    im_set_window_size(_make_label_string(name), size, cond);
}
proc set_window_focus                (name : string) {
    im_set_window_focus(_make_label_string(name));
}
proc set_window_pos_by_name          (name : string, pos : Vec2, cond : GuiSetCond) {
    im_set_window_pos_by_name(_make_label_string(name), pos, cond);
}
foreign cimgui {
    proc im_set_window_collapsed(name : Cstring, collapsed : bool, cond : GuiSetCond) #link_name "igSetWindowCollapsed2";
    proc im_set_window_size(name : Cstring, size : Vec2, cond : GuiSetCond)           #link_name "igSetWindowSize2";
    proc im_set_window_focus(name : Cstring)                                          #link_name "igSetWindowFocus2";
    proc im_set_window_pos_by_name(name : Cstring, pos : Vec2, cond : GuiSetCond)     #link_name "igSetWindowPosByName";
}

foreign cimgui {
    proc set_next_window_pos             (pos : Vec2, cond : GuiSetCond)                                                                                   #link_name "igSetNextWindowPos";
    proc set_next_window_pos_center      (cond : GuiSetCond)                                                                                               #link_name "igSetNextWindowPosCenter";
    proc set_next_window_size            (size : Vec2, cond : GuiSetCond)                                                                                  #link_name "igSetNextWindowSize";
    proc set_next_window_size_constraints(size_min : Vec2, size_max : Vec2, custom_callback : gui_size_constraint_callback, custom_callback_data : rawptr) #link_name "igSetNextWindowSizeConstraints";
    proc set_next_window_content_size    (size : Vec2)                                                                                                     #link_name "igSetNextWindowContentSize";
    proc set_next_window_content_width   (width : f32)                                                                                                     #link_name "igSetNextWindowContentWidth";
    proc set_next_window_collapsed       (collapsed : bool, cond : GuiSetCond)                                                                             #link_name "igSetNextWindowCollapsed";
    proc set_next_window_focus           ()                                                                                                                #link_name "igSetNextWindowFocus";
    proc set_window_pos                  (pos : Vec2, cond : GuiSetCond)                                                                                   #link_name "igSetWindowPos";
    proc set_window_size                 (size : Vec2, cond : GuiSetCond)                                                                                  #link_name "igSetWindowSize";
    proc set_window_collapsed            (collapsed : bool, cond : GuiSetCond)                                                                             #link_name "igSetWindowCollapsed";
    proc set_window_focus                ()                                                                                                                #link_name "igSetWindowFocus";

    proc get_scroll_x           () -> f32                           #link_name "igGetScrollX";
    proc get_scroll_y           () -> f32                           #link_name "igGetScrollY";
    proc get_scroll_max_x       () -> f32                           #link_name "igGetScrollMaxX";
    proc get_scroll_max_y       () -> f32                           #link_name "igGetScrollMaxY";
    proc set_scroll_x           (scroll_x : f32)                    #link_name "igSetScrollX";
    proc set_scroll_y           (scroll_y : f32)                    #link_name "igSetScrollY";
    proc set_scroll_here        (center_y_ratio : f32)              #link_name "igSetScrollHere";
    proc set_scroll_from_pos_y  (pos_y : f32, center_y_ratio : f32) #link_name "igSetScrollFromPosY";
    proc set_keyboard_focus_here(offset : i32)                      #link_name "igSetKeyboardFocusHere";

    proc set_state_storage      (tree : ^GuiStorage) #link_name "igSetStateStorage";
    proc get_state_storage      () -> ^GuiStorage    #link_name "igGetStateStorage";

    // Parameters stacks (shared)
    proc push_font                  (font : ^Font)                         #link_name "igPushFont";
    proc pop_font                   ()                                     #link_name "igPopFont";
    proc push_style_color           (idx : GuiCol, col : Vec4)             #link_name "igPushStyleColor";
    proc pop_style_color            (count : i32)                          #link_name "igPopStyleColor";
    proc push_style_var             (idx : GuiStyleVar, val : f32)         #link_name "igPushStyleVar";
    proc push_style_var_vec         (idx : GuiStyleVar, val : Vec2)        #link_name "igPushStyleVarVec";
    proc pop_style_var              (count : i32)                          #link_name "igPopStyleVar";
    proc get_font                   () -> ^Font                            #link_name "igGetFont";
    proc get_font_size              () -> f32                              #link_name "igGetFontSize";
    proc get_font_tex_uv_white_pixel(pOut : ^Vec2)                         #link_name "igGetFontTexUvWhitePixel";
    proc get_color_u32              (idx : GuiCol, alpha_mul : f32) -> u32 #link_name "igGetColorU32";
    proc get_color_u32_vec          (col : ^Vec4) -> u32                   #link_name "igGetColorU32Vec";

    // Parameters stacks (current window)
    proc push_item_width          (item_width : f32) #link_name "igPushItemWidth";
    proc pop_item_width           ()                 #link_name "igPopItemWidth";
    proc calc_item_width          () -> f32          #link_name "igCalcItemWidth";
    proc push_text_wrap_pos       (wrap_pos_x : f32) #link_name "igPushTextWrapPos";
    proc pop_text_wrap_pos        ()                 #link_name "igPopTextWrapPos";
    proc push_allow_keyboard_focus(v : bool)         #link_name "igPushAllowKeyboardFocus";
    proc pop_allow_keyboard_focus ()                 #link_name "igPopAllowKeyboardFocus";
    proc push_button_repeat       (repeat : bool)    #link_name "igPushButtonRepeat";
    proc pop_button_repeat        ()                 #link_name "igPopButtonRepeat";

    // Layout
    proc separator                         ()                                      #link_name "igSeparator";
    proc same_line                         (pos_x : f32 = 0, spacing_w : f32 = -1) #link_name "igSameLine";
    proc new_line                          ()                                      #link_name "igNewLine";
    proc spacing                           ()                                      #link_name "igSpacing";
    proc dummy                             (size : ^Vec2)                          #link_name "igDummy";
    proc indent                            (indent_w : f32 = 0.0)                  #link_name "igIndent";
    proc unindent                          (indent_w : f32 = 0.0)                  #link_name "igUnindent";
    proc begin_group                       ()                                      #link_name "igBeginGroup";
    proc end_group                         ()                                      #link_name "igEndGroup";
    proc get_cursor_pos                    (pOut : ^Vec2)                          #link_name "igGetCursorPos";
    proc get_cursor_pos_x                  () -> f32                               #link_name "igGetCursorPosX";
    proc get_cursor_pos_y                  () -> f32                               #link_name "igGetCursorPosY";
    proc set_cursor_pos                    (local_pos : Vec2)                      #link_name "igSetCursorPos";
    proc set_cursor_pos_x                  (x : f32)                               #link_name "igSetCursorPosX";
    proc set_cursor_pos_y                  (y : f32)                               #link_name "igSetCursorPosY";
    proc get_cursor_start_pos              (pOut : ^Vec2)                          #link_name "igGetCursorStartPos";
    proc get_cursor_screen_pos             (pOut : ^Vec2)                          #link_name "igGetCursorScreenPos";
    proc set_cursor_screen_pos             (pos : Vec2)                            #link_name "igSetCursorScreenPos";
    proc align_first_text_height_to_widgets()                                      #link_name "igAlignFirstTextHeightToWidgets";
    proc get_text_line_height              () -> f32                               #link_name "igGetTextLineHeight";
    proc get_text_line_height_with_spacing () -> f32                               #link_name "igGetTextLineHeightWithSpacing";
    proc get_items_line_height_with_spacing() -> f32                               #link_name "igGetItemsLineHeightWithSpacing";
}
proc get_cursor_pos                    () -> Vec2 {
    var out : Vec2;
    get_cursor_pos(&out);
    return out;
}
proc get_cursor_start_pos              () -> Vec2 {
    var out : Vec2;
    get_cursor_start_pos(&out);
    return out;
}
proc get_cursor_screen_pos             () -> Vec2 {
    var out : Vec2;
    get_cursor_screen_pos(&out);
    return out;
}

//Columns
proc columns          (count : i32, id : string = "", border : bool = true) {
    im_columns(count, _make_label_string(id), border);
}
foreign cimgui {
    proc im_columns(count : i32, id : Cstring, border : bool)  #link_name "igColumns";
    proc next_column      ()                                   #link_name "igNextColumn";
    proc get_column_index () -> i32                            #link_name "igGetColumnIndex";
    proc get_column_offset(column_index : i32) -> f32          #link_name "igGetColumnOffset";
    proc set_column_offset(column_index : i32, offset_x : f32) #link_name "igSetColumnOffset";
    proc get_column_width (column_index : i32) -> f32          #link_name "igGetColumnWidth";
    proc get_columns_count() -> i32                            #link_name "igGetColumnsCount";

    // ID scopes
    // If you are creating widgets in a loop you most likely want to push a unique identifier so ImGui can differentiate them
    // You can also use "##extra" within your widget name to distinguish them from each others (see 'Programmer Guide')
    //@TODO(Hoej): Figure out what to do here
    proc push_id_str      (str_id : Cstring)                                #link_name "igPushIdStr";
    proc push_id_str_range(str_begin : Cstring, str_end : Cstring)          #link_name "igPushIdStrRange";
    proc get_id_str       (str_id : Cstring) -> GuiId                       #link_name "igGetIdStr";
    proc get_id_str_range (str_begin : Cstring, str_end : Cstring) -> GuiId #link_name "igGetIdStrRange";

    proc push_id_ptr      (ptr_id : rawptr)          #link_name "igPushIdPtr";
    proc push_id_int      (int_id : i32)             #link_name "igPushIdInt";
    proc pop_id           ()                         #link_name "igPopId";
    proc get_id_ptr       (ptr_id : rawptr) -> GuiId #link_name "igGetIdPtr";
}

/////// Text
proc text           (fmt_: string, args: ..any) {
    im_text(_make_text_string(fmt_, ..args));
}
proc text_colored   (col : Vec4, fmt_: string, args: ..any) {
    im_text_colored(col, _make_text_string(fmt_, ..args));
}
proc text_disabled  (fmt_: string, args: ..any) {
    im_text_disabled(_make_text_string(fmt_, ..args));
}
proc text_wrapped   (fmt_: string, args: ..any) {
    im_text_wrapped(_make_text_string(fmt_, ..args));
}
proc label_text     (label : string, fmt_ : string, args : ..any) {
    im_label_text(_make_label_string(label), _make_text_string(fmt_, ..args));
}
proc bullet_text    (fmt_: string, args: ..any) {
    im_bullet_text(_make_text_string(fmt_, ..args));
}
foreign cimgui {
    proc im_text         (fmt: ^u8) #cc_c                  #link_name "igText"; 
    proc im_text_colored (col : Vec4, fmt_ : ^u8) #cc_c    #link_name "igTextColored";
    proc im_text_disabled(fmt_ : ^u8)                      #link_name "igTextDisabled";
    proc im_text_wrapped (fmt: ^u8)                        #link_name "igTextWrapped";
    proc im_label_text   (label : Cstring, fmt_ : Cstring) #link_name "igLabelText";
    proc im_bullet_text  (fmt_ : Cstring)                  #link_name "igBulletText";

    proc TextUnformatted(text : Cstring, text_end : Cstring) #link_name "igTextUnformatted";
    proc bullet         ()                                   #link_name "igBullet";
}

//@TODO(Hoej): Figure out what to do here.


///// Buttons
proc button          (label : string) -> bool {
    return button(label, Vec2{0, 0}); //TODO Ask Bill if it's intentional that this can't be a default parameter
}
proc button          (label : string, size : Vec2) -> bool {
    foreign cimgui proc im_button(label : Cstring, size : Vec2) -> bool #link_name "igButton";
    return im_button(_make_label_string(label), size);
}
proc small_button    (label : string) -> bool {
    foreign cimgui proc im_small_button(label : Cstring) -> bool #link_name "igSmallButton";
    return im_small_button(_make_label_string(label));
}
proc invisible_button(str_id : string, size : Vec2) -> bool {
    foreign cimgui proc im_invisible_button(str_id : Cstring, size : Vec2) -> bool #link_name "igInvisibleButton";
    return im_invisible_button(_make_label_string(str_id), size);
}
foreign cimgui proc image_button    (user_texture_id : TextureID, size : Vec2, uv0 : Vec2, uv1 : Vec2, frame_padding : i32, bg_col : Vec4, tint_col : Vec4) -> bool #link_name "igImageButton";

proc image             (user_texture_id : TextureID, size : Vec2) {
    image(user_texture_id, size, Vec2{0, 0}, Vec2{1, 1}, Vec4{1, 1, 1, 1}, Vec4{0, 0, 0, 0}); //TODO Ask Bill if it's intentional that this can't be a default parameter
}
foreign cimgui proc image             (user_texture_id : TextureID, size : Vec2, uv0 : Vec2, uv1 : Vec2, tint_col : Vec4, border_col : Vec4) #link_name "igImage";

proc checkbox          (label : string, v : ^bool) -> bool {
    foreign cimgui proc im_checkbox(label : Cstring, v : ^bool) -> bool #link_name "igCheckbox";
    return im_checkbox(_make_label_string(label), v);
}
proc checkbox_flags    (label : string, flags : ^u32, flags_value : u32) -> bool {
    foreign cimgui proc im_checkbox_flags(label : Cstring, flags : ^u32, flags_value : u32) -> bool #link_name "igCheckboxFlags";
    return im_checkbox_flags(_make_label_string(label), flags, flags_value);
}

proc radio_buttons_bool(label : string, active : bool) -> bool {
    foreign cimgui proc im_radio_buttons_bool(label : Cstring, active : bool) -> bool #link_name "igRadioButtonBool";
    return im_radio_buttons_bool(_make_label_string(label), active);
}
proc radio_button      (label : string, v : ^i32, v_button : i32) -> bool {
    foreign cimgui proc im_radio_button(label : Cstring, v : ^i32, v_button : i32) -> bool #link_name "igRadioButton";
    return im_radio_button(_make_label_string(label), v, v_button);
}

proc combo             (label : string, current_item : ^i32, items : []string, height_in_items : i32 = -1) -> bool {
    foreign cimgui proc im_combo(label : Cstring, current_item : ^i32, items : ^^u8, items_count : i32, height_in_items : i32) -> bool #link_name "igCombo";

    var data = make([]^u8, len(items)); defer free(data);
    for item, idx in items {
        data[idx] = strings.new_c_string(item);
    } //@TODO(Hoej): Change this to stack buffers.

    return im_combo(_make_label_string(label), current_item, &data[0], i32(len(items)), height_in_items); 
}
//@TODO(Hoej): Get this shit straight
foreign cimgui proc combo2            (label : Cstring, current_item : ^i32, items_separated_by_zeros : Cstring, height_in_items : i32) -> bool #link_name "igCombo2";
foreign cimgui proc combo3            (label : Cstring, current_item : ^i32, items_getter : proc(data : rawptr, idx : i32, out_text : ^^u8) -> bool #cc_c, data : rawptr, items_count : i32, height_in_items : i32) -> bool #link_name "igCombo3";
//@TODO(Hoej): Get this shit straight
foreign cimgui proc color_button      (col : Vec4, small_height : bool, outline_border : bool) -> bool #link_name "igColorButton";

proc color_edit        (label : string, col : ^[3]f32) -> bool {
    foreign cimgui proc im_color_edit3(label : Cstring, col : ^f32) -> bool #link_name "igColorEdit3";
    return im_color_edit3(_make_label_string(label), &col[0]);    
}
proc color_edit        (label : string, col : ^[4]f32) -> bool {
    foreign cimgui proc im_color_edit4(label : Cstring, col : ^f32) -> bool #link_name "igColorEdit4";
    return im_color_edit4(_make_label_string(label), &col[0]);    
}

foreign cimgui proc color_edit_mode(mode : GuiColorEditMode) #link_name "igColorEditMode";
//@TODO(Hoej): Get this shit straight
foreign cimgui proc plot_lines        (label : Cstring, values : ^f32, values_count : i32, values_offset : i32, overlay_text : Cstring, scale_min : f32, scale_max : f32, graph_size : Vec2, stride : i32) #link_name "igPlotLines";
foreign cimgui proc plot_lines2       (label : Cstring, values_getter : proc(data : rawptr, idx : i32) -> f32, data : rawptr, values_count : i32, values_offset : i32, overlay_text : Cstring, scale_min : f32, scale_max : f32, graph_size : Vec2) #link_name "igPlotLines2";

//TODO figure out what if this can't be replaced with default params
proc plot_histogram    (label : string, values : []f32, scale_min : f32, scale_max : f32, graph_size : Vec2) {
    plot_histogram(label, values, "\x00", scale_min, scale_max, graph_size, size_of(f32));
}
proc plot_histogram    (label : string, values : []f32, overlay_text : string, scale_min : f32, scale_max : f32, graph_size : Vec2) {
    plot_histogram(label, values, overlay_text, scale_min, scale_max, graph_size, size_of(f32));
}
proc plot_histogram    (label : string, values : []f32, overlay_text : string, scale_min : f32, scale_max : f32, graph_size : Vec2, stride : i32) {
    foreign cimgui proc im_plot_histogram    (label : Cstring, values : ^f32, values_count : i32, values_offset : i32, overlay_text : Cstring, scale_min : f32, scale_max : f32, graph_size : Vec2, stride : i32) #link_name "igPlotHistogram";

    im_plot_histogram(_make_label_string(label), &values[0], i32(len(values)), 0, _make_misc_string(overlay_text), scale_min, scale_max, graph_size, stride);
}

foreign cimgui proc plot_histogram2   (label : Cstring, values_getter : proc(data : rawptr, idx : i32) -> f32, data : rawptr, values_count : i32, values_offset : i32, overlay_text : Cstring, scale_min : f32, scale_max : f32, graph_size : Vec2) #link_name "igPlotHistogram2";

proc progress_bar      (fraction : f32, size_arg : ^Vec2, overlay : string = "") {
    foreign cimgui proc im_progress_bar(fraction : f32, size_arg : ^Vec2, overlay : Cstring) #link_name "igProgressBar";
    im_progress_bar(fraction, size_arg, _make_misc_string(overlay));
}


// Widgets: Sliders (tip: ctrl+click on a slider to input text)
proc slider_float(label : string, v : ^f32, v_min : f32, v_max : f32, display_format : string, power : f32) -> bool {
    return im_slider_float(_make_label_string(label), v, v_min, v_max, _make_display_fmt_string(display_format), power);
}
proc slider_float(label : string, v : ^[2]f32, v_min : f32, v_max : f32, display_format : string, power : f32) -> bool {
    return im_slider_float2(_make_label_string(label), &v[0], v_min, v_max, _make_display_fmt_string(display_format), power);
}
proc slider_float(label : string, v : ^[3]f32, v_min : f32, v_max : f32, display_format : string, power : f32) -> bool {
    return im_slider_float2(_make_label_string(label), &v[0], v_min, v_max, _make_display_fmt_string(display_format), power);
}
proc slider_float(label : string, v : ^[4]f32, v_min : f32, v_max : f32, display_format : string, power : f32) -> bool {
    return im_slider_float2(_make_label_string(label), &v[0], v_min, v_max, _make_display_fmt_string(display_format), power);
}

proc slider_angle(label : string, v_rad : ^f32, v_degrees_min : f32, v_degrees_max : f32) -> bool {
    return im_slider_angle(_make_label_string(label),v_rad, v_degrees_min, v_degrees_max);
}

proc slider_int(label : string, v : ^i32, v_min : i32, v_max : i32, display_format : string) -> bool {
    return im_slider_int(_make_label_string(label), v, v_min, v_max, _make_display_fmt_string(display_format));
}
proc slider_int(label : string, v : ^[2]i32, v_min : i32, v_max : i32, display_format : string) -> bool {
    return im_slider_int2(_make_label_string(label), &v[0], v_min, v_max, _make_display_fmt_string(display_format));
}
proc slider_int(label : string, v : ^[3]i32, v_min : i32, v_max : i32, display_format : string) -> bool {
    return im_slider_int3(_make_label_string(label), &v[0], v_min, v_max, _make_display_fmt_string(display_format));
}
proc slider_int(label : string, v : ^[4]i32, v_min : i32, v_max : i32, display_format : string) -> bool {
    return im_slider_int4(_make_label_string(label), &v[0], v_min, v_max, _make_display_fmt_string(display_format));
}

proc vslider_float(label : string, size : Vec2, v : ^f32, v_min : f32 , v_max : f32, display_format : string, power : f32) -> bool {
    return im_vslider_float(_make_label_string(label), size, v, v_min, v_max, _make_display_fmt_string(display_format), power);
}

proc vslider_int(label : string, size : Vec2, v : ^i32, v_min : i32, v_max : i32, display_format : string) -> bool {
    return im_vslider_int(_make_label_string(label), size, v, v_min, v_max, _make_display_fmt_string(display_format));
}


// Widgets: Drags (tip: ctrl+click on a drag box to input text)
proc drag_float(label : string, v : ^f32, v_speed : f32, v_min : f32, v_max : f32, display_format : string, power : f32) {
    im_drag_float(_make_label_string(label), v, v_speed, v_min, v_max, _make_display_fmt_string(display_format), power);
}
proc drag_float(label : string, v : ^[2]f32, v_speed : f32, v_min : f32, v_max : f32, display_format : string, power : f32) -> bool {
    return im_drag_float2(_make_label_string(label), &v[0], v_speed, v_min, v_max, _make_display_fmt_string(display_format), power);
}
proc drag_float(label : string, v : ^[3]f32, v_speed : f32, v_min : f32, v_max : f32, display_format : string, power : f32) -> bool {
    return im_drag_float3(_make_label_string(label), &v[0], v_speed, v_min, v_max, _make_display_fmt_string(display_format), power);
}
proc drag_float(label : string, v : ^[4]f32, v_speed : f32, v_min : f32, v_max : f32, display_format : string, power : f32) -> bool {
    return im_drag_float4(_make_label_string(label), &v[0], v_speed, v_min, v_max, _make_display_fmt_string(display_format), power);
}

proc drag_float_range(label : string, v_current_min, v_current_max : ^f32, v_speed, v_min, v_max : f32, display_format, display_format_max : string, power : f32) -> bool {
    var id  = _make_label_string(label);
    var df  = _make_display_fmt_string(display_format);
    var mdf = _make_misc_string(display_format_max);
    return im_drag_float_range(id, v_current_min, v_current_max, v_speed, v_min, v_max, df, mdf, power);
}

proc drag_int(label : string, v : ^i32, v_speed : f32, v_min : i32, v_max : i32, display_format : string) {
    im_drag_int(_make_label_string(label), v, v_speed, v_min, v_max, _make_display_fmt_string(display_format));
}
proc drag_int(label : string, v : ^[2]i32, v_speed : f32, v_min : i32, v_max : i32, display_format : string) {
    im_drag_int2(_make_label_string(label), &v[0], v_speed, v_min, v_max, _make_display_fmt_string(display_format));
}
proc drag_int(label : string, v : ^[3]i32, v_speed : f32, v_min : i32, v_max : i32, display_format : string) {
    im_drag_int3(_make_label_string(label), &v[0], v_speed, v_min, v_max, _make_display_fmt_string(display_format));
}
proc drag_int(label : string, v : ^[4]i32, v_speed : f32, v_min : i32, v_max : i32, display_format : string) {
    im_drag_int4(_make_label_string(label), &v[0], v_speed, v_min, v_max, _make_display_fmt_string(display_format));
}

proc drag_int_range(label : string, v_current_min, v_current_max : ^i32, v_speed, v_min, v_max : i32, display_format, display_format_max : string) -> bool {
    var id  = _make_label_string(label);
    var df  = _make_display_fmt_string(display_format);
    var mdf = _make_misc_string(display_format_max);
    return im_drag_int_range(id, v_current_min, v_current_max, v_speed, v_min, v_max, df, mdf);
}

// Widgets: Input
proc input_text          (label : string, buf : []u8, flags : GuiInputTextFlags, callback : gui_text_edit_callback, user_data : rawptr) -> bool {
    return im_input_text(_make_label_string(label), &buf[0], u64(len(buf)), flags, callback, user_data);
}
proc input_text_multiline(label : string, buf : []u8, size : Vec2, flags : GuiInputTextFlags, callback : gui_text_edit_callback, user_data : rawptr) -> bool {
    return im_input_text_multiline(_make_label_string(label), &buf[0], u64(len(buf)), size, flags, callback, user_data);
}

proc input_float(label : string, v : ^f32, step : f32, step_fast : f32, decimal_precision : i32, extra_flags : GuiInputTextFlags) -> bool {
    return im_input_float(_make_label_string(label), v, step, step_fast, decimal_precision, extra_flags);
}
proc input_float(label : string, v : ^[2]f32, decimal_precision : i32, extra_flags : GuiInputTextFlags) -> bool {
    return im_input_float2(_make_label_string(label), &v[0], decimal_precision, extra_flags);
}
proc input_float(label : string, v : ^[3]f32, decimal_precision : i32, extra_flags : GuiInputTextFlags) -> bool {
    return im_input_float3(_make_label_string(label), &v[0], decimal_precision, extra_flags);
}
proc input_float(label : string, v : ^[4]f32, decimal_precision : i32, extra_flags : GuiInputTextFlags) -> bool {
    return im_input_float4(_make_label_string(label), &v[0], decimal_precision, extra_flags);
}

proc input_int (label : string, v : ^i32, step : i32, step_fast : i32, extra_flags : GuiInputTextFlags) -> bool {
    return im_input_int(_make_label_string(label), v, step, step_fast, extra_flags);
}
proc input_int(label : string, v : ^[2]i32, extra_flags : GuiInputTextFlags) -> bool {
    return im_input_int2(_make_label_string(label), &v[0], extra_flags);
}
proc input_int(label : string, v : ^[3]i32, extra_flags : GuiInputTextFlags) -> bool {
    return im_input_int3(_make_label_string(label), &v[0], extra_flags);
}
proc input_int(label : string, v : ^[4]i32, extra_flags : GuiInputTextFlags) -> bool {
    return im_input_int4(_make_label_string(label), &v[0], extra_flags);
}

foreign cimgui {
    proc im_slider_float (label : Cstring, v : ^f32, v_min : f32, v_max : f32, display_format : Cstring, power : f32) -> bool #link_name "igSliderFloat";
    proc im_slider_float2(label : Cstring, v : ^f32, v_min : f32, v_max : f32, display_format : Cstring, power : f32) -> bool #link_name "igSliderFloat2";
    proc im_slider_float3(label : Cstring, v : ^f32, v_min : f32, v_max : f32, display_format : Cstring, power : f32) -> bool #link_name "igSliderFloat3";
    proc im_slider_float4(label : Cstring, v : ^f32, v_min : f32, v_max : f32, display_format : Cstring, power : f32) -> bool #link_name "igSliderFloat4";
    proc im_slider_angle (label : Cstring, v_rad : ^f32, v_degrees_min : f32, v_degrees_max : f32) -> bool                    #link_name "igSliderAngle";
    
    proc im_slider_int (label : Cstring, v : ^i32, v_min : i32, v_max : i32, display_format : Cstring) -> bool #link_name "igSliderInt";
    proc im_slider_int2(label : Cstring, v : ^i32, v_min : i32, v_max : i32, display_format : Cstring) -> bool #link_name "igSliderInt2";
    proc im_slider_int3(label : Cstring, v : ^i32, v_min : i32, v_max : i32, display_format : Cstring) -> bool #link_name "igSliderInt3";
    proc im_slider_int4(label : Cstring, v : ^i32, v_min : i32, v_max : i32, display_format : Cstring) -> bool #link_name "igSliderInt4";
    
    proc im_vslider_float(label : Cstring, size : Vec2, v : ^f32, v_min : f32 , v_max : f32, display_format : Cstring, power : f32) -> bool #link_name "igVSliderFloat";
    proc im_vslider_int  (label : Cstring, size : Vec2, v : ^i32, v_min : i32, v_max : i32, display_format : Cstring) -> bool               #link_name "igVSliderInt";
    
    proc im_drag_float      (label : Cstring, v : ^f32, v_speed : f32, v_min : f32, v_max : f32, display_format : Cstring, power : f32)                                            #link_name "igDragFloat";
    proc im_drag_float2     (label : Cstring, v : ^f32, v_speed : f32, v_min : f32, v_max : f32, display_format : Cstring, power : f32) -> bool                                    #link_name "igDragFloat2";
    proc im_drag_float3     (label : Cstring, v : ^f32, v_speed : f32, v_min : f32, v_max : f32, display_format : Cstring, power : f32) -> bool                                    #link_name "igDragFloat3";
    proc im_drag_float4     (label : Cstring, v : ^f32, v_speed : f32, v_min : f32, v_max : f32, display_format : Cstring, power : f32) -> bool                                    #link_name "igDragFloat4";
    proc im_drag_float_range(label : Cstring, v_current_min, v_current_max : ^f32, v_speed, v_min, v_max : f32, display_format, display_format_max : Cstring, power : f32) -> bool #link_name "igDragFloatRange2";
    
    proc im_drag_int      (label : Cstring, v : ^i32, v_speed : f32, v_min : i32, v_max : i32, display_format : Cstring)                                            #link_name "igDragInt";
    proc im_drag_int2     (label : Cstring, v : ^i32, v_speed : f32, v_min : i32, v_max : i32, display_format : Cstring)                                            #link_name "igDragInt2";
    proc im_drag_int3     (label : Cstring, v : ^i32, v_speed : f32, v_min : i32, v_max : i32, display_format : Cstring)                                            #link_name "igDragInt3";
    proc im_drag_int4     (label : Cstring, v : ^i32, v_speed : f32, v_min : i32, v_max : i32, display_format : Cstring)                                            #link_name "igDragInt4";
    proc im_drag_int_range(label : Cstring, v_current_min, v_current_max : ^i32, v_speed, v_min, v_max : i32, display_format, display_format_max : Cstring) -> bool #link_name "igDragIntRange2";
    
    proc im_input_text          (label : Cstring, buf : Cstring, buf_size : u64 /*size_t*/, flags : GuiInputTextFlags, callback : gui_text_edit_callback, user_data : rawptr) -> bool              #link_name "igInputText";
    proc im_input_text_multiline(label : Cstring, buf : Cstring, buf_size : u64 /*size_t*/, size : Vec2, flags : GuiInputTextFlags, callback : gui_text_edit_callback, user_data : rawptr) -> bool #link_name "igInputTextMultiline";
    
    proc im_input_float (label : Cstring, v : ^f32, step : f32, step_fast : f32, decimal_precision : i32, extra_flags : GuiInputTextFlags) -> bool #link_name "igInputFloat";
    proc im_input_float2(label : Cstring, v : ^f32, decimal_precision : i32, extra_flags : GuiInputTextFlags) -> bool                              #link_name "igInputFloat2";
    proc im_input_float3(label : Cstring, v : ^f32, decimal_precision : i32, extra_flags : GuiInputTextFlags) -> bool                              #link_name "igInputFloat3";
    proc im_input_float4(label : Cstring, v : ^f32, decimal_precision : i32, extra_flags : GuiInputTextFlags) -> bool                              #link_name "igInputFloat4";
    
    proc im_input_int (label : Cstring, v : ^i32, step : i32, step_fast : i32, extra_flags : GuiInputTextFlags) -> bool #link_name "igInputInt";
    proc im_input_int2(label : Cstring, v : ^i32, extra_flags : GuiInputTextFlags) -> bool                              #link_name "igInputInt2";
    proc im_input_int3(label : Cstring, v : ^i32, extra_flags : GuiInputTextFlags) -> bool                              #link_name "igInputInt3";
    proc im_input_int4(label : Cstring, v : ^i32, extra_flags : GuiInputTextFlags) -> bool                              #link_name "igInputInt4";
}

// Widgets: Trees
proc tree_node(label : string) -> bool {
    foreign cimgui proc im_tree_node(label : Cstring) -> bool #link_name "igTreeNode";
    return im_tree_node(_make_label_string(label));
}
proc tree_node(str_id : string, fmt_ : string, args : ..any) -> bool {
    foreign cimgui proc im_tree_node_str(str_id : Cstring, fmt_ : ^u8) -> bool #link_name "igTreeNodeStr";
    return im_tree_node_str(_make_label_string(str_id), _make_text_string(fmt_, ..args));
}
proc tree_node(ptr_id : rawptr, fmt_ : string, args : ..any) -> bool {
    foreign cimgui proc im_tree_node_ptr(ptr_id : rawptr, fmt_ : ^u8) -> bool #link_name "igTreeNodePtr";
    return im_tree_node_ptr(ptr_id, _make_text_string(fmt_, ..args));
}
proc tree_node_ex(label : string, flags : GuiTreeNodeFlags) -> bool {
    foreign cimgui proc im_tree_node_ex(label : Cstring, flags : GuiTreeNodeFlags) -> bool #link_name "igTreeNodeEx";
    return im_tree_node_ex(_make_label_string(label), flags);
}
proc tree_node_ex(str_id : string, flags : GuiTreeNodeFlags, fmt_ : string, args : ..any) -> bool {
    foreign cimgui proc im_tree_node_ex_str(str_id : Cstring, flags : GuiTreeNodeFlags, fmt_ : ^u8) -> bool #link_name "igTreeNodeExStr";
    return im_tree_node_ex_str(_make_label_string(str_id), flags, _make_text_string(fmt_, ..args));
}
proc tree_node_ex(ptr_id : rawptr, flags : GuiTreeNodeFlags, fmt_ : string, args : ..any) -> bool {
    foreign cimgui proc im_tree_node_ex_ptr(ptr_id : rawptr, flags : GuiTreeNodeFlags, fmt_ : ^u8) -> bool #link_name "igTreeNodeExPtr";
    return im_tree_node_ex_ptr(ptr_id, flags, _make_text_string(fmt_, ..args));
}
proc tree_push_str(str_id : string) {
    foreign cimgui proc im_tree_push_str(str_id : Cstring) #link_name "igTreePushStr";
    im_tree_push_str(_make_label_string(str_id));
}

foreign cimgui {
    proc tree_push_ptr(ptr_id : rawptr) #link_name "igTreePushPtr";
    proc tree_pop() #link_name "igTreePop";
    proc tree_advance_to_label_pos() #link_name "igTreeAdvanceToLabelPos";
    proc get_tree_node_to_label_spacing() -> f32 #link_name "igGetTreeNodeToLabelSpacing";
    proc set_next_tree_node_open(opened : bool, cond : GuiSetCond) #link_name "igSetNextTreeNodeOpen";
}

proc collapsing_header(label : string, flags : GuiTreeNodeFlags = 0) -> bool {
    foreign cimgui proc im_collapsing_header(label : Cstring, flags : GuiTreeNodeFlags) -> bool #link_name "igCollapsingHeader";
    return im_collapsing_header(_make_label_string(label), flags);
}

proc collapsing_header_ex(label : string, p_open : ^bool, flags : GuiTreeNodeFlags) -> bool {
    foreign cimgui proc im_collapsing_header_ex(label : Cstring, p_open : ^bool, flags : GuiTreeNodeFlags) -> bool #link_name "igCollapsingHeaderEx";
    return im_collapsing_header_ex(_make_label_string(label), p_open, flags);
}

// Widgets: Selectable / Lists
proc selectable(label : string, selected : bool, flags : GuiSelectableFlags, size : Vec2) -> bool {
    foreign cimgui proc im_selectable(label : Cstring, selected : bool, flags : GuiSelectableFlags, size : Vec2) -> bool #link_name "igSelectable";
    return im_selectable(_make_label_string(label), selected, flags, size);
}

proc selectable_ex(label : string, p_selected : ^bool, flags : GuiSelectableFlags, size : Vec2) -> bool {
    foreign cimgui proc im_selectable_ex(label : Cstring, p_selected : ^bool, flags : GuiSelectableFlags, size : Vec2) -> bool #link_name "igSelectableEx";
    return im_selectable_ex(_make_label_string(label), p_selected, flags, size);
}

//@TODO(Hoej): Figure this shit out
foreign cimgui proc list_box(label : Cstring, current_item : ^i32, items : ^^u8, items_count : i32, height_in_items : i32) -> bool #link_name "igListBox";
foreign cimgui proc list_box(label : Cstring, current_item : ^i32, items_getter : proc(data : rawptr, idx : i32, out_text : ^^u8) -> bool #cc_c, data : rawptr, items_count : i32, height_in_items : i32) -> bool #link_name "igListBox2";

proc list_box_header(label : string, size : Vec2) -> bool {
    foreign cimgui proc im_list_box_header(label : Cstring, size : Vec2) -> bool #link_name "igListBoxHeader";
    return im_list_box_header(_make_label_string(label), size);
}
proc list_box_header(label : string, items_count : i32, height_in_items : i32) -> bool {
    foreign cimgui proc im_list_box_header(label : Cstring, items_count : i32, height_in_items : i32) -> bool #link_name "igListBoxHeader2";
    return im_list_box_header(_make_label_string(label), items_count, height_in_items);
}
foreign cimgui proc list_box_footer() #link_name "igListBoxFooter";

// Widgets: Value() Helpers. Output single value in "name: value" format (tip: freely declare your own within the ImGui namespace!)
proc value(prefix : string, b : bool) {
    foreign cimgui proc im_value_bool(prefix : Cstring, b : bool) #link_name "igValueBool";
    im_value_bool(_make_label_string(prefix), b);
}
proc value(prefix : string, v : i32) {
    foreign cimgui proc im_value_int(prefix : Cstring, v : i32) #link_name "igValueInt";
    im_value_int(_make_label_string(prefix), v);
}
proc value(prefix : string, v : u32) {
    foreign cimgui proc im_value_uint(prefix : Cstring, v : u32) #link_name "igValueUInt";
    im_value_uint(_make_label_string(prefix), v);
}
proc value(prefix : string, v : f32, format : string) {
    foreign cimgui proc im_value_float(prefix : Cstring, v : f32, float_format : Cstring) #link_name "igValueFloat";
    im_value_float(_make_label_string(prefix), v, _make_misc_string(format));
}
proc value(prefix : string, v : Vec4) {
    foreign cimgui proc im_value_color(prefix : Cstring, v : Vec4) #link_name "igValueColor";
    im_value_color(_make_label_string(prefix), v);
}

// Tooltip
proc set_tooltip(fmt_ : string, args : ..any) {
    foreign cimgui proc im_set_tooltip(fmt : ^u8) #link_name "igSetTooltip"; 
    im_set_tooltip(_make_text_string(fmt_, ..args));
}
foreign cimgui proc begin_tooltip() #link_name "igBeginTooltip";
foreign cimgui proc end_tooltip  () #link_name "igEndTooltip";

foreign cimgui {
    // Widgets: Menus
    proc begin_main_menu_bar() -> bool #link_name "igBeginMainMenuBar";
    proc end_main_menu_bar  () #link_name "igEndMainMenuBar";
    proc begin_menu_bar     () -> bool #link_name "igBeginMenuBar";
    proc end_menu_bar       () #link_name "igEndMenuBar";
}

proc begin_menu(label : string, enabled : bool = true) -> bool {
    foreign cimgui proc im_begin_menu(label : Cstring, enabled : bool) -> bool #link_name "igBeginMenu";
    return im_begin_menu(_make_label_string(label), enabled);
}

foreign cimgui proc end_menu() #link_name "igEndMenu";

proc menu_item(label : string, shortcut : string = "", selected : bool = false, enabled : bool = true) -> bool  {
    foreign cimgui proc im_menu_item(label : Cstring, shortcut : Cstring, selected : bool, enabled : bool) -> bool #link_name "igMenuItem";   
    return im_menu_item(_make_label_string(label), _make_misc_string(shortcut), selected, enabled);
}

proc menu_item_ptr(label : string, shortcut : string, selected : ^bool, enabled : bool) -> bool  {
    foreign cimgui proc im_menu_item_ptr(label : Cstring, shortcut : Cstring, p_selected : ^bool, enabled : bool) -> bool #link_name "igMenuItemPtr";
    return im_menu_item_ptr(_make_label_string(label), _make_misc_string(shortcut), selected, enabled);
}

// Popup
proc open_popup(str_id : string) {
    foreign cimgui proc im_open_popup(str_id : Cstring) #link_name "igOpenPopup";
    im_open_popup(_make_label_string(str_id));
}

proc begin_popup(str_id : string) -> bool {
    foreign cimgui proc im_begin_popup(str_id : Cstring) -> bool #link_name "igBeginPopup";
    return im_begin_popup(_make_label_string(str_id));
}

proc begin_popup_modal(name : string, open : ^bool, extra_flags : GuiWindowFlags) -> bool {
    foreign cimgui proc im_begin_popup_modal(name : Cstring, p_open : ^bool, extra_flags : GuiWindowFlags) -> bool #link_name "igBeginPopupModal";
    return im_begin_popup_modal(_make_label_string(name), open, extra_flags);
}

proc begin_popup_context_item(str_id : string, mouse_button : i32) -> bool {
    foreign cimgui proc im_begin_popup_context_item(str_id : Cstring, mouse_button : i32) -> bool #link_name "igBeginPopupContextItem";
    return im_begin_popup_context_item(_make_label_string(str_id), mouse_button);
}
proc begin_popup_context_window(also_over_items : bool, str_id : string, mouse_button : i32) -> bool {
    foreign cimgui proc im_begin_popup_context_window(also_over_items : bool, str_id : Cstring, mouse_button : i32) -> bool #link_name "igBeginPopupContextWindow";
    return im_begin_popup_context_window(also_over_items, _make_label_string(str_id), mouse_button);
}
proc begin_popup_context_void(str_id : string, mouse_button : i32) -> bool {
    foreign cimgui proc im_begin_popup_context_void(str_id : Cstring, mouse_button : i32) -> bool #link_name "igBeginPopupContextVoid";
    return im_begin_popup_context_void(_make_label_string(str_id), mouse_button);
}
foreign cimgui proc end_popup() #link_name "igEndPopup";
foreign cimgui proc close_current_popup() #link_name "igCloseCurrentPopup";

foreign cimgui {
    // Logging: all text output from interface is redirected to tty/file/clipboard. Tree nodes are automatically opened.
    proc log_to_tty(max_depth : i32) #link_name "igLogToTTY";
    proc log_to_file(max_depth : i32, filename : Cstring) #link_name "igLogToFile";
    proc log_to_clipboard(max_depth : i32) #link_name "igLogToClipboard";
    proc log_finish() #link_name "igLogFinish";
    proc log_buttons() #link_name "igLogButtons";
}
proc log_text(fmt_ : string, args : ..any) {
    foreign cimgui proc im_log_text(fmt_ : ^u8) #link_name "igLogText";
    im_log_text(_make_text_string(fmt_, ..args));
}

// Clipping
foreign cimgui proc push_clip_rect(clip_rect_min : Vec2, clip_rect_max : Vec2, intersect_with_current_clip_rect : bool) #link_name "igPushClipRect";
foreign cimgui proc pop_clip_rect() #link_name "igPopClipRect";

foreign cimgui {
    // Utilities
    proc is_item_hovered                    () -> bool                                                                                                 #link_name "igIsItemHovered";
    proc is_item_hovered_rect               () -> bool                                                                                                 #link_name "igIsItemHoveredRect";
    proc is_item_active                     () -> bool                                                                                                 #link_name "igIsItemActive";
    proc is_item_clicked                    (mouse_button : i32) -> bool                                                                               #link_name "igIsItemClicked";
    proc is_item_visible                    () -> bool                                                                                                 #link_name "igIsItemVisible";
    proc is_any_item_hovered                () -> bool                                                                                                 #link_name "igIsAnyItemHovered";
    proc is_any_item_active                 () -> bool                                                                                                 #link_name "igIsAnyItemActive";
    proc get_item_rect_min                  (pOut : ^Vec2)                                                                                             #link_name "igGetItemRectMin";
    proc get_item_rect_max                  (pOut : ^Vec2)                                                                                             #link_name "igGetItemRectMax";
    proc get_item_rect_size                 (pOut : ^Vec2)                                                                                             #link_name "igGetItemRectSize";
    proc set_item_allow_overlap             ()                                                                                                         #link_name "igSetItemAllowOverlap";
    proc is_window_hovered                  () -> bool                                                                                                 #link_name "igIsWindowHovered";
    proc is_window_focused                  () -> bool                                                                                                 #link_name "igIsWindowFocused";
    proc is_root_window_focused             () -> bool                                                                                                 #link_name "igIsRootWindowFocused";
    proc is_root_window_or_any_child_focused() -> bool                                                                                                 #link_name "igIsRootWindowOrAnyChildFocused";
    proc is_root_window_or_any_child_hovered() -> bool                                                                                                 #link_name "igIsRootWindowOrAnyChildHovered";
    proc is_rect_visible                    (item_size : Vec2) -> bool                                                                                 #link_name "igIsRectVisible";
    proc is_pos_hovering_any_window         (pos : Vec2) -> bool                                                                                       #link_name "igIsPosHoveringAnyWindow";
    proc get_time                           () -> f32                                                                                                  #link_name "igGetTime";
    proc get_frame_count                    () -> i32                                                                                                  #link_name "igGetFrameCount";
    proc get_style_col_name                 (idx : GuiCol) -> Cstring                                                                                 #link_name "igGetStyleColName";
    proc calc_item_rect_closest_point       (pOut : ^Vec2, pos : Vec2 , on_edge : bool, outward : f32)                                                 #link_name "igCalcItemRectClosestPoint";
    //@TODO(Hoej): Figure that shit out
    proc calc_text_size                     (pOut : ^Vec2, text : Cstring, text_end : Cstring, hide_text_after_double_hash : bool, wrap_width : f32) #link_name "igCalcTextSize";
    proc calc_list_clipping                 (items_count : i32, items_height : f32, out_items_display_start : ^i32, out_items_display_end : ^i32)      #link_name "igCalcListClipping";
}

foreign cimgui proc begin_child_frame(id : GuiId, size : Vec2, extra_flags : GuiWindowFlags) -> bool #link_name "igBeginChildFrame";
foreign cimgui proc end_child_frame  ()                                                              #link_name "igEndChildFrame";

foreign cimgui {
    proc color_convert_u32_to_float4(pOut : ^Vec4 , in_ : u32)                                            #link_name "igColorConvertU32ToFloat4";
    proc color_convert_float4_to_u32(in_ : Vec4) -> u32                                                   #link_name "igColorConvertFloat4ToU32";
    proc color_convert_rgb_to_hsv   (r : f32, g : f32, b : f32, out_h : ^f32, out_s : ^f32, out_v : ^f32) #link_name "igColorConvertRGBtoHSV";
    proc color_convert_hsv_to_rgb   (h : f32, s : f32, v : f32, out_r : ^f32, out_g : ^f32, out_b : ^f32) #link_name "igColorConvertHSVtoRGB";
}
foreign cimgui {
    proc get_key_index                         (key : GuiKey) -> i32                              #link_name "igGetKeyIndex";
    proc is_key_Down                           (key_index : i32) -> bool                          #link_name "igIsKeyDown";
    proc is_key_Pressed                        (key_index : i32, repeat : bool) -> bool           #link_name "igIsKeyPressed";
    proc is_key_Released                       (key_index : i32) -> bool                          #link_name "igIsKeyReleased";
    proc is_mouse_down                         (button : i32) -> bool                             #link_name "igIsMouseDown";
    proc is_mouse_clicked                      (button : i32, repeat : bool) -> bool              #link_name "igIsMouseClicked";
    proc is_mouse_double_clicked               (button : i32) -> bool                             #link_name "igIsMouseDoubleClicked";
    proc is_mouse_released                     (button : i32) -> bool                             #link_name "igIsMouseReleased";
    proc is_mouse_hovering_window              () -> bool                                         #link_name "igIsMouseHoveringWindow";
    proc is_mouse_hovering_any_window          () -> bool                                         #link_name "igIsMouseHoveringAnyWindow";
    proc is_mouse_hovering_rect                (r_min : Vec2, r_max : Vec2, clip : bool) -> bool  #link_name "igIsMouseHoveringRect";
    proc is_mouse_dragging                     (button : i32, lock_threshold : f32) -> bool       #link_name "igIsMouseDragging";
    proc get_mouse_pos                         (pOut : ^Vec2)                                     #link_name "igGetMousePos";
    proc get_mouse_pos_on_opening_current_popup(pOut : ^Vec2)                                     #link_name "igGetMousePosOnOpeningCurrentPopup";
    proc get_mouse_drag_delta                  (pOut : ^Vec2, button : i32, lock_threshold : f32) #link_name "igGetMouseDragDelta";
    proc reset_mouse_drag_delta                (button : i32)                                     #link_name "igResetMouseDragDelta";
    proc get_mouse_cursor                      () -> GuiMouseCursor                               #link_name "igGetMouseCursor";
    proc set_mouse_cursor                      (type_ : GuiMouseCursor)                           #link_name "igSetMouseCursor";
    proc capture_keyboard_from_app             (capture : bool)                                   #link_name "igCaptureKeyboardFromApp";
    proc capture_mouse_from_app                (capture : bool)                                   #link_name "igCaptureMouseFromApp";
}
proc get_mouse_pos       () -> Vec2 {
    var out : Vec2;
    get_mouse_pos(&out);
    return out;
}
proc get_mouse_drag_delta(button : i32 = 0, lock_threshold : f32 = -1.0) -> Vec2 {
    var out : Vec2;
    get_mouse_drag_delta(&out, button, lock_threshold);
    return out;
}

foreign cimgui {
    // Helpers functions to access functions pointers in  ::GetIO()
    proc mem_alloc         (sz : u64 /*size_t*/) -> rawptr #link_name "igMemAlloc";
    proc mem_free          (ptr : rawptr)                  #link_name "igMemFree";
    //@TODO(Hoej): Figure out if these should be wrapped
    proc get_clipboard_text() -> Cstring                   #link_name "igGetClipboardText";
    proc set_clipboard_text(text : Cstring)                #link_name "igSetClipboardText";
}

foreign cimgui {
    // Internal state access - if you want to share ImGui state between modules (e.g. DLL) or allocate it yourself
    proc get_version        () -> Cstring                                                                                     #link_name "igGetVersion";
    proc create_context     (malloc_fn : proc(size : u64 /*size_t*/) -> rawptr, free_fn : proc(data : rawptr)) -> ^GuiContext #link_name "igCreateContext";
    proc destroy_context    (ctx : ^GuiContext)                                                                               #link_name "igDestroyContext";
    proc get_current_context() -> ^GuiContext                                                                                 #link_name "igGetCurrentContext";
    proc set_current_context(ctx : ^GuiContext)                                                                               #link_name "igSetCurrentContext";
}

////////////////////////////////////// Misc    ///////////////////////////////////////////////
foreign cimgui {
    proc font_config_default_constructor(config : ^FontConfig) #link_name "ImFontConfig_DefaultConstructor";
    proc gui_io_add_input_character(c : u16)                   #link_name "ImGuiIO_AddInputCharacter";
    proc gui_io_add_input_characters_utf8(utf8_chars : ^u8)    #link_name "ImGuiIO_AddInputCharactersUTF8";
    proc gui_io_clear_input_characters()                       #link_name "ImGuiIO_ClearInputCharacters";
//////////////////////////////// FontAtlas  //////////////////////////////////////////////
    proc font_atlas_get_text_data_as_rgba32                   (atlas : ^FontAtlas, out_pixels : ^^u8, out_width : ^i32, out_height : ^i32, out_bytes_per_pixel : ^i32) #link_name "ImFontAtlas_GetTexDataAsRGBA32";
    proc font_atlas_get_text_data_as_alpha8                   (atlas : ^FontAtlas, out_pixels : ^^u8, out_width : ^i32, out_height : ^i32, out_bytes_per_pixel : ^i32) #link_name "ImFontAtlas_GetTexDataAsAlpha8";
    proc font_atlas_set_text_id                               (atlas : ^FontAtlas, tex : rawptr)                                                                       #link_name "ImFontAtlas_SetTexID";
    proc font_atlas_add_font_                                 (atlas : ^FontAtlas, font_cfg : ^FontConfig ) -> ^Font                                                   #link_name "ImFontAtlas_AddFont";
    proc font_atlas_add_font_default                          (atlas : ^FontAtlas, font_cfg : ^FontConfig ) -> ^Font                                                   #link_name "ImFontAtlas_AddFontDefault";

    proc font_atlas_add_font_from_memory_ttf                  (atlas : ^FontAtlas, ttf_data : rawptr, ttf_size : i32, size_pixels : f32, font_cfg : ^FontConfig, glyph_ranges : ^Wchar) -> ^Font                       #link_name "ImFontAtlas_AddFontFromMemoryTTF";
    proc font_atlas_add_font_from_memory_compressed_ttf       (atlas : ^FontAtlas, compressed_ttf_data : rawptr, compressed_ttf_size : i32, size_pixels : f32, font_cfg : ^FontConfig, glyph_ranges : ^Wchar) -> ^Font #link_name "ImFontAtlas_AddFontFromMemoryCompressedTTF";
    proc font_atlas_add_font_from_memory_compressed_base85_ttf(atlas : ^FontAtlas, compressed_ttf_data_base85 : Cstring, size_pixels : f32, font_cfg : ^FontConfig, glyph_ranges : ^Wchar) -> ^Font                    #link_name "ImFontAtlas_AddFontFromMemoryCompressedBase85TTF";
    proc font_atlas_clear_tex_data                            (atlas : ^FontAtlas)                                                                                                                                     #link_name "ImFontAtlas_ClearTexData";
    proc font_atlas_clear                                     (atlas : ^FontAtlas)                                                                                                                                     #link_name "ImFontAtlas_Clear";
}
proc font_atlas_add_font_from_file_ttf                    (atlas : ^FontAtlas, filename : string, size_pixels : f32, font_cfg : ^FontConfig, glyph_ranges : ^Wchar) -> ^Font {
    foreign cimgui proc im_font_atlas_add_font_from_file_ttf(atlas : ^FontAtlas, filename : Cstring, size_pixels : f32, font_cfg : ^FontConfig, glyph_ranges : ^Wchar) -> ^Font #link_name "ImFontAtlas_AddFontFromFileTTF";
    return im_font_atlas_add_font_from_file_ttf(atlas, _make_misc_string(filename), size_pixels, font_cfg, glyph_ranges);
}
//////////////////////////////// DrawList  //////////////////////////////////////////////
foreign cimgui {
    proc draw_list_get_vertex_buffer_size(list : ^DrawList) -> i32                #link_name "ImDrawList_GetVertexBufferSize";
    proc draw_list_get_vertex_ptr        (list : ^DrawList, n : i32) -> ^DrawVert #link_name "ImDrawList_GetVertexPtr";
    proc draw_list_get_index_buffer_size (list : ^DrawList) -> i32                #link_name "ImDrawList_GetIndexBufferSize";
    proc draw_list_get_index_ptr         (list : ^DrawList, n : i32) -> ^DrawIdx  #link_name "ImDrawList_GetIndexPtr";
    proc draw_list_get_cmd_size          (list : ^DrawList) -> i32                #link_name "ImDrawList_GetCmdSize";
    proc draw_list_get_cmd_ptr           (list : ^DrawList, n : i32) -> ^DrawCmd  #link_name "ImDrawList_GetCmdPtr";

    proc draw_list_clear                     (list : ^DrawList)                                                                                      #link_name "ImDrawList_Clear";
    proc draw_list_clear_free_memory         (list : ^DrawList)                                                                                      #link_name "ImDrawList_ClearFreeMemory";
    proc draw_list_push_clip_rect            (list : ^DrawList, clip_rect_min : Vec2, clip_rect_max : Vec2, intersect_with_current_clip_rect : bool) #link_name "ImDrawList_PushClipRect";
    proc draw_list_push_clip_rect_full_screen(list : ^DrawList)                                                                                      #link_name "ImDrawList_PushClipRectFullScreen";
    proc draw_list_pop_clip_rect             (list : ^DrawList)                                                                                      #link_name "ImDrawList_PopClipRect";
    proc draw_list_push_texture_id           (list : ^DrawList, texture_id : TextureID)                                                              #link_name "ImDrawList_PushTextureID";
    proc draw_list_pop_texture_id            (list : ^DrawList)                                                                                      #link_name "ImDrawList_PopTextureID";

    // Primitives
    proc draw_list_add_line                   (list : ^DrawList, a : Vec2, b : Vec2, col : u32, thickness : f32)                                                       #link_name "ImDrawList_AddLine";
    proc draw_list_add_rect                   (list : ^DrawList, a : Vec2, b : Vec2, col : u32, rounding : f32, rounding_corners : i32, thickness : f32)               #link_name "ImDrawList_AddRect";
    proc draw_list_add_rect_filled            (list : ^DrawList, a : Vec2, b : Vec2, col : u32, rounding : f32, rounding_corners : i32)                                #link_name "ImDrawList_AddRectFilled";
    proc draw_list_add_rect_filled_multi_color(list : ^DrawList, a : Vec2, b : Vec2, col_upr_left : u32, col_upr_right : u32, col_bot_right : u32, col_bot_left : u32) #link_name "ImDrawList_AddRectFilledMultiColor";
    proc draw_list_add_quad                   (list : ^DrawList, a : Vec2, b : Vec2, c : Vec2, d : Vec2, col : u32, thickness : f32)                                   #link_name "ImDrawList_AddQuad";
    proc draw_list_add_quad_filled            (list : ^DrawList, a : Vec2, b : Vec2, c : Vec2, d : Vec2, col : u32)                                                    #link_name "ImDrawList_AddQuadFilled";
    proc draw_list_add_triangle               (list : ^DrawList, a : Vec2, b : Vec2, c : Vec2, col : u32, thickness : f32)                                             #link_name "ImDrawList_AddTriangle";
    proc draw_list_add_triangle_filled        (list : ^DrawList, a : Vec2, b : Vec2, c : Vec2, col : u32)                                                              #link_name "ImDrawList_AddTriangleFilled";
    proc draw_list_add_circle                 (list : ^DrawList, centre : Vec2, radius : f32, col : u32, num_segments : i32, thickness : f32)                          #link_name "ImDrawList_AddCircle";
    proc draw_list_add_circle_filled          (list : ^DrawList, centre : Vec2, radius : f32, col : u32, num_segments : i32)                                           #link_name "ImDrawList_AddCircleFilled";

    //@TODO(Hoej); Figure that shit out
    proc draw_list_add_text                   (list : ^DrawList, pos : Vec2, col : u32, text_begin : Cstring, text_end : Cstring)                                                                              #link_name "ImDrawList_AddText";
    proc draw_list_add_text_ext               (list : ^DrawList, font : ^Font, font_size : f32, pos : Vec2, col : u32, text_begin : Cstring, text_end : Cstring, wrap_width : f32, cpu_fine_clip_rect : ^Vec4) #link_name "ImDrawList_AddTextExt";

    proc draw_list_add_image                  (list : ^DrawList, user_texture_id : TextureID, a : Vec2, b : Vec2, uv0 : Vec2, uv1 : Vec2, col : u32)               #link_name "ImDrawList_AddImage";
    proc draw_list_add_poly_line              (list : ^DrawList, points : ^Vec2, num_points : i32, col : u32, closed : bool, thickness : f32, anti_aliased : bool) #link_name "ImDrawList_AddPolyline";
    proc draw_list_add_convex_poly_filled     (list : ^DrawList, points : ^Vec2, num_points : i32, col : u32, anti_aliased : bool)                                 #link_name "ImDrawList_AddConvexPolyFilled";
    proc draw_list_add_bezier_curve           (list : ^DrawList, pos0 : Vec2, cp0 : Vec2, cp1 : Vec2, pos1 : Vec2, col : u32, thickness : f32, num_segments : i32) #link_name "ImDrawList_AddBezierCurve";

    // Stateful path API, add points then finish with PathFill() or PathStroke()
    proc draw_list_path_clear                  (list : ^DrawList)                                                                            #link_name "ImDrawList_PathClear";
    proc draw_list_path_line_to                (list : ^DrawList, pos : Vec2)                                                                #link_name "ImDrawList_PathLineTo";
    proc draw_list_path_line_to_merge_duplicate(list : ^DrawList, pos : Vec2)                                                                #link_name "ImDrawList_PathLineToMergeDuplicate";
    proc draw_list_path_fill                   (list : ^DrawList, col : u32)                                                                 #link_name "ImDrawList_PathFill";
    proc draw_list_path_stroke                 (list : ^DrawList, col : u32, closed : bool, thickness : f32)                                 #link_name "ImDrawList_PathStroke";
    proc draw_list_path_arc_to                 (list : ^DrawList, centre : Vec2, radius : f32, a_min : f32, a_max : f32, num_segments : i32) #link_name "ImDrawList_PathArcTo";
    proc draw_list_path_arc_to_fast            (list : ^DrawList, centre : Vec2, radius : f32, a_min_of_12 : i32, a_max_of_12 : i32)         #link_name "ImDrawList_PathArcToFast"; // Use precomputed angles for a 12 steps circle
    proc draw_list_path_bezier_curve_to        (list : ^DrawList, p1 : Vec2, p2 : Vec2, p3 : Vec2, num_segments : i32)                       #link_name "ImDrawList_PathBezierCurveTo";
    proc draw_list_path_rect                   (list : ^DrawList, rect_min : Vec2, rect_max : Vec2, rounding : f32, rounding_corners : i32)  #link_name "ImDrawList_PathRect";

    // Channels
    proc draw_list_channels_split      (list : ^DrawList, channels_count : i32) #link_name "ImDrawList_ChannelsSplit";
    proc draw_list_channels_merge      (list : ^DrawList)                       #link_name "ImDrawList_ChannelsMerge";
    proc draw_list_channels_set_current(list : ^DrawList, channel_index : i32)  #link_name "ImDrawList_ChannelsSetCurrent";

    // Advanced
    // Your rendering function must check for 'UserCallback' in ImDrawCmd and call the function instead of rendering triangles.
    proc draw_list_add_callback     (list : ^DrawList, callback : draw_callback, callback_data : rawptr)                                                     #link_name "ImDrawList_AddCallback";
    // This is useful if you need to forcefully create a new draw call(to allow for dependent rendering / blending). Otherwise primitives are merged into the same draw-call as much as possible
    proc draw_list_add_draw_cmd     (list : ^DrawList)                                                                                                       #link_name "ImDrawList_AddDrawCmd";
    // Internal helpers
    proc draw_list_prim_reserve     (list : ^DrawList, idx_count : i32, vtx_count : i32)                                                                     #link_name "ImDrawList_PrimReserve";
    proc draw_list_prim_rect        (list : ^DrawList, a : Vec2, b : Vec2, col : u32)                                                                        #link_name "ImDrawList_PrimRect";
    proc draw_list_prim_rectuv      (list : ^DrawList, a : Vec2, b : Vec2, uv_a : Vec2, uv_b : Vec2, col : u32)                                              #link_name "ImDrawList_PrimRectUV";
    proc draw_list_prim_quaduv      (list : ^DrawList,a : Vec2, b : Vec2, c : Vec2, d : Vec2, uv_a : Vec2, uv_b : Vec2, uv_c : Vec2, uv_d : Vec2, col : u32) #link_name "ImDrawList_PrimQuadUV";
    proc draw_list_prim_writevtx    (list : ^DrawList, pos : Vec2, uv : Vec2, col : u32)                                                                     #link_name "ImDrawList_PrimWriteVtx";
    proc draw_list_prim_writeidx    (list : ^DrawList, idx : DrawIdx)                                                                                        #link_name "ImDrawList_PrimWriteIdx";
    proc draw_list_prim_vtx         (list : ^DrawList, pos : Vec2, uv : Vec2, col : u32)                                                                     #link_name "ImDrawList_PrimVtx";
    proc draw_list_update_clip_rect (list : ^DrawList)                                                                                                       #link_name "ImDrawList_UpdateClipRect";
    proc draw_list_update_texture_id(list : ^DrawList)                                                                                                       #link_name "ImDrawList_UpdateTextureID";
}