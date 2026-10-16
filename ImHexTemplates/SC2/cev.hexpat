import std.core;
import std.mem;

struct CameraFrame {
    float point1[3];
    float point2[3];
    if (parent.kind & 1) {
        float fov;
    }
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

u32 gBase = 0;
u32 gNext = 0;

struct CameraSlot {
    u32 unk0;
    u32 size;
    if (size > 0) {
        if (gNext + size <= std::mem::size()) {
            CAM camera @ gNext;
            gNext += size;
        } else {
            CAM camera @ gBase;
        }
    }
};

struct CameraSet {
    u32 unk0;
    CameraSlot slots[8];
};

struct CEV {
    u32 setCount;
    gBase = $ + setCount * 0x44;
    gNext = gBase;
    CameraSet sets[setCount];
};

u32 gProbe @ 0 [[hidden]];
if (gProbe > 0xFFFF) {
    std::core::set_endian(std::mem::Endian::Big);
} else {
    std::core::set_endian(std::mem::Endian::Little);
}

CEV gCev @ 0;
