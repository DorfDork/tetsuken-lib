#pragma array_limit 0x100000
#pragma pattern_limit 0x400000

import std.mem;

struct Name {
    char text[];
};

Name gNames[while(!std::mem::eof())] @ 0;
