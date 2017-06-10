/*
 *  @Name:     opengl
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    hjortshoej@handmade.network
 *  @Creation: 10-06-2017 16:57:06
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 10-06-2017 16:58:47
 *  
 *  @Description:
 *  
 */

#import "sys/wgl.odin";

GlContext :: wgl.Hglrc;

create_gl_conext :: proc() -> GlContext {
    return nil;
}