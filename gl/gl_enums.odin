/*
 *  @Name:     gl_enums
 *  
 *  @Author:   Mikkel Hjortshoej
 *  @Email:    hjortshoej@handmade.network
 *  @Creation: 02-05-2017 21:38:35
 *
 *  @Last By:   Mikkel Hjortshoej
 *  @Last Time: 05-08-2018 20:02:28 UTC+1
 *  
 *  @Description:
 *      Part of the GL Wrapper, makes enum for all constants in use
 */

package gl;

UniformTypes :: enum i32 {
    float                              = FLOAT,
    float_vec2                         = FLOAT_VEC2,
    float_vec3                         = FLOAT_VEC3,
    float_vec4                         = FLOAT_VEC4,

    double                             = DOUBLE,
    double_vec2                        = DOUBLE_VEC2,
    double_vec3                        = DOUBLE_VEC3,
    double_vec4                        = DOUBLE_VEC4,

    int_                               = INT,
    int_vec2                           = INT_VEC2,
    int_vec3                           = INT_VEC3,
    int_vec4                           = INT_VEC4,

    unsigned_int                       = UNSIGNED_INT,
    unsigned_int_vec2                  = UNSIGNED_INT_VEC2,
    unsigned_int_vec3                  = UNSIGNED_INT_VEC3,
    unsigned_int_vec4                  = UNSIGNED_INT_VEC4,

    bool_                              = BOOL,
    bool_vec2                          = BOOL_VEC2,
    bool_vec3                          = BOOL_VEC3,
    bool_vec4                          = BOOL_VEC4,

    float_mat2                         = FLOAT_MAT2,
    float_mat3                         = FLOAT_MAT3,
    float_mat4                         = FLOAT_MAT4,
    float_mat2x3                       = FLOAT_MAT2x3,
    float_mat2x4                       = FLOAT_MAT2x4,
    float_mat3x2                       = FLOAT_MAT3x2,
    float_mat3x4                       = FLOAT_MAT3x4,
    float_mat4x2                       = FLOAT_MAT4x2,
    float_mat4x3                       = FLOAT_MAT4x3,

    double_mat2                        = DOUBLE_MAT2,
    double_mat3                        = DOUBLE_MAT3,
    double_mat4                        = DOUBLE_MAT4,
    double_mat2x3                      = DOUBLE_MAT2x3,
    double_mat2x4                      = DOUBLE_MAT2x4,
    double_mat3x2                      = DOUBLE_MAT3x2,
    double_mat3x4                      = DOUBLE_MAT3x4,
    double_mat4x2                      = DOUBLE_MAT4x2,
    double_mat4x3                      = DOUBLE_MAT4x3,

    sampler_1d                         = SAMPLER_1D,
    sampler_2d                         = SAMPLER_2D,
    sampler_3d                         = SAMPLER_3D,
    sampler_cube                       = SAMPLER_CUBE,
    sampler_1d_shadow                  = SAMPLER_1D_SHADOW,
    sampler_2d_shadow                  = SAMPLER_2D_SHADOW,
    sampler_1d_array                   = SAMPLER_1D_ARRAY,
    sampler_2d_array                   = SAMPLER_2D_ARRAY,
    sampler_1d_array_shadow            = SAMPLER_1D_ARRAY_SHADOW,
    sampler_2d_array_shadow            = SAMPLER_2D_ARRAY_SHADOW,
    sampler_2d_multisample             = SAMPLER_2D_MULTISAMPLE,
    sampler_2d_multisample_array       = SAMPLER_2D_MULTISAMPLE_ARRAY,
    sampler_cube_shadow                = SAMPLER_CUBE_SHADOW,
    sampler_buffer                     = SAMPLER_BUFFER,
    sampler_2d_rect                    = SAMPLER_2D_RECT,
    sampler_2d_rect_shadow             = SAMPLER_2D_RECT_SHADOW,

    int_sampler_1d                     = INT_SAMPLER_1D,
    int_sampler_2d                     = INT_SAMPLER_2D,
    int_sampler_3d                     = INT_SAMPLER_3D,
    int_sampler_cube                   = INT_SAMPLER_CUBE,
    int_sampler_1d_array               = INT_SAMPLER_1D_ARRAY,
    int_sampler_2d_array               = INT_SAMPLER_2D_ARRAY,
    int_sampler_2d_multisample         = INT_SAMPLER_2D_MULTISAMPLE,
    int_sampler_2d_multisample_array   = INT_SAMPLER_2D_MULTISAMPLE_ARRAY,
    int_sampler_buffer                 = INT_SAMPLER_BUFFER,
    int_sampler_2d_rect                = INT_SAMPLER_2D_RECT,

    uint_sampler_1d                    = UNSIGNED_INT_SAMPLER_1D,
    uint_sampler_2d                    = UNSIGNED_INT_SAMPLER_2D,
    uint_sampler_3d                    = UNSIGNED_INT_SAMPLER_3D,
    uint_sampler_cube                  = UNSIGNED_INT_SAMPLER_CUBE,
    uint_sampler_1d_array              = UNSIGNED_INT_SAMPLER_1D_ARRAY,
    uint_sampler_2d_array              = UNSIGNED_INT_SAMPLER_2D_ARRAY,
    uint_sampler_2d_multisample        = UNSIGNED_INT_SAMPLER_2D_MULTISAMPLE,
    uint_sampler_2d_multisample_array  = UNSIGNED_INT_SAMPLER_2D_MULTISAMPLE_ARRAY,
    uint_sampler_buffer                = UNSIGNED_INT_SAMPLER_BUFFER,
    uint_sampler_2d_rect               = UNSIGNED_INT_SAMPLER_2D_RECT,

    image_1d                           = IMAGE_1D,
    image_2d                           = IMAGE_2D,
    image_3d                           = IMAGE_3D,
    image_2d_rect                      = IMAGE_2D_RECT,
    image_cube                         = IMAGE_CUBE,
    image_buffer                       = IMAGE_BUFFER,
    image_1d_array                     = IMAGE_1D_ARRAY,
    image_2d_array                     = IMAGE_2D_ARRAY,
    image_cube_map_array               = IMAGE_CUBE_MAP_ARRAY,
    image_2d_multisample               = IMAGE_2D_MULTISAMPLE,
    image_2d_multisample_array         = IMAGE_2D_MULTISAMPLE_ARRAY,

    int_image_1d                       = INT_IMAGE_1D,
    int_image_2d                       = INT_IMAGE_2D,
    int_image_3d                       = INT_IMAGE_3D,
    int_image_2d_rect                  = INT_IMAGE_2D_RECT,
    int_image_cube                     = INT_IMAGE_CUBE,
    int_image_buffer                   = INT_IMAGE_BUFFER,
    int_image_1d_array                 = INT_IMAGE_1D_ARRAY,
    int_image_2d_array                 = INT_IMAGE_2D_ARRAY,
    int_image_cube_map_array           = INT_IMAGE_CUBE_MAP_ARRAY,
    int_image_2d_multisample           = INT_IMAGE_2D_MULTISAMPLE,
    int_image_2d_multisample_array     = INT_IMAGE_2D_MULTISAMPLE_ARRAY,

    uint_image_1d                      = UNSIGNED_INT_IMAGE_1D,
    uint_image_2d                      = UNSIGNED_INT_IMAGE_2D,
    uint_image_3d                      = UNSIGNED_INT_IMAGE_3D,
    uint_image_2d_rect                 = UNSIGNED_INT_IMAGE_2D_RECT,
    uint_image_cube                    = UNSIGNED_INT_IMAGE_CUBE,
    uint_image_buffer                  = UNSIGNED_INT_IMAGE_BUFFER,
    uint_image_1d_array                = UNSIGNED_INT_IMAGE_1D_ARRAY,
    uint_image_2d_array                = UNSIGNED_INT_IMAGE_2D_ARRAY,
    uint_image_cube_map_array          = UNSIGNED_INT_IMAGE_CUBE_MAP_ARRAY,
    uint_image_2d_multisample          = UNSIGNED_INT_IMAGE_2D_MULTISAMPLE,
    uint_image_2d_multisample_array    = UNSIGNED_INT_IMAGE_2D_MULTISAMPLE_ARRAY,

    unsigned_int_atomic_counter        = UNSIGNED_INT_ATOMIC_COUNTER,
}

AttribTypes :: enum i32 {
    float             = FLOAT,
    float_vec2        = FLOAT_VEC2,
    float_vec3        = FLOAT_VEC3,
    float_vec4        = FLOAT_VEC4,
    float_mat2        = FLOAT_MAT2,
    float_mat3        = FLOAT_MAT3,
    float_mat4        = FLOAT_MAT4,
    float_mat2x3      = FLOAT_MAT2x3,
    float_mat2x4      = FLOAT_MAT2x4,
    float_mat3x2      = FLOAT_MAT3x2,
    float_mat3x4      = FLOAT_MAT3x4,
    float_mat4x2      = FLOAT_MAT4x2,
    float_mat4x3      = FLOAT_MAT4x3,
    int_              = INT,
    int_vec2          = INT_VEC2,
    int_vec3          = INT_VEC3,
    int_vec4          = INT_VEC4,
    uint_             = UNSIGNED_INT,
    uint_vec2         = UNSIGNED_INT_VEC2,
    uint_vec3         = UNSIGNED_INT_VEC3,
    uint_vec4         = UNSIGNED_INT_VEC4,
}

GetShaderNames :: enum i32 {
    ShaderType                         = SHADER_TYPE,
    DeleteStatus                       = DELETE_STATUS,
    CompileStatus                      = COMPILE_STATUS,
    InfoLogLength                      = INFO_LOG_LENGTH,
    ShaderSourceLength                 = SHADER_SOURCE_LENGTH,
}

GetProgramNames :: enum i32 {
    DeleteStatus                       = DELETE_STATUS,
    LinkStatus                         = LINK_STATUS,
    ValidateStatus                     = VALIDATE_STATUS,
    InfoLogLength                      = INFO_LOG_LENGTH,
    AttachedShaders                    = ATTACHED_SHADERS,
    ActiveAttributes                   = ACTIVE_ATTRIBUTES,
    ActiveAttributeMaxLength           = ACTIVE_ATTRIBUTE_MAX_LENGTH,
    ActiveUniforms                     = ACTIVE_UNIFORMS,
    ActiveUniformMaxLength             = ACTIVE_UNIFORM_MAX_LENGTH,
    TransformFeedbackBufferMode        = TRANSFORM_FEEDBACK_BUFFER_MODE,
    TransformFeedbackVaryingMaxLength  = TRANSFORM_FEEDBACK_VARYING_MAX_LENGTH,
    GeometryVerticesOut                = GEOMETRY_VERTICES_OUT,
    GeometryInputType                  = GEOMETRY_INPUT_TYPE,
    GeometryOutputType                 = GEOMETRY_OUTPUT_TYPE,
}

DebugSource :: enum i32 {
    Api                                = DEBUG_SOURCE_API,
    WindowSystem                       = DEBUG_SOURCE_WINDOW_SYSTEM,
    ShaderCompiler                     = DEBUG_SOURCE_SHADER_COMPILER,
    ThirdParty                         = DEBUG_SOURCE_THIRD_PARTY,
    Application                        = DEBUG_SOURCE_APPLICATION,
    Other                              = DEBUG_SOURCE_OTHER,
    DontCare                           = DONT_CARE,
}

DebugType :: enum i32 {
    Error                              = DEBUG_TYPE_ERROR,
    DeprecatedBehavior                 = DEBUG_TYPE_DEPRECATED_BEHAVIOR,
    UndefinedBehavior                  = DEBUG_TYPE_UNDEFINED_BEHAVIOR,
    Portability                        = DEBUG_TYPE_PORTABILITY,
    Performance                        = DEBUG_TYPE_PERFORMANCE,
    Marker                             = DEBUG_TYPE_MARKER,
    PushGroup                          = DEBUG_TYPE_PUSH_GROUP,
    PopGroup                           = DEBUG_TYPE_POP_GROUP,
    Other                              = DEBUG_TYPE_OTHER,
    DontCare                           = DONT_CARE,
}

DebugSeverity :: enum i32 {
    High                               = DEBUG_SEVERITY_HIGH,
    Medium                             = DEBUG_SEVERITY_MEDIUM,
    Low                                = DEBUG_SEVERITY_LOW,
    Notification                       = DEBUG_SEVERITY_NOTIFICATION,
    DontCare                           = DONT_CARE,
}

DrawModes :: enum i32 {
    Points                             = POINTS, 
    LineStrip                          = LINE_STRIP,
    LineLoop                           = LINE_LOOP, 
    Lines                              = LINES,
    LineStripAdjacency                 = LINE_STRIP_ADJACENCY,
    LinesAdjacency                     = LINES_ADJACENCY,
    TriangleStrip                      = TRIANGLE_STRIP,
    TriangleFan                        = TRIANGLE_FAN,
    Triangles                          = TRIANGLES,
    TriangleStripAdjacency             = TRIANGLE_STRIP_ADJACENCY,
    TrianglesAdjacency                 = TRIANGLES_ADJACENCY,
    Patches                            = PATCHES,
}

DrawElementsType :: enum i32 {
    UByte                              = UNSIGNED_BYTE,
    UShort                             = UNSIGNED_SHORT,
    UInt                               = UNSIGNED_INT,
}

ShaderTypes :: enum i32 {
    Compute                            = COMPUTE_SHADER,
    Vertex                             = VERTEX_SHADER,
    TessControl                        = TESS_CONTROL_SHADER,
    TessEvaluation                     = TESS_EVALUATION_SHADER,
    Geometry                           = GEOMETRY_SHADER,
    Fragment                           = FRAGMENT_SHADER,
}

BlendFactors :: enum i32 {
    Zero                               = ZERO,
    One                                = ONE,
    SrcColor                           = SRC_COLOR,
    OneMinusSrccolor                   = ONE_MINUS_SRC_COLOR,
    DstColor                           = DST_COLOR,
    OneMinusDstColor                   = ONE_MINUS_DST_COLOR,
    SrcAlpha                           = SRC_ALPHA,
    OneMinusSrcAlpha                   = ONE_MINUS_SRC_ALPHA,
    DstAlpha                           = DST_ALPHA,
    OneMinusDstAlpha                   = ONE_MINUS_DST_ALPHA,
    Constantcolor                      = CONSTANT_COLOR,
    OneMinusConstantColor              = ONE_MINUS_CONSTANT_COLOR,
    ConstantAlpha                      = CONSTANT_ALPHA,
    OneMinusConstantAlpha              = ONE_MINUS_CONSTANT_ALPHA,
}

BlendEquations :: enum i32 {
    FuncAdd                            = FUNC_ADD,
    FuncSubtract                       = FUNC_SUBTRACT,
    FuncReverseSubtract                = FUNC_REVERSE_SUBTRACT,
    Min                                = MIN,
    Max                                = MAX,
}

Capabilities :: enum i32 {
    Blend                              = BLEND,
    ClipDistance0                      = CLIP_DISTANCE0,
    ClipDistance1                      = CLIP_DISTANCE1,
    ClipDistance3                      = CLIP_DISTANCE3,
    ClipDistance2                      = CLIP_DISTANCE2,
    ClipDistance4                      = CLIP_DISTANCE4,
    ClipDistance5                      = CLIP_DISTANCE5,
    ClipDistance6                      = CLIP_DISTANCE6,
    ClipDistance7                      = CLIP_DISTANCE7,
    ColorLogicOp                       = COLOR_LOGIC_OP,
    CullFace                           = CULL_FACE,
    DebugOutput                        = DEBUG_OUTPUT,
    DebugOutputSynchronous             = DEBUG_OUTPUT_SYNCHRONOUS,
    DepthVlamp                         = DEPTH_CLAMP,
    DepthTest                          = DEPTH_TEST,
    Dither                             = DITHER,
    FramebufferSRGB                    = FRAMEBUFFER_SRGB,
    LineSmooth                         = LINE_SMOOTH,
    Multisample                        = MULTISAMPLE,
    PolygonOffsetFill                  = POLYGON_OFFSET_FILL,
    PolygonOffsetLine                  = POLYGON_OFFSET_LINE,
    PolygonOffsetPoint                 = POLYGON_OFFSET_POINT,
    PolygonSmooth                      = POLYGON_SMOOTH,
    PrimitiveRestart                   = PRIMITIVE_RESTART,
    PrimitiveRestartFixedIndex         = PRIMITIVE_RESTART_FIXED_INDEX,
    RasterizerDiscard                  = RASTERIZER_DISCARD,
    SampleAlphaToCoverage              = SAMPLE_ALPHA_TO_COVERAGE,
    SampleAlphaToOne                   = SAMPLE_ALPHA_TO_ONE,
    SampleCoverage                     = SAMPLE_COVERAGE,
    SampleShading                      = SAMPLE_SHADING,
    SampleMask                         = SAMPLE_MASK,
    ScissorTest                        = SCISSOR_TEST,
    StencilTest                        = STENCIL_TEST,
    TextureCubeMapSeamless             = TEXTURE_CUBE_MAP_SEAMLESS,
    ProgramPointSize                   = PROGRAM_POINT_SIZE,
}

ClearFlags :: enum i32 {
    COLOR_BUFFER                       = COLOR_BUFFER_BIT,
    DEPTH_BUFFER                       = DEPTH_BUFFER_BIT,
    STENCIL_BUFFER                     = STENCIL_BUFFER_BIT,
}

GetStringNames :: enum i32 {
    Vendor                             = VENDOR,
    Renderer                           = RENDERER,
    Version                            = VERSION,
    ShadingLanguageVersion             = SHADING_LANGUAGE_VERSION,
    Extensions                         = EXTENSIONS,   
}

GetIntegerNames :: enum i32 {
    ContextFlags                       = CONTEXT_FLAGS,
    MajorVersion                       = MAJOR_VERSION,
    MinorVersion                       = MINOR_VERSION,
    NumExtensions                      = NUM_EXTENSIONS,
    NumShadingLanguageVersions         = NUM_SHADING_LANGUAGE_VERSIONS,

    TextureBinding2D                   = TEXTURE_BINDING_2D,
    ArraybufferBinding                 = ARRAY_BUFFER_BINDING,
    VertexArrayBinding                 = VERTEX_ARRAY_BINDING,

    CurrentProgram                     = CURRENT_PROGRAM,
    ActiveTexture                      = ACTIVE_TEXTURE,
    ElementArray_buffer_binding        = ELEMENT_ARRAY_BUFFER_BINDING,
    BlendSrc                           = BLEND_SRC,
    BlendDst                           = BLEND_DST,
    BlendEquation_rgb                  = BLEND_EQUATION_RGB,
    BlendEquation_alpha                = BLEND_EQUATION_ALPHA,
    Viewport                           = VIEWPORT,
    ScissorBox                         = SCISSOR_BOX,
    Blend                              = BLEND,
    CullFace                           = CULL_FACE,
    DepthTest                          = DEPTH_TEST,
    ScissorTest                        = SCISSOR_TEST,
    PolygonMode                        = POLYGON_MODE,
}

InternalColorFormat :: enum i32 {
    //Base
    DepthComponent                     = DEPTH_COMPONENT,
    DepthStencil                       = DEPTH_STENCIL,
    RED                                = RED,
    RG                                 = RG,
    RGB                                = RGB,
    RGBA                               = RGBA,

    //Sized
    R8                                 = R8,
    R8_SNORM                           = R8_SNORM,
    R16                                = R16,
    R16_SNORM                          = R16_SNORM,
    RG8                                = RG8,
    RG8_SNORM                          = RG8_SNORM,
    RG16                               = RG16,
    RG16_SNORM                         = RG16_SNORM,
    R3_G3_B2                           = R3_G3_B2,
    RGB4                               = RGB4,
    RGB5                               = RGB5,
    RGB8                               = RGB8,
    RGB8_SNORM                         = RGB8_SNORM,
    RGB10                              = RGB10,
    RGB12                              = RGB12,
    RGB16_SNORM                        = RGB16_SNORM,
    RGBA2                              = RGBA2,
    RGBA4                              = RGBA4,
    RGB5_A1                            = RGB5_A1,
    RGBA8                              = RGBA8,
    RGBA8_SNORM                        = RGBA8_SNORM,
    RGB10_A2                           = RGB10_A2,
    RGB10_A2UI                         = RGB10_A2UI,
    RGBA12                             = RGBA12,
    RGBA16                             = RGBA16,
    SRGB8                              = SRGB8,
    SRGB8_ALPHA8                       = SRGB8_ALPHA8,
    R16F                               = R16F,
    RG16F                              = RG16F,
    RGB16F                             = RGB16F,
    RGBA16F                            = RGBA16F,
    R32F                               = R32F,
    RG32F                              = RG32F,
    RGB32F                             = RGB32F,
    RGBA32F                            = RGBA32F,
    R11F_G11F_B10F                     = R11F_G11F_B10F,
    RGB9_E5                            = RGB9_E5,
    R8I                                = R8I,
    R8UI                               = R8UI,
    R16I                               = R16I,
    R16UI                              = R16UI,
    R32I                               = R32I,
    R32UI                              = R32UI,
    RG8I                               = RG8I,
    RG8UI                              = RG8UI,
    RG16I                              = RG16I,
    RG16UI                             = RG16UI,
    RG32I                              = RG32I,
    RG32UI                             = RG32UI,
    RGB8I                              = RGB8I,
    RGB8UI                             = RGB8UI,
    RGB16I                             = RGB16I,
    RGB16UI                            = RGB16UI,
    RGB32I                             = RGB32I,
    RGB32UI                            = RGB32UI,
    RGBA8I                             = RGBA8I,
    RGBA8UI                            = RGBA8UI,
    RGBA16I                            = RGBA16I,
    RGBA16UI                           = RGBA16UI,
    RGBA32I                            = RGBA32I,
    RGBA32UI                           = RGBA32UI,

    //Compressed
    COMPRESSED_RED                     = COMPRESSED_RED,
    COMPRESSED_RG                      = COMPRESSED_RG,
    COMPRESSED_RGB                     = COMPRESSED_RGB,
    COMPRESSED_RGBA                    = COMPRESSED_RGBA,
    COMPRESSED_SRGB                    = COMPRESSED_SRGB,
    COMPRESSED_SRGB_ALPHA              = COMPRESSED_SRGB_ALPHA,
    COMPRESSED_RED_RGTC1               = COMPRESSED_RED_RGTC1,
    COMPRESSED_SIGNED_RED_RGTC1        = COMPRESSED_SIGNED_RED_RGTC1,
    COMPRESSED_RG_RGTC2                = COMPRESSED_RG_RGTC2,
    COMPRESSED_SIGNED_RG_RGTC2         = COMPRESSED_SIGNED_RG_RGTC2,
    COMPRESSED_RGBA_BPTC_UNORM         = COMPRESSED_RGBA_BPTC_UNORM,
    COMPRESSED_SRGB_ALPHA_BPTC_UNORM   = COMPRESSED_SRGB_ALPHA_BPTC_UNORM,
    COMPRESSED_RGB_BPTC_SIGNED_FLOAT   = COMPRESSED_RGB_BPTC_SIGNED_FLOAT,
    COMPRESSED_RGB_BPTC_UNSIGNED_FLOAT = COMPRESSED_RGB_BPTC_UNSIGNED_FLOAT,
}

PixelDataFormat :: enum i32 {
    Red                                = RED,
    RG                                 = RG,
    RGB                                = RGB,
    BGR                                = BGR,
    RGBA                               = RGBA,
    BGRA                               = BGRA,
    RedInteger                         = RED_INTEGER,
    RGInteger                          = RG_INTEGER,
    RGBInteger                         = RGB_INTEGER,
    BGRInteger                         = BGR_INTEGER,
    RGBAInteger                        = RGBA_INTEGER,
    BGRAInteger                        = BGRA_INTEGER,
    StencilIndex                       = STENCIL_INDEX,
    DepthComponent                     = DEPTH_COMPONENT,
    DepthStencil                       = DEPTH_STENCIL,
}

Texture2DDataType :: enum i32 {
    UByte                              = UNSIGNED_BYTE,
    Byte                               = BYTE,
    UShort                             = UNSIGNED_SHORT,
    Short                              = SHORT,
    UInt                               = UNSIGNED_INT,
    Int                                = INT,
    Float                              = FLOAT,
    UByte_3_3_2                        = UNSIGNED_BYTE_3_3_2,
    UByte_2_3_3_rev                    = UNSIGNED_BYTE_2_3_3_REV,
    UShort_5_6_5                       = UNSIGNED_SHORT_5_6_5,
    UShort_5_6_5_rev                   = UNSIGNED_SHORT_5_6_5_REV,
    UShort_4_4_4_4                     = UNSIGNED_SHORT_4_4_4_4,
    UShort_4_4_4_4_rev                 = UNSIGNED_SHORT_4_4_4_4_REV,
    UShort_5_5_5_1                     = UNSIGNED_SHORT_5_5_5_1,
    UShort_1_5_5_5_rev                 = UNSIGNED_SHORT_1_5_5_5_REV,
    UInt_8_8_8_8                       = UNSIGNED_INT_8_8_8_8,
    UInt_8_8_8_8_rev                   = UNSIGNED_INT_8_8_8_8_REV,
    UInt_10_10_10_2                    = UNSIGNED_INT_10_10_10_2,
    UInt_2_10_10_10_rev                = UNSIGNED_INT_2_10_10_10_REV,
}

VertexAttribDataType :: enum i32 {
    Byte                               = BYTE,
    UByte                              = UNSIGNED_BYTE,
    Short                              = SHORT,
    Ushort                             = UNSIGNED_SHORT,
    Int                                = INT,
    UInt                               = UNSIGNED_INT, 
    HalfFloat                          = HALF_FLOAT,
    Float                              = FLOAT,
    Double                             = DOUBLE,
    Fixed                              = FIXED,
    Int_2_10_10_10_rev                 = INT_2_10_10_10_REV,
    UInt_2_10_10_10_rev                = UNSIGNED_INT_2_10_10_10_REV, 
    UInt_10f_11f_11f_rev               = UNSIGNED_INT_10F_11F_11F_REV, 
}

MipmapTargets :: enum i32 {
    Texture1D                          = TEXTURE_1D, 
    Texture2D                          = TEXTURE_2D,
    Texture3D                          = TEXTURE_3D, 

    Texture1DArray                     = TEXTURE_1D_ARRAY,
    Texture2DArray                     = TEXTURE_2D_ARRAY,
    TextureCubeMapArray                = TEXTURE_CUBE_MAP_ARRAY,
}

TextureTargets :: enum i32 {
    Texture1D                          = TEXTURE_1D, 
    Texture2D                          = TEXTURE_2D,
    Texture3D                          = TEXTURE_3D, 

    TextureRectangle                   = TEXTURE_RECTANGLE,
    TextureCubeMap                     = TEXTURE_CUBE_MAP,
    Texture2DMultisample               = TEXTURE_2D_MULTISAMPLE, 
    TextureBuffer                      = TEXTURE_BUFFER,

    Texture1DArray                     = TEXTURE_1D_ARRAY,
    Texture2DArray                     = TEXTURE_2D_ARRAY,
    TextureCubeMapArray                = TEXTURE_CUBE_MAP_ARRAY,
    Texture2DMultisampleArray          = TEXTURE_2D_MULTISAMPLE_ARRAY,
}

TextureParameters :: enum i32 {
    DepthStencilTextureMode            = DEPTH_STENCIL_TEXTURE_MODE, 
    BaseLevel                          = TEXTURE_BASE_LEVEL,
    CompareFunc                        = TEXTURE_COMPARE_FUNC,
    CompareMode                        = TEXTURE_COMPARE_MODE,
    LodBias                            = TEXTURE_LOD_BIAS,
    MinFilter                          = TEXTURE_MIN_FILTER,
    MagFilter                          = TEXTURE_MAG_FILTER,
    MinLod                             = TEXTURE_MIN_LOD,
    MaxLod                             = TEXTURE_MAX_LOD,
    MaxLevel                           = TEXTURE_MAX_LEVEL,
    SwizzleR                           = TEXTURE_SWIZZLE_R,
    SwizzleG                           = TEXTURE_SWIZZLE_G,
    SwizzleB                           = TEXTURE_SWIZZLE_B,
    SwizzleA                           = TEXTURE_SWIZZLE_A,
    WrapS                              = TEXTURE_WRAP_S,
    WrapT                              = TEXTURE_WRAP_T,
    WrapR                              = TEXTURE_WRAP_R,
}

TextureParametersValues :: enum i32 {
    Nearest                            = NEAREST,
    Linear                             = LINEAR,
    NearestMipmapNearest               = NEAREST_MIPMAP_NEAREST,
    LinearMipmapNearest                = LINEAR_MIPMAP_NEAREST,
    NearestMipmapLinear                = NEAREST_MIPMAP_LINEAR,
    LinearMipmapLinear                 = LINEAR_MIPMAP_LINEAR,

    Repeat                             = REPEAT,
    ClampToEdge                        = CLAMP_TO_EDGE,
}

TextureUnits :: enum i32 {
    Texture0                           = TEXTURE0,
    Texture1                           = TEXTURE1,
    Texture2                           = TEXTURE2,
    Texture3                           = TEXTURE3,
    Texture4                           = TEXTURE4,
    Texture5                           = TEXTURE5,
    Texture6                           = TEXTURE6,
    Texture7                           = TEXTURE7,
    Texture8                           = TEXTURE8,
    Texture9                           = TEXTURE9,
    Texture10                          = TEXTURE10,
    Texture11                          = TEXTURE11,
    Texture12                          = TEXTURE12,
    Texture13                          = TEXTURE13,
    Texture14                          = TEXTURE14,
    Texture15                          = TEXTURE15,
    Texture16                          = TEXTURE16,
    Texture17                          = TEXTURE17,
    Texture18                          = TEXTURE18,
    Texture19                          = TEXTURE19,
    Texture20                          = TEXTURE20,
    Texture21                          = TEXTURE21,
    Texture22                          = TEXTURE22,
    Texture23                          = TEXTURE23,
    Texture24                          = TEXTURE24,
    Texture25                          = TEXTURE25,
    Texture26                          = TEXTURE26,
    Texture27                          = TEXTURE27,
    Texture28                          = TEXTURE28,
    Texture29                          = TEXTURE29,
    Texture30                          = TEXTURE30,
    Texture31                          = TEXTURE31,
}

BufferTargets :: enum i32 {
    Array                              = ARRAY_BUFFER,
    AtomicCounter                      = ATOMIC_COUNTER_BUFFER,
    CopyRead                           = COPY_READ_BUFFER,
    CopyWrite                          = COPY_WRITE_BUFFER,
    DispatchIndirect                   = DISPATCH_INDIRECT_BUFFER,
    Draw_indirect                      = DRAW_INDIRECT_BUFFER,
    ElementArray                       = ELEMENT_ARRAY_BUFFER,
    PixelPack                          = PIXEL_PACK_BUFFER,
    PixelUnpack                        = PIXEL_UNPACK_BUFFER,
    Query                              = QUERY_BUFFER,
    ShaderStorage                      = SHADER_STORAGE_BUFFER,
    Texture                            = TEXTURE_BUFFER,
    TransformFeedback                  = TRANSFORM_FEEDBACK_BUFFER,
    Uniform                            = UNIFORM_BUFFER,
}

BufferDataUsage :: enum i32 {
    StreamDraw                         = STREAM_DRAW, 
    StreamRead                         = STREAM_READ,
    StreamCopy                         = STREAM_COPY,
    StaticDraw                         = STATIC_DRAW,
    StaticRead                         = STATIC_READ,
    StaticCopy                         = STATIC_COPY,
    DynamicDraw                        = DYNAMIC_DRAW,
    DynamicRead                        = DYNAMIC_READ,
    DynamicCopy                        = DYNAMIC_COPY,
}

PolygonFace :: enum i32 {
    Front                              = FRONT,
    Back                               = BACK,
    FrontAndBack                       = FRONT_AND_BACK,
}

PolygonModes :: enum i32 {
    Point                              = POINT,
    Line                               = LINE,
    Fill                               = FILL,
}

DepthFuncs :: enum i32 {
    Never                              = NEVER,
    Less                               = LESS,
    Equal                              = EQUAL,
    Lequal                             = LEQUAL,
    Greater                            = GREATER,
    NotEqual                           = NOTEQUAL,
    Gequal                             = GEQUAL,
    Always                             = ALWAYS,
}