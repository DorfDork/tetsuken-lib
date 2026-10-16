import std.core;
import std.mem;

bitfield Date {
    day   : 8;
    month : 8;
    year  : 16;
} [[bitfield_order(std::core::BitfieldOrder::LeastToMostSignificant, 32)]];

bitfield Time {
    second : 8;
    minute : 8;
    hour   : 16;
} [[bitfield_order(std::core::BitfieldOrder::LeastToMostSignificant, 32)]];

struct MotionSource {
    u16 fighter;
    u16 stage;
    Date date;
    Time time;
    u32 nameOffset;
    char name[] @ nameOffset;
};

u32 gProbe @ 4 [[hidden]];
if (gProbe > 0xFFFF) {
    std::core::set_endian(std::mem::Endian::Big);
} else {
    std::core::set_endian(std::mem::Endian::Little);
}

u32 gFirstName @ 0x1C [[hidden]];

struct MOI {
    u32 hash;
    u32 namesEnd;
    u32 unk8;
    u32 unkC;
    MotionSource sources[(gFirstName - 0x10) / 0x10];
};

MOI gMoi @ 0;
