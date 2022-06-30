VAL_NONZERO_LOOP: ; 1F:0000, 0x03E000
    LDY #$00 ; Stream index.
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load stream.
    BEQ USE_CLEAR ; == 0, goto.
    BMI USE_CLEAR ; Negative, goto.
    LDY #$08 ; Stream index.
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load from ptr.
    AND #$3F ; Keep lower.
    BEQ USE_CLEAR ; == 0, goto.
    LDY #$14 ; Stream index.
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load from stream.
    AND #$10 ; Keep ??
    BEQ WRITE_CLEAR ; Clear, goto.
    TXA ; Write X. To A.
    LDX #$00 ; Seed clear?
WRITE_CLEAR: ; 1F:001B, 0x03E01B
    STA SLOT/DATA_OFFSET_USE/CURR? ; Store val.
    LDY #$10 ; Stream index.
    TXA ; X to A.
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Store to stream.
    LDY #$08 ; Stream mod.
VAL_LT_0xE: ; 1F:0024, 0x03E024
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load from stream.
    STA OBJ?_BYTE_0x0_STATUS?,X ; Store ??
    INX ; Index++
    INY ; Stream++
    CPY #$0E ; If _ #$0E
    BCC VAL_LT_0xE ; << goto.
    CLC ; Prep add.
    LDA SPRITE_PAGE+250,X ; Load sprite attrs ??
    AND #$40 ; Keep ??
    BEQ SPRITE_NO_HFLIP ; None, goto.
    LDA #$04 ; Seed ??
SPRITE_NO_HFLIP: ; 1F:0039, 0x03E039
    ADC [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Add with stream.
    STA OBJ?_BYTE_0x0_STATUS?,X ; To ??
    INX ; Indexes++
    INY
    LDA #$00 ; Seed carry add.
    ADC [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Add with carry.
    STA OBJ?_BYTE_0x0_STATUS?,X ; To ??
    INX ; Index++
    BEQ EXIT_WRAM_WDISABLED ; == 0, goto.
    LDA SLOT/DATA_OFFSET_USE/CURR? ; Load ??
    BEQ USE_CLEAR ; == 0, goto.
    TAX ; Nonzero to index.
USE_CLEAR: ; 1F:004F, 0x03E04F
    JSR ENGINE_FPTR_COL/ROW_MOD/FORWARD? ; Forward.
    DEC SAVE_ID_FOCUS/OTHER ; --
    BNE VAL_NONZERO_LOOP ; != 0, GOTO.
X_NO_OVERFLOW: ; 1F:0056, 0x03E056
    LDA #$00
    STA OBJ?_BYTE_0x0_STATUS?,X ; Clear ??
    CLC ; Prep add. X += 8
    TXA
    ADC #$08
    TAX
    BCC X_NO_OVERFLOW ; <, goto.
EXIT_WRAM_WDISABLED: ; 1F:0062, 0x03E062
    JMP ENGINE_WRAM_STATE_WRITE_DISABLED ; Exit.
OBJECTS_MOVE?: ; 1F:0065, 0x03E065
    LDX #$00 ; Reset index.
LOOP_INDEXES: ; 1F:0067, 0x03E067
    LDA OBJ?_BYTE_0x0_STATUS?,X ; Load ??
    AND #$40 ; Test ??
    BEQ TO_NEXT_SLOT ; == 0, goto.
    SEC ; Prep sub.
    LDA OBJ?_PTR?[2],X ; Load data.
    SBC #$04 ; -= 0x4
    STA OBJ?_PTR?[2],X ; Store back.
    LDA OBJ?_PTR?+1,X ; Carry sub.
    SBC #$00
    STA OBJ?_PTR?+1,X
TO_NEXT_SLOT: ; 1F:007F, 0x03E07F
    CLC ; Prep add.
    TXA ; X to A.
    ADC #$08 ; Move index.
    TAX ; Back to X index.
    BCC LOOP_INDEXES ; <, goto.
    RTS ; Leave.
ARR_MAKE_UNK: ; 1F:0087, 0x03E087
    JSR SETUP_PTR_6780_UNK ; Setup ptr.
    LDX #$04
    STX SAVE_ID_FOCUS/OTHER ; Set slot.
    LDA #$00
    STA BCD/MODULO/DIGITS_USE_C ; Clear index.
    LDX #$08 ; Seed index.
LOOP_NONZERO: ; 1F:0094, 0x03E094
    LDY #$00 ; Reset stream.
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load from file.
    BEQ FLAGGED_DATA ; == 0, goto.
    BMI FLAGGED_DATA ; Negative, goto.
    LDY BCD/MODULO/DIGITS_USE_C ; Alt stream index.
    LDA [BCD/MODULO/DIGITS_USE_A],Y ; Load from stream.
    STA OBJ?_BYTE_0x2_UNK,X ; Store to arr.
    INY ; Stream++
    LDA [BCD/MODULO/DIGITS_USE_A],Y ; Load from stream.
    STA OBJ?_BYTE_0x3_UNK,X ; Store to arr.
    INY ; Stream++
    LDA [BCD/MODULO/DIGITS_USE_A],Y ; Load from stream.
    STA BCD/MODULO/DIGITS_USE_D ; Store to.
    INY ; Stream++
    CLC ; Prep add.
    LDA [BCD/MODULO/DIGITS_USE_A],Y ; Load from stream.
    LDY #$16 ; Alt stream index.
    ADC [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Add with stream.
    STA OBJ?_PTR?[2],X ; Store to arr.
    INY ; Stream++
    LDA #$00 ; Seed carry.
    ADC [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Add with stream.
    STA OBJ?_PTR?+1,X ; Store to arr.
    LDY #$08 ; Stream index.
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load from arr.
    AND #$3F ; Keep lower.
    ASL A ; << 1, *2.
    ASL BCD/MODULO/DIGITS_USE_D ; << 1, *2.
    ROR A ; Rotate carry into A.
    STA OBJ?_BYTE_0x0_STATUS?,X ; Store to arr.
    LDA #$70 ; Load ??
    ASL BCD/MODULO/DIGITS_USE_D ; << 1, *2.
    ROR A ; Rotate into A.
    STA OBJ?_BYTE_0x1_UNK,X ; Store to.
    LDA #$00
    STA OBJ?_BYTE_0x4_UNK,X ; Clear ??
    STA OBJ?_BYTE_0x5_BYTE,X
    CLC ; Prep add.
    TXA ; Index to A.
    ADC #$08 ; Index mod.
    TAX ; Back to index.
FLAGGED_DATA: ; 1F:00E3, 0x03E0E3
    CLC ; Prep add.
    LDA #$04 ; Adding.
    ADC BCD/MODULO/DIGITS_USE_C ; Add with.
    STA BCD/MODULO/DIGITS_USE_C ; Store 
    JSR ENGINE_FPTR_COL/ROW_MOD/FORWARD? ; Do mod.
    DEC SAVE_ID_FOCUS/OTHER ; --
    BNE LOOP_NONZERO ; == 0, goto.
    RTS ; Leave.
ENGINE_HELPER_LOAD_7400_INDEX_A&3F: ; 1F:00F2, 0x03E0F2
    AND #$3F ; Keep group count/data index.
    TAX ; To X index.
    LDA CURRENT_SAVE_MANIPULATION_PAGE[768],X ; Load from.
    RTS ; Leave.
SWITCH_SCRIPT_ROUTINES: ; 1F:00F9, 0x03E0F9
    ASL A ; << 2, *4.
    ASL A
    TAX ; To X index.
    LDA SCRIPT_SWITCH_RTNS_L,X ; Routine RTS addr to stack.
    PHA
    LDA SCRIPT_SWITCH_RTNS_H,X
    PHA
    RTS ; Run it.
SCRIPT_SWITCH_RTNS_H: ; 1F:0105, 0x03E105
    LOW(SCRIPT_RTN_A) ; 0x00
SCRIPT_SWITCH_RTNS_L: ; 1F:0106, 0x03E106
    HIGH(SCRIPT_RTN_A) ; RTS, NOOP.
SCRIPT_ATTRIBUTES_A: ; 1F:0107, 0x03E107
    .db 00
SCRIPT_ATTRIBUTE_B: ; 1F:0108, 0x03E108
    .db 00
    LOW(SCRIPT_RTN_B) ; 0x01
    HIGH(SCRIPT_RTN_B)
    .db 00
    .db 88
    LOW(SCRIPT_RTN_B)
    HIGH(SCRIPT_RTN_B)
    .db 00
    .db 88
    LOW(SCRIPT_RTN_C)
    HIGH(SCRIPT_RTN_C)
    .db 00
    .db 88
    LOW(SCRIPT_RTN_D)
    HIGH(SCRIPT_RTN_D)
    .db 00
    .db 08
    LOW(SCRIPT_RTN_A) ; RTS
    HIGH(SCRIPT_RTN_A)
    .db 00
    .db 00
    LOW(SCRIPT_RTN_A)
    HIGH(SCRIPT_RTN_A)
    .db 00
    .db 00
    LOW(SCRIPT_RTN_F)
    HIGH(SCRIPT_RTN_F)
    .db 04
    .db A6
    LOW(SCRIPT_RTN_G_ELSEWHERE)
    HIGH(SCRIPT_RTN_G_ELSEWHERE)
    .db 04
    .db 60
    LOW(SCRIPT_RTN_H)
    HIGH(SCRIPT_RTN_H)
    .db 09
    .db 20
    LOW(SCRIPT_RTN_I)
    HIGH(SCRIPT_RTN_I)
    .db 09
    .db 20
    LOW(SCRIPT_RTN_J)
    HIGH(SCRIPT_RTN_J)
    .db 09
    .db 20
    LOW(SCRIPT_RTN_K)
    HIGH(SCRIPT_RTN_K)
    .db 04
    .db 60
    LOW(SCRIPT_RTN_L_VERY_IMPORTANT_BANKED_HANDLES)
    HIGH(SCRIPT_RTN_L_VERY_IMPORTANT_BANKED_HANDLES)
    .db 09
    .db 20
    LOW(SCRIPT_RTN_M)
    HIGH(SCRIPT_RTN_M)
    .db 09
    .db 20
    LOW(SCRIPT_RTN_N)
    HIGH(SCRIPT_RTN_N)
    .db 04
    .db 20
    LOW(SCRIPT_RTN_O_SET_SWITCH_EXIT_JMP)
    HIGH(SCRIPT_RTN_O_SET_SWITCH_EXIT_JMP)
    .db 04
    .db E6
    LOW(SCRIPT_RTN_P)
    HIGH(SCRIPT_RTN_P)
    .db 04
    .db E6
    LOW(SCRIPT_RTN_Q)
    HIGH(SCRIPT_RTN_Q)
    .db 04
    .db E6
    LOW(SCRIPT_RTN_R)
    HIGH(SCRIPT_RTN_R)
    .db 04
    .db E6
    LOW(SCRIPT_RTN_S)
    HIGH(SCRIPT_RTN_S)
    .db 04
    .db E6
    LOW(SCRIPT_RTN_T)
    HIGH(SCRIPT_RTN_T)
    .db 04
    .db E6
    LOW(SCRIPT_RTN_U)
    HIGH(SCRIPT_RTN_U)
    .db 04
    .db E6
    LOW(SCRIPT_RTN_V)
    HIGH(SCRIPT_RTN_V)
    .db 04
    .db E6
    LOW(SCRIPT_RTN_W)
    HIGH(SCRIPT_RTN_W)
    .db 00
    .db C4
    LOW(SCRIPT_RTN_W)
    HIGH(SCRIPT_RTN_W)
    .db 04
    .db C6
    LOW(SCRIPT_RTN_W)
    HIGH(SCRIPT_RTN_W)
    .db 09
    .db 46
    LOW(SCRIPT_RTN_W)
    HIGH(SCRIPT_RTN_W)
    .db 00
    .db 44
    LOW(SCRIPT_RTN_X)
    HIGH(SCRIPT_RTN_X)
    .db 00
    .db C4
    LOW(SCRIPT_RTN_X)
    HIGH(SCRIPT_RTN_X)
    .db 04
    .db C6
    LOW(SCRIPT_RTN_X)
    HIGH(SCRIPT_RTN_X)
    .db 09
    .db 46
    LOW(SCRIPT_RTN_X)
    HIGH(SCRIPT_RTN_X)
    .db 00
    .db 44
    LOW(SCRIPT_RTN_Y)
    HIGH(SCRIPT_RTN_Y)
    .db 04
    .db 88
    LOW(SCRIPT_RTN_Z)
    HIGH(SCRIPT_RTN_Z)
    .db 04
    .db C6
    LOW(SCRIPT_RTN_Q)
    HIGH(SCRIPT_RTN_Q)
    .db 02
    .db E6
    LOW(SCRIPT_RTN_W)
    HIGH(SCRIPT_RTN_W)
    .db 0A
    .db 56
    LOW(SCRIPT_RTN_W)
    HIGH(SCRIPT_RTN_W)
    .db 04
    .db 56
    LOW(SCRIPT_RTN_W)
    HIGH(SCRIPT_RTN_W)
    .db 08
    .db C6
    LOW(SCRIPT_RTN_AA) ; AA
    HIGH(SCRIPT_RTN_AA)
    .db 04
    .db A6
    LOW(SCRIPT_RTN_AB) ; AB
    HIGH(SCRIPT_RTN_AB)
    .db 04
    .db C6
    LOW(SCRIPT_RTN_AC) ; AC
    HIGH(SCRIPT_RTN_AC)
    .db 09
    .db 46
    LOW(SCRIPT_RTN_AD) ; AD
    HIGH(SCRIPT_RTN_AD)
    .db 00
    .db 45
    LOW(SCRIPT_RTN_AE) ; AE
    HIGH(SCRIPT_RTN_AE)
    .db 00
    .db 45
    LOW(SCRIPT_RTN_AF) ; AF
    HIGH(SCRIPT_RTN_AF)
    .db 0A
    .db C6
    LOW(SCRIPT_RTN_AH) ; AG
    HIGH(SCRIPT_RTN_AH)
    .db 09
    .db 46
    LOW(SCRIPT_RTN_X) ; X
    HIGH(SCRIPT_RTN_X)
    .db 04
    .db 46
SCRIPT_RTN_A: ; 1F:01BD, 0x03E1BD
    RTS
MAP?_RTN_A: ; 1F:01BE, 0x03E1BE
    LDY #$04 ; Stream index.
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Move ??
    STA STREAM_WRITE_ARR_UNK[4] ; Store to.
    INY ; Stream++
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Move ??
    STA STREAM_WRITE_ARR_UNK+1
    LDY #$06 ; Restream to same.
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Move ??
    STA STREAM_WRITE_ARR_UNK+2
    INY
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Move ??
    STA STREAM_WRITE_ARR_UNK+3
ENGINE_SCRIPTY_RESULT_TEST_UNK: ; 1F:01D4, 0x03E1D4
    SEC ; Prep sub.
    LDA STREAM_WRITE_ARR_UNK+2 ; Load ??
    SBC SCRIPT_PAIR_PTR?[2] ; Sub with.
    STA SAVE_GAME_MOD_PAGE_PTR[2] ; Store to.
    LDA STREAM_WRITE_ARR_UNK+3 ; Load ??
    SBC SCRIPT_PAIR_PTR?+1 ; Carry sub.
    STA SAVE_GAME_MOD_PAGE_PTR+1 ; Store to.
    SEC ; Prep sub.
    LDA #$C0 ; Seed ??
    SBC SAVE_GAME_MOD_PAGE_PTR[2] ; Sub with.
    LDA #$03 ; Load ??
    SBC SAVE_GAME_MOD_PAGE_PTR+1 ; Sub with.
    BCC RTS ; Underflow, goto.
    LDA SCRIPT_PAIR_PTR_B_SEED?[2] ; Load ??
    SBC #$40 ; Sub with.
    STA BCD/MODULO/DIGITS_USE_A ; Store to.
    LDA SCRIPT_PAIR_PTR_B_SEED?+1 ; Load ??
    SBC #$00 ; Carry sub.
    STA BCD/MODULO/DIGITS_USE_B ; Store to.
    SEC ; Prep sub.
    LDA STREAM_WRITE_ARR_UNK[4] ; Load ??
    SBC BCD/MODULO/DIGITS_USE_A ; Sub with.
    STA BCD/MODULO/DIGITS_USE_A ; Store.
    LDA STREAM_WRITE_ARR_UNK+1 ; Load ??
    SBC BCD/MODULO/DIGITS_USE_B ; Carry sub.
    STA BCD/MODULO/DIGITS_USE_B ; Store to.
    SEC ; Prep sub.
    LDA #$80 ; Seed ??
    SBC BCD/MODULO/DIGITS_USE_A ; Sub with.
    LDA #$04 ; Seed ??
    SBC BCD/MODULO/DIGITS_USE_B ; Sub with.
RTS: ; 1F:020E, 0x03E20E
    RTS ; Return result.
LIB_SCRIPT_DIRECT_UNK_A: ; 1F:020F, 0x03E20F
    JSR SETUP_PTR_6780_UNK ; Setup ptr.
    LDY #$15 ; Stream index.
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load from file.
    ASL A ; << 3, *8. To tile index.
    ASL A
    ASL A
    TAX ; To X index.
    LDA DATA_UNK_C,X ; Load ??
    ASL A ; << 1, *2.
    TAX ; To X index.
    STA OBJ_PROCESS_COUNT_LEFT? ; Store ??
    LDY #$11 ; Load ??
    LDA DATA_UNK_B,X ; Load ??
    ASL A ; << 4, *16.
    ASL A
    ASL A
    ASL A
    CLC ; Prep add.
    ADC [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Add with.
    STA STREAM_DEEP_INDEX ; Store to.
    INY ; Stream++
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Move ??
    STA STREAM_DEEP_C ; Store to.
    INY ; Stream++
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Move ??
    STA STREAM_DEEP_D?
    CLC ; Prep add.
    LDA STREAM_DEEP_INDEX ; Load ??
    ADC DATA_UNK_A,X ; Add with.
    TAX ; To X index.
    EOR STREAM_DEEP_INDEX ; Invert ??
    AND #$F0 ; Keep upper.
    BEQ EXIT_WRITE_INDEX ; == 0, goto.
    LDA STREAM_DEEP_INDEX ; Load ??
    AND #$F0 ; Keep upper.
    STA STREAM_DEEP_INDEX ; Store to.
    TXA ; X to A.
    AND #$0F ; Keep lower.
    ORA STREAM_DEEP_INDEX ; Combine with.
    TAX ; To X index.
    LDA STREAM_DEEP_D? ; Invert ??
    EOR #$01
    STA STREAM_DEEP_D?
EXIT_WRITE_INDEX: ; 1F:0258, 0x03E258
    STX STREAM_DEEP_INDEX ; Store to, index.
    JSR SUB_STREAM_RESET_TO_??_AND_PTR/VAL_RTN ; Do.
EXIT_PTR_MOVE/PROMOTE?: ; 1F:025D, 0x03E25D
    LDX SCRIPT_MAIN_FPTR[2] ; Move PTR to PTR.
    LDY SCRIPT_MAIN_FPTR+1
    STX ENGINE_MAP_OBJ_RESERVATIONS/??[2]
    STY ENGINE_MAP_OBJ_RESERVATIONS/??+1
    RTS
LIB_RTN_PTR_CREATION/SHIFT+CLEAR_UNK_MOVE_PTR_DOWN_UNK: ; 1F:0266, 0x03E266
    LDA MAIN_FLAG_UNK ; Load ??
    AND #$7F ; Keep lower.
    JSR PTR_CREATE_AND_LOAD_STREAM_0x14 ; Do ??
    ASL MAIN_FLAG_UNK ; << ??
    LDX #$00
    STX MAIN_FLAG_UNK ; Clear ??
    BEQ EXIT_PTR_MOVE/PROMOTE? ; Always taken.
SUB_STREAM_RESET_TO_??_AND_PTR/VAL_RTN: ; 1F:0275, 0x03E275
    LDY STREAM_DEEP_INDEX ; Load stream index.
    LDA [STREAM_DEEP_C],Y ; Load ??
    BEQ RTS ; == 0, leave.
    BMI NEGATIVE_SLOT_SKIP?
    SEC ; Prep sub.
    LDA #$28 ; Load ??
    SBC [STREAM_DEEP_C],Y ; Sub with stream value.
NEGATIVE_SLOT_SKIP?: ; 1F:0282, 0x03E282
    CLC ; Prep add.
    ADC #$04 ; += 0x4
    TAX ; To X index.
PTR_CREATE_AND_LOAD_STREAM_0x14: ; 1F:0286, 0x03E286
    STA SCRIPT_MAIN_FPTR+1 ; Store to.
    LDA #$00 ; Ptr create clear.
    LSR SCRIPT_MAIN_FPTR+1 ; >> 1
    ROR A ; Into A.
    LSR SCRIPT_MAIN_FPTR+1 ; 2x
    ROR A
    LSR SCRIPT_MAIN_FPTR+1 ; 3x
    ROR A
    ADC #$80 ; += 0x80 + 1110.0000
    STA SCRIPT_MAIN_FPTR[2]
    LDA SCRIPT_MAIN_FPTR+1 ; Load leftover.
    ADC #$67 ; += 0x67
    STA SCRIPT_MAIN_FPTR+1 ; To PTR H.
    LDY #$14 ; Depth into.
    LDA [SCRIPT_MAIN_FPTR[2]],Y ; Load it.
RTS: ; 1F:02A1, 0x03E2A1
    RTS ; Return.
LIB_SCRIPT_DIRECT_UNK_B: ; 1F:02A2, 0x03E2A2
    LDY #$14 ; Stream index.
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load ??
    AND #$20 ; Keep upper.
    BEQ RTS ; Clear, leave.
    JSR ENGINE_WRAM_STATE_WRITEABLE ; Do WRAM.
    CLC ; Prep add.
    LDA OBJ_PROCESS_COUNT_LEFT? ; Load ??
    ADC #$20 ; += 0x20
    AND #$38 ; Keep 0011.1000
    TAX ; To X index.
    LDY #$15 ; Stream index.
    LSR A ; >> 3, /8.
    LSR A
    LSR A
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Store to file.
    JSR ENGINE_WRAM_STATE_WRITE_DISABLED ; Disable.
DATA_MAP_RESERVATION_HELPER?_TODO: ; 1F:02BF, 0x03E2BF
    LDA DATA_UNK_C,X ; Load ??
    CLC ; Prep add.
    LDY #$16 ; Stream index.
    ADC [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Add from file.
    STA BCD/MODULO/DIGITS_USE_A ; Store to.
    LDA #$00 ; Seed ??
    INY ; Stream++
    ADC [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Add with stream.
    STA BCD/MODULO/DIGITS_USE_B ; Store to.
    LDA #$15
    LDX #$06
    JSR ENGINE_MAPPER_COMMIT_BANK_X_VAL_A ; Seed R6 0x15
    LDY #$10 ; Stream index.
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load ??
    TAY ; To Y index.
    LDA OBJ?_BYTE_0x0_STATUS?,Y ; Load ??
    AND #$3F ; Keep 0011.1111
    STA OBJ_PROCESS_COUNT_LEFT? ; Store count.
    BEQ RTS ; == 0, leave.
    LDA BCD/MODULO/DIGITS_USE_A ; Move ?? to arr spot.
    STA OBJ?_PTR?[2],Y
    LDA BCD/MODULO/DIGITS_USE_B
    STA OBJ?_PTR?+1,Y
    LDA OBJ?_BYTE_0x2_UNK,Y ; Slot to ?? A
    STA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY[8]
    LDA OBJ?_BYTE_0x3_UNK,Y ; B
    STA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY+1
    LDA OBJ?_BYTE_0x1_UNK,Y ; Load ??
    ASL A ; << 2, *4.
    ASL A
    TAX ; To X index.
    LDY #$00 ; Stream index.
    LDA [BCD/MODULO/DIGITS_USE_A],Y ; Load from file.
    STA SAVE_GAME_MOD_PAGE_PTR[2] ; Store to.
    INY ; Stream++
    LDA [BCD/MODULO/DIGITS_USE_A],Y ; 2x
    STA SAVE_GAME_MOD_PAGE_PTR+1
    INY
    LDA [BCD/MODULO/DIGITS_USE_A],Y ; 3x
    STA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY+2
    INY
    LDA [BCD/MODULO/DIGITS_USE_A],Y ; 4x
    STA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY+3
    SEC ; Seed CS.
OBJECT_DISPLAY_HELPER_UNK: ; 1F:0315, 0x03E315
    BIT NMI_FLAG_OBJECT_PROCESSING? ; Test.
    BVS OBJECT_DISPLAY_HELPER_UNK ; If 0x40 set, loop. TODO: Wrong CMP? Maybe BMI meant?
    ROR NMI_FLAG_OBJECT_PROCESSING? ; Rotate in CS.
    LDY #$00 ; Stream index.
TODO_MORE_OBJS: ; 1F:031D, 0x03E31D
    LDA SPRITE_PAGE[256],X ; Load Ypos of X index.
    CMP #$F0 ; If _ #$F0
    BEQ INC_Y_AND_X_INDEXES ; ==, goto.
    CLC ; Prep add.
    LDA [SAVE_GAME_MOD_PAGE_PTR[2]],Y ; Load.
    ADC RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY[8] ; Add with.
    STA SPRITE_PAGE+3,X ; Store to Xpos.
    INY ; Stream++
    CLC ; Prep add.
    LDA [SAVE_GAME_MOD_PAGE_PTR[2]],Y ; Load from stream.
    ADC RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY+1 ; Add with.
    STA SPRITE_PAGE[256],X ; Store to Ypos.
    INY ; Stream++
    LDA [SAVE_GAME_MOD_PAGE_PTR[2]],Y ; Load from stream. TODO clarify this better in docs as bits change attr out.
    STA BCD/MODULO/DIGITS_USE_A ; Store to. Attrs base.
    LDA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY+3 ; Seed shift.
    LSR BCD/MODULO/DIGITS_USE_A ; >> var. Test flips disable?
    BCC PALETTE_KEEP? ; CC, goto.
    LSR A ; Shift off what would be color.
    LSR A
PALETTE_KEEP?: ; 1F:0342, 0x03E342
    LSR BCD/MODULO/DIGITS_USE_A ; Shift var. Tests palette only?
    BCC UPPER_KEEP? ; Clear, goto.
    LSR A ; >> 4, /16. Shift down what would be VHB0 bits.
    LSR A
    LSR A
    LSR A
UPPER_KEEP?: ; 1F:034A, 0x03E34A
    AND #$03 ; Keep palette only.
    ASL BCD/MODULO/DIGITS_USE_A ; Shift test bits back but clear.
    ASL BCD/MODULO/DIGITS_USE_A
    ORA BCD/MODULO/DIGITS_USE_A ; Set attrs with what is left.
    STA SPRITE_PAGE+2,X ; Store as attributes.
    INY ; Stream++
    CLC ; Prep add.
    AND #$10 ; Keep ??
    BEQ TEST_C_CLEAR ; Clear, goto. Tile rebase bit.
    LDA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY+2 ; Seed alt tile base.
TEST_C_CLEAR: ; 1F:035D, 0x03E35D
    ADC [SAVE_GAME_MOD_PAGE_PTR[2]],Y ; Add with stream.
    STA SPRITE_PAGE+1,X ; Store to, tile ID.
    INY ; Stream++
    BNE INC_X_INDEX_ONLY ; Nonzero, goto.
INC_Y_AND_X_INDEXES: ; 1F:0365, 0x03E365
    INY
    INY
    INY
    INY
INC_X_INDEX_ONLY: ; 1F:0369, 0x03E369
    INX ; Sprite slot ++
    INX
    INX
    INX
    BEQ EXIT_OBJECT_PROCESSING
    DEC OBJ_PROCESS_COUNT_LEFT? ; --
    BNE TODO_MORE_OBJS ; != 0, goto.
EXIT_OBJECT_PROCESSING: ; 1F:0373, 0x03E373
    ASL NMI_FLAG_OBJECT_PROCESSING? ; Unlock.
    RTS ; Leave.
SCRIPT_UNK_R6_AND_FILE_UNK: ; 1F:0376, 0x03E376
    LDA SCRIPT_USE_UNK_C_PTR_H ; Load ??
    LSR A ; Nibble down.
    LSR A
    LSR A
    LSR A
    AND #$0E ; Keep.
    ORA #$01 ; Set bottom.
    LDX #$06 ; Set R6.
    JSR ENGINE_MAPPER_COMMIT_BANK_X_VAL_A ; Set bank.
    LDA SCRIPT_USE_UNK_C_PTR_H ; Load ??
    LSR A ; >> 2
    LSR A
    AND #$07 ; Keep bottom.
    STA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY+1 ; Store bits here.
    LDA SCRIPT_USE_UNK_A ; Load ??
    AND #$FC ; Keep 1111.1100
    CLC ; Prep add.
    STA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY[8] ; Store bits.
    LDA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY+1 ; Load ??
    ADC #$98 ; Add base.
    STA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY+1 ; Store to.
    LDY #$01 ; Stream index.
    LDA [RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY[8]],Y ; Load from file.
    AND #$3F ; Keep lower.
    LDY #$01 ; Stream index.
    CMP [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; If _ file
    BNE FILE_MISMATCH ; Mismatch, goto.
    LDA SCRIPT_R6_ROUTINE_SELECT ; Load ??
    JSR BANK_HANDLER_R6_AND_BASE_FILE? ; Do.
    CLC ; Ret CC.
    RTS
FILE_MISMATCH: ; 1F:03AD, 0x03E3AD
    LDA SCRIPT_R6_ROUTINE_SELECT ; Load val.
    JSR BANK_HANDLER_R6_AND_BASE_FILE? ; Bank and base.
    SEC ; Ret CS.
    RTS ; Leave.
BANK/MOVE/RUN_RTN_SWITCH_UNK: ; 1F:03B4, 0x03E3B4
    LDA #$14
    LDX #$06
    JSR ENGINE_MAPPER_COMMIT_BANK_X_VAL_A ; Set R6 to bank 0x14.
    LDA STREAM_DEEP_C ; Move ??
    STA STREAM_UNK_DEEP_A[2]
    LDA ROUTINE_SWITCH_ID_TODO ; Load.
    ASL A ; To word index.
    TAX ; To index.
    LDA RTN_PTRS_H,X ; Move routine RTS ptr.
    PHA
    LDA RTN_PTRS_L,X
    PHA
    RTS ; Run it.
RTN_PTRS_L: ; 1F:03CC, 0x03E3CC
    LOW(RTN_ARR_RTN_A) ; TODO TODO TODO
RTN_PTRS_H: ; 1F:03CD, 0x03E3CD
    HIGH(RTN_ARR_RTN_A) ; 0x00
    LOW(RTN_ARR_RTN_B)
    HIGH(RTN_ARR_RTN_B) ; 0x01
    LOW(RTN_ARR_RTN_C)
    HIGH(RTN_ARR_RTN_C) ; 0x02
    LOW(RTN_ARR_RTN_D)
    HIGH(RTN_ARR_RTN_D) ; 0x03
    LOW(RTN_ARR_RTN_E)
    HIGH(RTN_ARR_RTN_E) ; 0x04
    LOW(RTN_ARR_RTN_F)
    HIGH(RTN_ARR_RTN_F) ; 0x05
    LOW(RTN_ARR_RTN_G)
    HIGH(RTN_ARR_RTN_G) ; 0x06
    LOW(RTN_ARR_RTN_H)
    HIGH(RTN_ARR_RTN_H) ; 0x07
    LOW(R6_BANK_WITH_RET_CS) ; Banks, returns CS.
    HIGH(R6_BANK_WITH_RET_CS) ; 0x08
RTN_ARR_RTN_C: ; 1F:03DE, 0x03E3DE
    .db 20 ; Do.
    ASL NMI_FLAG_EXECUTE_UPDATE_BUF_AND_MORE_TODO ; << 1
    TAX ; To X index.
    AND #$30 ; Keep 0011.0000
    BEQ VAL_EQ_0x00 ; == 0, goto.
    AND #$20 ; Keep other bit.
    BEQ EXIT_JMP_R6_SET ; Clear, goto.
    TXA ; X to A.
    AND #$1C ; Keep mid.
    BNE EXIT_JMP_R6_SET ; Set, goto.
VAL_EQ_0x00: ; 1F:03EF, 0x03E3EF
    LDX #$FF ; Seed ??
    LDY #$00
    JSR STREAMS_AND_SPRITE_CHECK_IDK ; Do ??
    TAX ; To X.
    AND #$20 ; Test ??
    BEQ EXIT_R6_BANK_WITH_RET_CC ; == 0, goto.
    TXA ; X to A.
    AND #$03 ; Keep lower.
    BEQ EXIT_R6_BANK_WITH_RET_CC ; Clear, goto.
EXIT_JMP_R6_SET: ; 1F:0400, 0x03E400
    JMP R6_BANK_WITH_RET_CS ; Exit other.
RTN_ARR_RTN_G: ; 1F:0403, 0x03E403
    JSR SUB_SEED_UNK_AND_UNK ; Do ??
    TAX ; To X.
    AND #$30 ; Keep ??
    BEQ BITS_CLEAR ; Clear, goto.
    AND #$20 ; Test.
    BEQ EXIT_JMP_R6_SET ; If clear, goto.
    TXA ; X to A.
    AND #$13 ; Keep ??
    BNE EXIT_JMP_R6_SET ; Set, goto.
BITS_CLEAR: ; 1F:0414, 0x03E414
    LDX #$01 ; Seed ??
    LDY #$00
    JSR STREAMS_AND_SPRITE_CHECK_IDK ; Do ??
    TAX ; To X.
    AND #$20 ; Test ??
    BEQ EXIT_R6_BANK_WITH_RET_CC ; == 0, goto.
    TXA ; X to A.
    AND #$0C ; Keep ??
    BNE EXIT_JMP_R6_SET ; Set, goto.
EXIT_R6_BANK_WITH_RET_CC: ; 1F:0425, 0x03E425
    JMP R6_BANK_WITH_RET_CC ; Goto.
RTN_ARR_RTN_A: ; 1F:0428, 0x03E428
    JSR SUB_SEED_UNK_AND_UNK ; Do ??
    AND #$16 ; Keep ??
    BNE R6_BANK_WITH_RET_CS ; Set, goto.
    LDX #$00 ; Seed ??
    LDY #$10
    JSR STREAMS_AND_SPRITE_CHECK_IDK ; Do ??
    AND #$09 ; Keep ??
    BNE R6_BANK_WITH_RET_CS ; Set, goto.
    BEQ R6_BANK_WITH_RET_CC ; Clear, goto.
RTN_ARR_RTN_B: ; 1F:043C, 0x03E43C
    JSR SUB_SEED_UNK_AND_UNK ; Do ??
    AND #$14 ; Keep ??
    BNE R6_BANK_WITH_RET_CS ; Set, goto.
    LDX #$00 ; Seed ??
    LDY #$10
    JSR STREAMS_AND_SPRITE_CHECK_IDK
    AND #$08 ; Keep ??
    BNE R6_BANK_WITH_RET_CS ; Set, goto.
    LDX #$FF ; Seed ??
    LDY #$00
    JSR STREAMS_AND_SPRITE_CHECK_IDK ; Do ??
    AND #$02 ; Keep ??
    BNE R6_BANK_WITH_RET_CS ; Set, goto.
    LDX #$FF ; Seed ??
    LDY #$10
    JSR STREAMS_AND_SPRITE_CHECK_IDK ; Do ??
    AND #$01 ; Keep lower.
    BNE R6_BANK_WITH_RET_CS ; Set, goto.
    BEQ R6_BANK_WITH_RET_CC ; Clear.
RTN_ARR_RTN_H: ; 1F:0466, 0x03E466
    JSR SUB_SEED_UNK_AND_UNK ; Do ??
    AND #$12 ; Keep ??
    BNE R6_BANK_WITH_RET_CS ; If set, goto.
    LDX #$00 ; Seed ??
    LDY #$10
    JSR STREAMS_AND_SPRITE_CHECK_IDK ; Do ??
    AND #$01 ; Keep lower.
    BNE R6_BANK_WITH_RET_CS ; Set, goto.
    LDX #$01 ; Seed ??
    LDY #$00
    JSR STREAMS_AND_SPRITE_CHECK_IDK ; Do ??
    AND #$04 ; Keep ??
    BNE R6_BANK_WITH_RET_CS ; Set, goto.
    LDX #$01 ; Seed ??
    LDY #$10
    JSR STREAMS_AND_SPRITE_CHECK_IDK ; Do ??
    AND #$08 ; Test ??
    BNE R6_BANK_WITH_RET_CS ; Set, goto.
    BEQ R6_BANK_WITH_RET_CC ; Clear, goto.
R6_BANK_WITH_RET_CS: ; 1F:0490, 0x03E490
    LDA SCRIPT_R6_ROUTINE_SELECT ; Load rtn.
    JSR BANK_HANDLER_R6_AND_BASE_FILE? ; Bank in.
    SEC ; Ret CS.
    RTS ; Leave.
R6_BANK_WITH_RET_CC: ; 1F:0497, 0x03E497
    LDA SCRIPT_R6_ROUTINE_SELECT ; Load rtn.
    JSR BANK_HANDLER_R6_AND_BASE_FILE? ; Bank in.
    CLC ; Ret CC.
    RTS ; Leave.
RTN_ARR_RTN_E: ; 1F:049E, 0x03E49E
    JSR SUB_SEED_UNK_AND_UNK ; Do.
    AND #$19 ; Keep 0001.1001
    BNE R6_BANK_WITH_RET_CS ; Set, goto.
    LDX #$00 ; Seed ??
    LDY #$F0
    JSR STREAMS_AND_SPRITE_CHECK_IDK ; Do.
    AND #$06 ; Keep 0000.0110
    BNE R6_BANK_WITH_RET_CS ; Set, goto.
    BEQ R6_BANK_WITH_RET_CC ; == 0, goto.
RTN_ARR_RTN_D: ; 1F:04B2, 0x03E4B2
    JSR SUB_SEED_UNK_AND_UNK ; Do sub.
    AND #$18 ; Keep ??
    BNE R6_BANK_WITH_RET_CS ; Set, goto.
    LDX #$00 ; Seed ??
    LDY #$F0
    JSR STREAMS_AND_SPRITE_CHECK_IDK ; Do ??
    AND #$04 ; Test ??
    BNE R6_BANK_WITH_RET_CS ; Set, goto.
    LDX #$FF ; Seed ??
    LDY #$00
    JSR STREAMS_AND_SPRITE_CHECK_IDK ; Do ??
    AND #$01 ; Test ??
    BNE R6_BANK_WITH_RET_CS ; Set, goto.
    LDX #$FF ; Seed ??
    LDY #$F0
    JSR STREAMS_AND_SPRITE_CHECK_IDK ; Do ??
    AND #$02 ; Test ??
    BNE R6_BANK_WITH_RET_CS ; Set, goto.
    BEQ R6_BANK_WITH_RET_CC ; == 0, goto.
RTN_ARR_RTN_F: ; 1F:04DC, 0x03E4DC
    JSR SUB_SEED_UNK_AND_UNK ; Do ??
    AND #$11 ; Test ??
    BNE R6_BANK_WITH_RET_CS ; Set, goto.
    LDX #$00 ; Seed ??
    LDY #$F0
    JSR STREAMS_AND_SPRITE_CHECK_IDK ; Do ??
    AND #$02 ; Test ??
    BNE R6_BANK_WITH_RET_CS ; Set, goto.
    LDX #$01 ; Seed ??
    LDY #$00
    JSR STREAMS_AND_SPRITE_CHECK_IDK ; Do ??
    AND #$08 ; Test ??
    BNE R6_BANK_WITH_RET_CS ; Set, goto.
    LDX #$01 ; Seed ??
    LDY #$F0
    JSR STREAMS_AND_SPRITE_CHECK_IDK ; Do ??
    AND #$04 ; Set ??
    BNE R6_BANK_WITH_RET_CS ; Set, goto.
    BEQ R6_BANK_WITH_RET_CC ; Not, goto.
SUB_SEED_UNK_AND_UNK: ; 1F:0506, 0x03E506
    LDX #$00 ; Seed ??
    LDY #$00
    JSR STREAMS_AND_SPRITE_CHECK_IDK ; Do ??
    STA OBJ_PROCESS_COUNT_LEFT? ; Store ??
    RTS ; Leave.
STREAMS_AND_SPRITE_CHECK_IDK: ; 1F:0510, 0x03E510
    CLC ; Prep add.
    TYA ; Y to A.
    ADC STREAM_DEEP_INDEX ; Add with.
    STA STREAM_UNK_DEEP_A+1 ; Store result.
    CLC ; Prep add.
    TXA ; X to A.
    ADC STREAM_UNK_DEEP_A+1 ; Add to.
    TAY ; Value to Y.
    EOR STREAM_UNK_DEEP_A+1 ; Invert ??
    AND #$F0 ; Keep upper nibble.
    BEQ UPPER_EQ_0x00 ; == 0, goto.
    LDA STREAM_UNK_DEEP_A+1 ; Load ??
    AND #$F0 ; Keep nibble.
    STA STREAM_UNK_DEEP_A+1 ; Store back.
    TYA ; Y to A.
    AND #$0F ; Keep lower.
    ORA STREAM_UNK_DEEP_A+1 ; Combine with.
    TAY ; To Y index.
    LDA #$01 ; Seed invert ??
UPPER_EQ_0x00: ; 1F:052F, 0x03E52F
    EOR STREAM_DEEP_D? ; Invert with.
    CLC ; Prep add.
    ADC #$FC ; Add with.
    STA STREAM_UNK_DEEP_A+1 ; Store to, PTR H.
    LDA #$00
    STA STREAM_DEEP_B ; Clear ??
    LDA [STREAM_UNK_DEEP_A[2]],Y ; Load stream.
    BMI STREAM_NEGATIVE ; Negative, goto.
    LDA SCRIPT_R6_UNK/R2_GFX_BANK_UNK ; Load ??
    BIT SPRITE_PAGE+165 ; Test ?? TODO: Bug? Why?
    LSR A ; A >> 1
    ROR STREAM_DEEP_B ; Rotate into.
    ADC #$80 ; Add with.
    STA R_**:$00A5 ; Store to.
    LDA [STREAM_UNK_DEEP_A[2]],Y ; Load from stream.
    AND #$7F ; Keep lower.
    TAY ; To Y index.
    LDA [STREAM_DEEP_B],Y ; Load other stream.
    RTS ; Return stream val.
DATA_INDEX_SWITCH_MOVE_UNK_SHIFTED: ; 1F:0552, 0x03E552
    JSR ROUTINE_SWITCH_TO_DATA_SLOT_INDEX_X ; Get data index.
    LDY #$0C ; Stream index ??
    LDA DATA_UNK_A,X ; Load ??
    ASL A ; << 1, *2.
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Store to engine ptr.
    INY ; Stream++
    LDA DATA_UNK_B,X ; Load data.
    ASL A ; << 1, *2.
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Store to PTR.
    JMP ENTRY_UNK ; Goto.
DATA_INDEX_SWITCH_UNK_MOVEMENT?: ; 1F:0567, 0x03E567
    JSR ROUTINE_SWITCH_TO_DATA_SLOT_INDEX_X ; Get data index.
    LDY #$0C ; Stream index ??
    LDA DATA_UNK_A,X ; Move from data to engine.
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y
    INY ; Stream++
    LDA DATA_UNK_B,X ; Move data from engine.
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y
ENTRY_UNK: ; 1F:0577, 0x03E577
    LDY #$08 ; Stream index.
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load from file.
    AND #$3F ; Keep lower.
    ORA #$40 ; Set ??
    STA BCD/MODULO/DIGITS_USE_A ; Store to.
    LDA ROUTINE_SWITCH_ID_TODO ; Load val.
    LSR A ; >> 1, /2.
    AND #$40 ; Keep bit.
    EOR BCD/MODULO/DIGITS_USE_A ; Invert with.
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Store to ptr.
    LDY #$09 ; Stream index. ??
    LDA #$38 ; Move ??
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y
    LDY #$15 ; Stream index ??
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load fptr.
    ASL A ; << 3, *8.
    ASL A
    ASL A
    TAX ; To X index.
    LDA DATA_UNK_C,X ; Load data.
EXIT_STREAM_ADD_TOGETHER_FILE_VALS: ; 1F:059B, 0x03E59B
    CLC ; Prep add.
    LDY #$16 ; Stream index.
    ADC [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Add with.
    LDY #$0E ; Stream index.
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Store to.
    LDA #$00 ; Seed ??
    LDY #$17 ; Stream index.
    ADC [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Add with.
    LDY #$0F ; Stream index.
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Store to other.
    RTS ; Leave.
INDEX_AND_MODS_WITH_SHIFT_UNK: ; 1F:05AF, 0x03E5AF
    JSR SUB_INDEX_AND_MODS_UNK ; Do index and mods.
    ASL STREAM_WRITE_ARR_UNK[4] ; << 1.
    ROL STREAM_WRITE_ARR_UNK+1 ; Rotate.
    ASL STREAM_WRITE_ARR_UNK+2 ; << 1.
    ROL STREAM_WRITE_ARR_UNK+3 ; Rotate.
    JMP ENTRY_UNK
INDEX_AND_MODS_NO_SHIFT_UNK: ; 1F:05BD, 0x03E5BD
    JSR SUB_INDEX_AND_MODS_UNK ; Do sub.
ENTRY_UNK: ; 1F:05C0, 0x03E5C0
    CLC ; Prep add.
    LDY #$04 ; Stream index.
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load from stream.
    ADC STREAM_WRITE_ARR_UNK[4] ; Add with.
    STA STREAM_WRITE_ARR_UNK[4] ; Store to.
    AND #$C0 ; Keep upper.
    STA SCRIPT_LOADED_SHIFTED_UNK[2] ; Store to.
    INY ; Stream++
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load from stream.
    ADC STREAM_WRITE_ARR_UNK+1 ; Add with.
    STA STREAM_WRITE_ARR_UNK+1 ; Store to.
    STA SCRIPT_USE_UNK_A ; And to ??
    CLC ; Prep add.
    LDY #$06 ; Stream index.
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load from stream.
    ADC STREAM_WRITE_ARR_UNK+2
    STA STREAM_WRITE_ARR_UNK+2 ; Store to.
    AND #$C0 ; Keep upper.
    STA SCRIPT_USE_UNK_B_PTR_L ; Store to upper.
    INY ; Stream++
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load from stream.
    ADC STREAM_WRITE_ARR_UNK+3 ; Add with.
    STA STREAM_WRITE_ARR_UNK+3 ; Store to.
    STA SCRIPT_USE_UNK_C_PTR_H ; Store to.
    JMP SETUP_DEEP_STREAM_UNK ; Goto.
SUB_INDEX_AND_MODS_UNK: ; 1F:05EF, 0x03E5EF
    JSR ROUTINE_SWITCH_TO_DATA_SLOT_INDEX_X ; Switch to slot index.
    LDA LUT_MOD_ARRAY_MOVEMENT?[4],X ; Move from arr to other.
    STA STREAM_WRITE_ARR_UNK[4]
    LDA LUT_MOD_ARRAY_MOVEMENT?+1,X
    STA STREAM_WRITE_ARR_UNK+1
    LDA LUT_MOD_ARRAY_MOVEMENT?+2,X
    STA STREAM_WRITE_ARR_UNK+2
    LDA LUT_MOD_ARRAY_MOVEMENT?+3,X
    STA STREAM_WRITE_ARR_UNK+3
    RTS ; Leave.
ROUTINE_SWITCH_TO_DATA_SLOT_INDEX_X: ; 1F:0607, 0x03E607
    LDA ROUTINE_SWITCH_ID_TODO ; Load ??
    ASL A ; << 3, *8.
    ASL A
    ASL A
    TAX ; To X index.
    RTS ; Leave.
SUB_PTR_SETUP_CHECK_IDFK_GOSH: ; 1F:060E, 0x03E60E
    JSR SETUP_PTR_FROM_PTR_TODO ; Do ptr setup.
    LDY #$14 ; Stream index.
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load from stream.
    AND #$0F ; Keep lower.
    TAY ; To Y index.
    LDA [SCRIPT_MAIN_FPTR[2]],Y ; Load other stream.
    INY ; Stream++
    CMP #$05 ; If 2nd _ #$05
    BEQ TEST_EXIT ; ==, goto.
    CMP #$06 ; If _ #$06
    BEQ TEST_EXIT_ALT ; ==, goto.
    BNE EXIT_CC ; !=, exit CC.
TEST_EXIT: ; 1F:0625, 0x03E625
    JSR SCRIPT_LOWER_TO_INDEX_AND_UPPER_AS_SAVE_INDEX_TO_RET ; Do.
    AND LIB_LUT_BIT_TEST_0x80-0x01,X ; And with LUT.
    BNE VALUE_SET ; Set, goto.
EXIT_CC: ; 1F:062D, 0x03E62D
    CLC ; Not set, ret CC.
    RTS ; Leave.
TEST_EXIT_ALT: ; 1F:062F, 0x03E62F
    JSR SCRIPT_LOWER_TO_INDEX_AND_UPPER_AS_SAVE_INDEX_TO_RET ; Get value.
    AND LIB_LUT_BIT_TEST_0x80-0x01,X ; Test bit.
    BNE EXIT_CC ; If set, exit CC.
VALUE_SET: ; 1F:0637, 0x03E637
    LDY #$00 ; Stream index.
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load from FPTR.
    ORA #$80 ; Set top bit.
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Store back.
    SEC ; Ret CS.
    RTS
SETUP_PTR_AND_STREAM_PAGE_VAL_TODO: ; 1F:0641, 0x03E641
    JSR SETUP_PTR_FROM_PTR_TODO
    LDY #$04 ; Seed stream index ??
SCRIPT_LOWER_TO_INDEX_AND_UPPER_AS_SAVE_INDEX_TO_RET: ; 1F:0646, 0x03E646
    LDA [SCRIPT_MAIN_FPTR[2]],Y ; Load alt stream.
    AND #$07 ; Keep lower.
    TAX ; To X index.
    LDA [SCRIPT_MAIN_FPTR[2]],Y ; Load alt stream.
    LSR A ; Shift off value to Y.
    LSR A
    LSR A
    TAY ; To Y index.
    LDA CURRENT_SAVE_MANIPULATION_PAGE+512,Y ; Load from page.
    RTS
SETUP_PTR_FROM_PTR_TODO: ; 1F:0655, 0x03E655
    LDY #$02 ; Stream index.
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Move from PTR L from stream to other.
    STA SCRIPT_MAIN_FPTR[2]
    INY ; Stream++
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Move PTR H.
    STA SCRIPT_MAIN_FPTR+1
    RTS ; Leave.
SCRIPT_RTN_AD: ; 1F:0661, 0x03E661
    JSR SETUP_PTR_AND_STREAM_PAGE_VAL_TODO ; Do.
    ORA LIB_LUT_BIT_TEST_0x80-0x01,X ; Set bit.
    BNE BIT_SET_ENTRY ; Always taken.
SCRIPT_RTN_AE: ; 1F:0669, 0x03E669
    JSR SETUP_PTR_AND_STREAM_PAGE_VAL_TODO ; Do.
    ORA LIB_LUT_BIT_TEST_0x80-0x01,X ; Set bit.
    EOR LIB_LUT_BIT_TEST_0x80-0x01,X ; Invert it, turning it off.
BIT_SET_ENTRY: ; 1F:0672, 0x03E672
    STA CURRENT_SAVE_MANIPULATION_PAGE+512,Y ; Store to page.
    JMP SCRIPT_RTN_W ; Goto.
SCRIPT_RTN_D: ; 1F:0678, 0x03E678
    LDY #$1B ; Stream index.
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load from stream.
    BNE STREAM_NE_0x00 ; !=, goto.
    JMP SUB_SWITCH_SET_0x88 ; Goto.
SCRIPT_RTN_B: ; 1F:0681, 0x03E681
    LDY #$15 ; Stream index.
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load from stream.
    ORA #$40 ; Set ??
    LDY #$1B ; Stream index.
    EOR [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Invert with.
    AND #$4F ; Keep 0100.1111
    BEQ STREAM_NE_0x00 ; == 0, goto.
    JSR SUB_SWITCH_SET_0x88 ; Set switch.
    CLC ; Ret CC.
    RTS
STREAM_NE_0x00: ; 1F:0694, 0x03E694
    JSR SETUP_PTR_FROM_PTR_TODO ; Do ptr.
    LDY #$04 ; Stream index.
    JSR MISC_FILE_MANIP_WITH_PTR_32_AS_MANIP ; Do.
    JSR SUB_SWITCH_SET_0x88 ; Do ??
    SEC ; Ret CS.
    RTS
MISC_FILE_MANIP_WITH_PTR_32_AS_MANIP: ; 1F:06A1, 0x03E6A1
    LDA SCRIPT_MAIN_FPTR[2] ; Move FPTR to MISC.
    STA BCD/MODULO/DIGITS_USE_A
    LDA SCRIPT_MAIN_FPTR+1
    STA BCD/MODULO/DIGITS_USE_B
MISC_FILE_MANIP_UNK: ; 1F:06A9, 0x03E6A9
    SEC ; Prep sub.
    LDA [BCD/MODULO/DIGITS_USE_A],Y ; Load from original 32
    SBC #$00 ; Sub with.
    STA CURRENT_SAVE_MANIPULATION_PAGE+4 ; Store to.
    INY ; Stream++
    LDA [BCD/MODULO/DIGITS_USE_A],Y ; Load from ptr.
    SBC #$02 ; Sub with.
    STA CURRENT_SAVE_MANIPULATION_PAGE+5 ; Store to.
    INY ; Stream++
    SEC ; Prep sub.
    LDA [BCD/MODULO/DIGITS_USE_A],Y ; Load stream.
    SBC #$C0 ; Sub with.
    STA CURRENT_SAVE_MANIPULATION_PAGE+6 ; Store to.
    INY ; Stream++
    LDA [BCD/MODULO/DIGITS_USE_A],Y ; Load stream.
    SBC #$01 ; Sub with.
    STA CURRENT_SAVE_MANIPULATION_PAGE+7 ; Store to.
    LDA #$40
    STA FIRST_LAUNCHER_HOLD_FLAG? ; Set flag.
    RTS ; Leave.
SCRIPT_RTN_C: ; 1F:06CF, 0x03E6CF
    JSR SCRIPT_RTN_B ; Do map.
    BCC RTS ; Ret CC, goto.
    LDA #$01
    STA SWITCH_INIT_PORTION? ; Set switch.
RTS: ; 1F:06D8, 0x03E6D8
    RTS ; Leave.
SCRIPT_RTN_AB: ; 1F:06D9, 0x03E6D9
    JSR SUB_PTR_SETUP_CHECK_IDFK_GOSH ; Do sub.
    BCC EXTENDED ; CC, extend.
    RTS ; Leave.
EXTENDED: ; 1F:06DF, 0x03E6DF
    JSR FLAG_SET_MAYBE_FIX_PULL_UNK ; Do ??
    AND #$F0 ; Keep upper.
    LSR A ; >> 3, /8.
    LSR A
    LSR A
    CMP #$08 ; If _ #$08
    BCS VAL_GTE_0x8 ; >=, goto.
    JSR SUB_SWITCH_AND_MORE_UNK ; Do ??
    JMP STREAM_MOD_LOWER_ONLY_UNK ; Goto.
SCRIPT_RTN_Z: ; 1F:06F1, 0x03E6F1
    JSR SUB_PTR_SETUP_CHECK_IDFK_GOSH ; Do ??
    BCC VAL_RET_CC ; CC, goto.
    RTS ; Leave.
VAL_RET_CC: ; 1F:06F7, 0x03E6F7
    JSR FLAG_SET_MAYBE_FIX_PULL_UNK ; Do ??
    AND #$F0 ; Keep upper.
    BNE SCRIPT_RTN_W ; != 0, goto.
VAL_GTE_0x8: ; 1F:06FE, 0x03E6FE
    LDY #$0C ; Stream index.
    LDA #$3D ; Move ??
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y
    INY ; Stream++
    LDA #$EC ; Move ??
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y
    JSR STREAM_MOD_LOWER_ONLY_UNK ; Do ??
    LDY #$09 ; Stream index.
    LDA #$78 ; Val ??
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Store to file.
    LDA #$00 ; Seed ??
    JSR EXIT_STREAM_ADD_TOGETHER_FILE_VALS ; Do.
    JMP SUB_SWITCH_SET_0x88 ; Goto. Abuse RTS.
SCRIPT_RTN_X: ; 1F:071A, 0x03E71A
    JSR SUB_PTR_SETUP_CHECK_IDFK_GOSH
    BCC SCRIPT_RTN_W ; Ret CC, goto.
    RTS ; Leave now.
SCRIPT_RTN_W: ; 1F:0720, 0x03E720
    JSR STREAM_CLEAR_DUBS ; Clear ??
    JSR STREAM_MOD_LOWER_ONLY_UNK ; Do stream.
    JSR STREAM_SET_FILE_DONE? ; Do ??
    LDA #$00 ; Seed ??
    JSR EXIT_STREAM_ADD_TOGETHER_FILE_VALS ; Do add.
SUB_SWITCH_SET_0x88: ; 1F:072E, 0x03E72E
    LDA #$88
    STA ROUTINE_SWITCH_ID_TODO ; Set switch.
    RTS ; Leave.
STREAM_CLEAR_DUBS: ; 1F:0733, 0x03E733
    LDA #$00 ; Clear val.
    LDY #$0C ; Stream index.
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Clear stream.
    INY ; Stream++
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Store to stream.
    RTS ; Leave.
STREAM_MOD_LOWER_ONLY_UNK: ; 1F:073D, 0x03E73D
    LDY #$08 ; Stream index.
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load from file.
    AND #$3F ; Keep 0011.1111
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Store to.
    RTS ; Leave.
STREAM_SET_FILE_DONE?: ; 1F:0746, 0x03E746
    LDY #$09 ; Stream index.
    LDA #$38 ; Val to store.
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Store.
    RTS ; Leave.
STREAM_SET_FILE_NOTDONEBUTIDK?: ; 1F:074D, 0x03E74D
    LDY #$08 ; Stream index.
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load from file.
    ORA #$40 ; Set bit.
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Store to.
    RTS ; Leave.
SCRIPT_RTN_Y: ; 1F:0756, 0x03E756
    JSR STREAM_CLEAR_DUBS ; LOts of small file routines. Good place to label them all.
    JSR STREAM_MOD_LOWER_ONLY_UNK
    JSR STREAM_SET_FILE_DONE?
    JSR SETUP_PTR_FROM_PTR_TODO
    JSR LIB_GET_FILE_DATA_BIT_TO_SET_UNK ; Get data.
    AND LIB_LUT_BIT_TEST_0x80-0x01,X ; And with.
    BEQ VAL_CLEAR ; Use 0x00.
    LDA #$04 ; Seed alt ??
VAL_CLEAR: ; 1F:076C, 0x03E76C
    JSR EXIT_STREAM_ADD_TOGETHER_FILE_VALS ; Do ??
    JMP SUB_SWITCH_SET_0x88 ; Goto.
LIB_GET_FILE_DATA_BIT_TO_SET_UNK: ; 1F:0772, 0x03E772
    LDY #$06 ; Stream.
    LDA [SCRIPT_MAIN_FPTR[2]],Y ; Load from file.
    ASL A ; << 1, *2. Bit from. Does +0x20 to Y index.
    LDY #$07 ; Stream mod. INY better here.
    LDA [SCRIPT_MAIN_FPTR[2]],Y ; Load from file, index/bit to set. XXXX.XBBB, CC=X+0x20
    AND #$07 ; Keep lower.
    TAX ; To X index. Bit to set.
    LDA [SCRIPT_MAIN_FPTR[2]],Y ; Reload.
    ROR A ; Rotate above shift into this for index.
    LSR A ; >> 2, /4. All down with above shift in place. 0x00 - 0x3F range.
    LSR A
    TAY ; To Y index.
    LDA CURRENT_SAVE_MANIPULATION_PAGE+544,Y ; Load from save page.
    RTS ; Leave.
SCRIPT_RTN_AA: ; 1F:0788, 0x03E788
    LDY #$1A ; File index.
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load from file.
    BNE SCRIPT_ALT_UNK ; != 0, goto.
    LDA #$01
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Store to file.
    LDY #$15 ; Stream index.
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load ??
    EOR #$04 ; Invert ??
    AND #$0F ; Keep lower.
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Store to file.
SCRIPT_ALT_UNK: ; 1F:079C, 0x03E79C
    LDY #$15 ; Stream index.
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load ??
    STA ROUTINE_SWITCH_ID_TODO ; Store to switch.
    JSR INDEX_AND_MODS_WITH_SHIFT_UNK ; Do sub.
    JSR ENGINE_SCRIPTY_RESULT_TEST_UNK ; Do ??
    BCC RET_CC ; CC, goto.
    LDA #$F8
    STA SCRIPT_FLAG_0x22_AUTO_MOVE ; Set ??
    JMP DATA_INDEX_SWITCH_MOVE_UNK_SHIFTED ; Goto.
RET_CC: ; 1F:07B1, 0x03E7B1
    LDA #$00
    STA SCRIPT_FLAG_0x22_AUTO_MOVE ; Clear ??
    JMP STREAM_SET_0x80_FIRST_BYTE ; Goto.
SCRIPT_RTN_U: ; 1F:07B8, 0x03E7B8
    JSR SUB_PTR_SETUP_CHECK_IDFK_GOSH ; Do ??
    BCC SCRIPT_RTN_Q ; CC, goto.
    RTS ; Leave.
SCRIPT_RTN_Q: ; 1F:07BE, 0x03E7BE
    JSR FLAG_SET_MAYBE_FIX_PULL_UNK ; Do ??
    AND #$E0 ; Keep upper.
    LSR A ; >> 2, /4.
    LSR A
    BCC VAL_CC ; CC, goto.
SCRIPT_RTN_T: ; 1F:07C7, 0x03E7C7
    JSR SUB_PTR_SETUP_CHECK_IDFK_GOSH ; Do ??
    BCC SCRIPT_RTN_P ; CC, goto.
    RTS ; Leave.
SCRIPT_RTN_P: ; 1F:07CD, 0x03E7CD
    JSR FLAG_SET_MAYBE_FIX_PULL_UNK ; Do ??
    AND #$F8 ; Keep ??
VAL_CC: ; 1F:07D2, 0x03E7D2
    LSR A ; >> 2, /4.
    LSR A
    CMP #$08 ; If _ #$08
    BCS SCRIPT_RTN_O_SET_SWITCH_EXIT_JMP ; >=, goto.
    LDY #$15 ; Stream index.
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Store to file TODO wut ??
SUB_SWITCH_AND_MORE_UNK: ; 1F:07DC, 0x03E7DC
    STA ROUTINE_SWITCH_ID_TODO ; Store value.
    JSR INDEX_AND_MODS_NO_SHIFT_UNK ; Do ??
    JSR SCRIPT_UNK_R6_AND_FILE_UNK ; Do.
    BCS SCRIPT_RTN_O_SET_SWITCH_EXIT_JMP ; Ret CS, goto.
    JSR ENGINE_SCRIPTY_RESULT_TEST_UNK ; Do.
BANK_0_PTR_B: ; 1F:07E9, 0x03E7E9
    BCC SCRIPT_RTN_O_SET_SWITCH_EXIT_JMP ; CC, goto.
    JSR SUB_STREAM_RESET_TO_??_AND_PTR/VAL_RTN ; Do ??
    BNE SCRIPT_RTN_O_SET_SWITCH_EXIT_JMP ; != 0, goto.
    JSR BANK/MOVE/RUN_RTN_SWITCH_UNK ; Do ??
    BCC EXIT_JMP_DATA_INDEX_SWITCH_MOVE_UNK ; Ret CC, goto.
SCRIPT_RTN_O_SET_SWITCH_EXIT_JMP: ; 1F:07F5, 0x03E7F5
    LDA #$88
    STA ROUTINE_SWITCH_ID_TODO ; Set switch no action?
EXIT_JMP_DATA_INDEX_SWITCH_MOVE_UNK: ; 1F:07F9, 0x03E7F9
    JMP DATA_INDEX_SWITCH_UNK_MOVEMENT? ; Goto.
FLAG_SET_MAYBE_FIX_PULL_UNK: ; 1F:07FC, 0x03E7FC
    LDA ENGINE_FLAG_25_SKIP_UNK ; Load ??
    BNE VAL_EXTENDED ; Set, goto.
    JMP RANDOMIZE_GROUP_A ; Do random.
VAL_EXTENDED: ; 1F:0803, 0x03E803
    PLA ; Pull A.
    PLA
    JMP SCRIPT_RTN_O_SET_SWITCH_EXIT_JMP ; Goto.
SCRIPT_RTN_S: ; 1F:0808, 0x03E808
    JSR SUB_PTR_SETUP_CHECK_IDFK_GOSH ; Do.
    BCC SCRIPT_RTN_O_SET_SWITCH_EXIT_JMP ; Ret CC, goto.
    RTS ; Leave.
SCRIPT_RTN_V: ; 1F:080E, 0x03E80E
    JSR SUB_PTR_SETUP_CHECK_IDFK_GOSH ; Do.
    BCC SCRIPT_RTN_R ; Ret CC, goto.
    RTS ; Leave.
SCRIPT_RTN_R: ; 1F:0814, 0x03E814
    JSR FLAG_SET_MAYBE_FIX_PULL_UNK ; Do.
    AND #$E0 ; Keep 1110.0000
    LSR A ; >> 4, /16.
    LSR A
    LSR A
    LSR A
    CMP #$08 ; If _ #$08
    BCS SCRIPT_RTN_O_SET_SWITCH_EXIT_JMP ; >=, goto.
    LDY #$15 ; Stream index.
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Store to stream.
    JSR SCRIPT_RTN_O_SET_SWITCH_EXIT_JMP ; Do.
    JMP STREAM_SET_FILE_NOTDONEBUTIDK? ; Do.
VAL_LT_0x10: ; 1F:082B, 0x03E82B
    CMP #$00 ; Compare value.
    BNE SCRIPT_RTN_O_SET_SWITCH_EXIT_JMP ; !=, goto.
    STA SCRIPT_FLAG_0x22_AUTO_MOVE ; Store to.
    LDY #$1D ; Seed file index.
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load from file.
    AND #$7F ; Keep lower.
    PHA ; Save it.
    JSR STREAM_UNK_RESERVATION_ATTRS_UNK ; Do sub.
    PLA ; Pull value.
    JMP SWITCH_SCRIPT_ROUTINES ; Goto.
SCRIPT_RTN_F: ; 1F:083F, 0x03E83F
    LDY #$1A ; Stream index.
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load from file.
    BNE VAL_NE_0x00 ; !=, goto.
    LDY #$1E ; Stream index.
    CLC ; Prep clear.
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load from file.
    STA SCRIPT_MAIN_FPTR[2] ; Store to.
    ADC #$02 ; += 0x2
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Store to.
    INY ; Stream++
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load from file.
    STA SCRIPT_MAIN_FPTR+1 ; Store to.
    ADC #$00 ; Carry add.
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Store to ptr.
    LDY #$00 ; Stream index.
    LDA [SCRIPT_MAIN_FPTR[2]],Y ; Load from file.
    CMP #$10 ; If _ #$10
    BCC VAL_LT_0x10 ; <, goto.
    LDY #$19 ; Stream index.
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Store to.
    LDY #$01 ; Stream index.
    LDA [SCRIPT_MAIN_FPTR[2]],Y ; Load from file.
    LDY #$1A ; Stream index.
VAL_NE_0x00: ; 1F:086B, 0x03E86B
    SEC ; Prep sub.
    SBC #$01 ; Sub with.
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Store to.
    BNE VAL_NONZERO ; != 0, goto.
    LDY #$1E ; Stream index.
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load from file.
    STA SCRIPT_MAIN_FPTR[2] ; Store to.
    INY ; Stream++
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load from file.
    STA SCRIPT_MAIN_FPTR+1 ; Store to ptr.
    LDY #$00 ; Stream index.
    LDA [SCRIPT_MAIN_FPTR[2]],Y ; Load from file.
    CMP #$10 ; If _ #$10
    BCS VAL_NONZERO ; >=, goto.
    SEC ; Prep sub.
    LDA #$28 ; Load ??
    SBC SAVE_ID_FOCUS/OTHER ; Sub with.
    CLC ; Prep add.
    ADC #$84 ; Add with.
    STA MAIN_FLAG_UNK ; Store to.
VAL_NONZERO: ; 1F:088F, 0x03E88F
    LDY #$19 ; Stream index.
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load from file.
    TAX ; To X index.
    AND #$20 ; Keep bit.
    BEQ FLAG_CLEAR ; == 0, goto.
    LDY #$1D ; Stream index.
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load from file.
    ASL A ; << 2, *4.
    ASL A
    TAY ; To Y index. Slot to index.
    LDA SCRIPT_ATTRIBUTES_A,Y ; Load attr.
FLAG_CLEAR: ; 1F:08A2, 0x03E8A2
    LDY #$08 ; Stream index.
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Store attr.
    TXA ; X to A.
    AND #$08 ; Keep bit.
    BNE VAL_SET ; !=, goto.
    LDY #$15 ; Stream index.
    TXA ; X to A.
    AND #$07 ; Keep lower.
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Store to file.
VAL_SET: ; 1F:08B2, 0x03E8B2
    TXA ; X to A.
    BMI SWITCH_NONE ; Negative, goto.
    PHA ; Save val.
    AND #$07 ; Keep lower.
    STA ROUTINE_SWITCH_ID_TODO ; Store as switch.
    JSR INDEX_AND_MODS_NO_SHIFT_UNK ; Do ??
    PLA ; Pull value.
    TAX ; To X index.
    BPL POSITIVE ; Positive, goto.
SWITCH_NONE: ; 1F:08C1, 0x03E8C1
    LDA #$88
    STA ROUTINE_SWITCH_ID_TODO ; Routine switch. TODO none right?
POSITIVE: ; 1F:08C5, 0x03E8C5
    TXA ; X to A.
    AND #$40 ; Keep bit.
    ASL A ; << 1, *2.
    ORA #$70 ; Set lower bits in nibble.
    ORA ROUTINE_SWITCH_ID_TODO ; Set with other.
    STA SCRIPT_FLAG_0x22_AUTO_MOVE ; Store to.
    JMP DATA_INDEX_SWITCH_UNK_MOVEMENT? ; Goto.
SCRIPT_RTN_AC: ; 1F:08D2, 0x03E8D2
    JSR SUB_PTR_SETUP_CHECK_IDFK_GOSH ; Do sub.
    BCC SUB_AND_EXIT_EXTENDED_GFX ; CC, goto.
    RTS ; Leave.
SUB_AND_EXIT_EXTENDED_GFX: ; 1F:08D8, 0x03E8D8
    JSR SCRIPT_RTN_O_SET_SWITCH_EXIT_JMP ; Do.
    JMP EXIT_EXTENDED_GFX ; Goto.
SCRIPT_RTN_J: ; 1F:08DE, 0x03E8DE
    JSR SCRIPT_RTN_I ; Do sub.
EXIT_EXTENDED_GFX: ; 1F:08E1, 0x03E8E1
    JSR STREAM_SET_FILE_NOTDONEBUTIDK? ; Do sub.
    LDA #$74 ; Seed GFX bank.
    BNE SET_BANK_0x1_VAL_A ; Set, goto.
SCRIPT_RTN_AH: ; 1F:08E8, 0x03E8E8
    JSR SUB_PTR_SETUP_CHECK_IDFK_GOSH ; Do sub.
    BCC SUB_AND_GFX_UNK ; CC, goto.
    RTS ; Leave.
SUB_AND_GFX_UNK: ; 1F:08EE, 0x03E8EE
    JSR SCRIPT_RTN_O_SET_SWITCH_EXIT_JMP ; Do ??
    LDA #$74 ; Seed bank.
    BNE SET_BANK_0x1_VAL_A ; Set it. Always taken.
SCRIPT_RTN_AF: ; 1F:08F5, 0x03E8F5
    JSR SUB_PTR_SETUP_CHECK_IDFK_GOSH ; Do ??
    BCC FOR_MAP_RTN ; CC, goto.
    RTS ; Leave.
FOR_MAP_RTN: ; 1F:08FB, 0x03E8FB
    JSR SCRIPT_RTN_O_SET_SWITCH_EXIT_JMP
    LDA #$72 ; Seed GFX bank?
SET_BANK_0x1_VAL_A: ; 1F:0900, 0x03E900
    LDX #$01 ; Seed R1.
    JMP ENGINE_MAPPER_COMMIT_BANK_X_VAL_A ; Store to.
SCRIPT_RTN_K: ; 1F:0905, 0x03E905
    LDA FLAG_UNK_23 ; Load.
    CLC ; Prep add.
    BNE SCRIPT_INIT_SMOLLER_UNK ; != 0, goto.
    LDA ROUTINE_SWITCH_ID_TODO ; Load.
    BMI SKIP_FILE_UNK ; Negative, goto.
    LDY #$1D ; Seed index.
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load from file.
    TAX ; To X index.
    LDA FILE_MOVE_VAL_UNK ; Move ??
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y
    TXA ; X to A.
    LDY #$15 ; Stream index.
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Store to move file.
    STA FILE_MOVE_VAL_UNK ; Store to also.
    LDY #$19 ; Stream index.
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load from file.
    TAX ; To X index.
    LDA ROUTINE_SWITCH_ID_TODO ; Move ??
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y
    TXA ; X to A.
    STA ROUTINE_SWITCH_ID_TODO ; Store to.
    BMI SKIP_FILE_UNK ; Negative, goto.
    JSR INDEX_AND_MODS_NO_SHIFT_UNK ; Do.
SKIP_FILE_UNK: ; 1F:092F, 0x03E92F
    JSR DATA_INDEX_SWITCH_UNK_MOVEMENT? ; Do ??
    JSR SCRIPT_PTR_SETUP_SUBFILE_LOWER_KEEP_ONLY ; Do ??
    LDY #$08 ; Stream index.
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load from file.
    AND #$0F ; Keep lower.
    CMP #$0A ; If _ #$0A
    BEQ VAL_EQ_0xA ; ==, goto.
    RTS ; Leave.
VAL_EQ_0xA: ; 1F:0940, 0x03E940
    LDA ENGINE/SCRIPT_R1_BANK_USE_TODO ; Load ??
    ASL A ; << 1, *2.
    AND #$02 ; Keep lower.
    ORA #$70 ; Set ??
    LDX #$01 ; Bank R1.
    JMP ENGINE_MAPPER_COMMIT_BANK_X_VAL_A ; Bank it.
SCRIPT_INIT_UNK: ; 1F:094C, 0x03E94C
    LDA #$88
    STA SCRIPT_UNK_DATA_SELECT_?? ; Set ??
    LDA #$00
    STA NMI_FLAG_ACTION? ; Clear ??
    STA NMI_FP_UNK[2]
    STA NMI_FP_UNK+1
    JSR STREAM_CLEAR_DUBS ; Clear more.
SCRIPT_INIT_SMOLLER_UNK: ; 1F:095B, 0x03E95B
    LDA #$00
    STA ROUTINE_SWITCH_ID_TODO ; Clear ??
    STA FLAG_UNK_23 ; Clear ??
    LDA #$10 ; Seed ??
    BCS STREAM_SET_FIRST_BYTE_A ; CS, goto. Shift from entry?
STREAM_SET_0x80_FIRST_BYTE: ; 1F:0965, 0x03E965
    LDA #$80 ; Value to write seed.
STREAM_SET_FIRST_BYTE_A: ; 1F:0967, 0x03E967
    LDY #$00 ; Stream = 0x00
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Store to.
    RTS ; Leave.
SCRIPT_RTN_G_ELSEWHERE: ; 1F:096C, 0x03E96C
    LDA FLAG_UNK_23 ; Load flag. Top bit seems to be flag to use 0x10 instead of 0x80?
    ASL A ; << 1, *2.
    BNE SCRIPT_INIT_UNK ; != 0, goto.
    JSR SCRIPT_ACTION_DIRECTION_UPDATE/RET ; Do.
    BMI EXIT_NO_SWITCH ; Negative, goto.
    LDY #$15 ; File index.
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Store to file.
    STA FILE_MOVE_VAL_UNK ; Store to also ??
LOOP_SWITCH: ; 1F:097C, 0x03E97C
    STA ROUTINE_SWITCH_ID_TODO ; Store value.
    JSR INDEX_AND_MODS_NO_SHIFT_UNK ; Do
    LDA ENGINE_FLAG_25_SKIP_UNK ; Load ??
    CMP #$28 ; If _ #$28
    BCS EXIT_NORMAL ; >=, goto.
    JSR SCRIPT_TEST_PMOVE? ; Do ??
    BCS EXIT_NO_SWITCH ; CS, goto.
    JSR BANK/MOVE/RUN_RTN_SWITCH_UNK ; Do ??
    BCS EXIT_NO_SWITCH ; CS, goto.
    BIT OBJ_PROCESS_COUNT_LEFT? ; Test it.
    BPL EXIT_NORMAL ; Positive, goto.
    BVS TEST_0x40_SET ; Set, goto.
    LDA ROUTINE_SWITCH_ID_TODO ; Load ??
    SBC #$00 ; Sub one conditionally.
    AND #$0F ; Keep lower.
    BPL LOOP_SWITCH ; Positive, do more.
TEST_0x40_SET: ; 1F:099F, 0x03E99F
    LDY #$15 ; FIle index.
    LDA #$00 ; Clear it.
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Clear it.
    STA FILE_MOVE_VAL_UNK ; Clear ??
    BCC EXIT_NORMAL
EXIT_NO_SWITCH: ; 1F:09A9, 0x03E9A9
    LDA #$88
    STA ROUTINE_SWITCH_ID_TODO ; Set none.
EXIT_NORMAL: ; 1F:09AD, 0x03E9AD
    JSR DATA_INDEX_SWITCH_UNK_MOVEMENT? ; Do.
    JSR SCRIPT_PTR_SETUP_SUBFILE_LOWER_KEEP_ONLY ; Do.
EXIT_MOVE_FPTR/SAVE_SWITCH?: ; 1F:09B3, 0x03E9B3
    LDA ROUTINE_SWITCH_ID_TODO ; Move switch.
    STA SCRIPT_UNK_DATA_SELECT_??
    LDY #$09 ; Stream index.
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load from stream.
    AND #$40 ; Keep bit.
    ORA ACTION_BUTTONS_RESULT ; Or with.
    STA NMI_FLAG_ACTION? ; Store to.
    LDY #$0C ; Stream index.
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load from file.
    STA NMI_FP_UNK[2] ; Store as PTR L.
    INY ; Stream++
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Move PTR H.
    STA NMI_FP_UNK+1
    RTS ; Leave.
SCRIPT_ACTION_DIRECTION_UPDATE/RET: ; 1F:09CD, 0x03E9CD
    LDA SCRIPT_FLAG_0x22_AUTO_MOVE ; Load ??
    BEQ FLAG_CLEAR ; Clear, goto.
    BPL VAL_POSITIVE ; Positive, goto.
    RTS ; Leave, nonzero/negative.
VAL_POSITIVE: ; 1F:09D4, 0x03E9D4
    LDY #$19 ; Stream index.
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load from file.
    TAX ; To X index.
    LDA SCRIPT_FLAG_0x22_AUTO_MOVE ; Move to file.
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y
    TXA ; X to A
    AND #$8F ; Keep 1000.1111
    RTS ; Leave.
FLAG_CLEAR: ; 1F:09E1, 0x03E9E1
    LDA CTRL_BUTTONS_PREVIOUS[2] ; Load buttons.
    AND #$0F ; Keep UDLR.
    TAX ; To X index.
    LDA SCRIPT_ACTION_IDFK ; Load old.
    BPL EXIT_LOAD_ACTION ; Positive, was valid last time, return this instead.
    AND #$0F ; Keep bits of action.
    CMP ACTION_ARRAY_UDLR?,X ; If _ buttons.
    BEQ EXIT_NO_ACTION ; ==, goto.
    STA SCRIPT_ACTION_IDFK ; Store nonzero.
EXIT_LOAD_ACTION: ; 1F:09F3, 0x03E9F3
    LDA ACTION_ARRAY_UDLR?,X ; Load action.
    RTS ; Store to.
EXIT_NO_ACTION: ; 1F:09F7, 0x03E9F7
    LDA #$88 ; Write negative, invalid.
    RTS
SCRIPT_TEST_PMOVE?: ; 1F:09FA, 0x03E9FA
    JSR SUB_STREAM_RESET_TO_??_AND_PTR/VAL_RTN ; Do sub.
    BEQ EXIT_CC ; == 0, ret CC.
    ASL A ; << 1, *2.
    LDA ROUTINE_SWITCH_ID_TODO ; Load switch.
    AND #$01 ; Keep bit.
    BEQ RIGHT_CLEAR ; Clear, goto.
    BCS SET_0x80 ; Was set, goto.
RIGHT_CLEAR: ; 1F:0A08, 0x03EA08
    LDA R_**:$000F ; Load ??
    BNE FLAG_NONZERO ; != 0, goto.
    LDY #$1B ; Stream ??
    LDA ROUTINE_SWITCH_ID_TODO ; Load.
    ORA #$40 ; Set ??
    STA [SCRIPT_MAIN_FPTR[2]],Y ; Store to.
    BIT MAIN_FLAG_UNK ; Test flag.
    BMI FLAG_NONZERO ; Negative, goto.
    STX MAIN_FLAG_UNK ; X to.
FLAG_NONZERO: ; 1F:0A1A, 0x03EA1A
    BCC EXIT_RTS ; <, goto. Exit CC if CC.
SET_0x80: ; 1F:0A1C, 0x03EA1C
    LDA SCRIPT_FLAG_0x22_AUTO_MOVE ; Load ??
    AND #$10 ; Keep ??
    BEQ EXIT_RTS ; Clear, goto.
EXIT_CC: ; 1F:0A22, 0x03EA22
    CLC ; Ret CC.
EXIT_RTS: ; 1F:0A23, 0x03EA23
    RTS ; Leave.
SCRIPT_PTR_SETUP_SUBFILE_LOWER_KEEP_ONLY: ; 1F:0A24, 0x03EA24
    JSR SETUP_PTR_FROM_PTR_TODO ; Setup ptr.
    LDY #$01 ; Stream index.
    LDA [SCRIPT_MAIN_FPTR[2]],Y ; Load from file.
    AND #$40 ; Test bit.
    BEQ RTS ; Clear, leave.
    LDY #$08 ; Alt stream index.
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load data.
    AND #$3F ; Keep 0011.1111
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Store back.
RTS: ; 1F:0A37, 0x03EA37
    RTS
SCRIPT_RTN_L_VERY_IMPORTANT_BANKED_HANDLES: ; 1F:0A38, 0x03EA38
    LDY #$1A ; Stream index.
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load from file.
    BNE FILE_NONZERO ; != 0, goto.
    LDA SCRIPT_R6_ROUTINE_SELECT
    JSR BANK_HANDLER_R6_AND_BASE_FILE? ; Handler and base.
    ASL A ; << 1, *2.
    TAX ; To X index.
    LDA $8000,X ; Banked to misc for file.
    STA BCD/MODULO/DIGITS_USE_A
    LDA $8001,X
    STA BCD/MODULO/DIGITS_USE_B
    LDY #$1E ; Stream index.
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load from file.
    ASL A ; << 1, *2.
    TAY ; To index.
    LDA [BCD/MODULO/DIGITS_USE_A],Y ; Move from file to alt ptr.
    STA SCRIPT_MAIN_FPTR[2]
    INY ; Stream++
    LDA [BCD/MODULO/DIGITS_USE_A],Y ; Load from again.
    STA SCRIPT_MAIN_FPTR+1 ; Store to again.
    LDY #$1F ; Stream index.
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load from file.
    TAY ; To stream.
    LDA [SCRIPT_MAIN_FPTR[2]],Y ; Load from alt moved.
    CMP #$10 ; If _ #$10
    BCC VAL_LT_0x10 ; <, goto.
    PHA ; Save val.
    INY ; Stream++
    LDA [SCRIPT_MAIN_FPTR[2]],Y ; Load from alt.
    TAX ; To X index.
    INY ; Stream++
    TYA ; Stream to A.
    LDY #$1F ; Stream index.
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Save stream.
    LDY #$19 ; Stream index.
    PLA ; Pull val.
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Store to file.
    TXA ; X index to A.
    LDY #$1A ; Stream ??
FILE_NONZERO: ; 1F:0A7C, 0x03EA7C
    SEC ; Prep sub.
    SBC #$01 ; Sub with.
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Store to file.
    LDY #$19 ; Stream index.
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load from file.
    BMI EXIT_NO_STATE? ; Negative, goto.
    AND #$0F ; Keep lower.
    STA ROUTINE_SWITCH_ID_TODO ; Store to.
    LDY #$15 ; Stream index.
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Store to file.
    JSR INDEX_AND_MODS_NO_SHIFT_UNK ; Do.
    JSR GET_STATE_UNK_LOWER ; Do ??
    JSR EXIT_STREAM_ADD_TOGETHER_FILE_VALS ; Do mix.
    JMP EXIT_MOVE_FPTR/SAVE_SWITCH? ; Goto.
VAL_LT_0x10: ; 1F:0A9B, 0x03EA9B
    CMP #$00 ; If _ #$00
    BNE VAL_NONZERO ; !@= 0, goto.
    STA FLAG_UNK_23 ; Clear ??
VAL_NONZERO: ; 1F:0AA1, 0x03EAA1
    INY ; Stream++
    JSR MISC_FILE_MANIP_WITH_PTR_32_AS_MANIP ; Do file.
    INY ; Stream++
    TYA ; To A.
    LDY #$1F ; Stream mod.
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load from file.
    LDA FLAG_UNK_23 ; Load flag.
    BNE EXIT_NO_STATE? ; Set, goto.
    LDA #$80
    STA FLAG_UNK_23 ; Set flag ??
    JSR SLOTS_AND_FPTRS_TODO_LARGER_FILES ; Do slots and ptrs.
    LDX #$00 ; Seed ??
    JSR ACTION_INDEX_STORE_AND_RETURN_VALUE_UNK
EXIT_NO_STATE?: ; 1F:0ABB, 0x03EABB
    LDA #$88
    STA ROUTINE_SWITCH_ID_TODO ; Set switch clear?
    JSR GET_STATE_UNK_LOWER ; Do.
    JMP EXIT_MOVE_FPTR/SAVE_SWITCH? ; Goto.
SCRIPT_RTN_M: ; 1F:0AC5, 0x03EAC5
    LDA ROUTINE_SWITCH_ID_TODO ; Load.
    BMI SET_SWITCH_RTN_NO_MOVE?UNK ; Negative, goto.
    LDY #$19 ; Stream index.
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load from file.
    TAX ; To X index.
    LDA ROUTINE_SWITCH_ID_TODO ; Load.
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Store to file.
    TXA ; X to A.
    BMI SET_SWITCH_RTN_NO_MOVE?UNK ; If negative, goto.
    STA ROUTINE_SWITCH_ID_TODO ; Set positive.
    LDY #$15 ; Stream index.
    EOR #$04 ; Invert ?? TODO
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Store to other file.
    LDY #$06 ; Stream index.
    SEC ; Prep sub.
    LDA WRAM_SPECIAL_A? ; Load ??
    SBC [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Sub with file.
    INY ; Stream++
    LDA WRAM_SPECIAL_B? ; Load from file.
    SBC [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Sub with.
    LDY #$14 ; Stream index.
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load from file.
    BCS SUB_NO_UNDERFLOW ; No underflow, goto.
    ORA #$10 ; Set ??
    BIT ROM_BIT_HELPER_0XA9 ; Test ROM.
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Store to file.
    JSR INDEX_AND_MODS_NO_SHIFT_UNK ; Do ??
    JSR GET_STATE_UNK_LOWER ; Get ??
    CPX #$40 ; If _ #$40
    BCC EXIT_NORMAL ; <, goto.
    SBC #$04 ; Sub ??
EXIT_NORMAL: ; 1F:0B04, 0x03EB04
    JMP EXIT_STREAM_ADD_TOGETHER_FILE_VALS ; Goto.
SET_SWITCH_RTN_NO_MOVE?UNK: ; 1F:0B07, 0x03EB07
    LDA #$88
    STA ROUTINE_SWITCH_ID_TODO ; Set no action?
GET_STATE_UNK_LOWER: ; 1F:0B0B, 0x03EB0B
    JSR ROUTINE_SWITCH_TO_DATA_SLOT_INDEX_X ; Get index.
    LDY #$0C ; Stream index.
    LDA DATA_UNK_A,X ; Move to file ??
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y
    INY ; File++
    LDA DATA_UNK_B,X ; Move ?? to file.
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y
    JSR STREAM_MOD_LOWER_ONLY_UNK ; Remove.
    JSR STREAM_SET_FILE_DONE? ; Set ??
    LDA ROUTINE_SWITCH_ID_TODO ; Load.
    BMI RTS ; Negative, goto.
    LDY #$15 ; Stream index.
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load from file.
    TAX ; To X index.
    LDA TRANSLATE_ARR_UNK,X ; Load translate.
    TAX ; To X index.
    LDY #$08 ; File.
    AND #$40 ; Keep 0100.0000
    ORA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Combine into.
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y
    TXA ; X to A.
    AND #$1F ; Keep index.
RTS: ; 1F:0B39, 0x03EB39
    RTS
SCRIPT_RTN_H: ; 1F:0B3A, 0x03EB3A
    JSR SCRIPT_ACTION_DIRECTION_UPDATE/RET ; Do.
    BMI SWITCH_SWITCH_SET ; Return neg, goto.
    LDY #$15 ; Stream index ??
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Store val to.
    STA SCRIPT_UNK_DATA_SELECT_?? ; Store to, too.
    TAX ; To X index.
    LDY #$1A ; Stream index.
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load from file.
    BEQ FILE_EQ_0x00 ; == 0, goto.
    BMI IS_NEGATIVE ; Negative, goto.
    SEC ; Prep sub.
    SBC #$01 ; Sub with.
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Store to.
    CMP #$05 ; If _ #$05
    BCS FILE_EQ_0x00 ; >=, goto.
    LDX #$07 ; If _ #$06
    BCC FILE_EQ_0x00 ; <, goto.
IS_NEGATIVE: ; 1F:0B5B, 0x03EB5B
    PHA ; Save A.
    CLC ; Prep add.
    ADC #$01 ; Add with.
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Store to.
    PLA ; Pull A.
    CMP #$FD ; If _ #$FD
    BCS FILE_EQ_0x00 ; >=, goto.
    LDX #$05 ; Set ??
FILE_EQ_0x00: ; 1F:0B68, 0x03EB68
    STX ROUTINE_SWITCH_ID_TODO ; Store ??
    JSR INDEX_AND_MODS_NO_SHIFT_UNK ; Do ??
    JMP SWITCH_SWITCH_MOVEMENT?_UNK ; Goto.
SWITCH_SWITCH_SET: ; 1F:0B70, 0x03EB70
    LDA #$88
    STA SCRIPT_UNK_DATA_SELECT_?? ; Set ??
    STA ROUTINE_SWITCH_ID_TODO ; Set ??
SWITCH_SWITCH_MOVEMENT?_UNK: ; 1F:0B76, 0x03EB76
    JSR DATA_INDEX_SWITCH_UNK_MOVEMENT? ; Do.
    JSR STREAM_SET_FILE_NOTDONEBUTIDK? ; Do.
    LDA SCRIPT_UNK_DATA_SELECT_?? ; Move ??
    STA ROUTINE_SWITCH_ID_TODO
    JSR ROUTINE_SWITCH_TO_DATA_SLOT_INDEX_X ; Do rtn.
    LDA ACTION_BUTTONS_RESULT ; Move ??
    STA NMI_FLAG_ACTION?
    LDA DATA_UNK_A,X ; Move data.
    STA NMI_FP_UNK[2]
    LDA DATA_UNK_B,X
    STA NMI_FP_UNK+1
    RTS ; Leave.
SCRIPT_RTN_I: ; 1F:0B92, 0x03EB92
    JSR SCRIPT_ACTION_DIRECTION_UPDATE/RET ; Do sub.
    BMI WRITE_NO_ACTION_HELPER ; Negative, set nothing.
    LDY #$15 ; Stream index.
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Store to file.
    STA ROUTINE_SWITCH_ID_TODO ; Store to switch.
    JSR INDEX_AND_MODS_NO_SHIFT_UNK ; Do.
    JSR SCRIPT_TEST_PMOVE? ; Test?
    BCS WRITE_NO_ACTION_HELPER ; Ret CS, goto.
    LDA SCRIPT_FLAG_0x22_AUTO_MOVE ; Load from stream.
    BNE EXIT_DATA_SWITCH_AND_MOVE ; Set, goto.
    LDA #$14 ; Set R6, 0x14.
    LDX #$06
    JSR ENGINE_MAPPER_COMMIT_BANK_X_VAL_A ; Set bank.
    LDA STREAM_DEEP_C ; Move ??
    STA STREAM_UNK_DEEP_A[2]
    JSR SUB_SEED_UNK_AND_UNK ; Do sub.
    LDA SCRIPT_R6_ROUTINE_SELECT ; Load.
    JSR BANK_HANDLER_R6_AND_BASE_FILE? ; Do R6 RTN.
    BIT OBJ_PROCESS_COUNT_LEFT? ; Test.
    BVS EXIT_DATA_SWITCH_AND_MOVE ; If 0x40 set, goto.
WRITE_NO_ACTION_HELPER: ; 1F:0BC0, 0x03EBC0
    LDA #$88
    STA ROUTINE_SWITCH_ID_TODO ; Set no action.
EXIT_DATA_SWITCH_AND_MOVE: ; 1F:0BC4, 0x03EBC4
    JSR DATA_INDEX_SWITCH_UNK_MOVEMENT? ; Do.
    JMP EXIT_MOVE_FPTR/SAVE_SWITCH? ; Goto.
SCRIPT_RTN_N: ; 1F:0BCA, 0x03EBCA
    JSR SCRIPT_ACTION_DIRECTION_UPDATE/RET ; Do.
    STA ROUTINE_SWITCH_ID_TODO ; Store to rtn switch.
    BMI ACTION_INVALID ; Invalid.
    JSR INDEX_AND_MODS_NO_SHIFT_UNK ; Do file if valid.
ACTION_INVALID: ; 1F:0BD4, 0x03EBD4
    JSR DATA_INDEX_SWITCH_UNK_MOVEMENT? ; Do ??
    JSR STREAM_MOD_LOWER_ONLY_UNK ; Stream.
    JMP EXIT_MOVE_FPTR/SAVE_SWITCH? ; Goto.
ACTION_ARRAY_UDLR?: ; 1F:0BDD, 0x03EBDD
    .db 88 ; No action value.
    .db 02 ; Right.
    .db 06 ; Left.
    .db 88 ; Left, right.
    .db 04 ; Down.
    .db 03 ; Down, right.
    .db 05 ; Down, left.
    .db 88 ; Down, right, left.
    .db 00 ; Up.
    .db 01 ; Up, right.
    .db 07 ; Up, left.
    .db 88 ; Up, right, left.
    .db 88 ; Up, down.
    .db 88 ; Up, down, right.
    .db 88 ; Up, down, left.
    .db 88 ; Up, down, left, right.
LUT_MOD_ARRAY_MOVEMENT?: ; [4], 1F:0BED, 0x03EBED
    .db 00
    .db 00
    .db C0
    .db FF
DATA_UNK_C: ; 1F:0BF1, 0x03EBF1
    .db 00
    .db 00
DATA_UNK_A: ; 1F:0BF3, 0x03EBF3
    .db 00
DATA_UNK_B: ; 1F:0BF4, 0x03EBF4
    .db FF
    .db 40
    .db 00
    .db C0
    .db FF
    .db 00
    .db 00
    .db 01
    .db FF
    .db 40
    .db 00
    .db 00
    .db 00
    .db 08
    .db 00
    .db 01
    .db 00
    .db 40
    .db 00
    .db 40
    .db 00
    .db 10
    .db 00
    .db 01
    .db 01
    .db 00
    .db 00
    .db 40
    .db 00
    .db 10
    .db 00
    .db 00
    .db 01
    .db C0
    .db FF
    .db 40
    .db 00
    .db 10
    .db 00
    .db FF
    .db 01
    .db C0
    .db FF
    .db 00
    .db 00
    .db 18
    .db 00
    .db FF
    .db 00
    .db C0
    .db FF
    .db C0
    .db FF
    .db 00
    .db 00
    .db FF
    .db FF
    .db 00
    .db 00
    .db 00
    .db 00
    .db 10
    .db 00
    .db 00
    .db 00
TRANSLATE_ARR_UNK: ; 1F:0C35, 0x03EC35
    .db 54
    .db 14
    .db 1C
    .db 04
    .db 44
    .db 00
    .db 0C
    .db 10
    .db 00
    .db FF
    .db 00
    .db 01
    .db FF
    .db 00
    .db 01
    .db 00
    .db 00
    .db FF
    .db 00
    .db 01
    .db 00
    .db FF
    .db 00
    .db 01
    .db FF
    .db 00
    .db 01
    .db 00
    .db 00
    .db FF
    .db 00
    .db 01
    .db 00
    .db 01
    .db 00
    .db FF
    .db 00
    .db FF
    .db 00
    .db 01
LIB_LUT_BIT_TEST_0x80-0x01: ; 1F:0C5D, 0x03EC5D
    .db 80
    .db 40
    .db 20
    .db 10
    .db 08
    .db 04
    .db 02
    .db 01
HELPER_FADE_AND_SET_LATCHED_IDK: ; 1F:0C65, 0x03EC65
    JSR ENGINE_PALETTE_FADE_OUT ; Fade.
    LDX #$00 ; Scroll vals.
    LDY #$08
    JSR ENGINE_HELPER_SETTLE_CLEAR_LATCH_SET_SCROLL_TODO_MORE ; Do a lot.
    LDA #$EC
    LDX #$EC
    JSR ENGINE_SET_GFX_BANKS_FPTR_AX ; Set GFX.
    LDA #$01
    STA MMC3_MIRRORING ; Set mirroring horizontal.
    LDA #$80
    STA **:$07EF ; Set ??
    LDA #$7C
    STA GFX_BANKS_EXTENSION[4] ; Set GFX banks.
    STA GFX_BANKS_EXTENSION+1
    STA GFX_BANKS_EXTENSION+2
    STA GFX_BANKS_EXTENSION+3
    LDA #$00
    STA LATCH_VAL_MOD? ; Clear latch.
    LDA #$00
    STA ENGINE_FLAG_LATCHY_GFX_FLAGS ; Clear flag.
    LDX #$09 ; Index ??
MOVE_ALL_POSITIVE: ; 1F:0C94, 0x03EC94
    LDA IRQ_SCRIPT_PTRS_DEFAULT,X ; Move PTRS for RTNS.
    STA IRQ_SCRIPT_PTRS[6],X
    DEX ; Index--
    BPL MOVE_ALL_POSITIVE ; Positive, goto.
    JSR LATCH_DIFF_0x59_HELPER ; Latch helper.
    JMP ENGINE_NMI_0x01_SET/WAIT ; Wait and leave.
LIB_CHECK_ENDING_TEST_ALOT_FADE_AND_MOAR: ; 1F:0CA3, 0x03ECA3
    LDA #$C3 ; Load ??
    JSR TODO_ROUTINE_MASK_A ; Do ??
    LDX #$1E ; Delay frames.
    JSR ENGINE_DELAY_X_FRAMES ; Delay.
    JSR LIB_SPECIAL_CHECKS_UNK ; Do ??
    BCS GAME_ENDED ; Ret CS, goto.
    JSR LIB_UNK ; Do, game can't be ended.
    CLC ; Game continue.
GAME_ENDED: ; 1F:0CB6, 0x03ECB6
    PHP ; Save status of last JSR.
    JSR FOCUS/ID_RELATED_TODO ; Do ??
    LDX #$3C ; Timeout max.Save status.
VAL_NONZERO: ; 1F:0CBC, 0x03ECBC
    JSR ENGINE_NMI_0x01_SET/WAIT
    LDA CTRL_BUTTONS_PREVIOUS[2] ; Load buttons.
    BNE ANY_BUTTONS_PRESSED ; != 0, any, goto.
    DEX ; X--
    BNE VAL_NONZERO ; != 0, goto.
ANY_BUTTONS_PRESSED: ; 1F:0CC6, 0x03ECC6
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle.
    JSR ENGINE_PALETTE_FADE_OUT_NO_UPLOAD_CURRENT ; Fade.
    JSR ENGINE_PALETTE_SCRIPT_TO_UPLOADED ; Upload.
    LDA #$60 ; Bank.
    LDX #$00 ; R0 GFX.
    JSR ENGINE_MAPPER_COMMIT_BANK_X_VAL_A ; Set it.
    LDA #$00
    STA MMC3_MIRRORING ; Mirroring vert.
    STA NMI_LATCH_FLAG_UNK ; Clear latch.
    STA R_**:$0070 ; Clear ??
    STA ENGINE_PACKINATOR_ARG_SEED_BLANK_PRE_COUNT ; Clear.
    STA SCRIPT_ENCOUNTER_ID?(SAID_SONG_ID???) ; Clear ??
    STA **:$07EF ; Clear ??
    STA RAM_CODE_UNK[3] ; Clear ??
    PLP ; Pull status, return.
    JMP ENGINE_NMI_0x01_SET/WAIT ; Wait and abuse RTS.
    .db 78 ; GFX Banks.
    .db 00
    .db 7C
    .db 7D
    .db 7E
    .db 7F
IRQ_SCRIPT_PTRS_DEFAULT: ; 1F:0CF2, 0x03ECF2
    LOW(SCRIPT_RTN_DEFAULT_A) ; Latch += 2, write, GFX.
    HIGH(SCRIPT_RTN_DEFAULT_A)
    LOW(SCRIPT_RTN_DEFAULT_B) ; Latch sub double and write, GFX.
    HIGH(SCRIPT_RTN_DEFAULT_B)
    LOW(SCRIPT_RTN_DEFAULT_A) ; **
    HIGH(SCRIPT_RTN_DEFAULT_A)
    LOW(SCRIPT_RTN_DEFAULT_C)
    HIGH(SCRIPT_RTN_DEFAULT_C)
    LOW(R_**:$0000) ; NULL
    HIGH(R_**:$0000)
SEED_0xFC_ENTRY_UNK: ; 1F:0CFC, 0x03ECFC
    LDX #$FC ; Seed ??
    BIT **:$04A2 ; Test ??
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle.
    STX NMI_FP_UNK+1 ; Store X to ??
    LDX #$14 ; Seed loops.
X_TIMES_LOOP: ; 1F:0D08, 0x03ED08
    LDA #$01
    STA NMI_FLAG_EXECUTE_UPDATE_BUF_AND_MORE_TODO ; Set ??
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle updates.
    JSR LATCH_DIFF_0x59_HELPER ; Make latch.
    DEX ; X--
    BNE X_TIMES_LOOP ; != 0, loop more.
    LDA #$00
    STA NMI_FP_UNK+1 ; Clear ??
    RTS ; Leave.
LATCH_DIFF_0x59_HELPER: ; 1F:0D1A, 0x03ED1A
    SEC ; Prep sub.
    LDA #$59 ; Load val.
    SBC ENGINE_SCROLL_Y ; Sub with.
    STA NMI_LATCH_FLAG_UNK ; Store to latch.
    RTS ; Leave.
SCRIPT_RTN_DEFAULT_A: ; 1F:0D22, 0x03ED22
    CLC ; Prep add.
    LDA #$02 ; Seed offset.
    ADC LATCH_VAL_MOD? ; Add with latch.
    JSR LIB_WRITE_LATCH_AND_RETURN_R2_GFX_INDEX ; Store to latch.
    BIT ENGINE_FLAG_LATCHY_GFX_FLAGS ; Test.
    BPL ENGINE_MOVE_MAPPER_GFX_BANKS_NO_OVERRIDES ; Positive, none custom.
GFX_BANKS_WRITE_POSSIBLY_OVERRIDDEN: ; 1F:0D2E, 0x03ED2E
    LDA GFX_BANKS_EXTENSION[4] ; Load. R2.
    BPL WRITE_BANK_VAR_R1 ; Positive.
    LDA #$7C ; Seed bank if negative.
WRITE_BANK_VAR_R1: ; 1F:0D34, 0x03ED34
    STX MMC3_BANK_CFG ; Store CFG.
    STA MMC3_BANK_DATA ; Set bank.
    INX ; GFX swapping ++
    LDA GFX_BANKS_EXTENSION+1 ; Load. R3.
    BPL WRITE_BANK_VAR_R2 ; No seed.
    LDA #$7C ; Seed bank.
WRITE_BANK_VAR_R2: ; 1F:0D41, 0x03ED41
    STX MMC3_BANK_CFG ; Store CFG.
    STA MMC3_BANK_DATA ; Set GFX.
    INX ; GFX CFG++
    LDA GFX_BANKS_EXTENSION+2 ; Load bank. R4.
    BPL WRITE_BANK_VAR_R3 ; Positive, keep.
    LDA #$7C ; Seed bank.
WRITE_BANK_VAR_R3: ; 1F:0D4E, 0x03ED4E
    STX MMC3_BANK_CFG ; Write GFX CFG.
    STA MMC3_BANK_DATA ; Set GFX bank.
    INX ; CFG++
    LDA GFX_BANKS_EXTENSION+3 ; Load bank, R5.
    BPL WRITE_BANK_VAR_R4 ; Keep seed.
    LDA #$7C ; Seed GFX bank.
WRITE_BANK_VAR_R4: ; 1F:0D5B, 0x03ED5B
    STX MMC3_BANK_CFG ; Set GFX CFG.
    STA MMC3_BANK_DATA ; Set GFX Bank.
    RTS ; Leave.
SCRIPT_RTN_DEFAULT_B: ; 1F:0D62, 0x03ED62
    SEC ; Prep sub.
    LDA #$23 ; Load val.
    SBC LATCH_VAL_MOD? ; Sub with.
    ASL A ; << 1, *2.
    JSR LIB_WRITE_LATCH_AND_RETURN_R2_GFX_INDEX ; Write latch.
    BIT ENGINE_FLAG_LATCHY_GFX_FLAGS ; Test GFX RTN flag.
    BVS GFX_BANKS_WRITE_POSSIBLY_OVERRIDDEN ; If set, do override.
ENGINE_MOVE_MAPPER_GFX_BANKS_NO_OVERRIDES: ; 1F:0D6F, 0x03ED6F
    LDA GFX_BANKS_EXTENSION[4] ; GFX bank, R2.
    AND #$7F ; Keep lower.
    STX MMC3_BANK_CFG ; X as CFG.
    STA MMC3_BANK_DATA ; Store A as data.
    INX ; Register++
    LDA GFX_BANKS_EXTENSION+1 ; Load GFX bank. R3.
    AND #$7F ; Keep lower bits.
    STX MMC3_BANK_CFG ; Store CFG.
    STA MMC3_BANK_DATA ; Set bank with.
    INX ; Register++
    LDA GFX_BANKS_EXTENSION+2 ; Load GFX. R4.
    AND #$7F ; Keep lower bits.
    STX MMC3_BANK_CFG ; Set CFG.
    STA MMC3_BANK_DATA ; Set as data.
    INX ; Register++
    LDA GFX_BANKS_EXTENSION+3 ; Load GFX. R6.
    AND #$7F ; Keep lower bits.
    STX MMC3_BANK_CFG ; Set bank cfg.
    STA MMC3_BANK_DATA ; Set GFX data.
    RTS ; Leave.
SCRIPT_RTN_DEFAULT_C: ; 1F:0D9B, 0x03ED9B
    LDA SCRIPT_REPLACE_LATCH_MOD_VAL? ; Move mod ??
    STA LATCH_VAL_MOD?
    LDA #$C8 ; Load latch for ??
    JSR LIB_WRITE_LATCH_AND_RETURN_R2_GFX_INDEX ; Set latch and config.
    STA MMC3_IRQ_DISABLE ; Disable IRQ.
    LDA ENGINE_MAPPER_BANK_VALS_COMMITTING+2 ; Load bank.
    STX MMC3_BANK_CFG ; Store CFG.
    STA MMC3_BANK_DATA ; Store as gfx.
    INX ; Config bank++
    LDA ENGINE_MAPPER_BANK_VALS_COMMITTING+3 ; Move GFX.
    STX MMC3_BANK_CFG
    STA MMC3_BANK_DATA
    INX
    LDA ENGINE_MAPPER_BANK_VALS_COMMITTING+4 ; 3x
    STX MMC3_BANK_CFG
    STA MMC3_BANK_DATA
    INX
    LDA ENGINE_MAPPER_BANK_VALS_COMMITTING+5 ; 4x
    STX MMC3_BANK_CFG
    STA MMC3_BANK_DATA
    RTS ; Leave.
    JSR EXIT_DELAY_SEED_0x4 ; Delay.
    LDX #$24 ; Seed addr. TODO: loopy?
    LDA #$1F
    BIT PPU_STATUS ; Reset latch.
    STX PPU_ADDR ; Set.
    STA PPU_ADDR
    RTS ; Leave.
ENGINE_PALETTE_FADE_OUT: ; 1F:0DDC, 0x03EDDC
    JSR ENGINE_PALETTE_SCRIPT_TO_TARGET ; Settle with move.
ENGINE_PALETTE_FADE_OUT_NO_UPLOAD_CURRENT: ; 1F:0DDF, 0x03EDDF
    LDY #$05 ; Iterations.
TARGET_ITERATION: ; 1F:0DE1, 0x03EDE1
    LDX #$1F ; Index reset.
LOOP_PALETTE_DARKEN: ; 1F:0DE3, 0x03EDE3
    SEC ; Prep sub.
    LDA ENGINE_COMMIT_PALETTE[32],X ; Load val.
    SBC #$10 ; Sub with.
    BCS VAL_GTE_0x10 ; GTE.
    LDA #$0F ; Seed black?
VAL_GTE_0x10: ; 1F:0DED, 0x03EDED
    STA ENGINE_COMMIT_PALETTE[32],X ; Store back.
    DEX ; Index--
    BPL LOOP_PALETTE_DARKEN ; Positive, loop.
    TYA ; Iteration to A.
    TAX ; Iteration to X. This is to make the iteration the delay, too, to speed diff each iteration.
    JSR CREATE_PALETTE_UPLOAD_PACKET_X_WAIT ; Queue update, delay iteration is delay frames, nice.
    DEY ; Loops--
    CPY #$01 ; If _ #$01
    BNE TARGET_ITERATION ; !=, loop.
    RTS ; Leave.
ENGINE_ALL_COLOR_TO_A: ; 1F:0DFE, 0x03EDFE
    PHA ; Save passed.
    JSR ENGINE_PALETTE_SCRIPT_TO_TARGET ; Fade.
ENGINE_COLOR_TO_A_FROM_STACK: ; 1F:0E02, 0x03EE02
    PLA ; Pull passed.
ENGINE_COLOR_TO_A_PASSED: ; 1F:0E03, 0x03EE03
    LDX #$1F ; Index.
LOOP_PALETTE_WRITE: ; 1F:0E05, 0x03EE05
    STA ENGINE_COMMIT_PALETTE[32],X ; Store to palette.
    DEX ; X--
    BPL LOOP_PALETTE_WRITE ; Positive, goto.
    JMP CREATE_PALETTE_UPLOAD_PACKET_0x1_WAIT ; Goto, abuse RTS.
ENGINE_BG_COLOR_A: ; 1F:0E0E, 0x03EE0E
    PHA ; Save passed.
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle.
    PLA ; Pull passed.
    LDX #$1F ; Load index.
PALETTE_POSITIVE: ; 1F:0E15, 0x03EE15
    DEX ; X-= 3, slot base.
    DEX
    DEX
    STA ENGINE_COMMIT_PALETTE[32],X ; Store color first index of slot.
    DEX ; Slot finished.
    BPL PALETTE_POSITIVE ; Positive, goto.
    JMP CREATE_PALETTE_UPLOAD_PACKET_0x1_WAIT ; Goto.
PALETTE_TO_COLOR_A_AND_FORWARDED: ; 1F:0E21, 0x03EE21
    PHA ; Save A.
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle.
    PLA ; Pull A.
    LDX #$1F ; Index.
WRITE_ALL_PALETTE: ; 1F:0E28, 0x03EE28
    STA SCRIPT_PALETTE[32],X ; Set color.
    DEX ; Index--
    BPL WRITE_ALL_PALETTE ; Positive, loop.
    BMI ENGINE_PALETTE_FORWARD_TO_TARGET_NOSETTLE ; Do.
ENGINE_PALETTE_FORWARD_TO_TARGET: ; 1F:0E30, 0x03EE30
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle.
ENGINE_PALETTE_FORWARD_TO_TARGET_NOSETTLE: ; 1F:0E33, 0x03EE33
    LDY #$05 ; Iterations.
LOOP_PMOD_ITERATION: ; 1F:0E35, 0x03EE35
    LDX #$1F ; Index.
LOOP_PALETTE: ; 1F:0E37, 0x03EE37
    SEC ; Prep sub.
    LDA ENGINE_COMMIT_PALETTE[32],X ; Load palette.
    SBC SCRIPT_PALETTE[32],X ; Get target diff.
    BEQ TARGET_REACHED ; ==, goto.
    AND #$0F ; Keep lower bits only.
    BNE STEP_LOWER_NIBBLE_DIFFERS ; Lower nibble bits set, handle special.
    BCS DARKEN_TO_TARGET ; No overflow on sub, goto. Darken.
    LDA ENGINE_COMMIT_PALETTE[32],X ; Load script.
    ADC #$10 ; Add brightness.
    BPL COLOR_OUTPUT ; Always taken, output.
STEP_LOWER_NIBBLE_DIFFERS: ; 1F:0E4D, 0x03EE4D
    LDA SCRIPT_PALETTE[32],X ; Load target.
    AND #$0F ; Keep the hue only.
    CMP #$0D ; If _ #$0D. 0xD-0xF for blacks/greys, so excluded from hue mod.
    BCC ASSIGN_HUE_BITS_TO_TARGET_WANTED ; <, goto.
DARKEN_TO_TARGET: ; 1F:0E56, 0x03EE56
    LDA ENGINE_COMMIT_PALETTE[32],X ; Load color.
    SBC #$10 ; Mod brightness step down.
    BCS COLOR_OUTPUT ; No underflow, output.
    LDA #$0F ; Seed black.
    BPL COLOR_OUTPUT ; Always taken, seeded.
ASSIGN_HUE_BITS_TO_TARGET_WANTED: ; 1F:0E61, 0x03EE61
    PHA ; Save hue passed.
    LDA ENGINE_COMMIT_PALETTE[32],X ; Load script.
    AND #$30 ; Keep brightness bits.
    STA ENGINE_COMMIT_PALETTE[32],X ; Store result.
    PLA ; Pull hue bits.
    ORA ENGINE_COMMIT_PALETTE[32],X ; Combine with brightness.
COLOR_OUTPUT: ; 1F:0E6E, 0x03EE6E
    STA ENGINE_COMMIT_PALETTE[32],X ; Store color decided.
TARGET_REACHED: ; 1F:0E71, 0x03EE71
    DEX ; Index--
    BPL LOOP_PALETTE ; Positive, goto.
    TYA ; Y to X, iteration is delay frames.
    TAX
    JSR CREATE_PALETTE_UPLOAD_PACKET_X_WAIT ; Wait.
    DEY ; Iteration--
    CPY #$01 ; If _ #$01
    BNE LOOP_PMOD_ITERATION ; !=, goto.
    RTS ; Leave.
ENGINE_PALETTE_SCRIPT_TO_UPLOADED: ; 1F:0E7F, 0x03EE7F
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle.
    LDX #$1F ; Index.
LOOP_ALL_INDEXES: ; 1F:0E84, 0x03EE84
    LDA SCRIPT_PALETTE[32],X ; Load script.
    STA ENGINE_COMMIT_PALETTE[32],X ; To upload.
    DEX ; Index++
    BPL LOOP_ALL_INDEXES ; Positive, do more.
    RTS ; Leave.
ENGINE_PALETTE_SCRIPT_TO_TARGET: ; 1F:0E8E, 0x03EE8E
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle.
    LDX #$1F ; Index.
INDEX_POSITIVE: ; 1F:0E93, 0x03EE93
    LDA ENGINE_COMMIT_PALETTE[32],X ; Load from index.
    STA SCRIPT_PALETTE[32],X ; Store to other arr.
    DEX ; Index--
    BPL INDEX_POSITIVE ; Positive, loop.
    RTS
ENGINE_SETTLE_AND_PALETTE_FROM_PTR: ; 1F:0E9D, 0x03EE9D
    STA BCD/MODULO/DIGITS_USE_A ; Init FPTR.
    STX BCD/MODULO/DIGITS_USE_B
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle.
    LDY #$1F ; Index.
COUNT_POSITIVE: ; 1F:0EA6, 0x03EEA6
    LDA [BCD/MODULO/DIGITS_USE_A],Y ; From index.
    STA ENGINE_COMMIT_PALETTE[32],Y ; To script palette.
    DEY ; Index--
    BPL COUNT_POSITIVE ; Positive, loop to do all.
    BMI CREATE_PALETTE_UPLOAD_PACKET_0x1_WAIT ; Always taken, delay 0x1.
ENGINE_PALETTE_UPLOAD_WITH_PACKET_HELPER: ; 1F:0EB0, 0x03EEB0
    JSR ENGINE_PALETTE_SCRIPT_TO_UPLOADED ; Do script to uploaded.
CREATE_PALETTE_UPLOAD_PACKET_0x1_WAIT: ; 1F:0EB3, 0x03EEB3
    LDX #$01 ; Seed 0x1 wait.
CREATE_PALETTE_UPLOAD_PACKET_X_WAIT: ; 1F:0EB5, 0x03EEB5
    LDA #$04 ; Seed palette update.
    STA NMI_PPU_CMD_PACKETS_BUF[69]
    LDA #$00
    STA NMI_PPU_CMD_PACKETS_BUF+1 ; EOF.
    STA NMI_PPU_CMD_PACKETS_INDEX ; Reset index, new update.
    LDA #$80
    STA NMI_FLAG_EXECUTE_UPDATE_BUF_AND_MORE_TODO ; Set flag.
    JMP ENGINE_DELAY_X_FRAMES ; Goto.
ENGINE_HELPER_SETTLE_CLEAR_NMI_AND_TO_MAIN_SCREEN: ; 1F:0EC8, 0x03EEC8
    LDX #$00 ; Seed scroll.
    LDY #$00
ENGINE_HELPER_SETTLE_CLEAR_LATCH_SET_SCROLL_TODO_MORE: ; 1F:0ECC, 0x03EECC
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle updates.
    LDA #$00
    STA NMI_FP_UNK[2] ; Clear ptr.
    STA NMI_FP_UNK+1
    STA NMI_LATCH_FLAG_UNK ; Clear flag.
    LDA #$FC
    AND ENGINE_PPU_CTRL_COPY ; To screen 0x2000.
    STA ENGINE_PPU_CTRL_COPY
    STX ENGINE_SCROLL_X ; Set scroll 0x00.
    STY ENGINE_SCROLL_Y
    JMP ENGINE_NMI_0x01_SET/WAIT ; Settle 1 frame.
SCRIPT_INVERT_X_SCROLL_SETTLE: ; 1F:0EE4, 0x03EEE4
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle updates.
    LDA #$04
    EOR ENGINE_SCROLL_X ; Invert scroll bit.
    STA ENGINE_SCROLL_X ; Store back.
    JMP ENGINE_NMI_0x01_SET/WAIT ; Set wait, abuse RTS.
SCRIPT_SCROLL_INVERT_RTN?: ; 1F:0EF0, 0x03EEF0
    LDA CURRENT_SAVE_MANIPULATION_PAGE+543 ; Load ??
    AND #$F0 ; Keep upper.
    BEQ RTS ; == 0, leave.
    STA BCD/MODULO/DIGITS_USE_A ; Store val.
    ASL BCD/MODULO/DIGITS_USE_A ; Shift it.
    BCC RTS ; CC, leave.
    JSR RANDOMIZE_GROUP_A ; Adds ??
    AND #$C0 ; Keep 1100.0000
    BNE RTS ; Nonzero, leave.
    JSR ENGINE_PALETTE_SCRIPT_TO_TARGET ; Do.
    JSR ENGINE_PALETTE_FADE_SKIP_INDEX_0xE? ; Do ??
    LDX #$0A ; Seed ??
LOOP_X_TIMES: ; 1F:0F0C, 0x03EF0C
    LDA #$07 ; Seed ??
    STA SOUND_EFFECT_REQUEST_ARRAY[5] ; Set ??
    JSR SCRIPT_INVERT_X_SCROLL_SETTLE ; Do ??
    DEX ; X--
    BNE LOOP_X_TIMES ; != 0, loop more.
    JSR ENGINE_PALETTE_UPLOAD_WITH_PACKET_HELPER ; Colors.
RTS: ; 1F:0F1A, 0x03EF1A
    RTS ; Leave.
ENGINE_PALETTE_FADE_SKIP_INDEX_0xE?: ; 1F:0F1B, 0x03EF1B
    LDX #$0F ; Load ??
VAL_POSITIVE_LOOP: ; 1F:0F1D, 0x03EF1D
    CPX #$0E ; If _ val
    BEQ INDEX_SKIP ; == index, goto.
    SEC ; Set carry.
    LDA ENGINE_COMMIT_PALETTE[32],X ; Load from palette.
    SBC #$10 ; Color--
    BCS PALETTE_COLOR_NO_UNDERFLOW ; No underflow, goto.
ROM_BIT_HELPER_0XA9: ; 1F:0F29, 0x03EF29
    LDA #$0F ; Seed black.
PALETTE_COLOR_NO_UNDERFLOW: ; 1F:0F2B, 0x03EF2B
    STA ENGINE_COMMIT_PALETTE[32],X ; Store color.
INDEX_SKIP: ; 1F:0F2E, 0x03EF2E
    DEX ; Index--
    BPL VAL_POSITIVE_LOOP ; Positive, goto.
    JMP CREATE_PALETTE_UPLOAD_PACKET_0x1_WAIT ; Upload palette.
ENGINE_MENU_INIT_MASTER_FULL: ; 1F:0F34, 0x03EF34
    LDY #$08 ; Stream index for submenu included.
    LDA [FPTR_MENU_MASTER[2]],Y ; Move submenu ptr.
    STA FPTR_MENU_SUBMENU[2] ; Ptr L.
    INY ; Stream++
    LDA [FPTR_MENU_MASTER[2]],Y ; Move rows.
    STA FPTR_MENU_SUBMENU+1 ; Ptr H.
ENGINE_MENU_INIT_MASTER_PARTIAL: ; 1F:0F3F, 0x03EF3F
    LDY #$06 ; Stream index.
    LDA [FPTR_MENU_MASTER[2]],Y ; Move coord base.
    STA GFX_COORD_HORIZONTAL_OFFSET
    LDY #$07 ; Stream index++, not iny? Hmm...
    LDA [FPTR_MENU_MASTER[2]],Y ; Move coord base.
    STA GFX_COORD_VERTICAL_OFFSET ; Store to.
MENU_FILE_MAKE_ROW_OFFSET?: ; 1F:0F4B, 0x03EF4B
    LDY #$00 ; Stream reset.
    LDA [FPTR_MENU_MASTER[2]],Y ; Load from stream.
    STA MENU_COLUMN_INDEX ; Set ??
    TAX ; Val to X for multiply.
    LDY #$01 ; Stream set.
    LDA [FPTR_MENU_MASTER[2]],Y ; Load from stream. Max selection in line?
    JSR ENGINE_HEX_MULTIPLY_BYTES_TO_WORD_IN_XA ; Multiply with.
    STA MENU_SELECTED_SUBMENU_OPTION_INDEX_FINAL ; Store offset created.
    LDY #$00 ; Stream set.
    STY MENU_ROW_INDEX ; Clear which selected.
SUBMENU_FIND_VALID_OPTION: ; 1F:0F5F, 0x03EF5F
    LDA [FPTR_MENU_SUBMENU[2]],Y ; Load from submenu.
    BNE SUBMENU_OPTION_INDEX_FOUND ; Nonzero, goto.
    INY ; Stream++
    CPY MENU_SELECTED_SUBMENU_OPTION_INDEX_FINAL ; If index _ var
    BCC SUBMENU_FIND_VALID_OPTION ; <, can be valid, loop.
    STA MENU_SELECTED_SUBMENU_OPTION_INDEX_FINAL ; Clear vals. Overflow row size.
    STA SCRIPT_MENU_STATUS ; No status.
    RTS ; Leave to re-load?
SUBMENU_OPTION_INDEX_FOUND: ; 1F:0F6D, 0x03EF6D
    STY MENU_SELECTED_SUBMENU_OPTION_INDEX_FINAL ; Store offset.
    TYA ; Selection valid to A.
MODULO_FOR_SELECTION: ; 1F:0F70, 0x03EF70
    CMP MENU_COLUMN_INDEX ; If _ var
    BCC STORE_OPTION_ACTUALLY_ON? ; <, goto.
    SBC MENU_COLUMN_INDEX ; Sub with val.
    INC MENU_ROW_INDEX ; Is now on next row.
    BCS MODULO_FOR_SELECTION ; Always taken.
STORE_OPTION_ACTUALLY_ON?: ; 1F:0F7A, 0x03EF7A
    STA MENU_COLUMN_INDEX ; Store val, index of row selected.
SETTLE_AND_SPRITES_TO_COORD?_IDFK: ; 1F:0F7C, 0x03EF7C
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle updates.
    LDY #$18 ; Seed wait.
    STY SAVE_GAME_MOD_PAGE_PTR+1
    LDA #$00
    STA SPRITE_PAGE+2 ; Clear attrs.
TABLE_REPORT_INVALID: ; 1F:0F88, 0x03EF88
    LDY #$05 ; Stream index.
    LDA [FPTR_MENU_MASTER[2]],Y ; Move to cursor tile.
    STA SPRITE_PAGE+1
    LDY #$02 ; Stream index.
    LDA [FPTR_MENU_MASTER[2]],Y ; Load ?? from main.
    LDX MENU_COLUMN_INDEX ; Load which.
    JSR ENGINE_HEX_MULTIPLY_BYTES_TO_WORD_IN_XA ; Multiply file with selected.
    CLC ; Prep add.
    ADC GFX_COORD_HORIZONTAL_OFFSET ; Add with base val.
    ASL A ; << 3, *8. To tile pos.
    ASL A
    ASL A
    STA SPRITE_PAGE+3 ; Store to X, tile aligned.
    LDY #$03 ; Stream index.
    LDA [FPTR_MENU_MASTER[2]],Y ; Load from stream.
    LDX MENU_ROW_INDEX ; Load count in row.
    JSR ENGINE_HEX_MULTIPLY_BYTES_TO_WORD_IN_XA ; Multiply.
    CLC ; Prep add.
    ADC GFX_COORD_VERTICAL_OFFSET ; Add with.
    ASL A ; << 3, *8.
    ASL A
    ASL A
    CLC ; Prep add.
    ADC #$07 ; Add offset to put onto line proper.
    STA SPRITE_PAGE[256] ; Store to Ypos.
    LDY SAVE_GAME_MOD_PAGE_PTR+1 ; Load ??
LOOP_CTRL_INPUT_WAITER: ; 1F:0FB8, 0x03EFB8
    LDX #$00
    STX CONTROL_ACCUMULATED?[2] ; Clear buttons.
Y_LOOPS_CHECK: ; 1F:0FBC, 0x03EFBC
    JSR RANDOMIZE_GROUP_A ; Do ??
    JSR ENGINE_NMI_0x01_SET/WAIT ; Settle.
    LDA CONTROL_ACCUMULATED?[2] ; Load.
    BNE CONTROLS_PRESSED ; != 0, goto.
    DEY ; Y--
    BNE Y_LOOPS_CHECK ; != 0, goto.
    LDY #$05
    LDA [FPTR_MENU_MASTER[2]],Y ; Load cursor value to invert to 0x00. Smart.
    EOR SPRITE_PAGE+1 ; Invert with tile.
    STA SPRITE_PAGE+1 ; Store new tile.
    LDA CTRL_BUTTONS_PREVIOUS[2] ; Load.
    BNE BUTTONS_PREVIOUSLY_PRESSED ; Prev set, goto.
    LDY #$18 ; Reseed wait.
    STY SAVE_GAME_MOD_PAGE_PTR+1
    BNE LOOP_CTRL_INPUT_WAITER ; Always taken.
BUTTONS_PREVIOUSLY_PRESSED: ; 1F:0FDD, 0x03EFDD
    LDY #$06
    STY SAVE_GAME_MOD_PAGE_PTR+1 ; Reseed check wait.
CONTROLS_PRESSED: ; 1F:0FE1, 0x03EFE1
    LDX #$00
    STX CONTROL_ACCUMULATED?[2] ; Clear buttons.
    TAX ; Buttons to X.
    LDY #$04 ; File index.
    AND #$F0 ; Keep upper.
    AND [FPTR_MENU_MASTER[2]],Y ; Mask with file.
    BEQ A/B/SEL/START_NO_TRIGGER ; == 0, goto. Doesn't care.
    STA SCRIPT_MENU_STATUS ; Store nonzero otherwise.
    LDA #$05
    STA SOUND_EFFECT_REQUEST_ARRAY+1 ; Play sound effect.
EXIT_CURSOR_OFFSCREEN: ; 1F:0FF5, 0x03EFF5
    LDA #$F0
    STA SPRITE_PAGE[256] ; Set Y pos offscreen.
    RTS ; Leave.
A/B/SEL/START_NO_TRIGGER: ; 1F:0FFB, 0x03EFFB
    TXA ; Buttons to A.
    AND #$0F ; Test 
    STA SCRIPT_MENU_STATUS ; Keep U/D/L/R.
    TAY ; To Y.
    LDX BUTTON_TABLE_UDLR_ONLY,Y ; Load from table.
    BMI TABLE_REPORT_INVALID ; Negative, invalid entry.
    LDA MENU_COLUMN_INDEX ; Move selection column.
    STA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY[8]
    LDA MENU_ROW_INDEX ; Move selection row.
    STA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY+1
    STX RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY+3 ; Store button result.
LOOP_SELECTY?: ; 1F:1010, 0x03F010
    CLC ; Prep add.
    LDA ACTION_MENU_ROW_MOD,X ; Load from action arr.
    ADC RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY+1 ; Add with row.
    LDY #$01 ; Stream index max rows?
    CMP [FPTR_MENU_MASTER[2]],Y ; If _ stream
    BCS MENU_SELECTION_INVALID ; >=, goto. Invalid.
    STA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY+1 ; <, store. Valid row.
    STA BCD/MODULO/DIGITS_USE_A ; Also store to VALID ROW??
    CLC ; Prep add.
    LDA ACTION_MENU_COLUMN_MOD,X ; Load mod for column.
    ADC RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY[8] ; Add with column id.
    LDY #$00 ; Stream index max per group?
    CMP [FPTR_MENU_MASTER[2]],Y ; If _ stream
    BCS MENU_SELECTION_INVALID ; >=, goto. Invalid.
    STA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY[8] ; Store valid column id.
    STA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY+2 ; Store, valid column.
    LDA [FPTR_MENU_MASTER[2]],Y ; Load from FPTR.
    LDX BCD/MODULO/DIGITS_USE_A ; X from, valid row?
    JSR ENGINE_HEX_MULTIPLY_BYTES_TO_WORD_IN_XA ; Multiply.
    CLC ; Prep add.
    ADC RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY+2 ; Add with column.
    STA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY+2 ; Store result.
    TAY ; Value to Y index.
    LDA [FPTR_MENU_SUBMENU[2]],Y ; Load from submenu.
    BEQ SUBMENU_PTR_H_EQ_0x00 ; == 0, goto. Invalid.
    LDA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY[8] ; Move validated back ??
    STA MENU_COLUMN_INDEX
    LDA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY+1 ; Move row.
    STA MENU_ROW_INDEX
    LDA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY+2 ; Move ??
    STA MENU_SELECTED_SUBMENU_OPTION_INDEX_FINAL
    LDA #$0D ; Seed sound effect.
    STA SOUND_EFFECT_REQUEST_ARRAY+1
EXIT_REPORT_INVALID: ; 1F:1052, 0x03F052
    JMP TABLE_REPORT_INVALID ; Goto. TODO exactly what.
MENU_SELECTION_INVALID: ; 1F:1055, 0x03F055
    LDY #$04 ; Stream index.
    LDA SCRIPT_MENU_STATUS ; Load ??
    AND [FPTR_MENU_MASTER[2]],Y ; Mask with.
    BEQ EXIT_REPORT_INVALID ; == 0, goto.
    STA SCRIPT_MENU_STATUS ; Store mask nonzero.
    LDA #$0D
    STA SOUND_EFFECT_REQUEST_ARRAY+1 ; Seed sound effect.
    JMP EXIT_CURSOR_OFFSCREEN ; Exit off screen.
SUBMENU_PTR_H_EQ_0x00: ; 1F:1067, 0x03F067
    LDX RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY+3 ; X from.
    LDY #$01 ; Val ??
    LDA R_**:$00D6 ; Load.
    BEQ LOADED_EQ_0x00_A ; == 0, goto.
    INX ; Index++
    DEY ; Y--
LOADED_EQ_0x00_A: ; 1F:1071, 0x03F071
    LDA ACTION_MENU_COLUMN_MOD,X ; Load from index.
    BEQ LOADED_EQ_0x00_B ; == 0, goto.
LOOP_NONZERO: ; 1F:1076, 0x03F076
    STA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY+2 ; Store ??
    SEC ; Prep sub.
    LDA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY[8],Y ; Load from arr.
    SBC MENU_COLUMN_INDEX,Y ; Sub with.
    EOR #$FF ; Invert.
    BPL INVERT_POSITIVE ; Positive, goto.
    CLC ; Prep add.
    ADC MENU_COLUMN_INDEX,Y ; Add with.
    STA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY[8],Y ; Store to.
    BPL ADD_RESULT_POSITIVE ; Positive, goto.
    BMI ADD_RESULT_NEGATIVE ; Negative, goto.
INVERT_POSITIVE: ; 1F:108E, 0x03F08E
    SEC ; Prep add +1
    ADC MENU_COLUMN_INDEX,Y ; Add with.
    STA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY[8],Y ; Store to.
    CMP [FPTR_MENU_MASTER[2]],Y ; If _ stream
    BCC ADD_RESULT_POSITIVE ; <, goto.
ADD_RESULT_NEGATIVE: ; 1F:1099, 0x03F099
    LDA #$00 ; Seed ??
    CMP RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY+2 ; If _ var
    BNE LOOP_NONZERO ; != 0, goto.
    BEQ MENU_SELECTION_INVALID ; == 0, goto.
ADD_RESULT_POSITIVE: ; 1F:10A1, 0x03F0A1
    TYA ; Y to A.
    EOR #$01 ; Invert.
    TAY ; Back to Y.
    LDA MENU_COLUMN_INDEX,Y ; Move ??
    STA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY[8],Y
LOADED_EQ_0x00_B: ; 1F:10AB, 0x03F0AB
    LDX RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY+3 ; Load, action mod.
    JMP LOOP_SELECTY? ; Goto.
ENGINE_CURSOR_TO_BG_UPDATE_INTO_MENU?: ; 1F:10B0, 0x03F0B0
    PHA ; Save A.
    LDY #$02 ; Stream index.
    LDA [FPTR_MENU_MASTER[2]],Y ; Load X pos related?
    LDX MENU_COLUMN_INDEX ; Load index.
    JSR ENGINE_HEX_MULTIPLY_BYTES_TO_WORD_IN_XA ; Do.
    CLC ; Prep add.
    ADC GFX_COORD_HORIZONTAL_OFFSET ; Add with.
    STA GFX_COORD_HORIZONTAL_OFFSET ; Store to.
    LDY #$03 ; Stream index.
    LDA [FPTR_MENU_MASTER[2]],Y ; Load row height.
    LDX MENU_ROW_INDEX ; Load ??
    JSR ENGINE_HEX_MULTIPLY_BYTES_TO_WORD_IN_XA ; Multiply.
    CLC ; Prep add.
    ADC GFX_COORD_VERTICAL_OFFSET ; Add vert.
    STA GFX_COORD_VERTICAL_OFFSET ; Store result.
    PLA ; Pull A.
    JMP ENGINE_A_TO_UPDATE_PACKET ; Reenter.
LUT_0x01-0x08: ; 1F:10D1, 0x03F0D1
    .db 01
    .db 02
    .db 03
    .db 04
    .db 05
    .db 06
    .db 07
    .db 08
BUTTON_TABLE_UDLR_ONLY: ; 1F:10D9, 0x03F0D9
    .db 88 ; 0x00, None pressed. 0/2/4/6 = U/R/D/L
    .db 02 ; 0x01, R
    .db 06 ; 0x02, L
    .db 88 ; 0x03, LR
    .db 04 ; 0x04, D
    .db 88 ; 0x05, DR
    .db 88 ; 0x06, DL
    .db 88 ; 0x07, DRL
    .db 00 ; 0x08, U
    .db 88 ; 0x09, UR
    .db 88 ; 0x0A, UL
    .db 88 ; 0x0B, ULR
    .db 88 ; 0x0C, UD
    .db 88 ; 0x0D, UDR
    .db 88 ; 0x0E, UDL
    .db 88 ; 0x0F, UDLR
ACTION_MENU_COLUMN_MOD: ; 1F:10E9, 0x03F0E9
    .db 00 ; +0 U
ACTION_MENU_ROW_MOD: ; 1F:10EA, 0x03F0EA
    .db FF ; -1
    .db 01 ; +1 R
    .db 00 ; +0
    .db 00 ; +0 D
    .db 01 ; +1
    .db FF ; -1 L
    .db 00 ; +0
LIB_DECIMAL?_UNK: ; 1F:10F1, 0x03F0F1
    LDA #$00 ; Init clear.
    LDX #$10 ; Bits to check count.
VAL_NONZERO: ; 1F:10F5, 0x03F0F5
    ROR BCD/MODULO/DIGITS_USE_B ; Rotate bits.
    ROR BCD/MODULO/DIGITS_USE_A
    BCC ROTATE_CC
    CLC ; Prep add.
    ADC SAVE_GAME_MOD_PAGE_PTR[2] ; Add val.
ROTATE_CC: ; 1F:10FE, 0x03F0FE
    ROR A ; Rotate into A.
    DEX ; Count--
    BNE VAL_NONZERO ; != 0, goto.
    STA BCD/MODULO/DIGITS_USE_C ; Store val.
    ROR BCD/MODULO/DIGITS_USE_B ; Rotate bits.
    ROR BCD/MODULO/DIGITS_USE_A
    RTS ; Return.
LIB_DECIMAL?_UNK: ; 1F:1109, 0x03F109
    LDA #$00 ; Clear init.
    LDX #$18 ; Bits to check count.
VAL_NONZERO: ; 1F:110D, 0x03F10D
    ROR BCD/MODULO/DIGITS_USE_C ; Rotate bits.
    ROR BCD/MODULO/DIGITS_USE_B
    ROR BCD/MODULO/DIGITS_USE_A
    BCC ROTATE_CLEAR ; Clear, rotate.
    CLC ; Prep add.
    ADC SAVE_GAME_MOD_PAGE_PTR[2] ; Add val.
ROTATE_CLEAR: ; 1F:1118, 0x03F118
    ROR A ; Rotate into A.
    DEX ; Loops--
    BNE VAL_NONZERO ; != 0, goto.
    STA BCD/MODULO/DIGITS_USE_D ; Store result.
    ROR BCD/MODULO/DIGITS_USE_C ; Rotate all bits.
    ROR BCD/MODULO/DIGITS_USE_B
    ROR BCD/MODULO/DIGITS_USE_A
    RTS ; Leave.
ENGINE_HEX_MULTIPLY_BYTES_TO_WORD_IN_XA: ; 1F:1125, 0x03F125
    STA BCD/MODULO/DIGITS_USE_A ; Store bits.
    STX SAVE_GAME_MOD_PAGE_PTR[2] ; Store mod? Multiply?
    LDA #$00 ; Seed clear.
    LDX #$08 ; Loop count.
LOOPS_NONZERO: ; 1F:112D, 0x03F12D
    ROR BCD/MODULO/DIGITS_USE_A ; OUT: Unique bit. IN: Bit rotate out from A.
    BCC ROTATE_CLEAR ; Clear, goto.
    CLC ; Prep add.
    ADC SAVE_GAME_MOD_PAGE_PTR[2] ; Add with, stride per bit set.
ROTATE_CLEAR: ; 1F:1134, 0x03F134
    ROR A ; Rotate A. TODO: Why/result.
    DEX ; Loops--
    BNE LOOPS_NONZERO ; != 0, goto.
    TAX ; Val to X, high byte.
    LDA BCD/MODULO/DIGITS_USE_A ; Load low byte.
    ROR A ; Rotate final into.
    RTS ; Leave.
ENGINE_BINARY_MODULO_HELPER: ; 1F:113D, 0x03F13D
    LDA SAVE_GAME_MOD_PAGE_PTR[2] ; Load.
ENGINE_HOLD_FOREVER_IF_ZERO: ; 1F:113F, 0x03F13F
    BEQ ENGINE_HOLD_FOREVER_IF_ZERO ; == 0, loop forever. Mistake to be left in? Debug probs.
    LDA #$00 ; Init clear for rotate into.
    LDX #$18 ; Bits count.
    ROL BCD/MODULO/DIGITS_USE_A ; Rotate bits to seed it all.
    ROL BCD/MODULO/DIGITS_USE_B
    ROL BCD/MODULO/DIGITS_USE_C
PROCESS_WHOLE_NUMBER: ; 1F:114B, 0x03F14B
    ROL A ; Into A.
    BCS ROTATE_CS ; CS, goto.
    CMP SAVE_GAME_MOD_PAGE_PTR[2] ; If _ val
    BCC VAL_LT_VAR ; <, goto. Is okay.
ROTATE_CS: ; 1F:1152, 0x03F152
    SBC SAVE_GAME_MOD_PAGE_PTR[2] ; Sub with value. Either for overflow or set.
    SEC ; Bring in 0x1 on rotate.
VAL_LT_VAR: ; 1F:1155, 0x03F155
    ROL BCD/MODULO/DIGITS_USE_A ; Rotate into.
    ROL BCD/MODULO/DIGITS_USE_B
    ROL BCD/MODULO/DIGITS_USE_C
    DEX ; Todo--
    BNE PROCESS_WHOLE_NUMBER ; !=, goto.
    STA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY[8] ; Store result overflow.
    RTS ; Leave.
ENGINE_24BIT_TO_TEXT_DIGITS: ; 1F:1161, 0x03F161
    LDY #$08 ; Index output beginning for numbers.
LOOP_FIGURE_SINGLE_DIGIT: ; 1F:1163, 0x03F163
    DEY ; Index--
    LDA #$00 ; Seed ??
    LDX #$18 ; Count for all bits.
    ROL BCD/MODULO/DIGITS_USE_A ; Rotate to begin.
    ROL BCD/MODULO/DIGITS_USE_B
    ROL BCD/MODULO/DIGITS_USE_C
TODO_COUNT: ; 1F:116E, 0x03F16E
    ROL A ; ...into A.
    CMP #$0A ; If _ #$0A
    BCC VAL_IN_DECIMAL_RANGE ; <, goto, 0 back in.
    SBC #$0A ; Adjust. CS after, still.
VAL_IN_DECIMAL_RANGE: ; 1F:1175, 0x03F175
    ROL BCD/MODULO/DIGITS_USE_A ; Rotate again. CC in if no overflow. CS otherwise.
    ROL BCD/MODULO/DIGITS_USE_B
    ROL BCD/MODULO/DIGITS_USE_C
    DEX ; Loops--
    BNE TODO_COUNT ; != 0, loop.
    TAX ; Result in A.
    LDA LUT_NUMBER_TILES,X ; Move number tile.
    STA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY[8],Y ; Store to, number output.
    LDA BCD/MODULO/DIGITS_USE_A ; Combine all.
    ORA BCD/MODULO/DIGITS_USE_B
    ORA BCD/MODULO/DIGITS_USE_C
    BNE LOOP_FIGURE_SINGLE_DIGIT ; More to do since bits left, do.
    STY BCD/MODULO/DIGITS_USE_D ; Store initial digit index here.
    LDA #$A0 ; Seed blank tile.
    BNE SEED_BLANKS ; Always taken.
CLEAR_OTHERS: ; 1F:1193, 0x03F193
    STA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY[8],Y ; Store val.
SEED_BLANKS: ; 1F:1196, 0x03F196
    DEY ; Index--
    BPL CLEAR_OTHERS ; Positive, clear it too.
    RTS ; Leave.
LUT_NUMBER_TILES: ; 1F:119A, 0x03F19A
    .db B0 ; '0'
    .db B1
    .db B2
    .db B3
    .db B4
    .db B5
    .db B6
    .db B7
    .db B8
    .db B9 ; '9'
CLEAR_MODSTUFF_AND_GOTO: ; 1F:11A4, 0x03F1A4
    LDY #$00
    STY BCD/MODULO/DIGITS_USE_A
    STY BCD/MODULO/DIGITS_USE_B
    STY BCD/MODULO/DIGITS_USE_C
    BEQ SYNC_CLEARED
ENGINE_DEC_TO_BIN24: ; 1F:11AE, 0x03F1AE
    LDA #$00 ; Init. Y needs to be set to highest digit here.
    LDX #$18 ; Bit count.
LOOP_MORE_BITS: ; 1F:11B2, 0x03F1B2
    ROR BCD/MODULO/DIGITS_USE_C ; Rotate bits.
    ROR BCD/MODULO/DIGITS_USE_B
    ROR BCD/MODULO/DIGITS_USE_A
    BCC ROTATE_CC ; CC, goto.
    ADC #$09 ; Add 0xA, CS here. CC after.
ROTATE_CC: ; 1F:11BC, 0x03F1BC
    ROR A ; Rotate result.
    DEX ; Count--
    BNE LOOP_MORE_BITS ; != 0, do more.
    ROR BCD/MODULO/DIGITS_USE_C ; Rotate bits.
    ROR BCD/MODULO/DIGITS_USE_B
    ROR BCD/MODULO/DIGITS_USE_A
SYNC_CLEARED: ; 1F:11C6, 0x03F1C6
    LDA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY[8],Y ; Load from array.
    CMP #$BA ; If _ '00 cents'
    BCS ADD_VAL_TO_BITS ; >=, goto.
    CMP #$B0 ; If _ '0'
    BCC ADD_VAL_TO_BITS ; <, goto.
    SBC #$B0 ; Subtract to get base value.
    .db 2C ; BIT $00A9, BIT trick?
ADD_VAL_TO_BITS: ; 1F:11D4, 0x03F1D4
    LDA #$00 ; Seed 0x00
    CLC ; Prep add.
    ADC BCD/MODULO/DIGITS_USE_A ; Add with.
    STA BCD/MODULO/DIGITS_USE_A ; Store to.
    LDA #$00
    ADC BCD/MODULO/DIGITS_USE_B ; Carry add.
    STA BCD/MODULO/DIGITS_USE_B ; Store result.
    LDA #$00
    ADC BCD/MODULO/DIGITS_USE_C ; Carry add.
    STA BCD/MODULO/DIGITS_USE_C
    INY ; Digit++
    CPY #$08 ; If _ #$08
    BCC ENGINE_DEC_TO_BIN24 ; <, goto.
    RTS ; Leave.
RANDOMIZE_GROUP_A: ; 1F:11ED, 0x03F1ED
    CLC ; Prep add.
    LDA RANDOM_PAIR_A[2] ; Load ??
    ADC RANDOM_PAIR_A+1 ; Add with.
    STA RANDOM_PAIR_A+1 ; Store to.
    CLC ; Prep add.
    LDA RANDOM_PAIR_A[2] ; Load.
    ADC #$75 ; Add with.
    STA RANDOM_PAIR_A[2] ; Store to.
    LDA RANDOM_PAIR_A+1 ; Load.
    ADC #$63 ; Add with.
    STA RANDOM_PAIR_A+1 ; Store to.
    RTS
LIB_BATTLE_ENDED?: ; 1F:1202, 0x03F202
    JSR ENGINE_HELPER_R7_0x17 ; R7 to 0x17
    JSR ENGINE_SET_MAPPER_R6_TO_0x16 ; Do ??
    JSR LIB_VAL_TO_DECIMAL_AND_FILE? ; Do ??
    LDX #$2C ; Val ??
    LDY #$09 ; Stream index ??
    LDA [FPTR_5C_UNK[2]],Y ; Load from created in sub above.
    AND #$F0 ; Keep upper.
    CMP #$50 ; If _ #$50
    BEQ VAL_EQ_0x50 ; ==, goto.
    LSR A ; >> 4, /16.
    LSR A
    LSR A
    LSR A
    TAX ; To X.
VAL_EQ_0x50: ; 1F:121C, 0x03F21C
    TXA ; X to A.
    JSR SOUND_LIB_SET_NEW_SONG_ID ; Write song.
    JSR ENGINE_HELPER_R6_0x14 ; Set bank.
    JSR SCREEN_TRANSITIONER ; Do transition.
    JSR ENGINE_SET_MAPPER_R6_TO_0x16 ; Map.
    JSR SETTLE_SPRITES_OFFSCREEN/CLEAR_OBJ_RAM ; Do.
    JSR ENGINE_CLEAR_SCREENS_0x2000-0x2800 ; Clear screens.
    JSR HELPER_FADE_AND_SET_LATCHED_IDK ; Do ??
    JSR SUB_CLEAR_MANY_UNK ; Do ??
    JSR LIB_CHECK_ENDING_TEST_ALOT_FADE_AND_MOAR ; Do, end game test here.
    RTS ; Leave.
ENGINE_SET_MAPPER_R6_TO_0x16: ; 1F:1239, 0x03F239
    PHA
    TXA ; Save X and A.
    PHA
    LDA #$16 ; Seed R6 to 0x16.
    LDX #$06
    JSR ENGINE_MAPPER_COMMIT_BANK_X_VAL_A ; Set mapper.
    PLA
    TAX ; Restore X/A.
    PLA
    RTS ; Leave.
ENGINE_SET_MAPPER_R6_TO_0x00: ; 1F:1247, 0x03F247
    PHA
    TXA
    PHA
    LDA #$00
    LDX #$06
    JSR ENGINE_MAPPER_COMMIT_BANK_X_VAL_A ; Set mapper.
    PLA
    TAX
    PLA
    RTS
SOUND_LIB_SET_NEW_SONG_ID: ; 1F:1255, 0x03F255
    CMP SOUND_MAIN_SONG_CURRENTLY_PLAYING_ID ; If _ val
    BEQ SONG_ID_MATCHES ; ==, goto.
    STA SOUND_MAIN_SONG_INIT_ID ; Store if differs, trigger init.
SONG_ID_MATCHES: ; 1F:125D, 0x03F25D
    RTS ; Leave.
ENGINE_WAIT_X_SETTLES: ; 1F:125E, 0x03F25E
    TXA ; X to A.
    BEQ RTS ; == 0, leave.
    PHA ; Save it.
    JSR ENGINE_NMI_0x01_SET/WAIT ; Wait.
    PLA ; Pull.
    TAX ; Back to X.
    DEX ; X--
    BNE ENGINE_WAIT_X_SETTLES ; != 0, goto.
RTS: ; 1F:126A, 0x03F26A
    RTS
    INX ; Index++
LOOP_SCRIPTY_BG: ; 1F:126C, 0x03F26C
    TXA
    PHA
    JSR SCRIPTY_ITERATE_BG_COLORS_RTN ; Do scripty.
    PLA ; Restore X count.
    TAX
    DEX
    BNE LOOP_SCRIPTY_BG ; != 0, loop.
    JSR SCRIPTY_ITERATE_BG_COLORS_RTN ; Do one last time.
    JMP PALETTE_MOD_TO_BLACK ; Do to black.
SCRIPTY_ITERATE_BG_COLORS_RTN: ; 1F:127C, 0x03F27C
    LDX #$2F ; Iterations.
KEEP_ITERATING: ; 1F:127E, 0x03F27E
    TXA ; Index to A.
    PHA ; Save it.
    AND #$0F ; Keep lower.
    LSR A ; Shift it, too.
    TAX ; To index.
    LDA BG_COLORS,X ; Load BG color to do.
    JSR PALETTE_MOD_BG_COLOR_TO_A ; Set BG color.
    JSR ENGINE_NMI_0x01_SET/WAIT ; Wait settle.
    JSR ENGINE_NMI_0x01_SET/WAIT ; 2x
    PLA ; Pull iteration.
    TAX ; To X.
    DEX ; --
    BNE KEEP_ITERATING ; != 0, goto.
    RTS ; Leave.
BG_COLORS: ; 1F:1296, 0x03F296
    .db 21
    .db 22
    .db 23
    .db 24
    .db 25
    .db 24
    .db 23
    .db 22
SCRIPT_CTRL_WAIT_A/B_PRESSED: ; 1F:129E, 0x03F29E
    LDX #$00
    STX CONTROL_ACCUMULATED?[2] ; Clear CTRL.
A/B_NOT_PRESSED: ; 1F:12A2, 0x03F2A2
    JSR ENGINE_NMI_0x01_SET/WAIT ; Wait.
    LDA CONTROL_ACCUMULATED?[2] ; Load.
    STX CONTROL_ACCUMULATED?[2] ; Clear.
    AND #$C0 ; Test A/B
    BEQ A/B_NOT_PRESSED ; !=, goto.
    RTS ; Leave.
SWITCH_TABLE_PAST_JSR_INDIRECT: ; 1F:12AE, 0x03F2AE
    ASL A ; << 1, *2.
    TAY ; Val to Y.
    INY ; Offset 0x3, one for addr, two for skipping first slot?
    INY
    INY
    PLA ; RTS Addr as ptr.
    STA BCD/MODULO/DIGITS_USE_A
    PLA
    STA BCD/MODULO/DIGITS_USE_B
    LDA [BCD/MODULO/DIGITS_USE_A],Y ; Load from JSR file.
    STA BCD/MODULO/DIGITS_USE_C ; Store to call.
    INY ; Stream++
    LDA [BCD/MODULO/DIGITS_USE_A],Y ; Load from file.
    STA BCD/MODULO/DIGITS_USE_D ; Call H.
    LDY #$01 ; Reseed into first ptr.
    SEC ; Prep sub for RTS fix to Addr-0x1
    LDA [BCD/MODULO/DIGITS_USE_A],Y ; Load from header, RTS PTR L.
    SBC #$01 ; -= 0x1
    TAX ; Save to X.
    INY ; Stream++
    LDA [BCD/MODULO/DIGITS_USE_A],Y ; Load from file, RTS PTR H.
    SBC #$00 ; Carry sub.
    PHA ; Save back to stack.
    TXA ; Save lower.
    PHA
    JMP [BCD/MODULO/DIGITS_USE_C] ; Run main routine.
SWITCH_TABLE_PAST_JSR_HELPER: ; 1F:12D5, 0x03F2D5
    ASL A ; << 1, *2. To word offset.
    TAY ; To Y.
    INY ; Offset stream data.
    PLA ; Pull address from stack.
    STA BCD/MODULO/DIGITS_USE_A ; Address to fptr.
    PLA
    STA BCD/MODULO/DIGITS_USE_B
    SEC ; Prep sub.
    LDA [BCD/MODULO/DIGITS_USE_A],Y ; Load from file.
    SBC #$01 ; Sub for RTS offset.
    TAX ; To X.
    INY ; Stream++
    LDA [BCD/MODULO/DIGITS_USE_A],Y ; Load PTR H.
    SBC #$00 ; Carry sub.
    PHA ; Save addr created.
    TXA
    PHA
    RTS ; Run the switch option.
SCRIPT_HARD_SWITCH_TO_SOMETHING_HUGE: ; 1F:12ED, 0x03F2ED
    PHA ; Save A,X,Y.
    TXA
    PHA
    TYA
    PHA
    LDA BCD/MODULO/DIGITS_USE_D ; Save.
    PHA
    LDA BCD/MODULO/DIGITS_USE_C ; Save.
    PHA
    LDA SAVE_GAME_MOD_PAGE_PTR+1 ; Save.
    PHA
    LDA SAVE_GAME_MOD_PAGE_PTR[2] ; Save.
    PHA
    LDA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY+1 ; Save.
    PHA
    LDA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY[8] ; Save.
    PHA
    LDA BCD/MODULO/DIGITS_USE_B ; Load ??
    AND #$FC ; Keep 1111.1100
    PHA ; Save.
    LDX #$06 ; Seed iterations to shift. *64
LOOP_ROTATE: ; 1F:130B, 0x03F30B
    ASL BCD/MODULO/DIGITS_USE_A ; << 1
    ROL BCD/MODULO/DIGITS_USE_B ; Roll into.
    DEX ; Count--
    BNE LOOP_ROTATE ; != 0, loop.
    STX BCD/MODULO/DIGITS_USE_C ; Clear.
    TXA ; Clear A.
    PHA ; 0x00 to stack.
    LDA BCD/MODULO/DIGITS_USE_B ; Save shifty.
    PHA
    LDA BCD/MODULO/DIGITS_USE_A
    PHA
    LDA #$64
    STA SAVE_GAME_MOD_PAGE_PTR[2] ; Seed PTR L.
    JSR ENGINE_BINARY_MODULO_HELPER ; Do numbers.
    JSR RANDOMIZE_GROUP_A ; Randomize.
    LSR A ; A >> 1 to get random decision.
    PHP ; Save the randomness.
    TAX ; To X index.
    LDA ROM_TABLE_RANDOM_UNK,X ; Move ??
    STA SAVE_GAME_MOD_PAGE_PTR[2]
    JSR LIB_DECIMAL?_UNK ; Do 
    PLP ; Pull status.
    BCS DO_SUBS_ROUTINE ; CS, goto.
    PLA ; Pull value.
    ADC BCD/MODULO/DIGITS_USE_A ; Add with.
    STA BCD/MODULO/DIGITS_USE_A ; Store result.
    PLA ; Pull value.
    ADC BCD/MODULO/DIGITS_USE_B ; Add with.
    STA BCD/MODULO/DIGITS_USE_B ; Store result.
    PLA ; Pull value.
    ADC BCD/MODULO/DIGITS_USE_C ; Add with.
    STA BCD/MODULO/DIGITS_USE_C ; Store result.
    JMP SHIFTY_BACK_UNK ; Goto.
DO_SUBS_ROUTINE: ; 1F:1346, 0x03F346
    PLA ; Pull value.
    SBC BCD/MODULO/DIGITS_USE_A ; Sub with.
    STA BCD/MODULO/DIGITS_USE_A ; Store to.
    PLA ; Pull value.
    SBC BCD/MODULO/DIGITS_USE_B ; Sub with.
    STA BCD/MODULO/DIGITS_USE_B ; Store to.
    PLA ; Pull value.
    SBC BCD/MODULO/DIGITS_USE_C ; Sub with.
    STA BCD/MODULO/DIGITS_USE_C ; Store to.
SHIFTY_BACK_UNK: ; 1F:1355, 0x03F355
    LDX #$06 ; Iterations.
LOOP_SHIFT: ; 1F:1357, 0x03F357
    LSR BCD/MODULO/DIGITS_USE_C ; Shift.
    ROR BCD/MODULO/DIGITS_USE_B ; Rotate into.
    ROR BCD/MODULO/DIGITS_USE_A ; 2x
    DEX ; Count--
    BNE LOOP_SHIFT ; != 0, do more.
    PLA ; Pull stack.
    ORA BCD/MODULO/DIGITS_USE_B ; Combine with.
    STA BCD/MODULO/DIGITS_USE_B ; Store to.
    PLA ; Stack to.
    STA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY[8]
    PLA ; 2x
    STA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY+1
    PLA ; 3x
    STA SAVE_GAME_MOD_PAGE_PTR[2]
    PLA ; 4x
    STA SAVE_GAME_MOD_PAGE_PTR+1
    PLA ; 5x
    STA BCD/MODULO/DIGITS_USE_C
    PLA ; 6x
    STA BCD/MODULO/DIGITS_USE_D
    PLA ; Restore Y.
    TAY
    PLA
    TAX ; Restore X.
    PLA ; Restore A.
    RTS ; Leave.
ROM_TABLE_RANDOM_UNK: ; 1F:137D, 0x03F37D
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 0C
    .db 0C
    .db 0C
    .db 0C
    .db 0C
    .db 01
    .db 01
    .db 01
    .db 01
    .db 01
    .db 01
    .db 01
    .db 01
    .db 01
    .db 01
    .db 02
    .db 02
    .db 02
    .db 02
    .db 02
    .db 02
    .db 02
    .db 02
    .db 02
    .db 02
    .db 03
    .db 03
    .db 03
    .db 03
    .db 03
    .db 03
    .db 03
    .db 03
    .db 03
    .db 03
    .db 04
    .db 04
    .db 04
    .db 04
    .db 04
    .db 04
    .db 04
    .db 04
    .db 04
    .db 04
    .db 05
    .db 05
    .db 05
    .db 05
    .db 05
    .db 05
    .db 05
    .db 05
    .db 05
    .db 14
    .db 06
    .db 06
    .db 06
    .db 06
    .db 06
    .db 06
    .db 06
    .db 06
    .db 06
    .db 15
    .db 07
    .db 07
    .db 07
    .db 07
    .db 07
    .db 07
    .db 07
    .db 07
    .db 11
    .db 11
    .db 08
    .db 08
    .db 08
    .db 08
    .db 08
    .db 08
    .db 08
    .db 08
    .db 12
    .db 12
    .db 09
    .db 09
    .db 09
    .db 09
    .db 09
    .db 09
    .db 09
    .db 0F
    .db 0F
    .db 0F
    .db 0A
    .db 0A
    .db 0A
    .db 0A
    .db 0A
    .db 0A
    .db 0D
    .db 0D
    .db 0D
    .db 0D
    .db 0B
    .db 0B
    .db 0B
    .db 0B
    .db 0B
    .db 0B
    .db 0E
    .db 0E
    .db 0E
    .db 0E
    .db 10
    .db 10
    .db 10
    .db 13
    .db 13
    .db 16
    .db 17
    .db 18
MISC_RESTORE_REPLACE_AND_RESTORE_UNK: ; 1F:13FD, 0x03F3FD
    TAX ; A to X.
    LDA BCD/MODULO/DIGITS_USE_B ; Move to stack.
    PHA
    LDA BCD/MODULO/DIGITS_USE_A
    PHA
    STX BCD/MODULO/DIGITS_USE_A ; X to.
    LDA #$00
    STA BCD/MODULO/DIGITS_USE_B ; Clear ??
    JSR SCRIPT_HARD_SWITCH_TO_SOMETHING_HUGE ; Do ??
    LDA BCD/MODULO/DIGITS_USE_B ; Load ??
    BEQ VAL_EQ_0x00 ; == 0, goto.
    LDA #$FF
    STA BCD/MODULO/DIGITS_USE_A ; Set ??
VAL_EQ_0x00: ; 1F:1415, 0x03F415
    LDX BCD/MODULO/DIGITS_USE_A ; Load ??
    PLA
    STA BCD/MODULO/DIGITS_USE_A ; Restore old.
    PLA
    STA BCD/MODULO/DIGITS_USE_B
    TXA ; X to A.
    RTS ; Leave.
LIB_DIRECT_ENTRY_TOSOLVE: ; 1F:141F, 0x03F41F
    PHA ; Save A.
    ASL A ; << 2, *4.
    ASL A
    BEQ EXIT_RESTORE ; == 0, goto.
    TAX ; To index.
    LDA $9EEA,X ; Move ??
    STA SAVE_GAME_MOD_PAGE_PTR+1
    LDA $9EEB,X
    STA ALT_COUNT_UNK ; 2x
    LDA $9EE9,X ; Load ??
    CMP #$00 ; If _ #$00
    BNE SWITCH_NONZERO? ; != 0, goto.
    LDA SAVE_GAME_MOD_PAGE_PTR+1 ; Move ??
    STA SOUND_EFFECT_REQUEST_ARRAY[5]
    JMP ENTRY_PAST ; Past.
SWITCH_NONZERO?: ; 1F:143E, 0x03F43E
    CMP #$01 ; If _ #$01
    BNE SWITCH_NE_0x1 ; != 0, goto.
    LDA SAVE_GAME_MOD_PAGE_PTR+1 ; Move ??
    STA SOUND_EFFECT_REQUEST_ARRAY+1
    JMP ENTRY_PAST ; Past.
SWITCH_NE_0x1: ; 1F:144A, 0x03F44A
    CMP #$02 ; If _ #$02
    BNE SWITCH_NE_0x2 ; != 0, goto.
    LDA SAVE_GAME_MOD_PAGE_PTR+1 ; Move ??
    STA R_**:$07F3
    JMP ENTRY_PAST ; Past.
SWITCH_NE_0x2: ; 1F:1456, 0x03F456
    LDA SAVE_GAME_MOD_PAGE_PTR+1 ; Move ??
    STA SOUND_EFFECT_REQUEST_ARRAY+4
ENTRY_PAST: ; 1F:145B, 0x03F45B
    LDX ALT_COUNT_UNK ; Load wait.
    JSR ENGINE_WAIT_X_SETTLES ; Wait.
    JSR ENGINE_SET_MAPPER_R6_TO_0x16 ; Set mapper.
EXIT_RESTORE: ; 1F:1463, 0x03F463
    PLA ; Pull A.
    RTS ; Leave.
    LDX #$0F ; Index.
LOOP_OBJECTS: ; 1F:1467, 0x03F467
    TXA ; Save X to stack.
    PHA
    LDA #$05
    STA SOUND_EFFECT_REQUEST_ARRAY+1 ; Set ??
    LDX #$02 ; Wait.
    JSR ENGINE_WAIT_X_SETTLES
    PLA ; Pull obj.
    TAX
    DEX ; Obj--
    BNE LOOP_OBJECTS ; != 0, loop.
    RTS ; Leave.
LIB_VAL_TO_DECIMAL_AND_FILE?: ; 1F:1479, 0x03F479
    LDA SCRIPT_ENCOUNTER_ID?(SAID_SONG_ID???) ; Val ??
    STA BCD/MODULO/DIGITS_USE_A ; Move.
    LDA #$00
    STA BCD/MODULO/DIGITS_USE_B ; Clear bits upper.
    LDA #$0A
    STA SAVE_GAME_MOD_PAGE_PTR[2] ; Val inc.
    JSR LIB_DECIMAL?_UNK ; Do ??
    CLC
    LDA #$98 ; Load ??
    ADC BCD/MODULO/DIGITS_USE_A ; Add with.
    STA FPTR_5C_UNK[2] ; Store result.
    LDA #$8F ; Load.
    ADC BCD/MODULO/DIGITS_USE_B ; Add ??
    STA FPTR_5C_UNK+1 ; Store result.
    RTS ; Leave.Leave.
ENGINE_SET_PALETTE_AND_QUEUE_UPLOAD: ; 1F:1496, 0x03F496
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle.
    LDY #$1F ; Index.
STREAM_POSITIVE: ; 1F:149B, 0x03F49B
    LDA [BCD/MODULO/DIGITS_USE_A],Y ; Load from stream.
    STA ENGINE_COMMIT_PALETTE[32],Y ; Store to arr.
    DEY ; Stream--
    BPL STREAM_POSITIVE ; Positive, goto.
ENGINE_QUEUE_UPDATE_PALETTE_PACKET: ; 1F:14A3, 0x03F4A3
    LDA #$04
    STA NMI_PPU_CMD_PACKETS_BUF[69] ; Queue palette update.
    LDA #$00
    STA NMI_PPU_CMD_PACKETS_BUF+1 ; EOF for update.
    LDA #$00
    STA NMI_PPU_CMD_PACKETS_INDEX ; Reset index.
    LDA #$80
    STA NMI_FLAG_EXECUTE_UPDATE_BUF_AND_MORE_TODO ; Set flag.
    RTS ; Leave.
PALETTE_MOD_TO_BLACK: ; 1F:14B6, 0x03F4B6
    LDA #$0F ; Val ??
PALETTE_MOD_BG_COLOR_TO_A: ; 1F:14B8, 0x03F4B8
    PHA ; Save value.
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle.
    PLA ; Pull val.
    LDY #$1C ; Stream index BG color.
INDEX_POSITIVE: ; 1F:14BF, 0x03F4BF
    STA ENGINE_COMMIT_PALETTE[32],Y ; Store to palette.
    DEY ; Slot--
    DEY
    DEY
    DEY
    BPL INDEX_POSITIVE ; Positive, goto.
    JSR ENGINE_QUEUE_UPDATE_PALETTE_PACKET ; Do ??
    JMP ENGINE_NMI_0x01_SET/WAIT ; Wait.
LIB_SUB_TODO: ; 1F:14CE, 0x03F4CE
    ASL A ; << 1, *1.
    STA BCD/MODULO/DIGITS_USE_A ; Store to.
    TXA ; Save X and Y.
    PHA
    TYA
    PHA
    JSR ENGINE_SET_MAPPER_R6_TO_0x00 ; R6 to 0x00.
    LDY BCD/MODULO/DIGITS_USE_A ; Load as index.
    LDA PTR_TABLE_UNK_L,Y ; Index to PTR.
    STA BCD/MODULO/DIGITS_USE_A
    LDA PTR_TABLE_UNK_H,Y
    STA BCD/MODULO/DIGITS_USE_B
    LDY #$00 ; Reset stream index.
    LDA [BCD/MODULO/DIGITS_USE_A],Y ; Load from file.
    STA ALT_STUFF_COUNT? ; Store to ??
    INY ; Stream++
    LDX GFX_COORD_HORIZONTAL_OFFSET ; Load coord.
    LDA [BCD/MODULO/DIGITS_USE_A],Y ; Load from stream.
    CMP #$FF ; If _ #$FF
    BEQ USE_XCOORD_ASIS ; ==, goto.
    TAX ; Val replaces coord.
USE_XCOORD_ASIS: ; 1F:14F4, 0x03F4F4
    STX BCD/MODULO/DIGITS_USE_C ; X to. Coord?
    INY ; Stream++
    LDX GFX_COORD_VERTICAL_OFFSET ; Load Ycoord.
    LDA [BCD/MODULO/DIGITS_USE_A],Y ; Load from file.
    CMP #$FF ; If _ #$FF
    BEQ USE_YCOORD_ASIS ; ==, use coord as-is.
    TAX ; Val replaces coord.
USE_YCOORD_ASIS: ; 1F:1500, 0x03F500
    STX BCD/MODULO/DIGITS_USE_D ; Store val.
LIB_X_STORE_UNK: ; 1F:1502, 0x03F502
    INY ; Stream++
    LDA [BCD/MODULO/DIGITS_USE_A],Y ; Load from stream.
    LDX #$00 ; Val ??
    CMP #$FC ; If _ #$FC
    BEQ X_STORE_AND_RERUN ; ==, goto.
    LDX #$01 ; Val.
    CMP #$FD ; If _ #$FD
    BEQ X_STORE_AND_RERUN ; ==, goto.
    LDX #$02 ; Val.
    CMP #$FE ; If _ #$FE
    BEQ X_STORE_AND_RERUN ; ==, goto.
    CMP #$FF ; If _ #$FF
    BEQ EXIT_RESTORE_R6 ; ==, goto.
    JSR LIB_MOVE_PTR_LOL ; Do routine with A val.
    JMP LIB_X_STORE_UNK ; Goto, loop.
X_STORE_AND_RERUN: ; 1F:1521, 0x03F521
    STX ALT_COUNT_UNK ; Store X.
    JMP LIB_X_STORE_UNK ; Loop, goto.
EXIT_RESTORE_R6: ; 1F:1526, 0x03F526
    JSR ENGINE_SET_MAPPER_R6_TO_0x16 ; Set R6.
    PLA
    TAY ; Restore X and Y.
    PLA
    TAX
    RTS ; Leave.
LIB_MOVE_PTR_LOL: ; 1F:152E, 0x03F52E
    TAX ; A to X, count to do loop below.
    INY ; Stream++
    LDA [BCD/MODULO/DIGITS_USE_A],Y ; Move pointer ??
    STA SAVE_GAME_MOD_PAGE_PTR[2]
    INY ; Stream++
    LDA [BCD/MODULO/DIGITS_USE_A],Y
    STA SAVE_GAME_MOD_PAGE_PTR+1
X_NONZERO: ; 1F:1539, 0x03F539
    TXA ; Save X and Y.
    PHA
    TYA
    PHA
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle.
    LDA #$00
    STA R_**:$0070 ; Clear ??
    LDA BCD/MODULO/DIGITS_USE_C ; Move to HPos coord.
    STA GFX_COORD_HORIZONTAL_OFFSET
    LDA SAVE_GAME_MOD_PAGE_PTR[2] ; Move packet creation ptr.
    STA FPTR_PACKET_CREATION/PTR_H_FILE_IDK[2]
    LDA SAVE_GAME_MOD_PAGE_PTR+1
    STA FPTR_PACKET_CREATION/PTR_H_FILE_IDK+1
    JSR LIB_SAVE_STATE_FULL? ; Save state and do routine.
    CLC ; Prep add.
    LDA BCD/MODULO/DIGITS_USE_D ; Load ??
    ADC ALT_STUFF_COUNT? ; Add with.
    STA BCD/MODULO/DIGITS_USE_D ; Store result.
    PLA
    TAY ; Restore X and Y.
    PLA
    TAX
    DEX ; X--
    BNE X_NONZERO ; != 0, loop.
    RTS ; Leave.
LIB_SAVE_STATE_FULL?: ; 1F:1562, 0x03F562
    LDA BCD/MODULO/DIGITS_USE_B ; Stack this stuff.
    PHA
    LDA BCD/MODULO/DIGITS_USE_A
    PHA
    LDA BCD/MODULO/DIGITS_USE_C
    PHA
    LDA SAVE_GAME_MOD_PAGE_PTR+1
    PHA
    LDA SAVE_GAME_MOD_PAGE_PTR[2]
    PHA
    LDA ALT_COUNT_UNK
    PHA
    LDA ALT_STUFF_COUNT?
    PHA
    LDA ALT_COUNT_UNK
    BEQ VAL_EQ_0x00 ; == 0, goto.
    CMP #$01 ; If _ #$01
    BEQ LIB_STATE_RESTORE_WITH_UPDATE ; ==, goto.
    LDA BCD/MODULO/DIGITS_USE_D ; Move ??
    STA GFX_COORD_VERTICAL_OFFSET
    PHA ; Save it, too.
    JSR ENGINE_CREATE_UPDATE_BUF_INIT_INC? ; Do.
    PLA ; Pull saved.
    STA BCD/MODULO/DIGITS_USE_D ; Store back.
    JMP LIB_STATE_RESTORE ; Restore.
VAL_EQ_0x00: ; 1F:158D, 0x03F58D
    CLC ; Prep add.
    LDA BCD/MODULO/DIGITS_USE_D ; Load val.
    ADC ALT_STUFF_COUNT? ; Mod val.
    STA GFX_COORD_VERTICAL_OFFSET ; Store to.
    PHA ; Save it, too.
    JSR RTN_SETTLE_UPDATE_TODO ; Do.
    PLA ; Pull saved.
    STA BCD/MODULO/DIGITS_USE_D ; Restore it.
    JMP LIB_STATE_RESTORE ; Restore.
LIB_STATE_RESTORE_WITH_UPDATE: ; 1F:159E, 0x03F59E
    CLC ; Prep add.
    LDA BCD/MODULO/DIGITS_USE_D ; Load ??
    ADC ALT_STUFF_COUNT? ; Add with.
    STA GFX_COORD_VERTICAL_OFFSET ; Store to.
    PHA ; Save it.
    JSR ENGINE_CREATE_UPDATE_BUF_INIT_DEC? ; Do update.
    PLA ; Pull it.
    STA BCD/MODULO/DIGITS_USE_D ; Restore it.
LIB_STATE_RESTORE: ; 1F:15AC, 0x03F5AC
    PLA ; From stack to vars.
    STA ALT_STUFF_COUNT?
    PLA
    STA ALT_COUNT_UNK
    PLA
    STA SAVE_GAME_MOD_PAGE_PTR[2]
    PLA
    STA SAVE_GAME_MOD_PAGE_PTR+1
    PLA
    STA BCD/MODULO/DIGITS_USE_C
    PLA
    STA BCD/MODULO/DIGITS_USE_A
    PLA
    STA BCD/MODULO/DIGITS_USE_B
    RTS ; Leave.
    LDA FLAG_SPRITE_OFF_SCREEN_UNK ; Load ??
    PHA ; Save it.
    JSR CLEAR_FLAG_OFFSCREEN ; Do.
    LDA #$DF
    STA FPTR_MENU_SUBMENU[2] ; Set up PTR, 1F:15DF data table.
    LDA #$F5
    STA FPTR_MENU_SUBMENU+1
    LDA #$DF
    STA FPTR_MENU_MASTER[2] ; Set up ptr, 1F:15DF data table.
    LDA #$F5
    STA FPTR_MENU_MASTER+1
    JSR MENU_FILE_MAKE_ROW_OFFSET? ; Do ??
    PLA ; Pull A.
    STA FLAG_SPRITE_OFF_SCREEN_UNK ; Restore it.
    RTS ; Leave.
    .db 01 ; Data table ??
    .db 01
    .db 00
    .db 00
    .db C0
    .db 5D
    PHA ; Save A,X,Y.
    TXA
    PHA
    TYA
    PHA
    JSR TODO_ROUTINE_NO_MASK_ENTRY ; Do ??
    JSR LIB_IDFK ; Do ??
    PLA ; Restore A,X,Y.
    TAY
    PLA
    TAX
    PLA
    SEC ; Ret CS.
    RTS ; Leave.
LIB_PTR_CREATE_UNK: ; 1F:15F7, 0x03F5F7
    STA BCD/MODULO/DIGITS_USE_C ; A to.
    LDA #$00 ; Init clear.
    ASL BCD/MODULO/DIGITS_USE_C ; << 1, *2.
    ROL A ; Into A.
    ASL BCD/MODULO/DIGITS_USE_C ; 2x
    ROL A
    ASL BCD/MODULO/DIGITS_USE_C ; 3x
    ROL A
    STA BCD/MODULO/DIGITS_USE_D ; A result to.
    CLC
    LDA BCD/MODULO/DIGITS_USE_C ; LOad.
    ADC #$00 ; += 0x00
    STA BCD/MODULO/DIGITS_USE_C ; Store result.
    LDA BCD/MODULO/DIGITS_USE_D ; Load.
    ADC #$9E ; += 0x9E
    STA BCD/MODULO/DIGITS_USE_D ; Store result.
    RTS ; Leave.
LIB_IDFK: ; 1F:1614, 0x03F614
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle.
    LDY #$E8
    STY RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY[8] ; Set ??
    LDA #$DF
    STA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY+1
    LDY COUNT_LOOPS?_UNK ; Y from.
Y_LOOP: ; 1F:1622, 0x03F622
    SEC ; Prep sub.
    LDA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY+1 ; Load ??
    SBC #$10 ; Sub.
    STA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY+1 ; Store back.
    DEY ; Y--
    BNE Y_LOOP ; !=, goto.
    LDA #$00
    STA ALT_STUFF_COUNT? ; Clear ??
VAL_NE_0x60: ; 1F:1630, 0x03F630
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle.
    LDY ALT_STUFF_COUNT? ; Load index.
    LDA STREAM_INDEXES_ARR_UNK[24],Y
    BEQ DATA_INDEXED_0x00 ; == 0, goto.
    LDA STREAM_INDEXES_ARR_UNK+17,Y ; Load really indexed.
    AND #$06 ; Keep 0000.0110
    EOR #$06 ; Invert them.
    BEQ DATA_INDEXED_0x00 ; == 0, goto.
    LDX #$02 ; Seed main.
    LDA STREAM_INDEXES_ARR_UNK+1,Y ; Load from pair.
    AND #$80 ; Keep neg.
    BNE NEGATIVE_SET ; Set, goto.
    LDX #$01 ; Seed alt
    JSR ROUTINE_OBJ_HANDLE_UNK_A ; Do ??
    BCC NEGATIVE_SET ; Set, goto.
    LDX #$00 ; Load ??
NEGATIVE_SET: ; 1F:1655, 0x03F655
    TXA ; Val to A.
    JSR SETTLE_AND_TABLE_IN_A ; Do ??
    CLC ; Prep add.
    LDA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY[8] ; Load ??
    ADC #$08 ; Add with.
    STA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY[8] ; Store result.
DATA_INDEXED_0x00: ; 1F:1660, 0x03F660
    CLC ; Prep add.
    LDA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY+1 ; Load ??
    ADC #$10 ; Add with.
    STA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY+1 ; Store result.
    CLC ; Prep add.
    LDA ALT_STUFF_COUNT? ; Load ??
    ADC #$20 ; Add with.
    STA ALT_STUFF_COUNT? ; Store to.
    CMP #$60 ; If _ #$60
    BNE VAL_NE_0x60 ; !=, goto, loop.
    RTS ; Leave.
ROUTINE_OBJ_HANDLE_UNK_A: ; 1F:1673, 0x03F673
    TYA ; Save Y
    PHA
    LDA STREAM_PTRS_ARR_UNK[48],Y ; Move from Y index to MISC.
    STA BCD/MODULO/DIGITS_USE_A
    LDA STREAM_PTRS_ARR_UNK+1,Y
    STA BCD/MODULO/DIGITS_USE_B
    LDA STREAM_INDEXES_ARR_UNK+3,Y ; Move to mod ptr?
    STA SAVE_GAME_MOD_PAGE_PTR[2]
    LDA STREAM_INDEXES_ARR_UNK+4,Y
    STA SAVE_GAME_MOD_PAGE_PTR+1
    LDY #$03 ; Stream index.
    LDA [BCD/MODULO/DIGITS_USE_A],Y ; Load from stream.
    STA BCD/MODULO/DIGITS_USE_C
    INY ; Stream++
    LDA [BCD/MODULO/DIGITS_USE_A],Y ; Load from stream.
    AND #$03 ; Keep lower bits.
    STA BCD/MODULO/DIGITS_USE_D ; Stopre to ??
    LSR BCD/MODULO/DIGITS_USE_D ; Shift it into.
    ROR BCD/MODULO/DIGITS_USE_C
    LSR BCD/MODULO/DIGITS_USE_D ; 2x
    ROR BCD/MODULO/DIGITS_USE_C
    PLA ; Restore Y.
    TAY
    SEC ; Prep sub.
    LDA SAVE_GAME_MOD_PAGE_PTR[2] ; Load ??
    SBC BCD/MODULO/DIGITS_USE_C ; Sub with created.
    LDA SAVE_GAME_MOD_PAGE_PTR+1 ; Load other.
    SBC BCD/MODULO/DIGITS_USE_D ; Sub with. other.
    RTS ; Leave.
SETTLE_AND_TABLE_IN_A: ; 1F:16AA, 0x03F6AA
    PHA ; Save A.
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle.
    PLA ; Restore.
    JSR SWITCH_TABLE_PAST_JSR_INDIRECT ; Do routine passed in A.
    LOW(IN-CODE_PTR_TABLE_A) ; Set flag ??
    HIGH(IN-CODE_PTR_TABLE_A)
    LOW(IN-CODE_PTR_TABLE_B) ; Seeded obj store ??
    HIGH(IN-CODE_PTR_TABLE_B)
    LOW(IN-CODE_PTR_TABLE_C) ; Obj status for all.
    HIGH(IN-CODE_PTR_TABLE_C)
    LOW(IN-CODE_PTR_TABLE_D) ; State and ptr restore.
    HIGH(IN-CODE_PTR_TABLE_D)
IN-CODE_PTR_TABLE_A: ; 1F:16BA, 0x03F6BA
    LDA #$01
    STA NMI_FLAG_EXECUTE_UPDATE_BUF_AND_MORE_TODO ; Set flag ??
    RTS
IN-CODE_PTR_TABLE_B: ; 1F:16BF, 0x03F6BF
    LDA #$00 ; Seed ??
    LDX #$0C
    LDY #$97
    JMP OBJECT_STORE_UNK ; Store to ??
IN-CODE_PTR_TABLE_C: ; 1F:16C8, 0x03F6C8
    LDX RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY[8] ; Index from.
    LDA OBJ?_BYTE_0x0_STATUS?,X ; Obj? Save.
    PHA
    LDA #$03 ; To obj status.
    LDX #$0C ; Ptr.
    LDY #$97
    JSR OBJECT_STORE_UNK ; Do.
    PLA ; Pull old obj.
    CMP #$03 ; If was _ #$03
    BEQ RTS ; ==, leave.
    LDX #$04 ; Alt index.
INDEX_NONZERO: ; 1F:16DE, 0x03F6DE
    TXA ; Obj save on stack.
    PHA
    LDA #$00 ; Obj set state.
    JSR OBJ_SET_AND_SETTLE_RETURN ; Mod and settle.
    LDA #$03 ; Obj set state.
    JSR OBJ_SET_AND_SETTLE_RETURN ; Mod and settle.
    PLA ; Pull value.
    TAX ; Restore X object.
    DEX ; Obj--
    BNE INDEX_NONZERO ; != 0, loop.
RTS: ; 1F:16EF, 0x03F6EF
    RTS ; Leave.
IN-CODE_PTR_TABLE_D: ; 1F:16F0, 0x03F6F0
    LDA #$03 ; Seed state.
    LDX #$10
    LDY #$97 ; Seed ptr.
    JMP OBJECT_STORE_UNK
OBJECT_STORE_UNK: ; 1F:16F9, 0x03F6F9
    STX BCD/MODULO/DIGITS_USE_A ; X and Y to. Will go to obj.
    STY BCD/MODULO/DIGITS_USE_B
    LDX RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY[8] ; Load index.
    STA OBJ?_BYTE_0x0_STATUS?,X ; To A passed.
    LDA #$08 ; Obj ??
    STA OBJ?_BYTE_0x1_UNK,X
    LDA #$70 ; Obj ??
    STA OBJ?_BYTE_0x2_UNK,X
    LDA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY+1 ; Move ?? to obj.
    STA OBJ?_BYTE_0x3_UNK,X
    LDA #$00 ; Clear ??
    STA OBJ?_BYTE_0x4_UNK,X ; Clear OBJs.
    STA OBJ?_BYTE_0x5_BYTE,X
    LDA BCD/MODULO/DIGITS_USE_A ; Move passed PTR to.
    STA OBJ?_PTR?[2],X
    LDA BCD/MODULO/DIGITS_USE_B
    STA OBJ?_PTR?+1,X
    RTS ; Leave.
OBJ_SET_AND_SETTLE_RETURN: ; 1F:1724, 0x03F724
    LDX RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY[8] ; Load index.
    STA OBJ?_BYTE_0x0_STATUS?,X ; Store passed as status.
    LDA #$01
    STA NMI_FLAG_EXECUTE_UPDATE_BUF_AND_MORE_TODO ; Set flag.
    LDX #$08
    JMP ENGINE_WAIT_X_SETTLES ; Wait and leave abuse rts.
ENGINE_PALETTE_SIZE_UPDATE_FPTR_XY: ; 1F:1732, 0x03F732
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle.
    STX BCD/MODULO/DIGITS_USE_A ; X and Y to FPTR.
    STY BCD/MODULO/DIGITS_USE_B
    LDY #$1F ; Index.
VAL_POSITIVE: ; 1F:173B, 0x03F73B
    LDA [BCD/MODULO/DIGITS_USE_A],Y ; Load from stream.
    STA NMI_PPU_CMD_PACKETS_BUF[69],Y ; To.
    DEY ; Stream/index--
    BPL VAL_POSITIVE ; Positive, do more.
    LDA #$80
    STA NMI_FLAG_EXECUTE_UPDATE_BUF_AND_MORE_TODO ; Set ??
    LDA #$00
    STA NMI_PPU_CMD_PACKETS_INDEX ; Clear ??
    RTS ; Leave.
LIB_SETUP_RAM_JMP_ABS: ; 1F:174C, 0x03F74C
    LDA #$6A ; Set addr for JMP, 1F:176A.
    STA RAM_CODE_UNK+1
    LDA #$F7
    STA RAM_CODE_UNK+2
    LDA #$4C
    STA RAM_CODE_UNK[3] ; Set JMP ABS.
    RTS ; Leave.
RAM_JMP_DISABLE: ; 1F:1759, 0x03F759
    LDA #$00
    STA RAM_CODE_UNK[3] ; Clear JMP opcode.
    JMP ENGINE_NMI_0x01_SET/WAIT ; Wait and leave.
SET_FLAG_OFFSCREEN: ; 1F:1760, 0x03F760
    LDA #$01
    STA FLAG_SPRITE_OFF_SCREEN_UNK ; Set flag.
    RTS ; Leave.
CLEAR_FLAG_OFFSCREEN: ; 1F:1765, 0x03F765
    LDA #$00
    STA FLAG_SPRITE_OFF_SCREEN_UNK ; Clear flag.
    RTS ; Leave.
RAM_JMP_RTN: ; 1F:176A, 0x03F76A
    LDA FLAG_SPRITE_OFF_SCREEN_UNK ; Load ??
    BEQ RTS ; == 0, goto.
    JSR SPRITE_OFF_SCREEN_THINGY ; Do sprity thing.
RTS: ; 1F:1771, 0x03F771
    RTS ; Leave.
SPRITE_OFF_SCREEN_THINGY: ; 1F:1772, 0x03F772
    LDA R_**:$0059 ; Load ??
    BEQ RTS ; == 0, leave.
    BIT NMI_FLAG_OBJECT_PROCESSING? ; Test.
    BVS RTS ; 0x40 set, leave.
    LDX #$00 ; Clear val.
    LDA CONTROL_ACCUMULATED?[2] ; Load CTRL.
    STX CONTROL_ACCUMULATED?[2] ; Clear buttons.
    AND #$40 ; Test B.
    BEQ RTS ; Not pressed, leave.
    TXA ; Clear A.
    STA R_**:$0059 ; Clear ??
    STA R_**:$03E0 ; Clear ??
    LDA SPRITE_SLOT_Y_OFF_SCREEN_UNK ; Load ??
    ASL A ; << 2, *4.
    ASL A
    TAY ; To Y index.
    LDA #$F0 ; Set Xpos.
    STA SPRITE_PAGE[256],Y ; Set Ypos off screen 4x.
    STA SPRITE_PAGE+4,Y
    STA SPRITE_PAGE+8,Y
    STA SPRITE_PAGE+12,Y
RTS: ; 1F:179E, 0x03F79E
    RTS ; Leave.
VECTOR_NMI: ; 1F:179F, 0x03F79F
    BIT PPU_STATUS ; Reset status.
    BIT ENGINE_NMI_CONFIG_FLAGS_DIS:0x80 ; Test flag.
    BPL POSITIVE ; Positive, run NMI.
    RTI ; Leave, disabled.
POSITIVE: ; 1F:17A7, 0x03F7A7
    PHA ; Save X, Y, A.
    TXA
    PHA
    TYA
    PHA
    LDX #$00 ; OAM ADDR reset.
    LDA #$02 ; $0200 for sprites.
    STX PPU_OAM_ADDR ; DMA sprites.
    STA OAM_DMA
    LDY NMI_PPU_CMD_PACKETS_INDEX ; Load index.
    LDA NMI_FLAG_EXECUTE_HOLD_MULTIPART/BOTTOM? ; Load flag.
    BEQ EXECUTE_FLAG_B ; Clear, execute on main flag.
    LDA NMI_FLAG_EXECUTE_UPDATE_BUF_AND_MORE_TODO ; Load other.
    BNE PROCESS_UPD8_BUF ; Set, do.
    BEQ EXIT_CLEAN ; == 0, skip upload.
EXECUTE_FLAG_B: ; 1F:17C2, 0x03F7C2
    LDA NMI_FLAG_EXECUTE_UPDATE_BUF_AND_MORE_TODO ; Load flag.
    BEQ EXIT_CLEAN ; == 0, both flags clear, skip.
    AND #$7F ; Keep lower bits.
    STA NMI_FLAG_EXECUTE_HOLD_MULTIPART/BOTTOM? ; Store lower to A. Clear OR set.
PROCESS_UPD8_BUF: ; 1F:17CA, 0x03F7CA
    LDA NMI_PPU_CMD_PACKETS_BUF[69],Y ; Load from buf.
    BEQ EXIT_CLEAR_EXECUTION ; == 0, exit clearing.
    BMI EXIT_FLAGGED_BUF ; Negative, flagged, do exit routine.
    ASL A ; << 1, *2. Run handler for positive value.
    TAX ; To X index.
    LDA UPDATE_BUF_HANDLERS_H,X ; Move addr to stack.
    PHA
    LDA UPDATE_BUF_HANDLERS_L,X
    PHA
    RTS ; Run it.
EXIT_FLAGGED_BUF: ; 1F:17DC, 0x03F7DC
    AND #$7F ; Keep lower.
    STA NMI_PPU_CMD_PACKETS_BUF[69],Y ; Store lower to buf as next data. Not flagged, 0x00 or command.
    BNE EXIT_CLEAN ; If bottom has value, don't clear exec.
EXIT_CLEAR_EXECUTION: ; 1F:17E3, 0x03F7E3
    STA NMI_FLAG_EXECUTE_UPDATE_BUF_AND_MORE_TODO ; Clear flag, updates ran.
EXIT_CLEAN: ; 1F:17E5, 0x03F7E5
    LDX NMI_LATCH_FLAG_UNK
    BEQ NO_LATCH ; == 0, goto.
    LDA #$FF
    STA MMC3_IRQ_LATCH ; Set latch.
    STA MMC3_IRQ_RELOAD
    LDA #$00 ; Clock mapper attempt 5x.
    STA PPU_ADDR
    STA PPU_ADDR
    LDA #$10
    STA PPU_ADDR
    STA PPU_ADDR
    LDA #$00
    STA PPU_ADDR
    STA PPU_ADDR
    LDA #$10
    STA PPU_ADDR
    STA PPU_ADDR
    LDA #$00
    STA PPU_ADDR
    STA PPU_ADDR
    STX MMC3_IRQ_LATCH ; Set latch from X.
    STX MMC3_IRQ_RELOAD ; Reload it.
    STX MMC3_IRQ_ENABLE ; Enable IRQ.
    STX ENGINE_IRQ_LATCH_CURRENT?
    STA ENGINE_IRQ_RTN_INDEX ; Clear.
    CLI ; Enable interrupts.
NO_LATCH: ; 1F:1827, 0x03F827
    LDA ENGINE_SCROLL_X ; Set scroll.
    LDX ENGINE_SCROLL_Y
    STA PPU_SCROLL
    STX PPU_SCROLL
    LDA ENGINE_PPU_CTRL_COPY ; Set CTRL/MASK.
    LDX ENGINE_PPU_MASK_COPY
    STA PPU_CTRL
    STX PPU_MASK
    STY NMI_PPU_CMD_PACKETS_INDEX ; Store index back.
    LDA #$80
    STA ENGINE_NMI_CONFIG_FLAGS_DIS:0x80 ; Set ??
    LDA MAPPER_INDEX_LAST_WRITTEN ; Save last written and PRG banks.
    PHA
    LDA ENGINE_MAPPER_BANK_VALS_COMMITTING+6
    PHA
    LDA ENGINE_MAPPER_BANK_VALS_COMMITTING+7
    PHA
    LDA NMI_GFX_COUNTER ; Load.
RTN_N: ; 1F:184C, 0x03F84C
    BEQ SKIP_GFX_MOD ; == 0, goto.
    LSR A ; >> 1, /2.
    AND #$03 ; Keep bottom bits.
    ORA #$44 ; Set 0100.01XX
    LDX #$02 ; GFX bank R2.
    JSR ENGINE_MAPPER_COMMIT_BANK_X_VAL_A ; Set GFX.
    LDX #$03 ; GFX bank R3.
    JSR ENGINE_MAPPER_COMMIT_BANK_X_VAL_A
    DEC NMI_GFX_COUNTER ; --
SKIP_GFX_MOD: ; 1F:185F, 0x03F85F
    JSR ENGINE_SWAP_TO_SOUND_ENGINE_HELPER ; Set sound banks.
    JSR JMP_SOUND_ENTRY_FORWARD ; Forward engine.
    LDA NMI_FLAG_OBJECT_PROCESSING? ; Load ??
    BMI NMI_RESTORE_ENGINE_STATE/READ_INPUT ; Negative, goto.
    LDA NMI_FLAG_ACTION? ; Load.
    AND #$3F ; Keep 0011.1111
    STA BMI_FLAG_SET_DIFF_MODDED_UNK ; Store to.
    LDA NMI_FLAG_EXECUTE_HOLD_MULTIPART/BOTTOM? ; Load.
    BNE NONZERO ; != 0, goto.
    JSR NMI_SPRITE_SWAP_UNK ; Swap sprites.
    JMP NMI_RESTORE_ENGINE_STATE/READ_INPUT ; Goto.
NONZERO: ; 1F:1879, 0x03F879
    CLC ; Sub -1
    SBC BMI_FLAG_SET_DIFF_MODDED_UNK ; Sub with, extra.
    BCS SUB_NO_UNDERFLOW ; No underflow, goto.
    LDX NMI_FLAG_EXECUTE_HOLD_MULTIPART/BOTTOM? ; Load ??
    DEX ; Index--
    STX BMI_FLAG_SET_DIFF_MODDED_UNK ; Store modded.
    LDA #$00 ; Seed clear.
SUB_NO_UNDERFLOW: ; 1F:1885, 0x03F885
    STA NMI_FLAG_EXECUTE_HOLD_MULTIPART/BOTTOM? ; Store flag.
    JSR SUB_TODOOOOOOOOOOOOO ; Do, scrolly?
NMI_RESTORE_ENGINE_STATE/READ_INPUT: ; 1F:188A, 0x03F88A
    PLA ; Restore R7 val.
    LDX #$07 ; R7.
    JSR ENGINE_MAPPER_COMMIT_BANK_X_VAL_A ; Bank it in.
    PLA ; Restore R6 val.
    LDX #$06
    JSR ENGINE_MAPPER_COMMIT_BANK_X_VAL_A
    PLA ; Restore index.
    STA MAPPER_INDEX_LAST_WRITTEN
    ORA ENGINE_MAPPER_CONFIG_STATUS_NO_BANK ; Set other bits.
    STA MMC3_BANK_CFG ; Set CFG.
    JSR READ_CONTROLLERS ; Read controllers.
    LDA CTRL_NEWLY_PRESSED[2] ; Load P1.
    ORA CONTROL_ACCUMULATED?[2] ; Or with.
    STA CONTROL_ACCUMULATED?[2] ; Store combined.
    LDA CTRL_NEWLY_PRESSED+1 ; Load P2.
    ORA CONTROL_ACCUMULATED?+1 ; Or with.
    STA CONTROL_ACCUMULATED?+1 ; Store combined.
    JSR SUB_CTRL_TODO ; Do ??
    LDA RAM_CODE_UNK[3] ; Load.
    BEQ VAL_EQ_0x00 ; == 0, goto.
    JSR RAM_CODE_UNK[3] ; Do sub.
VAL_EQ_0x00: ; 1F:18B7, 0x03F8B7
    LDA #$00
    STA ENGINE_NMI_CONFIG_FLAGS_DIS:0x80 ; Clear flags.
    PLA ; Leave NMI.
    TAY
    PLA
    TAX
    PLA
    RTI ; Leave NMI.
UPDATE_BUF_HANDLERS_L: ; 1F:18C1, 0x03F8C1
    LOW(PROCESS_UPD8_BUF) ; 0x00
UPDATE_BUF_HANDLERS_H: ; 1F:18C2, 0x03F8C2
    HIGH(PROCESS_UPD8_BUF) ; Check routine for ending/continue/more.
    LOW(RTN_0x01_SKIP_AND_RELAUNCH) ; 0x01
    HIGH(RTN_0x01_SKIP_AND_RELAUNCH) ; Index++
    LOW(RTN_0x02_DELTA_BUF_INDEX_DELTA) ; 0x02
    HIGH(RTN_0x02_DELTA_BUF_INDEX_DELTA) ; Index delta from buf.
    LOW(RTN_0x03_RELOAD_INDEX_DIRECT) ; 0x03
    HIGH(RTN_0x03_RELOAD_INDEX_DIRECT) ; Index val from stream.
    LOW(RTN_0x04_UPDATE_PALETTE) ; 0x04
    HIGH(RTN_0x04_UPDATE_PALETTE) ; Palette update.
    LOW(RTN_0x05_UNIQUE_UPLOAD_INC_ONE) ; 0x05
    HIGH(RTN_0x05_UNIQUE_UPLOAD_INC_ONE) ; Data upload VRAM mode +1
    LOW(RTN_0x06_UNIQUE_UPLOAD_INC_THIRTY_TWO) ; 0x06
    HIGH(RTN_0x06_UNIQUE_UPLOAD_INC_THIRTY_TWO) ; Data upload. VRAM mode +32
    LOW(RTN_0x07_BULK_UPLOAD_SINGLE_UPDATES) ; 0x07
    HIGH(RTN_0x07_BULK_UPLOAD_SINGLE_UPDATES) ; Bulk upload byte with addr.
    LOW(RTN_0x08_BULK_UPLOAD_SINGLE_TILE_COUNT) ; 0x08
    HIGH(RTN_0x08_BULK_UPLOAD_SINGLE_TILE_COUNT) ; Move a single byte count times.
    LOW(RTN_0x09_READ_PPU_INTO_UPDATE_BUFFER) ; 0x09
    HIGH(RTN_0x09_READ_PPU_INTO_UPDATE_BUFFER) ; Reads the PPU memory and put it to the update buffer in-place.
    LOW(RTN_0x0A_READ_PPU_INTO_UPDATE_STACK_AREA) ; 0x0A
    HIGH(RTN_0x0A_READ_PPU_INTO_UPDATE_STACK_AREA) ; Reads the PPU memory and put it in a stack-page buffer at $0110.
RTN_0x01_SKIP_AND_RELAUNCH: ; 1F:18D7, 0x03F8D7
    INY ; Mod index.
    JMP PROCESS_UPD8_BUF ; Relaunch.
RTN_0x02_DELTA_BUF_INDEX_DELTA: ; 1F:18DB, 0x03F8DB
    INY ; To next index.
    TYA ; Index pos to A.
    SEC ; Prep with carry.
    ADC NMI_PPU_CMD_PACKETS_BUF[69],Y ; Mod with value and extra.
    TAY ; Back to index.
    JMP PROCESS_UPD8_BUF ; Re-launch with new index.
RTN_0x03_RELOAD_INDEX_DIRECT: ; 1F:18E5, 0x03F8E5
    INY ; Index++
    LDA NMI_PPU_CMD_PACKETS_BUF[69],Y ; Load from buffer.
    TAY ; To new index.
    JMP PROCESS_UPD8_BUF ; Goto.
RTN_0x04_UPDATE_PALETTE: ; 1F:18ED, 0x03F8ED
    LDA #$3F ; Seed PPU 0x3F00
    LDX #$00
    STA PPU_ADDR ; Set addr.
    STX PPU_ADDR
PALETTE_NOT_COMPLETED: ; 1F:18F7, 0x03F8F7
    LDA ENGINE_COMMIT_PALETTE[32],X ; Load palette
    STA PPU_DATA ; Store to data.
    INX ; Entry++
    CPX #$20 ; If _ #$20
    BNE PALETTE_NOT_COMPLETED ; !=, do more.
    LDA #$3F ; Reseed palette.
    LDX #$00
    STA PPU_ADDR ; Store addr.
    STX PPU_ADDR
    STX PPU_ADDR ; Store 0x0000
    STX PPU_ADDR
    INY ; Index++
    JMP PROCESS_UPD8_BUF ; Relaunch.
RTN_0x05_UNIQUE_UPLOAD_INC_ONE: ; 1F:1916, 0x03F916
    JSR NMI_PACKET_UNIQUE_DATA_UPLOADER ; Upload the packet.
    LDA NMI_PPU_CMD_PACKETS_BUF[69],Y ; Load from buf.
    CMP #$05 ; If _ #$05
    BEQ RTN_0x05_UNIQUE_UPLOAD_INC_ONE ; Relaunch quick.
    JMP PROCESS_UPD8_BUF ; Relaunch other pakcet type.
RTN_0x06_UNIQUE_UPLOAD_INC_THIRTY_TWO: ; 1F:1923, 0x03F923
    LDA ENGINE_PPU_CTRL_COPY ; Load CTRL.
    ORA #$04 ; VRAM +32
    STA PPU_CTRL ; Set CTRL with option.
PACKET_RELAUNCH: ; 1F:192A, 0x03F92A
    JSR NMI_PACKET_UNIQUE_DATA_UPLOADER ; Upload the packet.
    LDA NMI_PPU_CMD_PACKETS_BUF[69],Y ; Load next packet.
    CMP #$06 ; Same type?
    BEQ PACKET_RELAUNCH ; ==, yes, reloop.
    LDA ENGINE_PPU_CTRL_COPY ; Set CTRL +1
    STA PPU_CTRL
    JMP PROCESS_UPD8_BUF ; Relaunch.
RTN_0x07_BULK_UPLOAD_SINGLE_UPDATES: ; 1F:193C, 0x03F93C
    INY ; Get data.
    LDX NMI_PPU_CMD_PACKETS_BUF[69],Y ; Load count of single byte updates.
    INY
LOOP_UPDATES: ; 1F:1941, 0x03F941
    LDA NMI_PPU_CMD_PACKETS_BUF[69],Y ; Move addr from buf.
    STA PPU_ADDR
    INY
    LDA NMI_PPU_CMD_PACKETS_BUF[69],Y
    STA PPU_ADDR
    INY
    LDA NMI_PPU_CMD_PACKETS_BUF[69],Y ; Move data from buf.
    STA PPU_DATA
    INY
    DEX ; Count--
    BNE LOOP_UPDATES ; !=, goto.
    JMP PROCESS_UPD8_BUF ; Relaunch routine.
RTN_0x08_BULK_UPLOAD_SINGLE_TILE_COUNT: ; 1F:195C, 0x03F95C
    INY ; Buf++
    LDX NMI_PPU_CMD_PACKETS_BUF[69],Y ; Load count.
    INY ; Buf++
    LDA NMI_PPU_CMD_PACKETS_BUF[69],Y ; Write addr.
    STA PPU_ADDR
    INY ; Buf++
    LDA NMI_PPU_CMD_PACKETS_BUF[69],Y
    STA PPU_ADDR
    INY ; Buf++
    LDA NMI_PPU_CMD_PACKETS_BUF[69],Y ; Load data.
    INY ; Buf++
COUNT_MOVE_SINGLE: ; 1F:1973, 0x03F973
    STA PPU_DATA ; Store data.
    DEX ; Count--
    BNE COUNT_MOVE_SINGLE ; != 0, goto.
    JMP PROCESS_UPD8_BUF ; Relaunch.
RTN_0x09_READ_PPU_INTO_UPDATE_BUFFER: ; 1F:197C, 0x03F97C
    INY ; Buf++
    LDX NMI_PPU_CMD_PACKETS_BUF[69],Y ; Count todo.
    INY ; Buf++
    LDA NMI_PPU_CMD_PACKETS_BUF[69],Y ; Move addr.
    STA PPU_ADDR
    INY ; Buf++
    LDA NMI_PPU_CMD_PACKETS_BUF[69],Y
    STA PPU_ADDR
    INY ; Buf++
    LDA PPU_DATA ; Read buffer delay accounting.
READ_TO_UPDATE_BUF: ; 1F:1992, 0x03F992
    LDA PPU_DATA ; Load from PPU.
    STA NMI_PPU_CMD_PACKETS_BUF[69],Y ; To buf in-pos.
    INY ; Buf++
    DEX ; Count--
    BNE READ_TO_UPDATE_BUF ; != 0, loop more.
    JMP PROCESS_UPD8_BUF ; Relaunch.
RTN_0x0A_READ_PPU_INTO_UPDATE_STACK_AREA: ; 1F:199F, 0x03F99F
    LDA MAPPER_INDEX_LAST_WRITTEN ; Save mapper setup.
    PHA
    LDA ENGINE_MAPPER_BANK_VALS_COMMITTING+4 ; R4
    PHA
    LDA ENGINE_MAPPER_BANK_VALS_COMMITTING+5 ; R5
    PHA
    INY ; Buf++
    LDA NMI_PPU_CMD_PACKETS_BUF[69],Y ; Load from buf.
    LDX #$04 ; Set GFX R4.
    JSR ENGINE_MAPPER_COMMIT_BANK_X_VAL_A ; To buf val loaded.
    CLC ; Prep add.
    ADC #$01 ; Add 0x1 for the pair.
    LDX #$05 ; INX plox.
    JSR ENGINE_MAPPER_COMMIT_BANK_X_VAL_A ; Set R5 to pair.
    INY ; Stream++
    LDA NMI_PPU_CMD_PACKETS_BUF[69],Y ; Move addr from buf.
    STA PPU_ADDR
    INY
    LDA NMI_PPU_CMD_PACKETS_BUF[69],Y
    STA PPU_ADDR
    INY
    LDA PPU_DATA ; Buffer read issue.
    LDX #$00 ; SP Buf index.
MOVE_0x40_LOOP: ; 1F:19CD, 0x03F9CD
    LDA PPU_DATA ; Load from the PPU.
    STA NMI_PPU_READ_BUF_UNK[64],X ; Store to alt buf.
    INX ; Buf++
    CPX #$40 ; If _ #$40
    BCC MOVE_0x40_LOOP ; <, goto.
    PLA ; Restore the mapper gfx banks.
    LDX #$05
    JSR ENGINE_MAPPER_COMMIT_BANK_X_VAL_A
    PLA
    LDX #$04
    JSR ENGINE_MAPPER_COMMIT_BANK_X_VAL_A
    PLA
    STA MAPPER_INDEX_LAST_WRITTEN
    ORA ENGINE_MAPPER_CONFIG_STATUS_NO_BANK ; Set other CFG bits.
    STA MMC3_BANK_CFG ; Set config to mapper.
    JMP PROCESS_UPD8_BUF ; Relaunch buffer.
NMI_PACKET_UNIQUE_DATA_UPLOADER: ; 1F:19EF, 0x03F9EF
    INY ; Buf++
    LDX NMI_PPU_CMD_PACKETS_BUF[69],Y ; X from buf.
    STX UPDATE_PACKET_COUNT/GROUPS ; To, lower nibble count, upper nibble 0x8 groups.
    INY ; Buf++
    LDA NMI_PPU_CMD_PACKETS_BUF[69],Y ; PPU Addr
    STA PPU_ADDR
    INY ; Buf++
    LDA NMI_PPU_CMD_PACKETS_BUF[69],Y
    STA PPU_ADDR
    INY ; Buf++
    LSR UPDATE_PACKET_COUNT/GROUPS ; Test bit 0x01, +0x1 Bytes
    BCC TEST_0x2_FLAG_0x2_DBYTES ; Skip 0x1 DBytes.
    LDA NMI_PPU_CMD_PACKETS_BUF[69],Y ; Move 1x Byte.
    STA PPU_DATA
    INY
TEST_0x2_FLAG_0x2_DBYTES: ; 1F:1A0F, 0x03FA0F
    LSR UPDATE_PACKET_COUNT/GROUPS ; Test bit 0x02, +0x2 Bytes
    BCC TEST_0x4_FLAG_0x4_DBYTES ; Skip 0x2 DBytes.
    LDA NMI_PPU_CMD_PACKETS_BUF[69],Y ; Move 2x DBytes.
    STA PPU_DATA
    INY
    LDA NMI_PPU_CMD_PACKETS_BUF[69],Y
    STA PPU_DATA
    INY
TEST_0x4_FLAG_0x4_DBYTES: ; 1F:1A21, 0x03FA21
    LSR UPDATE_PACKET_COUNT/GROUPS ; Test 0x4, +0x4 Bytes
    BCC TEST_CLEAR ; Skip 0x4 DBytes.
    LDA NMI_PPU_CMD_PACKETS_BUF[69],Y ; Move 4x DBytes.
    STA PPU_DATA
    INY
    LDA NMI_PPU_CMD_PACKETS_BUF[69],Y
    STA PPU_DATA
    INY
    LDA NMI_PPU_CMD_PACKETS_BUF[69],Y
    STA PPU_DATA
    INY
    LDA NMI_PPU_CMD_PACKETS_BUF[69],Y
    STA PPU_DATA
    INY
TEST_CLEAR: ; 1F:1A41, 0x03FA41
    LDX UPDATE_PACKET_COUNT/GROUPS ; X count from upper nibble.
    BEQ RTS ; Tested top, clear, done.
X_LOOPS_NONZERO: ; 1F:1A45, 0x03FA45
    LDA NMI_PPU_CMD_PACKETS_BUF[69],Y ; Move 0x8 DBytes.
    STA PPU_DATA
    INY
    LDA NMI_PPU_CMD_PACKETS_BUF[69],Y ; 2x
    STA PPU_DATA
    INY
    LDA NMI_PPU_CMD_PACKETS_BUF[69],Y ; 3x
    STA PPU_DATA
    INY
    LDA NMI_PPU_CMD_PACKETS_BUF[69],Y ; 4x
    STA PPU_DATA
    INY
    LDA NMI_PPU_CMD_PACKETS_BUF[69],Y ; 5x
    STA PPU_DATA
    INY
    LDA NMI_PPU_CMD_PACKETS_BUF[69],Y ; 6x
    STA PPU_DATA
    INY
    LDA NMI_PPU_CMD_PACKETS_BUF[69],Y ; 7x
    STA PPU_DATA
    INY
    LDA NMI_PPU_CMD_PACKETS_BUF[69],Y ; 8x
    STA PPU_DATA
    INY
    DEX ; X--
    BNE X_LOOPS_NONZERO
RTS: ; 1F:1A80, 0x03FA80
    RTS
SUB_TODOOOOOOOOOOOOO: ; 1F:1A81, 0x03FA81
    LDA #$15 ; Set R6 to 0x15.
    LDX #$06
    JSR ENGINE_MAPPER_COMMIT_BANK_X_VAL_A
    LDA #$00
    STA R_**:$00CE ; Clear ??
    STA R_**:$00CF
    LDX BMI_FLAG_SET_DIFF_MODDED_UNK ; Load.
    BIT NMI_FLAG_ACTION?
    BVC LOOP_ADD_PAIR_UNK ; Clear, goto.
    LDY #$00 ; Stream index.
COUNT_POSITIVE: ; 1F:1A96, 0x03FA96
    CLC ; Prep add.
    LDA [NMI_FP_UNK[2]],Y ; Load from stream.
    ADC R_**:$00CE ; Add with.
    STA R_**:$00CE ; Store result.
    INY ; Stream++
    CLC ; Prep add.
    LDA [NMI_FP_UNK[2]],Y ; Load from stream.
    ADC R_**:$00CF ; Add to.
    STA R_**:$00CF ; Store result.
    INY ; Stream++
    DEX ; Count--
    BPL COUNT_POSITIVE ; Positive, goto.
    CLC ; Prep add.
    TYA ; Stream to A.
    ADC NMI_FP_UNK[2] ; Add with.
    STA NMI_FP_UNK[2] ; Store result.
    LDA #$00 ; Carry seed.
    ADC NMI_FP_UNK+1 ; Add carry.
    STA NMI_FP_UNK+1 ; Store result.
    JMP ALT_ENTRY ; Goto.
LOOP_ADD_PAIR_UNK: ; 1F:1AB8, 0x03FAB8
    CLC ; Prep add.
    LDA NMI_FP_UNK[2] ; Load ??
    ADC R_**:$00CE ; Add with.
    STA R_**:$00CE ; Store result.
    CLC ; Prep add.
    LDA NMI_FP_UNK+1 ; Load ??
    ADC R_**:$00CF ; Add with.
    STA R_**:$00CF ; Sture result.
    DEX ; X--
    BPL LOOP_ADD_PAIR_UNK ; Positive, goto.
ALT_ENTRY: ; 1F:1AC9, 0x03FAC9
    CLC ; Prep add.
    LDA R_**:$00CE ; Load ??
    BMI VAL_NEGATIVE ; Negative, goto.
    ADC ENGINE_SCROLL_X ; Add with.
    STA ENGINE_SCROLL_X ; Store to.
    BCC ADD_NO_CARRY ; No carry, goto.
    BCS ADD_CARRY ; Cary, goto.
VAL_NEGATIVE: ; 1F:1AD6, 0x03FAD6
    ADC ENGINE_SCROLL_X ; Add again.
    STA ENGINE_SCROLL_X ; Store result.
    BCS ADD_NO_CARRY ; CS, goto.
ADD_CARRY: ; 1F:1ADC, 0x03FADC
    LDA ENGINE_PPU_CTRL_COPY ; Invert nametable base X.
    EOR #$01 ; Invert.
    STA ENGINE_PPU_CTRL_COPY ; Store result.
ADD_NO_CARRY: ; 1F:1AE2, 0x03FAE2
    CLC ; Prep add.
    LDA R_**:$00CF ; Load ??
    BMI VAL_NEGATIVE ; Negative, goto.
    ADC #$10 ; Add with ??
    ADC ENGINE_SCROLL_Y ; Add with.
    BCC ADD_NO_CARRY ; No carry, goto.
    BCS ADD_CARRY ; Carry, goto.
VAL_NEGATIVE: ; 1F:1AEF, 0x03FAEF
    ADC ENGINE_SCROLL_Y ; Add with.
    BCS ADD_CARRY ; Carry, goto.
ADD_NO_CARRY: ; 1F:1AF3, 0x03FAF3
    ADC #$F0 ; Add with.
ADD_CARRY: ; 1F:1AF5, 0x03FAF5
    STA ENGINE_SCROLL_Y ; Store to.
    LDA NMI_FLAG_OBJECT_PROCESSING? ; Load ??
    AND #$3F ; Keep lower.
    EOR #$20 ; Invert.
    STA NMI_FLAG_OBJECT_PROCESSING? ; Store back.
    LDA #$00
    STA CC_INDEX_UNK ; Clear ??
    STA SPRITE_INDEX_SWAP ; Clear.
    LDA #$08
    STA R_**:$00CD ; Set ??
    LDX #$10 ; Index ??
ITERATION_START: ; 1F:1B0B, 0x03FB0B
    LDY CC_INDEX_UNK ; Index from.
    LDA OBJ?_BYTE_0x0_STATUS?,Y ; Load from.
    AND #$3F ; Keep lower.
    BNE OBJECT_BITS_SET ; Set, goto.
    JMP OBJECT_ITERATE ; Goto.
OBJECT_BITS_SET: ; 1F:1B17, 0x03FB17
    STA CTRL_BIT_0x0 ; Store val.
    STX OBJ_INDEX_TEMP? ; Store obj index.
    LDA OBJ?_BYTE_0x1_UNK,Y ; Load pair.
    AND #$C0 ; Keep bits.
    STA CTRL_BIT_0x1 ; Store to.
    TXA ; Index to A.
    LSR A ; >> 2, /4.
    LSR A
    ORA CTRL_BIT_0x1 ; Set with others.
    STA OBJ?_BYTE_0x1_UNK,Y ; Store to pair.
    SEC ; Prep sub.
    LDA #$00 ; Invert seed.
    SBC R_**:$00CE ; Invert with.
    STA R_**:$00C8 ; Store to.
    SEC ; Seed invert.
    LDA #$00
    SBC R_**:$00CF ; Sub with.
    STA R_**:$00CA ; Store result.
    LDX BMI_FLAG_SET_DIFF_MODDED_UNK ; Load val.
    BIT CTRL_BIT_0x1 ; Test 0x40
    BVC BIT_0x40_SET ; Set, goto.
    LDA OBJ?_BYTE_0x4_UNK,Y ; Move obj to ZP.
    STA OBJ_FPTR_TODO[2]
    LDA OBJ?_BYTE_0x5_BYTE,Y ; 2x
    STA OBJ_FPTR_TODO+1
    LDY #$00 ; Index reset.
COUNT_POSITIVE: ; 1F:1B4A, 0x03FB4A
    CLC ; Prep add.
    LDA [OBJ_FPTR_TODO[2]],Y ; Load from file.
    ADC R_**:$00C8 ; Add with.
    STA R_**:$00C8 ; Store result.
    INY ; Index++
    CLC ; Prep add.
    LDA [OBJ_FPTR_TODO[2]],Y ; Load obj.
    ADC R_**:$00CA ; Add with.
    STA R_**:$00CA ; Store result.
    INY ; Stream++
    DEX ; Count--
    BPL COUNT_POSITIVE ; Positive, do more from file.
    CLC ; Prep add.
    TYA ; Stream to A.
    ADC OBJ_FPTR_TODO[2] ; Add with fptr.
    LDY CC_INDEX_UNK ; Index ??
    STA OBJ?_BYTE_0x4_UNK,Y ; Store val to index.
    LDA #$00 ; Seed ??
    ADC OBJ_FPTR_TODO+1 ; Carry add but dumb?
    STA OBJ?_BYTE_0x5_BYTE,Y ; Store result.
    JMP JMP_ENTRY_UNK ; Goto.
BIT_0x40_SET: ; 1F:1B70, 0x03FB70
    CLC ; Prep add.
    LDA OBJ?_BYTE_0x4_UNK,Y ; Load from obj.
    ADC R_**:$00C8 ; Add with.
    STA R_**:$00C8 ; Store to.
    CLC ; Prep add.
    LDA OBJ?_BYTE_0x5_BYTE,Y ; Load.
    ADC R_**:$00CA ; Add with.
    STA R_**:$00CA ; Store result.
    DEX ; Index--
    BPL BIT_0x40_SET ; Index positive, goto.
JMP_ENTRY_UNK: ; 1F:1B83, 0x03FB83
    LDX OBJ_INDEX_TEMP? ; Load index.
    CLC ; Prep add.
    LDA R_**:$00C8 ; Load val.
    BMI VAL_NEGATIVE ; Negative, goto.
    ADC OBJ?_BYTE_0x2_UNK,Y ; Add with.
    STA R_**:$00C8 ; Store to.
    STA OBJ?_BYTE_0x2_UNK,Y ; Store to obj.
    BCC ADD_CC ; CC, goto.
    BCS OBJ_UNK_INVERTED ; CS, goto.
VAL_NEGATIVE: ; 1F:1B96, 0x03FB96
    ADC OBJ?_BYTE_0x2_UNK,Y ; Add with.
    STA R_**:$00C8 ; Store to ??
    STA OBJ?_BYTE_0x2_UNK,Y ; Store to obj.
    BCS ADD_CC ; CS, goto.
OBJ_UNK_INVERTED: ; 1F:1BA0, 0x03FBA0
    LDA OBJ?_BYTE_0x0_STATUS?,Y ; Load obj.
    EOR #$80 ; Invert ??
    STA OBJ?_BYTE_0x0_STATUS?,Y ; Store inverted.
ADD_CC: ; 1F:1BA8, 0x03FBA8
    CLC ; Prep add.
    LDA R_**:$00CA ; Load ??
    BMI VAL_NEGATIVE ; Negative, goto.
    ADC OBJ?_BYTE_0x3_UNK,Y ; Add with.
    STA R_**:$00CA ; Store to.
    STA OBJ?_BYTE_0x3_UNK,Y ; Store to obj.
    BCC ADD_CC ; CC, goto.
    BCS ADD_CS ; CS, goto.
VAL_NEGATIVE: ; 1F:1BB9, 0x03FBB9
    ADC OBJ?_BYTE_0x3_UNK,Y ; Add with.
    STA R_**:$00CA ; Store to.
    STA OBJ?_BYTE_0x3_UNK,Y ; Store to obj.
    BCS ADD_CC ; CS, goto.
ADD_CS: ; 1F:1BC3, 0x03FBC3
    LDA OBJ?_BYTE_0x1_UNK,Y ; Move negative bit.
    EOR #$80
    STA OBJ?_BYTE_0x1_UNK,Y
ADD_CC: ; 1F:1BCB, 0x03FBCB
    LDA OBJ?_BYTE_0x0_STATUS?,Y ; Load from object.
    AND #$80 ; Keep top bit.
    STA R_**:$00C9 ; Store to.
    LDA OBJ?_BYTE_0x1_UNK,Y ; Move obj negative.
    AND #$80 ; Keep top bit.
    STA R_**:$00CB ; Store top set.
    LDA OBJ?_PTR?[2],Y ; Move from obj to ZP.
    STA R_**:$00C6
    LDA OBJ?_PTR?+1,Y ; Move.
    STA R_**:$00C7
    LDY #$00 ; Stream index.
    LDA [R_**:$00C6],Y ; Move stream pointer.
    STA OBJ_FPTR_TODO[2]
    INY ; Stream++
    LDA [R_**:$00C6],Y ; Move stream ptr H.
    STA OBJ_FPTR_TODO+1
    INY ; Stream++
    LDA [R_**:$00C6],Y ; Move stream to ??
    STA OBJ_INDEX_TEMP?
    INY
    LDA [R_**:$00C6],Y ; Move ??
    STA UPDATE_PACKET_COUNT/GROUPS
    LDY #$00 ; Stream reset.
VAL_NONZERO: ; 1F:1BFA, 0x03FBFA
    LDA [OBJ_FPTR_TODO[2]],Y ; Load stream.
    INY ; Index++
    CLC ; Prep 
    ADC R_**:$00C8 ; Add val.
    STA SPRITE_PAGE+3,X ; Store to sprite X pos.
    ROR A ; Rotate val.
    EOR R_**:$00C9 ; Invert.
    BMI VAL_NEGATIVE ; Negative.
    LDA [OBJ_FPTR_TODO[2]],Y ; Load from file.
    CLC ; Prep add.
    ADC R_**:$00CA ; Add with.
    STA SPRITE_PAGE[256],X ; Store to, sprite Y pos.
    ROR A ; Rotate.
    EOR R_**:$00CB ; Invert with.
    BMI VAL_NEGATIVE ; Negative, goto.
    CMP #$F0 ; If _ #$F0
    BCC VAL_LT_0xF0 ; <, goto.
    BCS VAL_NEGATIVE ; >=, goto.
VAL_NEGATIVE: ; 1F:1C1B, 0x03FC1B
    CMP #$F9 ; If _ #$F9
    BCS VAL_LT_0xF0 ; >=, goto.
VAL_NEGATIVE: ; 1F:1C1F, 0x03FC1F
    INY ; Index += 3
    INY
    INY
    JMP COUNT_DOWN ; Goto.
VAL_LT_0xF0: ; 1F:1C25, 0x03FC25
    INY ; Stream++
    LDA [OBJ_FPTR_TODO[2]],Y ; Load ??
    STA CTRL_BIT_0x1 ; Store to.
    LDA UPDATE_PACKET_COUNT/GROUPS ; Load ??
    LSR CTRL_BIT_0x1 ; Shift.
    BCC CARRY_CLEAR ; CC, goto.
    LSR A ; >> 2, /4.
    LSR A
CARRY_CLEAR: ; 1F:1C32, 0x03FC32
    LSR CTRL_BIT_0x1 ; >>
    BCC NO_NIBBLE_DOWN ; CC, goto.
    LSR A ; Shift nibble down.
    LSR A
    LSR A
    LSR A
NO_NIBBLE_DOWN: ; 1F:1C3A, 0x03FC3A
    AND #$03 ; Keep lower.
    ASL CTRL_BIT_0x1 ; <<
    ASL CTRL_BIT_0x1 ; <<
    ORA CTRL_BIT_0x1 ; Combine.
    STA SPRITE_PAGE+2,X ; Store to, sprite attrs.
    INY ; Index++
    AND #$10 ; Keep ??
    BEQ VAL_CLEAR
    LDA OBJ_INDEX_TEMP? ; Load ??
VAL_CLEAR: ; 1F:1C4C, 0x03FC4C
    ADC [OBJ_FPTR_TODO[2]],Y ; Add from file.
    STA SPRITE_PAGE+1,X ; Store to, tile.
    INY ; Stream++
    INX ; Sprite += 4
    INX
    INX
    INX
    BEQ SPRITES_EXPIRED ; == 0, goto.
COUNT_DOWN: ; 1F:1C58, 0x03FC58
    DEC CTRL_BIT_0x0 ; --
    BNE VAL_NONZERO
OBJECT_ITERATE: ; 1F:1C5C, 0x03FC5C
    CLC ; Prep add.
    LDA R_**:$00CD ; Load ??
    BMI VAL_NEGATIVE ; Negative, goto.
    ADC CC_INDEX_UNK ; Add with.
    STA CC_INDEX_UNK ; Store to.
    BEQ CLEAR_SPRITES_OFFSCREEN ; == 0, goto.
    CMP E3_TARGET_UNK ; If _ #$E3
    BEQ VAL_EQ_0xE3 ; ==, goto.
    JMP ITERATION_START ; Goto.
VAL_NEGATIVE: ; 1F:1C6E, 0x03FC6E
    ADC CC_INDEX_UNK ; Add with.
    STA CC_INDEX_UNK ; Store to.
    CMP E3_TARGET_UNK ; If _ #$E3
    BCC CLEAR_SPRITES_OFFSCREEN ; <, goto.
    JMP ITERATION_START ; Goto.
VAL_EQ_0xE3: ; 1F:1C79, 0x03FC79
    STX SPRITE_INDEX_SWAP ; X to.
    LDA NMI_FLAG_OBJECT_PROCESSING? ; Load ??
    AND #$20 ; Keep set.
    BNE BIT_SET ; Set, goto.
    LDA #$F8
    STA CC_INDEX_UNK ; Set ??
    STA R_**:$00CD ; ??
BIT_SET: ; 1F:1C87, 0x03FC87
    JMP ITERATION_START ; Reenter.
CLEAR_SPRITES_OFFSCREEN: ; 1F:1C8A, 0x03FC8A
    LDA #$F0 ; Offscreen.
SPRITES_NONZERO: ; 1F:1C8C, 0x03FC8C
    STA SPRITE_PAGE[256],X ; Store to Ypos.
    INX ; Slot++
    INX
    INX
    INX
    BNE SPRITES_NONZERO ; != 0, goto.
SPRITES_EXPIRED: ; 1F:1C95, 0x03FC95
    RTS ; Leave.
NMI_SPRITE_SWAP_UNK: ; 1F:1C96, 0x03FC96
    LDA NMI_FLAG_OBJECT_PROCESSING? ; Load.
    EOR #$40 ; Invert 0100.0000
    STA NMI_FLAG_OBJECT_PROCESSING? ; Store back.
    LDY #$FC ; Seed swap pos.
    LDX SPRITE_INDEX_SWAP ; Load index.
    BNE INDEX_NONZERO ; Nonzero, enter.
    RTS ; Leave.
SWAP_LT_OTHER: ; 1F:1CA3, 0x03FCA3
    LDA SPRITE_PAGE[256],X ; Y-X data swap.
    PHA
    LDA SPRITE_PAGE[256],Y
    STA SPRITE_PAGE[256],X
    PLA
    STA SPRITE_PAGE[256],Y
    INX ; Data++
    INY
    LDA SPRITE_PAGE[256],X ; 2x.
    PHA
    LDA SPRITE_PAGE[256],Y
    STA SPRITE_PAGE[256],X
    PLA
    STA SPRITE_PAGE[256],Y
    INX
    INY
    LDA SPRITE_PAGE[256],X ; 3x
    PHA
    LDA SPRITE_PAGE[256],Y
    STA SPRITE_PAGE[256],X
    PLA
    STA SPRITE_PAGE[256],Y
    INX
    INY
    LDA SPRITE_PAGE[256],X ; 4x
    PHA
    LDA SPRITE_PAGE[256],Y
    STA SPRITE_PAGE[256],X
    PLA
    STA SPRITE_PAGE[256],Y
    INX
    TYA ; Y to A.
    SEC ; Sub index.
    SBC #$07
    TAY ; Back to index.
INDEX_NONZERO: ; 1F:1CE7, 0x03FCE7
    STY CTRL_BIT_0x0 ; Y to.
    CPX CTRL_BIT_0x0 ; If _ X
    BCC SWAP_LT_OTHER ; <, goto.
    RTS ; Leave.
SETUP_SPRITES/ENGINE: ; 1F:1CEE, 0x03FCEE
    LDA #$00 ; Clear.
    TAX ; Index reset.
CLEAR_PAGE: ; 1F:1CF1, 0x03FCF1
    STA R_**:$0000,X ; Store. Right addrmode, nice.
    INX ; Index++
    BNE CLEAR_PAGE ; != 0, goto.
    JSR CLEAR_SPRITES_OFFSCREEN ; Do ??
    LDA #$08
    STA PPU_CTRL ; Set CTRL.
    STA ENGINE_PPU_CTRL_COPY
MANUAL_ENTRY_FROM_PTR: ; 1F:1D00, 0x03FD00
    LDA #$80
    STA ENGINE_MAPPER_CONFIG_STATUS_NO_BANK ; Set four pages at PPU 0x1000.
    STA MMC3_BANK_CFG ; Set to hardware.
    LDA #$18
    STA PPU_MASK ; Enable rendering, no left column.
    STA ENGINE_PPU_MASK_COPY
    LDA #$00
    STA MMC3_MIRRORING ; V mirroring, H unique.
    RTS ; Leave.
ENGINE_SOUND_INIT_HELPER: ; 1F:1D14, 0x03FD14
    LDA #$1C
    STA ENGINE_SOUND_ENGINE_BANK_VAL? ; Set R6, 0x1C. Sound bank.
    LDA #$00 ; Clear.
    LDX #$00 ; Index. Not TAX like the other?! Hmm. :) Diff programmers?
CLEAR_0x700_PAGE: ; 1F:1D1C, 0x03FD1C
    STA **:$0700,X ; Clear sound page.
    INX ; Index++
    BNE CLEAR_0x700_PAGE ; != 0, goto.
    JSR ENGINE_SWAP_TO_SOUND_ENGINE_HELPER ; Set engine.
    JMP JMP_SOUND_ENGINE_SELF_INIT ; Goto.
SOUND_ASSIGN_NEW_MAIN_SONG: ; 1F:1D28, 0x03FD28
    CMP SOUND_MAIN_SONG_CURRENTLY_PLAYING_ID ; If _ current
    BEQ JUST_WAIT ; ==, skip.
    STA SOUND_MAIN_SONG_INIT_ID ; Store new to start.
JUST_WAIT: ; 1F:1D30, 0x03FD30
    JMP ENGINE_NMI_0x01_SET/WAIT ; Wait, abuse RTS.
ENGINE_SETTLE_ALL_UPDATES?: ; 1F:1D33, 0x03FD33
    LDA NMI_FLAG_EXECUTE_UPDATE_BUF_AND_MORE_TODO ; Load.
    ORA NMI_FLAG_EXECUTE_HOLD_MULTIPART/BOTTOM? ; Or with other.
    BNE ENGINE_SETTLE_ALL_UPDATES? ; Nonzero, redo.
    RTS ; Leave.
ENGINE_DELAY_X_FRAMES: ; 1F:1D3A, 0x03FD3A
    JSR ENGINE_NMI_0x01_SET/WAIT ; Wait.
    DEX ; Loops--
    BNE ENGINE_DELAY_X_FRAMES ; != 0, loop.
    RTS ; Leave.
ENGINE_NMI_0x01_SET/WAIT: ; 1F:1D41, 0x03FD41
    LDA #$01
    STA ENGINE_NMI_CONFIG_FLAGS_DIS:0x80 ; Set flag.
WAIT_COMPLETION: ; 1F:1D45, 0x03FD45
    LDA ENGINE_NMI_CONFIG_FLAGS_DIS:0x80 ; Load.
    BNE WAIT_COMPLETION ; Not done, take.
    RTS ; Leave, done.
WAIT_NMI/IRQ_CLEAR: ; 1F:1D4A, 0x03FD4A
    LDA ENGINE_IRQ_LATCH_CURRENT? ; Load.
    BNE WAIT_NMI/IRQ_CLEAR ; != 0, loop.
    RTS ; Leave.
WAIT_ANY_BUTTONS_PRESSED_RET_PRESSED: ; 1F:1D4F, 0x03FD4F
    LDA #$00
    STA CONTROL_ACCUMULATED?[2] ; Clear accumulated buttons.
WAIT_LOOP: ; 1F:1D53, 0x03FD53
    LDA CONTROL_ACCUMULATED?[2] ; Load.
    BEQ WAIT_LOOP ; == 0, wait longer for press.
    PHA ; Save buttons.
    LDA #$00
    STA CONTROL_ACCUMULATED?[2] ; Clear accumulated.
    PLA ; Restore, get buttons accumulated.
    RTS ; Leave.
SETTLE_SPRITES_OFFSCREEN/CLEAR_OBJ_RAM: ; 1F:1D5E, 0x03FD5E
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Wait for settle.
    SEC ; Shift in 0x1
    ROR NMI_FLAG_OBJECT_PROCESSING? ; Rotate, smol lock.
    LDX #$00 ; Seed index start.
SLOT_NONZERO: ; 1F:1D66, 0x03FD66
    LDA #$00 ; Clear.
    STA OBJ?_BYTE_0x0_STATUS?,X ; Clear indexed.
    LDA #$F0 ; Off screen on Y coord.
    STA SPRITE_PAGE[256],X ; Set sprite index, too.
    INX ; Slot++
    INX
    INX
    INX
    STA SPRITE_PAGE[256],X ; Store Next slot, too.
    INX
    INX
    INX
    INX
    BNE SLOT_NONZERO ; != 0, goto.
    ASL NMI_FLAG_OBJECT_PROCESSING? ; << 1, *2.
    RTS
ENGINE_CLEAR_SCREENS_0x2000-0x2800: ; 1F:1D80, 0x03FD80
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle ??
    LDA #$08 ; Packet type.
    LDX #$80 ; Packet count.
    STA NMI_PPU_CMD_PACKETS_BUF[69] ; Store to buf.
    STX NMI_PPU_CMD_PACKETS_BUF+1
    LDA #$00 ; Packet addr L.
    LDX #$20 ; Packet addr H.
    STA NMI_PPU_CMD_PACKETS_BUF+3 ; Store to buf.
    STX NMI_PPU_CMD_PACKETS_BUF+2
    LDA #$00
    STA NMI_PPU_CMD_PACKETS_BUF+4 ; Packet tile.
    STA NMI_PPU_CMD_PACKETS_BUF+5 ; End of packet.
LOOP_CLEARING_ADDR_ADJUST: ; 1F:1D9F, 0x03FD9F
    LDX #$00
    LDA #$80
    STX NMI_PPU_CMD_PACKETS_INDEX ; Reset index.
    STA NMI_FLAG_EXECUTE_UPDATE_BUF_AND_MORE_TODO ; Set flag ??
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle engine.
    CLC ; Prep add.
    LDA NMI_PPU_CMD_PACKETS_BUF+3 ; To next 
    ADC #$80 ; Add 128, next 4x rows.
    STA NMI_PPU_CMD_PACKETS_BUF+3 ; Store to.
    LDA NMI_PPU_CMD_PACKETS_BUF+2 ; Carry add to addr H.
    ADC #$00
    STA NMI_PPU_CMD_PACKETS_BUF+2
    CMP #$28 ; At addr 0x2800?
    BCC LOOP_CLEARING_ADDR_ADJUST ; <, loop.
    RTS ; Leave.
ENGINE_0x300_OBJECTS_UNK?: ; 1F:1DC0, 0x03FDC0
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle.
    LDA NMI_FLAG_ACTION? ; Load.
    AND #$BF ; Keep 1011.1111
    STA NMI_FLAG_ACTION? ; Cleared 0x40 store.
    LDA #$00
    STA NMI_FP_UNK[2] ; Clear ??
    STA NMI_FP_UNK+1
    CLC ; Prep add.
CARRY_NO_OVERFLOW: ; 1F:1DD0, 0x03FDD0
    TAX ; Val to index.
    LDA OBJ?_BYTE_0x1_UNK,X ; Load ??
    AND #$BF ; Keep 1011.1111
    STA OBJ?_BYTE_0x1_UNK,X ; Store to.
    LDA #$00
    STA OBJ?_BYTE_0x4_UNK,X ; Clear ??
    STA OBJ?_BYTE_0x5_BYTE,X
    TXA ; Index to A.
    ADC #$08 ; += 0x8, next obj?
    BCC CARRY_NO_OVERFLOW ; No overflow, goto.
    RTS ; Leave.
ENGINE_WRAM_STATE_WRITEABLE: ; 1F:1DE7, 0x03FDE7
    LDA #$80
    STA MMC3_WRAM_CFG ; Set CFG, WRAM with writes.
    RTS
ENGINE_WRAM_STATE_WRITE_DISABLED: ; 1F:1DED, 0x03FDED
    LDA #$C0
    STA MMC3_WRAM_CFG ; Set CFG, writes disabled.
    RTS
ENGINE_SCRIPT_LAUNCH_R7_A_PTR_XY_WITH_RESTORE: ; 1F:1DF3, 0x03FDF3
    PHA ; Save A passed, R7 val.
    LDA #$FE ; ENGINE_R7_RESTORE handler, in between return.
    PHA
    LDA #$0C
    PHA
    TYA ; Save Y, routine launching at RTS of RTN.
    PHA
    TXA ; Save X.
    PHA
    TSX ; Stack to X index.
    LDA ENGINE_MAPPER_BANK_VALS_COMMITTING+7 ; Load R7 currently.
    LDY R_**:$0105,X ; Load 6th value up stack, R7 val.
    STA R_**:$0105,X ; Store R7 val to stack.
    TYA ; Val passed to us into A.
    LDX #$07 ; Bank it in to R7.
    JMP ENGINE_MAPPER_COMMIT_BANK_X_VAL_A ; COMMIT.
ENGINE_R7_RESTORE_FROM_STACK_SCRIPT?: ; 1F:1E0D, 0x03FE0D
    PLA ; Pull value from stack.
    LDX #$07
    JMP ENGINE_MAPPER_COMMIT_BANK_X_VAL_A ; Exit restoring R7.
VECTOR_IRQ: ; 1F:1E13, 0x03FE13
    PHA ; Save AXY.
    TXA
    PHA
    TYA
    PHA
    LDA MAPPER_INDEX_LAST_WRITTEN ; Save because of our possible changes to mapper config.
    PHA
    JSR ENGINE_IRQ_SCRIPT_RUN?
    PLA ; Restore.
    ORA ENGINE_MAPPER_CONFIG_STATUS_NO_BANK ; Set CFG.
    STA MMC3_BANK_CFG ; Set mapper.
    LDX ENGINE_IRQ_RTN_INDEX ; Move index.
    INX ; Index += 2
    INX
    STX ENGINE_IRQ_RTN_INDEX ; Store index.
    LDA IRQ_SCRIPT_PTRS+1,X ; Load from.
    BNE VALID_VALUE ; Nonzero, valid.
    STA MMC3_IRQ_DISABLE ; Disable IRQ's.
    STA ENGINE_IRQ_LATCH_CURRENT? ; Store to.
VALID_VALUE: ; 1F:1E34, 0x03FE34
    PLA ; Leave IRQ.
    TAY
    PLA
    TAX
    PLA
    RTI
ENGINE_IRQ_SCRIPT_RUN?: ; 1F:1E3A, 0x03FE3A
    STA MMC3_IRQ_DISABLE
    LDX ENGINE_IRQ_RTN_INDEX ; Index from.
    LDA IRQ_SCRIPT_PTRS+1,X ; Load rtn from index.
    PHA
    LDA IRQ_SCRIPT_PTRS[6],X
    PHA
    STA MMC3_IRQ_ENABLE ; Enable IRQ's.
    RTS ; Run routine.
READ_CONTROLLERS: ; 1F:1E4B, 0x03FE4B
    LDX #$01 ; Player 2 index.
LOOP_OTHER_PLAYER_CTRL: ; 1F:1E4D, 0x03FE4D
    SEC ; Seed read 1.
LOOP_PLAYER: ; 1F:1E4E, 0x03FE4E
    PHP ; Save player seed. CS = P2, CC = P1.
    LDA #$01
    STA NES_CTRL1 ; Reset latch.
    LDA #$00
    STA NES_CTRL1
    LDY #$08 ; Loop count.
LOOP_READ_BITS: ; 1F:1E5B, 0x03FE5B
    LDA NES_CTRL1,X ; Load player controller.
    LSR A ; Shift.
    ROL CTRL_BIT_0x0
    LSR A
    ROL CTRL_BIT_0x1
    DEY ; Loop--
    BNE LOOP_READ_BITS ; != 0, loop.
    LDA CTRL_BIT_0x0 ; Set CTRL from either.
    ORA CTRL_BIT_0x1
    PLP ; Pull buttons.
    BCC READ_TWICE ; P1 status, goto.
    STA CTRL_NEWLY_PRESSED[2],X ; Store primary read.
    CLC ; Pass 2.
    BCC LOOP_PLAYER ; Always taken.
READ_TWICE: ; 1F:1E73, 0x03FE73
    CMP CTRL_NEWLY_PRESSED[2],X ; If _ PRIMARY
    BEQ CTRL_READS_MATCHED ; ==, goto.
    LDA CTRL_BUTTONS_PREVIOUS[2],X ; Load older as fallback.
CTRL_READS_MATCHED: ; 1F:1E79, 0x03FE79
    TAY ; Pressed to Y.
    EOR CTRL_BUTTONS_PREVIOUS[2],X ; Invert with previous to get changed.
    AND CTRL_NEWLY_PRESSED[2],X ; Keep only the currenly pressed, aka newly pressed.
    STA CTRL_NEWLY_PRESSED[2],X ; Store newly pressed.
    STY CTRL_BUTTONS_PREVIOUS[2],X ; Buttons pressed to.
    DEX ; Player--
    BPL LOOP_OTHER_PLAYER_CTRL ; Positive, do P1.
    RTS ; Leave.
SUB_CTRL_TODO: ; 1F:1E86, 0x03FE86
    LDA CTRL_NEWLY_PRESSED[2] ; Load newly pressed.
    BNE BUTTONS_NEWLY_PRESSED ; != 0, some newly pressed, goto.
    LDA INPUT_COUNTER_MATCHED ; Load.
    CMP #$2A ; If _ #$2A
    BCC VAR_LT_0x2A ; <, goto.
    RTS ; Leave.
BUTTONS_NEWLY_PRESSED: ; 1F:1E91, 0x03FE91
    LDA #$00
    STA INPUT_COUNTER_MATCHED ; Clear matched count.
VAR_LT_0x2A: ; 1F:1E95, 0x03FE95
    INC INPUT_COUNT_UNK_A ; ++
    BNE RTS ; != 0, leave.
    INC INPUT_COUNTER_MATCHED ; ++
    INC INP_COUNT_UNK_B ; ++
    BNE RTS ; != 0, leave.
    INC INP_COUNT_UNK_C ; ++
RTS: ; 1F:1EA1, 0x03FEA1
    RTS ; Leave.
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
VECTOR_RESET: ; 1F:1F40, 0x03FF40
    LDA #$08
    STA PPU_CTRL ; Clear CTRL.
    SEI ; No interrupts.
    CLD ; No decimal.
    LDA #$00
    STA PPU_MASK ; No rendering.
    STA APU_STATUS ; No sound.
    STA APU_DMC_CTRL ; No DMC.
    STA MMC3_IRQ_DISABLE ; No MMC3 IRQ's.
    LDA #$40
    STA APU_FSEQUENCE ; Set APU settings.
    STA MMC3_WRAM_CFG ; Disable WRAM, deny writes.
    LDX #$02 ; Count.
STATUS_WAIT: ; 1F:1F5F, 0x03FF5F
    BIT PPU_STATUS ; Check status.
    BPL STATUS_WAIT ; Wait loop.
    DEX ; Count--
    BNE STATUS_WAIT ; Nonzero, loop.
    BIT PPU_STATUS ; Extra read here.
    LDY #$3F ; Set palette.
    LDX #$00
    STY PPU_ADDR ; Palette to address.
    STX PPU_ADDR
    LDX #$20 ; Count.
    LDA #$0F ; Color, black.
PALETTE_BLACKOUT_LOOP: ; 1F:1F78, 0x03FF78
    STA PPU_DATA ; Store to palette.
    DEX ; Count--
    BNE PALETTE_BLACKOUT_LOOP ; != 0, goto.
    STY PPU_ADDR ; Set palette addr again.
    STX PPU_ADDR
    STX PPU_ADDR ; Clear addr.
    STX PPU_ADDR
    LDA #$1E
    STA PPU_MASK ; Enable rendering.
    BIT PPU_STATUS ; Reset status.
    LDA #$10 ; Seed PPU addr 0x1010
    TAX ; To count.
MMC3_CLOCKING_BORKED: ; 1F:1F95, 0x03FF95
    STA PPU_ADDR ; Set addr. 0x1010/0x0000
    STA PPU_ADDR
    EOR #$00 ; Invert nothing, lol. Oops, on oops.
    DEX ; Count--
    BNE MMC3_CLOCKING_BORKED ; != 0, loop.
    LDX #$FF ; Setup stack.
    TXS
    LDA #$00
    STA MMC3_BANK_CFG ; Ret R0.
    JSR SETUP_SPRITES/ENGINE ; Setup.
    JSR ENGINE_SOUND_INIT_HELPER ; Sound init?
    LDX #$07
    LDA #$13
    JSR ENGINE_MAPPER_COMMIT_BANK_X_VAL_A ; Set R7, bank 0x13.
    BIT PPU_STATUS ; Reset status.
    LDA ENGINE_PPU_CTRL_COPY ; Set CTRL NMI.
    ORA #$80
    STA ENGINE_PPU_CTRL_COPY
    STA PPU_CTRL ; Store to PPU.
    CLI ; Enable interrupts.
    JMP SYSTEM_SETUP_COMPLETED ; Goto. <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
ENGINE_SWAP_TO_SOUND_ENGINE_HELPER: ; 1F:1FC5, 0x03FFC5
    LDA ENGINE_SOUND_ENGINE_BANK_VAL? ; Load sound bank.
    LDX #$06 ; R6.
    JSR ENGINE_MAPPER_COMMIT_BANK_X_VAL_A ; Set.
    LDA #$1D ; Bank val.
    LDX #$07 ; R7.
ENGINE_MAPPER_COMMIT_BANK_X_VAL_A: ; 1F:1FD0, 0x03FFD0
    STX MAPPER_INDEX_LAST_WRITTEN ; Index to.
    STA ENGINE_MAPPER_BANK_VALS_COMMITTING[8],X ; Value to index.
    TXA ; Bank slot to A.
    ORA ENGINE_MAPPER_CONFIG_STATUS_NO_BANK ; Set config status bits.
    STA MMC3_BANK_CFG ; Store R# bank config.
    LDA ENGINE_MAPPER_BANK_VALS_COMMITTING[8],X ; Load value stored from arr.
    STA MMC3_BANK_DATA ; Store bank data to mapper.
    RTS ; Leave.
    .db 45
    .db 41
    .db 52
    .db 54
    .db 48
    .db 20
    .db 42
    .db 4F
    .db 55
    .db 4E
    .db 44
    .db 20
    .db 31
    .db 2E
    .db 30
    .db 30
    .db 00
    .db 00
    .db 00
    .db 00
    .db 03
    .db 00
    .db 01
    .db 0F
    .db 01
    .db 00
    LOW(VECTOR_NMI)
    HIGH(VECTOR_NMI)
    LOW(VECTOR_RESET)
    HIGH(VECTOR_RESET)
    LOW(VECTOR_IRQ)
    HIGH(VECTOR_IRQ)
