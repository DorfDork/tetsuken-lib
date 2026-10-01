struct fmtOLK_Entry { // 16 Bytes
    u32 addr; // relative to data buffer start
    u32 size; // relative
    u32 unix_time; // accumlated seconds since January 1, 1970
    u32 reserved1;
    };

struct fmtOLK {
    u32 data_count;
    u32 olk_id;
    u32 alignment;
    u32 reserved0;
    fmtOLK_Entry data_info; // First Entry describes bounds of the data buffer
    fmtOLK_Entry entrys[data_count];
    };
    
fmtOLK OLK @ 0;