/*
 *  @Name:     example
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    hjortshoej@handmade.network
 *  @Creation: 31-05-2017 21:57:56
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 01-06-2017 02:47:08
 *  
 *  @Description:
 *      Example for LibBrew
 */
#import "fmt.odin";
#import "libbrew/libbrew.odin";

main :: proc() {
    appHandle := libbrew.get_app_handle();
    wndHandle := libbrew.create_window(appHandle, "LibBrew Example", 1280, 720);
    message : libbrew.Msg;
    i : int;
main_loop: 
    for {
        for libbrew.poll_message(&message) {
            match msg in message {
                case libbrew.Msg.QuitMessage : {
                    break main_loop;
                }

                case libbrew.Msg.KeyDown : {
                    if msg.Key == libbrew.VirtualKey.Escape {
                        break main_loop;
                    }
                }
            }
        }
        
        libbrew.sleep(1);
    }
}