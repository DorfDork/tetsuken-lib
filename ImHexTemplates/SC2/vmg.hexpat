#pragma endian big

import std.core;
import std.io;
import std.mem;

enum Console : u8 {
    UNK0     = 0,
    UNK1     = 1,
    UNK2     = 2,
    GAMECUBE = 3,
    XBOX     = 4
};

enum ModelContent : u8 {
    STAGE     = 0,
    CHARACTER = 1,
    WEAPON    = 2
};

enum MatrixType : u8 {
    UNKMT0    = 0,
    STAGEMTX  = 1,
    BONEMTX   = 2,
    EFFECTMTX = 3
};

enum MaterialType : u8 {
    UNLIT  = 0,
    PRELIT = 1,
    LIT    = 2
};

enum OpacitySrc : u32 {
    OPAQUE         = 0,
    ALPHA          = 1,
    ADDITIVE       = 2,
    ADDITIVE_ALPHA = 3,
    MULTIPLY       = 4,
    MODULATE_2X    = 11,
    SPECBALL_16    = 16,
    SPECBALL_32    = 32,
    SPECBALL_ALPHA = 33
};

enum BoneType : u8 {
    BODY    = 0,
    WEAPON  = 1,
    FINGER  = 2,
    FACE    = 3,
    ROT     = 4,
    PROT    = 5,
    AIM     = 7,
    SLERP   = 9,
    SWING   = 11, // Some silly stuff with GC (NO ENDIAN SWAPIN)
    SHIT    = 12,
    UNNAMED = 14,
    RANDEYE = 15,
    RANDLID = 16
};

enum MeshGCNContent : u8 {
    STATICGCN  = 2, //(2, 2, 2, 2)
    SKINNEDGCN = 3  //(3, 3, 2, 3)  //(3, 3, 3, 3)
};

enum PrimativeGCN : u8 {
    PACKEDTRIANGLELIST  = 0x90,
    PACKEDTRIANGLESTRIP = 0x98
};

enum ImageTypeGCN : u32 {
    I4         = 0,  //(4 bit intensity, 8x8 tiles)
    I8         = 1,  //(8 bit intensity, 8x4 tiles)
    IA4        = 2,  //(4 bit intensity with 4 bit alpha, 8x4 tiles)
    IA8        = 3,  //(8 bit intensity with 8 bit alpha, 4x4 tiles)
    RGB565     = 4,  //(4x4 tiles)
    RGB5A3     = 5,  //(*) (4x4 tiles)
    RGBA8      = 6,  //(4x4 tiles in two cache lines - first is AR and second is GB)
    CI4        = 8,  //(4 bit color index, 8x8 tiles)
    CI8        = 9,  //(8 bit color index, 8x4 tiles)
    C14X2      = 10, //(14 bit color index, 4x4 tiles)
    CMPR_ALPHA = 12,
    CMPR       = 14, //(S3TC compressed, 2x2 blocks of 4x4 tiles)
    XFB        = 15, // 0x0F
    UNK16      = 16  // 0x10
};

enum TextureMapType : u16 {
    UNKTT0   = 0,
    DIFFUSE  = 1,
    EFFECTS  = 2,
    ANIMATE  = 3,
    UNKTT    = 4,
    SPECBALL = 5
};

enum MaterialTableCull : u8 {
    DRAWNBOTHSIDES                 = 0,
    DRAWNONESIDE                   = 8,
    DRAWNBOTHSIDES_ALPHATEST       = 0x10,
    DRAWNONESIDE_ALPHATEST         = 0x18,
    DRAWNBOTHSIDES_ALPHATEST_BIT20 = 0x30,
    DRAWNONESIDE_ALPHATEST_BIT20   = 0x38
};

struct Vector4b {
    u8 x;
    u8 y;
    u8 z;
    u8 w;
} [[static, name(std::format("{}{}{}{}", x, y, z, w))]];

struct VectorColorb {
    u8 r [[color("FF0000")]];
    u8 g [[color("00FF00")]];
    u8 b [[color("0000FF")]];
    u8 a;
} [[static, color(std::format("{:02X}{:02X}{:02X}", r, g, b))]];

struct Face {
    u16 x;
    u16 y;
    u16 z;
} [[static, name(std::format("{}{}{}", x, y, z))]];

struct VectorUVf {
    float x;
} [[static, name(std::format("{},{}", x, ((x * -1) + 1)))]];

struct Vector2f {
    float x;
    float y;
} [[static, name(std::format("{},{}", x, y))]];

struct Vector3f {
    float x;
    float y;
    float z;
} [[static, name(std::format("{},{},{}", x, y, z))]];

struct Vector4f {
    float x;
    float y;
    float z;
    float w;
} [[static, name(std::format("{},{},{},{}", x, y, z, w))]];

struct Matrix2 {
    Vector4f matrix4x4Transform[4];
};

struct MatrixUnk { // data Present in stage files? boundaries?
    u16 unk1;
    u16 matrix2Count;
    u32 matrix2Offset; // if count is 0, then this will point to the material block
    Matrix2 matrix2[matrix2Count] @ matrix2Offset;
};

fn matrix_unk_flag_size(u8 type) {
    if (type == 2 || type == 3 || type == 12) {
        return 0x20;
    }
    if (type == 10 || type == 11) {
        return 0x30;
    }
    if (type == 7 || type == 9) {
        return 0x40;
    }
    return 0x10;
};

struct MatrixUnkFlag {
    u8 type;
    if (type == 1) {
        u8 unk1;
        u8 indexCount;
        u8 unk2;
        u8 indices[indexCount];
        u8 unused[12 - indexCount];
    } else if (type == 8) {
        u8 unk1;
        u8 matrixCount;
        u8 unk2;
        u8 unused[12];
        Matrix2 matrices[matrixCount];
    } else {
        u8 unk[3];
        float values[(matrix_unk_flag_size(type) - 4) / 4];
    }
};

struct MatrixUnkFlagList {
    MatrixUnkFlag unkFlags[while ($[$] != 0)];
    MatrixUnkFlag end;
};

struct EffectPoint {
    Vector4f position;
    Vector4f direction;
};

struct MatrixTable {
    MatrixType type;
    if (type == MatrixType::EFFECTMTX) {
        u8 effectTextureCount;
        u8 effectPointCount;
        u8 effectType;
        float effectValues[3];
    } else {
        u8 parentBoneIdx; // parent object to this bone?
        u16 ukn1;
        u32 unkFlagListOffset; // on stages files an offset is present
        u32 ukn4;
        u32 ukn5;
    }
    Vector4f matrix4x4Transform[4];
    if (type == MatrixType::EFFECTMTX) {
        u32 effectTextureListOffset;
        u32 effectPointsOffset;
        padding[248];
        if (effectTextureCount > 0) {
            u32 effectTextureOffsets[effectTextureCount] @ effectTextureListOffset;
        }
        if (effectPointCount > 0) {
            EffectPoint effectPoints[effectPointCount] @ effectPointsOffset;
        }
    } else {
        padding[256]; //64 more than gamecube
        if (unkFlagListOffset > 0) {
            MatrixUnkFlagList unkFlagList @ unkFlagListOffset;
        }
    }
};

struct StageBuffers {
    if (gMdlContents == ModelContent::STAGE) {
        u32 locatorOffset = $;
        u32 listBufferOffset;
        u32 nodeBufferOffset;
        u32 matrixPaletteOffset;
        u32 pad;
        Matrix2 matrixPalette[(listBufferOffset - matrixPaletteOffset) / 64] @ matrixPaletteOffset;
        u8 listBuffer[nodeBufferOffset - listBufferOffset] @ listBufferOffset;
        u8 nodeBuffer[locatorOffset - nodeBufferOffset] @ nodeBufferOffset;
    }
};

u8 gMdlVersion = 0;
ModelContent gMdlContents = 0;
u16 gMdlWeightTables = 0;

struct MdlHeader {
    char magic[4];
    u8 version; // 0x02=Xbox?, 0x03=Gamecube, 0x04=Xbox
    gMdlVersion = version;
    u8 pointerListOffset;
    u8 pointerCount;
    u8 flags;
    u8 unk08;
    ModelContent modelContent;
    gMdlContents = modelContent;
    u16 matricesCount;
    u16 objects1Count;
    u16 objects2Count;
    u16 objects3Count;
    u16 bonesCount;
    u16 materialsCount;
    u16 weightTableCount; // always 1?
    gMdlWeightTables = weightTableCount;
    u32 textureTableOffset;
    u32 materialOffset;
    u32 textureMapOffset;
    u32 matrixTableOffset;
    u32 uknMatrixTableOffset;
    u32 object1Offset;
    u32 object2Offset;
    u32 object3Offset;
    u32 weightTableOffset;
    u32 stageBuffersOffset;
    u32 boneOffset;
    u32 boneNameOffset;
    u32 boneHeaderOffset;
};

enum WrapMode : u32 {
    CLAMP  = 0,
    REPEAT = 1,
    MIRROR = 2
    // Hardware testing indicates that WrapMode set to 3 behaves the same as clamp, though this is an
    // invalid value
};

enum FilterMode : u32 {
    NEAR   = 0,
    LINEAR = 1
};

enum MipMode : u32 {
    NONE   = 0,
    POINT  = 1,
    LINEAR = 2
};

enum LODType : u32 {
    EDGE     = 0,
    DIAGONAL = 1
};

enum MaxAniso : u32 {
    ANISO_1 = 0,
    ANISO_2 = 1,
    ANISO_4 = 2
};

bitfield TexMode0 {
    padd                 : 12;
    bool lodClamp        : 1;
    MaxAniso maxAniso    : 2;
    signed lodBias       : 8;
    LODType diagLod      : 1;
    FilterMode minFilter : 1;
    MipMode mipmapFilter : 2;
    FilterMode magFilter : 1;
    WrapMode wrapT       : 2;
    WrapMode wrapS       : 2;
};

bitfield Dimension {
    ImageTypeGCN imageType : 12;
    y                      : 10;
    x                      : 10;
} [[static, name(std::format("imagetype{}, X: {}, Y:{}", imageType, x, y))]];

enum PalletTypeGCN : u32 {
    IA8    = 0,
    RGB565 = 1,
    RGB5A3 = 2
};

bitfield RGB565 {
    r : 5;
    g : 6;
    b : 5;
} [[static, color(std::format("{:02X}{:02X}{:02X}", r, g, b))]];

bitfield TexImage1 {
    padd                 : 10;
    tmemEven             : 15;
    cacheWidth           : 3;
    cacheHeight          : 3;
    cacheManuallyManaged : 1;
};

u32 gVgtOffset = 0;
u32 gMipWidth = 0;
u32 gMipHeight = 0;
ImageTypeGCN gMipImageType = 0;

fn mip_level_size_gcn(u32 width, u32 height, ImageTypeGCN type) {
    u32 tileWidth = 4;
    u32 tileHeight = 4;
    u32 tileSize = 32;
    if (type == ImageTypeGCN::I4 || type == ImageTypeGCN::CI4 || type == ImageTypeGCN::CMPR || type == ImageTypeGCN::CMPR_ALPHA) {
        tileWidth = 8;
        tileHeight = 8;
    }
    if (type == ImageTypeGCN::I8 || type == ImageTypeGCN::IA4 || type == ImageTypeGCN::CI8) {
        tileWidth = 8;
    }
    if (type == ImageTypeGCN::RGBA8) {
        tileSize = 64;
    }
    return ((width + tileWidth - 1) / tileWidth) * ((height + tileHeight - 1) / tileHeight) * tileSize;
};

struct TextureMipLevel {
    if (gMipWidth > 1) {
        gMipWidth = gMipWidth / 2;
    }
    if (gMipHeight > 1) {
        gMipHeight = gMipHeight / 2;
    }
    u8 mipData[mip_level_size_gcn(gMipWidth, gMipHeight, gMipImageType)];
};

bitfield TextureFlags {
    PALETTE_PLANES : 1;
    ALPHA_SLICE    : 1;
    unk2           : 3;
    ALPHA_TEST     : 1;
    unk6           : 10;
} [[bitfield_order(std::core::BitfieldOrder::LeastToMostSignificant, 16)]];

bitfield TexObjFlags {
    MIPMAP      : 1;
    NOT_INDEXED : 1;
    unk2        : 6;
} [[bitfield_order(std::core::BitfieldOrder::LeastToMostSignificant, 8)]];

struct TextureDataSlice {
    TexMode0 texModeInfo;
    u16 texMode1Register;
    u8 maxLod;
    u8 minLod;
    Dimension texImage;
    u32 dataOffset;
    u16 imageSizeCheck @ $ + 0xC [[hidden]];
    if (imageSizeCheck > 0) {
        TextureFlags userFlags;
        u16 combinedFormat;
    } else {
        u16 widthVisible;
        u16 heightVisible;
    }
    ImageTypeGCN imageType;
    u32 tlutName;
    u16 imageSize;
    u8 loadFormat;
    TexObjFlags texObjFlags;
    if (imageSize > 0) {
        u8 data[imageSize * 32] @ gVgtOffset + dataOffset;
        if (maxLod >= 16) {
            gMipWidth = texImage.x + 1;
            gMipHeight = texImage.y + 1;
            gMipImageType = imageType;
            TextureMipLevel mips[maxLod / 16] @ gVgtOffset + dataOffset + imageSize * 32;
        }
    }
};

struct PalletData {
    u32 texTlut; // TexTLUT?
    u32 paletteOffset;
    u16 paletteCount;
    u16 pad;
    if (((texTlut >> 10) & 3) == 0) {
        u16 dataGr[paletteCount] @ gVgtOffset + paletteOffset;
        u16 dataAb[paletteCount] @ gVgtOffset + paletteOffset + (paletteCount * 2);
    } else {
        u16 data[paletteCount] @ gVgtOffset + paletteOffset;
    }
};

struct TextureData {
    u32 texturePaletteOffset;
    TextureDataSlice slices[2];
    bool colorIndexed = slices[0].imageType == ImageTypeGCN::CI4 || slices[0].imageType == ImageTypeGCN::CI8 || slices[0].imageType == ImageTypeGCN::C14X2;
    bool alphaIndexed = slices[1].imageSize > 0 && (slices[1].imageType == ImageTypeGCN::CI4 || slices[1].imageType == ImageTypeGCN::CI8 || slices[1].imageType == ImageTypeGCN::C14X2);
    if (texturePaletteOffset > 0 && (colorIndexed || alphaIndexed)) {
        PalletData pallet @ gVgtOffset + texturePaletteOffset;
        if (alphaIndexed) {
            PalletData alphaPallet @ gVgtOffset + texturePaletteOffset + 0xC;
        }
    }
};

struct PalletDataLegacy {
    u32 paletteOffset;
    u32 reserved;
    u32 size;
    u32 format;
    u16 data[size / 2] @ gVgtOffset + paletteOffset;
};

struct TextureDataLegacy {
    u32 texturePaletteOffset;
    u32 flags;
    u32 unk;
    u32 colorOffset; // Texture Offset
    u32 alphaOffset; // Texture Alpha Map Offset
    ImageTypeGCN imageType;
    u16 width;
    u16 height;
    u16 mipMapCount;
    u16 unk1E;
    if (texturePaletteOffset > 0 && (imageType == ImageTypeGCN::CI4 || imageType == ImageTypeGCN::CI8)) {
        PalletDataLegacy pallet @ gVgtOffset + texturePaletteOffset;
    }
};

struct VGT {
    gVgtOffset = $;
    char magic[4];

    u8 type;
    u8 flag1;
    u8 flag2;
    u8 flag3;

    u32 textureCount;
    u32 tlutCount;
    u32 headerLength;
    u32 tlutTableOffset;
    if (type == 3) {
        TextureDataLegacy textures[textureCount] @ gVgtOffset + headerLength;
    } else {
        TextureData textures[textureCount] @ gVgtOffset + headerLength;
    }
    //PalletData pltData[texCount];
};

struct TextureMap {
    TextureMapType type; // 0x01=Diffuse, 0x02=Effects, 0x03=Animating, 0x04=?, 0x05=SpecBall
    u16 size;            // size of entry?
    if (size != -1 && size > 4) {
        if (type == 1 && size == 36) {
            Vector2f tileUv;
            float values[6];
        } else {
            float values[(size - 4) / 4];
        }
    }
};

struct MaterialTable {
    MaterialTableCull cullMode; // 0x00=DrawnBothSides, 0x08=DrawnOneSide
    u8 ukn2;
    u8 ukn1;
    MaterialType type;
    OpacitySrc opacitySrc;
    u32 vgtOffset1; // offsets within the VGT block
    u32 vgtOffset2;
    u32 vgtOffset3;
    u32 map1Offset; //offsets to the texture table entries
    u32 map2Offset;
    u32 map3Offset;
    Vector4f ambientRgba;
    Vector4f diffuseRgba;
    Vector4f specularRgba;
    if (map1Offset != 0) {
        TextureMap textureMap1 @ map1Offset;
    }
    if (map2Offset != 0) {
        TextureMap textureMap2 @ map2Offset;
    }
    if (map3Offset != 0) {
        TextureMap textureMap3 @ map3Offset;
    }
};

struct BoneInfo { // bone positions relative to its parent
    Vector4f endPositionXyzScale;
    Vector4f startPositionXyzScale;
    Vector3f rotation; // eulerangles, degrees (n*360)
    u32 boneNameOffset;
    Vector3f uknBone1;
    u8 aimTargetIdx;
    u8 boneParentIdx;
    u8 boneIdx; // used for name look up?
    BoneType boneType;
    //if (boneNameOffset != 0) {
    char name[] @ boneNameOffset;
    //}
} [[name(std::format("{}", name))]];

enum PrimitiveType : u32 {
    POINTS,
    LINES,
    TRIANGLES,
    TRIANGLE_STRIP
};

enum CullMode : u32 {
    ALL,
    FRONT, // cull back-facing primitives
    BACK,  // cull front-facing primitives
    NONE   // cull all primitives
};

enum ComponentFormat : u8 {
    UBYTE          = 0, // Invalid for normals
    BYTE           = 1,
    USHORT         = 2, // Invalid for normals
    SHORT          = 3,
    FLOAT          = 4,
    // Known to be used by Fifa Street and Def Jam: Fight for New York
    // See https://bugs.dolphin-emu.org/issues/12719
    // Assumed to behave the same as float, but further testing is needed
    INVALID_FLOAT5 = 5,
    // Not known to be used
    INVALID_FLOAT6 = 6,
    INVALID_FLOAT7 = 7
};

bitfield RasterizationState {
    CullMode cullMode       : 2;
    padding                 : 1;
    PrimitiveType primitive : 2;
};

enum VertexComponentFormat : u8 {
    NOT_PRESENT = 0,
    DIRECT      = 1,
    INDEX8      = 2,
    INDEX16     = 3
};

enum ColorFormat : u8 {
    RGB565   = 0, // 16b
    RGB888   = 1, // 24b
    RGB888X  = 2, // 32b
    RGBA4444 = 3, // 16b
    RGBA6666 = 4, // 24b
    RGBA8888 = 5  // 32b
};

enum CPArray : u8 {
    POSITION   = 0,
    NORMAL     = 1,

    COLOR0     = 2,
    COLOR1     = 3,

    TEX_COORD0 = 4,
    TEX_COORD1 = 5,
    TEX_COORD2 = 6,
    TEX_COORD3 = 7,
    TEX_COORD4 = 8,
    TEX_COORD5 = 9,
    TEX_COORD6 = 10,
    TEX_COORD7 = 11,

    XF_A       = 12, // Usually used for position matrices
    XF_B       = 13, // Usually used for normal matrices
    XF_C       = 14, // Usually used for tex coord matrices
    XF_D       = 15  // Usually used for light objects
};

enum CoordComponentCount : u8 {
    XY  = 0,
    XYZ = 1
};

enum NormalComponentCount : u8 {
    N   = 0,
    NTB = 1
};

enum ColorComponentCount : u8 {
    RGB  = 0,
    RGBA = 1
};

enum TexComponentCount : u8 {
    S  = 0,
    ST = 1
};

bitfield UVATGroup0 {
    bool normalIndex3                         : 1;
    bool byteDequant                          : 1;

    tex0Frac                                  : 5;
    ComponentFormat tex0CoordFormat           : 3;
    TexComponentCount tex0CoordElements       : 1;

    ColorFormat color1Comp                    : 3;
    ColorComponentCount color1Elements        : 1;

    ColorFormat color0Comp                    : 3;
    ColorComponentCount color0Elements        : 1;

    ComponentFormat normalFormat              : 3;
    NormalComponentCount normalComponentCount : 1;

    posFrac                                   : 5;
    ComponentFormat posFormat                 : 3;
    CoordComponentCount posElements           : 1;
};

VertexComponentFormat gIType1 = 0;
VertexComponentFormat gIType2 = 0;
VertexComponentFormat gIType3 = 0;
VertexComponentFormat gIType4 = 0;
u8 gGcMeshType = 0;
u32 gGcPositionCount = 0;
u32 gGcNormalCount = 0;
u32 gGcColorCount = 0;
u32 gGcTexCoordCount = 0;
ComponentFormat gGcArrayFormat = 0;
u8 gGcArrayStride = 0;
u32 gSkinnedColorOffset = 0;
u32 gSkinnedColorCount = 0;
u32 gSkinnedTexCoordOffset = 0;
u32 gSkinnedTexCoordCount = 0;
ComponentFormat gSkinnedTexCoordFormat = 0;
u8 gSkinnedTexCoordStride = 0;

struct GCPoly { // 0x98=ストリップ、0x90=リスト。頂点は位置・法線・カラー・UVの各インデックスを持つ。
    match (gIType1) {
        (VertexComponentFormat::INDEX8): u8 vertIdx;
        (VertexComponentFormat::INDEX16): u16 vertIdx;
    }
    match (gIType2) {
        (VertexComponentFormat::INDEX8): u8 normalIdx;
        (VertexComponentFormat::INDEX16): u16 normalIdx;
    }
    match (gIType3) {
        (VertexComponentFormat::INDEX8): u8 clrIdx;
        (VertexComponentFormat::INDEX16): u16 clrIdx;
    }
    match (gIType4) {
        (VertexComponentFormat::INDEX8): u8 uvIdx;
        (VertexComponentFormat::INDEX16): u16 uvIdx;
    }
    if (gIType1 == VertexComponentFormat::INDEX8 || gIType1 == VertexComponentFormat::INDEX16) {
        if (vertIdx >= gGcPositionCount) {
            gGcPositionCount = vertIdx + 1;
        }
    }
    if (gIType2 == VertexComponentFormat::INDEX8 || gIType2 == VertexComponentFormat::INDEX16) {
        if (normalIdx >= gGcNormalCount) {
            gGcNormalCount = normalIdx + 1;
        }
    }
    if (gIType3 == VertexComponentFormat::INDEX8 || gIType3 == VertexComponentFormat::INDEX16) {
        if (clrIdx >= gGcColorCount) {
            gGcColorCount = clrIdx + 1;
        }
    }
    if (gIType4 == VertexComponentFormat::INDEX8 || gIType4 == VertexComponentFormat::INDEX16) {
        if (uvIdx >= gGcTexCoordCount) {
            gGcTexCoordCount = uvIdx + 1;
        }
    }
};

struct GCArrayEntry {
    match (gGcArrayFormat) {
        (ComponentFormat::UBYTE): u8 components[gGcArrayStride];
        (ComponentFormat::BYTE): s8 components[gGcArrayStride];
        (ComponentFormat::USHORT): u16 components[gGcArrayStride / 2];
        (ComponentFormat::SHORT): s16 components[gGcArrayStride / 2];
        (_): float components[gGcArrayStride / 4];
    }
};

struct GCIndc {
    if (gGcMeshType == 2) {
        u8 extra;
    }
    u8 state;
    if (state > 0) {
        u16 indexCount;
        GCPoly polys[indexCount];
    }
};

struct GCDisplayListCopyHeader {
    u16 triangleCount;
    u16 vertexSize;
    u32 verticesOffset;
    u32 copyVerticesOffset;
    padding[20];
};

struct LayerObjectEntryGC {
    u8 meshType; // These unk are consistent with skinned/static meshes
    gGcMeshType = meshType;
    u8 posStride;
    ComponentFormat positionFormat;
    u8 posFraction;

    u8 normalStride;
    ComponentFormat normalFormat;
    u8 normalFraction;

    u8 uvStride;
    ComponentFormat uvFormat;
    u8 uvFraction;

    VertexComponentFormat indiceType1;
    VertexComponentFormat indiceType2;
    VertexComponentFormat indiceType3;
    VertexComponentFormat indiceType4;
    gIType1 = indiceType1;
    gIType2 = indiceType2;
    gIType3 = indiceType3;
    gIType4 = indiceType4;
    u16 faceCount;
    u32 matrixOffset;
    u32 materialOffset;
    u32 position1Offset; //Vertex Buffer1
    u32 position2Offset; //Vertex Buffer2
    u32 normal1Offset;   //Normal Buffer1
    u32 normal2Offset;   //Normal Buffer2
    u32 colorOffset;
    u32 texCoordOffset;
    u32 faceOffset;
    if (gMdlVersion >= 3) {
        u32 boundingOffset;
    }
    u32 bufferAlloc = faceCount * 32;
    u32 endAddress = faceOffset + bufferAlloc;
    std::mem::Section mySection = std::mem::create_section("GC Indexes");
    gGcPositionCount = 0;
    gGcNormalCount = 0;
    gGcColorCount = 0;
    gGcTexCoordCount = 0;
    GCIndc mesh[while ($ < endAddress && std::mem::read_unsigned($ + (gGcMeshType == 2 ? 1 : 0), 1) != 0)] @ faceOffset;
    if (gGcMeshType == 2) {
        GCDisplayListCopyHeader copyHeader @ faceOffset - 32;
        u32 copyEndAddress = endAddress + bufferAlloc;
        GCIndc meshCopy[while ($ < copyEndAddress && std::mem::read_unsigned($ + 1, 1) != 0)] @ endAddress;
    }
    if (position2Offset > 0) {
        if (colorOffset > 0) {
            gSkinnedColorOffset = colorOffset;
            if (gGcColorCount > gSkinnedColorCount) {
                gSkinnedColorCount = gGcColorCount;
            }
        }
        if (texCoordOffset > 0) {
            gSkinnedTexCoordOffset = texCoordOffset;
            gSkinnedTexCoordFormat = uvFormat;
            gSkinnedTexCoordStride = uvStride;
            if (gGcTexCoordCount > gSkinnedTexCoordCount) {
                gSkinnedTexCoordCount = gGcTexCoordCount;
            }
        }
    } else {
        if (position1Offset > 0) {
            gGcArrayFormat = positionFormat;
            gGcArrayStride = posStride;
            GCArrayEntry positions[gGcPositionCount] @ position1Offset;
        }
        if (normal1Offset > 0) {
            gGcArrayFormat = normalFormat;
            gGcArrayStride = normalStride;
            GCArrayEntry normals[gGcNormalCount] @ normal1Offset;
        }
        if (colorOffset > 0) {
            VectorColorb vertexColor[gGcColorCount] @ colorOffset;
        }
        if (texCoordOffset > 0) {
            gGcArrayFormat = uvFormat;
            gGcArrayStride = uvStride;
            GCArrayEntry texCoords[gGcTexCoordCount] @ texCoordOffset;
        }
    }
    if (gMdlVersion >= 3) {
        if (boundingOffset > 0) {
            Vector4f centerRadius @ boundingOffset;
        }
    }
};

u8 gLastStat = 0;

struct WeightDef {
    s16 position[3]; // positions relative to assigned bone &
    s16 boneWeight; // # / 8192
    s16 normal[3];  // # / 16384
    u8 intcre;
    u8 boneIdx;
    gLastStat = intcre;
};

u32 gLongRow = 4;

struct WeightRowLong { // 4本影響枠ではstat==1によりレコード数が累積拡張される。
    WeightDef defs[gLongRow];
    gLongRow = gLongRow + gLastStat;
};

struct WeightBuffer { // Flat with dynamic sizing 1,2,3,4,5,6, .......
    WeightDef relativePositionNormal1[parent.vertCount1];
    WeightDef relativePositionNormal2[parent.vertCount2 * 2];
    WeightDef relativePositionNormal3[parent.vertCount3 * 3];
    WeightRowLong relativePositionNormal4[parent.vertCount4];
    WeightDef end;
};

struct WeightTable {
    u32 vertCount1;         // number of vertices with 1 bone weight per vertex bone_id1
    u32 vertCount2;         // number of vertices with 2 bone weight per vertex bone_id2
    u32 vertCount3;         // number of vertices with 3 bone weight per vertex bone_id3
    u32 vertCount4;         // number of vertices with 4 or more bone weight per vertex bone_id4
    u32 weightBufferOffset; // weight buffer, also contains vertices and Normals
    u32 vertFrame1Offset;   // Vertex Buffer
    u32 vertFrame2Offset;   // Vertex Buffer2
    u32 normalFrame1Offset;
    u32 normalFrame2Offset;
    gLongRow = 4;
    WeightBuffer weightBuffer @ weightBufferOffset;
    u32 totalVertCount = vertCount1 + vertCount2 + vertCount3 + vertCount4;
    if (vertFrame1Offset > 0) {
        Vector4f vertFrame1[totalVertCount] @ vertFrame1Offset;
    }
    if (vertFrame2Offset > 0) {
        Vector4f vertFrame2[totalVertCount] @ vertFrame2Offset;
    }
    if (normalFrame1Offset > 0) {
        Vector4f normalFrame1[totalVertCount] @ normalFrame1Offset;
    }
    if (normalFrame2Offset > 0) {
        Vector4f normalFrame2[totalVertCount] @ normalFrame2Offset;
    }
};

struct WeightSection {
    if (gMdlWeightTables > 0) {
        WeightTable weightTable;
    }
};

struct SkinnedVertexArraysGC {
    if (gSkinnedColorOffset > 0) {
        VectorColorb vertexColor[gSkinnedColorCount] @ gSkinnedColorOffset;
    }
    if (gSkinnedTexCoordOffset > 0) {
        gGcArrayFormat = gSkinnedTexCoordFormat;
        gGcArrayStride = gSkinnedTexCoordStride;
        GCArrayEntry texCoord[gSkinnedTexCoordCount] @ gSkinnedTexCoordOffset;
    }
};

struct BoneHeader {
    u8 day;
    u8 month;
    u16 year;
    u8 second;
    u8 minute;
    u8 hour;
    u8 pad;
    char author[32];
};

MdlHeader gHeader @ 0;
u32 gTextureMapEnd @ gHeader.uknMatrixTableOffset - 4;
MatrixUnk gUnkMtx @ gHeader.uknMatrixTableOffset;
StageBuffers gStageBuffers @ gHeader.matrixTableOffset - 16;
MatrixTable gMatrixTable[gHeader.matricesCount] @ gHeader.matrixTableOffset;
VGT gVgt @ gHeader.textureTableOffset;
MaterialTable gMaterials[gHeader.materialsCount] @ gHeader.materialOffset;
BoneInfo gBones[gHeader.bonesCount] @ gHeader.boneOffset;

LayerObjectEntryGC gObject1Gc[gHeader.objects1Count] @ gHeader.object1Offset;
LayerObjectEntryGC gObject2Gc[gHeader.objects2Count] @ gHeader.object2Offset;
LayerObjectEntryGC gObject3Gc[gHeader.objects3Count] @ gHeader.object3Offset;
SkinnedVertexArraysGC gSkinnedVertexArraysGc @ gSkinnedColorOffset;

WeightSection gWeights @ gHeader.weightTableOffset;

BoneHeader gBoneHeader @ gHeader.boneHeaderOffset;
