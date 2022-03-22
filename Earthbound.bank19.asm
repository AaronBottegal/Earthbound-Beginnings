LOOPY_IDFK: ; 13:0000, 0x026000
    LDA #$05
    STA R_**:$07F1 ; Clear ??
    LDA CURRENT_SAVE_MANIPULATION_PAGE+542 ; Load ??
    STA MISC_USE_A ; Store ??
    LDY #$F0 ; Seed index ??
VAL_LT_0xF8: ; 13:000C, 0x02600C
    LDA #$A5 ; Val ??
    LSR MISC_USE_A ; >> 1
    BCC SHIFT_CC ; CC, goto.
    LDA #$96 ; Seed val ??
SHIFT_CC: ; 13:0014, 0x026014
    STA STREAM_INDEXES_ARR_UNK[24],Y ; Val ??
    INY ; Index++
    CPY #$F8 ; If _ #$F8
    BCC VAL_LT_0xF8 ; <, goto.
    LDA #$00
    STA STREAM_INDEXES_ARR_UNK[24],Y ; Clear ??
VAL_GTE_0x4: ; 13:0021, 0x026021
    LDX #$00 ; Val ??
VAL_LT_0x4: ; 13:0023, 0x026023
    JSR X_INDEX_TEST_UNK ; Do ??
    BCS TO_NEXT_X_OBJ_FAST ; Ret CS, goto.
    JSR CREATE_PTR_UNK ; Do ptr.
    TXA ; X to A.
    PHA ; Save it.
    LDY #$3F ; Stream index reset.
Y_POSITIVE: ; 13:002F, 0x02602F
    LDA [MISC_USE_A],Y ; Load from stream.
    STA STREAM_INDEXES_ARR_UNK[24],Y ; Store to page at index.
    DEY ; Y--
    BPL Y_POSITIVE ; Positive, goto.
    LDX #$80 ; Val ??
    LDY #$28 ; Index ??
VAL_LT_0x2C: ; 13:003B, 0x02603B
    LDA STREAM_INDEXES_ARR_UNK[24],Y ; Load ??
    STA PTR_CREATE_SEED? ; Store to.
    JSR SUB_PAGE_AND_FILE_MOVE_UNK ; Do ??
    INY ; Stream++
    CPY #$2C ; If _ #$2C
    BCC VAL_LT_0x2C ; <, goto.
    JSR PTR_SEEDED_UNK_I ; Do ??
    LDA #$F5
    LDX #$A0 ; Seed ptr.
    JSR FILE_CREATE ; Do.
    LDA #$C0
    STA PTR_CREATE_SEED? ; Set ??
    JSR PACKETER_UPDATE_IDFK ; Do ??
    LDA #$19
    LDX #$A1 ; Seed FPTR.
    STA FPTR_SPRITES?[2]
    STX FPTR_SPRITES?+1
    JSR ENGINE_MENU_HELPER_BEGIN? ; Do.
LOOPER: ; 13:0064, 0x026064
    BIT MENU_HELPER_STATUS? ; Test.
    BVS BIT_0x40_SET ; 0x40 set, goto.
    LDA FPTR_UNK_84_MENU_SELECTION?[2] ; Load ??
    BEQ TO_NEXT_X_OBJ_STACK ; == 0, goto.
    JSR PACKETER_UPDATE_IDFK ; Packeter.
    BCS COORDS_SET ; CS, goto.
    JSR PACKETER_UPDATE_IDFK ; Run again.
COORDS_SET: ; 13:0074, 0x026074
    LDX #$0A ; Set coords.
    LDY #$03
    STX PACKET_HPOS_COORD?
    STY PACKET_YPOS_COORD?
    JSR SETTLE_AND_SPRITES_TO_COORD?_IDFK ; Do.
    JMP LOOPER ; Goto.
TO_NEXT_X_OBJ_STACK: ; 13:0082, 0x026082
    PLA ; Restore X.
    TAX
TO_NEXT_X_OBJ_FAST: ; 13:0084, 0x026084
    INX ; X += 0x1
    CPX #$04 ; If _ #$04
    BCC VAL_LT_0x4 ; <, goto.
    BCS VAL_GTE_0x4 ; >=, goto, always taken.
BIT_0x40_SET: ; 13:008B, 0x02608B
    PLA ; Pull A.
    JMP LIB_OBJECTS_AND_SETTLE_AND_FLAGS_UNK ; Do.
SUB_PAGE_AND_FILE_MOVE_UNK: ; 13:008F, 0x02608F
    TYA ; Save Y and X.
    PHA
    TXA
    PHA
    JSR SUB_PTR_OFFSET_AND_BASE_9800 ; Do.
    LDY #$00 ; Stream reset.
    LDA [MISC_USE_A],Y ; Load from file.
    STA SAVE_GAME_MOD_PAGE_PTR[2] ; Store PTR L.
    INY ; Stream++
    LDA [MISC_USE_A],Y ; Load from file.
    STA SAVE_GAME_MOD_PAGE_PTR+1 ; Store PTR H.
    PLA ; '
    TAX ; Restore X, page index.
    LDY #$00 ; Stream reset.
LT_0x10: ; 13:00A5, 0x0260A5
    LDA [SAVE_GAME_MOD_PAGE_PTR[2]],Y ; Load from file.
    STA STREAM_INDEXES_ARR_UNK[24],X ; Store to page.
    INX ; Index++
    INY ; Index++
    CPY #$10 ; If _ #$10
    BCC LT_0x10 ; <, goto.
    PLA
    TAY ; Restore Y.
    RTS
PACKETER_UPDATE_IDFK: ; 13:00B3, 0x0260B3
    LDX #$40
X_LT_0x80: ; 13:00B5, 0x0260B5
    STX ARR_BITS_TO_UNK[8] ; Set ??
    JSR SUB_PTR_SEED_TO_STREAM_INDEX_AND_BIT_TO_TEST ; Do ?? <<<<<<<<<<<<<<<<<<
    LDX ARR_BITS_TO_UNK[8]
    AND STREAM_INDEXES_ARR_UNK[24],Y
    BEQ VAL_EQ_0x00 ; == 0, goto.
    JSR SUB_PAGE_AND_FILE_MOVE_UNK ; Do ??
VAL_EQ_0x00: ; 13:00C4, 0x0260C4
    INC PTR_CREATE_SEED? ; +
    BNE VAL_NONZERO ; != 0, goto.
    LDA #$C0
    STA PTR_CREATE_SEED? ; Set ??
    CPX #$41 ; If _ #$41
    BCS VAL_GT_0x41 ; >=, goto.
    RTS ; Leave.
X_LT_0x80: ; 13:00D1, 0x0260D1
    LDA #$00
    STA STREAM_INDEXES_ARR_UNK[24],X ; Clear page.
    CLC ; Prep add.
    TXA ; Index to A.
    ADC #$10 ; += 0x10
    TAX ; To X index.
VAL_GT_0x41: ; 13:00DB, 0x0260DB
    CPX #$80 ; If _ #$80
    BCC X_LT_0x80 ; <, goto.
    BCS PACKETER_DATA_SEEDED ; >=, goto.
VAL_NONZERO: ; 13:00E1, 0x0260E1
    CPX #$80 ; If _ #$80
    BCC X_LT_0x80 ; <, goto.
PACKETER_DATA_SEEDED: ; 13:00E5, 0x0260E5
    LDA #$FE
    LDX #$A0 ; Seed ptr.
    STA FPTR_PACKET_CREATION[2]
    STX FPTR_PACKET_CREATION+1
CREATE_PACKETER: ; 13:00ED, 0x0260ED
    JSR ENGINE_CREATE_UPDATE_BUF_INIT_DEC? ; Create.
    CMP #$00 ; If _ #$00
    BNE CREATE_PACKETER ; != 0, goto.
    RTS ; Leave.
    .db 20 ; File start, update, packet.
    .db 0B
    .db 03
    .db 23
    .db 38
    .db 06
    .db 00
    .db 07
    .db 00
    .db 20
    .db 13
    .db 05
    .db 23
    .db 40
    .db 06
    .db 00
    .db 0B
    .db 01
    .db 23
    .db 50
    .db 06
    .db 00
    .db 0B
    .db 01
    .db 23
    .db 60
    .db 06
    .db 00
    .db 0B
    .db 01
    .db 23
    .db 70
    .db 06
    .db 00
    .db 0B
    .db 00
    .db 02
    .db 01
    .db 09
    .db 00
    .db C5
    .db 3A
    .db 0A
    .db 03
    .db D1
    .db F0
MAIN_RTN_MENU?_UNK: ; 13:0123, 0x026123
    LDA #$80 ; Val for setting, too. Nice trick.
    BIT **:$00D4 ; Test ??
    BNE RTS ; Was set, leave.
    LDX INP_COUNT_UNK_C ; Load ??
    LDY INP_COUNT_UNK_B
    CPX #$06 ; If _ #$06
    BCC RTS ; <, goto.
    CPY #$90 ; If _ #$90
    BCC RTS ; << leave.
    ORA **:$00D4 ; Set ??
    STA **:$00D4 ; Store to.
    LDA #$2F ; Val ??
    JSR ENGINE_COMPARES/MISMATCH_RTN_UNK ; Do ??
    LDX #$7C
    JSR PTR_AND_CREATE_UNK ; Do ??
    LDX #$7E
    JSR PTR_AND_CREATE_UNK
    LDX #$80
    JSR PTR_AND_CREATE_UNK
    LDA #$37
    STA ROUTINE_CONTINUE_FLAG? ; Set ??
    JSR STREAMS_AND_STREAM+CONVERT_IDK ; Do ??
    BIT MENU_HELPER_STATUS? ; Test.
    BVS ALT_UNK ; 0x40 set, goto.
    LDA FPTR_UNK_84_MENU_SELECTION?[2] ; Load ??
    BEQ ALT_UNK ; == 0, goto.
    JSR SAVE_GAME_FILE ; Do.
    LDX #$86 ; Val ??
    JSR PTR_AND_CREATE_UNK
    JMP ENGINE_RESET_GAME ; Goto.
RTS: ; 13:0167, 0x026167
    RTS ; Leave.
ALT_UNK: ; 13:0168, 0x026168
    LDX #$82
    JSR PTR_AND_CREATE_UNK ; Display ptrs?
    LDX #$84
    JSR PTR_AND_CREATE_UNK
    JSR WAIT_PRESSES_CLEAR? ; Wait.
    JMP LIB_OBJECTS_AND_SETTLE_AND_FLAGS_UNK ; Goto.
ENGINE_UNK_OBJECTS_REELATED?: ; 13:0178, 0x026178
    LDA #$05
    STA R_**:$07F1 ; Set ??
    JSR PACKETS_IDK ; Do ??
    LDA #$B0 ; Set FPTR, R7??:01B0 ??
    LDX #$A1
    STA FPTR_SPRITES?[2]
    STX FPTR_SPRITES?+1
    JSR ENGINE_MENU_HELPER_BEGIN? ; Do, menu?
    BIT MENU_HELPER_STATUS? ; Test.
    BMI VAL_NEGATIVE ; Negative, goto.
    JMP LIB_OBJECTS_AND_SETTLE_AND_FLAGS_UNK ; Goto ??
VAL_NEGATIVE: ; 13:0192, 0x026192
    LDA #$FF ; Load ??
    JSR ENGINE_POS_TO_UPDATE_UNK ; Do ??
    LDA FPTR_UNK_84_MENU_SELECTION?[2] ; Load ??
    ASL A ; << 1, *2.
    TAX ; To index.
    LDA $A1A5,X ; Move routine.
    PHA
    LDA $A1A4,X
    PHA
    RTS ; Execute it.
    LOW(RTS) ; 0x00
    HIGH(RTS) ; Many routines.
    LOW(13:020E) ; 0x01
    HIGH(13:020E)
    LOW(13:0261) ; 0x02
    HIGH(13:0261)
    LOW(13:0004) ; 0x03
    HIGH(13:0004)
    LOW(13:0237) ; 0x04
    HIGH(13:0237)
    LOW(13:01B9) ; 0x05
    HIGH(13:01B9)
    .db 02
    .db 03
    .db 06
    .db 02
    .db C0
    .db 3A
    .db 02
    .db 03
    .db D1
    .db F0
    LDA #$19
    LDX #$6D
    LDY #$A3
    JSR ENGINE_SCRIPT_LAUNCH_R7_A_PTR_XY ; Script launch ??
    JMP LIB_OBJECTS_AND_SETTLE_AND_FLAGS_UNK ; Do ??
STREAMY_LIBY_UNK: ; 13:01C6, 0x0261C6
    JSR LIB_RTN_PTR_CREATION/SHIFT+CLEAR_UNK_MOVE_PTR_DOWN_UNK ; Do ??
    BCS RET_CS ; Ret CS, goto.
    JSR SUB_STREAM_AND_CMP_UNK ; Do ??
    BEQ RTS ; ==, goto.
    ASL A ; << 2, *4.
    ASL A
    BCC RTS ; CC, goto.
    AND #$3C ; Keep 0011.1100
    BEQ RTS ; == 0, goto.
    LDA #$35
    STA **:$0034 ; Set ??
    JSR STREAM_PROCESS_UNK_INIT ; Do ??
    BCS RTS ; Ret CS, goto.
EXIT_LIB_UNK: ; 13:01E1, 0x0261E1
    JMP LIB_OBJECTS_AND_SETTLE_AND_FLAGS_UNK ; Goto otherwise.
RET_CS: ; 13:01E4, 0x0261E4
    JSR STREAM_MOVE_BANK_STREAM_READ_UNK ; Do ??
    BCC EXIT_LIB_UNK ; Ret CC, goto.
RTS: ; 13:01E9, 0x0261E9
    RTS ; Leave.
    JSR 1F:020F
    ASL A
    BPL 13:0200
    AND #$1E
    BEQ 13:0204
    JSR 1F:02A2
    LDA #$0A
    STA **:$0034
    JSR $AB0F
    BCC 13:020C
    LDX #$02
    BNE 13:0206
    LDX #$04
    JSR $A445
    JSR $AB30
    JMP LIB_OBJECTS_AND_SETTLE_AND_FLAGS_UNK
    JSR 1F:020F
    JSR $A9C7
    BNE 13:021D
    JSR $A9D6
    JMP LIB_OBJECTS_AND_SETTLE_AND_FLAGS_UNK
    ASL A
    BPL 13:022D
    AND #$1E
    BEQ 13:022D
    LDA #$0B
    STA **:$0034
    JSR $AB0F
    BCC 13:0235
    LDX #$06
    JSR $A445
    JSR $AB30
    JMP LIB_OBJECTS_AND_SETTLE_AND_FLAGS_UNK
    JSR $B8E6
    BCC 13:0240
    JMP LIB_OBJECTS_AND_SETTLE_AND_FLAGS_UNK
    JSR $A92D
    LDY #$07
    LDA [MISC_USE_A],Y
    STA GFX_BANKS+3
    SEC
    LDY #$16
    LDA [GFX_BANKS[4]],Y
    SBC GFX_BANKS+3
    INY
    LDA [GFX_BANKS[4]],Y
    SBC #$00
    BCC 13:025D
    JSR $A3BC
    JMP $A90C
    LDX #$10
    JMP $A909
    JSR L_13:17B6
    BCC 13:026A
    JMP LIB_OBJECTS_AND_SETTLE_AND_FLAGS_UNK
    JSR PTR_SEDED_UNK_D
    JSR $A964
    JSR $A972
    BEQ 13:0281
    LDA PTR_CREATE_SEED?
    CMP #$03
    BEQ 13:0281
    LDA #$A2
    LDX #$A2
    BNE 13:0285
    LDA #$D1
    LDX #$F0
    STA FPTR_UNK_84_MENU?[2]
    STX FPTR_UNK_84_MENU?+1
    LDA #$9A
    LDX #$A2
    STA FPTR_SPRITES?[2]
    STX FPTR_SPRITES?+1
    JSR 1F:0F3F
    BIT MENU_HELPER_STATUS?
    BMI 13:02A7
    BPL 13:0262
    .db 01
    .db 05
    .db 00
    .db 02
    .db C0
    .db 3A
    .db 18
    .db 07
    .db 00
    .db 00
    .db 03
    .db 04
    .db 00
    LDA #$FF
    JSR ENGINE_POS_TO_UPDATE_UNK
    JSR $A92D
    LDA FPTR_UNK_84_MENU_SELECTION?[2]
    ASL A
    TAX
    LDA $A2BD,X
    PHA
    LDA $A2BC,X
    PHA
    RTS
    .db C5
    .db A2
    .db 7C
    .db A3
    .db 14
    .db A3
    .db 8F
    .db A3
    .db A8
    .db A3
    LDY #$03
    LDA [MISC_USE_A],Y
    BNE 13:02F1
    LDY #$02
    LDA [MISC_USE_A],Y
    AND #$3F
    BEQ 13:02E1
    LDX R_**:$0028
    AND $AA74,X
    BEQ 13:02EC
    JSR $A3BC
    JMP $A90C
    LDX #$16
    JSR $A445
    JSR $A443
    JMP $A90C
    LDX #$18
    JMP $A909
    STA MISC_USE_C
    LDY #$02
    LDA [MISC_USE_A],Y
    LDX R_**:$0028
    AND $AA74,X
    BEQ 13:0310
    JSR $BC3A
    BCS 13:0310
    LDX #$1C
    JSR $A445
    LDA #$04
    STA R_**:$07F3
    JMP $A90C
    LDX #$1E
    JMP $A909
    LDX COUNT_LOOPS?_UNK
    DEX
    BEQ 13:0375
    LDA PTR_CREATE_SEED?
    CMP #$03
    BEQ 13:0365
    JSR $AA4E
    BCS 13:037A
    JSR $A979
    BCS 13:036A
    JSR $A9A3
    CMP GFX_BANKS+2
    BEQ 13:0356
    JSR $A972
    BNE 13:0349
    JSR $A964
    JSR $A972
    BNE 13:0344
    LDX #$24
    JMP $A909
    LDX #$4C
    JMP $A909
    JSR $A964
    JSR $A972
    BNE 13:0360
    LDX #$4E
    JMP $A909
    JSR $A972
    BNE 13:0360
    LDX #$50
    JMP $A909
    LDX #$52
    JMP $A909
    LDX #$26
    JMP $A909
    LDA R_**:$0028
    CMP GFX_BANKS+2
    BEQ 13:0356
    LDX #$28
    JMP $A909
    LDX #$0C
    JMP $A909
    JMP $A26A
    LDY #$02
    LDA [MISC_USE_A],Y
    AND #$40
    BEQ 13:038B
    JSR $A3BC
    JMP $A90C
    LDX #$1A
    JMP $A909
    JSR $A98B
    BCS 13:03A4
    JSR $A972
    BNE 13:039F
    LDX #$20
    JMP $A909
    LDX #$54
    JMP $A909
    LDX #$22
    JMP $A909
    CLC
    LDA PTR_CREATE_SEED?
    ADC #$E8
    STA FPTR_PACKET_CREATION[2]
    LDA #$00
    ADC #$03
    STA ARG_IDFK
    JSR $AD1A
    JMP $A90C
    LDY #$04
    LDA [MISC_USE_A],Y
    ASL A
    TAX
    LDA $A3CC,X
    PHA
    LDA $A3CB,X
    PHA
    RTS
    .db 42
    .db A4
    .db 50
    .db A4
    .db 42
    .db A4
    .db 42
    .db A4
    .db 42
    .db A4
    .db 99
    .db A4
    .db CE
    .db A4
    .db 50
    .db A4
    .db 64
    .db A4
    .db 42
    .db A4
    .db EA
    .db A4
    .db EF
    .db A4
    .db F4
    .db A4
    .db F9
    .db A4
    .db FE
    .db A4
    .db 03
    .db A5
    .db 0B
    .db A5
    .db 4C
    .db A7
    .db 55
    .db A7
    .db 5E
    .db A7
    .db 99
    .db A7
    .db A6
    .db A7
    .db B3
    .db A7
    .db BA
    .db A7
    .db C1
    .db A7
    .db C8
    .db A7
    .db CF
    .db A7
    .db 10
    .db A8
    .db 42
    .db A4
    .db 42
    .db A4
    .db D6
    .db A7
    .db 77
    .db A4
    .db 06
    .db A8
    .db 0B
    .db A8
    .db 24
    .db A8
    .db 15
    .db A8
    .db 3D
    .db A4
    .db 26
    .db A4
    .db 11
    .db A6
    .db DA
    .db A4
    .db DF
    .db A4
    .db E4
    .db A4
    .db 3E
    .db A7
    .db 3D
    .db A4
    .db 37
    .db A7
    .db 45
    .db A7
    JSR $A9B1
    JSR 1F:020F
    ASL A
    BPL 13:043E
    AND #$1E
    BEQ 13:043E
    LDA #$0C
    STA **:$0034
    JSR $AB0F
    BCS 13:043E
    RTS
    LDX #$0E
    JSR $A445
    LDX #$2A
PTR_AND_CREATE_UNK: ; 13:0445, 0x026445
    JSR MOVE_FILE_UNK ; Do.
    JMP ALT_ENTRY_UNK ; Goto.
    JSR MOVE_FILE_UNK ; Do.
    JMP L_13:0D29 ; Goto.
    JSR 1F:020F
    ASL A
    BPL 13:0443
    AND #$1E
    BEQ 13:0443
    LDA #$0D
    STA **:$0034
    JSR $AB0F
    BCS 13:0443
    RTS
    JSR $A990
    JSR ENGINE_WRAM_STATE_WRITEABLE
    LDA #$0A
    STA CURRENT_SAVE_MANIPULATION_PAGE+25
    JSR ENGINE_WRAM_STATE_WRITE_DISABLED
    LDX #$16
    JMP $A445
    JSR $A990
    JSR ENGINE_WRAM_STATE_WRITEABLE
    LDY #$2C
    LDA [GFX_BANKS[4]],Y
    STA WRAM_ARR_UNK[48],Y
    INY
    CPY #$30
    BCC 13:0480
    JSR ENGINE_WRAM_STATE_WRITE_DISABLED
    LDA #$40
    STA FIRST_LAUNCHER_HOLD_FLAG?
    LDA #$01
    STA SWITCH_INIT_PORTION?
    LDX #$48
    JMP $A445
    LDA FPTR_UNK_84_MENU_SELECTION?[2]
    BNE 13:04CA
    LDA #$03
    JSR $B058
    BCC 13:04C5
    LDA PTR_CREATE_SEED?
    JSR $B058
    JSR ENGINE_WRAM_STATE_WRITEABLE
    LDA #$03
    STA [MISC_USE_A],Y
    LDY #$2C
    LDA WRAM_ARR_UNK[48],Y
    STA [GFX_BANKS[4]],Y
    INY
    CPY #$30
    BCC 13:04B3
    JSR ENGINE_WRAM_STATE_WRITE_DISABLED
    LDX #$44
    JMP $A445
    LDX #$46
    JMP $A445
    LDA #$14
    JMP $A542
    LDA FPTR_UNK_84_MENU_SELECTION?[2]
    BNE 13:04D6
    JMP $A451
    LDA #$0F
    JMP $A542
    LDA #$1E
    JMP $A63B
    LDA #$50
    JMP $A63B
    JSR $A924
    JMP $A63E
    LDA #$0A
    JMP $A53E
    LDA #$14
    JMP $A542
    LDA #$1E
    JMP $A542
    LDA #$3C
    JMP $A542
    LDA #$64
    JMP $A53E
    JSR $A924
    LDX #$16
    JMP $A54B
    LDA #$1E
    JSR $A912
    JSR $AA4E
    BCS 13:056A
    JSR $A964
    JSR $A972
    BMI 13:056F
    JSR $A92D
    LDX #$42
    JSR $A445
    JSR ENGINE_WRAM_STATE_WRITEABLE
    DEC CURRENT_SAVE_MANIPULATION_PAGE+31
    PHP
    JSR ENGINE_WRAM_STATE_WRITE_DISABLED
    PLP
    BNE 13:053B
    JSR $A9A3
    LDX #$56
    JSR $A445
    JMP $A564
    LDX #$2E
    BNE 13:0544
    LDX #$2C
    STX FPTR_PACKET_CREATION[2]
    JSR $A912
    LDX FPTR_PACKET_CREATION[2]
    JSR $AA7C
    JSR $AA4E
    BCS 13:056A
    JSR $A964
    JSR $A972
    BMI 13:056F
    JSR $A92D
    JSR $AD1A
    JSR $A9A3
    JSR $A681
    JMP $BC04
    PLA
    PLA
    JMP $A26A
    JSR $A9A3
    LDX #$58
    JSR $A445
    JMP $A443
    STA R_**:$002A
    STY R_**:$002B
    JSR $AA7C
    JSR $AA4E
    BCS 13:056A
    LDA R_**:$002A
    BMI 13:0592
    JSR $A964
    JSR $A972
    BMI 13:056F
    JSR $A92D
    JSR $AD1A
    JSR $A9A3
    LDY #$01
    LDA [GFX_BANKS[4]],Y
    AND R_**:$002A
    BEQ 13:0577
    JSR ENGINE_WRAM_STATE_WRITEABLE
    LDA R_**:$002A
    PHP
    EOR #$FF
    AND [GFX_BANKS[4]],Y
    STA [GFX_BANKS[4]],Y
    PLP
    BPL 13:05B5
    JSR $A6E0
    JSR ENGINE_WRAM_STATE_WRITE_DISABLED
    LDA #$07
    STA R_**:$07F1
    LDX R_**:$002B
    JSR $A445
    JMP $BC04
    STY R_**:$002A
    JSR $AA7C
    JSR $AA4E
    BCS 13:056A
    JSR $A964
    JSR $A972
    BMI 13:056F
    JSR $A92D
    JSR $AD1A
    JSR $A9A3
    LDY R_**:$002A
    LDA #$05
    JSR $A912
    CLC
    LDA [GFX_BANKS[4]],Y
    ADC R_**:$002A
    STA SAVE_GAME_MOD_PAGE_PTR[2]
    BCC 13:05F7
    CLC
    LDA R_**:$002A
    SBC SAVE_GAME_MOD_PAGE_PTR[2]
    STA R_**:$002A
    JSR ENGINE_WRAM_STATE_WRITEABLE
    CLC
    LDA [GFX_BANKS[4]],Y
    ADC R_**:$002A
    STA [GFX_BANKS[4]],Y
    JSR ENGINE_WRAM_STATE_WRITE_DISABLED
    CLC
    TYA
    ADC #$11
    ASL A
    TAX
    JSR $A445
    LDX #$32
    JMP $A44B
    JSR $A62C
    JSR $B98F
    BCS 13:0659
    JSR $A9B1
    LDX #$0E
    JSR $A445
    PLA
    PLA
    PLA
    PLA
    JSR $AB30
    JMP 1E:0CD8
    LDA CURRENT_SAVE_MANIPULATION_PAGE+543
    AND #$02
    BEQ 13:063A
    PLA
    PLA
    LDX #$12
    JMP $A445
    RTS
    JSR $A912
    JSR $AA4E
    BCS 13:0659
    JSR $A9B1
    LDX #$0E
    JSR $A445
    JSR $A92D
    JSR $A972
    BMI 13:065E
    JSR $A681
    JMP $BC04
    PLA
    PLA
    JMP $A238
    JMP $A443
    STA R_**:$002A
    STY R_**:$002B
    JSR $AA4E
    BCS 13:0659
    JSR $A9B1
    LDX #$0E
    JSR $A445
    JSR $A92D
    LDA R_**:$002A
    BMI 13:067E
    JSR $A972
    BMI 13:065E
    JMP $A59B
    LDY #$14
    JSR $A6A5
    LDY #$03
    JSR $A6B4
    JSR ENGINE_WRAM_STATE_WRITEABLE
    LDY #$14
    JSR $A6D1
    JSR ENGINE_WRAM_STATE_WRITE_DISABLED
    LDA #$07
    STA R_**:$07F1
    LDX #$34
    JSR $A445
    LDX #$30
    JMP $A44B
    CLC
    LDA [GFX_BANKS[4]],Y
    ADC R_**:$002A
    STA SAVE_GAME_MOD_PAGE_PTR[2]
    INY
    LDA [GFX_BANKS[4]],Y
    ADC R_**:$002B
    STA SAVE_GAME_MOD_PAGE_PTR+1
    RTS
    SEC
    LDA [GFX_BANKS[4]],Y
    SBC SAVE_GAME_MOD_PAGE_PTR[2]
    STA ARR_BITS_TO_UNK[8]
    INY
    LDA [GFX_BANKS[4]],Y
    SBC SAVE_GAME_MOD_PAGE_PTR+1
    STA ARR_BITS_TO_UNK+1
    BCS 13:06D0
    LDA R_**:$002A
    ADC ARR_BITS_TO_UNK[8]
    STA R_**:$002A
    LDA R_**:$002B
    ADC ARR_BITS_TO_UNK+1
    STA R_**:$002B
    RTS
    CLC
    LDA [GFX_BANKS[4]],Y
    ADC R_**:$002A
    STA [GFX_BANKS[4]],Y
    INY
    LDA [GFX_BANKS[4]],Y
    ADC R_**:$002B
    STA [GFX_BANKS[4]],Y
    RTS
    LDY #$03
    LDA [GFX_BANKS[4]],Y
    LDY #$14
    STA [GFX_BANKS[4]],Y
    LDY #$04
    LDA [GFX_BANKS[4]],Y
    LDY #$15
    STA [GFX_BANKS[4]],Y
    LDA ENGINE_FPTR_30[2]
    PHA
    LDA ENGINE_FPTR_30+1
    PHA
    JSR LIB_SPECIAL_CHECKS_UNK
    JSR $A728
    BCS 13:071E
    TXA
    JSR CREATE_PTR_HELPER_6700
    LDA MAPPER_BANK_VALS+6
    PHA
    LDY #$15
    LDA [ENGINE_FPTR_30[2]],Y
    ASL A
    ASL A
    ASL A
    TAX
    JSR 1F:02BF
    PLA
    LDX #$06
    JSR ENGINE_SET_MAPPER_BANK_X_VAL_A
    LDA #$1D
    JSR ENGINE_COMPARES/MISMATCH_RTN_UNK
    JSR L_1E:1977
    JSR ENGINE_WRAM_STATE_WRITEABLE
    PLA
    STA ENGINE_FPTR_30+1
    PLA
    STA ENGINE_FPTR_30[2]
    RTS
L_13:0728: ; 13:0728, 0x026728
    LDA R_**:$0028
    LDX #$00
    CMP CURRENT_SAVE_MANIPULATION_PAGE+8,X
    CLC
    BEQ 13:0737
    INX
    CPX #$04
    BCC 13:072C
    RTS
    LDA #$02
    LDY #$5A
    JMP $A661
    LDA #$40
    LDY #$6C
    JMP $A661
    LDA #$80
    LDY #$14
    JMP $A661
    LDA #$02
    LDX #$2E
    LDY #$5A
    JMP $A57A
    LDA #$01
    LDX #$16
    LDY #$5C
    JMP $A57A
    LDA #$14
    JSR $A912
    LDX #$5E
    JSR $A445
    LDY #$16
    JSR $A6A5
    LDY #$05
    JSR $A6B4
    JSR ENGINE_WRAM_STATE_WRITEABLE
    LDY #$16
    JSR $A6D1
    JSR ENGINE_WRAM_STATE_WRITE_DISABLED
    LDX #$36
    JSR $A445
    LDX #$30
    JSR $A44B
    JSR ADDS_IDFK
    CMP #$19
    BCS 13:0797
    JSR $A990
    LDX #$60
    JSR $A445
    JMP $BC04
    LDX #$4A
    JSR $A445
    JSR $A990
    LDY #$0F
    JMP $A5E2
    LDX #$2C
    JSR $A445
    JSR $A990
    LDY #$0B
    JMP $A5E2
    LDX #$2E
    LDY #$0C
    JMP $A5C5
    LDX #$2E
    LDY #$0D
    JMP $A5C5
    LDX #$2E
    LDY #$0E
    JMP $A5C5
    LDX #$2E
    LDY #$0F
    JMP $A5C5
    LDX #$2E
    LDY #$0B
    JMP $A5C5
    JSR $A62C
    LDA CURRENT_SAVE_MANIPULATION_PAGE+540
    BPL 13:07E2
    JMP $A443
    JSR ENGINE_WRAM_STATE_WRITEABLE
    LDX #$03
    LDA $A803,X
    STA CURRENT_SAVE_MANIPULATION_PAGE+4,X
    DEX
    BPL 13:07E7
    JSR SLOTS_AND_FPTRS_IDFK
    JSR 1E:18CE
    LDA #$02
    STA SWITCH_INIT_PORTION?
    LDA #$40
    STA FIRST_LAUNCHER_HOLD_FLAG?
    LDX #$16
    JMP $A445
    EOR #$9E
    ???
    TAY
    LDX #$62
    JMP $A445
    LDX #$64
    JMP $A445
    LDX #$74
    JMP $A445
    LDX #$70
    JSR $A445
    LDA #$01
    JSR ENGINE_COMPARES/MISMATCH_RTN_UNK
    LDX #$72
    JMP $A445
    PLA
    PLA
    LDX #$78
    JSR $A445
    JMP $A834
ENGINE_MAIN_RTN_MANY_FADES: ; 13:082F, 0x02682F
    LDA #$05
    STA R_**:$07F1 ; Set ??
    LDA R_**:$0014 ; Load ??
    CMP #$01 ; If _ #$01
    BEQ VAL_EQ_0x01 ; ==, goto.
    CMP #$02 ; If _ #$02
    BEQ VAL_EQ_0x01 ; ==, goto.
    LDX #$7A ; File.
    JMP ALT_RTN_UNK ; Goto ??
VAL_EQ_0x01: ; 13:0843, 0x026843
    JSR WAIT_PRESSES_CLEAR? ; Wait.
    JSR ENGINE_PALETTE_FADE_OUT ; Fade.
    JSR SETTLE_SPRITES_OFFSCREEN/CLEAR_RAM ; Clear off screen.
    LDX #$00
    LDY #$08 ; Seed scroll.
    JSR ENGINE_HELPER_SETTLE_CLEAR_LATCH_SET_SCROLL_TODO_MORE ; Do.
    LDA #$06 ; Add sprites and BG in the leftmost column.
    ORA ENGINE_PPU_MASK_COPY ; Set with copy.
    STA ENGINE_PPU_MASK_COPY ; Store it.
    LDA #$5B
    LDX #$02 ; GFX swap.
    JSR ENGINE_SET_MAPPER_BANK_X_VAL_A
    JSR PPU_READ_INTO_$0110_HELPER_LOOP_UNK ; Read into RAM.
    LDA #$E3
    LDX #$A8
    JSR ENGINE_SET_GFX_BANKS_FPTR_AX ; Set GFX banks PTRS.
    LDA #$DF
    STA SPRITE_PAGE+1 ; Set tile.
    LDA #$00
    STA SPRITE_PAGE+2 ; Clear ATTRS.
    LDX #$40 ; Attr, sprite HFlip.
    LDA R_**:$6785 ; Load ??
    JSR HELPER_SPRITE_0_ATTR ; Do ??
    SBC #$08 ; -= 0x8
    STA SPRITE_PAGE+3 ; As XPos of SPR 0.
    LDX #$80 ; Attr VFlip.
    LDA R_**:$6787 ; Load ??
    JSR HELPER_SPRITE_0_ATTR ; Do ??
    SBC #$21 ; -= 0x21
    STA SPRITE_PAGE[256] ; Store as VPos.
    LDA #$E9
    LDX #$A8
    JSR ENGINE_SETTLE_AND_PALETTE_FROM_PTR ; Palette.
    LDA #$00
    STA CONTROL_ACCUMULATED?[2] ; No buttons.
BUTTON_B_NOT_PRESSED: ; 13:0899, 0x026899
    LDX #$08
    JSR ENGINE_DELAY_X_FRAMES ; Delay frames.
    LDA #$DF ; Val ?? 1101.1111
    EOR SPRITE_PAGE+1 ; Invert tile.
    STA SPRITE_PAGE+1 ; Store back.
    BIT CONTROL_ACCUMULATED?[2] ; Test P1 CTRL.
    BVC BUTTON_B_NOT_PRESSED ; Not pressed, goto.
    LDA #$00
    STA CONTROL_ACCUMULATED?[2] ; No buttons pressed now.
    LDA #$F0
    STA SPRITE_PAGE[256] ; Set Ypos way down.
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle.
    JSR ENGINE_PALETTE_FADE_OUT_NO_UPLOAD_CURRENT ; Fade out.
    JSR ENGINE_PALETTE_SCRIPT_TO_UPLOADED ; Do palette.
    LDA #$F9 ; Keep all except left column.
    AND ENGINE_PPU_MASK_COPY ; Set from current.
    STA ENGINE_PPU_MASK_COPY ; Store disabled.
    LDA #$7E
    LDX #$04 ; GFX.
    JSR ENGINE_SET_MAPPER_BANK_X_VAL_A
    LDA #$00
    STA SOUND_SAMPLE_FLAG_DONT_RESET_LEVEL ; Clear ??
    JSR SETTLE_SPRITES_OFFSCREEN/CLEAR_RAM ; Settle clean.
    JMP ENGINE_SETTLE_UPDATES_TODO ; Do.
HELPER_SPRITE_0_ATTR: ; 13:08D4, 0x0268D4
    SEC ; Prep sub.
    BPL RTS ; Positive, goto.
    TAY ; A to Y.
    TXA ; Attr to A.
    ORA SPRITE_PAGE+2 ; Combine attrs.
    STA SPRITE_PAGE+2 ; Update attrs.
    TYA ; A val back.
    SBC #$07 ; -= 0x7
RTS: ; 13:08E2, 0x0268E2
    RTS ; Leave.
    .db 00 ; GFX Banks set.
    .db 78
    .db 58
    .db 59
    .db 5A
    .db 00
    .db 0F ; Palette.
    .db 36
    .db 30
    .db 2A
    .db 0F
    .db 36
    .db 30
    .db 2A
    .db 0F
    .db 36
    .db 30
    .db 16
    .db 0F
    .db 36
    .db 30
    .db 16
    .db 0F
    .db 21
    .db 02
    .db 0A
    .db 0F
    .db 21
    .db 21
    .db 21
    .db 0F
    .db 21
    .db 21
    .db 21
    .db 0F
    .db 21
    .db 21
    .db 21
ALT_RTN_UNK: ; 13:0909, 0x026909
    JSR PTR_AND_CREATE_UNK
    JSR WAIT_PRESSES_CLEAR?
    JMP LIB_OBJECTS_AND_SETTLE_AND_FLAGS_UNK
    STA MISC_USE_A
    LDA #$00
    STA MISC_USE_B
    JSR SUB_UNK
    LDA MISC_USE_A
    STA R_**:$002A
    LDA MISC_USE_B
    STA R_**:$002B
    RTS
    LDA #$E8
    LDX #$03
    STA R_**:$002A
    STX R_**:$002B
    RTS
    JSR ENGINE_WRAM_STATE_WRITEABLE
    JSR $A964
    LDA #$04
    STA **:$6D20
    CLC
    LDA GFX_BANKS[4]
    ADC #$38
    STA **:$6D21
    LDA GFX_BANKS+1
    ADC #$00
    STA **:$6D22
    JSR $BBDF
    LDY #$00
    LDA [MISC_USE_A],Y
    STA SAVE_GAME_MOD_PAGE_PTR[2]
    INY
    LDA [MISC_USE_A],Y
    STA SAVE_GAME_MOD_PAGE_PTR+1
    LDY #$00
    LDA [SAVE_GAME_MOD_PAGE_PTR[2]],Y
    STA **:$6D24,Y
    INY
    CMP #$00
    BNE 13:0957
    JMP ENGINE_WRAM_STATE_WRITE_DISABLED
    LDA R_**:$0028
    JSR CREATE_PTR_UNK
    LDA MISC_USE_A
    STA GFX_BANKS[4]
    LDA MISC_USE_B
    STA GFX_BANKS+1
    RTS
    LDY #$01
    LDA [GFX_BANKS[4]],Y
    AND #$F0
    RTS
BANKED_DERP: ; 13:0979, 0x026979
    LDA #$00 ; Val ??
    JSR TEST_FOR_VAL_EQ_PASSED ; Do ??
    BCS EXIT_RET_CS ; CS, goto.
    JSR ENGINE_WRAM_STATE_WRITEABLE ; Do WRAM writable.
    LDA PTR_CREATE_SEED? ; Load ??
    STA [MISC_USE_A],Y ; Store to ptr.
    CLC ; Ret CC.
    JMP ENGINE_WRAM_STATE_WRITE_DISABLED ; Exit disabling wram.
    JSR L_13:10A3
    BNE EXIT_RET_CS
    LDA PTR_CREATE_SEED?
    JSR TEST_FOR_VAL_EQ_PASSED
    BCS EXIT_RET_CS
    JSR ENGINE_WRAM_STATE_WRITEABLE
    JSR L_13:107E
    CLC
    JMP ENGINE_WRAM_STATE_WRITE_DISABLED
EXIT_RET_CS: ; 13:09A1, 0x0269A1
    SEC
    RTS
    LDA R_**:$0028
    PHA
    LDA GFX_BANKS+2
    STA R_**:$0028
    JSR 13:0990
    PLA
    STA R_**:$0028
    RTS
    JSR ENGINE_WRAM_STATE_WRITEABLE
    SEC
    LDY #$16
    LDA [GFX_BANKS[4]],Y
    SBC GFX_BANKS+3
    STA [GFX_BANKS[4]],Y
    INY
    LDA [GFX_BANKS[4]],Y
    SBC #$00
    STA [GFX_BANKS[4]],Y
    JMP ENGINE_WRAM_STATE_WRITE_DISABLED
SUB_STREAM_AND_CMP_UNK: ; 13:09C7, 0x0269C7
    TAY ; A to Y.
    BEQ Y_EQ_0x00 ; == 0, goto.
    TAX ; Val to X.
    LDY #$00 ; Stream reset.
    LDA [ENGINE_FPTR_30[2]],Y ; Load from stream.
    AND #$3F ; Keep lower.
    TAY ; Val to index.
    TXA ; X to A.
Y_EQ_0x00: ; 13:09D3, 0x0269D3
    CPY #$20 ; If _ #$20
    RTS ; Return compare.
    JSR $AB3E
    JSR L_1F:0772
    AND LUT_INDEX_TO_BITS_0x80-0x01,X
    BNE 13:09FD
    LDA #$04
    JSR 1F:02C2
    LDX #$66
    JSR $A445
    LDA #$0A
    STA R_**:$07F1
    LDY #$06
    LDA [ENGINE_FPTR_32[2]],Y
    AND #$7F
    STA PTR_CREATE_SEED?
    BNE 13:0A05
    JSR $AA3F
    LDX #$76
    JSR $A445
    JMP $AB30
    JSR $BB8C
    LDX #$68
    JSR $A445
    LDX #$00
    JSR X_INDEX_TEST_UNK
    BCS 13:0A1F
    STA R_**:$0028
    TXA
    PHA
    JSR $A979
    PLA
    TAX
    BCC 13:0A2C
    INX
    CPX #$04
    BCC 13:0A0F
    LDX #$6E
    JSR $A445
    JMP $AB30
    JSR $AA3F
    JSR $BB6F
    LDX #$6A
    JSR $A445
    LDA #$06
    STA R_**:$07F1
    JMP $AB30
    JSR ENGINE_WRAM_STATE_WRITEABLE
    JSR L_1F:0772
    ORA LUT_INDEX_TO_BITS_0x80-0x01,X
    STA CURRENT_SAVE_MANIPULATION_PAGE+544,Y
    JMP ENGINE_WRAM_STATE_WRITE_DISABLED
    LDA R_**:$0028
    STA GFX_BANKS+2
    LDA COUNT_LOOPS?_UNK
    CMP #$02
    BCC 13:0A6A
    LDA FPTR_PACKET_CREATION[2]
    PHA
    LDA ARG_IDFK
    PHA
    JSR $B763
    PLA
    STA ARG_IDFK
    PLA
    STA FPTR_PACKET_CREATION[2]
    BCS 13:0A6F
    JSR $BB6F
    CLC
    RTS
    .db A5
    .db 42
    .db 85
    .db 28
    .db 60
    .db 00
    .db 01
    .db 02
    .db 04
    .db 08
    .db 10
    .db 20
    .db 20
MOVE_FILE_UNK: ; 13:0A7C, 0x026A7C
    LDA FILE_PTR_H,X
    STA FPTR_PACKET_CREATION[2]
    LDA FILE_PTR_L,X
    STA ARG_IDFK
    RTS
FILE_PTR_H: ; 13:0A87, 0x026A87
    HIGH(R_**:$0000)
FILE_PTR_L: ; 13:0A88, 0x026A88
    LOW(R_**:$0000)
    HIGH((null))
    LOW((null))
    HIGH((null))
    LOW((null))
    HIGH((null))
    LOW((null))
    HIGH(R_**:$0000)
    LOW(R_**:$0000)
    HIGH(1E:1703)
    LOW(1E:1703)
    HIGH(1E:1B03)
    LOW(1E:1B03)
    HIGH(RTS)
    LOW(RTS)
    HIGH(1E:0806)
    LOW(1E:0806)
    HIGH(1E:1006)
    LOW(1E:1006)
    HIGH(1E:0906)
    LOW(1E:0906)
    HIGH((null))
    LOW((null))
    HIGH((null))
    LOW((null))
    HIGH((null))
    LOW((null))
    HIGH((null))
    LOW((null))
    HIGH((null))
    LOW((null))
    HIGH((null))
    LOW((null))
    HIGH((null))
    LOW((null))
    HIGH((null))
    LOW((null))
    HIGH((null))
    LOW((null))
    HIGH((null))
    LOW((null))
    HIGH((null))
    LOW((null))
    HIGH((null))
    LOW((null))
    HIGH((null))
    LOW((null))
    HIGH((null))
    LOW((null))
    HIGH((null))
    LOW((null))
    HIGH((null))
    LOW((null))
    HIGH((null))
    LOW((null))
    HIGH((null))
    LOW((null))
    HIGH((null))
    LOW((null))
    HIGH((null))
    LOW((null))
    HIGH((null))
    LOW((null))
    HIGH((null))
    LOW((null))
    HIGH((null))
    LOW((null))
    HIGH((null))
    LOW((null))
    HIGH((null))
    LOW((null))
    HIGH((null))
    LOW((null))
    HIGH((null))
    LOW((null))
    HIGH((null))
    LOW((null))
    HIGH((null))
    LOW((null))
    HIGH((null))
    LOW((null))
    HIGH((null))
    LOW((null))
    HIGH((null))
    LOW((null))
    HIGH(1E:0106)
    LOW(1E:0106)
    HIGH((null))
    LOW((null))
    HIGH(SCRIPT_UPDATES_AND_MORE_UNK)
    LOW(SCRIPT_UPDATES_AND_MORE_UNK)
    HIGH(TODO_ROUTINE_NO_MASK_ENTRY)
    LOW(TODO_ROUTINE_NO_MASK_ENTRY)
    HIGH(1E:0506)
    LOW(1E:0506)
    HIGH(1E:0606)
    LOW(1E:0606)
    HIGH((null))
    LOW((null))
    HIGH(1E:0006)
    LOW(1E:0006)
    HIGH((null))
    LOW((null))
    HIGH((null))
    LOW((null))
    HIGH((null))
    LOW((null))
    HIGH(1E:0B06)
    LOW(1E:0B06)
    HIGH((null))
    LOW((null))
    HIGH(1E:0C06)
    LOW(1E:0C06)
    HIGH(1E:0D06)
    LOW(1E:0D06)
    HIGH(1E:0A06)
    LOW(1E:0A06)
    HIGH((null))
    LOW((null))
    HIGH(1E:0F06)
    LOW(1E:0F06)
    HIGH(1E:0E06)
    LOW(1E:0E06)
    .db 14
    .db 00
    .db 16
    .db 00
    .db 38
    .db 03
    .db 18
    .db 00
    .db 21
    .db 00
    .db 1B
    .db 00
STREAM_PROCESS_UNK_INIT: ; 13:0B0F, 0x026B0F
    JSR STREAM_MOVE_AND_BANKED_PROPER_TODO
    LDY #$14 ; Stream index.
    LDA [ENGINE_FPTR_30[2]],Y ; Load ??
    AND #$0F ; Keep lower.
    TAY ; To Y index.
PROCESS_STREAM_LOOP: ; 13:0B19, 0x026B19
    LDA [ENGINE_FPTR_32[2]],Y ; Load from ptr.
    BEQ PTR_EQ_0x00 ; == 0, goto.
    JSR SCRIPT_COMMAND_LAUNCHER ; Do command launch.
    JMP PROCESS_STREAM_LOOP ; Loop more.
PTR_EQ_0x00: ; 13:0B23, 0x026B23
    LDA MAIN_FLAG_UNK ; Load ??
    BEQ WAIT_PRESSES_CLEAR? ; == 0, goto.
    JSR LIB_RTN_PTR_CREATION/SHIFT+CLEAR_UNK_MOVE_PTR_DOWN_UNK ; Do.
    LDA #$40
    STA **:$0034 ; Set ??
    BNE STREAM_PROCESS_UNK_INIT ; Always taken, loop.
WAIT_PRESSES_CLEAR?: ; 13:0B30, 0x026B30
    LDA ROUTINE_CONTINUE_FLAG? ; Load ??
    BEQ EXIT_FINISHED_RET_CS ; == 0, goto.
    LDA #$00
    STA ROUTINE_CONTINUE_FLAG? ; Clear flag.
    CLC ; Ret CC, continue.
    JMP WAIT_ANY_BUTTONS_PRESSED_RET_PRESSED ; Goto.
EXIT_FINISHED_RET_CS: ; 13:0B3C, 0x026B3C
    SEC ; Ret CS, finished.
    RTS ; Leave.
STREAM_MOVE_AND_BANKED_PROPER_TODO: ; 13:0B3E, 0x026B3E
    JSR STREAM_PTR_30_PTR_DATA_TO_32 ; Do.
EXIT_HANDLED?: ; 13:0B41, 0x026B41
    LDY #$01 ; Stream index.
    LDA [ENGINE_FPTR_30[2]],Y ; Load data from file.
    JMP BANK_HANDLER_R6_AND_BASE ; Set R6 for routine called, base the bank index.
STREAM_MOVE_BANK_STREAM_READ_UNK: ; 13:0B48, 0x026B48
    JSR STREAM_MOVE_AND_BANKED_PROPER_TODO ; Do.
    LDY #$1C ; Stream index.
    LDA [ENGINE_FPTR_30[2]],Y ; Load from stream.
    TAY ; To Y index.
    JMP PROCESS_STREAM_LOOP ; Goto.
LIB_STREAM_COMMANDS_PROCESS_UNK: ; 13:0B53, 0x026B53
    JSR LIB_RTN_PTR_CREATION/SHIFT+CLEAR_UNK_MOVE_PTR_DOWN_UNK ; Do ??
    JSR STREAM_MOVE_AND_BANKED_PROPER_TODO ; Do ??
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT? ; Y from ??
    JMP PROCESS_STREAM_LOOP ; Goto.
SCRIPT_COMMAND_LAUNCHER: ; 13:0B5E, 0x026B5E
    ASL A ; << 1, *2.
    TAX ; To X index.
    LDA RTN_TBL_H,X ; PTR to stack for RTS Launch.
    PHA
    LDA RTN_TBL_L,X
    PHA
    RTS ; Launch it.
RTN_TBL_L: ; 13:0B69, 0x026B69
    LOW(13:0B2F) ; 0x00
RTN_TBL_H: ; 13:0B6A, 0x026B6A
    HIGH(13:0B2F) ; Wait for CTRL press, any button. CC continue, CS completed.
    LOW(13:0C87) ; 0x01
    HIGH(13:0C87)
    LOW(13:0C8C) ; 0x02
    HIGH(13:0C8C)
    LOW(13:0CB6) ; 0x03
    HIGH(13:0CB6) ; Pulls stack 2x, returns.
    LOW(13:0CB9)
    HIGH(13:0CB9)
    LOW(13:0C53)
    HIGH(13:0C53)
    LOW(13:0C53)
    HIGH(13:0C53)
    LOW(13:0C40)
    HIGH(13:0C40)
    LOW(13:0D0C)
    HIGH(13:0D0C)
    LOW(13:0DA1)
    HIGH(13:0DA1)
    LOW(13:0C70)
    HIGH(13:0C70)
    LOW(13:0C70)
    HIGH(13:0C70)
    LOW(13:0C60)
    HIGH(13:0C60)
    LOW(13:0C69)
    HIGH(13:0C69)
    LOW(13:0C40)
    HIGH(13:0C40)
    LOW(13:0C4A)
    HIGH(13:0C4A)
    LOW(13:0E22)
    HIGH(13:0E22)
    LOW(13:0E34)
    HIGH(13:0E34)
    LOW(13:0E49)
    HIGH(13:0E49)
    LOW(13:0E6B)
    HIGH(13:0E6B)
    LOW(13:0E5D)
    HIGH(13:0E5D)
    LOW(13:0E79)
    HIGH(13:0E79)
    LOW(13:0E89)
    HIGH(13:0E89)
    LOW(13:148C)
    HIGH(13:148C)
    LOW(13:10AC)
    HIGH(13:10AC)
    LOW(13:0E96)
    HIGH(13:0E96)
    LOW(13:0EBC)
    HIGH(13:0EBC)
    LOW(13:1504)
    HIGH(13:1504)
    LOW(13:10E3)
    HIGH(13:10E3)
    LOW(13:0E9D)
    HIGH(13:0E9D)
    LOW(13:0EC4)
    HIGH(13:0EC4)
    LOW(13:1483)
    HIGH(13:1483)
    LOW(13:1195)
    HIGH(13:1195)
    LOW(13:1171)
    HIGH(13:1171)
    LOW(13:1183)
    HIGH(13:1183)
    LOW(13:0FAB)
    HIGH(13:0FAB)
    LOW(13:0FB7)
    HIGH(13:0FB7)
    LOW(13:0EB5)
    HIGH(13:0EB5)
    LOW(13:0ED2)
    HIGH(13:0ED2)
    LOW(13:0F8D)
    HIGH(13:0F8D)
    LOW(13:0EDA)
    HIGH(13:0EDA)
    LOW(13:0EED)
    HIGH(13:0EED)
    LOW(13:0F14)
    HIGH(13:0F14)
    LOW(13:0F2E)
    HIGH(13:0F2E)
    LOW(13:0FDB)
    HIGH(13:0FDB)
    LOW(13:0FD0)
    HIGH(13:0FD0)
    LOW(13:0FE9)
    HIGH(13:0FE9)
    LOW(13:0FF4)
    HIGH(13:0FF4)
    LOW(13:100B)
    HIGH(13:100B)
    LOW(13:103B)
    HIGH(13:103B)
    LOW(13:0F5D)
    HIGH(13:0F5D)
    LOW(13:1027)
    HIGH(13:1027)
    LOW(13:0C70)
    HIGH(13:0C70)
    LOW(13:0C70)
    HIGH(13:0C70)
    LOW(13:13D7)
    HIGH(13:13D7)
    LOW(13:0DF9)
    HIGH(13:0DF9)
    LOW(13:11BC)
    HIGH(13:11BC)
    LOW(13:11D7)
    HIGH(13:11D7)
    LOW(13:10D0)
    HIGH(13:10D0)
    LOW(13:1234)
    HIGH(13:1234)
    LOW(13:142A)
    HIGH(13:142A)
    LOW(13:141F)
    HIGH(13:141F)
    LOW(13:1245)
    HIGH(13:1245)
    LOW(13:0C56)
    HIGH(13:0C56)
    LOW(13:0C70)
    HIGH(13:0C70)
    LOW(13:14EA)
    HIGH(13:14EA)
    LOW(13:143F)
    HIGH(13:143F)
    LOW(13:1458)
    HIGH(13:1458)
    LOW(13:1471)
    HIGH(13:1471)
    LOW(13:1510)
    HIGH(13:1510)
    LOW(13:128F)
    HIGH(13:128F)
    LOW(13:12FB)
    HIGH(13:12FB)
    LOW(13:1322)
    HIGH(13:1322)
    LOW(13:1338)
    HIGH(13:1338)
    LOW(13:1349)
    HIGH(13:1349)
    LOW(13:13A7)
    HIGH(13:13A7)
    LOW(13:13B4)
    HIGH(13:13B4)
    LOW(13:1316)
    HIGH(13:1316)
    LOW(13:1431)
    HIGH(13:1431)
    LOW(13:13E7)
    HIGH(13:13E7)
    LOW(13:15A8)
    HIGH(13:15A8)
    LOW(13:1649)
    HIGH(13:1649)
    LOW(13:15E1)
    HIGH(13:15E1)
    LOW(13:15FF)
    HIGH(13:15FF)
    LOW(13:15F0)
    HIGH(13:15F0)
    LOW(13:1545)
    HIGH(13:1545)
    LOW(13:149F)
    HIGH(13:149F)
    LOW(13:14A8)
    HIGH(13:14A8)
    LOW(13:0EA9)
    HIGH(13:0EA9)
    LOW(13:1628)
    HIGH(13:1628)
    LOW(13:1694)
    HIGH(13:1694)
    LOW(13:16AB)
    HIGH(13:16AB)
    LOW(13:16B3)
    HIGH(13:16B3)
    LOW(13:16BB)
    HIGH(13:16BB)
    LOW(13:0C40)
    HIGH(13:0C40)
    LOW(13:16C3)
    HIGH(13:16C3)
    LOW(13:15C8)
    HIGH(13:15C8)
    LOW(13:163F)
    HIGH(13:163F)
    LOW(13:11FC)
    HIGH(13:11FC)
    LOW(13:1222)
    HIGH(13:1222)
    LOW(13:16DA)
    HIGH(13:16DA)
    LOW(13:16E9)
    HIGH(13:16E9)
    LOW(13:170B)
    HIGH(13:170B)
    LOW(13:1724)
    HIGH(13:1724)
    LOW(13:172C)
    HIGH(13:172C)
    LOW(13:1734)
    HIGH(13:1734)
    LOW(13:173E)
    HIGH(13:173E)
    LOW(13:1750)
    HIGH(13:1750)
SELF_LOCKUP_JMP: ; 13:0C41, 0x026C41
    JMP SELF_LOCKUP_JMP ; JMP Self?
FILE_CREATE: ; 13:0C44, 0x026C44
    STA FPTR_PACKET_CREATION[2] ; Store FPTR.
    STX FPTR_PACKET_CREATION+1
    JMP ENGINE_CREATE_UPDATE_BUF_INIT_INC? ; Create.
ENGINE_RESET_GAME: ; 13:0C4B, 0x026C4B
    JSR WAIT_PRESSES_CLEAR? ; Do.
    JSR ENGINE_PALETTE_FADE_OUT ; Palette.
    JMP VECTOR_RESET ; Reset the game.
    INY
    INY
    RTS
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    CLC
    ADC #$04
    STA MAIN_FLAG_UNK
    INY
    RTS
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    CLC
    ADC #$C0
    JMP $AC6D
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    CMP PTR_CREATE_SEED?
    BNE L_13:0C88
    TXA
    LSR A
    CMP **:$0034
    BNE L_13:0C88
    INY
    INY
    RTS
L_13:0C7A: ; 13:0C7A, 0x026C7A
    BCS 13:0C77
    BCC L_13:0C88
L_13:0C7E: ; 13:0C7E, 0x026C7E
    BCC 13:0C77
    BCS L_13:0C88
L_13:0C82: ; 13:0C82, 0x026C82
    BNE 13:0C77
    BEQ L_13:0C88
L_13:0C86: ; 13:0C86, 0x026C86
    BEQ 13:0C77
L_13:0C88: ; 13:0C88, 0x026C88
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    TAY
    RTS
    LDA ENGINE_FPTR_32[2]
    PHA
    LDA ENGINE_FPTR_32+1
    PHA
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    PHA
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    PHA
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    STA STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    INY
    PLA
    STA ENGINE_FPTR_32+1
    PLA
    STA ENGINE_FPTR_32[2]
    TYA
    PHA
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    JSR $AB19
    PLA
    TAY
    PLA
    STA ENGINE_FPTR_32+1
    PLA
    STA ENGINE_FPTR_32[2]
    RTS
RETURN_EXTRA_LAYER?: ; 13:0CB7, 0x026CB7
    PLA
    PLA
    RTS
    LDA CURRENT_SAVE_MANIPULATION_PAGE+4
    AND #$3F
    CMP #$24
    BCC 13:0D05
    CMP #$2C
    BCS 13:0D05
    JSR ENGINE_PALETTE_SCRIPT_TO_TARGET
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    STA NMI_GFX_COUNTER
    INY
    LSR A
    LSR A
    LSR A
    AND #$07
    TAX
    LDA $ACFD,X
    STA SCRIPT_PALETTE_UPLOADED?+1
    STA SCRIPT_PALETTE_UPLOADED?+5
    STA SCRIPT_PALETTE_UPLOADED?+9
    STA SCRIPT_PALETTE_UPLOADED?+13
    JSR CREATE_PALETTE_UPLOAD_PACKET_0x1_WAIT
    LDA NMI_GFX_COUNTER
    BNE 13:0CD0
    LDA SCRIPT_R6_UNK
    LDX #$02
    JSR ENGINE_SET_MAPPER_BANK_X_VAL_A
    LDA SCRIPT_R7_UNK
    LDX #$03
    JSR ENGINE_SET_MAPPER_BANK_X_VAL_A
    JMP ENGINE_PALETTE_UPLOAD_WITH_PACKET_HELPER
    AND [SCRIPT_FLAG_0x22,X]
    ???
    BIT ENGINE_FLAG_25_SKIP_UNK
    BIT FLAG_UNK_23
    ???
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    TAX
    INY
    JMP ENGINE_DELAY_X_FRAMES
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    STA FPTR_PACKET_CREATION[2]
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    STA ARG_IDFK
    INY
    STY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
ALT_ENTRY_UNK: ; 13:0D1A, 0x026D1A
    LDA ROUTINE_CONTINUE_FLAG? ; Load ??
    BNE VAL_NONZERO ; != 0, goto.
    JSR L_13:1C0A ; Do ??
VAL_NONZERO: ; 13:0D21, 0x026D21
    LDA #$08 ; Val ??
    CMP ROUTINE_CONTINUE_FLAG? ; If _ #$2C
    BEQ VAL_EQ_2C_PORTION ; ==, goto.
L_13:0D27: ; 13:0D27, 0x026D27
    STA ROUTINE_CONTINUE_FLAG? ; Store diff.
L_13:0D29: ; 13:0D29, 0x026D29
    LDY PACKET_YPOS_COORD?
    CPY #$1B
    BCC L_13:0D36
    JSR L_13:0D98
    DEC R_**:$002D
    BMI L_13:0D84
L_13:0D36: ; 13:0D36, 0x026D36
    LDA R_**:$002D
    BNE L_13:0D40
    LDY PACKET_YPOS_COORD?
    CPY #$19
    BCS L_13:0D84
L_13:0D40: ; 13:0D40, 0x026D40
    JSR LIB_READING_PPU_ROM_$0110_HELPER
    LDA #$16
    STA R_**:$0070
    LDA #$00
    STA ENGINE_PACKINATOR_ARG_SEED_0xA0_PRE_COUNT
    JSR RTN_SETTLE_UPDATE_TODO
    JSR L_1E:07AF
    CMP #$00
    BEQ L_13:0D61
    LDY #$00
    LDA [FPTR_PACKET_CREATION[2]],Y
    CMP #$03
    BEQ L_13:0D75
    CMP #$00
    BNE L_13:0D29
L_13:0D61: ; 13:0D61, 0x026D61
    JSR EXIT_HANDLED?
    LDA #$00
    STA R_**:$0070
    STA ENGINE_PACKINATOR_ARG_SEED_0xA0_PRE_COUNT
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
L_13:0D6C: ; 13:0D6C, 0x026D6C
    SEC
    LDA PACKET_YPOS_COORD?
    SBC #$13
    LSR A
    STA R_**:$002D
    RTS
L_13:0D75: ; 13:0D75, 0x026D75
    INC FPTR_PACKET_CREATION[2]
    BNE VAL_EQ_2C_PORTION
    INC ARG_IDFK
VAL_EQ_2C_PORTION: ; 13:0D7B, 0x026D7B
    LDY PACKET_YPOS_COORD?
    CPY #$1B
    BCC L_13:0D84
    JSR L_13:0D98
L_13:0D84: ; 13:0D84, 0x026D84
    JSR L_13:0D6C
    LDA #$91
    LDX #$AD
    JSR L_13:0DC5
    JMP L_13:0D40
    .db 01
    .db 01
    .db 00
    .db 00
    .db C0
    .db 3B
    .db 12
L_13:0D98: ; 13:0D98, 0x026D98
    LDX #$04
    JSR L_1E:07C1
    DEC PACKET_YPOS_COORD?
    DEC PACKET_YPOS_COORD?
    RTS
    STY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    JSR L_13:0DAE
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    LDA FPTR_UNK_84_MENU_SELECTION?[2]
    JMP L_13:0C86
L_13:0DAE: ; 13:0DAE, 0x026DAE
    LDA #$DF
    LDX #$AD
    STA FPTR_PACKET_CREATION[2]
    STX ARG_IDFK
    LDA #$09
    JSR L_13:0D27
    LDA #$EC
    LDX #$AD
    BNE L_13:0DC5
STREAMS_AND_STREAM+CONVERT_IDK: ; 13:0DC1, 0x026DC1
    LDA #$F3 ; Seed FPTR ??
    LDX #$AD
L_13:0DC5: ; 13:0DC5, 0x026DC5
    STA FPTR_SPRITES?[2]
    STX FPTR_SPRITES?+1
    LDY #$06 ; Stream index into,
    LDA [FPTR_SPRITES?[2]],Y
    STA PACKET_HPOS_COORD? ; Store to.
    LDA #$D1 ; Seed FPTR ??
    LDX #$F0
    STA FPTR_UNK_84_MENU?[2]
    STX FPTR_UNK_84_MENU?+1
    JSR STREAM_AND_CONVERT_IDFK ; Do ??
    LDA #$08
    STA PACKET_HPOS_COORD? ; Set.
    RTS ; Leave.
    .db A0
    .db A0
    .db A0
    .db A0
    .db D9
    .db E5
    .db F3
    .db A0
    .db A0
    .db CE
    .db EF
    .db A0
    .db 00
    .db 02
    .db 01
    .db 05
    .db 00
    .db 80
    .db 3A
    .db 0B
    .db 02 ; File.
    .db 01
    .db 09
    .db 00
    .db C0
    .db 3A
    .db 09
    .db C8
    LDA [ENGINE_FPTR_32[2]],Y
    STA FPTR_PACKET_CREATION[2]
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    STA ARG_IDFK
    INY
    STY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    LDA #$37
    JSR L_13:0D27
    JSR STREAMS_AND_STREAM+CONVERT_IDK
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    BIT MENU_HELPER_STATUS?
    BVS L_13:0E20
    LDA FPTR_UNK_84_MENU_SELECTION?[2]
    BNE L_13:0E1C
    INY
    INY
    RTS
L_13:0E1C: ; 13:0E1C, 0x026E1C
    LDA [ENGINE_FPTR_32[2]],Y
    TAY
    RTS
L_13:0E20: ; 13:0E20, 0x026E20
    JMP L_13:0C88
    JSR ENGINE_WRAM_STATE_WRITEABLE
    JSR L_13:0E58
    ORA LUT_INDEX_TO_BITS_0x80-0x01,X
    STA CURRENT_SAVE_MANIPULATION_PAGE+512,Y
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    INY
    JMP ENGINE_WRAM_STATE_WRITE_DISABLED
    JSR ENGINE_WRAM_STATE_WRITEABLE
    JSR L_13:0E58
    ORA LUT_INDEX_TO_BITS_0x80-0x01,X
    EOR LUT_INDEX_TO_BITS_0x80-0x01,X
    STA CURRENT_SAVE_MANIPULATION_PAGE+512,Y
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    INY
    JMP ENGINE_WRAM_STATE_WRITE_DISABLED
    JSR L_13:0E58
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    AND LUT_INDEX_TO_BITS_0x80-0x01,X
    EOR LUT_INDEX_TO_BITS_0x80-0x01,X
    JMP L_13:0C86
L_13:0E58: ; 13:0E58, 0x026E58
    INY
    STY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    JMP L_1F:0646
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    TAX
    INY
    JSR ENGINE_WRAM_STATE_WRITEABLE
    INC CURRENT_SAVE_MANIPULATION_PAGE+608,X
    JMP ENGINE_WRAM_STATE_WRITE_DISABLED
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    TAX
    INY
    JSR ENGINE_WRAM_STATE_WRITEABLE
    DEC CURRENT_SAVE_MANIPULATION_PAGE+608,X
    JMP ENGINE_WRAM_STATE_WRITE_DISABLED
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    TAX
    INY
    JSR ENGINE_WRAM_STATE_WRITEABLE
    LDA #$00
    STA CURRENT_SAVE_MANIPULATION_PAGE+608,X
    JMP ENGINE_WRAM_STATE_WRITE_DISABLED
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    TAX
    INY
    LDA CURRENT_SAVE_MANIPULATION_PAGE+608,X
    CMP [ENGINE_FPTR_32[2]],Y
    JMP L_13:0C7A
    JSR L_13:1032
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    INY
    RTS
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    STA R_**:$002A
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    STA R_**:$002B
    INY
    RTS
    LDA CURRENT_SAVE_MANIPULATION_PAGE+16
    STA R_**:$002A
    LDA CURRENT_SAVE_MANIPULATION_PAGE+17
    STA R_**:$002B
    INY
    RTS
    JSR L_13:0FC4
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    INY
    RTS
    INY
    LDA R_**:$0028
    CMP [ENGINE_FPTR_32[2]],Y
    JMP L_13:0C86
    SEC
    INY
    LDA R_**:$002A
    SBC [ENGINE_FPTR_32[2]],Y
    INY
    LDA R_**:$002B
    SBC [ENGINE_FPTR_32[2]],Y
    JMP L_13:0C7A
    INY
    LDA PTR_CREATE_SEED?
    CMP [ENGINE_FPTR_32[2]],Y
    JMP L_13:0C86
    CLC
    LDA CURRENT_SAVE_MANIPULATION_PAGE+16
    ADC R_**:$002A
    STA MISC_USE_A
    LDA CURRENT_SAVE_MANIPULATION_PAGE+17
    ADC R_**:$002B
    STA MISC_USE_B
    BCS L_13:0F12
    BCC L_13:0EFF
    SEC
    LDA CURRENT_SAVE_MANIPULATION_PAGE+16
    SBC R_**:$002A
    STA MISC_USE_A
    LDA CURRENT_SAVE_MANIPULATION_PAGE+17
    SBC R_**:$002B
    STA MISC_USE_B
    BCC L_13:0F12
L_13:0EFF: ; 13:0EFF, 0x026EFF
    JSR ENGINE_WRAM_STATE_WRITEABLE
    LDA MISC_USE_A
    STA CURRENT_SAVE_MANIPULATION_PAGE+16
    LDA MISC_USE_B
    STA CURRENT_SAVE_MANIPULATION_PAGE+17
    JSR ENGINE_WRAM_STATE_WRITE_DISABLED
    INY
    INY
    RTS
L_13:0F12: ; 13:0F12, 0x026F12
    JMP L_13:0C88
    CLC
    LDA CURRENT_SAVE_MANIPULATION_PAGE+18
    ADC R_**:$002A
    STA MISC_USE_A
    LDA CURRENT_SAVE_MANIPULATION_PAGE+19
    ADC R_**:$002B
    STA MISC_USE_B
    LDA CURRENT_SAVE_MANIPULATION_PAGE+20
    ADC #$00
    STA MISC_USE_C
    BCS L_13:0F12
    BCC L_13:0F47
    SEC
    LDA CURRENT_SAVE_MANIPULATION_PAGE+18
    SBC R_**:$002A
    STA MISC_USE_A
    LDA CURRENT_SAVE_MANIPULATION_PAGE+19
    SBC R_**:$002B
    STA MISC_USE_B
    LDA CURRENT_SAVE_MANIPULATION_PAGE+20
    SBC #$00
    STA MISC_USE_C
    BCC L_13:0F12
L_13:0F47: ; 13:0F47, 0x026F47
    JSR ENGINE_WRAM_STATE_WRITEABLE
    LDA MISC_USE_A
    STA CURRENT_SAVE_MANIPULATION_PAGE+18
    LDA MISC_USE_B
    STA CURRENT_SAVE_MANIPULATION_PAGE+19
    LDA MISC_USE_C
    STA CURRENT_SAVE_MANIPULATION_PAGE+20
    INY
    INY
    JMP ENGINE_WRAM_STATE_WRITE_DISABLED
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    STA SAVE_GAME_MOD_PAGE_PTR[2]
    STY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    LDA R_**:$002A
    STA MISC_USE_A
    LDA R_**:$002B
    STA MISC_USE_B
    JSR LIB_DECIMAL?_UNK
    LDA #$64
    STA SAVE_GAME_MOD_PAGE_PTR[2]
    JSR ENGINE_NUMS_UNK_MODULO?
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    INY
    LDA MISC_USE_C
    BNE L_13:0F87
    LDA MISC_USE_A
    STA R_**:$002A
    LDA MISC_USE_B
    STA R_**:$002B
    RTS
L_13:0F87: ; 13:0F87, 0x026F87
    LDA #$FF
    STA R_**:$002A
    STA R_**:$002B
    RTS
    JSR L_13:0FC4
    LDX #$00
L_13:0F93: ; 13:0F93, 0x026F93
    JSR X_INDEX_TEST_UNK
    BCS L_13:0FA5
    STA R_**:$0028
    TXA
    PHA
    LDA PTR_CREATE_SEED?
    JSR TEST_FOR_VAL_EQ_PASSED
    PLA
    TAX
    BCC L_13:101E
L_13:0FA5: ; 13:0FA5, 0x026FA5
    INX
    CPX #$04
    BCC L_13:0F93
    BCS L_13:1023
    JSR L_13:0FC4
    LDA PTR_CREATE_SEED?
    JSR TEST_FOR_VAL_EQ_PASSED
    BCC L_13:101E
    BCS L_13:1023
    JSR L_13:0FC4
    LDA PTR_CREATE_SEED?
    JSR L_13:1063
    BCS L_13:1023
    BCC L_13:101E
L_13:0FC4: ; 13:0FC4, 0x026FC4
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    STA PTR_CREATE_SEED?
    STY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    JSR PTR_AND_BANK_R6_UNK
    JMP PTR_MOVE_TO_UNK_ARR_WRAM
    STY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    LDA #$00
    JSR TEST_FOR_VAL_EQ_PASSED
    BCS L_13:1023
    BCC L_13:0FFE
    STY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    JSR L_13:10A3
    PHP
    JSR EXIT_HANDLED?
    PLP
    BNE L_13:1023
    BEQ L_13:0FEC
    STY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
L_13:0FEC: ; 13:0FEC, 0x026FEC
    LDA PTR_CREATE_SEED?
    JSR TEST_FOR_VAL_EQ_PASSED
    BCS L_13:1023
    BCC L_13:1015
    STY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    LDA #$00
    JSR L_13:1063
    BCS L_13:1023
L_13:0FFE: ; 13:0FFE, 0x026FFE
    JSR ENGINE_WRAM_STATE_WRITEABLE
    LDA PTR_CREATE_SEED?
    STA [MISC_USE_A],Y
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    INY
    INY
    JMP ENGINE_WRAM_STATE_WRITE_DISABLED
    STY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    LDA PTR_CREATE_SEED?
    JSR L_13:1063
    BCS L_13:1023
L_13:1015: ; 13:1015, 0x027015
    JSR ENGINE_WRAM_STATE_WRITEABLE
    JSR L_13:107E
    JSR ENGINE_WRAM_STATE_WRITE_DISABLED
L_13:101E: ; 13:101E, 0x02701E
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    INY
    INY
    RTS
L_13:1023: ; 13:1023, 0x027023
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    JMP L_13:0C88
    JSR L_13:1032
    JSR L_13:0728
    BCC L_13:101E
    BCS L_13:1023
L_13:1032: ; 13:1032, 0x027032
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    STA R_**:$0028
    STY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    JMP L_13:1B6F
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    STY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    PHA
    LDA R_**:$0028
    JSR PTR_AND_ADVANCE_TODO
    PLA
    TAY
    LDA [MISC_USE_A],Y
    BEQ L_13:1023
    STA PTR_CREATE_SEED?
    JSR PTR_AND_BANK_R6_UNK
    JSR PTR_MOVE_TO_UNK_ARR_WRAM
    JMP L_13:101E
TEST_FOR_VAL_EQ_PASSED: ; 13:1058, 0x027058
    PHA ; Save val. TODO TODO TODO
    LDA R_**:$0028 ; Load ??
    JSR PTR_AND_ADVANCE_TODO ; Do ??
    PLA ; Pull val passed.
    LDY #$08 ; Seed target.
    BNE SEEDED_ENTRY ; Always taken.
L_13:1063: ; 13:1063, 0x027063
    JSR PTR_VERY_MANUAL_HELPER_76B0 ; Set PTR.
    LDY #$50 ; Seed target.
SEEDED_ENTRY: ; 13:1068, 0x027068
    STY SAVE_GAME_MOD_PAGE_PTR[2] ; Y to.
    LDY #$00 ; Reseet.
LT_TARGET: ; 13:106C, 0x02706C
    CMP [MISC_USE_A],Y ; If A _ stream
    BEQ EXIT_RET_CC ; ==, goto.
    INY ; Stream++
    CPY SAVE_GAME_MOD_PAGE_PTR[2] ; If _ target
    BCC LT_TARGET ; <, goto.
    RTS ; Return CS, failed.
EXIT_RET_CC: ; 13:1076, 0x027076
    CLC ; Passed, ret CC.
    RTS ; Leave.
L_13:1078: ; 13:1078, 0x027078
    LDA [MISC_USE_A],Y
    DEY
    STA [MISC_USE_A],Y
    INY
L_13:107E: ; 13:107E, 0x02707E
    INY
    CPY SAVE_GAME_MOD_PAGE_PTR[2]
    BCC L_13:1078
    LDA #$00
    DEY
    STA [MISC_USE_A],Y
    RTS
PTR_AND_ADVANCE_TODO: ; 13:1089, 0x027089
    JSR CREATE_PTR_UNK ; Create ptr.
    CLC ; Prep add.
    LDA MISC_USE_A ; Load ??
    ADC #$20 ; += 0x20
    STA MISC_USE_A ; Store result.
    LDA MISC_USE_B ; Carry into.
    ADC #$00
    STA MISC_USE_B ; Store result.
    RTS ; Leave.
PTR_VERY_MANUAL_HELPER_76B0: ; 13:109A, 0x02709A
    LDX #$B0
    STX MISC_USE_A
    LDX #$76
    STX MISC_USE_B
    RTS
L_13:10A3: ; 13:10A3, 0x0270A3
    JSR SUB_PTR_OFFSET_AND_BASE_9800
    LDY #$02
    LDA [MISC_USE_A],Y
    AND #$80
    RTS
    LDA #$18
    STA ROUTINE_CONTINUE_FLAG?
    LDA PACKET_HPOS_COORD?
    PHA
    LDA PACKET_YPOS_COORD?
    PHA
    STY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    JSR L_13:1763
    PLA
    STA PACKET_YPOS_COORD?
    PLA
    STA PACKET_HPOS_COORD?
    BCS L_13:10CC
L_13:10C4: ; 13:10C4, 0x0270C4
    JSR L_13:1B6F
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    INY
    INY
    RTS
L_13:10CC: ; 13:10CC, 0x0270CC
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    JMP L_13:0C88
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    STY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    TAX
    CPX #$04
    BCS L_13:10CC
    LDA CURRENT_SAVE_MANIPULATION_PAGE+8,X
    BEQ L_13:10CC
    STA R_**:$0028
    BNE L_13:10C4
    STY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    JSR L_13:1C28
    LDX #$07
L_13:10EB: ; 13:10EB, 0x0270EB
    LDA L_13:115E,X
    STA ARR_BITS_TO_UNK[8],X
    DEX
    BPL L_13:10EB
    LDA #$66
    LDX #$B1
    STA FPTR_PACKET_CREATION[2]
    STX ARG_IDFK
    LDA #$1C
    JSR L_13:0D27
    LDA #$6C
    LDX #$B1
    STA FPTR_SPRITES?[2]
    STX FPTR_SPRITES?+1
    LDA #$6C
    LDX #$00
    STA FPTR_UNK_84_MENU?[2]
    STX FPTR_UNK_84_MENU?+1
    LDA #$00
    STA STREAM_TARGET?
    STA CARRY_UP?
    STA FPTR_UNK_84_MENU_SELECTION?[2]
L_13:1118: ; 13:1118, 0x027118
    LDX #$0C
    STX PACKET_HPOS_COORD?
    JSR SETTLE_AND_SPRITES_TO_COORD?_IDFK
    LDA MENU_HELPER_STATUS?
    AND #$0C
    BEQ L_13:1146
    LDX FPTR_UNK_84_MENU_SELECTION?[2]
    LDY ARR_BITS_TO_UNK+4,X
    AND #$08
    BEQ L_13:1136
    INY
    CPY #$BA
    BNE L_13:113D
    LDY #$B0
    BNE L_13:113D
L_13:1136: ; 13:1136, 0x027136
    DEY
    CPY #$AF
    BNE L_13:113D
    LDY #$B9
L_13:113D: ; 13:113D, 0x02713D
    TYA
    STA ARR_BITS_TO_UNK+4,X
    JSR ENGINE_POS_TO_UPDATE_UNK
    JMP L_13:1118
L_13:1146: ; 13:1146, 0x027146
    JSR LUT_UNK
    LDA MISC_USE_A
    STA R_**:$002A
    LDA MISC_USE_B
    STA R_**:$002B
    LDX #$08
    STX PACKET_HPOS_COORD?
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    LDA #$40
    BIT MENU_HELPER_STATUS?
    JMP L_13:0C86
L_13:115E: ; 13:115E, 0x02715E
    .db A0
    .db A0
    .db A4
    .db A0
    .db B0
    .db B0
    .db B0
    .db B0
    .db 23
    .db 68
    .db 00
    .db 00
    .db 08
    .db 00
    .db 04
    .db 01
    .db 01
    .db 00
    .db CC
    .db 01
    .db A9
    .db 21
    .db 85
    .db 2C
    .db 84
    .db 35
    LDA PACKET_HPOS_COORD?
    PHA
    LDA PACKET_YPOS_COORD?
    PHA
    JSR L_13:187F
    JMP L_13:11A5
    LDA #$22
    STA ROUTINE_CONTINUE_FLAG?
    STY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    LDA PACKET_HPOS_COORD?
    PHA
    LDA PACKET_YPOS_COORD?
    PHA
    JSR L_13:1814
    JMP L_13:11A5
    LDA #$20
    STA ROUTINE_CONTINUE_FLAG?
    STY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    LDA PACKET_HPOS_COORD?
    PHA
    LDA PACKET_YPOS_COORD?
    PHA
    JSR L_13:17B6
L_13:11A5: ; 13:11A5, 0x0271A5
    PLA
    STA PACKET_YPOS_COORD?
    PLA
    STA PACKET_HPOS_COORD?
    BCS L_13:11B8
    JSR PTR_AND_BANK_R6_UNK
    JSR PTR_MOVE_TO_UNK_ARR_WRAM
L_13:11B3: ; 13:11B3, 0x0271B3
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    INY
    INY
    RTS
L_13:11B8: ; 13:11B8, 0x0271B8
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    JMP L_13:0C88
    STY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    LDX #$00
L_13:11C1: ; 13:11C1, 0x0271C1
    JSR X_INDEX_TEST_UNK
    BCS L_13:11D1
    TAY
    TXA
    PHA
    TYA
    JSR L_13:11E1
    PLA
    TAX
    BCC L_13:11B3
L_13:11D1: ; 13:11D1, 0x0271D1
    INX
    CPX #$04
    BCC L_13:11C1
    BCS L_13:11B8
    STY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    JSR L_13:11E8
    BCS L_13:11B8
    BCC L_13:11B3
L_13:11E1: ; 13:11E1, 0x0271E1
    JSR PTR_AND_ADVANCE_TODO
    LDY #$08
    BNE L_13:11ED
L_13:11E8: ; 13:11E8, 0x0271E8
    JSR PTR_VERY_MANUAL_HELPER_76B0
    LDY #$50
L_13:11ED: ; 13:11ED, 0x0271ED
    STY SAVE_GAME_MOD_PAGE_PTR[2]
    LDY #$00
L_13:11F1: ; 13:11F1, 0x0271F1
    LDA [MISC_USE_A],Y
    BNE L_13:11FB
    INY
    CPY SAVE_GAME_MOD_PAGE_PTR[2]
    BCC L_13:11F1
    RTS
L_13:11FB: ; 13:11FB, 0x0271FB
    CLC
    RTS
    STY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    JSR L_13:15C4
    JSR ENGINE_WRAM_STATE_WRITEABLE
    LDY #$28
    LDA [MISC_USE_A],Y
    BEQ L_13:121B
    STA CURRENT_SAVE_MANIPULATION_PAGE+640
    STY MISC_USE_C
    JSR L_13:1C5A
    JSR EXIT_HANDLED?
L_13:1216: ; 13:1216, 0x027216
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    INY
    INY
    RTS
L_13:121B: ; 13:121B, 0x02721B
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    JSR ENGINE_WRAM_STATE_WRITE_DISABLED
L_13:1220: ; 13:1220, 0x027220
    JMP L_13:0C88
    LDA CURRENT_SAVE_MANIPULATION_PAGE+640
    BEQ L_13:1220
    STA PTR_CREATE_SEED?
    STY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    JSR PTR_AND_BANK_R6_UNK
    JSR PTR_MOVE_TO_UNK_ARR_WRAM
    JMP L_13:1216
    JSR ENGINE_WRAM_STATE_WRITEABLE
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    STY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    JSR STREAM_UNK
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    INY
    JMP ENGINE_WRAM_STATE_WRITE_DISABLED
    JSR ENGINE_WRAM_STATE_WRITEABLE
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    PHA
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    INY
    STY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    LDY #$1F
    STA [ENGINE_FPTR_30[2]],Y
    DEY
    PLA
    STA [ENGINE_FPTR_30[2]],Y
    LDY #$00
    LDA #$07
    STA [ENGINE_FPTR_30[2]],Y
    LDY #$00
    LDA [ENGINE_FPTR_32[2]],Y
    AND #$3F
    LDY #$1D
    STA [ENGINE_FPTR_30[2]],Y
    LDY #$14
    LDA [ENGINE_FPTR_30[2]],Y
    AND #$BF
    STA [ENGINE_FPTR_30[2]],Y
    LDY #$1C
    LDA STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    STA [ENGINE_FPTR_30[2]],Y
    LDA R_**:$6795
    ASL A
    ASL A
    ASL A
    TAX
    LDA L_1F:0BF1,X
    LSR A
    LSR A
    STA R_**:$6799
    JSR ENGINE_WRAM_STATE_WRITE_DISABLED
    PLA
    PLA
    JMP PTR_EQ_0x00
    LDA MAPPER_BANK_VALS+1
    JSR L_13:129C
L_13:1295: ; 13:1295, 0x027295
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    INY
    INY
    JMP ENGINE_WRAM_STATE_WRITE_DISABLED
L_13:129C: ; 13:129C, 0x02729C
    TAX
    STY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    JSR ENGINE_WRAM_STATE_WRITEABLE
    TXA
    EOR FLAG_UNK_23
    AND #$7F
    BNE L_13:12AA
    RTS
L_13:12AA: ; 13:12AA, 0x0272AA
    STX FLAG_UNK_23
    LDY #$1C
    LDA STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    STA [ENGINE_FPTR_30[2]],Y
    JSR L_13:12C3
    ORA #$80
    STA MAIN_FLAG_UNK
    JSR ENGINE_WRAM_STATE_WRITE_DISABLED
    PLA
    PLA
    PLA
    PLA
    JMP WAIT_PRESSES_CLEAR?
L_13:12C3: ; 13:12C3, 0x0272C3
    SEC
    LDA ENGINE_FPTR_30[2]
    SBC #$80
    STA MISC_USE_A
    LDA ENGINE_FPTR_30+1
    SBC #$67
    ASL MISC_USE_A
    ROL A
    ASL MISC_USE_A
    ROL A
    ASL MISC_USE_A
    ROL A
    RTS
L_13:12D8: ; 13:12D8, 0x0272D8
    STX R_**:$6796
    STY R_**:$6797
L_13:12DE: ; 13:12DE, 0x0272DE
    STA R_**:$6780
    ASL A
    ASL A
    TAX
    LDA ROUTINE_ATTR_A,X
    STA R_**:$6788
    LDA ROUTINE_ATTR_B,X
    STA R_**:$6794
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    STA R_**:$6795
    STA R_**:$6799
    RTS
    LDA #$74
    JSR L_13:129C
    LDA #$09
    LDX #$FC
    LDY #$8A
    JSR L_13:12D8
    LDA #$0F
    STA R_**:$679A
    LDX #$10
    JSR L_1E:0DAF
    JMP L_13:1295
    JSR ENGINE_WRAM_STATE_WRITEABLE
    LDA #$F8
    STA R_**:$679A
    INY
    JMP ENGINE_WRAM_STATE_WRITE_DISABLED
    LDA #$74
    JSR L_13:129C
    LDA #$0A
    LDX #$1C
    LDY #$8B
    JSR L_13:12D8
    LDX #$08
    JSR L_1E:0DAF
    JMP L_13:1295
    LDA #$74
    JSR L_13:129C
    LDA #$0B
    LDX #$3C
    LDY #$8B
    JSR L_13:12D8
    JMP L_13:1295
    STY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    LDA #$F0
    STA FLAG_UNK_23
    LDA #$3F
    STA SCRIPT_R6_ROUTINE_SELECT
    JSR ENGINE_WRAM_STATE_WRITEABLE
    LDA #$00
    STA R_**:$67C0
    STA R_**:$67E0
    LDA #$0D
    LDY #$00
    JSR L_13:138B
    LDA #$0E
    LDY #$20
    JSR L_13:138B
    SEC
    LDA PTR_CREATE_SEED?
    SBC #$8F
    STA R_**:$679E
    LDA #$00
    STA R_**:$679F
    STA R_**:$679A
    JSR L_13:1BD4
    LDX #$10
    JSR L_1E:0DAF
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    INY
    JMP ENGINE_WRAM_STATE_WRITE_DISABLED
L_13:138B: ; 13:138B, 0x02738B
    STA R_**:$6780,Y
    ASL A
    ASL A
    TAX
    LDA #$28
    STA R_**:$6796,Y
    LDA #$8A
    STA R_**:$6797,Y
    LDA ROUTINE_ATTR_A,X
    STA R_**:$6788,Y
    LDA ROUTINE_ATTR_B,X
    STA R_**:$6794,Y
    RTS
    LDA #$F2
    JSR L_13:129C
    LDA #$0F
    JSR L_13:12DE
    JMP L_13:1295
    INY
    STY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    LDA [ENGINE_FPTR_32[2]],Y
    ORA #$80
    STA FIRST_LAUNCHER_HOLD_FLAG?
    LDX #$00
    STX FLAG_UNK_23
    JSR L_1E:0DAF
    LDA ENGINE_FPTR_30[2]
    PHA
    LDA ENGINE_FPTR_30+1
    PHA
    JSR HUGE_ASS_STREAMS_THINGY_IDFK
    PLA
    STA ENGINE_FPTR_30+1
    PLA
    STA ENGINE_FPTR_30[2]
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    INY
    RTS
    STY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    LDY #$02
    LDA [ENGINE_FPTR_32[2]],Y
    AND #$3F
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    CMP R_**:$6795
    JMP L_13:0C86
    STY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    LDY #$00
    LDA [ENGINE_FPTR_32[2]],Y
    AND #$C0
    LDY #$04
    CMP [ENGINE_FPTR_30[2]],Y
    BNE L_13:141B
    LDY #$01
    LDA [ENGINE_FPTR_32[2]],Y
    LDY #$05
    CMP [ENGINE_FPTR_30[2]],Y
    BNE L_13:141B
    LDY #$02
    LDA [ENGINE_FPTR_32[2]],Y
    AND #$C0
    LDY #$06
    CMP [ENGINE_FPTR_30[2]],Y
    BNE L_13:141B
    LDY #$03
    LDA [ENGINE_FPTR_32[2]],Y
    LDY #$07
    CMP [ENGINE_FPTR_30[2]],Y
    BNE L_13:141B
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    INY
    INY
    RTS
L_13:141B: ; 13:141B, 0x02741B
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    JMP L_13:0C88
    JSR ENGINE_WRAM_STATE_WRITEABLE
    INY
    JSR L_1F:06A1
    INY
    JMP ENGINE_WRAM_STATE_WRITE_DISABLED
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    STA SWITCH_INIT_PORTION?
    INY
    RTS
    STY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    JSR ENGINE_WRAM_STATE_WRITEABLE
    JSR SLOTS_AND_FPTRS_IDFK
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    INY
    JMP ENGINE_WRAM_STATE_WRITE_DISABLED
    JSR L_13:1032
    LDA ENGINE_FPTR_30[2]
    PHA
    LDA ENGINE_FPTR_30+1
    PHA
    LDA R_**:$0028
    JSR SUB_INDEX_HELPER_UNK
    PLA
    STA ENGINE_FPTR_30+1
    PLA
    STA ENGINE_FPTR_30[2]
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    JMP L_13:0C7E
    JSR L_13:1032
    LDA ENGINE_FPTR_30[2]
    PHA
    LDA ENGINE_FPTR_30+1
    PHA
    LDA R_**:$0028
    JSR COMAPRE_IDFK
    PLA
    STA ENGINE_FPTR_30+1
    PLA
    STA ENGINE_FPTR_30[2]
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    JMP L_13:0C7E
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    STA FLAG_UNK_48
    JSR L_13:12C3
    STA MAIN_FLAG_UNK
    INY
    STY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    PLA
    PLA
    JMP WAIT_PRESSES_CLEAR?
    STY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    JSR L_13:1C28
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    INY
    RTS
    JSR ENGINE_WRAM_STATE_WRITEABLE
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    AND #$3F
    TAX
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    STA CURRENT_SAVE_MANIPULATION_PAGE[768],X
    INY
    JMP ENGINE_WRAM_STATE_WRITE_DISABLED
    STY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    JSR SAVE_GAME_FILE
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    INY
    RTS
    STY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    JSR L_13:15C4
    LDY #$10
    LDA [MISC_USE_A],Y
    JSR LIB_IDFK_DECIMALY_AND_IDK
    JSR L_13:15C4
    LDY #$11
    SEC
    LDA SAVE_GAME_MOD_PAGE_PTR[2]
    SBC [MISC_USE_A],Y
    STA R_**:$002A
    INY
    LDA SAVE_GAME_MOD_PAGE_PTR+1
    SBC [MISC_USE_A],Y
    STA R_**:$002B
    JSR EXIT_HANDLED?
    JSR ENGINE_WRAM_STATE_WRITEABLE
    LDX #$03
L_13:14D0: ; 13:14D0, 0x0274D0
    LDA CURRENT_SAVE_MANIPULATION_PAGE+4,X
    STA CURRENT_SAVE_MANIPULATION_PAGE+12,X
    DEX
    BPL L_13:14D0
    LDA #$00
    STA CURRENT_SAVE_MANIPULATION_PAGE+21
    STA CURRENT_SAVE_MANIPULATION_PAGE+22
    STA CURRENT_SAVE_MANIPULATION_PAGE+23
    JSR ENGINE_WRAM_STATE_WRITE_DISABLED
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    INY
    RTS
    JSR ENGINE_WRAM_STATE_WRITEABLE
    LDX #$03
L_13:14F0: ; 13:14F0, 0x0274F0
    LDA CURRENT_SAVE_MANIPULATION_PAGE+12,X
    STA CURRENT_SAVE_MANIPULATION_PAGE+4,X
    DEX
    BPL L_13:14F0
    LDA #$20
    STA FIRST_LAUNCHER_HOLD_FLAG?
    LDA #$00
    STA SCRIPT_FLAG_0x22
    INY
    JMP ENGINE_WRAM_STATE_WRITE_DISABLED
    LDA CURRENT_SAVE_MANIPULATION_PAGE+21
    ORA CURRENT_SAVE_MANIPULATION_PAGE+22
    ORA CURRENT_SAVE_MANIPULATION_PAGE+23
    JMP L_13:0C82
    STY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    LDA R_**:$002A
    STA SAVE_GAME_MOD_PAGE_PTR[2]
    LDA R_**:$002B
    STA SAVE_GAME_MOD_PAGE_PTR+1
    LDX #$01
L_13:151D: ; 13:151D, 0x02751D
    JSR X_INDEX_TEST_UNK
    BCS L_13:153D
    JSR CREATE_PTR_UNK
    LDY #$01
    LDA [MISC_USE_A],Y
    BMI L_13:153D
    CLC
    LDA SAVE_GAME_MOD_PAGE_PTR[2]
    ADC R_**:$002A
    STA R_**:$002A
    LDA SAVE_GAME_MOD_PAGE_PTR+1
    ADC R_**:$002B
    STA R_**:$002B
    BCC L_13:153D
    JSR L_13:0F87
L_13:153D: ; 13:153D, 0x02753D
    INX
    CPX #$04
    BCC L_13:151D
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    INY
    RTS
    STY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    LDX #$3C
    JSR ENGINE_DELAY_X_FRAMES
    JSR ENGINE_PALETTE_FADE_OUT
    JSR ENGINE_IDK
    JSR L_13:1C0A
    LDA #$55
    STA ROUTINE_CONTINUE_FLAG?
    JSR ENGINE_PALETTE_FORWARD_TO_TARGET
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    INY
    RTS
ENGINE_IDK: ; 13:1561, 0x027561
    JSR ENGINE_WRAM_STATE_WRITEABLE ; Do with writes.
    LDX #$00 ; Count loops.
LOOP_LT: ; 13:1566, 0x027566
    LDA CURRENT_SAVE_MANIPULATION_PAGE+8,X ; Load save offset.
    BEQ SAVE_OFFSET_EQ_0x00 ; == 0, goto.
    JSR CREATE_PTR_UNK ; Create ptr.
    LDY #$01 ; Seed index.
    LDA [MISC_USE_A],Y ; Load from PTR.
    BMI SAVE_OFFSET_EQ_0x00 ; If negative, goto.
    JSR STREAM_EXPAND_0x03->0x14_0x4->0x15 ; Alt A.
    JSR STREAM_EXPAND_0x05->0x16_0x06->0x17 ; Alt B.
SAVE_OFFSET_EQ_0x00: ; 13:157A, 0x02757A
    INX ; ++
    CPX #$04 ; If _ #$04
    BCC LOOP_LT ; <, goto.
    JSR ENGINE_WRAM_STATE_WRITE_DISABLED ; Re-disable.
    LDA #$20 ; Val ??
    JMP ENGINE_COMPARES/MISMATCH_RTN_UNK ; Goto.
STREAM_EXPAND_0x03->0x14_0x4->0x15: ; 13:1587, 0x027587
    LDY #$03
    LDA [MISC_USE_A],Y
    LDY #$14
    STA [MISC_USE_A],Y
    LDY #$04
    LDA [MISC_USE_A],Y
    LDY #$15
    STA [MISC_USE_A],Y
    RTS
STREAM_EXPAND_0x05->0x16_0x06->0x17: ; 13:1598, 0x027598
    LDY #$05
    LDA [MISC_USE_A],Y
    LDY #$16
    STA [MISC_USE_A],Y
    LDY #$06
    LDA [MISC_USE_A],Y
    LDY #$17
    STA [MISC_USE_A],Y
    RTS
    JSR $B5C2
    SEC
    LDY #$14
    LDA [MISC_USE_A],Y
    LDY #$03
    SBC [MISC_USE_A],Y
    LDY #$15
    LDA [MISC_USE_A],Y
    LDY #$04
    SBC [MISC_USE_A],Y
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    JMP $AC7A
    STY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
L_13:15C4: ; 13:15C4, 0x0275C4
    LDA R_**:$0028
    JMP CREATE_PTR_UNK
    JSR $B5C2
    SEC
    LDY #$16
    LDA [MISC_USE_A],Y
    LDY #$05
    SBC [MISC_USE_A],Y
    LDY #$17
    LDA [MISC_USE_A],Y
    LDY #$06
    SBC [MISC_USE_A],Y
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    JMP $AC7A
    INY
    JSR $B5C2
    LDY #$01
    LDA [MISC_USE_A],Y
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    AND [ENGINE_FPTR_32[2]],Y
    JMP $AC86
    INY
    JSR $B5C2
    LDY #$10
    LDA [MISC_USE_A],Y
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    CMP [ENGINE_FPTR_32[2]],Y
    JMP $AC7A
    INY
    JSR $B5C2
    JSR ENGINE_WRAM_STATE_WRITEABLE
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    LDA [ENGINE_FPTR_32[2]],Y
    PHP
    LDY #$01
    PHA
    LDA [MISC_USE_A],Y
    TAX
    PLA
    AND [MISC_USE_A],Y
    STA [MISC_USE_A],Y
    PLP
    BMI 13:1623
    JSR $B587
    TXA
    BPL 13:1623
    JSR $A6F0
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    INY
    JMP ENGINE_WRAM_STATE_WRITE_DISABLED
    INY
    JSR $B5C2
    JSR ENGINE_WRAM_STATE_WRITEABLE
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    LDA [ENGINE_FPTR_32[2]],Y
    LDY #$01
    ORA [MISC_USE_A],Y
    STA [MISC_USE_A],Y
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    INY
    JMP ENGINE_WRAM_STATE_WRITE_DISABLED
    INY
    JSR $B5C2
    LDX #$16
    LDY #$05
    BNE 13:1652
    INY
    JSR $B5C2
    LDX #$14
    LDY #$03
    STX MISC_USE_C
    STY MISC_USE_D/DECIMAL_POS?
    CLC
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    LDA [ENGINE_FPTR_32[2]],Y
    LDY MISC_USE_C
    ADC [MISC_USE_A],Y
    STA SAVE_GAME_MOD_PAGE_PTR[2]
    INY
    LDA #$00
    ADC [MISC_USE_A],Y
    STA SAVE_GAME_MOD_PAGE_PTR+1
    SEC
    LDY MISC_USE_D/DECIMAL_POS?
    LDA [MISC_USE_A],Y
    SBC SAVE_GAME_MOD_PAGE_PTR[2]
    INY
    LDA [MISC_USE_A],Y
    SBC SAVE_GAME_MOD_PAGE_PTR+1
    BCS 13:1681
    LDY MISC_USE_D/DECIMAL_POS?
    LDA [MISC_USE_A],Y
    STA SAVE_GAME_MOD_PAGE_PTR[2]
    INY
    LDA [MISC_USE_A],Y
    STA SAVE_GAME_MOD_PAGE_PTR+1
    JSR ENGINE_WRAM_STATE_WRITEABLE
    LDY MISC_USE_C
    LDA SAVE_GAME_MOD_PAGE_PTR[2]
    STA [MISC_USE_A],Y
    INY
    LDA SAVE_GAME_MOD_PAGE_PTR+1
    STA [MISC_USE_A],Y
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    INY
    JMP ENGINE_WRAM_STATE_WRITE_DISABLED
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    JSR STORE_IF_MISMATCH_OTHERWISE_SOUND?
    JSR ENGINE_WRAM_STATE_WRITEABLE
    LDA CURRENT_SAVE_MANIPULATION_PAGE+4
    AND #$C0
    ORA [ENGINE_FPTR_32[2]],Y
    STA CURRENT_SAVE_MANIPULATION_PAGE+4
    INY
    JMP ENGINE_WRAM_STATE_WRITE_DISABLED
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    STA SND_CODE_HELPER_ARR
    INY
    RTS
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    STA R_**:$07F1
    INY
    RTS
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    STA R_**:$07F3
    INY
    RTS
    JSR ENGINE_WRAM_STATE_WRITEABLE
    LDA #$20
    ORA CURRENT_SAVE_MANIPULATION_PAGE+112
    STA CURRENT_SAVE_MANIPULATION_PAGE+112
    LDA #$20
    ORA CURRENT_SAVE_MANIPULATION_PAGE+176
    STA CURRENT_SAVE_MANIPULATION_PAGE+176
    INY
    JMP ENGINE_WRAM_STATE_WRITE_DISABLED
    STY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    LDA #$19
    LDX #$C1
    LDY #$A6
    JSR ENGINE_SCRIPT_LAUNCH_R7_A_PTR_XY
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    INY
    RTS
    LDA CURRENT_SAVE_MANIPULATION_PAGE+542
    CMP #$FF
    BEQ 13:16F4
    JMP $AC88
    JSR ENGINE_WRAM_STATE_WRITEABLE
    LDX #$03
    LDA $B708,X
    STA CURRENT_SAVE_MANIPULATION_PAGE+12,X
    DEX
    BPL 13:16F9
    JSR ENGINE_WRAM_STATE_WRITE_DISABLED
    INY
    INY
    RTS
    .db D2
    .db 00
    .db 80
    .db 47
    LDA #$66
    STA ROUTINE_CONTINUE_FLAG?
    STY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    LDA PACKET_HPOS_COORD?
    PHA
    LDA PACKET_YPOS_COORD?
    PHA
    JSR $B9E4
    PLA
    STA PACKET_YPOS_COORD?
    PLA
    STA PACKET_HPOS_COORD?
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    INY
    RTS
    JSR ENGINE_SETTLE_ALL_UPDATES?
    JSR ENGINE_PALETTE_FADE_SKIP_INDEX_0xE?
    INY
    RTS
    JSR $BD3B
    JSR ENGINE_PALETTE_UPLOAD_WITH_PACKET_HELPER
    INY
    RTS
    LDX #$10
    JSR SCRIPT_INVERT_X_SCROLL_SETTLE
    DEX
    BNE 13:1737
    INY
    RTS
    STY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    LDA #$19
    LDX #$CB
    LDY #$A5
    JSR ENGINE_SCRIPT_LAUNCH_R7_A_PTR_XY
    JSR $AB41
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    INY
    RTS
    STY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    LDA #$19
    LDX #$C0
    LDY #$A6
    JSR ENGINE_SCRIPT_LAUNCH_R7_A_PTR_XY
    JSR $AB41
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    INY
    RTS
L_13:1763: ; 13:1763, 0x027763
    LDX #$02
    LDY #$19
    STX PACKET_HPOS_COORD?
    STY PACKET_YPOS_COORD?
    LDX #$02
    LDA R_**:$6704,X
    BEQ 13:177E
    LDA #$A0
    JSR ENGINE_A_TO_UPDATE_PACKET
    DEC PACKET_YPOS_COORD?
    DEC PACKET_YPOS_COORD?
    DEX
    BPL 13:176D
    DEC PACKET_HPOS_COORD?
    SEC
    LDA PACKET_YPOS_COORD?
    SBC #$04
    STA PACKET_YPOS_COORD?
    JSR PTR_SEEDED_UNK_C
    JSR $AB41
    LDA #$AC
    LDX #$B7
    STA FPTR_SPRITES?[2]
    STX FPTR_SPRITES?+1
    JSR ENGINE_MENU_HELPER_BEGIN?
    BIT MENU_HELPER_STATUS?
    BMI 13:179E
    SEC
    RTS
    LDA #$FF
    JSR ENGINE_POS_TO_UPDATE_UNK
    LDX FPTR_UNK_84_MENU_SELECTION?[2]
    LDA R_**:$6704,X
    STA R_**:$0028
    CLC
    RTS
    .db 01
    .db 03
    .db 00
    .db 02
    .db C0
    .db 3A
    .db 02
    .db 15
    .db 04
    .db 67
L_13:17B6: ; 13:17B6, 0x0277B6
    JSR PTR_SEEDED_UNK_A
    LDX #$FF
    INX
    CPX #$03
    BCC 13:17C2
    LDX #$00
    JSR X_INDEX_TEST_UNK
    BCS 13:17BB
    STA R_**:$0028
    STX SLOT/DATA_OFFSET_USE?
    JSR $BB21
    JSR $B803
    JSR $BB40
    JSR $BAF9
    LDX SLOT/DATA_OFFSET_USE?
    LDA #$06
    BIT MENU_HELPER_STATUS?
    BVS 13:17F4
    BMI 13:17BB
    BEQ 13:17BB
    JSR $B803
    JSR $BB0E
    BIT MENU_HELPER_STATUS?
    BVS 13:17F4
    BMI 13:17F6
    LDX SLOT/DATA_OFFSET_USE?
    JMP $B7C2
    SEC
    RTS
    LDA #$FF
    JSR ENGINE_POS_TO_UPDATE_UNK
    LDY FPTR_UNK_84_MENU_SELECTION?[2]
    LDA [FPTR_UNK_84_MENU?[2]],Y
    STA PTR_CREATE_SEED?
    CLC
    RTS
    JSR $B5C4
    CLC
    LDA MISC_USE_A
    ADC #$20
    STA FPTR_UNK_84_MENU?[2]
    LDA MISC_USE_B
    ADC #$00
    STA FPTR_UNK_84_MENU?+1
    RTS
L_13:1814: ; 13:1814, 0x027814
    JSR PTR_SEEDED_UNK_B
    JSR $AB41
    SEC
    LDA STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    ADC ENGINE_FPTR_32[2]
    STA FPTR_UNK_84_MENU?[2]
    LDA #$00
    ADC ENGINE_FPTR_32+1
    STA FPTR_UNK_84_MENU?+1
    LDY #$03
    STY PACKET_YPOS_COORD?
    LDY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    INY
    STY STREAM_INDEX_FILE_UNK_SCRIPT/COMMANDS_TEXT?
    LDA [ENGINE_FPTR_32[2]],Y
    STA PTR_CREATE_SEED?
    BEQ 13:1853
    LDA #$0C
    STA R_**:$0070
    LDX #$03
    STX PACKET_HPOS_COORD?
    JSR $BBAF
    JSR $BBC3
    LDA #$00
    STA R_**:$0070
    LDX #$0F
    STX PACKET_HPOS_COORD?
    LDA #$6F
    LDX #$B8
    JSR $AC44
    LDY PACKET_YPOS_COORD?
    INY
    INY
    CPY #$0B
    BCC 13:1829
    LDA #$77
    LDX #$B8
    STA FPTR_SPRITES?[2]
    STX FPTR_SPRITES?+1
    JSR 1F:0F3F
    BIT MENU_HELPER_STATUS?
    BMI 13:186C
    SEC
    RTS
    .db 4C
    .db F6
    .db B7
    .db A4
    .db 23
    .db 2A
    .db 00
    .db 02
    .db 04
    .db BA
    .db 00
    .db 01
    .db 04
    .db 00
    .db 02
    .db C0
    .db 3A
    .db 02
    .db 03
L_13:187F: ; 13:187F, 0x02787F
    JSR PTR_SEEDED_UNK_A
    LDA #$D8
    LDX #$B8
    JSR $AC44
    LDX #$F8
    CLC
    TXA
    ADC #$08
    TAX
    CPX #$50
    BCC 13:1896
    LDX #$00
    LDA CURRENT_SAVE_MANIPULATION_PAGE+688,X
    BNE 13:189D
    LDX #$00
    STX SLOT/DATA_OFFSET_USE?
    JSR $B8CA
    JSR $BB40
    JSR $BAF9
    LDX SLOT/DATA_OFFSET_USE?
    LDA #$06
    BIT MENU_HELPER_STATUS?
    BVS 13:18C5
    BMI 13:188B
    BEQ 13:188B
    JSR $B8CA
    JSR $BB0E
    BIT MENU_HELPER_STATUS?
    BVS 13:18C5
    BMI 13:18C7
    LDX SLOT/DATA_OFFSET_USE?
    JMP $B896
    SEC
    RTS
    JMP $B7F6
    CLC
    LDA SLOT/DATA_OFFSET_USE?
    ADC #$B0
    STA FPTR_UNK_84_MENU?[2]
    LDA #$00
    ADC #$76
    STA FPTR_UNK_84_MENU?+1
    RTS
    JSR **:$0309
    ???
    INX
    SBC SCRIPT_UNK_DATA_SELECT_??
    ???
    CPX 1F:13EF
    SBC MAPPER_BANK_VALS+4
    BRK
    JSR PTR_SEEDED_UNK_A
    LDX #$FF
    INX
    CPX #$03
    BCC 13:18F2
    LDX #$00
    LDA CURRENT_SAVE_MANIPULATION_PAGE+8,X
    BEQ 13:18EB
    CMP #$03
    BCS 13:18EB
    STA R_**:$0028
    STX SLOT/DATA_OFFSET_USE?
    JSR $BB21
    JSR $B935
    JSR $BB40
    JSR $BAF9
    LDX SLOT/DATA_OFFSET_USE?
    LDA #$06
    BIT MENU_HELPER_STATUS?
    BVS 13:1930
    BMI 13:18EB
    BEQ 13:18EB
    JSR $B935
    LDY #$01
    LDA [MISC_USE_A],Y
    AND #$F0
    BNE 13:192B
    JSR $BB0E
    BIT MENU_HELPER_STATUS?
    BVS 13:1930
    BMI 13:1932
    LDX SLOT/DATA_OFFSET_USE?
    JMP $B8F2
    SEC
    RTS
    JMP $B7F6
    JSR $B5C4
    CLC
    LDA MISC_USE_A
    ADC #$30
    STA FPTR_UNK_84_MENU?[2]
    LDA MISC_USE_B
    ADC #$00
    STA FPTR_UNK_84_MENU?+1
    LDX #$00
    LDY #$00
    STX SAVE_GAME_MOD_PAGE_PTR[2]
    STY SAVE_GAME_MOD_PAGE_PTR+1
    LDA SAVE_GAME_MOD_PAGE_PTR+1
    AND #$07
    TAX
    LDA SAVE_GAME_MOD_PAGE_PTR+1
    LSR A
    LSR A
    LSR A
    TAY
    LDA [FPTR_UNK_84_MENU?[2]],Y
    AND LUT_INDEX_TO_BITS_0x80-0x01,X
    LDX SAVE_GAME_MOD_PAGE_PTR[2]
    AND $B98B,Y
    BEQ 13:1971
    CLC
    LDA SAVE_GAME_MOD_PAGE_PTR+1
    ADC #$C0
    STA CHARACTER_NAMES_ARR[8],X
    INX
    CPX #$08
    BCS 13:1982
    LDY SAVE_GAME_MOD_PAGE_PTR+1
    INY
    CPY #$20
    BCC 13:1949
    LDA #$00
    STA CHARACTER_NAMES_ARR[8],X
    INX
    CPX #$08
    BCC 13:197A
    LDA #$80
    LDX #$05
    STA FPTR_UNK_84_MENU?[2]
    STX FPTR_UNK_84_MENU?+1
    RTS
    RTS
    CPX #$A8
    BRK
    JSR PTR_SEEDED_UNK_A
    LDA #$D1
    LDX #$B9
    JSR $AC44
    JSR $B9AF
    JSR $BB40
    LDA #$DC
    LDX #$B9
    JSR $BB12
    BIT MENU_HELPER_STATUS?
    BMI 13:19AC
    SEC
    RTS
    JMP $B7F6
    LDA CURRENT_SAVE_MANIPULATION_PAGE+541
    STA SAVE_GAME_MOD_PAGE_PTR+1
    LDX #$00
    LDA #$00
    ASL SAVE_GAME_MOD_PAGE_PTR+1
    BCC 13:19C0
    CLC
    TXA
    ADC #$80
    STA CHARACTER_NAMES_ARR[8],X
    INX
    CPX #$08
    BCC 13:19B6
    LDA #$80
    LDX #$05
    STA FPTR_UNK_84_MENU?[2]
    STX FPTR_UNK_84_MENU?+1
    RTS
    .db 20
    .db 07
    .db 03
    .db FE
    .db D7
    .db E8
    .db E5
    .db F2
    .db E5
    .db A2
    .db 00
    .db 02
    .db 04
    .db 0C
    .db 02
    .db C0
    .db 3A
    .db 06
    .db 05
    JSR PTR_SEEDED_UNK_E
    LDA #$B6
    LDX #$BA
    JSR $AC44
    JSR ENGINE_CREATE_UPDATE_BUF_INIT_INC?
    LDX #$00
    JSR $BA72
    JSR $BA72
    JSR ENGINE_WRAM_STATE_WRITEABLE
    LDA #$00
    STA CURRENT_SAVE_MANIPULATION_PAGE+49
    STA SLOT/DATA_OFFSET_USE?
    LDY #$10
    LDA #$A2
    STA CURRENT_SAVE_MANIPULATION_PAGE+32,Y
    DEY
    BPL 13:1A07
    STA R_**:$00D6
    JSR $BA8D
    JSR ENGINE_MENU_HELPER_BEGIN?
    JMP $BA1E
    JSR $BA8D
    JSR SETTLE_AND_SPRITES_TO_COORD?_IDFK
    BIT MENU_HELPER_STATUS?
    BMI 13:1A39
    BVC 13:1A54
    LDY SLOT/DATA_OFFSET_USE?
    BEQ 13:1A18
    LDA CURRENT_SAVE_MANIPULATION_PAGE+32,Y
    CMP #$A2
    BNE 13:1A30
    DEY
    LDA #$A2
    STY SLOT/DATA_OFFSET_USE?
    STA CURRENT_SAVE_MANIPULATION_PAGE+32,Y
    BNE 13:1A18
    LDY FPTR_UNK_84_MENU_SELECTION?[2]
    CPY #$10
    BEQ 13:1A24
    CPY #$26
    BEQ 13:1A54
    LDA CHARACTER_NAMES_ARR[8],Y
    LDY SLOT/DATA_OFFSET_USE?
    STA CURRENT_SAVE_MANIPULATION_PAGE+32,Y
    CPY #$10
    BCS 13:1A18
    INY
    STY SLOT/DATA_OFFSET_USE?
    BNE 13:1A18
    LDY SLOT/DATA_OFFSET_USE?
    BEQ 13:1A18
    LDA CURRENT_SAVE_MANIPULATION_PAGE+32,Y
    CMP #$A2
    BEQ 13:1A60
    INY
    LDA #$00
    STA CURRENT_SAVE_MANIPULATION_PAGE+32,Y
    STA R_**:$00D6
    LDA #$F0
    STA SPRITE_PAGE+4
    JSR ENGINE_WRAM_STATE_WRITE_DISABLED
    JMP $AB41
    LDY #$11
    LDA $BAB9,X
    STA CHARACTER_NAMES_ARR[8],X
    INX
    DEY
    BNE 13:1A74
    LDA #$00
    STA **:$057E,X
    LDY #$05
    STA CHARACTER_NAMES_ARR[8],X
    INX
    DEY
    BNE 13:1A85
    RTS
    LDA #$E5
    LDX #$BA
    JSR $AC44
    LDA #$32
    STA SPRITE_PAGE+4
    LDA #$01
    STA SPRITE_PAGE+5
    LDA #$00
    STA SPRITE_PAGE+6
    LDA SLOT/DATA_OFFSET_USE?
    ASL A
    ASL A
    ASL A
    ADC #$48
    STA SPRITE_PAGE+7
    LDA #$EF
    LDX #$BA
    STA FPTR_SPRITES?[2]
    STX FPTR_SPRITES?+1
    RTS
    .db 20
    .db 08
    .db 09
    .db C1
    .db C2
    .db C3
    .db C4
    .db C5
    .db C6
    .db C7
    .db A0
    .db C8
    .db C9
    .db CA
    .db CB
    .db CC
    .db CD
    .db CE
    .db A0
    .db C0
    .db C2
    .db E1
    .db E3
    .db EB
    .db 01
    .db CF
    .db D0
    .db D1
    .db D2
    .db D3
    .db D4
    .db D5
    .db A0
    .db D6
    .db D7
    .db D8
    .db D9
    .db DA
    .db AE
    .db A7
    .db A0
    .db C0
    .db C5
    .db EE
    .db E4
    .db A0
    .db 00
    .db 20
    .db 09
    .db 05
    .db 21
    .db 20
    .db 74
    .db 20
    .db 08
    .db 09
    .db 00
    .db 16
    .db 02
    .db 01
    .db 02
    .db D0
    .db 01
    .db 08
    .db 09
    .db 80
    .db 05
    LDA #$04
    LDX #$BB
    STA FPTR_SPRITES?[2]
    STX FPTR_SPRITES?+1
    JMP ENGINE_MENU_HELPER_BEGIN?
    .db 01
    .db 01
    .db 00
    .db 00
    .db C5
    .db 3A
    .db 07
    .db 03
    .db D1
    .db F0
    .db A9
    .db 19
    .db A2
    .db BB
    .db 85
    .db 80
    .db 86
    .db 81
    .db 4C
    .db 3F
    .db EF
    .db 02
    .db 04
    .db 0C
    .db 02
    .db C8
    .db 3A
    .db 06
    .db 05
    JSR CREATE_PTR_UNK
    CLC
    LDA MISC_USE_A
    ADC #$38
    STA FPTR_PACKET_CREATION[2]
    LDA MISC_USE_B
    ADC #$00
    STA FPTR_PACKET_CREATION+1
    LDA #$07
    LDX #$09
    LDY #$03
    STA R_**:$0070
    STX PACKET_HPOS_COORD?
    STY PACKET_YPOS_COORD?
    JMP ENGINE_CREATE_UPDATE_BUF_INIT_INC?
    LDA #$0B
    LDX #$07
    LDY #$05
    STA R_**:$0070
    STY PACKET_YPOS_COORD?
    LDY #$00
    STX PACKET_HPOS_COORD?
    STY FPTR_UNK_84_MENU_SELECTION?[2]
    LDA [FPTR_UNK_84_MENU?[2]],Y
    STA PTR_CREATE_SEED?
    JSR $BBAF
    LDX #$13
    CPX PACKET_HPOS_COORD?
    BNE 13:1B63
    INC PACKET_YPOS_COORD?
    INC PACKET_YPOS_COORD?
    LDX #$07
    LDY FPTR_UNK_84_MENU_SELECTION?[2]
    INY
    CPY #$08
    BCC 13:1B4C
    LDA #$00
    STA R_**:$0070
    RTS
L_13:1B6F: ; 13:1B6F, 0x027B6F
    JSR $B5C4
    JSR ENGINE_WRAM_STATE_WRITEABLE
    LDA #$04
    STA **:$6D00
    CLC
    LDA MISC_USE_A
    ADC #$38
    STA **:$6D01
    LDA MISC_USE_B
    ADC #$00
    STA **:$6D02
    JMP ENGINE_WRAM_STATE_WRITE_DISABLED
PTR_MOVE_TO_UNK_ARR_WRAM: ; 13:1B8C, 0x027B8C
    JSR SUB_PTR_OFFSET_AND_BASE_9800 ; Get ptr.
    LDY #$00 ; Stream index.
    LDA [MISC_USE_A],Y ; Load from stream.
    STA SAVE_GAME_MOD_PAGE_PTR[2] ; Move ptr.
    INY ; Stream index.
    LDA [MISC_USE_A],Y
    STA SAVE_GAME_MOD_PAGE_PTR+1
    JSR ENGINE_WRAM_STATE_WRITEABLE ; Do WRAM writable.
    LDY #$00 ; Stream index reset.
A_NONZERO: ; 13:1B9F, 0x027B9F
    LDA [SAVE_GAME_MOD_PAGE_PTR[2]],Y ; Load from stream.
    STA **:$6D04,Y ; Store to ??
    INY ; Stream++
    CMP #$00 ; If A _ #$00
    BNE A_NONZERO ; != 0, goto. EOF.
    JSR ENGINE_WRAM_STATE_WRITE_DISABLED ; Do disabled.
    JMP EXIT_HANDLED? ; Exit.
    JSR SUB_PTR_OFFSET_AND_BASE_9800
    LDY #$00
    LDA [MISC_USE_A],Y
    STA FPTR_PACKET_CREATION[2]
    INY
    LDA [MISC_USE_A],Y
    STA FPTR_PACKET_CREATION+1
    JSR ENGINE_CREATE_UPDATE_BUF_INIT_INC?
    JMP EXIT_HANDLED?
PTR_AND_BANK_R6_UNK: ; 13:1BC3, 0x027BC3
    JSR SUB_PTR_OFFSET_AND_BASE_9800 ; Do ptr.
    LDY #$06 ; Stream index.
    LDA [MISC_USE_A],Y ; Move ptr? ??
    STA R_**:$002A
    INY
    LDA [MISC_USE_A],Y
    STA R_**:$002B
    JMP EXIT_HANDLED? ; Exit.
L_13:1BD4: ; 13:1BD4, 0x027BD4
    JSR SUB_PTR_OFFSET_AND_BASE_9800
    LDY #$02
    JSR 1F:06A9
    JMP EXIT_HANDLED?
SUB_PTR_OFFSET_AND_BASE_9800: ; 13:1BDF, 0x027BDF
    JSR SUB_PTRER_UGH
    CLC ; Prep add.
    LDA MISC_USE_A ; Base at $9800
    ADC #$00
    STA MISC_USE_A
    LDA MISC_USE_B
    ADC #$98
    STA MISC_USE_B
    RTS ; Leave.
SUB_PTRER_UGH: ; 13:1BF0, 0x027BF0
    LDA PTR_CREATE_SEED? ; Make ptr ??
    STA MISC_USE_A
    LDA #$00
    ASL MISC_USE_A
    ROL A
    ASL MISC_USE_A
    ROL A
    ASL MISC_USE_A
    ROL A
    STA MISC_USE_B
    JMP ENGINE_R6_TO_BANK_0x00_THING_1 ; Do R6, leave.
    JSR WAIT_ANY_BUTTONS_PRESSED_RET_PRESSED
    JMP PTR_SEEDED_UNK_F_WRAM
L_13:1C0A: ; 13:1C0A, 0x027C0A
    LDA FPTR_PACKET_CREATION[2]
    PHA
    LDA ARG_IDFK
    PHA
    JSR 1E:03A0
    PLA
    STA ARG_IDFK
    PLA
    STA FPTR_PACKET_CREATION[2]
    LDA #$00
    STA R_**:$002D
    LDX #$08
    LDY #$13
    STX PACKET_HPOS_COORD?
    STY PACKET_YPOS_COORD?
    JMP $AB41
L_13:1C28: ; 13:1C28, 0x027C28
    LDA PACKET_HPOS_COORD?
    PHA
    LDA PACKET_YPOS_COORD?
    PHA
    JSR PTR_SEEDED_UNK_H
    PLA
    STA PACKET_YPOS_COORD?
    PLA
    STA PACKET_HPOS_COORD?
    JMP $AB41
    LDA MISC_USE_C
    AND #$3F
    STA ARR_BITS_TO_UNK+3
    LDA MISC_USE_C
    AND #$C0
    ASL A
    ROL A
    ROL A
    ADC #$28
    STA MISC_USE_C
    LDA PTR_CREATE_SEED?
    JSR $B058
    BCS 13:1C59
    TYA
    ADC #$20
    STA ARR_BITS_TO_UNK+2
    BCC 13:1C5E
    RTS
L_13:1C5A: ; 13:1C5A, 0x027C5A
    LDA #$00
    STA ARR_BITS_TO_UNK+3
    JSR $B5C4
    LDA MISC_USE_A
    LDX MISC_USE_B
    STA ARR_BITS_TO_UNK[8]
    STX ARR_BITS_TO_UNK+1
    LDY MISC_USE_C
    LDA [ARR_BITS_TO_UNK[8]],Y
    JSR $BBF2
    JSR $BBE2
    LDY #$03
    LDA [MISC_USE_A],Y
    AND #$3F
    STA MISC_USE_D/DECIMAL_POS?
    JSR ENGINE_WRAM_STATE_WRITEABLE
    LDX MISC_USE_C
    LDA $BCC0,X
    BMI 13:1CA6
    TAY
    SEC
    LDA [ARR_BITS_TO_UNK[8]],Y
    SBC MISC_USE_D/DECIMAL_POS?
    STA [ARR_BITS_TO_UNK[8]],Y
    INY
    LDA [ARR_BITS_TO_UNK[8]],Y
    SBC #$00
    STA [ARR_BITS_TO_UNK[8]],Y
    DEY
    CLC
    LDA [ARR_BITS_TO_UNK[8]],Y
    ADC ARR_BITS_TO_UNK+3
    STA [ARR_BITS_TO_UNK[8]],Y
    INY
    LDA [ARR_BITS_TO_UNK[8]],Y
    ADC #$00
    STA [ARR_BITS_TO_UNK[8]],Y
    JMP $BCB8
    LDY #$02
    LDA MISC_USE_D/DECIMAL_POS?
    ASL A
    EOR #$FF
    AND [ARR_BITS_TO_UNK[8]],Y
    STA [ARR_BITS_TO_UNK[8]],Y
    LDA ARR_BITS_TO_UNK+3
    ASL A
    ORA [ARR_BITS_TO_UNK[8]],Y
    STA [ARR_BITS_TO_UNK[8]],Y
    LDA ARR_BITS_TO_UNK+3
    BEQ 13:1CE0
    LDY ARR_BITS_TO_UNK+2
    LDA [ARR_BITS_TO_UNK[8]],Y
    TAX
    LDY MISC_USE_C
    LDA [ARR_BITS_TO_UNK[8]],Y
    BNE 13:1CDB
    LDY ARR_BITS_TO_UNK+2
    BNE 13:1CD1
    LDA [ARR_BITS_TO_UNK[8]],Y
    DEY
    STA [ARR_BITS_TO_UNK[8]],Y
    INY
    INY
    CPY #$28
    BCC 13:1CCB
    DEY
    LDA #$00
    BEQ 13:1CDD
    LDY ARR_BITS_TO_UNK+2
    STA [ARR_BITS_TO_UNK[8]],Y
    TXA
    LDY MISC_USE_C
    STA [ARR_BITS_TO_UNK[8]],Y
    CLC
    JMP ENGINE_WRAM_STATE_WRITE_DISABLED
    .db 07
    .db 09
    .db 09
    .db FF
ROUTINE_LAUNCHER_0xE: ; 13:1CEC, 0x027CEC
    LDA SWITCH_INIT_PORTION? ; Load.
    ASL A ; *2.
    TAX ; To X.
    LDA #$00
    STA SWITCH_INIT_PORTION? ; Clear, not again.
    LDA RTN_TABLE_H,X ; Move routine.
    PHA
    LDA RTN_TABLE_L,X
    PHA
    RTS ; Run it.
RTN_TABLE_L: ; 13:1CFD, 0x027CFD
    LOW(1F:0DDB) ; Rtn 0x00
RTN_TABLE_H: ; 13:1CFE, 0x027CFE
    HIGH(1F:0DDB) ; Palette fade out.
    LOW(13:1D0C) ; Rtn 0x01
    HIGH(13:1D0C) ; Palette fade out with flag unk.
    LOW(13:1D14) ; Rtn 0x02
    HIGH(13:1D14) ; Game stuff, can lock up script.
    LOW(13:1D30) ; Rtn 0x03
    HIGH(13:1D30) ; Palette color thingy.
    LOW(13:1D5B) ; Rtn 0x04
    HIGH(13:1D5B) ; Long.
    LOW(13:1DD8) ; Rtn 0x05
    HIGH(13:1DD8) ; A bit.
    LOW(13:1D33) ; Rtn 0x06
    HIGH(13:1D33) ; Palette colors and ??
    LOW(13:1E0E) ; Rtn 0x07
    HIGH(13:1E0E) ; FF val to CMP, idk.
PALETTE_FADE_WITH_??: ; 13:1D0D, 0x027D0D
    LDA #$08 ; Set ??
    STA SND_CODE_HELPER_ARR
    JMP ENGINE_PALETTE_FADE_OUT
    LDA #$10
    STA R_**:$07F1 ; Set ??
    LDA #$34 ; Palette data.
    JSR PALETTE_TO_COLOR_A_AND_FORWARDED ; Do.
    LDA COPY_PROTECTION_VAL
    BEQ VAL_EQ_0x00 ; == 0, goto. Is okay.
    LDA #$19 ; Launch 19:01F7, mwahah.
    LDX #$F7
    LDY #$A1
    JSR ENGINE_SCRIPT_LAUNCH_R7_A_PTR_XY ; Launch it.
VAL_EQ_0x00: ; 13:1D2C, 0x027D2C
    LDX #$3C
    JMP ENGINE_DELAY_X_FRAMES ; Engine delay, leave.
    JSR SCRIPT_PALETTE_COLOR ; Do ??
SCRIPT_SET_??_PALETTE_FADE_OUT: ; 13:1D34, 0x027D34
    LDA #$20
    STA FIRST_LAUNCHER_HOLD_FLAG? ; Set ??
    JMP ENGINE_PALETTE_FADE_OUT ; Palette fade out.
SCRIPT_PALETTE_COLOR: ; 13:1D3B, 0x027D3B
    JSR ENGINE_PALETTE_SCRIPT_TO_TARGET ; To target.
    LDA #$02
    STA SND_CODE_HELPER_ARR ; Set ??
    LDA #$14 ; Seed.
LOOP_COUNT: ; 13:1D45, 0x027D45
    PHA ; Save todo count.
    LDA #$34
    JSR ENGINE_COLOR_TO_A_PASSED ; Color write.
    LDA #$38
    JSR ENGINE_COLOR_TO_A_PASSED
    LDA #$30
    JSR ENGINE_COLOR_TO_A_PASSED
    PLA ; Pull count.
    SEC ; Prep sub.
    SBC #$01 ; Sub with.
    BNE LOOP_COUNT ; != 0, loop.
    RTS
    LDA #$09
    STA SND_CODE_HELPER_ARR ; Set ??
    LDA #$11
    JSR PALETTE_TO_COLOR_A_AND_FORWARDED ; Palette to color.
    JSR SETTLE_SPRITES_OFFSCREEN/CLEAR_RAM ; No sprites.
    JSR ENGINE_SETTLE_EXTENDED_0x2000_SCREEN ; Do.
    LDA #$5D
    LDX #$02 ; Set GFX.
    JSR ENGINE_SET_MAPPER_BANK_X_VAL_A
    JSR PPU_READ_INTO_$0110_HELPER_LOOP_UNK ; Load.
    LDA #$5C
    LDX #$02 ; Set GFX.
    JSR ENGINE_SET_MAPPER_BANK_X_VAL_A
    LDA #$1F
    LDX #$BE ; Set PTR $BE1F, 13:
    STA MISC_USE_A
    STX MISC_USE_B
    JSR ARR_MAKE_UNK ; Do ??
    LDA #$2F
    LDX #$BE ; Set PTR, $BE2F, 13:
    JSR ENGINE_SETTLE_AND_PALETTE_FROM_PTR ; Set ??
    LDY #$16 ; Loop count.
COUNT_NONZERO: ; 13:1D91, 0x027D91
    TYA ; To A.
    PHA ; Save it.
    LDX #$08 ; Index.
INDEX_LT_0x28: ; 13:1D95, 0x027D95
    JSR ENGINE_SETTLE_ALL_UPDATES?
    LDA #$01
    STA R_**:$0305,X ; Set ??
    LDA R_**:$0303,X ; Load.
    AND #$1F ; Keep lower.
    BNE LOWER_NONZERO ; != 0, goto.
    LDA #$E8
    LDY #$FF ; Seed ??
    BNE PTR_SUB_0x18 ; Always taken, goto.
LOWER_NONZERO: ; 13:1DAA, 0x027DAA
    LDA #$08 ; Val add.
    LDY #$00
PTR_SUB_0x18: ; 13:1DAE, 0x027DAE
    CLC ; Prep add.
    ADC OBJ_UNK_A,X ; Add A to.
    STA OBJ_UNK_A,X ; Store result.
    TYA ; Y val to A.
    ADC OBJ_UNK_A_PAIR,X ; Add A to.
    STA OBJ_UNK_A_PAIR,X ; Store carry result.
    CLC ; Prep add.
    TXA ; Index to A.
    ADC #$08 ; Index mod, goto.
    TAX ; Val to X.
    CPX #$28 ; If _ #$28
    BCC INDEX_LT_0x28 ; <, goto.
    LDA #$08
    STA NMI_FLAG_B ; Set flag ??
    PLA ; Pull A.
    TAY ; To Y.
    DEY ; --
    BNE COUNT_NONZERO ; != 0, goto.
    JSR SETTLE_SPRITES_OFFSCREEN/CLEAR_RAM ; Do.
    JSR ENGINE_PALETTE_FADE_OUT ; Fade out.
    LDX #$5A
    JMP ENGINE_DELAY_X_FRAMES ; Abuse RTS.
    LDA #$11 ; Seed color.
    JSR ENGINE_BG_COLOR_A
    LDA #$03
    STA SND_CODE_HELPER_ARR ; Set ??
    JSR ENGINE_0x300_OBJECTS_UNK? ; Do ??
    LDX #$08 ; Index.
    LDY #$07 ; Data index/loop.
DATA_POSITIVE: ; 13:1DEA, 0x027DEA
    LDA ROM_DATA_LUT_UNK,Y ; Move data.
    STA R_**:$0305,X
    DEY ; Data--
    LDA ROM_DATA_LUT_UNK,Y ; Move data.
    STA R_**:$0304,X
    CLC ; Prep add.
    TXA ; Index to A.
    ADC #$08 ; Add to X index.
    TAX ; Back to X.
    DEY ; Data--
    BPL DATA_POSITIVE ; Positive, loop.
    JSR ENGINE_HELPER_R6_0x14
    JSR ENGINE_MAKE_UPDATE_UNK ; Do ??
    LDA #$11
    JSR ENGINE_ALL_COLOR_TO_A ; Do.
    LDX #$5A
    JMP ENGINE_DELAY_X_FRAMES ; Delay, abuse RTS.
    JSR SCRIPT_SET_??_PALETTE_FADE_OUT ; Do.
    LDA #$FF
    JSR STORE_IF_MISMATCH_OTHERWISE_SOUND? ; Do.
    LDX #$5A
    JSR ENGINE_DELAY_X_FRAMES ; Delay frames.
    JMP ENGINE_IDK ; Goto.
    RTS
    .db E0
    .db 40
    .db 18
    .db 68
    .db C8
    .db 40
    .db 00
    .db 58
    .db B0
    .db 40
    .db 08
    .db 60
    .db 98
    .db 40
    .db 10
    .db 0F
    .db 22
    .db 20
    .db 11
    .db 0F
    .db 10
    .db 1A
    .db 11
    .db 0F
    .db 30
    .db 00
    .db 11
    .db 0F
    .db 00
    .db 10
    .db 30
    .db 0F
    .db 0F
    .db 01
    .db 31
    .db 0F
    .db 0F
    .db 13
    .db 32
    .db 0F
    .db 0F
    .db 22
    .db 32
    .db 0F
    .db 0F
    .db 11
    .db 32
ROM_DATA_LUT_UNK: ; 13:1E4F, 0x027E4F
    .db FE
    .db FF
    .db 02
    .db FF
    .db FF
    .db FE
    .db 01
    .db FE
SAVE_GAME_FILE: ; 13:1E57, 0x027E57
    LDA SAVE_SLOT_DATA_UNK_A ; Load stored.
    JSR SAVEGAME_INIT_FPTRS ; Make ptrs.
    JSR SAVEGAME_LOADED_CHECKSUM ; Do checksum.
    JSR ENGINE_WRAM_STATE_WRITEABLE ; Enable.
    SEC ; Prep sub.
    LDY #$00 ; Reset stream.
    LDA [SAVE_GAME_MOD_PAGE_PTR[2]],Y ; Load 0x7400
    SBC MISC_USE_A ; Sub with.
    STA [SAVE_GAME_MOD_PAGE_PTR[2]],Y ; Store back to.
    INY ; Stream++
    LDA [SAVE_GAME_MOD_PAGE_PTR[2]],Y ; 2x
    SBC MISC_USE_B ; Sub with.
    STA [SAVE_GAME_MOD_PAGE_PTR[2]],Y ; Store back to.
    LDX #$03 ; Pages loop count.
LOOP_NEXT_PAGE: ; 13:1E75, 0x027E75
    LDY #$00 ; Seed stream index.
STREAM_NONZERO: ; 13:1E77, 0x027E77
    LDA [SAVE_GAME_MOD_PAGE_PTR[2]],Y ; Load from mod page.
    STA [ARR_BITS_TO_UNK[8]],Y ; Store to slot.
    INY ; Stream++
    BNE STREAM_NONZERO ; != 0, goto.
    INC SAVE_GAME_MOD_PAGE_PTR+1 ; Inc PTR H.
    INC ARR_BITS_TO_UNK+1
    DEX ; Loops--
    BNE LOOP_NEXT_PAGE ; != 0, goto.
    JMP ENGINE_WRAM_STATE_WRITE_DISABLED ; Leave, no writes.
SAVEGAME_LOAD_AND_CHECKSUM[A]: ; 13:1E88, 0x027E88
    JSR SAVEGAME_INIT_FPTRS ; Set up ptrs.
    JSR ENGINE_WRAM_STATE_WRITEABLE ; Enable WRAM writes.
    LDX #$03 ; Loop count.
LOOP_ALL_PAGES: ; 13:1E90, 0x027E90
    LDY #$00 ; Stream index.
LOOP_STREAM_PAGE: ; 13:1E92, 0x027E92
    LDA [ARR_BITS_TO_UNK[8]],Y ; Load from file.
    STA [SAVE_GAME_MOD_PAGE_PTR[2]],Y ; Store to mod page.
    INY ; Stream++
    BNE LOOP_STREAM_PAGE ; != 0, loop.
    INC ARR_BITS_TO_UNK+1 ; Inc PTR H.
    INC SAVE_GAME_MOD_PAGE_PTR+1
    DEX ; X--
    BNE LOOP_ALL_PAGES ; != 0, goto.
    JSR ENGINE_WRAM_STATE_WRITE_DISABLED ; No more WRAM writes.
    JSR SAVEGAME_LOADED_CHECKSUM ; Check check it, yeah.
    LDA SAVE_SLOT_DATA_UNK_A ; Load save slot data.
    AND #$F0 ; Keep upper.
    CMP #$B0 ; If _ #$B0
    BNE EXIT_FAIL_DIRECT ; !=, goto. TODO: Carry matters?
    LDA SAVE_SLOT_DATA_UNK_B ; Load other.
    CMP #$E9 ; If _ #$E9
    BNE EXIT_FAIL_DIRECT ; !=, goto.
    LDA MISC_USE_A ; Load slot value added up.
    ORA MISC_USE_B ; Combine with other bits. == 0, pass exit. Else, failed.
EXIT_FAIL_DIRECT: ; 13:1EBA, 0x027EBA
    RTS
SAVEGAME_INIT_FPTRS: ; 13:1EBB, 0x027EBB
    AND #$07 ; Keep lower bits, index.
    STA ARR_BITS_TO_UNK+1 ; Store to.
    ASL A ; << 1, *2. CC now.
    ADC ARR_BITS_TO_UNK+1 ; Add with, *3. Slot size.
    ADC #$77 ; Addr + 0x7700, base of saved files.
    STA ARR_BITS_TO_UNK+1 ; Store ptr H, 0x77/0x7A/0x7D.
    LDA #$00
    STA ARR_BITS_TO_UNK[8] ; Clear addr L.
SAVEGAME_INIT_MOD_PAGE_PTR: ; 13:1ECA, 0x027ECA
    LDA #$00 ; Set FPTR 0x7400
    LDX #$74
    STA SAVE_GAME_MOD_PAGE_PTR[2]
    STX SAVE_GAME_MOD_PAGE_PTR+1
    RTS ; Leave.
SAVEGAME_LOADED_CHECKSUM: ; 13:1ED3, 0x027ED3
    JSR SAVEGAME_INIT_MOD_PAGE_PTR ; Reset.
    LDA #$00
    STA MISC_USE_A ; Clear checksum.
    STA MISC_USE_B
    LDX #$03 ; Pages to add together count.
LOOP_ALL_PAGES: ; 13:1EDE, 0x027EDE
    LDY #$00 ; Stream index reset.
LOOP_PAGE_STREAM: ; 13:1EE0, 0x027EE0
    CLC ; Prep add.
    LDA [SAVE_GAME_MOD_PAGE_PTR[2]],Y ; Load from file.
    ADC MISC_USE_A ; Add with.
    STA MISC_USE_A ; Store back.
    INY ; Stream++
    LDA [SAVE_GAME_MOD_PAGE_PTR[2]],Y ; Load from file.
    ADC MISC_USE_B ; Add with.
    STA MISC_USE_B ; Store to.
    INY ; Stream++
    BNE LOOP_PAGE_STREAM ; != 0, loop all stream.
    INC SAVE_GAME_MOD_PAGE_PTR+1 ; Inc PTR H.
    DEX ; Pages--
    BNE LOOP_ALL_PAGES ; != 0, goto.
    JMP SAVEGAME_INIT_MOD_PAGE_PTR ; Reset, abuse RTS.
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
