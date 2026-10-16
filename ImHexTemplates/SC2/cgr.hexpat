import std.core;
import std.mem;

struct CameraGroup {
    char name[0x10];
    u16 entryCount;
    u16 unk12;
    u16 unk14;
    u16 unk16;
    u16 entries[8];
};

struct CGR {
    u16 unk0;
    u16 groupCount;
    u32 pad;
    CameraGroup groups[groupCount];
};

u16 gProbe @ 0 [[hidden]];
if (gProbe > 0xFF) {
    std::core::set_endian(std::mem::Endian::Big);
} else {
    std::core::set_endian(std::mem::Endian::Little);
}

CGR gFile @ 0;
