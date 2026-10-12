import std.core;

struct Row {
    u16 floorFirst;
    u16 floorCount;
    u16 wallFirst;
    u16 wallCount;
    u32 end;
    u32 pad;
};

struct Cell {
    float start;
    float end;
    s16 triangles[28];
};

enum HitSurface : u8 {
    FLOOR = 0x0,
    WALL  = 0x1
};

enum HitMaterial : u8 {
    STONE          = 0x0,
    PEBBLE         = 0x1,
    WOOD           = 0x2,
    SOIL           = 0x3,
    WATER          = 0x4,
    GRASS          = 0x5,
    WIRE           = 0x6, // unused in sc2
    METAL          = 0x7,
    CARPET         = 0x8,
    ICE            = 0x9,
    LAVA           = 0xA,
    SAND           = 0xB,
    RINGOUT        = 0xC,
    OOB            = 0xD,
    LEVEL_BOUNDARY = 0xE
};

bitfield SurfaceFlags {
    HitSurface surface   : 1;
    unk1                 : 1;
    breakable            : 1;
    HitMaterial material : 4;
    unk7                 : 1;
    unk8                 : 20;
    unk28                : 4; // always 3
} [[bitfield_order(std::core::BitfieldOrder::LeastToMostSignificant, 32)]];

bitfield CeilingFlags {
    ceilingMagic : 12;
    lightCast    : 4;
    ringout      : 4;
    unk20        : 4;
    ringout2     : 4;
    mainWall     : 4;
} [[bitfield_order(std::core::BitfieldOrder::LeastToMostSignificant, 32)]];

struct TriangleFlags {
    u32 ceilingCheck @ $ [[hidden]];
    if ((ceilingCheck & 3) == 3) {
        CeilingFlags ceiling;
    } else {
        SurfaceFlags surface;
    }
};

struct Triangle {
    float a[3];
    TriangleFlags flags;
    float b[3];
    u32 unk1C;
    float c[3];
    u16 unk2C;
    u16 unk2E;
    float normal[3];
    float distance;
};

struct Hdr {
    float cellSize;
    float boundsMin[2];
    float boundsMax[2];
    float boundsSize[2];
    u16 rowCount;
    u16 triangleCount;
    u16 cellCount;
    u16 unk22;
    u32 fileSize;
    u8 day;
    u8 month;
    u16 year;
    u8 second;
    u8 minute;
    u16 hour;
};

struct SHZ {
    Hdr header;
    Row rows[header.rowCount];
    Cell cells[header.cellCount];
    Triangle triangles[header.triangleCount];
};

SHZ gShz @ 0;
