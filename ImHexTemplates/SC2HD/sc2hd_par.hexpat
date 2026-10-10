#pragma endian big

u32 gAligment = 0x20;

struct Achared {
    char string[gAligment];
};

struct Header {
    char magic[3];
    u8 subVer;
    match (subVer) {
        (0): u8 ver;
        (1): u16 ver;
        (2): u32 ver;
    }

    if (ver == 3) {
        gAligment = 0x80;
    }
    u32 count;
    u32 smth;
    padding[0x10 % $];
    u32 offsets[count];
    if ($ % 0x10) {
        padding[0x10 - ($ % 0x10)];
    }
    Achared names[count];
};

Header gPar @ 0;
