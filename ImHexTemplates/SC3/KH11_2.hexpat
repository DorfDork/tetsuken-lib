struct KHeader{
    u32 magic;
    u8 day;
    u8 month;
    u16 year;
    u8 sec;
    u8 min;
    u16 hour;
    u16 numEntries;
    u16 unk4;
    u32 attack_list;
    u32 throw_info;
    u16 moveGrpIdx1;
    u16 moveGrpCount1;
    u16 moveGrpIdx2;
    u16 moveGrpCount2;
    u16 hurtIdx;
    u16 hurtCount;
    u16 neutralIdx;
    u16 neutralCount;
};
u32 attack_count = 0;
u32 grab_count = 0;

struct moves{
    s16 motionIdx;
    u16 unkMotion;
    u32 unk0;
    float motion_multiplier;
    float speed_multiplier;
    u32 unk1;
    
    u32 unk2;
    u32 unk3;
    float unk4;
    
    u32 unk5;
    u32 unk6;
    u32 unk7;
    u32 unk8;
    
    float unknown_multiplier;
    s16 frameCount;
    u16 frameCountUnk;
    u32 cancel_address;
    u8 test @ cancel_address;
    u32 attack_index;
    if(attack_index<0xFFFFFFFF){
        if(attack_index&0x1000){
            grab_count = grab_count + 1;
        }else{
            attack_count = attack_count + 1;
        }
    }
};
struct vec3short{
    s16 x;
    s16 y;
    s16 z;
};
struct attacks {
    u32 hitbox;
    u16 unk1;
    u16 unk2;
    
    vec3short normal_vec;
    vec3short normal_launch_vec;
    vec3short counter_vec;
    vec3short counter_launch_vec;
    vec3short airborne_vec;
    vec3short block_vec;
    vec3short grounded_vec;
    
    u16 type;
    u16 notsure;
    u16 start;
    u16 active;
    s16 damage;
    u16 activeNOT;
    u16 not_dmg;
    
    u16 block_stun;
    u16 hit_stun;
    u16 counter_stun;
    u16 unsure2;
    u16 dmg_type;
    u16 counter_type;
    u16 unk3;
    u16 unk4;
    u32 unk5;
    u32 unk6;
};
struct KHFile{
    KHeader hdr;
    moves chunks[hdr.numEntries];
    attacks aChunk[attack_count];
    u16 grabs[grab_count];

};

KHFile file @ 0;