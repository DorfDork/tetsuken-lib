#pragma array_limit 0x100000

import std.core;
import std.mem;

struct CategoryEntry {
    u16 setup;
    u16 command;
    u16 text;
};

struct SC2CategoryEntry {
    u16 setup;
    u16 command;
};

fn sc3_layout() {
    u32 count = std::mem::read_unsigned(0, 2, std::mem::Endian::Little);
    if (4 + count * 6 > std::mem::size()) {
        return false;
    }
    u32 i = 0;
    while (i < count) {
        if (std::mem::read_unsigned(4 + i * 6 + 4, 2, std::mem::Endian::Little) % 5 != 1) {
            return false;
        }
        i += 1;
    }
    return true;
};

bool gSC3Layout = sc3_layout();

struct MLC {
    if (gSC3Layout) {
        u32 entryCount;
        CategoryEntry entries[entryCount];
    } else {
        u16 entryCount;
        padding[2];
        SC2CategoryEntry entries[entryCount];
    }
};

std::core::set_endian(std::mem::Endian::Little);

MLC gFile @ 0;
