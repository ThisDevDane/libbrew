/*
 *  @Name:     libbrew
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    hjortshoej@handmade.network
 *  @Creation: 31-05-2017 22:01:38
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 01-06-2017 02:38:15
 *  
 *  @Description:
 *      SDL like library to easy development 
 */

/*
TODO list
    [X] Window Creation
    [X] Get Input from message queue
    [ ] Make an OpenGL Contxt
    [ ] Provide mechanism to hot-reload DLLs
    [ ] Traverse File Directory
    [ ] Maybe handle file I/O or just use os.odin?
    [ ] Handle Unicode in window title and such.
*/

#import "fmt.odin";
#import "strings.odin";
#import win32 "sys/windows.odin";

#load "win/window.odin" when ODIN_OS == "windows";
#load "win/keys.odin" when ODIN_OS == "windows";
#load "win/misc.odin" when ODIN_OS == "windows";
#load "win/msg.odin" when ODIN_OS == "windows";