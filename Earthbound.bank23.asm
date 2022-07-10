SUB_CLEAR_MANY_UNK: ; 17:0000, 0x02E000
    LDA #$00
    STA CONTROL_ACCUMULATED?[2] ; Clear CTRL's.
    STA CONTROL_ACCUMULATED?+1
    STA SCRIPT?_UNK_0x52 ; Clear tons more.
    STA SCRIPT_BATTLE_UNK_0x59
    STA TRIO_FILE_OFFSET_UNK[3]
    STA TRIO_FILE_OFFSET_UNK+1
    STA TRIO_FILE_OFFSET_UNK+2
    STA SCRIPT_BATTLE_ACCUMULATOR_UNSIGNED_INT_UNK[2]
    STA SCRIPT_BATTLE_ACCUMULATOR_UNSIGNED_INT_UNK+1
    TAX ; X = 0
INDEX_NONZERO: ; 17:0015, 0x02E015
    STA SCRIPT_PARTY_ATTRIBUTES[32],X ; Clear arr.
    INX ; Index++
    BNE INDEX_NONZERO ; != 0, goto.
    LDX #$1F ; Seed index.
VAL_POSITIVE: ; 17:001D, 0x02E01D
    STA CHARACTER_NAMES_ARR[8],X ; Clear.
    DEX ; Index--
    BPL VAL_POSITIVE ; Positive, goto.
    LDA #$00
    STA SCRIPT_BATTLE_PARTY_ID_FOCUS ; Clear ??
    LDX #$00 ; Reset index.
VAL_NE_0x4: ; 17:0029, 0x02E029
    TXA ; X index to A.
    PHA ; Save index to stack.
    LDA WRAM_ARR_PARTY_CHARACTER_IDS?[6],X ; Load.
    BEQ VAL_EQ_0x00 ; == 0, goto.
    JSR SUB _TODO_PTR_AND_ARRS_IDFK ; Do ??
    CLC ; Prep add.
    LDA SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load val.
    ADC #$20 ; += 0x20
    STA SCRIPT_BATTLE_PARTY_ID_FOCUS ; Store back.
VAL_EQ_0x00: ; 17:003A, 0x02E03A
    PLA ; Pull stack.
    TAX ; To X.
    INX ; ++
    CPX #$04 ; If _ #$04
    BNE VAL_NE_0x4 ; != 0, goto.
    JSR LIB_VAL_TO_DECIMAL_AND_FILE? ; Do.
    LDA #$80
    STA SCRIPT_BATTLE_PARTY_ID_FOCUS ; Set ?
    LDY #$00 ; Stream index.
STREAM_NE_0x8: ; 17:004A, 0x02E04A
    LDA [BATTLE_PARTY_FPTR_DATA_TODO[2]],Y ; Move from file.
    STA LIB_BCD/EXTRA_FILE_BCD_A
    INY ; Stream++
    LDA [BATTLE_PARTY_FPTR_DATA_TODO[2]],Y
    STA LIB_BCD/EXTRA_FILE_BCD_B
    INY ; Stream++
    TYA ; Stream to A.
    PHA ; Save it.
    LDA LIB_BCD/EXTRA_FILE_BCD_A ; Load moved.
    CMP #$FF ; If _ #$FF
    BEQ VAL_EQ_0xFF ; ==, goto.
    JSR SUB_UNK_PTRS_ARR_UNK ; Do ??
VAL_EQ_0xFF: ; 17:005F, 0x02E05F
    CLC ; Prep add.
    LDA SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load.
    ADC #$20 ; += 0x20
    STA SCRIPT_BATTLE_PARTY_ID_FOCUS ; Store result.
    PLA ; Pull A.
    TAY ; Back to stream.
    CPY #$08 ; If _ #$08
    BNE STREAM_NE_0x8 ; !=, goto.
    LDA [BATTLE_PARTY_FPTR_DATA_TODO[2]],Y ; Load from stream.
    AND #$E0 ; Keep 1110.0000
    LDX #$05 ; Shift count.
SHIFT_LOOP: ; 17:0072, 0x02E072
    LSR A ; >> 1, /2.
    DEX ; X--
    BNE SHIFT_LOOP ; != 0, loop shift.
    STA 56_OBJECT_NAME_SIZE? ; Store to. Not name size here.
    LDA [BATTLE_PARTY_FPTR_DATA_TODO[2]],Y ; Load from file.
    AND #$1F ; Keep 0001.1111
    STA FLAG_SPRITE_OFF_SCREEN_UNK ; Store to.
    INY ; Stream++
    LDA [BATTLE_PARTY_FPTR_DATA_TODO[2]],Y ; Load from file.
    AND #$0F ; Keep lower.
    STA LIB_BCD/EXTRA_FILE_BCD_A ; Store to.
    LDA #$00 ; Seed clear.
    LDX #$05 ; Shift count.
COUNT_NONZERO: ; 17:0089, 0x02E089
    ASL LIB_BCD/EXTRA_FILE_BCD_A ; << 1, *2.
    ROL A ; Into A.
    DEX ; Count--
    BNE COUNT_NONZERO ; != 0, loop more shifts.
    STA LIB_BCD/EXTRA_FILE_BCD_B ; Store result.
    CLC ; Prep add.
    LDA #$81 ; Load base. TODO: Base/range.
    ADC LIB_BCD/EXTRA_FILE_BCD_A ; Add with.
    STA LIB_BCD/EXTRA_FILE_BCD_A ; Store result.
    LDA #$8E ; Load base.
    ADC LIB_BCD/EXTRA_FILE_BCD_B ; Add with val.
    STA LIB_BCD/EXTRA_FILE_BCD_B ; Store result.
    JSR ENGINE_SCRIPT_HELP_MAPPER_R6_TO_0x00 ; Do.
    JSR ENGINE_SET_PALETTE_AND_QUEUE_UPLOAD ; Do.
    JSR ENGINE_SET_MAPPER_R6_TO_0x16 ; Set R6 to 0x16.
    LDX #$23
    LDY #$C0 ; PPU PTR, attributes.
    JSR PPU_PACKET_SET_VAL_0xFF_COUNT_0x40_PPU_ADDR_XY ; Clear attrs.
    LDX #$2B
    LDY #$C0
    JSR PPU_PACKET_SET_VAL_0xFF_COUNT_0x40_PPU_ADDR_XY ; For both.
    JSR LIB_SCRIPT_HELPER_CREATE_DISPLAY_PACKET_HELPER ; Do ??
    LDA #$00
    STA SCRIPT_UNK_BATTLE?_OBJECT_ID_FOCUSED? ; Clear ??
    LDA #$80
    STA SCRIPT_BATTLE_PARTY_ID_FOCUS ; Set ??
LOOP_CC: ; 17:00C0, 0x02E0C0
    LDX SCRIPT_BATTLE_PARTY_ID_FOCUS ; Index from.
    LDA SCRIPT_PARTY_ATTRIBUTES[32],X ; Load from arr.
    BEQ INDEX_EQ_0x00 ; == 0, goto.
    JSR SUB_IDFK ; Nonzero, do.
INDEX_EQ_0x00: ; 17:00CA, 0x02E0CA
    INC SCRIPT_UNK_BATTLE?_OBJECT_ID_FOCUSED? ; ++ ??
    CLC ; Prep add.
    LDA SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load ??
    ADC #$20 ; += 0x20
    STA SCRIPT_BATTLE_PARTY_ID_FOCUS ; Store back.
    BCC LOOP_CC ; No overflow, goto.
    LDY #$00 ; Clear index.
    LDX #$00 ; Clear count.
X_NE_0x8: ; 17:00D9, 0x02E0D9
    LDA CHARACTER_NAMES_ARR[8],Y ; Load from Y.
    INY ; ++
    ORA CHARACTER_NAMES_ARR[8],Y ; Combine with other.
    STA LIB_BCD/EXTRA_FILE_BCD_A ; Store to.
    INY ; ++
    LDA CHARACTER_NAMES_ARR[8],Y ; Load from Y.
    INY ; ++
    ORA CHARACTER_NAMES_ARR[8],Y ; Combine with other.
    ASL A ; << 2, *4.
    ASL A
    ORA LIB_BCD/EXTRA_FILE_BCD_A ; Combine with other.
    STA LIB_BCD/EXTRA_FILE_BCD_A ; Store to.
    ASL A ; << 4, *16.
    ASL A
    ASL A
    ASL A
    ORA LIB_BCD/EXTRA_FILE_BCD_A ; Combine with.
    STA CHARACTER_NAMES_ARR[8],X ; Store to X.
    INY ; Y++
    INX ; X++
    CPX #$08 ; If _ #$08
    BNE X_NE_0x8 ; != 0, loop.
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle engine.
    LDA #$05
    STA NMI_PPU_CMD_PACKETS_BUF[69] ; Make packet, +1 unique.
    LDA #$10
    STA NMI_PPU_CMD_PACKETS_BUF+1 ; Set count, 0x1 groups of 0x8
    LDY #$00 ; Array index.
    LDX #$04 ; Update buf index.
ARR_LT_0x8: ; 17:0110, 0x02E110
    LDA CHARACTER_NAMES_ARR[8],Y ; Move from array.
    STA NMI_PPU_CMD_PACKETS_BUF[69],X ; To update buf.
    STA NMI_PPU_CMD_PACKETS_BUF+8,X ; Making 2 packets.
    INY ; Indexes++
    INX
    CPY #$08 ; If _ #$08
    BNE ARR_LT_0x8 ; !=, goto.
    LDA #$00
    STA NMI_PPU_CMD_PACKETS_BUF+8,X ; EOF for packet A.
    LDA #$80
    STA NMI_FLAG_EXECUTE_UPDATE_BUF_AND_MORE_TODO ; Set flag to do.
    LDA #$23
    STA NMI_PPU_CMD_PACKETS_BUF+2 ; Set addr, $23D8, attrs.
    LDA #$D8
    STA NMI_PPU_CMD_PACKETS_BUF+3
    LDA #$00
    STA NMI_PPU_CMD_PACKETS_INDEX ; Clear TODO better.
    LDA #$00
    STA STREAM_REPLACE_COUNT?_TODO_BETTER ; Clear TODO better.
    STA SCRIPT_OVERWORLD_BATTLE_ENCOUNTER? ; Clear flag ??
    LDX #$80 ; Seed ??
INDEX_NONZERO_LOOP: ; 17:013E, 0x02E13E
    TXA ; X to A.
    PHA ; Save seeded.
    LDY #$04 ; Index ??
COUNT_NONZERO: ; 17:0142, 0x02E142
    LDA SCRIPT_PARTY_ATTRIBUTES+4,X ; Load ??
    AND #$03 ; Keep lower.
    STA SCRIPT_PARTY_ATTRIBUTES+4,X ; Store back.
    INX ; Index += 2
    INX
    DEY ; Count--
    BNE COUNT_NONZERO ; != 0, loop.
    PLA ; Pull pushed.
    CLC ; Pprep add.
    ADC #$20 ; Add val.
    TAX ; To X.
    BNE INDEX_NONZERO_LOOP ; != 0, goto.
    LDX #$00 ; Seed val stored. ??
    LDA 56_OBJECT_NAME_SIZE? ; Load ??
    CMP #$01 ; If _ #$01
    BNE A_NE_0x1 ; !=, goto.
    LDX #$04 ; Val stored.
    LDA #$FF
    STA R_**:$0683 ; Set ??
    STA R_**:$0684
    LDA #$00
    STA **:$0620 ; Clear ??
    STA **:$0640
    STA R_**:$0660 ; Clear ??
A_NE_0x1: ; 17:0173, 0x02E173
    STX SCRIPT_UNK_BATTLE?_OBJECT_ID_FOCUSED? ; X to.
    LDA FLAG_UNK_23 ; Load ??
    BEQ VAL_EQ_0x00 ; == 0, goto.
    LDY #$00 ; Index reset.
    STY 56_OBJECT_NAME_SIZE? ; Clear ??
NO_OVERFLOW_LOOP: ; 17:017D, 0x02E17D
    LDA SCRIPT_PARTY_ATTRIBUTES+30,Y ; Load.
    ORA #$04 ; Set.
    STA SCRIPT_PARTY_ATTRIBUTES+30,Y ; Store back.
    TYA ; To A.
    CLC ; Prep add.
    ADC #$20 ; Add ??
    TAY ; To Y index.
    BPL NO_OVERFLOW_LOOP ; Positive, goto.
VAL_EQ_0x00: ; 17:018C, 0x02E18C
    LDA 56_OBJECT_NAME_SIZE? ; Load ??
    CMP #$05 ; If _ #$05
    BNE VAL_NONZERO ; != 0, goto.
    LDA #$96
    STA 57_INDEX_UNK ; Set ??
    LDA SCRIPT_PARTY_ATTRIBUTES+12 ; Move ??
    STA R_**:$068C
VAL_NONZERO: ; 17:019C, 0x02E19C
    LDX #$14
    JSR ENGINE_WAIT_X_SETTLES ; Wait.
    JSR LIB_SETUP_RAM_JMP_ABS ; Setup.
ENTRY_UNK: ; 17:01A4, 0x02E1A4
    LDA #$00 ; Seed ??
    JSR LIB_BANK_0_FILES_COORDS_BATTLE_MENU?_UNK ; Do a lot with state and updates/restore, special.
    JSR SUB_TODO
    BCS NO_RAM_JUMP_AND_CLEAR_CTRL_BUTTONS ; CS, goto.
    LDX #$14
    JSR ENGINE_WAIT_X_SETTLES ; Settle.
    LDA #$07 ; Seed ??
    JSR LIB_BANK_0_FILES_COORDS_BATTLE_MENU?_UNK ; Lib ??
    LDA #$00
    STA SCRIPT?_UNK_0x52 ; Clear ??
    JSR SEED_SETTLE_0x4_BIT_TRICKED
    JSR CLEAR_FLAG_OFFSCREEN ; Clear.
    JSR SUB_UNK ; Do sub ??
    JSR SET_FLAG_OFFSCREEN ; Flag.
    LDA #$03 ; Seed ??
    JSR LIB_BANK_0_FILES_COORDS_BATTLE_MENU?_UNK ; Lib ??
    JSR SEED_SETTLE_0xFC_BIT_TRICKY ; Do ??
    JMP ENTRY_UNK ; Goto.
NO_RAM_JUMP_AND_CLEAR_CTRL_BUTTONS: ; 17:01D3, 0x02E1D3
    JSR RAM_JMP_DISABLE ; Disable.
    LDA #$00
    STA CONTROL_ACCUMULATED?[2] ; Clear controller.
    STA CONTROL_ACCUMULATED?+1
    RTS ; Leave.
SUB _TODO_PTR_AND_ARRS_IDFK: ; 17:01DD, 0x02E1DD
    STA LIB_BCD2/EXTRA_FILE_STREAM_INDEX ; Store val.
    TAX ; To X.
    LDA #$00 ; Seed ptr 0x7400
    STA LIB_BCD/EXTRA_FILE_BCD_A
    LDA #$74
    STA LIB_BCD/EXTRA_FILE_BCD_B
VAL_NONZERO: ; 17:01E8, 0x02E1E8
    CLC ; Prep add.
    LDA LIB_BCD/EXTRA_FILE_BCD_A ; Load ??
    ADC #$40 ; Add with.
    STA LIB_BCD/EXTRA_FILE_BCD_A ; Store to.
    LDA LIB_BCD/EXTRA_FILE_BCD_B ; Load ??
    ADC #$00 ; Carry add.
    STA LIB_BCD/EXTRA_FILE_BCD_B ; Store to.
    DEX ; Index--
    BNE VAL_NONZERO ; != 0, goto.
    LDY #$01 ; Seed file index ??
    LDX SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load index.
VAL_NE_0x10: ; 17:01FC, 0x02E1FC
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y ; Load from file, save page.
    STA SCRIPT_PARTY_ATTRIBUTES+1,X ; Store to ??
    INY ; Stream++
    INX ; Index++
    CPY #$10 ; If _ #$10
    BNE VAL_NE_0x10 ; !=, goto.
    LDY #$14 ; Stream index.
    LDX SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load index ??
VAL_NE_0x18: ; 17:020B, 0x02E20B
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y ; Load from file.
    STA SCRIPT_PARTY_ATTRIBUTES+3,X ; Store to ??
    INX ; Index++
    INY ; Stream++
    CPY #$18 ; If _ #$18
    BNE VAL_NE_0x18 ; !=, goto.
    LDX SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load index.
    LDA #$FF ; Move ??
    STA SCRIPT_PARTY_ATTRIBUTES[32],X
    LDA LIB_BCD2/EXTRA_FILE_STREAM_INDEX ; Move ??
    STA SCRIPT_PARTY_ATTRIBUTES+17,X
    LDA LIB_BCD/EXTRA_FILE_BCD_A ; Move ??
    STA PARTY_ATTR_PTR[2],X
    LDA LIB_BCD/EXTRA_FILE_BCD_B ; Move ??
    STA PARTY_ATTR_PTR+1,X
    RTS ; Leave.
SUB_UNK_PTRS_ARR_UNK: ; 17:022D, 0x02E22D
    LDX SCRIPT_BATTLE_PARTY_ID_FOCUS ; X from.
    LDA LIB_BCD/EXTRA_FILE_BCD_B ; Load ??
    ASL A ; << 2, *4.
    ASL A
    STA SCRIPT_PARTY_ATTRIBUTES+26,X ; A to.
    LDA LIB_BCD/EXTRA_FILE_BCD_A ; Move from 0x60 to 0x62
    STA LIB_BCD2/EXTRA_FILE_STREAM_INDEX
    LDA #$00 ; Init.
    LDX #$05 ; Shifts to do.
X_NONZERO: ; 17:023E, 0x02E23E
    ASL LIB_BCD2/EXTRA_FILE_STREAM_INDEX ; << 1 var.
    ROL A ; Into A.
    DEX ; X--
    BNE X_NONZERO ; != 0, goto.
    STA LIB_BCD/EXTRA_FILE_D ; Store to.
    CLC ; Prep add.
    LDA #$00
    ADC LIB_BCD2/EXTRA_FILE_STREAM_INDEX ; += val.
    STA LIB_BCD2/EXTRA_FILE_STREAM_INDEX ; Store result, same.
    LDA #$80 ; Val adding.
    ADC LIB_BCD/EXTRA_FILE_D ; += val.
    STA LIB_BCD/EXTRA_FILE_D ; Store result.
    LDY #$01 ; Stream set.
    LDX SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load index.
STREAM_NE_0x18: ; 17:0257, 0x02E257
    LDA [LIB_BCD2/EXTRA_FILE_STREAM_INDEX],Y ; Load from file 62
    STA SCRIPT_PARTY_ATTRIBUTES+1,X ; Store to arr.
    INY ; Stream++
    INX ; Index++
    CPY #$18 ; If _ #$18
    BNE STREAM_NE_0x18 ; !=, goto.
    LDX SCRIPT_BATTLE_PARTY_ID_FOCUS ; X from.
    LDY SCRIPT_OVERWORLD_BATTLE_ENCOUNTER? ; Y from.
    INY ; Y++
    TYA ; To A.
    STA SCRIPT_PARTY_ATTRIBUTES[32],X ; Store to X index.
    LDA LIB_BCD2/EXTRA_FILE_STREAM_INDEX ; Move to arr.
    STA PARTY_ATTR_PTR[2],X
    LDA LIB_BCD/EXTRA_FILE_D ; Move both.
    STA PARTY_ATTR_PTR+1,X
    LDY #$5E ; Val ??
    LDA LIB_BCD/EXTRA_FILE_BCD_B ; Load ??
    BPL VAL_POSITIVE ; Positive, goto.
    LDA SCRIPT_PARTY_ATTRIBUTES+30,X ; Load ??
    ORA #$01 ; Set bit.
    STA SCRIPT_PARTY_ATTRIBUTES+30,X ; Store to.
    LDY #$00 ; Stream reset.
VAL_POSITIVE: ; 17:0285, 0x02E285
    TYA ; Val to A.
    STA SCRIPT_PARTY_ATTRIBUTES+29,X ; Store val.
    RTS ; Leave.
SUB_IDFK: ; 17:028A, 0x02E28A
    LDA SCRIPT_PARTY_ATTRIBUTES+30,X ; Load ??
    AND #$01 ; Keep lower.
    BEQ LOWER_CLEAR ; Clear, goto.
    LDA #$00
    STA SCRIPT_PARTY_ATTRIBUTES[32],X ; Clear ??
LOWER_CLEAR: ; 17:0296, 0x02E296
    LDA SCRIPT_PARTY_ATTRIBUTES+26,X ; Load ??
    ORA SCRIPT_UNK_BATTLE?_OBJECT_ID_FOCUSED? ; Or with.
    STA SCRIPT_PARTY_ATTRIBUTES+26,X ; Store back.
    LDA SCRIPT_PARTY_ATTRIBUTES+4,X ; Load ??
    AND #$F0 ; Nibble upper only.
    LSR A ; >> 3, /8. Word index based on upper.
    LSR A
    LSR A
    TAY ; To Y index.
    LDA $960A,Y ; TODO banked in? Move fptr.
    STA LIB_BCD/EXTRA_FILE_BCD_A
    LDA $960B,Y
    STA LIB_BCD/EXTRA_FILE_BCD_B
    LDA SCRIPT_PARTY_ATTRIBUTES+8,X ; Load ??
    AND #$E0 ; Keep 1110.0000
    LSR A ; >> 5, 32. Byte index.
    LSR A
    LSR A
    LSR A
    LSR A
    STA ALT_STUFF_COUNT? ; Store to.
    LDY #$00 ; Stream reset.
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y ; Load from file.
    STA LIB_BCD2/EXTRA_FILE_STREAM_INDEX ; Store to.
    INY ; Stream++
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y ; Load from file.
    STA LIB_BCD/EXTRA_FILE_D ; Store to.
    INY ; Stream++
    SEC ; Prep sub.
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y ; Load from file.
    SBC ALT_STUFF_COUNT? ; Sub with.
    TAY ; Count to Y.
    INY ; Add'l.
    LDA #$E0 ; Load ??
COUNT_NONZERO: ; 17:02D2, 0x02E2D2
    CLC ; Prep add.
    ADC #$20 ; Add with.
    DEY ; Count--
    BNE COUNT_NONZERO ; != 0, goto.
    STA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2] ; Store as page mod ptr.
    LDA FLAG_SPRITE_OFF_SCREEN_UNK ; Load val.
    ASL A ; << 2, *4.
    ASL A
    ADC SCRIPT_UNK_BATTLE?_OBJECT_ID_FOCUSED? ; Add with ??
    TAY ; To Y index.
    LDA $8F40,Y ; Load ?? todo banked in?? val??
    STA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER+1 ; Store as PTR H.
    LDA SCRIPT_PARTY_ATTRIBUTES+4,X ; Load ??
    AND #$0C ; Add with.
    LSR A ; >> 2, /4.
    LSR A
    LDY SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER+1 ; Stream index from.
    LDX #$00 ; Seed count.
INDEX_NOT_TO_TARGET: ; 17:02F1, 0x02E2F1
    STA CHARACTER_NAMES_ARR[8],Y ; Store to.
    INY ; Index++
    INX ; Count++
    CPX LIB_BCD/EXTRA_FILE_D ; If _ target
    BNE INDEX_NOT_TO_TARGET ; !=, goto.
    CLC ; Prep add.
    LDA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER+1 ; Load TODO check what is here.
    ADC SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2] ; Add with.
    ADC #$80 ; Add ??
    STA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2] ; Store to.
    LDA #$00 ; Seed ??
    ADC #$21 ; Add with.
    STA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER+1 ; Store to. Macroy.
    LDA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2] ; Load ??
    AND #$E0 ; Keep upper.
    STA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY[8] ; Store to ??
    LDA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER+1 ; Load ??
    AND #$03 ; Keep lower.
    LSR A ; >>
    ROR RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY[8] ; Rotate into.
    LSR A ; >> 
    ROR RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY[8] ; ROtate into.
    SEC ; Prep sub.
    LDA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY[8] ; Load ??
    SBC #$19 ; Sub with.
    STA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY[8] ; Store back.
    LDA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2] ; Load ??
    ASL A ; << 3, *8.
    ASL A
    ASL A
    SEC ; Prep sub.
    SBC #$10 ; Sub with.
    STA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY+1 ; Store to.
    LDX SCRIPT_UNK_BATTLE?_OBJECT_ID_FOCUSED? ; Load ??
    INX ; Index++
    LDA #$C0 ; Load base.
DO_COUNT: ; 17:032F, 0x02E32F
    CLC ; Prep add.
    ADC #$40 ; Add with.
    DEX ; Count--
    BNE DO_COUNT ; !=, goto.
    STA ALT_STUFF_COUNT? ; Store to.
    LDY #$02 ; Seed ??
COUNT_NONZERO_SETTLE_LOOP: ; 17:0339, 0x02E339
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle engine.
    LDX #$00 ; Seed index.
    LDA #$05 ; Type of update.
    STA NMI_PPU_CMD_PACKETS_BUF[69],X ; Store to.
    INX ; ++
    LDA LIB_BCD/EXTRA_FILE_D ; Move addr A. TODO h/l
    STA NMI_PPU_CMD_PACKETS_BUF[69],X
    STA ALT_COUNT_UNK
    INX ; Index++
    LDA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER+1 ; Move addr B.
    STA NMI_PPU_CMD_PACKETS_BUF[69],X
    INX ; Index++
    LDA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2] ; Load ??
    STA NMI_PPU_CMD_PACKETS_BUF[69],X ; Store to.
COUNT_NONZERO: ; 17:0357, 0x02E357
    INY ; Stream++
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y ; Load from stream.
    CLC ; Prep add.
    ADC ALT_STUFF_COUNT? ; Add with.
    INX ; Index++
    STA NMI_PPU_CMD_PACKETS_BUF[69],X ; Store to update packet.
    DEC ALT_COUNT_UNK ; Count--
    BNE COUNT_NONZERO ; != 0, goto.
    LDA #$00 ; Seed EOF.
    INX ; Index++
    STA NMI_PPU_CMD_PACKETS_BUF[69],X ; Store EOF.
    CLC ; Prep add.
    LDA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2] ; Load.
    ADC #$20 ; += 0x20
    STA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2] ; Store back.
    LDA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER+1 ; Load PTR H.
    ADC #$00 ; Carry add.
    STA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER+1 ; Store back.
    LDA #$00
    STA NMI_PPU_CMD_PACKETS_INDEX ; Reset index to trigger.
    LDA #$80
    STA NMI_FLAG_EXECUTE_UPDATE_BUF_AND_MORE_TODO ; Set flag to trigger.
    DEC LIB_BCD2/EXTRA_FILE_STREAM_INDEX ; --
    BNE COUNT_NONZERO_SETTLE_LOOP ; != 0, goto.
    LDX SCRIPT_BATTLE_PARTY_ID_FOCUS ; Index ??
    LDA SCRIPT_PARTY_ATTRIBUTES+6,X ; Load ??
    AND #$FC ; Keep upper.
    BEQ RTS ; == 0, goto.
    LSR A ; >> 2, /4.
    LSR A
    STA LIB_BCD/EXTRA_FILE_BCD_A ; Store to.
    ASL A ; << 1, *2.
    ADC LIB_BCD/EXTRA_FILE_BCD_A ; Add with /4 for total of 3/4 original val.
    CLC ; Prep add.
    ADC #$C8 ; Add with ptr base L.
    STA LIB_BCD/EXTRA_FILE_BCD_A ; Store to, ptr L.
    LDA #$00 ; Seed carry add.
    ADC #$97 ; Add with base ptr H.
    STA LIB_BCD/EXTRA_FILE_BCD_B ; Store, ptr H.
    LDY #$00 ; Seed stream index.
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y ; Load from file.
    STA SCRIPT_PARTY_ATTRIBUTES+28,X ; Store to.
    LDA SCRIPT_UNK_BATTLE?_OBJECT_ID_FOCUSED? ; Load ??
    ASL A ; << 3, *8.
    ASL A
    ASL A
    TAX ; To X index.
    LDA #$00 ; Seed clear.
    STA WORLD_OBJECT_PAGE_EXTRA_ATTRS[256],X ; Clear many of obj.
    STA OBJ?_BYTE_0x1_UNK,X
    STA OBJ?_BYTE_0x4_UNK,X
    STA OBJ?_BYTE_0x5_BYTE,X
    LDA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY+1 ; Move ??
    STA OBJ?_BYTE_0x2_UNK,X
    LDA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY[8] ; Move ??
    STA OBJ?_BYTE_0x3_UNK,X
    LDY #$01 ; Stream index.
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y ; Move from file to obj.
    STA OBJ?_PTR?[2],X
    INY ; Stream++
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y ; Move from file to obj.
    STA OBJ?_PTR?+1,X
RTS: ; 17:03D1, 0x02E3D1
    RTS ; Leave.
PPU_PACKET_SET_VAL_0xFF_COUNT_0x40_PPU_ADDR_XY: ; 17:03D2, 0x02E3D2
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle.
    STX NMI_PPU_CMD_PACKETS_BUF+2
    STY NMI_PPU_CMD_PACKETS_BUF+3
    LDA #$08 ; Type, single byte count times.
    STA NMI_PPU_CMD_PACKETS_BUF[69] ; Store type.
    LDA #$40 ; Count.
    STA NMI_PPU_CMD_PACKETS_BUF+1
    LDA #$FF ; Byte, 0xFF.
    STA NMI_PPU_CMD_PACKETS_BUF+4
    LDA #$00 ; EOF.
    STA NMI_PPU_CMD_PACKETS_BUF+5
    LDA #$80 ; Flag set.
    STA NMI_FLAG_EXECUTE_UPDATE_BUF_AND_MORE_TODO
    LDA #$00 ; Reset index for trigger.
    STA NMI_PPU_CMD_PACKETS_INDEX
    RTS ; Leave.
SCRIPT_TEXT_AND_REENTER_THINGY???: ; 17:03F8, 0x02E3F8
    CMP #$00 ; If _ #$00
    BEQ RTS ; ==, leave.
    PHA ; Save nonzero.
    JSR SUB_FILES_MOD_PARTY_TODO_UNK ; Do.
    JSR ENGINE_SCRIPT_HELP_MAPPER_R6_TO_0x00 ; Do.
    PLA ; Pull value.
    CMP #$FF ; If _ #$FF
    BNE VAL_NE_0xFF ; !=, goto.
    SEC ; Prep sub.
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load ??
    LDA PARTY_ATTR_PTR[2],Y ; Load index.
    SBC #$00 ; Sub with.
    STA FPTR_PACKET_CREATION/PTR_H_FILE_IDK[2] ; Store to.
    LDA PARTY_ATTR_PTR+1,Y ; Load ??
    SBC #$80 ; Sub with.
    ASL FPTR_PACKET_CREATION/PTR_H_FILE_IDK[2] ; Rotates 3x.
    ROL A
    ASL FPTR_PACKET_CREATION/PTR_H_FILE_IDK[2]
    ROL A
    ASL FPTR_PACKET_CREATION/PTR_H_FILE_IDK[2]
    ROL A
    CLC ; Prep add.
    ADC #$14 ; Add with.
    STA FPTR_PACKET_CREATION/PTR_H_FILE_IDK[2] ; Store to.
    LDA #$00 ; Seed ??
    ADC #$05 ; Add 0x5/0x6.
    STA ARG/PTR_L ; Store to, PTR L.
    BCC READ_PORTION_BEGINNING ; CC, goto. Always taken?
VAL_NE_0xFF: ; 17:042D, 0x02E42D
    LDY #$00 ; Seed clear.
    STY LIB_BCD/EXTRA_FILE_BCD_B ; Clear.
    ASL A ; ASL/ROT
    ROL LIB_BCD/EXTRA_FILE_BCD_B
    CLC ; Prep add.
    ADC #$81 ; Add with.
    STA LIB_BCD/EXTRA_FILE_BCD_A ; Store to, PTR L.
    LDA LIB_BCD/EXTRA_FILE_BCD_B ; Load.
    ADC #$90 ; += 0x90
    STA LIB_BCD/EXTRA_FILE_BCD_B ; Store to.
    LDY #$00 ; Stream reset.
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y ; Load from file.
    STA FPTR_PACKET_CREATION/PTR_H_FILE_IDK[2] ; Store to.
    INY ; Stream++
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y ; Load from file.
    STA ARG/PTR_L ; Store to.
READ_PORTION_BEGINNING: ; 17:044A, 0x02E44A
    JSR LIB_READING_PPU_ROM_$0110_HELPER ; Read PPU.
    LDA FPTR_PACKET_CREATION/PTR_H_FILE_IDK[2] ; Move ??
    STA SCRIPT_PACKET_CREATE_SAVED_UNK[2]
    LDA FPTR_PACKET_CREATION/PTR_H_FILE_IDK+1
    STA SCRIPT_PACKET_CREATE_SAVED_UNK+1
    LDA SCRIPT?_UNK_0x52 ; Load ??
    CMP #$03 ; If _ #$03
    BNE VAL_NE_0x3 ; !=, goto.
    LDX #$03 ; Seed ??
    JSR SUB_ADDRESSES_UNK_ENTRY_ADD ; Do ??
    DEC SCRIPT?_UNK_0x52 ; --
VAL_NE_0x3: ; 17:0462, 0x02E462
    JSR SUB_UNK_TODO ; Do ??
    CMP #$02 ; If _ #$02
    BEQ VAL_EQ_0x2 ; ==, goto.
    INC SCRIPT?_UNK_0x52 ; ++
    CMP #$00 ; If _ #$00
    BNE READ_PORTION_BEGINNING ; !=, goto.
VAL_EQ_0x2: ; 17:046F, 0x02E46F
    JSR ENGINE_SET_MAPPER_R6_TO_0x16 ; Do R6 to 0x16.
    LDX CURRENT_SAVE_MANIPULATION_PAGE+24 ; Load ??
    JSR ENGINE_WAIT_X_SETTLES ; Wait that long.
RTS: ; 17:0478, 0x02E478
    RTS ; Leave.
SUB_UNK_TODO: ; 17:0479, 0x02E479
    LDA SCRIPT?_UNK_0x52 ; Load.
    ASL A ; << 1, *2.
    ADC #$03 ; += 0x3
    STA GFX_COORD_VERTICAL_OFFSET ; Store to, V coord.
    LDY #$00 ; Stream index.
    LDA [SCRIPT_PACKET_CREATE_SAVED_UNK[2]],Y ; Load from file.
    CMP #$03 ; If _ #$03
    BNE VAL_NE_0x3 ; !=, goto.
    LDA #$0F
    STA GFX_COORD_HORIZONTAL_OFFSET ; Set X coord.
    JSR SAVE_FLAG_SET_SUBMENU_AND_MENU_SINGLE_UNK_TODO ; Do ??
    INC SCRIPT_PACKET_CREATE_SAVED_UNK[2] ; PTRL ++
    BNE VAL_NE ; !=, goto.
    INC SCRIPT_PACKET_CREATE_SAVED_UNK+1 ; PTRH ++
VAL_NE: ; 17:0495, 0x02E495
    LDY #$00 ; Stream index.
    LDA [SCRIPT_PACKET_CREATE_SAVED_UNK[2]],Y ; Load from file.
    CMP #$02 ; If _ #$02
    BEQ RTS ; ==, leave.
VAL_NE_0x3: ; 17:049D, 0x02E49D
    LDA #$16 ; Load ??
    STA R_**:$0070 ; Store ??
    LDA #$05
    STA GFX_COORD_HORIZONTAL_OFFSET ; Set H coord.
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle.
    LDA SCRIPT_PACKET_CREATE_SAVED_UNK[2] ; Move ptr back.
    STA FPTR_PACKET_CREATION/PTR_H_FILE_IDK[2]
    LDA SCRIPT_PACKET_CREATE_SAVED_UNK+1
    STA FPTR_PACKET_CREATION/PTR_H_FILE_IDK+1
    JSR RTN_SETTLE_UPDATE_TODO ; Settle.
    LDA #$01 ; Seed do.
    JSR LIB_SUB_HELPER_MOVE_CMD_TO_DEEPER ; Move ??
    LDA ENGINE_SCRIPT_SWITCH_VAL_CONTINUE_UPDATES? ; Load ??
RTS: ; 17:04BA, 0x02E4BA
    RTS ; Leave.
SUB_FILES_MOD_PARTY_TODO_UNK: ; 17:04BB, 0x02E4BB
    LDA #$21 ; Move ??
    STA CHARACTER_NAMES_ARR[8]
    STA R_**:$0588 ; Set ??
    LDA #$80
    STA LIB_BCD2/EXTRA_FILE_STREAM_INDEX ; Set ??
    LDA #$05
    STA LIB_BCD/EXTRA_FILE_D ; Set ??
    LDX SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load ??
    JSR SUB_TODO ; Do sub.
    LDA #$88
    STA LIB_BCD2/EXTRA_FILE_STREAM_INDEX ; Set ??
    LDA #$05
    STA LIB_BCD/EXTRA_FILE_D ; Set ??
    LDX SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load index ??
SUB_TODO: ; 17:04DA, 0x02E4DA
    LDA PARTY_ATTR_PTR[2],X ; Move fptr.
    STA LIB_BCD/EXTRA_FILE_BCD_A
    LDA PARTY_ATTR_PTR+1,X
    STA LIB_BCD/EXTRA_FILE_BCD_B
    LDY #$18 ; Stream index.
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y ; Load from file.
    PHA ; Save it.
    INY ; Stream++
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y ; Load from file.
    LDY #$02 ; Restream.
    STA [LIB_BCD2/EXTRA_FILE_STREAM_INDEX],Y ; Store to other file.
    PLA ; Pull value saved.
    DEY ; Stream--
    STA [LIB_BCD2/EXTRA_FILE_STREAM_INDEX],Y ; Store to file.
    INY ; Stream += 2
    INY
    LDA SCRIPT_PARTY_ATTRIBUTES+26,X ; Load ??
    AND #$1C ; Keep 0001.1100
    BEQ EXIT_MOVE_CLEAR ; == 0, goto.
    LSR A ; >> 2, /4.
    LSR A
    CLC ; Prep add.
    ADC #$40 ; Add with.
    STA [LIB_BCD2/EXTRA_FILE_STREAM_INDEX],Y ; Store to file.
    INY ; Stream++
EXIT_MOVE_CLEAR: ; 17:0505, 0x02E505
    LDA #$00 ; Move clear.
    STA [LIB_BCD2/EXTRA_FILE_STREAM_INDEX],Y
    RTS ; Leave.
SUB_UNK: ; 17:050A, 0x02E50A
    LDA #$00
    STA SCRIPT_BATTLE_PARTY_ID_FOCUS ; Clear ??
LOOP_FOCUS_CHECK: ; 17:050E, 0x02E50E
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load index.
    LDA #$00
    STA SCRIPT_PARTY_ATTRIBUTES+29,Y ; Clear index.
    LDA SCRIPT_PARTY_ATTRIBUTES+30,Y ; Load ??
    AND #$F7 ; Keep 1111.0111
    STA SCRIPT_PARTY_ATTRIBUTES+30,Y ; Store back.
    LDA SCRIPT_PARTY_ATTRIBUTES[32],Y ; Load ??
    BEQ VAL_EQ_0x00 ; == 0, goto.
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y ; Load ??
    AND #$F4 ; Keep 1111.0100
    BNE VAL_EQ_0x00 ; Any set, goto.
    LDA SCRIPT_PARTY_ATTRIBUTES+30,Y ; Load ??
    AND #$20 ; Keep 0010.0000
    BNE VAL_EQ_0x00 ; !=, goto.
    JSR ATTR_SET_UNK_TODO ; Do sub.
    BCS LOOP_FOCUS_CHECK ; CS, goto.
VAL_EQ_0x00: ; 17:0535, 0x02E535
    CLC ; Prep add.
    LDA SCRIPT_BATTLE_PARTY_ID_FOCUS ; Focus slot++
    ADC #$20
    STA SCRIPT_BATTLE_PARTY_ID_FOCUS
    BNE LOOP_FOCUS_CHECK ; != 0, loop.
    RTS
ATTR_SET_UNK_TODO: ; 17:053F, 0x02E53F
    LDA SCRIPT_BATTLE_UNK_0x59 ; Load ??
    BNE VAL_NONZERO ; != 0, goto.
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load index ??
    BMI VAL_NONZERO ; Negative, goto.
    LDA SCRIPT_PARTY_ATTRIBUTES+17,Y ; Load ??
    AND #$06 ; Keep ?? 0000.0101
    EOR #$06 ; Invert them.
    BEQ VAL_NONZERO ; == 0, goto.
    JSR ENTRENCE_REDISPLAY_MENU_HELPER? ; Do sub extra.
    BCS RTS ; CS, leave.
    LDA SCRIPT_BATTLE_UNK_0x59 ; Load ??
    BEQ PORTION_UNK ; ==, goto.
VAL_NONZERO: ; 17:0559, 0x02E559
    JSR SUB_HELP_UNK ; Do ??
PORTION_UNK: ; 17:055C, 0x02E55C
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Index ??
    LDA SCRIPT_PARTY_ATTRIBUTES+29,Y ; Load ??
    CMP #$53 ; If _ #$53
    BEQ EXIT_SET_AND_RET_CC ; ==, goto.
    CMP #$59 ; If _ #$59
    BNE EXIT_RET_CC ; !=, goto.
EXIT_SET_AND_RET_CC: ; 17:0569, 0x02E569
    LDA SCRIPT_PARTY_ATTRIBUTES+30,Y ; Load ??
    ORA #$08 ; Set ??
    STA SCRIPT_PARTY_ATTRIBUTES+30,Y ; Store back.
EXIT_RET_CC: ; 17:0571, 0x02E571
    CLC ; Ret CC.
RTS: ; 17:0572, 0x02E572
    RTS ; Leave.
SUB_HELP_UNK: ; 17:0573, 0x02E573
    LDA SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load ??
    BMI VAL_NEGATIVE ; Negative, goto.
    JMP EXIT_FOCUSED_FRIENDLY ; Goto.
VAL_NEGATIVE: ; 17:057A, 0x02E57A
    JMP EXIT_FOCUSED_ENEMY ; Goto.
EXIT_FOCUSED_FRIENDLY: ; 17:057D, 0x02E57D
    LDY #$00
INDEX_POSITIVE: ; 17:057F, 0x02E57F
    STY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Store index.
    LDA SCRIPT_PARTY_ATTRIBUTES[32],Y ; Load ??
    BEQ ITER_DATA ; == 0, goto.
    LDA SCRIPT_PARTY_ATTRIBUTES+17,Y ; Load ??
    AND #$06 ; Keep bit.
    EOR #$06 ; Invert it.
    BEQ ITER_DATA ; Clear, goto.
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y ; Load ??
    BMI EXIT_JMP ; Negative, goto.
ITER_DATA: ; 17:0594, 0x02E594
    TYA ; Y to A.
    CLC ; Prep add.
    ADC #$20 ; Add with.
    TAY ; To Y index.
    BPL INDEX_POSITIVE ; Positive, goto.
    BMI PORTION_TODO_PARTNER_UNK ; Always taken, goto.
EXIT_JMP: ; 17:059D, 0x02E59D
    JMP PORTION_SET_ATTR_UNK ; Goto.
PORTION_TODO_PARTNER_UNK: ; 17:05A0, 0x02E5A0
    LDY #$00 ; Index reset.
LOOP_POSITIVE: ; 17:05A2, 0x02E5A2
    STY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Store index.
    LDA SCRIPT_PARTY_ATTRIBUTES[32],Y ; Load ??
    BEQ VAL_EQ_0x00 ; == 0, goto.
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y ; Load ??
    BMI VAL_EQ_0x00 ; Negative, goto.
    LDA SCRIPT_PARTY_ATTRIBUTES+17,Y ; Load ??
    AND #$06 ; Keep bit.
    EOR #$06 ; Invert it.
    BEQ VAL_EQ_0x00 ; == 0, goto.
    JSR ROUTINE_OBJ_HANDLE_UNK_A ; Do ??
    BCC SEED_0x00S_UNK ; CC, goto.
VAL_EQ_0x00: ; 17:05BC, 0x02E5BC
    TYA ; Y += 0x20
    CLC
    ADC #$20
    TAY
    BPL LOOP_POSITIVE ; Positive, loop.
    BMI EXIT_UNK ; Always taken, goto.
SEED_0x00S_UNK: ; 17:05C5, 0x02E5C5
    LDX #$00 ; Seed ??
    LDY #$00
LOOP_POSITIVE: ; 17:05C9, 0x02E5C9
    LDA SCRIPT_PARTY_ATTRIBUTES[32],Y ; Load ??
    BEQ ITER ; == 0, goto.
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y ; Load pair.
    BMI ITER ; Negative, iter.
    JSR ROUTINE_OBJ_HANDLE_UNK_A ; Handle.
    BCS ITER ; CS, iter.
    INX ; Index++
    STY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Store ??
ITER: ; 17:05DB, 0x02E5DB
    TYA ; Y += 0x20, next obj.
    CLC
    ADC #$20
    TAY
    BPL LOOP_POSITIVE ; Positive, goto.
    CPX #$01 ; If _ #$01
    BCC VAL_LT_0x1 ; <, goto.
    JMP SCRIPT_EXTENSION_TODO ; Goto.
EXIT_UNK: ; 17:05E9, 0x02E5E9
    LDY #$00 ; Index reset.
VAL_POSITIVE: ; 17:05EB, 0x02E5EB
    STY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Store index.
    LDA SCRIPT_PARTY_ATTRIBUTES[32],Y ; Load member status.
    BEQ ITER_TO_NEXT_PARTNER ; == 0, goto.
    LDA SCRIPT_PARTY_ATTRIBUTES+17,Y ; Load ??
    AND #$06 ; Keep 0000.0110
    EOR #$06 ; Invert them.
    BEQ ITER_TO_NEXT_PARTNER ; == 0, goto. Both set originally.
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y ; Load attr ??
    BMI ITER_TO_NEXT_PARTNER ; Negative, goto.
    AND #$70 ; Keep 1110.0000
    BNE PARTNER_UPPER_NONZERO ; != 0, goto.
ITER_TO_NEXT_PARTNER: ; 17:0604, 0x02E604
    TYA
    CLC
    ADC #$20 ; Add with attributes struct size.
    TAY
    BPL VAL_POSITIVE ; Positive, goto.
    JMP ENTRY_FAILED_PARTNER_FIND ; Goto.
PARTNER_UPPER_NONZERO: ; 17:060E, 0x02E60E
    JMP EXIT_SYNC_UNK ; != 0, goto.
VAL_LT_0x1: ; 17:0611, 0x02E611
    LDA #$0C ; Seed ??
    JSR SCRIPT_SET_ATTRIBUTE_HELPER_RET_CC_PASS_CS_FAIL ; Do script.
    BCC RET_CC ; Set, leave.
    LDA #$0B ; Seed ??
    JSR SCRIPT_SET_ATTRIBUTE_HELPER_RET_CC_PASS_CS_FAIL ; Do script.
    BCC RET_CC ; Ret CC, yes, goto.
    JMP SCRIPT_EXTENSION_TODO ; Goto.
RET_CC: ; 17:0622, 0x02E622
    RTS ; Leave.
SCRIPT_EXTENSION_TODO: ; 17:0623, 0x02E623
    LDA #$0A ; Seed attribute.
    JSR SCRIPT_SET_ATTRIBUTE_HELPER_RET_CC_PASS_CS_FAIL ; Do script.
    BCC ATTR_NO_SET ; CC, goto.
    LDA #$09 ; Seed attribute.
    JSR SCRIPT_SET_ATTRIBUTE_HELPER_RET_CC_PASS_CS_FAIL ; Set attr.
    BCC ATTR_NO_SET ; CC, set, leave.
    LDA #$08 ; Seed attribute.
    JSR SCRIPT_SET_ATTRIBUTE_HELPER_RET_CC_PASS_CS_FAIL ; Set attr.
    BCC ATTR_NO_SET ; CC, set, leave.
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load focus.
    JSR PARTY_FOCUS_NO_ATTRS_SET_UNK ; None set, do.
    BCS EXIT_UNK ; CS, goto.
    CPX #$7C ; If _ #$7C
    BEQ EXIT_UNK ; ==, goto.
    CPX #$84 ; If _ #$84
    BEQ EXIT_UNK ; ==, goto.
    TYA ; Y to A.
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load focus.
    STA SCRIPT_PARTY_ATTRIBUTES+16,Y ; Store to attr ??
    TXA ; X to A.
    STA SCRIPT_PARTY_ATTRIBUTES+29,Y ; Store to attr ??
ATTR_NO_SET: ; 17:0651, 0x02E651
    LDA SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load data to?
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load focus?
    STA SCRIPT_PARTY_ATTRIBUTES+28,Y ; Store to obj.
    RTS ; Leave.
EXIT_SYNC_UNK: ; 17:0659, 0x02E659
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load ??
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y ; Load attr ??
    TAX ; To X index.
    AND #$20 ; Keep 0010.0000
    BNE ATTR_0x20_SET ; != 0, set, goto.
    TXA ; X to A.
    AND #$10 ; Test 0001.0000
    BNE ATTR_0x10_SET ; != 0, goto, was set.
    TXA ; X to A.
    AND #$40 ; Test 0100.0000
    BNE ATTR_0x40_SET ; If set, goto.
    JMP EXIT_FAILED_PARTNER_FIND ; Goto.
ATTR_0x20_SET: ; 17:0670, 0x02E670
    LDA #$11 ; Seed attr.
    JSR SCRIPT_SET_ATTRIBUTE_HELPER_RET_CC_PASS_CS_FAIL ; Do.
    BCC EXIT_SCRIPT_OBJECT_UPDATE_DATA ; CC, set, goto.
ATTR_0x10_SET: ; 17:0677, 0x02E677
    LDA #$13 ; Seed attr.
    JSR SCRIPT_SET_ATTRIBUTE_HELPER_RET_CC_PASS_CS_FAIL ; Do.
    BCC EXIT_SCRIPT_OBJECT_UPDATE_DATA ; CC, set, goto.
ATTR_0x40_SET: ; 17:067E, 0x02E67E
    LDA #$12 ; Seed attr.
    JSR SCRIPT_SET_ATTRIBUTE_HELPER_RET_CC_PASS_CS_FAIL ; Do.
    BCC EXIT_SCRIPT_OBJECT_UPDATE_DATA ; CC, set, goto.
EXIT_FAILED_PARTNER_FIND: ; 17:0685, 0x02E685
    JMP ENTRY_FAILED_PARTNER_FIND ; Goto.
EXIT_SCRIPT_OBJECT_UPDATE_DATA: ; 17:0688, 0x02E688
    LDA SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load data writing.
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load index for obj.
    STA SCRIPT_PARTY_ATTRIBUTES+28,Y ; Set attr.
    RTS ; Leave.
ENTRY_FAILED_PARTNER_FIND: ; 17:0690, 0x02E690
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load focus.
    LDA #$01
    STA SCRIPT_PARTY_ATTRIBUTES+29,Y ; Set ??
EXIT_RANDOMIZE_ENEMY_FOCUS_AUTO_HELPER: ; 17:0697, 0x02E697
    JSR RANDOMIZE_GROUP_A ; Randomize.
    AND #$E0 ; Keep upper.
    ORA #$80 ; Set enemy index.
    TAY ; A to Y.
    LDA SCRIPT_PARTY_ATTRIBUTES[32],Y ; Load status for.
    BEQ EXIT_RANDOMIZE_ENEMY_FOCUS_AUTO_HELPER ; == 0, loop until we find one. TODO: sanic fast logeek
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y ; Load attr ??
    BMI EXIT_RANDOMIZE_ENEMY_FOCUS_AUTO_HELPER ; Negative, loop. Fainted?
    TYA ; Y to A.
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load 
    STA SCRIPT_PARTY_ATTRIBUTES+28,Y ; Store value into, focus for this one.
    RTS ; Leave.
PORTION_SET_ATTR_UNK: ; 17:06B0, 0x02E6B0
    LDA #$14 ; Load ??
    JSR SCRIPT_SET_ATTRIBUTE_HELPER_RET_CC_PASS_CS_FAIL ; Set attr.
    BCC EXIT_ATTR_SET ; Set, goto.
    JMP PORTION_TODO_PARTNER_UNK
EXIT_ATTR_SET: ; 17:06BA, 0x02E6BA
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load focus.
    LDA SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load commit val.
    STA SCRIPT_PARTY_ATTRIBUTES+28,Y ; Commit it.
    RTS ; Leave.
SCRIPT_SET_ATTRIBUTE_HELPER_RET_CC_PASS_CS_FAIL: ; 17:06C2, 0x02E6C2
    STA LIB_BCD/EXTRA_FILE_BCD_A ; Store passed.
    JSR SCRIPT_BATTLE_FOCUS_DPTR_INC_0x30 ; Do.
    LDA LIB_BCD/EXTRA_FILE_BCD_A ; Load.
    LSR A ; >> 3, /8.
    LSR A
    LSR A
    TAY ; To Y index.
    LDA LIB_BCD/EXTRA_FILE_BCD_A ; Load ??
    AND #$07 ; Keep 0000.0111
    TAX ; To X index.
    INX ; Index++
    SEC ; Prep carry to bring in.
    LDA #$00 ; Seed ??
INDEX_NONZERO: ; 17:06D6, 0x02E6D6
    ROR A ; Rotate A.
    DEX ; Index--
    BNE INDEX_NONZERO ; != 0, rotate it.
    STA LIB_BCD/EXTRA_FILE_BCD_B ; Store result.
    LDA [BATTLE_PARTY_FPTR_DATA_TODO[2]],Y ; Load file.
    AND LIB_BCD/EXTRA_FILE_BCD_B ; Test with file.
    BEQ EXIT_FAIL_TO_SET_ATTR ; == 0, goto.
    LDA #$00 ; Seed clear.
    ASL LIB_BCD/EXTRA_FILE_BCD_A ; Shift and rotate into.
    ROL A
    ASL LIB_BCD/EXTRA_FILE_BCD_A ; 2x
    ROL A
    ASL LIB_BCD/EXTRA_FILE_BCD_A ; 3x
    ROL A
    STA LIB_BCD/EXTRA_FILE_BCD_B ; Store lower.
    CLC ; Prep add.
    LDA LIB_BCD/EXTRA_FILE_BCD_A ; Load with.
    ADC #$00 ; Add with.
    STA LIB_BCD/EXTRA_FILE_BCD_A ; Store to, PTR L.
    LDA LIB_BCD/EXTRA_FILE_BCD_B ; Load PTR H.
    ADC #$9E ; Add with.
    STA LIB_BCD/EXTRA_FILE_BCD_B ; Store to. Based 0x9E00 + 0x16/val TODO double check.
    JSR ENGINE_SCRIPT_HELP_MAPPER_R6_TO_0x00 ; Do R6 to 0x00.
    LDY #$05 ; File index.
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y ; Load from file.
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load alt index.
    STA SCRIPT_PARTY_ATTRIBUTES+29,Y ; Store val to.
    LDY #$07 ; Stream index.
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y ; Load from file.
    STA SUB/MOD_VAL_UNK_WORD[2] ; Store to.
    LDA #$00
    STA SUB/MOD_VAL_UNK_WORD+1 ; Clear ??
    JSR ENGINE_SET_MAPPER_R6_TO_0x16 ; R6 to 0x16.
    JSR SCRIPT_TEST_VALS_UNK ; Do sub.
    BCC EXIT_FAIL_TO_SET_ATTR ; CC, didn't set.
    JSR SCRIPT_ATTR_INVERT_TEST_UNK ; Do sub.
    BCC EXIT_FAIL_TO_SET_ATTR ; CC, goto. Failed to set.
    CLC ; Ret CC, set attr.
    RTS ; Leave.
EXIT_FAIL_TO_SET_ATTR: ; 17:0721, 0x02E721
    SEC ; Ret CS, fail, not settable.
    RTS ; Leave.
EXIT_FOCUSED_ENEMY: ; 17:0723, 0x02E723
    JSR RANDOMIZE_GROUP_A ; Randomize a value.
    AND #$07 ; Keep lower.
    CLC ; Prep add.
    ADC SCRIPT_BATTLE_PARTY_ID_FOCUS ; Add with focus.
    TAY ; To Y index.
    LDA SCRIPT_PARTY_ATTRIBUTES+16,Y ; Load attr, random.
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Re-load focus.
    STA SCRIPT_PARTY_ATTRIBUTES+29,Y ; Store to obj higher.
    JSR SCRIPT_BATTLE_HELPER_MAKE_TIMES_FOR_EFFECT? ; Do sub.
    JSR SWITCH_TABLE_PAST_JSR_HELPER ; Switch with.
    LOW(SCRIPT_A_STORE_ATTR_UNK)
    HIGH(SCRIPT_A_STORE_ATTR_UNK)
    LOW(SCRIPT_B_FIND_CHAR_VALID_NOT_DEAD)
    HIGH(SCRIPT_B_FIND_CHAR_VALID_NOT_DEAD)
    LOW(SCRIPT_C_PLAYER_FOCUS_AND_TODO)
    HIGH(SCRIPT_C_PLAYER_FOCUS_AND_TODO)
SCRIPT_B_FIND_CHAR_VALID_NOT_DEAD: ; 17:0740, 0x02E740
    JSR SCRIPT_RANDOMIZE_BATTLE_CHARACTER_FRIEND_OR_FOE ; Randomize.
    LDA SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load val.
    BPL SCRIPT_B_FIND_CHAR_VALID_NOT_DEAD ; Positive, goto.
    JMP SCRIPT_A_STORE_ATTR_UNK ; Goto. Set attr.
SCRIPT_C_PLAYER_FOCUS_AND_TODO: ; 17:074A, 0x02E74A
    LDA SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load focus.
    BPL RANDOM_FOCUS_FRIENDLY ; Positive, goto.
    LDA 56_OBJECT_NAME_SIZE? ; Load ??
    CMP #$03 ; If _ #$03
    BNE SLOT_FIND_EXTENSION_UNK ; !=, goto.
    LDX #$03 ; Seed slot start.
FIND_SLOT_ID_0x6: ; 17:0756, 0x02E756
    LDA #$06 ; Load ID to find.
    JSR SUB_FIND_CHARACTER_ID_PASSED_CS_FOUND_CC_FAIL ; Find char ID.
    BCS EXIT_SET_ATTR_TO_CHAR_UNK ; CS, goto.
    DEX ; Slot--
    BPL FIND_SLOT_ID_0x6 ; Positive, goto.
SLOT_FIND_EXTENSION_UNK: ; 17:0760, 0x02E760
    LDA 56_OBJECT_NAME_SIZE? ; Load ??
    CMP #$04 ; If _ #$04
    BNE VAR_EQ_0x4 ; ==, goto.
    LDX #$03 ; Slot index.
FIND_SLOT_ID_0x1: ; 17:0768, 0x02E768
    LDA #$01 ; Load ID to find.
    JSR SUB_FIND_CHARACTER_ID_PASSED_CS_FOUND_CC_FAIL ; Find it.
    BCS EXIT_SET_ATTR_TO_CHAR_UNK ; Found, set ??
    DEX ; Slot--
    BPL FIND_SLOT_ID_0x1 ; Positive, loop, not found.
    LDX #$03 ; Seed index.
FIND_SLOT_ID_0x2: ; 17:0774, 0x02E774
    LDA #$02 ; Load ID ??
    JSR SUB_FIND_CHARACTER_ID_PASSED_CS_FOUND_CC_FAIL ; Find it.
    BCS EXIT_SET_ATTR_TO_CHAR_UNK ; CS, goto.
    DEX ; Slot index--
    BPL FIND_SLOT_ID_0x2 ; Positive, loop.
    LDX #$03 ; Seed slot index reset.
FIND_SLOT_ID_0x4: ; 17:0780, 0x02E780
    LDA #$04 ; Seed ID to find.
    JSR SUB_FIND_CHARACTER_ID_PASSED_CS_FOUND_CC_FAIL ; Find it.
    BCS EXIT_SET_ATTR_TO_CHAR_UNK ; Found, goto.
    DEX ; Slot--
    BPL FIND_SLOT_ID_0x4 ; Positive, still search.
VAR_EQ_0x4: ; 17:078A, 0x02E78A
    LDX #$03 ; Seed slot index.
FIND_SLOT_ID_0x7: ; 17:078C, 0x02E78C
    LDA #$07 ; Slot ID to find.
    JSR SUB_FIND_CHARACTER_ID_PASSED_CS_FOUND_CC_FAIL ; Find test.
    BCS EXIT_SET_ATTR_TO_CHAR_UNK ; CS, found, set attr.
    DEX ; Slot index--
    BPL FIND_SLOT_ID_0x7 ; Positive, loop.
RANDOM_FOCUS_FRIENDLY: ; 17:0796, 0x02E796
    JSR SCRIPT_RANDOMIZE_BATTLE_CHARACTER_FRIEND_OR_FOE ; Randomize.
    LDA SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load focus made.
    BMI RANDOM_FOCUS_FRIENDLY ; Negative, enemy, randomize again.
    JMP SCRIPT_A_STORE_ATTR_UNK ; Exit store attr.
EXIT_SET_ATTR_TO_CHAR_UNK: ; 17:07A0, 0x02E7A0
    JMP SCRIPT_A_STORE_ATTR_UNK ; Goto the next line, lol. Exit attr set.
SCRIPT_A_STORE_ATTR_UNK: ; 17:07A3, 0x02E7A3
    LDA SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load attr val.
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load index.
    STA SCRIPT_PARTY_ATTRIBUTES+28,Y ; Store attr.
    RTS
SCRIPT_RANDOMIZE_BATTLE_CHARACTER_FRIEND_OR_FOE: ; 17:07AB, 0x02E7AB
    JSR RANDOMIZE_GROUP_A ; Randomize val.
    AND #$E0 ; Keep 1110.0000, random thing.
    TAY ; To Y index.
    LDA SCRIPT_PARTY_ATTRIBUTES[32],Y ; Load status.
    BEQ SCRIPT_RANDOMIZE_BATTLE_CHARACTER_FRIEND_OR_FOE ; == 0, goto.
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y ; Load pair.
    BMI SCRIPT_RANDOMIZE_BATTLE_CHARACTER_FRIEND_OR_FOE ; Negative, loop. Fainted?
    STY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Store focus.
    RTS ; Leave.
SUB_FIND_CHARACTER_ID_PASSED_CS_FOUND_CC_FAIL: ; 17:07BE, 0x02E7BE
    CMP WRAM_ARR_PARTY_CHARACTER_IDS?[6],X ; If _ arr
    BNE RET_CC_FAILURE_NOT_FOUND ; !=, exit CC, fail.
    TXA ; Slot ID to A.
    ASL A ; << 5, *32. To slot index.
    ASL A
    ASL A
    ASL A
    ASL A
    TAY ; To Y index.
    LDA SCRIPT_PARTY_ATTRIBUTES[32],Y ; Load attr status.
    BEQ RET_CC_FAILURE_NOT_FOUND ; == 0, goto.
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y ; Load pair.
    BMI RET_CC_FAILURE_NOT_FOUND ; Negative, goto.
    STY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Store index focus.
    SEC ; Ret CS, success.
    RTS
RET_CC_FAILURE_NOT_FOUND: ; 17:07D8, 0x02E7D8
    CLC ; Ret CC.
    RTS
ENTRENCE_REDISPLAY_MENU_HELPER?: ; 17:07DA, 0x02E7DA
    JSR BATTLE_SEED_UNKNOWN_UPDATE_PACKET_DISPLAY ; Do sub, display ??
BATTLE_MENU_BASE_SEEDED: ; 17:07DD, 0x02E7DD
    LDA #$02 ; Seed file.
    LDX CURRENT_SAVE_MANIPULATION_PAGE+540 ; Load ??
    BPL BATTLE_MENU_CONTINUE_SWITCH ; Positive, goto.
    LDA #$13 ; Seed alt file.
BATTLE_MENU_CONTINUE_SWITCH: ; 17:07E6, 0x02E7E6
    JSR LIB_BANK_0_FILES_COORDS_BATTLE_MENU?_UNK ; Do ??
    JSR BATTLE_SCRIPT_IDK_HIT_ENEMY? ; Do sub.
    JSR SWITCH_TABLE_PAST_JSR_HELPER ; Switch on below.
    LOW(RTN_A_ATTR_AND_HELPER_TODO)
    HIGH(RTN_A_ATTR_AND_HELPER_TODO)
    LOW(RTN_B_SETTLE_AND_OFFSCREEN_HELPER_AUTOREMOVE_SPRITE)
    HIGH(RTN_B_SETTLE_AND_OFFSCREEN_HELPER_AUTOREMOVE_SPRITE)
    LOW(RTN_C_THING_DPTR_ADV_0x30_AND_DO_TODO)
    HIGH(RTN_C_THING_DPTR_ADV_0x30_AND_DO_TODO)
    LOW(RTN_D_ATTR_WRITE_UNK)
    HIGH(RTN_D_ATTR_WRITE_UNK)
    LOW(RTN_E_SEARCH_FOCUS_UNK_TODO)
    HIGH(RTN_E_SEARCH_FOCUS_UNK_TODO)
    LOW(RTN_F_SET_ATTR_UNK)
    HIGH(RTN_F_SET_ATTR_UNK)
    LOW(RTN_G_FOCUS_ENEMY_TODO_BETTER)
    HIGH(RTN_G_FOCUS_ENEMY_TODO_BETTER)
    LOW(RTN_H_SET_ATTR_UNK)
    HIGH(RTN_H_SET_ATTR_UNK)
    LOW(RTN_I_FIND_FOCUS_LOOPED)
    HIGH(RTN_I_FIND_FOCUS_LOOPED)
RTS: ; 17:0801, 0x02E801
    .db 60 ; Leave? Extra probs.
RTN_A_ATTR_AND_HELPER_TODO: ; 17:0802, 0x02E802
    LDA #$01 ; Seed attr ??
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load focus.
    STA SCRIPT_PARTY_ATTRIBUTES+29,Y ; Set attr ??
    JSR PARTY_ATTR_HELPER_TODO_BETTER_MENU? ; Do attr.
    BCC EXIT_RTS ; CC, goto.
    JMP BATTLE_MENU_BASE_SEEDED ; Goto.
EXIT_RTS: ; 17:0811, 0x02E811
    JMP RTS ; Leave RTS.
RTN_B_SETTLE_AND_OFFSCREEN_HELPER_AUTOREMOVE_SPRITE: ; 17:0814, 0x02E814
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle.
    LDA #$01
    STA SCRIPT_BATTLE_UNK_0x59 ; Set ??
    LDA #$14
    STA R_**:$03E6 ; Set ??
    LDA #$97
    STA R_**:$03E7 ; Set ??
    LDA #$04
    STA WORLD_OBJECT_PAGE_EXTRA_ATTRS+224 ; Set ??
    LDA #$00
    STA ENGINE_NMI_HELPER_SLOT_OFFSCREEN_ALWAYS_NMI_CURSOR_DELETE ; Clear sprite off screen with engine.
    STA R_**:$03E4 ; Clear ??
    STA R_**:$03E5
    LDA #$D0
    STA R_**:$03E2 ; Set ??
    LDA #$47
    STA R_**:$03E3 ; Set ??
    LDA #$01
    STA NMI_FLAG_EXECUTE_UPDATE_BUF_AND_MORE_TODO ; Set flag PPU buf do.
    CLC ; Ret CC, great success?
    JMP RTS ; Goto, leave.
RTN_C_THING_DPTR_ADV_0x30_AND_DO_TODO: ; 17:0847, 0x02E847
    JSR SCRIPT_BATTLE_FOCUS_DPTR_INC_0x30 ; Advance focus ptr.
    LDA #$00
    STA LIB_BCD/EXTRA_FILE_BCD_A ; Clear ??
    LDY #$07 ; Stream index.
STREAM_NONZERO: ; 17:0850, 0x02E850
    LDA [BATTLE_PARTY_FPTR_DATA_TODO[2]],Y ; Load from file.
    ORA LIB_BCD/EXTRA_FILE_BCD_A ; Combine with.
    STA LIB_BCD/EXTRA_FILE_BCD_A ; Store to.
    DEY ; Stream--
    BNE STREAM_NONZERO ; != 0, goto.
    LDA LIB_BCD/EXTRA_FILE_BCD_A ; Load ??
    BEQ EXIT_NEXT_MENU ; == 0, goto.
    JSR SUB_FILE_DATA_TEST_INIT ; Do.
    BCS EXIT_REDISPLAY_MENU? ; Ret CS, goto.
    JMP RTS ; Leave.
EXIT_REDISPLAY_MENU?: ; 17:0865, 0x02E865
    JMP ENTRENCE_REDISPLAY_MENU_HELPER? ; Goto.
EXIT_NEXT_MENU: ; 17:0868, 0x02E868
    JMP BATTLE_MENU_BASE_SEEDED ; Goto.
SCRIPT_BATTLE_FOCUS_DPTR_INC_0x30: ; 17:086B, 0x02E86B
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load party focus.
    CLC ; Prep add.
    LDA PARTY_ATTR_PTR[2],Y ; Load from ptr.
    ADC #$30 ; Offset.
    STA BATTLE_PARTY_FPTR_DATA_TODO[2]
    LDA PARTY_ATTR_PTR+1,Y ; Load from obj.
    ADC #$00 ; Carry add.
    STA BATTLE_PARTY_FPTR_DATA_TODO+1 ; Store to.
    RTS ; Leave.
RTN_D_ATTR_WRITE_UNK: ; 17:087D, 0x02E87D
    LDA #$59 ; Seed ??
ATTR_UNK_WRITE_EXIT: ; 17:087F, 0x02E87F
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load focus index.
    STA SCRIPT_PARTY_ATTRIBUTES+29,Y ; Store to attr ??
    CLC ; Ret CC.
    JMP RTS ; JMP to RTS, lol.
RTN_E_SEARCH_FOCUS_UNK_TODO: ; 17:0888, 0x02E888
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load ID.
    CLC ; Prep add.
    LDA PARTY_ATTR_PTR[2],Y ; Load attr.
    ADC #$20 ; += 0x20.
    STA BATTLE_PARTY_FPTR_DATA_TODO[2] ; Store back.
    LDA PARTY_ATTR_PTR+1,Y ; Load ??
    ADC #$00 ; Carry add.
    STA BATTLE_PARTY_FPTR_DATA_TODO+1 ; Store back.
    LDA #$00
    STA LIB_BCD/EXTRA_FILE_BCD_A ; Clear ??
    LDY #$07 ; File index.
STREAM_POSITIVE: ; 17:089F, 0x02E89F
    LDA [BATTLE_PARTY_FPTR_DATA_TODO[2]],Y ; Load from file, attrs.
    ORA LIB_BCD/EXTRA_FILE_BCD_A ; Combine with.
    STA LIB_BCD/EXTRA_FILE_BCD_A ; Store to.
    DEY ; Stream--
    BPL STREAM_POSITIVE ; Positive, loop.
    LDA LIB_BCD/EXTRA_FILE_BCD_A ; Load val.
    BEQ EXIT_ZERO
    JSR FILE_MENU_THINGY_PROBS? ; != 0, goto.
    BCS EXIT_RET_CS_DONE ; Do.
    JMP RTS ; Exit RTS.
EXIT_RET_CS_DONE: ; 17:08B4, 0x02E8B4
    JMP ENTRENCE_REDISPLAY_MENU_HELPER? ; Goto.
EXIT_ZERO: ; 17:08B7, 0x02E8B7
    JMP BATTLE_MENU_BASE_SEEDED ; Goto.
RTN_F_SET_ATTR_UNK: ; 17:08BA, 0x02E8BA
    LDA #$48 ; Seed attr ??
    JMP ATTR_UNK_WRITE_EXIT ; Seeded, goto.
RTN_G_FOCUS_ENEMY_TODO_BETTER: ; 17:08BF, 0x02E8BF
    LDA #$80
    STA SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Set focus enemy.
    JSR BATTLE_SCRIPT_MENU_INIT/CONTINUE ; Do menu.
    BCS RET_FAIL ; Ret CS, not done.
    LDX MENU_SELECTED_SUBMENU_OPTION_INDEX_FINAL ; Seed index.
    LDA BATTLE_ARRAY_UNK+1,X ; Load arr.
    TAX ; To X index.
    DEX ; --
    TXA ; Back to A.
    STA SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Store attr val.
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load focus.
    STA SCRIPT_PARTY_ATTRIBUTES+28,Y ; Store attr.
    LDA #$6F ; Sed attr ??
    STA SCRIPT_PARTY_ATTRIBUTES+29,Y ; Store attr.
    JMP RTS ; JMP to RTS again, lol.
RET_FAIL: ; 17:08DF, 0x02E8DF
    JMP BATTLE_MENU_BASE_SEEDED ; Do submenu.
RTN_H_SET_ATTR_UNK: ; 17:08E2, 0x02E8E2
    LDA #$1C ; Seed attr ??
    JMP ATTR_UNK_WRITE_EXIT ; Exit write.
RTN_I_FIND_FOCUS_LOOPED: ; 17:08E7, 0x02E8E7
    SEC ; Prep sub.
    LDA SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load focus.
    BEQ EXIT_FAIL_CS ; == 0, goto.
    SBC #$20 ; -= 0x20, slot--
    STA SCRIPT_BATTLE_PARTY_ID_FOCUS ; Store to focus, one lower.
    TAY ; A to Y.
    LDA SCRIPT_PARTY_ATTRIBUTES[32],Y ; Load attr.
    BEQ RTN_I_FIND_FOCUS_LOOPED ; == 0, goto.
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y ; Load attr.
    BMI RTN_I_FIND_FOCUS_LOOPED ; Negative, goto. Find other.
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y ; Load ??
    AND #$F4 ; Test 111.0100
    BNE RTN_I_FIND_FOCUS_LOOPED ; Set, loop.
    LDA SCRIPT_PARTY_ATTRIBUTES+30,Y ; Load attr.
    AND #$20 ; Test ??
    BNE RTN_I_FIND_FOCUS_LOOPED ; Set, find other.
EXIT_FAIL_CS: ; 17:0909, 0x02E909
    SEC ; Ret CS, fail to find.
    JMP RTS ; JMP to RTS 3x.
BATTLE_SCRIPT_IDK_HIT_ENEMY?: ; 17:090D, 0x02E90D
    LDX #$73 ; Seed menu A ??
    LDY #$9F
    LDA 56_OBJECT_NAME_SIZE? ; Load ??
    CMP #$01 ; If _ #$01
    BNE VAL_NE_0x1 ; !=, goto.
    LDX #$83 ; Seed menu B ??
    LDY #$9F
    JMP ENTRY_SEEDED_MENU ; Goto.
VAL_NE_0x1: ; 17:091E, 0x02E91E
    LDA CURRENT_SAVE_MANIPULATION_PAGE+540 ; Load ??
    BPL ENTRY_SEEDED_MENU ; Positive, use as-is.
    LDX #$7B ; Seed menu C ??
    LDY #$9F
ENTRY_SEEDED_MENU: ; 17:0927, 0x02E927
    STX FPTR_MENU_SECONDARY/SUBMENU[2] ; Store submenu.
    STY FPTR_MENU_SECONDARY/SUBMENU+1
    LDX #$6B ; Seed master menu ??
    LDY #$9F
    STX FPTR_MENU_PRIMARY[2]
    STY FPTR_MENU_PRIMARY+1
    JSR ENGINE_MENU_INIT_MASTER_PARTIAL ; Partial show.
    BIT SCRIPT_MENU_STATUS ; Test status.
    BVS STATUS_B_PRESSED ; B pressed, goto.
    LDA #$09 ; Seed ??
    JSR SCRIPT_BATTLE_MENU_TODO ; Do.
    LDA MENU_SELECTED_SUBMENU_OPTION_INDEX_FINAL ; Load option.
    RTS ; Leave.
STATUS_B_PRESSED: ; 17:0942, 0x02E942
    LDA #$08 ; Ret 0x8.
    RTS
SCRIPT_BATTLE_MENU_TODO: ; 17:0945, 0x02E945
    STA LIB_BCD/EXTRA_FILE_BCD_A ; Store ??
    LDA MENU_SELECTED_SUBMENU_OPTION_INDEX_FINAL ; Load ??
    LSR A ; >> 1, /2. No bits on ends 0x1. Range/no ??
    ASL A ; << 1, *2.
    CLC ; Prep add.
    ADC GFX_COORD_VERTICAL_OFFSET ; Add with coord.
    STA GFX_COORD_VERTICAL_OFFSET ; Store coord.
    LDA MENU_SELECTED_SUBMENU_OPTION_INDEX_FINAL ; Load ??
    AND #$01 ; Keep ??
    BEQ LOWER_EQ_0x00 ; == 0, goto.
    CLC ; Prep add.
    LDA GFX_COORD_HORIZONTAL_OFFSET ; Load ??
    ADC LIB_BCD/EXTRA_FILE_BCD_A ; Add with, offset menu.
    STA GFX_COORD_HORIZONTAL_OFFSET ; Store horiz.
LOWER_EQ_0x00: ; 17:095D, 0x02E95D
    LDA #$0D ; Seed ??
    JMP LIB_BANK_0_FILES_COORDS_BATTLE_MENU?_UNK ; Goto.
PARTY_ATTR_HELPER_TODO_BETTER_MENU?: ; 17:0962, 0x02E962
    JSR SCRIPT_BATTLE_HELPER_MAKE_TIMES_FOR_EFFECT? ; Do attr times?
    BEQ EXIT_RET_CC ; == 0, goto.
    LDX #$80 ; Seed 0x80, enemies.
    CMP #$02 ; If _ #$02
    BEQ VAL_EQ_0x00 ; ==, goto.
    LDX #$00 ; Seed 0x00, players.
VAL_EQ_0x00: ; 17:096F, 0x02E96F
    STX LIB_BCD/EXTRA_FILE_BCD_A ; Store focus.
    LDA SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load party ID focus.
    AND #$80 ; Keep enemy/friend.
    EOR LIB_BCD/EXTRA_FILE_BCD_A ; Invert with, setting times?
    STA SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Store final value.
    JSR BATTLE_SCRIPT_MENU_INIT/CONTINUE ; Do sub.
    BCS EXIT_RET_CS ; Ret CS, leave.
    LDX MENU_SELECTED_SUBMENU_OPTION_INDEX_FINAL ; Load index.
    LDA BATTLE_ARRAY_UNK+1,X ; Load attr ??
    TAX ; A - 1 also to X.
    DEX ; --
    TXA ; X to A.
    STA SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Store value.
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load party focus.
    STA SCRIPT_PARTY_ATTRIBUTES+28,Y ; Store attr ??
EXIT_RET_CC: ; 17:098D, 0x02E98D
    CLC ; Ret CC, attr store success.
    RTS
EXIT_RET_CS: ; 17:098F, 0x02E98F
    SEC ; RTS CS, fail attr set.
    RTS
BATTLE_SCRIPT_MENU_INIT/CONTINUE: ; 17:0991, 0x02E991
    LDA #$0B
    JSR LIB_BANK_0_FILES_COORDS_BATTLE_MENU?_UNK ; File ??
    JSR L_17:09B3 ; Do sub.
    LDA #$8B
    STA FPTR_MENU_PRIMARY[2] ; Seed menu.
    LDA #$9F
    STA FPTR_MENU_PRIMARY+1
    JSR ENGINE_MENU_INIT_MASTER_FULL ; Init menu.
    BIT SCRIPT_MENU_STATUS ; Test status.
    BVS EXIT_B_PRESSED ; B set, leave.
    BMI EXIT_A_PRESSED ; A pressed, goto.
    JMP BATTLE_SCRIPT_MENU_INIT/CONTINUE ; Goto otherwise.
EXIT_A_PRESSED: ; 17:09AD, 0x02E9AD
    LDA MENU_SELECTED_SUBMENU_OPTION_INDEX_FINAL ; Load ??
    CLC ; Ret CC.
    RTS
EXIT_B_PRESSED: ; 17:09B1, 0x02E9B1
    SEC ; Ret CS.
    RTS
L_17:09B3: ; 17:09B3, 0x02E9B3
    LDA #$12
    STA GFX_COORD_VERTICAL_OFFSET ; Set coord.
    LDX #$00
    STX BATTLE_ARRAY_UNK+1 ; Clear ??
    STX BATTLE_ARRAY_UNK+2
    STX BATTLE_ARRAY_UNK+3
    STX BATTLE_ARRAY_UNK+4
    INX ; X = 0x1
    STX BATTLE_ARRAY_UNK[5] ; Store to ??
    LDA SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load ??
    PHA ; Save focus.
    LDY #$04 ; Seed ??
INDEX_NONZERO_LOOP: ; 17:09CE, 0x02E9CE
    TYA ; Y to stack.
    PHA
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load focus.
    LDA SCRIPT_PARTY_ATTRIBUTES[32],Y ; Load attr.
    BEQ ATTR[0]_CLEAR ; Clear, goto.
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load focus.
    BMI FOCUS_NEGATIVE ; Negative, goto.
    LDA SCRIPT_PARTY_ATTRIBUTES+17,Y ; Load attr ??
    AND #$06 ; Keep 0000.0110
    EOR #$06 ; Invert bits ??
    BEQ ATTR[0]_CLEAR ; == 0, goto.
FOCUS_NEGATIVE: ; 17:09E4, 0x02E9E4
    INY ; Focus++
    TYA ; Y to A
    STA BATTLE_ARRAY_UNK[5],X ; Store to ??
    INX ; Index++
    TXA ; X to stack.
    PHA
    JSR SUB_FILES_MOD_PARTY_TODO_UNK ; Do ??
    LDA #$0C ; File ??
    JSR LIB_BANK_0_FILES_COORDS_BATTLE_MENU?_UNK ; Do menu?
    INC GFX_COORD_VERTICAL_OFFSET ; Coord++
    PLA ; Restore X.
    TAX
ATTR[0]_CLEAR: ; 17:09F8, 0x02E9F8
    CLC ; Prep add.
    LDA SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load attr.
    ADC #$20 ; += 0x20
    STA SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Store to.
    PLA ; Pull index.
    TAY
    DEY ; Index--
    BNE INDEX_NONZERO_LOOP ; != 0, goto.
    PLA
    STA SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Restore attr ??
    RTS ; Leave.
FILE_MENU_THINGY_PROBS?: ; 17:0A08, 0x02EA08
    LDA #$0E ; File.
    JSR LIB_BANK_0_FILES_COORDS_BATTLE_MENU?_UNK ; File ??
    JSR SUB_TODO_A_MEDIUM_MENU?
    JSR SUB_TODO_B_MENU_UNK
    BCS EXIT_RET_CS ; Ret CS, goto.
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load focus.
    LDA MENU_SELECTED_SUBMENU_OPTION_INDEX_FINAL ; Load option index final.
    STA SCRIPT_PARTY_ATTRIBUTES+16,Y ; Store to party.
    LDY MENU_SELECTED_SUBMENU_OPTION_INDEX_FINAL ; Load the item ID stored?
    LDA [BATTLE_PARTY_FPTR_DATA_TODO[2]],Y ; Load file.
    JSR SCRIPT_BATTLE_ID_TO_PTR_UNK ; Do sub.
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load focus.
    JSR SCRIPT_CHECK_ATTR_BIT_SET_UNK_TODO ; Do sub.
    BCS RET_CS ; CS, goto.
    JSR ENGINE_SCRIPT_HELP_MAPPER_R6_TO_0x00 ; Do data.
    LDY #$05 ; Stream index.
    LDA [LIB_BCD2/EXTRA_FILE_STREAM_INDEX],Y ; Load from file.
    JSR ENGINE_SET_MAPPER_R6_TO_0x16 ; Data bank.
    CMP #$00 ; If _ #$00
    BEQ VAL_EQ_0x00 ; == 0, goto.
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load focus.
    STA SCRIPT_PARTY_ATTRIBUTES+29,Y ; Store nonzero to attrs.
    JSR PARTY_ATTR_HELPER_TODO_BETTER_MENU? ; Do ??
    BCS EXIT_RET_CS ; Ret CS, goto.
    RTS ; Leave.
RET_CS: ; 17:0A43, 0x02EA43
    LDX SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load focus.
    JSR SUB_FILES_MOD_PARTY_TODO_UNK ; Do sub.
    LDX #$14 ; Seed ??
    BNE VAL_NONZERO ; != 0, goto.
VAL_EQ_0x00: ; 17:0A4C, 0x02EA4C
    LDX #$10 ; Seed ??
    JSR ENGINE_SCRIPT_HELP_MAPPER_R6_TO_0x00 ; Bank.
    LDY #$03 ; Stream index.
    LDA [LIB_BCD2/EXTRA_FILE_STREAM_INDEX],Y ; Load from file.
    JSR ENGINE_SET_MAPPER_R6_TO_0x16 ; Do sub.
    CMP #$00 ; If _ #$00
    BEQ VAL_NONZERO ; == 0, goto.
    LDX #$11 ; Seed alt ??
VAL_NONZERO: ; 17:0A5E, 0x02EA5E
    TXA ; X to A.
    JSR LIB_BANK_0_FILES_COORDS_BATTLE_MENU?_UNK ; Do ??
    JSR SCRIPT_CTRL_WAIT_A/B_PRESSED ; Script.
EXIT_RET_CS: ; 17:0A65, 0x02EA65
    SEC ; Ret CS.
    RTS
SUB_TODO_A_MEDIUM_MENU?: ; 17:0A67, 0x02EA67
    LDY #$00 ; Stream index reset.
INDEX_NE_0x8_LOOP: ; 17:0A69, 0x02EA69
    TYA ; Save index val.
    PHA
    AND #$01 ; Keep even/odd.
    TAX ; To X index.
    LDA DATA_HOFFSET_TODO,X ; Move Hoff.
    STA GFX_COORD_HORIZONTAL_OFFSET
    TYA ; Y to A.
    LSR A ; >> 1, /2.
    TAX ; To X index.
    LDA DATA_VOFFSET_TODO,X ; Move Voff.
    STA GFX_COORD_VERTICAL_OFFSET
    LDA [BATTLE_PARTY_FPTR_DATA_TODO[2]],Y ; Load from file.
    BEQ FILE_EQ_0x00 ; == 0, goto.
    JSR SCRIPT_BATTLE_ID_TO_PTR_UNK ; Do script ??
    JSR ENGINE_SCRIPT_HELP_MAPPER_R6_TO_0x00 ; Battle data.
    LDA #$04
    STA R_**:$0588 ; Clear ??
    LDY #$00 ; Stream index.
    LDA [LIB_BCD2/EXTRA_FILE_STREAM_INDEX],Y ; Move fptr.
    STA FILE_BATTLE_PTR_UNK[2] ; Store to.
    INY ; Stream++
    LDA [LIB_BCD2/EXTRA_FILE_STREAM_INDEX],Y ; Move ??
    STA FILE_BATTLE_PTR_UNK+1
    LDA #$0F ; Seed menu.
    JSR LIB_BANK_0_FILES_COORDS_BATTLE_MENU?_UNK ; Do menu.
FILE_EQ_0x00: ; 17:0A9C, 0x02EA9C
    PLA ; Restore Y
    TAY
    INY ; Y++
    CPY #$08 ; If _ #$08
    BNE INDEX_NE_0x8_LOOP ; !=, goto.
    RTS ; Leave.
SCRIPT_BATTLE_ID_TO_PTR_UNK: ; 17:0AA4, 0x02EAA4
    LDX #$00 ; Seed clear.
    STX LIB_BCD/EXTRA_FILE_D ; Clear.
    LDX #$03 ; Count to move.
SHIFT/ROTATE_ITERATION: ; 17:0AAA, 0x02EAAA
    ASL A ; Shift from A.
    ROL LIB_BCD/EXTRA_FILE_D ; Rotate into var.
    DEX ; Count--
    BNE SHIFT/ROTATE_ITERATION ; !=, goto.
    CLC ; Prep add.
    ADC #$00 ; Add with.
    STA LIB_BCD2/EXTRA_FILE_STREAM_INDEX ; Store to.
    LDA LIB_BCD/EXTRA_FILE_D ; Load PTR H.
    ADC #$98 ; Add with, 0x9800 based.
    STA LIB_BCD/EXTRA_FILE_D ; (A * 8) + 0x9800 for slot.
    RTS ; Leave.
SCRIPT_ENEMY_FOCUS_INDEX_PTR_TO_NEXT_SLOT/DATA: ; 17:0ABC, 0x02EABC
    CLC ; Prep add.
    LDA PARTY_ATTR_PTR[2],Y ; Load ptr from enemy.
    ADC #$20 ; Add with.
    STA LIB_BCD/EXTRA_FILE_BCD_A ; Store to.
    LDA PARTY_ATTR_PTR+1,Y ; Load ??
    ADC #$00 ; Carry add.
    STA LIB_BCD/EXTRA_FILE_BCD_B ; Store to.
    RTS ; Leave.
SCRIPT_BATTLE_MOVE_ARR_UNK: ; 17:0ACC, 0x02EACC
    JSR ENGINE_SCRIPT_HELP_MAPPER_R6_TO_0x00 ; Battle data.
    LDA #$21
    STA BATTLE_ARRAY_UNK[5] ; Set ??
    LDY #$00 ; Stream index.
    LDA [LIB_BCD2/EXTRA_FILE_STREAM_INDEX],Y ; Move ??
    STA BATTLE_ARRAY_UNK+1
    INY ; Stream++
    LDA [LIB_BCD2/EXTRA_FILE_STREAM_INDEX],Y ; Move ??
    STA BATTLE_ARRAY_UNK+2
    LDA #$00 ; Clear ??
    STA BATTLE_ARRAY_UNK+3
    JMP ENGINE_SET_MAPPER_R6_TO_0x16 ; Exit R6 0x16.
SUB_TODO_B_MENU_UNK: ; 17:0AE9, 0x02EAE9
    LDA #$95
    STA FPTR_MENU_PRIMARY[2] ; Seed menu.
    LDA #$9F
    STA FPTR_MENU_PRIMARY+1
    LDA BATTLE_PARTY_FPTR_DATA_TODO[2] ; Move to submenu.
    STA FPTR_MENU_SECONDARY/SUBMENU[2]
    LDA BATTLE_PARTY_FPTR_DATA_TODO+1
    STA FPTR_MENU_SECONDARY/SUBMENU+1
    JSR ENGINE_MENU_INIT_MASTER_PARTIAL ; Partial init.
    BIT SCRIPT_MENU_STATUS ; Test status.
    BVS EXIT_RET_CS ; B pressed, go back.
    BMI EXIT_A_PRESSED ; A pressed, goto.
    JMP SUB_TODO_B_MENU_UNK ; Continue.
EXIT_A_PRESSED: ; 17:0B05, 0x02EB05
    LDA #$0C
    JSR SCRIPT_BATTLE_MENU_TODO ; File ??
    LDA MENU_SELECTED_SUBMENU_OPTION_INDEX_FINAL ; Load option.
    CLC ; Ret CC, pass.
    RTS ; Leave.
EXIT_RET_CS: ; 17:0B0E, 0x02EB0E
    SEC ; Ret CS.
    RTS ; Leave.
SUB_FILE_DATA_TEST_INIT: ; 17:0B10, 0x02EB10
    LDY #$01 ; Seed index.
CONSOME_STREAM_DATA_LOOP: ; 17:0B12, 0x02EB12
    LDA [BATTLE_PARTY_FPTR_DATA_TODO[2]],Y ; Load from file.
    BEQ NEXT_ITERATION ; == 0, goto.
    TYA ; Save index.
    PHA
    LDA #$0E ; Seed file.
    JSR LIB_BANK_0_FILES_COORDS_BATTLE_MENU?_UNK ; Do menu?
    LDA #$12 ; Seed file.
    JSR LIB_BANK_0_FILES_COORDS_BATTLE_MENU?_UNK ; Do menu?
    JSR Y_MULTIPLY_UNK
    JSR CONTINUE_MENU_PRIMARY ; Do.
    PLA ; Pull index.
    TAY
    CPX #$01 ; Ret _ #$01
    BEQ RET_EQ_0x01 ; == 0, goto.
    CPX #$02 ; Ret _ #$02
    BEQ EXIT_CS ; ==, goto.
NEXT_ITERATION: ; 17:0B32, 0x02EB32
    INY ; Stream++
    CPY #$08 ; If _ #$08
    BEQ SUB_FILE_DATA_TEST_INIT ; == 0, goto.
    BNE CONSOME_STREAM_DATA_LOOP ; != 0, goto.
RET_EQ_0x01: ; 17:0B39, 0x02EB39
    LDY MENU_SELECTED_SUBMENU_OPTION_INDEX_FINAL ; Load option.
    LDA CHARACTER_NAMES_ARR[8],Y ; Load arr.
    JSR LIB_PTR_CREATE_UNK ; Do lib.
    JSR ENGINE_SCRIPT_HELP_MAPPER_R6_TO_0x00 ; R6 to 0x00.
    LDY #$05 ; Stream index.
    LDA [LIB_BCD2/EXTRA_FILE_STREAM_INDEX],Y ; Load from created.
    BEQ VAL_EQ_0x00 ; == 0, goto.
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load focus.
    STA SCRIPT_PARTY_ATTRIBUTES+29,Y ; Store value to attr.
    PHA ; Save value.
    JSR ENGINE_SET_MAPPER_R6_TO_0x16 ; R6 to 0x16.
    PLA ; Pull value.
    JMP PARTY_ATTR_HELPER_TODO_BETTER_MENU? ; Goto.
VAL_EQ_0x00: ; 17:0B57, 0x02EB57
    LDA #$10 ; Seed ??
    JSR LIB_BANK_0_FILES_COORDS_BATTLE_MENU?_UNK ; Do menu?
    JSR SCRIPT_CTRL_WAIT_A/B_PRESSED ; Wait A/B.
EXIT_CS: ; 17:0B5F, 0x02EB5F
    SEC ; Ret CS.
    RTS
Y_MULTIPLY_UNK: ; 17:0B61, 0x02EB61
    TYA ; Y to A.
    ASL A ; << 3, *8.
    ASL A
    ASL A
    STA LIB_BCD/EXTRA_FILE_BCD_A ; Store val.
    LDA #$80
    STA LIB_BCD/EXTRA_FILE_BCD_B ; Set mask?
    LDX #$00 ; Seed index.
LOOP_CLEAR/MOVE_NAME?: ; 17:0B6D, 0x02EB6D
    LDA #$00 ; Load clear.
    STA CHARACTER_NAMES_ARR[8],X ; Store to arr.
    LDA [BATTLE_PARTY_FPTR_DATA_TODO[2]],Y ; Load from file.
    AND LIB_BCD/EXTRA_FILE_BCD_B ; Mask with.
    BEQ MASK_EQ_0x00 ; == 0, goto.
    LDA LIB_BCD/EXTRA_FILE_BCD_A ; Move ??
    STA CHARACTER_NAMES_ARR[8],X
MASK_EQ_0x00: ; 17:0B7D, 0x02EB7D
    INC LIB_BCD/EXTRA_FILE_BCD_A ; ++
    INX ; Index++
    LSR LIB_BCD/EXTRA_FILE_BCD_B ; >> 1, /2.
    BCC LOOP_CLEAR/MOVE_NAME? ; Clear, loop.
    LDY #$00 ; Index ??
FILE_NE_TO_0x8: ; 17:0B86, 0x02EB86
    TYA ; Y to stack.
    PHA
    AND #$01 ; Keep even/odd.
    TAX ; To X.
    LDA DATA_HOFFSET_TODO,X ; Load indexed.
    STA GFX_COORD_HORIZONTAL_OFFSET ; Store to.
    TYA ; Y to A.
    LSR A ; >> 1, /2.
    TAX ; To X index.
    LDA DATA_VOFFSET_TODO,X ; Move offset.
    STA GFX_COORD_VERTICAL_OFFSET
    LDA CHARACTER_NAMES_ARR[8],Y ; Load arr.
    BEQ ARRAY_CLEAR ; == 0, goto.
    JSR LIB_PTR_CREATE_UNK ; Do lib.
    JSR ENGINE_SCRIPT_HELP_MAPPER_R6_TO_0x00 ; Do lib, R6 0x00.
    LDA #$04
    STA R_**:$0588 ; Set ??
    LDY #$00 ; Stream index.
    LDA [LIB_BCD2/EXTRA_FILE_STREAM_INDEX],Y ; Move PTR?
    STA FILE_BATTLE_PTR_UNK[2]
    INY
    LDA [LIB_BCD2/EXTRA_FILE_STREAM_INDEX],Y
    STA FILE_BATTLE_PTR_UNK+1
    LDA #$0F ; File.
    JSR LIB_BANK_0_FILES_COORDS_BATTLE_MENU?_UNK ; Do menu.
ARRAY_CLEAR: ; 17:0BBA, 0x02EBBA
    PLA ; Restore index.
    TAY
    INY ; Stream++
    CPY #$08 ; If _ #$08
    BNE FILE_NE_TO_0x8 ; !=, goto.
    RTS ; Leave.
CONTINUE_MENU_PRIMARY: ; 17:0BC2, 0x02EBC2
    LDA #$A7
    STA FPTR_MENU_PRIMARY[2] ; Move file master.
    LDA #$9F
    STA FPTR_MENU_PRIMARY+1
    JSR ENGINE_MENU_INIT_MASTER_FULL ; Do init.
    LDA SCRIPT_MENU_STATUS ; Load status.
    AND #$06 ; Test TODO buttons.
    BNE CONTINUE_MENU_SECONDARY ; != 0, goto.
    LDA SCRIPT_MENU_STATUS ; Load again.
    AND #$81 ; Test TODO
    BNE TEST_SET_A/DIR ; != 0, set, goto.
    BIT SCRIPT_MENU_STATUS ; Test status.
    BVS MENU_B_PRESSED ; Set, goto.
    JMP CONTINUE_MENU_PRIMARY ; Continue.
TEST_SET_A/DIR: ; 17:0BE0, 0x02EBE0
    LDX #$00 ; Load ??
    RTS ; Ret val.
MENU_B_PRESSED: ; 17:0BE3, 0x02EBE3
    LDX #$02 ; Load ??
    RTS ; Ret val.
CONTINUE_MENU_SECONDARY: ; 17:0BE6, 0x02EBE6
    LDA #$9D
    STA FPTR_MENU_PRIMARY[2] ; Seed menu main.
    LDA #$9F
    STA FPTR_MENU_PRIMARY+1
    JSR ENGINE_MENU_INIT_MASTER_FULL ; Init it.
    LDA SCRIPT_MENU_STATUS ; Load status.
    AND #$08 ; Keep TODO button.
    BNE CONTINUE_MENU_PRIMARY ; != 0, goto.
    BIT SCRIPT_MENU_STATUS ; Test status.
    BVS STATUS_B_PRESSED ; B set, goto.
    BMI STATUS_A_PRESSED ; A set, goto.
    JMP CONTINUE_MENU_PRIMARY ; Continue.
STATUS_A_PRESSED: ; 17:0C00, 0x02EC00
    LDX #$01 ; Load ??
    RTS
STATUS_B_PRESSED: ; 17:0C03, 0x02EC03
    LDX #$02 ; Load ??
    RTS
BATTLE_SEED_UNKNOWN_UPDATE_PACKET_DISPLAY: ; 17:0C06, 0x02EC06
    LDA #$0A ; Seed ??
    JSR LIB_BANK_0_FILES_COORDS_BATTLE_MENU?_UNK ; Do library.
    JSR SUB_FILES_MOD_PARTY_TODO_UNK ; Do sub.
    JSR ENGINE_SCRIPT_HELP_MAPPER_R6_TO_0x00 ; Do R6 to 0x00.
    LDA #$00
    STA R_**:$0070 ; Clear ??
    LDA #$7A
    STA FPTR_PACKET_CREATION/PTR_H_FILE_IDK[2] ; Set PTR 00:0E7A for update packet.
    LDA #$8E
    STA FPTR_PACKET_CREATION/PTR_H_FILE_IDK+1
    JSR ENGINE_CREATE_UPDATE_BUF_INIT_DEC? ; Upload it.
    JMP ENGINE_SET_MAPPER_R6_TO_0x16 ; To R6 0x16.
SCRIPT_BATTLE_HELPER_MAKE_TIMES_FOR_EFFECT?: ; 17:0C23, 0x02EC23
    PHA ; Save val.
    AND #$03 ; Keep lower.
    TAX ; To X.
    INX ; X++
    LDA #$01 ; Seed ??
    SEC ; Rotate CS.
ROTATE_CS_UNK: ; 17:0C2B, 0x02EC2B
    ROR A ; Rotate 2 times.
    ROR A
    DEX ; Count--
    BNE ROTATE_CS_UNK ; != 0, goto.
    STA LIB_BCD/EXTRA_FILE_BCD_A ; Store to.
    PLA ; Pull stack.
    LSR A ; >> 2, /4.
    LSR A
    TAY ; To Y index.
    LDA 16:1EC7,Y ; I think this is R16, but TODO verify.
    AND LIB_BCD/EXTRA_FILE_BCD_A ; Mask with.
    STA LIB_BCD/EXTRA_FILE_BCD_B ; Store to.
SHIFT_LOOP: ; 17:0C3D, 0x02EC3D
    LSR LIB_BCD/EXTRA_FILE_BCD_A ; >>
    BCS EXIT_RET_VAL_UNK ; CS, goto.
    LSR LIB_BCD/EXTRA_FILE_BCD_B ; >> 1, /2.
    JMP SHIFT_LOOP ; Goto.
EXIT_RET_VAL_UNK: ; 17:0C46, 0x02EC46
    LDA LIB_BCD/EXTRA_FILE_BCD_B ; Return val.
    RTS ; Leave.
SCRIPT_CHECK_ATTR_BIT_SET_UNK_TODO: ; 17:0C49, 0x02EC49
    JSR ENGINE_SCRIPT_HELP_MAPPER_R6_TO_0x00 ; Helper data.
    LDA SCRIPT_PARTY_ATTRIBUTES+17,Y ; Load attr ??
    STA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2] ; Store to.
    TAX ; To X index. Bit move count.
    SEC ; Prep carry into.
    LDA #$00 ; Seed ??
SHIFTS_TODO: ; 17:0C55, 0x02EC55
    ROL A ; Rotate it.
    DEX ; Count--
    BNE SHIFTS_TODO ; != 0, loop, move moves.
    STA ALT_COUNT_UNK ; Store bit.
    LDY #$02 ; Stream index.
    LDA [LIB_BCD2/EXTRA_FILE_STREAM_INDEX],Y ; Load from file.
    JSR ENGINE_SET_MAPPER_R6_TO_0x16 ; Do data always.
    AND ALT_COUNT_UNK ; Combine with.
    BEQ EXIT_RET_CS ; == 0, goto.
    CLC ; Exit CC.
    RTS
EXIT_RET_CS: ; 17:0C68, 0x02EC68
    SEC ; Exit CS.
    RTS
SUB_TODO: ; 17:0C6A, 0x02EC6A
    JSR SUB_REPLACE_COUNT_UNK_TODO ; Do ??
    BCS EXIT_CS ; Ret CS, goto.
    LDX #$08 ; Seed count.
LOOP_COUNT_NONZERO: ; 17:0C71, 0x02EC71
    TXA ; X to A.
    PHA ; Save it.
    JSR UNK_SUB_A ; Do.
    JSR UNK_SUB_B ; Do.
    LDA #$FF ; Seed ??
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load index.
    STA SCRIPT_PARTY_ATTRIBUTES+29,Y ; Set ??
    JSR SUB_REPLACE_COUNT_UNK_TODO ; Do sub.
    BCS EXIT_STACK_FIX_RET_CS ; CS, goto.
    PLA
    TAX ; Restore X.
    DEX ; Index--
    BNE LOOP_COUNT_NONZERO ; != 0, goto.
    DEC SCRIPT_UNK_BATTLE?_OBJECT_ID_FOCUSED? ; --
    BEQ COUNT_EQ_0x00 ; == 0, goto.
    CLC ; Ret CC.
    RTS
EXIT_STACK_FIX_RET_CS: ; 17:0C90, 0x02EC90
    PLA ; Pull ??
EXIT_CS: ; 17:0C91, 0x02EC91
    SEC ; Ret CS.
    RTS
COUNT_EQ_0x00: ; 17:0C93, 0x02EC93
    LDA 56_OBJECT_NAME_SIZE? ; Load ??
    CMP #$01 ; If _ #$01
    BEQ EXIT_CS ; ==, goto.
    LDX #$64 ; Wait a long time.
    JSR ENGINE_WAIT_X_SETTLES ; Wait.
    LDA #$92 ; Do ??
    JSR SCRIPT_TEXT_AND_REENTER_THINGY??? ; Goto.
EXIT_CS: ; 17:0CA3, 0x02ECA3
    SEC ; Ret CS.
    RTS
UNK_SUB_A: ; 17:0CA5, 0x02ECA5
    LDA #$00
    STA LIB_BCD/EXTRA_FILE_BCD_A ; Clear ??
    STA LIB_BCD/EXTRA_FILE_BCD_B
LOOP_ON_PAGE: ; 17:0CAB, 0x02ECAB
    LDY LIB_BCD/EXTRA_FILE_BCD_A ; Load index.
    LDA SCRIPT_PARTY_ATTRIBUTES+29,Y ; Load from arr.
    CMP #$FF ; If _ #$FF
    BEQ ITERATION_STEP_FORWARD ; ==, goto.
    CMP #$5E ; If _ #$5E
    BEQ EXIT_STORE_Y ; ==, goto.
    LDA SCRIPT_PARTY_ATTRIBUTES+12,Y ; Load from deeper.
    JSR ENGINE_LIB_STASH_EXTRA_FILE_AND_SWITCH_UNK ; Do rtn.
    CMP LIB_BCD/EXTRA_FILE_BCD_B ; If _ var
    BCC ITERATION_STEP_FORWARD ; CC, goto.
    STA LIB_BCD/EXTRA_FILE_BCD_B ; Store ??
    LDA LIB_BCD/EXTRA_FILE_BCD_A ; Move ??
    STA LIB_BCD2/EXTRA_FILE_STREAM_INDEX
ITERATION_STEP_FORWARD: ; 17:0CC8, 0x02ECC8
    CLC ; Prep add.
    LDA LIB_BCD/EXTRA_FILE_BCD_A ; Load.
    ADC #$20 ; += 0x20
    STA LIB_BCD/EXTRA_FILE_BCD_A ; Store back.
    BNE LOOP_ON_PAGE ; != 0, loop.
    LDY LIB_BCD2/EXTRA_FILE_STREAM_INDEX ; Load ??
EXIT_STORE_Y: ; 17:0CD3, 0x02ECD3
    STY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Store ??
    RTS
UNK_SUB_B: ; 17:0CD6, 0x02ECD6
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load ??
    LDA SCRIPT_PARTY_ATTRIBUTES[32],Y ; Load ??
    BNE VAL_NONZERO ; != 0, goto.
    LDA #$00 ; Load ??
    JMP JMP_SCRIPT_REENTER_UNK ; Goto lib.
VAL_NONZERO: ; 17:0CE2, 0x02ECE2
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y ; Load ??
    AND #$80 ; Keep ??
    BEQ UPPER_CLEAR_A ; == 0, goto.
    LDA #$00 ; Seed ??
    JMP JMP_SCRIPT_REENTER_UNK ; Goto.
UPPER_CLEAR_A: ; 17:0CEE, 0x02ECEE
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y ; Load ??
    AND #$40 ; Keep ??
    BEQ UPPER_CLEAR_B ; Clear, goto.
    LDA #$47 ; Seed ??
    JMP JMP_SCRIPT_REENTER_UNK ; Reenter.
UPPER_CLEAR_B: ; 17:0CFA, 0x02ECFA
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y ; Load ??
    AND #$20 ; Keep ??
    BEQ UPPER_CLEAR_C ; == 0, goto.
    LDA #$46 ; Seed ??
    JMP JMP_SCRIPT_REENTER_UNK ; Goto.
UPPER_CLEAR_C: ; 17:0D06, 0x02ED06
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y ; Load ??
    AND #$10 ; Keep ??
    BEQ UPPER_CLEAR_D ; == 0, goto.
    JSR RANDOMIZE_GROUP_A ; Randomize.
    AND #$E0 ; Keep upper 1110.000
    BNE EXIT_SEED_0x3C ; Set, goto.
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y ; Load ??
    AND #$EF ; Keep 1110.1111
    STA SCRIPT_PARTY_ATTRIBUTES+1,Y ; Store to.
    STY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Store index.
    JSR LIB_SCRIPT_HELPER_CREATE_DISPLAY_PACKET_HELPER ; Do ??
    LDA #$8E ; Seed ??
    JMP JMP_SCRIPT_REENTER_UNK ; Goto.
EXIT_SEED_0x3C: ; 17:0D26, 0x02ED26
    LDA #$3C ; Seed ??
    JMP JMP_SCRIPT_REENTER_UNK ; Goto.
UPPER_CLEAR_D: ; 17:0D2B, 0x02ED2B
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y ; Load ??
    AND #$04 ; Keep 0000.0100
    BEQ LOWER_CLEAR_A ; == 0, goto.
    LDA #$68 ; Seed ??
    JMP JMP_SCRIPT_REENTER_UNK ; Reenter.
LOWER_CLEAR_A: ; 17:0D37, 0x02ED37
    LDA SCRIPT_PARTY_ATTRIBUTES+30,Y ; Load ??
    AND #$02 ; Keep 0000.0010
    BEQ LOWER_CLEAR_B ; == 0, goto.
    LDA SCRIPT_PARTY_ATTRIBUTES+29,Y ; Load ??
    CMP #$76 ; If _ #$76
    BEQ LOWER_CLEAR_B ; ==, goto.
    LDA #$56 ; Seed ??
    JMP JMP_SCRIPT_REENTER_UNK ; Goto.
LOWER_CLEAR_B: ; 17:0D4A, 0x02ED4A
    LDA SCRIPT_PARTY_ATTRIBUTES+30,Y ; Load ??
    AND #$20 ; Keep 0010.0000
    BEQ UPPER_CLEAR_A ; == 0, goto, not set.
    JSR RANDOMIZE_GROUP_A ; Randomize.
    AND #$C0 ; Keep 1100.0000
    BNE EXIT_SEED_0x1C ; != 0, goto.
    LDA SCRIPT_PARTY_ATTRIBUTES+30,Y ; Load ??
    AND #$DF ; Keep 1101.1111
    STA SCRIPT_PARTY_ATTRIBUTES+30,Y ; Store to, cleared.
    LDA #$8B ; Seed ??
    JMP JMP_SCRIPT_REENTER_UNK ; Goto.
EXIT_SEED_0x1C: ; 17:0D65, 0x02ED65
    LDA #$1C ; Seed ??
    JMP JMP_SCRIPT_REENTER_UNK ; Goto.
UPPER_CLEAR_A: ; 17:0D6A, 0x02ED6A
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y ; Load ??
    AND #$08 ; Keep 0000.1000
    BEQ LOWER_CLEAR_ZZZ ; == 0, goto.
    LDA #$3A ; Seed ??
    JSR SCRIPT_TEXT_AND_REENTER_THINGY???
LOWER_CLEAR_ZZZ: ; 17:0D76, 0x02ED76
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load ??
    LDA SCRIPT_PARTY_ATTRIBUTES+29,Y ; Load ??
BATTLE_MAIN_FPTR_INIT_AND_SWITCH: ; 17:0D7B, 0x02ED7B
    LDY #$00 ; Seed clear.
    STY LIB_BCD/EXTRA_FILE_BCD_B ; Clear ??
    ASL A ; << 1, *2.
    ROL LIB_BCD/EXTRA_FILE_BCD_B ; Rotate into.
    STA LIB_BCD/EXTRA_FILE_BCD_A ; Store to.
    CLC ; Prep add.
    LDA #$FB ; Load ??
    ADC LIB_BCD/EXTRA_FILE_BCD_A ; Add with.
    STA LIB_BCD/EXTRA_FILE_BCD_A ; Store to.
    LDA #$97 ; Load ??
    ADC LIB_BCD/EXTRA_FILE_BCD_B ; Add with.
    STA LIB_BCD/EXTRA_FILE_BCD_B ; Store to.
    LDY #$00 ; Stream file.
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y ; Load from file.
    STA FPTR_BATTLE_PTR_UNK_5E[2] ; Store to.
    INY ; Stream++
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y ; Load from file.
    STA FPTR_BATTLE_PTR_UNK_5E+1 ; Store to.
MAIN_BATTLE_SWITCH_RUN_FILE?: ; 17:0D9C, 0x02ED9C
    LDY #$00 ; Stream reset.
    LDA [FPTR_BATTLE_PTR_UNK_5E[2]],Y ; Load from file.
    LSR A ; Nibble down.
    LSR A
    LSR A
    LSR A
    JSR SWITCH_TABLE_PAST_JSR_HELPER ; Switch with.
    LOW(RTN_A_ADVANCE_SWITCH_FILE_0x1) ; Advance.
    HIGH(RTN_A_ADVANCE_SWITCH_FILE_0x1) ; 0x00
    LOW(RTN_B_FILE_SUBSWITCH_A) ; Subswitch.
    HIGH(RTN_B_FILE_SUBSWITCH_A) ; 0x01
    LOW(RTN_C_HEADER_SHIFT_UNK_TODO)
    HIGH(RTN_C_HEADER_SHIFT_UNK_TODO) ; 0x02
    LOW(RTN_D)
    HIGH(RTN_D) ; 0x03
    LOW(RTN_E_FILE_SUBSWITCH_B)
    HIGH(RTN_E_FILE_SUBSWITCH_B) ; 0x04
    LOW(RTN_F_FILE_SUBSWITCH_C)
    HIGH(RTN_F_FILE_SUBSWITCH_C) ; 0x05
    LOW(RTN_G_FILE_SUBSWITCH_AND_UNK)
    HIGH(RTN_G_FILE_SUBSWITCH_AND_UNK) ; 0x06
    LOW(RTN_H)
    HIGH(RTN_H) ; 0x07
    LOW(RTN_I)
    HIGH(RTN_I) ; 0x08
    LOW(RTN_J_FILE_GOSUB?)
    HIGH(RTN_J_FILE_GOSUB?) ; 0x09
    LOW(RTN_K_GOTO_AND_RESWITCH)
    HIGH(RTN_K_GOTO_AND_RESWITCH) ; 0x0A
    LOW(RTN_L_INTO_AND_SAVE_TODO_SWAPPY)
    HIGH(RTN_L_INTO_AND_SAVE_TODO_SWAPPY) ; 0x0B
    LOW(RTN_M)
    HIGH(RTN_M) ; 0x0C
JMP_SCRIPT_REENTER_UNK: ; 17:0DC1, 0x02EDC1
    JMP SCRIPT_TEXT_AND_REENTER_THINGY??? ; Goto.
RTN_A_ADVANCE_SWITCH_FILE_0x1: ; 17:0DC4, 0x02EDC4
    LDA #$01
    JMP ADVANCE_FPTR_UNK_0x1_BY_A ; Advance exit.
RTN_B_FILE_SUBSWITCH_A: ; 17:0DC9, 0x02EDC9
    LDY #$00 ; Reset stream.
    LDA [FPTR_BATTLE_PTR_UNK_5E[2]],Y ; Load from file.
    AND #$0F ; Keep lower.
    JSR SWITCH_TABLE_PAST_JSR_WITH_PTR[0]_AS_RET_CATCH ; Switch with lower.
    LOW(RTN_A_ALT_ADVANCE_0x1_RESWITCH_MAIN)
    HIGH(RTN_A_ALT_ADVANCE_0x1_RESWITCH_MAIN)
    LOW(RTN_B_ALT_FOCUS_AND_ENTRY)
    HIGH(RTN_B_ALT_FOCUS_AND_ENTRY)
    LOW(RTN_C_ALT_FOCUS_COMMITTING_AND_GOTO)
    HIGH(RTN_C_ALT_FOCUS_COMMITTING_AND_GOTO)
    LOW(RTN_D_ALT_NEGATIVE_NORMAL_BLACK_HIT_POSITIVE_UNK)
    HIGH(RTN_D_ALT_NEGATIVE_NORMAL_BLACK_HIT_POSITIVE_UNK)
    LOW(RTN_E_ALT) ; GFX/Script black.
    HIGH(RTN_E_ALT)
    LOW(RTN_F_ALT) ; Scripty.
    HIGH(RTN_F_ALT)
    LOW(RTN_G_ALT) ; Scripty.
    HIGH(RTN_G_ALT)
    LOW(RTN_H_ALT) ; 0x2 unk
    HIGH(RTN_H_ALT)
    LOW(RTN_I_ALT) ; Red.
    HIGH(RTN_I_ALT)
    LOW(RTN_J_ALT) ; Purplish.
    HIGH(RTN_J_ALT)
    LOW(RTN_K_ALT) ; Blueish.
    HIGH(RTN_K_ALT)
    LOW(RTN_L_ALT) ; Yellow.
    HIGH(RTN_L_ALT)
    LOW(RTN_M_ALT) ; Green extended.
    HIGH(RTN_M_ALT)
RTN_A_ALT_ADVANCE_0x1_RESWITCH_MAIN: ; 17:0DEC, 0x02EDEC
    LDA #$01 ; Advance seed.
    JMP HELPER_0x17_ADVANCE_A_AND_RESWITCH_MAIN ; Advance and reswitch.
RTN_C_HEADER_SHIFT_UNK_TODO: ; 17:0DF1, 0x02EDF1
    LDY #$01 ; Stream header.
    LDA [FPTR_BATTLE_PTR_UNK_5E[2]],Y ; Load from file.
    LDX #$00 ; Seed clear.
    STX LIB_BCD/EXTRA_FILE_BCD_B ; Clear.
    LDX #$03 ; Seed count to do. For smoller code. Nice.
ROTATION_LOOP: ; 17:0DFB, 0x02EDFB
    ASL A ; << 1, *2.
    ROL LIB_BCD/EXTRA_FILE_BCD_B ; Rotate into.
    DEX ; Times--
    BNE ROTATION_LOOP ; != 0, goto.
    CLC ; Prep add.
    ADC #$00 ; Add with.
    STA LIB_BCD/EXTRA_FILE_BCD_A ; Store to. TODO: Clear it just?
    LDA LIB_BCD/EXTRA_FILE_BCD_B ; Load ??
    ADC #$9E ; Add with.
    STA LIB_BCD/EXTRA_FILE_BCD_B ; Store to.
    JSR ENGINE_SCRIPT_HELP_MAPPER_R6_TO_0x00 ; R6 to 0x00.
    LDY #$07 ; Stream index.
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y ; Load from file.
    STA SUB/MOD_VAL_UNK_WORD[2] ; Store to, L.
    LDA #$00 ; Clear H.
    STA SUB/MOD_VAL_UNK_WORD+1
    LDA #$21
    STA BATTLE_ARRAY_UNK[5] ; Seed ??
    LDY #$00 ; Stream index.
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y ; Move ??
    STA BATTLE_ARRAY_UNK+1
    INY ; Stream++
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y ; Move ??
    STA BATTLE_ARRAY_UNK+2
    LDA #$00
    STA BATTLE_ARRAY_UNK+3 ; Clear ??
    JSR ENGINE_SET_MAPPER_R6_TO_0x16 ; R6 to  0x16
    LDA #$64 ; Seed ??
    JSR SCRIPT_TEXT_AND_REENTER_THINGY??? ; Do script.
    JSR SCRIPT_ATTR_INVERT_TEST_UNK ; Do ??
    BCC SCRIPT_CC_A ; CC, goto.
    JSR SCRIPT_TEST_VALS_UNK ; Test TODO stats?
    BCC SCRIPT_CC_B ; CC, goto.
    JSR SCRIPT_LAUNCH_SUB_TODO ; Do ??
    LDA SCRIPT_EFFECT_SFX_AND_SCRIPT_DO_UNK_GIVE_ITEM? ; Load ??
    JSR LIB_PLAY_BATTLE_SFX_A_PASSED_WITH_SCRIPT_DOING_TODO ; Do lib.
    LDA #$00
    STA SCRIPT_EFFECT_SFX_AND_SCRIPT_DO_UNK_GIVE_ITEM? ; Clear it.
    LDA #$02 ; Advance AMT.
    JMP HELPER_0x17_ADVANCE_A_AND_RESWITCH_MAIN ; Goto.
SCRIPT_CC_A: ; 17:0E53, 0x02EE53
    LDA #$51 ; Script ??
    JMP SCRIPT_TEXT_AND_REENTER_THINGY???
SCRIPT_CC_B: ; 17:0E58, 0x02EE58
    LDA #$54 ; Script ??
    JMP SCRIPT_TEXT_AND_REENTER_THINGY???
RTN_D: ; 17:0E5D, 0x02EE5D
    LDY #$01 ; Stream index.
    LDA [FPTR_BATTLE_PTR_UNK_5E[2]],Y ; Load file.
    JSR SCRIPT_BATTLE_ID_TO_PTR_UNK ; Do ??
    JSR SCRIPT_BATTLE_MOVE_ARR_UNK ; Do ??
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load focus.
    BMI FOCUS_ENEMY ; Enemy, goto.
    JSR ENGINE_WRAM_STATE_WRITEABLE ; Do WRAM.
    LDY #$00 ; Stream index.
    LDA [FPTR_BATTLE_PTR_UNK_5E[2]],Y ; Load ??
    AND #$0F ; Keep lower.
    CMP #$01 ; If _ #$01
    BNE FOCUS_ENEMY ; !=, goto.
    JSR EXTENSION_MOVE_FILE_DOWN_UNK ; Do ??
FOCUS_ENEMY: ; 17:0E7B, 0x02EE7B
    LDA #$63 ; Seed ??
    JSR SCRIPT_TEXT_AND_REENTER_THINGY??? ; Do text.
    LDA SCRIPT_EFFECT_SFX_AND_SCRIPT_DO_UNK_GIVE_ITEM? ; Load ??
    JSR LIB_PLAY_BATTLE_SFX_A_PASSED_WITH_SCRIPT_DOING_TODO ; Do SFX/script.
    LDA #$00
    STA SCRIPT_EFFECT_SFX_AND_SCRIPT_DO_UNK_GIVE_ITEM? ; Clear it.
    LDA #$02 ; Seed advance.
    JMP HELPER_0x17_ADVANCE_A_AND_RESWITCH_MAIN ; Goto.
RTN_M: ; 17:0E8E, 0x02EE8E
    LDY #$01 ; Stream index.
    LDA [FPTR_BATTLE_PTR_UNK_5E[2]],Y ; Load file.
    JSR SCRIPT_BATTLE_ID_TO_PTR_UNK ; Do sub.
    JSR SCRIPT_BATTLE_MOVE_ARR_UNK ; Do ??
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load focus.
    BMI EXIT_ADVANCE_0x2_AND_RESWITCH ; If negative, goto.
    LDY #$00 ; Stream index.
    LDA [FPTR_BATTLE_PTR_UNK_5E[2]],Y ; Load from file.
    AND #$0F ; Keep lower.
    JSR SWITCH_TABLE_PAST_JSR_HELPER ; Switch on.
    LOW(RTN_A_ALT4) ; TODO: Specific info later.
    HIGH(RTN_A_ALT4)
    LOW(RTN_B_ALT4)
    HIGH(RTN_B_ALT4)
    LOW(RTN_C_ALT4?)
    HIGH(RTN_C_ALT4?)
RTN_A_ALT4: ; 17:0EAB, 0x02EEAB
    JSR RANDOMIZE_GROUP_A ; Randomize.
    AND #$E0 ; Keep focus.
    BNE EXIT_ADVANCE_0x2_AND_RESWITCH ; != 0, goto.
    JSR EXTENSION_MOVE_FILE_DOWN_UNK ; Do sub.
    LDA #$75 ; Load ??
    JSR SCRIPT_TEXT_AND_REENTER_THINGY??? ; Do ??
    JMP EXIT_ADVANCE_0x2_AND_RESWITCH ; Exit advance.
RTN_B_ALT4: ; 17:0EBD, 0x02EEBD
    JSR RANDOMIZE_GROUP_A ; Randomize.
    AND #$E0 ; Keep focus.
    BNE EXIT_ADVANCE_0x2_AND_RESWITCH ; Is not player, do.
    JSR EXTENSION_MOVE_FILE_DOWN_UNK ; Do ??
    LDA #$78 ; Seed ??
    JSR SCRIPT_TEXT_AND_REENTER_THINGY??? ; Do.
    JMP EXIT_ADVANCE_0x2_AND_RESWITCH ; Exit advance.
RTN_C_ALT4?: ; 17:0ECF, 0x02EECF
    JSR ENGINE_WRAM_STATE_WRITEABLE ; WRAM writable.
    DEC CURRENT_SAVE_MANIPULATION_PAGE+31 ; --
    JSR ENGINE_WRAM_STATE_WRITE_DISABLED ; Do sub.
    LDA CURRENT_SAVE_MANIPULATION_PAGE+31 ; Load ??
    BNE EXIT_ADVANCE_0x2_AND_RESWITCH ; != 0, goto.
    JSR EXTENSION_MOVE_FILE_DOWN_UNK ; Do ??
    LDA #$91 ; Seed ??
    JSR SCRIPT_TEXT_AND_REENTER_THINGY??? ; Do.
EXIT_ADVANCE_0x2_AND_RESWITCH: ; 17:0EE5, 0x02EEE5
    LDA #$02 ; Seed advance.
    JMP HELPER_0x17_ADVANCE_A_AND_RESWITCH_MAIN ; Exit advance.
RTN_F_FILE_SUBSWITCH_C: ; 17:0EEA, 0x02EEEA
    LDY #$00 ; Stream index.
    LDA [FPTR_BATTLE_PTR_UNK_5E[2]],Y ; Load from file.
    AND #$0F ; Keep lower.
    JSR SWITCH_TABLE_PAST_JSR_WITH_PTR[0]_AS_RET_CATCH ; Switch with catch.
    LOW(RTN_A_CATCH_ADVANCE_0x1)
    HIGH(RTN_A_CATCH_ADVANCE_0x1)
    LOW(RTN_B_ALT2_NOOP) ; RTS, noop?
    HIGH(RTN_B_ALT2_NOOP)
    LOW(RTN_C_ALT2_ALIVE_THING_UNK)
    HIGH(RTN_C_ALT2_ALIVE_THING_UNK)
    LOW(RTN_D_ALT2_ATTR_THINGY_FRIEND/FOE_MATTERS)
    HIGH(RTN_D_ALT2_ATTR_THINGY_FRIEND/FOE_MATTERS)
    LOW(RTN_E_ALT2_ATTR_SET_RANDOM_UNK)
    HIGH(RTN_E_ALT2_ATTR_SET_RANDOM_UNK)
    LOW(RTN_F_ALT2_FOCUS_ID_TO_OTHER_UNK)
    HIGH(RTN_F_ALT2_FOCUS_ID_TO_OTHER_UNK)
    LOW(RTN_G_ALT2_CLEAR_FRIENDLY_SET_FOE)
    HIGH(RTN_G_ALT2_CLEAR_FRIENDLY_SET_FOE)
    LOW(RTN_H_ALT2_NEXT_ATTR_FOCUS_ALT?)
    HIGH(RTN_H_ALT2_NEXT_ATTR_FOCUS_ALT?)
RTN_A_CATCH_ADVANCE_0x1: ; 17:0F03, 0x02EF03
    LDA #$01 ; Seed switch advance.
    JMP HELPER_0x17_ADVANCE_A_AND_RESWITCH_MAIN ; Exit advance.
RTN_G_FILE_SUBSWITCH_AND_UNK: ; 17:0F08, 0x02EF08
    LDY #$01 ; Stream header.
    LDA [FPTR_BATTLE_PTR_UNK_5E[2]],Y ; Load ??
    STA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2] ; Store to.
    DEY ; Stream--
    LDA [FPTR_BATTLE_PTR_UNK_5E[2]],Y ; Load from stream[0]
    AND #$0F ; Keep lower.
    JSR SWITCH_TABLE_PAST_JSR_WITH_PTR[0]_AS_RET_CATCH ; Switch with.
    LOW(RTN_A_ALT_3_CATCH_ADV_0x2) ; Advance header for this setup.
    HIGH(RTN_A_ALT_3_CATCH_ADV_0x2)
    LOW(RTN_B_ALT3_ATTR_CALC_AND_SUBS_OUTPUT_UNK)
    HIGH(RTN_B_ALT3_ATTR_CALC_AND_SUBS_OUTPUT_UNK)
    LOW(RTN_C_ALT3_ATTR_UNK_OUTPUT_BIGGER_UNK)
    HIGH(RTN_C_ALT3_ATTR_UNK_OUTPUT_BIGGER_UNK)
    LOW(RTN_D_ALT3_MOVE_STATIC_UNK)
    HIGH(RTN_D_ALT3_MOVE_STATIC_UNK)
    LOW(RTN_E_ALT3_IF_UNK_DO_RTN_LOOPED)
    HIGH(RTN_E_ALT3_IF_UNK_DO_RTN_LOOPED)
    LOW(RTN_F_ALT3_COMBINE_UNK)
    HIGH(RTN_F_ALT3_COMBINE_UNK)
    LOW(RTN_G_ALT3_SCRIPT_SWITCH_UNK)
    HIGH(RTN_G_ALT3_SCRIPT_SWITCH_UNK)
    LOW(RTN_H_ALT3_SFX_SCRIPTY_THING)
    HIGH(RTN_H_ALT3_SFX_SCRIPTY_THING)
    LOW(RTN_I_ALT3_MOVE_STATIC_UNK)
    HIGH(RTN_I_ALT3_MOVE_STATIC_UNK)
    LOW(VAL_SCRIPT_MOD_AS_SCRIPT?)
    HIGH(VAL_SCRIPT_MOD_AS_SCRIPT?)
    LOW(RTN_K_ALT3_VAL_SFX_SCRIPT)
    HIGH(RTN_K_ALT3_VAL_SFX_SCRIPT)
RTN_A_ALT_3_CATCH_ADV_0x2: ; 17:0F2C, 0x02EF2C
    LDA #$02 ; Advance seed.
    JMP HELPER_0x17_ADVANCE_A_AND_RESWITCH_MAIN ; Exit advance.
RTN_H: ; 17:0F31, 0x02EF31
    JSR FILE_HEAD_SUBSWITCH ; Do sub.
    BCC EXIT_MAIN_RESTREAM_SELF ; CC, goto.
    JMP EXIT_ADVANCE_0x3 ; Exit advance.
RTN_I: ; 17:0F39, 0x02EF39
    JSR FILE_HEAD_SUBSWITCH ; Subswitch.
    BCC EXIT_ADVANCE_0x3 ; Ret CC, advance Ox3.
EXIT_MAIN_RESTREAM_SELF: ; 17:0F3E, 0x02EF3E
    LDY #$01 ; Stream index.
    LDA [FPTR_BATTLE_PTR_UNK_5E[2]],Y ; File restream self.
    PHA ; Save PTR H.
    INY ; Stream++
    LDA [FPTR_BATTLE_PTR_UNK_5E[2]],Y ; Move PTR L.
    STA FPTR_BATTLE_PTR_UNK_5E+1
    PLA ; Restore PTR H from self.
    STA FPTR_BATTLE_PTR_UNK_5E[2] ; Overwrite.
    JMP MAIN_BATTLE_SWITCH_RUN_FILE? ; Main switch.
EXIT_ADVANCE_0x3: ; 17:0F4E, 0x02EF4E
    LDA #$03 ; Advance 0x3
    JMP HELPER_0x17_ADVANCE_A_AND_RESWITCH_MAIN ; Exit reswitch.
FILE_HEAD_SUBSWITCH: ; 17:0F53, 0x02EF53
    LDY #$00 ; Stream index.
    LDA [FPTR_BATTLE_PTR_UNK_5E[2]],Y ; Load header.
    AND #$0F ; Lower.
    JSR SWITCH_TABLE_PAST_JSR_WITH_PTR[0]_AS_RET_CATCH ; Could have used other switch type, catch is NOOP anyway. TODO
    LOW(RTN_A_ALT5_CATCH_NOOP)
    HIGH(RTN_A_ALT5_CATCH_NOOP)
    LOW(RTN_B_ALT5)
    HIGH(RTN_B_ALT5)
    LOW(RTN_C_ALT5)
    HIGH(RTN_C_ALT5)
    LOW(RTN_D_ALT5_FOCUS_THINGY_CHANCE_UNK)
    HIGH(RTN_D_ALT5_FOCUS_THINGY_CHANCE_UNK)
    LOW(RTN_E_ALT6)
    HIGH(RTN_E_ALT6)
    LOW(RTN_F_ALT5)
    HIGH(RTN_F_ALT5)
    LOW(RTN_G_ALT5)
    HIGH(RTN_G_ALT5)
    LOW(RTN_H_ALT5)
    HIGH(RTN_H_ALT5)
    LOW(RTN_I_ALT5)
    HIGH(RTN_I_ALT5)
    LOW(RTN_J_ALT5_SIMPLE_RANDOMIZE_RET)
    HIGH(RTN_J_ALT5_SIMPLE_RANDOMIZE_RET)
    LOW(RTN_K_ALT5)
    HIGH(RTN_K_ALT5)
    LOW(RTN_L_ALT5)
    HIGH(RTN_L_ALT5)
    LOW(RTN_M_ALT5)
    HIGH(RTN_M_ALT5)
    LOW(RTN_O_ALT5_TEST_ATTR_0x00_UNK)
    HIGH(RTN_O_ALT5_TEST_ATTR_0x00_UNK)
    LOW(RTN_P_ALT5_TEST_OBJS_0x5/0x6_CC_TRUE_CS_FALSE)
    HIGH(RTN_P_ALT5_TEST_OBJS_0x5/0x6_CC_TRUE_CS_FALSE)
RTN_A_ALT5_CATCH_NOOP: ; 17:0F7A, 0x02EF7A
    .db 60 ; Leave.
RTN_J_FILE_GOSUB?: ; 17:0F7B, 0x02EF7B
    LDA FPTR_BATTLE_PTR_UNK_5E+1 ; Save file to stack.
    PHA
    LDA FPTR_BATTLE_PTR_UNK_5E[2]
    PHA
    JSR SCRIPT_BATTLE_MENU?_RESEED_STREAM_SELF ; Restream self. Gosub?
    JSR MAIN_BATTLE_SWITCH_RUN_FILE? ; Main switch again.
    PLA
    STA FPTR_BATTLE_PTR_UNK_5E[2] ; Restore file.
    PLA
    STA FPTR_BATTLE_PTR_UNK_5E+1
    LDA #$03 ; Seed advance.
    JMP HELPER_0x17_ADVANCE_A_AND_RESWITCH_MAIN ; Exit advance.
RTN_K_GOTO_AND_RESWITCH: ; 17:0F92, 0x02EF92
    JSR SCRIPT_BATTLE_MENU?_RESEED_STREAM_SELF ; Reseed self.
    JMP MAIN_BATTLE_SWITCH_RUN_FILE? ; Redo.
RTN_L_INTO_AND_SAVE_TODO_SWAPPY: ; 17:0F98, 0x02EF98
    LDY #$00 ; Stream index.
    LDA [FPTR_BATTLE_PTR_UNK_5E[2]],Y ; Load from file.
    AND #$0F ; Keep lower, loop count.
    TAX ; To X index. TODO meaning.
    LDA #$01 ; Advance.
    JSR ADVANCE_FPTR_UNK_0x1_BY_A ; Advance.
LOOP_COUNT_NONZERO: ; 17:0FA4, 0x02EFA4
    TXA ; Save X to stack.
    PHA
    LDA FPTR_BATTLE_PTR_UNK_5E+1 ; Save file.
    PHA
    LDA FPTR_BATTLE_PTR_UNK_5E[2]
    PHA
    JSR MAIN_BATTLE_SWITCH_RUN_FILE? ; Reprocess.
    LDA FPTR_BATTLE_PTR_UNK_5E[2] ; Move file ??
    STA LIB_BCD/EXTRA_FILE_BCD_A
    LDA FPTR_BATTLE_PTR_UNK_5E+1
    STA LIB_BCD/EXTRA_FILE_BCD_B
    PLA
    STA FPTR_BATTLE_PTR_UNK_5E[2] ; Restore saved pos.
    PLA
    STA FPTR_BATTLE_PTR_UNK_5E+1
    PLA
    TAX ; Restore X.
    DEX ; X--
    BNE LOOP_COUNT_NONZERO ; != 0, goto.
    LDA LIB_BCD/EXTRA_FILE_BCD_A ; Move other back to main ptr.
    STA FPTR_BATTLE_PTR_UNK_5E[2]
    LDA LIB_BCD/EXTRA_FILE_BCD_B
    STA FPTR_BATTLE_PTR_UNK_5E+1
    JMP MAIN_BATTLE_SWITCH_RUN_FILE? ; Reswitch.
HELPER_0x17_ADVANCE_A_AND_RESWITCH_MAIN: ; 17:0FCD, 0x02EFCD
    JSR ADVANCE_FPTR_UNK_0x1_BY_A ; Advance passed.
    JMP MAIN_BATTLE_SWITCH_RUN_FILE? ; Goto.
SCRIPT_BATTLE_MENU?_RESEED_STREAM_SELF: ; 17:0FD3, 0x02EFD3
    LDY #$01 ; Stream index.
    LDA [FPTR_BATTLE_PTR_UNK_5E[2]],Y ; Load from file.
    PHA ; Save to stack.
    INY ; Stream++
    LDA [FPTR_BATTLE_PTR_UNK_5E[2]],Y ; Load from file.
    STA FPTR_BATTLE_PTR_UNK_5E+1 ; Store over, reseeding self.
    PLA ; Pull value.
    STA FPTR_BATTLE_PTR_UNK_5E[2]
    RTS
ADVANCE_FPTR_UNK_0x1_BY_A: ; 17:0FE1, 0x02EFE1
    CLC ; Prep add.
    ADC FPTR_BATTLE_PTR_UNK_5E[2] ; Add with PTR L.
    STA FPTR_BATTLE_PTR_UNK_5E[2] ; Store to PTR L.
    LDA #$00 ; Carry seed.
    ADC FPTR_BATTLE_PTR_UNK_5E+1 ; Add for carry.
    STA FPTR_BATTLE_PTR_UNK_5E+1 ; Store to.
    RTS ; Leave.
RTN_B_ALT_FOCUS_AND_ENTRY: ; 17:0FED, 0x02EFED
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load focus.
    JMP SCRIPT_ENTRY_SCREEN_MODDY_GFX_THINGY_TODO ; Goto.
RTN_C_ALT_FOCUS_COMMITTING_AND_GOTO: ; 17:0FF2, 0x02EFF2
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load committing.
    BPL EXIT_SET_TODO ; Positive, goto.
    JMP FOCUS_EXTRA_UNK_AND_GFX ; Negative, goto.
EXIT_SET_TODO: ; 17:0FF9, 0x02EFF9
    LDA #$01
    STA STREAM_REPLACE_COUNT?_TODO_BETTER ; Set ??
    RTS ; Leave.
RTN_D_ALT_NEGATIVE_NORMAL_BLACK_HIT_POSITIVE_UNK: ; 17:0FFE, 0x02EFFE
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load commiting.
    BPL COMMIT_POSITIVE ; Positive, goto.
    JMP ENTRY_COMMIT_NEGATIVE ; Negative, goto.
COMMIT_POSITIVE: ; 17:1005, 0x02F005
    JMP ENTRY_BG_COLOR_BLACK_EXTENDED ; Positive, goto.
RTN_E_ALT: ; 17:1008, 0x02F008
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load commit.
    BPL COMMIT_POSITIVE ; Positive, goto.
    JMP SCRIPTY_BATTLE_UNK_SCROLLY_GFX_TODO ; Do.
COMMIT_POSITIVE: ; 17:100F, 0x02F00F
    JMP ENTRY_BLACK_ALT_B_EXTENDED ; Do.
RTN_F_ALT: ; 17:1012, 0x02F012
    LDA #$2D ; Seed ??
    JSR SCRIPT_TEXT_AND_REENTER_THINGY??? ; Script ??
    JSR SCRIPT_FIND_ENEMY_FOCUS_CC_FAIL_PASS_DO_TODO ; Do sub.
    BCS RET_CS ; Pass, do.
    LDA #$40 ; Fail seeds ??
    JSR SCRIPT_TEXT_AND_REENTER_THINGY??? ; Re-do.
RET_CS: ; 17:1021, 0x02F021
    RTS ; Leave.
RTN_G_ALT: ; 17:1022, 0x02F022
    LDA #$2E
    JSR SCRIPT_TEXT_AND_REENTER_THINGY??? ; Seed ??
    JSR SCRIPT_FIND_ENEMY_FOCUS_CC_FAIL_PASS_DO_TODO ; Find.
    BCS EXIT_RET_CS ; CS, goto.
    LDA #$41 ; Seed ?? on fail.
    JSR SCRIPT_TEXT_AND_REENTER_THINGY??? ; Do.
EXIT_RET_CS: ; 17:1031, 0x02F031
    RTS ; Leave.
RTN_H_ALT: ; 17:1032, 0x02F032
    LDA #$02
    STA STREAM_REPLACE_COUNT?_TODO_BETTER ; Set ??
    RTS ; Leave.
RTN_I_ALT: ; 17:1037, 0x02F037
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load ??
    BPL EXTENDED ; Positive, do.
    JMP ENTRY_RED ; Goto.
EXTENDED: ; 17:103E, 0x02F03E
    JMP ENTRY_BG_COLOR_RED_EXTENDED ; Do red.
RTN_J_ALT: ; 17:1041, 0x02F041
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load ??
    BPL EXTENDED_B ; Positive, do.
    JMP ENTRY_PURPLISH ; Do purplish.
EXTENDED_B: ; 17:1048, 0x02F048
    JMP ENTRY_PURPLISH_EXTENDED ; Do extended.
RTN_K_ALT: ; 17:104B, 0x02F04B
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load ??
    BPL EXTENDED_C ; Positive, goto.
    JMP ENTRY_WHITE-BLUE ; Do purplish.
EXTENDED_C: ; 17:1052, 0x02F052
    JMP ENTRY_WHITE_BLUISH_EXTENDED ; Do extended.
RTN_L_ALT: ; 17:1055, 0x02F055
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load ??
    BPL EXTENDED_D ; Positive, goto.
    JMP ENTRY_YELLOW ; Do yellow.
EXTENDED_D: ; 17:105C, 0x02F05C
    JMP ENTRY_YELLOWISH_EXTENDED ; Do extended.
RTN_M_ALT: ; 17:105F, 0x02F05F
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load ??
    BPL EXTENDED_E
    JMP ENTRY_GREEN
EXTENDED_E: ; 17:1066, 0x02F066
    JMP ENTRY_GREEN_EXTENDED
SCRIPT_FIND_ENEMY_FOCUS_CC_FAIL_PASS_DO_TODO: ; 17:1069, 0x02F069
    LDY #$80 ; Seed enemy.
VAL_NONZERO: ; 17:106B, 0x02F06B
    CPY SCRIPT_BATTLE_PARTY_ID_FOCUS ; If test _ focus.
    BEQ FOCUS_MATCH ; == 0, goto.
    LDA SCRIPT_PARTY_ATTRIBUTES+30,Y ; Load ??
    AND #$01 ; Keep ??
    BNE ATTR_UNK_SET ; != 0, set, goto.
FOCUS_MATCH: ; 17:1076, 0x02F076
    TYA ; Focus test advance.
    CLC
    ADC #$20 ; += 0x20
    TAY
    BNE VAL_NONZERO ; != 0, goto.
    CLC ; Ret CC, fail, no match.
    RTS
ATTR_UNK_SET: ; 17:107F, 0x02F07F
    STY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Store focus.
    JSR SCRIPT_ENTRY_SCREEN_MODDY_GFX_THINGY_TODO ; Do.
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load ??
    LDA SCRIPT_PARTY_ATTRIBUTES+30,Y ; Load attr ??
    AND #$FE ; Clear bit.
    STA SCRIPT_PARTY_ATTRIBUTES+30,Y ; Store back.
    LDA #$00
    STA SCRIPT_PARTY_ATTRIBUTES+29,Y ; Clear ??
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load focus.
    LDA SCRIPT_PARTY_ATTRIBUTES[32],Y ; Load attr.
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load special focus.
    STA SCRIPT_PARTY_ATTRIBUTES[32],Y ; Store to other obj.
    LDA #$42 ; Seed ??
    JSR SCRIPT_TEXT_AND_REENTER_THINGY??? ; Do.
    SEC ; Ret CS.
    RTS
SCRIPT_LAUNCH_SUB_TODO: ; 17:10A4, 0x02F0A4
    LDA #$19 ; Launch 19:07FC scripty. Math todo.
    LDX #$FB
    LDY #$A7
    JSR ENGINE_SCRIPT_LAUNCH_R7_A_PTR_XY_WITH_RESTORE ; Make R7, 0xA000.
    JMP LIB_SCRIPT_HELPER_CREATE_DISPLAY_PACKET_HELPER ; Do ??
RTN_B_ALT5: ; 17:10B0, 0x02F0B0
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load focus.
    LDA SCRIPT_PARTY_ATTRIBUTES[32],Y ; Load ??
    BEQ RET_CS ; == 0, leave.
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y ; Load ??
    BMI RET_CS ; Negative, goto.
RTN_H_ALT5: ; 17:10BC, 0x02F0BC
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load focus.
    LDA SCRIPT_PARTY_ATTRIBUTES[32],Y ; Load attr.
    BEQ RET_CS ; == 0, leave.
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y ; Load attr.
    BMI RET_CS ; Test negative.
    CLC ; Ret CC.
    RTS
RET_CS: ; 17:10CA, 0x02F0CA
    SEC ; Ret CS.
    RTS
RTN_C_ALT5: ; 17:10CC, 0x02F0CC
    LDA FLAG_UNK_23 ; Load flag.
    BNE RET_CC ; != 0, exit CC, fail/blocked?
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load focus.
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y ; Load.
    AND #$70 ; Keep 0111.0000
    BNE RET_CC ; != 0, goto.
    LDA SCRIPT_PARTY_ATTRIBUTES+30,Y ; Load ??
    BMI RET_CC ; Negative, goto.
    LDA SCRIPT_PARTY_ATTRIBUTES+11,Y ; Move ??
    STA LIB_BCD/EXTRA_FILE_BCD_A
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load focus.
    LDA SCRIPT_PARTY_ATTRIBUTES+11,Y ; Load attr.
    STA LIB_BCD2/EXTRA_FILE_STREAM_INDEX ; Store to.
    JSR SUB_MATH_UNK_TODO_RANDOMIZE_CHANCE_AND_RET ; Do ??
    LDA LIB_BCD/EXTRA_FILE_BCD_A ; Load ??
    CMP LIB_BCD2/EXTRA_FILE_STREAM_INDEX ; If _ var
    BCS VAL_GTE_VAR ; >=, goto.
RET_CC: ; 17:10F3, 0x02F0F3
    CLC ; Ret CC, fail?
    RTS
VAL_GTE_VAR: ; 17:10F5, 0x02F0F5
    SEC ; Ret CS, pass?
    RTS
RTN_D_ALT5_FOCUS_THINGY_CHANCE_UNK: ; 17:10F7, 0x02F0F7
    JSR SUB_FIND_ALT_FRIENDLY/SHIFT_SET ; Do sub.
    BCS EXIT_FAILED ; CS, goto, fail?
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load focus.
    LDA SCRIPT_PARTY_ATTRIBUTES+11,Y ; Move attr ??
    STA LIB_BCD/EXTRA_FILE_BCD_A
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load alt index.
    LDA SCRIPT_PARTY_ATTRIBUTES+11,Y ; Move attr ??
    STA LIB_BCD2/EXTRA_FILE_STREAM_INDEX
    JSR SUB_MATH_UNK_TODO_RANDOMIZE_CHANCE_AND_RET ; Math random chance.
    LDA LIB_BCD2/EXTRA_FILE_STREAM_INDEX ; Load.
    CMP LIB_BCD/EXTRA_FILE_BCD_A ; If _ var, ret CC/CS on decision.
EXIT_FAILED: ; 17:1111, 0x02F111
    RTS ; Leave.
RTN_E_ALT6: ; 17:1112, 0x02F112
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load focus.
    LDA SCRIPT_PARTY_ATTRIBUTES+30,Y ; Load attr ??
    AND #$80 ; Keep top.
    EOR #$80 ; Invert it.
    ROL A ; Rotate into carry.
    BCS RTS ; CS, goto. Was set.
    JSR RANDOMIZE_GROUP_A ; Randomize.
    AND #$80 ; Keep upper.
    ROL A ; Rotate left.
RTS: ; 17:1124, 0x02F124
    RTS ; Leave. TODO: A vals.
RTN_F_ALT5: ; 17:1125, 0x02F125
    LDA SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load focus.
    BMI RTS_CS ; Negative, goto.
    LDA FLAG_UNK_23 ; Load flag.
    BEQ RTS_CS ; Clear, goto.
    CLC ; Ret CC.
    RTS
RTS_CS: ; 17:112F, 0x02F12F
    SEC ; Ret CS.
    RTS
RTN_G_ALT5: ; 17:1131, 0x02F131
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load focus.
    BMI FOCUS_NEGATIVE ; Negative, goto, enemy.
    LDA PARTY_ATTR_PTR[2],Y ; Move attr ??
    STA LIB_BCD/EXTRA_FILE_BCD_A
    LDA PARTY_ATTR_PTR+1,Y
    STA LIB_BCD/EXTRA_FILE_BCD_B
    LDY #$20 ; Seed index ??
VAL_NE_0x28: ; 17:1141, 0x02F141
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y ; Load from file.
    CMP #$68 ; If _ #$68
    BEQ VAL_EQ_0x68 ; ==, goto.
    INY ; Stream++
    CPY #$28 ; If _ #$28
    BNE VAL_NE_0x28 ; !=, goto.
FOCUS_NEGATIVE: ; 17:114C, 0x02F14C
    SEC ; Ret CS.
    RTS
VAL_EQ_0x68: ; 17:114E, 0x02F14E
    CLC ; Ret CC.
    RTS
RTN_I_ALT5: ; 17:1150, 0x02F150
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load focus.
    LDA SCRIPT_PARTY_ATTRIBUTES+2,Y ; Load attr ??
    AND #$80 ; Keep upper.
    BNE RET_CS ; != 0, goto.
    LDA SCRIPT_PARTY_ATTRIBUTES+2,Y ; Load attr ??
    AND #$01 ; Keep lower.
    BNE RET_CC ; != 0, goto.
RET_CS: ; 17:1160, 0x02F160
    SEC ; Ret CS.
    RTS
RET_CC: ; 17:1162, 0x02F162
    CLC ; Ret CC.
    RTS
RTN_J_ALT5_SIMPLE_RANDOMIZE_RET: ; 17:1164, 0x02F164
    JSR RANDOMIZE_GROUP_A ; Randomize.
    ASL A ; << 1, /2. 50%/50%? Weight?
    RTS ; Leave.
RTN_K_ALT5: ; 17:1169, 0x02F169
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load focus.
    LDA SCRIPT_PARTY_ATTRIBUTES+2,Y ; Load attr ??
    AND #$80 ; Keep top.
    EOR #$80 ; Invert.
    ROL A ; Rotate, ret opposite.
    RTS ; Leave.
RTN_L_ALT5: ; 17:1174, 0x02F174
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load focus.
    LDA SCRIPT_PARTY_ATTRIBUTES+2,Y ; Load attr.
    AND #$04 ; Keep ??
    EOR #$04 ; Invert it.
    CMP #$01 ; CMP for set/not set.
    RTS ; Leave.
RTN_M_ALT5: ; 17:1180, 0x02F180
    LDA MAIN_FLAG_UNK ; Load ??
    BNE RET_CC ; != 0, goto.
    SEC ; Ret CS.
    RTS
RET_CC: ; 17:1186, 0x02F186
    CLC ; Ret CC.
    RTS
RTN_O_ALT5_TEST_ATTR_0x00_UNK: ; 17:1188, 0x02F188
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load ??
    LDA SCRIPT_PARTY_ATTRIBUTES+17,Y ; Load attr ??
    AND #$06 ; Keep 0000.0110
    EOR #$06 ; Invert.
    CMP #$01 ; If _ #$01
    RTS ; Ret CC if was 0x00. TODO double check.
RTN_P_ALT5_TEST_OBJS_0x5/0x6_CC_TRUE_CS_FALSE: ; 17:1194, 0x02F194
    LDA 56_OBJECT_NAME_SIZE? ; Load ??
    CMP #$05 ; If _ #$05
    BEQ RET_CC ; ==, goto.
    CMP #$06 ; If _ #$06
    BEQ RET_CC ; == 0, goto.
    SEC ; Ret CS.
    RTS
RET_CC: ; 17:11A0, 0x02F1A0
    CLC ; Ret CC.
    RTS
SUB_MATH_UNK_TODO_RANDOMIZE_CHANCE_AND_RET: ; 17:11A2, 0x02F1A2
    LDA #$01
    STA LIB_BCD/EXTRA_FILE_BCD_B ; Set ??
    SEC ; Prep sub.
    LDA LIB_BCD/EXTRA_FILE_BCD_A ; Load ??
    SBC LIB_BCD2/EXTRA_FILE_STREAM_INDEX ; Sub with.
    STA LIB_BCD/EXTRA_FILE_BCD_A ; Store to.
    LDA LIB_BCD/EXTRA_FILE_BCD_B ; Load ??
    SBC #$00 ; Carry sub.
    LSR A ; >> 1, /2.
    ROR LIB_BCD/EXTRA_FILE_BCD_A ; Rotate into.
    SEC ; Prep sub.
    LDA LIB_BCD/EXTRA_FILE_BCD_A ; Load ??
    SBC #$66 ; -= 0x66
    BCS SUB_NO_UNDERFLOW ; No underflow, goto.
    LDA #$00 ; Min 0x00.
SUB_NO_UNDERFLOW: ; 17:11BD, 0x02F1BD
    STA LIB_BCD/EXTRA_FILE_BCD_A ; Store ??
    JSR RANDOMIZE_GROUP_A ; Randomize.
    STA LIB_BCD2/EXTRA_FILE_STREAM_INDEX ; Store random.
    RTS ; Leave.
SCRIPT_ATTR_INVERT_TEST_UNK: ; 17:11C5, 0x02F1C5
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load index ??
    LDA SCRIPT_PARTY_ATTRIBUTES+30,Y ; Load from other.
    AND #$40 ; Keep ??
    EOR #$40 ; Invert it.
    CMP #$01 ; If _ #$01. CC = Unset, CS = Set.
    RTS ; Leave.
SCRIPT_TEST_VALS_UNK: ; 17:11D1, 0x02F1D1
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load ??
    SEC ; Prep sub.
    LDA SCRIPT_PARTY_ATTRIBUTES+5,Y ; Load deeper.
    SBC SUB/MOD_VAL_UNK_WORD[2] ; Sub with.
    LDA SCRIPT_PARTY_ATTRIBUTES+6,Y ; Load pair?
    SBC SUB/MOD_VAL_UNK_WORD+1 ; Sub with.
    RTS ; Ret, CS arr >= var
RTN_B_ALT2_NOOP: ; 17:11DF, 0x02F1DF
    RTS
RTN_C_ALT2_ALIVE_THING_UNK: ; 17:11E0, 0x02F1E0
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load focus.
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y ; Load attr ??
    AND #$08 ; Keep bit.
    BNE RANDOMIZE_ALIVE_THING ; Set, goto.
    LDA SCRIPT_PARTY_ATTRIBUTES+28,Y ; Move ??
    STA SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING
    RTS ; Leave.
RANDOMIZE_ALIVE_THING: ; 17:11EF, 0x02F1EF
    JSR RANDOMIZE_GROUP_A ; Randize.
    AND #$E0 ; Keep focus val.
    TAY ; To Y.
    LDA SCRIPT_PARTY_ATTRIBUTES[32],Y ; Load attr ??
    BEQ RANDOMIZE_ALIVE_THING ; == 0, goto.
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y
    BMI RANDOMIZE_ALIVE_THING ; Negative, goto.
    STY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Store alt, alive thing friend/foe.
    RTS ; Leave.
RTN_D_ALT2_ATTR_THINGY_FRIEND/FOE_MATTERS: ; 17:1202, 0x02F202
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load focus.
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y ; Load attr ??
    AND #$08 ; Keep ??
    BEQ EXIT_WRITE_UNK_ATTR_SET_IF_FRIEND ; == 0, goto.
    JSR RANDOMIZE_GROUP_A ; Randomize.
    AND #$80 ; Keep top.
    BNE EXIT_COMMIT_CLEAR_IF_FRIEND_SET_IF_FOE ; Set,, goto.
EXIT_WRITE_UNK_ATTR_SET_IF_FRIEND: ; 17:1212, 0x02F212
    LDX #$80 ; Seed attr to write to friend.
    LDA SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load focus.
    BPL WRITE_ATTR ; Friend, goto.
    LDX #$00 ; Seed clear ??
WRITE_ATTR: ; 17:121A, 0x02F21A
    STX SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Store attr commiting.
    RTS ; Leave.
RTN_E_ALT2_ATTR_SET_RANDOM_UNK: ; 17:121D, 0x02F21D
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load focus.
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y ; Load attr ??
    AND #$08 ; Keep ??
    BEQ EXIT_COMMIT_CLEAR_IF_FRIEND_SET_IF_FOE ; == 0, goto.
    JSR RANDOMIZE_GROUP_A ; Randomize.
    AND #$80 ; Keep top.
    BNE EXIT_WRITE_UNK_ATTR_SET_IF_FRIEND ; Set, goto.
EXIT_COMMIT_CLEAR_IF_FRIEND_SET_IF_FOE: ; 17:122D, 0x02F22D
    LDX #$00 ; Seed clear.
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load focus.
    BPL FOCUS_FRIENDLY ; Friendly, goto, clear.
    LDX #$80 ; Seed set.
FOCUS_FRIENDLY: ; 17:1235, 0x02F235
    STX SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Set attr?
    RTS ; Leave.
RTN_F_ALT2_FOCUS_ID_TO_OTHER_UNK: ; 17:1238, 0x02F238
    LDA SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load focus.
    STA SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Store to.
    RTS ; Leave.
RTN_G_ALT2_CLEAR_FRIENDLY_SET_FOE: ; 17:123D, 0x02F23D
    LDX #$00 ; Seed clear.
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load focus.
    BPL FRIENDLY_CODE ; Positive, do clear for friendly.
    LDX #$80 ; Seed set for foe.
FRIENDLY_CODE: ; 17:1245, 0x02F245
    STX SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Store val.
    RTS ; Leave.
RTN_H_ALT2_NEXT_ATTR_FOCUS_ALT?: ; 17:1248, 0x02F248
    CLC ; Prep add.
    LDA SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load.
    ADC #$20 ; To next attr?
    STA SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Store.
    RTS ; Leave.
RTN_B_ALT3_ATTR_CALC_AND_SUBS_OUTPUT_UNK: ; 17:1250, 0x02F250
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load attr ??
    LDA SCRIPT_PARTY_ATTRIBUTES+9,Y ; Move attr ??
    STA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2]
    LDA SCRIPT_PARTY_ATTRIBUTES+10,Y
    STA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER+1
    SEC ; Prep sub.
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load other focus.
    LDA SCRIPT_PARTY_ATTRIBUTES+7,Y ; Move attr ??
    STA ALT_STUFF_COUNT?
    STA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY[8] ; Store to, slwo.
    SBC SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2] ; Sub with other.
    LDA SCRIPT_PARTY_ATTRIBUTES+8,Y ; Load other.
    STA ALT_COUNT_UNK ; Store to.
    STA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY+1 ; Store to arr.
    SBC SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER+1 ; Sub with.
    BCC SUB_UNDERFLOW ; Underflow, goto.
    LSR SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER+1 ; Shift.
    ROR SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2] ; Rotate.
    SEC ; Prep sub.
    LDA ALT_STUFF_COUNT? ; Load original attr ??
    SBC SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2] ; Sub with.
    STA LIB_BCD/EXTRA_FILE_BCD_A ; Store to.
    LDA ALT_COUNT_UNK ; Load original attr ??
    SBC SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER+1 ; Sub with.
    STA LIB_BCD/EXTRA_FILE_BCD_B ; Store to.
VALS_MADE_SYNC_DAMAGE_CALC?: ; 17:1284, 0x02F284
    LDA 56_OBJECT_NAME_SIZE? ; Load ??
    CMP #$01 ; If _ #$01
    BNE VAL_NE_0x1 ; !=, goto.
    JSR RANDOMIZE_GROUP_A ; Randomize.
    AND #$07 ; Keep lower.
    ORA #$04 ; Set ??
    STA LIB_BCD/EXTRA_FILE_BCD_A ; Store to.
    LDA #$00
    STA LIB_BCD/EXTRA_FILE_BCD_B ; Clear upper.
VAL_NE_0x1: ; 17:1297, 0x02F297
    LDA LIB_BCD/EXTRA_FILE_BCD_A ; Load.
    ORA LIB_BCD/EXTRA_FILE_BCD_B ; Combine with.
    BNE COMBINED_NONZERO ; != 0, goto.
    INC LIB_BCD/EXTRA_FILE_BCD_A ; ++, 0x1. Min damage for turn?
COMBINED_NONZERO: ; 17:129F, 0x02F29F
    LDA LIB_BCD/EXTRA_FILE_BCD_A ; Move ??, output ??
    STA SUB/MOD_VAL_UNK_WORD[2]
    LDA LIB_BCD/EXTRA_FILE_BCD_B
    STA SUB/MOD_VAL_UNK_WORD+1
    RTS ; Leave.
SUB_UNDERFLOW: ; 17:12A8, 0x02F2A8
    ASL ALT_STUFF_COUNT? ; ASL/ROT << 1, ??
    ROL ALT_COUNT_UNK
    CLC ; Prep add.
    LDA ALT_STUFF_COUNT? ; Load ??
    ADC RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY[8] ; Add with.
    STA ALT_STUFF_COUNT? ; Store to.
    LDA ALT_COUNT_UNK ; Load ??
    ADC RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY+1 ; Add carry.
    STA ALT_COUNT_UNK ; Store to.
    SEC ; Prep sub.
    LDA ALT_STUFF_COUNT? ; Load ??
    SBC SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2] ; Sub with.
    STA LIB_BCD/EXTRA_FILE_BCD_A ; Store to.
    LDA ALT_COUNT_UNK ; Load ??
    SBC SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER+1 ; Sub with.
    STA LIB_BCD/EXTRA_FILE_BCD_B ; Store to.
    BCS SUB_NO_UNDERFLOW
    LDA #$00
    STA LIB_BCD/EXTRA_FILE_BCD_A ; Min 0x00.
    STA LIB_BCD/EXTRA_FILE_BCD_B
SUB_NO_UNDERFLOW: ; 17:12CE, 0x02F2CE
    LSR LIB_BCD/EXTRA_FILE_BCD_B ; LSR/ROR >> 2, /4. Unsigned shorts probs.
    ROR LIB_BCD/EXTRA_FILE_BCD_A
    LSR LIB_BCD/EXTRA_FILE_BCD_B
    ROR LIB_BCD/EXTRA_FILE_BCD_A
    JMP VALS_MADE_SYNC_DAMAGE_CALC? ; Goto.
RTN_C_ALT3_ATTR_UNK_OUTPUT_BIGGER_UNK: ; 17:12D9, 0x02F2D9
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load focus.
    LDA SCRIPT_PARTY_ATTRIBUTES+7,Y ; Move ??
    STA SUB/MOD_VAL_UNK_WORD[2]
    LDA SCRIPT_PARTY_ATTRIBUTES+8,Y
    STA SUB/MOD_VAL_UNK_WORD+1
    LDA 56_OBJECT_NAME_SIZE? ; Load ??
    CMP #$01 ; If _ #$01
    BNE RTS ; !=, goto.
    JSR RANDOMIZE_GROUP_A ; Randomize.
    AND #$0F ; Keep lower.
    ORA #$08 ; Set ??
    STA SUB/MOD_VAL_UNK_WORD[2] ; Store val.
    LDA #$00
    STA SUB/MOD_VAL_UNK_WORD+1 ; Clear upper.
RTS: ; 17:12F8, 0x02F2F8
    RTS ; Leave.
RTN_D_ALT3_MOVE_STATIC_UNK: ; 17:12F9, 0x02F2F9
    LDA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2] ; mOVE ??
    STA SUB/MOD_VAL_UNK_WORD[2]
    LDA #$00 ; Clear ??
    STA SUB/MOD_VAL_UNK_WORD+1
    RTS
RTN_E_ALT3_IF_UNK_DO_RTN_LOOPED: ; 17:1302, 0x02F302
    LDA 56_OBJECT_NAME_SIZE? ; Load ??
    CMP #$05 ; If _ #$05
    BNE RTS ; !=, leave.
    LDA 57_INDEX_UNK ; Load ??
    JSR SCRIPT_TEXT_AND_REENTER_THINGY??? ; Do ??
    LDX 57_INDEX_UNK ; Load index.
    INX ; ++
    CPX #$9E ; If _ #$9E
    BNE VAL_NE_0x9E ; !=, goto.
    INC 56_OBJECT_NAME_SIZE? ; ++
VAL_NE_0x9E: ; 17:1316, 0x02F316
    STX 57_INDEX_UNK ; Store ??
RTS: ; 17:1318, 0x02F318
    RTS ; Leave.
RTN_F_ALT3_COMBINE_UNK: ; 17:1319, 0x02F319
    LDA SCRIPT_BATTLE_UNK ; Load ??
    ORA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2] ; Combine with.
    STA SCRIPT_BATTLE_UNK ; Store ??
    RTS ; Leave.
RTN_G_ALT3_SCRIPT_SWITCH_UNK: ; 17:1320, 0x02F320
    LDA #$6A ; Seed ??
    JSR SCRIPT_TEXT_AND_REENTER_THINGY??? ; Do ??
    LDA 56_OBJECT_NAME_SIZE? ; Load to switch with.
    CMP #$02 ; If _ #$02
    BNE SWITCH_0x3 ; !=, goto.
    LDA #$95 ; Seed ??
    JMP SCRIPT_TEXT_AND_REENTER_THINGY??? ; Goto, exit.
SWITCH_0x3: ; 17:1330, 0x02F330
    CMP #$03
    BNE SWITCH_0x4 ; !=, goto.
    LDA #$94 ; Seed ??
    JMP SCRIPT_TEXT_AND_REENTER_THINGY??? ; Goto, exit.
SWITCH_0x4: ; 17:1339, 0x02F339
    CMP #$04 ; If _ #$04
    BNE SWITCH_0x5 ; !=, goto.
    LDA #$93 ; Seed ??
    JMP SCRIPT_TEXT_AND_REENTER_THINGY??? ; Goto.
SWITCH_0x5: ; 17:1342, 0x02F342
    CMP #$05 ; If _ #$05
    BNE SWITCH_0x6 ; !=, goto.
    LDA #$01 ; Seed ??
    JMP SCRIPT_TEXT_AND_REENTER_THINGY??? ; Goto.
SWITCH_0x6: ; 17:134B, 0x02F34B
    CMP #$06 ; If _ #$06
    BNE SWITCH_0x7_DEFAULT_ALT ; !=, goto.
    LDA #$01 ; Seed ??
    JMP SCRIPT_TEXT_AND_REENTER_THINGY??? ; Goto.
SWITCH_0x7_DEFAULT_ALT: ; 17:1354, 0x02F354
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load alt focus.
    BMI VAL_NEGATIVE ; Negative, goto.
    LDA #$90 ; Seed ??
    JMP SCRIPT_TEXT_AND_REENTER_THINGY??? ; Goto.
VAL_NEGATIVE: ; 17:135D, 0x02F35D
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load alt focus.
    LDA SCRIPT_PARTY_ATTRIBUTES+7,Y ; Move attrs ??
    STA BATTLE_ARRAY_UNK[5]
    LDA SCRIPT_PARTY_ATTRIBUTES+8,Y
    STA BATTLE_ARRAY_UNK+1
    LDA SCRIPT_PARTY_ATTRIBUTES+9,Y
    STA BATTLE_ARRAY_UNK+2
    LDA SCRIPT_PARTY_ATTRIBUTES+10,Y ; 4x
    STA BATTLE_ARRAY_UNK+3
    LDA #$24 ; Script.
    JSR SCRIPT_TEXT_AND_REENTER_THINGY???
    LDA #$25 ; Script.
    JSR SCRIPT_TEXT_AND_REENTER_THINGY???
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load focus.
    LDA SCRIPT_PARTY_ATTRIBUTES+2,Y ; Load attr ??
    PHA ; Save it.
    AND #$40 ; Set, goto.
    BEQ EXTENSION_UNK ; == 0, goto.
    LDA #$6B ; Load ??
    JSR SCRIPT_TEXT_AND_REENTER_THINGY??? ; Do ??
EXTENSION_UNK: ; 17:1390, 0x02F390
    PLA ; Fetch stack A.
    PHA
    AND #$20 ; Test ??
    BEQ TEST_CLEAR_0x20 ; Clear, goto.
    LDA #$6C ; Set, script.
    JSR SCRIPT_TEXT_AND_REENTER_THINGY??? ; Do.
TEST_CLEAR_0x20: ; 17:139B, 0x02F39B
    PLA ; Fetch stack A.
    PHA
    AND #$10 ; Test ??
    BEQ TEST_CLEAR_0x10 ; == 0, goto.
    LDA #$6D ; Script ??
    JSR SCRIPT_TEXT_AND_REENTER_THINGY???
TEST_CLEAR_0x10: ; 17:13A6, 0x02F3A6
    PLA ; Fetch stack A.
    PHA
    AND #$80 ; Test 0x80.
    BNE TEST_0x80_SET ; Set, goto.
    PLA ; Fetch stack A.
    PHA
    AND #$01 ; Test 0x01
    BEQ TEST_0x80_SET ; == 0, goto.
    LDA #$6F ; Script ??
    JSR SCRIPT_TEXT_AND_REENTER_THINGY???
TEST_0x80_SET: ; 17:13B7, 0x02F3B7
    PLA ; Pull stack A.
    LDA #$FF ; Seed ??
    JMP SCRIPT_TEXT_AND_REENTER_THINGY??? ; Script.
    LDA #$90 ; Seed script ?? TODO called how?
    JMP SCRIPT_TEXT_AND_REENTER_THINGY???
RTN_H_ALT3_SFX_SCRIPTY_THING: ; 17:13C2, 0x02F3C2
    LDX #$0F ; Seed SFX 0xF.
    LDA SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load focus.
    BMI FOCUS_NEGATIVE ; Negative, goto.
    LDX #$01 ; Seed SFX 0x1.
FOCUS_NEGATIVE: ; 17:13CA, 0x02F3CA
    TXA ; X to A.
    JMP LIB_PLAY_BATTLE_SFX_A_PASSED_WITH_SCRIPT_DOING_TODO ; Do SFX.
RTN_I_ALT3_MOVE_STATIC_UNK: ; 17:13CE, 0x02F3CE
    LDA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2] ; Move ??
    STA SCRIPT_EFFECT_SFX_AND_SCRIPT_DO_UNK_GIVE_ITEM?
    RTS ; Leave.
VAL_SCRIPT_MOD_AS_SCRIPT?: ; 17:13D3, 0x02F3D3
    LDA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2] ; Seed script with?
    JMP SCRIPT_TEXT_AND_REENTER_THINGY???
RTN_K_ALT3_VAL_SFX_SCRIPT: ; 17:13D8, 0x02F3D8
    LDA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2] ; Seed SFX script with?
    JMP LIB_PLAY_BATTLE_SFX_A_PASSED_WITH_SCRIPT_DOING_TODO
SUBFOCUS_DO_SCRIPTED_UNK: ; 17:13DD, 0x02F3DD
    TYA ; Y to A.
    BMI FOCUS_NEGATIVE ; Negative, goto.
    LDA SCRIPT_PARTY_ATTRIBUTES+17,Y ; Load attr.
    CMP #$06 ; If _ #$06
    BNE FOCUS_NEGATIVE ; !=, goto.
    LDA #$00
    STA 56_OBJECT_NAME_SIZE? ; Clear ??
    LDX #$88 ; Seed ??
    JMP SCRIPT_SAVE_UNK_AND_RESWITCH_MAIN ; Goto.
FOCUS_NEGATIVE: ; 17:13F0, 0x02F3F0
    JSR SCRIPT_TODO ; Do ??
    CMP #$01 ; If _ #$01
    BNE VAL_NE_0x1 ; !=, goto.
    LDX #$19 ; Seed ??
    JMP SCRIPT_SAVE_UNK_AND_RESWITCH_MAIN ; Sync.
VAL_NE_0x1: ; 17:13FC, 0x02F3FC
    CMP #$02 ; If _ #$02
    BNE VAL_NE_0x2 ; !=, goto.
    LDX #$1A ; Seed ??
    JMP SCRIPT_SAVE_UNK_AND_RESWITCH_MAIN ; Sync.
VAL_NE_0x2: ; 17:1405, 0x02F405
    JSR SUB_ATTR_THINGY_TODO ; Do ??
    JMP SYNC_POST_UNK ; Goto.
SCRIPT_SAVE_UNK_AND_RESWITCH_MAIN: ; 17:140B, 0x02F40B
    LDA SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Save focuses.
    PHA
    LDA SCRIPT_BATTLE_PARTY_ID_FOCUS
    PHA
    LDA FPTR_BATTLE_PTR_UNK_5E+1 ; Save main fptr.
    PHA
    LDA FPTR_BATTLE_PTR_UNK_5E[2]
    PHA
    STY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Save Y to focus.
    TXA ; X as file to use main.
    JSR BATTLE_MAIN_FPTR_INIT_AND_SWITCH
    PLA
    STA FPTR_BATTLE_PTR_UNK_5E[2] ; Restore main.
    PLA
    STA FPTR_BATTLE_PTR_UNK_5E+1
    PLA
    STA SCRIPT_BATTLE_PARTY_ID_FOCUS ; Restore focuses.
    PLA
    STA SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING
    TAY ; In register.
    JMP SYNC_POST_UNK ; Sync.
SUB_ATTR_THINGY_TODO: ; 17:142D, 0x02F42D
    TYA ; Save Y.
    PHA
    LDA #$00 ; Seed clear.
    STA SCRIPT_PARTY_ATTRIBUTES+3,Y ; Clear attr ??
    STA SCRIPT_PARTY_ATTRIBUTES+4,Y
    LDA #$80
    STA SCRIPT_PARTY_ATTRIBUTES+1,Y ; Set attr ??
    TYA ; Focus to A.
    BPL FOCUS_POSITIVE ; Positive, goto.
    LDA #$00
    STA SCRIPT_PARTY_ATTRIBUTES[32],Y ; Clear for foes.
    LDA PARTY_ATTR_PTR[2],Y ; Move attr ??
    STA LIB_BCD/EXTRA_FILE_BCD_A
    LDA PARTY_ATTR_PTR+1,Y
    STA LIB_BCD/EXTRA_FILE_BCD_B
    TYA ; Y to stack.
    PHA
    CLC ; Prep add.
    LDY #$1A ; Stream index.
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y ; Load ??
    ADC TRIO_FILE_OFFSET_UNK[3] ; Add with.
    STA TRIO_FILE_OFFSET_UNK[3] ; Store to.
    INY ; Stream++
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y ; Load ??
    ADC TRIO_FILE_OFFSET_UNK+1 ; Add with.
    STA TRIO_FILE_OFFSET_UNK+1 ; Store to.
    LDA #$00 ; Seed carry.
    ADC TRIO_FILE_OFFSET_UNK+2 ; Carry add.
    STA TRIO_FILE_OFFSET_UNK+2 ; Store to.
    CLC ; Prep add.
    LDY #$1C ; Stream index.
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y ; Load from file.
    ADC SCRIPT_BATTLE_ACCUMULATOR_UNSIGNED_INT_UNK[2] ; Add with.
    STA SCRIPT_BATTLE_ACCUMULATOR_UNSIGNED_INT_UNK[2] ; Store to.
    INY ; Stream++
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y ; Load from file.
    ADC SCRIPT_BATTLE_ACCUMULATOR_UNSIGNED_INT_UNK+1 ; Add with.
    STA SCRIPT_BATTLE_ACCUMULATOR_UNSIGNED_INT_UNK+1
    LDY #$1E ; Stream index, encounter ID.
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y ; Load from file.
    BEQ FILE_CLEAR ; Clear, goto.
    STA SCRIPT_OVERWORLD_BATTLE_ENCOUNTER? ; Store to, battle encounter from file.
FILE_CLEAR: ; 17:147E, 0x02F47E
    LDA #$06
    STA SOUND_EFFECT_REQUEST_ARRAY[5] ; Play weird going down effect.
    PLA ; Restore Y.
    TAY
    JSR FOCUS_EXTRA_UNK_AND_GFX ; Do sub.
    JMP EXIT_UNK
FOCUS_POSITIVE: ; 17:148B, 0x02F48B
    LDA #$15
    JSR LIB_PLAY_BATTLE_SFX_A_PASSED_WITH_SCRIPT_DOING_TODO
EXIT_UNK: ; 17:1490, 0x02F490
    JSR LIB_SCRIPT_HELPER_CREATE_DISPLAY_PACKET_HELPER ; Create packet?
    PLA ; Restore Y.
    TAY
    RTS ; Leave.
SYNC_POST_UNK: ; 17:1496, 0x02F496
    TYA ; Save Y.
    PHA
    BMI Y_NEGATIVE ; Negative, goto.
    LDA SCRIPT_PARTY_ATTRIBUTES+17,Y ; Load attr of friend
    CMP #$06 ; If _ #$06
    BEQ EXIT_RESTORE_Y ; ==, goto.
    LDA #$10 ; Seed ??
    JSR SCRIPT_TEXT_AND_REENTER_THINGY??? ; Script.
    JMP EXIT_RESTORE_Y ; Goto.
Y_NEGATIVE: ; 17:14A9, 0x02F4A9
    LDA 56_OBJECT_NAME_SIZE? ; Load.
    CMP #$06 ; If _ #$06
    BEQ EXIT_RESTORE_Y ; ==, goto.
    LDA PARTY_ATTR_PTR[2],Y ; Move party file.
    STA LIB_BCD/EXTRA_FILE_BCD_A
    LDA PARTY_ATTR_PTR+1,Y ; 2x
    STA LIB_BCD/EXTRA_FILE_BCD_B
    LDY #$0A ; Stream index.
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y ; Load from file.
    AND #$1C ; Keep 0001.1100
    LSR A ; >> 1, /4.
    LSR A
    CLC ; Prep add.
    ADC #$79 ; Do script with count.
    JSR SCRIPT_TEXT_AND_REENTER_THINGY??? ; Script.
EXIT_RESTORE_Y: ; 17:14C7, 0x02F4C7
    PLA ; Restore Y.
    TAY
    RTS ; Leave.
SCRIPT_TODO: ; 17:14CA, 0x02F4CA
    TYA ; Y to stack save.
    PHA
    LDA PARTY_ATTR_PTR[2],Y ; Move party file.
    STA LIB_BCD/EXTRA_FILE_BCD_A
    LDA PARTY_ATTR_PTR+1,Y
    STA LIB_BCD/EXTRA_FILE_BCD_B
    LDY #$08 ; Stream index.
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y ; Load from file.
    AND #$1C ; Keep 0001.1100
    LSR A ; >> 2, /4.
    LSR A
    STA LIB_BCD/EXTRA_FILE_BCD_A ; Store to.
    PLA
    TAY ; Restore Y.
    LDA LIB_BCD/EXTRA_FILE_BCD_A ; Load ??
    RTS ; Leave.
EXTENSION_MOVE_FILE_DOWN_UNK: ; 17:14E5, 0x02F4E5
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load focus.
    CLC ; Prep add.
    LDA PARTY_ATTR_PTR[2],Y ; Load ??
    ADC #$20 ; += 0x20
    STA LIB_BCD/EXTRA_FILE_BCD_A ; Store to.
    LDA PARTY_ATTR_PTR+1,Y ; Load ??
    ADC #$00 ; Carry add.
    STA LIB_BCD/EXTRA_FILE_BCD_B ; Store to.
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load focus.
    LDA SCRIPT_PARTY_ATTRIBUTES+16,Y ; Load attr ??
    TAY ; To Y.
ENABLE_WRAM_UNK: ; 17:14FC, 0x02F4FC
    JSR ENGINE_WRAM_STATE_WRITEABLE ; WRAM.
LOOP_INDEX_CHECK: ; 17:14FF, 0x02F4FF
    CPY #$07 ; If _ #$07
    BEQ EXIT_EQ_TARGET ; ==, goto.
    INY ; Stream++
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y ; Load from file.
    DEY ; Stream--
    STA [LIB_BCD/EXTRA_FILE_BCD_A],Y ; Store to, moving up.
    INY ; Stream++
    BNE LOOP_INDEX_CHECK ; != 0, goto.
EXIT_EQ_TARGET: ; 17:150C, 0x02F50C
    LDA #$00 ; Seed clear ??
    STA [LIB_BCD/EXTRA_FILE_BCD_A],Y ; Clear final.
    JMP ENGINE_WRAM_STATE_WRITE_DISABLED ; Disable WRAM.
SCRIPT_ENTRY_SCREEN_MODDY_GFX_THINGY_TODO: ; 17:1513, 0x02F513
    JSR SCRIPT_HELP_MOVE_FOCUS_PTR_UNK_AND_WORLD_SLOT ; Move stuff, extra slot too.
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y ; Load attr ??
    AND #$7F ; Keep lower.
    STA SCRIPT_PARTY_ATTRIBUTES+1,Y ; Store back.
    LDA #$22
    STA LIB_BCD/EXTRA_FILE_BCD_A ; Set init?
    LDA #$FF
    STA LIB_BCD/EXTRA_FILE_BCD_B ; Set target?
    LDA #$FF
    STA LIB_BCD2/EXTRA_FILE_STREAM_INDEX
    JSR SCRIPT_HELPER_SCREEN_GFX_SET_UNK ; Screen do, GFX.
    LDA #$00
    STA ENGINE_FLAG_LATCHY_GFX_FLAGS ; Clear flags.
    TYA ; Save Y.
    PHA
    LDA SCRIPT_PARTY_ATTRIBUTES+26,Y ; Load ??
    AND #$03 ; Keep lower.
    TAX ; To X index, GFX mod.
    LDY #$1F ; Stream index.
    LDA [BATTLE_PARTY_FPTR_DATA_TODO[2]],Y ; Load from file, GFX bank.
    STA GFX_BANKS_EXTENSION[4],X ; Store to GFX extensions.
    PLA ; Restore Y.
    TAY
    LDA SCRIPT_PARTY_ATTRIBUTES+28,Y ; Load attr ??
    LDX SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER+1 ; Load index extra.
    STA WORLD_OBJECT_PAGE_EXTRA_ATTRS[256],X ; Store attr to extra.
    LDA #$01
    STA NMI_FLAG_EXECUTE_UPDATE_BUF_AND_MORE_TODO ; Set flag.
    JSR ENGINE_SET_NMI_FLAG_UPDATE_TODO_WAIT ; Wait.
    LDA #$80
    STA NMI_FLAG_EXECUTE_UPDATE_BUF_AND_MORE_TODO ; Set flag to upload.
    RTS ; Leave.
FOCUS_EXTRA_UNK_AND_GFX: ; 17:1555, 0x02F555
    JSR SCRIPT_HELP_MOVE_FOCUS_PTR_UNK_AND_WORLD_SLOT ; Do helper.
    LDA #$00 ; Seed ??
    LDX SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER+1 ; Load multiplied.
    STA WORLD_OBJECT_PAGE_EXTRA_ATTRS[256],X ; Load multiplied from obj.
    LDA #$01
    STA NMI_FLAG_EXECUTE_UPDATE_BUF_AND_MORE_TODO ; Set flag.
    JSR ENGINE_SET_NMI_FLAG_UPDATE_TODO_WAIT ; Settle.
    LDA #$80
    STA NMI_FLAG_EXECUTE_UPDATE_BUF_AND_MORE_TODO ; Set flag.
    LDA #$00
    STA SCRIPT_PARTY_ATTRIBUTES[32],Y ; Clear 
    LDA #$00
    STA LIB_BCD/EXTRA_FILE_BCD_A ; Set ??
    LDA #$23
    STA LIB_BCD/EXTRA_FILE_BCD_B
    LDA #$01
    STA LIB_BCD2/EXTRA_FILE_STREAM_INDEX ; Set ??
    JSR SCRIPT_HELPER_SCREEN_GFX_SET_UNK ; Do sub, scroll?
    LDA SCRIPT_PARTY_ATTRIBUTES+26,Y ; Load attr from party.
    AND #$03 ; Keep lower, GFX bank writing.
    TAX ; To X index.
    LDA #$7C ; Seed GFX base.
    STA GFX_BANKS_EXTENSION[4],X ; Store to GFX.
    RTS ; Leave.
SCRIPT_HELPER_SCREEN_GFX_SET_UNK: ; 17:1589, 0x02F589
    TYA ; Save Y index.
    PHA
    LDA SCRIPT_PARTY_ATTRIBUTES+26,Y ; Load attr.
    AND #$03 ; Keep lower.
    TAX ; To X index.
    LDY #$1F ; Load stream.
    LDA [BATTLE_PARTY_FPTR_DATA_TODO[2]],Y ; Load from file.
    ORA #$80 ; Set flag for override.
    STA GFX_BANKS_EXTENSION[4],X ; Store override.
    PLA ; Restore Y.
    TAY
    LDA #$80
    STA ENGINE_FLAG_LATCHY_GFX_FLAGS ; Set GFX latchy unk.
LOOP_NOT_TO_TARGET: ; 17:159F, 0x02F59F
    LDA LIB_BCD/EXTRA_FILE_BCD_A ; Load ??
    STA SCRIPT_REPLACE_LATCH_MOD_VAL? ; Store to.
    AND #$01 ; Keep lower.
    BNE LOWEST_SET ; != 0, goto.
    LDA ENGINE_FLAG_LATCHY_GFX_FLAGS ; Modify ??
    EOR #$40 ; Invert.
    STA ENGINE_FLAG_LATCHY_GFX_FLAGS
LOWEST_SET: ; 17:15AD, 0x02F5AD
    JSR ENGINE_SET_NMI_FLAG_UPDATE_TODO_WAIT ; Wait.
    CLC ; Prep add.
    LDA LIB_BCD/EXTRA_FILE_BCD_A ; Load ??
    ADC LIB_BCD2/EXTRA_FILE_STREAM_INDEX ; Add with.
    STA LIB_BCD/EXTRA_FILE_BCD_A ; Store back.
    CMP LIB_BCD/EXTRA_FILE_BCD_B ; If _ B, target?
    BNE LOOP_NOT_TO_TARGET ; !=, loop.
    RTS
SCRIPT_HELP_MOVE_FOCUS_PTR_UNK_AND_WORLD_SLOT: ; 17:15BC, 0x02F5BC
    LDA PARTY_ATTR_PTR[2],Y ; Move attr to FPTR.
    STA BATTLE_PARTY_FPTR_DATA_TODO[2]
    LDA PARTY_ATTR_PTR+1,Y
    STA BATTLE_PARTY_FPTR_DATA_TODO+1
    LDA SCRIPT_PARTY_ATTRIBUTES+26,Y ; Load ??
    AND #$03 ; Keep lower.
    STA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2] ; Store to, raw val.
    ASL A ; << 3, *8.
    ASL A
    ASL A
    STA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER+1 ; Store to, multiplied value, extra world slot.
    RTS ; Leave.
ENTRY_COMMIT_NEGATIVE: ; 17:15D3, 0x02F5D3
    LDA #$0F ; Black.
    LDX #$03 ; Count.
    JMP BATTLE_BACKGROUND_COLOR_AND_LOOP_COUNT_HELPER ; Goto.
ENTRY_RED: ; 17:15DA, 0x02F5DA
    LDA #$16 ; Red color.
    LDX #$03 ; Count.
    JMP BATTLE_BACKGROUND_COLOR_AND_LOOP_COUNT_HELPER
ENTRY_PURPLISH: ; 17:15E1, 0x02F5E1
    LDA #$12 ; Purplish.
    LDX #$03 ; Count.
    JMP BATTLE_BACKGROUND_COLOR_AND_LOOP_COUNT_HELPER
ENTRY_WHITE-BLUE: ; 17:15E8, 0x02F5E8
    LDA #$31 ; White with a hint of blue.
    LDX #$03
    JMP BATTLE_BACKGROUND_COLOR_AND_LOOP_COUNT_HELPER
ENTRY_YELLOW: ; 17:15EF, 0x02F5EF
    LDA #$28 ; Clay yellow.
    LDX #$03 ; Count.
    JMP BATTLE_BACKGROUND_COLOR_AND_LOOP_COUNT_HELPER
ENTRY_GREEN: ; 17:15F6, 0x02F5F6
    LDA #$2A ; Green.
    LDX #$03 ; Count.
    JMP BATTLE_BACKGROUND_COLOR_AND_LOOP_COUNT_HELPER ; Do it.
LOOP_SFX_0x3_TIMES: ; 17:15FD, 0x02F5FD
    LDX #$03 ; Seed loop count.
COUNT_LARGER_NONZERO: ; 17:15FF, 0x02F5FF
    TXA ; X to stack.
    PHA
    LDA #$05 ; Seed crit sound?
    STA SOUND_EFFECT_REQUEST_ARRAY[5] ; Play crit sound?
    JSR RANDOMIZE_GROUP_A ; Randomize.
    AND #$03 ; Keep lower, random times.
    TAX ; Val to X.
    INX ; X++
SEED_HIT_SOUND_RANDOM_TIMES: ; 17:160D, 0x02F60D
    TXA ; Save X.
    PHA
    LDA #$01
    STA SOUND_EFFECT_REQUEST_ARRAY[5] ; Play hit sound?
    PLA ; Peek stack.
    PHA
    LDX #$03 ; Seed ??
    JSR BATTLE_BACKGROUND_COLOR_AND_LOOP_COUNT_HELPER ; BG thingy.
    PLA
    TAX ; Restore X.
    DEX ; X--
    BNE SEED_HIT_SOUND_RANDOM_TIMES ; != 0, goto.
    PLA ; Restore X.
    TAX
    DEX ; Count--
    BNE COUNT_LARGER_NONZERO ; != 0, goto.
    RTS
BATTLE_BACKGROUND_COLOR_AND_LOOP_COUNT_HELPER: ; 17:1626, 0x02F626
    STA LIB_BCD/EXTRA_FILE_BCD_B ; Store BG color.
    STX LIB_BCD/EXTRA_FILE_BCD_A ; Store loop count.
    LDA #$02 ; Seed SFX slot.
    JSR LIB_PLAY_BATTLE_SFX_A_PASSED_WITH_SCRIPT_DOING_TODO ; Do ??
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load commiting.
    JSR SCRIPT_HELP_MOVE_FOCUS_PTR_UNK_AND_WORLD_SLOT ; Do ??
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle.
    LDX LIB_BCD/EXTRA_FILE_BCD_A ; Load loop count.
X_NONZERO: ; 17:1639, 0x02F639
    TXA ; Save X.
    PHA
    LDX SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER+1 ; Load extra page index for obj.
    LDA WORLD_OBJECT_PAGE_EXTRA_ATTRS[256],X ; Load attr.
    PHA ; Save it.
    LDA #$00
    STA WORLD_OBJECT_PAGE_EXTRA_ATTRS[256],X ; Clear it.
    LDA #$01
    STA NMI_FLAG_EXECUTE_UPDATE_BUF_AND_MORE_TODO ; Set flag to disp.
    JSR ENGINE_SET_NMI_FLAG_UPDATE_TODO_WAIT ; Wait.
    LDA #$7C ; Seed base GFX bank?
    LDX SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2] ; Load index for char.
    STA GFX_BANKS_EXTENSION[4],X ; Store seeded GFX bank to.
    LDA LIB_BCD/EXTRA_FILE_BCD_B ; Load ??
    JSR PALETTE_MOD_BG_COLOR_TO_A ; BG color to val.
    JSR ENGINE_SET_NMI_FLAG_UPDATE_TODO_WAIT ; Wait.
    PLA ; Pull value attr.
    LDX SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER+1 ; Load extra index.
    STA WORLD_OBJECT_PAGE_EXTRA_ATTRS[256],X ; Store back.
    LDA #$01
    STA NMI_FLAG_EXECUTE_UPDATE_BUF_AND_MORE_TODO ; Set flag update.
    JSR ENGINE_SET_NMI_FLAG_UPDATE_TODO_WAIT ; Wait.
    LDY #$1F ; Seed stream index header.
    LDA [BATTLE_PARTY_FPTR_DATA_TODO[2]],Y ; Load from obj data file.
    LDX SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2] ; Load index changing.
    STA GFX_BANKS_EXTENSION[4],X ; Store to GFX index.
    JSR PALETTE_MOD_BG_COLOR_TO_0x00 ; Palette to black.
    JSR ENGINE_SET_NMI_FLAG_UPDATE_TODO_WAIT ; Wait.
    PLA
    TAX ; Restore X.
    DEX ; X--
    BNE X_NONZERO ; != 0, goto.
    RTS ; Leave.
SCRIPTY_BATTLE_UNK_SCROLLY_GFX_TODO: ; 17:167C, 0x02F67C
    LDA #$02
    JSR LIB_PLAY_BATTLE_SFX_A_PASSED_WITH_SCRIPT_DOING_TODO ; Do passed.
    JSR SCRIPT_HELP_MOVE_FOCUS_PTR_UNK_AND_WORLD_SLOT ; Do.
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load commiting.
    LDA SCRIPT_PARTY_ATTRIBUTES+28,Y ; Load attr.
    PHA ; Save attr.
    LDX SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER+1 ; Load extra slot index.
    LDA WORLD_OBJECT_PAGE_EXTRA_ATTRS[256],X ; Load attr.
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load attr.
    STA SCRIPT_PARTY_ATTRIBUTES+28,Y ; Store extra to.
    LDA #$00 ; Clear ??
    LDX SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER+1 ; Load extra slot index.
    STA WORLD_OBJECT_PAGE_EXTRA_ATTRS[256],X ; Store to.
    LDA #$01
    STA NMI_FLAG_EXECUTE_UPDATE_BUF_AND_MORE_TODO ; Set flag.
    JSR ENGINE_SET_NMI_FLAG_UPDATE_TODO_WAIT ; Wait.
    LDA #$80
    STA NMI_FLAG_EXECUTE_UPDATE_BUF_AND_MORE_TODO ; Do.
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load focus commit.
    JSR SCRIPT_ENTRY_SCREEN_MODDY_GFX_THINGY_TODO ; Do.
    PLA ; Pull value.
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load index.
    STA SCRIPT_PARTY_ATTRIBUTES+28,Y ; Store attr to. ??
    RTS ; Leave.
ENTRY_BG_COLOR_BLACK_EXTENDED: ; 17:16B2, 0x02F6B2
    LDX #$41 ; Seed FPTR TODO.
    LDY #$9F
    LDA #$0F ; Seed BG color, black.
    JMP RUN_FPTR_BLINKY_BG_PASSED_AND_TODO
ENTRY_BG_COLOR_RED_EXTENDED: ; 17:16BB, 0x02F6BB
    LDX #$41
    LDY #$9F
    LDA #$16 ; Seed red.
    JMP RUN_FPTR_BLINKY_BG_PASSED_AND_TODO
ENTRY_PURPLISH_EXTENDED: ; 17:16C4, 0x02F6C4
    LDX #$41
    LDY #$9F
    LDA #$12 ; Seed purplish.
    JMP RUN_FPTR_BLINKY_BG_PASSED_AND_TODO
ENTRY_WHITE_BLUISH_EXTENDED: ; 17:16CD, 0x02F6CD
    LDX #$41
    LDY #$9F
    LDA #$31 ; White with light blue.
    JMP RUN_FPTR_BLINKY_BG_PASSED_AND_TODO
ENTRY_YELLOWISH_EXTENDED: ; 17:16D6, 0x02F6D6
    LDX #$41
    LDY #$9F
    LDA #$28 ; Yellowish.
    JMP RUN_FPTR_BLINKY_BG_PASSED_AND_TODO
ENTRY_GREEN_EXTENDED: ; 17:16DF, 0x02F6DF
    LDX #$61
    LDY #$9F
    LDA #$2A ; Green.
    JMP RUN_FPTR_BLINKY_BG_PASSED_AND_TODO
ENTRY_BLACK_ALT_A_EXTENDED: ; 17:16E8, 0x02F6E8
    LDX #$61
    LDY #$9F
    LDA #$0F ; Black.
    JMP RUN_FPTR_BLINKY_BG_PASSED_AND_TODO
ENTRY_BLACK_ALT_B_EXTENDED: ; 17:16F1, 0x02F6F1
    LDX #$4B
    LDY #$9F
    LDA #$0F ; Black.
    JMP RUN_FPTR_BLINKY_BG_PASSED_AND_TODO
RUN_FPTR_BLINKY_BG_PASSED_AND_TODO: ; 17:16FA, 0x02F6FA
    STA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2] ; Store color BG to.
    STX LIB_BCD/EXTRA_FILE_BCD_A ; Store file L.
    STY LIB_BCD/EXTRA_FILE_BCD_B ; Store file H.
    LDA #$10 ; SFX/Script?
    JSR LIB_PLAY_BATTLE_SFX_A_PASSED_WITH_SCRIPT_DOING_TODO ; Lib sound.
    JSR ENGINE_SETTLE_ALL_UPDATES? ; Settle.
    LDY #$00 ; Stream index.
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y ; Move count.
    STA LIB_BCD2/EXTRA_FILE_STREAM_INDEX
    INY
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y ; Move target.
    STA LIB_BCD/EXTRA_FILE_D
    CLC ; Prep add, forward pointer.
    LDA LIB_BCD/EXTRA_FILE_BCD_A ; Load PTR L.
    ADC #$02 ; += 0x2
    STA LIB_BCD/EXTRA_FILE_BCD_A ; Store PTRL.
    LDA LIB_BCD/EXTRA_FILE_BCD_B ; Load for carry.
    ADC #$00 ; Carry add, but diff. Other programmer? :P
    STA LIB_BCD/EXTRA_FILE_BCD_B ; Store to.
BG_BLINK_REENTER: ; 17:1720, 0x02F720
    LDY #$00 ; Stream reset.
BG_BLINK_COLOR_LOOP: ; 17:1722, 0x02F722
    TYA ; Save stream index.
    PHA
    AND #$02 ; Keep bit.
    BEQ BG_COLOR_TO_BLACK ; == 0, to black.
    LDA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2] ; Load arg.
    JSR PALETTE_MOD_BG_COLOR_TO_A ; Mod BG to.
    JMP SYNC ; Entry.
BG_COLOR_TO_BLACK: ; 17:1730, 0x02F730
    JSR PALETTE_MOD_BG_COLOR_TO_0x00 ; BG color to 0x00.
SYNC: ; 17:1733, 0x02F733
    PLA ; Restore stream index.
    TAY
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y ; Move FPTR ??
    STA NMI_FP_BATTLE_UNK+1
    INY ; Stream++
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y
    STA NMI_FP_BATTLE_UNK[2]
    INY
    LDA #$01
    STA NMI_FLAG_EXECUTE_UPDATE_BUF_AND_MORE_TODO ; Set flag.
    JSR ENGINE_SET_NMI_FLAG_UPDATE_TODO_WAIT ; Wait.
    CPY LIB_BCD/EXTRA_FILE_D ; If _ var
    BNE BG_BLINK_COLOR_LOOP ; !=, goto.
    DEC LIB_BCD2/EXTRA_FILE_STREAM_INDEX ; Count--
    BNE BG_BLINK_REENTER
    LDA #$00
    STA NMI_FP_BATTLE_UNK[2] ; Clear FP, done.
    STA NMI_FP_BATTLE_UNK+1
    JSR ENGINE_SET_NMI_FLAG_UPDATE_TODO_WAIT ; Update wait.
    JMP PALETTE_MOD_BG_COLOR_TO_0x00 ; Exit BG 0x00.
SUB_REPLACE_COUNT_UNK_TODO: ; 17:175A, 0x02F75A
    LDA STREAM_REPLACE_COUNT?_TODO_BETTER ; Load ??
    CMP #$01 ; If _ #$01
    BEQ EXIT_CS ; ==, goto.
    CMP #$02 ; If _ #$02
    BEQ EXIT_CS ; == 0, goto.
    LDY #$00 ; Index ??
ITERATE_POSITIVE: ; 17:1766, 0x02F766
    LDA SCRIPT_PARTY_ATTRIBUTES[32],Y ; Load from stream.
    BEQ INDEX_ITERATE ; == 0, goto.
    LDA SCRIPT_PARTY_ATTRIBUTES+17,Y ; Load ??
    AND #$06 ; Keep 0000.0110
    EOR #$06 ; Invert both.
    BEQ INDEX_ITERATE ; == 0, goto.
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y ; Load ??
    AND #$E0 ; Keep 1110.0000
    BEQ BATTLE_OVER_CHECK_ENEMIY_ATTRIBUTES ; == 0, goto.
INDEX_ITERATE: ; 17:177B, 0x02F77B
    TYA ; Y to A.
    CLC ; Prep add.
    ADC #$20 ; Add with.
    TAY ; Back to Y.
    BPL ITERATE_POSITIVE ; Positive, goto.
    LDA #$80
    STA SCRIPT_PARTY_ATTRIBUTES+1 ; Set all attrs, party friends, TODO why.
    STA **:$0621
    STA **:$0641
    STA **:$0661
    LDA 56_OBJECT_NAME_SIZE? ; Load ??
    CMP #$04 ; If _ #$04
    BNE VAL_NE_0x4 ; !=, goto.
    LDA #$03
    STA STREAM_REPLACE_COUNT?_TODO_BETTER ; Set ??
    LDA #$04
    JSR LIB_PLAY_BATTLE_SFX_A_PASSED_WITH_SCRIPT_DOING_TODO ; Do lib.
    LDA #$8F
    JSR SCRIPT_TEXT_AND_REENTER_THINGY??? ; Script ??
    JMP EXIT_CS ; Goto, RTS CS.
VAL_NE_0x4: ; 17:17A7, 0x02F7A7
    LDA #$00
    STA SCRIPT_BATTLE_PARTY_ID_FOCUS ; Clear ??
    LDA #$0E ; Seed ??
    JSR SCRIPT_TEXT_AND_REENTER_THINGY??? ; Do.
EXIT_CS: ; 17:17B0, 0x02F7B0
    SEC ; Ret CS.
    RTS
BATTLE_OVER_CHECK_ENEMIY_ATTRIBUTES: ; 17:17B2, 0x02F7B2
    LDA ENEMY_A_ATTRIBUTES[32] ; Load.
    ORA ENEMY_B_ATTRIBUTES[32] ; Combine with others. Enemy statuses.
    ORA ENEMY_C_ATTRIBUTES[32]
    ORA ENEMY_D_ATTRIBUTES[32]
    BNE ANY_NONZERO ; != 0, goto.
    LDA FLAG_UNK_23 ; Load ??
    BEQ FLAG_ZERO ; == 0, goto.
    LDA #$31 ; Load ??
    JSR SCRIPT_TEXT_AND_REENTER_THINGY??? ; Do.
FLAG_ZERO: ; 17:17C9, 0x02F7C9
    LDA 56_OBJECT_NAME_SIZE? ; Load ??
    CMP #$06 ; If _ #$06
    BNE BATTLE_OVER? ; !=, goto.
    LDA #$00
    STA SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Clear ??
    JSR PARTY_RELATED?_UNK ; Do ??
    LDA #$20
    STA SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Set ??
    JSR PARTY_RELATED?_UNK
    LDA #$40
    STA SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Set ??
    JSR PARTY_RELATED?_UNK
    JMP EXIT_CS ; Goto, ret CS.
BATTLE_OVER?: ; 17:17E7, 0x02F7E7
    LDA #$05
    JSR SOUND_LIB_SET_NEW_SONG_ID ; Play sound good battle over?
    LDA #$0D
    JSR SCRIPT_TEXT_AND_REENTER_THINGY??? ; Do ??
EXIT_CS: ; 17:17F1, 0x02F7F1
    SEC ; Ret CS.
    RTS
ANY_NONZERO: ; 17:17F3, 0x02F7F3
    LDA 56_OBJECT_NAME_SIZE? ; Load ??
    CMP #$01 ; If _ #$01
    BNE RET_CC ; !=, goto.
    LDY #$00 ; Seed ??
    JSR ROUTINE_OBJ_HANDLE_UNK_A ; Do.
    BCS RET_CC ; Ret CS, do other.
    SEC ; Ret CS.
    RTS
RET_CC: ; 17:1802, 0x02F802
    CLC ; Ret CC.
    RTS
RTN_E_FILE_SUBSWITCH_B: ; 17:1804, 0x02F804
    LDY #$01 ; Stream index.
    LDA [FPTR_BATTLE_PTR_UNK_5E[2]],Y ; Load file.
    JSR SWITCH_TABLE_PAST_JSR_WITH_PTR[0]_AS_RET_CATCH ; Switch with entire.
    LOW(RTN_A_CATCH_ADVANCE_0x2) ; Catch advance 0x2.
    HIGH(RTN_A_CATCH_ADVANCE_0x2)
    LOW(RTN_B)
    HIGH(RTN_B)
    LOW(RTN_C)
    HIGH(RTN_C)
    LOW(RTN_D)
    HIGH(RTN_D)
    LOW(RTN_E)
    HIGH(RTN_E)
    LOW(RTN_F)
    HIGH(RTN_F)
    LOW(RTN_G_SET_MAX_AND_SCRIPTY)
    HIGH(RTN_G_SET_MAX_AND_SCRIPTY)
    LOW(RTN_H)
    HIGH(RTN_H)
    LOW(RTN_I)
    HIGH(RTN_I)
    LOW(RTN_J)
    HIGH(RTN_J)
    LOW(RTN_K)
    HIGH(RTN_K)
    LOW(RTN_L)
    HIGH(RTN_L)
    LOW(RTN_M)
    HIGH(RTN_M)
    LOW(RTN_N)
    HIGH(RTN_N)
    LOW(RTN_O)
    HIGH(RTN_O)
    LOW(RTN_P)
    HIGH(RTN_P)
    LOW(RTN_Q)
    HIGH(RTN_Q)
    LOW(RTN_R)
    HIGH(RTN_R)
    LOW(RTN_S)
    HIGH(RTN_S)
    LOW(CHECK_SCRIPT_AND_ADDL_STUFF_ITEMS_MAYBE_FIRST_OF_MANY)
    HIGH(CHECK_SCRIPT_AND_ADDL_STUFF_ITEMS_MAYBE_FIRST_OF_MANY)
    LOW(RTN_U)
    HIGH(RTN_U)
    LOW(RTN_V)
    HIGH(RTN_V)
    LOW(RTN_W)
    HIGH(RTN_W)
    LOW(RTN_X)
    HIGH(RTN_X)
    LOW(RTN_Y)
    HIGH(RTN_Y)
    LOW(RTN_Z_SIMPLER_ATTR_SET)
    HIGH(RTN_Z_SIMPLER_ATTR_SET)
    LOW(RTN_AA)
    HIGH(RTN_AA)
    LOW(RTN_AB)
    HIGH(RTN_AB)
    LOW(RTN_AC)
    HIGH(RTN_AC)
    LOW(RTN_AD)
    HIGH(RTN_AD)
    LOW(RTN_AE)
    HIGH(RTN_AE)
    LOW(RTN_AF_ALT_SCRIPTY_THING)
    HIGH(RTN_AF_ALT_SCRIPTY_THING)
    LOW(RTN_AG_ALT_SCRIPT_THING_BASIC)
    HIGH(RTN_AG_ALT_SCRIPT_THING_BASIC)
    LOW(RTN_AH)
    HIGH(RTN_AH)
    LOW(RTN_AI)
    HIGH(RTN_AI)
    LOW(RTN_AJ)
    HIGH(RTN_AJ)
    LOW(RTN_AK)
    HIGH(RTN_AK)
    LOW(RTN_AL)
    HIGH(RTN_AL)
    LOW(RTN_AM)
    HIGH(RTN_AM)
    LOW(RTN_AN)
    HIGH(RTN_AN)
    LOW(RTN_AO)
    HIGH(RTN_AO)
    LOW(RTN_AP)
    HIGH(RTN_AP)
    LOW(RTN_AQ)
    HIGH(RTN_AQ)
    LOW(RTN_AR)
    HIGH(RTN_AR)
RTN_A_CATCH_ADVANCE_0x2: ; 17:1863, 0x02F863
    LDA #$02 ; Mod val.
    JMP HELPER_0x17_ADVANCE_A_AND_RESWITCH_MAIN
RTN_B: ; 17:1868, 0x02F868
    JSR MOVE_FILE_UNK_WITH_OTHER_LARGE_SWITCH ; Save large.
MOD_SEEDED_SYNC: ; 17:186B, 0x02F86B
    LDX SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load ??
    LDY #$03 ; Seed file index.
    JSR DEEPER_SUB_UNK ; Do.
    LDX #$0A ; Seed script.
    LDA #$3E
    JMP SUB_SCRIPT_A_AND_X_SFX/SCRIPT ; Do.
RTN_C: ; 17:1879, 0x02F879
    JSR MOVE_FILE_UNK_WITH_OTHER_LARGE_SWITCH ; Large.
    LDX SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load ??
    LDY #$05 ; Seed file index.
    JSR DEEPER_SUB_UNK ; Do.
    LDX #$0A ; Seed scripty.
    LDA #$3D
    JMP SUB_SCRIPT_A_AND_X_SFX/SCRIPT ; Goto.
RTN_S: ; 17:188A, 0x02F88A
    JSR MOVE_FILE_UNK_WITH_OTHER_LARGE_SWITCH ; Seed ??
    LDX SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load ptr to use.
    LDY #$07 ; Seed stream index.
    JSR SYNC_X_PTR_Y_STREAM_HELPER_UNK ; Do.
    LDA #$20 ; Seed file.
    JMP SCRIPT_TEXT_AND_REENTER_THINGY??? ; Re-enter main.
RTN_D: ; 17:1899, 0x02F899
    JSR MOVE_FILE_UNK_WITH_OTHER_LARGE_SWITCH ; Move and switch.
    LDX SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load.
    LDY #$0C ; Seed file index.
    JSR SUB_TODO ; Do.
    LDX #$09 ; Seed SFX
    LDA #$23 ; Seed script.
    JMP SUB_SCRIPT_A_AND_X_SFX/SCRIPT ; Goto.
RTN_P: ; 17:18AA, 0x02F8AA
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load focus.
    JMP SUB_ATTR_THINGY_TODO ; Goto.
RTN_E: ; 17:18AF, 0x02F8AF
    LDX SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Seed ??
    LDY #$07 ; Load ??
    JSR SUB_SEEDED_UNK_MOVE_FILE_AND_SWITCH_LARGE_TODO ; Do.
    LDX #$09 ; Seed script.
    LDA #$20 ; Seed SFX/Script.
    JMP SUB_SCRIPT_A_AND_X_SFX/SCRIPT ; Goto.
RTN_F: ; 17:18BD, 0x02F8BD
    LDX SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Seed ??
    LDY #$09
    JSR SUB_SEEDED_UNK_MOVE_FILE_AND_SWITCH_LARGE_TODO ; Do.
    LDX #$09 ; Seed script.
    LDA #$22 ; Seed SFX.
    JMP SUB_SCRIPT_A_AND_X_SFX/SCRIPT
RTN_G_SET_MAX_AND_SCRIPTY: ; 17:18CB, 0x02F8CB
    LDA #$FF
    STA SUB/MOD_VAL_UNK_WORD[2] ; Set max.
    STA SUB/MOD_VAL_UNK_WORD+1
    JMP MOD_SEEDED_SYNC ; Goto.
PARTY_RELATED?_UNK: ; 17:18D4, 0x02F8D4
    LDA #$FF
    STA SUB/MOD_VAL_UNK_WORD[2] ; Seed ??
    STA SUB/MOD_VAL_UNK_WORD+1
    LDA #$00
    LDX SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load index.
    STA SCRIPT_PARTY_ATTRIBUTES+1,X ; Store ??
    LDY #$03 ; Load ??
    JSR DEEPER_SUB_UNK ; Goto.
    LDX #$0A ; Seed ??
    LDA #$00
    JSR SUB_SCRIPT_A_AND_X_SFX/SCRIPT ; Do ??
    LDX #$14
    JMP ENGINE_WAIT_X_SETTLES ; Wait and goto.
RTN_Q: ; 17:18F2, 0x02F8F2
    JSR MOVE_FILE_UNK_WITH_OTHER_LARGE_SWITCH ; Do.
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load focus.
    SEC ; Prep sub.
    LDA SCRIPT_PARTY_ATTRIBUTES+3,Y ; Load attr.
    SBC LIB_BCD/EXTRA_FILE_BCD_A ; Sub with.
    STA SCRIPT_PARTY_ATTRIBUTES+3,Y ; Store result.
    LDA SCRIPT_PARTY_ATTRIBUTES+4,Y ; Load attr.
    SBC LIB_BCD/EXTRA_FILE_BCD_B ; Carry sub.
    STA SCRIPT_PARTY_ATTRIBUTES+4,Y ; Store result.
    BCC SUB_UNDERFLOW ; CC, goto.
    ORA SCRIPT_PARTY_ATTRIBUTES+3,Y ; Set ??
    BEQ SUB_UNDERFLOW ; == 0, goto.
    JMP LIB_SCRIPT_HELPER_CREATE_DISPLAY_PACKET_HELPER ; Goto, display ??
SUB_UNDERFLOW: ; 17:1912, 0x02F912
    JMP SUBFOCUS_DO_SCRIPTED_UNK ; Goto.
RTN_H: ; 17:1915, 0x02F915
    LDA 56_OBJECT_NAME_SIZE? ; Load ??
    CMP #$05 ; If _ #$05
    BEQ SCRIPT_SAVE_ALT_FOCUS_AND_LARGE_SAVE/RESWITCH ; ==, goto.
    CMP #$06 ; If _ #$06
    BEQ SCRIPT_SAVE_ALT_FOCUS_AND_LARGE_SAVE/RESWITCH ; ==, goto.
    JSR SUB_FIND_ALT_FRIENDLY/SHIFT_SET ; Do sub.
    BCC SCRIPT_SAVE_ALT_FOCUS_AND_LARGE_SAVE/RESWITCH ; Ret CC, goto.
ATTR_MASK_DECIDE: ; 17:1924, 0x02F924
    LDX #$03 ; Seed mask.
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load focus.
    LDA SCRIPT_PARTY_ATTRIBUTES+17,Y ; Load attr.
    CMP #$06 ; If _ #$06
    BNE MASK_SEEDED ; !=, goto.
    LDX #$3F ; Seed alt mask.
MASK_SEEDED: ; 17:1931, 0x02F931
    STX LIB_BCD/EXTRA_FILE_BCD_A ; Store mask val.
    JSR RANDOMIZE_GROUP_A ; Randomize val.
    AND LIB_BCD/EXTRA_FILE_BCD_A ; Mask with.
    STA SUB/MOD_VAL_UNK_WORD[2] ; Store ??
    LDA #$00
    STA SUB/MOD_VAL_UNK_WORD+1 ; Clear upper.
SCRIPT_SAVE_ALT_FOCUS_AND_LARGE_SAVE/RESWITCH: ; 17:193E, 0x02F93E
    LDA SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load alt focus.
    PHA ; Save it.
    JSR MOVE_FILE_UNK_WITH_OTHER_LARGE_SWITCH ; Do large switch.
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load focus.
    LDA SCRIPT_PARTY_ATTRIBUTES+30,Y ; Load attr ??
    AND #$04 ; Keep ??
    BEQ VAL_CLEAR ; Clear, goto.
    LDA LIB_BCD/EXTRA_FILE_BCD_B ; Save file ??
    PHA
    LDA LIB_BCD/EXTRA_FILE_BCD_A
    PHA
    LDA #$53 ; Script.
    JSR SCRIPT_TEXT_AND_REENTER_THINGY???
    PLA
    STA LIB_BCD/EXTRA_FILE_BCD_A ; Restore file.
    PLA
    STA LIB_BCD/EXTRA_FILE_BCD_B
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Move main focus to secondary.
    STY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING
VAL_CLEAR: ; 17:1962, 0x02F962
    LDA SCRIPT_PARTY_ATTRIBUTES+30,Y ; Load attr ??
    AND #$10 ; Test ??
    BEQ TEST_CLEAR ; Clear, goto.
    LSR LIB_BCD/EXTRA_FILE_BCD_B ; >> 1
    ROR LIB_BCD/EXTRA_FILE_BCD_A
TEST_CLEAR: ; 17:196D, 0x02F96D
    LDA SCRIPT_PARTY_ATTRIBUTES+30,Y ; Load attr ??
    AND #$08 ; Keep 0000.1000
    BEQ VAL_CLEAR ; == 0, goto.
    LSR LIB_BCD/EXTRA_FILE_BCD_B ; >> 1
    ROR LIB_BCD/EXTRA_FILE_BCD_A
VAL_CLEAR: ; 17:1978, 0x02F978
    JSR ATTR_HELPER_MASK/ROTATE_UNK ; Do sub.
    LDA LIB_BCD/EXTRA_FILE_BCD_A ; Load.
    ORA LIB_BCD/EXTRA_FILE_BCD_B ; Combine with.
    BNE COMBINED_NONZERO ; != 0, goto.
    INC LIB_BCD/EXTRA_FILE_BCD_A ; ++
COMBINED_NONZERO: ; 17:1983, 0x02F983
    LDA LIB_BCD/EXTRA_FILE_BCD_A ; Move ??
    STA BATTLE_ARRAY_UNK[5]
    PHA ; Save it, too.
    LDA LIB_BCD/EXTRA_FILE_BCD_B ; Move ??
    STA BATTLE_ARRAY_UNK+1
    PHA ; Save it.
    LDA #$0C ; Script ??
    JSR SCRIPT_TEXT_AND_REENTER_THINGY???
    PLA
    STA LIB_BCD/EXTRA_FILE_BCD_B ; Restore file.
    PLA
    STA LIB_BCD/EXTRA_FILE_BCD_A
    LDA 56_OBJECT_NAME_SIZE? ; Load ??
    CMP #$03 ; If _ #$03
    BEQ VAL_EQ_0x00 ; == 0, goto.
    JSR SCRIPT_HELP_CHECK_ATTR_FRIEND_ATTR_0x6-UNK ; Do attr.
    BCS IS_TRUE ; CS, goto.
VAL_EQ_0x00: ; 17:19A5, 0x02F9A5
    JSR SUB_FIND_ALT_FRIENDLY/SHIFT_SET ; Do sub.
    BCS IS_TRUE ; CS, goto.
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load focus.
    SEC ; Prep sub.
    LDA SCRIPT_PARTY_ATTRIBUTES+3,Y ; Load attr.
    SBC LIB_BCD/EXTRA_FILE_BCD_A ; Sub with.
    STA SCRIPT_PARTY_ATTRIBUTES+3,Y ; Store to.
    LDA SCRIPT_PARTY_ATTRIBUTES+4,Y ; Load attr.
    SBC LIB_BCD/EXTRA_FILE_BCD_B ; Carry sub.
    STA SCRIPT_PARTY_ATTRIBUTES+4,Y ; Store to.
    BCC SUB_UNDERFLOW ; Underflow, goto.
    ORA SCRIPT_PARTY_ATTRIBUTES+3,Y ; Combine with.
    BEQ SUB_UNDERFLOW ; == 0, min.
IS_TRUE: ; 17:19C4, 0x02F9C4
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y ; Load ??
    AND #$0C ; Mask 0000.1100
    BEQ MASK_EQ_0x00 ; == 0, goto.
    JSR RANDOMIZE_GROUP_A ; Randomize.
    AND #$C0 ; Keep 1100.0000
    BNE MASK_EQ_0x00 ; != 0, goto.
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y ; Load attr ??
    AND #$F3 ; Keep 1111.0011
    STA SCRIPT_PARTY_ATTRIBUTES+1,Y ; Store back.
    LDA #$8D ; Script ??
    JSR SCRIPT_TEXT_AND_REENTER_THINGY??? ; Do.
MASK_EQ_0x00: ; 17:19DF, 0x02F9DF
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y ; Load attr ??
    AND #$10 ; Test ??
    BEQ EXIT_RESTORE_AND_MESSAGE ; == 0, goto. Not set.
    JSR RANDOMIZE_GROUP_A ; Randomize.
    AND #$C0 ; Keep upper.
    BNE EXIT_RESTORE_AND_MESSAGE ; != 0, goto.
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y ; Load attr ??
    AND #$EF ; Keep 1110.1111
    STA SCRIPT_PARTY_ATTRIBUTES+1,Y ; Store to.
    LDA #$61 ; Script ??
    JSR SCRIPT_TEXT_AND_REENTER_THINGY??? ; Do.
EXIT_RESTORE_AND_MESSAGE: ; 17:19FA, 0x02F9FA
    PLA ; Restore subfocus?
    STA SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING
    JMP LIB_SCRIPT_HELPER_CREATE_DISPLAY_PACKET_HELPER ; Display packet do.
SUB_UNDERFLOW: ; 17:1A00, 0x02FA00
    JSR SUBFOCUS_DO_SCRIPTED_UNK ; Do sub.
    PLA ; Restore subfocus.
    STA SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING
    RTS ; Leave.
RTN_I: ; 17:1A07, 0x02FA07
    JSR MOVE_FILE_UNK_WITH_OTHER_LARGE_SWITCH ; Do.
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load subfocus.
    JSR ATTR_HELPER_MASK/ROTATE_UNK ; Do attr.
    LDX SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load subfocus.
    LDY #$09 ; Seed ??
    JSR X_PTR_Y_STREAM_SEEDED_RTN_UNK_TODO_FIGURE_UNK ; Do.
    LDA #$27 ; Seed script.
    JMP SCRIPT_TEXT_AND_REENTER_THINGY??? ; Goto.
RTN_J: ; 17:1A1B, 0x02FA1B
    JSR MOVE_FILE_UNK_WITH_OTHER_LARGE_SWITCH ; Do sub.
    LDX SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load focus file.
    LDY #$0B ; Seed stream.
    JSR X_PTR_Y_STREAM_ROUTINE ; Do routine.
    LDA #$26 ; Script ??
    JMP SCRIPT_TEXT_AND_REENTER_THINGY??? ; Goto.
RTN_K: ; 17:1A2A, 0x02FA2A
    JSR SUB_FIND_ALT_FRIENDLY/SHIFT_SET ; Do ??
    BCS EXIT_MASKY_THING ; CS, goto.
    JSR SCRIPT_HELP_CHECK_ATTR_FRIEND_ATTR_0x6-UNK ; Do sub.
    BCS EXIT_MASKY_THING ; Ret CS, goto.
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Seed alt focus.
    JMP SUBFOCUS_DO_SCRIPTED_UNK ; Goto.
EXIT_MASKY_THING: ; 17:1A39, 0x02FA39
    JMP ATTR_MASK_DECIDE ; Goto.
RTN_L: ; 17:1A3C, 0x02FA3C
    JSR SUB_FIND_ALT_FRIENDLY/SHIFT_SET ; Do.
    BCS EXIT_FAIL? ; CS, goto.
    JSR SCRIPT_HELP_CHECK_ATTR_FRIEND_ATTR_0x6-UNK ; Do attr.
    BCS EXIT_FAIL? ; CS, goto.
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load subfocus.
    JSR RANDOMIZE_GROUP_A ; Randomize.
    AND #$03 ; Keep lower.
    TAX ; To X.
    INX ; X++
    TXA ; X to A.
    SEC ; Prep sub.
    SBC SCRIPT_PARTY_ATTRIBUTES+3,Y ; Sub with attr.
    LDA #$00 ; Cary seed.
    SBC SCRIPT_PARTY_ATTRIBUTES+4,Y ; Carry sub.
    BCS EXIT_FAIL? ; No underflow, fail.
    TXA ; X to A.
    STA SCRIPT_PARTY_ATTRIBUTES+3,Y ; Store attr ??
    LDA #$00
    STA SCRIPT_PARTY_ATTRIBUTES+4,Y ; Clear ??
    LDX #$00 ; Seed script and sfx/script.
    LDA #$38
    JMP SUB_SCRIPT_A_AND_X_SFX/SCRIPT ; Do.
EXIT_FAIL?: ; 17:1A6B, 0x02FA6B
    JMP EXIT_REENTER_SCRIPT_0x55_HELPER ; Goto.
RTN_M: ; 17:1A6E, 0x02FA6E
    LDX SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; File ID.
    LDY #$07 ; Seed index.
    JSR SCRIPTY_PTR/STREAM_THINGY_SUB_HUGE_TODO ; Do sub.
    LDA #$21 ; Seed script ??
    JMP SCRIPT_TEXT_AND_REENTER_THINGY??? ; Goto.
RTN_N: ; 17:1A7A, 0x02FA7A
    LDX SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; File ID.
    LDY #$09 ; Seed index.
    JSR SCRIPTY_PTR/STREAM_THINGY_SUB_HUGE_TODO ; Do sub.
    LDA #$27 ; Script ??
    JMP SCRIPT_TEXT_AND_REENTER_THINGY??? ; Goto.
RTN_R: ; 17:1A86, 0x02FA86
    JSR MOVE_FILE_UNK_WITH_OTHER_LARGE_SWITCH ; Do large.
    LDX SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load focus.
    LDY #$07 ; Load index.
    JSR SYNC_X_PTR_Y_STREAM_HELPER_UNK ; Do sub.
    LDA #$5C ; Seed file.
    JMP SCRIPT_TEXT_AND_REENTER_THINGY??? ; Goto.
RTN_O: ; 17:1A95, 0x02FA95
    JSR MOVE_FILE_UNK_WITH_OTHER_LARGE_SWITCH ; Do large switch.
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load alt focus.
    BMI EXIT_SCRIPT_UNK ; Foe, goto.
    LDA PARTY_ATTR_PTR[2],Y ; Move file ??
    STA LIB_BCD2/EXTRA_FILE_STREAM_INDEX
    LDA PARTY_ATTR_PTR+1,Y
    STA LIB_BCD/EXTRA_FILE_D
    LDY #$11 ; Stream index.
    CLC ; Prep add.
    LDA [LIB_BCD2/EXTRA_FILE_STREAM_INDEX],Y ; Load from file.
    ADC LIB_BCD/EXTRA_FILE_BCD_A ; Add with ??
    STA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2] ; Store to.
    INY ; Stream++
    LDA [LIB_BCD2/EXTRA_FILE_STREAM_INDEX],Y ; Load stream.
    ADC LIB_BCD/EXTRA_FILE_BCD_B ; Add with.
    STA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER+1 ; Store to.
    INY ; Stream++
    LDA [LIB_BCD2/EXTRA_FILE_STREAM_INDEX],Y ; Load from file.
    ADC #$00 ; Carry add.
    STA ALT_STUFF_COUNT? ; Store to.
    BCC CARRY_NO_OVERFLOW ; CC, goto.
    LDA #$FF
    STA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2] ; Set max if overflow.
    STA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER+1
    STA ALT_STUFF_COUNT?
CARRY_NO_OVERFLOW: ; 17:1AC7, 0x02FAC7
    JSR ENGINE_WRAM_STATE_WRITEABLE ; Do WRAM.
    LDY #$11 ; Stream index.
    LDA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2] ; Move ??
    STA [LIB_BCD2/EXTRA_FILE_STREAM_INDEX],Y ; Save to WRAM?
    INY ; Stream++
    LDA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER+1 ; Move ??
    STA [LIB_BCD2/EXTRA_FILE_STREAM_INDEX],Y
    INY ; Stream++
    LDA ALT_STUFF_COUNT? ; Load ??
    STA [LIB_BCD2/EXTRA_FILE_STREAM_INDEX],Y ; Store to WRAM?
    JSR ENGINE_WRAM_STATE_WRITE_DISABLED ; Disable WRAM.
EXIT_SCRIPT_UNK: ; 17:1ADD, 0x02FADD
    LDX #$0A ; Seed script.
    LDA #$2F
    JMP SUB_SCRIPT_A_AND_X_SFX/SCRIPT ; Goto.
CHECK_SCRIPT_AND_ADDL_STUFF_ITEMS_MAYBE_FIRST_OF_MANY: ; 17:1AE4, 0x02FAE4
    JSR SUB_FIND_ALT_FRIENDLY/SHIFT_SET ; Do.
    BCS EXIT_REENTER_HELPER ; CS, exit.
    JSR SEED_ATTRS_A ; Do attrs.
    BCS EXIT_REENTER_HELPER ; CS, exit.
    LDA #$1B ; Seed  ??
    LDY #$00 ; ID ??
    LDX #$80 ; Invert val.
    JMP SCRIPT_HELP_X_MASKY_Y_ID_A_SOUND/SCRIPT_ALT_B ; Goto.
EXIT_REENTER_HELPER: ; 17:1AF7, 0x02FAF7
    JMP EXIT_REENTER_SCRIPT_0x55_HELPER ; Goto.
RTN_U: ; 17:1AFA, 0x02FAFA
    JSR SUB_FIND_ALT_FRIENDLY/SHIFT_SET ; Do sub.
    BCS EXIT_REENTER_HELPER ; CS, goto.
    JSR SEED_ATTRS_A ; Do ??
    BCS EXIT_REENTER_HELPER ; CS, goto.
    LDA #$4B ; Seed ??
    LDY #$00
    LDX #$02
    JMP SCRIPT_HELP_X_MASKY_Y_ID_A_SOUND/SCRIPT_ALT_A ; Goto.
RTN_V: ; 17:1B0D, 0x02FB0D
    JSR SUB_FIND_ALT_FRIENDLY/SHIFT_SET ; Do ??
    BCS EXIT_REENTER_HELPER ; CS, goto.
    JSR SCRIPT_HELP_CHECK_ATTR_FRIEND_ATTR_0x6-UNK ; Do ??
    BCS EXIT_REENTER_HELPER ; Goto.
    JSR SEED_ATTRS_B ; Do rtn.
    BCS EXIT_REENTER_HELPER ; CS, goto.
    LDA #$39 ; Seed file sound.
    LDY #$00 ; ID.
    LDX #$08 ; Masky.
    JMP SCRIPT_HELP_X_MASKY_Y_ID_A_SOUND/SCRIPT_ALT_A ; Goto.
RTN_W: ; 17:1B25, 0x02FB25
    JSR SUB_FIND_ALT_FRIENDLY/SHIFT_SET ; Do.
    BCS EXIT_REENTER_HELPER ; CS, exit.
    JSR SCRIPT_HELP_CHECK_ATTR_FRIEND_ATTR_0x6-UNK ; Do attr.
    BCS EXIT_REENTER_HELPER ; CS, goto.
    JSR SEED_ATTRS_B ; Do.
    BCS EXIT_REENTER_HELPER ; CS, leave.
    LDA #$3B ; Seed.
    LDY #$00
    LDX #$10
    JMP SCRIPT_HELP_X_MASKY_Y_ID_A_SOUND/SCRIPT_ALT_A ; Do.
RTN_X: ; 17:1B3D, 0x02FB3D
    JSR SUB_FIND_ALT_FRIENDLY/SHIFT_SET ; Do ??
    BCS EXIT_REENTER_HELPER ; CS, goto.
    JSR SCRIPT_HELP_CHECK_ATTR_FRIEND_ATTR_0x6-UNK ; Do ??
    BCS EXIT_REENTER_HELPER ; CS, goto.
    JSR SEED_ATTRS_A ; Do.
    BCS EXIT_REENTER_HELPER ; CS, goto.
    LDA #$49 ; Do script.
    LDY #$00
    LDX #$20
    JMP SCRIPT_HELP_X_MASKY_Y_ID_A_SOUND/SCRIPT_ALT_A ; Goto.
RTN_Y: ; 17:1B55, 0x02FB55
    JSR SUB_FIND_ALT_FRIENDLY/SHIFT_SET ; Do sub.
    BCS EXIT_REENTER_HELPER ; CS, goto.
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load index.
    LDA PARTY_ATTR_PTR[2],Y ; Move attr ??
    STA LIB_BCD/EXTRA_FILE_BCD_A
    LDA PARTY_ATTR_PTR+1,Y
    STA LIB_BCD/EXTRA_FILE_BCD_B
    LDY #$05 ; Stream index.
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y ; Load from file.
    INY ; Stream++
    ORA [LIB_BCD/EXTRA_FILE_BCD_A],Y ; Combine with.
    BEQ EXIT_REENTER_HELPER ; == 0, goto, do none.
    LDA #$4D ; Seed give ??
    LDY #$00
    LDX #$40
    JMP SCRIPT_HELP_X_MASKY_Y_ID_A_SOUND/SCRIPT_ALT_B ; Goto.
RTN_Z_SIMPLER_ATTR_SET: ; 17:1B78, 0x02FB78
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Seed alt focus.
    LDA SCRIPT_PARTY_ATTRIBUTES+30,Y ; Load attr ??
    ORA #$08 ; Set ??
    STA SCRIPT_PARTY_ATTRIBUTES+30,Y ; Store to.
    RTS ; Leave.
RTN_AA: ; 17:1B83, 0x02FB83
    LDA #$4F ; Seed scripty.
    LDY #$0A
    LDX #$10
    JMP SCRIPT_HELP_X_MASKY_Y_ID_A_SOUND/SCRIPT_ALT_B ; Goto.
RTN_AB: ; 17:1B8C, 0x02FB8C
    JSR SCRIPT_HELP_VAR_SHIFT_TEST ; Do helper.
    BCS EXIT_JMP_HELPER ; CS, goto.
    LDA #$17 ; Seed.
    LDY #$0A
    LDX #$04
    JMP SCRIPT_HELP_X_MASKY_Y_ID_A_SOUND/SCRIPT_ALT_B ; Do.
EXIT_JMP_HELPER: ; 17:1B9A, 0x02FB9A
    JMP EXIT_REENTER_SCRIPT_0x55_HELPER ; Exit helper.
RTN_AC: ; 17:1B9D, 0x02FB9D
    JSR SUB_FIND_ALT_FRIENDLY/SHIFT_SET ; Do.
    BCS EXIT_JMP_HELPER ; CS, goto.
    JSR SCRIPT_HELP_CHECK_ATTR_FRIEND_ATTR_0x6-UNK ; Do attr.
    BCS EXIT_JMP_HELPER ; CS, goto.
    LDA #$4E ; Seed.
    LDY #$00
    LDX #$20
    JMP SCRIPT_HELP_X_MASKY_Y_ID_A_SOUND/SCRIPT_ALT_B ; Goto.
RTN_AD: ; 17:1BB0, 0x02FBB0
    JSR SUB_FIND_ALT_FRIENDLY/SHIFT_SET ; Helper.
    BCS EXIT_JMP_HELPER ; CS, goto.
    JSR SCRIPT_HELP_CHECK_ATTR_FRIEND_ATTR_0x6-UNK ; Do.
    BCS EXIT_JMP_HELPER ; Ret CS, goto.
    LDA #$19 ; Seed ??
    LDY #$00
    LDX #$40
    JSR SCRIPT_HELP_X_MASKY_Y_ID_A_SOUND/SCRIPT_ALT_A
    BCS RET_CS ; CS, leave.
    LDX SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Set attr ??
    LDY #$09 ; Seed ??
    JSR SUB_SEEDED_UNK_MOVE_FILE_AND_SWITCH_LARGE_TODO ; Do sub.
RET_CS: ; 17:1BCC, 0x02FBCC
    RTS ; Leave.
RTN_AE: ; 17:1BCD, 0x02FBCD
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load focus.
    LDA SCRIPT_PARTY_ATTRIBUTES+17,Y ; Load attr ??
    CMP #$01 ; If _ #$01
    BNE RTS ; !=, leave.
    LDA SCRIPT_PARTY_ATTRIBUTES+30,Y ; Load attr.
    AND #$02 ; Keep ??
    BNE RTS ; != 0, goto.
    LDA SCRIPT_PARTY_ATTRIBUTES+30,Y ; Load ??
    ORA #$02 ; Set attr ??
    STA SCRIPT_PARTY_ATTRIBUTES+30,Y ; Set attr.
    LDA #$74 ; Seed script.
    JMP SCRIPT_TEXT_AND_REENTER_THINGY??? ; Goto.
RTS: ; 17:1BEA, 0x02FBEA
    RTS ; Leave.
RTN_AF_ALT_SCRIPTY_THING: ; 17:1BEB, 0x02FBEB
    JSR SEED_ATTRS_B ; Seed attrs.
    BCS EXIT_JMP_HELPER ; CS, exit.
    LDA #$67 ; Seed ??
    LDY #$00
    LDX #$04
    JMP SCRIPT_HELP_X_MASKY_Y_ID_A_SOUND/SCRIPT_ALT_A ; Script.
RTN_AG_ALT_SCRIPT_THING_BASIC: ; 17:1BF9, 0x02FBF9
    LDA #$5D ; Seed ??
    LDY #$0A
    LDX #$02
    JMP SCRIPT_HELP_X_MASKY_Y_ID_A_SOUND/SCRIPT_ALT_C ; Goto.
RTN_AH: ; 17:1C02, 0x02FC02
    LDA #$61 ; Script ??
    LDY #$0A
    LDX #$10
    JMP SCRIPT_HELP_X_MASKY_Y_ID_A_SOUND/SCRIPT_ALT_C
RTN_AI: ; 17:1C0B, 0x02FC0B
    LDA #$60 ; Script ??
    LDY #$0A
    LDX #$20
    JMP SCRIPT_HELP_X_MASKY_Y_ID_A_SOUND/SCRIPT_ALT_C
RTN_AJ: ; 17:1C14, 0x02FC14
    LDA #$70 ; Script ??
    LDY #$0A
    LDX #$02
    JMP SCRIPT_HELP_X_MASKY_Y_ID_A_SOUND/SCRIPT_ALT_D
RTN_AK: ; 17:1C1D, 0x02FC1D
    LDA #$5E ; Script ??
    LDY #$0A
    LDX #$0C
    JMP SCRIPT_HELP_X_MASKY_Y_ID_A_SOUND/SCRIPT_ALT_C
RTN_AL: ; 17:1C26, 0x02FC26
    LDA #$69 ; Script ??
    LDY #$02
    LDX #$10
    JMP SCRIPT_HELP_X_MASKY_Y_ID_A_SOUND/SCRIPT_ALT_D
RTN_AN: ; 17:1C2F, 0x02FC2F
    LDA #$71 ; Script ??
    LDY #$0A
    LDX #$40
    JMP SCRIPT_HELP_X_MASKY_Y_ID_A_SOUND/SCRIPT_ALT_C
RTN_AM: ; 17:1C38, 0x02FC38
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load focus alt.
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y ; Load ??
    AND #$80 ; Keep upper.
    BEQ EXIT_REENTER ; == 0, goto.
    LDA #$00 ; Seed clear.
    STA SCRIPT_PARTY_ATTRIBUTES+1,Y ; Clear ??
    LDA #$FF
    STA SUB/MOD_VAL_UNK_WORD[2] ; Set max ??
    STA SUB/MOD_VAL_UNK_WORD+1
    LDX SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Seed file ID.
    LDY #$03 ; Seed stream index.
    JSR DEEPER_SUB_UNK ; Do deeper.
    LDX #$0A ; Seed script/sfx.
    LDA #$62
    JMP SUB_SCRIPT_A_AND_X_SFX/SCRIPT ; Goto.
EXIT_REENTER: ; 17:1C5A, 0x02FC5A
    JMP EXIT_REENTER_SCRIPT_0x55_HELPER ; Reenter helper.
RTN_AQ: ; 17:1C5D, 0x02FC5D
    LDX 56_OBJECT_NAME_SIZE? ; Load ??
    CPX #$06 ; If _ #$06
    BEQ LONG_ALL_FINAL_SONG ; ==, goto.
    LDA #$19
    JSR SOUND_LIB_SET_NEW_SONG_ID ; Do melody.
    LDA SOUND_MAIN_SONG_CURRENTLY_PLAYING_ID
    PHA
    LDX #$00
    JSR SCRIPT_BATTLE_HELPER_BG_COLORS?
    LDA #$03
    STA SOUND_EFFECT_REQUEST_ARRAY[5] ; Play SFX hit special?
    LDX #$38
    JSR ENGINE_WAIT_X_SETTLES ; Wait settles.
    PLA ; Pull value.
    CMP SOUND_MAIN_SONG_CURRENTLY_PLAYING_ID ; If _ ID playing
    BEQ EXIT_NO_REINIT
    STA SOUND_MAIN_SONG_INIT_ID ; Store init.
EXIT_NO_REINIT: ; 17:1C84, 0x02FC84
    RTS ; Leave.
LONG_ALL_FINAL_SONG: ; 17:1C85, 0x02FC85
    LDA #$19
    JSR SOUND_LIB_SET_NEW_SONG_ID ; Set song ID, long melody.
    SEC ; Prep sub.
    LDA 57_INDEX_UNK ; Load ??
    SBC #$9E ; -= 0x9E
    TAX ; To X index.
    JSR SCRIPT_BATTLE_HELPER_BG_COLORS? ; Do BG colors.
    LDA #$03
    STA SOUND_EFFECT_REQUEST_ARRAY[5] ; SFX hit hard?
    JSR ENTRY_BLACK_ALT_A_EXTENDED ; Do entry.
    LDA 57_INDEX_UNK ; Load ??
    JSR SCRIPT_TEXT_AND_REENTER_THINGY??? ; Do script.
    LDA #$2C
    JSR SOUND_LIB_SET_NEW_SONG_ID ; Giygas/star SFX?
    LDX 57_INDEX_UNK ; Load ??
    INX ; Index++
    CPX #$A9 ; If _ #$A9
    BEQ VAL_EQ_0xA9 ; ==, goto.
    STX 57_INDEX_UNK ; Store index.
    RTS ; Leave.
VAL_EQ_0xA9: ; 17:1CAF, 0x02FCAF
    JSR LOOP_SFX_0x3_TIMES ; Do SFX.
    LDA #$FF
    JSR SOUND_LIB_SET_NEW_SONG_ID ; No song.
    LDX #$C8
    JSR ENGINE_WAIT_X_SETTLES ; Wait time.
    LDX #$A9 ; Seed ??
LOOP_NE_0xAC: ; 17:1CBE, 0x02FCBE
    STX 57_INDEX_UNK ; Store val.
    TXA ; X to A.
    JSR SCRIPT_TEXT_AND_REENTER_THINGY??? ; Do script.
    LDX 57_INDEX_UNK ; Load index.
    INX ; ++
    CPX #$AC ; If _ #$AC
    BNE LOOP_NE_0xAC ; !=, goto.
    LDY #$80 ; Seed ??
    JMP SUBFOCUS_DO_SCRIPTED_UNK ; Goto.
RTN_AO: ; 17:1CD0, 0x02FCD0
    LDX #$0A ; Load ??
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Seed focus.
    LDA SCRIPT_PARTY_ATTRIBUTES+5,Y ; Load attr.
    ORA SCRIPT_PARTY_ATTRIBUTES+6,Y ; Combine with.
    BEQ EXIT_REENTER_HELPER ; == 0, goto.
    SEC ; Prep sub.
    LDA SCRIPT_PARTY_ATTRIBUTES+5,Y ; Load val.
    TAX ; To X.
    SBC #$0A ; -= 0xA
    LDA SCRIPT_PARTY_ATTRIBUTES+6,Y ; Load other.
    SBC #$00 ; Carry sub.
    BCC SUB_UNDERFLOW ; Underflow, goto.
    LDX #$0A ; Seed val.
SUB_UNDERFLOW: ; 17:1CEC, 0x02FCEC
    STX BATTLE_ARRAY_UNK[5] ; Store val.
    LDX #$00
    STX BATTLE_ARRAY_UNK+1 ; Clear ??
    SEC ; Prep sub.
    LDA SCRIPT_PARTY_ATTRIBUTES+5,Y ; Load attr ??
    SBC BATTLE_ARRAY_UNK[5] ; Sub with.
    STA SCRIPT_PARTY_ATTRIBUTES+5,Y ; Store result back.
    LDA SCRIPT_PARTY_ATTRIBUTES+6,Y ; Load attr ??
    SBC BATTLE_ARRAY_UNK+1 ; Carry sub.
    STA SCRIPT_PARTY_ATTRIBUTES+6,Y ; Store result.
    LDA #$48 ; Seed script ??
    JSR SCRIPT_TEXT_AND_REENTER_THINGY??? ; Do sub.
    LDA BATTLE_ARRAY_UNK[5] ; Move ??
    STA LIB_BCD/EXTRA_FILE_BCD_A
    LDA BATTLE_ARRAY_UNK+1
    STA LIB_BCD/EXTRA_FILE_BCD_B
    LDX SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load file ID.
    LDY #$05 ; Seed stream index.
    JSR DEEPER_SUB_UNK ; Do sub.
    LDA SCRIPT_BATTLE_PARTY_ID_FOCUS ; Move focus to secondary.
    STA SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING
    LDX #$0A ; Seed sound/helper.
    LDA #$3D ; Seed script.
    JMP SUB_SCRIPT_A_AND_X_SFX/SCRIPT
EXIT_REENTER_HELPER: ; 17:1D28, 0x02FD28
    JMP EXIT_REENTER_SCRIPT_0x55_HELPER ; Exit.
RTN_AP: ; 17:1D2B, 0x02FD2B
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load focus alt.
    BMI EXIT_SCRIPT_0x59 ; Negative, goto.
    JSR PARTY_FOCUS_NO_ATTRS_SET_UNK ; Do sub.
    BCS EXIT_SCRIPT_0x59 ; CS, goto.
    JSR ENABLE_WRAM_UNK ; WRAM.
    JSR SCRIPT_BATTLE_MOVE_ARR_UNK ; Do script.
    LDA #$81 ; Script ID.
    JMP SCRIPT_TEXT_AND_REENTER_THINGY???
EXIT_SCRIPT_0x59: ; 17:1D3F, 0x02FD3F
    LDA #$59 ; Script.
    JMP SCRIPT_TEXT_AND_REENTER_THINGY??? ; Goto.
RTN_AR: ; 17:1D44, 0x02FD44
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load focus alt.
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y ; Load attr ??
    AND #$08 ; Keep 0000.1000
    BNE EXIT_LEAVE ; Set, goto.
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y ; Load attr.
    ORA #$08 ; Set it.
    STA SCRIPT_PARTY_ATTRIBUTES+1,Y ; Store back.
    LDA #$39
    JSR SCRIPT_TEXT_AND_REENTER_THINGY??? ; Script.
EXIT_LEAVE: ; 17:1D5A, 0x02FD5A
    RTS ; Leave.
SUB_SCRIPT_A_AND_X_SFX/SCRIPT: ; 17:1D5B, 0x02FD5B
    PHA ; Save A.
    TXA ; X to A.
    BEQ X_EQ_0x00 ; == 0, goto.
    JSR LIB_PLAY_BATTLE_SFX_A_PASSED_WITH_SCRIPT_DOING_TODO ; Do ??
X_EQ_0x00: ; 17:1D62, 0x02FD62
    JSR LIB_SCRIPT_HELPER_CREATE_DISPLAY_PACKET_HELPER ; Do ??
    PLA ; Pull value.
    JMP SCRIPT_TEXT_AND_REENTER_THINGY??? ; Do ??
SCRIPT_HELP_X_MASKY_Y_ID_A_SOUND/SCRIPT_ALT_A: ; 17:1D69, 0x02FD69
    PHA ; Save script sound value.
    JSR SCRIPT_VAL_HELPER_X_MASK_Y_ID_RET_ALTFOCUS ; Do sub set vals.
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y ; Load ??
    AND LIB_BCD/EXTRA_FILE_BCD_A ; Mask with.
    BNE EXIT_SCRIPT_EXEC_STACK_HELPER ; != 0, goto.
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y ; Load attr.
    ORA LIB_BCD/EXTRA_FILE_BCD_A ; Combine with.
    STA SCRIPT_PARTY_ATTRIBUTES+1,Y ; Store to.
    JMP EXIT_SCRIPT_SFX/SCRIPT? ; Exit script.
SCRIPT_HELP_X_MASKY_Y_ID_A_SOUND/SCRIPT_ALT_B: ; 17:1D7F, 0x02FD7F
    PHA ; Save passed.
    JSR SCRIPT_VAL_HELPER_X_MASK_Y_ID_RET_ALTFOCUS ; Do sub.
    LDA SCRIPT_PARTY_ATTRIBUTES+30,Y ; Load ??
    AND LIB_BCD/EXTRA_FILE_BCD_A ; Mask with.
    BNE EXIT_SCRIPT_EXEC_STACK_HELPER ; != 0, goto.
    LDA SCRIPT_PARTY_ATTRIBUTES+30,Y ; Load ??
    ORA LIB_BCD/EXTRA_FILE_BCD_A ; Combine with.
    STA SCRIPT_PARTY_ATTRIBUTES+30,Y ; Store attr.
    JMP EXIT_SCRIPT_SFX/SCRIPT? ; Goto.
SCRIPT_HELP_X_MASKY_Y_ID_A_SOUND/SCRIPT_ALT_C: ; 17:1D95, 0x02FD95
    PHA ; Save script.
    JSR SCRIPT_VAL_HELPER_X_MASK_Y_ID_RET_ALTFOCUS ; Do vals.
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y ; Load attr.
    AND LIB_BCD/EXTRA_FILE_BCD_A ; Mask.
    BEQ EXIT_SCRIPT_EXEC_STACK_HELPER ; Clear, goto.
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y ; Load ??
    AND LIB_BCD/EXTRA_FILE_BCD_B ; Mask with.
    STA SCRIPT_PARTY_ATTRIBUTES+1,Y ; Store back.
    JMP EXIT_SCRIPT_SFX/SCRIPT? ; Exit helper.
SCRIPT_HELP_X_MASKY_Y_ID_A_SOUND/SCRIPT_ALT_D: ; 17:1DAB, 0x02FDAB
    PHA ; Save val.
    JSR SCRIPT_VAL_HELPER_X_MASK_Y_ID_RET_ALTFOCUS ; Do vals.
    LDA SCRIPT_PARTY_ATTRIBUTES+30,Y ; Load attr ??
    AND LIB_BCD/EXTRA_FILE_BCD_A ; Mask ??
    BEQ EXIT_SCRIPT_EXEC_STACK_HELPER ; == 0, goto.
    LDA SCRIPT_PARTY_ATTRIBUTES+30,Y ; Load ??
    AND LIB_BCD/EXTRA_FILE_BCD_B ; Mask ??
    STA SCRIPT_PARTY_ATTRIBUTES+30,Y ; Store attr back. Fall through to end others use.
EXIT_SCRIPT_SFX/SCRIPT?: ; 17:1DBE, 0x02FDBE
    LDX SCRIPT_EFFECT_SFX_AND_SCRIPT_DO_UNK_GIVE_ITEM? ; Load val.
    PLA ; Save to stack.
    JSR SUB_SCRIPT_A_AND_X_SFX/SCRIPT ; Do script SFX.
    CLC ; Ret CC.
    RTS
EXIT_SCRIPT_EXEC_STACK_HELPER: ; 17:1DC6, 0x02FDC6
    PLA ; Pull stack.
    JSR EXIT_REENTER_SCRIPT_0x55_HELPER ; Do sub.
    SEC ; Ret CS.
    RTS
SCRIPT_VAL_HELPER_X_MASK_Y_ID_RET_ALTFOCUS: ; 17:1DCC, 0x02FDCC
    STX LIB_BCD/EXTRA_FILE_BCD_A ; Load ??
    TXA ; X to A.
    EOR #$FF ; Invert val.
    STA LIB_BCD/EXTRA_FILE_BCD_B ; Store to alt.
    STY SCRIPT_EFFECT_SFX_AND_SCRIPT_DO_UNK_GIVE_ITEM? ; Store passed ??
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Return alt.
    RTS ; Leave.
EXIT_REENTER_SCRIPT_0x55_HELPER: ; 17:1DD8, 0x02FDD8
    LDA #$55 ; Seed script.
    JMP SCRIPT_TEXT_AND_REENTER_THINGY??? ; Goto, reenter.
MOVE_FILE_UNK_WITH_OTHER_LARGE_SWITCH: ; 17:1DDD, 0x02FDDD
    LDA SUB/MOD_VAL_UNK_WORD[2] ; Move ??
    STA LIB_BCD/EXTRA_FILE_BCD_A
    LDA SUB/MOD_VAL_UNK_WORD+1
    STA LIB_BCD/EXTRA_FILE_BCD_B
    JMP SCRIPT_HARD_SWITCH_HUGE_FILES_TODO ; Do hard switch.
SYNC_X_PTR_Y_STREAM_HELPER_UNK: ; 17:1DE8, 0x02FDE8
    JSR X_PTR_Y_STREAM_SEEDED_MOVE_UNK ; Do.
SYNC_UNK: ; 17:1DEB, 0x02FDEB
    CLC ; Prep add.
    LDA SCRIPT_PARTY_ATTRIBUTES[32],X ; Load attr.
    ADC LIB_BCD/EXTRA_FILE_BCD_A ; Add with.
    STA ALT_STUFF_COUNT? ; Store to.
    LDA SCRIPT_PARTY_ATTRIBUTES+1,X ; Load attr.
    ADC LIB_BCD/EXTRA_FILE_BCD_B ; Add with.
    STA ALT_COUNT_UNK ; Store to.
    BCC ADD_NO_OVERFLOW ; No overflow, goto.
    LDA #$FF
    STA ALT_STUFF_COUNT? ; Seed max ??
    STA ALT_COUNT_UNK
ADD_NO_OVERFLOW: ; 17:1E02, 0x02FE02
    SEC ; Prep sub.
    LDA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2] ; Load ??
    SBC ALT_STUFF_COUNT? ; Sub with.
    LDA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER+1 ; Load alt.
    SBC ALT_COUNT_UNK ; Sub with.
    BCS SUB_NO_UNDERFLOW ; No underflow, goto.
    LDA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2] ; Move val instead.
    STA ALT_STUFF_COUNT?
    LDA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER+1
    STA ALT_COUNT_UNK
SUB_NO_UNDERFLOW: ; 17:1E15, 0x02FE15
    SEC ; Prep sub.
    LDA ALT_STUFF_COUNT? ; Load ??
    SBC SCRIPT_PARTY_ATTRIBUTES[32],X ; Sub with.
    STA BATTLE_ARRAY_UNK[5] ; Store to.
    LDA ALT_COUNT_UNK ; Load ??
    SBC SCRIPT_PARTY_ATTRIBUTES+1,X ; Sub with.
    STA BATTLE_ARRAY_UNK+1 ; Store to.
    BCC EXIT_MIN_0x0000 ; Underflow, goto.
    ORA BATTLE_ARRAY_UNK[5] ; Combine with.
    BEQ EXIT_MIN_0x0000 ; == 0, goto. Min 0x00.
    LDA ALT_STUFF_COUNT? ; Move otherwise to party.
    STA SCRIPT_PARTY_ATTRIBUTES[32],X
    LDA ALT_COUNT_UNK
    STA SCRIPT_PARTY_ATTRIBUTES+1,X
    RTS ; Leave.
EXIT_MIN_0x0000: ; 17:1E38, 0x02FE38
    JMP CLEAR_BATTLE_VALS_RET_CC ; Goto exit.
SUB_TODO: ; 17:1E3B, 0x02FE3B
    JSR X_PTR_Y_STREAM_SEEDED_MOVE_UNK ; Seed X ptr Y stream index.
    CLC ; Prep add.
    LDA SCRIPT_PARTY_ATTRIBUTES[32],X ; Load ??
    ADC LIB_BCD/EXTRA_FILE_BCD_A ; Add with.
    STA ALT_STUFF_COUNT? ; Store to.
    BCC ADD_NO_OVERFLOW ; No overflow, goto.
    LDA #$FF
    STA ALT_STUFF_COUNT? ; Store max.
ADD_NO_OVERFLOW: ; 17:1E4C, 0x02FE4C
    SEC ; Prep sub.
    LDA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2] ; Load ??
    SBC ALT_STUFF_COUNT? ; Sub with.
    BCS SUB_NO_UNDERFLOW ; No underflow, goto.
    LDA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2] ; Move ??
    STA ALT_STUFF_COUNT?
SUB_NO_UNDERFLOW: ; 17:1E57, 0x02FE57
    LDA #$00
    STA BATTLE_ARRAY_UNK+1 ; Min 0x00.
    SEC ; Prep sub.
    LDA ALT_STUFF_COUNT? ; Load ??
    SBC SCRIPT_PARTY_ATTRIBUTES[32],X ; Sub with obj.
    STA BATTLE_ARRAY_UNK[5] ; Store to.
    BCC EXIT_CLEAR ; Underflow, goto.
    BEQ EXIT_CLEAR ; == 0, goto.
    LDA ALT_STUFF_COUNT? ; Move to attr alive.
    STA SCRIPT_PARTY_ATTRIBUTES[32],X
    RTS ; Leave.
EXIT_CLEAR: ; 17:1E6F, 0x02FE6F
    JMP CLEAR_BATTLE_VALS_RET_CC ; Goto.
X_PTR_Y_STREAM_SEEDED_RTN_UNK_TODO_FIGURE_UNK: ; 17:1E72, 0x02FE72
    JSR X_PTR_Y_STREAM_SEEDED_MOVE_UNK ; Do ptr/stream.
    SEC ; Prep sub.
    LDA SCRIPT_PARTY_ATTRIBUTES[32],X ; Load attr.
    SBC LIB_BCD/EXTRA_FILE_BCD_A ; Sub with.
    STA ALT_STUFF_COUNT? ; Store to.
    LDA SCRIPT_PARTY_ATTRIBUTES+1,X ; Load ??
    SBC LIB_BCD/EXTRA_FILE_BCD_B ; Sub with.
    STA ALT_COUNT_UNK ; Store to.
    BCS NO_UNDERFLOW ; CS, goto.
    LDA #$00
    STA ALT_STUFF_COUNT? ; Clear, min 0x0000.
    STA ALT_COUNT_UNK
NO_UNDERFLOW: ; 17:1E8C, 0x02FE8C
    CPY #$03 ; If _ #$03
    BEQ VAL_EQ_0x3 ; == 0x3, goto.
    CPY #$05 ; If _ #$05
    BEQ VAL_EQ_0x3 ; == 0, goto.
    LDA ALT_STUFF_COUNT? ; Load ??
    ORA ALT_COUNT_UNK ; Combine with.
    BNE VAL_EQ_0x3 ; != 0, goto.
    LDA #$01
    STA ALT_STUFF_COUNT? ; Seed min?
VAL_EQ_0x3: ; 17:1E9E, 0x02FE9E
    SEC ; Prep sub.
    LDA SCRIPT_PARTY_ATTRIBUTES[32],X ; Load attr ??
    SBC ALT_STUFF_COUNT? ; Sub with.
    STA BATTLE_ARRAY_UNK[5] ; Store to.
    LDA SCRIPT_PARTY_ATTRIBUTES+1,X ; Load ??
    SBC ALT_COUNT_UNK ; Carry sub.
    STA BATTLE_ARRAY_UNK+1 ; Store to.
    BCC EXIT_MIN_ARRAY_WITH_0x0000 ; Underflow, goto.
    ORA BATTLE_ARRAY_UNK[5] ; Combine with.
    BEQ EXIT_MIN_ARRAY_WITH_0x0000 ; == 0, min.
    LDA ALT_STUFF_COUNT? ; Move val to attr.
    STA SCRIPT_PARTY_ATTRIBUTES[32],X
    LDA ALT_COUNT_UNK
    STA SCRIPT_PARTY_ATTRIBUTES+1,X
    RTS ; Leave.
EXIT_MIN_ARRAY_WITH_0x0000: ; 17:1EC1, 0x02FEC1
    JMP CLEAR_BATTLE_VALS_RET_CC ; Goto.
X_PTR_Y_STREAM_ROUTINE: ; 17:1EC4, 0x02FEC4
    JSR X_PTR_Y_STREAM_SEEDED_MOVE_UNK ; Do.
    SEC ; Prep sub.
    LDA SCRIPT_PARTY_ATTRIBUTES[32],X ; Load attr.
    SBC LIB_BCD/EXTRA_FILE_BCD_A ; Sub with.
    STA ALT_STUFF_COUNT? ; Store result.
    BEQ RESULT_0x00 ; == 0, goto.
    BCS NO_UNDERFLOW ; No underflow, goto.
RESULT_0x00: ; 17:1ED3, 0x02FED3
    LDA #$01
    STA ALT_STUFF_COUNT? ; Set min??
NO_UNDERFLOW: ; 17:1ED7, 0x02FED7
    LDA #$00
    STA BATTLE_ARRAY_UNK+1 ; Clear ??
    SEC ; Prep sub.
    LDA SCRIPT_PARTY_ATTRIBUTES[32],X ; Load attr.
    SBC ALT_STUFF_COUNT? ; Sub with.
    STA BATTLE_ARRAY_UNK[5] ; Store to.
    BEQ EXIT_MIN_0x0000 ; == 0, goto.
    BCC EXIT_MIN_0x0000 ; Underflow, goto.
    LDA ALT_STUFF_COUNT? ; Move to attr.
    STA SCRIPT_PARTY_ATTRIBUTES[32],X
    RTS ; Leave.
EXIT_MIN_0x0000: ; 17:1EEF, 0x02FEEF
    JMP CLEAR_BATTLE_VALS_RET_CC ; Goto.
DEEPER_SUB_UNK: ; 17:1EF2, 0x02FEF2
    JSR X_PTR_Y_STREAM_SEEDED_MOVE_UNK ; Do sub.
    LDA LIB_BCD2/EXTRA_FILE_STREAM_INDEX ; Move TODO: Restore?
    STA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2]
    LDA LIB_BCD/EXTRA_FILE_D
    STA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER+1
    JMP SYNC_UNK ; Goto.
SUB_SEEDED_UNK_MOVE_FILE_AND_SWITCH_LARGE_TODO: ; 17:1F00, 0x02FF00
    TXA ; Save X.
    PHA
    JSR X_PTR_Y_STREAM_SEEDED_MOVE_UNK ; Do.
    PLA ; Restore X.
    TAX
    LDA LIB_BCD2/EXTRA_FILE_STREAM_INDEX ; Move ?? todo restore?
    STA LIB_BCD/EXTRA_FILE_BCD_A
    LDA LIB_BCD/EXTRA_FILE_D
    STA LIB_BCD/EXTRA_FILE_BCD_B
    JSR SCRIPT_HARD_SWITCH_HUGE_FILES_TODO ; Do switch.
    JMP SYNC_X_PTR_Y_STREAM_HELPER_UNK ; Goto.
SCRIPTY_PTR/STREAM_THINGY_SUB_HUGE_TODO: ; 17:1F15, 0x02FF15
    TXA ; Save X.
    PHA
    JSR X_PTR_Y_STREAM_SEEDED_MOVE_UNK ; Do.
    PLA ; Restore X.
    TAX
    LDA LIB_BCD/EXTRA_FILE_D ; Load ??
    LSR A ; >> 1, /2.
    STA LIB_BCD/EXTRA_FILE_BCD_B ; Store to.
    LDA LIB_BCD2/EXTRA_FILE_STREAM_INDEX ; Load ??
    ROR A ; >> Rotate into.
    STA LIB_BCD/EXTRA_FILE_BCD_A ; Store to.
    JSR SCRIPT_HARD_SWITCH_HUGE_FILES_TODO ; Do switch.
    JMP X_PTR_Y_STREAM_SEEDED_RTN_UNK_TODO_FIGURE_UNK ; Goto.
X_PTR_Y_STREAM_SEEDED_MOVE_UNK: ; 17:1F2C, 0x02FF2C
    LDA PARTY_ATTR_PTR[2],X ; Move ptr.
    STA ALT_STUFF_COUNT?
    LDA PARTY_ATTR_PTR+1,X
    STA ALT_COUNT_UNK
    LDA [ALT_STUFF_COUNT?],Y ; Load from file.
    STA LIB_BCD2/EXTRA_FILE_STREAM_INDEX ; Store to.
    ASL A ; << 1, *2.
    STA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2] ; Store to.
    INY ; Stream++
    LDA [ALT_STUFF_COUNT?],Y ; Load from stream.
    AND #$03 ; Keep lower.
    STA LIB_BCD/EXTRA_FILE_D ; Store to.
    ROL A ; Rotate ??
    STA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER+1 ; Store to.
    BCC VAL_CC ; CC, goto.
    LDA #$FF
    STA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2] ; Seed ??
    STA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER+1
VAL_CC: ; 17:1F4F, 0x02FF4F
    DEY ; Y--
    STX RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY[8] ; Store ??
    TYA ; Y to A.
    CLC ; Prep add.
    ADC RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY[8] ; Add var.
    TAX ; To X.
    RTS ; Leave.
SEED_ATTRS_A: ; 17:1F58, 0x02FF58
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load focus.
    LDA SCRIPT_PARTY_ATTRIBUTES+13,Y ; Load attr ??
    TAX ; To X index.
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load alt focus.
    LDA SCRIPT_PARTY_ATTRIBUTES+14,Y ; Load attr ??
    JMP ATTRS_SEEDED ; Seeded, goto.
SEED_ATTRS_B: ; 17:1F66, 0x02FF66
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Seed focus.
    LDA SCRIPT_PARTY_ATTRIBUTES+13,Y ; Load attr.
    TAX ; To X index.
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load alt focus.
    LDA SCRIPT_PARTY_ATTRIBUTES+15,Y ; Load attr.
    JMP ATTRS_SEEDED ; Seeded, do.
ATTR_HELPER_MASK/ROTATE_UNK: ; 17:1F74, 0x02FF74
    LDA SCRIPT_PARTY_ATTRIBUTES+2,Y ; Load attr ??
    AND SCRIPT_BATTLE_UNK ; Mask with.
    BEQ CLEAR_BATTLE_UNK ; == 0, goto.,
    LSR LIB_BCD/EXTRA_FILE_BCD_B ; Rotate ??
    ROR LIB_BCD/EXTRA_FILE_BCD_A
    LDA LIB_BCD/EXTRA_FILE_BCD_A
    ORA LIB_BCD/EXTRA_FILE_BCD_B
    BNE CLEAR_BATTLE_UNK ; != 0, goto.
    INC LIB_BCD/EXTRA_FILE_BCD_A ; ++
CLEAR_BATTLE_UNK: ; 17:1F87, 0x02FF87
    LDA #$00
    STA SCRIPT_BATTLE_UNK ; Clear ??
    RTS ; Leave.
ATTRS_SEEDED: ; 17:1F8C, 0x02FF8C
    LSR A ; >> 1, /2.
    STA LIB_BCD/EXTRA_FILE_BCD_A ; Store ??
    STX SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2] ; Save ??
    TXA ; X to A.
    SEC ; Prep sub.
    SBC LIB_BCD/EXTRA_FILE_BCD_A ; Sub with.
    BCS NO_UNDERFLOW ; CS, goto.
    LDA #$00 ; Seed clear.
NO_UNDERFLOW: ; 17:1F99, 0x02FF99
    STA LIB_BCD/EXTRA_FILE_BCD_B ; Store result.
    LDA #$00
    STA LIB_BCD/EXTRA_FILE_BCD_A ; Clear ??
    STA LIB_BCD2/EXTRA_FILE_STREAM_INDEX ; Clear ??
    JSR ENGINE_MATH_24BIT_DIVIDE? ; Do math.
    JSR RANDOMIZE_GROUP_A ; Randomize val.
    CMP LIB_BCD/EXTRA_FILE_BCD_A ; If _ var
    RTS ; Ret result of CMP.
PARTY_FOCUS_NO_ATTRS_SET_UNK: ; 17:1FAA, 0x02FFAA
    JSR SCRIPT_ENEMY_FOCUS_INDEX_PTR_TO_NEXT_SLOT/DATA ; Do ??
    LDY #$00 ; Seed index.
VAL_NE_0x8: ; 17:1FAF, 0x02FFAF
    TYA ; Y to stack.
    PHA
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y ; Load from file.
    BEQ DO_ITERATION ; == 0, goto.
    JSR SCRIPT_BATTLE_ID_TO_PTR_UNK ; Do ptr.
    JSR ENGINE_SCRIPT_HELP_MAPPER_R6_TO_0x00 ; Load from file.
    LDY #$05 ; Stream header.
    LDA [LIB_BCD2/EXTRA_FILE_STREAM_INDEX],Y ; Load from file.
    TAX ; To X index.
    LDY #$02 ; Stream index.
    LDA [LIB_BCD2/EXTRA_FILE_STREAM_INDEX],Y ; Load from file. ??
    JSR ENGINE_SET_MAPPER_R6_TO_0x16 ; R6 to 0x16.
    AND #$40 ; Test ??
    BNE EXIT_SUCCESS_RETURN_INDEX_VALUE ; Attr set, goto.
DO_ITERATION: ; 17:1FCB, 0x02FFCB
    PLA ; Restore Y.
    TAY
    INY ; Y++
    CPY #$08 ; If _ #$08
    BNE VAL_NE_0x8 ; !=, goto.
    SEC ; Prep sub.
    RTS ; Leave.
EXIT_SUCCESS_RETURN_INDEX_VALUE: ; 17:1FD4, 0x02FFD4
    PLA
    TAY ; Restore Y.
    CLC ; Ret CC, success.
    RTS
CLEAR_BATTLE_VALS_RET_CC: ; 17:1FD8, 0x02FFD8
    LDA #$00 ; Seed clear for min 0x0000.
    STA BATTLE_ARRAY_UNK[5] ; Clear for min.
    STA BATTLE_ARRAY_UNK+1
    CLC ; Ret CC.
    RTS
SUB_FIND_ALT_FRIENDLY/SHIFT_SET: ; 17:1FE2, 0x02FFE2
    LDA SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load ??
    BPL EXIT_RET_CC_GOOD? ; Positive, goto.
SCRIPT_HELP_VAR_SHIFT_TEST: ; 17:1FE6, 0x02FFE6
    LDA 56_OBJECT_NAME_SIZE? ; Load ??
    LSR A ; >> 1, /2.
    BNE EXIT_RET_CS_BAD? ; != 0, goto.
EXIT_RET_CC_GOOD?: ; 17:1FEB, 0x02FFEB
    CLC ; Ret CC, found/good.
    RTS
EXIT_RET_CS_BAD?: ; 17:1FED, 0x02FFED
    SEC ; Ret CS, fail.
    RTS
SCRIPT_HELP_CHECK_ATTR_FRIEND_ATTR_0x6-UNK: ; 17:1FEF, 0x02FFEF
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS_ALT/ATTR_COMMITING ; Load focus?
    BMI RET_CC ; Negative, foe, goto.
    LDA SCRIPT_PARTY_ATTRIBUTES+17,Y ; Load attr ??
    CMP #$06 ; If _ #$06
    BNE RET_CC ; !=, goto, ret CC, fail.
    SEC ; Ret CS. == 0X6, pass/true.
    RTS
RET_CC: ; 17:1FFC, 0x02FFFC
    CLC ; Ret CC. Fail/false.
    RTS
    .db FF ; 2 Bytes total unused. Wowza.
    .db FF
