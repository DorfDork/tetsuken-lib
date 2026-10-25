#pragma array_limit 0x100000

import std.core;
import std.mem;

struct CategoryEntry {
    u16 setup;
    u16 command;
};

struct MLC {
    u16 entryCount;
    padding[2];
    CategoryEntry entries[entryCount];
};

u16 gProbe @ 0 [[hidden]];
if (gProbe > 0xFF) {
    std::core::set_endian(std::mem::Endian::Big);
} else {
    std::core::set_endian(std::mem::Endian::Little);
}

MLC gFile @ 0;
