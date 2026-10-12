struct OLKEntry { // 16 Bytes
    u32 addr;     // relative to data buffer start
    u32 size;     // relative
    u32 unixTime; // accumlated seconds since January 1, 1970
    u32 reserved2;
};

struct OLK {
    u32 dataCount;
    char magic[4];
    u32 alignment;
    u32 reserved1;
    OLKEntry dataInfo; // First Entry describes bounds of the data buffer
    OLKEntry files[dataCount];
};

OLK gOlk @ 0;
