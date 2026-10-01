u32 curStriptOff = 0;
struct vec3short{
s16 x;
s16 y;
s16 z;
};

struct MotHurt{
    u64 hurtbox;
    vec3short normal_vec;
    vec3short normal_launch_vec;
    vec3short counter_vec;
    vec3short counter_launch_vec;
    vec3short airborne_vec;
    vec3short block_vec;
    vec3short grounded_vec;
    
    s16 hitType;
    s16 Unk34;
    s16 start;
    s16 active;
    s16 dmg;
    s16 activeNOT;
    s16 not_dmg;
    
    s16 block_stun;
    s16 hit_stun;
    s16 counter_stun;
    s16 Unk46;
    s16 dmg_type;
    s16 counter_type;
    s16 Unk4C;
    s16 Unk4E;
    u32   Unk50;
    u32   Unk54;
    u32   Unk58;
    u32   Unk5C;
};
struct MotItem{
    u16 AnimIdx;
    u16 Unk02;
    u32 Unk04;
    u32 SpeedWeapon;
    u32 SpeedAnim;
    u16 TransAnimIdx;
    u16 Unk12;
    u32 Unk14;
    u32 Unk18;
    u8 _p0[0x14];
    u32 SpeedMove;
    u32 Frames;
    u32 Unk38;
    u8 _p1[0x14];
    u32 ScriptPtr;
    u8 test @ ScriptPtr+curStriptOff;
    u32 Unk54;
    u16 HitBoxIdx;
    u16 Unk5A;
    u8 _p2[4];
};
struct MotInfo
{
    u16 Idx;
    u16 Count; 
    u32 Unk04; 
    u32 ItemsOffset;
    u32 ScriptOffset;
    u32 HitboxOffset;
    u32 GrabDmgOffset;
    u32 FileSize;
    u32 Unk1C;
    u32 InfoCount;
    u8 Unk24[0x80];
};
struct MotHeader {
    u16 Unk0;
    u16 MotCount;
    char Tag[0x20]; // shift-jis encoding
    u32 Unk24; // Magic Hash idk
    MotInfo Normal;
    MotInfo Enshutsu;
    MotInfo Yarare;
    MotInfo Sub;
    u32 Unk2B8;
    u32 HitboxCount;
    u32 GrabDmgCount;
    u32 Unk2C4;
    u32 Unk2C8;
};

struct Moveset{
MotHeader hdr;
u32 hdrSize = sizeof(hdr);
curStriptOff = hdr.Normal.ScriptOffset;
MotItem Normal[hdr.Normal.Count] @ hdrSize+(0x60*hdr.Normal.Idx);

curStriptOff = hdr.Enshutsu.ScriptOffset;
MotItem Enshutsu[hdr.Enshutsu.Count] @ hdrSize+(0x60*hdr.Enshutsu.Idx);

curStriptOff = hdr.Yarare.ScriptOffset;
MotItem Yarare[hdr.Yarare.Count] @ hdrSize+(0x60*hdr.Yarare.Idx);

curStriptOff = hdr.Sub.ScriptOffset;
MotItem Sub[hdr.Sub.Count] @ hdrSize+(0x60*hdr.Sub.Idx);


MotHurt HBoxes[hdr.HitboxCount] @ hdr.Normal.HitboxOffset;
//MotItem items[hdr.MotCount];
};

Moveset moves @ 0;