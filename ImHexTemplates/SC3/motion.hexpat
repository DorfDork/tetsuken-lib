u32 curoffset = 0;
u16 byteCountField = 0;

struct entrys{
u16 size;
u16 datahdr[(byteCountField>>1)] @ curoffset;
u8 data[(size-byteCountField)] @ curoffset + sizeof(datahdr);
curoffset = curoffset + size;
};

struct mothdr{
u16 maxFrames;
u16 numBytes;
byteCountField = numBytes;
u32 unk2;//unk + BaseRY(u16 + u16)
u64 unk3;//
u16 unk4;
u8 unk5[10];
u16 dataEntryCount;
u16 trueCount = (dataEntryCount >> 1) - 1;
curoffset = $ + (trueCount*2);
entrys dataEntrys[trueCount];
u16 ender[(byteCountField>>1)] @ curoffset;

};
struct motionHdrPointer{
mothdr * offset : u32;
};
struct header{
u32 count;
u32 unk;
//u32 newoffset;//SC1 only
motionHdrPointer offsets[count];
};

struct motion{
header hdr;
};
motion test @ 0;