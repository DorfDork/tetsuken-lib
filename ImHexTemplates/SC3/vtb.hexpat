struct Effect {
    s16 frame;
    s16 bank;
    s16 wave;
    s16 pad;
};

struct Entry {
    u32 unk0;
    Effect effects[16];
};

struct Group {
    u32 first;
    u32 count;
};

struct Header {
    char magic[4];
    u32 size;
    u8 day;
    u8 month;
    u16 year;
    u8 second;
    u8 minute;
    u8 hour;
    u8 pad;
    u32 version;
    u32 count;
    u32 entriesOffset;
    u32 groupCount;
};

struct VTB {
    Header hdr;
    Group groups[hdr.groupCount];
    Entry entrys[hdr.count] @ hdr.entriesOffset;
};

VTB gFile @ 0;
