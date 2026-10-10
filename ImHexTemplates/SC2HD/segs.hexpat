#pragma endian big

struct Chunk {
    u16 size;
    u16 dsize;
    u32 addr;
    u8 cdata[size] @ addr - 1;
};

struct Header {
    char magic[4];
    u16 ver;
    u16 count;
    u32 dsize;
    u32 fsize;
    Chunk chunks[count];
};

Header gSegs @ 0;
