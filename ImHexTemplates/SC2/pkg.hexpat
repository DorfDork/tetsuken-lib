import std.core;
import std.mem;

struct PKGSlot{
u32 offset;
u32 end @ $ [[hidden]];
if(end > offset){
    u8 file[end - offset] @ offset;
}
};

struct PKG{
u32 count;
PKGSlot slots[count];
u32 end;
};

u32 probe @ 0 [[hidden]];
if(probe > 0xFFFF){ // check if dtp file is big endian
    std::core::set_endian(std::mem::Endian::Big);
}else{
    std::core::set_endian(std::mem::Endian::Little);
};

PKG pkg @ 0;
