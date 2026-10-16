import std.core;
import std.mem;

struct CameraFrame {
    float point1[3];
    float point2[3];
    float fov;
};

struct CAM {
    u16 unk0;
    u16 kind;
    u16 frameCount;
    u16 pad;
    float unk8;
    u32 unkC;
    u32 unk10;
    u32 unk14;
    u32 dataSize;
    u32 unk1C;
    CameraFrame frames[frameCount];
};

u16 gProbe @ 2 [[hidden]];
if (gProbe > 0xFF) {
    std::core::set_endian(std::mem::Endian::Big);
} else {
    std::core::set_endian(std::mem::Endian::Little);
}

CAM gFile @ 0;
