VAL_NONZERO_LOOP: ; 1F:0000, 0x03E000
    LDY #$00 ; Stream index.
    LDA [ENGINE_FPTR_30[2]],Y ; Load stream.
    BEQ USE_CLEAR ; == 0, goto.
    BMI USE_CLEAR ; Negative, goto.
    LDY #$08 ; Stream index.
    LDA [ENGINE_FPTR_30[2]],Y ; Load from ptr.
    AND #$3F ; Keep lower.
    BEQ USE_CLEAR ; == 0, goto.
    LDY #$14 ; Stream index.
    LDA [ENGINE_FPTR_30[2]],Y ; Load from stream.
    AND #$10 ; Keep ??
    BEQ WRITE_CLEAR ; Clear, goto.
    TXA ; Write X. To A.
    LDX #$00 ; Seed clear?
WRITE_CLEAR: ; 1F:001B, 0x03E01B
    STA SLOT/DATA_OFFSET_USE? ; Store val.
    LDY #$10 ; Stream index.
    TXA ; X to A.
    STA [ENGINE_FPTR_30[2]],Y ; Store to stream.
    LDY #$08 ; Stream mod.
VAL_LT_0xE: ; 1F:0024, 0x03E024
    LDA [ENGINE_FPTR_30[2]],Y ; Load from stream.
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
    ADC [ENGINE_FPTR_30[2]],Y ; Add with stream.
    STA OBJ?_BYTE_0x0_STATUS?,X ; To ??
    INX ; Indexes++
    INY
    LDA #$00 ; Seed carry add.
    ADC [ENGINE_FPTR_30[2]],Y ; Add with carry.
    STA OBJ?_BYTE_0x0_STATUS?,X ; To ??
    INX ; Index++
    BEQ EXIT_WRAM_WDISABLED ; == 0, goto.
    LDA SLOT/DATA_OFFSET_USE? ; Load ??
    BEQ USE_CLEAR ; == 0, goto.
    TAX ; Nonzero to index.
USE_CLEAR: ; 1F:004F, 0x03E04F
    JSR ENGINE_FPTR_COL/ROW_MOD/FORWARD? ; Forward.
    DEC GAME_SLOT_CURRENT? ; --
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
    JSR SETUP_PTR_6780_UNK ; Do ??
    LDX #$04
    STX GAME_SLOT_CURRENT? ; Set ??
    LDA #$00
    STA MISC_USE_C ; Clear index.
    LDX #$08 ; Seed index.
LOOP_NONZERO: ; 1F:0094, 0x03E094
    LDY #$00 ; Reset stream.
    LDA [ENGINE_FPTR_30[2]],Y ; Load from file.
    BEQ FLAGGED_DATA ; == 0, goto.
    BMI FLAGGED_DATA ; Negative, goto.
    LDY MISC_USE_C ; Alt stream index.
    LDA [MISC_USE_A],Y ; Load from stream.
    STA OBJ?_BYTE_0x2_UNK,X ; Store to arr.
    INY ; Stream++
    LDA [MISC_USE_A],Y ; Load from stream.
    STA OBJ?_BYTE_0x3_UNK,X ; Store to arr.
    INY ; Stream++
    LDA [MISC_USE_A],Y ; Load from stream.
    STA MISC_USE_D/DECIMAL_POS? ; Store to.
    INY ; Stream++
    CLC ; Prep add.
    LDA [MISC_USE_A],Y ; Load from stream.
    LDY #$16 ; Alt stream index.
    ADC [ENGINE_FPTR_30[2]],Y ; Add with stream.
    STA OBJ?_PTR?[2],X ; Store to arr.
    INY ; Stream++
    LDA #$00 ; Seed carry.
    ADC [ENGINE_FPTR_30[2]],Y ; Add with stream.
    STA OBJ?_PTR?+1,X ; Store to arr.
    LDY #$08 ; Stream index.
    LDA [ENGINE_FPTR_30[2]],Y ; Load from arr.
    AND #$3F ; Keep lower.
    ASL A ; << 1, *2.
    ASL MISC_USE_D/DECIMAL_POS? ; << 1, *2.
    ROR A ; Rotate carry into A.
    STA OBJ?_BYTE_0x0_STATUS?,X ; Store to arr.
    LDA #$70 ; Load ??
    ASL MISC_USE_D/DECIMAL_POS? ; << 1, *2.
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
    ADC MISC_USE_C ; Add with.
    STA MISC_USE_C ; Store 
    JSR ENGINE_FPTR_COL/ROW_MOD/FORWARD? ; Do mod.
    DEC GAME_SLOT_CURRENT? ; --
    BNE LOOP_NONZERO ; == 0, goto.
    RTS ; Leave.
ENGINE_HELPER_LOAD_7400_INDEX_A&3F: ; 1F:00F2, 0x03E0F2
    AND #$3F ; Keep group count/data index.
    TAX ; To X index.
    LDA CURRENT_SAVE_MANIPULATION_PAGE[768],X ; Load from.
    RTS ; Leave.
SWITCH_SCRIPTS?: ; 1F:00F9, 0x03E0F9
    ASL A ; << 2, *4.
    ASL A
    TAX ; To X index.
    LDA SCRIPT_SWITCH_RTNS_L,X ; Routine RTS addr to stack.
    PHA
    LDA SCRIPT_SWITCH_RTNS_H,X
    PHA
    RTS ; Run it.
SCRIPT_SWITCH_RTNS_H: ; 1F:0105, 0x03E105
    LOW(1F:01BC) ; 0x00
SCRIPT_SWITCH_RTNS_L: ; 1F:0106, 0x03E106
    HIGH(1F:01BC) ; RTS
ROUTINE_ATTR_A: ; 1F:0107, 0x03E107
    .db 00
ROUTINE_ATTR_B: ; 1F:0108, 0x03E108
    .db 00
    LOW(1F:0680) ; 0x01
    HIGH(1F:0680)
    .db 00
    .db 88
    LOW(1F:0680)
    HIGH(1F:0680)
    .db 00
    .db 88
    LOW(1F:06CE)
    HIGH(1F:06CE)
    .db 00
    .db 88
    LOW(1F:0677)
    HIGH(1F:0677)
    .db 00
    .db 08
    LOW(1F:01BC) ; RTS
    HIGH(1F:01BC)
    .db 00
    .db 00
    LOW(1F:01BC)
    HIGH(1F:01BC)
    .db 00
    .db 00
    LOW(1F:083E)
    HIGH(1F:083E)
    .db 04
    .db A6
    LOW(1F:096B)
    HIGH(1F:096B)
    .db 04
    .db 60
    LOW(RTS)
    HIGH(RTS)
    .db 09
    .db 20
    LOW(1F:0B91)
    HIGH(1F:0B91)
    .db 09
    .db 20
    LOW(1F:08DD)
    HIGH(1F:08DD)
    .db 09
    .db 20
    LOW(1F:0904)
    HIGH(1F:0904) ; K
    .db 04
    .db 60
    LOW(L_1F:0A37)
    HIGH(L_1F:0A37)
    .db 09
    .db 20
    LOW(1F:0AC4)
    HIGH(1F:0AC4)
    .db 09
    .db 20
    LOW(1F:0BC9) ; N
    HIGH(1F:0BC9)
    .db 04
    .db 20
    LOW(1F:07F4)
    HIGH(1F:07F4)
    .db 04
    .db E6
    LOW(1F:07CC) ; P
    HIGH(1F:07CC)
    .db 04
    .db E6
    LOW(1F:07BD)
    HIGH(1F:07BD)
    .db 04
    .db E6
    LOW(1F:0813)
    HIGH(1F:0813)
    .db 04
    .db E6
    LOW(1F:0807) ; S
    HIGH(1F:0807)
    .db 04
    .db E6
    LOW(1F:07C6)
    HIGH(1F:07C6)
    .db 04
    .db E6
    LOW(1F:07B7) ; U
    HIGH(1F:07B7)
    .db 04
    .db E6
    LOW(1F:080D) ; V
    HIGH(1F:080D)
    .db 04
    .db E6
    LOW(1F:071F) ; W
    HIGH(1F:071F)
    .db 00
    .db C4
    LOW(1F:071F)
    HIGH(1F:071F)
    .db 04
    .db C6
    LOW(1F:071F)
    HIGH(1F:071F)
    .db 09
    .db 46
    LOW(1F:071F) ; W
    HIGH(1F:071F)
    .db 00
    .db 44
    LOW(1F:0719) ; X
    HIGH(1F:0719)
    .db 00
    .db C4
    LOW(1F:0719)
    HIGH(1F:0719)
    .db 04
    .db C6
    LOW(1F:0719)
    HIGH(1F:0719)
    .db 09
    .db 46
    LOW(1F:0719) ; X
    HIGH(1F:0719)
    .db 00
    .db 44
    LOW(1F:0755) ; Y
    HIGH(1F:0755)
    .db 04
    .db 88
    LOW(1F:06F0) ; Z
    HIGH(1F:06F0)
    .db 04
    .db C6
    LOW(1F:07BD) ; Q
    HIGH(1F:07BD)
    .db 02
    .db E6
    LOW(1F:071F) ; W
    HIGH(1F:071F)
    .db 0A
    .db 56
    LOW(1F:071F)
    HIGH(1F:071F)
    .db 04
    .db 56
    LOW(1F:071F) ; W
    HIGH(1F:071F)
    .db 08
    .db C6
    LOW(1F:0787) ; AA
    HIGH(1F:0787)
    .db 04
    .db A6
    LOW(RTS) ; AB
    HIGH(RTS)
    .db 04
    .db C6
    LOW(1F:08D1) ; AC
    HIGH(1F:08D1)
    .db 09
    .db 46
    LOW(1F:0660) ; AD
    HIGH(1F:0660)
    .db 00
    .db 45
    LOW(1F:0668) ; AE
    HIGH(1F:0668)
    .db 00
    .db 45
    LOW(1F:08F4) ; AF
    HIGH(1F:08F4)
    .db 0A
    .db C6
    LOW(1F:08E7) ; AG
    HIGH(1F:08E7)
    .db 09
    .db 46
    LOW(1F:0719) ; X
    HIGH(1F:0719)
    .db 04
    .db 46
MAP_RTN_E: ; 1F:01BD, 0x03E1BD
    RTS
MAP?_RTN_A: ; 1F:01BE, 0x03E1BE
    LDY #$04
    LDA [ENGINE_FPTR_30[2]],Y
    STA STREAM_WRITE_ARR_UNK[4]
    INY
    LDA [ENGINE_FPTR_30[2]],Y
    STA STREAM_WRITE_ARR_UNK+1
    LDY #$06
    LDA [ENGINE_FPTR_30[2]],Y
    STA STREAM_WRITE_ARR_UNK+2
    INY
    LDA [ENGINE_FPTR_30[2]],Y
    STA STREAM_WRITE_ARR_UNK+3
L_1F:01D4: ; 1F:01D4, 0x03E1D4
    SEC
    LDA STREAM_WRITE_ARR_UNK+2
    SBC SCRIPT_PAIR_PTR?[2]
    STA SAVE_GAME_MOD_PAGE_PTR[2]
    LDA STREAM_WRITE_ARR_UNK+3
    SBC SCRIPT_PAIR_PTR?+1
    STA SAVE_GAME_MOD_PAGE_PTR+1
    SEC
    LDA #$C0
    SBC SAVE_GAME_MOD_PAGE_PTR[2]
    LDA #$03
    SBC SAVE_GAME_MOD_PAGE_PTR+1
    BCC RTS
    LDA SCRIPT_PAIR_PTR_B?[2]
    SBC #$40
    STA MISC_USE_A
    LDA SCRIPT_PAIR_PTR_B?+1
    SBC #$00
    STA MISC_USE_B
    SEC
    LDA STREAM_WRITE_ARR_UNK[4]
    SBC MISC_USE_A
    STA MISC_USE_A
    LDA STREAM_WRITE_ARR_UNK+1
    SBC MISC_USE_B
    STA MISC_USE_B
    SEC
    LDA #$80
    SBC MISC_USE_A
    LDA #$04
    SBC MISC_USE_B
RTS: ; 1F:020E, 0x03E20E
    RTS
    JSR SETUP_PTR_6780_UNK
    LDY #$15
    LDA [ENGINE_FPTR_30[2]],Y
    ASL A
    ASL A
    ASL A
    TAX
    LDA DATA_UNK_C,X
    ASL A
    TAX
    STA OBJ_PROCESS_COUNT_LEFT?
    LDY #$11
    LDA DATA_UNK_B,X
    ASL A
    ASL A
    ASL A
    ASL A
    CLC
    ADC [ENGINE_FPTR_30[2]],Y
    STA STREAM_DEEP_INDEX
    INY
    LDA [ENGINE_FPTR_30[2]],Y
    STA STREAM_DEEP_C
    INY
    LDA [ENGINE_FPTR_30[2]],Y
    STA STREAM_DEEP_D?
    CLC
    LDA STREAM_DEEP_INDEX
    ADC DATA_UNK_A,X
    TAX
    EOR STREAM_DEEP_INDEX
    AND #$F0
    BEQ EXIT_WRITE_INDEX
    LDA STREAM_DEEP_INDEX
    AND #$F0
    STA STREAM_DEEP_INDEX
    TXA
    AND #$0F
    ORA STREAM_DEEP_INDEX
    TAX
    LDA STREAM_DEEP_D?
    EOR #$01
    STA STREAM_DEEP_D?
EXIT_WRITE_INDEX: ; 1F:0258, 0x03E258
    STX STREAM_DEEP_INDEX ; Store to.
    JSR SUB_STREAM_RESET_TO_??_AND_PTR/VAL_RTN ; Do.
EXIT_PTR_MOVE: ; 1F:025D, 0x03E25D
    LDX ENGINE_FPTR_32[2] ; Move PTR to PTR.
    LDY ENGINE_FPTR_32+1
    STX ENGINE_FPTR_30[2]
    STY ENGINE_FPTR_30+1
    RTS
LIB_RTN_PTR_CREATION/SHIFT+CLEAR_UNK_MOVE_PTR_DOWN_UNK: ; 1F:0266, 0x03E266
    LDA MAIN_FLAG_UNK ; Load ??
    AND #$7F ; Keep lower.
    JSR PTR_CREATE_AND_LOAD_STREAM_0x14 ; Do ??
    ASL MAIN_FLAG_UNK ; << ??
    LDX #$00
    STX MAIN_FLAG_UNK ; Clear ??
    BEQ EXIT_PTR_MOVE ; Always taken.
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
    STA ENGINE_FPTR_32+1 ; Store to.
    LDA #$00 ; Ptr create clear.
    LSR ENGINE_FPTR_32+1 ; >> 1
    ROR A ; Into A.
    LSR ENGINE_FPTR_32+1 ; 2x
    ROR A
    LSR ENGINE_FPTR_32+1 ; 3x
    ROR A
    ADC #$80 ; += 0x80 + 1110.0000
    STA ENGINE_FPTR_32[2]
    LDA ENGINE_FPTR_32+1 ; Load leftover.
    ADC #$67 ; += 0x67
    STA ENGINE_FPTR_32+1 ; To PTR H.
    LDY #$14 ; Depth into.
    LDA [ENGINE_FPTR_32[2]],Y ; Load it.
RTS: ; 1F:02A1, 0x03E2A1
    RTS ; Return.
    LDY #$14
    LDA [ENGINE_FPTR_30[2]],Y
    AND #$20
    BEQ RTS
    JSR ENGINE_WRAM_STATE_WRITEABLE
    CLC
    LDA OBJ_PROCESS_COUNT_LEFT?
    ADC #$20
    AND #$38
    TAX
    LDY #$15
    LSR A
    LSR A
    LSR A
    STA [ENGINE_FPTR_30[2]],Y
    JSR ENGINE_WRAM_STATE_WRITE_DISABLED
    LDA DATA_UNK_C,X
    CLC
    LDY #$16
    ADC [ENGINE_FPTR_30[2]],Y
    STA MISC_USE_A
    LDA #$00
    INY
    ADC [ENGINE_FPTR_30[2]],Y
    STA MISC_USE_B
    LDA #$15
    LDX #$06
    JSR ENGINE_SET_MAPPER_BANK_X_VAL_A
    LDY #$10
    LDA [ENGINE_FPTR_30[2]],Y
    TAY
    LDA OBJ?_BYTE_0x0_STATUS?,Y
    AND #$3F
    STA OBJ_PROCESS_COUNT_LEFT?
    BEQ RTS ; == 0, leave.
    LDA MISC_USE_A
    STA OBJ?_PTR?[2],Y
    LDA MISC_USE_B
    STA OBJ?_PTR?+1,Y
    LDA OBJ?_BYTE_0x2_UNK,Y
    STA ARR_BITS_TO_UNK[8]
    LDA OBJ?_BYTE_0x3_UNK,Y
    STA ARR_BITS_TO_UNK+1
    LDA OBJ?_BYTE_0x1_UNK,Y
    ASL A
    ASL A
    TAX
    LDY #$00
    LDA [MISC_USE_A],Y
    STA SAVE_GAME_MOD_PAGE_PTR[2]
    INY
    LDA [MISC_USE_A],Y
    STA SAVE_GAME_MOD_PAGE_PTR+1
    INY
    LDA [MISC_USE_A],Y
    STA ARR_BITS_TO_UNK+2
    INY
    LDA [MISC_USE_A],Y
    STA ARR_BITS_TO_UNK+3
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
    ADC ARR_BITS_TO_UNK[8] ; Add with.
    STA SPRITE_PAGE+3,X ; Store to Xpos.
    INY ; Stream++
    CLC ; Prep add.
    LDA [SAVE_GAME_MOD_PAGE_PTR[2]],Y ; Load from stream.
    ADC ARR_BITS_TO_UNK+1 ; Add with.
    STA SPRITE_PAGE[256],X ; Store to Ypos.
    INY ; Stream++
    LDA [SAVE_GAME_MOD_PAGE_PTR[2]],Y ; Load from stream. TODO clarify this better in docs as bits change attr out.
    STA MISC_USE_A ; Store to. Attrs base.
    LDA ARR_BITS_TO_UNK+3 ; Seed shift.
    LSR MISC_USE_A ; >> var. Test flips disable?
    BCC PALETTE_KEEP? ; CC, goto.
    LSR A ; Shift off what would be color.
    LSR A
PALETTE_KEEP?: ; 1F:0342, 0x03E342
    LSR MISC_USE_A ; Shift var. Tests palette only?
    BCC UPPER_KEEP? ; Clear, goto.
    LSR A ; >> 4, /16. Shift down what would be VHB0 bits.
    LSR A
    LSR A
    LSR A
UPPER_KEEP?: ; 1F:034A, 0x03E34A
    AND #$03 ; Keep palette only.
    ASL MISC_USE_A ; Shift test bits back but clear.
    ASL MISC_USE_A
    ORA MISC_USE_A ; Set attrs with what is left.
    STA SPRITE_PAGE+2,X ; Store as attributes.
    INY ; Stream++
    CLC ; Prep add.
    AND #$10 ; Keep ??
    BEQ TEST_C_CLEAR ; Clear, goto. Tile rebase bit.
    LDA ARR_BITS_TO_UNK+2 ; Seed alt tile base.
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
SCRIPT_UNK_R6_ANBD_FILE_UNK: ; 1F:0376, 0x03E376
    LDA SCRIPT_USE_UNK_C ; Load ??
    LSR A ; Nibble down.
    LSR A
    LSR A
    LSR A
    AND #$0E ; Keep.
    ORA #$01 ; Set bottom.
    LDX #$06 ; Set R6.
    JSR ENGINE_SET_MAPPER_BANK_X_VAL_A ; Set bank.
    LDA SCRIPT_USE_UNK_C ; Load ??
    LSR A ; >> 2
    LSR A
    AND #$07 ; Keep bottom.
    STA ARR_BITS_TO_UNK+1 ; Store bits here.
    LDA SCRIPT_USE_UNK_A ; Load ??
    AND #$FC ; Keep 1111.1100
    CLC ; Prep add.
    STA ARR_BITS_TO_UNK[8] ; Store bits.
    LDA ARR_BITS_TO_UNK+1 ; Load ??
    ADC #$98 ; Add base.
    STA ARR_BITS_TO_UNK+1 ; Store to.
    LDY #$01 ; Stream index.
    LDA [ARR_BITS_TO_UNK[8]],Y ; Load from file.
    AND #$3F ; Keep lower.
    LDY #$01 ; Stream index.
    CMP [ENGINE_FPTR_30[2]],Y ; If _ file
    BNE FILE_MISMATCH ; Mismatch, goto.
    LDA SCRIPT_R6_ROUTINE_SELECT ; Load ??
    JSR BANK_HANDLER_R6_AND_BASE ; Do.
    CLC ; Ret CC.
    RTS
FILE_MISMATCH: ; 1F:03AD, 0x03E3AD
    LDA SCRIPT_R6_ROUTINE_SELECT ; Load val.
    JSR BANK_HANDLER_R6_AND_BASE ; Bank and base.
    SEC ; Ret CS.
    RTS ; Leave.
BANK/MOVE/RUN_RTN_SWITCH_UNK: ; 1F:03B4, 0x03E3B4
    LDA #$14
    LDX #$06
    JSR ENGINE_SET_MAPPER_BANK_X_VAL_A ; Set R6 to bank 0x14.
    LDA STREAM_DEEP_C ; Move ??
    STA STREAM_UNK_DEEP_A[2]
    LDA ROUTINE_SWITCH_UNK ; Load.
    ASL A ; To word index.
    TAX ; To index.
    LDA RTN_PTRS_H,X ; Move routine RTS ptr.
    PHA
    LDA RTN_PTRS_L,X
    PHA
    RTS ; Run it.
RTN_PTRS_L: ; 1F:03CC, 0x03E3CC
    LOW(1F:0427) ; TODO
RTN_PTRS_H: ; 1F:03CD, 0x03E3CD
    HIGH(1F:0427)
    LOW(1F:043B)
    HIGH(1F:043B)
    LOW(1F:03DD)
    HIGH(1F:03DD)
    LOW(1F:04B1)
    HIGH(1F:04B1)
    LOW(1F:049D)
    HIGH(1F:049D)
    LOW(1F:04DB)
    HIGH(1F:04DB)
    LOW(1F:0402)
    HIGH(1F:0402)
    LOW(1F:0465)
    HIGH(1F:0465)
    LOW(1F:048F) ; Banks, returns CS.
    HIGH(1F:048F)
RTN_ARR_RTN_C: ; 1F:03DE, 0x03E3DE
    .db 20 ; Do.
    ASL NMI_FLAG_B ; << 1
    TAX ; To X index.
    AND #$30 ; Keep 0011.0000
    BEQ VAL_EQ_0x00 ; == 0, goto.
    AND #$20 ; Keep other bit.
    BEQ EXIT_JMP_R6_SET ; Clear, goto.
    TXA
    AND #$1C
    BNE EXIT_JMP_R6_SET
VAL_EQ_0x00: ; 1F:03EF, 0x03E3EF
    LDX #$FF
    LDY #$00
    JSR STREAMS_AND_SPRITE_CHECK_IDK
    TAX
    AND #$20
    BEQ L_1F:0425
    TXA
    AND #$03
    BEQ L_1F:0425
EXIT_JMP_R6_SET: ; 1F:0400, 0x03E400
    JMP R6_BANK_WITH_RET_CS
RTN_ARR_RTN_G: ; 1F:0403, 0x03E403
    JSR SUB_SEED_UNK_AND_UNK
    TAX
    AND #$30
    BEQ L_1F:0414
    AND #$20
    BEQ EXIT_JMP_R6_SET
    TXA
    AND #$13
    BNE EXIT_JMP_R6_SET
L_1F:0414: ; 1F:0414, 0x03E414
    LDX #$01
    LDY #$00
    JSR STREAMS_AND_SPRITE_CHECK_IDK
    TAX
    AND #$20
    BEQ L_1F:0425
    TXA
    AND #$0C
    BNE EXIT_JMP_R6_SET
L_1F:0425: ; 1F:0425, 0x03E425
    JMP R6_BANK_WITH_RET_CC
RTN_ARR_RTN_A: ; 1F:0428, 0x03E428
    JSR SUB_SEED_UNK_AND_UNK
    AND #$16
    BNE R6_BANK_WITH_RET_CS
    LDX #$00
    LDY #$10
    JSR STREAMS_AND_SPRITE_CHECK_IDK
    AND #$09
    BNE R6_BANK_WITH_RET_CS
    BEQ R6_BANK_WITH_RET_CC
RTN_ARR_RTN_B: ; 1F:043C, 0x03E43C
    JSR SUB_SEED_UNK_AND_UNK
    AND #$14
    BNE R6_BANK_WITH_RET_CS
    LDX #$00
    LDY #$10
    JSR STREAMS_AND_SPRITE_CHECK_IDK
    AND #$08
    BNE R6_BANK_WITH_RET_CS
    LDX #$FF
    LDY #$00
    JSR STREAMS_AND_SPRITE_CHECK_IDK
    AND #$02
    BNE R6_BANK_WITH_RET_CS
    LDX #$FF
    LDY #$10
    JSR STREAMS_AND_SPRITE_CHECK_IDK
    AND #$01
    BNE R6_BANK_WITH_RET_CS
    BEQ R6_BANK_WITH_RET_CC
RTN_ARR_RTN_H: ; 1F:0466, 0x03E466
    JSR SUB_SEED_UNK_AND_UNK
    AND #$12
    BNE R6_BANK_WITH_RET_CS
    LDX #$00
    LDY #$10
    JSR STREAMS_AND_SPRITE_CHECK_IDK
    AND #$01
    BNE R6_BANK_WITH_RET_CS
    LDX #$01
    LDY #$00
    JSR STREAMS_AND_SPRITE_CHECK_IDK
    AND #$04
    BNE R6_BANK_WITH_RET_CS
    LDX #$01
    LDY #$10
    JSR STREAMS_AND_SPRITE_CHECK_IDK
    AND #$08
    BNE R6_BANK_WITH_RET_CS
    BEQ R6_BANK_WITH_RET_CC
R6_BANK_WITH_RET_CS: ; 1F:0490, 0x03E490
    LDA SCRIPT_R6_ROUTINE_SELECT ; Load rtn.
    JSR BANK_HANDLER_R6_AND_BASE ; Bank in.
    SEC ; Ret CS.
    RTS ; Leave.
R6_BANK_WITH_RET_CC: ; 1F:0497, 0x03E497
    LDA SCRIPT_R6_ROUTINE_SELECT ; Load rtn.
    JSR BANK_HANDLER_R6_AND_BASE ; Bank in.
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
    JSR SUB_SEED_UNK_AND_UNK
    AND #$18
    BNE R6_BANK_WITH_RET_CS
    LDX #$00
    LDY #$F0
    JSR STREAMS_AND_SPRITE_CHECK_IDK
    AND #$04
    BNE R6_BANK_WITH_RET_CS
    LDX #$FF
    LDY #$00
    JSR STREAMS_AND_SPRITE_CHECK_IDK
    AND #$01
    BNE R6_BANK_WITH_RET_CS
    LDX #$FF
    LDY #$F0
    JSR STREAMS_AND_SPRITE_CHECK_IDK
    AND #$02
    BNE R6_BANK_WITH_RET_CS
    BEQ R6_BANK_WITH_RET_CC
RTN_ARR_RTN_F: ; 1F:04DC, 0x03E4DC
    JSR SUB_SEED_UNK_AND_UNK
    AND #$11
    BNE R6_BANK_WITH_RET_CS
    LDX #$00
    LDY #$F0
    JSR STREAMS_AND_SPRITE_CHECK_IDK
    AND #$02
    BNE R6_BANK_WITH_RET_CS
    LDX #$01
    LDY #$00
    JSR STREAMS_AND_SPRITE_CHECK_IDK
    AND #$08
    BNE R6_BANK_WITH_RET_CS
    LDX #$01
    LDY #$F0
    JSR STREAMS_AND_SPRITE_CHECK_IDK
    AND #$04
    BNE R6_BANK_WITH_RET_CS
    BEQ R6_BANK_WITH_RET_CC
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
    LDA SCRIPT_R6_UNK ; Load ??
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
    STA [ENGINE_FPTR_30[2]],Y ; Store to engine ptr.
    INY ; Stream++
    LDA DATA_UNK_B,X ; Load data.
    ASL A ; << 1, *2.
    STA [ENGINE_FPTR_30[2]],Y ; Store to PTR.
    JMP ENTRY_UNK ; Goto.
DATA_INDEX_SWITCH_MOVE_UNK: ; 1F:0567, 0x03E567
    JSR ROUTINE_SWITCH_TO_DATA_SLOT_INDEX_X ; Get data index.
    LDY #$0C ; Stream index ??
    LDA DATA_UNK_A,X ; Move from data to engine.
    STA [ENGINE_FPTR_30[2]],Y
    INY ; Stream++
    LDA DATA_UNK_B,X ; Move data from engine.
    STA [ENGINE_FPTR_30[2]],Y
ENTRY_UNK: ; 1F:0577, 0x03E577
    LDY #$08 ; Stream index.
    LDA [ENGINE_FPTR_30[2]],Y ; Load from file.
    AND #$3F ; Keep lower.
    ORA #$40 ; Set ??
    STA MISC_USE_A ; Store to.
    LDA ROUTINE_SWITCH_UNK ; Load val.
    LSR A ; >> 1, /2.
    AND #$40 ; Keep bit.
    EOR MISC_USE_A ; Invert with.
    STA [ENGINE_FPTR_30[2]],Y ; Store to ptr.
    LDY #$09 ; Stream index. ??
    LDA #$38 ; Move ??
    STA [ENGINE_FPTR_30[2]],Y
    LDY #$15 ; Stream index ??
    LDA [ENGINE_FPTR_30[2]],Y ; Load fptr.
    ASL A ; << 3, *8.
    ASL A
    ASL A
    TAX ; To X index.
    LDA DATA_UNK_C,X ; Load data.
EXIT_STREAM_MIX_UNK: ; 1F:059B, 0x03E59B
    CLC ; Prep add.
    LDY #$16 ; Stream index.
    ADC [ENGINE_FPTR_30[2]],Y ; Add with.
    LDY #$0E ; Stream index.
    STA [ENGINE_FPTR_30[2]],Y ; Store to.
    LDA #$00 ; Seed ??
    LDY #$17 ; Stream index.
    ADC [ENGINE_FPTR_30[2]],Y ; Add with.
    LDY #$0F ; Stream index.
    STA [ENGINE_FPTR_30[2]],Y ; Store to other.
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
    LDA [ENGINE_FPTR_30[2]],Y ; Load from stream.
    ADC STREAM_WRITE_ARR_UNK[4] ; Add with.
    STA STREAM_WRITE_ARR_UNK[4] ; Store to.
    AND #$C0 ; Keep upper.
    STA SCRIPT_LOADED_SHIFTED_UNK[1] ; Store to.
    INY ; Stream++
    LDA [ENGINE_FPTR_30[2]],Y ; Load from stream.
    ADC STREAM_WRITE_ARR_UNK+1 ; Add with.
    STA STREAM_WRITE_ARR_UNK+1 ; Store to.
    STA SCRIPT_USE_UNK_A ; And to ??
    CLC ; Prep add.
    LDY #$06 ; Stream index.
    LDA [ENGINE_FPTR_30[2]],Y ; Load from stream.
    ADC STREAM_WRITE_ARR_UNK+2
    STA STREAM_WRITE_ARR_UNK+2 ; Store to.
    AND #$C0 ; Keep upper.
    STA SCRIPT_USE_UNK_B ; Store to upper.
    INY ; Stream++
    LDA [ENGINE_FPTR_30[2]],Y ; Load from stream.
    ADC STREAM_WRITE_ARR_UNK+3 ; Add with.
    STA STREAM_WRITE_ARR_UNK+3 ; Store to.
    STA SCRIPT_USE_UNK_C ; Store to.
    JMP SETUP_DEEP_STREAM_UNK ; Goto.
SUB_INDEX_AND_MODS_UNK: ; 1F:05EF, 0x03E5EF
    JSR ROUTINE_SWITCH_TO_DATA_SLOT_INDEX_X ; Switch to slot index.
    LDA LUT_MOD_ARRAY_UNK[4],X ; Move from arr to other.
    STA STREAM_WRITE_ARR_UNK[4]
    LDA LUT_MOD_ARRAY_UNK+1,X
    STA STREAM_WRITE_ARR_UNK+1
    LDA LUT_MOD_ARRAY_UNK+2,X
    STA STREAM_WRITE_ARR_UNK+2
    LDA LUT_MOD_ARRAY_UNK+3,X
    STA STREAM_WRITE_ARR_UNK+3
    RTS ; Leave.
ROUTINE_SWITCH_TO_DATA_SLOT_INDEX_X: ; 1F:0607, 0x03E607
    LDA ROUTINE_SWITCH_UNK ; Load ??
    ASL A ; << 3, *8.
    ASL A
    ASL A
    TAX ; To X index.
    RTS ; Leave.
SUB_PTR_SETUP_CHECK_IDFK_GOSH: ; 1F:060E, 0x03E60E
    JSR SETUP_PTR_FROM_PTR_TODO ; Do ptr setup.
    LDY #$14 ; Stream index.
    LDA [ENGINE_FPTR_30[2]],Y ; Load from stream.
    AND #$0F ; Keep lower.
    TAY ; To Y index.
    LDA [ENGINE_FPTR_32[2]],Y ; Load other stream.
    INY ; Stream++
    CMP #$05 ; If 2nd _ #$05
    BEQ TEST_EXIT ; ==, goto.
    CMP #$06 ; If _ #$06
    BEQ TEST_EXIT_ALT ; ==, goto.
    BNE EXIT_CC ; !=, exit CC.
TEST_EXIT: ; 1F:0625, 0x03E625
    JSR GET_STREAM_INDEX_AND_VALUE_TODO ; Do.
    AND LUT_INDEX_TO_BITS_0x80-0x01,X ; And with LUT.
    BNE VALUE_SET ; Set, goto.
EXIT_CC: ; 1F:062D, 0x03E62D
    CLC ; Not set, ret CC.
    RTS ; Leave.
TEST_EXIT_ALT: ; 1F:062F, 0x03E62F
    JSR GET_STREAM_INDEX_AND_VALUE_TODO ; Get value.
    AND LUT_INDEX_TO_BITS_0x80-0x01,X ; Test bit.
    BNE EXIT_CC ; If set, exit CC.
VALUE_SET: ; 1F:0637, 0x03E637
    LDY #$00 ; Stream index.
    LDA [ENGINE_FPTR_30[2]],Y ; Load from FPTR.
    ORA #$80 ; Set top bit.
    STA [ENGINE_FPTR_30[2]],Y ; Store back.
    SEC ; Ret CS.
    RTS
SETUP_PTR_AND_STREAM_PAGE_VAL_TODO: ; 1F:0641, 0x03E641
    JSR SETUP_PTR_FROM_PTR_TODO
    LDY #$04 ; Seed stream index ??
GET_STREAM_INDEX_AND_VALUE_TODO: ; 1F:0646, 0x03E646
    LDA [ENGINE_FPTR_32[2]],Y ; Load alt stream.
    AND #$07 ; Keep lower.
    TAX ; To X index.
    LDA [ENGINE_FPTR_32[2]],Y ; Load alt stream.
    LSR A ; Shift off value to Y.
    LSR A
    LSR A
    TAY ; To Y index.
    LDA CURRENT_SAVE_MANIPULATION_PAGE+512,Y ; Load from page.
    RTS
SETUP_PTR_FROM_PTR_TODO: ; 1F:0655, 0x03E655
    LDY #$02 ; Stream index.
    LDA [ENGINE_FPTR_30[2]],Y ; Move from PTR L from stream to other.
    STA ENGINE_FPTR_32[2]
    INY ; Stream++
    LDA [ENGINE_FPTR_30[2]],Y ; Move PTR H.
    STA ENGINE_FPTR_32+1
    RTS ; Leave.
MAP_RTN_AD: ; 1F:0661, 0x03E661
    JSR SETUP_PTR_AND_STREAM_PAGE_VAL_TODO ; Do.
    ORA LUT_INDEX_TO_BITS_0x80-0x01,X ; Set bit.
    BNE BIT_SET_ENTRY ; Always taken.
MAP_RTN_AE: ; 1F:0669, 0x03E669
    JSR SETUP_PTR_AND_STREAM_PAGE_VAL_TODO ; Do.
    ORA LUT_INDEX_TO_BITS_0x80-0x01,X ; Set bit.
    EOR LUT_INDEX_TO_BITS_0x80-0x01,X ; Invert it, turning it off.
BIT_SET_ENTRY: ; 1F:0672, 0x03E672
    STA CURRENT_SAVE_MANIPULATION_PAGE+512,Y ; Store to page.
    JMP MAP_RTN_W ; Goto.
MAP_RTN_D: ; 1F:0678, 0x03E678
    LDY #$1B ; Stream index.
    LDA [ENGINE_FPTR_30[2]],Y ; Load from stream.
    BNE STREAM_NE_0x00 ; !=, goto.
    JMP SUB_SWITCH_SET_0x88 ; Goto.
MAP_RTN_B: ; 1F:0681, 0x03E681
    LDY #$15 ; Stream index.
    LDA [ENGINE_FPTR_30[2]],Y ; Load from stream.
    ORA #$40 ; Set ??
    LDY #$1B ; Stream index.
    EOR [ENGINE_FPTR_30[2]],Y ; Invert with.
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
    LDA ENGINE_FPTR_32[2] ; Move FPTR to MISC.
    STA MISC_USE_A
    LDA ENGINE_FPTR_32+1
    STA MISC_USE_B
MISC_FILE_MANIP_UNK: ; 1F:06A9, 0x03E6A9
    SEC ; Prep sub.
    LDA [MISC_USE_A],Y ; Load from original 32
    SBC #$00 ; Sub with.
    STA CURRENT_SAVE_MANIPULATION_PAGE+4 ; Store to.
    INY ; Stream++
    LDA [MISC_USE_A],Y ; Load from ptr.
    SBC #$02 ; Sub with.
    STA CURRENT_SAVE_MANIPULATION_PAGE+5 ; Store to.
    INY ; Stream++
    SEC ; Prep sub.
    LDA [MISC_USE_A],Y ; Load stream.
    SBC #$C0 ; Sub with.
    STA CURRENT_SAVE_MANIPULATION_PAGE+6 ; Store to.
    INY ; Stream++
    LDA [MISC_USE_A],Y ; Load stream.
    SBC #$01 ; Sub with.
    STA CURRENT_SAVE_MANIPULATION_PAGE+7 ; Store to.
    LDA #$40
    STA FIRST_LAUNCHER_HOLD_FLAG? ; Set flag.
    RTS ; Leave.
MAP_RTN_C: ; 1F:06CF, 0x03E6CF
    JSR MAP_RTN_B ; Do map.
    BCC RTS ; Ret CC, goto.
    LDA #$01
    STA SWITCH_INIT_PORTION? ; Set switch.
RTS: ; 1F:06D8, 0x03E6D8
    RTS ; Leave.
MAP_RTN_AB: ; 1F:06D9, 0x03E6D9
    JSR SUB_PTR_SETUP_CHECK_IDFK_GOSH ; Do sub.
    BCC EXTENDED ; CC, extend.
    RTS ; Leave.
EXTENDED: ; 1F:06DF, 0x03E6DF
    JSR FLAG_SET_MAYBE_FIX_PULL_UNK
    AND #$F0
    LSR A
    LSR A
    LSR A
    CMP #$08
    BCS L_1F:06FE
    JSR L_1F:07DC
    JMP STREAM_LOAD_STATUS_UNK
MAP_RTN_Z: ; 1F:06F1, 0x03E6F1
    JSR SUB_PTR_SETUP_CHECK_IDFK_GOSH
    BCC L_1F:06F7
    RTS
L_1F:06F7: ; 1F:06F7, 0x03E6F7
    JSR FLAG_SET_MAYBE_FIX_PULL_UNK
    AND #$F0
    BNE MAP_RTN_W
L_1F:06FE: ; 1F:06FE, 0x03E6FE
    LDY #$0C
    LDA #$3D
    STA [ENGINE_FPTR_30[2]],Y
    INY
    LDA #$EC
    STA [ENGINE_FPTR_30[2]],Y
    JSR STREAM_LOAD_STATUS_UNK
    LDY #$09
    LDA #$78
    STA [ENGINE_FPTR_30[2]],Y
    LDA #$00
    JSR EXIT_STREAM_MIX_UNK
    JMP SUB_SWITCH_SET_0x88
MAP_RTN_X: ; 1F:071A, 0x03E71A
    JSR SUB_PTR_SETUP_CHECK_IDFK_GOSH
    BCC MAP_RTN_W ; Ret CC, goto.
    RTS ; Leave now.
MAP_RTN_W: ; 1F:0720, 0x03E720
    JSR STREAM_CLEAR_DUBS
    JSR STREAM_LOAD_STATUS_UNK
    JSR STREAM_SET_FILE_DONE?
    LDA #$00
    JSR EXIT_STREAM_MIX_UNK
SUB_SWITCH_SET_0x88: ; 1F:072E, 0x03E72E
    LDA #$88
    STA ROUTINE_SWITCH_UNK ; Set switch.
    RTS ; Leave.
STREAM_CLEAR_DUBS: ; 1F:0733, 0x03E733
    LDA #$00 ; Clear val.
    LDY #$0C ; Stream index.
    STA [ENGINE_FPTR_30[2]],Y ; Clear stream.
    INY ; Stream++
    STA [ENGINE_FPTR_30[2]],Y ; Store to stream.
    RTS ; Leave.
STREAM_LOAD_STATUS_UNK: ; 1F:073D, 0x03E73D
    LDY #$08 ; Stream index.
    LDA [ENGINE_FPTR_30[2]],Y ; Load from file.
    AND #$3F ; Keep 0011.1111
    STA [ENGINE_FPTR_30[2]],Y ; Store to.
    RTS ; Leave.
STREAM_SET_FILE_DONE?: ; 1F:0746, 0x03E746
    LDY #$09 ; Stream index.
    LDA #$38 ; Val to store.
    STA [ENGINE_FPTR_30[2]],Y ; Store.
    RTS ; Leave.
STREAM_SET_FILE_NOTDONEBUTIDK?: ; 1F:074D, 0x03E74D
    LDY #$08 ; Stream index.
    LDA [ENGINE_FPTR_30[2]],Y ; Load from file.
    ORA #$40 ; Set bit.
    STA [ENGINE_FPTR_30[2]],Y ; Store to.
    RTS ; Leave.
MAP_RTN_Y: ; 1F:0756, 0x03E756
    JSR STREAM_CLEAR_DUBS ; LOts of small file routines. Good place to label them all.
    JSR STREAM_LOAD_STATUS_UNK
    JSR STREAM_SET_FILE_DONE?
    JSR SETUP_PTR_FROM_PTR_TODO
    JSR GET_FPTR_DATA_UNK ; Get data.
    AND LUT_INDEX_TO_BITS_0x80-0x01,X ; And with.
    BEQ L_1F:076C
    LDA #$04
L_1F:076C: ; 1F:076C, 0x03E76C
    JSR EXIT_STREAM_MIX_UNK
    JMP SUB_SWITCH_SET_0x88
GET_FPTR_DATA_UNK: ; 1F:0772, 0x03E772
    LDY #$06 ; Stream.
    LDA [ENGINE_FPTR_32[2]],Y ; Load from file.
    ASL A ; << 1, *2. Bit from.
    LDY #$07 ; Stream mod. INY better here.
    LDA [ENGINE_FPTR_32[2]],Y ; Load from file.
    AND #$07 ; Keep lower.
    TAX ; To X index.
    LDA [ENGINE_FPTR_32[2]],Y ; Load from file.
    ROR A ; Rotate above shift into this for index.
    LSR A ; >> 2
    LSR A
    TAY ; To Y index.
    LDA CURRENT_SAVE_MANIPULATION_PAGE+544,Y ; Load from.
    RTS ; Leave.
MAP_RTN_AA: ; 1F:0788, 0x03E788
    LDY #$1A
    LDA [ENGINE_FPTR_30[2]],Y
    BNE SCRIPT_ALT_UNK ; != 0, goto.
    LDA #$01
    STA [ENGINE_FPTR_30[2]],Y
    LDY #$15
    LDA [ENGINE_FPTR_30[2]],Y
    EOR #$04
    AND #$0F
    STA [ENGINE_FPTR_30[2]],Y
SCRIPT_ALT_UNK: ; 1F:079C, 0x03E79C
    LDY #$15
    LDA [ENGINE_FPTR_30[2]],Y
    STA ROUTINE_SWITCH_UNK
    JSR INDEX_AND_MODS_WITH_SHIFT_UNK
    JSR L_1F:01D4
    BCC L_1F:07B1
    LDA #$F8
    STA SCRIPT_FLAG_0x22
    JMP DATA_INDEX_SWITCH_MOVE_UNK_SHIFTED
L_1F:07B1: ; 1F:07B1, 0x03E7B1
    LDA #$00
    STA SCRIPT_FLAG_0x22
    JMP STREAM_SET_0x80_FIRST_BYTE
MAP_RTN_U: ; 1F:07B8, 0x03E7B8
    JSR SUB_PTR_SETUP_CHECK_IDFK_GOSH
    BCC MAP_RTN_Q
    RTS
MAP_RTN_Q: ; 1F:07BE, 0x03E7BE
    JSR FLAG_SET_MAYBE_FIX_PULL_UNK
    AND #$E0
    LSR A
    LSR A
    BCC L_1F:07D2
MAP_RTN_T: ; 1F:07C7, 0x03E7C7
    JSR SUB_PTR_SETUP_CHECK_IDFK_GOSH
    BCC MAP_RTN_P
    RTS
MAP_RTN_P: ; 1F:07CD, 0x03E7CD
    JSR FLAG_SET_MAYBE_FIX_PULL_UNK
    AND #$F8
L_1F:07D2: ; 1F:07D2, 0x03E7D2
    LSR A
    LSR A
    CMP #$08
    BCS MAP_RTN_O_SET_SWITCH_EXIT_JMP
    LDY #$15
    STA [ENGINE_FPTR_30[2]],Y
L_1F:07DC: ; 1F:07DC, 0x03E7DC
    STA ROUTINE_SWITCH_UNK
    JSR INDEX_AND_MODS_NO_SHIFT_UNK
    JSR SCRIPT_UNK_R6_ANBD_FILE_UNK
    BCS MAP_RTN_O_SET_SWITCH_EXIT_JMP
    JSR L_1F:01D4
    BCC MAP_RTN_O_SET_SWITCH_EXIT_JMP
    JSR SUB_STREAM_RESET_TO_??_AND_PTR/VAL_RTN
    BNE MAP_RTN_O_SET_SWITCH_EXIT_JMP
    JSR BANK/MOVE/RUN_RTN_SWITCH_UNK
    BCC EXIT_JMP_DATA_INDEX_SWITCH_MOVE_UNK
MAP_RTN_O_SET_SWITCH_EXIT_JMP: ; 1F:07F5, 0x03E7F5
    LDA #$88
    STA ROUTINE_SWITCH_UNK ; Set switch.
EXIT_JMP_DATA_INDEX_SWITCH_MOVE_UNK: ; 1F:07F9, 0x03E7F9
    JMP DATA_INDEX_SWITCH_MOVE_UNK ; Goto.
FLAG_SET_MAYBE_FIX_PULL_UNK: ; 1F:07FC, 0x03E7FC
    LDA ENGINE_FLAG_25_SKIP_UNK ; Load ??
    BNE VAL_EXTENDED ; Set, goto.
    JMP ADDS_IDFK ; Do adds instead.
VAL_EXTENDED: ; 1F:0803, 0x03E803
    PLA ; Pull A.
    PLA
    JMP MAP_RTN_O_SET_SWITCH_EXIT_JMP ; Goto.
MAP_RTN_S: ; 1F:0808, 0x03E808
    JSR SUB_PTR_SETUP_CHECK_IDFK_GOSH ; Do.
    BCC MAP_RTN_O_SET_SWITCH_EXIT_JMP ; Ret CC, goto.
    RTS ; Leave.
MAP_RTN_V: ; 1F:080E, 0x03E80E
    JSR SUB_PTR_SETUP_CHECK_IDFK_GOSH ; Do.
    BCC MAP_RTN_R ; Ret CC, goto.
    RTS ; Leave.
MAP_RTN_R: ; 1F:0814, 0x03E814
    JSR FLAG_SET_MAYBE_FIX_PULL_UNK ; Do.
    AND #$E0 ; Keep 1110.0000
    LSR A ; >> 4, /16.
    LSR A
    LSR A
    LSR A
    CMP #$08 ; If _ #$08
    BCS MAP_RTN_O_SET_SWITCH_EXIT_JMP ; >=, goto.
    LDY #$15 ; Stream index.
    STA [ENGINE_FPTR_30[2]],Y ; Store to stream.
    JSR MAP_RTN_O_SET_SWITCH_EXIT_JMP ; Do.
    JMP STREAM_SET_FILE_NOTDONEBUTIDK?
L_1F:082B: ; 1F:082B, 0x03E82B
    CMP #$00
    BNE MAP_RTN_O_SET_SWITCH_EXIT_JMP
    STA SCRIPT_FLAG_0x22
    LDY #$1D
    LDA [ENGINE_FPTR_30[2]],Y
    AND #$7F
    PHA
    JSR STREAM_UNK
    PLA
    JMP SWITCH_SCRIPTS?
MAP_RTN_F: ; 1F:083F, 0x03E83F
    LDY #$1A
    LDA [ENGINE_FPTR_30[2]],Y
    BNE L_1F:086B
    LDY #$1E
    CLC
    LDA [ENGINE_FPTR_30[2]],Y
    STA ENGINE_FPTR_32[2]
    ADC #$02
    STA [ENGINE_FPTR_30[2]],Y
    INY
    LDA [ENGINE_FPTR_30[2]],Y
    STA ENGINE_FPTR_32+1
    ADC #$00
    STA [ENGINE_FPTR_30[2]],Y
    LDY #$00
    LDA [ENGINE_FPTR_32[2]],Y
    CMP #$10
    BCC L_1F:082B
    LDY #$19
    STA [ENGINE_FPTR_30[2]],Y
    LDY #$01
    LDA [ENGINE_FPTR_32[2]],Y
    LDY #$1A
L_1F:086B: ; 1F:086B, 0x03E86B
    SEC
    SBC #$01
    STA [ENGINE_FPTR_30[2]],Y
    BNE L_1F:088F
    LDY #$1E
    LDA [ENGINE_FPTR_30[2]],Y
    STA ENGINE_FPTR_32[2]
    INY
    LDA [ENGINE_FPTR_30[2]],Y
    STA ENGINE_FPTR_32+1
    LDY #$00
    LDA [ENGINE_FPTR_32[2]],Y
    CMP #$10
    BCS L_1F:088F
    SEC
    LDA #$28
    SBC GAME_SLOT_CURRENT?
    CLC
    ADC #$84
    STA MAIN_FLAG_UNK
L_1F:088F: ; 1F:088F, 0x03E88F
    LDY #$19
    LDA [ENGINE_FPTR_30[2]],Y
    TAX
    AND #$20
    BEQ L_1F:08A2
    LDY #$1D
    LDA [ENGINE_FPTR_30[2]],Y
    ASL A
    ASL A
    TAY
    LDA ROUTINE_ATTR_A,Y
L_1F:08A2: ; 1F:08A2, 0x03E8A2
    LDY #$08
    STA [ENGINE_FPTR_30[2]],Y
    TXA
    AND #$08
    BNE L_1F:08B2
    LDY #$15
    TXA
    AND #$07
    STA [ENGINE_FPTR_30[2]],Y
L_1F:08B2: ; 1F:08B2, 0x03E8B2
    TXA
    BMI L_1F:08C1
    PHA
    AND #$07
    STA ROUTINE_SWITCH_UNK
    JSR INDEX_AND_MODS_NO_SHIFT_UNK
    PLA
    TAX
    BPL L_1F:08C5
L_1F:08C1: ; 1F:08C1, 0x03E8C1
    LDA #$88
    STA ROUTINE_SWITCH_UNK
L_1F:08C5: ; 1F:08C5, 0x03E8C5
    TXA
    AND #$40
    ASL A
    ORA #$70
    ORA ROUTINE_SWITCH_UNK
    STA SCRIPT_FLAG_0x22
    JMP DATA_INDEX_SWITCH_MOVE_UNK
MAP_RTN_AC: ; 1F:08D2, 0x03E8D2
    JSR SUB_PTR_SETUP_CHECK_IDFK_GOSH
    BCC L_1F:08D8
    RTS
L_1F:08D8: ; 1F:08D8, 0x03E8D8
    JSR MAP_RTN_O_SET_SWITCH_EXIT_JMP
    JMP L_1F:08E1
MAP_RTN_J: ; 1F:08DE, 0x03E8DE
    JSR MAP_RTN_I
L_1F:08E1: ; 1F:08E1, 0x03E8E1
    JSR STREAM_SET_FILE_NOTDONEBUTIDK?
    LDA #$74
    BNE L_1F:0900
MAP_RTN_AG: ; 1F:08E8, 0x03E8E8
    JSR SUB_PTR_SETUP_CHECK_IDFK_GOSH
    BCC L_1F:08EE
    RTS
L_1F:08EE: ; 1F:08EE, 0x03E8EE
    JSR MAP_RTN_O_SET_SWITCH_EXIT_JMP
    LDA #$74
    BNE L_1F:0900
MAP_RTN_AF: ; 1F:08F5, 0x03E8F5
    JSR SUB_PTR_SETUP_CHECK_IDFK_GOSH
    BCC L_1F:08FB
    RTS
L_1F:08FB: ; 1F:08FB, 0x03E8FB
    JSR MAP_RTN_O_SET_SWITCH_EXIT_JMP
    LDA #$72
L_1F:0900: ; 1F:0900, 0x03E900
    LDX #$01
    JMP ENGINE_SET_MAPPER_BANK_X_VAL_A
MAP_RTN_K: ; 1F:0905, 0x03E905
    LDA FLAG_UNK_23
    CLC
    BNE L_1F:095B
    LDA ROUTINE_SWITCH_UNK
    BMI L_1F:092F
    LDY #$1D
    LDA [ENGINE_FPTR_30[2]],Y
    TAX
    LDA R_**:$000C
    STA [ENGINE_FPTR_30[2]],Y
    TXA
    LDY #$15
    STA [ENGINE_FPTR_30[2]],Y
    STA R_**:$000C
    LDY #$19
    LDA [ENGINE_FPTR_30[2]],Y
    TAX
    LDA ROUTINE_SWITCH_UNK
    STA [ENGINE_FPTR_30[2]],Y
    TXA
    STA ROUTINE_SWITCH_UNK
    BMI L_1F:092F
    JSR INDEX_AND_MODS_NO_SHIFT_UNK
L_1F:092F: ; 1F:092F, 0x03E92F
    JSR DATA_INDEX_SWITCH_MOVE_UNK
    JSR L_1F:0A24
    LDY #$08
    LDA [ENGINE_FPTR_30[2]],Y
    AND #$0F
    CMP #$0A
    BEQ L_1F:0940
    RTS
L_1F:0940: ; 1F:0940, 0x03E940
    LDA R_**:$00D5
    ASL A
    AND #$02
    ORA #$70
    LDX #$01
    JMP ENGINE_SET_MAPPER_BANK_X_VAL_A
L_1F:094C: ; 1F:094C, 0x03E94C
    LDA #$88
    STA SCRIPT_UNK_DATA_SELECT_??
    LDA #$00
    STA NMI_FLAG_C
    STA NMI_FP_UNK[2]
    STA NMI_FP_UNK+1
    JSR STREAM_CLEAR_DUBS
L_1F:095B: ; 1F:095B, 0x03E95B
    LDA #$00
    STA ROUTINE_SWITCH_UNK
    STA FLAG_UNK_23
    LDA #$10
    BCS STREAM_SET_FIRST_BYTE_A
STREAM_SET_0x80_FIRST_BYTE: ; 1F:0965, 0x03E965
    LDA #$80 ; Value to write seed.
STREAM_SET_FIRST_BYTE_A: ; 1F:0967, 0x03E967
    LDY #$00 ; Stream = 0x00
    STA [ENGINE_FPTR_30[2]],Y ; Store to.
    RTS ; Leave.
MAP_RTN_G: ; 1F:096C, 0x03E96C
    LDA FLAG_UNK_23
    ASL A
    BNE L_1F:094C
    JSR L_1F:09CD
    BMI L_1F:09A9
    LDY #$15
    STA [ENGINE_FPTR_30[2]],Y
    STA R_**:$000C
L_1F:097C: ; 1F:097C, 0x03E97C
    STA ROUTINE_SWITCH_UNK
    JSR INDEX_AND_MODS_NO_SHIFT_UNK
    LDA ENGINE_FLAG_25_SKIP_UNK
    CMP #$28
    BCS L_1F:09AD
    JSR L_1F:09FA
    BCS L_1F:09A9
    JSR BANK/MOVE/RUN_RTN_SWITCH_UNK
    BCS L_1F:09A9
    BIT OBJ_PROCESS_COUNT_LEFT?
    BPL L_1F:09AD
    BVS L_1F:099F
    LDA ROUTINE_SWITCH_UNK
    SBC #$00
    AND #$0F
    BPL L_1F:097C
L_1F:099F: ; 1F:099F, 0x03E99F
    LDY #$15
    LDA #$00
    STA [ENGINE_FPTR_30[2]],Y
    STA R_**:$000C
    BCC L_1F:09AD
L_1F:09A9: ; 1F:09A9, 0x03E9A9
    LDA #$88
    STA ROUTINE_SWITCH_UNK
L_1F:09AD: ; 1F:09AD, 0x03E9AD
    JSR DATA_INDEX_SWITCH_MOVE_UNK
    JSR L_1F:0A24
EXIT_MOVE_FPTR/SAVE_SWITCH?: ; 1F:09B3, 0x03E9B3
    LDA ROUTINE_SWITCH_UNK ; Move switch.
    STA SCRIPT_UNK_DATA_SELECT_??
    LDY #$09 ; Stream index.
    LDA [ENGINE_FPTR_30[2]],Y ; Load from stream.
    AND #$40 ; Keep bit.
    ORA ACTION_BUTTONS_RESULT ; Or with.
    STA NMI_FLAG_C ; Store to.
    LDY #$0C ; Stream index.
    LDA [ENGINE_FPTR_30[2]],Y ; Load from file.
    STA NMI_FP_UNK[2] ; Store as PTR L.
    INY ; Stream++
    LDA [ENGINE_FPTR_30[2]],Y ; Move PTR H.
    STA NMI_FP_UNK+1
    RTS ; Leave.
L_1F:09CD: ; 1F:09CD, 0x03E9CD
    LDA SCRIPT_FLAG_0x22
    BEQ L_1F:09E1
    BPL L_1F:09D4
    RTS
L_1F:09D4: ; 1F:09D4, 0x03E9D4
    LDY #$19
    LDA [ENGINE_FPTR_30[2]],Y
    TAX
    LDA SCRIPT_FLAG_0x22
    STA [ENGINE_FPTR_30[2]],Y
    TXA
    AND #$8F
    RTS
L_1F:09E1: ; 1F:09E1, 0x03E9E1
    LDA CTRL_BUTTONS_PREVIOUS[2]
    AND #$0F
    TAX
    LDA R_**:$000D
    BPL L_1F:09F3
    AND #$0F
    CMP ACTION_ARRAY_UDLR?,X
    BEQ L_1F:09F7
    STA R_**:$000D
L_1F:09F3: ; 1F:09F3, 0x03E9F3
    LDA ACTION_ARRAY_UDLR?,X
    RTS
L_1F:09F7: ; 1F:09F7, 0x03E9F7
    LDA #$88
    RTS
L_1F:09FA: ; 1F:09FA, 0x03E9FA
    JSR SUB_STREAM_RESET_TO_??_AND_PTR/VAL_RTN
    BEQ L_1F:0A22
    ASL A
    LDA ROUTINE_SWITCH_UNK
    AND #$01
    BEQ L_1F:0A08
    BCS L_1F:0A1C
L_1F:0A08: ; 1F:0A08, 0x03EA08
    LDA R_**:$000F
    BNE L_1F:0A1A
    LDY #$1B
    LDA ROUTINE_SWITCH_UNK
    ORA #$40
    STA [ENGINE_FPTR_32[2]],Y
    BIT MAIN_FLAG_UNK
    BMI L_1F:0A1A
    STX MAIN_FLAG_UNK
L_1F:0A1A: ; 1F:0A1A, 0x03EA1A
    BCC L_1F:0A23
L_1F:0A1C: ; 1F:0A1C, 0x03EA1C
    LDA SCRIPT_FLAG_0x22
    AND #$10
    BEQ L_1F:0A23
L_1F:0A22: ; 1F:0A22, 0x03EA22
    CLC
L_1F:0A23: ; 1F:0A23, 0x03EA23
    RTS
L_1F:0A24: ; 1F:0A24, 0x03EA24
    JSR SETUP_PTR_FROM_PTR_TODO
    LDY #$01
    LDA [ENGINE_FPTR_32[2]],Y
    AND #$40
    BEQ L_1F:0A37
    LDY #$08
    LDA [ENGINE_FPTR_30[2]],Y
    AND #$3F
    STA [ENGINE_FPTR_30[2]],Y
L_1F:0A37: ; 1F:0A37, 0x03EA37
    RTS
MAP_RTN_L: ; 1F:0A38, 0x03EA38
    LDY #$1A
    LDA [ENGINE_FPTR_30[2]],Y
    BNE L_1F:0A7C
    LDA SCRIPT_R6_ROUTINE_SELECT
    JSR BANK_HANDLER_R6_AND_BASE
    ASL A
    TAX
    LDA $8000,X
    STA MISC_USE_A
    LDA $8001,X
    STA MISC_USE_B
    LDY #$1E
    LDA [ENGINE_FPTR_30[2]],Y
    ASL A
    TAY
    LDA [MISC_USE_A],Y
    STA ENGINE_FPTR_32[2]
    INY
    LDA [MISC_USE_A],Y
    STA ENGINE_FPTR_32+1
    LDY #$1F
    LDA [ENGINE_FPTR_30[2]],Y
    TAY
    LDA [ENGINE_FPTR_32[2]],Y
    CMP #$10
    BCC L_1F:0A9B
    PHA
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    TAX
    INY
    TYA
    LDY #$1F
    STA [ENGINE_FPTR_30[2]],Y
    LDY #$19
    PLA
    STA [ENGINE_FPTR_30[2]],Y
    TXA
    LDY #$1A
L_1F:0A7C: ; 1F:0A7C, 0x03EA7C
    SEC
    SBC #$01
    STA [ENGINE_FPTR_30[2]],Y
    LDY #$19
    LDA [ENGINE_FPTR_30[2]],Y
    BMI L_1F:0ABB
    AND #$0F
    STA ROUTINE_SWITCH_UNK
    LDY #$15
    STA [ENGINE_FPTR_30[2]],Y
    JSR INDEX_AND_MODS_NO_SHIFT_UNK
    JSR GET_STATE_UNK_LOWER
    JSR EXIT_STREAM_MIX_UNK
    JMP EXIT_MOVE_FPTR/SAVE_SWITCH?
L_1F:0A9B: ; 1F:0A9B, 0x03EA9B
    CMP #$00
    BNE L_1F:0AA1
    STA FLAG_UNK_23
L_1F:0AA1: ; 1F:0AA1, 0x03EAA1
    INY
    JSR MISC_FILE_MANIP_WITH_PTR_32_AS_MANIP
    INY
    TYA
    LDY #$1F
    STA [ENGINE_FPTR_30[2]],Y
    LDA FLAG_UNK_23
    BNE L_1F:0ABB
    LDA #$80
    STA FLAG_UNK_23
    JSR SLOTS_AND_FPTRS_IDFK
    LDX #$00
    JSR ACTION_INDEX_STORE_AND_RETURN_VALUE_UNK
L_1F:0ABB: ; 1F:0ABB, 0x03EABB
    LDA #$88
    STA ROUTINE_SWITCH_UNK
    JSR GET_STATE_UNK_LOWER
    JMP EXIT_MOVE_FPTR/SAVE_SWITCH?
MAP_RTN_M: ; 1F:0AC5, 0x03EAC5
    LDA ROUTINE_SWITCH_UNK
    BMI SET_SWITCH_RTN_NO_MOVE?UNK
    LDY #$19
    LDA [ENGINE_FPTR_30[2]],Y
    TAX
    LDA ROUTINE_SWITCH_UNK
    STA [ENGINE_FPTR_30[2]],Y
    TXA
    BMI SET_SWITCH_RTN_NO_MOVE?UNK
    STA ROUTINE_SWITCH_UNK
    LDY #$15
    EOR #$04
    STA [ENGINE_FPTR_30[2]],Y
    LDY #$06
    SEC
    LDA R_**:$6786
    SBC [ENGINE_FPTR_30[2]],Y
    INY
    LDA R_**:$6787
    SBC [ENGINE_FPTR_30[2]],Y
    LDY #$14
    LDA [ENGINE_FPTR_30[2]],Y
    BCS L_1F:0AF4
    ORA #$10
    BIT L_1F:0F29
    STA [ENGINE_FPTR_30[2]],Y
    JSR INDEX_AND_MODS_NO_SHIFT_UNK
    JSR GET_STATE_UNK_LOWER
    CPX #$40
    BCC L_1F:0B04
    SBC #$04
L_1F:0B04: ; 1F:0B04, 0x03EB04
    JMP EXIT_STREAM_MIX_UNK
SET_SWITCH_RTN_NO_MOVE?UNK: ; 1F:0B07, 0x03EB07
    LDA #$88
    STA ROUTINE_SWITCH_UNK
GET_STATE_UNK_LOWER: ; 1F:0B0B, 0x03EB0B
    JSR ROUTINE_SWITCH_TO_DATA_SLOT_INDEX_X ; Get index.
    LDY #$0C ; Stream index.
    LDA DATA_UNK_A,X ; Move to file ??
    STA [ENGINE_FPTR_30[2]],Y
    INY ; File++
    LDA DATA_UNK_B,X ; Move ?? to file.
    STA [ENGINE_FPTR_30[2]],Y
    JSR STREAM_LOAD_STATUS_UNK ; Remove.
    JSR STREAM_SET_FILE_DONE? ; Set ??
    LDA ROUTINE_SWITCH_UNK ; Load.
    BMI RTS ; Negative, goto.
    LDY #$15 ; Stream index.
    LDA [ENGINE_FPTR_30[2]],Y ; Load from file.
    TAX ; To X index.
    LDA TRANSLATE_ARR_UNK,X ; Load translate.
    TAX ; To X index.
    LDY #$08 ; File.
    AND #$40 ; Keep 0100.0000
    ORA [ENGINE_FPTR_30[2]],Y ; Combine into.
    STA [ENGINE_FPTR_30[2]],Y
    TXA ; X to A.
    AND #$1F ; Keep index.
RTS: ; 1F:0B39, 0x03EB39
    RTS
MAP_RTN_H: ; 1F:0B3A, 0x03EB3A
    JSR L_1F:09CD
    BMI SWITCH_SWITCH_SET
    LDY #$15
    STA [ENGINE_FPTR_30[2]],Y
    STA SCRIPT_UNK_DATA_SELECT_??
    TAX
    LDY #$1A
    LDA [ENGINE_FPTR_30[2]],Y
    BEQ L_1F:0B68
    BMI L_1F:0B5B
    SEC
    SBC #$01
    STA [ENGINE_FPTR_30[2]],Y
    CMP #$05
    BCS L_1F:0B68
    LDX #$07
    BCC L_1F:0B68
L_1F:0B5B: ; 1F:0B5B, 0x03EB5B
    PHA
    CLC
    ADC #$01
    STA [ENGINE_FPTR_30[2]],Y
    PLA
    CMP #$FD
    BCS L_1F:0B68
    LDX #$05
L_1F:0B68: ; 1F:0B68, 0x03EB68
    STX ROUTINE_SWITCH_UNK
    JSR INDEX_AND_MODS_NO_SHIFT_UNK
    JMP SWITCH_SWITCH_IDK ; Goto.
SWITCH_SWITCH_SET: ; 1F:0B70, 0x03EB70
    LDA #$88
    STA SCRIPT_UNK_DATA_SELECT_?? ; Set ??
    STA ROUTINE_SWITCH_UNK ; Set ??
SWITCH_SWITCH_IDK: ; 1F:0B76, 0x03EB76
    JSR DATA_INDEX_SWITCH_MOVE_UNK ; Do.
    JSR STREAM_SET_FILE_NOTDONEBUTIDK? ; Do.
    LDA SCRIPT_UNK_DATA_SELECT_?? ; Move ??
    STA ROUTINE_SWITCH_UNK
    JSR ROUTINE_SWITCH_TO_DATA_SLOT_INDEX_X ; Do rtn.
    LDA ACTION_BUTTONS_RESULT ; Move ??
    STA NMI_FLAG_C
    LDA DATA_UNK_A,X ; Move data.
    STA NMI_FP_UNK[2]
    LDA DATA_UNK_B,X
    STA NMI_FP_UNK+1
    RTS ; Leave.
MAP_RTN_I: ; 1F:0B92, 0x03EB92
    JSR L_1F:09CD
    BMI L_1F:0BC0
    LDY #$15
    STA [ENGINE_FPTR_30[2]],Y
    STA ROUTINE_SWITCH_UNK
    JSR INDEX_AND_MODS_NO_SHIFT_UNK
    JSR L_1F:09FA
    BCS L_1F:0BC0
    LDA SCRIPT_FLAG_0x22
    BNE L_1F:0BC4
    LDA #$14
    LDX #$06
    JSR ENGINE_SET_MAPPER_BANK_X_VAL_A
    LDA STREAM_DEEP_C
    STA STREAM_UNK_DEEP_A[2]
    JSR SUB_SEED_UNK_AND_UNK
    LDA SCRIPT_R6_ROUTINE_SELECT
    JSR BANK_HANDLER_R6_AND_BASE
    BIT OBJ_PROCESS_COUNT_LEFT?
    BVS L_1F:0BC4
L_1F:0BC0: ; 1F:0BC0, 0x03EBC0
    LDA #$88
    STA ROUTINE_SWITCH_UNK
L_1F:0BC4: ; 1F:0BC4, 0x03EBC4
    JSR DATA_INDEX_SWITCH_MOVE_UNK
    JMP EXIT_MOVE_FPTR/SAVE_SWITCH?
MAP_RTN_N: ; 1F:0BCA, 0x03EBCA
    JSR L_1F:09CD
    STA ROUTINE_SWITCH_UNK
    BMI L_1F:0BD4
    JSR INDEX_AND_MODS_NO_SHIFT_UNK
L_1F:0BD4: ; 1F:0BD4, 0x03EBD4
    JSR DATA_INDEX_SWITCH_MOVE_UNK
    JSR STREAM_LOAD_STATUS_UNK
    JMP EXIT_MOVE_FPTR/SAVE_SWITCH?
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
LUT_MOD_ARRAY_UNK: ; [4], 1F:0BED, 0x03EBED
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
LUT_INDEX_TO_BITS_0x80-0x01: ; 1F:0C5D, 0x03EC5D
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
    STA SCRIPT_UNK_TESTED[6] ; Set ??
    LDA #$7C
    STA GFX_BANKS[4] ; Set ??
    STA GFX_BANKS+1
    STA GFX_BANKS+2
    STA GFX_BANKS+3
    LDA #$00
    STA LATCH_VAL_ADDL? ; Clear ??
    LDA #$00
    STA ENGINE_FLAG_LATCHY_GFX_FLAGS
    LDX #$09 ; Index ??
MOVE_ALL_POSITIVE: ; 1F:0C94, 0x03EC94
    LDA ROM_DATA_ARR_FUCK,X ; Move ??
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
    JSR L_1E:1977 ; Do ??
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
    JSR ENGINE_SET_MAPPER_BANK_X_VAL_A ; Set it.
    LDA #$00
    STA MMC3_MIRRORING ; Mirroring vert.
    STA NMI_LATCH_FLAG ; Clear latch.
    STA R_**:$0070 ; Clear ??
    STA ENGINE_PACKINATOR_ARG_SEED_0xA0_PRE_COUNT ; Clear.
    STA SOUND_MAIN_SONG_ID ; Clear ??
    STA SCRIPT_UNK_TESTED[6] ; Clear ??
    STA RAM_CODE_UNK[3] ; Clear ??
    PLP ; Pull status, return.
    JMP ENGINE_NMI_0x01_SET/WAIT ; Wait and abuse RTS.
    .db 78 ; GFX Banks.
    .db 00
    .db 7C
    .db 7D
    .db 7E
    .db 7F
ROM_DATA_ARR_FUCK: ; 1F:0CF2, 0x03ECF2
    .db 21 ; File?
    .db ED
    .db 61
    .db ED
    .db 21
    .db ED
    .db 9A
    .db ED
    .db 00
    .db 00
    LDX #$FC ; Seed ??
    BIT **:$04A2 ; Test ??
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle.
    STX NMI_FP_UNK+1 ; Store X to ??
    LDX #$14 ; Seed loops.
X_TIMES_LOOP: ; 1F:0D08, 0x03ED08
    LDA #$01
    STA NMI_FLAG_B ; Set ??
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
    STA NMI_LATCH_FLAG ; Store to latch.
    RTS ; Leave.
    CLC ; Prep add.
    LDA #$02 ; Seed offset.
    ADC LATCH_VAL_ADDL? ; Add with val.
    JSR LIB_WRITE_LATCH ; Store to latch.
    BIT ENGINE_FLAG_LATCHY_GFX_FLAGS ; Test.
    BPL ENGINE_MOVE_MAPPER_GFX_BANKS ; Positive, goto.
BIT_0x40_SET: ; 1F:0D2E, 0x03ED2E
    LDA GFX_BANKS[4] ; Load.
    BPL SKIP_SEED_A ; Positive.
    LDA #$7C ; Seed bank.
SKIP_SEED_A: ; 1F:0D34, 0x03ED34
    STX MMC3_BANK_CFG ; Store CFG.
    STA MMC3_BANK_DATA ; Set bank.
    INX ; GFX swapping ++
    LDA GFX_BANKS+1 ; Load.
    BPL SKIP_SEED_B ; No seed.
    LDA #$7C ; Seed bank.
SKIP_SEED_B: ; 1F:0D41, 0x03ED41
    STX MMC3_BANK_CFG ; Store CFG.
    STA MMC3_BANK_DATA ; Set GFX.
    INX ; GFX CFG++
    LDA GFX_BANKS+2 ; Load bank.
    BPL SKIP_SEED_C ; Positive, keep.
    LDA #$7C ; Seed bank.
SKIP_SEED_C: ; 1F:0D4E, 0x03ED4E
    STX MMC3_BANK_CFG ; Write GFX CFG.
    STA MMC3_BANK_DATA ; Set GFX bank.
    INX ; CFG++
    LDA GFX_BANKS+3 ; Load GFX Bank.
    BPL SKIP_SEED_D ; Keep seed.
    LDA #$7C ; Seed GFX bank.
SKIP_SEED_D: ; 1F:0D5B, 0x03ED5B
    STX MMC3_BANK_CFG ; Set GFX CFG.
    STA MMC3_BANK_DATA ; Set GFX Bank.
    RTS ; Leave.
    SEC ; Prep sub.
    LDA #$23 ; Load val.
    SBC LATCH_VAL_ADDL? ; Sub with.
    ASL A ; << 1, *2.
    JSR LIB_WRITE_LATCH ; Write latch.
    BIT ENGINE_FLAG_LATCHY_GFX_FLAGS ; Test GFX RTN flag.
    BVS BIT_0x40_SET ; If set, do alt rtn.
ENGINE_MOVE_MAPPER_GFX_BANKS: ; 1F:0D6F, 0x03ED6F
    LDA GFX_BANKS[4] ; Load ??
    AND #$7F ; Keep lower.
    STX MMC3_BANK_CFG ; X as CFG.
    STA MMC3_BANK_DATA ; Store A as data.
    INX ; Register++
    LDA GFX_BANKS+1 ; Load ??
    AND #$7F ; Keep lower bits.
    STX MMC3_BANK_CFG ; Store CFG.
    STA MMC3_BANK_DATA ; Set bank with.
    INX ; Register++
    LDA GFX_BANKS+2 ; Load ??
    AND #$7F ; Keep lower bits.
    STX MMC3_BANK_CFG ; Set CFG.
    STA MMC3_BANK_DATA ; Set as data.
    INX ; Register++
    LDA GFX_BANKS+3 ; Load ??
    AND #$7F ; Keep lower bits.
    STX MMC3_BANK_CFG ; Set bank cfg.
    STA MMC3_BANK_DATA ; Set GFX data.
    RTS ; Leave.
    LDA R_**:$0044 ; Move ??
    STA LATCH_VAL_ADDL?
    LDA #$C8 ; Load ??
    JSR LIB_WRITE_LATCH ; Set latch and config.
    STA MMC3_IRQ_DISABLE ; Disable IRQ.
    LDA MAPPER_BANK_VALS+2 ; Load bank.
    STX MMC3_BANK_CFG ; Store CFG.
    STA MMC3_BANK_DATA ; Store as gfx.
    INX ; Config bank++
    LDA MAPPER_BANK_VALS+3 ; Move GFX.
    STX MMC3_BANK_CFG
    STA MMC3_BANK_DATA
    INX
    LDA MAPPER_BANK_VALS+4 ; 3x
    STX MMC3_BANK_CFG
    STA MMC3_BANK_DATA
    INX
    LDA MAPPER_BANK_VALS+5 ; 4x
    STX MMC3_BANK_CFG
    STA MMC3_BANK_DATA
    RTS ; Leave.
    JSR DELAY_Y_0x4 ; Delay.
    LDX #$24 ; Seed TODO: Loopy scroll?
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
    LDA SCRIPT_PALETTE_UPLOADED?[32],X ; Load val.
    SBC #$10 ; Sub with.
    BCS VAL_GTE_0x10 ; GTE.
    LDA #$0F ; Seed black?
VAL_GTE_0x10: ; 1F:0DED, 0x03EDED
    STA SCRIPT_PALETTE_UPLOADED?[32],X ; Store back.
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
    STA SCRIPT_PALETTE_UPLOADED?[32],X ; Store to palette.
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
    STA SCRIPT_PALETTE_UPLOADED?[32],X ; Store color first index of slot.
    DEX ; Slot finished.
    BPL PALETTE_POSITIVE ; Positive, goto.
    JMP CREATE_PALETTE_UPLOAD_PACKET_0x1_WAIT ; Goto.
PALETTE_TO_COLOR_A_AND_FORWARDED: ; 1F:0E21, 0x03EE21
    PHA ; Save A.
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle.
    PLA ; Pull A.
    LDX #$1F ; Index.
WRITE_ALL_PALETTE: ; 1F:0E28, 0x03EE28
    STA SCRIPT_PALETTE_TARGET/ALT?[32],X ; Set color.
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
    LDA SCRIPT_PALETTE_UPLOADED?[32],X ; Load palette.
    SBC SCRIPT_PALETTE_TARGET/ALT?[32],X ; Get target diff.
    BEQ TARGET_REACHED ; ==, goto.
    AND #$0F ; Keep lower bits only.
    BNE STEP_LOWER_NIBBLE_DIFFERS ; Lower nibble bits set, handle special.
    BCS DARKEN_TO_TARGET ; No overflow on sub, goto. Darken.
    LDA SCRIPT_PALETTE_UPLOADED?[32],X ; Load script.
    ADC #$10 ; Add brightness.
    BPL COLOR_OUTPUT ; Always taken, output.
STEP_LOWER_NIBBLE_DIFFERS: ; 1F:0E4D, 0x03EE4D
    LDA SCRIPT_PALETTE_TARGET/ALT?[32],X ; Load target.
    AND #$0F ; Keep the hue only.
    CMP #$0D ; If _ #$0D. 0xD-0xF for blacks/greys, so excluded from hue mod.
    BCC ASSIGN_HUE_BITS_TO_TARGET_WANTED ; <, goto.
DARKEN_TO_TARGET: ; 1F:0E56, 0x03EE56
    LDA SCRIPT_PALETTE_UPLOADED?[32],X ; Load color.
    SBC #$10 ; Mod brightness step down.
    BCS COLOR_OUTPUT ; No underflow, output.
    LDA #$0F ; Seed black.
    BPL COLOR_OUTPUT ; Always taken, seeded.
ASSIGN_HUE_BITS_TO_TARGET_WANTED: ; 1F:0E61, 0x03EE61
    PHA ; Save hue passed.
    LDA SCRIPT_PALETTE_UPLOADED?[32],X ; Load script.
    AND #$30 ; Keep brightness bits.
    STA SCRIPT_PALETTE_UPLOADED?[32],X ; Store result.
    PLA ; Pull hue bits.
    ORA SCRIPT_PALETTE_UPLOADED?[32],X ; Combine with brightness.
COLOR_OUTPUT: ; 1F:0E6E, 0x03EE6E
    STA SCRIPT_PALETTE_UPLOADED?[32],X ; Store color decided.
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
    LDA SCRIPT_PALETTE_TARGET/ALT?[32],X ; Load script.
    STA SCRIPT_PALETTE_UPLOADED?[32],X ; To upload.
    DEX ; Index++
    BPL LOOP_ALL_INDEXES ; Positive, do more.
    RTS ; Leave.
ENGINE_PALETTE_SCRIPT_TO_TARGET: ; 1F:0E8E, 0x03EE8E
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle.
    LDX #$1F ; Index.
INDEX_POSITIVE: ; 1F:0E93, 0x03EE93
    LDA SCRIPT_PALETTE_UPLOADED?[32],X ; Load from index.
    STA SCRIPT_PALETTE_TARGET/ALT?[32],X ; Store to other arr.
    DEX ; Index--
    BPL INDEX_POSITIVE ; Positive, loop.
    RTS
ENGINE_SETTLE_AND_PALETTE_FROM_PTR: ; 1F:0E9D, 0x03EE9D
    STA MISC_USE_A ; Init FPTR.
    STX MISC_USE_B
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle.
    LDY #$1F ; Index.
COUNT_POSITIVE: ; 1F:0EA6, 0x03EEA6
    LDA [MISC_USE_A],Y ; From index.
    STA SCRIPT_PALETTE_UPLOADED?[32],Y ; To script palette.
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
    STA NMI_FLAG_B ; Set flag.
    JMP ENGINE_DELAY_X_FRAMES ; Goto.
ENGINE_SETTLE_EXTENDED_0x2000_SCREEN: ; 1F:0EC8, 0x03EEC8
    LDX #$00 ; Seed scroll.
    LDY #$00
ENGINE_HELPER_SETTLE_CLEAR_LATCH_SET_SCROLL_TODO_MORE: ; 1F:0ECC, 0x03EECC
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle updates.
    LDA #$00
    STA NMI_FP_UNK[2] ; Clear ptr.
    STA NMI_FP_UNK+1
    STA NMI_LATCH_FLAG ; Clear flag.
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
    STA MISC_USE_A ; Store val.
    ASL MISC_USE_A ; Shift it.
    BCC RTS ; CC, leave.
    JSR ADDS_IDFK ; Adds ??
    AND #$C0 ; Keep 1100.0000
    BNE RTS ; Nonzero, leave.
    JSR ENGINE_PALETTE_SCRIPT_TO_TARGET ; Do.
    JSR ENGINE_PALETTE_FADE_SKIP_INDEX_0xE? ; Do ??
    LDX #$0A ; Seed ??
LOOP_X_TIMES: ; 1F:0F0C, 0x03EF0C
    LDA #$07 ; Seed ??
    STA SND_CODE_HELPER_ARR ; Set ??
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
    LDA SCRIPT_PALETTE_UPLOADED?[32],X ; Load from palette.
    SBC #$10 ; Color--
    BCS PALETTE_COLOR_NO_UNDERFLOW ; No underflow, goto.
L_1F:0F29: ; 1F:0F29, 0x03EF29
    LDA #$0F ; Seed black.
PALETTE_COLOR_NO_UNDERFLOW: ; 1F:0F2B, 0x03EF2B
    STA SCRIPT_PALETTE_UPLOADED?[32],X ; Store color.
INDEX_SKIP: ; 1F:0F2E, 0x03EF2E
    DEX ; Index--
    BPL VAL_POSITIVE_LOOP ; Positive, goto.
    JMP CREATE_PALETTE_UPLOAD_PACKET_0x1_WAIT ; Upload palette.
ENGINE_MENU_HELPER_BEGIN?: ; 1F:0F34, 0x03EF34
    LDY #$08 ; Stream index.
    LDA [FPTR_SPRITES?[2]],Y ; Load from file.
    STA FPTR_UNK_84_MENU?[2] ; Store to.
    INY ; Stream++
    LDA [FPTR_SPRITES?[2]],Y ; Load from file.
    STA FPTR_UNK_84_MENU?+1 ; Store to.
    LDY #$06 ; Stream index.
    LDA [FPTR_SPRITES?[2]],Y ; Load from file.
    STA PACKET_HPOS_COORD? ; Store to.
    LDY #$07 ; Stream index.
    LDA [FPTR_SPRITES?[2]],Y ; Load from file.
    STA PACKET_YPOS_COORD? ; Store to.
STREAM_AND_CONVERT_IDFK: ; 1F:0F4B, 0x03EF4B
    LDY #$00 ; Stream reset.
    LDA [FPTR_SPRITES?[2]],Y ; Load from stream.
    STA STREAM_TARGET? ; Set ??
    TAX ; Val to X.
    LDY #$01 ; Stream set.
    LDA [FPTR_SPRITES?[2]],Y ; Load from stream.
    JSR ENGINE_NUMS_IDFK ; Do ??
    STA FPTR_UNK_84_MENU_SELECTION?[2] ; Store result.
    LDY #$00 ; Stream set.
    STY CARRY_UP? ; Clear ??
LOOP_LT_TARGET: ; 1F:0F5F, 0x03EF5F
    LDA [FPTR_UNK_84_MENU?[2]],Y ; Load from stream.
    BNE STREAM_NONZERO ; Nonzero, goto.
    INY ; Stream++
    CPY FPTR_UNK_84_MENU_SELECTION?[2] ; If _ var
    BCC LOOP_LT_TARGET ; <, do more.
    STA FPTR_UNK_84_MENU_SELECTION?[2] ; Clear ??
    STA MENU_HELPER_STATUS?
    RTS ; Leave.
STREAM_NONZERO: ; 1F:0F6D, 0x03EF6D
    STY FPTR_UNK_84_MENU_SELECTION?[2] ; Stream to.
    TYA ; Stream to A.
TARGET_MET: ; 1F:0F70, 0x03EF70
    CMP STREAM_TARGET? ; If _ var
    BCC VAL_LT_TARGET ; <, goto.
    SBC STREAM_TARGET? ; Sub with val.
    INC CARRY_UP? ; ++ ??
    BCS TARGET_MET ; Always taken.
VAL_LT_TARGET: ; 1F:0F7A, 0x03EF7A
    STA STREAM_TARGET? ; Store val.
SETTLE_AND_SPRITES_TO_COORD?_IDFK: ; 1F:0F7C, 0x03EF7C
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle.
    LDY #$18 ; Seed wait.
    STY SAVE_GAME_MOD_PAGE_PTR+1
    LDA #$00
    STA SPRITE_PAGE+2 ; Clear attrs.
TABLE_NEGATIVE: ; 1F:0F88, 0x03EF88
    LDY #$05 ; Stream index.
    LDA [FPTR_SPRITES?[2]],Y ; Load from stream.
    STA SPRITE_PAGE+1 ; Store to tile.
    LDY #$02 ; Stream index.
    LDA [FPTR_SPRITES?[2]],Y ; Load from stream.
    LDX STREAM_TARGET? ; Load index?
    JSR ENGINE_NUMS_IDFK ; Do ??
    CLC ; Prep add.
    ADC PACKET_HPOS_COORD? ; Add with.
    ASL A ; << 3, *8.
    ASL A
    ASL A
    STA SPRITE_PAGE+3 ; Store to X, tile aligned.
    LDY #$03 ; Stream index.
    LDA [FPTR_SPRITES?[2]],Y ; Load from stream.
    LDX CARRY_UP? ; Load.
    JSR ENGINE_NUMS_IDFK ; Do.
    CLC ; Prep add.
    ADC PACKET_YPOS_COORD? ; Add with.
    ASL A ; << 3, *8.
    ASL A
    ASL A
    CLC ; Prep add.
    ADC #$07 ; Add with. TODO: Why?
    STA SPRITE_PAGE[256] ; Store to Ypos.
    LDY SAVE_GAME_MOD_PAGE_PTR+1 ; Load ??
LOOP_CTRL_CHECK: ; 1F:0FB8, 0x03EFB8
    LDX #$00
    STX CONTROL_ACCUMULATED?[2] ; Clear buttons.
Y_LOOPS_CHECK: ; 1F:0FBC, 0x03EFBC
    JSR ADDS_IDFK ; Do ??
    JSR ENGINE_NMI_0x01_SET/WAIT ; Settle.
    LDA CONTROL_ACCUMULATED?[2] ; Load.
    BNE CONTROLS_PRESSED ; != 0, goto.
    DEY ; Y--
    BNE Y_LOOPS_CHECK ; != 0, goto.
    LDY #$05 ; Load stream index.
    LDA [FPTR_SPRITES?[2]],Y ; Load from stream.
    EOR SPRITE_PAGE+1 ; Invert with tile.
    STA SPRITE_PAGE+1 ; Store new tile.
    LDA CTRL_BUTTONS_PREVIOUS[2] ; Load.
    BNE BUTTONS_PREVIOUSLY_PRESSED ; Prev set, goto.
    LDY #$18 ; Reseed wait.
    STY SAVE_GAME_MOD_PAGE_PTR+1
    BNE LOOP_CTRL_CHECK ; Always taken.
BUTTONS_PREVIOUSLY_PRESSED: ; 1F:0FDD, 0x03EFDD
    LDY #$06
    STY SAVE_GAME_MOD_PAGE_PTR+1 ; Reseed check wait.
CONTROLS_PRESSED: ; 1F:0FE1, 0x03EFE1
    LDX #$00
    STX CONTROL_ACCUMULATED?[2] ; Clear buttons.
    TAX ; Buttons to X.
    LDY #$04 ; File index.
    AND #$F0 ; Keep upper.
    AND [FPTR_SPRITES?[2]],Y ; And from file.
    BEQ AND_RESULT_0x00 ; == 0, goto.
    STA MENU_HELPER_STATUS? ; Store nonzero.
    LDA #$05
    STA R_**:$07F1 ; Set ??
EXIT_OFF_SCREEN: ; 1F:0FF5, 0x03EFF5
    LDA #$F0
    STA SPRITE_PAGE[256] ; Set Y pos offscreen.
    RTS ; Leave.
AND_RESULT_0x00: ; 1F:0FFB, 0x03EFFB
    TXA ; Buttons to A.
    AND #$0F ; Test 
    STA MENU_HELPER_STATUS? ; Keep U/D/L/R.
    TAY ; To Y.
    LDX BUTTON_TABLE,Y ; Load from table.
    BMI TABLE_NEGATIVE ; Negative, goto.
    LDA STREAM_TARGET? ; Move ??
    STA ARR_BITS_TO_UNK[8]
    LDA CARRY_UP?
    STA ARR_BITS_TO_UNK+1 ; Move ??
    STX ARR_BITS_TO_UNK+3 ; Val loaded to.
LOOP_IDK: ; 1F:1010, 0x03F010
    CLC ; Prep add.
    LDA CARRY_ADD_UNK,X ; Load.
    ADC ARR_BITS_TO_UNK+1 ; Add with.
    LDY #$01 ; Stream index.
    CMP [FPTR_SPRITES?[2]],Y ; If _ stream
    BCS VAL_GTE_STREAM ; >=, goto.
    STA ARR_BITS_TO_UNK+1 ; <, store.
    STA MISC_USE_A
    CLC ; Prep add.
    LDA ARR_UNK,X ; Load from arr.
    ADC ARR_BITS_TO_UNK[8] ; Add with.
    LDY #$00 ; Stream.
    CMP [FPTR_SPRITES?[2]],Y ; If _ stream
    BCS VAL_GTE_STREAM ; >=, goto.
    STA ARR_BITS_TO_UNK[8] ; Store result from add.
    STA ARR_BITS_TO_UNK+2
    LDA [FPTR_SPRITES?[2]],Y ; Load from FPTR.
    LDX MISC_USE_A ; X from.
    JSR ENGINE_NUMS_IDFK ; Do.
    CLC ; Prep add.
    ADC ARR_BITS_TO_UNK+2 ; Add with.
    STA ARR_BITS_TO_UNK+2 ; Store result.
    TAY ; To Y index.
    LDA [FPTR_UNK_84_MENU?[2]],Y ; Load at index.
    BEQ VAL_EQ_0x00 ; == 0, goto.
    LDA ARR_BITS_TO_UNK[8] ; Move ??
    STA STREAM_TARGET?
    LDA ARR_BITS_TO_UNK+1 ; Move ??
    STA CARRY_UP?
    LDA ARR_BITS_TO_UNK+2 ; Move ??
    STA FPTR_UNK_84_MENU_SELECTION?[2]
    LDA #$0D ; Seed ??
    STA R_**:$07F1
RELOOP: ; 1F:1052, 0x03F052
    JMP TABLE_NEGATIVE ; Goto.
VAL_GTE_STREAM: ; 1F:1055, 0x03F055
    LDY #$04 ; Stream index.
    LDA MENU_HELPER_STATUS? ; Load.
    AND [FPTR_SPRITES?[2]],Y ; And with arr.
    BEQ RELOOP ; == 0, goto.
    STA MENU_HELPER_STATUS? ; Store bits.
    LDA #$0D
    STA R_**:$07F1 ; Seed ??
    JMP EXIT_OFF_SCREEN
VAL_EQ_0x00: ; 1F:1067, 0x03F067
    LDX ARR_BITS_TO_UNK+3 ; X from.
    LDY #$01 ; Val ??
    LDA R_**:$00D6 ; Load.
    BEQ LOADED_EQ_0x00_A
    INX ; Index++
    DEY ; Y--
LOADED_EQ_0x00_A: ; 1F:1071, 0x03F071
    LDA ARR_UNK,X ; Load from index.
    BEQ LOADED_EQ_0x00_B ; == 0, goto.
LOOP_NONZERO: ; 1F:1076, 0x03F076
    STA ARR_BITS_TO_UNK+2 ; Store ??
    SEC ; Prep sub.
    LDA ARR_BITS_TO_UNK[8],Y ; Load from arr.
    SBC STREAM_TARGET?,Y ; Sub with.
    EOR #$FF ; Invert.
    BPL INVERT_POSITIVE ; Positive, goto.
    CLC ; Prep add.
    ADC STREAM_TARGET?,Y ; Add with.
    STA ARR_BITS_TO_UNK[8],Y ; Store to.
    BPL ADD_RESULT_POSITIVE ; Positive, goto.
    BMI ADD_RESULT_NEGATIVE ; Negative, goto.
INVERT_POSITIVE: ; 1F:108E, 0x03F08E
    SEC ; Prep add +1
    ADC STREAM_TARGET?,Y ; Add with.
    STA ARR_BITS_TO_UNK[8],Y ; Store to.
    CMP [FPTR_SPRITES?[2]],Y ; If _ stream
    BCC ADD_RESULT_POSITIVE ; <, goto.
ADD_RESULT_NEGATIVE: ; 1F:1099, 0x03F099
    LDA #$00 ; Seed ??
    CMP ARR_BITS_TO_UNK+2 ; If _ var
    BNE LOOP_NONZERO ; != 0, goto.
    BEQ VAL_GTE_STREAM ; == 0, goto.
ADD_RESULT_POSITIVE: ; 1F:10A1, 0x03F0A1
    TYA ; Y to A.
    EOR #$01 ; Invert.
    TAY ; Back to Y.
    LDA STREAM_TARGET?,Y ; Load.
    STA ARR_BITS_TO_UNK[8],Y ; Store to.
LOADED_EQ_0x00_B: ; 1F:10AB, 0x03F0AB
    LDX ARR_BITS_TO_UNK+3 ; Load ??
    JMP LOOP_IDK ; Goto.
ENGINE_POS_TO_UPDATE_UNK: ; 1F:10B0, 0x03F0B0
    PHA ; Save A.
    LDY #$02 ; Stream index.
    LDA [FPTR_SPRITES?[2]],Y ; Load from stream.
    LDX STREAM_TARGET? ; Load index.
    JSR ENGINE_NUMS_IDFK ; Do.
    CLC ; Prep add.
    ADC PACKET_HPOS_COORD? ; Add with.
    STA PACKET_HPOS_COORD? ; Store to.
    LDY #$03 ; Stream index.
    LDA [FPTR_SPRITES?[2]],Y ; Load from file.
    LDX CARRY_UP? ; Load ??
    JSR ENGINE_NUMS_IDFK ; Do.
    CLC ; Prep add.
    ADC PACKET_YPOS_COORD? ; Add Y coord.
    STA PACKET_YPOS_COORD? ; Store result.
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
BUTTON_TABLE: ; 1F:10D9, 0x03F0D9
    .db 88 ; 0x00, None pressed.
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
ARR_UNK: ; 1F:10E9, 0x03F0E9
    .db 00
CARRY_ADD_UNK: ; 1F:10EA, 0x03F0EA
    .db FF
    .db 01
    .db 00
    .db 00
    .db 01
    .db FF
    .db 00
LIB_DECIMAL?_UNK: ; 1F:10F1, 0x03F0F1
    LDA #$00 ; Init clear.
    LDX #$10 ; Bits to check count.
VAL_NONZERO: ; 1F:10F5, 0x03F0F5
    ROR MISC_USE_B ; Rotate bits.
    ROR MISC_USE_A
    BCC ROTATE_CC
    CLC ; Prep add.
    ADC SAVE_GAME_MOD_PAGE_PTR[2] ; Add val.
ROTATE_CC: ; 1F:10FE, 0x03F0FE
    ROR A ; Rotate into A.
    DEX ; Count--
    BNE VAL_NONZERO ; != 0, goto.
    STA MISC_USE_C ; Store val.
    ROR MISC_USE_B ; Rotate bits.
    ROR MISC_USE_A
    RTS ; Return.
LIB_DECIMAL?_UNK: ; 1F:1109, 0x03F109
    LDA #$00 ; Clear init.
    LDX #$18 ; Bits to check count.
VAL_NONZERO: ; 1F:110D, 0x03F10D
    ROR MISC_USE_C ; Rotate bits.
    ROR MISC_USE_B
    ROR MISC_USE_A
    BCC ROTATE_CLEAR ; Clear, rotate.
    CLC ; Prep add.
    ADC SAVE_GAME_MOD_PAGE_PTR[2] ; Add val.
ROTATE_CLEAR: ; 1F:1118, 0x03F118
    ROR A ; Rotate into A.
    DEX ; Loops--
    BNE VAL_NONZERO ; != 0, goto.
    STA MISC_USE_D/DECIMAL_POS? ; Store result.
    ROR MISC_USE_C ; Rotate all bits.
    ROR MISC_USE_B
    ROR MISC_USE_A
    RTS ; Leave.
ENGINE_NUMS_IDFK: ; 1F:1125, 0x03F125
    STA MISC_USE_A ; Store bits.
    STX SAVE_GAME_MOD_PAGE_PTR[2] ; Store stride?
    LDA #$00 ; Seed ??
    LDX #$08 ; Loop count.
LOOPS_NONZERO: ; 1F:112D, 0x03F12D
    ROR MISC_USE_A
    BCC ROTATE_CLEAR ; Clear, goto.
    CLC ; Prep add.
    ADC SAVE_GAME_MOD_PAGE_PTR[2] ; Add with.
ROTATE_CLEAR: ; 1F:1134, 0x03F134
    ROR A ; Carry into A.
    DEX ; Loops--
    BNE LOOPS_NONZERO ; != 0, goto.
    TAX ; Val to X.
    LDA MISC_USE_A ; Load.
    ROR A ; Rotate into A.
    RTS ; Leave.
ENGINE_NUMS_UNK_MODULO?: ; 1F:113D, 0x03F13D
    LDA SAVE_GAME_MOD_PAGE_PTR[2] ; Load.
ENGINE_HOLD_FOREVER_IF_ZERO: ; 1F:113F, 0x03F13F
    BEQ ENGINE_HOLD_FOREVER_IF_ZERO ; == 0, loop forever.
    LDA #$00 ; Init.
    LDX #$18 ; Bits count.
    ROL MISC_USE_A ; Rotate bits.
    ROL MISC_USE_B
    ROL MISC_USE_C
PROCESS_WHOLE_NUMBER: ; 1F:114B, 0x03F14B
    ROL A ; Into A.
    BCS ROTATE_CS ; CS, goto.
    CMP SAVE_GAME_MOD_PAGE_PTR[2] ; If _ val
    BCC VAL_LT_VAR ; <, goto.
ROTATE_CS: ; 1F:1152, 0x03F152
    SBC SAVE_GAME_MOD_PAGE_PTR[2] ; Sub with.
    SEC ; Bring in 0x1
VAL_LT_VAR: ; 1F:1155, 0x03F155
    ROL MISC_USE_A ; Rotate up.
    ROL MISC_USE_B
    ROL MISC_USE_C
    DEX ; X--
    BNE PROCESS_WHOLE_NUMBER ; !=, goto.
    STA ARR_BITS_TO_UNK[8] ; Store result.
    RTS ; Leave.
ENGINE_24BIT_TO_TEXT: ; 1F:1161, 0x03F161
    LDY #$08 ; Index output beginning for numbers.
LOOP_FIGURE_NEXT_DIGIT: ; 1F:1163, 0x03F163
    DEY ; Index--
    LDA #$00 ; Seed ??
    LDX #$18 ; Count for all bits.
    ROL MISC_USE_A ; Rotate to begin.
    ROL MISC_USE_B
    ROL MISC_USE_C
TODO_COUNT: ; 1F:116E, 0x03F16E
    ROL A ; ...into A.
    CMP #$0A ; If _ #$0A
    BCC VAL_IN_DECIMAL_RANGE ; <, goto, 0 back in.
    SBC #$0A ; Adjust. CS after, still.
VAL_IN_DECIMAL_RANGE: ; 1F:1175, 0x03F175
    ROL MISC_USE_A ; Rotate again. CC in if no overflow. CS otherwise.
    ROL MISC_USE_B
    ROL MISC_USE_C
    DEX ; Loops--
    BNE TODO_COUNT ; != 0, loop.
    TAX ; Val to X.
    LDA LUT_NUMBER_TILES,X ; Move ??
    STA ARR_BITS_TO_UNK[8],Y ; Store to, number output.
    LDA MISC_USE_A ; Combine all.
    ORA MISC_USE_B
    ORA MISC_USE_C
    BNE LOOP_FIGURE_NEXT_DIGIT ; More to do since bits left, do.
    STY MISC_USE_D/DECIMAL_POS? ; Index to.
    LDA #$A0 ; Seed blank tile.
    BNE SEED_BLANKS ; Always taken.
CLEAR_OTHERS: ; 1F:1193, 0x03F193
    STA ARR_BITS_TO_UNK[8],Y ; Store val.
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
LUT_UNK: ; 1F:11A4, 0x03F1A4
    .db A0
    .db 00
    .db 84
    .db 60
    .db 84
    .db 61
    .db 84
    .db 62
    .db F0
    .db 18
ENGINE_DEC_TO_BIN24: ; 1F:11AE, 0x03F1AE
    LDA #$00 ; Init. Y needs to be set to highest digit here.
    LDX #$18 ; Bit count.
LOOP_MORE_BITS: ; 1F:11B2, 0x03F1B2
    ROR MISC_USE_C ; Rotate bits.
    ROR MISC_USE_B
    ROR MISC_USE_A
    BCC ROTATE_CC ; CC, goto.
    ADC #$09 ; Add 0xA, CS here. CC after.
ROTATE_CC: ; 1F:11BC, 0x03F1BC
    ROR A ; Rotate result.
    DEX ; Count--
    BNE LOOP_MORE_BITS ; != 0, do more.
    ROR MISC_USE_C ; Rotate bits.
    ROR MISC_USE_B
    ROR MISC_USE_A
    LDA ARR_BITS_TO_UNK[8],Y ; Load from array.
    CMP #$BA ; If _ '00 cents'
    BCS ADD_VAL_TO_BITS ; >=, goto.
    CMP #$B0 ; If _ '0'
    BCC ADD_VAL_TO_BITS ; <, goto.
    SBC #$B0 ; Subtract to get base value.
    .db 2C ; BIT $00A9, BIT trick?
ADD_VAL_TO_BITS: ; 1F:11D4, 0x03F1D4
    LDA #$00 ; Seed 0x00
    CLC ; Prep add.
    ADC MISC_USE_A ; Add with.
    STA MISC_USE_A ; Store to.
    LDA #$00
    ADC MISC_USE_B ; Carry add.
    STA MISC_USE_B ; Store result.
    LDA #$00
    ADC MISC_USE_C ; Carry add.
    STA MISC_USE_C
    INY ; Digit++
    CPY #$08 ; If _ #$08
    BCC ENGINE_DEC_TO_BIN24 ; <, goto.
    RTS ; Leave.
ADDS_IDFK: ; 1F:11ED, 0x03F1ED
    CLC ; Prep add.
    LDA R_**:$0026 ; Load.
    ADC R_**:$0027 ; Add with.
    STA R_**:$0027 ; Store to.
    CLC ; Prep add.
    LDA R_**:$0026 ; Load.
    ADC #$75 ; Add with.
    STA R_**:$0026 ; Store to.
    LDA R_**:$0027 ; Load.
    ADC #$63 ; Add with.
    STA R_**:$0027 ; Store to.
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
    JSR LIB_COMPARED_OVERWRITE_IF_MISMATCH ; Do overwrite if mismatch.
    JSR ENGINE_HELPER_R6_0x14 ; Goto ??
    JSR SCREEN_TRANSITIONER ; Do ??
    JSR ENGINE_SET_MAPPER_R6_TO_0x16 ; Map.
    JSR SETTLE_SPRITES_OFFSCREEN/CLEAR_RAM ; Do.
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
    JSR ENGINE_SET_MAPPER_BANK_X_VAL_A ; Set mapper.
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
    JSR ENGINE_SET_MAPPER_BANK_X_VAL_A ; Set mapper.
    PLA
    TAX
    PLA
    RTS
LIB_COMPARED_OVERWRITE_IF_MISMATCH: ; 1F:1255, 0x03F255
    CMP SOUND_VAL_CMP_UNK ; If _ val
    BEQ VAL_CMP_EQ ; ==, goto.
    STA VAL_CMP_DIFFERS_STORED_UNK ; Store if differs.
VAL_CMP_EQ: ; 1F:125D, 0x03F25D
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
    STA MISC_USE_A
    PLA
    STA MISC_USE_B
    LDA [MISC_USE_A],Y ; Load from JSR file.
    STA MISC_USE_C ; Store to call.
    INY ; Stream++
    LDA [MISC_USE_A],Y ; Load from file.
    STA MISC_USE_D/DECIMAL_POS? ; Call H.
    LDY #$01 ; Reseed into first ptr.
    SEC ; Prep sub for RTS fix to Addr-0x1
    LDA [MISC_USE_A],Y ; Load from header, RTS PTR L.
    SBC #$01 ; -= 0x1
    TAX ; Save to X.
    INY ; Stream++
    LDA [MISC_USE_A],Y ; Load from file, RTS PTR H.
    SBC #$00 ; Carry sub.
    PHA ; Save back to stack.
    TXA ; Save lower.
    PHA
    JMP [MISC_USE_C] ; Run main routine.
RESTORE_FPTR_AND_CALL_FROM_FILE: ; 1F:12D5, 0x03F2D5
    ASL A ; << 1, *2.
    TAY ; To Y.
    INY ; Offset ??
    PLA ; Restore fptr from stack.
    STA MISC_USE_A
    PLA
    STA MISC_USE_B
    SEC ; Prep sub.
    LDA [MISC_USE_A],Y ; Load from file.
    SBC #$01 ; Sub for RTS offset.
    TAX ; To X.
    INY ; Stream++
    LDA [MISC_USE_A],Y ; Load PTR H.
    SBC #$00 ; Carry sub.
    PHA ; Save addr loaded.
    TXA
    PHA
    RTS ; Run it.
SUB_DECIMAL_STATS_THINGY?: ; 1F:12ED, 0x03F2ED
    PHA ; Save A,X,Y.
    TXA
    PHA
    TYA
    PHA
    LDA MISC_USE_D/DECIMAL_POS? ; Save.
    PHA
    LDA MISC_USE_C ; Save.
    PHA
    LDA SAVE_GAME_MOD_PAGE_PTR+1 ; Save.
    PHA
    LDA SAVE_GAME_MOD_PAGE_PTR[2] ; Save.
    PHA
    LDA ARR_BITS_TO_UNK+1 ; Save.
    PHA
    LDA ARR_BITS_TO_UNK[8] ; Save.
    PHA
    LDA MISC_USE_B ; Load ??
    AND #$FC ; Keep 1111.1100
    PHA ; Save.
    LDX #$06 ; Seed iterations.
LOOP_ROTATE: ; 1F:130B, 0x03F30B
    ASL MISC_USE_A ; << 1
    ROL MISC_USE_B ; Roll into.
    DEX ; Count--
    BNE LOOP_ROTATE ; != 0, loop.
    STX MISC_USE_C ; Clear.
    TXA ; Clear A.
    PHA
    LDA MISC_USE_B ; Save shifty.
    PHA
    LDA MISC_USE_A
    PHA
    LDA #$64
    STA SAVE_GAME_MOD_PAGE_PTR[2] ; Seed PTR L.
    JSR ENGINE_NUMS_UNK_MODULO? ; Do numbers.
    JSR ADDS_IDFK ; Do adds.
    LSR A ; A >> 1
    PHP ; Save status.
    TAX ; To X index.
    LDA ROM_TABLE_UNK,X ; Move ??
    STA SAVE_GAME_MOD_PAGE_PTR[2]
    JSR LIB_DECIMAL?_UNK ; Do 
    PLP ; Pull status.
    BCS DO_SUBS_ROUTINE ; CS, goto.
    PLA ; Pull value.
    ADC MISC_USE_A ; Add with.
    STA MISC_USE_A ; Store result.
    PLA ; Pull value.
    ADC MISC_USE_B ; Add with.
    STA MISC_USE_B ; Store result.
    PLA ; Pull value.
    ADC MISC_USE_C ; Add with.
    STA MISC_USE_C ; Store result.
    JMP SHIFTY_BACK_UNK ; Goto.
DO_SUBS_ROUTINE: ; 1F:1346, 0x03F346
    PLA ; Pull value.
    SBC MISC_USE_A ; Sub with.
    STA MISC_USE_A ; Store to.
    PLA ; Pull value.
    SBC MISC_USE_B ; Sub with.
    STA MISC_USE_B ; Store to.
    PLA ; Pull value.
    SBC MISC_USE_C ; Sub with.
    STA MISC_USE_C ; Store to.
SHIFTY_BACK_UNK: ; 1F:1355, 0x03F355
    LDX #$06 ; Iterations.
LOOP_SHIFT: ; 1F:1357, 0x03F357
    LSR MISC_USE_C ; Shift.
    ROR MISC_USE_B ; Rotate into.
    ROR MISC_USE_A ; 2x
    DEX ; Count--
    BNE LOOP_SHIFT ; != 0, do more.
    PLA ; Pull stack.
    ORA MISC_USE_B ; Combine with.
    STA MISC_USE_B ; Store to.
    PLA ; Stack to.
    STA ARR_BITS_TO_UNK[8]
    PLA ; 2x
    STA ARR_BITS_TO_UNK+1
    PLA ; 3x
    STA SAVE_GAME_MOD_PAGE_PTR[2]
    PLA ; 4x
    STA SAVE_GAME_MOD_PAGE_PTR+1
    PLA ; 5x
    STA MISC_USE_C
    PLA ; 6x
    STA MISC_USE_D/DECIMAL_POS?
    PLA ; Restore Y.
    TAY
    PLA
    TAX ; Restore X.
    PLA ; Restore A.
    RTS ; Leave.
ROM_TABLE_UNK: ; 1F:137D, 0x03F37D
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
    LDA MISC_USE_B ; Move to stack.
    PHA
    LDA MISC_USE_A
    PHA
    STX MISC_USE_A ; X to.
    LDA #$00
    STA MISC_USE_B ; Clear ??
    JSR SUB_DECIMAL_STATS_THINGY? ; Do ??
    LDA MISC_USE_B ; Load ??
    BEQ VAL_EQ_0x00 ; == 0, goto.
    LDA #$FF
    STA MISC_USE_A ; Set ??
VAL_EQ_0x00: ; 1F:1415, 0x03F415
    LDX MISC_USE_A ; Load ??
    PLA
    STA MISC_USE_A ; Restore old.
    PLA
    STA MISC_USE_B
    TXA ; X to A.
    RTS ; Leave.
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
    STA SND_CODE_HELPER_ARR
    JMP ENTRY_PAST ; Past.
SWITCH_NONZERO?: ; 1F:143E, 0x03F43E
    CMP #$01 ; If _ #$01
    BNE SWITCH_NE_0x1 ; != 0, goto.
    LDA SAVE_GAME_MOD_PAGE_PTR+1 ; Move ??
    STA R_**:$07F1
    JMP ENTRY_PAST ; Past.
SWITCH_NE_0x1: ; 1F:144A, 0x03F44A
    CMP #$02 ; If _ #$02
    BNE SWITCH_NE_0x2 ; != 0, goto.
    LDA SAVE_GAME_MOD_PAGE_PTR+1 ; Move ??
    STA R_**:$07F3
    JMP ENTRY_PAST ; Past.
SWITCH_NE_0x2: ; 1F:1456, 0x03F456
    LDA SAVE_GAME_MOD_PAGE_PTR+1 ; Move ??
    STA R_**:$07F4
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
    STA R_**:$07F1 ; Set ??
    LDX #$02 ; Wait.
    JSR ENGINE_WAIT_X_SETTLES
    PLA ; Pull obj.
    TAX
    DEX ; Obj--
    BNE LOOP_OBJECTS ; != 0, loop.
    RTS ; Leave.
LIB_VAL_TO_DECIMAL_AND_FILE?: ; 1F:1479, 0x03F479
    LDA SOUND_MAIN_SONG_ID ; Val ??
    STA MISC_USE_A ; Move.
    LDA #$00
    STA MISC_USE_B ; Clear bits upper.
    LDA #$0A
    STA SAVE_GAME_MOD_PAGE_PTR[2] ; Val inc.
    JSR LIB_DECIMAL?_UNK ; Do ??
    CLC
    LDA #$98 ; Load ??
    ADC MISC_USE_A ; Add with.
    STA FPTR_5C_UNK[2] ; Store result.
    LDA #$8F ; Load.
    ADC MISC_USE_B ; Add ??
    STA FPTR_5C_UNK+1 ; Store result.
    RTS ; Leave.Leave.
ENGINE_SET_PALETTE_AND_QUEUE_UPLOAD: ; 1F:1496, 0x03F496
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle.
    LDY #$1F ; Index.
STREAM_POSITIVE: ; 1F:149B, 0x03F49B
    LDA [MISC_USE_A],Y ; Load from stream.
    STA SCRIPT_PALETTE_UPLOADED?[32],Y ; Store to arr.
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
    STA NMI_FLAG_B ; Set flag.
    RTS ; Leave.
PALETTE_MOD_TO_BLACK: ; 1F:14B6, 0x03F4B6
    LDA #$0F ; Val ??
PALETTE_MOD_BG_COLOR_TO_A: ; 1F:14B8, 0x03F4B8
    PHA ; Save value.
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle.
    PLA ; Pull val.
    LDY #$1C ; Stream index BG color.
INDEX_POSITIVE: ; 1F:14BF, 0x03F4BF
    STA SCRIPT_PALETTE_UPLOADED?[32],Y ; Store to palette.
    DEY ; Slot--
    DEY
    DEY
    DEY
    BPL INDEX_POSITIVE ; Positive, goto.
    JSR ENGINE_QUEUE_UPDATE_PALETTE_PACKET ; Do ??
    JMP ENGINE_NMI_0x01_SET/WAIT ; Wait.
LIB_SUB_TODO: ; 1F:14CE, 0x03F4CE
    ASL A ; << 1, *1.
    STA MISC_USE_A ; Store to.
    TXA ; Save X and Y.
    PHA
    TYA
    PHA
    JSR ENGINE_SET_MAPPER_R6_TO_0x00 ; R6 to 0x00.
    LDY MISC_USE_A ; Load as index.
    LDA PTR_TABLE_UNK_L,Y ; Index to PTR.
    STA MISC_USE_A
    LDA PTR_TABLE_UNK_H,Y
    STA MISC_USE_B
    LDY #$00 ; Reset stream index.
    LDA [MISC_USE_A],Y ; Load from file.
    STA ALT_STUFF_INDEX? ; Store to ??
    INY ; Stream++
    LDX PACKET_HPOS_COORD? ; Load coord.
    LDA [MISC_USE_A],Y ; Load from stream.
    CMP #$FF ; If _ #$FF
    BEQ USE_XCOORD_ASIS ; ==, goto.
    TAX ; Val replaces coord.
USE_XCOORD_ASIS: ; 1F:14F4, 0x03F4F4
    STX MISC_USE_C ; X to. Coord?
    INY ; Stream++
    LDX PACKET_YPOS_COORD? ; Load Ycoord.
    LDA [MISC_USE_A],Y ; Load from file.
    CMP #$FF ; If _ #$FF
    BEQ USE_YCOORD_ASIS ; ==, use coord as-is.
    TAX ; Val replaces coord.
USE_YCOORD_ASIS: ; 1F:1500, 0x03F500
    STX MISC_USE_D/DECIMAL_POS? ; Store val.
LIB_X_STORE_UNK: ; 1F:1502, 0x03F502
    INY ; Stream++
    LDA [MISC_USE_A],Y ; Load from stream.
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
    LDA [MISC_USE_A],Y ; Move pointer ??
    STA SAVE_GAME_MOD_PAGE_PTR[2]
    INY ; Stream++
    LDA [MISC_USE_A],Y
    STA SAVE_GAME_MOD_PAGE_PTR+1
X_NONZERO: ; 1F:1539, 0x03F539
    TXA ; Save X and Y.
    PHA
    TYA
    PHA
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle.
    LDA #$00
    STA R_**:$0070 ; Clear ??
    LDA MISC_USE_C ; Move to HPos coord.
    STA PACKET_HPOS_COORD?
    LDA SAVE_GAME_MOD_PAGE_PTR[2] ; Move packet creation ptr.
    STA FPTR_PACKET_CREATION[2]
    LDA SAVE_GAME_MOD_PAGE_PTR+1
    STA FPTR_PACKET_CREATION+1
    JSR LIB_SAVE_STATE_FULL? ; Save state and do routine.
    CLC ; Prep add.
    LDA MISC_USE_D/DECIMAL_POS? ; Load ??
    ADC ALT_STUFF_INDEX? ; Add with.
    STA MISC_USE_D/DECIMAL_POS? ; Store result.
    PLA
    TAY ; Restore X and Y.
    PLA
    TAX
    DEX ; X--
    BNE X_NONZERO ; != 0, loop.
    RTS ; Leave.
LIB_SAVE_STATE_FULL?: ; 1F:1562, 0x03F562
    LDA MISC_USE_B ; Stack this stuff.
    PHA
    LDA MISC_USE_A
    PHA
    LDA MISC_USE_C
    PHA
    LDA SAVE_GAME_MOD_PAGE_PTR+1
    PHA
    LDA SAVE_GAME_MOD_PAGE_PTR[2]
    PHA
    LDA ALT_COUNT_UNK
    PHA
    LDA ALT_STUFF_INDEX?
    PHA
    LDA ALT_COUNT_UNK
    BEQ VAL_EQ_0x00 ; == 0, goto.
    CMP #$01 ; If _ #$01
    BEQ LIB_STATE_RESTORE_WITH_UPDATE ; ==, goto.
    LDA MISC_USE_D/DECIMAL_POS? ; Move ??
    STA PACKET_YPOS_COORD?
    PHA ; Save it, too.
    JSR ENGINE_CREATE_UPDATE_BUF_INIT_INC? ; Do.
    PLA ; Pull saved.
    STA MISC_USE_D/DECIMAL_POS? ; Store back.
    JMP LIB_STATE_RESTORE ; Restore.
VAL_EQ_0x00: ; 1F:158D, 0x03F58D
    CLC ; Prep add.
    LDA MISC_USE_D/DECIMAL_POS? ; Load val.
    ADC ALT_STUFF_INDEX? ; Mod val.
    STA PACKET_YPOS_COORD? ; Store to.
    PHA ; Save it, too.
    JSR RTN_SETTLE_UPDATE_TODO ; Do.
    PLA ; Pull saved.
    STA MISC_USE_D/DECIMAL_POS? ; Restore it.
    JMP LIB_STATE_RESTORE ; Restore.
LIB_STATE_RESTORE_WITH_UPDATE: ; 1F:159E, 0x03F59E
    CLC ; Prep add.
    LDA MISC_USE_D/DECIMAL_POS? ; Load ??
    ADC ALT_STUFF_INDEX? ; Add with.
    STA PACKET_YPOS_COORD? ; Store to.
    PHA ; Save it.
    JSR ENGINE_CREATE_UPDATE_BUF_INIT_DEC? ; Do update.
    PLA ; Pull it.
    STA MISC_USE_D/DECIMAL_POS? ; Restore it.
LIB_STATE_RESTORE: ; 1F:15AC, 0x03F5AC
    PLA ; From stack to vars.
    STA ALT_STUFF_INDEX?
    PLA
    STA ALT_COUNT_UNK
    PLA
    STA SAVE_GAME_MOD_PAGE_PTR[2]
    PLA
    STA SAVE_GAME_MOD_PAGE_PTR+1
    PLA
    STA MISC_USE_C
    PLA
    STA MISC_USE_A
    PLA
    STA MISC_USE_B
    RTS ; Leave.
    LDA FLAG_SPRITE_OFF_SCREEN_UNK ; Load ??
    PHA ; Save it.
    JSR CLEAR_FLAG_OFFSCREEN ; Do.
    LDA #$DF
    STA FPTR_UNK_84_MENU?[2] ; Set up PTR, 1F:15DF data table.
    LDA #$F5
    STA FPTR_UNK_84_MENU?+1
    LDA #$DF
    STA FPTR_SPRITES?[2] ; Set up ptr, 1F:15DF data table.
    LDA #$F5
    STA FPTR_SPRITES?+1
    JSR STREAM_AND_CONVERT_IDFK ; Do ??
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
    STA MISC_USE_C ; A to.
    LDA #$00 ; Init clear.
    ASL MISC_USE_C ; << 1, *2.
    ROL A ; Into A.
    ASL MISC_USE_C ; 2x
    ROL A
    ASL MISC_USE_C ; 3x
    ROL A
    STA MISC_USE_D/DECIMAL_POS? ; A result to.
    CLC
    LDA MISC_USE_C ; LOad.
    ADC #$00 ; += 0x00
    STA MISC_USE_C ; Store result.
    LDA MISC_USE_D/DECIMAL_POS? ; Load.
    ADC #$9E ; += 0x9E
    STA MISC_USE_D/DECIMAL_POS? ; Store result.
    RTS ; Leave.
LIB_IDFK: ; 1F:1614, 0x03F614
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle.
    LDY #$E8
    STY ARR_BITS_TO_UNK[8] ; Set ??
    LDA #$DF
    STA ARR_BITS_TO_UNK+1
    LDY COUNT_LOOPS?_UNK ; Y from.
Y_LOOP: ; 1F:1622, 0x03F622
    SEC ; Prep sub.
    LDA ARR_BITS_TO_UNK+1 ; Load ??
    SBC #$10 ; Sub.
    STA ARR_BITS_TO_UNK+1 ; Store back.
    DEY ; Y--
    BNE Y_LOOP ; !=, goto.
    LDA #$00
    STA ALT_STUFF_INDEX? ; Clear ??
VAL_NE_0x60: ; 1F:1630, 0x03F630
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle.
    LDY ALT_STUFF_INDEX? ; Load index.
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
    LDA ARR_BITS_TO_UNK[8] ; Load ??
    ADC #$08 ; Add with.
    STA ARR_BITS_TO_UNK[8] ; Store result.
DATA_INDEXED_0x00: ; 1F:1660, 0x03F660
    CLC ; Prep add.
    LDA ARR_BITS_TO_UNK+1 ; Load ??
    ADC #$10 ; Add with.
    STA ARR_BITS_TO_UNK+1 ; Store result.
    CLC ; Prep add.
    LDA ALT_STUFF_INDEX? ; Load ??
    ADC #$20 ; Add with.
    STA ALT_STUFF_INDEX? ; Store to.
    CMP #$60 ; If _ #$60
    BNE VAL_NE_0x60 ; !=, goto, loop.
    RTS ; Leave.
ROUTINE_OBJ_HANDLE_UNK_A: ; 1F:1673, 0x03F673
    TYA ; Save Y
    PHA
    LDA STREAM_PTRS_ARR_UNK[48],Y ; Move from Y index to MISC.
    STA MISC_USE_A
    LDA STREAM_PTRS_ARR_UNK+1,Y
    STA MISC_USE_B
    LDA STREAM_INDEXES_ARR_UNK+3,Y ; Move to mod ptr?
    STA SAVE_GAME_MOD_PAGE_PTR[2]
    LDA STREAM_INDEXES_ARR_UNK+4,Y
    STA SAVE_GAME_MOD_PAGE_PTR+1
    LDY #$03 ; Stream index.
    LDA [MISC_USE_A],Y ; Load from stream.
    STA MISC_USE_C
    INY ; Stream++
    LDA [MISC_USE_A],Y ; Load from stream.
    AND #$03 ; Keep lower bits.
    STA MISC_USE_D/DECIMAL_POS? ; Stopre to ??
    LSR MISC_USE_D/DECIMAL_POS? ; Shift it into.
    ROR MISC_USE_C
    LSR MISC_USE_D/DECIMAL_POS? ; 2x
    ROR MISC_USE_C
    PLA ; Restore Y.
    TAY
    SEC ; Prep sub.
    LDA SAVE_GAME_MOD_PAGE_PTR[2] ; Load ??
    SBC MISC_USE_C ; Sub with created.
    LDA SAVE_GAME_MOD_PAGE_PTR+1 ; Load other.
    SBC MISC_USE_D/DECIMAL_POS? ; Sub with. other.
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
    STA NMI_FLAG_B ; Set flag ??
    RTS
IN-CODE_PTR_TABLE_B: ; 1F:16BF, 0x03F6BF
    LDA #$00 ; Seed ??
    LDX #$0C
    LDY #$97
    JMP OBJECT_STORE_UNK ; Store to ??
IN-CODE_PTR_TABLE_C: ; 1F:16C8, 0x03F6C8
    LDX ARR_BITS_TO_UNK[8] ; Index from.
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
    STX MISC_USE_A ; X and Y to. Will go to obj.
    STY MISC_USE_B
    LDX ARR_BITS_TO_UNK[8] ; Load index.
    STA OBJ?_BYTE_0x0_STATUS?,X ; To A passed.
    LDA #$08 ; Obj ??
    STA OBJ?_BYTE_0x1_UNK,X
    LDA #$70 ; Obj ??
    STA OBJ?_BYTE_0x2_UNK,X
    LDA ARR_BITS_TO_UNK+1 ; Move ?? to obj.
    STA OBJ?_BYTE_0x3_UNK,X
    LDA #$00 ; Clear ??
    STA OBJ?_BYTE_0x4_UNK,X ; Clear OBJs.
    STA OBJ?_BYTE_0x5_BYTE,X
    LDA MISC_USE_A ; Move passed PTR to.
    STA OBJ?_PTR?[2],X
    LDA MISC_USE_B
    STA OBJ?_PTR?+1,X
    RTS ; Leave.
OBJ_SET_AND_SETTLE_RETURN: ; 1F:1724, 0x03F724
    LDX ARR_BITS_TO_UNK[8] ; Load index.
    STA OBJ?_BYTE_0x0_STATUS?,X ; Store passed as status.
    LDA #$01
    STA NMI_FLAG_B ; Set flag.
    LDX #$08
    JMP ENGINE_WAIT_X_SETTLES ; Wait and leave abuse rts.
ENGINE_PALETTE_SIZE_UPDATE_FPTR_XY: ; 1F:1732, 0x03F732
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle.
    STX MISC_USE_A ; X and Y to FPTR.
    STY MISC_USE_B
    LDY #$1F ; Index.
VAL_POSITIVE: ; 1F:173B, 0x03F73B
    LDA [MISC_USE_A],Y ; Load from stream.
    STA NMI_PPU_CMD_PACKETS_BUF[69],Y ; To.
    DEY ; Stream/index--
    BPL VAL_POSITIVE ; Positive, do more.
    LDA #$80
    STA NMI_FLAG_B ; Set ??
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
RAM_JMP_DISABLE?: ; 1F:1759, 0x03F759
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
    LDA NMI_FLAG_A_OVERRIDE?
    BEQ NMI_FLAG_NO_OVERRIDE? ; == 0, goto.
    LDA NMI_FLAG_B
    BNE NMI_BUF_PROCESSOR_CHECK ; != 0, goto always.
    BEQ NMI_FLAGS_CHECKED ; == 0, goto.
NMI_FLAG_NO_OVERRIDE?: ; 1F:17C2, 0x03F7C2
    LDA NMI_FLAG_B ; Load.
    BEQ NMI_FLAGS_CHECKED ; == 0, goto.
    AND #$7F ; Keep bits.
    STA NMI_FLAG_A_OVERRIDE? ; Set modded as other.
NMI_BUF_PROCESSOR_CHECK: ; 1F:17CA, 0x03F7CA
    LDA NMI_PPU_CMD_PACKETS_BUF[69],Y ; Load from buf.
    BEQ EXIT_UPDATES_CLEAR_FLAG_B ; == 0, goto.
    BMI LOWER_DIRECTLY_TO_BUFFER ; Negative, directly to buffer.
    ASL A ; << 1, *2.
    TAX ; To X index.
    LDA UPDATE_BUF_HANDLERS_H,X ; Move addr to stack.
    PHA
    LDA UPDATE_BUF_HANDLERS_L,X
    PHA
    RTS ; Run it.
LOWER_DIRECTLY_TO_BUFFER: ; 1F:17DC, 0x03F7DC
    AND #$7F ; Keep bits.
    STA NMI_PPU_CMD_PACKETS_BUF[69],Y ; Store to buf.
    BNE NMI_FLAGS_CHECKED ; != 0, goto.
EXIT_UPDATES_CLEAR_FLAG_B: ; 1F:17E3, 0x03F7E3
    STA NMI_FLAG_B ; Clear flag, updates ran.
NMI_FLAGS_CHECKED: ; 1F:17E5, 0x03F7E5
    LDX NMI_LATCH_FLAG
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
    LDA MAPPER_BANK_VALS+6
    PHA
    LDA MAPPER_BANK_VALS+7
    PHA
    LDA NMI_GFX_COUNTER ; Load.
    BEQ SKIP_GFX_MOD ; == 0, goto.
    LSR A ; >> 1, /2.
    AND #$03 ; Keep bottom bits.
    ORA #$44 ; Set 0100.01XX
    LDX #$02 ; GFX bank R2.
    JSR ENGINE_SET_MAPPER_BANK_X_VAL_A ; Set GFX.
    LDX #$03 ; GFX bank R3.
    JSR ENGINE_SET_MAPPER_BANK_X_VAL_A
    DEC NMI_GFX_COUNTER ; --
SKIP_GFX_MOD: ; 1F:185F, 0x03F85F
    JSR ENGINE_SWAP_TO_SOUND_ENGINE_HELPER ; Set sound banks.
    JSR JMP_SOUND_ENTRY_FORWARD ; Forward engine.
    LDA NMI_FLAG_OBJECT_PROCESSING? ; Load ??
    BMI NMI_RESTORE_ENGINE_STATE/READ_INPUT ; Negative, goto.
    LDA NMI_FLAG_C ; Load.
    AND #$3F ; Keep 0011.1111
    STA BMI_FLAG_SET_DIFF_MODDED_UNK ; Store to.
    LDA NMI_FLAG_A_OVERRIDE? ; Load.
    BNE NONZERO ; != 0, goto.
    JSR NMI_SPRITE_SWAP_UNK ; Swap sprites.
    JMP NMI_RESTORE_ENGINE_STATE/READ_INPUT ; Goto.
NONZERO: ; 1F:1879, 0x03F879
    CLC ; Sub -1
    SBC BMI_FLAG_SET_DIFF_MODDED_UNK ; Sub with, extra.
    BCS SUB_NO_UNDERFLOW ; No underflow, goto.
    LDX NMI_FLAG_A_OVERRIDE? ; Load ??
    DEX ; Index--
    STX BMI_FLAG_SET_DIFF_MODDED_UNK ; Store modded.
    LDA #$00 ; Seed clear.
SUB_NO_UNDERFLOW: ; 1F:1885, 0x03F885
    STA NMI_FLAG_A_OVERRIDE? ; Store flag.
    JSR SUB_TODOOOOOOOOOOOOO ; Do, scrolly?
NMI_RESTORE_ENGINE_STATE/READ_INPUT: ; 1F:188A, 0x03F88A
    PLA ; Restore R7 val.
    LDX #$07 ; R7.
    JSR ENGINE_SET_MAPPER_BANK_X_VAL_A ; Bank it in.
    PLA ; Restore R6 val.
    LDX #$06
    JSR ENGINE_SET_MAPPER_BANK_X_VAL_A
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
    LOW(1F:17C9) ; 0x00
UPDATE_BUF_HANDLERS_H: ; 1F:18C2, 0x03F8C2
    HIGH(1F:17C9) ; Check routine for ending/continue/more.
    LOW(1F:18D6) ; 0x01
    HIGH(1F:18D6) ; Index++
    LOW(1F:18DA) ; 0x02
    HIGH(1F:18DA) ; Index delta from buf.
    LOW(1F:18E4) ; 0x03
    HIGH(1F:18E4) ; Index val from stream.
    LOW(1F:18EC) ; 0x04
    HIGH(1F:18EC) ; Palette update.
    LOW(1F:1915) ; 0x05
    HIGH(1F:1915) ; Data upload VRAM mode +1
    LOW(1F:1922) ; 0x06
    HIGH(1F:1922) ; Data upload. VRAM mode +32
    LOW(1F:193B) ; 0x07
    HIGH(1F:193B) ; Bulk upload byte with addr.
    LOW(1F:195B) ; 0x08
    HIGH(1F:195B) ; Move a single byte count times.
    LOW(1F:197B) ; 0x09
    HIGH(1F:197B) ; Reads the PPU memory and put it to the update buffer ahead.
    LOW(1F:199E) ; 0x0A
    HIGH(1F:199E) ; Reads the PPU memory and put it in a stack-page buffer at $0110.
RTN_0x01: ; 1F:18D7, 0x03F8D7
    INY ; Mod index.
    JMP NMI_BUF_PROCESSOR_CHECK ; Relaunch.
RTN_0x02: ; 1F:18DB, 0x03F8DB
    INY ; To next index.
    TYA ; Index pos to A.
    SEC ; Prep with carry.
    ADC NMI_PPU_CMD_PACKETS_BUF[69],Y ; Mod with value.
    TAY ; Back to index.
    JMP NMI_BUF_PROCESSOR_CHECK ; Re-launch with new index.
RTN_0x03: ; 1F:18E5, 0x03F8E5
    INY ; Index++
    LDA NMI_PPU_CMD_PACKETS_BUF[69],Y ; Load from buffer.
    TAY ; To new index.
    JMP NMI_BUF_PROCESSOR_CHECK ; Goto.
RTN_0x04: ; 1F:18ED, 0x03F8ED
    LDA #$3F ; Seed PPU 0x3F00
    LDX #$00
    STA PPU_ADDR ; Set addr.
    STX PPU_ADDR
PALETTE_NOT_COMPLETED: ; 1F:18F7, 0x03F8F7
    LDA SCRIPT_PALETTE_UPLOADED?[32],X ; Load palette
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
    JMP NMI_BUF_PROCESSOR_CHECK ; Relaunch.
RTN_0x05: ; 1F:1916, 0x03F916
    JSR NMI_PACKET_UNIQUE_DATA_UPLOADER ; Upload the packet.
    LDA NMI_PPU_CMD_PACKETS_BUF[69],Y ; Load from buf.
    CMP #$05 ; If _ #$05
    BEQ RTN_0x05 ; Relaunch another packet.
    JMP NMI_BUF_PROCESSOR_CHECK ; Relaunch other pakcet type.
RTN_0x06: ; 1F:1923, 0x03F923
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
    JMP NMI_BUF_PROCESSOR_CHECK ; Relaunch.
RTN_0x07: ; 1F:193C, 0x03F93C
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
    JMP NMI_BUF_PROCESSOR_CHECK ; Relaunch routine.
RTN_0x08: ; 1F:195C, 0x03F95C
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
    JMP NMI_BUF_PROCESSOR_CHECK ; Relaunch.
RTN_0x09: ; 1F:197C, 0x03F97C
    INY ; Buf++
    LDX NMI_PPU_CMD_PACKETS_BUF[69],Y ; Count.
    INY ; Buf++
    LDA NMI_PPU_CMD_PACKETS_BUF[69],Y ; Move addr.
    STA PPU_ADDR
    INY ; Buf++
    LDA NMI_PPU_CMD_PACKETS_BUF[69],Y
    STA PPU_ADDR
    INY ; Buf++
    LDA PPU_DATA ; Read buffer fix.
READ_TO_UPDATE_BUF: ; 1F:1992, 0x03F992
    LDA PPU_DATA ; Load from PPU.
    STA NMI_PPU_CMD_PACKETS_BUF[69],Y ; To buf.
    INY ; Buf++
    DEX ; Count--
    BNE READ_TO_UPDATE_BUF ; != 0, loop more.
    JMP NMI_BUF_PROCESSOR_CHECK ; Relaunch.
RTN_0x0A: ; 1F:199F, 0x03F99F
    LDA MAPPER_INDEX_LAST_WRITTEN ; Save mapper setup.
    PHA
    LDA MAPPER_BANK_VALS+4 ; R4
    PHA
    LDA MAPPER_BANK_VALS+5 ; R5
    PHA
    INY ; Buf++
    LDA NMI_PPU_CMD_PACKETS_BUF[69],Y ; Load from buf.
    LDX #$04 ; Set GFX R4.
    JSR ENGINE_SET_MAPPER_BANK_X_VAL_A ; To buf val loaded.
    CLC ; Prep add.
    ADC #$01 ; Add 0x1 for the pair.
    LDX #$05 ; INX plox.
    JSR ENGINE_SET_MAPPER_BANK_X_VAL_A ; Set R5 to pair.
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
    JSR ENGINE_SET_MAPPER_BANK_X_VAL_A
    PLA
    LDX #$04
    JSR ENGINE_SET_MAPPER_BANK_X_VAL_A
    PLA
    STA MAPPER_INDEX_LAST_WRITTEN
    ORA ENGINE_MAPPER_CONFIG_STATUS_NO_BANK ; Set other CFG bits.
    STA MMC3_BANK_CFG ; Set config to mapper.
    JMP NMI_BUF_PROCESSOR_CHECK ; Relaunch buffer.
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
    JSR ENGINE_SET_MAPPER_BANK_X_VAL_A
    LDA #$00
    STA R_**:$00CE ; Clear ??
    STA R_**:$00CF
    LDX BMI_FLAG_SET_DIFF_MODDED_UNK ; Load.
    BIT NMI_FLAG_C
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
    CMP SOUND_VAL_CMP_UNK ; If _ var
    BEQ JUST_WAIT ; ==, skip.
    STA VAL_CMP_DIFFERS_STORED_UNK ; Store if mismatch, new song. 0xFF = None?
JUST_WAIT: ; 1F:1D30, 0x03FD30
    JMP ENGINE_NMI_0x01_SET/WAIT ; Wait, abuse RTS.
ENGINE_SETTLE_ALL_UPDATES?: ; 1F:1D33, 0x03FD33
    LDA NMI_FLAG_B ; Load.
    ORA NMI_FLAG_A_OVERRIDE? ; Or with other.
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
SETTLE_SPRITES_OFFSCREEN/CLEAR_RAM: ; 1F:1D5E, 0x03FD5E
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
    STA NMI_FLAG_B ; Set flag ??
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
    LDA NMI_FLAG_C ; Load.
    AND #$BF ; Keep 1011.1111
    STA NMI_FLAG_C ; Cleared 0x40 store.
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
ENGINE_SCRIPT_LAUNCH_R7_A_PTR_XY: ; 1F:1DF3, 0x03FDF3
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
    LDA MAPPER_BANK_VALS+7 ; Load R7 currently.
    LDY R_**:$0105,X ; Load 6th value up stack, R7 val.
    STA R_**:$0105,X ; Store R7 val to stack.
    TYA ; Val passed to us into A.
    LDX #$07 ; Bank it in to R7.
    JMP ENGINE_SET_MAPPER_BANK_X_VAL_A ; COMMIT.
ENGINE_R7_RESTORE_FROM_STACK_SCRIPT?: ; 1F:1E0D, 0x03FE0D
    PLA ; Pull value from stack.
    LDX #$07
    JMP ENGINE_SET_MAPPER_BANK_X_VAL_A
VECTOR_IRQ: ; 1F:1E13, 0x03FE13
    PHA
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
    JSR ENGINE_SET_MAPPER_BANK_X_VAL_A ; Set R7, bank 0x13.
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
    JSR ENGINE_SET_MAPPER_BANK_X_VAL_A ; Set.
    LDA #$1D ; Bank val.
    LDX #$07 ; R7.
ENGINE_SET_MAPPER_BANK_X_VAL_A: ; 1F:1FD0, 0x03FFD0
    STX MAPPER_INDEX_LAST_WRITTEN ; Index to.
    STA MAPPER_BANK_VALS[8],X ; Value to index.
    TXA ; Bank slot to A.
    ORA ENGINE_MAPPER_CONFIG_STATUS_NO_BANK ; Set config status bits.
    STA MMC3_BANK_CFG ; Store R# bank config.
    LDA MAPPER_BANK_VALS[8],X ; Load value stored from arr.
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
