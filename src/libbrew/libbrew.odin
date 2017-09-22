/*
 *  @Name:     libbrew
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    hjortshoej@handmade.network
 *  @Creation: 31-05-2017 22:01:38
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 22-09-2017 22:07:26
 *  
 *  @Description:
 *      SDL like library to ease development 
 */

/*
TODO list
    [X] Window Creation
    [ ] Get Input from message queue
        [X] Sys key
        [X] Key
        [ ] WM_CHAR
        [ ] WM_WCHAR
    [X] Make an OpenGL Context
    [ ] Messages
        [ ] Handle mouse enter and leave
        [ ] Handle window destory messages better
    [ ] Provide mechanism to hot-reload DLLs
        [ ]  Maybe make the app go through a DLL
    [ ] Dear ImGui
        [ ] Handle passing the Context through a DLL boundry
    [ ] Traverse File Directory
    [ ] Maybe handle file I/O or just use os.odin?
    [ ] Handle Unicode everywhere.
    [ ] Audio!
*/

import "core:fmt.odin";
import "core:strings.odin";
import win32 "core:sys/windows.odin";

export "win/window.odin" when ODIN_OS == "windows";
export "win/opengl.odin" when ODIN_OS == "windows";
export "win/opengl_wgl.odin" when ODIN_OS == "windows";
export "win/keys.odin" when ODIN_OS == "windows";
export "win/misc.odin" when ODIN_OS == "windows";
export "win/msg.odin" when ODIN_OS == "windows";