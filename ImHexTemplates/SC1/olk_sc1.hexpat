struct OLKEntry { // 8 Bytes
    u32 addr; // relative to data buffer start
    u32 size; // relative
};

struct OLK {
    u32 dataCount;
    char olkId[4];
    u32 alignment;
    u32 reserved1;
    OLKEntry dataInfo; // First Entry describes bounds of the data buffer
    OLKEntry entrys[dataCount];
};

OLK gOlk @ 0;
