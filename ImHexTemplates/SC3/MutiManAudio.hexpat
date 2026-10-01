import std.core;
import std.io;
import std.mem;
import type.magic;

struct Header{
char MAGIC[4];
u32 size;
u8 unk1;
u8 unk2;
u16 unk3;
u32 unk4;
u32 unk5;
u32 count;
};
struct PHDent{
u16 index;
u32 unk0;
u16 unk1;
s16 unk2_loop;
padding[6];
u64 unk3;
u32 freqency;
u32 unk4;
u64 unk5;
u32 unk6;
float unk7;
u64 unk8;
u32 size;
u32 offset;

float unk10;
float unk11;
u64 unk12;
};
struct PHDp{
char MAGIC[4];
u16 ver;
u16 unk0;
u16 count;
u8 unk1;
u8 unk2;
u32 dataSize;
PHDent entrys[count];

};
struct Entry{
u32 HeaderOffset;
u32 HeaderSize;
u32 DataOffset;
u32 DataSize;
PHDp Header @ HeaderOffset;
u8 DATA[DataSize] @ DataOffset;
};
struct MMA{
Header HDR;
Entry ents[HDR.count];
};
u32 magic @ 0 [[hidden]];
if(magic == 6778221){
    std::core::set_endian(std::mem::Endian::Big);
}else{
    std::core::set_endian(std::mem::Endian::Little);
};

MMA file @ 0;