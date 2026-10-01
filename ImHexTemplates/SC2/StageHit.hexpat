struct subsection1{
u16 unk0;
u16 unk1;
u16 unk2;
u16 unk3;
u32 unk4;
u32 unk5;
};
struct subsection2{
float val1;
float val2;
s16 values[28];
};

struct hdr{
u32 magic;
float values[6];
u16 size1;
u16 val2;
u16 size2;
u16 val4;
u32 fileSize;
u64 date;
};

struct StageHit{
hdr header;
subsection1 sec1[header.size1];
subsection2 sec2[header.size2];

};

StageHit test @ 0;