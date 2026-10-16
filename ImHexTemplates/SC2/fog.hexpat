import std.core;
import std.mem;

struct HSV {
    float hue;
    float saturation;
    float value;
};

struct FOG {
    float near;
    float nearInvDensity;
    float far;
    float farInvDensity;
    HSV color;
    float unk1C;
    u8 unused20[0x60];
};

u8 gProbe @ 0x1C [[hidden]];
if (gProbe == 0x3F) {
    std::core::set_endian(std::mem::Endian::Big);
} else {
    std::core::set_endian(std::mem::Endian::Little);
}

FOG gFile @ 0;
