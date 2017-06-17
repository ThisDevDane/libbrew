/*
 *  @Name:     gl_enums
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    hjortshoej@handmade.network
 *  @Creation: 02-05-2017 21:38:35
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 15-06-2017 21:26:47
 *  
 *  @Description:
 *      Part of the GL Wrapper, makes enum for all constants.
 */
import gl_const "opengl_constants.odin";

type GetShaderNames enum i32 {
    ShaderType = gl_const.SHADER_TYPE,
    DeleteStatus = gl_const.DELETE_STATUS,
    CompileStatus = gl_const.COMPILE_STATUS,
    InfoLogLength = gl_const.INFO_LOG_LENGTH,
    ShaderSourceLength = gl_const.SHADER_SOURCE_LENGTH,
}

type DebugSource enum i32 {
    Api                                = gl_const.DEBUG_SOURCE_API,
    WindowSystem                       = gl_const.DEBUG_SOURCE_WINDOW_SYSTEM,
    ShaderCompiler                     = gl_const.DEBUG_SOURCE_SHADER_COMPILER,
    ThirdParty                         = gl_const.DEBUG_SOURCE_THIRD_PARTY,
    Application                        = gl_const.DEBUG_SOURCE_APPLICATION,
    Other                              = gl_const.DEBUG_SOURCE_OTHER,
    DontCare                           = gl_const.DONT_CARE,
}

type DebugType enum i32 {
    Error                              = gl_const.DEBUG_TYPE_ERROR,
    DeprecatedBehavior                 = gl_const.DEBUG_TYPE_DEPRECATED_BEHAVIOR,
    UndefinedBehavior                  = gl_const.DEBUG_TYPE_UNDEFINED_BEHAVIOR,
    Portability                        = gl_const.DEBUG_TYPE_PORTABILITY,
    Performance                        = gl_const.DEBUG_TYPE_PERFORMANCE,
    Marker                             = gl_const.DEBUG_TYPE_MARKER,
    PushGroup                          = gl_const.DEBUG_TYPE_PUSH_GROUP,
    PopGroup                           = gl_const.DEBUG_TYPE_POP_GROUP,
    Other                              = gl_const.DEBUG_TYPE_OTHER,
    DontCare                           = gl_const.DONT_CARE,
}

type DebugSeverity enum i32 {
    High                               = gl_const.DEBUG_SEVERITY_HIGH,
    Medium                             = gl_const.DEBUG_SEVERITY_MEDIUM,
    Low                                = gl_const.DEBUG_SEVERITY_LOW,
    Notification                       = gl_const.DEBUG_SEVERITY_NOTIFICATION,
    DontCare                           = gl_const.DONT_CARE,
}

type DrawModes enum i32 {
    Points                             = gl_const.POINTS, 
    LineStrip                          = gl_const.LINE_STRIP,
    LineLoop                           = gl_const.LINE_LOOP, 
    Lines                              = gl_const.LINES,
    LineStripAdjacency                 = gl_const.LINE_STRIP_ADJACENCY,
    LinesAdjacency                     = gl_const.LINES_ADJACENCY,
    TriangleStrip                      = gl_const.TRIANGLE_STRIP,
    TriangleFan                        = gl_const.TRIANGLE_FAN,
    Triangles                          = gl_const.TRIANGLES,
    TriangleStripAdjacency             = gl_const.TRIANGLE_STRIP_ADJACENCY,
    TrianglesAdjacency                 = gl_const.TRIANGLES_ADJACENCY,
    Patches                            = gl_const.PATCHES,
}

type DrawElementsType enum i32 {
    UByte                              = gl_const.UNSIGNED_BYTE,
    UShort                             = gl_const.UNSIGNED_SHORT,
    UInt                               = gl_const.UNSIGNED_INT,
}

type ShaderTypes enum i32 {
    Compute                            = gl_const.COMPUTE_SHADER,
    Vertex                             = gl_const.VERTEX_SHADER,
    TessControl                        = gl_const.TESS_CONTROL_SHADER,
    TessEvaluation                     = gl_const.TESS_EVALUATION_SHADER,
    Geometry                           = gl_const.GEOMETRY_SHADER,
    Fragment                           = gl_const.FRAGMENT_SHADER,
}

type BlendFactors enum i32 {
    Zero                               = gl_const.ZERO,
    One                                = gl_const.ONE,
    SrcColor                           = gl_const.SRC_COLOR,
    OneMinusSrccolor                   = gl_const.ONE_MINUS_SRC_COLOR,
    DstColor                           = gl_const.DST_COLOR,
    OneMinusDstColor                   = gl_const.ONE_MINUS_DST_COLOR,
    SrcAlpha                           = gl_const.SRC_ALPHA,
    OneMinusSrcAlpha                   = gl_const.ONE_MINUS_SRC_ALPHA,
    DstAlpha                           = gl_const.DST_ALPHA,
    OneMinusDstAlpha                   = gl_const.ONE_MINUS_DST_ALPHA,
    Constantcolor                      = gl_const.CONSTANT_COLOR,
    OneMinusConstantColor              = gl_const.ONE_MINUS_CONSTANT_COLOR,
    ConstantAlpha                      = gl_const.CONSTANT_ALPHA,
    OneMinusConstantAlpha              = gl_const.ONE_MINUS_CONSTANT_ALPHA,
}

type BlendEquations enum i32 {
    FuncAdd                            = gl_const.FUNC_ADD,
    FuncSubtract                       = gl_const.FUNC_SUBTRACT,
    FuncReverseSubtract                = gl_const.FUNC_REVERSE_SUBTRACT,
    Min                                = gl_const.MIN,
    Max                                = gl_const.MAX,
}

type Capabilities enum i32 {
    Blend                              = gl_const.BLEND,
    ClipDistance0                      = gl_const.CLIP_DISTANCE0,
    ClipDistance1                      = gl_const.CLIP_DISTANCE1,
    ClipDistance3                      = gl_const.CLIP_DISTANCE3,
    ClipDistance2                      = gl_const.CLIP_DISTANCE2,
    ClipDistance4                      = gl_const.CLIP_DISTANCE4,
    ClipDistance5                      = gl_const.CLIP_DISTANCE5,
    ClipDistance6                      = gl_const.CLIP_DISTANCE6,
    ClipDistance7                      = gl_const.CLIP_DISTANCE7,
    ColorLogicOp                       = gl_const.COLOR_LOGIC_OP,
    CullFace                           = gl_const.CULL_FACE,
    DebugOutput                        = gl_const.DEBUG_OUTPUT,
    DebugOutputSynchronous             = gl_const.DEBUG_OUTPUT_SYNCHRONOUS,
    DepthVlamp                         = gl_const.DEPTH_CLAMP,
    DepthTest                          = gl_const.DEPTH_TEST,
    Dither                             = gl_const.DITHER,
    FramebufferSRGB                    = gl_const.FRAMEBUFFER_SRGB,
    LineSmooth                         = gl_const.LINE_SMOOTH,
    Multisample                        = gl_const.MULTISAMPLE,
    PolygonOffsetFill                  = gl_const.POLYGON_OFFSET_FILL,
    PolygonOffsetLine                  = gl_const.POLYGON_OFFSET_LINE,
    PolygonOffsetPoint                 = gl_const.POLYGON_OFFSET_POINT,
    PolygonSmooth                      = gl_const.POLYGON_SMOOTH,
    PrimitiveRestart                   = gl_const.PRIMITIVE_RESTART,
    PrimitiveRestartFixedIndex         = gl_const.PRIMITIVE_RESTART_FIXED_INDEX,
    RasterizerDiscard                  = gl_const.RASTERIZER_DISCARD,
    SampleAlphaToCoverage              = gl_const.SAMPLE_ALPHA_TO_COVERAGE,
    SampleAlphaToOne                   = gl_const.SAMPLE_ALPHA_TO_ONE,
    SampleCoverage                     = gl_const.SAMPLE_COVERAGE,
    SampleShading                      = gl_const.SAMPLE_SHADING,
    SampleMask                         = gl_const.SAMPLE_MASK,
    ScissorTest                        = gl_const.SCISSOR_TEST,
    StencilTest                        = gl_const.STENCIL_TEST,
    TextureCubeMapSeamless             = gl_const.TEXTURE_CUBE_MAP_SEAMLESS,
    ProgramPointSize                   = gl_const.PROGRAM_POINT_SIZE,
}

type ClearFlags enum i32 {
    COLOR_BUFFER                       = gl_const.COLOR_BUFFER_BIT,
    DEPTH_BUFFER                       = gl_const.DEPTH_BUFFER_BIT,
    STENCIL_BUFFER                     = gl_const.STENCIL_BUFFER_BIT,
}

type GetStringNames enum i32 {
    Vendor                             = gl_const.VENDOR,
    Renderer                           = gl_const.RENDERER,
    Version                            = gl_const.VERSION,
    ShadingLanguageVersion             = gl_const.SHADING_LANGUAGE_VERSION,
    Extensions                         = gl_const.EXTENSIONS,   
}

type GetIntegerNames enum i32 {
    ContextFlags                       = gl_const.CONTEXT_FLAGS,
    MajorVersion                       = gl_const.MAJOR_VERSION,
    MinorVersion                       = gl_const.MINOR_VERSION,
    NumExtensions                      = gl_const.NUM_EXTENSIONS,
    NumShadingLanguageVersions         = gl_const.NUM_SHADING_LANGUAGE_VERSIONS,

    TextureBinding2D                   = gl_const.TEXTURE_BINDING_2D,
    ArraybufferBinding                 = gl_const.ARRAY_BUFFER_BINDING,
    VertexArrayBinding                 = gl_const.VERTEX_ARRAY_BINDING,

    CurrentProgram                     = gl_const.CURRENT_PROGRAM,
    ActiveTexture                      = gl_const.ACTIVE_TEXTURE,
    ElementArray_buffer_binding        = gl_const.ELEMENT_ARRAY_BUFFER_BINDING,
    BlendSrc                           = gl_const.BLEND_SRC,
    BlendDst                           = gl_const.BLEND_DST,
    BlendEquation_rgb                  = gl_const.BLEND_EQUATION_RGB,
    BlendEquation_alpha                = gl_const.BLEND_EQUATION_ALPHA,
    Viewport                           = gl_const.VIEWPORT,
    ScissorBox                         = gl_const.SCISSOR_BOX,
    Blend                              = gl_const.BLEND,
    CullFace                           = gl_const.CULL_FACE,
    DepthTest                          = gl_const.DEPTH_TEST,
    ScissorTest                        = gl_const.SCISSOR_TEST,
}

type InternalColorFormat enum i32 {
    //Base
    DepthComponent                     = gl_const.DEPTH_COMPONENT,
    DepthStencil                       = gl_const.DEPTH_STENCIL,
    RED                                = gl_const.RED,
    RG                                 = gl_const.RG,
    RGB                                = gl_const.RGB,
    RGBA                               = gl_const.RGBA,

    //Sized
    R8                                 = gl_const.R8,
    R8_SNORM                           = gl_const.R8_SNORM,
    R16                                = gl_const.R16,
    R16_SNORM                          = gl_const.R16_SNORM,
    RG8                                = gl_const.RG8,
    RG8_SNORM                          = gl_const.RG8_SNORM,
    RG16                               = gl_const.RG16,
    RG16_SNORM                         = gl_const.RG16_SNORM,
    R3_G3_B2                           = gl_const.R3_G3_B2,
    RGB4                               = gl_const.RGB4,
    RGB5                               = gl_const.RGB5,
    RGB8                               = gl_const.RGB8,
    RGB8_SNORM                         = gl_const.RGB8_SNORM,
    RGB10                              = gl_const.RGB10,
    RGB12                              = gl_const.RGB12,
    RGB16_SNORM                        = gl_const.RGB16_SNORM,
    RGBA2                              = gl_const.RGBA2,
    RGBA4                              = gl_const.RGBA4,
    RGB5_A1                            = gl_const.RGB5_A1,
    RGBA8                              = gl_const.RGBA8,
    RGBA8_SNORM                        = gl_const.RGBA8_SNORM,
    RGB10_A2                           = gl_const.RGB10_A2,
    RGB10_A2UI                         = gl_const.RGB10_A2UI,
    RGBA12                             = gl_const.RGBA12,
    RGBA16                             = gl_const.RGBA16,
    SRGB8                              = gl_const.SRGB8,
    SRGB8_ALPHA8                       = gl_const.SRGB8_ALPHA8,
    R16F                               = gl_const.R16F,
    RG16F                              = gl_const.RG16F,
    RGB16F                             = gl_const.RGB16F,
    RGBA16F                            = gl_const.RGBA16F,
    R32F                               = gl_const.R32F,
    RG32F                              = gl_const.RG32F,
    RGB32F                             = gl_const.RGB32F,
    RGBA32F                            = gl_const.RGBA32F,
    R11F_G11F_B10F                     = gl_const.R11F_G11F_B10F,
    RGB9_E5                            = gl_const.RGB9_E5,
    R8I                                = gl_const.R8I,
    R8UI                               = gl_const.R8UI,
    R16I                               = gl_const.R16I,
    R16UI                              = gl_const.R16UI,
    R32I                               = gl_const.R32I,
    R32UI                              = gl_const.R32UI,
    RG8I                               = gl_const.RG8I,
    RG8UI                              = gl_const.RG8UI,
    RG16I                              = gl_const.RG16I,
    RG16UI                             = gl_const.RG16UI,
    RG32I                              = gl_const.RG32I,
    RG32UI                             = gl_const.RG32UI,
    RGB8I                              = gl_const.RGB8I,
    RGB8UI                             = gl_const.RGB8UI,
    RGB16I                             = gl_const.RGB16I,
    RGB16UI                            = gl_const.RGB16UI,
    RGB32I                             = gl_const.RGB32I,
    RGB32UI                            = gl_const.RGB32UI,
    RGBA8I                             = gl_const.RGBA8I,
    RGBA8UI                            = gl_const.RGBA8UI,
    RGBA16I                            = gl_const.RGBA16I,
    RGBA16UI                           = gl_const.RGBA16UI,
    RGBA32I                            = gl_const.RGBA32I,
    RGBA32UI                           = gl_const.RGBA32UI,

    //Compressed
    COMPRESSED_RED                     = gl_const.COMPRESSED_RED,
    COMPRESSED_RG                      = gl_const.COMPRESSED_RG,
    COMPRESSED_RGB                     = gl_const.COMPRESSED_RGB,
    COMPRESSED_RGBA                    = gl_const.COMPRESSED_RGBA,
    COMPRESSED_SRGB                    = gl_const.COMPRESSED_SRGB,
    COMPRESSED_SRGB_ALPHA              = gl_const.COMPRESSED_SRGB_ALPHA,
    COMPRESSED_RED_RGTC1               = gl_const.COMPRESSED_RED_RGTC1,
    COMPRESSED_SIGNED_RED_RGTC1        = gl_const.COMPRESSED_SIGNED_RED_RGTC1,
    COMPRESSED_RG_RGTC2                = gl_const.COMPRESSED_RG_RGTC2,
    COMPRESSED_SIGNED_RG_RGTC2         = gl_const.COMPRESSED_SIGNED_RG_RGTC2,
    COMPRESSED_RGBA_BPTC_UNORM         = gl_const.COMPRESSED_RGBA_BPTC_UNORM,
    COMPRESSED_SRGB_ALPHA_BPTC_UNORM   = gl_const.COMPRESSED_SRGB_ALPHA_BPTC_UNORM,
    COMPRESSED_RGB_BPTC_SIGNED_FLOAT   = gl_const.COMPRESSED_RGB_BPTC_SIGNED_FLOAT,
    COMPRESSED_RGB_BPTC_UNSIGNED_FLOAT = gl_const.COMPRESSED_RGB_BPTC_UNSIGNED_FLOAT,
}

type PixelDataFormat enum i32 {
    Red                                = gl_const.RED,
    RG                                 = gl_const.RG,
    RGB                                = gl_const.RGB,
    BGR                                = gl_const.BGR,
    RGBA                               = gl_const.RGBA,
    BGRA                               = gl_const.BGRA,
    RedInteger                         = gl_const.RED_INTEGER,
    RGInteger                          = gl_const.RG_INTEGER,
    RGBInteger                         = gl_const.RGB_INTEGER,
    BGRInteger                         = gl_const.BGR_INTEGER,
    RGBAInteger                        = gl_const.RGBA_INTEGER,
    BGRAInteger                        = gl_const.BGRA_INTEGER,
    StencilIndex                       = gl_const.STENCIL_INDEX,
    DepthComponent                     = gl_const.DEPTH_COMPONENT,
    DepthStencil                       = gl_const.DEPTH_STENCIL,
}

type Texture2DDataType enum i32 {
    UByte                              = gl_const.UNSIGNED_BYTE,
    Byte                               = gl_const.BYTE,
    UShort                             = gl_const.UNSIGNED_SHORT,
    Short                              = gl_const.SHORT,
    UInt                               = gl_const.UNSIGNED_INT,
    Int                                = gl_const.INT,
    Float                              = gl_const.FLOAT,
    UByte_3_3_2                        = gl_const.UNSIGNED_BYTE_3_3_2,
    UByte_2_3_3_rev                    = gl_const.UNSIGNED_BYTE_2_3_3_REV,
    UShort_5_6_5                       = gl_const.UNSIGNED_SHORT_5_6_5,
    UShort_5_6_5_rev                   = gl_const.UNSIGNED_SHORT_5_6_5_REV,
    UShort_4_4_4_4                     = gl_const.UNSIGNED_SHORT_4_4_4_4,
    UShort_4_4_4_4_rev                 = gl_const.UNSIGNED_SHORT_4_4_4_4_REV,
    UShort_5_5_5_1                     = gl_const.UNSIGNED_SHORT_5_5_5_1,
    UShort_1_5_5_5_rev                 = gl_const.UNSIGNED_SHORT_1_5_5_5_REV,
    UInt_8_8_8_8                       = gl_const.UNSIGNED_INT_8_8_8_8,
    UInt_8_8_8_8_rev                   = gl_const.UNSIGNED_INT_8_8_8_8_REV,
    UInt_10_10_10_2                    = gl_const.UNSIGNED_INT_10_10_10_2,
    UInt_2_10_10_10_rev                = gl_const.UNSIGNED_INT_2_10_10_10_REV,
}

type VertexAttribDataType enum i32 {
    Byte                               = gl_const.BYTE,
    UByte                              = gl_const.UNSIGNED_BYTE,
    Short                              = gl_const.SHORT,
    Ushort                             = gl_const.UNSIGNED_SHORT,
    Int                                = gl_const.INT,
    UInt                               = gl_const.UNSIGNED_INT, 
    HalfFloat                          = gl_const.HALF_FLOAT,
    Float                              = gl_const.FLOAT,
    Double                             = gl_const.DOUBLE,
    Fixed                              = gl_const.FIXED,
    Int_2_10_10_10_rev                 = gl_const.INT_2_10_10_10_REV,
    UInt_2_10_10_10_rev                = gl_const.UNSIGNED_INT_2_10_10_10_REV, 
    UInt_10f_11f_11f_rev               = gl_const.UNSIGNED_INT_10F_11F_11F_REV, 
}

type MipmapTargets enum i32 {
    Texture1D                          = gl_const.TEXTURE_1D, 
    Texture2D                          = gl_const.TEXTURE_2D,
    Texture3D                          = gl_const.TEXTURE_3D, 

    Texture1DArray                     = gl_const.TEXTURE_1D_ARRAY,
    Texture2DArray                     = gl_const.TEXTURE_2D_ARRAY,
    TextureCubeMapArray                = gl_const.TEXTURE_CUBE_MAP_ARRAY,
}

type TextureTargets enum i32 {
    Texture1D                          = gl_const.TEXTURE_1D, 
    Texture2D                          = gl_const.TEXTURE_2D,
    Texture3D                          = gl_const.TEXTURE_3D, 

    TextureRectangle                   = gl_const.TEXTURE_RECTANGLE,
    TextureCubeMap                     = gl_const.TEXTURE_CUBE_MAP,
    Texture2DMultisample               = gl_const.TEXTURE_2D_MULTISAMPLE, 
    TextureBuffer                      = gl_const.TEXTURE_BUFFER,

    Texture1DArray                     = gl_const.TEXTURE_1D_ARRAY,
    Texture2DArray                     = gl_const.TEXTURE_2D_ARRAY,
    TextureCubeMapArray                = gl_const.TEXTURE_CUBE_MAP_ARRAY,
    Texture2DMultisampleArray          = gl_const.TEXTURE_2D_MULTISAMPLE_ARRAY,
}

type TextureParameters enum i32 {
    DepthStencilTextureMode            = gl_const.DEPTH_STENCIL_TEXTURE_MODE, 
    BaseLevel                          = gl_const.TEXTURE_BASE_LEVEL,
    CompareFunc                        = gl_const.TEXTURE_COMPARE_FUNC,
    CompareMode                        = gl_const.TEXTURE_COMPARE_MODE,
    LodBias                            = gl_const.TEXTURE_LOD_BIAS,
    MinFilter                          = gl_const.TEXTURE_MIN_FILTER,
    MagFilter                          = gl_const.TEXTURE_MAG_FILTER,
    MinLod                             = gl_const.TEXTURE_MIN_LOD,
    MaxLod                             = gl_const.TEXTURE_MAX_LOD,
    MaxLevel                           = gl_const.TEXTURE_MAX_LEVEL,
    SwizzleR                           = gl_const.TEXTURE_SWIZZLE_R,
    SwizzleG                           = gl_const.TEXTURE_SWIZZLE_G,
    SwizzleB                           = gl_const.TEXTURE_SWIZZLE_B,
    SwizzleA                           = gl_const.TEXTURE_SWIZZLE_A,
    WrapS                              = gl_const.TEXTURE_WRAP_S,
    WrapT                              = gl_const.TEXTURE_WRAP_T,
    WrapR                              = gl_const.TEXTURE_WRAP_R,
}

type TextureParametersValues enum i32 {
    Nearest                            = gl_const.NEAREST,
    Linear                             = gl_const.LINEAR,
    NearestMipmapNearest               = gl_const.NEAREST_MIPMAP_NEAREST,
    LinearMipmapNearest                = gl_const.LINEAR_MIPMAP_NEAREST,
    NearestMipmapLinear                = gl_const.NEAREST_MIPMAP_LINEAR,
    LinearMipmapLinear                 = gl_const.LINEAR_MIPMAP_LINEAR,

    Repeat                             = gl_const.REPEAT,
    ClampToEdge                        = gl_const.CLAMP_TO_EDGE,
}

type TextureUnits enum i32 {
    Texture0                           = gl_const.TEXTURE0,
    Texture1                           = gl_const.TEXTURE1,
    Texture2                           = gl_const.TEXTURE2,
    Texture3                           = gl_const.TEXTURE3,
    Texture4                           = gl_const.TEXTURE4,
    Texture5                           = gl_const.TEXTURE5,
    Texture6                           = gl_const.TEXTURE6,
    Texture7                           = gl_const.TEXTURE7,
    Texture8                           = gl_const.TEXTURE8,
    Texture9                           = gl_const.TEXTURE9,
    Texture10                          = gl_const.TEXTURE10,
    Texture11                          = gl_const.TEXTURE11,
    Texture12                          = gl_const.TEXTURE12,
    Texture13                          = gl_const.TEXTURE13,
    Texture14                          = gl_const.TEXTURE14,
    Texture15                          = gl_const.TEXTURE15,
    Texture16                          = gl_const.TEXTURE16,
    Texture17                          = gl_const.TEXTURE17,
    Texture18                          = gl_const.TEXTURE18,
    Texture19                          = gl_const.TEXTURE19,
    Texture20                          = gl_const.TEXTURE20,
    Texture21                          = gl_const.TEXTURE21,
    Texture22                          = gl_const.TEXTURE22,
    Texture23                          = gl_const.TEXTURE23,
    Texture24                          = gl_const.TEXTURE24,
    Texture25                          = gl_const.TEXTURE25,
    Texture26                          = gl_const.TEXTURE26,
    Texture27                          = gl_const.TEXTURE27,
    Texture28                          = gl_const.TEXTURE28,
    Texture29                          = gl_const.TEXTURE29,
    Texture30                          = gl_const.TEXTURE30,
    Texture31                          = gl_const.TEXTURE31,
}

type BufferTargets enum i32 {
    Array                              = gl_const.ARRAY_BUFFER,
    AtomicCounter                      = gl_const.ATOMIC_COUNTER_BUFFER,
    CopyRead                           = gl_const.COPY_READ_BUFFER,
    CopyWrite                          = gl_const.COPY_WRITE_BUFFER,
    DispatchIndirect                   = gl_const.DISPATCH_INDIRECT_BUFFER,
    Draw_indirect                      = gl_const.DRAW_INDIRECT_BUFFER,
    ElementArray                       = gl_const.ELEMENT_ARRAY_BUFFER,
    PixelPack                          = gl_const.PIXEL_PACK_BUFFER,
    PixelUnpack                        = gl_const.PIXEL_UNPACK_BUFFER,
    Query                              = gl_const.QUERY_BUFFER,
    ShaderStorage                      = gl_const.SHADER_STORAGE_BUFFER,
    Texture                            = gl_const.TEXTURE_BUFFER,
    TransformFeedback                  = gl_const.TRANSFORM_FEEDBACK_BUFFER,
    Uniform                            = gl_const.UNIFORM_BUFFER,
}

type BufferDataUsage enum i32 {
    StreamDraw                         = gl_const.STREAM_DRAW, 
    StreamRead                         = gl_const.STREAM_READ,
    StreamCopy                         = gl_const.STREAM_COPY,
    StaticDraw                         = gl_const.STATIC_DRAW,
    StaticRead                         = gl_const.STATIC_READ,
    StaticCopy                         = gl_const.STATIC_COPY,
    DynamicDraw                        = gl_const.DYNAMIC_DRAW,
    DynamicRead                        = gl_const.DYNAMIC_READ,
    DynamicCopy                        = gl_const.DYNAMIC_COPY,
}

type PolygonFace enum i32 {
    Front                              = gl_const.FRONT,
    Back                               = gl_const.BACK,
    FrontAndBack                       = gl_const.FRONT_AND_BACK,
}

type PolygonModes enum i32 {
    Point                              = gl_const.POINT,
    Line                               = gl_const.LINE,
    Fill                               = gl_const.FILL,
}

type DepthFuncs enum i32 {
    Never                              = gl_const.NEVER,
    Less                               = gl_const.LESS,
    Equal                              = gl_const.EQUAL,
    Lequal                             = gl_const.LEQUAL,
    Greater                            = gl_const.GREATER,
    NotEqual                           = gl_const.NOTEQUAL,
    Gequal                             = gl_const.GEQUAL,
    Always                             = gl_const.ALWAYS,
}/*
 *  @Name:     gl_enums
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    hjortshoej@handmade.network
 *  @Creation: 10-06-2017 17:41:03
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 10-06-2017 17:41:03
 *  
 *  @Description:
 *  
 */
