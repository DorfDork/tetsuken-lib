import std.io;
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
bitfield VIFCODE
{
     imdt : 16;
     num  : 8;
     cmd  : 8;
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

struct addressTable{
    dma_tag_t values[while(std::mem::read_unsigned($, 4) != 0x60000000)];
    dma_tag_t end;
};
struct addrCnt{
dma_tag_t val;
match(val.ID){
    (DmaTagType::P2_DMA_TAG_REF):u128 data[val.QWC] @ val.ADDR;
}

};
struct addressTableMdl{
    addrCnt values[while(std::mem::read_unsigned($, 4) != 0x60000000)];
    dma_tag_t end;
};
struct Pallet{
    u32 color[256];
};
struct TextureSlice{
    u32 stuff[24];
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
DimentionEnt texture @ offsetto + offset-(offset%0x10);
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
u32 address2;
textable textures[textureCount] @ offsetto + address2;
//u32 testa2[textureCount] @ offsetto+address2;
u32 address3;//End of file
u32 testa3 @ offsetto+address3;
u32 address4;//End of file
u32 testa4 @ offsetto+address4;
padding[8];
//u32 address5;
//u32 testa5 @ offsetto+address5;
//textable *texturesAlt[textureCount] : u32;
u32 trueDmaCount = dmaCount ? dmaCount * 2 : (offsetCount == 6) ;
u32 trueTextureCount = textureCount ? textureCount * 2 : (offsetCount == 6) ;
addressTable textureInfo[trueDmaCount];
TextureEntry textEnt[while(std::mem::read_unsigned($, 4) == 268435462)];
//DimentionEnt dimmy[trueCountTextures];
//Pallet pallets[textureCount];

};

struct tVector4f{
    float X;
    float Y;
    float Z;
    float W;
}[[static,name(std::format("{},{},{},{}", X, Y, Z, W))]];
struct tVector3f{
    float X;
    float Y;
    float Z;
}[[static,name(std::format("{},{},{}", X, Y,Z))]];


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
};
struct cmd11{
u8 val[4];
};
struct TableC{
    u32 currentoff = $;
    
    u8 type;
    u8 size;
    u8 unk0;
    u8 unk1;
    u32 trueSize = currentoff + size;
    match(type){
        (3):{
            DimentionEnt * textureEntry0 : u32;
            DimentionEnt * textureEntry1 : u32;
            float f1;
            float f2;
        }
        (5):{
            addressTableMdl * ModelDma : u32;
        }
    }
    padding[trueSize-$];
    
};
struct TableCPoint{
u32 offset;
TableC Entry[while(std::mem::read_unsigned($, 1) != 0)] @ offset;
};
struct TableB{
    u8 unk0;
    u8 unk1;
    u8 unk2;
    u8 unk3;
    TableCPoint Entry;
};
struct TableBPoint{
u32 offset;
TableB entry @ offset;
};
struct objectLayer{
    u8 type;
    u8 count;
    u8 unk0;
    u8 LayerCount;
    match(type){
    (1):{
        u8 indices[LayerCount];
        padding[32-LayerCount];
    }
    (2):{
        u32 i;
        float f1;
        float f2;
    }
        (3):{
        float f;
        u32 i1;
        u32 i2;
        u32 i3;
    }
        (4):{
        u32 v[39];
        }
    }
    u32 unk1;
    TableBPoint Entrys[count];
};
struct objectPoint{
u32 offset;
objectLayer Layer @ offset;
};

struct table2{
u32 unk0;
u32 unk1;
u32 unk2;
};

struct Header{
    u32 Type;
    u8 Unk04;
    u8 Unk05;
    u8 Unk06;
    u8 Unk07;
    u16 Object1Count;
    u16 BoneCount;
    u32 VertCount;
    //padding[16]; //SC3 Specal
    u32 BoneOffset;
    u32 tex_file_addr;
    u32 Object1Offset;
    u32 table5_addr;
    u32 table4_addr;
    u32 BoneHeaderOffset;
    //u32 unk016;

};
struct table4{
    u8 type;
    u8 count;
    u8 unk0;
    u8 unk1;
    match(type){
        (1):u32 val;
        (2):u32 val[2];
        (3):u32 val;
        (4):u32 val;
        (6):u32 val;
        (7):{
            u8 indexes[count];
            padding[0x20-count];
        }
        (8):u32 val;
        (9):u32 val;
        (10):u32 val;
        (11):u32 val;
        (16):{
            u8 indexes[count];
            padding[0x20-count];
        }
    }
};
struct table4Entrys{
table4 Entry[while(std::mem::read_unsigned($, 1) != 0)];
padding[4];
};

struct VMP{
Header HDR;
objectPoint Objects[HDR.Object1Count];
//table2 tbl2 @ HDR.table2_addr;
//u32 tbl3 @ HDR.table3_addr;
table4Entrys tbl4 @  HDR.table4_addr;
boneInfo Bones[HDR.BoneCount] @ HDR.BoneOffset;
VPT tex @ offsetto;
//u8 texture[HDR.BoneHeaderOffset - HDR.tex_file_addr] @ HDR.tex_file_addr;
};
u32 offsetto @ 0x14;
VMP model @ 0;