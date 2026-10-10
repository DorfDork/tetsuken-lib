struct KHeader {
    u32 magic;
    u8 day;
    u8 month;
    u16 year;
    u8 sec;
    u8 min;
    u16 hour;
    u16 numEntries;
    u16 unk4;
    u32 attackList;
    u32 throwInfo;
    u16 moveGrpIdx1;
    u16 moveGrpCount1;
    u16 moveGrpIdx2;
    u16 moveGrpCount2;
    u16 hurtIdx;
    u16 hurtCount;
    u16 neutralIdx;
    u16 neutralCount;
};

u32 gAttackCount = 0;
u32 gGrabCount = 0;

struct Moves {
    s16 motionIdx;
    u16 unkMotion;
    u32 unk1;
    float motionMultiplier;
    float speedMultiplier;
    u32 unk2;

    u32 unk3;
    u32 unk4;
    float unk5;

    u32 unk6;
    u32 unk7;
    u32 unk8;
    u32 unk9;

    float unknownMultiplier;
    s16 frameCount;
    u16 frameCountUnk;
    u32 cancelAddress;
    u8 test @ cancelAddress;
    u32 attackIndex;
    if (attackIndex < 0xFFFFFFFF) {
        if (attackIndex & 0x1000) {
            gGrabCount = gGrabCount + 1;
        } else {
            gAttackCount = gAttackCount + 1;
        }
    }
};

struct Vec3Short {
    s16 x;
    s16 y;
    s16 z;
};

struct Attacks {
    u32 hitbox;
    u16 unk1;
    u16 unk2;

    Vec3Short normalVec;
    Vec3Short normalLaunchVec;
    Vec3Short counterVec;
    Vec3Short counterLaunchVec;
    Vec3Short airborneVec;
    Vec3Short blockVec;
    Vec3Short groundedVec;

    u16 type;
    u16 notsure;
    u16 start;
    u16 active;
    s16 damage;
    u16 activeNot;
    u16 notDmg;

    u16 blockStun;
    u16 hitStun;
    u16 counterStun;
    u16 unsure2;
    u16 dmgType;
    u16 counterType;
    u16 unk3;
    u16 unk4;
    u32 unk5;
    u32 unk6;
};

struct KHFile {
    KHeader hdr;
    Moves chunks[hdr.numEntries];
    Attacks aChunk[gAttackCount];
    u16 grabs[gGrabCount];
};

KHFile gFile @ 0;
