#pragma endian big

import std.io;

enum palletTypeGCN : u32 {
        IA8 = 0,
        RGB565 = 1,
        RGB5A3 = 2
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


fn imageSizeGCN(u32 num) {
        match ( num ) 
        {
            (2   )   : return 2 << 5; // 8 x 8 
            (4   )   : return 2 << 6; // 16 x 8 
            (8   )   : return 2 << 7; // 32 x 16 
            (16  )   : return 2 << 8; // 32 x 32 
            (32  )   : return 2 << 9; // 64 x 32
            (64  )   : return 2 << 10; // 64 x 64
            (128 )   : return 2 << 11; // 128 x 64
            (256 )   : return 2 << 12; // 128 x 128
            (512 )   : return 2 << 13; // 256 x 128
            (1024)   : return 2 << 14; // 256 x 256
            (2048)   : return 2 << 15; // 512 x 256
            (4096)   : return 2 << 16; // 512 x 512
            (_   )   : return -1;
        }
};

bitfield rgb565{
    R : 5;
    G : 6;
    B : 5;
} [[static, color(std::format("{:02X}{:02X}{:02X}", R, G, B))]];

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



struct tVectorColorb {
  u8 R   [[color("FF0000")]];
  u8 G [[color("00FF00")]];
  u8 B  [[color("0000FF")]];
  u8 A;
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

VGT texture @ 0;