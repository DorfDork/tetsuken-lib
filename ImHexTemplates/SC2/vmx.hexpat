enum console : u8 {
    UNK0     = 0,
    UNK1     = 1,
    UNK2     = 2,
    GAMECUBE = 3,
    XBOX     = 4
};

enum modelContent : u8 {
    STAGE     = 0,
    CHARACTER = 1,
    WEAPON    = 2
};

enum matrixType : u8 {
    UNKMT0    = 0,
    STAGEMTX  = 1,
    BONEMTX   = 2
};

enum materialType : u8 {
    UNLIT  = 0,
    PRELIT = 1,
    LIT    = 2
};

enum opacitySrc : u32 {
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

enum boneType : u8 {
    BODY     = 0,
    WEAPON   = 1,
    FINGER   = 2,
    FACE     = 3,
    ROT      = 4,
    PROT     = 5,
    AIM      = 7,
    SLERP    = 9,
    SWING    = 11, // Some silly stuff with GC (NO ENDIAN SWAPIN)
    SHIT     = 12,
    UNNAMED  = 14,
    RANDEYE  = 15,
    RANDLID  = 16
};

enum meshXboxContent : u16 {
    STATICXBOX  = 0,
    SKINNEDXBOX = 4
};

enum primativeXbox : u16 {
    TRIANGLESTRIP = 0,
    TRIANGLELIST  = 1
};

enum imageTypeXBOX : u32{
    // Xbox D3DFORMAT types :
    // See https://wiki.beyondunreal.com/Legacy:Texture_Format

    // Swizzled Formats

    D3DFMT_L8 = 0x00,
    D3DFMT_AL8 = 0x01,
    D3DFMT_A1R5G5B5 = 0x02,
    D3DFMT_X1R5G5B5 = 0x03,
    D3DFMT_A4R4G4B4 = 0x04,
    D3DFMT_R5G6B5 = 0x05,
    D3DFMT_A8R8G8B8 = 0x06,
    D3DFMT_X8R8G8B8 = 0x07,
    D3DFMT_X8L8V8U8 = 0x07, // Alias

    D3DFMT_P8 = 0x0b, // 8-bit Palletized

    D3DFMT_A8 = 0x19,
    D3DFMT_A8L8 = 0x1a,
    D3DFMT_R6G5B5 = 0x27,
    D3DFMT_L6V5U5 = 0x27, // Alias

    D3DFMT_G8B8 = 0x28,
    D3DFMT_V8U8 = 0x28, // Alias

    D3DFMT_R8B8 = 0x29,
    D3DFMT_D24S8 = 0x2a,
    D3DFMT_F24S8 = 0x2b,
    D3DFMT_D16 = 0x2c,
    D3DFMT_D16_LOCKABLE = 0x2c, // Alias

    D3DFMT_F16 = 0x2d,
    D3DFMT_L16 = 0x32,
    D3DFMT_V16U16 = 0x33,
    D3DFMT_R5G5B5A1 = 0x38,
    D3DFMT_R4G4B4A4 = 0x39,
    D3DFMT_A8B8G8R8 = 0x3A,
    D3DFMT_Q8W8V8U8 = 0x3A, // Alias

    D3DFMT_B8G8R8A8 = 0x3B,
    D3DFMT_R8G8B8A8 = 0x3C,

    // YUV Formats

    D3DFMT_YUY2 = 0x24,
    D3DFMT_UYVY = 0x25,

    // Compressed Formats

    D3DFMT_DXT1 = 0x0C, // opaque/one-bit alpha
    D3DFMT_DXT2 = 0x0E, // Alias for D3DFMT_DXT3
    D3DFMT_DXT3 = 0x0E, // linear alpha
    D3DFMT_DXT4 = 0x0F, // Alias for D3DFMT_DXT5
    D3DFMT_DXT5 = 0x0F, // interpolated alpha

    // Linear Formats

    D3DFMT_LIN_A1R5G5B5 = 0x10,
    D3DFMT_LIN_R5G6B5 = 0x11,
    D3DFMT_LIN_A8R8G8B8 = 0x12,
    D3DFMT_LIN_L8 = 0x13,
    D3DFMT_LIN_R8B8 = 0x16,
    D3DFMT_LIN_G8B8 = 0x17,
    D3DFMT_LIN_V8U8 = 0x17, // Alias

    D3DFMT_LIN_AL8 = 0x1b,
    D3DFMT_LIN_X1R5G5B5 = 0x1c,
    D3DFMT_LIN_A4R4G4B4 = 0x1d,
    D3DFMT_LIN_X8R8G8B8 = 0x1e,
    D3DFMT_LIN_X8L8V8U8 = 0x1e, // Alias

    D3DFMT_LIN_A8 = 0x1f,
    D3DFMT_LIN_A8L8 = 0x20,
    D3DFMT_LIN_D24S8 = 0x2E,
    D3DFMT_LIN_F24S8 = 0x2f,
    D3DFMT_LIN_D16 = 0x30,
    D3DFMT_LIN_F16 = 0x31,
    D3DFMT_LIN_L16 = 0x35,
    D3DFMT_LIN_V16U16 = 0x36,
    D3DFMT_LIN_R6G5B5 = 0x37,
    D3DFMT_LIN_L6V5U5 = 0x37, // Alias

    D3DFMT_LIN_R5G5B5A1 = 0x3D,
    D3DFMT_LIN_R4G4B4A4 = 0x3e,
    D3DFMT_LIN_A8B8G8R8 = 0x3f,
    D3DFMT_LIN_B8G8R8A8 = 0x40,
    D3DFMT_LIN_R8G8B8A8 = 0x41,

    D3DFMT_VERTEXDATA = 0x64,

    D3DFMT_INDEX16 = 101,
};

fn bitsPerPixelXbox(imageTypeXBOX type){
    match(type){
        (imageTypeXBOX::D3DFMT_L8 | imageTypeXBOX::D3DFMT_AL8 | imageTypeXBOX::D3DFMT_P8 | imageTypeXBOX::D3DFMT_A8): return 8;
        (imageTypeXBOX::D3DFMT_LIN_L8 | imageTypeXBOX::D3DFMT_LIN_AL8 | imageTypeXBOX::D3DFMT_LIN_A8): return 8;
        (imageTypeXBOX::D3DFMT_A1R5G5B5 | imageTypeXBOX::D3DFMT_X1R5G5B5 | imageTypeXBOX::D3DFMT_A4R4G4B4 | imageTypeXBOX::D3DFMT_R5G6B5 | imageTypeXBOX::D3DFMT_R5G5B5A1 | imageTypeXBOX::D3DFMT_R4G4B4A4): return 16;
        (imageTypeXBOX::D3DFMT_A8L8 | imageTypeXBOX::D3DFMT_R6G5B5 | imageTypeXBOX::D3DFMT_G8B8 | imageTypeXBOX::D3DFMT_R8B8 | imageTypeXBOX::D3DFMT_D16 | imageTypeXBOX::D3DFMT_F16 | imageTypeXBOX::D3DFMT_L16 | imageTypeXBOX::D3DFMT_YUY2 | imageTypeXBOX::D3DFMT_UYVY): return 16;
        (imageTypeXBOX::D3DFMT_LIN_A1R5G5B5 | imageTypeXBOX::D3DFMT_LIN_X1R5G5B5 | imageTypeXBOX::D3DFMT_LIN_A4R4G4B4 | imageTypeXBOX::D3DFMT_LIN_R5G6B5 | imageTypeXBOX::D3DFMT_LIN_R5G5B5A1 | imageTypeXBOX::D3DFMT_LIN_R4G4B4A4): return 16;
        (imageTypeXBOX::D3DFMT_LIN_A8L8 | imageTypeXBOX::D3DFMT_LIN_R6G5B5 | imageTypeXBOX::D3DFMT_LIN_G8B8 | imageTypeXBOX::D3DFMT_LIN_R8B8 | imageTypeXBOX::D3DFMT_LIN_D16 | imageTypeXBOX::D3DFMT_LIN_F16 | imageTypeXBOX::D3DFMT_LIN_L16): return 16;
        (imageTypeXBOX::D3DFMT_A8R8G8B8 | imageTypeXBOX::D3DFMT_X8R8G8B8 | imageTypeXBOX::D3DFMT_A8B8G8R8 | imageTypeXBOX::D3DFMT_B8G8R8A8 | imageTypeXBOX::D3DFMT_R8G8B8A8 | imageTypeXBOX::D3DFMT_D24S8 | imageTypeXBOX::D3DFMT_F24S8 | imageTypeXBOX::D3DFMT_V16U16): return 32;
        (imageTypeXBOX::D3DFMT_LIN_A8R8G8B8 | imageTypeXBOX::D3DFMT_LIN_X8R8G8B8 | imageTypeXBOX::D3DFMT_LIN_A8B8G8R8 | imageTypeXBOX::D3DFMT_LIN_B8G8R8A8 | imageTypeXBOX::D3DFMT_LIN_R8G8B8A8 | imageTypeXBOX::D3DFMT_LIN_D24S8 | imageTypeXBOX::D3DFMT_LIN_F24S8 | imageTypeXBOX::D3DFMT_LIN_V16U16): return 32;
        (_): return 0;
    }
};

fn bytesPerBlockXbox(imageTypeXBOX type){
    match(type){
        (imageTypeXBOX::D3DFMT_DXT1): return 8;
        (imageTypeXBOX::D3DFMT_DXT3 | imageTypeXBOX::D3DFMT_DXT5): return 16;
        (_): return 0;
    }
};

enum textureMapType : u16{
    UNKTT0   = 0,
    DIFFUSE  = 1,
    EFFECTS  = 2,
    ANIMATE  = 3,
    UNKTT    = 4,
    SPECBALL = 5
};

enum materialTableCull : u8{
    DRAWNBOTHSIDES = 0,
    DRAWNONESIDE   = 8,
    DRAWNBOTHSIDES_ALPHATEST = 0x10,
    DRAWNONESIDE_ALPHATEST   = 0x18,
    DRAWNBOTHSIDES_ALPHATEST_BIT20 = 0x30,
    DRAWNONESIDE_ALPHATEST_BIT20   = 0x38
};

bitfield fmtTXV_FLAG{
    BIT01   : 1;  
    CLAMP   : 1;  
    BIT03   : 1;  
    BIT04   : 1;  
    TWOSIDED: 1;  
    BIT06   : 1;  
    BIT07   : 1;  
    BIT08   : 1; 
    SPEC    : 1;  
    BIT10   : 1;
    BIT11   : 1;
    BIT12   : 1;
    BIT13   : 1;
    BIT14   : 1;
    padd    : 2;
    pad2    :16;
};

struct tVector4b{
    u8 X;
    u8 Y;
    u8 Z;
    u8 W;
}[[static,name(std::format("{}{}{}{}", X, Y, Z, W))]];

struct tVectorColorb {
  u8 B  [[color("0000FF")]];
  u8 G [[color("00FF00")]];
  u8 R   [[color("FF0000")]];
  u8 A;
} [[static, color(std::format("{:02X}{:02X}{:02X}", R, G, B))]];

struct tFace{
    u16 X;
    u16 Y;
    u16 Z;
}[[static,name(std::format("{}{}{}", X, Y, Z))]];

struct tVectorUVf{
    float X;
}[[static,name(std::format("{},{}", X, ((X * -1)+1)))]];

struct tVector2f{
    float X;
    float Y;
}[[static,name(std::format("{},{}", X, Y))]];

struct tVector3f{
    float X;
    float Y;
    float Z;
}[[static,name(std::format("{},{},{}", X, Y,Z))]];

struct tVector4f{
    float X;
    float Y;
    float Z;
    float W;
}[[static,name(std::format("{},{},{},{}", X, Y, Z, W))]];
struct matrixUnk{ // data Present in stage files? boundaries?
    u16 Unk1;
    u16 Matrix2Count;
    u32 Matrix2Offset; // if count is 0, then this will point to the material block
}
;
struct matrixTable{
    matrixType Type;
    u8 ParentBoneIdx; // parent object to this bone?
    u16 Ukn1;
    u32 Ukn3; // on stages files an offset is present
    u32 Ukn4;
    u32 Ukn5;
    tVector4f Matrix4x4Transform[4];
    padding[320]; //64 more than gamecube
};

#pragma endian little

import std.io;

u8 mdlVersion = 0;
u16 mdlWeightTables = 0;

struct mdl_header{
    char MAGIC[4];
    u8 Version; // 0x02=Xbox?, 0x03=Gamecube, 0x04=Xbox
    mdlVersion = Version;
    u8 textureOffsetPoint;
    u8 textureCount;
    u8 isLoaded;
    u8 unk;
    modelContent Contents;
    u16 MatricesCount;
    u16 Objects0Count;
    u16 Objects1Count;
    u16 Objects2Count;
    u16 BonesCount;
    u16 MaterialsCount;
    u16 WeightTableCount; // always 1?
    mdlWeightTables = WeightTableCount;
    u32 TextureTableOffset;
    u32 MaterialOffset;
    u32 TextureMapOffset;
    u32 MatrixTableOffset;
    u32 ukn_MatrixTableOffset;
    u32 Object0Offset;
    u32 Object1Offset;
    u32 Object2Offset;
    u32 WeightTableOffset;
    u32 ukn01_offset;
    u32 BoneOffset;
    u32 BoneNameOffset;
    u32 BoneHeaderOffset;
};

fn mipLevelByteCountXbox(imageTypeXBOX type, u32 mipWidth, u32 mipHeight){
    if(bytesPerBlockXbox(type) != 0){
        u32 blocksAcross = (mipWidth + 3) / 4;
        u32 blocksDown = (mipHeight + 3) / 4;
        return blocksAcross * blocksDown * bytesPerBlockXbox(type);
    }
    return mipWidth * mipHeight * bitsPerPixelXbox(type) / 8;
};

fn halfButAtLeastOne(u32 size){
    if(size <= 1){
        return 1;
    }
    return size / 2;
};

fn textureByteCountXbox(imageTypeXBOX type, u32 width, u32 height, u32 mipMapCount){
    u32 mipWidth = width;
    u32 mipHeight = height;
    u32 byteCount = 0;
    u32 mipLevel = 0;
    while(mipLevel < mipMapCount || mipLevel == 0){
        byteCount = byteCount + mipLevelByteCountXbox(type, mipWidth, mipHeight);
        mipWidth = halfButAtLeastOne(mipWidth);
        mipHeight = halfButAtLeastOne(mipHeight);
        mipLevel = mipLevel + 1;
    }
    return byteCount;
};

u32 PalletCount = 0;
u32 vxt_offset = 0;
u8 vxt_type = 2;
struct texturePalRow{
u32 PaletteOffset;
u32 PaletteCount;
u32 Padd;
tVectorColorb Pallet[PaletteCount] @ PaletteOffset + vxt_offset;
};

struct textureDataTypeXbox2{
u32 TexturePaletteOffset;
fmtTXV_FLAG flags;
u32 Unk1;
if(vxt_type == 2){ // rowType2=36B（dataOff@16）、rowType1=32B（dataOff@12）。
    u16 WidthVisible;
u16 HeightVisible;
}
u32 DataOffset;
imageTypeXBOX ImageType;
u16 Width;
u16 Height;
u32 MipMapCount;
u32 Pad2;
if(TexturePaletteOffset){
PalletCount +=1;
}
u8 data[textureByteCountXbox(ImageType, Width, Height, MipMapCount)] @ vxt_offset + DataOffset;
};

struct VXT{
vxt_offset = $;
char MAGIC[4];
u8 type;
vxt_type = type;
u8 flag0;
u8 flag1;
padding[1];
u32 TextureCount;

u32 HeaderLength;
u32 HeaderBlockSize;

textureDataTypeXbox2 TextureEntrys[TextureCount];


texturePalRow pallets[PalletCount];

};

struct textureMap{
    textureMapType Type; // 0x01=Diffuse, 0x02=Effects, 0x03=Animating, 0x04=?, 0x05=SpecBall 
    u16 Size; // size of entry?
    if (Size != -1 && Size > 4) {
        if (Type == 1 && Size == 36) {
            tVector2f TileUV;
            float Values[6];
        }
        else {
            float Values[(Size - 4) / 4];
        }
    }
}
;

 struct textureDataTypeXbox {
    u32 TexturePaletteOffset; //TEXTURE PALETTE ROW OFFSET
    fmtTXV_FLAG flags;
    u32 Unk1; //00000000
    if (vxt_header.Type == 2) {
        u16 HeightVisible; //visible height
        u16 WidthVisible; //visible width
    }
    u32 CLUTOffset; // color look up table, if DXT this is the image data addr
    imageTypeXBOX ImageType; //0C = DXT1; 0F=DXT5; 0B=INDEX_COLOR(p8);
    u16 Height; // dimension but in multiples of 8
    u16 Width; // dimension but in multiples of 8
    u32 MipMapCount; // mip count range [1 - 6]
    padding[4] ; // pad to align
}
;


struct materialTable{
    materialType Type;
    u8 ukn1;
    u8 ukn2;
    materialTableCull CullMode; // 0x00=DrawnBothSides, 0x08=DrawnOneSide
    opacitySrc OpacitySrc;
    u32 VXTOffset0; // offsets within the VXT block
    u32 VXTOffset1;
    u32 VXTOffset2;
    u32 Map0Offset; //offsets to the texture table entries
    u32 Map1Offset;
    u32 Map2Offset;
    tVector4f AmbientRGBA;
    tVector4f DiffuseRGBA;
    tVector4f SpecularRGBA;
    if (Map0Offset !=0) {
        textureMap texture_map0 @ Map0Offset;   
    }
    if (Map1Offset !=0) {
        textureMap texture_map1 @ Map1Offset;   
    }
    if (Map2Offset !=0) {
        textureMap texture_map2 @ Map2Offset;  
    }
};

 struct boneInfo { // bone positions relative to its parent
    tVector4f EndPositionXYZScale;
    tVector4f StartPositionXYZScale;
    tVector3f Rotation; // eulerangles, degrees (n*360)
    u32 BoneNameOffset;
    tVector3f ukn_bone1;
    u8 AimTargetIdx;
    u8 BoneParentIdx;
    u8 BoneIdx; // used for name look up?
    boneType BoneType;
    //if (BoneNameOffset != 0) {
    char Name[] @ BoneNameOffset;
    //}
}[[name(std::format("{}", Name))]];

struct buffer1{
    tVectorColorb ColorRGBA;
    tVector2f TextureUV;
}[[static]];
struct buffer2{
    tVector4f PositonXYZScale;
    tVector4f NormalXYZScale;
}[[static]];
struct buffer3{
    tVector4f PositonXYZScale;
    tVector4f NormalXYZScale;
}[[static]];
struct buffer4{
    tVector3f Positon;
    tVector3f Normal;
    buffer1 vert_def;
    u32 Pad;
}[[static]];
u16 vertCount = 0;
struct face{
    u16 value; // ストリップ（0xFFFFで再開）またはリスト
    if(value != 0xFFFF && vertCount < value){
    vertCount = value;
    }
};
 struct layerObjectEntryXbox{
    vertCount = 0;
    meshXboxContent ObjectType; // 0x00=Static, 0x04=Skinned
    primativeXbox PrimitiveType; // 0x00=TriangleStrip, 0x01=TriangleList
    u32 FaceCount; // Number of Index in Index Buffer
    u32 MatrixOffset;
    u32 MaterialOffset;
    u32 FaceOffset; // Index Buffer Offset
    u32 Buffer1Offset; // for skinned and static meshes this is the vertex buffer
    u32 Buffer2Offset;
    u32 Buffer3Offset;
    u32 Buffer4Offset;
    if(mdlVersion >= 4){
    u32 CenterRadiusOffset; // "Aman" describes this section as "Center+Radius Offset"
    }
    
    face skinned_mesh_data[FaceCount] @ FaceOffset;
    vertCount+=1;
    
    if(ObjectType == meshXboxContent::STATICXBOX){
    buffer4 staticVerts[vertCount] @ Buffer1Offset;
    if(mdlVersion >= 4){
        if(CenterRadiusOffset > 0){
            tVector4f CenterRadius @ CenterRadiusOffset;
        }
    }
    }else if(ObjectType == meshXboxContent::SKINNEDXBOX){
    buffer1 color[vertCount] @ Buffer1Offset;
    buffer2 position[vertCount] @ Buffer2Offset;
    buffer3 normal[vertCount] @ Buffer3Offset;
    }
    
    };
    
u8 lastStat = 0;
struct weightDef{
        tVector3f Positon; // positions relative to assigned bone
        float BoneWeight;
        tVector3f Normal;
        u8 BoneIdx;
        u8 intcre;
        u8 Unk1[2];
        lastStat = intcre;
};

u32 longRow = 4;
struct weightRowLong{ // 4本影響枠ではstat==1によりレコード数が累積拡張される。
        weightDef defs[longRow];
        longRow = longRow + lastStat;
};

struct weightBuffer { // Flat with dynamic sizing 1,2,3,4,5,6, .......
    weightDef relative_position_normal1[parent.VertCount1];
    weightDef relative_position_normal2[parent.VertCount2 * 2];
    weightDef relative_position_normal3[parent.VertCount3 * 3];
    weightRowLong relative_position_normal4[parent.VertCount4];
};

struct weightTable {
    u32 VertCount1; // number of vertices with 1 bone weight per vertex bone_id1
    u32 VertCount2; // number of vertices with 2 bone weight per vertex bone_id2
    u32 VertCount3; // number of vertices with 3 bone weight per vertex bone_id3
    u32 VertCount4; // number of vertices with 4 or more bone weight per vertex bone_id4
    u32 WeightBufferOffset; // weight buffer, also contains vertices and Normals
    u32 VertBuffer1Offset; // Vertex Buffer
    u32 VertBuffer2Offset; // Vertex Buffer2, redundant?
    longRow = 4;
    weightBuffer weight_buffer @ WeightBufferOffset;

};

struct weightRowV2{
        lastStat = 0;
        weightDef defs[while(lastStat != 1)];
};
struct weightTableV2 {
    u32 zero;
    u32 WeightBufferOffset;
    u32 VertBuffer1Offset;
    u32 VertBuffer2Offset;
    u32 VertBuffer3Offset;
    weightRowV2 weight_buffer[(VertBuffer2Offset - VertBuffer1Offset) / 32] @ WeightBufferOffset;
};

struct weightSection {
    if(mdlWeightTables > 0){
        if(mdlVersion > 2){
            weightTable weight_table;
        }else{
            weightTableV2 weight_table;
        }
    }
};

struct boneHeader{
    u8 day;
    u8 month;
    u16 year;
    u8 second;
    u8 minute;
    u8 hour;
    u8 pad;
    char author[32];
};


mdl_header SC2_MDL @0;
matrixTable MatrixTBL[SC2_MDL.MatricesCount] @ SC2_MDL.MatrixTableOffset;
VXT vxt @ SC2_MDL.TextureTableOffset;
materialTable vxt_materials[SC2_MDL.MaterialsCount] @ SC2_MDL.MaterialOffset;
boneInfo bone_data[SC2_MDL.BonesCount] @ SC2_MDL.BoneOffset;
matrixUnk unkMtx @ SC2_MDL.ukn_MatrixTableOffset;

layerObjectEntryXbox object_0_xbox[SC2_MDL.Objects0Count] @ SC2_MDL.Object0Offset;
layerObjectEntryXbox object_1_xbox[SC2_MDL.Objects1Count] @ SC2_MDL.Object1Offset;
layerObjectEntryXbox object_2_xbox[SC2_MDL.Objects2Count] @ SC2_MDL.Object2Offset;
weightSection weights @ SC2_MDL.WeightTableOffset;
boneHeader author @ SC2_MDL.BoneHeaderOffset;