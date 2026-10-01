import std.mem;

fn fixy(u32 a){
    u32 rem = a % 0x10;
    if(rem>0)
        return a - rem;
    else
        return a;
};

struct dmaTable{
u32 Tag;
u32 EntryOffset;
padding[8];
};
/** Destination chain tag. */
enum DmaTagType : u64
{
    /** Transfers the QWC qword from the ADDR field, clears the Dn_CHCR.STR to 0, and ends transfer. */
    P2_DMA_TAG_REFE = 0,
    /** Transfers the QWC qword following the tag and reads the succeeding qword as the next tag. */
    P2_DMA_TAG_CNT = 1,
    /** Transfers the QWC qword following the tag and reads the qword of the ADDR field as the next tag. */
    P2_DMA_TAG_NEXT = 2,
    /** Transfers the QWC qword from the ADDR field and reads the qword following the tag as the next tag.  */
    P2_DMA_TAG_REF = 3,
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
    P2_DMA_TAG_RET = 6,
    /** Transfers the QWC qword following the tag, clears the Dn_CHCR.STR to 0, and ends transfer. */
    P2_DMA_TAG_END = 7
};
enum psm_types : u32{
GS_TEX_32 =          0,
GS_TEX_24 =          1,
GS_TEX_16 =          2,
GS_TEX_16S =        10,
GS_TEX_8 =         19,
GS_TEX_4 =         20,
GS_TEX_8H =         27,
GS_TEX_4HL =        36,
GS_TEX_4HH =        44
};
enum GsTexFunctions : u32{
    GS_TEX_MODULATE     =0,    /** brighten texture based on Pixel's Alpha */
    GS_TEX_DECAL,           /** keep texture as is */
    GS_TEX_HIGHLIHGT1,      /** used when highlighting translucent polygons */
    GS_TEX_HIGHLIHGT2       /** used when highlighting opaque polygons */
};

bitfield GS_TEX0 {
    tb_addr     :14;
    tb_width        :6;
    psm_types psm     :6;
    tex_width       :4;
    tex_height  :4;
    tex_cc      :1;
    GsTexFunctions tex_funtion :2;
    cb_addr     :14;
    clut_pixmode    :4;
    clut_smode  :1;
    clut_offset :5;
    clut_loadmode   :3;

};
bitfield GS_BITBLTBUF {
    src_addr      :14;
    pad1          :2;
    src_width     :6;
    pad2          :2;
    src_pixmode :6;
    pad3          :2;
    dest_addr     :14;
    pad4          :2;
    dest_width  :6;
    pad5          :2;
    dest_pixmode:6;
    pad6          :2;
};
bitfield GS_TRXPOS {
    src_x       :11;
    pad1        :5;
    src_y       :11;
    pad2        :5;
    dest_x  :11;
    pad3        :5;
    dest_y  :11;
    direction   :2;
    pad4        :3;
};
bitfield GS_TRXREG {
    trans_w :12;
    pad1        :20;
    trans_h :12;
    pad2        :20;
};
bitfield GS_TRXDIR {
    trans_dir   :2;
    pad1        :62;
};
bitfield GS_PRIM {
    prim_type   :3;
    iip     :1;
    tme     :1;
    fge     :1;
    abe     :1;
    aa1     :1;
    fst     :1;
    ctxt        :1;
    fix     :1;
    pad1        :53;
};
bitfield dma_tag_t
{
    /** Quadword count. */
     QWC : 16;
     PAD : 10;
    /** 
     * Priority Control Enable. 
     * 00 Nothing performed 
     * 01 Reserved 
     * 10 Priority setting disabled (D_PCR.PCE = 0) 
     * 11 Priority setting enabled (D_PCR.PCE = 1) 
     */
     PCE : 2;
    /** Tag ID. (look at DmaTagType) */
     DmaTagType ID : 3;
    /** 
     * Interrupt Request. 
     * 0 No interrupt request 
     * 1 Interrupt request at end of packet transfer 
     */
     IRQ : 1;
    /** 
     * Address. 
     * Address of packet or next tag instruction 
     * (With qword alignment, lower 4 bits become 0.) 
     */
     ADDR : 31;
    /** 
     * Memory/SPR Selection. 
     * 0 Memory address 
     * 1 SPR address 
     */
     SPR : 1;
     OPT1 : 32;
     OPT2 : 32;
};
bitfield GS_GIF_TAG {
    nloop   :15;
    eop :1;
    pad1    :30;
    pre :1;
    prim    :11;
    flg :2;
    nreg    :4;
    u64 reg;
};
enum GS_TYPE : u64{
GS_PRIM = 0x00,
GS_RGBAQ = 0x01,
GS_ST = 0x02,
GS_UV = 0x03,
GS_XYZF2 = 0x04,
GS_XYZ2 = 0x05,
GS_TEX0_1 = 0x06,
GS_TEX0_2 = 0x07,
GS_CLAMP_1 = 0x08,
GS_CLAMP_2 = 0x09,
GS_FOG = 0x0A,
GS_XYZF3 = 0x0C,
GS_XYZ3 = 0x0D,
GS_TEX1_1 = 0x14,
GS_TEX1_2 = 0x15,
GS_TEX2_1 = 0x16,
GS_TEX2_2 = 0x17,
GS_XYOFFSET_1 = 0x18,
GS_XYOFFSET_2 = 0x19,
GS_PRMODECONT = 0x1A,
GS_PRMODE = 0x1B,
GS_TEXCLUT = 0x1C,
GS_SCANMSK = 0x22,
GS_MIPTBP1_1 = 0x34,
GS_MIPTBP1_2 = 0x35,
GS_MIPTBP2_1 = 0x36,
GS_MIPTBP2_2 = 0x37,
GS_TEXA = 0x3B,
GS_FOGCOL = 0x3D,
GS_TEXFLUSH = 0x3F,
GS_SCISSOR_1 = 0x40,
GS_SCISSOR_2 = 0x41,
GS_ALPHA_1 = 0x42,
GS_ALPHA_2 = 0x43,
GS_DIMX = 0x44,
GS_DTHE = 0x45,
GS_COLCLAMP = 0x46,
GS_TEST_1 = 0x47,
GS_TEST_2 = 0x48,
GS_PABE = 0x49,
GS_FBA_1 = 0x4A,
GS_FBA_2 = 0x4B,
GS_FRAME_1 = 0x4C,
GS_FRAME_2 = 0x4D,
GS_ZBUF_1 = 0x4E,
GS_ZBUF_2 = 0x4F,
GS_BITBLTBUF = 0x50,
GS_TRXPOS = 0x51,
GS_TRXREG = 0x52,
GS_TRXDIR = 0x53,
GS_HWREG = 0x54,
GS_SIGNAL = 0x60,
GS_FINISH = 0x61,
GS_LABEL = 0x62,
GS_NOP = 0x7F
}

struct addressTable{
    dma_tag_t values[while(std::mem::read_unsigned($, 4) != 0x60000000)];
    dma_tag_t end;
};
struct Pallet{
    u32 color[256];
};
struct TextureSlice{
    u32 stuff[4];
    GS_GIF_TAG gif_tag;
    u32 stuff2[16];
    u32 PalletLen;
    u32 count;
    padding[8];
    u16 UNK0;
    u16 UNK1;
    u32 PalletOffset;
    padding[8];
    //u8 data[PalletLen] @ PalletOffset;
};
u32 trueCountTextures = 0;
struct TextureEntry{
    TextureSlice slices[2];
    u32 footer[4];
    trueCountTextures = trueCountTextures + 1;
    //Lets use what the DMA uses!
    u128 tex[slices[0].UNK0] @ slices[0].PalletOffset+offsetto;
    u128 pal[slices[1].UNK0] @ slices[1].PalletOffset+offsetto;
};
struct DimentionEnt{
    u8 stuff[0x20];
    GS_TEX0 test;
    u8 stuff2[0x18];
    };
struct textable{
u32 offset;
DimentionEnt texture @ offset-(offset%0x10);
};
struct VPT{
u8 byteMagic;
u8 offset2DMAs;
u8 offsetCount;
u8 reserved;
u8 dmaCount;
u8 textureCount;
u8 extendedTexCount;
u8 idk2;
u32 address1;
u32 testa1 @ offsetto+address1;
//u32 address2;
textable *textures[textureCount] : u32;
//u32 testa2[textureCount] @ offsetto+address2;
u32 address3;//End of file
u32 testa3 @ offsetto+address3;
u32 address4;//End of file
u32 testa4 @ offsetto+address4;
padding[8];
//u32 address5;
//u32 testa5 @ offsetto+address5;
//textable *texturesAlt[textureCount] : u32;
u32 trueDmaCount = dmaCount;
u32 trueTextureCount = textureCount ? textureCount * 2 : (offsetCount == 6) ;
addressTable textureInfo[trueDmaCount];
TextureEntry textEnt[while(std::mem::read_unsigned($, 4) == 268435462)];
//DimentionEnt dimmy[trueCountTextures];
//Pallet pallets[textureCount];

};
//u32 offsetto @ 0x14;
u32 offsetto = 0;
VPT file @ offsetto;