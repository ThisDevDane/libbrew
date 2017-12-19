/*
 *  @Name:     time_util
 *  
 *  @Author:   Brendan Punsky
 *  @Email:    bpunsky@gmail.com
 *  @Creation: 18-12-2017 23:32:57 UTC-5
 *
 *  @Last By:   Brendan Punsky
 *  @Last Time: 18-12-2017 23:33:22 UTC-5
 *  
 *  @Description:
 *  
 */

Timer :: struct {
    length : f64,
    accum  : f64,
}

create_timer :: proc(length : f64) -> Timer {
    return Timer{length=length};
}

query :: proc(timer : ^Timer, dt : f64) -> bool {
    timer.accum += dt;

    if timer.accum >= timer.length {
        timer.accum -= timer.length;
        return true;
    }

    return false;
}
