/*
 *  @Name:     imgui_console
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    hjortshoej@handmade.network
 *  @Creation: 10-05-2017 21:11:30
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 02-08-2018 22:56:42 UTC+1
 *  
 *  @Description:
 *      The console is an in engine window that can be pulled up for viewing.
 *      It also takes care of outputting to a log file if enabled.
 *      The console can also execute commands if matched with input.
 */
 
package console;

import       "core:fmt";
import       "core:os";
import       "core:mem";
import       "core:strings";
import       "core:sys/win32";

import       "shared:libbrew/imgui"
import util  "shared:libbrew/util"
import imgui "shared:odin-imgui";

OUTPUT_TO_CLI  :: true;
OUTPUT_TO_FILE :: false;

_BUF_SIZE :: 2048;

CommandProc :: #type proc(args : []string);

LogData :: struct {
    input_buf     : [256]u8,
    log           : [dynamic]LogItem,
    history       : [dynamic]string,
    current_log   : [dynamic]LogItem,
    commands      : map[string]CommandProc,
    log_file_name : string,

    _scroll_to_bottom : bool,
    _history_pos      : int, 
}

LogItem :: struct {
    text     : string,
    time     : win32.Systemtime,
    level    : LogLevel,
    loc_file : string,
    loc_line : int
}

_internal_data := LogData{};

LogLevel :: enum {
    Info,
    ConsoleInput,
    Error,
    Warning,
}

_log_level_strings := []string{
    "[Info]:",
    "\\\\:",
    "[Error]:",
    "[Warning]:"
};

_error_callback : proc();

logf :: proc(fmt_ : string, args : ..any, loc := #caller_location) {
    data : [_BUF_SIZE]u8;
    buf  := fmt.string_buffer_from_slice(data[:]);
    str  := fmt.sbprintf(&buf, fmt_, ..args);   
    _internal_log(LogLevel.Info, str, loc);
}

log :: proc(args : ..any, loc := #caller_location) {
    data : [_BUF_SIZE]u8;
    buf  := fmt.string_buffer_from_slice(data[:]);
    str  := fmt.sbprint(&buf, ..args);   
    _internal_log(LogLevel.Info, str, loc);
}

logf_warning :: proc(fmt_ : string, args : ..any, loc := #caller_location) {
    data : [_BUF_SIZE]u8;
    buf  := fmt.string_buffer_from_slice(data[:]);
    str  := fmt.sbprintf(&buf, fmt_, ..args);   
    _internal_log(LogLevel.Warning, str, loc);
}

log_warning :: proc(args : ..any, loc := #caller_location) {
    data : [_BUF_SIZE]u8;
    buf  := fmt.string_buffer_from_slice(data[:]);
    str  := fmt.sbprint(&buf, ..args);   
    _internal_log(LogLevel.Warning, str, loc);
}


logf_error :: proc(fmt_ : string, args : ..any, loc := #caller_location) {
    buf  : [_BUF_SIZE]u8;
    str := fmt.bprintf(buf[:], fmt_, ..args);   
    _internal_log(LogLevel.Error, str, loc);
    if _error_callback != nil {
        _error_callback();
    }
}

log_error :: proc(args : ..any, loc := #caller_location) {
    buf  : [_BUF_SIZE]u8;
    str := fmt.bprint(buf[:], ..args);   
    _internal_log(LogLevel.Error, str, loc);
    if _error_callback != nil {
        _error_callback();
    }
}

set_error_callback :: proc(callback : proc()) {
    _error_callback = callback;
}

_get_system_time :: proc() -> win32.Systemtime {
    ft : win32.Filetime;
    st : win32.Systemtime
;    win32.get_system_time_as_file_time(&ft);
    win32.file_time_to_system_time(&ft, &st);

    return st;
}

_internal_log :: proc(level : LogLevel, txt : string, loc := #caller_location) {
    item         := LogItem{};
    item.text     = strings.new_string(txt);
    item.time     = _get_system_time();;
    item.level    = level;
    item.loc_line = loc.line;
    item.loc_file = util.remove_path_from_file(loc.file_path);

    append(&_internal_data.current_log, item);
    item.text = strings.new_string(txt); //Note: needed cause clear console free's the item.text
    append(&_internal_data.log, item);
    _internal_data._scroll_to_bottom = true;
  
    when OUTPUT_TO_FILE {
        _update_log_file();
    }
    when OUTPUT_TO_CLI {
        h := os.stdout;
        level_col := FOR_GREEN;
        switch level {
            case LogLevel.Warning : {
                h = os.stderr;
                level_col = FOR_YELLOW;
            }

            case LogLevel.Error : {
                h = os.stderr;
                level_col = FOR_RED;
            }

            case LogLevel.ConsoleInput : {
                h = os.stdin;
                level_col = NORM;
            }
        }

        //TODO(Hoej): Figure out where to put this
        NORM        :: "\x1b[0m";

        FOR_BLACK   :: "\x1b[30m";
        FOR_RED     :: "\x1b[31m";
        FOR_GREEN   :: "\x1b[32m";
        FOR_YELLOW  :: "\x1b[33m";
        FOR_BLUE    :: "\x1b[34m";
        FOR_MAGENTA :: "\x1b[35m";
        FOR_CYAN    :: "\x1b[36m";
        FOR_WHITE   :: "\x1b[37m";

        BACK_BLACK   :: "\x1b[40m";
        BACK_RED     :: "\x1b[41m";
        BACK_GREEN   :: "\x1b[42m";
        BACK_YELLOW  :: "\x1b[43m";
        BACK_BLUE    :: "\x1b[44m";
        BACK_MAGENTA :: "\x1b[45m";
        BACK_CYAN    :: "\x1b[46m";
        BACK_WHITE   :: "\x1b[47m"; 

        fmt.fprintf(h, "%s%s %s%s\n", level_col, _log_level_strings[level], NORM, txt);
    }
}

//TODO(Hoej): make this appedn to the logfile instead of truncating everytime. Should be faster
_update_log_file :: proc() {
    if len(_internal_data.log_file_name) <= 0 {
        st := _get_system_time();
        buf := make([]u8, 255);
        _internal_data.log_file_name = fmt.bprintf(buf[:], "%d-%d-%d_%d%d%d.jlog", 
                                                st.day, st.month, st.year, 
                                                st.hour, st.minute, st.second);
    }

    h, _ := os.open(_internal_data.log_file_name, os.O_WRONLY | os.O_CREATE | os.O_TRUNC, 0);
    os.seek(h, 0, 2);
    for log in _internal_data.log {
        buf : [_BUF_SIZE]u8;
        str := fmt.bprintf(buf[:], "[%2d:%2d:%2d-%3d]%s %s\n", _log_level_strings[log.level],
                                                               log.time.hour,   log.time.minute, 
                                                               log.time.second, log.time.millisecond, 
                                                               log.text);
        os.write(h, cast([]u8)str); 
        os.seek(h, 0, 2);
    }
    os.close(h);   
} 

add_command :: proc(name : string p : CommandProc) {
    _internal_data.commands[name] = p;
}

default_help_command :: proc(args : []string) {
    log("Available Commands: ");
    for key, val in _internal_data.commands {
        logf("\t%s", key);
    }
}

default_clear_command :: proc(args : []string) {
    clear_console();
}

add_default_commands :: proc() {
    add_command("Clear", default_clear_command);
    add_command("Help",  default_help_command);
}

draw_log :: proc(show : ^bool) {
    imgui.begin("Log##Console", show,  imgui.Window_Flags.NoCollapse);
    {
        imgui.begin_child("Items");
        {
            imgui.push_font(brew_imgui.mono_font); // Pushes Poggy Clean
            defer imgui.pop_font();
            imgui.columns(count = 4, border = false);
            for t in _internal_data.log {
                imgui.set_column_width(width = 80);
                imgui.text("%2d:%2d:%2d-%3d", t.time.hour, t.time.minute, t.time.second, t.time.millisecond);
                imgui.next_column();
                pop := false;
                switch t.level {
                    case LogLevel.Error : {
                        imgui.push_style_color(imgui.Color.Text, imgui.Vec4{1, 0, 0, 1});
                        pop = true;
                    }

                    case LogLevel.Warning : {
                        imgui.push_style_color(imgui.Color.Text, imgui.Vec4{0.96, 0.86, 0.26, 1});
                        pop = true;
                    }

                    case LogLevel.ConsoleInput : {
                        imgui.push_style_color(imgui.Color.Text, imgui.Vec4{0.7, 0.7, 0.7, 1});
                        pop = true;
                    }
                }

                imgui.set_column_width(width = 70);
                imgui.text(_log_level_strings[t.level]);
                imgui.next_column();
                imgui.set_column_width(width = 150);
                imgui.text("(%s:%d)", t.loc_file, t.loc_line);
                imgui.next_column();
                imgui.text(t.text);
                if pop do imgui.pop_style_color();
                imgui.next_column();
            }
        }
        imgui.end_child();
    }
    imgui.end();
}


draw_history :: proc(show : ^bool) {
    if imgui.begin("History", show,  imgui.Window_Flags.NoCollapse) {
        defer imgui.end();
        imgui.push_font(brew_imgui.mono_font); // Pushes Poggy Clean
        defer imgui.pop_font();
        if imgui.begin_child("Items") {
            for t in _internal_data.history {
                imgui.text(t);
            }
        }
        imgui.end_child();
    }
}

draw_console :: proc(show : ^bool, show_log : ^bool, show_history : ^bool) {
    imgui.begin("Console", show, imgui.Window_Flags.NoCollapse | imgui.Window_Flags.MenuBar);
    {
        if imgui.begin_menu_bar() {
            if imgui.begin_menu("Misc", true) {
                if imgui.menu_item("Show Log", "", false, len(_internal_data.log) > 0) {
                    
                    show_log^ = !show_log^;
                }             
                if imgui.menu_item("Show History", "", false, len(_internal_data.log) > 0) {
                    
                    show_history^ = !show_history^;
                }      
                if imgui.menu_item("Clear", "", false, len(_internal_data.current_log) > 0) {
                    clear_console();
                }

                imgui.end_menu();
            }
            imgui.end_menu_bar();
        }

        if imgui.begin_child("Buffer", imgui.Vec2{-1, -40}, true) {
            imgui.push_font(brew_imgui.mono_font); // Pushes Poggy Clean
            defer imgui.pop_font();
            for t in _internal_data.current_log {
                pop := false;
                switch t.level {
                    case LogLevel.Error : {
                        imgui.push_style_color(imgui.Color.Text, imgui.Vec4{1, 0, 0, 1});
                        pop = true;
                    }

                    case LogLevel.Warning : {
                        imgui.push_style_color(imgui.Color.Text, imgui.Vec4{0.96, 0.86, 0.26, 1});
                        pop = true;
                    }
                    case LogLevel.ConsoleInput : {
                        imgui.push_style_color(imgui.Color.Text, imgui.Vec4{0.7, 0.7, 0.7, 1});
                        pop = true;
                    }
                }
                imgui.text(_log_level_strings[t.level]); imgui.same_line();
                imgui.text_wrapped(t.text);
                if pop do imgui.pop_style_color();
            }

            if _internal_data._scroll_to_bottom {
                imgui.set_scroll_here(0.5);
            }
            _internal_data._scroll_to_bottom = false;
        }
        imgui.end_child();

        TEXT_FLAGS :: imgui.Input_Text_Flags.EnterReturnsTrue | imgui.Input_Text_Flags.CallbackCompletion | imgui.Input_Text_Flags.CallbackHistory;
        if imgui.input_text("##Input", _internal_data.input_buf[:], TEXT_FLAGS, _text_edit_callback) {
            imgui.set_keyboard_focus_here(-1);
            enter_input(_internal_data.input_buf[:]);
        }
        imgui.same_line(0, -1);
        if imgui.button("Enter", imgui.Vec2{-1, 0}) {
            enter_input(_internal_data.input_buf[:]);
        }
        imgui.separator();
        imgui.text_colored(imgui.Vec4{1, 1, 1, 0.2}, "Current: %d | Log : %d | History: %d", len(_internal_data.current_log), 
                                                                                             len(_internal_data.log), 
                                                                                             len(_internal_data.history));
    }
    imgui.end();
}

enter_input :: proc(input : []u8) {
    if input[0] != 0 &&
       input[0] != ' ' {
        i := _find_string_null(input[:]);
        str := string(input[0:i]);
        _internal_log(LogLevel.ConsoleInput, str);
        append(&_internal_data.history, strings.new_string(str)); 
        if !execute_command(str) {
            cmd_name, _ := util.split_first(str, ' ');
            logf_warning("%s is not a command", cmd_name);
        }
        input[0] = 0;
        _internal_data._scroll_to_bottom = true;
        _internal_data._history_pos = 0;
    }
}

clear_console :: proc() {
    for t in _internal_data.current_log {
        delete(t.text);
    }
    clear(&_internal_data.current_log);
}

execute_command :: proc(cmdString : string) -> bool {
    name, _ := util.split_first(cmdString, ' ');
    if cmd, ok := _internal_data.commands[name]; ok {
        args : [dynamic]string;
        //TODO(Hoej): Revisist all of this
        if len(cmdString) != len(name) {
            p := 0;
            newStr := cmdString[len(name)+1:];
            for r, i in newStr {
                if r == ' ' {
                    append(&args, newStr[p:i]);
                    p = i+1;
                }

                if i == len(newStr)-1 {
                    append(&args, newStr[p:i+1]);
                }
            }
        }
        cmd(args[:]);
        return true;
    }
    return false;
}

_text_edit_callback :: proc "cdecl"(data : ^imgui.TextEditCallbackData) -> i32{
    switch data.event_flag {
        case imgui.Input_Text_Flags.CallbackHistory : {
            using _internal_data;
            prev := _history_pos;

            if data.event_key == imgui.Key.UpArrow {
                if _history_pos == 0 {
                    _history_pos = len(history);
                } else {
                    _history_pos -= 1;
                }
            } else if data.event_key == imgui.Key.DownArrow {
                if _history_pos != 0 {
                    _history_pos += 1;
                    if _history_pos > len(history) {
                        _history_pos = 0;
                    }
                }
            }

            if prev != _history_pos {
                pos := _history_pos > 0 ? _history_pos-1 : -1;  
                slice := cast([]u8)mem.slice_ptr(&data.buf^, int(data.buf_size));
                str := fmt.bprintf(slice, "%s", pos < 0 ? "" : history[pos]);
                strlen := i32(len(str));
                data.buf_text_len = strlen;
                data.cursor_pos = strlen;
                data.selection_start = strlen;
                data.selection_end = strlen;
                data.buf_dirty = true;
            }
        }

        case imgui.Input_Text_Flags.CallbackCompletion : {
            //TODO(Hoej): Tab to complete partial command/cycle
            //            or maybe just print a list of commands that could match 
        }
    }

    return 0;
}

_find_string_null :: proc(s : []u8) -> int {
    for r, i in s {
        if r == 0 {
            return i;
        }
    }

    return -1;
}