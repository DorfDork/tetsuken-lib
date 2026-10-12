#pragma endian big

import std.core;
import std.io;

enum PalletTypeGCN : u32 {
    IA8    = 0,
    RGB565 = 1,
    RGB5A3 = 2
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

fn image_size_gcn(u32 num) {
    match (num) {
        (2): return 2 << 5;     // 8 x 8
        (4): return 2 << 6;     // 16 x 8
        (8): return 2 << 7;     // 32 x 16
        (16): return 2 << 8;    // 32 x 32
        (32): return 2 << 9;    // 64 x 32
        (64): return 2 << 10;   // 64 x 64
        (128): return 2 << 11;  // 128 x 64
        (256): return 2 << 12;  // 128 x 128
        (512): return 2 << 13;  // 256 x 128
        (1024): return 2 << 14; // 256 x 256
        (2048): return 2 << 15; // 512 x 256
        (4096): return 2 << 16; // 512 x 512
        (_): return -1;
    }
};

bitfield RGB565 {
    r : 5;
    g : 6;
    b : 5;
} [[static, color(std::format("{:02X}{:02X}{:02X}", r, g, b))]];

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

struct VectorColorb {
    u8 r [[color("FF0000")]];
    u8 g [[color("00FF00")]];
    u8 b [[color("0000FF")]];
    u8 a;
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

VGT gTexture @ 0;
