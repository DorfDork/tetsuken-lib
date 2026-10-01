struct KHeader{
    u32 magic;
    u8 day;
    u8 month;
    u16 year;
    u8 sec;
    u8 min;
    u16 hour;
    u16 numEntries;
    u16 unk4;
    u32 unkOffset0;
    u32 unkOffset1;
    u16 unk5;
    u16 unk6;
    u16 unk7;
    u16 unk8;
    u16 hurtIdx;
    u16 unk9;
    u16 neutralIdx;
    u16 unkA;
};
struct smallbit{
u32 unk0;
u32 unk1;
u32 unk2;
u32 unk3;
};
struct largebit{
smallbit unkpack[5];
u32 tail0;
u32 tail1;
};
struct headsec{
smallbit test[4];
};
struct somthingIdkName {
    u16 unk01;
    u16 unk02;
    u32 unk03;
    u32 unk04;
    u32 unk05;
    u16 unk06;
    u16 unk07;
    u8 unk08;
    u8 unk09;
    u8 unk10;
    u8 unk11;
    u32 unk12;
    u32 unk13;
    u32 unk14;
    u32 unk15;
    u32 unk16;
    u32 unk17;
    u32 unk18;
    u16 unk19;
    u16 unk20;
    u32 unk21;
    u32 hboxId;
};
struct KHFile{
KHeader hdr;
headsec chunks[hdr.numEntries];

};

KHFile file @ 0;