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
    STA **:$0300,X ; Store ??
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
    STA **:$0300,X ; To ??
    INX ; Indexes++
    INY
    LDA #$00 ; Seed carry add.
    ADC [ENGINE_FPTR_30[2]],Y ; Add with carry.
    STA **:$0300,X ; To ??
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
    STA **:$0300,X ; Clear ??
    CLC ; Prep add. X += 8
    TXA
    ADC #$08
    TAX
    BCC X_NO_OVERFLOW ; <, goto.
EXIT_WRAM_WDISABLED: ; 1F:0062, 0x03E062
    JMP ENGINE_WRAM_STATE_WRITE_DISABLED ; Exit.
OBJECTS_MOVE_PTRS?: ; 1F:0065, 0x03E065
    LDX #$00 ; Reset index.
LOOP_INDEXES: ; 1F:0067, 0x03E067
    LDA **:$0300,X ; Load ??
    AND #$40 ; Test ??
    BEQ TO_NEXT_SLOT ; == 0, goto.
    SEC ; Prep sub.
    LDA **:$0306,X ; Load data.
    SBC #$04 ; -= 0x4
    STA **:$0306,X ; Store back.
    LDA **:$0307,X ; Carry sub.
    SBC #$00
    STA **:$0307,X
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
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE+2 ; Clear ??
    LDX #$08 ; Seed index.
LOOP_NONZERO: ; 1F:0094, 0x03E094
    LDY #$00 ; Reset stream.
    LDA [ENGINE_FPTR_30[2]],Y ; Load from file.
    BEQ FLAGGED_DATA ; == 0, goto.
    BMI FLAGGED_DATA ; Negative, goto.
    LDY ENGINE_PALETTE_FPTR/BITS/GEN_USE+2 ; Alt stream index.
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y ; Load from stream.
    STA **:$0302,X ; Store to arr.
    INY ; Stream++
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y ; Load from stream.
    STA **:$0303,X ; Store to arr.
    INY ; Stream++
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y ; Load from stream.
    STA ENGINE_TO_DECIMAL_INDEX_POSITION ; Store to.
    INY ; Stream++
    CLC ; Prep add.
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y ; Load from stream.
    LDY #$16 ; Alt stream index.
    ADC [ENGINE_FPTR_30[2]],Y ; Add with stream.
    STA **:$0306,X ; Store to arr.
    INY ; Stream++
    LDA #$00 ; Seed carry.
    ADC [ENGINE_FPTR_30[2]],Y ; Add with stream.
    STA **:$0307,X ; Store to arr.
    LDY #$08 ; Stream index.
    LDA [ENGINE_FPTR_30[2]],Y ; Load from arr.
    AND #$3F ; Keep lower.
    ASL A ; << 1, *2.
    ASL ENGINE_TO_DECIMAL_INDEX_POSITION ; << 1, *2.
    ROR A ; Rotate carry into A.
    STA **:$0300,X ; Store to arr.
    LDA #$70 ; Load ??
    ASL ENGINE_TO_DECIMAL_INDEX_POSITION ; << 1, *2.
    ROR A ; Rotate into A.
    STA **:$0301,X ; Store to.
    LDA #$00
    STA **:$0304,X ; Clear ??
    STA **:$0305,X
    CLC ; Prep add.
    TXA ; Index to A.
    ADC #$08 ; Index mod.
    TAX ; Back to index.
FLAGGED_DATA: ; 1F:00E3, 0x03E0E3
    CLC ; Prep add.
    LDA #$04 ; Adding.
    ADC ENGINE_PALETTE_FPTR/BITS/GEN_USE+2 ; Add with.
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE+2 ; Store 
    JSR ENGINE_FPTR_COL/ROW_MOD/FORWARD? ; Do mod.
    DEC GAME_SLOT_CURRENT? ; --
    BNE LOOP_NONZERO ; == 0, goto.
    RTS ; Leave.
ENGINE_HELPER_LOAD_7400_INDEX_A&3F: ; 1F:00F2, 0x03E0F2
    AND #$3F ; Keep group count/data index.
    TAX ; To X index.
    LDA CURRENT_SAVE_MANIPULATION_PAGE[768],X ; Load from.
    RTS ; Leave.
SWITCH_MAP/SCREEN?: ; 1F:00F9, 0x03E0F9
    ASL A ; << 2, *4.
    ASL A
    TAX ; To X index.
    LDA SWITCH_RTNS_H,X ; Routine is first.
    PHA
    LDA SWITCH_RTNS_L,X
    PHA
    RTS ; Run it.
SWITCH_RTNS_L: ; 1F:0105, 0x03E105
    LOW(1F:01BC) ; 0x00
SWITCH_RTNS_H: ; 1F:0106, 0x03E106
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
    LOW(1F:0B39)
    HIGH(1F:0B39)
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
    LOW(1F:0A37)
    HIGH(1F:0A37)
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
    LOW(1F:06D8) ; AB
    HIGH(1F:06D8)
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
    BCC 1F:020E
    LDA SCRIPT_PAIR_PTR_B?[2]
    SBC #$40
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    LDA SCRIPT_PAIR_PTR_B?+1
    SBC #$00
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    SEC
    LDA STREAM_WRITE_ARR_UNK[4]
    SBC ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    LDA STREAM_WRITE_ARR_UNK+1
    SBC ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    SEC
    LDA #$80
    SBC ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    LDA #$04
    SBC ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    RTS
    JSR SETUP_PTR_6780_UNK
    LDY #$15
    LDA [ENGINE_FPTR_30[2]],Y
    ASL A
    ASL A
    ASL A
    TAX
    LDA L_1F:0BF1,X
    ASL A
    TAX
    STA **:$003F
    LDY #$11
    LDA 1F:0BF4,X
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
    STA **:$00A7
    CLC
    LDA STREAM_DEEP_INDEX
    ADC 1F:0BF3,X
    TAX
    EOR STREAM_DEEP_INDEX
    AND #$F0
    BEQ 1F:0258
    LDA STREAM_DEEP_INDEX
    AND #$F0
    STA STREAM_DEEP_INDEX
    TXA
    AND #$0F
    ORA STREAM_DEEP_INDEX
    TAX
    LDA **:$00A7
    EOR #$01
    STA **:$00A7
    STX STREAM_DEEP_INDEX
    JSR SUB_STREAM_RESET_TO_??_AND_PTR/VAL_RTN ; Do.
SUB_MOVE_PTR_0x32_TO_0x30: ; 1F:025D, 0x03E25D
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
    BEQ SUB_MOVE_PTR_0x32_TO_0x30 ; Always taken.
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
    LDA **:$003F
    ADC #$20
    AND #$38
    TAX
    LDY #$15
    LSR A
    LSR A
    LSR A
    STA [ENGINE_FPTR_30[2]],Y
    JSR ENGINE_WRAM_STATE_WRITE_DISABLED
    LDA L_1F:0BF1,X
    CLC
    LDY #$16
    ADC [ENGINE_FPTR_30[2]],Y
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    LDA #$00
    INY
    ADC [ENGINE_FPTR_30[2]],Y
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    LDA #$15
    LDX #$06
    JSR ENGINE_SET_MAPPER_BANK_X_VAL_A
    LDY #$10
    LDA [ENGINE_FPTR_30[2]],Y
    TAY
    LDA **:$0300,Y
    AND #$3F
    STA **:$003F
    BEQ RTS
    LDA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    STA **:$0306,Y
    LDA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    STA **:$0307,Y
    LDA **:$0302,Y
    STA ARR_BITS_TO_UNK[8]
    LDA **:$0303,Y
    STA ARR_BITS_TO_UNK+1
    LDA **:$0301,Y
    ASL A
    ASL A
    TAX
    LDY #$00
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    STA SAVE_GAME_MOD_PAGE_PTR[2]
    INY
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    STA SAVE_GAME_MOD_PAGE_PTR+1
    INY
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    STA ARR_BITS_TO_UNK+2
    INY
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    STA ARR_BITS_TO_UNK+3
    SEC
    BIT NMI_FLAG_OBJECT_PROCESSING?
    BVS 1F:0315
    ROR NMI_FLAG_OBJECT_PROCESSING?
    LDY #$00
    LDA SPRITE_PAGE[256],X
    CMP #$F0
    BEQ 1F:0365
    CLC
    LDA [SAVE_GAME_MOD_PAGE_PTR[2]],Y
    ADC ARR_BITS_TO_UNK[8]
    STA SPRITE_PAGE+3,X
    INY
    CLC
    LDA [SAVE_GAME_MOD_PAGE_PTR[2]],Y
    ADC ARR_BITS_TO_UNK+1
    STA SPRITE_PAGE[256],X
    INY
    LDA [SAVE_GAME_MOD_PAGE_PTR[2]],Y
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    LDA ARR_BITS_TO_UNK+3
    LSR ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    BCC 1F:0342
    LSR A
    LSR A
    LSR ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    BCC 1F:034A
    LSR A
    LSR A
    LSR A
    LSR A
    AND #$03
    ASL ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    ASL ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    ORA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    STA SPRITE_PAGE+2,X
    INY
    CLC
    AND #$10
    BEQ 1F:035D
    LDA ARR_BITS_TO_UNK+2
    ADC [SAVE_GAME_MOD_PAGE_PTR[2]],Y
    STA SPRITE_PAGE+1,X
    INY
    BNE 1F:0369
    INY
    INY
    INY
    INY
    INX
    INX
    INX
    INX
    BEQ 1F:0373
    DEC **:$003F
    BNE 1F:031D
    ASL NMI_FLAG_OBJECT_PROCESSING?
    RTS
    LDA SCRIPT_LOADED_SHIFTED_|VAL+1
    LSR A
    LSR A
    LSR A
    LSR A
    AND #$0E
    ORA #$01
    LDX #$06
    JSR ENGINE_SET_MAPPER_BANK_X_VAL_A
    LDA SCRIPT_LOADED_SHIFTED_|VAL+1
    LSR A
    LSR A
    AND #$07
    STA ARR_BITS_TO_UNK+1
    LDA **:$00AB
    AND #$FC
    CLC
    STA ARR_BITS_TO_UNK[8]
    LDA ARR_BITS_TO_UNK+1
    ADC #$98
    STA ARR_BITS_TO_UNK+1
    LDY #$01
    LDA [ARR_BITS_TO_UNK[8]],Y
    AND #$3F
    LDY #$01
    CMP [ENGINE_FPTR_30[2]],Y
    BNE 1F:03AD
    LDA SCRIPT_R6_ROUTINE_SELECT
    JSR BANK_HANDLER_R6_AND_BASE
    CLC
    RTS
    LDA SCRIPT_R6_ROUTINE_SELECT
    JSR BANK_HANDLER_R6_AND_BASE
    SEC
    RTS
    LDA #$14
    LDX #$06
    JSR ENGINE_SET_MAPPER_BANK_X_VAL_A
    LDA STREAM_DEEP_C
    STA STREAM_UNK_DEEP_A[2]
    LDA **:$003E
    ASL A
    TAX
    LDA 1F:03CD,X
    PHA
    LDA 1F:03CC,X
    PHA
    RTS
    ???
    CPX STREAM_WRITE_ARR_UNK+1
    CPX CTRL_NEWLY_PRESSED+1
    ???
    LDA [SPRITE_INDEX_SWAP],Y
    STA MMC3_IRQ_LATCH,X
    CPX **:$0002
    CPX SAVE_GAME_MOD_PAGE_PTR+1
    CPX **:$008F
    CPX FIRST_LAUNCHER_HOLD_FLAG?
    ASL NMI_FLAG_E5_TODO
    TAX
    AND #$30
    BEQ 1F:03EF
    AND #$20
    BEQ 1F:0400
    TXA
    AND #$1C
    BNE 1F:0400
    LDX #$FF
    LDY #$00
    JSR 1F:0510
    TAX
    AND #$20
    BEQ 1F:0425
    TXA
    AND #$03
    BEQ 1F:0425
    JMP 1F:0490
    JSR 1F:0506
    TAX
    AND #$30
    BEQ 1F:0414
    AND #$20
    BEQ 1F:0400
    TXA
    AND #$13
    BNE 1F:0400
    LDX #$01
    LDY #$00
    JSR 1F:0510
    TAX
    AND #$20
    BEQ 1F:0425
    TXA
    AND #$0C
    BNE 1F:0400
    JMP 1F:0497
    JSR 1F:0506
    AND #$16
    BNE 1F:0490
    LDX #$00
    LDY #$10
    JSR 1F:0510
    AND #$09
    BNE 1F:0490
    BEQ 1F:0497
    JSR 1F:0506
    AND #$14
    BNE 1F:0490
    LDX #$00
    LDY #$10
    JSR 1F:0510
    AND #$08
    BNE 1F:0490
    LDX #$FF
    LDY #$00
    JSR 1F:0510
    AND #$02
    BNE 1F:0490
    LDX #$FF
    LDY #$10
    JSR 1F:0510
    AND #$01
    BNE 1F:0490
    BEQ 1F:0497
    JSR 1F:0506
    AND #$12
    BNE 1F:0490
    LDX #$00
    LDY #$10
    JSR 1F:0510
    AND #$01
    BNE 1F:0490
    LDX #$01
    LDY #$00
    JSR 1F:0510
    AND #$04
    BNE 1F:0490
    LDX #$01
    LDY #$10
    JSR 1F:0510
    AND #$08
    BNE 1F:0490
    BEQ 1F:0497
    LDA SCRIPT_R6_ROUTINE_SELECT
    JSR BANK_HANDLER_R6_AND_BASE
    SEC
    RTS
    LDA SCRIPT_R6_ROUTINE_SELECT
    JSR BANK_HANDLER_R6_AND_BASE
    CLC
    RTS
    JSR 1F:0506
    AND #$19
    BNE 1F:0490
    LDX #$00
    LDY #$F0
    JSR 1F:0510
    AND #$06
    BNE 1F:0490
    BEQ 1F:0497
    JSR 1F:0506
    AND #$18
    BNE 1F:0490
    LDX #$00
    LDY #$F0
    JSR 1F:0510
    AND #$04
    BNE 1F:0490
    LDX #$FF
    LDY #$00
    JSR 1F:0510
    AND #$01
    BNE 1F:0490
    LDX #$FF
    LDY #$F0
    JSR 1F:0510
    AND #$02
    BNE 1F:0490
    BEQ 1F:0497
    JSR 1F:0506
    AND #$11
    BNE 1F:0490
    LDX #$00
    LDY #$F0
    JSR 1F:0510
    AND #$02
    BNE 1F:0490
    LDX #$01
    LDY #$00
    JSR 1F:0510
    AND #$08
    BNE 1F:0490
    LDX #$01
    LDY #$F0
    JSR 1F:0510
    AND #$04
    BNE 1F:0490
    BEQ 1F:0497
    LDX #$00
    LDY #$00
    JSR 1F:0510
    STA **:$003F
    RTS
    CLC
    TYA
    ADC STREAM_DEEP_INDEX
    STA STREAM_UNK_DEEP_A+1
    CLC
    TXA
    ADC STREAM_UNK_DEEP_A+1
    TAY
    EOR STREAM_UNK_DEEP_A+1
    AND #$F0
    BEQ 1F:052F
    LDA STREAM_UNK_DEEP_A+1
    AND #$F0
    STA STREAM_UNK_DEEP_A+1
    TYA
    AND #$0F
    ORA STREAM_UNK_DEEP_A+1
    TAY
    LDA #$01
    EOR **:$00A7
    CLC
    ADC #$FC
    STA STREAM_UNK_DEEP_A+1
    LDA #$00
    STA STREAM_DEEP_B
    LDA [STREAM_UNK_DEEP_A[2]],Y
    BMI 1F:0541
    LDA SCRIPT_R6_UNK
    BIT SPRITE_PAGE+165
    LSR A
    ROR STREAM_DEEP_B
    ADC #$80
    STA **:$00A5
    LDA [STREAM_UNK_DEEP_A[2]],Y
    AND #$7F
    TAY
    LDA [STREAM_DEEP_B],Y
    RTS
    JSR 1F:0607
    LDY #$0C
    LDA 1F:0BF3,X
    ASL A
    STA [ENGINE_FPTR_30[2]],Y
    INY
    LDA 1F:0BF4,X
    ASL A
    STA [ENGINE_FPTR_30[2]],Y
    JMP 1F:0577
    JSR 1F:0607
    LDY #$0C
    LDA 1F:0BF3,X
    STA [ENGINE_FPTR_30[2]],Y
    INY
    LDA 1F:0BF4,X
    STA [ENGINE_FPTR_30[2]],Y
    LDY #$08
    LDA [ENGINE_FPTR_30[2]],Y
    AND #$3F
    ORA #$40
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    LDA **:$003E
    LSR A
    AND #$40
    EOR ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    STA [ENGINE_FPTR_30[2]],Y
    LDY #$09
    LDA #$38
    STA [ENGINE_FPTR_30[2]],Y
    LDY #$15
    LDA [ENGINE_FPTR_30[2]],Y
    ASL A
    ASL A
    ASL A
    TAX
    LDA L_1F:0BF1,X
    CLC
    LDY #$16
    ADC [ENGINE_FPTR_30[2]],Y
    LDY #$0E
    STA [ENGINE_FPTR_30[2]],Y
    LDA #$00
    LDY #$17
    ADC [ENGINE_FPTR_30[2]],Y
    LDY #$0F
    STA [ENGINE_FPTR_30[2]],Y
    RTS
    JSR 1F:05EF
    ASL STREAM_WRITE_ARR_UNK[4]
    ROL STREAM_WRITE_ARR_UNK+1
    ASL STREAM_WRITE_ARR_UNK+2
    ROL STREAM_WRITE_ARR_UNK+3
    JMP 1F:05C0
    JSR 1F:05EF
    CLC
    LDY #$04
    LDA [ENGINE_FPTR_30[2]],Y
    ADC STREAM_WRITE_ARR_UNK[4]
    STA STREAM_WRITE_ARR_UNK[4]
    AND #$C0
    STA SCRIPT_LOADED_SHIFTED_UNK[1]
    INY
    LDA [ENGINE_FPTR_30[2]],Y
    ADC STREAM_WRITE_ARR_UNK+1
    STA STREAM_WRITE_ARR_UNK+1
    STA **:$00AB
    CLC
    LDY #$06
    LDA [ENGINE_FPTR_30[2]],Y
    ADC STREAM_WRITE_ARR_UNK+2
    STA STREAM_WRITE_ARR_UNK+2
    AND #$C0
    STA SCRIPT_LOADED_SHIFTED_|VAL[2]
    INY
    LDA [ENGINE_FPTR_30[2]],Y
    ADC STREAM_WRITE_ARR_UNK+3
    STA STREAM_WRITE_ARR_UNK+3
    STA SCRIPT_LOADED_SHIFTED_|VAL+1
    JMP SETUP_DEEP_STREAM_UNK
    JSR 1F:0607
    LDA LUT_MOD_0x0[4],X
    STA STREAM_WRITE_ARR_UNK[4]
    LDA LUT_MOD_0x0+1,X
    STA STREAM_WRITE_ARR_UNK+1
    LDA LUT_MOD_0x0+2,X
    STA STREAM_WRITE_ARR_UNK+2
    LDA LUT_MOD_0x0+3,X
    STA STREAM_WRITE_ARR_UNK+3
    RTS
    LDA **:$003E
    ASL A
    ASL A
    ASL A
    TAX
    RTS
    JSR STREAM_PTR_30_PTR_DATA_TO_32
    LDY #$14
    LDA [ENGINE_FPTR_30[2]],Y
    AND #$0F
    TAY
    LDA [ENGINE_FPTR_32[2]],Y
    INY
    CMP #$05
    BEQ 1F:0625
    CMP #$06
    BEQ 1F:062F
    BNE 1F:062D
    JSR L_1F:0646
    AND LUT_INDEX_TO_BITS_0x80-0x01,X
    BNE 1F:0637
    CLC
    RTS
    JSR L_1F:0646
    AND LUT_INDEX_TO_BITS_0x80-0x01,X
    BNE 1F:062D
    LDY #$00
    LDA [ENGINE_FPTR_30[2]],Y
    ORA #$80
    STA [ENGINE_FPTR_30[2]],Y
    SEC
    RTS
    JSR STREAM_PTR_30_PTR_DATA_TO_32
    LDY #$04
L_1F:0646: ; 1F:0646, 0x03E646
    LDA [ENGINE_FPTR_32[2]],Y
    AND #$07
    TAX
    LDA [ENGINE_FPTR_32[2]],Y
    LSR A
    LSR A
    LSR A
    TAY
    LDA CURRENT_SAVE_MANIPULATION_PAGE+512,Y
    RTS
STREAM_PTR_30_PTR_DATA_TO_32: ; 1F:0655, 0x03E655
    LDY #$02 ; Stream index.
    LDA [ENGINE_FPTR_30[2]],Y ; Move from PTR L from stream to other.
    STA ENGINE_FPTR_32[2]
    INY ; Stream++
    LDA [ENGINE_FPTR_30[2]],Y ; Move PTR H.
    STA ENGINE_FPTR_32+1
    RTS
MAP_RTN_AD: ; 1F:0661, 0x03E661
    JSR 1F:0641
    ORA LUT_INDEX_TO_BITS_0x80-0x01,X
    BNE 1F:0672
MAP_RTN_AE: ; 1F:0669, 0x03E669
    JSR 1F:0641
    ORA LUT_INDEX_TO_BITS_0x80-0x01,X
    EOR LUT_INDEX_TO_BITS_0x80-0x01,X
    STA CURRENT_SAVE_MANIPULATION_PAGE+512,Y
    JMP MAP_RTN_W
MAP_RTN_D: ; 1F:0678, 0x03E678
    LDY #$1B
    LDA [ENGINE_FPTR_30[2]],Y
    BNE 1F:0694
    JMP 1F:072E
MAP_RTN_B: ; 1F:0681, 0x03E681
    LDY #$15
    LDA [ENGINE_FPTR_30[2]],Y
    ORA #$40
    LDY #$1B
    EOR [ENGINE_FPTR_30[2]],Y
    AND #$4F
    BEQ 1F:0694
    JSR 1F:072E
    CLC
    RTS
    JSR STREAM_PTR_30_PTR_DATA_TO_32
    LDY #$04
    JSR L_1F:06A1
    JSR 1F:072E
    SEC
    RTS
L_1F:06A1: ; 1F:06A1, 0x03E6A1
    LDA ENGINE_FPTR_32[2]
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    LDA ENGINE_FPTR_32+1
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    SEC
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    SBC #$00
    STA CURRENT_SAVE_MANIPULATION_PAGE+4
    INY
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    SBC #$02
    STA CURRENT_SAVE_MANIPULATION_PAGE+5
    INY
    SEC
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    SBC #$C0
    STA CURRENT_SAVE_MANIPULATION_PAGE+6
    INY
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    SBC #$01
    STA CURRENT_SAVE_MANIPULATION_PAGE+7
    LDA #$40
    STA FIRST_LAUNCHER_HOLD_FLAG?
    RTS
MAP_RTN_C: ; 1F:06CF, 0x03E6CF
    JSR MAP_RTN_B
    BCC 1F:06D8
    LDA #$01
    STA SWITCH_INIT_PORTION?
    RTS
MAP_RTN_AB: ; 1F:06D9, 0x03E6D9
    JSR 1F:060E
    BCC 1F:06DF
    RTS
    JSR 1F:07FC
    AND #$F0
    LSR A
    LSR A
    LSR A
    CMP #$08
    BCS 1F:06FE
    JSR 1F:07DC
    JMP 1F:073D
MAP_RTN_Z: ; 1F:06F1, 0x03E6F1
    JSR 1F:060E
    BCC 1F:06F7
    RTS
    JSR 1F:07FC
    AND #$F0
    BNE MAP_RTN_W
    LDY #$0C
    LDA #$3D
    STA [ENGINE_FPTR_30[2]],Y
    INY
    LDA #$EC
    STA [ENGINE_FPTR_30[2]],Y
    JSR 1F:073D
    LDY #$09
    LDA #$78
    STA [ENGINE_FPTR_30[2]],Y
    LDA #$00
    JSR 1F:059B
    JMP 1F:072E
MAP_RTN_X: ; 1F:071A, 0x03E71A
    JSR 1F:060E
    BCC MAP_RTN_W
    RTS
MAP_RTN_W: ; 1F:0720, 0x03E720
    JSR 1F:0733
    JSR 1F:073D
    JSR 1F:0746
    LDA #$00
    JSR 1F:059B
    LDA #$88
    STA **:$003E
    RTS
    LDA #$00
    LDY #$0C
    STA [ENGINE_FPTR_30[2]],Y
    INY
    STA [ENGINE_FPTR_30[2]],Y
    RTS
    LDY #$08
    LDA [ENGINE_FPTR_30[2]],Y
    AND #$3F
    STA [ENGINE_FPTR_30[2]],Y
    RTS
    LDY #$09
    LDA #$38
    STA [ENGINE_FPTR_30[2]],Y
    RTS
    LDY #$08
    LDA [ENGINE_FPTR_30[2]],Y
    ORA #$40
    STA [ENGINE_FPTR_30[2]],Y
    RTS
MAP_RTN_Y: ; 1F:0756, 0x03E756
    JSR 1F:0733
    JSR 1F:073D
    JSR 1F:0746
    JSR STREAM_PTR_30_PTR_DATA_TO_32
    JSR 1F:0772
    AND LUT_INDEX_TO_BITS_0x80-0x01,X
    BEQ 1F:076C
    LDA #$04
    JSR 1F:059B
    JMP 1F:072E
    LDY #$06
    LDA [ENGINE_FPTR_32[2]],Y
    ASL A
    LDY #$07
    LDA [ENGINE_FPTR_32[2]],Y
    AND #$07
    TAX
    LDA [ENGINE_FPTR_32[2]],Y
    ROR A
    LSR A
    LSR A
    TAY
    LDA CURRENT_SAVE_MANIPULATION_PAGE+544,Y
    RTS
MAP_RTN_AA: ; 1F:0788, 0x03E788
    LDY #$1A
    LDA [ENGINE_FPTR_30[2]],Y
    BNE 1F:079C
    LDA #$01
    STA [ENGINE_FPTR_30[2]],Y
    LDY #$15
    LDA [ENGINE_FPTR_30[2]],Y
    EOR #$04
    AND #$0F
    STA [ENGINE_FPTR_30[2]],Y
    LDY #$15
    LDA [ENGINE_FPTR_30[2]],Y
    STA **:$003E
    JSR 1F:05AF
    JSR 1F:01D4
    BCC 1F:07B1
    LDA #$F8
    STA SCRIPT_FLAG_0x22
    JMP 1F:0552
    LDA #$00
    STA SCRIPT_FLAG_0x22
    JMP 1F:0965
MAP_RTN_U: ; 1F:07B8, 0x03E7B8
    JSR 1F:060E
    BCC MAP_RTN_Q
    RTS
MAP_RTN_Q: ; 1F:07BE, 0x03E7BE
    JSR 1F:07FC
    AND #$E0
    LSR A
    LSR A
    BCC 1F:07D2
MAP_RTN_T: ; 1F:07C7, 0x03E7C7
    JSR 1F:060E
    BCC MAP_RTN_P
    RTS
MAP_RTN_P: ; 1F:07CD, 0x03E7CD
    JSR 1F:07FC
    AND #$F8
    LSR A
    LSR A
    CMP #$08
    BCS MAP_RTN_O
    LDY #$15
    STA [ENGINE_FPTR_30[2]],Y
    STA **:$003E
    JSR 1F:05BD
    JSR 1F:0376
    BCS MAP_RTN_O
    JSR 1F:01D4
    BCC MAP_RTN_O
    JSR SUB_STREAM_RESET_TO_??_AND_PTR/VAL_RTN
    BNE MAP_RTN_O
    JSR 1F:03B4
    BCC 1F:07F9
MAP_RTN_O: ; 1F:07F5, 0x03E7F5
    LDA #$88
    STA **:$003E
    JMP 1F:0567
    LDA ENGINE_FLAG_25_SKIP_UNK
    BNE 1F:0803
    JMP ADDS_IDFK
    PLA
    PLA
    JMP MAP_RTN_O
MAP_RTN_S: ; 1F:0808, 0x03E808
    JSR 1F:060E
    BCC MAP_RTN_O
    RTS
MAP_RTN_V: ; 1F:080E, 0x03E80E
    JSR 1F:060E
    BCC MAP_RTN_R
    RTS
MAP_RTN_R: ; 1F:0814, 0x03E814
    JSR 1F:07FC
    AND #$E0
    LSR A
    LSR A
    LSR A
    LSR A
    CMP #$08
    BCS MAP_RTN_O
    LDY #$15
    STA [ENGINE_FPTR_30[2]],Y
    JSR MAP_RTN_O
    JMP 1F:074D
    CMP #$00
    BNE MAP_RTN_O
    STA SCRIPT_FLAG_0x22
    LDY #$1D
    LDA [ENGINE_FPTR_30[2]],Y
    AND #$7F
    PHA
    JSR STREAM_UNK
    PLA
    JMP SWITCH_MAP/SCREEN?
MAP_RTN_F: ; 1F:083F, 0x03E83F
    LDY #$1A
    LDA [ENGINE_FPTR_30[2]],Y
    BNE 1F:086B
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
    BCC 1F:082B
    LDY #$19
    STA [ENGINE_FPTR_30[2]],Y
    LDY #$01
    LDA [ENGINE_FPTR_32[2]],Y
    LDY #$1A
    SEC
    SBC #$01
    STA [ENGINE_FPTR_30[2]],Y
    BNE 1F:088F
    LDY #$1E
    LDA [ENGINE_FPTR_30[2]],Y
    STA ENGINE_FPTR_32[2]
    INY
    LDA [ENGINE_FPTR_30[2]],Y
    STA ENGINE_FPTR_32+1
    LDY #$00
    LDA [ENGINE_FPTR_32[2]],Y
    CMP #$10
    BCS 1F:088F
    SEC
    LDA #$28
    SBC GAME_SLOT_CURRENT?
    CLC
    ADC #$84
    STA MAIN_FLAG_UNK
    LDY #$19
    LDA [ENGINE_FPTR_30[2]],Y
    TAX
    AND #$20
    BEQ 1F:08A2
    LDY #$1D
    LDA [ENGINE_FPTR_30[2]],Y
    ASL A
    ASL A
    TAY
    LDA ROUTINE_ATTR_A,Y
    LDY #$08
    STA [ENGINE_FPTR_30[2]],Y
    TXA
    AND #$08
    BNE 1F:08B2
    LDY #$15
    TXA
    AND #$07
    STA [ENGINE_FPTR_30[2]],Y
    TXA
    BMI 1F:08C1
    PHA
    AND #$07
    STA **:$003E
    JSR 1F:05BD
    PLA
    TAX
    BPL 1F:08C5
    LDA #$88
    STA **:$003E
    TXA
    AND #$40
    ASL A
    ORA #$70
    ORA **:$003E
    STA SCRIPT_FLAG_0x22
    JMP 1F:0567
MAP_RTN_AC: ; 1F:08D2, 0x03E8D2
    JSR 1F:060E
    BCC 1F:08D8
    RTS
    JSR MAP_RTN_O
    JMP 1F:08E1
MAP_RTN_J: ; 1F:08DE, 0x03E8DE
    JSR MAP_RTN_I
    JSR 1F:074D
    LDA #$74
    BNE 1F:0900
MAP_RTN_AG: ; 1F:08E8, 0x03E8E8
    JSR 1F:060E
    BCC 1F:08EE
    RTS
    JSR MAP_RTN_O
    LDA #$74
    BNE 1F:0900
MAP_RTN_AF: ; 1F:08F5, 0x03E8F5
    JSR 1F:060E
    BCC 1F:08FB
    RTS
    JSR MAP_RTN_O
    LDA #$72
    LDX #$01
    JMP ENGINE_SET_MAPPER_BANK_X_VAL_A
MAP_RTN_K: ; 1F:0905, 0x03E905
    LDA FLAG_UNK_23
    CLC
    BNE 1F:095B
    LDA **:$003E
    BMI 1F:092F
    LDY #$1D
    LDA [ENGINE_FPTR_30[2]],Y
    TAX
    LDA **:$000C
    STA [ENGINE_FPTR_30[2]],Y
    TXA
    LDY #$15
    STA [ENGINE_FPTR_30[2]],Y
    STA **:$000C
    LDY #$19
    LDA [ENGINE_FPTR_30[2]],Y
    TAX
    LDA **:$003E
    STA [ENGINE_FPTR_30[2]],Y
    TXA
    STA **:$003E
    BMI 1F:092F
    JSR 1F:05BD
    JSR 1F:0567
    JSR 1F:0A24
    LDY #$08
    LDA [ENGINE_FPTR_30[2]],Y
    AND #$0F
    CMP #$0A
    BEQ 1F:0940
    RTS
    LDA **:$00D5
    ASL A
    AND #$02
    ORA #$70
    LDX #$01
    JMP ENGINE_SET_MAPPER_BANK_X_VAL_A
    LDA #$88
    STA SCRIPT_UNK_DATA_SELECT_??
    LDA #$00
    STA NMI_FLAG_E7
    STA NMI_FP_UNK[2]
    STA NMI_FP_UNK+1
    JSR 1F:0733
    LDA #$00
    STA **:$003E
    STA FLAG_UNK_23
    LDA #$10
    BCS 1F:0967
    LDA #$80
    LDY #$00
    STA [ENGINE_FPTR_30[2]],Y
    RTS
MAP_RTN_G: ; 1F:096C, 0x03E96C
    LDA FLAG_UNK_23
    ASL A
    BNE 1F:094C
    JSR 1F:09CD
    BMI 1F:09A9
    LDY #$15
    STA [ENGINE_FPTR_30[2]],Y
    STA **:$000C
    STA **:$003E
    JSR 1F:05BD
    LDA ENGINE_FLAG_25_SKIP_UNK
    CMP #$28
    BCS 1F:09AD
    JSR 1F:09FA
    BCS 1F:09A9
    JSR 1F:03B4
    BCS 1F:09A9
    BIT **:$003F
    BPL 1F:09AD
    BVS 1F:099F
    LDA **:$003E
    SBC #$00
    AND #$0F
    BPL 1F:097C
    LDY #$15
    LDA #$00
    STA [ENGINE_FPTR_30[2]],Y
    STA **:$000C
    BCC 1F:09AD
    LDA #$88
    STA **:$003E
    JSR 1F:0567
    JSR 1F:0A24
    LDA **:$003E
    STA SCRIPT_UNK_DATA_SELECT_??
    LDY #$09
    LDA [ENGINE_FPTR_30[2]],Y
    AND #$40
    ORA ACTION_BUTTONS_RESULT
    STA NMI_FLAG_E7
    LDY #$0C
    LDA [ENGINE_FPTR_30[2]],Y
    STA NMI_FP_UNK[2]
    INY
    LDA [ENGINE_FPTR_30[2]],Y
    STA NMI_FP_UNK+1
    RTS
    LDA SCRIPT_FLAG_0x22
    BEQ 1F:09E1
    BPL 1F:09D4
    RTS
    LDY #$19
    LDA [ENGINE_FPTR_30[2]],Y
    TAX
    LDA SCRIPT_FLAG_0x22
    STA [ENGINE_FPTR_30[2]],Y
    TXA
    AND #$8F
    RTS
    LDA CTRL_BUTTONS_PREVIOUS[2]
    AND #$0F
    TAX
    LDA **:$000D
    BPL 1F:09F3
    AND #$0F
    CMP 1F:0BDD,X
    BEQ 1F:09F7
    STA **:$000D
    LDA 1F:0BDD,X
    RTS
    LDA #$88
    RTS
    JSR SUB_STREAM_RESET_TO_??_AND_PTR/VAL_RTN
    BEQ 1F:0A22
    ASL A
    LDA **:$003E
    AND #$01
    BEQ 1F:0A08
    BCS 1F:0A1C
    LDA **:$000F
    BNE 1F:0A1A
    LDY #$1B
    LDA **:$003E
    ORA #$40
    STA [ENGINE_FPTR_32[2]],Y
    BIT MAIN_FLAG_UNK
    BMI 1F:0A1A
    STX MAIN_FLAG_UNK
    BCC 1F:0A23
    LDA SCRIPT_FLAG_0x22
    AND #$10
    BEQ 1F:0A23
    CLC
    RTS
    JSR STREAM_PTR_30_PTR_DATA_TO_32
    LDY #$01
    LDA [ENGINE_FPTR_32[2]],Y
    AND #$40
    BEQ 1F:0A37
    LDY #$08
    LDA [ENGINE_FPTR_30[2]],Y
    AND #$3F
    STA [ENGINE_FPTR_30[2]],Y
    RTS
MAP_RTN_L: ; 1F:0A38, 0x03EA38
    LDY #$1A
    LDA [ENGINE_FPTR_30[2]],Y
    BNE 1F:0A7C
    LDA SCRIPT_R6_ROUTINE_SELECT
    JSR BANK_HANDLER_R6_AND_BASE
    ASL A
    TAX
    LDA $8000,X
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    LDA $8001,X
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    LDY #$1E
    LDA [ENGINE_FPTR_30[2]],Y
    ASL A
    TAY
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    STA ENGINE_FPTR_32[2]
    INY
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    STA ENGINE_FPTR_32+1
    LDY #$1F
    LDA [ENGINE_FPTR_30[2]],Y
    TAY
    LDA [ENGINE_FPTR_32[2]],Y
    CMP #$10
    BCC 1F:0A9B
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
    SEC
    SBC #$01
    STA [ENGINE_FPTR_30[2]],Y
    LDY #$19
    LDA [ENGINE_FPTR_30[2]],Y
    BMI 1F:0ABB
    AND #$0F
    STA **:$003E
    LDY #$15
    STA [ENGINE_FPTR_30[2]],Y
    JSR 1F:05BD
    JSR 1F:0B0B
    JSR 1F:059B
    JMP 1F:09B3
    CMP #$00
    BNE 1F:0AA1
    STA FLAG_UNK_23
    INY
    JSR L_1F:06A1
    INY
    TYA
    LDY #$1F
    STA [ENGINE_FPTR_30[2]],Y
    LDA FLAG_UNK_23
    BNE 1F:0ABB
    LDA #$80
    STA FLAG_UNK_23
    JSR L_1E:19FA
    LDX #$00
    JSR L_1E:0DAF
    LDA #$88
    STA **:$003E
    JSR 1F:0B0B
    JMP 1F:09B3
MAP_RTN_M: ; 1F:0AC5, 0x03EAC5
    LDA **:$003E
    BMI 1F:0B07
    LDY #$19
    LDA [ENGINE_FPTR_30[2]],Y
    TAX
    LDA **:$003E
    STA [ENGINE_FPTR_30[2]],Y
    TXA
    BMI 1F:0B07
    STA **:$003E
    LDY #$15
    EOR #$04
    STA [ENGINE_FPTR_30[2]],Y
    LDY #$06
    SEC
    LDA **:$6786
    SBC [ENGINE_FPTR_30[2]],Y
    INY
    LDA **:$6787
    SBC [ENGINE_FPTR_30[2]],Y
    LDY #$14
    LDA [ENGINE_FPTR_30[2]],Y
    BCS 1F:0AF4
    ORA #$10
    BIT 1F:0F29
    STA [ENGINE_FPTR_30[2]],Y
    JSR 1F:05BD
    JSR 1F:0B0B
    CPX #$40
    BCC 1F:0B04
    SBC #$04
    JMP 1F:059B
    LDA #$88
    STA **:$003E
    JSR 1F:0607
    LDY #$0C
    LDA 1F:0BF3,X
    STA [ENGINE_FPTR_30[2]],Y
    INY
    LDA 1F:0BF4,X
    STA [ENGINE_FPTR_30[2]],Y
    JSR 1F:073D
    JSR 1F:0746
    LDA **:$003E
    BMI 1F:0B39
    LDY #$15
    LDA [ENGINE_FPTR_30[2]],Y
    TAX
    LDA 1F:0C35,X
    TAX
    LDY #$08
    AND #$40
    ORA [ENGINE_FPTR_30[2]],Y
    STA [ENGINE_FPTR_30[2]],Y
    TXA
    AND #$1F
    RTS
MAP_RTN_H: ; 1F:0B3A, 0x03EB3A
    JSR 1F:09CD
    BMI 1F:0B70
    LDY #$15
    STA [ENGINE_FPTR_30[2]],Y
    STA SCRIPT_UNK_DATA_SELECT_??
    TAX
    LDY #$1A
    LDA [ENGINE_FPTR_30[2]],Y
    BEQ 1F:0B68
    BMI 1F:0B5B
    SEC
    SBC #$01
    STA [ENGINE_FPTR_30[2]],Y
    CMP #$05
    BCS 1F:0B68
    LDX #$07
    BCC 1F:0B68
    PHA
    CLC
    ADC #$01
    STA [ENGINE_FPTR_30[2]],Y
    PLA
    CMP #$FD
    BCS 1F:0B68
    LDX #$05
    STX **:$003E
    JSR 1F:05BD
    JMP 1F:0B76
    LDA #$88
    STA SCRIPT_UNK_DATA_SELECT_??
    STA **:$003E
    JSR 1F:0567
    JSR 1F:074D
    LDA SCRIPT_UNK_DATA_SELECT_??
    STA **:$003E
    JSR 1F:0607
    LDA ACTION_BUTTONS_RESULT
    STA NMI_FLAG_E7
    LDA 1F:0BF3,X
    STA NMI_FP_UNK[2]
    LDA 1F:0BF4,X
    STA NMI_FP_UNK+1
    RTS
MAP_RTN_I: ; 1F:0B92, 0x03EB92
    JSR 1F:09CD
    BMI 1F:0BC0
    LDY #$15
    STA [ENGINE_FPTR_30[2]],Y
    STA **:$003E
    JSR 1F:05BD
    JSR 1F:09FA
    BCS 1F:0BC0
    LDA SCRIPT_FLAG_0x22
    BNE 1F:0BC4
    LDA #$14
    LDX #$06
    JSR ENGINE_SET_MAPPER_BANK_X_VAL_A
    LDA STREAM_DEEP_C
    STA STREAM_UNK_DEEP_A[2]
    JSR 1F:0506
    LDA SCRIPT_R6_ROUTINE_SELECT
    JSR BANK_HANDLER_R6_AND_BASE
    BIT **:$003F
    BVS 1F:0BC4
    LDA #$88
    STA **:$003E
    JSR 1F:0567
    JMP 1F:09B3
MAP_RTN_N: ; 1F:0BCA, 0x03EBCA
    JSR 1F:09CD
    STA **:$003E
    BMI 1F:0BD4
    JSR 1F:05BD
    JSR 1F:0567
    JSR 1F:073D
    JMP 1F:09B3
    .db 88
    .db 02
    .db 06
    .db 88
    .db 04
    .db 03
    .db 05
    .db 88
    .db 00
    .db 01
    .db 07
    .db 88
    .db 88
    .db 88
    .db 88
    .db 88
LUT_MOD_0x0: ; [4], 1F:0BED, 0x03EBED
    .db 00
    .db 00
    .db C0
    .db FF
L_1F:0BF1: ; 1F:0BF1, 0x03EBF1
    .db 00
    .db 00
    .db 00
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
    STA SCRIPT_UNK_TESTED ; Set ??
    LDA #$7C
    STA FPTR_SPRITES?[2] ; Set ??
    STA FPTR_SPRITES?+1
    STA **:$0042
    STA **:$0043
    LDA #$00
    STA **:$0046 ; Clear ??
    LDA #$00
    STA **:$0045
    LDX #$09 ; Index ??
MOVE_ALL_POSITIVE: ; 1F:0C94, 0x03EC94
    LDA ROM_DATA_ARR_FUCK,X ; Move ??
    STA IRQ_SCRIPT_B,X
    DEX ; Index--
    BPL MOVE_ALL_POSITIVE ; Positive, goto.
    JSR LATCH_0x59_HIGHER_HELPER ; Latch helper.
    JMP ENGINE_NMI_0x01_SET/WAIT ; Wait and leave.
LIB_UNK_CA3: ; 1F:0CA3, 0x03ECA3
    LDA #$C3 ; Load ??
    JSR TODO_ROUTINE_MASK_A ; Do ??
    LDX #$1E ; Delay frames.
    JSR ENGINE_DELAY_X_FRAMES
    JSR L_1E:18D3 ; Do ??
    BCS RET_CS ; CS, goto.
    JSR L_1E:1A48 ; Do ??
    CLC
RET_CS: ; 1F:0CB6, 0x03ECB6
    PHP
    JSR L_1E:1977
    LDX #$3C
L_1F:0CBC: ; 1F:0CBC, 0x03ECBC
    JSR ENGINE_NMI_0x01_SET/WAIT
    LDA CTRL_BUTTONS_PREVIOUS[2]
    BNE L_1F:0CC6
    DEX
    BNE L_1F:0CBC
L_1F:0CC6: ; 1F:0CC6, 0x03ECC6
    JSR ENGINE_SETTLE_ALL_UPDATES?
    JSR ENGINE_PALETTE_FADE_OUT_NO_UPLOAD_CURRENT
    JSR ENGINE_PALETTE_SCRIPT_TO_UPLOADED
    LDA #$60
    LDX #$00
    JSR ENGINE_SET_MAPPER_BANK_X_VAL_A
    LDA #$00
    STA MMC3_MIRRORING
    STA NMI_LATCH_FLAG
    STA R_**:$0070
    STA ENGINE_PACKINATOR_ARG_SEED_0xA0_PRE_COUNT
    STA FLAG_UNK_48
    STA SCRIPT_UNK_TESTED
    STA RAM_CODE_UNK[3]
    PLP
    JMP ENGINE_NMI_0x01_SET/WAIT
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
    LDX #$FC
    BIT **:$04A2
    JSR ENGINE_SETTLE_ALL_UPDATES?
    STX NMI_FP_UNK+1
    LDX #$14
    LDA #$01
    STA NMI_FLAG_E5_TODO
    JSR ENGINE_SETTLE_ALL_UPDATES?
    JSR LATCH_0x59_HIGHER_HELPER
    DEX
    BNE 1F:0D08
    LDA #$00
    STA NMI_FP_UNK+1
    RTS
LATCH_0x59_HIGHER_HELPER: ; 1F:0D1A, 0x03ED1A
    SEC ; Prep sub.
    LDA #$59 ; Load val.
    SBC ENGINE_SCROLL_Y ; Sub with.
    STA NMI_LATCH_FLAG ; Store to latch.
    RTS ; Leave.
    CLC
    LDA #$02
    ADC **:$0046
    JSR LIB_WRITE_LATCH
    BIT **:$0045
    BPL 1F:0D6F
    LDA FPTR_SPRITES?[2]
    BPL 1F:0D34
    LDA #$7C
    STX MMC3_BANK_CFG
    STA MMC3_BANK_DATA
    INX
    LDA FPTR_SPRITES?+1
    BPL 1F:0D41
    LDA #$7C
    STX MMC3_BANK_CFG
    STA MMC3_BANK_DATA
    INX
    LDA **:$0042
    BPL 1F:0D4E
    LDA #$7C
    STX MMC3_BANK_CFG
    STA MMC3_BANK_DATA
    INX
    LDA **:$0043
    BPL 1F:0D5B
    LDA #$7C
    STX MMC3_BANK_CFG
    STA MMC3_BANK_DATA
    RTS
    SEC
    LDA #$23
    SBC **:$0046
    ASL A
    JSR LIB_WRITE_LATCH
    BIT **:$0045
    BVS 1F:0D2E
    LDA FPTR_SPRITES?[2]
    AND #$7F
    STX MMC3_BANK_CFG
    STA MMC3_BANK_DATA
    INX
    LDA FPTR_SPRITES?+1
    AND #$7F
    STX MMC3_BANK_CFG
    STA MMC3_BANK_DATA
    INX
    LDA **:$0042
    AND #$7F
    STX MMC3_BANK_CFG
    STA MMC3_BANK_DATA
    INX
    LDA **:$0043
    AND #$7F
    STX MMC3_BANK_CFG
    STA MMC3_BANK_DATA
    RTS
    LDA **:$0044
    STA **:$0046
    LDA #$C8
    JSR LIB_WRITE_LATCH
    STA MMC3_IRQ_DISABLE
    LDA MAPPER_BANK_VALS+2
    STX MMC3_BANK_CFG
    STA MMC3_BANK_DATA
    INX
    LDA MAPPER_BANK_VALS+3
    STX MMC3_BANK_CFG
    STA MMC3_BANK_DATA
    INX
    LDA MAPPER_BANK_VALS+4
    STX MMC3_BANK_CFG
    STA MMC3_BANK_DATA
    INX
    LDA MAPPER_BANK_VALS+5
    STX MMC3_BANK_CFG
    STA MMC3_BANK_DATA
    RTS
    JSR DELAY_Y_0x4
    LDX #$24
    LDA #$1F
    BIT PPU_STATUS
    STX PPU_ADDR
    STA PPU_ADDR
    RTS
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
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2] ; Init FPTR.
    STX ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle.
    LDY #$1F ; Index.
COUNT_POSITIVE: ; 1F:0EA6, 0x03EEA6
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y ; From index.
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
    STA NMI_PPU_CMD_PACKETS_BUF[64]
    LDA #$00
    STA NMI_PPU_CMD_PACKETS_BUF+1 ; EOF.
    STA NMI_PPU_CMD_PACKETS_INDEX ; Reset index, new update.
    LDA #$80
    STA NMI_FLAG_E5_TODO ; Set flag.
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
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2] ; Store val.
    ASL ENGINE_PALETTE_FPTR/BITS/GEN_USE[2] ; Shift it.
    BCC RTS ; CC, leave.
    JSR ADDS_IDFK ; Adds ??
    AND #$C0 ; Keep 1100.0000
    BNE RTS ; Nonzero, leave.
    JSR ENGINE_PALETTE_SCRIPT_TO_TARGET ; Do.
    JSR ENGINE_PALETTE_FADE_SKIP_INDEX_0xE? ; Do ??
    LDX #$0A ; Seed ??
LOOP_X_TIMES: ; 1F:0F0C, 0x03EF0C
    LDA #$07 ; Seed ??
    STA **:$07F0 ; Set ??
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
    STA **:$07F1 ; Set ??
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
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    CLC ; Prep add.
    LDA ARR_UNK,X ; Load from arr.
    ADC ARR_BITS_TO_UNK[8] ; Add with.
    LDY #$00 ; Stream.
    CMP [FPTR_SPRITES?[2]],Y ; If _ stream
    BCS VAL_GTE_STREAM ; >=, goto.
    STA ARR_BITS_TO_UNK[8] ; Store result from add.
    STA ARR_BITS_TO_UNK+2
    LDA [FPTR_SPRITES?[2]],Y ; Load from FPTR.
    LDX ENGINE_PALETTE_FPTR/BITS/GEN_USE[2] ; X from.
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
    STA **:$07F1
RELOOP: ; 1F:1052, 0x03F052
    JMP TABLE_NEGATIVE ; Goto.
VAL_GTE_STREAM: ; 1F:1055, 0x03F055
    LDY #$04 ; Stream index.
    LDA MENU_HELPER_STATUS? ; Load.
    AND [FPTR_SPRITES?[2]],Y ; And with arr.
    BEQ RELOOP ; == 0, goto.
    STA MENU_HELPER_STATUS? ; Store bits.
    LDA #$0D
    STA **:$07F1 ; Seed ??
    JMP EXIT_OFF_SCREEN
VAL_EQ_0x00: ; 1F:1067, 0x03F067
    LDX ARR_BITS_TO_UNK+3 ; X from.
    LDY #$01 ; Val ??
    LDA **:$00D6 ; Load.
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
    ROR ENGINE_PALETTE_FPTR/BITS/GEN_USE+1 ; Rotate bits.
    ROR ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    BCC ROTATE_CC
    CLC ; Prep add.
    ADC SAVE_GAME_MOD_PAGE_PTR[2] ; Add val.
ROTATE_CC: ; 1F:10FE, 0x03F0FE
    ROR A ; Rotate into A.
    DEX ; Count--
    BNE VAL_NONZERO ; != 0, goto.
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE+2 ; Store val.
    ROR ENGINE_PALETTE_FPTR/BITS/GEN_USE+1 ; Rotate bits.
    ROR ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    RTS ; Return.
LIB_DECIMAL?_UNK: ; 1F:1109, 0x03F109
    LDA #$00 ; Clear init.
    LDX #$18 ; Bits to check count.
VAL_NONZERO: ; 1F:110D, 0x03F10D
    ROR ENGINE_PALETTE_FPTR/BITS/GEN_USE+2 ; Rotate bits.
    ROR ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    ROR ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    BCC ROTATE_CLEAR ; Clear, rotate.
    CLC ; Prep add.
    ADC SAVE_GAME_MOD_PAGE_PTR[2] ; Add val.
ROTATE_CLEAR: ; 1F:1118, 0x03F118
    ROR A ; Rotate into A.
    DEX ; Loops--
    BNE VAL_NONZERO ; != 0, goto.
    STA ENGINE_TO_DECIMAL_INDEX_POSITION ; Store result.
    ROR ENGINE_PALETTE_FPTR/BITS/GEN_USE+2 ; Rotate all bits.
    ROR ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    ROR ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    RTS ; Leave.
ENGINE_NUMS_IDFK: ; 1F:1125, 0x03F125
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2] ; Store bits.
    STX SAVE_GAME_MOD_PAGE_PTR[2] ; Store stride?
    LDA #$00 ; Seed ??
    LDX #$08 ; Loop count.
LOOPS_NONZERO: ; 1F:112D, 0x03F12D
    ROR ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    BCC ROTATE_CLEAR ; Clear, goto.
    CLC ; Prep add.
    ADC SAVE_GAME_MOD_PAGE_PTR[2] ; Add with.
ROTATE_CLEAR: ; 1F:1134, 0x03F134
    ROR A ; Carry into A.
    DEX ; Loops--
    BNE LOOPS_NONZERO ; != 0, goto.
    TAX ; Val to X.
    LDA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2] ; Load.
    ROR A ; Rotate into A.
    RTS ; Leave.
ENGINE_NUMS_UNK_MODULO?: ; 1F:113D, 0x03F13D
    LDA SAVE_GAME_MOD_PAGE_PTR[2] ; Load.
ENGINE_HOLD_FOREVER_IF_ZERO: ; 1F:113F, 0x03F13F
    BEQ ENGINE_HOLD_FOREVER_IF_ZERO ; == 0, loop forever.
    LDA #$00 ; Init.
    LDX #$18 ; Bits count.
    ROL ENGINE_PALETTE_FPTR/BITS/GEN_USE[2] ; Rotate bits.
    ROL ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    ROL ENGINE_PALETTE_FPTR/BITS/GEN_USE+2
PROCESS_WHOLE_NUMBER: ; 1F:114B, 0x03F14B
    ROL A ; Into A.
    BCS ROTATE_CS ; CS, goto.
    CMP SAVE_GAME_MOD_PAGE_PTR[2] ; If _ val
    BCC VAL_LT_VAR ; <, goto.
ROTATE_CS: ; 1F:1152, 0x03F152
    SBC SAVE_GAME_MOD_PAGE_PTR[2] ; Sub with.
    SEC ; Bring in 0x1
VAL_LT_VAR: ; 1F:1155, 0x03F155
    ROL ENGINE_PALETTE_FPTR/BITS/GEN_USE[2] ; Rotate up.
    ROL ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    ROL ENGINE_PALETTE_FPTR/BITS/GEN_USE+2
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
    ROL ENGINE_PALETTE_FPTR/BITS/GEN_USE[2] ; Rotate to begin.
    ROL ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    ROL ENGINE_PALETTE_FPTR/BITS/GEN_USE+2
TODO_COUNT: ; 1F:116E, 0x03F16E
    ROL A ; ...into A.
    CMP #$0A ; If _ #$0A
    BCC VAL_IN_DECIMAL_RANGE ; <, goto, 0 back in.
    SBC #$0A ; Adjust. CS after, still.
VAL_IN_DECIMAL_RANGE: ; 1F:1175, 0x03F175
    ROL ENGINE_PALETTE_FPTR/BITS/GEN_USE[2] ; Rotate again. CC in if no overflow. CS otherwise.
    ROL ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    ROL ENGINE_PALETTE_FPTR/BITS/GEN_USE+2
    DEX ; Loops--
    BNE TODO_COUNT ; != 0, loop.
    TAX ; Val to X.
    LDA LUT_NUMBER_TILES,X ; Move ??
    STA ARR_BITS_TO_UNK[8],Y ; Store to, number output.
    LDA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2] ; Combine all.
    ORA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    ORA ENGINE_PALETTE_FPTR/BITS/GEN_USE+2
    BNE LOOP_FIGURE_NEXT_DIGIT ; More to do since bits left, do.
    STY ENGINE_TO_DECIMAL_INDEX_POSITION ; Index to.
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
L_1F:11A4: ; 1F:11A4, 0x03F1A4
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
    ROR ENGINE_PALETTE_FPTR/BITS/GEN_USE+2 ; Rotate bits.
    ROR ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    ROR ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    BCC ROTATE_CC ; CC, goto.
    ADC #$09 ; Add 0xA, CS here. CC after.
ROTATE_CC: ; 1F:11BC, 0x03F1BC
    ROR A ; Rotate result.
    DEX ; Count--
    BNE LOOP_MORE_BITS ; != 0, do more.
    ROR ENGINE_PALETTE_FPTR/BITS/GEN_USE+2 ; Rotate bits.
    ROR ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    ROR ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
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
    ADC ENGINE_PALETTE_FPTR/BITS/GEN_USE[2] ; Add with.
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2] ; Store to.
    LDA #$00
    ADC ENGINE_PALETTE_FPTR/BITS/GEN_USE+1 ; Carry add.
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1 ; Store result.
    LDA #$00
    ADC ENGINE_PALETTE_FPTR/BITS/GEN_USE+2 ; Carry add.
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE+2
    INY ; Digit++
    CPY #$08 ; If _ #$08
    BCC ENGINE_DEC_TO_BIN24 ; <, goto.
    RTS ; Leave.
ADDS_IDFK: ; 1F:11ED, 0x03F1ED
    CLC ; Prep add.
    LDA **:$0026 ; Load.
    ADC **:$0027 ; Add with.
    STA **:$0027 ; Store to.
    CLC ; Prep add.
    LDA **:$0026 ; Load.
    ADC #$75 ; Add with.
    STA **:$0026 ; Store to.
    LDA **:$0027 ; Load.
    ADC #$63 ; Add with.
    STA **:$0027 ; Store to.
    RTS
LIB_UNK: ; 1F:1202, 0x03F202
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
    JSR SUB_UNK ; Do ??
    JSR LIB_UNK_CA3
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
    CMP VAL_CMP_UNK ; If _ val
    BEQ VAL_CMP_EQ ; ==, goto.
    STA VAL_CMP_DIFFERS_STORED_UNK ; Store if differs.
VAL_CMP_EQ: ; 1F:125D, 0x03F25D
    RTS ; Leave.
ENGINE_WAIT_X_TIMES_UNK: ; 1F:125E, 0x03F25E
    TXA ; X to A.
    BEQ RTS ; == 0, leave.
    PHA ; Save it.
    JSR ENGINE_NMI_0x01_SET/WAIT ; Wait.
    PLA ; Pull.
    TAX ; Back to X.
    DEX ; X--
    BNE ENGINE_WAIT_X_TIMES_UNK ; != 0, goto.
RTS: ; 1F:126A, 0x03F26A
    RTS
    INX
    TXA
    PHA
    JSR 1F:127C
    PLA
    TAX
    DEX
    BNE 1F:126C
    JSR 1F:127C
    JMP 1F:14B6
    LDX #$2F
    TXA
    PHA
    AND #$0F
    LSR A
    TAX
    LDA 1F:1296,X
    JSR 1F:14B8
    JSR ENGINE_NMI_0x01_SET/WAIT
    JSR ENGINE_NMI_0x01_SET/WAIT
    PLA
    TAX
    DEX
    BNE 1F:127E
    RTS
    AND [SCRIPT_FLAG_0x22,X]
    ???
    BIT ENGINE_FLAG_25_SKIP_UNK
    BIT FLAG_UNK_23
    ???
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
RTN_UNK_DATA_AFTER: ; 1F:12AE, 0x03F2AE
    ASL A
    TAY
    INY
    INY
    INY
    PLA
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    PLA
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE+2
    INY
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    STA ENGINE_TO_DECIMAL_INDEX_POSITION
    LDY #$01
    SEC
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    SBC #$01
    TAX
    INY
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    SBC #$00
    PHA
    TXA
    PHA
    JMP [ENGINE_PALETTE_FPTR/BITS/GEN_USE+2]
DATA_PAST_UNK: ; 1F:12D5, 0x03F2D5
    ASL A
    TAY
    INY
    PLA
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    PLA
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    SEC
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    SBC #$01
    TAX
    INY
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    SBC #$00
    PHA
    TXA
    PHA
    RTS
    PHA
    TXA
    PHA
    TYA
    PHA
    LDA ENGINE_TO_DECIMAL_INDEX_POSITION
    PHA
    LDA ENGINE_PALETTE_FPTR/BITS/GEN_USE+2
    PHA
    LDA SAVE_GAME_MOD_PAGE_PTR+1
    PHA
    LDA SAVE_GAME_MOD_PAGE_PTR[2]
    PHA
    LDA ARR_BITS_TO_UNK+1
    PHA
    LDA ARR_BITS_TO_UNK[8]
    PHA
    LDA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    AND #$FC
    PHA
    LDX #$06
    ASL ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    ROL ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    DEX
    BNE 1F:130B
    STX ENGINE_PALETTE_FPTR/BITS/GEN_USE+2
    TXA
    PHA
    LDA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    PHA
    LDA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    PHA
    LDA #$64
    STA SAVE_GAME_MOD_PAGE_PTR[2]
    JSR ENGINE_NUMS_UNK_MODULO?
    JSR ADDS_IDFK
    LSR A
    PHP
    TAX
    LDA 1F:137D,X
    STA SAVE_GAME_MOD_PAGE_PTR[2]
    JSR LIB_DECIMAL?_UNK
    PLP
    BCS 1F:1346
    PLA
    ADC ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    PLA
    ADC ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    PLA
    ADC ENGINE_PALETTE_FPTR/BITS/GEN_USE+2
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE+2
    JMP 1F:1355
    PLA
    SBC ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    PLA
    SBC ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    PLA
    SBC ENGINE_PALETTE_FPTR/BITS/GEN_USE+2
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE+2
    LDX #$06
    LSR ENGINE_PALETTE_FPTR/BITS/GEN_USE+2
    ROR ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    ROR ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    DEX
    BNE 1F:1357
    PLA
    ORA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    PLA
    STA ARR_BITS_TO_UNK[8]
    PLA
    STA ARR_BITS_TO_UNK+1
    PLA
    STA SAVE_GAME_MOD_PAGE_PTR[2]
    PLA
    STA SAVE_GAME_MOD_PAGE_PTR+1
    PLA
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE+2
    PLA
    STA ENGINE_TO_DECIMAL_INDEX_POSITION
    PLA
    TAY
    PLA
    TAX
    PLA
    RTS
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
    CLC
L_1F:13FD: ; 1F:13FD, 0x03F3FD
    TAX
    LDA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    PHA
    LDA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    PHA
    STX ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    LDA #$00
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    JSR 1F:12ED
    LDA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    BEQ 1F:1415
    LDA #$FF
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    LDX ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    PLA
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    PLA
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    TXA
    RTS
    PHA
    ASL A
    ASL A
    BEQ 1F:1463
    TAX
    LDA $9EEA,X
    STA SAVE_GAME_MOD_PAGE_PTR+1
    LDA $9EEB,X
    STA ALT_COUNT_UNK
    LDA $9EE9,X
    CMP #$00
    BNE 1F:143E
    LDA SAVE_GAME_MOD_PAGE_PTR+1
    STA **:$07F0
    JMP 1F:145B
    CMP #$01
    BNE 1F:144A
    LDA SAVE_GAME_MOD_PAGE_PTR+1
    STA **:$07F1
    JMP 1F:145B
    CMP #$02
    BNE 1F:1456
    LDA SAVE_GAME_MOD_PAGE_PTR+1
    STA **:$07F3
    JMP 1F:145B
    LDA SAVE_GAME_MOD_PAGE_PTR+1
    STA **:$07F4
    LDX ALT_COUNT_UNK
    JSR ENGINE_WAIT_X_TIMES_UNK
    JSR ENGINE_SET_MAPPER_R6_TO_0x16
    PLA
    RTS
    LDX #$0F
    TXA
    PHA
    LDA #$05
    STA **:$07F1
    LDX #$02
    JSR ENGINE_WAIT_X_TIMES_UNK
    PLA
    TAX
    DEX
    BNE 1F:1467
    RTS
LIB_VAL_TO_DECIMAL_AND_FILE?: ; 1F:1479, 0x03F479
    LDA FLAG_UNK_48 ; Val ??
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2] ; Move.
    LDA #$00
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1 ; Clear bits upper.
    LDA #$0A
    STA SAVE_GAME_MOD_PAGE_PTR[2] ; Val inc.
    JSR LIB_DECIMAL?_UNK ; Do ??
    CLC
    LDA #$98 ; Load ??
    ADC ENGINE_PALETTE_FPTR/BITS/GEN_USE[2] ; Add with.
    STA FPTR_5C_UNK[2] ; Store result.
    LDA #$8F ; Load.
    ADC ENGINE_PALETTE_FPTR/BITS/GEN_USE+1 ; Add ??
    STA FPTR_5C_UNK+1 ; Store result.
    RTS ; Leave.Leave.
ENGINE_SET_PALETTE_AND_QUEUE_UPLOAD: ; 1F:1496, 0x03F496
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle.
    LDY #$1F ; Index.
STREAM_POSITIVE: ; 1F:149B, 0x03F49B
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y ; Load from stream.
    STA SCRIPT_PALETTE_UPLOADED?[32],Y ; Store to arr.
    DEY ; Stream--
    BPL STREAM_POSITIVE ; Positive, goto.
    LDA #$04
    STA NMI_PPU_CMD_PACKETS_BUF[64] ; Queue palette update.
    LDA #$00
    STA NMI_PPU_CMD_PACKETS_BUF+1 ; EOF for update.
    LDA #$00
    STA NMI_PPU_CMD_PACKETS_INDEX ; Reset index.
    LDA #$80
    STA NMI_FLAG_E5_TODO ; Set flag.
    RTS ; Leave.
    LDA #$0F
    PHA
    JSR ENGINE_SETTLE_ALL_UPDATES?
    PLA
    LDY #$1C
    STA SCRIPT_PALETTE_UPLOADED?[32],Y
    DEY
    DEY
    DEY
    DEY
    BPL 1F:14BF
    JSR 1F:14A3
    JMP ENGINE_NMI_0x01_SET/WAIT
LIB_SUB_TODO: ; 1F:14CE, 0x03F4CE
    ASL A
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    TXA
    PHA
    TYA
    PHA
    JSR ENGINE_SET_MAPPER_R6_TO_0x00
    LDY ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    LDA $8C00,Y
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    LDA $8C01,Y
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    LDY #$00
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    STA ALT_STUFF_INDEX?
    INY
    LDX PACKET_HPOS_COORD?
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    CMP #$FF
    BEQ STREAM_EQ_0xFF ; ==, goto.
    TAX ; Val to X.
STREAM_EQ_0xFF: ; 1F:14F4, 0x03F4F4
    STX ENGINE_PALETTE_FPTR/BITS/GEN_USE+2
    INY
    LDX PACKET_YPOS_COORD?
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    CMP #$FF
    BEQ 1F:1500
    TAX
    STX ENGINE_TO_DECIMAL_INDEX_POSITION
LIB_X_STORE_UNK: ; 1F:1502, 0x03F502
    INY ; Stream++
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y ; Load from stream.
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
    JSR LIB_MOVE_PTR_LOL
    JMP LIB_X_STORE_UNK
X_STORE_AND_RERUN: ; 1F:1521, 0x03F521
    STX ALT_COUNT_UNK ; Store X.
    JMP LIB_X_STORE_UNK ; Loop, goto.
EXIT_RESTORE_R6: ; 1F:1526, 0x03F526
    JSR ENGINE_SET_MAPPER_R6_TO_0x16
    PLA
    TAY
    PLA
    TAX
    RTS
LIB_MOVE_PTR_LOL: ; 1F:152E, 0x03F52E
    TAX ; A to X, count.
    INY ; Stream++
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y ; Move ??
    STA SAVE_GAME_MOD_PAGE_PTR[2]
    INY ; Stream++
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y ; Move ??
    STA SAVE_GAME_MOD_PAGE_PTR+1
X_NONZERO: ; 1F:1539, 0x03F539
    TXA ; Save X and Y.
    PHA
    TYA
    PHA
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle.
    LDA #$00
    STA R_**:$0070 ; Clear ??
    LDA ENGINE_PALETTE_FPTR/BITS/GEN_USE+2 ; Move ??
    STA PACKET_HPOS_COORD?
    LDA SAVE_GAME_MOD_PAGE_PTR[2] ; 2x
    STA FPTR_PACKET_CREATION[2]
    LDA SAVE_GAME_MOD_PAGE_PTR+1 ; 3x
    STA FPTR_PACKET_CREATION+1
    JSR LIB_SAVE_STATE_FULL? ; Save state.
    CLC ; Prep add.
    LDA ENGINE_TO_DECIMAL_INDEX_POSITION ; Load ??
    ADC ALT_STUFF_INDEX? ; Add with.
    STA ENGINE_TO_DECIMAL_INDEX_POSITION ; Store result.
    PLA
    TAY ; Restore X and Y.
    PLA
    TAX
    DEX ; X--
    BNE X_NONZERO ; != 0, loop.
    RTS ; Leave.
LIB_SAVE_STATE_FULL?: ; 1F:1562, 0x03F562
    LDA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1 ; Stack this stuff.
    PHA
    LDA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    PHA
    LDA ENGINE_PALETTE_FPTR/BITS/GEN_USE+2
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
    LDA ENGINE_TO_DECIMAL_INDEX_POSITION ; Move ??
    STA PACKET_YPOS_COORD?
    PHA ; Save it, too.
    JSR ENGINE_CREATE_UPDATE_BUF_INIT_INC? ; Do.
    PLA ; Pull saved.
    STA ENGINE_TO_DECIMAL_INDEX_POSITION ; Store back.
    JMP LIB_STATE_RESTORE ; Restore.
VAL_EQ_0x00: ; 1F:158D, 0x03F58D
    CLC ; Prep add.
    LDA ENGINE_TO_DECIMAL_INDEX_POSITION ; Load val.
    ADC ALT_STUFF_INDEX? ; Mod val.
    STA PACKET_YPOS_COORD? ; Store to.
    PHA ; Save it, too.
    JSR RTN_SETTLE_UPDATE_TODO ; Do.
    PLA ; Pull saved.
    STA ENGINE_TO_DECIMAL_INDEX_POSITION ; Restore it.
    JMP LIB_STATE_RESTORE ; Restore.
LIB_STATE_RESTORE_WITH_UPDATE: ; 1F:159E, 0x03F59E
    CLC ; Prep add.
    LDA ENGINE_TO_DECIMAL_INDEX_POSITION ; Load ??
    ADC ALT_STUFF_INDEX? ; Add with.
    STA PACKET_YPOS_COORD? ; Store to.
    PHA ; Save it.
    JSR ENGINE_CREATE_UPDATE_BUF_INIT_DEC? ; Do update.
    PLA ; Pull it.
    STA ENGINE_TO_DECIMAL_INDEX_POSITION ; Restore it.
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
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE+2
    PLA
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    PLA
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
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
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE+2 ; A to.
    LDA #$00 ; Init clear.
    ASL ENGINE_PALETTE_FPTR/BITS/GEN_USE+2 ; << 1, *2.
    ROL A ; Into A.
    ASL ENGINE_PALETTE_FPTR/BITS/GEN_USE+2 ; 2x
    ROL A
    ASL ENGINE_PALETTE_FPTR/BITS/GEN_USE+2 ; 3x
    ROL A
    STA ENGINE_TO_DECIMAL_INDEX_POSITION ; A result to.
    CLC
    LDA ENGINE_PALETTE_FPTR/BITS/GEN_USE+2 ; LOad.
    ADC #$00 ; += 0x00
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE+2 ; Store result.
    LDA ENGINE_TO_DECIMAL_INDEX_POSITION ; Load.
    ADC #$9E ; += 0x9E
    STA ENGINE_TO_DECIMAL_INDEX_POSITION ; Store result.
    RTS ; Leave.
LIB_IDFK: ; 1F:1614, 0x03F614
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle.
    LDY #$E8
    STY ARR_BITS_TO_UNK[8] ; Set ??
    LDA #$DF
    STA ARR_BITS_TO_UNK+1
    LDY **:$6707 ; Y from.
    SEC
    LDA ARR_BITS_TO_UNK+1
    SBC #$10
    STA ARR_BITS_TO_UNK+1
    DEY
    BNE 1F:1622
    LDA #$00
    STA ALT_STUFF_INDEX?
    JSR ENGINE_SETTLE_ALL_UPDATES?
    LDY ALT_STUFF_INDEX?
    LDA STREAM_INDEXES_ARR_UNK[24],Y
    BEQ 1F:1660
    LDA STREAM_INDEXES_ARR_UNK+17,Y
    AND #$06
    EOR #$06
    BEQ 1F:1660
    LDX #$02
    LDA STREAM_INDEXES_ARR_UNK+1,Y
    AND #$80
    BNE 1F:1655
    LDX #$01
    JSR 1F:1673
    BCC 1F:1655
    LDX #$00
    TXA
    JSR 1F:16AA
    CLC
    LDA ARR_BITS_TO_UNK[8]
    ADC #$08
    STA ARR_BITS_TO_UNK[8]
    CLC
    LDA ARR_BITS_TO_UNK+1
    ADC #$10
    STA ARR_BITS_TO_UNK+1
    CLC
    LDA ALT_STUFF_INDEX?
    ADC #$20
    STA ALT_STUFF_INDEX?
    CMP #$60
    BNE 1F:1630
    RTS
    TYA
    PHA
    LDA STREAM_PTRS_ARR_UNK[48],Y
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    LDA STREAM_PTRS_ARR_UNK+1,Y
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    LDA STREAM_INDEXES_ARR_UNK+3,Y
    STA SAVE_GAME_MOD_PAGE_PTR[2]
    LDA STREAM_INDEXES_ARR_UNK+4,Y
    STA SAVE_GAME_MOD_PAGE_PTR+1
    LDY #$03
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE+2
    INY
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    AND #$03
    STA ENGINE_TO_DECIMAL_INDEX_POSITION
    LSR ENGINE_TO_DECIMAL_INDEX_POSITION
    ROR ENGINE_PALETTE_FPTR/BITS/GEN_USE+2
    LSR ENGINE_TO_DECIMAL_INDEX_POSITION
    ROR ENGINE_PALETTE_FPTR/BITS/GEN_USE+2
    PLA
    TAY
    SEC
    LDA SAVE_GAME_MOD_PAGE_PTR[2]
    SBC ENGINE_PALETTE_FPTR/BITS/GEN_USE+2
    LDA SAVE_GAME_MOD_PAGE_PTR+1
    SBC ENGINE_TO_DECIMAL_INDEX_POSITION
    RTS
    PHA
    JSR ENGINE_SETTLE_ALL_UPDATES?
    PLA
    JSR RTN_UNK_DATA_AFTER
    TSX
    INC **:$00BF,X
    INC **:$00C8,X
    INC MAPPER_BANK_VALS[8],X
    INC **:$00A9,X
    ORA [FPTR_UNK_84_MENU?+1,X]
    SBC ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    LDA #$00
    LDX #$0C
    LDY #$97
    JMP 1F:16F9
    LDX ARR_BITS_TO_UNK[8]
    LDA **:$0300,X
    PHA
    LDA #$03
    LDX #$0C
    LDY #$97
    JSR 1F:16F9
    PLA
    CMP #$03
    BEQ 1F:16EF
    LDX #$04
    TXA
    PHA
    LDA #$00
    JSR 1F:1724
    LDA #$03
    JSR 1F:1724
    PLA
    TAX
    DEX
    BNE 1F:16DE
    RTS
    LDA #$03
    LDX #$10
    LDY #$97
    JMP 1F:16F9
    STX ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    STY ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    LDX ARR_BITS_TO_UNK[8]
    STA **:$0300,X
    LDA #$08
    STA **:$0301,X
    LDA #$70
    STA **:$0302,X
    LDA ARR_BITS_TO_UNK+1
    STA **:$0303,X
    LDA #$00
    STA **:$0304,X
    STA **:$0305,X
    LDA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    STA **:$0306,X
    LDA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    STA **:$0307,X
    RTS
    LDX ARR_BITS_TO_UNK[8]
    STA **:$0300,X
    LDA #$01
    STA NMI_FLAG_E5_TODO ; Set flag.
    LDX #$08
    JMP ENGINE_WAIT_X_TIMES_UNK ; Wait and leave abuse rts.
ENGINE_PALETTE_SIZE_UPDATE_FPTR_XY: ; 1F:1732, 0x03F732
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle.
    STX ENGINE_PALETTE_FPTR/BITS/GEN_USE[2] ; X and Y to FPTR.
    STY ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    LDY #$1F ; Index.
VAL_POSITIVE: ; 1F:173B, 0x03F73B
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y ; Load from stream.
    STA NMI_PPU_CMD_PACKETS_BUF[64],Y ; To.
    DEY ; Stream/index--
    BPL VAL_POSITIVE ; Positive, do more.
    LDA #$80
    STA NMI_FLAG_E5_TODO ; Set ??
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
    LDA **:$0059 ; Load ??
    BEQ RTS ; == 0, leave.
    BIT NMI_FLAG_OBJECT_PROCESSING? ; Test.
    BVS RTS ; 0x40 set, leave.
    LDX #$00 ; Clear val.
    LDA CONTROL_ACCUMULATED?[2] ; Load CTRL.
    STX CONTROL_ACCUMULATED?[2] ; Clear buttons.
    AND #$40 ; Test B.
    BEQ RTS ; Not pressed, leave.
    TXA ; Clear A.
    STA **:$0059 ; Clear ??
    STA **:$03E0 ; Clear ??
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
    LDA NMI_FLAG_E0_TODO
    BEQ NMI_EQ_ZERO ; == 0, goto.
    LDA NMI_FLAG_E5_TODO
    BNE NMI_BUF_PROCESSOR_CHECK ; != 0, goto.
    BEQ PAST_SETTLE_LOADED ; == 0, goto.
NMI_EQ_ZERO: ; 1F:17C2, 0x03F7C2
    LDA NMI_FLAG_E5_TODO ; Load.
    BEQ PAST_SETTLE_LOADED ; == 0, goto.
    AND #$7F ; Keep bits.
    STA NMI_FLAG_E0_TODO ; Set modded.
NMI_BUF_PROCESSOR_CHECK: ; 1F:17CA, 0x03F7CA
    LDA NMI_PPU_CMD_PACKETS_BUF[64],Y ; Load from buf.
    BEQ NMI_UPDATE_FINSIHED ; == 0, goto.
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
    STA NMI_PPU_CMD_PACKETS_BUF[64],Y ; Store to buf.
    BNE PAST_SETTLE_LOADED ; != 0, goto.
NMI_UPDATE_FINSIHED: ; 1F:17E3, 0x03F7E3
    STA NMI_FLAG_E5_TODO ; Clear.
PAST_SETTLE_LOADED: ; 1F:17E5, 0x03F7E5
    LDX NMI_LATCH_FLAG
    BEQ FLAG_CLEAR ; == 0, goto.
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
FLAG_CLEAR: ; 1F:1827, 0x03F827
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
    BEQ SKIP_UNK ; == 0, goto.
    LSR A ; >> 1, /2.
    AND #$03 ; Keep bottom bits.
    ORA #$44 ; Set 0100.01XX
    LDX #$02 ; GFX bank R2.
    JSR ENGINE_SET_MAPPER_BANK_X_VAL_A ; Set GFX.
    LDX #$03 ; GFX bank R3.
    JSR ENGINE_SET_MAPPER_BANK_X_VAL_A
    DEC NMI_GFX_COUNTER ; --
SKIP_UNK: ; 1F:185F, 0x03F85F
    JSR ENGINE_SET_BASE_R6/R7_0x1D ; Set.
    JSR $8000 ; Do banked handler.
    LDA NMI_FLAG_OBJECT_PROCESSING? ; Load ??
    BMI NMI_RESTORE_STATE ; Negative, goto.
    LDA NMI_FLAG_E7 ; Load.
    AND #$3F ; Keep 0011.1111
    STA BMI_FLAG_SET_DIFF_MODDED_UNK ; Store to.
    LDA NMI_FLAG_E0_TODO ; LOad.
    BNE NONZERO ; != 0, goto.
    JSR NMI_SPRITE_SWAP_UNK ; Swap sprites.
    JMP NMI_RESTORE_STATE ; Goto.
NONZERO: ; 1F:1879, 0x03F879
    CLC ; Sub -1
    SBC BMI_FLAG_SET_DIFF_MODDED_UNK ; Sub with, extra.
    BCS SUB_NO_UNDERFLOW ; No underflow, goto.
    LDX NMI_FLAG_E0_TODO ; Load ??
    DEX ; Index--
    STX BMI_FLAG_SET_DIFF_MODDED_UNK ; Store modded.,
    LDA #$00 ; Seed clear.
SUB_NO_UNDERFLOW: ; 1F:1885, 0x03F885
    STA NMI_FLAG_E0_TODO ; Store flag.
    JSR SUB_TODOOOOOOOOOOOOO ; Do, scrolly?
NMI_RESTORE_STATE: ; 1F:188A, 0x03F88A
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
    ADC NMI_PPU_CMD_PACKETS_BUF[64],Y ; Mod with value.
    TAY ; Back to index.
    JMP NMI_BUF_PROCESSOR_CHECK ; Re-launch with new index.
RTN_0x03: ; 1F:18E5, 0x03F8E5
    INY ; Index++
    LDA NMI_PPU_CMD_PACKETS_BUF[64],Y ; Load from buffer.
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
    LDA NMI_PPU_CMD_PACKETS_BUF[64],Y ; Load from buf.
    CMP #$05 ; If _ #$05
    BEQ RTN_0x05 ; Relaunch another packet.
    JMP NMI_BUF_PROCESSOR_CHECK ; Relaunch other pakcet type.
RTN_0x06: ; 1F:1923, 0x03F923
    LDA ENGINE_PPU_CTRL_COPY ; Load CTRL.
    ORA #$04 ; VRAM +32
    STA PPU_CTRL ; Set CTRL with option.
PACKET_RELAUNCH: ; 1F:192A, 0x03F92A
    JSR NMI_PACKET_UNIQUE_DATA_UPLOADER ; Upload the packet.
    LDA NMI_PPU_CMD_PACKETS_BUF[64],Y ; Load next packet.
    CMP #$06 ; Same type?
    BEQ PACKET_RELAUNCH ; ==, yes, reloop.
    LDA ENGINE_PPU_CTRL_COPY ; Set CTRL +1
    STA PPU_CTRL
    JMP NMI_BUF_PROCESSOR_CHECK ; Relaunch.
RTN_0x07: ; 1F:193C, 0x03F93C
    INY ; Get data.
    LDX NMI_PPU_CMD_PACKETS_BUF[64],Y ; Load count of single byte updates.
    INY
LOOP_UPDATES: ; 1F:1941, 0x03F941
    LDA NMI_PPU_CMD_PACKETS_BUF[64],Y ; Move addr from buf.
    STA PPU_ADDR
    INY
    LDA NMI_PPU_CMD_PACKETS_BUF[64],Y
    STA PPU_ADDR
    INY
    LDA NMI_PPU_CMD_PACKETS_BUF[64],Y ; Move data from buf.
    STA PPU_DATA
    INY
    DEX ; Count--
    BNE LOOP_UPDATES ; !=, goto.
    JMP NMI_BUF_PROCESSOR_CHECK ; Relaunch routine.
RTN_0x08: ; 1F:195C, 0x03F95C
    INY ; Buf++
    LDX NMI_PPU_CMD_PACKETS_BUF[64],Y ; Load count.
    INY ; Buf++
    LDA NMI_PPU_CMD_PACKETS_BUF[64],Y ; Write addr.
    STA PPU_ADDR
    INY ; Buf++
    LDA NMI_PPU_CMD_PACKETS_BUF[64],Y
    STA PPU_ADDR
    INY ; Buf++
    LDA NMI_PPU_CMD_PACKETS_BUF[64],Y ; Load data.
    INY ; Buf++
COUNT_MOVE_SINGLE: ; 1F:1973, 0x03F973
    STA PPU_DATA ; Store data.
    DEX ; Count--
    BNE COUNT_MOVE_SINGLE ; != 0, goto.
    JMP NMI_BUF_PROCESSOR_CHECK ; Relaunch.
RTN_0x09: ; 1F:197C, 0x03F97C
    INY ; Buf++
    LDX NMI_PPU_CMD_PACKETS_BUF[64],Y ; Count.
    INY ; Buf++
    LDA NMI_PPU_CMD_PACKETS_BUF[64],Y ; Move addr.
    STA PPU_ADDR
    INY ; Buf++
    LDA NMI_PPU_CMD_PACKETS_BUF[64],Y
    STA PPU_ADDR
    INY ; Buf++
    LDA PPU_DATA ; Read buffer fix.
READ_TO_UPDATE_BUF: ; 1F:1992, 0x03F992
    LDA PPU_DATA ; Load from PPU.
    STA NMI_PPU_CMD_PACKETS_BUF[64],Y ; To buf.
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
    LDA NMI_PPU_CMD_PACKETS_BUF[64],Y ; Load from buf.
    LDX #$04 ; Set GFX R4.
    JSR ENGINE_SET_MAPPER_BANK_X_VAL_A ; To buf val loaded.
    CLC ; Prep add.
    ADC #$01 ; Add 0x1 for the pair.
    LDX #$05 ; INX plox.
    JSR ENGINE_SET_MAPPER_BANK_X_VAL_A ; Set R5 to pair.
    INY ; Stream++
    LDA NMI_PPU_CMD_PACKETS_BUF[64],Y ; Move addr from buf.
    STA PPU_ADDR
    INY
    LDA NMI_PPU_CMD_PACKETS_BUF[64],Y
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
    LDX NMI_PPU_CMD_PACKETS_BUF[64],Y ; X from buf.
    STX UPDATE_PACKET_COUNT/GROUPS ; To, lower nibble count, upper nibble 0x8 groups.
    INY ; Buf++
    LDA NMI_PPU_CMD_PACKETS_BUF[64],Y ; PPU Addr
    STA PPU_ADDR
    INY ; Buf++
    LDA NMI_PPU_CMD_PACKETS_BUF[64],Y
    STA PPU_ADDR
    INY ; Buf++
    LSR UPDATE_PACKET_COUNT/GROUPS ; Test bit 0x01, +0x1 Bytes
    BCC TEST_0x2_FLAG_0x2_DBYTES ; Skip 0x1 DBytes.
    LDA NMI_PPU_CMD_PACKETS_BUF[64],Y ; Move 1x Byte.
    STA PPU_DATA
    INY
TEST_0x2_FLAG_0x2_DBYTES: ; 1F:1A0F, 0x03FA0F
    LSR UPDATE_PACKET_COUNT/GROUPS ; Test bit 0x02, +0x2 Bytes
    BCC TEST_0x4_FLAG_0x4_DBYTES ; Skip 0x2 DBytes.
    LDA NMI_PPU_CMD_PACKETS_BUF[64],Y ; Move 2x DBytes.
    STA PPU_DATA
    INY
    LDA NMI_PPU_CMD_PACKETS_BUF[64],Y
    STA PPU_DATA
    INY
TEST_0x4_FLAG_0x4_DBYTES: ; 1F:1A21, 0x03FA21
    LSR UPDATE_PACKET_COUNT/GROUPS ; Test 0x4, +0x4 Bytes
    BCC TEST_CLEAR ; Skip 0x4 DBytes.
    LDA NMI_PPU_CMD_PACKETS_BUF[64],Y ; Move 4x DBytes.
    STA PPU_DATA
    INY
    LDA NMI_PPU_CMD_PACKETS_BUF[64],Y
    STA PPU_DATA
    INY
    LDA NMI_PPU_CMD_PACKETS_BUF[64],Y
    STA PPU_DATA
    INY
    LDA NMI_PPU_CMD_PACKETS_BUF[64],Y
    STA PPU_DATA
    INY
TEST_CLEAR: ; 1F:1A41, 0x03FA41
    LDX UPDATE_PACKET_COUNT/GROUPS ; X count from upper nibble.
    BEQ RTS ; Tested top, clear, done.
X_LOOPS_NONZERO: ; 1F:1A45, 0x03FA45
    LDA NMI_PPU_CMD_PACKETS_BUF[64],Y ; Move 0x8 DBytes.
    STA PPU_DATA
    INY
    LDA NMI_PPU_CMD_PACKETS_BUF[64],Y ; 2x
    STA PPU_DATA
    INY
    LDA NMI_PPU_CMD_PACKETS_BUF[64],Y ; 3x
    STA PPU_DATA
    INY
    LDA NMI_PPU_CMD_PACKETS_BUF[64],Y ; 4x
    STA PPU_DATA
    INY
    LDA NMI_PPU_CMD_PACKETS_BUF[64],Y ; 5x
    STA PPU_DATA
    INY
    LDA NMI_PPU_CMD_PACKETS_BUF[64],Y ; 6x
    STA PPU_DATA
    INY
    LDA NMI_PPU_CMD_PACKETS_BUF[64],Y ; 7x
    STA PPU_DATA
    INY
    LDA NMI_PPU_CMD_PACKETS_BUF[64],Y ; 8x
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
    STA **:$00CE ; Clear ??
    STA **:$00CF
    LDX BMI_FLAG_SET_DIFF_MODDED_UNK ; Load.
    BIT NMI_FLAG_E7
    BVC BIT_0x40_CLEAR ; Clear, goto.
    LDY #$00 ; Stream index.
COUNT_POSITIVE: ; 1F:1A96, 0x03FA96
    CLC ; Prep add.
    LDA [NMI_FP_UNK[2]],Y ; Load from stream.
    ADC **:$00CE ; Add with.
    STA **:$00CE ; Store result.
    INY ; Stream++
    CLC ; Prep add.
    LDA [NMI_FP_UNK[2]],Y ; Load from stream.
    ADC **:$00CF ; Add to.
    STA **:$00CF ; Store result.
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
BIT_0x40_CLEAR: ; 1F:1AB8, 0x03FAB8
    CLC
    LDA NMI_FP_UNK[2]
    ADC **:$00CE
    STA **:$00CE
    CLC
    LDA NMI_FP_UNK+1
    ADC **:$00CF
    STA **:$00CF
    DEX
    BPL BIT_0x40_CLEAR
ALT_ENTRY: ; 1F:1AC9, 0x03FAC9
    CLC
    LDA **:$00CE
    BMI 1F:1AD6
    ADC ENGINE_SCROLL_X
    STA ENGINE_SCROLL_X
    BCC 1F:1AE2
    BCS 1F:1ADC
    ADC ENGINE_SCROLL_X
    STA ENGINE_SCROLL_X
    BCS 1F:1AE2
    LDA ENGINE_PPU_CTRL_COPY
    EOR #$01
    STA ENGINE_PPU_CTRL_COPY
    CLC
    LDA **:$00CF
    BMI 1F:1AEF
    ADC #$10
    ADC ENGINE_SCROLL_Y
    BCC 1F:1AF3
    BCS 1F:1AF5
    ADC ENGINE_SCROLL_Y
    BCS 1F:1AF5
    ADC #$F0
    STA ENGINE_SCROLL_Y
    LDA NMI_FLAG_OBJECT_PROCESSING?
    AND #$3F
    EOR #$20
    STA NMI_FLAG_OBJECT_PROCESSING?
    LDA #$00
    STA **:$00CC
    STA SPRITE_INDEX_SWAP
    LDA #$08
    STA **:$00CD
    LDX #$10
    LDY **:$00CC
    LDA **:$0300,Y
    AND #$3F
    BNE 1F:1B17
    JMP 1F:1C5C
    STA CTRL_BIT_0x0
    STX **:$00C2
    LDA **:$0301,Y
    AND #$C0
    STA CTRL_BIT_0x1
    TXA
    LSR A
    LSR A
    ORA CTRL_BIT_0x1
    STA **:$0301,Y
    SEC
    LDA #$00
    SBC **:$00CE
    STA **:$00C8
    SEC
    LDA #$00
    SBC **:$00CF
    STA **:$00CA
    LDX BMI_FLAG_SET_DIFF_MODDED_UNK
    BIT CTRL_BIT_0x1
    BVC 1F:1B70
    LDA **:$0304,Y
    STA **:$00C4
    LDA **:$0305,Y
    STA **:$00C5
    LDY #$00
    CLC
    LDA [**:$00C4],Y
    ADC **:$00C8
    STA **:$00C8
    INY
    CLC
    LDA [**:$00C4],Y
    ADC **:$00CA
    STA **:$00CA
    INY
    DEX
    BPL 1F:1B4A
    CLC
    TYA
    ADC **:$00C4
    LDY **:$00CC
    STA **:$0304,Y
    LDA #$00
    ADC **:$00C5
    STA **:$0305,Y
    JMP 1F:1B83
    CLC
    LDA **:$0304,Y
    ADC **:$00C8
    STA **:$00C8
    CLC
    LDA **:$0305,Y
    ADC **:$00CA
    STA **:$00CA
    DEX
    BPL 1F:1B70
    LDX **:$00C2
    CLC
    LDA **:$00C8
    BMI 1F:1B96
    ADC **:$0302,Y
    STA **:$00C8
    STA **:$0302,Y
    BCC 1F:1BA8
    BCS 1F:1BA0
    ADC **:$0302,Y
    STA **:$00C8
    STA **:$0302,Y
    BCS 1F:1BA8
    LDA **:$0300,Y
    EOR #$80
    STA **:$0300,Y
    CLC
    LDA **:$00CA
    BMI 1F:1BB9
    ADC **:$0303,Y
    STA **:$00CA
    STA **:$0303,Y
    BCC 1F:1BCB
    BCS 1F:1BC3
    ADC **:$0303,Y
    STA **:$00CA
    STA **:$0303,Y
    BCS 1F:1BCB
    LDA **:$0301,Y
    EOR #$80
    STA **:$0301,Y
    LDA **:$0300,Y
    AND #$80
    STA **:$00C9
    LDA **:$0301,Y
    AND #$80
    STA **:$00CB
    LDA **:$0306,Y
    STA **:$00C6
    LDA **:$0307,Y
    STA **:$00C7
    LDY #$00
    LDA [**:$00C6],Y
    STA **:$00C4
    INY
    LDA [**:$00C6],Y
    STA **:$00C5
    INY
    LDA [**:$00C6],Y
    STA **:$00C2
    INY
    LDA [**:$00C6],Y
    STA UPDATE_PACKET_COUNT/GROUPS
    LDY #$00
    LDA [**:$00C4],Y
    INY
    CLC
    ADC **:$00C8
    STA SPRITE_PAGE+3,X
    ROR A
    EOR **:$00C9
    BMI 1F:1C1F
    LDA [**:$00C4],Y
    CLC
    ADC **:$00CA
    STA SPRITE_PAGE[256],X
    ROR A
    EOR **:$00CB
    BMI 1F:1C1B
    CMP #$F0
    BCC 1F:1C25
    BCS 1F:1C1F
    CMP #$F9
    BCS 1F:1C25
    INY
    INY
    INY
    JMP 1F:1C58
    INY
    LDA [**:$00C4],Y
    STA CTRL_BIT_0x1
    LDA UPDATE_PACKET_COUNT/GROUPS
    LSR CTRL_BIT_0x1
    BCC 1F:1C32
    LSR A
    LSR A
    LSR CTRL_BIT_0x1
    BCC 1F:1C3A
    LSR A
    LSR A
    LSR A
    LSR A
    AND #$03
    ASL CTRL_BIT_0x1
    ASL CTRL_BIT_0x1
    ORA CTRL_BIT_0x1
    STA SPRITE_PAGE+2,X
    INY
    AND #$10
    BEQ 1F:1C4C
    LDA **:$00C2
    ADC [**:$00C4],Y
    STA SPRITE_PAGE+1,X
    INY
    INX
    INX
    INX
    INX
    BEQ 1F:1C95
    DEC CTRL_BIT_0x0
    BNE 1F:1BFA
    CLC
    LDA **:$00CD
    BMI 1F:1C6E
    ADC **:$00CC
    STA **:$00CC
    BEQ CLEAR_SPRITES_OFFSCREEN
    CMP **:$00E3
    BEQ 1F:1C79
    JMP 1F:1B0B
    ADC **:$00CC
    STA **:$00CC
    CMP **:$00E3
    BCC CLEAR_SPRITES_OFFSCREEN
    JMP 1F:1B0B
    STX SPRITE_INDEX_SWAP
    LDA NMI_FLAG_OBJECT_PROCESSING?
    AND #$20
    BNE 1F:1C87
    LDA #$F8
    STA **:$00CC
    STA **:$00CD
    JMP 1F:1B0B
CLEAR_SPRITES_OFFSCREEN: ; 1F:1C8A, 0x03FC8A
    LDA #$F0 ; Offscreen.
SPRITES_NONZERO: ; 1F:1C8C, 0x03FC8C
    STA SPRITE_PAGE[256],X ; Store to Ypos.
    INX ; Slot++
    INX
    INX
    INX
    BNE SPRITES_NONZERO ; != 0, goto.
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
    STA **:$0000,X ; Store. Right addrmode, nice.
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
ENGINE_SND_INIT?: ; 1F:1D14, 0x03FD14
    LDA #$1C
    STA ENGINE_BASE_R6_VAL? ; Set R6, 0x1C.
    LDA #$00 ; Clear.
    LDX #$00 ; Index. Not TAX like the other?! Hmm. :)
CLEAR_0x700_PAGE: ; 1F:1D1C, 0x03FD1C
    STA **:$0700,X ; Clear.
    INX ; Index++
    BNE CLEAR_0x700_PAGE ; != 0, goto.
    JSR ENGINE_SET_BASE_R6/R7_0x1D ; Set engine.
    JMP JMP_STARTUP_INTRO ; Goto.
STORE_IF_MISMATCH_OTHERWISE_WAIT_MENU_DEPTH?: ; 1F:1D28, 0x03FD28
    CMP VAL_CMP_UNK ; If _ var
    BEQ JUST_WAIT
    STA VAL_CMP_DIFFERS_STORED_UNK ; Store if mismatch. TODO: Why.
JUST_WAIT: ; 1F:1D30, 0x03FD30
    JMP ENGINE_NMI_0x01_SET/WAIT ; Wait, abuse RTS.
ENGINE_SETTLE_ALL_UPDATES?: ; 1F:1D33, 0x03FD33
    LDA NMI_FLAG_E5_TODO ; Load.
    ORA NMI_FLAG_E0_TODO ; Or with other.
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
    STA **:$0300,X ; Clear indexed.
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
    STA NMI_PPU_CMD_PACKETS_BUF[64] ; Store to buf.
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
    STA NMI_FLAG_E5_TODO ; Set flag ??
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
    LDA NMI_FLAG_E7 ; Load.
    AND #$BF ; Keep 1011.1111
    STA NMI_FLAG_E7 ; Cleared 0x40 store.
    LDA #$00
    STA NMI_FP_UNK[2] ; Clear ??
    STA NMI_FP_UNK+1
    CLC ; Prep add.
CARRY_NO_OVERFLOW: ; 1F:1DD0, 0x03FDD0
    TAX ; Val to index.
    LDA **:$0301,X ; Load ??
    AND #$BF ; Keep 1011.1111
    STA **:$0301,X ; Store to.
    LDA #$00
    STA **:$0304,X ; Clear ??
    STA **:$0305,X
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
    LDY **:$0105,X ; Load 6th value up stack, R7 val.
    STA **:$0105,X ; Store R7 val to stack.
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
    LDA MAPPER_INDEX_LAST_WRITTEN ; Save.
    PHA
    JSR ENGINE_IRQ_SCRIPT_RUN?
    PLA ; Restore.
    ORA ENGINE_MAPPER_CONFIG_STATUS_NO_BANK ; Set CFG.
    STA MMC3_BANK_CFG ; Set mapper.
    LDX ENGINE_IRQ_RTN_INDEX ; Move index.
    INX ; Index++
    INX
    STX ENGINE_IRQ_RTN_INDEX ; Store index.
    LDA IRQ_SCRIPT_A,X ; Load from.
    BNE VAL_NOT_NULL ; Nonzero, valid.
    STA MMC3_IRQ_DISABLE ; Disable IRQ's.
    STA ENGINE_IRQ_LATCH_CURRENT? ; Store to.
VAL_NOT_NULL: ; 1F:1E34, 0x03FE34
    PLA ; Leave IRQ.
    TAY
    PLA
    TAX
    PLA
    RTI
ENGINE_IRQ_SCRIPT_RUN?: ; 1F:1E3A, 0x03FE3A
    STA MMC3_IRQ_DISABLE
    LDX ENGINE_IRQ_RTN_INDEX ; Index from.
    LDA IRQ_SCRIPT_A,X ; Load rtn from index.
    PHA
    LDA IRQ_SCRIPT_B,X
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
    LDA **:$00D3 ; Load.
    CMP #$2A ; If _ #$2A
    BCC VAR_LT_0x2A ; <, goto.
    RTS ; Leave.
BUTTONS_NEWLY_PRESSED: ; 1F:1E91, 0x03FE91
    LDA #$00
    STA **:$00D3 ; Clear ??
VAR_LT_0x2A: ; 1F:1E95, 0x03FE95
    INC **:$00D0 ; ++
    BNE RTS ; != 0, leave.
    INC **:$00D3 ; ++
    INC **:$00D1 ; ++
    BNE RTS ; != 0, leave.
    INC **:$00D2 ; ++
RTS: ; 1F:1EA1, 0x03FEA1
    RTS
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
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
    JSR ENGINE_SND_INIT? ; Sound init?
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
ENGINE_SET_BASE_R6/R7_0x1D: ; 1F:1FC5, 0x03FFC5
    LDA ENGINE_BASE_R6_VAL? ; Value.
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
