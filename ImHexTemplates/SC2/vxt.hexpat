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

struct tVectorColorb {
  u8 R   [[color("FF0000")]];
  u8 G [[color("00FF00")]];
  u8 B  [[color("0000FF")]];
  u8 A;
} [[static, color(std::format("{:02X}{:02X}{:02X}", R, G, B))]];

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
u32 flags;
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

VXT texture @ 0;