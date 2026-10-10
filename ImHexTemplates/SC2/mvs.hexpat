#pragma loop_limit 1000000

import std.mem;

u32 gCurStriptOff = 0;
u32 gScriptEnd = 0;

fn script_size(u32 start) {
    u32 pos = start;
    u8 op = 0;
    bool done = false;
    while (!done && pos < gScriptEnd) {
        op = std::mem::read_unsigned(pos, 1) & 0x7F;
        if (op == 0x01 || op == 0x09 || op == 0x0A || op == 0x0B || op == 0x12 || op == 0x19 || op == 0x1A || op == 0x1B || op == 0x25 || op == 0x28 || op == 0x29 || op == 0x2A) {
            pos = pos + 3;
        } else {
            pos = pos + 1;
            if (!(op == 0x00 || op == 0x08 || op == 0x0C || op == 0x0D || op == 0x0E || op == 0x0F || op == 0x16 || (op >= 0x1F && op <= 0x24))) {
                done = true;
            }
        }
    }
    return pos - start;
};

struct Vec3Short {
    s16 x;
    s16 y;
    s16 z;
};

struct MotHurt {
    u64 hurtbox;
    Vec3Short normalVec;
    Vec3Short normalLaunchVec;
    Vec3Short counterVec;
    Vec3Short counterLaunchVec;
    Vec3Short airborneVec;
    Vec3Short blockVec;
    Vec3Short groundedVec;

    s16 hitType;
    s16 unk34;
    s16 start;
    s16 active;
    s16 dmg;
    s16 activeNot;
    s16 notDmg;

    s16 blockStun;
    s16 hitStun;
    s16 counterStun;
    s16 unk46;
    s16 dmgType;
    s16 counterType;
    s16 unk4C;
    s16 unk4E;
    u32 unk50;
    u32 unk54;
    u32 unk58;
    u32 unk5C;
};

struct MotItem {
    u16 animIdx;
    u16 unk02;
    u32 unk04;
    float speedWeapon;
    float speedAnim;
    u16 transAnimIdx;
    u16 unk12;
    u32 unk14;
    u32 unk18;
    u8 p1[0x14];
    float speedMove;
    s32 frames; // Number of frames motion runs for
    u32 unk38;
    u8 p2[0x14];
    u32 scriptPtr;
    if (scriptPtr + gCurStriptOff < gScriptEnd) {
        u8 script[script_size(scriptPtr + gCurStriptOff)] @ scriptPtr + gCurStriptOff;
    }
    u32 descriptionOffset;
    u16 hitBoxIdx;
    u16 nameOffset;
    u8 p3[4];
};

struct MotInfo {
    u16 idx;
    u16 count;
    u32 unk04;
    u32 itemsOffset;
    u32 scriptOffset;
    u32 hitboxOffset;
    u32 grabDmgOffset;
    u32 fileSize;
    u32 unk1C;
    u32 infoCount;
    u8 unk24[0x80];
};

struct MotHeader {
    u16 unk0;
    u16 motCount;
    char tag[0x20]; // shift-jis encoding
    u32 unk24;      // Magic Hash idk
    MotInfo normal;
    MotInfo enshutsu;
    MotInfo yarare;
    MotInfo sub;
    u32 unk2B8;
    u32 hitboxCount;
    u32 grabDmgCount;
    u32 unk2C4;
    u32 unk2C8;
};

struct Moveset {
    MotHeader hdr;
    gScriptEnd = hdr.normal.hitboxOffset;
    gCurStriptOff = hdr.normal.scriptOffset;
    MotItem normal[hdr.normal.count] @ hdr.normal.itemsOffset;

    gCurStriptOff = hdr.enshutsu.scriptOffset;
    MotItem enshutsu[hdr.enshutsu.count] @ hdr.enshutsu.itemsOffset;

    gCurStriptOff = hdr.yarare.scriptOffset;
    MotItem yarare[hdr.yarare.count] @ hdr.yarare.itemsOffset;

    gCurStriptOff = hdr.sub.scriptOffset;
    MotItem sub[hdr.sub.count] @ hdr.sub.itemsOffset;

    MotHurt hBoxes[hdr.hitboxCount] @ hdr.normal.hitboxOffset;
    u16 grabDmg[hdr.grabDmgCount] @ hdr.normal.grabDmgOffset; // grab damage values
    //MotItem items[hdr.motCount];
};

Moveset gMoves @ 0;
