import std.core;
import std.mem;

u32 gCurOffset = 0;
u16 gByteCountField = 0;
u32 gMotionIdx = 0;
u32 gMotionCount = 0;
u32 gMotionEnd = 0;

bitfield MotFlags {
    BIT00                     : 1;
    BIT01                     : 1;
    KEYFRAME_EVERY_2          : 1; // pose saved as every 2nd frame
    KEYFRAME_EVERY_4          : 1; // pose saved as every 4th frame, unless KEYFRAME_EVERY_2 is set
    BIT04                     : 1; // maxFrames + 1 in ps2?
    BIT05                     : 1;
    BIT06                     : 1;
    BIT07                     : 1;
    BIT08                     : 1;
    BIT09                     : 1;
    BIT10                     : 1;
    BIT11                     : 1;
    BIT12                     : 1;
    BIT13                     : 1;
    SCALE_IN_16               : 1; // root and bone positions in 1/16
    BONE_ROTATION_TRANSLATION : 1; // trackMask is read with BONE_TRANSLATION_TABLE (every body bone has a position and a rotation) instead of BONE_ROTATION_TABLE (body bones only rotate)
    BIT16                     : 1;
    pad                       : 15;
} [[bitfield_order(std::core::BitfieldOrder::LeastToMostSignificant, 32)]];

bitfield MotFacing {
    unk       : 12;
    YAW_IN_16 : 4; // YAW in 1/16
} [[bitfield_order(std::core::BitfieldOrder::LeastToMostSignificant, 16)]];

bitfield BoneMask {
    unk         : 1;
    ROOT        : 1;  // whole body position and facing
    MUNE1       : 1;  // chest
    MUNE2       : 1;  // upper chest
    KUBI        : 1;  // neck
    ATAMA       : 1;  // head
    SAKOTSU_R   : 1;  // right collarbone
    KATA_R      : 1;  // right shoulder
    UDE_R       : 1;  // right elbow
    TE_R        : 1;  // right hand
    SAKOTSU_L   : 1;  // left collarbone
    KATA_L      : 1;  // left shoulder
    UDE_L       : 1;  // left elbow
    TE_L        : 1;  // left hand
    KOSHI       : 1;  // hips
    MOMO_R      : 1;  // right thigh
    HIZA_R      : 1;  // right knee
    ASHI_R      : 1;  // right foot
    TSUMASAKI_R : 1;  // right toes
    MOMO_L      : 1;  // left thigh
    HIZA_L      : 1;  // left knee
    ASHI_L      : 1;  // left foot
    TSUMASAKI_L : 1;  // left toes
    unk23       : 1;
    unk24       : 1;
    BUKI_1_POS  : 1;  // weapon bone position
    BUKI_1_ROT  : 1;  // weapon bone rotation
    BUKI_2_POS  : 1;  // weapon bone position
    BUKI_2_ROT  : 1;  // weapon bone rotation
    BUKI_3_POS  : 1;  // weapon bone position
    BUKI_3_ROT  : 1;  // weapon bone rotation
    BUKI_4_POS  : 1;  // weapon bone position
    BUKI_4_ROT  : 1;  // weapon bone rotation
    BUKI_5_POS  : 1;  // weapon bone position
    BUKI_5_ROT  : 1;  // weapon bone rotation
    BUKI_6_POS  : 1;  // weapon bone position
    BUKI_6_ROT  : 1;  // weapon bone rotation
    BUKI_7_POS  : 1;  // weapon bone position
    BUKI_7_ROT  : 1;  // weapon bone rotation
    BUKI_8_POS  : 1;  // weapon bone position
    BUKI_8_ROT  : 1;  // weapon bone rotation
    BUKI_9_POS  : 1;  // weapon bone position
    BUKI_9_ROT  : 1;  // weapon bone rotation
    pad         : 21; // unused
} [[bitfield_order(std::core::BitfieldOrder::LeastToMostSignificant, 64)]];

bitfield HandMask {
    OYA3  : 1;  // thumb base
    OYA2  : 1;  // thumb middle
    OYA1  : 1;  // thumb tip
    HITO3 : 1;  // index finger base
    HITO2 : 1;  // index finger middle
    HITO1 : 1;  // index finger tip
    NAKA3 : 1;  // middle finger base
    NAKA2 : 1;  // middle finger middle
    NAKA1 : 1;  // middle finger tip
    KUSU3 : 1;  // ring finger base
    KUSU2 : 1;  // ring finger middle
    KUSU1 : 1;  // ring finger tip
    KO3   : 1;  // little finger base
    KO2   : 1;  // little finger middle
    KO1   : 1;  // little finger tip
    pad   : 49; // unused
} [[bitfield_order(std::core::BitfieldOrder::LeastToMostSignificant, 64)]];

bitfield FaceMask {
    MIKEN_R        : 1;  // right inner eyebrow
    MAYU_R         : 1;  // right eyebrow
    EYE_R          : 1;  // right eye
    MABUTA_UP_R    : 1;  // right upper eyelid
    MABUTA_UN_R    : 1;  // right lower eyelid
    HOHO_R         : 1;  // right cheek
    BIKON_R_ROT    : 1;  // right nostril
    unk07          : 1;
    BIKON_R_POS    : 1;  // right nostril
    CHOBO_R        : 1;  // right lower cheek?
    MIKEN_L        : 1;  // left inner eyebrow
    MAYU_L         : 1;  // left eyebrow
    EYE_L          : 1;  // left eye
    MABUTA_UP_L    : 1;  // left upper eyelid
    MABUTA_UN_L    : 1;  // left lower eyelid
    HOHO_L         : 1;  // left cheek
    BIKON_L_ROT    : 1;  // left nostril
    unk17          : 1;
    BIKON_L_POS    : 1;  // left nostril
    CHOBO_L        : 1;  // left lower cheek?
    KUCHI_UP_ROT   : 1;  // upper lip
    unk21          : 1;
    KUCHI_UP_POS   : 1;  // upper lip
    KUCHI_UP_R_ROT : 1;  // upper lip, right
    unk24          : 1;
    KUCHI_UP_R_POS : 1;  // upper lip, right
    KUCHI_UP_L_ROT : 1;  // upper lip, left
    unk27          : 1;
    KUCHI_UP_L_POS : 1;  // upper lip, left
    AGO_ROT        : 1;  // jaw
    unk30          : 1;
    AGO_POS        : 1;  // jaw
    KUCHI_UN_R_ROT : 1;  // lower lip, right
    unk33          : 1;
    KUCHI_UN_R_POS : 1;  // lower lip, right
    KUCHI_R_ROT    : 1;  // right mouth corner
    unk36          : 1;
    KUCHI_R_POS    : 1;  // right mouth corner
    KUCHI_UN_L_ROT : 1;  // lower lip, left
    unk39          : 1;
    KUCHI_UN_L_POS : 1;  // lower lip, left
    KUCHI_L_ROT    : 1;  // left mouth corner
    unk42          : 1;
    KUCHI_L_POS    : 1;  // left mouth corner
    BERO1_ROT      : 1;  // tongue
    unk45          : 1;
    BERO1_SCALE    : 1;  // tongue
    BERO2_ROT      : 1;  // tongue tip
    unk48          : 1;
    BERO2_SCALE    : 1;  // tongue tip
    pad            : 14; // unused
} [[bitfield_order(std::core::BitfieldOrder::LeastToMostSignificant, 64)]];

enum FollowSlot : u8 {
    ROOT       = 1,
    RIGHT_HAND = 9,
    LEFT_HAND  = 13,
    HIPS       = 14,
    NONE_FD    = 0xFD,
    NONE_FE    = 0xFE,
    NONE       = 0xFF
};

struct Segment {
    u16 size;
    u16 firstPose[(gByteCountField >> 1)] @ gCurOffset;
    u8 packedFrames[(size - gByteCountField)] @ gCurOffset + sizeof(firstPose);
    gCurOffset = gCurOffset + size;
};

struct LastSegment {
    u16 firstPose[(gByteCountField >> 1)];
    if (gMotionEnd > $) {
        u8 packedFrames[gMotionEnd - $];
    }
};

struct MotHdr {
    u16 maxFrames;
    u16 numBytes;
    gByteCountField = numBytes;
    MotFlags flags;
    u64 maskProbe @ $ [[hidden]];
    if (maskProbe == 0x7FFF && numBytes == 50) {
        HandMask trackMask;
    } else if (maskProbe == 0x3FFFFFFFFFFFF && numBytes == 228) {
        FaceMask trackMask;
    } else {
        BoneMask trackMask; //
    }
    MotFacing facing;
    FollowSlot weaponFollow[10];
    u16 segmentTableSize;
    u16 trueCount = (segmentTableSize >> 1) - 1;
    gCurOffset = $ + (trueCount * 2);
    Segment segments[trueCount];
    LastSegment last @ gCurOffset;
};

struct MotionHdrPointer {
    gMotionIdx = gMotionIdx + 1;
    if (gMotionIdx < gMotionCount) {
        u32 next @ $ + 4 [[hidden]];
        gMotionEnd = next;
    } else {
        gMotionEnd = std::mem::size();
    }
    u32 start @ $ [[hidden]];
    if (gMotionEnd > start) {
        MotHdr *offset : u32;
    } else {
        u32 offset;
    }
};

struct Header {
    u32 count;
    gMotionCount = count;
    u32 unk;
    //u32 newOffset; //SC1 only
    MotionHdrPointer offsets[count];
    if ($ % 8 != 0) {
        padding[8 - ($ % 8)];
    }
};

struct Motion {
    Header hdr;
};

u32 gProbe @ 0 [[hidden]];
if (gProbe > 0xFFFF) {
    std::core::set_endian(std::mem::Endian::Big);
} else {
    std::core::set_endian(std::mem::Endian::Little);
}

Motion gMot @ 0;
