#pragma endian little

import std.io;

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
    UNKMT0   = 0,
    STAGEMTX = 1,
    BONEMTX  = 2
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

enum MeshXboxContent : u16 {
    STATICXBOX  = 0,
    SKINNEDXBOX = 4
};

enum PrimativeXbox : u16 {
    TRIANGLESTRIP = 0,
    TRIANGLELIST  = 1
};

enum ImageTypeXBOX : u32 {
    // Xbox D3DFORMAT types :
    // See https://wiki.beyondunreal.com/Legacy:Texture_Format

    // Swizzled Formats

    D3DFMT_L8           = 0x00,
    D3DFMT_AL8          = 0x01,
    D3DFMT_A1R5G5B5     = 0x02,
    D3DFMT_X1R5G5B5     = 0x03,
    D3DFMT_A4R4G4B4     = 0x04,
    D3DFMT_R5G6B5       = 0x05,
    D3DFMT_A8R8G8B8     = 0x06,
    D3DFMT_X8R8G8B8     = 0x07,
    D3DFMT_X8L8V8U8     = 0x07, // Alias

    D3DFMT_P8           = 0x0B, // 8-bit Palletized

    D3DFMT_A8           = 0x19,
    D3DFMT_A8L8         = 0x1A,
    D3DFMT_R6G5B5       = 0x27,
    D3DFMT_L6V5U5       = 0x27, // Alias

    D3DFMT_G8B8         = 0x28,
    D3DFMT_V8U8         = 0x28, // Alias

    D3DFMT_R8B8         = 0x29,
    D3DFMT_D24S8        = 0x2A,
    D3DFMT_F24S8        = 0x2B,
    D3DFMT_D16          = 0x2C,
    D3DFMT_D16_LOCKABLE = 0x2C, // Alias

    D3DFMT_F16          = 0x2D,
    D3DFMT_L16          = 0x32,
    D3DFMT_V16U16       = 0x33,
    D3DFMT_R5G5B5A1     = 0x38,
    D3DFMT_R4G4B4A4     = 0x39,
    D3DFMT_A8B8G8R8     = 0x3A,
    D3DFMT_Q8W8V8U8     = 0x3A, // Alias

    D3DFMT_B8G8R8A8     = 0x3B,
    D3DFMT_R8G8B8A8     = 0x3C,

    // YUV Formats

    D3DFMT_YUY2         = 0x24,
    D3DFMT_UYVY         = 0x25,

    // Compressed Formats

    D3DFMT_DXT1         = 0x0C, // opaque/one-bit alpha
    D3DFMT_DXT2         = 0x0E, // Alias for D3DFMT_DXT3
    D3DFMT_DXT3         = 0x0E, // linear alpha
    D3DFMT_DXT4         = 0x0F, // Alias for D3DFMT_DXT5
    D3DFMT_DXT5         = 0x0F, // interpolated alpha

    // Linear Formats

    D3DFMT_LIN_A1R5G5B5 = 0x10,
    D3DFMT_LIN_R5G6B5   = 0x11,
    D3DFMT_LIN_A8R8G8B8 = 0x12,
    D3DFMT_LIN_L8       = 0x13,
    D3DFMT_LIN_R8B8     = 0x16,
    D3DFMT_LIN_G8B8     = 0x17,
    D3DFMT_LIN_V8U8     = 0x17, // Alias

    D3DFMT_LIN_AL8      = 0x1B,
    D3DFMT_LIN_X1R5G5B5 = 0x1C,
    D3DFMT_LIN_A4R4G4B4 = 0x1D,
    D3DFMT_LIN_X8R8G8B8 = 0x1E,
    D3DFMT_LIN_X8L8V8U8 = 0x1E, // Alias

    D3DFMT_LIN_A8       = 0x1F,
    D3DFMT_LIN_A8L8     = 0x20,
    D3DFMT_LIN_D24S8    = 0x2E,
    D3DFMT_LIN_F24S8    = 0x2F,
    D3DFMT_LIN_D16      = 0x30,
    D3DFMT_LIN_F16      = 0x31,
    D3DFMT_LIN_L16      = 0x35,
    D3DFMT_LIN_V16U16   = 0x36,
    D3DFMT_LIN_R6G5B5   = 0x37,
    D3DFMT_LIN_L6V5U5   = 0x37, // Alias

    D3DFMT_LIN_R5G5B5A1 = 0x3D,
    D3DFMT_LIN_R4G4B4A4 = 0x3E,
    D3DFMT_LIN_A8B8G8R8 = 0x3F,
    D3DFMT_LIN_B8G8R8A8 = 0x40,
    D3DFMT_LIN_R8G8B8A8 = 0x41,

    D3DFMT_VERTEXDATA   = 0x64,

    D3DFMT_INDEX16      = 101
};

fn bits_per_pixel_xbox(ImageTypeXBOX type) {
    match (type) {
        (ImageTypeXBOX::D3DFMT_L8 | ImageTypeXBOX::D3DFMT_AL8 | ImageTypeXBOX::D3DFMT_P8 | ImageTypeXBOX::D3DFMT_A8): return 8;
        (ImageTypeXBOX::D3DFMT_LIN_L8 | ImageTypeXBOX::D3DFMT_LIN_AL8 | ImageTypeXBOX::D3DFMT_LIN_A8): return 8;
        (ImageTypeXBOX::D3DFMT_A1R5G5B5 | ImageTypeXBOX::D3DFMT_X1R5G5B5 | ImageTypeXBOX::D3DFMT_A4R4G4B4 | ImageTypeXBOX::D3DFMT_R5G6B5 | ImageTypeXBOX::D3DFMT_R5G5B5A1 | ImageTypeXBOX::D3DFMT_R4G4B4A4): return 16;
        (ImageTypeXBOX::D3DFMT_A8L8 | ImageTypeXBOX::D3DFMT_R6G5B5 | ImageTypeXBOX::D3DFMT_G8B8 | ImageTypeXBOX::D3DFMT_R8B8 | ImageTypeXBOX::D3DFMT_D16 | ImageTypeXBOX::D3DFMT_F16 | ImageTypeXBOX::D3DFMT_L16 | ImageTypeXBOX::D3DFMT_YUY2 | ImageTypeXBOX::D3DFMT_UYVY): return 16;
        (ImageTypeXBOX::D3DFMT_LIN_A1R5G5B5 | ImageTypeXBOX::D3DFMT_LIN_X1R5G5B5 | ImageTypeXBOX::D3DFMT_LIN_A4R4G4B4 | ImageTypeXBOX::D3DFMT_LIN_R5G6B5 | ImageTypeXBOX::D3DFMT_LIN_R5G5B5A1 | ImageTypeXBOX::D3DFMT_LIN_R4G4B4A4): return 16;
        (ImageTypeXBOX::D3DFMT_LIN_A8L8 | ImageTypeXBOX::D3DFMT_LIN_R6G5B5 | ImageTypeXBOX::D3DFMT_LIN_G8B8 | ImageTypeXBOX::D3DFMT_LIN_R8B8 | ImageTypeXBOX::D3DFMT_LIN_D16 | ImageTypeXBOX::D3DFMT_LIN_F16 | ImageTypeXBOX::D3DFMT_LIN_L16): return 16;
        (ImageTypeXBOX::D3DFMT_A8R8G8B8 | ImageTypeXBOX::D3DFMT_X8R8G8B8 | ImageTypeXBOX::D3DFMT_A8B8G8R8 | ImageTypeXBOX::D3DFMT_B8G8R8A8 | ImageTypeXBOX::D3DFMT_R8G8B8A8 | ImageTypeXBOX::D3DFMT_D24S8 | ImageTypeXBOX::D3DFMT_F24S8 | ImageTypeXBOX::D3DFMT_V16U16): return 32;
        (ImageTypeXBOX::D3DFMT_LIN_A8R8G8B8 | ImageTypeXBOX::D3DFMT_LIN_X8R8G8B8 | ImageTypeXBOX::D3DFMT_LIN_A8B8G8R8 | ImageTypeXBOX::D3DFMT_LIN_B8G8R8A8 | ImageTypeXBOX::D3DFMT_LIN_R8G8B8A8 | ImageTypeXBOX::D3DFMT_LIN_D24S8 | ImageTypeXBOX::D3DFMT_LIN_F24S8 | ImageTypeXBOX::D3DFMT_LIN_V16U16): return 32;
        (_): return 0;
    }
};

fn bytes_per_block_xbox(ImageTypeXBOX type) {
    match (type) {
        (ImageTypeXBOX::D3DFMT_DXT1): return 8;
        (ImageTypeXBOX::D3DFMT_DXT3 | ImageTypeXBOX::D3DFMT_DXT5): return 16;
        (_): return 0;
    }
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

bitfield FmtTXVFlag {
    BIT01    : 1;
    CLAMP    : 1;
    BIT03    : 1;
    BIT04    : 1;
    TWOSIDED : 1;
    BIT06    : 1;
    BIT07    : 1;
    BIT08    : 1;
    SPEC     : 1;
    BIT10    : 1;
    BIT11    : 1;
    BIT12    : 1;
    BIT13    : 1;
    BIT14    : 1;
    padd     : 2;
    pad2     : 16;
};

struct Vector4b {
    u8 x;
    u8 y;
    u8 z;
    u8 w;
} [[static, name(std::format("{}{}{}{}", x, y, z, w))]];

struct VectorColorb {
    u8 b [[color("0000FF")]];
    u8 g [[color("00FF00")]];
    u8 r [[color("FF0000")]];
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

struct MatrixUnk { // data Present in stage files? boundaries?
    u16 unk1;
    u16 matrix2Count;
    u32 matrix2Offset; // if count is 0, then this will point to the material block
};

struct MatrixTable {
    MatrixType type;
    u8 parentBoneIdx; // parent object to this bone?
    u16 ukn1;
    u32 ukn3; // on stages files an offset is present
    u32 ukn4;
    u32 ukn5;
    Vector4f matrix4x4Transform[4];
    padding[320]; //64 more than gamecube
};

u8 gMdlVersion = 0;
u16 gMdlWeightTables = 0;

struct MdlHeader {
    char magic[4];
    u8 version; // 0x02=Xbox?, 0x03=Gamecube, 0x04=Xbox
    gMdlVersion = version;
    u8 textureOffsetPoint;
    u8 textureCount;
    u8 isLoaded;
    u8 unk;
    ModelContent contents;
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
    u32 ukn01Offset;
    u32 boneOffset;
    u32 boneNameOffset;
    u32 boneHeaderOffset;
};

fn mip_level_byte_count_xbox(ImageTypeXBOX type, u32 mipWidth, u32 mipHeight) {
    if (bytes_per_block_xbox(type) != 0) {
        u32 blocksAcross = (mipWidth + 3) / 4;
        u32 blocksDown = (mipHeight + 3) / 4;
        return blocksAcross * blocksDown * bytes_per_block_xbox(type);
    }
    return mipWidth * mipHeight * bits_per_pixel_xbox(type) / 8;
};

fn half_but_at_least_one(u32 size) {
    if (size <= 1) {
        return 1;
    }
    return size / 2;
};

fn texture_byte_count_xbox(ImageTypeXBOX type, u32 width, u32 height, u32 mipMapCount) {
    u32 mipWidth = width;
    u32 mipHeight = height;
    u32 byteCount = 0;
    u32 mipLevel = 0;
    while (mipLevel < mipMapCount || mipLevel == 0) {
        byteCount = byteCount + mip_level_byte_count_xbox(type, mipWidth, mipHeight);
        mipWidth = half_but_at_least_one(mipWidth);
        mipHeight = half_but_at_least_one(mipHeight);
        mipLevel = mipLevel + 1;
    }
    return byteCount;
};

u32 gPalletCount = 0;
u32 gVxtOffset = 0;
u8 gVxtType = 2;

struct TexturePalRow {
    u32 paletteOffset;
    u32 paletteCount;
    u32 padd;
    VectorColorb pallet[paletteCount] @ paletteOffset + gVxtOffset;
};

struct TextureDataTypeXbox2 {
    u32 texturePaletteOffset;
    FmtTXVFlag flags;
    u32 unk1;
    if (gVxtType == 2) { // rowType2=36B（dataOff@16）、rowType1=32B（dataOff@12）。
        u16 widthVisible;
        u16 heightVisible;
    }
    u32 dataOffset;
    ImageTypeXBOX imageType;
    u16 width;
    u16 height;
    u32 mipMapCount;
    u32 pad2;
    if (texturePaletteOffset) {
        gPalletCount += 1;
    }
    u8 data[texture_byte_count_xbox(imageType, width, height, mipMapCount)] @ gVxtOffset + dataOffset;
};

struct VXT {
    gVxtOffset = $;
    char magic[4];
    u8 type;
    gVxtType = type;
    u8 flag1;
    u8 flag2;
    padding[1];
    u32 textureCount;

    u32 headerLength;
    u32 headerBlockSize;

    TextureDataTypeXbox2 textureEntrys[textureCount];

    TexturePalRow pallets[gPalletCount];
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

struct TextureDataTypeXbox {
    u32 texturePaletteOffset; //TEXTURE PALETTE ROW OFFSET
    FmtTXVFlag flags;
    u32 unk1; //00000000
    if (vxtHeader.type == 2) {
        u16 heightVisible; //visible height
        u16 widthVisible;  //visible width
    }
    u32 clutOffset;          // color look up table, if DXT this is the image data addr
    ImageTypeXBOX imageType; //0C = DXT1; 0F=DXT5; 0B=INDEX_COLOR(p8);
    u16 height;              // dimension but in multiples of 8
    u16 width;               // dimension but in multiples of 8
    u32 mipMapCount;         // mip count range [1 - 6]
    padding[4];              // pad to align
};

struct MaterialTable {
    MaterialType type;
    u8 ukn1;
    u8 ukn2;
    MaterialTableCull cullMode; // 0x00=DrawnBothSides, 0x08=DrawnOneSide
    OpacitySrc opacitySrc;
    u32 vxtOffset1; // offsets within the VXT block
    u32 vxtOffset2;
    u32 vxtOffset3;
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

struct Buffer1 {
    VectorColorb colorRgba;
    Vector2f textureUv;
} [[static]];

struct Buffer2 {
    Vector4f positonXyzScale;
    Vector4f normalXyzScale;
} [[static]];

struct Buffer3 {
    Vector4f positonXyzScale;
    Vector4f normalXyzScale;
} [[static]];

struct Buffer4 {
    Vector3f positon;
    Vector3f normal;
    Buffer1 vertDef;
    u32 pad;
} [[static]];

u16 gVertCount = 0;

struct FaceIndex {
    u16 value; // ストリップ（0xFFFFで再開）またはリスト
    if (value != 0xFFFF && gVertCount < value) {
        gVertCount = value;
    }
};

struct LayerObjectEntryXbox {
    gVertCount = 0;
    MeshXboxContent objectType;  // 0x00=Static, 0x04=Skinned
    PrimativeXbox primitiveType; // 0x00=TriangleStrip, 0x01=TriangleList
    u32 faceCount;               // Number of Index in Index Buffer
    u32 matrixOffset;
    u32 materialOffset;
    u32 faceOffset;    // Index Buffer Offset
    u32 buffer1Offset; // for skinned and static meshes this is the vertex buffer
    u32 buffer2Offset;
    u32 buffer3Offset;
    u32 buffer4Offset;
    if (gMdlVersion >= 4) {
        u32 centerRadiusOffset; // "Aman" describes this section as "Center+Radius Offset"
    }

    FaceIndex skinnedMeshData[faceCount] @ faceOffset;
    gVertCount += 1;

    if (objectType == MeshXboxContent::STATICXBOX) {
        Buffer4 staticVerts[gVertCount] @ buffer1Offset;
        if (gMdlVersion >= 4) {
            if (centerRadiusOffset > 0) {
                Vector4f centerRadius @ centerRadiusOffset;
            }
        }
    } else if (objectType == MeshXboxContent::SKINNEDXBOX) {
        Buffer1 color[gVertCount] @ buffer1Offset;
        Buffer2 position[gVertCount] @ buffer2Offset;
        Buffer3 normal[gVertCount] @ buffer3Offset;
    }
};

u8 gLastStat = 0;

struct WeightDef {
    Vector3f positon; // positions relative to assigned bone
    float boneWeight;
    Vector3f normal;
    u8 boneIdx;
    u8 intcre;
    u8 unk1[2];
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
};

struct WeightTable {
    u32 vertCount1;         // number of vertices with 1 bone weight per vertex bone_id1
    u32 vertCount2;         // number of vertices with 2 bone weight per vertex bone_id2
    u32 vertCount3;         // number of vertices with 3 bone weight per vertex bone_id3
    u32 vertCount4;         // number of vertices with 4 or more bone weight per vertex bone_id4
    u32 weightBufferOffset; // weight buffer, also contains vertices and Normals
    u32 vertBuffer1Offset;  // Vertex Buffer
    u32 vertBuffer2Offset;  // Vertex Buffer2, redundant?
    gLongRow = 4;
    WeightBuffer weightBuffer @ weightBufferOffset;
};

struct WeightRowV2 {
    gLastStat = 0;
    WeightDef defs[while (gLastStat != 1)];
};

struct WeightTableV2 {
    u32 zero;
    u32 weightBufferOffset;
    u32 vertBuffer1Offset;
    u32 vertBuffer2Offset;
    u32 vertBuffer3Offset;
    WeightRowV2 weightBuffer[(vertBuffer2Offset - vertBuffer1Offset) / 32] @ weightBufferOffset;
};

struct WeightSection {
    if (gMdlWeightTables > 0) {
        if (gMdlVersion > 2) {
            WeightTable weightTable;
        } else {
            WeightTableV2 weightTable;
        }
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

MdlHeader gSc2Mdl @ 0;
MatrixTable gMatrixTbl[gSc2Mdl.matricesCount] @ gSc2Mdl.matrixTableOffset;
VXT gVxt @ gSc2Mdl.textureTableOffset;
MaterialTable gVxtMaterials[gSc2Mdl.materialsCount] @ gSc2Mdl.materialOffset;
BoneInfo gBoneData[gSc2Mdl.bonesCount] @ gSc2Mdl.boneOffset;
MatrixUnk gUnkMtx @ gSc2Mdl.uknMatrixTableOffset;

LayerObjectEntryXbox gObject1Xbox[gSc2Mdl.objects1Count] @ gSc2Mdl.object1Offset;
LayerObjectEntryXbox gObject2Xbox[gSc2Mdl.objects2Count] @ gSc2Mdl.object2Offset;
LayerObjectEntryXbox gObject3Xbox[gSc2Mdl.objects3Count] @ gSc2Mdl.object3Offset;
WeightSection gWeights @ gSc2Mdl.weightTableOffset;
BoneHeader gAuthor @ gSc2Mdl.boneHeaderOffset;
