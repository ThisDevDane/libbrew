/*
 *  @Name:     msg_user
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    hjortshoej@handmade.network
 *  @Creation: 10-06-2017 16:42:50
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 15-06-2017 21:32:57
 *  
 *  @Description:
 *  
 */

import win32 "sys/windows.odin";

const {
    // @wparam Indicates whether the window is being activated or deactivated
    WINDOW_FOCUS   = win32.WM_USER + 1;
    // @wparam Indicates if we got keyboard focus or not.
    KEYBOARD_FOCUS = win32.WM_USER + 2;
}