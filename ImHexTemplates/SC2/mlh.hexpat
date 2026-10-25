import std.core;
import std.mem;

struct MLH {
    u16 commandCount;
    padding[0x0E];
};

u16 gProbe @ 0 [[hidden]];
if (gProbe > 0xFFF) {
    std::core::set_endian(std::mem::Endian::Big);
} else {
    std::core::set_endian(std::mem::Endian::Little);
}

MLH gFile @ 0;
