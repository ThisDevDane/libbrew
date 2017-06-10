/*
 *  @Name:     gl_enums
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    hjortshoej@handmade.network
 *  @Creation: 02-05-2017 21:38:35
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 10-06-2017 17:41:11
 *  
 *  @Description:
 *      Part of the GL Wrapper, makes enum for all constants.
 */
#import const "opengl_constants.odin";

GetShaderNames :: enum i32 {
    ShaderType = const.SHADER_TYPE,
    DeleteStatus = const.DELETE_STATUS,
    CompileStatus = const.COMPILE_STATUS,
    InfoLogLength = const.INFO_LOG_LENGTH,
    ShaderSourceLength = const.SHADER_SOURCE_LENGTH,
}

DebugSource :: enum i32 {
    Api                                = const.DEBUG_SOURCE_API,
    WindowSystem                       = const.DEBUG_SOURCE_WINDOW_SYSTEM,
    ShaderCompiler                     = const.DEBUG_SOURCE_SHADER_COMPILER,
    ThirdParty                         = const.DEBUG_SOURCE_THIRD_PARTY,
    Application                        = const.DEBUG_SOURCE_APPLICATION,
    Other                              = const.DEBUG_SOURCE_OTHER,
    DontCare                           = const.DONT_CARE,
}

DebugType :: enum i32 {
    Error                              = const.DEBUG_TYPE_ERROR,
    DeprecatedBehavior                 = const.DEBUG_TYPE_DEPRECATED_BEHAVIOR,
    UndefinedBehavior                  = const.DEBUG_TYPE_UNDEFINED_BEHAVIOR,
    Portability                        = const.DEBUG_TYPE_PORTABILITY,
    Performance                        = const.DEBUG_TYPE_PERFORMANCE,
    Marker                             = const.DEBUG_TYPE_MARKER,
    PushGroup                          = const.DEBUG_TYPE_PUSH_GROUP,
    PopGroup                           = const.DEBUG_TYPE_POP_GROUP,
    Other                              = const.DEBUG_TYPE_OTHER,
    DontCare                           = const.DONT_CARE,
}

DebugSeverity :: enum i32 {
    High                               = const.DEBUG_SEVERITY_HIGH,
    Medium                             = const.DEBUG_SEVERITY_MEDIUM,
    Low                                = const.DEBUG_SEVERITY_LOW,
    Notification                       = const.DEBUG_SEVERITY_NOTIFICATION,
    DontCare                           = const.DONT_CARE,
}

DrawModes :: enum i32 {
    Points                             = const.POINTS, 
    LineStrip                          = const.LINE_STRIP,
    LineLoop                           = const.LINE_LOOP, 
    Lines                              = const.LINES,
    LineStripAdjacency                 = const.LINE_STRIP_ADJACENCY,
    LinesAdjacency                     = const.LINES_ADJACENCY,
    TriangleStrip                      = const.TRIANGLE_STRIP,
    TriangleFan                        = const.TRIANGLE_FAN,
    Triangles                          = const.TRIANGLES,
    TriangleStripAdjacency             = const.TRIANGLE_STRIP_ADJACENCY,
    TrianglesAdjacency                 = const.TRIANGLES_ADJACENCY,
    Patches                            = const.PATCHES,
}

DrawElementsType :: enum i32 {
    UByte                              = const.UNSIGNED_BYTE,
    UShort                             = const.UNSIGNED_SHORT,
    UInt                               = const.UNSIGNED_INT,
}

ShaderTypes :: enum i32 {
    Compute                            = const.COMPUTE_SHADER,
    Vertex                             = const.VERTEX_SHADER,
    TessControl                        = const.TESS_CONTROL_SHADER,
    TessEvaluation                     = const.TESS_EVALUATION_SHADER,
    Geometry                           = const.GEOMETRY_SHADER,
    Fragment                           = const.FRAGMENT_SHADER,
}

BlendFactors :: enum i32 {
    Zero                               = const.ZERO,
    One                                = const.ONE,
    SrcColor                           = const.SRC_COLOR,
    OneMinusSrccolor                   = const.ONE_MINUS_SRC_COLOR,
    DstColor                           = const.DST_COLOR,
    OneMinusDstColor                   = const.ONE_MINUS_DST_COLOR,
    SrcAlpha                           = const.SRC_ALPHA,
    OneMinusSrcAlpha                   = const.ONE_MINUS_SRC_ALPHA,
    DstAlpha                           = const.DST_ALPHA,
    OneMinusDstAlpha                   = const.ONE_MINUS_DST_ALPHA,
    Constantcolor                      = const.CONSTANT_COLOR,
    OneMinusConstantColor              = const.ONE_MINUS_CONSTANT_COLOR,
    ConstantAlpha                      = const.CONSTANT_ALPHA,
    OneMinusConstantAlpha              = const.ONE_MINUS_CONSTANT_ALPHA,
}

BlendEquations :: enum i32 {
    FuncAdd                            = const.FUNC_ADD,
    FuncSubtract                       = const.FUNC_SUBTRACT,
    FuncReverseSubtract                = const.FUNC_REVERSE_SUBTRACT,
    Min                                = const.MIN,
    Max                                = const.MAX,
}

Capabilities :: enum i32 {
    Blend                              = const.BLEND,
    ClipDistance0                      = const.CLIP_DISTANCE0,
    ClipDistance1                      = const.CLIP_DISTANCE1,
    ClipDistance3                      = const.CLIP_DISTANCE3,
    ClipDistance2                      = const.CLIP_DISTANCE2,
    ClipDistance4                      = const.CLIP_DISTANCE4,
    ClipDistance5                      = const.CLIP_DISTANCE5,
    ClipDistance6                      = const.CLIP_DISTANCE6,
    ClipDistance7                      = const.CLIP_DISTANCE7,
    ColorLogicOp                       = const.COLOR_LOGIC_OP,
    CullFace                           = const.CULL_FACE,
    DebugOutput                        = const.DEBUG_OUTPUT,
    DebugOutputSynchronous             = const.DEBUG_OUTPUT_SYNCHRONOUS,
    DepthVlamp                         = const.DEPTH_CLAMP,
    DepthTest                          = const.DEPTH_TEST,
    Dither                             = const.DITHER,
    FramebufferSRGB                    = const.FRAMEBUFFER_SRGB,
    LineSmooth                         = const.LINE_SMOOTH,
    Multisample                        = const.MULTISAMPLE,
    PolygonOffsetFill                  = const.POLYGON_OFFSET_FILL,
    PolygonOffsetLine                  = const.POLYGON_OFFSET_LINE,
    PolygonOffsetPoint                 = const.POLYGON_OFFSET_POINT,
    PolygonSmooth                      = const.POLYGON_SMOOTH,
    PrimitiveRestart                   = const.PRIMITIVE_RESTART,
    PrimitiveRestartFixedIndex         = const.PRIMITIVE_RESTART_FIXED_INDEX,
    RasterizerDiscard                  = const.RASTERIZER_DISCARD,
    SampleAlphaToCoverage              = const.SAMPLE_ALPHA_TO_COVERAGE,
    SampleAlphaToOne                   = const.SAMPLE_ALPHA_TO_ONE,
    SampleCoverage                     = const.SAMPLE_COVERAGE,
    SampleShading                      = const.SAMPLE_SHADING,
    SampleMask                         = const.SAMPLE_MASK,
    ScissorTest                        = const.SCISSOR_TEST,
    StencilTest                        = const.STENCIL_TEST,
    TextureCubeMapSeamless             = const.TEXTURE_CUBE_MAP_SEAMLESS,
    ProgramPointSize                   = const.PROGRAM_POINT_SIZE,
}

ClearFlags :: enum i32 {
    COLOR_BUFFER                       = const.COLOR_BUFFER_BIT,
    DEPTH_BUFFER                       = const.DEPTH_BUFFER_BIT,
    STENCIL_BUFFER                     = const.STENCIL_BUFFER_BIT,
}

GetStringNames :: enum i32 {
    Vendor                             = const.VENDOR,
    Renderer                           = const.RENDERER,
    Version                            = const.VERSION,
    ShadingLanguageVersion             = const.SHADING_LANGUAGE_VERSION,
    Extensions                         = const.EXTENSIONS,   
}

GetIntegerNames :: enum i32 {
    ContextFlags                       = const.CONTEXT_FLAGS,
    MajorVersion                       = const.MAJOR_VERSION,
    MinorVersion                       = const.MINOR_VERSION,
    NumExtensions                      = const.NUM_EXTENSIONS,
    NumShadingLanguageVersions         = const.NUM_SHADING_LANGUAGE_VERSIONS,

    TextureBinding2D                   = const.TEXTURE_BINDING_2D,
    ArraybufferBinding                 = const.ARRAY_BUFFER_BINDING,
    VertexArrayBinding                 = const.VERTEX_ARRAY_BINDING,

    CurrentProgram                     = const.CURRENT_PROGRAM,
    ActiveTexture                      = const.ACTIVE_TEXTURE,
    ElementArray_buffer_binding        = const.ELEMENT_ARRAY_BUFFER_BINDING,
    BlendSrc                           = const.BLEND_SRC,
    BlendDst                           = const.BLEND_DST,
    BlendEquation_rgb                  = const.BLEND_EQUATION_RGB,
    BlendEquation_alpha                = const.BLEND_EQUATION_ALPHA,
    Viewport                           = const.VIEWPORT,
    ScissorBox                         = const.SCISSOR_BOX,
    Blend                              = const.BLEND,
    CullFace                           = const.CULL_FACE,
    DepthTest                          = const.DEPTH_TEST,
    ScissorTest                        = const.SCISSOR_TEST,
}

InternalColorFormat :: enum i32 {
    //Base
    DepthComponent                     = const.DEPTH_COMPONENT,
    DepthStencil                       = const.DEPTH_STENCIL,
    RED                                = const.RED,
    RG                                 = const.RG,
    RGB                                = const.RGB,
    RGBA                               = const.RGBA,

    //Sized
    R8                                 = const.R8,
    R8_SNORM                           = const.R8_SNORM,
    R16                                = const.R16,
    R16_SNORM                          = const.R16_SNORM,
    RG8                                = const.RG8,
    RG8_SNORM                          = const.RG8_SNORM,
    RG16                               = const.RG16,
    RG16_SNORM                         = const.RG16_SNORM,
    R3_G3_B2                           = const.R3_G3_B2,
    RGB4                               = const.RGB4,
    RGB5                               = const.RGB5,
    RGB8                               = const.RGB8,
    RGB8_SNORM                         = const.RGB8_SNORM,
    RGB10                              = const.RGB10,
    RGB12                              = const.RGB12,
    RGB16_SNORM                        = const.RGB16_SNORM,
    RGBA2                              = const.RGBA2,
    RGBA4                              = const.RGBA4,
    RGB5_A1                            = const.RGB5_A1,
    RGBA8                              = const.RGBA8,
    RGBA8_SNORM                        = const.RGBA8_SNORM,
    RGB10_A2                           = const.RGB10_A2,
    RGB10_A2UI                         = const.RGB10_A2UI,
    RGBA12                             = const.RGBA12,
    RGBA16                             = const.RGBA16,
    SRGB8                              = const.SRGB8,
    SRGB8_ALPHA8                       = const.SRGB8_ALPHA8,
    R16F                               = const.R16F,
    RG16F                              = const.RG16F,
    RGB16F                             = const.RGB16F,
    RGBA16F                            = const.RGBA16F,
    R32F                               = const.R32F,
    RG32F                              = const.RG32F,
    RGB32F                             = const.RGB32F,
    RGBA32F                            = const.RGBA32F,
    R11F_G11F_B10F                     = const.R11F_G11F_B10F,
    RGB9_E5                            = const.RGB9_E5,
    R8I                                = const.R8I,
    R8UI                               = const.R8UI,
    R16I                               = const.R16I,
    R16UI                              = const.R16UI,
    R32I                               = const.R32I,
    R32UI                              = const.R32UI,
    RG8I                               = const.RG8I,
    RG8UI                              = const.RG8UI,
    RG16I                              = const.RG16I,
    RG16UI                             = const.RG16UI,
    RG32I                              = const.RG32I,
    RG32UI                             = const.RG32UI,
    RGB8I                              = const.RGB8I,
    RGB8UI                             = const.RGB8UI,
    RGB16I                             = const.RGB16I,
    RGB16UI                            = const.RGB16UI,
    RGB32I                             = const.RGB32I,
    RGB32UI                            = const.RGB32UI,
    RGBA8I                             = const.RGBA8I,
    RGBA8UI                            = const.RGBA8UI,
    RGBA16I                            = const.RGBA16I,
    RGBA16UI                           = const.RGBA16UI,
    RGBA32I                            = const.RGBA32I,
    RGBA32UI                           = const.RGBA32UI,

    //Compressed
    COMPRESSED_RED                     = const.COMPRESSED_RED,
    COMPRESSED_RG                      = const.COMPRESSED_RG,
    COMPRESSED_RGB                     = const.COMPRESSED_RGB,
    COMPRESSED_RGBA                    = const.COMPRESSED_RGBA,
    COMPRESSED_SRGB                    = const.COMPRESSED_SRGB,
    COMPRESSED_SRGB_ALPHA              = const.COMPRESSED_SRGB_ALPHA,
    COMPRESSED_RED_RGTC1               = const.COMPRESSED_RED_RGTC1,
    COMPRESSED_SIGNED_RED_RGTC1        = const.COMPRESSED_SIGNED_RED_RGTC1,
    COMPRESSED_RG_RGTC2                = const.COMPRESSED_RG_RGTC2,
    COMPRESSED_SIGNED_RG_RGTC2         = const.COMPRESSED_SIGNED_RG_RGTC2,
    COMPRESSED_RGBA_BPTC_UNORM         = const.COMPRESSED_RGBA_BPTC_UNORM,
    COMPRESSED_SRGB_ALPHA_BPTC_UNORM   = const.COMPRESSED_SRGB_ALPHA_BPTC_UNORM,
    COMPRESSED_RGB_BPTC_SIGNED_FLOAT   = const.COMPRESSED_RGB_BPTC_SIGNED_FLOAT,
    COMPRESSED_RGB_BPTC_UNSIGNED_FLOAT = const.COMPRESSED_RGB_BPTC_UNSIGNED_FLOAT,
}

PixelDataFormat :: enum i32 {
    Red                                = const.RED,
    RG                                 = const.RG,
    RGB                                = const.RGB,
    BGR                                = const.BGR,
    RGBA                               = const.RGBA,
    BGRA                               = const.BGRA,
    RedInteger                         = const.RED_INTEGER,
    RGInteger                          = const.RG_INTEGER,
    RGBInteger                         = const.RGB_INTEGER,
    BGRInteger                         = const.BGR_INTEGER,
    RGBAInteger                        = const.RGBA_INTEGER,
    BGRAInteger                        = const.BGRA_INTEGER,
    StencilIndex                       = const.STENCIL_INDEX,
    DepthComponent                     = const.DEPTH_COMPONENT,
    DepthStencil                       = const.DEPTH_STENCIL,
}

Texture2DDataType :: enum i32 {
    UByte                              = const.UNSIGNED_BYTE,
    Byte                               = const.BYTE,
    UShort                             = const.UNSIGNED_SHORT,
    Short                              = const.SHORT,
    UInt                               = const.UNSIGNED_INT,
    Int                                = const.INT,
    Float                              = const.FLOAT,
    UByte_3_3_2                        = const.UNSIGNED_BYTE_3_3_2,
    UByte_2_3_3_rev                    = const.UNSIGNED_BYTE_2_3_3_REV,
    UShort_5_6_5                       = const.UNSIGNED_SHORT_5_6_5,
    UShort_5_6_5_rev                   = const.UNSIGNED_SHORT_5_6_5_REV,
    UShort_4_4_4_4                     = const.UNSIGNED_SHORT_4_4_4_4,
    UShort_4_4_4_4_rev                 = const.UNSIGNED_SHORT_4_4_4_4_REV,
    UShort_5_5_5_1                     = const.UNSIGNED_SHORT_5_5_5_1,
    UShort_1_5_5_5_rev                 = const.UNSIGNED_SHORT_1_5_5_5_REV,
    UInt_8_8_8_8                       = const.UNSIGNED_INT_8_8_8_8,
    UInt_8_8_8_8_rev                   = const.UNSIGNED_INT_8_8_8_8_REV,
    UInt_10_10_10_2                    = const.UNSIGNED_INT_10_10_10_2,
    UInt_2_10_10_10_rev                = const.UNSIGNED_INT_2_10_10_10_REV,
}

VertexAttribDataType :: enum i32 {
    Byte                               = const.BYTE,
    UByte                              = const.UNSIGNED_BYTE,
    Short                              = const.SHORT,
    Ushort                             = const.UNSIGNED_SHORT,
    Int                                = const.INT,
    UInt                               = const.UNSIGNED_INT, 
    HalfFloat                          = const.HALF_FLOAT,
    Float                              = const.FLOAT,
    Double                             = const.DOUBLE,
    Fixed                              = const.FIXED,
    Int_2_10_10_10_rev                 = const.INT_2_10_10_10_REV,
    UInt_2_10_10_10_rev                = const.UNSIGNED_INT_2_10_10_10_REV, 
    UInt_10f_11f_11f_rev               = const.UNSIGNED_INT_10F_11F_11F_REV, 
}

MipmapTargets :: enum i32 {
    Texture1D                          = const.TEXTURE_1D, 
    Texture2D                          = const.TEXTURE_2D,
    Texture3D                          = const.TEXTURE_3D, 

    Texture1DArray                     = const.TEXTURE_1D_ARRAY,
    Texture2DArray                     = const.TEXTURE_2D_ARRAY,
    TextureCubeMapArray                = const.TEXTURE_CUBE_MAP_ARRAY,
}

TextureTargets :: enum i32 {
    Texture1D                          = const.TEXTURE_1D, 
    Texture2D                          = const.TEXTURE_2D,
    Texture3D                          = const.TEXTURE_3D, 

    TextureRectangle                   = const.TEXTURE_RECTANGLE,
    TextureCubeMap                     = const.TEXTURE_CUBE_MAP,
    Texture2DMultisample               = const.TEXTURE_2D_MULTISAMPLE, 
    TextureBuffer                      = const.TEXTURE_BUFFER,

    Texture1DArray                     = const.TEXTURE_1D_ARRAY,
    Texture2DArray                     = const.TEXTURE_2D_ARRAY,
    TextureCubeMapArray                = const.TEXTURE_CUBE_MAP_ARRAY,
    Texture2DMultisampleArray          = const.TEXTURE_2D_MULTISAMPLE_ARRAY,
}

TextureParameters :: enum i32 {
    DepthStencilTextureMode            = const.DEPTH_STENCIL_TEXTURE_MODE, 
    BaseLevel                          = const.TEXTURE_BASE_LEVEL,
    CompareFunc                        = const.TEXTURE_COMPARE_FUNC,
    CompareMode                        = const.TEXTURE_COMPARE_MODE,
    LodBias                            = const.TEXTURE_LOD_BIAS,
    MinFilter                          = const.TEXTURE_MIN_FILTER,
    MagFilter                          = const.TEXTURE_MAG_FILTER,
    MinLod                             = const.TEXTURE_MIN_LOD,
    MaxLod                             = const.TEXTURE_MAX_LOD,
    MaxLevel                           = const.TEXTURE_MAX_LEVEL,
    SwizzleR                           = const.TEXTURE_SWIZZLE_R,
    SwizzleG                           = const.TEXTURE_SWIZZLE_G,
    SwizzleB                           = const.TEXTURE_SWIZZLE_B,
    SwizzleA                           = const.TEXTURE_SWIZZLE_A,
    WrapS                              = const.TEXTURE_WRAP_S,
    WrapT                              = const.TEXTURE_WRAP_T,
    WrapR                              = const.TEXTURE_WRAP_R,
}

TextureParametersValues :: enum i32 {
    Nearest                            = const.NEAREST,
    Linear                             = const.LINEAR,
    NearestMipmapNearest               = const.NEAREST_MIPMAP_NEAREST,
    LinearMipmapNearest                = const.LINEAR_MIPMAP_NEAREST,
    NearestMipmapLinear                = const.NEAREST_MIPMAP_LINEAR,
    LinearMipmapLinear                 = const.LINEAR_MIPMAP_LINEAR,

    Repeat                             = const.REPEAT,
    ClampToEdge                        = const.CLAMP_TO_EDGE,
}

TextureUnits :: enum i32 {
    Texture0                           = const.TEXTURE0,
    Texture1                           = const.TEXTURE1,
    Texture2                           = const.TEXTURE2,
    Texture3                           = const.TEXTURE3,
    Texture4                           = const.TEXTURE4,
    Texture5                           = const.TEXTURE5,
    Texture6                           = const.TEXTURE6,
    Texture7                           = const.TEXTURE7,
    Texture8                           = const.TEXTURE8,
    Texture9                           = const.TEXTURE9,
    Texture10                          = const.TEXTURE10,
    Texture11                          = const.TEXTURE11,
    Texture12                          = const.TEXTURE12,
    Texture13                          = const.TEXTURE13,
    Texture14                          = const.TEXTURE14,
    Texture15                          = const.TEXTURE15,
    Texture16                          = const.TEXTURE16,
    Texture17                          = const.TEXTURE17,
    Texture18                          = const.TEXTURE18,
    Texture19                          = const.TEXTURE19,
    Texture20                          = const.TEXTURE20,
    Texture21                          = const.TEXTURE21,
    Texture22                          = const.TEXTURE22,
    Texture23                          = const.TEXTURE23,
    Texture24                          = const.TEXTURE24,
    Texture25                          = const.TEXTURE25,
    Texture26                          = const.TEXTURE26,
    Texture27                          = const.TEXTURE27,
    Texture28                          = const.TEXTURE28,
    Texture29                          = const.TEXTURE29,
    Texture30                          = const.TEXTURE30,
    Texture31                          = const.TEXTURE31,
}

BufferTargets :: enum i32 {
    Array                              = const.ARRAY_BUFFER,
    AtomicCounter                      = const.ATOMIC_COUNTER_BUFFER,
    CopyRead                           = const.COPY_READ_BUFFER,
    CopyWrite                          = const.COPY_WRITE_BUFFER,
    DispatchIndirect                   = const.DISPATCH_INDIRECT_BUFFER,
    Draw_indirect                      = const.DRAW_INDIRECT_BUFFER,
    ElementArray                       = const.ELEMENT_ARRAY_BUFFER,
    PixelPack                          = const.PIXEL_PACK_BUFFER,
    PixelUnpack                        = const.PIXEL_UNPACK_BUFFER,
    Query                              = const.QUERY_BUFFER,
    ShaderStorage                      = const.SHADER_STORAGE_BUFFER,
    Texture                            = const.TEXTURE_BUFFER,
    TransformFeedback                  = const.TRANSFORM_FEEDBACK_BUFFER,
    Uniform                            = const.UNIFORM_BUFFER,
}

BufferDataUsage :: enum i32 {
    StreamDraw                         = const.STREAM_DRAW, 
    StreamRead                         = const.STREAM_READ,
    StreamCopy                         = const.STREAM_COPY,
    StaticDraw                         = const.STATIC_DRAW,
    StaticRead                         = const.STATIC_READ,
    StaticCopy                         = const.STATIC_COPY,
    DynamicDraw                        = const.DYNAMIC_DRAW,
    DynamicRead                        = const.DYNAMIC_READ,
    DynamicCopy                        = const.DYNAMIC_COPY,
}

PolygonFace :: enum i32 {
    Front                              = const.FRONT,
    Back                               = const.BACK,
    FrontAndBack                       = const.FRONT_AND_BACK,
}

PolygonModes :: enum i32 {
    Point                              = const.POINT,
    Line                               = const.LINE,
    Fill                               = const.FILL,
}

DepthFuncs :: enum i32 {
    Never                              = const.NEVER,
    Less                               = const.LESS,
    Equal                              = const.EQUAL,
    Lequal                             = const.LEQUAL,
    Greater                            = const.GREATER,
    NotEqual                           = const.NOTEQUAL,
    Gequal                             = const.GEQUAL,
    Always                             = const.ALWAYS,
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
