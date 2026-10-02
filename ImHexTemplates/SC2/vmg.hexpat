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
    BONEMTX   = 2,
    EFFECTMTX = 3
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

enum meshGCNContent : u8 {
    STATICGCN  = 2, //(2, 2, 2, 2)
    SKINNEDGCN = 3, //(3, 3, 2, 3)  //(3, 3, 3, 3)
};

enum primativeGCN : u8 {
    PACKEDTRIANGLELIST  = 0x90,
    PACKEDTRIANGLESTRIP = 0x98
};

enum imageTypeGCN : u32 {
    I4     = 0,  //(4 bit intensity, 8x8 tiles)
    I8     = 1,  //(8 bit intensity, 8x4 tiles)
    IA4    = 2,  //(4 bit intensity with 4 bit alpha, 8x4 tiles)
    IA8    = 3,  //(8 bit intensity with 8 bit alpha, 4x4 tiles)
    RGB565 = 4,  //(4x4 tiles)
    RGB5A3 = 5,  //(*) (4x4 tiles)
    RGBA8  = 6,  //(4x4 tiles in two cache lines - first is AR and second is GB)
    CI4    = 8,  //(4 bit color index, 8x8 tiles)
    CI8    = 9,  //(8 bit color index, 8x4 tiles)
    C14X2  = 10, //(14 bit color index, 4x4 tiles)
    CMPR_ALPHA = 12,
    CMPR   = 14, //(S3TC compressed, 2x2 blocks of 4x4 tiles)
    XFB    = 15, // 0x0F
    UNK16  = 16  // 0x10
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

struct tVector4b{
    u8 X;
    u8 Y;
    u8 Z;
    u8 W;
}[[static,name(std::format("{}{}{}{}", X, Y, Z, W))]];

struct tVectorColorb {
  u8 R   [[color("FF0000")]];
  u8 G [[color("00FF00")]];
  u8 B  [[color("0000FF")]];
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

struct matrix2{
    tVector4f Matrix4x4Transform[4];
};
struct matrixUnk{ // data Present in stage files? boundaries?
    u16 Unk1;
    u16 Matrix2Count;
    u32 Matrix2Offset; // if count is 0, then this will point to the material block
    matrix2 Matrix2[Matrix2Count] @ Matrix2Offset;
}
;
fn matrixUnkFlagSize(u8 type) {
    if(type == 2 || type == 3 || type == 12)
        return 0x20;
    if(type == 10 || type == 11)
        return 0x30;
    if(type == 7 || type == 9)
        return 0x40;
    return 0x10;
};
struct matrixUnkFlag{
    u8 Type;
    if(Type == 1){
        u8 Unk1;
        u8 IndexCount;
        u8 Unk2;
        u8 Indices[IndexCount];
        u8 Unused[12 - IndexCount];
    }else if(Type == 8){
        u8 Unk1;
        u8 MatrixCount;
        u8 Unk2;
        u8 Unused[12];
        matrix2 Matrices[MatrixCount];
    }else{
        u8 Unk[3];
        float Values[(matrixUnkFlagSize(Type) - 4) / 4];
    }
};
struct matrixUnkFlagList{
    matrixUnkFlag UnkFlags[while($[$] != 0)];
    matrixUnkFlag End;
};
struct effectPoint{
    tVector4f Position;
    tVector4f Direction;
};
struct matrixTable{
    matrixType Type;
    if(Type == matrixType::EFFECTMTX){
        u8 EffectTextureCount;
        u8 EffectPointCount;
        u8 EffectType;
        float EffectValues[3];
    }else{
        u8 ParentBoneIdx; // parent object to this bone?
        u16 Ukn1;
        u32 Ukn3; // on stages files an offset is present
        u32 Ukn4;
        u32 Ukn5;
    }
    tVector4f Matrix4x4Transform[4];
    if(Type == matrixType::EFFECTMTX){
        u32 EffectTextureListOffset;
        u32 EffectPointsOffset;
        padding[248];
        if(EffectTextureCount > 0)
            u32 EffectTextureOffsets[EffectTextureCount] @ EffectTextureListOffset;
        if(EffectPointCount > 0)
            effectPoint EffectPoints[EffectPointCount] @ EffectPointsOffset;
    }else{
        padding[256]; //64 more than gamecube
        if(Ukn3 > 0)
            matrixUnkFlagList UnkFlagList @ Ukn3;
    }
    
};
struct stageBuffers{
    if(mdlContents == modelContent::STAGE){
        u32 Buffer2Offset;
        u32 Buffer2End;
        u32 Buffer1Offset;
        padding[4];
        u8 Buffer1[Buffer2Offset - Buffer1Offset] @ Buffer1Offset;
        u8 Buffer2[Buffer2End - Buffer2Offset] @ Buffer2Offset;
    }
};

#pragma endian big

import std.io;

u8 mdlVersion = 0;
modelContent mdlContents = 0;
u16 mdlWeightTables = 0;

struct mdl_header{
    char MAGIC[4];
    u8 Version; // 0x02=Xbox?, 0x03=Gamecube, 0x04=Xbox
    mdlVersion = Version;
    u8 textureOffsetPoint;
    u8 textureCount;
    u8 isNotTexture;
    u8 unk;
    modelContent Contents;
    mdlContents = Contents;
    u16 MatricesCount;
    u16 Objects0Count;
    u16 Objects1Count;
    u16 Objects2Count;
    u16 BonesCount;
    u16 MaterialsCount;
    u16 MeshCount; // always 1?
    mdlWeightTables = MeshCount;
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

enum  WrapMode : u32
{
  Clamp = 0,
  Repeat = 1,
  Mirror = 2,
  // Hardware testing indicates that WrapMode set to 3 behaves the same as clamp, though this is an
  // invalid value
};
enum  FilterMode : u32
{
  Near = 0,
  Linear = 1,
};
enum  MipMode : u32
{
  None = 0,
  Point = 1,
  Linear = 2,
};
enum  LODType : u32
{
  Edge = 0,
  Diagonal = 1,
};
enum MaxAniso : u32
{
  One = 0,
  Two = 1,
  Four = 2,
};

bitfield TexMode0{
padd : 12;
bool lod_clamp : 1;
MaxAniso max_aniso : 2;
signed lod_bias : 8;
LODType diag_lod : 1;
FilterMode min_filter : 1;
MipMode mipmap_filter : 2;
FilterMode mag_filter : 1;
WrapMode wrap_t : 2;
WrapMode wrap_s : 2;
};


bitfield tDimension{
    imageTypeGCN imagetype : 12;
    Y : 10;
    X : 10;
}[[static,name(std::format("imagetype{}, X: {}, Y:{}",imagetype, X, Y))]];
enum palletTypeGCN : u32 {
        IA8 = 0,
        RGB565 = 1,
        RGB5A3 = 2
};
bitfield rgb565{
    R : 5;
    G : 6;
    B : 5;
} [[static, color(std::format("{:02X}{:02X}{:02X}", R, G, B))]];
bitfield TexImage1{
padd: 10;
tmem_even : 15;
cache_width : 3;
cache_height : 3;
cache_manually_managed : 1;
};


u32 vgt_offset = 0;
u32 mipWidth = 0;
u32 mipHeight = 0;
imageTypeGCN mipImageType = 0;

fn mipLevelSizeGCN(u32 width, u32 height, imageTypeGCN type) {
    u32 tileWidth = 4;
    u32 tileHeight = 4;
    u32 tileSize = 32;
    if(type == imageTypeGCN::I4 || type == imageTypeGCN::CI4 || type == imageTypeGCN::CMPR || type == imageTypeGCN::CMPR_ALPHA){
        tileWidth = 8;
        tileHeight = 8;
    }
    if(type == imageTypeGCN::I8 || type == imageTypeGCN::IA4 || type == imageTypeGCN::CI8){
        tileWidth = 8;
    }
    if(type == imageTypeGCN::RGBA8){
        tileSize = 64;
    }
    return ((width + tileWidth - 1) / tileWidth) * ((height + tileHeight - 1) / tileHeight) * tileSize;
};

struct textureMipLevel{
    if(mipWidth > 1)
        mipWidth = mipWidth / 2;
    if(mipHeight > 1)
        mipHeight = mipHeight / 2;
    u8 mipData[mipLevelSizeGCN(mipWidth, mipHeight, mipImageType)];
};

struct textureDataSlice{
    TexMode0 TexModeInfo;
    u16 unk0;
    u8 maxlod;
    u8 minlod;
    tDimension Dimensions;
    u32 DataOffset;
    u16 unk4;
    u16 unk5;
    imageTypeGCN ImageType;
    u32 unk6;
    u16 imageSizeGC;
    u16 unk8;
    if(imageSizeGC > 0){
        u8 data[imageSizeGC * 32] @ vgt_offset + DataOffset;
        if(maxlod >= 16){
            mipWidth = Dimensions.X + 1;
            mipHeight = Dimensions.Y + 1;
            mipImageType = ImageType;
            textureMipLevel mips[maxlod / 16] @ vgt_offset + DataOffset + imageSizeGC * 32;
        }
    }
};

struct palletData{
u32 TexTlut; // TexTLUT?
u32 offset;
u16 count;
u16 pad;
if(((TexTlut >> 10) & 3) == 0){
    u16 dataGR[count] @ vgt_offset + offset;
    u16 dataAB[count] @ vgt_offset + offset + (count * 2);
}else{
    u16 data[count] @ vgt_offset + offset;
}
};

struct textureData{
    u32 TexturePaletteOffset;
    textureDataSlice slices[2];
    bool colorIndexed = slices[0].ImageType == imageTypeGCN::CI4 || slices[0].ImageType == imageTypeGCN::CI8 || slices[0].ImageType == imageTypeGCN::C14X2;
    bool alphaIndexed = slices[1].imageSizeGC > 0 && (slices[1].ImageType == imageTypeGCN::CI4 || slices[1].ImageType == imageTypeGCN::CI8 || slices[1].ImageType == imageTypeGCN::C14X2);
    if(TexturePaletteOffset > 0 && (colorIndexed || alphaIndexed)){
        palletData pallet @ vgt_offset + TexturePaletteOffset;
        if(alphaIndexed){
            palletData alphaPallet @ vgt_offset + TexturePaletteOffset + 0xC;
        }
    }
};

struct palletDataLegacy{
u32 offset;
u32 reserved;
u32 size;
u32 format;
u16 data[size / 2] @ vgt_offset + offset;
};

struct textureDataLegacy{
    u32 TexturePaletteOffset;
    u32 flags;
    u32 unk;
    u32 ColorOffset; // Texture Offset
    u32 AlphaOffset; // Texture Alpha Map Offset
    imageTypeGCN ImageType;
    u16 Width;
    u16 Height;
    u16 MipMapCount;
    u16 unk1E;
    if(TexturePaletteOffset > 0 && (ImageType == imageTypeGCN::CI4 || ImageType == imageTypeGCN::CI8)){
        palletDataLegacy pallet @ vgt_offset + TexturePaletteOffset;
    }
};

struct VGT{
    vgt_offset = $;
    char MAGIC[4];
    
    u8 type;
    u8 flag0;
    u8 flag1;
    u8 flag2;
    
    u32 TexCount;
    u32 unk1;
    u32 HeaderLen;
    u32 HeaderBlockSize;
    if(type == 3){
        textureDataLegacy txtData[TexCount] @ vgt_offset + HeaderLen;
    }else{
        textureData txtData[TexCount] @ vgt_offset + HeaderLen;
    }
    //palletData pltData[TexCount];
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


struct materialTable{
    materialTableCull CullMode; // 0x00=DrawnBothSides, 0x08=DrawnOneSide
    u8 ukn2;
    u8 ukn1;
    materialType Type;
    opacitySrc OpacitySrc;
    u32 VGTOffset0; // offsets within the VGT block
    u32 VGTOffset1;
    u32 VGTOffset2;
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

enum  PrimitiveType : u32
{
  Points,
  Lines,
  Triangles,
  TriangleStrip,
};
enum CullMode : u32
{
  All,
  Front,   // cull back-facing primitives
  Back,  // cull front-facing primitives
  None,    // cull all primitives
};
enum ComponentFormat : u8
{
  UByte = 0,  // Invalid for normals
  Byte = 1,
  UShort = 2,  // Invalid for normals
  Short = 3,
  Float = 4,
  // Known to be used by Fifa Street and Def Jam: Fight for New York
  // See https://bugs.dolphin-emu.org/issues/12719
  // Assumed to behave the same as float, but further testing is needed
  InvalidFloat5 = 5,
  // Not known to be used
  InvalidFloat6 = 6,
  InvalidFloat7 = 7,
};
bitfield RasterizationState{
CullMode cullmode : 2;
padding : 1;
PrimitiveType primitive : 2;


};
enum VertexComponentFormat : u8
{
  NotPresent = 0,
  Direct = 1,
  Index8 = 2,
  Index16 = 3,
};
enum  ColorFormat : u8
{
  RGB565 = 0,    // 16b
  RGB888 = 1,    // 24b
  RGB888x = 2,   // 32b
  RGBA4444 = 3,  // 16b
  RGBA6666 = 4,  // 24b
  RGBA8888 = 5,  // 32b
};
enum CPArray : u8
{
  Position = 0,
  Normal = 1,

  Color0 = 2,
  Color1 = 3,

  TexCoord0 = 4,
  TexCoord1 = 5,
  TexCoord2 = 6,
  TexCoord3 = 7,
  TexCoord4 = 8,
  TexCoord5 = 9,
  TexCoord6 = 10,
  TexCoord7 = 11,

  XF_A = 12,  // Usually used for position matrices
  XF_B = 13,  // Usually used for normal matrices
  XF_C = 14,  // Usually used for tex coord matrices
  XF_D = 15,  // Usually used for light objects
};
enum  CoordComponentCount : u8
{
  XY = 0,
  XYZ = 1,
};
enum NormalComponentCount : u8
{
  N = 0,
  NTB = 1,
};
enum  ColorComponentCount : u8
{
  RGB = 0,
  RGBA = 1,
};
enum TexComponentCount : u8
{
  S = 0,
  ST = 1,
};
bitfield UVAT_group0{
bool NormalIndex3 : 1;
bool ByteDequant : 1;

 Tex0Frac : 5;
ComponentFormat Tex0CoordFormat : 3;
TexComponentCount Tex0CoordElements : 1;

ColorFormat Color1Comp : 3;
ColorComponentCount Color1Elements : 1;

ColorFormat Color0Comp : 3;
ColorComponentCount Color0Elements : 1;

ComponentFormat NormalFormat : 3;
NormalComponentCount NormalComponentCount : 1;

 PosFrac : 5;
ComponentFormat PosFormat : 3;
CoordComponentCount PosElements : 1;
};
    VertexComponentFormat IType1 = 0;
    VertexComponentFormat IType2 = 0;
    VertexComponentFormat IType3 = 0;
    VertexComponentFormat IType4 = 0;
u8 GCMeshType = 0;
u32 gcPositionCount = 0;
u32 gcNormalCount = 0;
u32 gcColorCount = 0;
u32 gcTexCoordCount = 0;
ComponentFormat gcArrayFormat = 0;
u8 gcArrayStride = 0;
u32 skinnedColorOffset = 0;
u32 skinnedColorCount = 0;
u32 skinnedTexCoordOffset = 0;
u32 skinnedTexCoordCount = 0;
ComponentFormat skinnedTexCoordFormat = 0;
u8 skinnedTexCoordStride = 0;
struct GCPoly{ // 0x98=ストリップ、0x90=リスト。頂点は位置・法線・カラー・UVの各インデックスを持つ。
match (IType1) {
        (VertexComponentFormat::Index8): u8 VertIDX;
        (VertexComponentFormat::Index16): u16 VertIDX;
    }
    match (IType2) {
        (VertexComponentFormat::Index8): u8 NormalIDX;
        (VertexComponentFormat::Index16): u16 NormalIDX;
    }
    match (IType3) {
        (VertexComponentFormat::Index8): u8 ClrIDX;
        (VertexComponentFormat::Index16): u16 ClrIDX;
    }
    match (IType4) {
        (VertexComponentFormat::Index8): u8 uvIDX;
        (VertexComponentFormat::Index16): u16 uvIDX;
    }
    if(IType1 == VertexComponentFormat::Index8 || IType1 == VertexComponentFormat::Index16){
        if(VertIDX >= gcPositionCount)
            gcPositionCount = VertIDX + 1;
    }
    if(IType2 == VertexComponentFormat::Index8 || IType2 == VertexComponentFormat::Index16){
        if(NormalIDX >= gcNormalCount)
            gcNormalCount = NormalIDX + 1;
    }
    if(IType3 == VertexComponentFormat::Index8 || IType3 == VertexComponentFormat::Index16){
        if(ClrIDX >= gcColorCount)
            gcColorCount = ClrIDX + 1;
    }
    if(IType4 == VertexComponentFormat::Index8 || IType4 == VertexComponentFormat::Index16){
        if(uvIDX >= gcTexCoordCount)
            gcTexCoordCount = uvIDX + 1;
    }

};
struct gcArrayEntry{
    match (gcArrayFormat) {
        (ComponentFormat::UByte): u8 Components[gcArrayStride];
        (ComponentFormat::Byte): s8 Components[gcArrayStride];
        (ComponentFormat::UShort): u16 Components[gcArrayStride / 2];
        (ComponentFormat::Short): s16 Components[gcArrayStride / 2];
        (_): float Components[gcArrayStride / 4];
    }
};
struct GCIndc{
if(GCMeshType == 2){
    u8 extra;
}
u8 State;
if(State > 0){
u16 IndexCount;
GCPoly Polys [IndexCount];
}
};
struct GCDisplayListCopyHeader{
    u16 TriangleCount;
    u16 VertexSize;
    u32 VerticesOffset;
    u32 CopyVerticesOffset;
    padding[20];
};
#include "std/mem.pat"

struct layerObjectEntryGC{
    u8 Unk0; // These unk are consistent with skinned/static meshes
    GCMeshType = Unk0;
    u8 PosStride;
    ComponentFormat PositionFormat;
    u8 PosScale;
    
    u8 NormalStride;
    ComponentFormat NormalFormat;
    u8 NormalScale;
    
    u8 UVStride;
    ComponentFormat UVFormat;
    u8 UVScale;
    
    VertexComponentFormat IndiceType1;
    VertexComponentFormat IndiceType2;
    VertexComponentFormat IndiceType3;
    VertexComponentFormat IndiceType4;
    IType1 = IndiceType1;
    IType2 = IndiceType2;
    IType3 = IndiceType3;
    IType4 = IndiceType4;
    u16 FaceCount;
    u32 MatrixOffset;
    u32 MaterialOffset;
    u32 Position1Offset; //Vertex Buffer1 
    u32 Position2Offset; //Vertex Buffer2
    u32 Normal1Offset; //Normal Buffer1
    u32 Normal2Offset; //Normal Buffer2
    u32 ColorOffset;
    u32 TexCoordOffset;
    u32 FaceOffset;
    if(mdlVersion >= 3){
    u32 BoundingOffset;
    }
    u32 BufferAlloc = FaceCount*32;
    u32 endAddress = FaceOffset + BufferAlloc;
    std::mem::Section mySection = std::mem::create_section("GC Indexes");
    gcPositionCount = 0;
    gcNormalCount = 0;
    gcColorCount = 0;
    gcTexCoordCount = 0;
    GCIndc polys[while($ < endAddress && std::mem::read_unsigned($ + (GCMeshType == 2 ? 1 : 0), 1) != 0)] @ FaceOffset;
    if(GCMeshType == 2){
        GCDisplayListCopyHeader copyHeader @ FaceOffset - 32;
        u32 copyEndAddress = endAddress + BufferAlloc;
        GCIndc polysCopy[while($ < copyEndAddress && std::mem::read_unsigned($ + 1, 1) != 0)] @ endAddress;
    }
    if(Position2Offset > 0){
        if(ColorOffset > 0){
            skinnedColorOffset = ColorOffset;
            if(gcColorCount > skinnedColorCount)
                skinnedColorCount = gcColorCount;
        }
        if(TexCoordOffset > 0){
            skinnedTexCoordOffset = TexCoordOffset;
            skinnedTexCoordFormat = UVFormat;
            skinnedTexCoordStride = UVStride;
            if(gcTexCoordCount > skinnedTexCoordCount)
                skinnedTexCoordCount = gcTexCoordCount;
        }
    }else{
        if(Position1Offset > 0){
            gcArrayFormat = PositionFormat;
            gcArrayStride = PosStride;
            gcArrayEntry test1[gcPositionCount] @ Position1Offset;
        }
        if(Normal1Offset > 0){
            gcArrayFormat = NormalFormat;
            gcArrayStride = NormalStride;
            gcArrayEntry Ntest1[gcNormalCount] @ Normal1Offset;
        }
        if(ColorOffset > 0)
            tVectorColorb VertexColor[gcColorCount] @ ColorOffset;
        if(TexCoordOffset > 0){
            gcArrayFormat = UVFormat;
            gcArrayStride = UVStride;
            gcArrayEntry UVTest[gcTexCoordCount] @ TexCoordOffset;
        }
    }
    if(mdlVersion >= 3){
    if(BoundingOffset > 0)
        tVector4f BoundBox @ BoundingOffset;
    }
    
    };
    
u8 lastStat = 0;
struct weightDef{
        s16 Positon[3]; // positions relative to assigned bone & 
        s16 BoneWeight; // # / 8192
        s16 Normal[3]; // # / 16384
        u8 intcre;
        u8 BoneIdx;
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
    u32 NormalBuffer1Offset;
    u32 NormalBuffer2Offset;
    longRow = 4;
    weightBuffer weight_buffer @ WeightBufferOffset;
    u32 TotalVertCount = VertCount1 + VertCount2 + VertCount3 + VertCount4;
    if(VertBuffer1Offset > 0)
        tVector4f VertBuffer1[TotalVertCount] @ VertBuffer1Offset;
    if(VertBuffer2Offset > 0)
        tVector4f VertBuffer2[TotalVertCount] @ VertBuffer2Offset;
    if(NormalBuffer1Offset > 0)
        tVector4f NormalBuffer1[TotalVertCount] @ NormalBuffer1Offset;
    if(NormalBuffer2Offset > 0)
        tVector4f NormalBuffer2[TotalVertCount] @ NormalBuffer2Offset;

};

struct weightSection {
    if(mdlWeightTables > 0){
        weightTable weight_table;
    }
};

struct skinnedVertexArraysGC {
    if(skinnedColorOffset > 0)
        tVectorColorb VertexColor[skinnedColorCount] @ skinnedColorOffset;
    if(skinnedTexCoordOffset > 0){
        gcArrayFormat = skinnedTexCoordFormat;
        gcArrayStride = skinnedTexCoordStride;
        gcArrayEntry TexCoord[skinnedTexCoordCount] @ skinnedTexCoordOffset;
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
u32 texture_map_end @ SC2_MDL.ukn_MatrixTableOffset - 4;
matrixUnk unkMtx @ SC2_MDL.ukn_MatrixTableOffset;
stageBuffers stage_buffers @ SC2_MDL.MatrixTableOffset - 16;
matrixTable MatrixTBL[SC2_MDL.MatricesCount] @ SC2_MDL.MatrixTableOffset;
VGT vgt @ SC2_MDL.TextureTableOffset;
materialTable vgt_materials[SC2_MDL.MaterialsCount] @ SC2_MDL.MaterialOffset;
boneInfo bone_data[SC2_MDL.BonesCount] @ SC2_MDL.BoneOffset;

layerObjectEntryGC object_0_gc[SC2_MDL.Objects0Count] @ SC2_MDL.Object0Offset;
layerObjectEntryGC object_1_gc[SC2_MDL.Objects1Count] @ SC2_MDL.Object1Offset;
layerObjectEntryGC object_2_gc[SC2_MDL.Objects2Count] @ SC2_MDL.Object2Offset;
skinnedVertexArraysGC skinned_vertex_arrays_gc @ skinnedColorOffset;

weightSection weights @ SC2_MDL.WeightTableOffset;

boneHeader author @ SC2_MDL.BoneHeaderOffset;