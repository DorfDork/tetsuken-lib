import std.core;
import std.mem;

enum ShapeType : u16 {
    SPHERE  = 0,
    SEGMENT = 1,
    END     = 0xFFFF
};

enum CollisionSlot : u32 {
    NONE        = 0,
    ROOT        = 1,
    MUNE1       = 2,
    MUNE2       = 3,
    KUBI        = 4,
    ATAMA       = 5,
    SAKOTSU_R   = 6,
    KATA_R      = 7,
    UDE_R       = 8,
    TE_R        = 9,
    SAKOTSU_L   = 10,
    KATA_L      = 11,
    UDE_L       = 12,
    TE_L        = 13,
    KOSHI       = 14,
    MOMO_R      = 15,
    HIZA_R      = 16,
    ASHI_R      = 17,
    TSUMASAKI_R = 18,
    MOMO_L      = 19,
    HIZA_L      = 20,
    ASHI_L      = 21,
    TSUMASAKI_L = 22,
    BUKI_1      = 23,
    BUKI_2      = 24,
    BUKI_3      = 25,
    BUKI_4      = 26,
    BUKI_5      = 27,
    BUKI_6      = 28,
    BUKI_7      = 29,
    BUKI_8      = 30,
    BUKI_9      = 31,
    BUKI_10     = 32
};

struct Sphere {
    float offset[3];
    float radius;
    float unk18;
    CollisionSlot bone;
};

struct Point {
    float offset[3];
    CollisionSlot bone;
};

struct Shape {
    ShapeType type;
    u16 group;
    u32 pad;
    if (type == ShapeType::SPHERE) {
        Sphere sphere;
    } else if (type == ShapeType::SEGMENT) {
        Point points[2];
    }
};

struct COL {
    Shape shapes[while (std::mem::read_unsigned($, 2) != 0xFFFF)];
    Shape end;
};

u32 gProbe @ 0x1C [[hidden]];
if (gProbe > 0xFFFF) {
    std::core::set_endian(std::mem::Endian::Big);
} else {
    std::core::set_endian(std::mem::Endian::Little);
}

COL gFile @ 0;
