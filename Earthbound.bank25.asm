    LDA ENGINE_SCROLL_Y ; Load.
    CMP #$00 ; If _ #$00
    BNE EXIT_COPY_PROTECTION_FAIL ; !=, goto, fail.
    LDA ENGINE_SCROLL_X ; Load.
    CMP #$00 ; If _ #$00
    BNE EXIT_COPY_PROTECTION_FAIL ; !=, goto, fail.
    LDA ENGINE_PPU_CTRL_COPY ; Load.
    CMP #$88 ; If _ #$88
    BNE EXIT_COPY_PROTECTION_FAIL ; !=, goto, fail.
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle updates.
    LDA #$09 ; Seed read.
    LDX #$12 ; Size.
    STA NMI_PPU_CMD_PACKETS_BUF[69]
    STX NMI_PPU_CMD_PACKETS_BUF+1
    LDA #$07
    LDX #$23 ; Seed screen addr.
    STX NMI_PPU_CMD_PACKETS_BUF+2
    STA NMI_PPU_CMD_PACKETS_BUF+3
    LDA #$00
    STA NMI_PPU_CMD_PACKETS_BUF+22 ; EOF data.
    STA NMI_PPU_CMD_PACKETS_INDEX ; Reset index to run.
    LDA #$80
    STA NMI_FLAG_EXECUTE_UPDATE_BUF ; Set flag to run.
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle it.
    LDX #$00 ; Index.
VAL_LT_0x12: ; 19:0039, 0x032039
    LDA NMI_PPU_CMD_PACKETS_BUF+4,X ; Read read.
    CMP CHECK_ARR_PPU,X ; If _ check
    BNE EXIT_COPY_PROTECTION_FAIL ; !=, fail. Checks bottom of screen line itoi/nintendo.
    INX ; ++
    CPX #$12 ; If _ #$12
    BCC VAL_LT_0x12 ; <, loop.
    LDA #$10
    STA NMI_PPU_CMD_PACKETS_BUF+1 ; Set CMD.
    LDA #$00
    STA NMI_PPU_CMD_PACKETS_BUF+20 ; EOF?
    LDA #$D8
    STA BCD/MODULO/DIGITS_USE_A ; Seed ??
    LDA #$A0
    STA BCD/MODULO/DIGITS_USE_B
    LDA #$43 ; Addr ref 0430
    LDX #$05 ; Packets to do.
    JSR PPU_TILE_DATA_CHECKER_PROTECTION ; Do sub.
    BNE EXIT_COPY_PROTECTION_FAIL ; != 0, fail.
    LDA #$69 ; Addr ref 0690
    LDX #$08 ; Packets to do.
    JSR PPU_TILE_DATA_CHECKER_PROTECTION
    BNE EXIT_COPY_PROTECTION_FAIL
    LDA #$53 ; Addr ref 0350
    LDX #$05 ; Packets to do.
    JSR PPU_TILE_DATA_CHECKER_PROTECTION
    BNE EXIT_COPY_PROTECTION_FAIL
    RTS ; Leave, we GUCCI.
EXIT_COPY_PROTECTION_FAIL: ; 19:0074, 0x032074
    LDA #$E5
    STA COPY_PROTECTION_VAL ; Set copy protection value failue.
    RTS ; Leave.
PPU_TILE_DATA_CHECKER_PROTECTION: ; 19:0079, 0x032079
    PHA ; Save passed. Will be addr LH with nibbles.
    ASL A ; Nibble up.
    ASL A
    ASL A
    ASL A
    STA NMI_PPU_CMD_PACKETS_BUF+3 ; To buf, addr H.
    PLA ; Pull passed.
    LSR A ; Nibble down.
    LSR A
    LSR A
    LSR A
    STA NMI_PPU_CMD_PACKETS_BUF+2 ; To buf, addr L.
REDO_PPU_READ: ; 19:0089, 0x032089
    LDA #$00
    STA NMI_PPU_CMD_PACKETS_INDEX ; Reset update index.
    LDA #$80
    STA NMI_FLAG_EXECUTE_UPDATE_BUF ; Set flag to upload.
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle updates.
    LDY #$00 ; Stream index.
VAL_LT_0x10: ; 19:0096, 0x032096
    LDA NMI_PPU_CMD_PACKETS_BUF+4,Y ; Load from buf.
    CMP [BCD/MODULO/DIGITS_USE_A],Y ; If _ stream
    BNE EXIT_RTS_NONZERO_FAIL ; !=, goto, fail.
    INY ; Stream++
    CPY #$10 ; If _ #$10
    BCC VAL_LT_0x10 ; <, goto.
    CLC ; Prep add.
    LDA #$10 ; Mod val.
    ADC BCD/MODULO/DIGITS_USE_A ; Add to.
    STA BCD/MODULO/DIGITS_USE_A ; Store result.
    LDA #$00 ; Carry add val.
    ADC BCD/MODULO/DIGITS_USE_B ; Carry add to.
    STA BCD/MODULO/DIGITS_USE_B ; Store result.
    DEX ; Count--
    BEQ EXIT_RTS_NONZERO_FAIL ; == 0, leave, done.
    CLC ; Prep add.
    LDA #$10 ; Add mod.
    ADC NMI_PPU_CMD_PACKETS_BUF+3 ; Mod.
    STA NMI_PPU_CMD_PACKETS_BUF+3 ; Store result.
    LDA #$00 ; Seed carry add.
    ADC NMI_PPU_CMD_PACKETS_BUF+2 ; Add with.
    STA NMI_PPU_CMD_PACKETS_BUF+2 ; Store result.
    BCC REDO_PPU_READ ; No overflow, goto, always taken probs.
EXIT_RTS_NONZERO_FAIL: ; 19:00C5, 0x0320C5
    RTS ; Leave with zero pass nonzero failue.
CHECK_ARR_PPU: ; 19:00C6, 0x0320C6
    .db 43
    .db 44
    .db 45
    .db 46
    .db 47
    .db 70
    .db 69
    .db 6A
    .db 6B
    .db 6C
    .db 6D
    .db 6E
    .db 6F
    .db 53
    .db 54
    .db 55
    .db 56
    .db 57
    .db 00 ; Packet CMP.
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 38
    .db 44
    .db BA
    .db A2
    .db BA
    .db 44
    .db 38 ; Packet CMP.
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 5E
    .db 52
    .db 5E
    .db 42
    .db 5E
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db F7
    .db 94
    .db F7
    .db 90
    .db F7
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 82
    .db 82
    .db 82
    .db 82
    .db B2
    .db 10
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db F7
    .db 94
    .db F7
    .db 10
    .db F7
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 3A
    .db 22
    .db 3B
    .db 0A
    .db 3A
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db BB
    .db 92
    .db 92
    .db 92
    .db BB
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db BB
    .db 22
    .db BB
    .db A0
    .db BB
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db BB
    .db 29
    .db A9
    .db B9
    .db A9
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db B8
    .db 28
    .db 28
    .db 28
    .db 38
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db EE
    .db 44
    .db 44
    .db 44
    .db E4
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db EE
    .db A4
    .db A4
    .db A4
    .db EE
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db BC
    .db A4
    .db A4
    .db A4
    .db BC
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 10
    .db 12
    .db 23
    .db 23
    .db 42
    .db 42
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 5D
    .db 49
    .db C9
    .db C9
    .db 5D
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 2E
    .db A4
    .db E4
    .db 64
    .db 24
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db E9
    .db 8D
    .db EF
    .db 8B
    .db E9
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 67
    .db 55
    .db 55
    .db 55
    .db 67
    .db 00
SHUTDOWN_COPY_PROTECTION: ; 19:01F8, 0x0321F8
    JSR ENGINE_PALETTE_FADE_OUT ; Fade screen out.
    JSR ENGINE_0x300_OBJECTS_UNK? ; Clears flags mainly, 0x300 is cleared in next rtn?
    JSR SETTLE_SPRITES_OFFSCREEN/CLEAR_OBJ_RAM ; Init sprites/stuff.
    JSR ENGINE_CLEAR_SCREENS_0x2000-0x2800 ; Clear screens.
SHUTDOWN_COPY_PROTECTION_ALT_ENTRY: ; 19:0204, 0x032204
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle.
    LDA #$00
    STA NMI_LATCH_FLAG ; Clear flag.
    STA ENGINE_SCROLL_X ; No scroll.
    STA ENGINE_SCROLL_Y
    LDA #$FF ; Seed ??
    JSR SOUND_ASSIGN_NEW_MAIN_SONG ; Do ??
SCRIPT_ENTRY_COPYRIGHT_HELP_ANOTHER_ALT: ; 19:0214, 0x032214
    LDA #$7E ; Set GFX.
    LDX #$04 ; R4
    JSR ENGINE_SET_MAPPER_BANK_X_VAL_A
    LDA #$7F ; 2x
    LDX #$05 ; R5
    JSR ENGINE_SET_MAPPER_BANK_X_VAL_A
    LDA #$F4
    STA FPTR_PACKET_CREATION/PTR_H_FILE_IDK[2] ; Set PTR L.
    LDA #$06
    STA ARG/PTR_L ; Set ??
    LDA #$02
    STA GFX_COORD_HORIZONTAL_OFFSET ; Set coord.
    LDA #$02
    STA GFX_COORD_VERTICAL_OFFSET
    LDA #$00
    STA R_**:$0070 ; Clear ??
    STA ENGINE_PACKINATOR_ARG_SEED_0xA0_PRE_COUNT ; Clear.
STREAM_NE_0x00: ; 19:0238, 0x032238
    JSR LIB_READING_PPU_ROM_$0110_HELPER ; Do ?? <<<<<<<<<<<<<<<<<<<<<<<<<<<
    JSR ENGINE_CREATE_UPDATE_BUF_INIT_DEC? ; Do buf.
    CMP #$00 ; If _ #$00
    BEQ VAL_EQ_0x00 ; == 0, goto.
    LDY #$00 ; Reset stream.
    LDA [FPTR_PACKET_CREATION/PTR_H_FILE_IDK[2]],Y ; Load from.
    CMP #$00 ; If _ #$00
    BNE STREAM_NE_0x00 ; !=, goto.
VAL_EQ_0x00: ; 19:024A, 0x03224A
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle.
    LDX #$1F ; Palette index.
LOOP_PALETTE: ; 19:024F, 0x03224F
    LDA PALETTE_DATA_COPY_PROTECTION,X ; Load data.
    STA SCRIPT_PALETTE_UPLOADED?[32],X ; Store to palette.
    DEX ; Index--
    BPL LOOP_PALETTE ; Positive, move it.
    LDA #$04
    STA NMI_PPU_CMD_PACKETS_BUF[69] ; Set palette update packet.
    LDA #$00
    STA NMI_PPU_CMD_PACKETS_BUF+1 ; EOF.
    STA NMI_PPU_CMD_PACKETS_INDEX ; Reset index.
    LDA #$80
    STA NMI_FLAG_EXECUTE_UPDATE_BUF ; Set flag for updates.
LOOP_FOREVER: ; 19:0268, 0x032268
    JMP LOOP_FOREVER ; Goto forever.
PALETTE_DATA_COPY_PROTECTION: ; 19:026B, 0x03226B
    .db 0F
    .db 00
    .db 30
    .db 10
    .db 0F
    .db 00
    .db 30
    .db 10
    .db 0F
    .db 00
    .db 30
    .db 10
    .db 0F
    .db 00
    .db 30
    .db 10
    .db 0F
    .db 0F
    .db 00
    .db 30
    .db 0F
    .db 0F
    .db 16
    .db 37
    .db 0F
    .db 0F
    .db 24
    .db 37
    .db 0F
    .db 0F
    .db 12
    .db 37
INIT_WRAM_$6000-$67FF_AREA: ; 19:028B, 0x03228B
    LDA #$00 ; File ptr 0xB800. 19:1800!
    LDX #$B8
    STA BCD/MODULO/DIGITS_USE_A ; Setup file.
    STX BCD/MODULO/DIGITS_USE_B
    LDA #$00 ; File ptr 0x6000.
    LDX #$60
    STA SAVE_GAME_MOD_PAGE_PTR[2] ; Setup file.
    STX SAVE_GAME_MOD_PAGE_PTR+1
    JSR ENGINE_WRAM_STATE_WRITEABLE ; Enable writes.
    LDX #$08 ; Pages to move count. 0x800 bytes.
MOVE_PAGE_INIT: ; 19:02A0, 0x0322A0
    LDY #$00 ; Reset index.
MOVE_PAGE_LOOP: ; 19:02A2, 0x0322A2
    LDA [BCD/MODULO/DIGITS_USE_A],Y ; Load from file, 0xB800 base.
    STA [SAVE_GAME_MOD_PAGE_PTR[2]],Y ; Store to alt file, 0x6000 base.
    INY ; Stream++
    BNE MOVE_PAGE_LOOP
    INC BCD/MODULO/DIGITS_USE_B ; Move HPTR of both files.
    INC SAVE_GAME_MOD_PAGE_PTR+1
    DEX ; Loops--
    BNE MOVE_PAGE_INIT ; != 0, goto.
    JMP ENGINE_WRAM_STATE_WRITE_DISABLED ; Disable writes, leave.
SCRIPT_UNK_TODO: ; 19:02B3, 0x0322B3
    CLC ; Prep add.
    LDA SCRIPT_PAIR_PTR_B_SEED?[2] ; Load ??
    ADC #$40 ; Add with.
    AND #$80 ; Keep ??
    STA SCRIPT_LOADED_SHIFTED_UNK[2] ; Store to.
    LDA SCRIPT_PAIR_PTR_B_SEED?+1 ; Load ??
    ADC #$00 ; Carry add.
    STA SCRIPT_USE_UNK_A ; Store to.
    LDA SCRIPT_PAIR_PTR?[2] ; Move ??
    STA SCRIPT_USE_UNK_B_PTR_L
    LDA SCRIPT_PAIR_PTR?+1
    STA SCRIPT_USE_UNK_C_PTR_H
    JSR SETUP_DEEP_STREAM_UNK ; Do ptrs.
    LDA SCRIPT_PAIR_PTR_B_SEED?[2] ; Load ??
    ASL A ; << 2, *4.
    ASL A
    ROL A ; Rotate.
    AND #$01 ; Keep lower only.
    TAX ; To X index.
    LDY STREAM_DEEP_INDEX ; Load stream index.
    LDA #$10
    STA PACKET_CONSUMED/INDEX? ; Store consume?
    JSR ENGINE_WRAM_STATE_WRITEABLE ; Do WRAM writable.
PACKETS_TODO_NONZERO: ; 19:02DE, 0x0322DE
    TYA ; Index to A.
    ORA #$F0 ; Make inverted value.
    STA DISP_UPDATE_COUNT_SMART_INVERTED/MISC ; Store inverted.
ITER_NONZERO: ; 19:02E3, 0x0322E3
    LDA [STREAM_DEEP_B],Y ; Move stream.
    STA WRAM_PAGE_LARGE_UNK[384],X ; To WRAM.
    INY ; Stream++
    INX ; Index++
    INC DISP_UPDATE_COUNT_SMART_INVERTED/MISC ; Iter++
    BNE ITER_NONZERO ; != 0, goto. Inverted loop check.
    TYA ; Y to A.
    SEC ; Prep sub.
    SBC #$10 ; Sub with.
    TAY ; Back to Y. Reset data stream.
    LDA R_**:$00A5 ; Load ??
    EOR #$01 ; Invert ??
    STA R_**:$00A5 ; Store back.
    LDA STREAM_DEEP_INDEX ; Load.
    AND #$0F ; Keep lower.
    BEQ LOWER_EQ_0x00 ; == 0, goto.
    STA DISP_UPDATE_COUNT_SMART_INVERTED/MISC ; Store to iter count.
MOVE_SECONDARY: ; 19:0301, 0x032301
    LDA [STREAM_DEEP_B],Y ; Load from stream.
    STA WRAM_PAGE_LARGE_UNK[384],X ; Store to WRAM.
    INY ; Stream++
    INX ; Index++
    DEC DISP_UPDATE_COUNT_SMART_INVERTED/MISC ; Iter--
    BNE MOVE_SECONDARY ; != 0, goto.
LOWER_EQ_0x00: ; 19:030C, 0x03230C
    TYA ; Y to A.
    CLC ; Prep add.
    ADC #$10 ; Add with.
    TAY ; To Y index.
    LDA R_**:$00A5 ; Load ??
    EOR #$01 ; Invert bottom bit.
    STA R_**:$00A5 ; Store back.
    DEC PACKET_CONSUMED/INDEX? ; Todo--
    BNE PACKETS_TODO_NONZERO ; != 0, goto.
    JMP ENGINE_WRAM_STATE_WRITE_DISABLED ; Abuse exit RTS, no WRAM.
SCRIPT_ENTRY_UNK: ; 19:031E, 0x03231E
    SEC ; Prep lock.
    ROR NMI_FLAG_OBJECT_PROCESSING? ; Rotate lock bit.
    LDA GFX_COORD_HORIZONTAL_OFFSET ; Load.
    ASL A ; << 3, *8.
    ASL A
    ASL A
    STA PACKET_PPU_ADDR_HL[2] ; Store to packed addr H.
    CLC ; Prep add.
    LDA GFX_COORD_HORIZONTAL_OFFSET ; Add coord offset.
    ADC DATA_APPEND_COUNT? ; Add with.
    ASL A ; << 3, *8.
    ASL A
    ASL A
    SEC ; Prep sub.
    SBC #$04 ; Sub with ??
    STA PACKET_PPU_ADDR_HL+1 ; Store to, addr L.
    LDA GFX_COORD_VERTICAL_OFFSET ; Load coord.
    CLC ; Prep add.
    AND #$1E ; Add with.
    ASL A ; << 3, *8.
    ASL A
    ASL A
    STA ENGINE_PTR_PACKET_MANAGER[2] ; Store to, fptr L.
    CLC ; Prep add.
    ADC #$0C ; Add with.
    STA ENGINE_PTR_PACKET_MANAGER+1 ; Store to, fptr H.
    LDX #$00 ; Index reset.
INDEX_NONZERO: ; 19:0346, 0x032346
    LDA SPRITE_PAGE[256],X ; Load ??
    CMP ENGINE_PTR_PACKET_MANAGER+1 ; If _ var
    BCS X_INC_0x4_LOOP ; >=, goto.
    ADC #$04 ; += 0x4
    CMP ENGINE_PTR_PACKET_MANAGER[2] ; If _ var
    BCC X_INC_0x4_LOOP ; <,, goto.
    LDA SPRITE_PAGE+3,X ; Load Y pos.
    CMP PACKET_PPU_ADDR_HL+1 ; If _ var
    BCS X_INC_0x4_LOOP ; ?=, goto.
    ADC #$04 ; Add with.
    CMP PACKET_PPU_ADDR_HL[2] ; If _ var
    BCC X_INC_0x4_LOOP ; <<, goto.
    LDA #$F0
    STA SPRITE_PAGE[256],X ; Seed off screen.
X_INC_0x4_LOOP: ; 19:0365, 0x032365
    INX ; Index += 4
    INX
    INX
    INX
    BNE INDEX_NONZERO ; != 0, goto.
    ASL NMI_FLAG_OBJECT_PROCESSING? ; Shift off flag?
    RTS ; Leave.
    JSR PTR_SEEDED_UNK_J ; Seed ??
    LDY #$00 ; Stream index.
INDEX_LT_0x4: ; 19:0373, 0x032373
    TYA ; Index save.
    PHA
    JSR SUB_TILE_TO_UPDATE_ADDR_UNK ; Do sub.
    PLA ; Restore index.
    TAY
    INY ; ++
    CPY #$04 ; If _ #$04
    BCC INDEX_LT_0x4 ; <, goto.
    LDA #$01
    STA R_**:$00D6 ; Set ??
    LDA #$FA ; Seed menu.
    LDX #$A3
    STA FPTR_MENU_MASTER[2] ; Set menu fptr.
    STX FPTR_MENU_MASTER+1
    JSR ENGINE_MENU_INIT_PRIMARY ; Do sub.
SCRIPT_STATUS_TEST: ; 19:038E, 0x03238E
    BIT SCRIPT_MENU_STATUS ; Test.
    BPL EXIT_RET_D6 ; Positive, goto.
    LDA MENU_SELECTED_SUBMENU_OPTION_INDEX_FINAL ; Load ??
    TAX ; To X index.
    LSR A ; >> 3, /8.
    LSR A
    LSR A
    TAY ; To Y index.
    JSR ENGINE_WRAM_STATE_WRITEABLE ; Writeable.
    LDA ACTION_DATA_ARR_A_UNK,X ; Move
    STA BUTTON_ACTION_INDEX_ARRAY[3],Y
    CPY #$03 ; If _ #$03
    BNE Y_INDEX_NE_0x3 ; !=, goto.
    TXA ; X to A.
    AND #$07 ; Keep lower.
    TAX ; To X index.
    LDA ACTION_DATA_ARR_B_UNK,X ; Move ??
    STA CURRENT_SAVE_MANIPULATION_PAGE+24
Y_INDEX_NE_0x3: ; 19:03B0, 0x0323B0
    JSR ENGINE_WRAM_STATE_WRITE_DISABLED ; Disabled.
    LDA GFX_COORD_HORIZONTAL_OFFSET ; Save coords.
    PHA
    LDA GFX_COORD_VERTICAL_OFFSET
    PHA
    JSR SUB_TILE_TO_UPDATE_ADDR_UNK ; Do ??
    PLA
    STA GFX_COORD_VERTICAL_OFFSET ; Restore coords.
    PLA
    STA GFX_COORD_HORIZONTAL_OFFSET
    JSR SETTLE_AND_SPRITES_TO_COORD?_IDFK ; Settle and ??
    JMP SCRIPT_STATUS_TEST ; Goto.
EXIT_RET_D6: ; 19:03C8, 0x0323C8
    LDA #$00
    STA R_**:$00D6
    RTS
SUB_TILE_TO_UPDATE_ADDR_UNK: ; 19:03CD, 0x0323CD
    TYA ; Index to A.
    ASL A ; << 2, *4.
    ASL A
    ADC #$0D ; += 0xD, offset.
    STA GFX_COORD_VERTICAL_OFFSET ; Store to Voffset.
    LDA BUTTON_ACTION_INDEX_ARRAY[3],Y ; Move index.
    STA BCD/MODULO/DIGITS_USE_A
    LDA ROM_DATA_UNK,Y ; Move ??
    STA BCD/MODULO/DIGITS_USE_B
    LDX #$05 ; Set H offset.
VAL_LT_0x19: ; 19:03E0, 0x0323E0
    STX GFX_COORD_HORIZONTAL_OFFSET
    LDA #$94 ; Seed ??
    ASL BCD/MODULO/DIGITS_USE_A ; Shift.
    ADC #$00 ; Carry offsets val.
    ASL BCD/MODULO/DIGITS_USE_B ; Shift again.
    BCC SHIFT_CC ; CC, skip.
    JSR ENGINE_A_TO_UPDATE_PACKET ; Do ??
SHIFT_CC: ; 19:03EF, 0x0323EF
    CLC ; Prep add.
    LDA GFX_COORD_HORIZONTAL_OFFSET ; Load offset.
    ADC #$04 ; Add with.
    TAX ; To X index.
    CPX #$19 ; If _ #$19
    BCC VAL_LT_0x19 ; <, goto.
    RTS ; Leave.
    .db 08
    .db 04
    .db 04
    .db 04
    .db C0
    .db 3A
    .db 04
    .db 0D
    .db 08
    .db A4
ROM_DATA_UNK: ; 19:0404, 0x032404
    .db A8
    .db A8
    .db A8
    .db F8
ACTION_DATA_ARR_A_UNK: ; 19:0408, 0x032408
    .db 80
    .db 00
    .db 20
    .db 00
    .db 08
    .db 00
    .db 00
    .db 00
    .db 80
    .db 00
    .db 20
    .db 00
    .db 08
    .db 00
    .db 00
    .db 00
    .db 80
    .db 00
    .db 20
    .db 00
    .db 08
    .db 00
    .db 00
    .db 00
    .db 80
    .db 40
    .db 20
    .db 10
    .db 08
    .db 00
    .db 00
    .db 00
ACTION_DATA_ARR_B_UNK: ; 19:0428, 0x032428
    .db 41
    .db 31
    .db 21
    .db 11
    .db 01
    LDA MAPPER_BANK_VALS+6 ; Load R6.
    PHA ; Save it.
    LDX #$00 ; Index reset.
VAL_NONZERO: ; 19:0432, 0x032432
    STX BCD/MODULO/DIGITS_USE_A ; Store index.
    LDA DATA_BANKS_TO_CHECK,X ; Load ??
    BMI VALUE_NEGATIVE ; Negative, goto.
    LDX #$06 ; R6.
    JSR ENGINE_SET_MAPPER_BANK_X_VAL_A ; Set it.
    LDA #$00 ; Seed 0x8000?
    LDX #$80
    STA SAVE_GAME_MOD_PAGE_PTR[2] ; Set ptr.
    STX SAVE_GAME_MOD_PAGE_PTR+1
    LDA #$00
    STA BCD/MODULO/DIGITS_USE_B ; Set 0x0000.
    STA BCD/MODULO/DIGITS_USE_C
    LDX #$20 ; Seed pages to do.
PAGES_LOOP: ; 19:044E, 0x03244E
    LDY #$00 ; Reset stream index.
VALUE_NONZERO: ; 19:0450, 0x032450
    CLC ; Prep add.
    LDA [SAVE_GAME_MOD_PAGE_PTR[2]],Y ; Delta value with file.
    ADC BCD/MODULO/DIGITS_USE_B ; Add with.
    STA BCD/MODULO/DIGITS_USE_B ; Store to.
    LDA #$00 ; Seed offset.
    ADC BCD/MODULO/DIGITS_USE_C ; Carry add.
    STA BCD/MODULO/DIGITS_USE_C ; Store to.
    INY ; Stream++
    BNE VALUE_NONZERO ; != 0, goto.
    INC SAVE_GAME_MOD_PAGE_PTR+1 ; ++
    DEX ; Count--
    BNE PAGES_LOOP ; != 0, another page.
    LDX BCD/MODULO/DIGITS_USE_A ; Load ??
    INX ; X++
    LDA DATA_BANKS_TO_CHECK,X ; Load ??
    CMP BCD/MODULO/DIGITS_USE_C ; If _ var
    BNE EXIT_FADE_AND_COPYRIGHT_ALT_ENTRY ; !=, goto.
    INX ; Index++
    LDA DATA_BANKS_TO_CHECK,X ; Load ??
    CMP BCD/MODULO/DIGITS_USE_B ; If _ var
    BNE EXIT_FADE_AND_COPYRIGHT_ALT_ENTRY ; !=, goto.
    INX ; Index++
    BNE VAL_NONZERO ; != 0, goto.
VALUE_NEGATIVE: ; 19:047A, 0x03247A
    PLA ; Pull A, old R6.
    LDX #$06 ; R6
    JMP ENGINE_SET_MAPPER_BANK_X_VAL_A ; Set R6 with A, fancy exit.
EXIT_FADE_AND_COPYRIGHT_ALT_ENTRY: ; 19:0480, 0x032480
    JSR ENGINE_PALETTE_FADE_OUT ; Fade out.
    JSR ENGINE_0x300_OBJECTS_UNK? ; Do ??
    JSR SETTLE_SPRITES_OFFSCREEN/CLEAR_OBJ_RAM ; No sprites.
    JSR ENGINE_CLEAR_SCREENS_0x2000-0x2800 ; Clear screens.
    JMP SHUTDOWN_COPY_PROTECTION_ALT_ENTRY ; Do ??. TODO: Bank R7?
DATA_BANKS_TO_CHECK: ; 19:048F, 0x03248F
    .db 13 ; R6 values for ??
    .db 2C
    .db 95
    .db 14
    .db 0B
    .db 82
    .db 17
    .db ED
    .db EB
    .db 19
    .db C7
    .db A8
    .db 1C
    .db AC
    .db D5
    .db 1E
    .db 1C
    .db CF
    .db 1F
    .db 36
    .db FA
    .db FF
    .db 57
    .db 38
    LDA CURRENT_SAVE_MANIPULATION_PAGE+25 ; Load ??
    BEQ RTS ; == 0, leave.
    LDY SCRIPT_ENCOUNTER_ID?(SAID_SONG_ID???) ; Load ID??
    LDX DATA_INDEXES_TO_USE,Y ; iNDEX FROM y.
    LDA WRAM_CMP_UNK,X ; Load ??
    CMP CURRENT_SAVE_MANIPULATION_PAGE+80 ; If _ var
    BCS RTS ; >=, goto. Leave.
    JSR ENGINE_WRAM_STATE_WRITEABLE ; Do writable.
    DEC CURRENT_SAVE_MANIPULATION_PAGE+25 ; --
    JSR ENGINE_WRAM_STATE_WRITE_DISABLED ; Disable.
    LDA #$00
    STA SCRIPT_ENCOUNTER_ID?(SAID_SONG_ID???) ; Clear ??
    LDA CURRENT_SAVE_MANIPULATION_PAGE+25 ; Load ??
    BEQ VAR_EQ_0x00 ; == 0, goto.
RTS: ; 19:04CB, 0x0324CB
    RTS ; Leave.
VAR_EQ_0x00: ; 19:04CC, 0x0324CC
    LDA #$D1
    STA FPTR_PACKET_CREATION/PTR_H_FILE_IDK[2] ; Set ??
    LDA #$06
    STA ARG/PTR_L ; Arg ??
    LDA #$13 ; Do 13:0D1A, script ??
    LDX #$19
    LDY #$AD
    JSR ENGINE_SCRIPT_LAUNCH_R7_A_PTR_XY_WITH_RESTORE ; Script ??
    LDA #$13 ; Do 13:0B30, script ??
    LDX #$2F
    LDY #$AB
    JSR ENGINE_SCRIPT_LAUNCH_R7_A_PTR_XY_WITH_RESTORE ; Script ??
    LDA #$13 ; Do 1E:03F4, script ?? bank no matter.
    LDX #$F3
    LDY #$C3
    JSR ENGINE_SCRIPT_LAUNCH_R7_A_PTR_XY_WITH_RESTORE ; Script ??
    JMP ENGINE_HELPER_R6_0x14 ; Goto, exit.
WRAM_CMP_UNK: ; 19:04F2, 0x0324F2
    .db 00
    .db 03
    .db 05
    .db 07
    .db 0A
    .db 0C
    .db 10
    .db 12
    .db 13
    .db 15
    .db 17
    .db 1A
    .db 1C
    .db 1E
    .db 23
    .db 24
    .db 25
    .db FF
DATA_INDEXES_TO_USE: ; 19:0504, 0x032504
    .db 00
    .db 01
    .db 03
    .db 01
    .db 03
    .db 01
    .db 03
    .db 03
    .db 01
    .db 03
    .db 01
    .db 01
    .db 07
    .db 01
    .db 01
    .db 02
    .db 11
    .db 11
    .db 11
    .db 11
    .db 02
    .db 02
    .db 03
    .db 03
    .db 11
    .db 03
    .db 03
    .db 03
    .db 03
    .db 03
    .db 03
    .db 11
    .db 03
    .db 11
    .db 03
    .db 03
    .db 11
    .db 03
    .db 06
    .db 11
    .db 06
    .db 06
    .db 11
    .db 08
    .db 04
    .db 11
    .db 11
    .db 11
    .db 04
    .db 04
    .db 04
    .db 04
    .db 05
    .db 05
    .db 05
    .db 04
    .db 05
    .db 05
    .db 04
    .db 04
    .db 04
    .db 05
    .db 05
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db 06
    .db 08
    .db 08
    .db 11
    .db 11
    .db 11
    .db 07
    .db 07
    .db 07
    .db 07
    .db 07
    .db 11
    .db 06
    .db 06
    .db 11
    .db 11
    .db 06
    .db 11
    .db 02
    .db 09
    .db 11
    .db 11
    .db 11
    .db 09
    .db 09
    .db 11
    .db 09
    .db 09
    .db 11
    .db 11
    .db 09
    .db 0A
    .db 0A
    .db 0A
    .db 0A
    .db 0A
    .db 0A
    .db 0A
    .db 0A
    .db 11
    .db 11
    .db 11
    .db 0B
    .db 0B
    .db 0B
    .db 0B
    .db 0B
    .db 0D
    .db 0D
    .db 0B
    .db 0B
    .db 0B
    .db 0B
    .db 0B
    .db 11
    .db 11
    .db 11
    .db 0B
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db 0B
    .db 0B
    .db 0C
    .db 0C
    .db 0C
    .db 0C
    .db 0C
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db 0E
    .db 0E
    .db 0E
    .db 0E
    .db 0E
    .db 0F
    .db 0F
    .db 0F
    .db 0F
    .db 10
    .db 10
    .db 10
    .db 10
    .db 10
    .db 10
    .db 10
    .db 10
    .db 10
    .db 10
    .db 10
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    JSR SUB_TODO ; Do sub.
    LDA #$00
    STA ROUTINE_CONTINUE_FLAG? ; Clear flag.
    LDA #$13 ; Seed 1E:03F4, script ??
    LDX #$F3
    LDY #$C3
    JSR ENGINE_SCRIPT_LAUNCH_R7_A_PTR_XY_WITH_RESTORE
    LDA #$6A ; Seed GFX bank.
    LDX #$01 ; Seed R1, GFX.
    JSR ENGINE_SET_MAPPER_BANK_X_VAL_A ; Set it.
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle.
    LDX #$DF ; Seed index.
INDEX_NE_0xFF: ; 19:05E8, 0x0325E8
    LDA OBJ?_BYTE_0x0_STATUS?,X ; Load ??
    STA **:$0320,X ; Store to ??
    DEX ; Index--
    CPX #$FF ; If _ #$FF
    BNE INDEX_NE_0xFF ; !=, goto.
    LDX #$1F ; Seed ??
INDEX_POSITIVE: ; 19:05F5, 0x0325F5
    LDA OBJECTS_CREATE_DATA_IDK,X ; Move ??
    STA OBJ?_BYTE_0x0_STATUS?,X
    DEX ; Index--
    BPL INDEX_POSITIVE ; Positive, goto.
    CLC ; Prep add.
    LDA SCRIPT_PAIR_PTR_B_SEED?[2] ; Load ??
    ADC #$60 ; Mod ??
    STA BCD/MODULO/DIGITS_USE_A ; Store to.
    LDA SCRIPT_PAIR_PTR_B_SEED?+1 ; Load.
    ADC #$00 ; Carry add.
    STA BCD/MODULO/DIGITS_USE_B ; Store to.
    SEC ; Prep sub.
    LDY #$04 ; Stream index.
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load from file.
    SBC BCD/MODULO/DIGITS_USE_A ; Sub with.
    STA BCD/MODULO/DIGITS_USE_A ; Store result.
    INY ; Stream++
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load from file.
    SBC BCD/MODULO/DIGITS_USE_B ; Sub with.
    STA BCD/MODULO/DIGITS_USE_B ; Store result.
    LSR BCD/MODULO/DIGITS_USE_B ; Rotate 0.
    ROR BCD/MODULO/DIGITS_USE_A ; Rotate carry.
    LSR BCD/MODULO/DIGITS_USE_B ; Rotate 0.
    ROR BCD/MODULO/DIGITS_USE_A ; Rotate carry.
    CLC ; Prep add.
    LDA SCRIPT_PAIR_PTR?[2] ; Load ??
    ADC #$A4 ; Add 0xA4.
    STA SAVE_GAME_MOD_PAGE_PTR[2] ; Store to addr L.
    LDA SCRIPT_PAIR_PTR?+1 ; Load ??
    ADC #$00 ; Carry add.
    STA SAVE_GAME_MOD_PAGE_PTR+1 ; Store to addr H.
    SEC ; Prep sub.
    LDY #$06 ; Stream index.
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load from file.
    SBC SAVE_GAME_MOD_PAGE_PTR[2] ; Sub with.
    STA SAVE_GAME_MOD_PAGE_PTR[2] ; Store to.
    INY ; Stream++
    LDA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Load from file.
    SBC SAVE_GAME_MOD_PAGE_PTR+1 ; Sub with, carried.
    STA SAVE_GAME_MOD_PAGE_PTR+1 ; Store to.
    LSR SAVE_GAME_MOD_PAGE_PTR+1 ; Rotate 0.
    ROR SAVE_GAME_MOD_PAGE_PTR[2] ; Rotate carry.
    LSR SAVE_GAME_MOD_PAGE_PTR+1 ; Rotate 0.
    ROR SAVE_GAME_MOD_PAGE_PTR[2] ; Rotate carry.
    LDA BCD/MODULO/DIGITS_USE_A ; Load.
    STA OBJ?_BYTE_0x2_UNK ; Set ??
    STA **:$030A
    STA **:$0312
    STA **:$031A
    LDA SAVE_GAME_MOD_PAGE_PTR[2] ; Load.
    STA OBJ?_BYTE_0x3_UNK ; Set ??
    STA **:$030B
    STA **:$0313
    STA **:$031B
    LDA #$5A
    STA NMI_FLAG_EXECUTE_UPDATE_BUF ; Set ??
    LDA #$30 ; Color, white.
    JSR ENGINE_ALL_COLOR_TO_A ; Do ??
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle.
    LDA #$00
    STA OBJ?_BYTE_0x4_UNK ; Clear ??
    STA OBJ?_BYTE_0x5_BYTE
    STA **:$0308
    STA **:$0310
    STA **:$0318
    LDA BCD/MODULO/DIGITS_USE_A ; Move ??
    STA OBJ?_BYTE_0x2_UNK
    LDA SAVE_GAME_MOD_PAGE_PTR[2] ; Move ??
    STA OBJ?_BYTE_0x3_UNK
    LDA #$FC ; Move ??
    STA OBJ?_PTR?[2]
    LDA #$99 ; Move ??
    STA OBJ?_PTR?+1
    LDA #$01
    STA NMI_FLAG_EXECUTE_UPDATE_BUF ; Set flag.
    JSR ENGINE_PALETTE_UPLOAD_WITH_PACKET_HELPER ; Do ??
    LDX #$3C
    JMP ENGINE_DELAY_X_FRAMES ; Delay with RTS abuse.
OBJECTS_CREATE_DATA_IDK: ; 19:06A1, 0x0326A1
    .db 04 ; 0x00
    .db 00
    .db 32
    .db 32
    .db 01
    .db 01
    .db F8
    .db 99
    .db 04
    .db 00
    .db 42
    .db 32
    .db 01
    .db FF
    .db F8
    .db 99
    .db 04
    .db 00
    .db 32
    .db 42
    .db FF
    .db 01
    .db F8
    .db 99
    .db 04
    .db 00
    .db 42
    .db 42
    .db FF
    .db FF
    .db F8
    .db 99
    .db 60 ; 0x1F
    JSR 19:042D ; Todo cri before going through all these lol.
    JSR ENGINE_0x300_OBJECTS_UNK? ; Do objects.
    LDA #$FF
    JSR SOUND_ASSIGN_NEW_MAIN_SONG ; No song.
    LDX #$3C
    JSR ENGINE_DELAY_X_FRAMES ; Delay.
    LDA #$23
    STA SOUND_VAL_SONG_INIT_ID ; Song init.
    LDA #$F8 ; Seed ??
    LDX #$FF
    JSR SUB_UNK_A_SETTLER ; Do sub ??
    LDA #$10 ; Seed ??
    LDX #$00
    JSR SUB_UNK_A_SETTLER ; Do ??
    JSR SUB_TWICE_TODO_IDFK ; Do 4x.
    JSR SUB_TWICE_TODO_IDFK
    JSR VAL_SEED_0x00 ; First.
    JSR VAL_SEEDED_0x8 ; 2nd.
    JSR VAL_SEED_0x00 ; First.
    JSR VAL_SEEDED_0x8 ; Second.
    JSR SUB_TWICE_TODO_IDFK ; Do 2x.
    JSR VAL_SEEDED_0x10 ; Do objs.
    JSR VAL_SEEDED_0x18
    JSR VAL_SEEDED_0x10
    JSR VAL_SEEDED_0x18
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle.
    LDX #$60
    JSR ENGINE_DELAY_X_FRAMES ; Delay frames.
    JSR VAL_SEED_0x00 ; Seed objs.
    JSR VAL_SEEDED_0x8
    JSR VAL_SEED_0x00
    JSR SUB_SINGLE_ENTRY_TODO ; Do ??
    LDX #$78 ; Delay exit.
    JMP ENGINE_DELAY_X_FRAMES ; Exit delay.
VAL_SEED_0x00: ; 19:071F, 0x03271F
    LDY #$00 ; Seed indexes.
    BPL VAL_SEEDED
VAL_SEEDED_0x8: ; 19:0723, 0x032723
    LDY #$08
    BPL VAL_SEEDED
VAL_SEEDED_0x10: ; 19:0727, 0x032727
    LDY #$10
    BPL VAL_SEEDED
VAL_SEEDED_0x18: ; 19:072B, 0x03272B
    LDY #$18
VAL_SEEDED: ; 19:072D, 0x03272D
    LDA DATA_PAIR_A,Y ; Load ??
    LDX DATA_PAIR_B,Y ; Load ??
    JSR SUB_HELPER ; Do ??
    INY ; Pair++
    INY
    TYA ; Index to A.
    AND #$07 ; Keep lower.
    BNE VAL_SEEDED ; Nonzero, loop.
    RTS ; Leave.
DATA_PAIR_A: ; 19:073E, 0x03273E
    .db 01 ; Movement arr?
DATA_PAIR_B: ; 19:073F, 0x03273F
    .db 00
    .db FF
    .db 00
    .db 01
    .db 00
    .db FF
    .db 00
    .db 01
    .db FF
    .db FF
    .db 00
    .db 01
    .db 01
    .db FF
    .db 00
    .db 00
    .db FF
    .db 00
    .db FF
    .db 00
    .db FF
    .db 00
    .db FF
    .db 01
    .db 01
    .db FF
    .db 01
    .db 01
    .db 01
    .db FF
    .db 01
SUB_UNK_A_SETTLER: ; 19:075E, 0x03275E
    STA BCD/MODULO/DIGITS_USE_A ; Store vals.
    STX BCD/MODULO/DIGITS_USE_B
    LDX #$08 ; Obj index.
VAL_LT_0x20: ; 19:0764, 0x032764
    JSR SUB_SETTLE_AND_OBJECT_MOD ; Mod obj.
    LDA #$30
    STA NMI_FLAG_EXECUTE_UPDATE_BUF ; Set flag.
    JSR X_INC_BY_0x8 ; Next obj.
    CPX #$20 ; If _ #$20
    BCC VAL_LT_0x20 ; <, goto.
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle.
    LDA #$30
    STA NMI_FLAG_EXECUTE_UPDATE_BUF ; Update.
    RTS ; Leave.
SUB_SETTLE_AND_OBJECT_MOD: ; 19:077A, 0x03277A
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle.
    CLC ; Prep add.
    LDA BCD/MODULO/DIGITS_USE_A ; Load ??
    ADC OBJ?_PTR?[2],X ; Add with obj.
    STA OBJ?_PTR?[2],X ; Store to obj.
    LDA BCD/MODULO/DIGITS_USE_B ; Load ??
    ADC OBJ?_PTR?+1,X ; Add with obj.
    STA OBJ?_PTR?+1,X ; Store to obj.
    RTS ; Leave.
BOUND_CHECK_REMOVE_OTHERWISE_UNK: ; 19:078F, 0x03278F
    CPX #$20 ; If _ #$20
    BCS OBJECT_CLEAR_HELPER_UNK ; >=, goto.
    LDA SAVE_GAME_MOD_PAGE_PTR[2] ; Move ?? to obj.
    STA OBJ?_BYTE_0x4_UNK,X
    LDA SAVE_GAME_MOD_PAGE_PTR+1
    STA OBJ?_BYTE_0x5_BYTE,X
    RTS ; Leave.
OBJECT_CLEAR_HELPER_UNK: ; 19:079E, 0x03279E
    LDA #$00
    STA OBJ?_BYTE_0x4_UNK,X ; Clear obj ??
    STA OBJ?_BYTE_0x5_BYTE,X
    RTS ; Leave.
X_INC_BY_0x8: ; 19:07A7, 0x0327A7
    CLC ; Prep add.
    TXA ; X to A.
    ADC #$08 ; Add to it.
    TAX ; Back to X.
    RTS ; Leave.
SUB_TWICE_TODO_IDFK: ; 19:07AD, 0x0327AD
    JSR SUB_SINGLE_ENTRY_TODO ; Do ??
SUB_SINGLE_ENTRY_TODO: ; 19:07B0, 0x0327B0
    LDA #$00 ; Seed clear ??
    LDX #$00
SUB_HELPER: ; 19:07B4, 0x0327B4
    STA SAVE_GAME_MOD_PAGE_PTR[2] ; Store mod ptr.
    STX SAVE_GAME_MOD_PAGE_PTR+1
    JSR SUB_DOUBLE_ENTRY ; Single re-do on RTS.
SUB_DOUBLE_ENTRY: ; 19:07BB, 0x0327BB
    LDA #$04 ; Seed ??
    LDX #$00
    STA BCD/MODULO/DIGITS_USE_A ; Store.
    STX BCD/MODULO/DIGITS_USE_B
    LDX #$08 ; Index ??
INC_NO_OVERFLOW_A: ; 19:07C5, 0x0327C5
    JSR SUB_SETTLE_AND_OBJECT_MOD ; Do settle and mod.
    JSR BOUND_CHECK_REMOVE_OTHERWISE_UNK ; Do ??
    JSR X_INC_BY_0x8 ; X++
    BCC INC_NO_OVERFLOW_A ; No overflow, goto.
    LDA #$02
    STA NMI_FLAG_EXECUTE_UPDATE_BUF ; Set ?? ugh literally new flag.
    LDX #$08 ; Seed index ??
INC_NO_OVERFLOW_B: ; 19:07D6, 0x0327D6
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle.
    JSR OBJECT_CLEAR_HELPER_UNK ; Clear ??
    JSR X_INC_BY_0x8 ; To next.
    BCC INC_NO_OVERFLOW_B ; No overflow, loop.
    LDA #$16
    STA NMI_FLAG_EXECUTE_UPDATE_BUF ; Set flag ??
    LDA #$FC ; Seed 1F:1CFF, ??
    LDX #$FF
    STA BCD/MODULO/DIGITS_USE_A
    STX BCD/MODULO/DIGITS_USE_B
    LDX #$08 ; Seed ??
INC_NO_OVERFLOW_C: ; 19:07EF, 0x0327EF
    JSR SUB_SETTLE_AND_OBJECT_MOD ; Settle.
    JSR X_INC_BY_0x8 ; Do ??
    BCC INC_NO_OVERFLOW_C ; No overflow, goto.
    LDA #$18
    STA NMI_FLAG_EXECUTE_UPDATE_BUF ; Set flag I understand finally.
    RTS ; Leave.
    LDY SCRIPT_INDEX_53_UNK ; Seed index.
    SEC ; Prep sub.
    LDA STREAM_INDEXES_ARR_UNK+5,Y ; Load ??
    SBC SUB/MOD_VAL_UNK_WORD[2] ; Sub with.
    STA STREAM_INDEXES_ARR_UNK+5,Y ; Store to.
    LDA STREAM_INDEXES_ARR_UNK+6,Y ; Load from obj.
    SBC SUB/MOD_VAL_UNK_WORD+1 ; Carry sub.
    STA STREAM_INDEXES_ARR_UNK+6,Y ; Store to.
    BCS SUB_NO_UNDERFLOW ; No underflow, goto.
    LDA #$00
    STA STREAM_INDEXES_ARR_UNK+5,Y ; Clear if underflow, min 0x0000.
    STA STREAM_INDEXES_ARR_UNK+6,Y
SUB_NO_UNDERFLOW: ; 19:0819, 0x032819
    RTS ; Leave.
SUB_TODO: ; 19:081A, 0x03281A
    LDA MAPPER_BANK_VALS+6 ; Save R6.
    PHA
    LDX #$00 ; Seed ??
INDEX_NE_0x00: ; 19:081F, 0x03281F
    STX BCD/MODULO/DIGITS_USE_A ; Clear ??
    LDA BANK_CHECKSUMS_DATA_WORDS?,X ; Load ??
    BMI DATA_NEGATIVE ; Negative, goto.
    LDX #$06
    JSR ENGINE_SET_MAPPER_BANK_X_VAL_A ; Set R6 from A if positive.
    LDA #$00
    LDX #$80
    STA SAVE_GAME_MOD_PAGE_PTR[2] ; Seed 0x8000.
    STX SAVE_GAME_MOD_PAGE_PTR+1
    LDA #$00
    STA BCD/MODULO/DIGITS_USE_B ; Clear ??
    STA BCD/MODULO/DIGITS_USE_C
    LDX #$20 ; Seed pages.
PAGE_LOOP: ; 19:083B, 0x03283B
    LDY #$00
STREAM_PAGES_TODO: ; 19:083D, 0x03283D
    CLC ; Prep add.
    LDA [SAVE_GAME_MOD_PAGE_PTR[2]],Y ; Load from file.
    ADC BCD/MODULO/DIGITS_USE_B ; Add with file.
    STA BCD/MODULO/DIGITS_USE_B ; Store back.
    LDA #$00 ; Seed carry.
    ADC BCD/MODULO/DIGITS_USE_C ; Carry add.
    STA BCD/MODULO/DIGITS_USE_C ; Store result.
    INY ; Stream++
    BNE STREAM_PAGES_TODO ; != 0, goto. More pages.
    INC SAVE_GAME_MOD_PAGE_PTR+1 ; PTRH++
    DEX ; Pages--
    BNE PAGE_LOOP ; != 0, goto, loop more pages.
    LDX BCD/MODULO/DIGITS_USE_A ; Seed index ??
    INX ; ++
    LDA BANK_CHECKSUMS_DATA_WORDS?,X ; Load from data.
    CMP BCD/MODULO/DIGITS_USE_C ; Compare to H.
    BNE COPY_PROTECT_FAILURE ; !=, goto.
    INX ; Index++
    LDA BANK_CHECKSUMS_DATA_WORDS?,X ; Load from arr.
    CMP BCD/MODULO/DIGITS_USE_B ; If _ var
    BNE COPY_PROTECT_FAILURE ; !=, goto.
    INX ; Index++
    BNE INDEX_NE_0x00 ; !=, goto.
DATA_NEGATIVE: ; 19:0867, 0x032867
    PLA ; R6 restore val.
    LDX #$06 ; R6.
    JMP ENGINE_SET_MAPPER_BANK_X_VAL_A ; Goto.
COPY_PROTECT_FAILURE: ; 19:086D, 0x03286D
    JSR ENGINE_PALETTE_FADE_OUT ; Fade out.
    JSR ENGINE_0x300_OBJECTS_UNK? ; Do objects.
    JSR SETTLE_SPRITES_OFFSCREEN/CLEAR_OBJ_RAM
    JSR ENGINE_CLEAR_SCREENS_0x2000-0x2800 ; Clear screens.
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle updates.
    LDA #$00
    STA NMI_LATCH_FLAG ; Clear flag.
    STA ENGINE_SCROLL_X ; Clear scrolls.
    STA ENGINE_SCROLL_Y
    LDA #$FF
    JSR SOUND_ASSIGN_NEW_MAIN_SONG ; No sound.
    JMP SCRIPT_ENTRY_COPYRIGHT_HELP_ANOTHER_ALT ; Copy protect.
BANK_CHECKSUMS_DATA_WORDS?: ; 19:088C, 0x03288C
    .db 13
    .db 2C
    .db 95
    .db 14
    .db 0B
    .db 82
    .db 17
    .db ED
    .db EB
    .db 19
    .db C7
    .db A8
    .db 1C
    .db AC
    .db D5
    .db 1E
    .db 1C
    .db CF
    .db 1F
    .db 36
    .db FA
    .db FF
    .db 57
    .db 38
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
WRAM_HELPER_ARR_A/B_MOVE_TO_RAM_UNK: ; 19:1800, 0x033800
    TAY ; Slot index to Y. **This chunk loaded in at $6000-$67FF**
    BEQ SLOT_ZERO ; == 0, goto.
    LDY #$04 ; Alt index.
SLOT_ZERO: ; 19:1805, 0x033805
    LDA WRAM/RAM_ARR_UNK_WRAM[4],Y ; Move Y to X.
    STA WRAM/RAM_ARR_UNK_RAM[4],X
    LDA WRAM/RAM_ARR_UNK_WRAM+1,Y ; Move Y to X.
    STA WRAM/RAM_ARR_UNK_RAM+1,X
    LDA WRAM/RAM_ARR_UNK_WRAM+2,Y ; Move Y to X.
    STA WRAM/RAM_ARR_UNK_RAM+2,X
    LDA WRAM/RAM_ARR_UNK_WRAM+3,Y ; Move Y to X.
    STA WRAM/RAM_ARR_UNK_RAM+3,X
    RTS ; Leave.
FILE_PTR_MOVE_A: ; 19:181E, 0x03381E
    LDA **:$6073,X ; Move file ptr. ROM addr: 19:1873
    STA FPTR_PACKET_CREATION/PTR_H_FILE_IDK[2]
    LDA **:$6074,X
    STA FPTR_PACKET_CREATION/PTR_H_FILE_IDK+1
    RTS ; Leave.
FILE_PTR_MOVE_B: ; 19:1829, 0x033829
    LDA **:$6085,X ; File ptr move, 19:1885
    STA FPTR_MENU_MASTER[2]
    LDA **:$6086,X
    STA FPTR_MENU_MASTER+1
    RTS
WRAM_CODE_SET_COORDS_AND_UNK: ; 19:1834, 0x033834
    LDA #$FF
    STA R_**:$00D6 ; Set ??
    LDX #$06
    LDY #$05
    STX GFX_COORD_HORIZONTAL_OFFSET ; Seed X and Y screen pos.
    STY GFX_COORD_VERTICAL_OFFSET
    RTS
SAVEGAME_MOD_PAGE_INIT: ; 19:1841, 0x033841
    PHA ; Save A passed, slot.
    LDA #$00 ; Set up 0x7400 ptr.
    LDX #$74
    STA ENGINE_MAP_OBJ_RESERVATIONS/??[2]
    STX ENGINE_MAP_OBJ_RESERVATIONS/??+1
    LDA #$00 ; Set up 0xBE00 ptr.
    LDX #$BE
    STA ENGINE_FPTR_32[2]
    STX ENGINE_FPTR_32+1
    LDX #$02 ; Pages count.
    LDY #$00 ; Seed index.
LOOP_PAGE_WRITE: ; 19:1856, 0x033856
    LDA [ENGINE_FPTR_32[2]],Y ; Load from stream, ROM.
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; To RAM.
    INY ; Stream++
    BNE LOOP_PAGE_WRITE ; != 0, goto.
    INC ENGINE_MAP_OBJ_RESERVATIONS/??+1 ; Inc ptr H.
    INC ENGINE_FPTR_32+1
    DEX ; Loops--
    BNE LOOP_PAGE_WRITE ; != 0, goto.
    LDA #$00 ; Clear val.
CLEAR_LAST_SAVE_PAGE: ; 19:1866, 0x033866
    STA [ENGINE_MAP_OBJ_RESERVATIONS/??[2]],Y ; Clear 0x7600 page, last page of save file.
    INY ; Index++
    BNE CLEAR_LAST_SAVE_PAGE ; != 0, goto.
    PLA ; Pull A, slot id.
    ORA SAVE_SLOT_DATA_CHECKSUM_ADJUST_A ; Set bits. TODO why ??
    STA SAVE_SLOT_DATA_CHECKSUM_ADJUST_A ; Store back.
    RTS ; Leave.
    LOW(**:$611A) ; 0x00
    HIGH(**:$611A) ; Continue copy erase file?
    LOW(**:$6192) ; 0x01, 19:1992
    HIGH(**:$6192)
    LOW(**:$6138) ; 0x02
    HIGH(**:$6138)
    LOW(**:$61AA) ; 0x03
    HIGH(**:$61AA)
    LOW(**:$6156) ; 0x04
    HIGH(**:$6156) ; ---p--\n----p--?
    LOW(**:$61C2) ; 0x05
    HIGH(**:$61C2) ; Copy erase file?
    LOW(**:$6095) ; 0x06
    HIGH(**:$6095) ; Start up game file?
    LOW(**:$60AC) ; 0x07
    HIGH(**:$60AC) ; Locks up game? Nothing on save screen with this one.
    LOW(**:$60FA) ; 0x08
    HIGH(**:$60FA) ; File for game valid?
MENU_POINTERS_L: ; 19:1885, 0x033885
    LOW(**:$61F0) ; 0x09
MENU_POINTERS_H: ; 19:1886, 0x033886
    HIGH(**:$61F0)
    LOW(**:$61F0) ; 0x0A
    HIGH(**:$61F0)
    LOW(**:$61F0) ; 0x0B
    HIGH(**:$61F0)
    LOW(**:$61FA) ; 0x0C
    HIGH(**:$61FA)
    LOW(**:$61F0) ; 0x0D
    HIGH(**:$61F0)
    LOW(**:$6204) ; 0x0E
    HIGH(**:$6204) ; Erasing file. " Lvl #" will vanish. OK? Y/N
    LOW(**:$620E) ; 0x0F
    HIGH(**:$620E)
    LOW(**:$6218) ; 0x10
    HIGH(**:$6218) ; Copying file. "To which?"
    .db 20 ; Packet start.
    .db 04
    .db 14
    .db 22
    .db A0
    .db 18
    .db 01
    .db 22
    .db A0
    .db 18
    .db 01
    .db 22
    .db A0
    .db 18
    .db 01
    .db 22
    .db A0
    .db 18
    .db 00
    .db 22
    .db A0
    .db 18
    .db 00
    .db 20 ; Packet start.
    .db 06
    .db 14
    .db DB
    .db 22
    .db DC
    .db 12
    .db DD
    .db 01
    .db 24
    .db A0
    .db A6
    .db 23
    .db 78
    .db 74
    .db 00
    .db 08
    .db CC
    .db F6
    .db EC
    .db 23
    .db 50
    .db 74
    .db 01
    .db 02
    .db A6
    .db A0
    .db A0
    .db 25
    .db 01
    .db 24
    .db A0
    .db F7
    .db E9
    .db EC
    .db EC
    .db A0
    .db F6
    .db E1
    .db EE
    .db E9
    .db F3
    .db E8
    .db AE
    .db A0
    .db CF
    .db CB
    .db A2
    .db A0
    .db 25
    .db 01
    .db 24
    .db A0
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
    .db A0
    .db A0
    .db A0
    .db A0
    .db A0
    .db 25
    .db 00
    .db FB
    .db 22
    .db FC
    .db 12
    .db FD
    .db 00
    .db 20 ; Packet start.
    .db 08
    .db 15
    .db DB
    .db 22
    .db DC
    .db 0E
    .db DD
    .db 01
    .db 24
    .db A0
    .db A0
    .db A0
    .db D4
    .db EF
    .db A0
    .db F7
    .db E8
    .db E9
    .db E3
    .db E8
    .db A2
    .db A0
    .db A0
    .db 25
    .db 00
    .db FB
    .db 22
    .db FC
    .db 0E
    .db FD
    .db 00
    .db 20 ; Packet 0x00. Space
    .db 03 ; 'C'
    .db 01
    .db A0
    .db 01
    .db A0
    .db DB ; Box top left.
    .db DC ; Box straight.
    .db FE ; Box straight short.
    .db 23
    .db 78
    .db 77
    .db 00
    .db 08
    .db CC
    .db F6
    .db EC
    .db 23
    .db 50
    .db 77
    .db 01
    .db 02
    .db 22
    .db DC
    .db 07
    .db DD
    .db 01
    .db 04
    .db 71
    .db 61
    .db 20 ; Packet start.
    .db 03
    .db 07
    .db A0
    .db 01
    .db A0
    .db DB
    .db DC
    .db FE
    .db 23
    .db 78
    .db 7A
    .db 00
    .db 08
    .db CC
    .db F6
    .db EC
    .db 23
    .db 50
    .db 7A
    .db 01
    .db 02
    .db 22
    .db DC
    .db 07
    .db DD
    .db 01
    .db 04
    .db 71
    .db 61
    .db 20 ; Packet start.
    .db 03
    .db 0D
    .db A0
    .db 01
    .db A0
    .db DB
    .db DC
    .db FE
    .db 23
    .db 78
    .db 7D
    .db 00
    .db 08
    .db CC
    .db F6
    .db EC
    .db 23
    .db 50
    .db 7D
    .db 01
    .db 02
    .db 22
    .db DC
    .db 07
    .db DD
    .db 01
    .db A0
    .db 24
    .db A0
    .db C3
    .db EF
    .db EE
    .db F4
    .db E9
    .db EE
    .db F5
    .db E5
    .db A0
    .db A0
    .db C3
    .db EF
    .db F0
    .db F9
    .db A0
    .db C5
    .db F2
    .db E1
    .db F3
    .db E5
    .db A0
    .db 25
    .db 00
    .db A0
    .db FB
    .db 22
    .db FC
    .db 16
    .db FD
    .db 00
    .db 20 ; Packet start.
    .db 03
    .db 01
    .db A0
    .db 01
    .db A0
    .db DB
    .db DC
    .db FE
    .db C7
    .db C1
    .db CD
    .db C5
    .db A8
    .db B1
    .db A9
    .db 22
    .db DC
    .db 0D
    .db DD
    .db 01
    .db 04
    .db D7
    .db 61
    .db 20 ; Packet start.
    .db 03
    .db 07
    .db A0
    .db 01
    .db A0
    .db DB
    .db DC
    .db FE
    .db C7
    .db C1
    .db CD
    .db C5
    .db A8
    .db B2
    .db A9
    .db 22
    .db DC
    .db 0D
    .db DD
    .db 01
    .db 04
    .db D7
    .db 61
    .db 20 ; Packet start.
    .db 03
    .db 0D
    .db A0
    .db 01
    .db A0
    .db DB
    .db DC
    .db FE
    .db C7
    .db C1
    .db CD
    .db C5
    .db A8
    .db B3
    .db A9
    .db 22
    .db DC
    .db 0D
    .db DD
    .db 01
    .db A0
    .db 24
    .db 22
    .db A0
    .db 06
    .db D3
    .db F4
    .db E1
    .db F2
    .db F4
    .db A0
    .db F5
    .db F0
    .db 22
    .db A0
    .db 08
    .db 25
    .db 00
    .db A0
    .db FB
    .db 22
    .db FC
    .db 16
    .db FD
    .db 00
    .db 01 ; Packet start.
    .db 03
    .db 00
    .db 06
    .db C0
    .db 3A
    .db 03
    .db 04
    .db 2C
    .db 62
    .db 01 ; Packet start.
    .db 03
    .db 00
    .db 06
    .db C0
    .db 3A
    .db 03
    .db 04
    .db 2F
    .db 62
    .db 01 ; Packet start.
    .db 03
    .db 00
    .db 06
    .db C0
    .db 3A
    .db 03
    .db 04
    .db 32
    .db 62
    .db 04 ; Packet start.
    .db 03
    .db 05
    .db 06
    .db 80
    .db 3A
    .db 05
    .db 05
    .db 84
    .db 05
    .db 02 ; Packet start.
    .db 01
    .db 05
    .db 00
    .db 80
    .db 3A
    .db 0B
    .db 1A
    .db 2A
    .db 62
    .db 80
    .db 00
    .db 81
    .db 82
    .db 00
    .db 83
    .db 00
    .db 00
    .db 01
    .db 02
    .db 00
    .db 03
    .db 05
    .db 01
    .db 00
    .db 05
    .db 01
    .db 03
    .db 00
    .db 60
    .db 00
    .db 7C
    .db 7D
    .db 7E
    .db 7F
    .db 0F
    .db 0F
    .db 30
    .db 30
    .db 0F
    .db 3A
    .db 10
    .db 20
    .db 0F
    .db 3A
    .db 25
    .db 1A
    .db 0F
    .db 3A
    .db 30
    .db 12
    .db 0F
    .db 0F
    .db 00
    .db 30
    .db 0F
    .db 0F
    .db 16
    .db 37
    .db 0F
    .db 0F
    .db 24
    .db 37
    .db 0F
    .db 0F
    .db 12
    .db 37
WRAM_ARRAY_IDK: ; 19:1A5B, 0x033A5B
    LDA #$04 ; Set ??
    STA OBJ?_BYTE_0x0_STATUS?,Y
    LDA SAVE_GAME_MOD_PAGE_PTR[2] ; Move ??
    STA OBJ?_BYTE_0x1_UNK,Y
    LDA BCD/MODULO/DIGITS_USE_C ; Move ??
    STA OBJ?_BYTE_0x2_UNK,Y
    LDA BCD/MODULO/DIGITS_USE_D ; Move ??
    STA OBJ?_BYTE_0x3_UNK,Y
    LDA #$00
    STA OBJ?_BYTE_0x4_UNK,Y ; Clear.
    STA OBJ?_BYTE_0x5_BYTE,Y
    LDA BCD/MODULO/DIGITS_USE_A ; Move ??
    STA OBJ?_PTR?[2],Y
    LDA BCD/MODULO/DIGITS_USE_B ; Move ??
    STA OBJ?_PTR?+1,Y
    LDA #$01
    STA NMI_FLAG_EXECUTE_UPDATE_BUF ; Set ??
    RTS ; Leave.
WRAM_SET_UNK: ; 19:1A86, 0x033A86
    LDA #$50
    STA BCD/MODULO/DIGITS_USE_C ; Set ??
    LDA #$08
    STA BCD/MODULO/DIGITS_USE_D ; Set ??
    LDA #$00
    STA SAVE_GAME_MOD_PAGE_PTR[2] ; Clear ??
    LDA #$10
    STA BCD/MODULO/DIGITS_USE_A ; Set ??
    LDA #$80
    STA BCD/MODULO/DIGITS_USE_B ; Set ??
    RTS ; Leave.
UNK: ; 19:1A9B, 0x033A9B
    CLC ; Prep add.
    LDA BCD/MODULO/DIGITS_USE_A ; Load.
    ADC #$20 ; +=
    STA BCD/MODULO/DIGITS_USE_A ; Store.
    LDA BCD/MODULO/DIGITS_USE_B ; Load.
    ADC #$00 ; Carry add.
    STA BCD/MODULO/DIGITS_USE_B ; Leave.
    CLC ; Prep add.
    LDA BCD/MODULO/DIGITS_USE_D ; Load.
    ADC #$18 ; Add 
    STA BCD/MODULO/DIGITS_USE_D ; Store back.
    CLC ; Prep add.
    TYA ; Y to A.
    ADC #$08 ; += 0x8.
    TAY ; Back to Y.
    RTS ; Leave.
MOD_SAVE_PAGE_PTR_AND_UNK: ; 19:1AB5, 0x033AB5
    CLC ; Prep add.
    LDA SAVE_GAME_MOD_PAGE_PTR[2] ; Load.
    ADC #$10 ; Add += 0x10
    STA SAVE_GAME_MOD_PAGE_PTR[2] ; Store.
    LDA SAVE_GAME_MOD_PAGE_PTR+1 ; Load.
    ADC #$00 ; Carry add.
    STA SAVE_GAME_MOD_PAGE_PTR+1 ; Store.
    CLC ; Prep add.
    LDA BCD/MODULO/DIGITS_USE_D ; Load.
    ADC #$02 ; += 0x2
    STA BCD/MODULO/DIGITS_USE_D ; Store.
    RTS ; Leave.
    .db 10
    .db 80
    .db 03
    .db 63
    .db 78
    .db 74
    .db 30
    .db 80
    .db 1C
    .db 63
    .db B8
    .db 74
    .db 50
    .db 80
    .db 36
    .db 63
    .db F8
    .db 74
    .db 70
    .db 80
    .db 4D
    .db 63
    .db 38
    .db 75
    .db 00
    .db 00
    .db 63
    .db 63
    .db 89
    .db 76
    .db 10
    .db 06
    .db 01
    .db 02
    .db D0
    .db 01
    .db 08
    .db 0E
    .db 02
    .db 01
    .db 04
    .db 00
    .db 80
    .db 3A
    .db 0C
    .db 18
    .db FA
    .db 62
    .db 01
    .db 01
    .db 01
    .db 08
    .db 40
    .db 23
    .db C0
    .db FF
    .db 00
    .db D7
    .db E8
    .db E1
    .db F4
    .db A0
    .db E9
    .db F3
    .db A0
    .db F4
    .db E8
    .db E9
    .db F3
    .db 01
    .db E2
    .db EF
    .db F9
    .db A7
    .db F3
    .db A0
    .db EE
    .db E1
    .db ED
    .db E5
    .db A2
    .db 00
    .db D7
    .db E8
    .db E1
    .db F4
    .db A0
    .db E9
    .db F3
    .db A0
    .db F4
    .db E8
    .db E9
    .db F3
    .db 01
    .db E7
    .db E9
    .db F2
    .db EC
    .db A7
    .db F3
    .db A0
    .db EE
    .db E1
    .db ED
    .db E5
    .db A2
    .db 00
    .db D4
    .db E8
    .db E9
    .db F3
    .db A0
    .db EF
    .db F4
    .db E8
    .db E5
    .db F2
    .db 01
    .db E2
    .db EF
    .db F9
    .db A7
    .db F3
    .db A0
    .db EE
    .db E1
    .db ED
    .db E5
    .db A2
    .db 00
    .db D4
    .db E8
    .db E9
    .db F3
    .db A0
    .db EC
    .db E1
    .db F3
    .db F4
    .db 01
    .db E2
    .db EF
    .db F9
    .db A7
    .db F3
    .db A0
    .db EE
    .db E1
    .db ED
    .db E5
    .db A2
    .db 00
    .db D7
    .db E8
    .db E1
    .db F4
    .db A0
    .db E9
    .db F3
    .db A0
    .db F9
    .db EF
    .db F5
    .db F2
    .db 01
    .db E6
    .db E1
    .db F6
    .db EF
    .db F2
    .db E9
    .db F4
    .db E5
    .db A0
    .db E6
    .db EF
    .db EF
    .db E4
    .db A2
    .db 00
    .db D0
    .db EC
    .db E5
    .db E1
    .db F3
    .db E5
    .db A0
    .db E3
    .db E8
    .db E1
    .db EE
    .db E7
    .db E5
    .db 01
    .db F4
    .db E8
    .db E9
    .db F3
    .db A0
    .db EE
    .db E1
    .db ED
    .db E5
    .db AE
    .db 00
    .db C1
    .db A0
    .db E3
    .db E8
    .db E1
    .db F2
    .db E1
    .db E3
    .db F4
    .db E5
    .db F2
    .db A0
    .db E9
    .db EE
    .db A0
    .db 01
    .db F4
    .db E8
    .db E9
    .db F3
    .db A0
    .db E7
    .db E1
    .db ED
    .db E5
    .db A0
    .db E8
    .db E1
    .db F3
    .db A0
    .db A0
    .db 01
    .db F4
    .db E8
    .db E1
    .db F4
    .db A0
    .db EE
    .db E1
    .db ED
    .db E5
    .db AE
    .db A0
    .db D4
    .db F2
    .db F9
    .db A0
    .db 01
    .db E1
    .db E7
    .db E1
    .db E9
    .db EE
    .db AC
    .db A0
    .db E1
    .db EE
    .db E4
    .db A0
    .db F5
    .db F3
    .db E5
    .db A0
    .db 01
    .db EF
    .db EE
    .db EC
    .db F9
    .db A0
    .db E3
    .db E1
    .db F0
    .db E9
    .db F4
    .db E1
    .db EC
    .db A0
    .db A0
    .db A0
    .db 01
    .db EC
    .db E5
    .db F4
    .db F4
    .db E5
    .db F2
    .db F3
    .db AE
    .db A0
    .db A0
    .db A0
    .db A0
    .db A0
    .db A0
    .db A0
    .db 00
    .db CD
    .db E1
    .db F2
    .db F9
    .db A2
    .db 01
    .db D3
    .db F5
    .db FA
    .db F9
    .db A2
    .db 01
    .db C7
    .db E5
    .db EF
    .db F2
    .db E7
    .db E5
    .db A2
    .db 01
    .db CD
    .db E1
    .db F2
    .db E9
    .db E1
    .db A2
    .db 01
    .db CD
    .db E9
    .db ED
    .db ED
    .db E9
    .db E5
    .db A2
    .db 01
    .db CD
    .db E9
    .db EE
    .db EE
    .db E9
    .db E5
    .db A2
    .db 01
    .db D0
    .db E9
    .db F0
    .db F0
    .db E9
    .db A2
    .db 01
    .db C4
    .db F5
    .db EE
    .db E3
    .db E1
    .db EE
    .db A2
    .db 01
    .db CC
    .db E1
    .db F5
    .db F2
    .db E1
    .db A2
    .db 01
    .db C7
    .db E9
    .db E5
    .db E7
    .db F5
    .db E5
    .db A2
    .db 01
    .db C1
    .db E2
    .db E2
    .db EF
    .db F4
    .db F4
    .db A2
    .db 01
    .db CE
    .db E1
    .db EE
    .db E3
    .db F9
    .db A2
    .db 01
    .db D5
    .db EC
    .db EC
    .db F2
    .db E9
    .db E3
    .db E8
    .db 01
    .db D7
    .db E1
    .db EC
    .db EC
    .db F9
    .db A2
    .db 01
    .db CB
    .db E5
    .db EC
    .db EC
    .db F9
    .db A2
    .db 01
    .db CA
    .db F5
    .db E1
    .db EE
    .db E1
    .db A2
    .db 01
    .db A0
    .db 01
    .db 00
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
    .db 00
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
    .db 00
    .db E1
    .db E2
    .db E3
    .db E4
    .db E5
    .db E6
    .db E7
    .db A0
    .db E8
    .db E9
    .db EA
    .db EB
    .db EC
    .db ED
    .db EE
    .db 00
    .db EF
    .db F0
    .db F1
    .db F2
    .db F3
    .db F4
    .db F5
    .db A0
    .db F6
    .db F7
    .db F8
    .db F9
    .db FA
    .db AD
    .db AA
    .db 00
    .db 00
    .db 00
    .db A1
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db A2
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db A3
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db C9
    .db EE
    .db A0
    .db F4
    .db E8
    .db E5
    .db A0
    .db E5
    .db E1
    .db F2
    .db EC
    .db F9
    .db A0
    .db B1
    .db B9
    .db B0
    .db B0
    .db A7
    .db F3
    .db AC
    .db A0
    .db E1
    .db A0
    .db E4
    .db E1
    .db F2
    .db EB
    .db 01
    .db F3
    .db E8
    .db E1
    .db E4
    .db EF
    .db F7
    .db A0
    .db E3
    .db EF
    .db F6
    .db E5
    .db F2
    .db E5
    .db E4
    .db A0
    .db E1
    .db A0
    .db F3
    .db ED
    .db E1
    .db EC
    .db EC
    .db 01
    .db E3
    .db EF
    .db F5
    .db EE
    .db F4
    .db F2
    .db F9
    .db A0
    .db F4
    .db EF
    .db F7
    .db EE
    .db A0
    .db E9
    .db EE
    .db A0
    .db F2
    .db F5
    .db F2
    .db E1
    .db EC
    .db 01
    .db C1
    .db ED
    .db E5
    .db F2
    .db E9
    .db E3
    .db E1
    .db AE
    .db A0
    .db A0
    .db C1
    .db F4
    .db A0
    .db F4
    .db E8
    .db E1
    .db F4
    .db A0
    .db F4
    .db E9
    .db ED
    .db E5
    .db AC
    .db A0
    .db E1
    .db 01
    .db F9
    .db EF
    .db F5
    .db EE
    .db E7
    .db A0
    .db ED
    .db E1
    .db F2
    .db F2
    .db E9
    .db E5
    .db E4
    .db A0
    .db E3
    .db EF
    .db F5
    .db F0
    .db EC
    .db E5
    .db 01
    .db F6
    .db E1
    .db EE
    .db E9
    .db F3
    .db E8
    .db E5
    .db E4
    .db A0
    .db ED
    .db F9
    .db F3
    .db F4
    .db E5
    .db F2
    .db E9
    .db EF
    .db F5
    .db F3
    .db EC
    .db F9
    .db A0
    .db E6
    .db F2
    .db EF
    .db ED
    .db 01
    .db F4
    .db E8
    .db E5
    .db E9
    .db F2
    .db A0
    .db E8
    .db EF
    .db ED
    .db E5
    .db AE
    .db 01
    .db A0
    .db 01
    .db D4
    .db E8
    .db E5
    .db A0
    .db ED
    .db E1
    .db EE
    .db A7
    .db F3
    .db A0
    .db EE
    .db E1
    .db ED
    .db E5
    .db A0
    .db F7
    .db E1
    .db F3
    .db A0
    .db C7
    .db E5
    .db EF
    .db F2
    .db E7
    .db E5
    .db AC
    .db 01
    .db F4
    .db E8
    .db E5
    .db A0
    .db F7
    .db EF
    .db ED
    .db E1
    .db EE
    .db A7
    .db F3
    .db A0
    .db EE
    .db E1
    .db ED
    .db E5
    .db A0
    .db F7
    .db E1
    .db F3
    .db A0
    .db CD
    .db E1
    .db F2
    .db E9
    .db E1
    .db AE
    .db 01
    .db A0
    .db 01
    .db D4
    .db F7
    .db EF
    .db A0
    .db F9
    .db E5
    .db E1
    .db F2
    .db F3
    .db A0
    .db EC
    .db E1
    .db F4
    .db E5
    .db F2
    .db AC
    .db A0
    .db E1
    .db F3
    .db A0
    .db F3
    .db F5
    .db E4
    .db E4
    .db E5
    .db EE
    .db EC
    .db F9
    .db 01
    .db E1
    .db F3
    .db A0
    .db E8
    .db E5
    .db A0
    .db EC
    .db E5
    .db E6
    .db F4
    .db AC
    .db A0
    .db C7
    .db E5
    .db EF
    .db F2
    .db E7
    .db E5
    .db A0
    .db F2
    .db E5
    .db F4
    .db F5
    .db F2
    .db EE
    .db E5
    .db E4
    .db AE
    .db 01
    .db C8
    .db E5
    .db A0
    .db EE
    .db E5
    .db F6
    .db E5
    .db F2
    .db A0
    .db F4
    .db EF
    .db EC
    .db E4
    .db A0
    .db E1
    .db EE
    .db F9
    .db EF
    .db EE
    .db E5
    .db A0
    .db F7
    .db E8
    .db E5
    .db F2
    .db E5
    .db 01
    .db E8
    .db E5
    .db A0
    .db E8
    .db E1
    .db E4
    .db A0
    .db E2
    .db E5
    .db E5
    .db EE
    .db A0
    .db EF
    .db F2
    .db A0
    .db F7
    .db E8
    .db E1
    .db F4
    .db A0
    .db E8
    .db E5
    .db A0
    .db E8
    .db E1
    .db E4
    .db 01
    .db E4
    .db EF
    .db EE
    .db E5
    .db AE
    .db A0
    .db A0
    .db C2
    .db F5
    .db F4
    .db AC
    .db A0
    .db E8
    .db E5
    .db A0
    .db E2
    .db E5
    .db E7
    .db E1
    .db EE
    .db A0
    .db E1
    .db EE
    .db A0
    .db EF
    .db E4
    .db E4
    .db 01
    .db F3
    .db F4
    .db F5
    .db E4
    .db F9
    .db AC
    .db A0
    .db E1
    .db EC
    .db EC
    .db A0
    .db E2
    .db F9
    .db A0
    .db E8
    .db E9
    .db ED
    .db F3
    .db E5
    .db EC
    .db E6
    .db AE
    .db 01
    .db A0
    .db 01
    .db C1
    .db F3
    .db A0
    .db E6
    .db EF
    .db F2
    .db A0
    .db CD
    .db E1
    .db F2
    .db E9
    .db E1
    .db AC
    .db A0
    .db E8
    .db E9
    .db F3
    .db A0
    .db F7
    .db E9
    .db E6
    .db E5
    .db AE
    .db AE
    .db AE
    .db 01
    .db D3
    .db E8
    .db E5
    .db A0
    .db EE
    .db E5
    .db F6
    .db E5
    .db F2
    .db A0
    .db F2
    .db E5
    .db F4
    .db F5
    .db F2
    .db EE
    .db E5
    .db E4
    .db AE
    .db 00
    .db B8
    .db B0
    .db A0
    .db F9
    .db E5
    .db E1
    .db F2
    .db F3
    .db A0
    .db E8
    .db E1
    .db F6
    .db E5
    .db A0
    .db F0
    .db E1
    .db F3
    .db F3
    .db E5
    .db E4
    .db 01
    .db A0
    .db 01
    .db F3
    .db E9
    .db EE
    .db E3
    .db E5
    .db A0
    .db F4
    .db E8
    .db E5
    .db EE
    .db AE
    .db 00 ; End of WRAM copy.
    .db FF ; Unused here to end.
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
