#pragma endian big
u32 aligment = 0x20;
struct achared{
char string[aligment];
};

struct header{
char MAGIC[3];
u8 subver;
match(subver){
(0) : u8 ver;
(1) : u16 ver;
(2) : u32 ver;
}

if(ver == 3){
aligment = 0x80;
}
u32 count;
u32 smth;
padding[0x10 % $];
u32 offsets[count];
if($ % 0x10){
padding[0x10 - ($ % 0x10)];
}
achared names[count];
};

header test @ 0;