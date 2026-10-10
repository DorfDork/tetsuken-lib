import std.core;
import std.mem;

struct DTPSlot {
    u32 offset;
    u32 end @ $ [[hidden]];
    if (end > offset) {
        u8 file[end - offset] @ offset;
    }
};

struct DTP {
    u32 count;
    DTPSlot slots[count];
    u32 end;
};

u32 gProbe @ 0 [[hidden]];
if (gProbe > 0xFFFF) { // check if dtp file is big endian
    std::core::set_endian(std::mem::Endian::Big);
} else {
    std::core::set_endian(std::mem::Endian::Little);
}

DTP gDtp @ 0;
