//This is the 4th file in the common motion found in 2 and 3
//Also found it in 4, now using 2 stuffs insted of 6.
//Everything is indexed as -0x20000.
//From KH11 from the base that is HurtIdx

struct ActionIndex {
    u16 n;
    u16 e;
    u16 s;
    u16 w;
};

struct HurtIndexTable {
    u16 name;
    u16 description;
    ActionIndex indexes[6];
};

struct HTB {
    u32 count;
    HurtIndexTable entries[count];
};

HTB gHtb @ 0;
