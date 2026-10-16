import std.core;
import std.mem;

enum LightType : u8 {
    ERROR            = 0,
    SPECULAR         = 1,
    PARALLEL         = 2,
    POINT            = 3,
    REFLECTION_COLOR = 4,
    AMBIENT          = 5,
    CAMERA_PARALLEL  = 6,
    AREA_PARALLEL    = 7,
    PSEUDO_POINT     = 8,
    SUNLIGHT         = 9,
    SUNLIGHT_SLAVE   = 10
};

bitfield LightLists {
    stage : 1;
    list2 : 1;
    list3 : 1;
    list4 : 1;
    unk4  : 27;
    mask  : 1;
} [[bitfield_order(std::core::BitfieldOrder::LeastToMostSignificant, 32)]];

struct HSV {
    float hue;
    float saturation;
    float value;
};

struct HSVA {
    float hue;
    float saturation;
    float value;
    float alpha;
};

struct SpecularParams {
    float unk50;
    u8 unused54[8];
    u32 followMainLight;
    u8 unused60[0x24];
};

struct ParallelParams {
    u8 unused50[0xC];
    u32 slot;
    u8 unused60[0x24];
};

struct CameraParallelParams {
    u8 unk50;
    u8 unk51;
    u8 unused52[0xA];
    u32 slot;
    u8 unused60[0x24];
};

struct AreaParallelParams {
    float unk50;
    u8 unused54[8];
    u32 slot;
    u8 unused60[4];
    float unk64[4];
    u8 unused74[0x10];
};

struct PseudoPointParams {
    float unk50;
    u8 unused54[8];
    u32 slot;
    u32 unk60;
    u8 unused64[0x20];
};

struct SunlightParams {
    u8 unused50[0x10];
    float unk60;
    float unk64;
    u8 unused68[0x1C];
};

struct Light {
    float elevation;
    float azimuth;
    u8 unused08[8];
    HSVA color;
    LightLists lists;
    LightType type;
    u8 unk25;
    u8 unk26;
    u8 unused27;
    u8 unk28;
    u8 unused29[7];
    float vector[3];
    float unk3C;
    u8 unused40[0x10];
    if (type == LightType::SPECULAR) {
        SpecularParams params;
    } else if (type == LightType::PARALLEL) {
        ParallelParams params;
    } else if (type == LightType::CAMERA_PARALLEL) {
        CameraParallelParams params;
    } else if (type == LightType::AREA_PARALLEL) {
        AreaParallelParams params;
    } else if (type == LightType::PSEUDO_POINT) {
        PseudoPointParams params;
    } else if (type == LightType::SUNLIGHT) {
        SunlightParams params;
    } else {
        u8 unused50[0x34];
    }
    float unk84;
    float unk88;
    float unk8C;
    u8 unused90[0x14];
    char name[12];
};

struct LHT {
    u8 lightCount;
    u8 version;
    u16 fog;
    HSVA fogColor;
    float fogNear;
    float fogFar;
    float fogNearDensity;
    float fogFarDensity;
    u8 unused24[0x2C];
    Light lights[lightCount];
    u8 unusedLights[(32 - lightCount) * 0xB0];
    HSV clearColor;
    u8 unused165C[0x24];
};

u8 gProbe @ 0x70 [[hidden]];
if (gProbe == 0x80 || gProbe == 0) {
    std::core::set_endian(std::mem::Endian::Big);
} else {
    std::core::set_endian(std::mem::Endian::Little);
}

LHT gFile @ 0;
