import std.core;
import std.mem;

struct CameraEntry {
    char motion[0x20];
    char camera[0x10];
    u16 path;
    u16 group;
    u16 unk34;
    u16 unk36;
    u16 unk38;
    u16 unk3A;
};

struct CTB {
    CameraEntry entries[64];
};

u16 gProbe @ 0x3A [[hidden]];
if (gProbe > 0xFF) {
    std::core::set_endian(std::mem::Endian::Big);
} else {
    std::core::set_endian(std::mem::Endian::Little);
}

CTB gFile @ 0;
