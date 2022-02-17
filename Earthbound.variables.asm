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


          .rsset 0x0000
R_**:$0000:                                   .rs 1 ; 0x0000


          .rsset 0x0002
R_**:$0002:                                   .rs 1 ; 0x0002


          .rsset 0x0006
COPY_PROTECTION_VAL:                          .rs 1 ; 0x0006
ENGINE_BASE_R6_VAL?:                          .rs 1 ; 0x0007
NMI_GFX_COUNTER:                              .rs 1 ; 0x0008
WORLD_POS?_CARRY_ADDS_UNK:                    .rs 3 ; 0x0009 to 0x000B
R_**:$000C:                                   .rs 1 ; 0x000C
R_**:$000D:                                   .rs 1 ; 0x000D
SWITCH_INIT_PORTION?:                         .rs 1 ; 0x000E
R_**:$000F:                                   .rs 1 ; 0x000F
SCRIPT_R6_UNK:                                .rs 1 ; 0x0010
R_**:$0011:                                   .rs 1 ; 0x0011
SCRIPT_R7_UNK:                                .rs 1 ; 0x0012
R_**:$0013:                                   .rs 1 ; 0x0013
R_**:$0014:                                   .rs 1 ; 0x0014
SCRIPT_R6_ROUTINE_SELECT:                     .rs 1 ; 0x0015
R_**:$0016:                                   .rs 1 ; 0x0016
R_**:$0017:                                   .rs 1 ; 0x0017
SCRIPT_PAIR_PTR_B?:                           .rs 2 ; 0x0018 to 0x0019
SCRIPT_PAIR_PTR?:                             .rs 2 ; 0x001A to 0x001B
R_**:$001C:                                   .rs 1 ; 0x001C
R_**:$001D:                                   .rs 1 ; 0x001D
R_**:$001E:                                   .rs 1 ; 0x001E
ACTION_BUTTONS_RESULT:                        .rs 1 ; 0x001F
FIRST_LAUNCHER_HOLD_FLAG?:                    .rs 1 ; 0x0020
MAIN_FLAG_UNK:                                .rs 1 ; 0x0021
SCRIPT_FLAG_0x22:                             .rs 1 ; 0x0022
FLAG_UNK_23:                                  .rs 1 ; 0x0023
CLEAR_AFTER_HELL_ALOT_LOL:                    .rs 1 ; 0x0024
ENGINE_FLAG_25_SKIP_UNK:                      .rs 1 ; 0x0025
R_**:$0026:                                   .rs 1 ; 0x0026
R_**:$0027:                                   .rs 1 ; 0x0027
R_**:$0028:                                   .rs 1 ; 0x0028
PTR_CREATE_SEED?:                             .rs 1 ; 0x0029
R_**:$002A:                                   .rs 1 ; 0x002A
R_**:$002B:                                   .rs 1 ; 0x002B
ROUTINE_CONTINUE_FLAG?:                       .rs 1 ; 0x002C
R_**:$002D:                                   .rs 1 ; 0x002D


          .rsset 0x0030
ENGINE_FPTR_30:                               .rs 2 ; 0x0030 to 0x0031
ENGINE_FPTR_32:                               .rs 2 ; 0x0032 to 0x0033


          .rsset 0x0035
STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?:  .rs 1 ; 0x0035
GAME_SLOT_CURRENT?:                           .rs 1 ; 0x0036
SLOT/DATA_OFFSET_USE?:                        .rs 1 ; 0x0037
R6_BANKED_ADDR_MOVED:                         .rs 2 ; 0x0038 to 0x0039
STREAM_WRITE_ARR_UNK:                         .rs 4 ; 0x003A to 0x003D
R_**:$003E:                                   .rs 1 ; 0x003E
R_**:$003F:                                   .rs 1 ; 0x003F
FPTR_SPRITES?:                                .rs 2 ; 0x0040 to 0x0041
R_**:$0042:                                   .rs 1 ; 0x0042
R_**:$0043:                                   .rs 1 ; 0x0043
R_**:$0044:                                   .rs 1 ; 0x0044
R_**:$0045:                                   .rs 1 ; 0x0045
R_**:$0046:                                   .rs 1 ; 0x0046
STREAM_REPLACE_COUNT?:                        .rs 1 ; 0x0047
FLAG_UNK_48:                                  .rs 1 ; 0x0048
R_**:$0049:                                   .rs 1 ; 0x0049
R_**:$004A:                                   .rs 1 ; 0x004A
R_**:$004B:                                   .rs 1 ; 0x004B
R_**:$004C:                                   .rs 1 ; 0x004C
R_**:$004D:                                   .rs 1 ; 0x004D


          .rsset 0x0050
R_**:$0050:                                   .rs 1 ; 0x0050
R_**:$0051:                                   .rs 1 ; 0x0051
R_**:$0052:                                   .rs 1 ; 0x0052
SCRIPT_INDEX_53_UNK:                          .rs 1 ; 0x0053
R_**:$0054:                                   .rs 1 ; 0x0054
57_INDEX_UNK:                                 .rs 1 ; 0x0055
56_THING_NAME_SIZE:                           .rs 1 ; 0x0056


          .rsset 0x0058
R_**:$0058:                                   .rs 1 ; 0x0058
R_**:$0059:                                   .rs 1 ; 0x0059
FLAG_SPRITE_OFF_SCREEN_UNK:                   .rs 1 ; 0x005A
R_**:$005B:                                   .rs 1 ; 0x005B
FPTR_5C_UNK:                                  .rs 2 ; 0x005C to 0x005D


          .rsset 0x0060
MISC_USE_A:                                   .rs 1 ; 0x0060
MISC_USE_B:                                   .rs 1 ; 0x0061
MISC_USE_C:                                   .rs 1 ; 0x0062
ENGINE_TO_DECIMAL_INDEX_POSITION:             .rs 1 ; 0x0063
SAVE_GAME_MOD_PAGE_PTR:                       .rs 2 ; 0x0064 to 0x0065
ALT_STUFF_INDEX?:                             .rs 1 ; 0x0066
ALT_COUNT_UNK:                                .rs 1 ; 0x0067
ARR_BITS_TO_UNK:                              .rs 8 ; 0x0068 to 0x006F
R_**:$0070:                                   .rs 1 ; 0x0070
ENGINE_PACKINATOR_ARG_SEED_0xA0_PRE_COUNT:    .rs 1 ; 0x0071
ENGINE_SCRIPT_SWITCH_VAL?:                    .rs 1 ; 0x0072
ARG_IDFK:                                     .rs 1 ; 0x0073
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
MENU_HELPER_STATUS?:                          .rs 1 ; 0x0083
FPTR_UNK_84_MENU?:                            .rs 2 ; 0x0084 to 0x0085
STREAM_TARGET?:                               .rs 1 ; 0x0086
CARRY_UP?:                                    .rs 1 ; 0x0087
SCRIPT_B800_PTR_UNK:                          .rs 2 ; 0x0088 to 0x0089
STREAM_DEEP_HELPER_UNK:                       .rs 2 ; 0x008A to 0x008B
PPU_GROUPED_ADDR_LH:                          .rs 2 ; 0x008C to 0x008D
R_**:$008E:                                   .rs 1 ; 0x008E
R_**:$008F:                                   .rs 1 ; 0x008F
OR_AND_STORE_UNK:                             .rs 1 ; 0x0090
PACKET_UPDATES_COUNT/SCRATCH:                 .rs 1 ; 0x0091
DEEP_BASE_UNK:                                .rs 1 ; 0x0092
DEEP_STREAM_MOD_UNK:                          .rs 1 ; 0x0093
R_**:$0094:                                   .rs 1 ; 0x0094


          .rsset 0x0096
B800_PTR_L_ADD_UNK:                           .rs 1 ; 0x0096
SCRIPT_INVERT_UNK:                            .rs 1 ; 0x0097
R_**:$0098:                                   .rs 1 ; 0x0098
R_**:$0099:                                   .rs 1 ; 0x0099
R_**:$009A:                                   .rs 1 ; 0x009A
R_**:$009B:                                   .rs 1 ; 0x009B


          .rsset 0x00A0
SCRIPT_UNK_DATA_SELECT_??:                    .rs 1 ; 0x00A0
STREAM_DEEP_INDEX:                            .rs 1 ; 0x00A1
STREAM_UNK_DEEP_A:                            .rs 2 ; 0x00A2 to 0x00A3
STREAM_DEEP_B:                                .rs 1 ; 0x00A4
R_**:$00A5:                                   .rs 1 ; 0x00A5
STREAM_DEEP_C:                                .rs 1 ; 0x00A6
R_**:$00A7:                                   .rs 1 ; 0x00A7
SCRIPT_COUNT_UNK:                             .rs 1 ; 0x00A8
R_**:$00A9:                                   .rs 1 ; 0x00A9
SCRIPT_LOADED_SHIFTED_UNK:                    .rs 1 ; 0x00AA
R_**:$00AB:                                   .rs 1 ; 0x00AB
SCRIPT_LOADED_SHIFTED_|VAL:                   .rs 2 ; 0x00AC to 0x00AD
R_**:$00AE:                                   .rs 1 ; 0x00AE
R_**:$00AF:                                   .rs 1 ; 0x00AF
SOUND_WRITE_DEST:                             .rs 2 ; 0x00B0 to 0x00B1


          .rsset 0x00BF
R_**:$00BF:                                   .rs 1 ; 0x00BF
CTRL_BIT_0x0:                                 .rs 1 ; 0x00C0
CTRL_BIT_0x1:                                 .rs 1 ; 0x00C1
R_**:$00C2:                                   .rs 1 ; 0x00C2
UPDATE_PACKET_COUNT/GROUPS:                   .rs 1 ; 0x00C3
R_**:$00C4:                                   .rs 1 ; 0x00C4
R_**:$00C5:                                   .rs 1 ; 0x00C5
R_**:$00C6:                                   .rs 1 ; 0x00C6
R_**:$00C7:                                   .rs 1 ; 0x00C7
R_**:$00C8:                                   .rs 1 ; 0x00C8
R_**:$00C9:                                   .rs 1 ; 0x00C9
R_**:$00CA:                                   .rs 1 ; 0x00CA
R_**:$00CB:                                   .rs 1 ; 0x00CB
R_**:$00CC:                                   .rs 1 ; 0x00CC
R_**:$00CD:                                   .rs 1 ; 0x00CD
R_**:$00CE:                                   .rs 1 ; 0x00CE
R_**:$00CF:                                   .rs 1 ; 0x00CF
R_**:$00D0:                                   .rs 1 ; 0x00D0
R_**:$00D1:                                   .rs 1 ; 0x00D1
R_**:$00D2:                                   .rs 1 ; 0x00D2
R_**:$00D3:                                   .rs 1 ; 0x00D3


          .rsset 0x00D5
R_**:$00D5:                                   .rs 1 ; 0x00D5
R_**:$00D6:                                   .rs 1 ; 0x00D6
RAM_CODE_UNK:                                 .rs 3 ; 0x00D7 to 0x00D9
CONTROL_ACCUMULATED?:                         .rs 2 ; 0x00DA to 0x00DB
CTRL_NEWLY_PRESSED:                           .rs 2 ; 0x00DC to 0x00DD
CTRL_BUTTONS_PREVIOUS:                        .rs 2 ; 0x00DE to 0x00DF
NMI_FLAG_E0_TODO:                             .rs 1 ; 0x00E0
BMI_FLAG_SET_DIFF_MODDED_UNK:                 .rs 1 ; 0x00E1
NMI_FLAG_OBJECT_PROCESSING?:                  .rs 1 ; 0x00E2
R_**:$00E3:                                   .rs 1 ; 0x00E3
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
ENGINE_MAPPER_CONFIG_STATUS_NO_BANK:          .rs 1 ; 0x00EF
MAPPER_BANK_VALS:                             .rs 8 ; 0x00F0 to 0x00F7


          .rsset 0x00FC
ENGINE_SCROLL_Y:                              .rs 1 ; 0x00FC
ENGINE_SCROLL_X:                              .rs 1 ; 0x00FD
ENGINE_PPU_MASK_COPY:                         .rs 1 ; 0x00FE
ENGINE_PPU_CTRL_COPY:                         .rs 1 ; 0x00FF
R_**:$0100:                                   .rs 1 ; 0x0100


          .rsset 0x0105
R_**:$0105:                                   .rs 1 ; 0x0105


          .rsset 0x0110
NMI_PPU_READ_BUF_UNK:                         .rs 64 ; 0x0110 to 0x014F


          .rsset 0x0200
SPRITE_PAGE:                                  .rs 256 ; 0x0200 to 0x02FF
R_**:$0300:                                   .rs 1 ; 0x0300
R_**:$0301:                                   .rs 1 ; 0x0301
R_**:$0302:                                   .rs 1 ; 0x0302
R_**:$0303:                                   .rs 1 ; 0x0303
R_**:$0304:                                   .rs 1 ; 0x0304
R_**:$0305:                                   .rs 1 ; 0x0305
R_**:$0306:                                   .rs 1 ; 0x0306
R_**:$0307:                                   .rs 1 ; 0x0307


          .rsset 0x03E0
R_**:$03E0:                                   .rs 1 ; 0x03E0
SPRITE_SLOT_Y_OFF_SCREEN_UNK:                 .rs 1 ; 0x03E1


          .rsset 0x0400
NMI_PPU_CMD_PACKETS_BUF:                      .rs 64 ; 0x0400 to 0x043F


          .rsset 0x0444
R_**:$0444:                                   .rs 1 ; 0x0444


          .rsset 0x045B
R_**:$045B:                                   .rs 1 ; 0x045B


          .rsset 0x04A2
R_**:$04A2:                                   .rs 1 ; 0x04A2


          .rsset 0x0500
SCRIPT_PALETTE_UPLOADED?:                     .rs 32 ; 0x0500 to 0x051F
SCRIPT_PALETTE_TARGET/ALT?:                   .rs 32 ; 0x0520 to 0x053F
IRQ_SCRIPT_B:                                 .rs 1 ; 0x0540
IRQ_SCRIPT_A:                                 .rs 1 ; 0x0541


          .rsset 0x0580
CHARACTER_NAMES_ARR:                          .rs 8 ; 0x0580 to 0x0587


          .rsset 0x0584
WRAM/RAM_ARR_UNK_RAM:                         .rs 4 ; 0x0584 to 0x0587


          .rsset 0x0600
STREAM_INDEXES_ARR_UNK:                       .rs 24 ; 0x0600 to 0x0617
STREAM_PTRS_ARR_UNK:                          .rs 48 ; 0x0618 to 0x0647


          .rsset 0x0700
R_**:$0700:                                   .rs 1 ; 0x0700


          .rsset 0x076C
ARR_UNK:                                      .rs 20 ; 0x076C to 0x077F


          .rsset 0x078C
VAL_CMP_UNK:                                  .rs 1 ; 0x078C


          .rsset 0x07EF
SCRIPT_UNK_TESTED:                            .rs 1 ; 0x07EF
R_**:$07F0:                                   .rs 1 ; 0x07F0
R_**:$07F1:                                   .rs 1 ; 0x07F1


          .rsset 0x07F3
R_**:$07F3:                                   .rs 1 ; 0x07F3
R_**:$07F4:                                   .rs 1 ; 0x07F4
VAL_CMP_DIFFERS_STORED_UNK:                   .rs 1 ; 0x07F5


          .rsset 0x07F7
R_**:$07F7:                                   .rs 1 ; 0x07F7
SOUND_UNK_REQUEST?:                           .rs 7 ; 0x07F8 to 0x07FE


          .rsset 0x6222
WRAM/RAM_ARR_UNK_WRAM:                        .rs 4


          .rsset 0x6600
R_**:$6600:                                   .rs 1


          .rsset 0x6700
R_**:$6700:                                   .rs 1
R_**:$6701:                                   .rs 1
R_**:$6702:                                   .rs 1


          .rsset 0x6704
R_**:$6704:                                   .rs 1
R_**:$6705:                                   .rs 1
R_**:$6706:                                   .rs 1
R_**:$6707:                                   .rs 1


          .rsset 0x670A
R_**:$670A:                                   .rs 1
R_**:$670B:                                   .rs 1
R_**:$670C:                                   .rs 1
R_**:$670D:                                   .rs 1
R_**:$670E:                                   .rs 1
R_**:$670F:                                   .rs 1


          .rsset 0x6713
R_**:$6713:                                   .rs 1
R_**:$6714:                                   .rs 1


          .rsset 0x6780
R_**:$6780:                                   .rs 1


          .rsset 0x6784
R_**:$6784:                                   .rs 1
R_**:$6785:                                   .rs 1
R_**:$6786:                                   .rs 1
R_**:$6787:                                   .rs 1
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
R_**:$67A0:                                   .rs 1


          .rsset 0x67C0
R_**:$67C0:                                   .rs 1


          .rsset 0x67E0
R_**:$67E0:                                   .rs 1


          .rsset 0x73D8
WRAM_ARR_UNK:                                 .rs 48


          .rsset 0x7400
CURRENT_SAVE_MANIPULATION_PAGE:               .rs 768


          .rsset 0x7402
SAVE_SLOT_DATA_UNK_A:                         .rs 1
SAVE_SLOT_DATA_UNK_B:                         .rs 1
