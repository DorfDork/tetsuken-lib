#pragma array_limit 0x100000
#pragma loop_limit 0x100000

import std.core;
import std.mem;

fn big_endian() {
    u32 big = 0;
    u32 little = 0;
    u128 i = 0;
    while (i + 1 < std::mem::size()) {
        u8 first = std::mem::read_unsigned(i, 1);
        u8 second = std::mem::read_unsigned(i + 1, 1);
        if (first == 0 && second != 0) {
            big += 1;
        }
        if (first != 0 && second == 0) {
            little += 1;
        }
        i += 2;
    }
    return big > little;
};

if (big_endian()) {
    std::core::set_endian(std::mem::Endian::Big);
} else {
    std::core::set_endian(std::mem::Endian::Little);
}

u16 gValues[while(!std::mem::eof())] @ 0;
