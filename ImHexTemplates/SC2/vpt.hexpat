import std.mem;

fn fixy(u32 a) {
    u32 rem = a % 0x10;
    if (rem > 0) {
        return a - rem;
    } else {
        return a;
    }
};

/** Destination chain tag. */
enum DmaTagType : u64 {
    /** Transfers the QWC qword from the ADDR field, clears the Dn_CHCR.STR to 0, and ends transfer. */
    P2_DMA_TAG_REFE = 0,
    /** Transfers the QWC qword following the tag and reads the succeeding qword as the next tag. */
    P2_DMA_TAG_CNT  = 1,
    /** Transfers the QWC qword following the tag and reads the qword of the ADDR field as the next tag. */
    P2_DMA_TAG_NEXT = 2,
    /** Transfers the QWC qword from the ADDR field and reads the qword following the tag as the next tag.  */
    P2_DMA_TAG_REF  = 3,
    /**
     * Transfers the QWC qword from the ADDR field while controlling stalls
     * and reads the qword following the tag as the next tag.
     * @note Effective only on the VIF1, GIF, and SIF1 channels.
     */
    P2_DMA_TAG_REFS = 4,
    /**
     * Transfers the QWC qword following the tag, pushes the next field into
     * the Dn_ASR register, and reads the qword of the ADDR field as the next tag.
     * @note Effective only on the VIF0, VIF1, and GIF channels.
     * Addresses can be pushed up to 2 levels
     */
    P2_DMA_TAG_CALL = 5,
    /**
     * Transfers the QWC qword following the tag and reads the
     * qword of the field popped from the Dn_ASR register as the
     * next tag.
     * Transfers the QWC qword following the tag, clears the
     * Dn_CHCR.STR to 0, and ends transfer when there is no
     * pushed address.
     * @note Effective only on the VIF0, VIF1, and GIF channels.
     */
    P2_DMA_TAG_RET  = 6,
    /** Transfers the QWC qword following the tag, clears the Dn_CHCR.STR to 0, and ends transfer. */
    P2_DMA_TAG_END  = 7
};

enum PsmTypes : u32 {
    GS_TEX_32  = 0,
    GS_TEX_24  = 1,
    GS_TEX_16  = 2,
    GS_TEX_16S = 10,
    GS_TEX_8   = 19,
    GS_TEX_4   = 20,
    GS_TEX_8H  = 27,
    GS_TEX_4HL = 36,
    GS_TEX_4HH = 44
};

enum GsTexFunctions : u32 {
    GS_TEX_MODULATE = 0, /** brighten texture based on Pixel's Alpha */
    GS_TEX_DECAL,        /** keep texture as is */
    GS_TEX_HIGHLIHGT1,   /** used when highlighting translucent polygons */
    GS_TEX_HIGHLIHGT2    /** used when highlighting opaque polygons */
};

bitfield GsTex0 {
    tbAddr                    : 14;
    tbWidth                   : 6;
    PsmTypes psm              : 6;
    texWidth                  : 4;
    texHeight                 : 4;
    texCc                     : 1;
    GsTexFunctions texFuntion : 2;
    cbAddr                    : 14;
    clutPixmode               : 4;
    clutSmode                 : 1;
    clutOffset                : 5;
    clutLoadmode              : 3;
};

bitfield GsBitbltbuf {
    srcAddr     : 14;
    pad1        : 2;
    srcWidth    : 6;
    pad2        : 2;
    srcPixmode  : 6;
    pad3        : 2;
    destAddr    : 14;
    pad4        : 2;
    destWidth   : 6;
    pad5        : 2;
    destPixmode : 6;
    pad6        : 2;
};

bitfield GsTrxpos {
    srcX      : 11;
    pad1      : 5;
    srcY      : 11;
    pad2      : 5;
    destX     : 11;
    pad3      : 5;
    destY     : 11;
    direction : 2;
    pad4      : 3;
};

bitfield GsTrxreg {
    transW : 12;
    pad1   : 20;
    transH : 12;
    pad2   : 20;
};

bitfield GsTrxdir {
    transDir : 2;
    pad1     : 62;
};

bitfield GsPrim {
    primType : 3;
    iip      : 1;
    tme      : 1;
    fge      : 1;
    abe      : 1;
    aa1      : 1;
    fst      : 1;
    ctxt     : 1;
    fix      : 1;
    pad1     : 53;
};

bitfield DmaTag {
    /** Quadword count. */
    QWC           : 16;
    PAD           : 10;
    /**
     * Priority Control Enable.
     * 00 Nothing performed
     * 01 Reserved
     * 10 Priority setting disabled (D_PCR.PCE = 0)
     * 11 Priority setting enabled (D_PCR.PCE = 1)
     */
    PCE           : 2;
    /** Tag ID. (look at DmaTagType) */
    DmaTagType ID : 3;
    /**
     * Interrupt Request.
     * 0 No interrupt request
     * 1 Interrupt request at end of packet transfer
     */
    IRQ           : 1;
    /**
     * Address.
     * Address of packet or next tag instruction
     * (With qword alignment, lower 4 bits become 0.)
     */
    ADDR          : 31;
    /**
     * Memory/SPR Selection.
     * 0 Memory address
     * 1 SPR address
     */
    SPR           : 1;
    OPT1          : 32;
    OPT2          : 32;
};

bitfield GsGifTag {
    nloop : 15;
    eop   : 1;
    pad1  : 30;
    pre   : 1;
    prim  : 11;
    flg   : 2;
    nreg  : 4;
    u64 reg;
};

enum GsType : u64 {
    GS_PRIM       = 0x00,
    GS_RGBAQ      = 0x01,
    GS_ST         = 0x02,
    GS_UV         = 0x03,
    GS_XYZF2      = 0x04,
    GS_XYZ2       = 0x05,
    GS_TEX0_1     = 0x06,
    GS_TEX0_2     = 0x07,
    GS_CLAMP_1    = 0x08,
    GS_CLAMP_2    = 0x09,
    GS_FOG        = 0x0A,
    GS_XYZF3      = 0x0C,
    GS_XYZ3       = 0x0D,
    GS_TEX1_1     = 0x14,
    GS_TEX1_2     = 0x15,
    GS_TEX2_1     = 0x16,
    GS_TEX2_2     = 0x17,
    GS_XYOFFSET_1 = 0x18,
    GS_XYOFFSET_2 = 0x19,
    GS_PRMODECONT = 0x1A,
    GS_PRMODE     = 0x1B,
    GS_TEXCLUT    = 0x1C,
    GS_SCANMSK    = 0x22,
    GS_MIPTBP1_1  = 0x34,
    GS_MIPTBP1_2  = 0x35,
    GS_MIPTBP2_1  = 0x36,
    GS_MIPTBP2_2  = 0x37,
    GS_TEXA       = 0x3B,
    GS_FOGCOL     = 0x3D,
    GS_TEXFLUSH   = 0x3F,
    GS_SCISSOR_1  = 0x40,
    GS_SCISSOR_2  = 0x41,
    GS_ALPHA_1    = 0x42,
    GS_ALPHA_2    = 0x43,
    GS_DIMX       = 0x44,
    GS_DTHE       = 0x45,
    GS_COLCLAMP   = 0x46,
    GS_TEST_1     = 0x47,
    GS_TEST_2     = 0x48,
    GS_PABE       = 0x49,
    GS_FBA_1      = 0x4A,
    GS_FBA_2      = 0x4B,
    GS_FRAME_1    = 0x4C,
    GS_FRAME_2    = 0x4D,
    GS_ZBUF_1     = 0x4E,
    GS_ZBUF_2     = 0x4F,
    GS_BITBLTBUF  = 0x50,
    GS_TRXPOS     = 0x51,
    GS_TRXREG     = 0x52,
    GS_TRXDIR     = 0x53,
    GS_HWREG      = 0x54,
    GS_SIGNAL     = 0x60,
    GS_FINISH     = 0x61,
    GS_LABEL      = 0x62,
    GS_NOP        = 0x7F
};

enum GsReg : u8 {
    TEX0_1    = 0x06, // Select current texture in context 1
    TEX0_2    = 0x07, // Select current texture in context 2
    CLAMP_1   = 0x08, // Set texture wrap mode in context 1
    CLAMP_2   = 0x09, // Set texture wrap mode in context 2
    TEX1_1    = 0x14,
    TEX1_2    = 0x15,
    TEX2_1    = 0x16, // Set texture filtering\sampling style in context 1
    TEX2_2    = 0x17, // Set texture filtering\sampling style in context 2
    TEXCLUT   = 0x1C,
    MIPTBP1_1 = 0x34, // Set mipmap address in context 1(mip level 1-3)
    MIPTBP1_2 = 0x35, // Set mipmap address in context 1(mip level 1-3)
    MIPTBP2_1 = 0x36, // Set mipmap address in context 2(mip level 4-6)
    MIPTBP2_2 = 0x37, // Set mipmap address in context 2(mip level 4-6)
    TEXA      = 0x3B, // Texture alpha setting
    TEXFLUSH  = 0x3F, // Flush texture buffer/cache
    ALPHA_1   = 0x42, // Alpha blending setting (Context 1)
    ALPHA_2   = 0x43, // Alpha blending setting (Context 2)
    TEST_1    = 0x47, // FrameBuffer\ZBuffer Pixel test contol (Context 1)
    TEST_2    = 0x48, // FrameBuffer\ZBuffer Pixel test contol (Context 2)
    BITBLTBUF = 0x50, // Texture transmission address & format
    TRXPOS    = 0x51, // Texture transmission coordinates
    TRXREG    = 0x52, // Texture transmission width & height
    TRXDIR    = 0x53  // Texture transmission direction
};

struct AddressTable {
    DmaTag values[while (std::mem::read_unsigned($, 4) != 0x60000000)];
    DmaTag end;
};

struct Pallet {
    u32 color[256];
};

struct ADWrite {
    u8 regPeek = std::mem::read_unsigned($ + 8, 1);
    if (regPeek == 6 || regPeek == 7) {
        GsTex0 value;
    } else {
        u64 value;
    }
    GsReg reg;
    padding[7];
};

struct TextureSlice {
    u32 stuff[4];
    GsGifTag gifTag;
    GsBitbltbuf bitbltbuf;
    u64 bitbltbufReg;
    GsTrxpos trxpos;
    u64 trxposReg;
    GsTrxreg trxreg;
    u64 trxregReg;
    GsTrxdir trxdir;
    u64 trxdirReg;
    u32 palletLen;
    u32 count;
    padding[8];
    u16 unk1;
    u16 unk2;
    u32 palletOffset;
    padding[8];
    //u8 data[palletLen] @ palletOffset;
    //Lets use what the DMA uses!
    u128 data[unk1] @ palletOffset + gOffsetTo;
};

u32 gTrueCountTextures = 0;

struct TextureEntry {
    TextureSlice slices[while (std::mem::read_unsigned($, 4) == 268435462)];
    u32 footer[4];
    gTrueCountTextures = gTrueCountTextures + 1;
};

struct DimentionEnt {
    u16 nloop;
    u16 tagPad;
    u32 tagHi;
    u8 regs;
    u8 dmaTableIdx;
    u8 uploadIdx;
    u8 pad;
    u16 width;
    u16 height;
    ADWrite writes[nloop & 0x7FFF];
};

struct TexTable {
    u32 offset;
    DimentionEnt texture @ gOffsetTo + offset - (offset % 0x10);
};

u8 gVptVersion = 2;

struct DmaTable {
    u32 offset;
    u32 extra;
    u16 count;
    u16 magic;
    if (gVptVersion == 3) {
        u64 unk; // 3 has an extra 64bit number after, idk why
    }
};

struct VPTDate {
    u8 day;
    u8 month;
    u16 year;
    u8 second;
    u8 minute;
    u8 hour;
    u8 pad;
};

struct VPT {
    u8 byteMagic;
    gVptVersion = byteMagic;
    u8 offset2Dmas;
    u8 offsetCount;
    u8 reserved;
    u8 dmaCount;
    u8 textureCount;
    u8 extendedTexCount;
    u8 idk2;
    u32 address1;
    DmaTable dmaTables[dmaCount] @ gOffsetTo + address1;
    u32 address2;
    TexTable textures[textureCount] @ gOffsetTo + address2;
    //u32 testa2[textureCount] @ gOffsetTo + address2;
    u32 address3; //End of file
    u32 testa3 @ gOffsetTo + address3;
    u32 address4; //End of file
    VPTDate date @ gOffsetTo + address4;
    u32 address5;
    u32 address6;
    if (offsetCount == 6) {
        if (address5 > 0) {
            DmaTable dmaTables2[dmaCount] @ gOffsetTo + address5;
        }
        if (address6 > 0) {
            TexTable textures2[textureCount] @ gOffsetTo + address6;
        }
    }
    u32 trueDmaCount = (offsetCount == 6) ? dmaCount * 2 : dmaCount;
    AddressTable textureInfo[trueDmaCount];
    TextureEntry textEnt[while (std::mem::read_unsigned($, 4) == 268435462)];
    //DimentionEnt dimmy[gTrueCountTextures];
    //Pallet pallets[textureCount];
};

//u32 gOffsetTo @ 0x14;
u32 gOffsetTo = 0;
VPT gFile @ gOffsetTo;
