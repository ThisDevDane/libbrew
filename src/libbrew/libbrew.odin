/*
 *  @Name:     libbrew
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    hjortshoej@handmade.network
 *  @Creation: 31-05-2017 22:01:38
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 15-06-2017 21:07:45
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

import "fmt.odin";
import "strings.odin";
import win32 "sys/windows.odin";

import_load "win/window.odin" when ODIN_OS == "windows";
import_load "win/opengl.odin" when ODIN_OS == "windows";
import_load "win/opengl_wgl.odin" when ODIN_OS == "windows";
import_load "win/keys.odin" when ODIN_OS == "windows";
import_load "win/misc.odin" when ODIN_OS == "windows";
import_load "win/msg.odin" when ODIN_OS == "windows";