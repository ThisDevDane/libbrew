/*
 *  @Name:     asset
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    hjortshoej@handmade.network
 *  @Creation: 21-04-2017 03:04:34
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 12-08-2018 22:25:43 UTC+1
 *  
 *  @Description:
 *      Contains the asset construct and associated data.
 */
package main;

import "core:math";
import gl "shared:libbrew/gl";

Asset_Info :: struct {
    file_name : string,
    path      : string,
    size      : int,
    loaded    : bool,
}

Asset :: struct {
    using info : Asset_Info,
    derived    : union {^Texture, ^Shader, ^TextAsset, ^Font, ^Model_3d, ^Unknown},
}

Texture :: struct {
    using asset : ^Asset,
    gl_id       : gl.Texture,
    width       : i32,
    height      : i32,
    comp        : i32,
    data        : ^u8
}

Shader :: struct {
    using asset : ^Asset,
    gl_id       : gl.Shader,
    type_       : gl.ShaderTypes,
    program     : gl.Program,

    data        : []u8,
    source      : string,
    fnv64_hash  : u64,
}

TextAsset :: struct {
    using asset : ^Asset,
    text        : string,
    extension   : string,
}

Font :: struct {
    using asset : ^Asset,
    data        : []u8,
}

Vertex :: struct {
    pos   : math.Vec3,
    uv    : math.Vec2,
    norm  : math.Vec3,
    color : math.Vec3,
}

Model_3d :: struct {
    using asset : ^Asset,
    vertices : [dynamic]Vertex,
}

Unknown :: struct {
}
