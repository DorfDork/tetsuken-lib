#pragma array_limit 0x100000

import std.core;
import std.mem;

struct CommandName {
    u16 command;
    u16 offset;
    char name[0x20];
    u32 unk24;
    u16 unk28;
    u16 unk2A;
    u16 unk2C;
    u8 unk2E;
    u8 unk2F;
};

struct CPN {
    u32 commandCount;
    CommandName commands[commandCount];
};

u32 gProbe @ 0 [[hidden]];
if (gProbe > 0xFFFF) {
    std::core::set_endian(std::mem::Endian::Big);
} else {
    std::core::set_endian(std::mem::Endian::Little);
}

CPN gFile @ 0;
