/*
 *  @Name:     imgui
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    hjortshoej@handmade.network
 *  @Creation: 10-05-2017 21:11:30
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 10-06-2017 18:47:45
 *  
 *  @Description:
 *      Wrapper for Dear ImGui.
 */
#foreign_library "cimgui.lib";
#import "fmt.odin";
#import "strings.odin"; //@TODO(Hoej): remove the need for

DrawIdx   :: u16;
Wchar     :: u16;
TextureID :: rawptr;
GuiID     :: u32;
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

Font       :: struct #ordered {}
GuiStorage :: struct #ordered {}
GuiContext :: struct #ordered {}
FontAtlas  :: struct #ordered {}
DrawList   :: struct #ordered {}

FontConfig :: struct #ordered {
    font_data                : rawptr,
    font_data_size           : i32,
    font_data_owned_by_atlas : bool,
    font_no                  : i32,
    size_pixels              : f32,
    over_sample_h            : i32, OversampleV,
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

    render_draw_list_fn         : #type proc(data : ^DrawData) #cc_c,
    get_clipboard_text_fn       : #type proc() -> Cstring #cc_c,
    set_clipboard_text_fn       : #type proc(text : Cstring) #cc_c,
    mem_alloc_fn                : #type proc(sz : u64 /*size_t*/) -> rawptr #cc_c,
    mem_free_fn                 : #type proc(ptr : rawptr) #cc_c,
    ime_set_input_screen_pos_fn : #type proc(x : i32, y : i32) #cc_c,

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

gui_text_edit_callback       :: #type proc(data : ^GuiTextEditCallbackData) -> i32 #cc_c;
gui_size_constraint_callback :: #type proc(data : ^GuiSizeConstraintCallbackData) #cc_c;
draw_callback                :: #type proc(parent_list : ^DrawList, cmd : ^DrawCmd) #cc_c;

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
    UserSelect = -2,
    UserSelectShowButton = -1,
    RGB = 0,
    HSV = 1,
    HEX = 2
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

/////////// Odin UTIL /////////////////////////

_LABEL_BUF_SIZE        :: 4096;
_TEXT_BUF_SIZE         :: 4096;
_DISPLAY_FMT_BUF_SIZE  :: 256;
_MISC_BUF_SIZE         :: 1024;

#thread_local _text_buf        : [_TEXT_BUF_SIZE       ]u8;
#thread_local _label_buf       : [_LABEL_BUF_SIZE      ]u8;
#thread_local _display_fmt_buf : [_DISPLAY_FMT_BUF_SIZE]u8;
#thread_local _misc_buf        : [_MISC_BUF_SIZE       ]u8;

_make_text_string        :: proc(fmt_: string, args: ..any) -> Cstring {
    s := fmt.bprintf(_text_buf[..], fmt_, ..args);
    _text_buf[len(s)] = 0;
    return &_text_buf[0];
}

_make_label_string       :: proc(label : string) -> Cstring {
    s := fmt.bprintf(_label_buf[..], "%s", label);
    _label_buf[len(s)] = 0;
    return &_label_buf[0];
}

_make_display_fmt_string :: proc(display_fmt : string) -> Cstring {
    s := fmt.bprintf(_display_fmt_buf[..], "%s", display_fmt);
    _display_fmt_buf[len(s)] = 0;
    return &_display_fmt_buf[0];
}

_make_misc_string        :: proc(misc : string) -> Cstring {
    s := fmt.bprintf(_misc_buf[..], "%s", misc);
    _misc_buf[len(s)] = 0;
    return &_misc_buf[0];
}

/////////// Functions ////////////////////////
get_io              :: proc() -> ^GuiIO      #foreign cimgui "igGetIO";
get_style           :: proc() -> ^GuiStyle   #foreign cimgui "igGetStyle";
get_draw_data       :: proc() -> ^DrawData   #foreign cimgui "igGetDrawData";
new_frame           :: proc()                #foreign cimgui "igNewFrame";
render              :: proc()                #foreign cimgui "igRender";
shutdown            :: proc()                #foreign cimgui "igShutdown";
show_user_guide     :: proc()                #foreign cimgui "igShowUserGuide";
show_style_editor   :: proc(ref : ^GuiStyle) #foreign cimgui "igShowStyleEditor";
show_test_window    :: proc(opened : ^bool)  #foreign cimgui "igShowTestWindow";
show_metrics_window :: proc(opened : ^bool)  #foreign cimgui "igShowMetricsWindow";

///////////// Window
begin                           :: proc(name : string, open : ^bool, flags : GuiWindowFlags) -> bool{
    im_begin :: proc(name : Cstring, p_open : ^bool, flags : GuiWindowFlags) -> bool #foreign cimgui "igBegin";
    return im_begin(_make_label_string(name), open, flags);
}
begin_child                     :: proc(str_id : string, size : Vec2, border : bool, extra_flags : GuiWindowFlags) -> bool {
    im_begin_child :: proc(str_id : Cstring, size : Vec2, border : bool, extra_flags : GuiWindowFlags) -> bool #foreign cimgui "igBeginChild";
    return im_begin_child(_make_label_string(str_id), size, border, extra_flags);
}

begin_child_ex                  :: proc(id : GuiID, size : Vec2, border : bool, extra_flags : GuiWindowFlags) -> bool #foreign cimgui "igBeginChildEx";
end                             :: proc()              #foreign cimgui "igEnd";
end_child                       :: proc()              #foreign cimgui "igEndChild";
get_content_region_max          :: proc(out : ^Vec2)   #foreign cimgui "igGetContentRegionMax";
get_content_region_avail        :: proc(out : ^Vec2)   #foreign cimgui "igGetContentRegionAvail";
get_content_region_avail_width  :: proc() -> f32       #foreign cimgui "igGetContentRegionAvailWidth";
get_window_content_region_min   :: proc(out : ^Vec2)   #foreign cimgui "igGetWindowContentRegionMin";
get_window_content_region_max   :: proc(out : ^Vec2)   #foreign cimgui "igGetWindowContentRegionMax";
get_window_content_region_width :: proc() -> f32       #foreign cimgui "igGetWindowContentRegionWidth";
get_window_draw_list            :: proc() -> ^DrawList #foreign cimgui "igGetWindowDrawList";
get_window_pos                  :: proc(out : ^Vec2)   #foreign cimgui "igGetWindowPos";
get_window_size                 :: proc(out : ^Vec2)   #foreign cimgui "igGetWindowSize";
get_window_width                :: proc() -> f32       #foreign cimgui "igGetWindowWidth";
get_window_height               :: proc() -> f32       #foreign cimgui "igGetWindowHeight";
is_window_collapsed             :: proc() -> bool      #foreign cimgui "igIsWindowCollapsed";
set_window_font_scale           :: proc(scale : f32)   #foreign cimgui "igSetWindowFontScale";


set_window_collapsed             :: proc(name : string, collapsed : bool, cond : GuiSetCond) {
    im_set_window_collapsed :: proc(name : Cstring, collapsed : bool, cond : GuiSetCond) #foreign cimgui "igSetWindowCollapsed2";
    im_set_window_collapsed(_make_label_string(name), collapsed, cond);
}
set_window_size                  :: proc(name : string, size : Vec2, cond : GuiSetCond) {
    im_set_window_size :: proc(name : Cstring, size : Vec2, cond : GuiSetCond) #foreign cimgui "igSetWindowSize2";
    im_set_window_size(_make_label_string(name), size, cond);
}
set_window_focus                 :: proc(name : string) {
    im_set_window_focus :: proc(name : Cstring) #foreign cimgui "igSetWindowFocus2";
    im_set_window_focus(_make_label_string(name));
}
set_window_pos_by_name           :: proc(name : string, pos : Vec2, cond : GuiSetCond) {
    im_set_window_pos_by_name :: proc(name : Cstring, pos : Vec2, cond : GuiSetCond) #foreign cimgui "igSetWindowPosByName";
    im_set_window_pos_by_name(_make_label_string(name), pos, cond);
}

set_next_window_pos              :: proc(pos : Vec2, cond : GuiSetCond)                                                                                   #foreign cimgui "igSetNextWindowPos";
set_next_window_pos_center       :: proc(cond : GuiSetCond)                                                                                               #foreign cimgui "igSetNextWindowPosCenter";
set_next_window_size             :: proc(size : Vec2, cond : GuiSetCond)                                                                                  #foreign cimgui "igSetNextWindowSize";
set_next_window_size_constraints :: proc(size_min : Vec2, size_max : Vec2, custom_callback : gui_size_constraint_callback, custom_callback_data : rawptr) #foreign cimgui "igSetNextWindowSizeConstraints";
set_next_window_content_size     :: proc(size : Vec2)                                                                                                     #foreign cimgui "igSetNextWindowContentSize";
set_next_window_content_width    :: proc(width : f32)                                                                                                     #foreign cimgui "igSetNextWindowContentWidth";
set_next_window_collapsed        :: proc(collapsed : bool, cond : GuiSetCond)                                                                             #foreign cimgui "igSetNextWindowCollapsed";
set_next_window_focus            :: proc()                                                                                                                #foreign cimgui "igSetNextWindowFocus";
set_window_pos                   :: proc(pos : Vec2, cond : GuiSetCond)                                                                                   #foreign cimgui "igSetWindowPos";
set_window_size                  :: proc(size : Vec2, cond : GuiSetCond)                                                                                  #foreign cimgui "igSetWindowSize";
set_window_collapsed             :: proc(collapsed : bool, cond : GuiSetCond)                                                                             #foreign cimgui "igSetWindowCollapsed";
set_window_focus                 :: proc()                                                                                                                #foreign cimgui "igSetWindowFocus";


get_scroll_x            :: proc() -> f32                           #foreign cimgui "igGetScrollX";
get_scroll_y            :: proc() -> f32                           #foreign cimgui "igGetScrollY";
get_scroll_max_x        :: proc() -> f32                           #foreign cimgui "igGetScrollMaxX";
get_scroll_max_y        :: proc() -> f32                           #foreign cimgui "igGetScrollMaxY";
set_scroll_x            :: proc(scroll_x : f32)                    #foreign cimgui "igSetScrollX";
set_scroll_y            :: proc(scroll_y : f32)                    #foreign cimgui "igSetScrollY";
set_scroll_here         :: proc(center_y_ratio : f32)              #foreign cimgui "igSetScrollHere";
set_scroll_from_pos_y   :: proc(pos_y : f32, center_y_ratio : f32) #foreign cimgui "igSetScrollFromPosY";
set_keyboard_focus_here :: proc(offset : i32)                      #foreign cimgui "igSetKeyboardFocusHere";


set_state_storage       :: proc(tree : ^GuiStorage) #foreign cimgui "igSetStateStorage";
get_state_storage       :: proc() -> ^GuiStorage    #foreign cimgui "igGetStateStorage";

// Parameters stacks (shared)
push_font                   :: proc(font : ^Font)                         #foreign cimgui "igPushFont";
pop_font                    :: proc()                                     #foreign cimgui "igPopFont";
push_style_color            :: proc(idx : GuiCol, col : Vec4)             #foreign cimgui "igPushStyleColor";
pop_style_color             :: proc(count : i32)                          #foreign cimgui "igPopStyleColor";
push_style_var              :: proc(idx : GuiStyleVar, val : f32)         #foreign cimgui "igPushStyleVar";
push_style_var_vec          :: proc(idx : GuiStyleVar, val : Vec2)        #foreign cimgui "igPushStyleVarVec";
pop_style_var               :: proc(count : i32)                          #foreign cimgui "igPopStyleVar";
get_font                    :: proc() -> ^Font                            #foreign cimgui "igGetFont";
get_font_size               :: proc() -> f32                              #foreign cimgui "igGetFontSize";
get_font_tex_uv_white_pixel :: proc(pOut : ^Vec2)                         #foreign cimgui "igGetFontTexUvWhitePixel";
get_color_u32               :: proc(idx : GuiCol, alpha_mul : f32) -> u32 #foreign cimgui "igGetColorU32";
get_color_u32_vec           :: proc(col : ^Vec4) -> u32                   #foreign cimgui "igGetColorU32Vec";


// Parameters stacks (current window)
push_item_width           :: proc(item_width : f32) #foreign cimgui "igPushItemWidth";
pop_item_width            :: proc()                 #foreign cimgui "igPopItemWidth";
calc_item_width           :: proc() -> f32          #foreign cimgui "igCalcItemWidth";
push_text_wrap_pos        :: proc(wrap_pos_x : f32) #foreign cimgui "igPushTextWrapPos";
pop_text_wrap_pos         :: proc()                 #foreign cimgui "igPopTextWrapPos";
push_allow_keyboard_focus :: proc(v : bool)         #foreign cimgui "igPushAllowKeyboardFocus";
pop_allow_keyboard_focus  :: proc()                 #foreign cimgui "igPopAllowKeyboardFocus";
push_button_repeat        :: proc(repeat : bool)    #foreign cimgui "igPushButtonRepeat";
pop_button_repeat         :: proc()                 #foreign cimgui "igPopButtonRepeat";


// Layout
separator                          :: proc()                             #foreign cimgui "igSeparator";
same_line                          :: proc(pos_x : f32, spacing_w : f32) #foreign cimgui "igSameLine";
new_line                           :: proc()                             #foreign cimgui "igNewLine";
spacing                            :: proc()                             #foreign cimgui "igSpacing";
dummy                              :: proc(size : ^Vec2)                 #foreign cimgui "igDummy";
indent                             :: proc(indent_w : f32)               #foreign cimgui "igIndent";
unindent                           :: proc(indent_w : f32)               #foreign cimgui "igUnindent";
begin_group                        :: proc()                             #foreign cimgui "igBeginGroup";
end_group                          :: proc()                             #foreign cimgui "igEndGroup";
get_cursor_pos                     :: proc(pOut : ^Vec2)                 #foreign cimgui "igGetCursorPos";
get_cursor_pos_x                   :: proc() -> f32                      #foreign cimgui "igGetCursorPosX";
get_cursor_pos_y                   :: proc() -> f32                      #foreign cimgui "igGetCursorPosY";
set_cursor_pos                     :: proc(local_pos : Vec2)             #foreign cimgui "igSetCursorPos";
set_cursor_pos_x                   :: proc(x : f32)                      #foreign cimgui "igSetCursorPosX";
set_cursor_pos_y                   :: proc(y : f32)                      #foreign cimgui "igSetCursorPosY";
get_cursor_start_pos               :: proc(pOut : ^Vec2)                 #foreign cimgui "igGetCursorStartPos";
get_cursor_screen_pos              :: proc(pOut : ^Vec2)                 #foreign cimgui "igGetCursorScreenPos";
set_cursor_screen_pos              :: proc(pos : Vec2)                   #foreign cimgui "igSetCursorScreenPos";
align_first_text_height_to_widgets :: proc()                             #foreign cimgui "igAlignFirstTextHeightToWidgets";
get_text_line_height               :: proc() -> f32                      #foreign cimgui "igGetTextLineHeight";
get_text_line_height_with_spacing  :: proc() -> f32                      #foreign cimgui "igGetTextLineHeightWithSpacing";
get_items_line_height_with_spacing :: proc() -> f32                      #foreign cimgui "igGetItemsLineHeightWithSpacing";


//Columns
columns           :: proc(count : i32, id : string, border : bool) {
    im_columns :: proc(count : i32, id : Cstring, border : bool) #foreign cimgui "igColumns";
    im_columns(count, _make_label_string(id), border);
}

next_column       :: proc()                                   #foreign cimgui "igNextColumn";
get_column_index  :: proc() -> i32                            #foreign cimgui "igGetColumnIndex";
get_column_offset :: proc(column_index : i32) -> f32          #foreign cimgui "igGetColumnOffset";
set_column_offset :: proc(column_index : i32, offset_x : f32) #foreign cimgui "igSetColumnOffset";
get_column_width  :: proc(column_index : i32) -> f32          #foreign cimgui "igGetColumnWidth";
get_columns_count :: proc() -> i32                            #foreign cimgui "igGetColumnsCount";


// ID scopes
// If you are creating widgets in a loop you most likely want to push a unique identifier so ImGui can differentiate them
// You can also use "##extra" within your widget name to distinguish them from each others (see 'Programmer Guide')
//@TODO(Hoej): Figure out what to do here
push_id_str       :: proc(str_id : Cstring)                                 #foreign cimgui "igPushIdStr";
push_id_str_range :: proc(str_begin : Cstring, str_end : Cstring)          #foreign cimgui "igPushIdStrRange";
get_id_str        :: proc(str_id : Cstring) -> GuiID                        #foreign cimgui "igGetIdStr";
get_id_str_range  :: proc(str_begin : Cstring, str_end : Cstring) -> GuiID #foreign cimgui "igGetIdStrRange";

push_id_ptr       :: proc(ptr_id : rawptr)                                   #foreign cimgui "igPushIdPtr";
push_id_int       :: proc(int_id : i32)                                      #foreign cimgui "igPushIdInt";
pop_id            :: proc()                                                  #foreign cimgui "igPopId";
get_id_ptr        :: proc(ptr_id : rawptr) -> GuiID                          #foreign cimgui "igGetIdPtr";


/////// Text
text            :: proc(fmt_: string, args: ..any) {
    im_text     :: proc(fmt: ^u8) #cc_c #foreign cimgui "igText"; 
    im_text(_make_text_string(fmt_, ..args));
}
text_colored    :: proc(col : Vec4, fmt_: string, args: ..any) {
    im_text_colored :: proc(col : Vec4, fmt : ^u8) #cc_c #foreign cimgui "igTextColored";
    im_text_colored(col, _make_text_string(fmt_, ..args));
}
text_disabled   :: proc(fmt_: string, args: ..any) {
    im_text_disabled :: proc(fmt_ : ^u8) #foreign cimgui "igTextDisabled";
    im_text_disabled(_make_text_string(fmt_, ..args));
}
text_wrapped    :: proc(fmt_: string, args: ..any) {
    im_text_wrapped :: proc(fmt: ^u8) #foreign cimgui "igTextWrapped";
    im_text_wrapped(_make_text_string(fmt_, ..args));
}
label_text      :: proc(label : string, fmt_ : string, args : ..any) {
    im_label_text :: proc(label : Cstring, fmt_ : Cstring) #foreign cimgui "igLabelText";
    im_label_text(_make_label_string(label), _make_text_string(fmt_, ..args));
}
bullet_text     :: proc(fmt_: string, args: ..any) {
    im_bullet_text :: proc(fmt_ : Cstring) #foreign cimgui "igBulletText";
    im_bullet_text(_make_text_string(fmt_, ..args));
}

//@TODO(Hoej): Figure out what to do here.
TextUnformatted :: proc(text : Cstring, text_end : Cstring) #foreign cimgui "igTextUnformatted";
bullet          :: proc() #foreign cimgui "igBullet";


///// Buttons
button           :: proc(label : string, size : Vec2) -> bool {
    im_button :: proc(label : Cstring, size : Vec2) -> bool #foreign cimgui "igButton";
    return im_button(_make_label_string(label), size);
}
small_button     :: proc(label : string) -> bool {
    im_small_button :: proc(label : Cstring) -> bool #foreign cimgui "igSmallButton";
    return im_small_button(_make_label_string(label));
}
invisible_button :: proc(str_id : string, size : Vec2) -> bool {
    im_invisible_button :: proc(str_id : Cstring, size : Vec2) -> bool #foreign cimgui "igInvisibleButton";
    return im_invisible_button(_make_label_string(str_id), size);
}
image_button     :: proc(user_texture_id : TextureID, size : Vec2, uv0 : Vec2, uv1 : Vec2, frame_padding : i32, bg_col : Vec4, tint_col : Vec4) -> bool #foreign cimgui "igImageButton";


//// ???
image              :: proc(user_texture_id : TextureID, size : Vec2, uv0 : Vec2, uv1 : Vec2, tint_col : Vec4, border_col : Vec4) #foreign cimgui "igImage";

checkbox           :: proc(label : string, v : ^bool) -> bool {
    im_checkbox :: proc(label : Cstring, v : ^bool) -> bool #foreign cimgui "igCheckbox";
    return im_checkbox(_make_label_string(label), v);
}
checkbox_flags     :: proc(label : string, flags : ^u32, flags_value : u32) -> bool {
    im_checkbox_flags :: proc(label : Cstring, flags : ^u32, flags_value : u32) -> bool #foreign cimgui "igCheckboxFlags";
    return im_checkbox_flags(_make_label_string(label), flags, flags_value);
}

radio_buttons_bool :: proc(label : string, active : bool) -> bool {
    im_radio_buttons_bool :: proc(label : Cstring, active : bool) -> bool #foreign cimgui "igRadioButtonBool";
    return im_radio_buttons_bool(_make_label_string(label), active);
}
radio_button       :: proc(label : string, v : ^i32, v_button : i32) -> bool {
    im_radio_button :: proc(label : Cstring, v : ^i32, v_button : i32) -> bool #foreign cimgui "igRadioButton";
    return im_radio_button(_make_label_string(label), v, v_button);
}

combo              :: proc(label : string, current_item : ^i32, items : []string, height_in_items : i32) -> bool {
    im_combo :: proc(label : Cstring, current_item : ^i32, items : ^^u8, items_count : i32, height_in_items : i32) -> bool #foreign cimgui "igCombo";

    data := make([]^u8, len(items)); defer free(data);
    for item, idx in items {
        data[idx] = strings.new_c_string(item);
    } //@TODO(Hoej): Change this to stack buffers.

    return im_combo(_make_label_string(label), current_item, &data[0], i32(len(items)), height_in_items); 
}
//@TODO(Hoej): Get this shit straight
combo2             :: proc(label : Cstring, current_item : ^i32, items_separated_by_zeros : Cstring, height_in_items : i32) -> bool #foreign cimgui "igCombo2";
combo3             :: proc(label : Cstring, current_item : ^i32, items_getter : proc(data : rawptr, idx : i32, out_text : ^^u8) -> bool #cc_c, data : rawptr, items_count : i32, height_in_items : i32) -> bool #foreign cimgui "igCombo3";
//@TODO(Hoej): Get this shit straight
color_button       :: proc(col : Vec4, small_height : bool, outline_border : bool) -> bool #foreign cimgui "igColorButton";

color_edit         :: proc(label : string, col : ^[3]f32) -> bool {
    im_color_edit3 :: proc(label : Cstring, col : ^f32) -> bool #foreign cimgui "igColorEdit3";
    return im_color_edit3(_make_label_string(label), &col[0]);    
}
color_edit         :: proc(label : string, col : ^[4]f32) -> bool {
    im_color_edit4 :: proc(label : Cstring, col : ^f32) -> bool #foreign cimgui "igColorEdit4";
    return im_color_edit4(_make_label_string(label), &col[0]);    
}

color_edit_mode :: proc(mode : GuiColorEditMode) #foreign cimgui "igColorEditMode";
//@TODO(Hoej): Get this shit straight
plot_lines         :: proc(label : Cstring, values : ^f32, values_count : i32, values_offset : i32, overlay_text : Cstring, scale_min : f32, scale_max : f32, graph_size : Vec2, stride : i32) #foreign cimgui "igPlotLines";
plot_lines2        :: proc(label : Cstring, values_getter : proc(data : rawptr, idx : i32) -> f32, data : rawptr, values_count : i32, values_offset : i32, overlay_text : Cstring, scale_min : f32, scale_max : f32, graph_size : Vec2) #foreign cimgui "igPlotLines2";
plot_histogram     :: proc(label : Cstring, values : ^f32, values_count : i32, values_offset : i32, overlay_text : Cstring, scale_min : f32, scale_max : f32, graph_size : Vec2, stride : i32) #foreign cimgui "igPlotHistogram";
plot_histogram2    :: proc(label : Cstring, values_getter : proc(data : rawptr, idx : i32) -> f32, data : rawptr, values_count : i32, values_offset : i32, overlay_text : Cstring, scale_min : f32, scale_max : f32, graph_size : Vec2) #foreign cimgui "igPlotHistogram2";

progress_bar       :: proc(fraction : f32, size_arg : ^Vec2, overlay : string) {
    im_progress_bar :: proc(fraction : f32, size_arg : ^Vec2, overlay : Cstring) #foreign cimgui "igProgressBar";
    im_progress_bar(fraction, size_arg, _make_misc_string(overlay));
}


// Widgets: Sliders (tip: ctrl+click on a slider to input text)
slider_float :: proc(label : string, v : ^f32, v_min : f32, v_max : f32, display_format : string, power : f32) -> bool {
    im_slider_float :: proc(label : Cstring, v : ^f32, v_min : f32, v_max : f32, display_format : Cstring, power : f32) -> bool #foreign cimgui "igSliderFloat";
    return im_slider_float(_make_label_string(label), v, v_min, v_max, _make_display_fmt_string(display_format), power);
}
slider_float :: proc(label : string, v : ^[2]f32, v_min : f32, v_max : f32, display_format : string, power : f32) -> bool {
    im_slider_float2 :: proc(label : Cstring, v : ^f32, v_min : f32, v_max : f32, display_format : Cstring, power : f32) -> bool #foreign cimgui "igSliderFloat2";
    return im_slider_float2(_make_label_string(label), &v[0], v_min, v_max, _make_display_fmt_string(display_format), power);
}
slider_float :: proc(label : string, v : ^[3]f32, v_min : f32, v_max : f32, display_format : string, power : f32) -> bool {
    im_slider_float2 :: proc(label : Cstring, v : ^f32, v_min : f32, v_max : f32, display_format : Cstring, power : f32) -> bool #foreign cimgui "igSliderFloat3";
    return im_slider_float2(_make_label_string(label), &v[0], v_min, v_max, _make_display_fmt_string(display_format), power);
}
slider_float :: proc(label : string, v : ^[4]f32, v_min : f32, v_max : f32, display_format : string, power : f32) -> bool {
    im_slider_float2 :: proc(label : Cstring, v : ^f32, v_min : f32, v_max : f32, display_format : Cstring, power : f32) -> bool #foreign cimgui "igSliderFloat4";
    return im_slider_float2(_make_label_string(label), &v[0], v_min, v_max, _make_display_fmt_string(display_format), power);
}

slider_angle :: proc(label : string, v_rad : ^f32, v_degrees_min : f32, v_degrees_max : f32) -> bool {
    im_slider_angle :: proc(label : Cstring, v_rad : ^f32, v_degrees_min : f32, v_degrees_max : f32) -> bool #foreign cimgui "igSliderAngle";
    return im_slider_angle(_make_label_string(label),v_rad, v_degrees_min, v_degrees_max);
}

slider_int :: proc(label : string, v : ^i32, v_min : i32, v_max : i32, display_format : string) -> bool {
    im_slider_int :: proc(label : Cstring, v : ^i32, v_min : i32, v_max : i32, display_format : Cstring) -> bool #foreign cimgui "igSliderInt";
    return im_slider_int(_make_label_string(label), v, v_min, v_max, _make_display_fmt_string(display_format));
}
slider_int :: proc(label : string, v : ^[2]i32, v_min : i32, v_max : i32, display_format : string) -> bool {
    im_slider_int2 :: proc(label : Cstring, v : ^i32, v_min : i32, v_max : i32, display_format : Cstring) -> bool #foreign cimgui "igSliderInt2";
    return im_slider_int2(_make_label_string(label), &v[0], v_min, v_max, _make_display_fmt_string(display_format));
}
slider_int :: proc(label : string, v : ^[3]i32, v_min : i32, v_max : i32, display_format : string) -> bool {
    im_slider_int3 :: proc(label : Cstring, v : ^i32, v_min : i32, v_max : i32, display_format : Cstring) -> bool #foreign cimgui "igSliderInt3";
    return im_slider_int3(_make_label_string(label), &v[0], v_min, v_max, _make_display_fmt_string(display_format));
}
slider_int :: proc(label : string, v : ^[4]i32, v_min : i32, v_max : i32, display_format : string) -> bool {
    im_slider_int4 :: proc(label : Cstring, v : ^i32, v_min : i32, v_max : i32, display_format : Cstring) -> bool #foreign cimgui "igSliderInt4";
    return im_slider_int4(_make_label_string(label), &v[0], v_min, v_max, _make_display_fmt_string(display_format));
}

vslider_float :: proc(label : string, size : Vec2, v : ^f32, v_min : f32 , v_max : f32, display_format : string, power : f32) -> bool {
    im_vslider_float :: proc(label : Cstring, size : Vec2, v : ^f32, v_min : f32 , v_max : f32, display_format : Cstring, power : f32) -> bool #foreign cimgui "igVSliderFloat";
    return im_vslider_float(_make_label_string(label), size, v, v_min, v_max, _make_display_fmt_string(display_format), power);
}

vslider_int :: proc(label : string, size : Vec2, v : ^i32, v_min : i32, v_max : i32, display_format : string) -> bool {
    im_vslider_int :: proc(label : Cstring, size : Vec2, v : ^i32, v_min : i32, v_max : i32, display_format : Cstring) -> bool #foreign cimgui "igVSliderInt";
    return im_vslider_int(_make_label_string(label), size, v, v_min, v_max, _make_display_fmt_string(display_format));
}


// Widgets: Drags (tip: ctrl+click on a drag box to input text)
drag_float :: proc(label : string, v : ^f32, v_speed : f32, v_min : f32, v_max : f32, display_format : string, power : f32) {
    im_drag_float :: proc(label : Cstring, v : ^f32, v_speed : f32, v_min : f32, v_max : f32, display_format : Cstring, power : f32) #foreign cimgui "igDragFloat";
    im_drag_float(_make_label_string(label), v, v_speed, v_min, v_max, _make_display_fmt_string(display_format), power);
}
drag_float :: proc(label : string, v : ^[2]f32, v_speed : f32, v_min : f32, v_max : f32, display_format : string, power : f32) -> bool {
    im_drag_float2 :: proc(label : Cstring, v : ^f32, v_speed : f32, v_min : f32, v_max : f32, display_format : Cstring, power : f32) -> bool #foreign cimgui "igDragFloat2";
    return im_drag_float2(_make_label_string(label), &v[0], v_speed, v_min, v_max, _make_display_fmt_string(display_format), power);
}
drag_float :: proc(label : string, v : ^[3]f32, v_speed : f32, v_min : f32, v_max : f32, display_format : string, power : f32) -> bool {
    im_drag_float3 :: proc(label : Cstring, v : ^f32, v_speed : f32, v_min : f32, v_max : f32, display_format : Cstring, power : f32) -> bool #foreign cimgui "igDragFloat3";
    return im_drag_float3(_make_label_string(label), &v[0], v_speed, v_min, v_max, _make_display_fmt_string(display_format), power);
}
drag_float :: proc(label : string, v : ^[4]f32, v_speed : f32, v_min : f32, v_max : f32, display_format : string, power : f32) -> bool {
    im_drag_float4 :: proc(label : Cstring, v : ^f32, v_speed : f32, v_min : f32, v_max : f32, display_format : Cstring, power : f32) -> bool #foreign cimgui "igDragFloat4";
    return im_drag_float4(_make_label_string(label), &v[0], v_speed, v_min, v_max, _make_display_fmt_string(display_format), power);
}

drag_float_range :: proc(label : string, v_current_min, v_current_max : ^f32, v_speed, v_min, v_max : f32, display_format, display_format_max : string, power : f32) -> bool {
    im_drag_float_range :: proc(label : Cstring, v_current_min, v_current_max : ^f32, v_speed, v_min, v_max : f32, display_format, display_format_max : Cstring, power : f32) -> bool #foreign cimgui "igDragFloatRange2";
    id  := _make_label_string(label);
    df  := _make_display_fmt_string(display_format);
    mdf := _make_misc_string(display_format_max);
    return im_drag_float_range(id, v_current_min, v_current_max, v_speed, v_min, v_max, df, mdf, power);
}

drag_int :: proc(label : string, v : ^i32, v_speed : f32, v_min : i32, v_max : i32, display_format : string) {
    im_drag_int :: proc(label : Cstring, v : ^i32, v_speed : f32, v_min : i32, v_max : i32, display_format : Cstring) #foreign cimgui "igDragInt";
    im_drag_int(_make_label_string(label), v, v_speed, v_min, v_max, _make_display_fmt_string(display_format));
}
drag_int :: proc(label : string, v : ^[2]i32, v_speed : f32, v_min : i32, v_max : i32, display_format : string) {
    im_drag_int2 :: proc(label : Cstring, v : ^i32, v_speed : f32, v_min : i32, v_max : i32, display_format : Cstring) #foreign cimgui "igDragInt2";
    im_drag_int2(_make_label_string(label), &v[0], v_speed, v_min, v_max, _make_display_fmt_string(display_format));
}
drag_int :: proc(label : string, v : ^[3]i32, v_speed : f32, v_min : i32, v_max : i32, display_format : string) {
    im_drag_int3 :: proc(label : Cstring, v : ^i32, v_speed : f32, v_min : i32, v_max : i32, display_format : Cstring) #foreign cimgui "igDragInt3";
    im_drag_int3(_make_label_string(label), &v[0], v_speed, v_min, v_max, _make_display_fmt_string(display_format));
}
drag_int :: proc(label : string, v : ^[4]i32, v_speed : f32, v_min : i32, v_max : i32, display_format : string) {
    im_drag_int4 :: proc(label : Cstring, v : ^i32, v_speed : f32, v_min : i32, v_max : i32, display_format : Cstring) #foreign cimgui "igDragInt4";
    im_drag_int4(_make_label_string(label), &v[0], v_speed, v_min, v_max, _make_display_fmt_string(display_format));
}

drag_int_range :: proc(label : string, v_current_min, v_current_max : ^i32, v_speed, v_min, v_max : i32, display_format, display_format_max : string) -> bool {
    im_drag_int_range :: proc(label : Cstring, v_current_min, v_current_max : ^i32, v_speed, v_min, v_max : i32, display_format, display_format_max : Cstring) -> bool #foreign cimgui "igDragIntRange2";
    id  := _make_label_string(label);
    df  := _make_display_fmt_string(display_format);
    mdf := _make_misc_string(display_format_max);
    return im_drag_int_range(id, v_current_min, v_current_max, v_speed, v_min, v_max, df, mdf);
}

// Widgets: Input
input_text           :: proc(label : string, buf : []u8, flags : GuiInputTextFlags, callback : gui_text_edit_callback, user_data : rawptr) -> bool {
    im_input_text :: proc(label : Cstring, buf : Cstring, buf_size : u64 /*size_t*/, flags : GuiInputTextFlags, callback : gui_text_edit_callback, user_data : rawptr) -> bool #foreign cimgui "igInputText";
    return im_input_text(_make_label_string(label), &buf[0], u64(len(buf)), flags, callback, user_data);
}
input_text_multiline :: proc(label : string, buf : []u8, size : Vec2, flags : GuiInputTextFlags, callback : gui_text_edit_callback, user_data : rawptr) -> bool {
    im_input_text_multiline :: proc(label : Cstring, buf : Cstring, buf_size : u64 /*size_t*/, size : Vec2, flags : GuiInputTextFlags, callback : gui_text_edit_callback, user_data : rawptr) -> bool #foreign cimgui "igInputTextMultiline";
    return im_input_text_multiline(_make_label_string(label), &buf[0], u64(len(buf)), size, flags, callback, user_data);
}

input_float :: proc(label : string, v : ^f32, step : f32, step_fast : f32, decimal_precision : i32, extra_flags : GuiInputTextFlags) -> bool {
    im_input_float :: proc(label : Cstring, v : ^f32, step : f32, step_fast : f32, decimal_precision : i32, extra_flags : GuiInputTextFlags) -> bool #foreign cimgui "igInputFloat";
    return im_input_float(_make_label_string(label), v, step, step_fast, decimal_precision, extra_flags);
}
input_float :: proc(label : string, v : ^[2]f32, decimal_precision : i32, extra_flags : GuiInputTextFlags) -> bool {
    im_input_float2 :: proc(label : Cstring, v : ^f32, decimal_precision : i32, extra_flags : GuiInputTextFlags) -> bool #foreign cimgui "igInputFloat2";
    return im_input_float2(_make_label_string(label), &v[0], decimal_precision, extra_flags);
}
input_float :: proc(label : string, v : ^[3]f32, decimal_precision : i32, extra_flags : GuiInputTextFlags) -> bool {
    im_input_float3 :: proc(label : Cstring, v : ^f32, decimal_precision : i32, extra_flags : GuiInputTextFlags) -> bool #foreign cimgui "igInputFloat3";
    return im_input_float3(_make_label_string(label), &v[0], decimal_precision, extra_flags);
}
input_float :: proc(label : string, v : ^[4]f32, decimal_precision : i32, extra_flags : GuiInputTextFlags) -> bool {
    im_input_float4 :: proc(label : Cstring, v : ^f32, decimal_precision : i32, extra_flags : GuiInputTextFlags) -> bool #foreign cimgui "igInputFloat4";
    return im_input_float4(_make_label_string(label), &v[0], decimal_precision, extra_flags);
}

input_int  :: proc(label : string, v : ^i32, step : i32, step_fast : i32, extra_flags : GuiInputTextFlags) -> bool {
    im_input_int  :: proc(label : Cstring, v : ^i32, step : i32, step_fast : i32, extra_flags : GuiInputTextFlags) -> bool #foreign cimgui "igInputInt";
    return im_input_int(_make_label_string(label), v, step, step_fast, extra_flags);
}
input_int :: proc(label : string, v : ^[2]i32, extra_flags : GuiInputTextFlags) -> bool {
    im_input_int2 :: proc(label : Cstring, v : ^i32, extra_flags : GuiInputTextFlags) -> bool #foreign cimgui "igInputInt2";
    return im_input_int2(_make_label_string(label), &v[0], extra_flags);
}
input_int :: proc(label : string, v : ^[3]i32, extra_flags : GuiInputTextFlags) -> bool {
    im_input_int3 :: proc(label : Cstring, v : ^i32, extra_flags : GuiInputTextFlags) -> bool #foreign cimgui "igInputInt3";
    return im_input_int3(_make_label_string(label), &v[0], extra_flags);
}
input_int :: proc(label : string, v : ^[4]i32, extra_flags : GuiInputTextFlags) -> bool {
    im_input_int4 :: proc(label : Cstring, v : ^i32, extra_flags : GuiInputTextFlags) -> bool #foreign cimgui "igInputInt4";
    return im_input_int4(_make_label_string(label), &v[0], extra_flags);
}

// Widgets: Trees
tree_node :: proc(label : string) -> bool {
    im_tree_node :: proc(label : Cstring) -> bool #foreign cimgui "igTreeNode";
    return im_tree_node(_make_label_string(label));
}
tree_node :: proc(str_id : string, fmt_ : string, args : ..any) -> bool {
    im_tree_node_str :: proc(str_id : Cstring, fmt_ : ^u8) -> bool #foreign cimgui "igTreeNodeStr";
    return im_tree_node_str(_make_label_string(str_id), _make_text_string(fmt_, ..args));
}
tree_node :: proc(ptr_id : rawptr, fmt_ : string, args : ..any) -> bool {
    im_tree_node_ptr :: proc(ptr_id : rawptr, fmt_ : ^u8) -> bool #foreign cimgui "igTreeNodePtr";
    return im_tree_node_ptr(ptr_id, _make_text_string(fmt_, ..args));
}
tree_node_ex :: proc(label : string, flags : GuiTreeNodeFlags) -> bool {
    im_tree_node_ex :: proc(label : Cstring, flags : GuiTreeNodeFlags) -> bool #foreign cimgui "igTreeNodeEx";
    return im_tree_node_ex(_make_label_string(label), flags);
}
tree_node_ex :: proc(str_id : string, flags : GuiTreeNodeFlags, fmt_ : string, args : ..any) -> bool {
    im_tree_node_ex_str :: proc(str_id : Cstring, flags : GuiTreeNodeFlags, fmt_ : ^u8) -> bool #foreign cimgui "igTreeNodeExStr";
    return im_tree_node_ex_str(_make_label_string(str_id), flags, _make_text_string(fmt_, ..args));
}
tree_node_ex :: proc(ptr_id : rawptr, flags : GuiTreeNodeFlags, fmt_ : string, args : ..any) -> bool {
    im_tree_node_ex_ptr :: proc(ptr_id : rawptr, flags : GuiTreeNodeFlags, fmt_ : ^u8) -> bool #foreign cimgui "igTreeNodeExPtr";
    return im_tree_node_ex_ptr(ptr_id, flags, _make_text_string(fmt_, ..args));
}
tree_push_str :: proc(str_id : string) {
    im_tree_push_str :: proc(str_id : Cstring) #foreign cimgui "igTreePushStr";
    im_tree_push_str(_make_label_string(str_id));
}

tree_push_ptr :: proc(ptr_id : rawptr) #foreign cimgui "igTreePushPtr";
tree_pop :: proc() #foreign cimgui "igTreePop";
tree_advance_to_label_pos :: proc() #foreign cimgui "igTreeAdvanceToLabelPos";
get_tree_node_to_label_spacing :: proc() -> f32 #foreign cimgui "igGetTreeNodeToLabelSpacing";
set_next_tree_node_open :: proc(opened : bool, cond : GuiSetCond) #foreign cimgui "igSetNextTreeNodeOpen";

collapsing_header :: proc(label : string, flags : GuiTreeNodeFlags) -> bool {
    im_collapsing_header :: proc(label : Cstring, flags : GuiTreeNodeFlags) -> bool #foreign cimgui "igCollapsingHeader";
    return im_collapsing_header(_make_label_string(label), flags);
}

collapsing_header_ex :: proc(label : string, p_open : ^bool, flags : GuiTreeNodeFlags) -> bool {
    im_collapsing_header_ex :: proc(label : Cstring, p_open : ^bool, flags : GuiTreeNodeFlags) -> bool #foreign cimgui "igCollapsingHeaderEx";
    return im_collapsing_header_ex(_make_label_string(label), p_open, flags);
}

// Widgets: Selectable / Lists
selectable :: proc(label : string, selected : bool, flags : GuiSelectableFlags, size : Vec2) -> bool {
    im_selectable :: proc(label : Cstring, selected : bool, flags : GuiSelectableFlags, size : Vec2) -> bool #foreign cimgui "igSelectable";
    return im_selectable(_make_label_string(label), selected, flags, size);
}

selectable_ex :: proc(label : string, p_selected : ^bool, flags : GuiSelectableFlags, size : Vec2) -> bool {
    im_selectable_ex :: proc(label : Cstring, p_selected : ^bool, flags : GuiSelectableFlags, size : Vec2) -> bool #foreign cimgui "igSelectableEx";
    return im_selectable_ex(_make_label_string(label), p_selected, flags, size);
}

//@TODO(Hoej): Figure this shit out
list_box :: proc(label : Cstring, current_item : ^i32, items : ^^u8, items_count : i32, height_in_items : i32) -> bool #foreign cimgui "igListBox";
list_box :: proc(label : Cstring, current_item : ^i32, items_getter : proc(data : rawptr, idx : i32, out_text : ^^u8) -> bool #cc_c, data : rawptr, items_count : i32, height_in_items : i32) -> bool #foreign cimgui "igListBox2";

list_box_header :: proc(label : string, size : Vec2) -> bool {
    im_list_box_header :: proc(label : Cstring, size : Vec2) -> bool #foreign cimgui "igListBoxHeader";
    return im_list_box_header(_make_label_string(label), size);
}
list_box_header :: proc(label : string, items_count : i32, height_in_items : i32) -> bool {
    im_list_box_header :: proc(label : Cstring, items_count : i32, height_in_items : i32) -> bool #foreign cimgui "igListBoxHeader2";
    return im_list_box_header(_make_label_string(label), items_count, height_in_items);
}
list_box_footer :: proc() #foreign cimgui "igListBoxFooter";

// Widgets: Value() Helpers. Output single value in "name: value" format (tip: freely declare your own within the ImGui namespace!)
value :: proc(prefix : string, b : bool) {
    im_value_bool :: proc(prefix : Cstring, b : bool) #foreign cimgui "igValueBool";
    im_value_bool(_make_label_string(prefix), b);
}
value :: proc(prefix : string, v : i32) {
    im_value_int :: proc(prefix : Cstring, v : i32) #foreign cimgui "igValueInt";
    im_value_int(_make_label_string(prefix), v);
}
value :: proc(prefix : string, v : u32) {
    im_value_uint :: proc(prefix : Cstring, v : u32) #foreign cimgui "igValueUInt";
    im_value_uint(_make_label_string(prefix), v);
}
value :: proc(prefix : string, v : f32, format : string) {
    im_value_float :: proc(prefix : Cstring, v : f32, float_format : Cstring) #foreign cimgui "igValueFloat";
    im_value_float(_make_label_string(prefix), v, _make_misc_string(format));
}
value :: proc(prefix : string, v : Vec4) {
    im_value_color :: proc(prefix : Cstring, v : Vec4) #foreign cimgui "igValueColor";
    im_value_color(_make_label_string(prefix), v);
}

// Tooltip
set_tooltip :: proc(fmt_ : string, args : ..any) {
    im_set_tooltip :: proc(fmt : ^u8) #foreign cimgui "igSetTooltip"; 
    im_set_tooltip(_make_text_string(fmt_, ..args));
}
begin_tooltip :: proc() #foreign cimgui "igBeginTooltip";
end_tooltip :: proc() #foreign cimgui "igEndTooltip";

// Widgets: Menus
begin_main_menu_bar :: proc() -> bool #foreign cimgui "igBeginMainMenuBar";
end_main_menu_bar :: proc() #foreign cimgui "igEndMainMenuBar";
begin_menu_bar :: proc() -> bool #foreign cimgui "igBeginMenuBar";
end_menu_bar :: proc() #foreign cimgui "igEndMenuBar";

begin_menu :: proc(label : string, enabled : bool) -> bool {
    im_begin_menu :: proc(label : Cstring, enabled : bool) -> bool #foreign cimgui "igBeginMenu";
    return im_begin_menu(_make_label_string(label), enabled);
}

end_menu :: proc() #foreign cimgui "igEndMenu";

menu_item :: proc(label : string, shortcut : string, selected : bool, enabled : bool) -> bool  {
    im_menu_item :: proc(label : Cstring, shortcut : Cstring, selected : bool, enabled : bool) -> bool #foreign cimgui "igMenuItem";   
    return im_menu_item(_make_label_string(label), _make_misc_string(shortcut), selected, enabled);
}

menu_item_ptr :: proc(label : string, shortcut : string, selected : ^bool, enabled : bool) -> bool  {
    im_menu_item_ptr :: proc(label : Cstring, shortcut : Cstring, p_selected : ^bool, enabled : bool) -> bool #foreign cimgui "igMenuItemPtr";
    return im_menu_item_ptr(_make_label_string(label), _make_misc_string(shortcut), selected, enabled);
}

// Popup
open_popup :: proc(str_id : string) {
    im_open_popup :: proc(str_id : Cstring) #foreign cimgui "igOpenPopup";
    im_open_popup(_make_label_string(str_id));
}

begin_popup :: proc(str_id : string) -> bool {
    im_begin_popup :: proc(str_id : Cstring) -> bool #foreign cimgui "igBeginPopup";
    return im_begin_popup(_make_label_string(str_id));
}

begin_popup_modal :: proc(name : string, open : ^bool, extra_flags : GuiWindowFlags) -> bool {
    im_begin_popup_modal :: proc(name : Cstring, p_open : ^bool, extra_flags : GuiWindowFlags) -> bool #foreign cimgui "igBeginPopupModal";
    return im_begin_popup_modal(_make_label_string(name), open, extra_flags);
}

begin_popup_context_item :: proc(str_id : string, mouse_button : i32) -> bool {
    im_begin_popup_context_item :: proc(str_id : Cstring, mouse_button : i32) -> bool #foreign cimgui "igBeginPopupContextItem";
    return im_begin_popup_context_item(_make_label_string(str_id), mouse_button);
}
begin_popup_context_window :: proc(also_over_items : bool, str_id : string, mouse_button : i32) -> bool {
    im_begin_popup_context_window :: proc(also_over_items : bool, str_id : Cstring, mouse_button : i32) -> bool #foreign cimgui "igBeginPopupContextWindow";
    return im_begin_popup_context_window(also_over_items, _make_label_string(str_id), mouse_button);
}
begin_popup_context_void :: proc(str_id : string, mouse_button : i32) -> bool {
    im_begin_popup_context_void :: proc(str_id : Cstring, mouse_button : i32) -> bool #foreign cimgui "igBeginPopupContextVoid";
    return im_begin_popup_context_void(_make_label_string(str_id), mouse_button);
}
end_popup :: proc() #foreign cimgui "igEndPopup";
close_current_popup :: proc() #foreign cimgui "igCloseCurrentPopup";

// Logging: all text output from interface is redirected to tty/file/clipboard. Tree nodes are automatically opened.
log_to_tty :: proc(max_depth : i32) #foreign cimgui "igLogToTTY";
log_to_file :: proc(max_depth : i32, filename : Cstring) #foreign cimgui "igLogToFile";
log_to_clipboard :: proc(max_depth : i32) #foreign cimgui "igLogToClipboard";
log_finish :: proc() #foreign cimgui "igLogFinish";
log_buttons :: proc() #foreign cimgui "igLogButtons";
log_text :: proc(fmt_ : string, args : ..any) {
    im_log_text :: proc(fmt_ : ^u8) #foreign cimgui "igLogText";
    im_log_text(_make_text_string(fmt_, ..args));
}

// Clipping
push_clip_rect :: proc(clip_rect_min : Vec2, clip_rect_max : Vec2, intersect_with_current_clip_rect : bool) #foreign cimgui "igPushClipRect";
pop_clip_rect :: proc() #foreign cimgui "igPopClipRect";

// Utilities
is_item_hovered                     :: proc() -> bool                                                                                                 #foreign cimgui "igIsItemHovered";
is_item_hovered_rect                :: proc() -> bool                                                                                                 #foreign cimgui "igIsItemHoveredRect";
is_item_active                      :: proc() -> bool                                                                                                 #foreign cimgui "igIsItemActive";
is_item_clicked                     :: proc(mouse_button : i32) -> bool                                                                               #foreign cimgui "igIsItemClicked";
is_item_visible                     :: proc() -> bool                                                                                                 #foreign cimgui "igIsItemVisible";
is_any_item_hovered                 :: proc() -> bool                                                                                                 #foreign cimgui "igIsAnyItemHovered";
is_any_item_active                  :: proc() -> bool                                                                                                 #foreign cimgui "igIsAnyItemActive";
get_item_rect_min                   :: proc(pOut : ^Vec2)                                                                                             #foreign cimgui "igGetItemRectMin";
get_item_rect_max                   :: proc(pOut : ^Vec2)                                                                                             #foreign cimgui "igGetItemRectMax";
get_item_rect_size                  :: proc(pOut : ^Vec2)                                                                                             #foreign cimgui "igGetItemRectSize";
set_item_allow_overlap              :: proc()                                                                                                         #foreign cimgui "igSetItemAllowOverlap";
is_window_hovered                   :: proc() -> bool                                                                                                 #foreign cimgui "igIsWindowHovered";
is_window_focused                   :: proc() -> bool                                                                                                 #foreign cimgui "igIsWindowFocused";
is_root_window_focused              :: proc() -> bool                                                                                                 #foreign cimgui "igIsRootWindowFocused";
is_root_window_or_any_child_focused :: proc() -> bool                                                                                                 #foreign cimgui "igIsRootWindowOrAnyChildFocused";
is_root_window_or_any_child_hovered :: proc() -> bool                                                                                                 #foreign cimgui "igIsRootWindowOrAnyChildHovered";
is_rect_visible                     :: proc(item_size : Vec2) -> bool                                                                                 #foreign cimgui "igIsRectVisible";
is_pos_hovering_any_window          :: proc(pos : Vec2) -> bool                                                                                       #foreign cimgui "igIsPosHoveringAnyWindow";
get_time                            :: proc() -> f32                                                                                                  #foreign cimgui "igGetTime";
get_frame_count                     :: proc() -> i32                                                                                                  #foreign cimgui "igGetFrameCount";
get_style_col_name                  :: proc(idx : GuiCol) -> Cstring                                                                                 #foreign cimgui "igGetStyleColName";
calc_item_rect_closest_point        :: proc(pOut : ^Vec2, pos : Vec2 , on_edge : bool, outward : f32)                                                 #foreign cimgui "igCalcItemRectClosestPoint";
//@TODO(Hoej): Figure that shit out
calc_text_size                      :: proc(pOut : ^Vec2, text : Cstring, text_end : Cstring, hide_text_after_double_hash : bool, wrap_width : f32) #foreign cimgui "igCalcTextSize";
calc_list_clipping                  :: proc(items_count : i32, items_height : f32, out_items_display_start : ^i32, out_items_display_end : ^i32)      #foreign cimgui "igCalcListClipping";

begin_child_frame :: proc(id : GuiID, size : Vec2, extra_flags : GuiWindowFlags) -> bool #foreign cimgui "igBeginChildFrame";
end_child_frame   :: proc()                                                              #foreign cimgui "igEndChildFrame";

color_convert_u32_to_float4 :: proc(pOut : ^Vec4 , in_ : u32)                                            #foreign cimgui "igColorConvertU32ToFloat4";
color_convert_float4_to_u32 :: proc(in_ : Vec4) -> u32                                                   #foreign cimgui "igColorConvertFloat4ToU32";
color_convert_rgb_to_hsv    :: proc(r : f32, g : f32, b : f32, out_h : ^f32, out_s : ^f32, out_v : ^f32) #foreign cimgui "igColorConvertRGBtoHSV";
color_convert_hsv_to_rgb    :: proc(h : f32, s : f32, v : f32, out_r : ^f32, out_g : ^f32, out_b : ^f32) #foreign cimgui "igColorConvertHSVtoRGB";

get_key_index                          :: proc(key : GuiKey) -> i32                              #foreign cimgui "igGetKeyIndex";
isKey_Down                             :: proc(key_index : i32) -> bool                          #foreign cimgui "igIsKeyDown";
isKey_Pressed                          :: proc(key_index : i32, repeat : bool) -> bool           #foreign cimgui "igIsKeyPressed";
isKey_Released                         :: proc(key_index : i32) -> bool                          #foreign cimgui "igIsKeyReleased";
is_mouse_down                          :: proc(button : i32) -> bool                             #foreign cimgui "igIsMouseDown";
is_mouse_clicked                       :: proc(button : i32, repeat : bool) -> bool              #foreign cimgui "igIsMouseClicked";
is_mouse_double_clicked                :: proc(button : i32) -> bool                             #foreign cimgui "igIsMouseDoubleClicked";
is_mouse_released                      :: proc(button : i32) -> bool                             #foreign cimgui "igIsMouseReleased";
is_mouse_hovering_window               :: proc() -> bool                                         #foreign cimgui "igIsMouseHoveringWindow";
is_mouse_hovering_any_window           :: proc() -> bool                                         #foreign cimgui "igIsMouseHoveringAnyWindow";
is_mouse_hovering_rect                 :: proc(r_min : Vec2, r_max : Vec2, clip : bool) -> bool  #foreign cimgui "igIsMouseHoveringRect";
is_mouse_dragging                      :: proc(button : i32, lock_threshold : f32) -> bool       #foreign cimgui "igIsMouseDragging";
get_mouse_pos                          :: proc(pOut : ^Vec2)                                     #foreign cimgui "igGetMousePos";
get_mouse_pos_on_opening_current_popup :: proc(pOut : ^Vec2)                                     #foreign cimgui "igGetMousePosOnOpeningCurrentPopup";
get_mouse_drag_delta                   :: proc(pOut : ^Vec2, button : i32, lock_threshold : f32) #foreign cimgui "igGetMouseDragDelta";
reset_mouse_drag_delta                 :: proc(button : i32)                                     #foreign cimgui "igResetMouseDragDelta";
get_mouse_cursor                       :: proc() -> GuiMouseCursor                               #foreign cimgui "igGetMouseCursor";
set_mouse_cursor                       :: proc(type_ : GuiMouseCursor)                           #foreign cimgui "igSetMouseCursor";
capture_keyboard_from_app              :: proc(capture : bool)                                   #foreign cimgui "igCaptureKeyboardFromApp";
capture_mouse_from_app                 :: proc(capture : bool)                                   #foreign cimgui "igCaptureMouseFromApp";

// Helpers functions to access functions pointers in  ::GetIO()
mem_alloc          :: proc(sz : u64 /*size_t*/) -> rawptr #foreign cimgui "igMemAlloc";
mem_free           :: proc(ptr : rawptr)                  #foreign cimgui "igMemFree";
//@TODO(Hoej): Figure out if these should be wrapped
get_clipboard_text :: proc() -> Cstring                  #foreign cimgui "igGetClipboardText";
set_clipboard_text :: proc(text : Cstring)               #foreign cimgui "igSetClipboardText";

// Internal state access - if you want to share ImGui state between modules (e.g. DLL) or allocate it yourself
get_version         :: proc() -> Cstring                                                                                    #foreign cimgui "igGetVersion";
create_context      :: proc(malloc_fn : proc(size : u64 /*size_t*/) -> rawptr, free_fn : proc(data : rawptr)) -> ^GuiContext #foreign cimgui "igCreateContext";
destroy_context     :: proc(ctx : ^GuiContext)                                                                               #foreign cimgui "igDestroyContext";
get_current_context :: proc() -> ^GuiContext                                                                                 #foreign cimgui "igGetCurrentContext";
set_current_context :: proc(ctx : ^GuiContext)                                                                               #foreign cimgui "igSetCurrentContext";

////////////////////////////////////// Misc    ///////////////////////////////////////////////
font_config_default_constructor :: proc(config : ^FontConfig) #foreign cimgui "ImFontConfig_DefaultConstructor";
gui_io_add_input_character :: proc(c : u16)                   #foreign cimgui "ImGuiIO_AddInputCharacter";
gui_io_add_input_characters_utf8 :: proc(utf8_chars : ^u8)  #foreign cimgui "ImGuiIO_AddInputCharactersUTF8";
gui_io_clear_input_characters :: proc()                       #foreign cimgui "ImGuiIO_ClearInputCharacters";

//////////////////////////////// FontAtlas  //////////////////////////////////////////////
font_atlas_get_text_data_as_rgba32                    :: proc(atlas : ^FontAtlas, out_pixels : ^^u8, out_width : ^i32, out_height : ^i32, out_bytes_per_pixel : ^i32)                                               #foreign cimgui "ImFontAtlas_GetTexDataAsRGBA32";
font_atlas_get_text_data_as_alpha8                    :: proc(atlas : ^FontAtlas, out_pixels : ^^u8, out_width : ^i32, out_height : ^i32, out_bytes_per_pixel : ^i32)                                               #foreign cimgui "ImFontAtlas_GetTexDataAsAlpha8";
font_atlas_set_text_id                                :: proc(atlas : ^FontAtlas, tex : rawptr)                                                                                                                       #foreign cimgui "ImFontAtlas_SetTexID";
font_atlas_add_font_                                  :: proc(atlas : ^FontAtlas, font_cfg : ^FontConfig ) -> ^Font                                                                                                   #foreign cimgui "ImFontAtlas_AddFont";
font_atlas_add_font_default                           :: proc(atlas : ^FontAtlas, font_cfg : ^FontConfig ) -> ^Font                                                                                                   #foreign cimgui "ImFontAtlas_AddFontDefault";

font_atlas_add_font_from_file_ttf                     :: proc(atlas : ^FontAtlas, filename : string, size_pixels : f32, font_cfg : ^FontConfig, glyph_ranges : ^Wchar) -> ^Font {
    im_font_atlas_add_font_from_file_ttf :: proc(atlas : ^FontAtlas, filename : Cstring, size_pixels : f32, font_cfg : ^FontConfig, glyph_ranges : ^Wchar) -> ^Font #foreign cimgui "ImFontAtlas_AddFontFromFileTTF";
    return im_font_atlas_add_font_from_file_ttf(atlas, _make_misc_string(filename), size_pixels, font_cfg, glyph_ranges);
}

font_atlas_add_font_from_memory_ttf                   :: proc(atlas : ^FontAtlas, ttf_data : rawptr, ttf_size : i32, size_pixels : f32, font_cfg : ^FontConfig, glyph_ranges : ^Wchar) -> ^Font                       #foreign cimgui "ImFontAtlas_AddFontFromMemoryTTF";
font_atlas_add_font_from_memory_compressed_ttf        :: proc(atlas : ^FontAtlas, compressed_ttf_data : rawptr, compressed_ttf_size : i32, size_pixels : f32, font_cfg : ^FontConfig, glyph_ranges : ^Wchar) -> ^Font #foreign cimgui "ImFontAtlas_AddFontFromMemoryCompressedTTF";
font_atlas_add_font_from_memory_compressed_base85_ttf :: proc(atlas : ^FontAtlas, compressed_ttf_data_base85 : Cstring, size_pixels : f32, font_cfg : ^FontConfig, glyph_ranges : ^Wchar) -> ^Font                   #foreign cimgui "ImFontAtlas_AddFontFromMemoryCompressedBase85TTF";
font_atlas_clear_tex_data                             :: proc(atlas : ^FontAtlas)                                                                                                                                     #foreign cimgui "ImFontAtlas_ClearTexData";
font_atlas_clear                                      :: proc(atlas : ^FontAtlas)                                                                                                                                     #foreign cimgui "ImFontAtlas_Clear";

//////////////////////////////// DrawList  //////////////////////////////////////////////
draw_list_get_vertex_buffer_size :: proc(list : ^DrawList) -> i32                #foreign cimgui "ImDrawList_GetVertexBufferSize";
draw_list_get_vertex_ptr         :: proc(list : ^DrawList, n : i32) -> ^DrawVert #foreign cimgui "ImDrawList_GetVertexPtr";
draw_list_get_index_buffer_size  :: proc(list : ^DrawList) -> i32                #foreign cimgui "ImDrawList_GetIndexBufferSize";
draw_list_get_index_ptr          :: proc(list : ^DrawList, n : i32) -> ^DrawIdx  #foreign cimgui "ImDrawList_GetIndexPtr";
draw_list_get_cmd_size           :: proc(list : ^DrawList) -> i32                #foreign cimgui "ImDrawList_GetCmdSize";
draw_list_get_cmd_ptr            :: proc(list : ^DrawList, n : i32) -> ^DrawCmd  #foreign cimgui "ImDrawList_GetCmdPtr";

draw_list_clear                      :: proc(list : ^DrawList)                                                                                      #foreign cimgui "ImDrawList_Clear";
draw_list_clear_free_memory          :: proc(list : ^DrawList)                                                                                      #foreign cimgui "ImDrawList_ClearFreeMemory";
draw_list_push_clip_rect             :: proc(list : ^DrawList, clip_rect_min : Vec2, clip_rect_max : Vec2, intersect_with_current_clip_rect : bool) #foreign cimgui "ImDrawList_PushClipRect";
draw_list_push_clip_rect_full_screen :: proc(list : ^DrawList)                                                                                      #foreign cimgui "ImDrawList_PushClipRectFullScreen";
draw_list_pop_clip_rect              :: proc(list : ^DrawList)                                                                                      #foreign cimgui "ImDrawList_PopClipRect";
draw_list_push_texture_id            :: proc(list : ^DrawList, texture_id : TextureID)                                                              #foreign cimgui "ImDrawList_PushTextureID";
draw_list_pop_texture_id             :: proc(list : ^DrawList)                                                                                      #foreign cimgui "ImDrawList_PopTextureID";

// Primitives
draw_list_add_line                    :: proc(list : ^DrawList, a : Vec2, b : Vec2, col : u32, thickness : f32)                                                                                                 #foreign cimgui "ImDrawList_AddLine";
draw_list_add_rect                    :: proc(list : ^DrawList, a : Vec2, b : Vec2, col : u32, rounding : f32, rounding_corners : i32, thickness : f32)                                                         #foreign cimgui "ImDrawList_AddRect";
draw_list_add_rect_filled             :: proc(list : ^DrawList, a : Vec2, b : Vec2, col : u32, rounding : f32, rounding_corners : i32)                                                                          #foreign cimgui "ImDrawList_AddRectFilled";
draw_list_add_rect_filled_multi_color :: proc(list : ^DrawList, a : Vec2, b : Vec2, col_upr_left : u32, col_upr_right : u32, col_bot_right : u32, col_bot_left : u32)                                           #foreign cimgui "ImDrawList_AddRectFilledMultiColor";
draw_list_add_quad                    :: proc(list : ^DrawList, a : Vec2, b : Vec2, c : Vec2, d : Vec2, col : u32, thickness : f32)                                                                             #foreign cimgui "ImDrawList_AddQuad";
draw_list_add_quad_filled             :: proc(list : ^DrawList, a : Vec2, b : Vec2, c : Vec2, d : Vec2, col : u32)                                                                                              #foreign cimgui "ImDrawList_AddQuadFilled";
draw_list_add_triangle                :: proc(list : ^DrawList, a : Vec2, b : Vec2, c : Vec2, col : u32, thickness : f32)                                                                                       #foreign cimgui "ImDrawList_AddTriangle";
draw_list_add_triangle_filled         :: proc(list : ^DrawList, a : Vec2, b : Vec2, c : Vec2, col : u32)                                                                                                        #foreign cimgui "ImDrawList_AddTriangleFilled";
draw_list_add_circle                  :: proc(list : ^DrawList, centre : Vec2, radius : f32, col : u32, num_segments : i32, thickness : f32)                                                                    #foreign cimgui "ImDrawList_AddCircle";
draw_list_add_circle_filled           :: proc(list : ^DrawList, centre : Vec2, radius : f32, col : u32, num_segments : i32)                                                                                     #foreign cimgui "ImDrawList_AddCircleFilled";

//@TODO(Hoej); Figure that shit out
draw_list_add_text                    :: proc(list : ^DrawList, pos : Vec2, col : u32, text_begin : Cstring, text_end : Cstring)                                                                              #foreign cimgui "ImDrawList_AddText";
draw_list_add_text_ext                :: proc(list : ^DrawList, font : ^Font, font_size : f32, pos : Vec2, col : u32, text_begin : Cstring, text_end : Cstring, wrap_width : f32, cpu_fine_clip_rect : ^Vec4) #foreign cimgui "ImDrawList_AddTextExt";

draw_list_add_image                   :: proc(list : ^DrawList, user_texture_id : TextureID, a : Vec2, b : Vec2, uv0 : Vec2, uv1 : Vec2, col : u32)                                                             #foreign cimgui "ImDrawList_AddImage";
draw_list_add_poly_line               :: proc(list : ^DrawList, points : ^Vec2, num_points : i32, col : u32, closed : bool, thickness : f32, anti_aliased : bool)                                               #foreign cimgui "ImDrawList_AddPolyline";
draw_list_add_convex_poly_filled      :: proc(list : ^DrawList, points : ^Vec2, num_points : i32, col : u32, anti_aliased : bool)                                                                               #foreign cimgui "ImDrawList_AddConvexPolyFilled";
draw_list_add_bezier_curve            :: proc(list : ^DrawList, pos0 : Vec2, cp0 : Vec2, cp1 : Vec2, pos1 : Vec2, col : u32, thickness : f32, num_segments : i32)                                               #foreign cimgui "ImDrawList_AddBezierCurve";

// Stateful path API, add points then finish with PathFill() or PathStroke()
draw_list_path_clear                   :: proc(list : ^DrawList)                                                                            #foreign cimgui "ImDrawList_PathClear";
draw_list_path_line_to                 :: proc(list : ^DrawList, pos : Vec2)                                                                #foreign cimgui "ImDrawList_PathLineTo";
draw_list_path_line_to_merge_duplicate :: proc(list : ^DrawList, pos : Vec2)                                                                #foreign cimgui "ImDrawList_PathLineToMergeDuplicate";
draw_list_path_fill                    :: proc(list : ^DrawList, col : u32)                                                                 #foreign cimgui "ImDrawList_PathFill";
draw_list_path_stroke                  :: proc(list : ^DrawList, col : u32, closed : bool, thickness : f32)                                 #foreign cimgui "ImDrawList_PathStroke";
draw_list_path_arc_to                  :: proc(list : ^DrawList, centre : Vec2, radius : f32, a_min : f32, a_max : f32, num_segments : i32) #foreign cimgui "ImDrawList_PathArcTo";
draw_list_path_arc_to_fast             :: proc(list : ^DrawList, centre : Vec2, radius : f32, a_min_of_12 : i32, a_max_of_12 : i32)         #foreign cimgui "ImDrawList_PathArcToFast"; // Use precomputed angles for a 12 steps circle
draw_list_path_bezier_curve_to         :: proc(list : ^DrawList, p1 : Vec2, p2 : Vec2, p3 : Vec2, num_segments : i32)                       #foreign cimgui "ImDrawList_PathBezierCurveTo";
draw_list_path_rect                    :: proc(list : ^DrawList, rect_min : Vec2, rect_max : Vec2, rounding : f32, rounding_corners : i32)  #foreign cimgui "ImDrawList_PathRect";

// Channels
draw_list_channels_split       :: proc(list : ^DrawList, channels_count : i32) #foreign cimgui "ImDrawList_ChannelsSplit";
draw_list_channels_merge       :: proc(list : ^DrawList)                       #foreign cimgui "ImDrawList_ChannelsMerge";
draw_list_channels_set_current :: proc(list : ^DrawList, channel_index : i32)  #foreign cimgui "ImDrawList_ChannelsSetCurrent";

// Advanced
// Your rendering function must check for 'UserCallback' in ImDrawCmd and call the function instead of rendering triangles.
draw_list_add_callback      :: proc(list : ^DrawList, callback : draw_callback, callback_data : rawptr)                                                     #foreign cimgui "ImDrawList_AddCallback";
// This is useful if you need to forcefully create a new draw call(to allow for dependent rendering / blending). Otherwise primitives are merged into the same draw-call as much as possible
draw_list_add_draw_cmd      :: proc(list : ^DrawList)                                                                                                       #foreign cimgui "ImDrawList_AddDrawCmd";
// Internal helpers
draw_list_prim_reserve      :: proc(list : ^DrawList, idx_count : i32, vtx_count : i32)                                                                     #foreign cimgui "ImDrawList_PrimReserve";
draw_list_prim_rect         :: proc(list : ^DrawList, a : Vec2, b : Vec2, col : u32)                                                                        #foreign cimgui "ImDrawList_PrimRect";
draw_list_prim_rectuv       :: proc(list : ^DrawList, a : Vec2, b : Vec2, uv_a : Vec2, uv_b : Vec2, col : u32)                                              #foreign cimgui "ImDrawList_PrimRectUV";
draw_list_prim_quaduv       :: proc(list : ^DrawList,a : Vec2, b : Vec2, c : Vec2, d : Vec2, uv_a : Vec2, uv_b : Vec2, uv_c : Vec2, uv_d : Vec2, col : u32) #foreign cimgui "ImDrawList_PrimQuadUV";
draw_list_prim_writevtx     :: proc(list : ^DrawList, pos : Vec2, uv : Vec2, col : u32)                                                                     #foreign cimgui "ImDrawList_PrimWriteVtx";
draw_list_prim_writeidx     :: proc(list : ^DrawList, idx : DrawIdx)                                                                                        #foreign cimgui "ImDrawList_PrimWriteIdx";
draw_list_prim_vtx          :: proc(list : ^DrawList, pos : Vec2, uv : Vec2, col : u32)                                                                     #foreign cimgui "ImDrawList_PrimVtx";
draw_list_update_clip_rect  :: proc(list : ^DrawList)                                                                                                       #foreign cimgui "ImDrawList_UpdateClipRect";
draw_list_update_texture_id :: proc(list : ^DrawList)                                                                                                       #foreign cimgui "ImDrawList_UpdateTextureID";