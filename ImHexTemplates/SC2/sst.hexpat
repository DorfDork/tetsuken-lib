u32 base = 0;

struct Line{
u32 offset;
char text[] @ base + offset;
};

struct SST{
u32 unk0;
u32 count;
base = $ + (count*4);
Line lines[count];
};

SST file @ 0;
