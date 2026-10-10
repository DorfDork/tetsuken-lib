//Common motion, Hurt Action indexing table

//Contains indexing to hurt action in mutiple modes
//Also has offset to simple name and Description(Shift-JIS)

struct ActionIndex {
    u16 n;
    u16 e;
    u16 s;
    u16 w;
    //The cardinal directions (North East South West)
};

struct HurtIndexTable {
    u16 name;
    u16 description;
    ActionIndex indexes[6];
};

struct CommonHurt {
    u32 count;
    HurtIndexTable entrys[count];
};

CommonHurt gCommonHurt @ 0;
