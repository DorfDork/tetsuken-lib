#pragma array_limit 0x100000
#pragma pattern_limit 0x400000

import std.core;
import std.mem;

bitfield Step {
    value : 16;
    op    : 16;
} [[bitfield_order(std::core::BitfieldOrder::LeastToMostSignificant, 32)]];

std::mem::Endian gEndian = std::mem::Endian::Little;

fn block_start(u128 address) {
    return (std::mem::read_unsigned(address, 4, gEndian) >> 16) == 8;
};

struct CommandBlock {
    Step header;
    Step steps[while(!std::mem::eof() && !block_start($))];
};

u32 gProbe @ 0 [[hidden]];
if ((gProbe >> 16) != 8) {
    gEndian = std::mem::Endian::Big;
}
std::core::set_endian(gEndian);

CommandBlock gBlocks[while(!std::mem::eof())] @ 0;
