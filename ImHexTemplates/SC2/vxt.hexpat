import std.io;

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

struct VectorColorb {
    u8 b [[color("0000FF")]];
    u8 g [[color("00FF00")]];
    u8 r [[color("FF0000")]];
    u8 a;
} [[static, color(std::format("{:02X}{:02X}{:02X}", r, g, b))]];

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

VXT gTexture @ 0;
