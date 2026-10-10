import std.core;
import std.io;
import std.mem;
import type.magic;

struct Header {
    char magic[4];
    u32 size;
    u8 day;
    u8 month;
    u16 year;
    u8 second;
    u8 minute;
    u8 hour;
    u8 pad;
    u32 version;
    u32 count;
};

enum OutBus : u8 {
    MASTER          = 0,
    REVERB_CORE0    = 1,
    REVERB_CORE1    = 2,
    DELAY           = 3,
    SS              = 5,
    HIT             = 6,
    GUARD           = 7,
    SWISH           = 8,
    FOOT            = 9,
    DOWN            = 10,
    BS              = 11,
    OTHER           = 12,
    VOICE_1P        = 13,
    VOICE_2P        = 14,
    NARRATION       = 15,
    JINGLE          = 16,
    GROUP_BGM       = 28,
    GROUP_VOICE     = 29,
    GROUP_SE        = 30,
    GROUP_SYSTEM_SE = 31
};

enum ChannelGroup : s8 {
    NO_LIMIT        = 0,
    FOOT_OTHER_1P   = 1,
    FOOT_OTHER_2P   = 2,
    ATTACK_GUARD_1P = 3,
    ATTACK_GUARD_2P = 4,
    VOICE_1P        = 5,
    VOICE_2P        = 6,
    SYSTEM_SE       = 29,
    SYSTEM_VOICE    = 30,
    MOB             = 31
};

struct PHDEnt {
    s16 toneNo;
    u8 effectFlag;
    ChannelGroup chGrp;
    u8 prior;
    u8 keyonProb;
    u8 rndFlag;
    u8 volMode;
    s16 link;
    u16 linkNum;
    s16 linkFlag;
    s16 sPad0;
    OutBus outBus;
    u8 sendBus;
    u8 sendVar;
    s8 cPad0;
    u32 delay;
    u16 basePitch;
    s16 dPitch;
    s16 rndPitch;
    u8 vol;
    s8 rndVol;
    s8 panLr;
    s8 panLh;
    s8 rndPan;
    s8 cPad1;
    float volOffset;
    float volLow;
    float volHigh;
    u16 adsr1;
    u16 adsr2;
    s32 ssa;
    u32 vagSize;
    u32 vagOfs;
    float adjPitch;
    float adjVol;
    s16 user0;
    s16 user1;
    s16 user2;
    s16 user3;
};

struct DSPHeader {
    u32 sampleCount;
    u32 nibbleCount;
    u32 sampleRate;
    u16 loopFlag;
    u16 format;
    u32 loopStart;
    u32 loopEnd;
    u32 currentAddress;
    s16 coefficients[16];
    u16 gain;
    u16 predictorScale;
    s16 history1;
    s16 history2;
    u16 loopPredictorScale;
    s16 loopHistory1;
    s16 loopHistory2;
    padding[22];
};

struct CHDEnt {
    u32 offset;
    u8 settings[0x4C]; // 0x4C
    DSPHeader dsp;
};

struct XHDWave {
    u16 formatTag;
    u16 channels;
    u32 sampleRate;
    u32 avgBytesPerSec;
    u16 blockAlign;
    u16 bitsPerSample;
    u16 extraSize;
    u16 samplesPerBlock;
    u32 offset;
    u32 size;
    u8 unk[0x114 - 0x1C];
};

u32 gSettingsSize = 0;

struct XHDSetting {
    u8 settings[gSettingsSize];
};

struct HDp {
    u32 start = $;
    char magic[4];
    u8 majVer;
    u8 minVer;
    u16 bankId;
    u16 toneCount;
    u16 headerSize;
    u32 dataSize;
    if (magic == "CHDp") {
        CHDEnt entrys[toneCount];
    } else if (magic == "XHDp") {
        u32 entryHeadersOffset;
        u32 entryHeadersSize;
        u32 wavHeaderOffset;
        u32 wavHeadersSize;
        if (toneCount > 0) {
            gSettingsSize = entryHeadersSize / toneCount;
            XHDSetting settings[toneCount] @ start + entryHeadersOffset;
            XHDWave waves[toneCount] @ start + wavHeaderOffset;
        }
    } else {
        PHDEnt entrys[toneCount];
    }
};

struct Entry {
    u32 headerOffset;
    u32 headerSize;
    u32 dataOffset;
    u32 dataSize;
    if (headerSize > 0) {
        HDp header @ headerOffset;
    }
    if (dataSize > 0) {
        u8 data[dataSize] @ dataOffset;
    }
};

struct MMA {
    Header hdr;
    Entry ents[hdr.count];
};

u32 gMagic @ 0 [[hidden]];
if (gMagic == 6778221) {
    std::core::set_endian(std::mem::Endian::Big);
} else {
    std::core::set_endian(std::mem::Endian::Little);
}

MMA gFile @ 0;
