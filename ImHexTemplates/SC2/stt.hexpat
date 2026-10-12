u32 gBase = 0;

struct Line {
    u32 offset;
    char text[] @ gBase + offset;
};

struct STT {
    u32 unk0;
    u32 count;
    gBase = $ + (count * 4);
    Line lines[count];
};

STT gStt @ 0;
