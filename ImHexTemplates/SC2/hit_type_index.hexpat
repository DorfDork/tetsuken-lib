//This is the 4th file in the common motion found in 2 and 3
//Also found it in 4, now using 2 stuffs insted of 6.
//Everything is indexed as -0x20000.
//From KH11 from the base that is HurtIdx

struct InnerThing {
    u16 index1;
    u16 index2;
    u16 index3;
    u16 index4;
};

struct Thang {
    u16 basicCmdNamePointer;
    u16 jpDescriptionPointer;
    InnerThing stuffs[6];
};

u32 gCount @ 0;
Thang gGroups[gCount] @ 0x4;
