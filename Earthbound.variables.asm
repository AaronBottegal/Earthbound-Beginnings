; Work in progress disassembly of Earthbound for the Nintendo Entertainment System.
; Created by Aaron Bottegal.


; NES PPU Registers

PPU_CTRL:                                     .equ $2000
PPU_MASK:                                     .equ $2001
PPU_STATUS:                                   .equ $2002
PPU_OAM_ADDR:                                 .equ $2003
PPU_OAM_DATA:                                 .equ $2004
PPU_SCROLL:                                   .equ $2005
PPU_ADDR:                                     .equ $2006
PPU_DATA:                                     .equ $2007


; NES APU Registers

APU_SQ1_CTRL:                                 .equ $4000
APU_SQ1_SWEEP:                                .equ $4001
APU_SQ1_LTIMER:                               .equ $4002
APU_SQ1_LENGTH:                               .equ $4003
APU_SQ2_CTRL:                                 .equ $4004
APU_SQ2_SWEEP:                                .equ $4005
APU_SQ2_LTIMER:                               .equ $4006
APU_SQ2_LENGTH:                               .equ $4007
APU_TRI_CTRL:                                 .equ $4008
APU_TRI_UNUSED:                               .equ $4009
APU_TRI_LTIMER:                               .equ $400A
APU_TRI_LENGTH:                               .equ $400B
APU_NSE_CTRL:                                 .equ $400C
APU_NSE_UNUSED:                               .equ $400D
APU_NSE_LOOP:                                 .equ $400E
APU_NSE_LENGTH:                               .equ $400F
APU_DMC_CTRL:                                 .equ $4010
APU_DMC_LOAD:                                 .equ $4011
APU_DMC_ADDR:                                 .equ $4012
APU_DMC_LENGTH:                               .equ $4013
OAM_DMA:                                      .equ $4014
APU_STATUS:                                   .equ $4015
NES_CTRL1:                                    .equ $4016
APU_FSEQUENCE:                                .equ $4017
NES_CTRL2:                                    .equ $4017


; NES RAM/WRAM Variables.


          .rsset 0x0006
COPY_PROTECTION_VAL:                          .rs 1 ; 0x0006
ENGINE_BASE_R6_VAL?:                          .rs 1 ; 0x0007
NMI_GFX_COUNTER:                              .rs 1 ; 0x0008
WORLD_POS?_CARRY_ADDS_UNK:                    .rs 3 ; 0x0009 to 0x000B


          .rsset 0x000E
SWITCH_INIT_PORTION?:                         .rs 1 ; 0x000E


          .rsset 0x0010
SCRIPT_R6_UNK:                                .rs 1 ; 0x0010


          .rsset 0x0012
SCRIPT_R7_UNK:                                .rs 1 ; 0x0012


          .rsset 0x0015
SCRIPT_R6_ROUTINE_SELECT:                     .rs 1 ; 0x0015


          .rsset 0x0018
SCRIPT_PAIR_PTR_B?:                           .rs 2 ; 0x0018 to 0x0019
SCRIPT_PAIR_PTR?:                             .rs 2 ; 0x001A to 0x001B


          .rsset 0x001F
ACTION_BUTTONS_RESULT:                        .rs 1 ; 0x001F
FIRST_LAUNCHER_HOLD_FLAG?:                    .rs 1 ; 0x0020
R_**:$0021:                                   .rs 1 ; 0x0021
SCRIPT_FLAG_0x22:                             .rs 1 ; 0x0022
UNK_NONZERO_SKIP:                             .rs 1 ; 0x0023
CLEAR_AFTER_HELL_ALOT_LOL:                    .rs 1 ; 0x0024
ENGINE_FLAG_25_SKIP_UNK:                      .rs 1 ; 0x0025


          .rsset 0x0028
R_**:$0028:                                   .rs 1 ; 0x0028
R_**:$0029:                                   .rs 1 ; 0x0029
R_**:$002A:                                   .rs 1 ; 0x002A
R_**:$002B:                                   .rs 1 ; 0x002B
R_**:$002C:                                   .rs 1 ; 0x002C
R_**:$002D:                                   .rs 1 ; 0x002D


          .rsset 0x0030
ENGINE_FPTR_30:                               .rs 2 ; 0x0030 to 0x0031
ENGINE_FPTR_32:                               .rs 2 ; 0x0032 to 0x0033


          .rsset 0x0035
R_**:$0035:                                   .rs 1 ; 0x0035
GAME_SLOT_CURRENT?:                           .rs 1 ; 0x0036
SLOT/DATA_OFFSET_USE?:                        .rs 1 ; 0x0037
R6_BANKED_ADDR_MOVED:                         .rs 2 ; 0x0038 to 0x0039
STREAM_WRITE_ARR_UNK:                         .rs 4 ; 0x003A to 0x003D


          .rsset 0x0040
FPTR_SPRITES?:                                .rs 2 ; 0x0040 to 0x0041


          .rsset 0x0048
R_**:$0048:                                   .rs 1 ; 0x0048


          .rsset 0x0055
57_INDEX_UNK:                                 .rs 1 ; 0x0055
56_THING_NAME_SIZE:                           .rs 1 ; 0x0056


          .rsset 0x005C
FPTR_5C_UNK:                                  .rs 2 ; 0x005C to 0x005D


          .rsset 0x0060
ENGINE_PALETTE_FPTR/BITS/GEN_USE:             .rs 2 ; 0x0060 to 0x0061
ENGINE_PALETTE_FPTR/BITS/GEN_USE+2:           .rs 1 ; 0x0062
ENGINE_TO_DECIMAL_INDEX_POSITION:             .rs 1 ; 0x0063
SAVE_GAME_MOD_PAGE_PTR:                       .rs 2 ; 0x0064 to 0x0065
ALT_STUFF_INDEX?:                             .rs 1 ; 0x0066
ALT_COUNT_UNK:                                .rs 1 ; 0x0067
ARR_BITS_TO_UNK:                              .rs 8 ; 0x0068 to 0x006F
R_**:$0070:                                   .rs 1 ; 0x0070
ENGINE_PACKINATOR_ARG_SEED_0xA0_PRE_COUNT:    .rs 1 ; 0x0071
ENGINE_SCRIPT_SWITCH_VAL:                     .rs 1 ; 0x0072
RTN_ARG_UNK:                                  .rs 1 ; 0x0073
FPTR_PACKET_CREATION:                         .rs 2 ; 0x0074 to 0x0075
PACKET_HPOS_COORD?:                           .rs 1 ; 0x0076
PACKET_YPOS_COORD?:                           .rs 1 ; 0x0077
PACKET_PPU_ADDR_HL:                           .rs 2 ; 0x0078 to 0x0079
PACKET_CONSUMED/INDEX?:                       .rs 1 ; 0x007A
DISP_UPDATE_COUNT_SMART_INVERTED/MISC:        .rs 1 ; 0x007B
ENGINE_PTR_PACKET_MANAGER:                    .rs 2 ; 0x007C to 0x007D
DATA_APPEND_COUNT?:                           .rs 1 ; 0x007E
PACKET_PRE_SEED_0xA0_COUNT:                   .rs 1 ; 0x007F
FPTR_SPRITES?:                                .rs 2 ; 0x0080 to 0x0081
FPTR_UNK_84_MENU_SELECTION?:                  .rs 2 ; 0x0082 to 0x0083


          .rsset 0x0083
R_**:$0083:                                   .rs 1 ; 0x0083
FPTR_UNK_84_MENU?:                            .rs 2 ; 0x0084 to 0x0085
STREAM_TARGET?:                               .rs 1 ; 0x0086
CARRY_UP?:                                    .rs 1 ; 0x0087
SCRIPT_B800_PTR_UNK:                          .rs 2 ; 0x0088 to 0x0089
STREAM_DEEP_HELPER_UNK:                       .rs 2 ; 0x008A to 0x008B
PPU_GROUPED_ADDR_LH:                          .rs 2 ; 0x008C to 0x008D


          .rsset 0x0090
OR_AND_STORE_UNK:                             .rs 1 ; 0x0090
PACKET_UPDATES_COUNT/SCRATCH:                 .rs 1 ; 0x0091
DEEP_BASE_UNK:                                .rs 1 ; 0x0092
DEEP_STREAM_MOD_UNK:                          .rs 1 ; 0x0093


          .rsset 0x0096
B800_PTR_L_ADD_UNK:                           .rs 1 ; 0x0096
SCRIPT_INVERT_UNK:                            .rs 1 ; 0x0097


          .rsset 0x00A0
SCRIPT_UNK_DATA_SELECT_??:                    .rs 1 ; 0x00A0
STREAM_DEEP_INDEX:                            .rs 1 ; 0x00A1
STREAM_UNK_DEEP_A:                            .rs 2 ; 0x00A2 to 0x00A3
STREAM_DEEP_B:                                .rs 1 ; 0x00A4


          .rsset 0x00A6
STREAM_DEEP_C:                                .rs 1 ; 0x00A6


          .rsset 0x00A8
SCRIPT_COUNT_UNK:                             .rs 1 ; 0x00A8


          .rsset 0x00AA
SCRIPT_LOADED_SHIFTED_UNK:                    .rs 1 ; 0x00AA


          .rsset 0x00AC
SCRIPT_LOADED_SHIFTED_|VAL:                   .rs 2 ; 0x00AC to 0x00AD


          .rsset 0x00B0
SOUND_WRITE_DEST:                             .rs 2 ; 0x00B0 to 0x00B1


          .rsset 0x00C0
CTRL_BIT_0x0:                                 .rs 1 ; 0x00C0
CTRL_BIT_0x1:                                 .rs 1 ; 0x00C1


          .rsset 0x00C3
UPDATE_PACKET_COUNT/GROUPS:                   .rs 1 ; 0x00C3


          .rsset 0x00D7
RAM_CODE_UNK:                                 .rs 2 ; 0x00D7 to 0x00D8


          .rsset 0x00DA
CONTROL_ACCUMULATED?:                         .rs 2 ; 0x00DA to 0x00DB
CTRL_NEWLY_PRESSED:                           .rs 2 ; 0x00DC to 0x00DD
CTRL_BUTTONS_PREVIOUS:                        .rs 2 ; 0x00DE to 0x00DF
NMI_FLAG_E0_TODO:                             .rs 1 ; 0x00E0
BMI_FLAG_SET_DIFF_MODDED_UNK:                 .rs 1 ; 0x00E1
NMI_FLAG_OBJECT_PROCESSING?:                  .rs 1 ; 0x00E2


          .rsset 0x00E4
SPRITE_INDEX_SWAP:                            .rs 1 ; 0x00E4
NMI_FLAG_E5_TODO:                             .rs 1 ; 0x00E5
NMI_PPU_CMD_PACKETS_INDEX:                    .rs 1 ; 0x00E6
NMI_FLAG_E7:                                  .rs 1 ; 0x00E7
NMI_FP_UNK:                                   .rs 2 ; 0x00E8 to 0x00E9
ENGINE_NMI_CONFIG_FLAGS_DIS:0x80:             .rs 1 ; 0x00EA
ENGINE_IRQ_LATCH_CURRENT?:                    .rs 1 ; 0x00EB
NMI_LATCH_FLAG:                               .rs 1 ; 0x00EC
ENGINE_IRQ_RTN_INDEX:                         .rs 1 ; 0x00ED
MAPPER_INDEX_LAST_WRITTEN:                    .rs 1 ; 0x00EE
ENGINE_MAPPER_CONFIG_STATUS:                  .rs 1 ; 0x00EF
MAPPER_BANK_VALS:                             .rs 8 ; 0x00F0 to 0x00F7


          .rsset 0x00FC
ENGINE_SCROLL_Y:                              .rs 1 ; 0x00FC
ENGINE_SCROLL_X:                              .rs 1 ; 0x00FD
ENGINE_PPU_MASK_COPY:                         .rs 1 ; 0x00FE
ENGINE_PPU_CTRL_COPY:                         .rs 1 ; 0x00FF


          .rsset 0x0110
NMI_PPU_READ_BUF_UNK:                         .rs 64 ; 0x0110 to 0x014F


          .rsset 0x0200
SPRITE_PAGE:                                  .rs 256 ; 0x0200 to 0x02FF


          .rsset 0x0400
NMI_PPU_CMD_PACKETS_BUF:                      .rs 64 ; 0x0400 to 0x043F


          .rsset 0x0500
SCRIPT_PALETTE_UPLOADED?:                     .rs 32 ; 0x0500 to 0x051F
SCRIPT_PALETTE_TARGET/ALT?:                   .rs 32 ; 0x0520 to 0x053F
IRQ_SCRIPT_B:                                 .rs 1 ; 0x0540
IRQ_SCRIPT_A:                                 .rs 1 ; 0x0541


          .rsset 0x0580
CHARACTER_NAMES_ARR:                          .rs 8 ; 0x0580 to 0x0587


          .rsset 0x0584
WRAM/RAM_ARR_UNK_RAM:                         .rs 4 ; 0x0584 to 0x0587


          .rsset 0x076C
ARR_UNK:                                      .rs 20 ; 0x076C to 0x077F


          .rsset 0x078C
VAL_CMP_UNK:                                  .rs 1 ; 0x078C


          .rsset 0x07EF
SCRIPT_UNK_TESTED:                            .rs 1 ; 0x07EF


          .rsset 0x07F5
VAL_CMP_DIFFERS_STORED_UNK:                   .rs 1 ; 0x07F5


          .rsset 0x07F8
SOUND_UNK_REQUEST?:                           .rs 7 ; 0x07F8 to 0x07FE


          .rsset 0x6222
WRAM/RAM_ARR_UNK_WRAM:                        .rs 4


          .rsset 0x6780
R_**:$6780:                                   .rs 1


          .rsset 0x6788
R_**:$6788:                                   .rs 1


          .rsset 0x6794
R_**:$6794:                                   .rs 1
R_**:$6795:                                   .rs 1
R_**:$6796:                                   .rs 1
R_**:$6797:                                   .rs 1


          .rsset 0x6799
R_**:$6799:                                   .rs 1
R_**:$679A:                                   .rs 1


          .rsset 0x679E
R_**:$679E:                                   .rs 1
R_**:$679F:                                   .rs 1


          .rsset 0x67C0
R_**:$67C0:                                   .rs 1


          .rsset 0x67E0
R_**:$67E0:                                   .rs 1


          .rsset 0x7400
CURRENT_SAVE_MANIPULATION_PAGE:               .rs 768


          .rsset 0x7402
SAVE_SLOT_DATA_UNK_A:                         .rs 1
SAVE_SLOT_DATA_UNK_B:                         .rs 1
