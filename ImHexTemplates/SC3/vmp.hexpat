import std.io;
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

bitfield VifCode {
    imdt : 16;
    num  : 8;
    cmd  : 8;
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

struct AddressTable {
    DmaTag values[while (std::mem::read_unsigned($, 4) != 0x60000000)];
    DmaTag end;
};

struct AddrCnt {
    DmaTag val;
    match (val.ID) {
        (DmaTagType::P2_DMA_TAG_REF): u128 data[val.QWC] @ val.ADDR;
    }
};

struct AddressTableMdl {
    AddrCnt values[while (std::mem::read_unsigned($, 4) != 0x60000000)];
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
    u32 gifTag[4];
    ADWrite bitbltbuf;
    ADWrite trxpos;
    ADWrite trxreg;
    ADWrite trxdir;
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
    u32 dmaTableHeader;
    DmaTable dmaTables[dmaCount] @ gOffsetTo + dmaTableHeader;
    u32 textureTableHeader;
    TexTable textures[textureCount] @ gOffsetTo + textureTableHeader;
    //u32 testa2[textureCount] @ gOffsetTo + textureTableHeader;
    u32 credits1; //End of file
    u32 testa3 @ gOffsetTo + credits1;
    u32 credits2; //End of file
    VPTDate date @ gOffsetTo + credits2;
    u32 extendOffset1;
    u32 extendOffset2;
    if (offsetCount == 6) {
        if (extendOffset1 > 0) {
            DmaTable dmaTables2[dmaCount] @ gOffsetTo + extendOffset1;
        }
        if (extendOffset2 > 0) {
            TexTable textures2[textureCount] @ gOffsetTo + extendOffset2;
        }
    }
    u32 trueDmaCount = (offsetCount == 6) ? dmaCount * 2 : dmaCount;
    AddressTable textureInfo[trueDmaCount];
    TextureEntry textEnt[while (std::mem::read_unsigned($, 4) == 268435462)];
    //DimentionEnt dimmy[gTrueCountTextures];
    //Pallet pallets[textureCount];
};

struct Vector4f {
    float x;
    float y;
    float z;
    float w;
} [[static, name(std::format("{},{},{},{}", x, y, z, w))]];

struct Vector3f {
    float x;
    float y;
    float z;
} [[static, name(std::format("{},{},{}", x, y, z))]];

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
    if (boneNameOffset != 0) {
        char name[] @ boneNameOffset;
    }
};

struct Cmd11 {
    u8 val[4];
};

enum VmdCommand : u8 {
    END   = 0,
    ST_SH = 1,
    STRP  = 2,
    TEX   = 3,
    ST_ED = 4,
    PRE_S = 5,
    CULL  = 6,
    MATE  = 7,
    SKN_S = 8,
    UV_SH = 9
};

bitfield ShapeFlags {
    type : 4;
    unk4 : 2;
    soft : 1;
    vFog : 1;
};

struct TableC {
    u32 currentOff = $;

    VmdCommand type;
    u8 size;
    if (type == VmdCommand::ST_SH) {
        ShapeFlags shape;
        u8 p1;
    } else {
        u16 qwc;
    }
    u32 trueSize = currentOff + size;
    match (type) {
        (VmdCommand::STRP): {
            if (size > 8) {
                float sphere[(size - 8) / 4];
            }
            u32 packetOffset;
            u8 packet[qwc * 16] @ packetOffset;
        }
        (VmdCommand::TEX): {
            u32 textureEntry1;
            u32 textureEntry2;
            if (size >= 20) {
                float f1;
                float f2;
            }
            DimentionEnt texture @ textureEntry1 - (textureEntry1 % 0x10);
        }
        (VmdCommand::ST_ED): {
            u32 nextGroup;
        }
        (VmdCommand::PRE_S): {
            AddressTableMdl *modelDma : u32;
        }
        (VmdCommand::CULL): {
            float values[(size - 4) / 4];
        }
    }
    padding[trueSize - $];
};

struct TableCPoint {
    u32 offset;
    TableC entry[while (std::mem::read_unsigned($, 1) != 0)] @ offset;
};

struct TableB {
    u8 layer;
    u8 unk1;
    u8 unk2;
    u8 unk3;
    TableCPoint entry;
};

struct TableBPoint {
    u32 offset;
    TableB entry @ offset;
};

struct ObjectLayer {
    u8 type;
    u8 batchCount;
    u8 unk1;
    u8 layerCount;
    match (type) {
        (1): {
            u8 palette[layerCount];
            padding[32 - layerCount];
        }
        (2): {
            u32 i;
            float f1;
            float f2;
        }
        (3): {
            float f;
            u32 i1;
            u32 i2;
            u32 i3;
        }
        (4): {
            u32 v[39];
        }
    }
    u32 unk2;
    if (type < 2) {
        TableBPoint batches[batchCount];
    }
};

struct ObjectPoint {
    u32 offset;
    ObjectLayer layer @ offset;
};

struct Table2 {
    u32 unk1;
    u32 unk2;
    u32 unk3;
};

struct Header {
    u8 version;
    u8 revision;
    u8 tag;
    u8 pointerCount;
    u8 unk04;
    u8 unk05;
    u8 unk06;
    u8 modelContent;
    u16 object1Count;
    u16 boneCount;
    u32 vertCount;
    padding[16]; //SC3 Specal
    u32 boneOffset;
    u32 textureTableOffset;
    u32 object1Offset;
    u32 table5Offset;
    u32 table4Offset;
    u32 boneHeaderOffset;
    u32 unk016;
    u32 table1Offset;
    if (pointerCount > 8) {
        u32 table2Offset;
    }
    if (pointerCount > 9) {
        u32 table3Offset;
    }
    if (pointerCount > 10) {
        u32 table6Offset;
    }
};

struct Table4 {
    u8 type;
    u8 count;
    u8 unk1;
    u8 unk2;
    match (type) {
        (1): u32 val;
        (2): u32 val[2];
        (3): u32 val;
        (4): u32 val;
        (6): u32 val;
        (7): {
            u8 indexes[count];
            padding[0x20 - count];
        }
        (8): u32 val;
        (9): u32 val;
        (10): u32 val;
        (11): u32 val;
        (16): {
            u8 indexes[count];
            padding[0x20 - count];
        }
    }
};

struct Table4Entrys {
    Table4 entry[while (std::mem::read_unsigned($, 1) != 0)];
    padding[4];
};

struct BoneHeader {
    VPTDate date;
    char author[];
};

struct VMP {
    Header header;
    if (header.table1Offset > 0) {
        ObjectPoint objects[header.object1Count] @ header.table1Offset;
    } else {
        ObjectPoint objects[header.object1Count];
    }
    if (header.pointerCount > 8) {
        Table2 tbl2 @ header.table2Offset;
    }
    if (header.pointerCount > 9) {
        u32 tbl3 @ header.table3Offset;
    }
    Table4Entrys tbl4 @ header.table4Offset;
    BoneInfo bones[header.boneCount] @ header.boneOffset;
    VPT tex @ gOffsetTo;
    BoneHeader author @ header.boneHeaderOffset;
    //u8 texture[header.boneHeaderOffset - header.textureTableOffset] @ header.textureTableOffset;
};

u32 gOffsetTo @ 0x24;
VMP gModel @ 0;
