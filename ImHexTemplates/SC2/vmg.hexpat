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

enum meshXboxContent : u16 {
    STATICXBOX  = 0,
    SKINNEDXBOX = 4
};

enum meshGCNContent : u8 {
    STATICGCN  = 2, //(2, 2, 2, 2)
    SKINNEDGCN = 3, //(3, 3, 2, 3)  //(3, 3, 3, 3)
};

enum primativeXbox : u16 {
    TRIANGLESTRIP = 0,
    TRIANGLELIST  = 1
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
    CMPR   = 14, //(S3TC compressed, 2x2 blocks of 4x4 tiles)
    XFB    = 15, // 0x0F
    UNK16  = 16  // 0x10
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
    DRAWNONESIDE   = 8
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

struct matrixTable{
    u8 Type;
    u8 ParentBoneIdx; // parent object to this bone?
    u16 Ukn1;
    u32 Ukn3; // on stages files an offset is present
    u32 Ukn4;
    u32 Ukn5;
    tVector4f Matrix4x4Transform[4];
    padding[256]; //64 more than gamecube
    
};

#pragma endian big

import std.io;

struct mdl_header{
    char MAGIC[4];
    console ConsoleVersion;
    u8 textureOffsetPoint;
    u8 textureCount;
    u8 isNotTexture;
    u8 unk;
    modelContent Contents;
    u16 MatricesCount;
    u16 Objects0Count;
    u16 Objects1Count;
    u16 Objects2Count;
    u16 BonesCount;
    u16 MaterialsCount;
    u16 MeshCount; // always 1?
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


struct textureDataSlice{
    TexMode0 TexModeInfo;
    u16 unk0;
    u8 maxlod;
    u8 minlod;
    tDimension Dimensions;
    u32 CLUTOffset;
    u16 unk4;
    u16 unk5;
    imageTypeGCN ImageType;
    u32 unk6;
    u16 imageSizeGC;
    u16 unk8;
};

struct textureData{
    u32 TexturePaletteOffset;
    textureDataSlice slices[2];
};

struct palletData{
u32 unk0;
u32 offset;
le palletTypeGCN palletFormat;
rgb565 data[256] @ offset;
};

struct VGT{
    char MAGIC[4];
    
    u32 unk0;
    
    u32 TexCount;
    u32 unk1;
    u32 HeaderLen;
    u32 HeaderBlockSize;
    textureData txtData[TexCount];
    //palletData pltData[TexCount];
};

u32 PalletCount = 0;
u32 vxt_offset = 0;

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
u16 HeightVisible;
u16 WidthVisible;
u32 CLUTOffset;
imageTypeXBOX ImageType;
u16 Height;
u16 Width;
u32 MipMapCount;
u32 Pad2;
if(TexturePaletteOffset){
PalletCount +=1;
}
match(ImageType){
    (imageTypeXBOX::D3DFMT_DXT1): u8 data[(Height*Width)/2] @ vxt_offset + CLUTOffset;
    (imageTypeXBOX::D3DFMT_DXT4): u8 data[(Height*Width)] @ vxt_offset + CLUTOffset;
    (imageTypeXBOX::D3DFMT_P8): u8 data[(Height*Width)] @ vxt_offset + CLUTOffset;
    }
};


struct VXT{
vxt_offset = $;
char MAGIC[4];
u8 type;
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
    u8 Type;
    u8 ukn1;
    u8 ukn2;
    materialTableCull CullMode; // 0x00=DrawnBothSides, 0x08=DrawnOneSide
    u32 OpacitySrc;
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
    u8 ukn_bone2;
    u8 BoneParentIdx;
    u8 BoneIdx; // used for name look up?
    u8 ukn_bone3;
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
    u16 value;
    if(vertCount < value){
    vertCount = value;
    }
};
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
struct GCPoly{
match (IType1) {
        (VertexComponentFormat::Index8): u8 VertIDX;
        (VertexComponentFormat::Index16): u16 VertIDX;
    }
    match (IType2) {
        (VertexComponentFormat::Index8): u8 ClrIDX;
        (VertexComponentFormat::Index16): u16 ClrIDX;
    }
    match (IType3) {
        (VertexComponentFormat::Index8): u8 uvIDX;
        (VertexComponentFormat::Index16): u16 uvIDX;
    }
    match (IType4) {
        (VertexComponentFormat::Index8): u8 NormalIDX;
        (VertexComponentFormat::Index16): u16 NormalIDX;
    }

};
struct GCIndc{
RasterizationState State;
u16 IndexCount;
GCPoly Polys [IndexCount];
};
#include "std/mem.pat"

struct layerObjectEntryGC{
    CPArray Unk0; // These unk are consistent with skinned/static meshes
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
    u32 BoundingOffset;
    u32 BufferAlloc = FaceCount*32;
    u32 endAddress = FaceOffset + BufferAlloc;
    std::mem::Section mySection = std::mem::create_section("GC Indexes");
    //GCIndc polys[while(std::mem::reached(endAddress) == false)] @ FaceOffset;
    u8 faceAlloc[BufferAlloc] @ FaceOffset;
    if(Position1Offset > 0)
        float test1 @ Position1Offset;
    if(Position2Offset > 0)
        float test2 @ Position2Offset;
    if(Normal1Offset > 0)
        float Ntest1 @ Normal1Offset;
    if(Normal2Offset > 0)
        float Ntest2 @ Normal2Offset;
    if(ColorOffset > 0)
        tVectorColorb CTest @ ColorOffset;
    if(TexCoordOffset > 0)
        float UVTest @ TexCoordOffset;
    if(BoundingOffset > 0)
        tVector4f BoundBox @ BoundingOffset;

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
    u32 CenterRadiusOffset; // "Aman" describes this section as "Center+Radius Offset"
    
    face skinned_mesh_data[FaceCount] @ FaceOffset;
    vertCount+=1;
    
    if(ObjectType == meshXboxContent::STATICXBOX){
    buffer4 staticVerts[vertCount] @ Buffer4Offset;
    tVector4f CenterRadius @ Buffer4Offset + sizeof(staticVerts);
    }else if(ObjectType == meshXboxContent::SKINNEDXBOX){
    buffer1 color[vertCount] @ Buffer1Offset;
    buffer2 position[vertCount] @ Buffer2Offset;
    buffer3 normal[vertCount] @ Buffer3Offset;
    }
    
    };
    
struct weightDef{
        s16 Positon[3]; // positions relative to assigned bone & 
        s16 BoneWeight; // # / 8192
        s16 Normal[3]; // # / 16384
        s16 BoneIdx;
};

struct weightTable {
    u32 VertCount1; // number of vertices with 1 bone weight per vertex bone_id1
    u32 VertCount2; // number of vertices with 2 bone weight per vertex bone_id2
    u32 VertCount3; // number of vertices with 3 bone weight per vertex bone_id3
    u32 VertCount4; // number of vertices with 4 bone weight per vertex bone_id4
    u32 WeightBufferOffset; // weight buffer, also contains vertices and Normals
    u32 VertBuffer1Offset; // Vertex Buffer
    u32 VertBuffer2Offset; // Vertex Buffer2, redundant?
    u32 NormalBuffer1Offset;
    u32 NormalBuffer2Offset;

};


mdl_header SC2_MDL @0;
matrixTable MatrixTBL[SC2_MDL.MatricesCount] @ SC2_MDL.MatrixTableOffset;
VGT vxt @ SC2_MDL.TextureTableOffset;
materialTable vxt_materials[SC2_MDL.MaterialsCount] @ SC2_MDL.MaterialOffset;
boneInfo bone_data[SC2_MDL.BonesCount] @ SC2_MDL.BoneOffset;

weightTable weight_table @ SC2_MDL.WeightTableOffset;

layerObjectEntryGC object_0_xbox[SC2_MDL.Objects0Count] @ SC2_MDL.Object0Offset;
layerObjectEntryGC object_1_xbox[SC2_MDL.Objects1Count] @ SC2_MDL.Object1Offset;
layerObjectEntryGC object_2_xbox[SC2_MDL.Objects2Count] @ SC2_MDL.Object2Offset;

weightDef relative_position_normal1[weight_table.VertCount1] @ weight_table.WeightBufferOffset;
weightDef relative_position_normal2[weight_table.VertCount2 * 2]@ weight_table.WeightBufferOffset + sizeof(relative_position_normal1);
weightDef relative_position_normal3[weight_table.VertCount3 * 3]@ weight_table.WeightBufferOffset + sizeof(relative_position_normal1) + sizeof(relative_position_normal2);
weightDef relative_position_normal4[weight_table.VertCount4 * 4]@ weight_table.WeightBufferOffset + sizeof(relative_position_normal1) + sizeof(relative_position_normal2) + sizeof(relative_position_normal3);

u8 unkarray[40] @ SC2_MDL.BoneHeaderOffset;