/*
 *  @Name:     libbrew
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    hjortshoej@handmade.network
 *  @Creation: 31-05-2017 22:01:38
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 11-12-2017 01:56:13
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
        [X] WM_CHAR
        [ ] WM_WCHAR
    [X] Make an OpenGL Context
    [ ] Messages
        [ ] Handle mouse enter and leave
        [ ] Handle window destory messages better
    [ ] Provide mechanism to hot-reload DLLs
        [ ]  Maybe make the app go through a DLL
    [ ] Dear ImGui
        [ ] Handle passing the Context through a DLL boundry
    [x] Traverse File Directory
    [ ] Maybe handle file I/O or just use os.odin?
    [ ] Use Unicode everywhere instead of ASCI.
    [ ] Audio! (FML, probably just openal tbh)
*/