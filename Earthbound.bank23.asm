SUB_CLEAR_MANY_UNK: ; 17:0000, 0x02E000
    LDA #$00
    STA CONTROL_ACCUMULATED?[2] ; Clear CTRL's.
    STA CONTROL_ACCUMULATED?+1
    STA SCRIPT?_UNK_0x52 ; Clear tons more.
    STA SCRIPT_UNK_0x59
    STA TRIO_FILE_OFFSET_UNK[3]
    STA TRIO_FILE_OFFSET_UNK+1
    STA TRIO_FILE_OFFSET_UNK+2
    STA R_**:$004C
    STA R_**:$004D
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
    LDA [FPTR_5C_BATTLE_PARTY_SCRIPT?[2]],Y ; Move from file.
    STA LIB_BCD/EXTRA_FILE_BCD_A
    INY ; Stream++
    LDA [FPTR_5C_BATTLE_PARTY_SCRIPT?[2]],Y
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
    LDA [FPTR_5C_BATTLE_PARTY_SCRIPT?[2]],Y ; Load from stream.
    AND #$E0 ; Keep 1110.0000
    LDX #$05 ; Shift count.
SHIFT_LOOP: ; 17:0072, 0x02E072
    LSR A ; >> 1, /2.
    DEX ; X--
    BNE SHIFT_LOOP ; != 0, loop shift.
    STA 56_OBJECT_NAME_SIZE? ; Store to. Not name size here.
    LDA [FPTR_5C_BATTLE_PARTY_SCRIPT?[2]],Y ; Load from file.
    AND #$1F ; Keep 0001.1111
    STA FLAG_SPRITE_OFF_SCREEN_UNK ; Store to.
    INY ; Stream++
    LDA [FPTR_5C_BATTLE_PARTY_SCRIPT?[2]],Y ; Load from file.
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
    JSR SUB_SAVE_REGS_AND_DO_UNK ; Do ??
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
    STA STREAM_REPLACE_COUNT? ; Clear TODO better.
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
    STA OBJ?_BYTE_0x0_STATUS?,X ; Clear many of obj.
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
SCRIPT_REENTER_UNK: ; 17:03F8, 0x02E3F8
    CMP #$00 ; If _ #$00
    BEQ RTS ; ==, leave.
    PHA ; Save nonzero.
    JSR SUB_FILES_UNK ; Do.
    JSR ENGINE_SCRIPT_HELP_MAPPER_R6_TO_0x00 ; Do.
    PLA ; Pull value.
    CMP #$FF ; If _ #$FF
    BNE VAL_NE_0xFF ; !=, goto.
    SEC ; Prep sub.
    LDY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL? ; Load ??
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
SUB_FILES_UNK: ; 17:04BB, 0x02E4BB
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
    LDX SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL? ; Load index ??
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
RET_CS: ; 17:050E, 0x02E50E
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
    JSR SUB_TODO ; Do sub.
    BCS RET_CS ; CS, goto.
VAL_EQ_0x00: ; 17:0535, 0x02E535
    CLC
    LDA SCRIPT_BATTLE_PARTY_ID_FOCUS
    ADC #$20
    STA SCRIPT_BATTLE_PARTY_ID_FOCUS
    BNE RET_CS
    RTS
SUB_TODO: ; 17:053F, 0x02E53F
    LDA SCRIPT_UNK_0x59 ; Load ??
    BNE VAL_NONZERO ; != 0, goto.
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load index ??
    BMI VAL_NONZERO ; Negative, goto.
    LDA SCRIPT_PARTY_ATTRIBUTES+17,Y ; Load ??
    AND #$06 ; Keep ?? 0000.0101
    EOR #$06 ; Invert them.
    BEQ VAL_NONZERO ; == 0, goto.
    JSR ENTRENCE_EXTRA_SUB ; Do sub extra.
    BCS RTS ; CS, leave.
    LDA SCRIPT_UNK_0x59 ; Load ??
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
    JMP EXIT_A ; Goto.
VAL_NEGATIVE: ; 17:057A, 0x02E57A
    JMP EXIT_B ; Goto.
EXIT_A: ; 17:057D, 0x02E57D
    LDY #$00
INDEX_POSITIVE: ; 17:057F, 0x02E57F
    STY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL? ; Store index.
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
    BMI PORTION_UNK ; Always taken, goto.
EXIT_JMP: ; 17:059D, 0x02E59D
    JMP PORTION_UNK ; Goto.
PORTION_UNK: ; 17:05A0, 0x02E5A0
    LDY #$00 ; Index reset.
LOOP_POSITIVE: ; 17:05A2, 0x02E5A2
    STY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL? ; Store index.
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
    STY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL? ; Store ??
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
    STY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL? ; Store index.
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
    LDA SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL? ; Load data to?
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load focus?
    STA SCRIPT_PARTY_ATTRIBUTES+28,Y ; Store to obj.
    RTS ; Leave.
EXIT_SYNC_UNK: ; 17:0659, 0x02E659
    LDY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL? ; Load ??
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
    BCC EXIT_SCRIPT_OBJECT_UPDATE_DATA
ATTR_0x10_SET: ; 17:0677, 0x02E677
    LDA #$13
    JSR SCRIPT_SET_ATTRIBUTE_HELPER_RET_CC_PASS_CS_FAIL
    BCC EXIT_SCRIPT_OBJECT_UPDATE_DATA
ATTR_0x40_SET: ; 17:067E, 0x02E67E
    LDA #$12
    JSR SCRIPT_SET_ATTRIBUTE_HELPER_RET_CC_PASS_CS_FAIL
    BCC EXIT_SCRIPT_OBJECT_UPDATE_DATA
EXIT_FAILED_PARTNER_FIND: ; 17:0685, 0x02E685
    JMP ENTRY_FAILED_PARTNER_FIND ; Goto.
EXIT_SCRIPT_OBJECT_UPDATE_DATA: ; 17:0688, 0x02E688
    LDA SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL? ; Load data writing.
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
    ORA #$80 ; Set enemy?
    TAY ; A to Y.
    LDA SCRIPT_PARTY_ATTRIBUTES[32],Y ; Load status for.
    BEQ EXIT_RANDOMIZE_ENEMY_FOCUS_AUTO_HELPER ; == 0, loop until we find one. TODO: sanic fast logeek
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y ; Load attr ??
    BMI EXIT_RANDOMIZE_ENEMY_FOCUS_AUTO_HELPER ; Negative, loop. Fainted?
    TYA ; Y to A.
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load 
    STA SCRIPT_PARTY_ATTRIBUTES+28,Y ; Store value into, focus for this one.
    RTS ; Leave.
PORTION_UNK: ; 17:06B0, 0x02E6B0
    LDA #$14 ; Load ??
    JSR SCRIPT_SET_ATTRIBUTE_HELPER_RET_CC_PASS_CS_FAIL ; Set attr.
    BCC EXIT_SET_ATTR
    JMP PORTION_UNK
EXIT_SET_ATTR: ; 17:06BA, 0x02E6BA
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load focus.
    LDA SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL? ; Load commit val.
    STA SCRIPT_PARTY_ATTRIBUTES+28,Y ; Commit it.
    RTS ; Leave.
SCRIPT_SET_ATTRIBUTE_HELPER_RET_CC_PASS_CS_FAIL: ; 17:06C2, 0x02E6C2
    STA LIB_BCD/EXTRA_FILE_BCD_A ; Store passed.
    JSR SCRIPT_BATTLE_FOCUS_PTR_MOVE_AND_OFFSET ; Do.
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
    LDA [FPTR_5C_BATTLE_PARTY_SCRIPT?[2]],Y ; Load file.
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
EXIT_B: ; 17:0723, 0x02E723
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
    LOW(SCRIPT_B)
    HIGH(SCRIPT_B)
    LOW(SCRIPT_C)
    HIGH(SCRIPT_C)
SCRIPT_B: ; 17:0740, 0x02E740
    JSR SCRIPT_RANDOMIZE_BATTLE_CHARACTER_FRIEND_OR_FOE ; Randomize.
    LDA SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL? ; Load val.
    BPL SCRIPT_B ; Positive, goto.
    JMP SCRIPT_A_STORE_ATTR_UNK ; Goto.
SCRIPT_C: ; 17:074A, 0x02E74A
    LDA SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load focus.
    BPL FOCUS_POSITIVE ; Positive, goto.
    LDA 56_OBJECT_NAME_SIZE?
    CMP #$03
    BNE L_17:0760
    LDX #$03
L_17:0756: ; 17:0756, 0x02E756
    LDA #$06
    JSR L_17:07BE
    BCS L_17:07A0
    DEX
    BPL L_17:0756
L_17:0760: ; 17:0760, 0x02E760
    LDA 56_OBJECT_NAME_SIZE?
    CMP #$04
    BNE L_17:078A
    LDX #$03
L_17:0768: ; 17:0768, 0x02E768
    LDA #$01
    JSR L_17:07BE
    BCS L_17:07A0
    DEX
    BPL L_17:0768
    LDX #$03
L_17:0774: ; 17:0774, 0x02E774
    LDA #$02
    JSR L_17:07BE
    BCS L_17:07A0
    DEX
    BPL L_17:0774
    LDX #$03
L_17:0780: ; 17:0780, 0x02E780
    LDA #$04
    JSR L_17:07BE
    BCS L_17:07A0
    DEX
    BPL L_17:0780
L_17:078A: ; 17:078A, 0x02E78A
    LDX #$03
L_17:078C: ; 17:078C, 0x02E78C
    LDA #$07
    JSR L_17:07BE
    BCS L_17:07A0
    DEX
    BPL L_17:078C
FOCUS_POSITIVE: ; 17:0796, 0x02E796
    JSR SCRIPT_RANDOMIZE_BATTLE_CHARACTER_FRIEND_OR_FOE ; Randomize.
    LDA SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL? ; Load focus made.
    BMI FOCUS_POSITIVE ; Negative, goto.
    JMP SCRIPT_A_STORE_ATTR_UNK
L_17:07A0: ; 17:07A0, 0x02E7A0
    JMP SCRIPT_A_STORE_ATTR_UNK
SCRIPT_A_STORE_ATTR_UNK: ; 17:07A3, 0x02E7A3
    LDA SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL? ; Load attr val.
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
    STY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL? ; Store focus.
    RTS ; Leave.
L_17:07BE: ; 17:07BE, 0x02E7BE
    CMP WRAM_ARR_PARTY_CHARACTER_IDS?[6],X ; If _ arr
    BNE RET_CC_FAILURE_NOT_FOUND ; !=, goto.
    TXA ; X to A.
    ASL A ; << 5, *32.
    ASL A
    ASL A
    ASL A
    ASL A
    TAY ; To Y index.
    LDA SCRIPT_PARTY_ATTRIBUTES[32],Y ; Load attr status.
    BEQ RET_CC_FAILURE_NOT_FOUND ; == 0, goto.
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y ; Load pair.
    BMI RET_CC_FAILURE_NOT_FOUND ; Negative, goto.
    STY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL? ; Store index focus.
    SEC ; Ret CS, success.
    RTS
RET_CC_FAILURE_NOT_FOUND: ; 17:07D8, 0x02E7D8
    CLC ; Ret CC.
    RTS
ENTRENCE_EXTRA_SUB: ; 17:07DA, 0x02E7DA
    JSR BATTLE_SEED_UNKNOWN_UPDATE_PACKET_DISPLAY ; Do sub, display ??
L_17:07DD: ; 17:07DD, 0x02E7DD
    LDA #$02 ; Seed ??
    LDX CURRENT_SAVE_MANIPULATION_PAGE+540 ; Load ??
    BPL SEED_CURRENT ; Positive, goto.
    LDA #$13 ; Seed alt ??
SEED_CURRENT: ; 17:07E6, 0x02E7E6
    JSR LIB_BANK_0_FILES_COORDS_BATTLE_MENU?_UNK ; Do ??
    JSR BATTLE_SCRIPT_IDK_HIT_ENEMY? ; Do sub.
    JSR SWITCH_TABLE_PAST_JSR_HELPER ; Switch on below.
    LOW(RTN_A)
    HIGH(RTN_A)
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
    LOW(RTN_G)
    HIGH(RTN_G)
    LOW(RTN_H)
    HIGH(RTN_H)
    LOW(RTN_I)
    HIGH(RTN_I)
L_17:0801: ; 17:0801, 0x02E801
    .db 60 ; Leave? Extra probs.
RTN_A: ; 17:0802, 0x02E802
    LDA #$01
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS
    STA SCRIPT_PARTY_ATTRIBUTES+29,Y
    JSR L_17:0962
    BCC L_17:0811
    JMP L_17:07DD
L_17:0811: ; 17:0811, 0x02E811
    JMP L_17:0801
RTN_B: ; 17:0814, 0x02E814
    JSR ENGINE_SETTLE_ALL_UPDATES?
    LDA #$01
    STA SCRIPT_UNK_0x59
    LDA #$14
    STA R_**:$03E6
    LDA #$97
    STA R_**:$03E7
    LDA #$04
    STA R_**:$03E0
    LDA #$00
    STA SPRITE_SLOT_Y_OFF_SCREEN_UNK
    STA R_**:$03E4
    STA R_**:$03E5
    LDA #$D0
    STA R_**:$03E2
    LDA #$47
    STA R_**:$03E3
    LDA #$01
    STA NMI_FLAG_EXECUTE_UPDATE_BUF_AND_MORE_TODO
    CLC
    JMP L_17:0801
RTN_C: ; 17:0847, 0x02E847
    JSR SCRIPT_BATTLE_FOCUS_PTR_MOVE_AND_OFFSET
    LDA #$00
    STA LIB_BCD/EXTRA_FILE_BCD_A
    LDY #$07
L_17:0850: ; 17:0850, 0x02E850
    LDA [FPTR_5C_BATTLE_PARTY_SCRIPT?[2]],Y
    ORA LIB_BCD/EXTRA_FILE_BCD_A
    STA LIB_BCD/EXTRA_FILE_BCD_A
    DEY
    BNE L_17:0850
    LDA LIB_BCD/EXTRA_FILE_BCD_A
    BEQ L_17:0868
    JSR L_17:0B10
    BCS L_17:0865
    JMP L_17:0801
L_17:0865: ; 17:0865, 0x02E865
    JMP ENTRENCE_EXTRA_SUB
L_17:0868: ; 17:0868, 0x02E868
    JMP L_17:07DD
SCRIPT_BATTLE_FOCUS_PTR_MOVE_AND_OFFSET: ; 17:086B, 0x02E86B
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load party focus.
    CLC ; Prep add.
    LDA PARTY_ATTR_PTR[2],Y ; Load from ptr.
    ADC #$30 ; Offset.
    STA FPTR_5C_BATTLE_PARTY_SCRIPT?[2]
    LDA PARTY_ATTR_PTR+1,Y ; Load from obj.
    ADC #$00 ; Carry add.
    STA FPTR_5C_BATTLE_PARTY_SCRIPT?+1 ; Store to.
    RTS ; Leave.
RTN_D: ; 17:087D, 0x02E87D
    LDA #$59
L_17:087F: ; 17:087F, 0x02E87F
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS
    STA SCRIPT_PARTY_ATTRIBUTES+29,Y
    CLC
    JMP L_17:0801
RTN_E: ; 17:0888, 0x02E888
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS
    CLC
    LDA PARTY_ATTR_PTR[2],Y
    ADC #$20
    STA FPTR_5C_BATTLE_PARTY_SCRIPT?[2]
    LDA PARTY_ATTR_PTR+1,Y
    ADC #$00
    STA FPTR_5C_BATTLE_PARTY_SCRIPT?+1
    LDA #$00
    STA LIB_BCD/EXTRA_FILE_BCD_A
    LDY #$07
L_17:089F: ; 17:089F, 0x02E89F
    LDA [FPTR_5C_BATTLE_PARTY_SCRIPT?[2]],Y
    ORA LIB_BCD/EXTRA_FILE_BCD_A
    STA LIB_BCD/EXTRA_FILE_BCD_A
    DEY
    BPL L_17:089F
    LDA LIB_BCD/EXTRA_FILE_BCD_A
    BEQ L_17:08B7
    JSR L_17:0A08
    BCS L_17:08B4
    JMP L_17:0801
L_17:08B4: ; 17:08B4, 0x02E8B4
    JMP ENTRENCE_EXTRA_SUB
L_17:08B7: ; 17:08B7, 0x02E8B7
    JMP L_17:07DD
RTN_F: ; 17:08BA, 0x02E8BA
    LDA #$48
    JMP L_17:087F
RTN_G: ; 17:08BF, 0x02E8BF
    LDA #$80
    STA SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    JSR BATTLE_SCRIPT_ENEMY/PLAYER_UNK
    BCS L_17:08DF
    LDX MENU_SELECTED_SUBMENU_OPTION_INDEX_FINAL
    LDA BATTLE_ARRAY_UNK+1,X
    TAX
    DEX
    TXA
    STA SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS
    STA SCRIPT_PARTY_ATTRIBUTES+28,Y
    LDA #$6F
    STA SCRIPT_PARTY_ATTRIBUTES+29,Y
    JMP L_17:0801
L_17:08DF: ; 17:08DF, 0x02E8DF
    JMP L_17:07DD
RTN_H: ; 17:08E2, 0x02E8E2
    LDA #$1C
    JMP L_17:087F
RTN_I: ; 17:08E7, 0x02E8E7
    SEC
    LDA SCRIPT_BATTLE_PARTY_ID_FOCUS
    BEQ L_17:0909
    SBC #$20
    STA SCRIPT_BATTLE_PARTY_ID_FOCUS
    TAY
    LDA SCRIPT_PARTY_ATTRIBUTES[32],Y
    BEQ RTN_I
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y
    BMI RTN_I
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y
    AND #$F4
    BNE RTN_I
    LDA SCRIPT_PARTY_ATTRIBUTES+30,Y
    AND #$20
    BNE RTN_I
L_17:0909: ; 17:0909, 0x02E909
    SEC
    JMP L_17:0801
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
    STX FPTR_MENU_SUBMENU[2] ; Store submenu.
    STY FPTR_MENU_SUBMENU+1
    LDX #$6B ; Seed master menu ??
    LDY #$9F
    STX FPTR_MENU_MASTER[2]
    STY FPTR_MENU_MASTER+1
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
L_17:0962: ; 17:0962, 0x02E962
    JSR SCRIPT_BATTLE_HELPER_MAKE_TIMES_FOR_EFFECT? ; Do ??
    BEQ EXIT_RET_CC ; == 0, goto.
    LDX #$80 ; Seed 0x80, enemies.
    CMP #$02 ; If _ #$02
    BEQ VAL_EQ_0x00
    LDX #$00 ; Seed 0x00, players.
VAL_EQ_0x00: ; 17:096F, 0x02E96F
    STX LIB_BCD/EXTRA_FILE_BCD_A ; Store focus.
    LDA SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load party ID focus.
    AND #$80 ; Keep enemy/friend.
    EOR LIB_BCD/EXTRA_FILE_BCD_A ; Invert with.
    STA SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL? ; Store final value.
    JSR BATTLE_SCRIPT_ENEMY/PLAYER_UNK ; Do sub.
    BCS EXIT_RET_CS ; Ret CS, leave.
    LDX MENU_SELECTED_SUBMENU_OPTION_INDEX_FINAL ; Load index.
    LDA BATTLE_ARRAY_UNK+1,X ; Load attr ??
    TAX ; A - 1 also to X.
    DEX ; --
    TXA ; X to A.
    STA SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL? ; Store value.
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load party focus.
    STA SCRIPT_PARTY_ATTRIBUTES+28,Y ; Store attr ??
EXIT_RET_CC: ; 17:098D, 0x02E98D
    CLC ; Ret CC, attr store success.
    RTS
EXIT_RET_CS: ; 17:098F, 0x02E98F
    SEC ; RTS CS, fail attr set.
    RTS
BATTLE_SCRIPT_ENEMY/PLAYER_UNK: ; 17:0991, 0x02E991
    LDA #$0B
    JSR LIB_BANK_0_FILES_COORDS_BATTLE_MENU?_UNK
    JSR L_17:09B3
    LDA #$8B
    STA FPTR_MENU_MASTER[2]
    LDA #$9F
    STA FPTR_MENU_MASTER+1
    JSR ENGINE_MENU_INIT_MASTER_FULL
    BIT SCRIPT_MENU_STATUS
    BVS L_17:09B1
    BMI L_17:09AD
    JMP BATTLE_SCRIPT_ENEMY/PLAYER_UNK
L_17:09AD: ; 17:09AD, 0x02E9AD
    LDA MENU_SELECTED_SUBMENU_OPTION_INDEX_FINAL
    CLC
    RTS
L_17:09B1: ; 17:09B1, 0x02E9B1
    SEC
    RTS
L_17:09B3: ; 17:09B3, 0x02E9B3
    LDA #$12
    STA GFX_COORD_VERTICAL_OFFSET
    LDX #$00
    STX BATTLE_ARRAY_UNK+1
    STX BATTLE_ARRAY_UNK+2
    STX BATTLE_ARRAY_UNK+3
    STX R_**:$0594
    INX
    STX BATTLE_ARRAY_UNK[4]
    LDA SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    PHA
    LDY #$04
L_17:09CE: ; 17:09CE, 0x02E9CE
    TYA
    PHA
    LDY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    LDA SCRIPT_PARTY_ATTRIBUTES[32],Y
    BEQ L_17:09F8
    LDY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    BMI L_17:09E4
    LDA SCRIPT_PARTY_ATTRIBUTES+17,Y
    AND #$06
    EOR #$06
    BEQ L_17:09F8
L_17:09E4: ; 17:09E4, 0x02E9E4
    INY
    TYA
    STA BATTLE_ARRAY_UNK[4],X
    INX
    TXA
    PHA
    JSR SUB_FILES_UNK
    LDA #$0C
    JSR LIB_BANK_0_FILES_COORDS_BATTLE_MENU?_UNK
    INC GFX_COORD_VERTICAL_OFFSET
    PLA
    TAX
L_17:09F8: ; 17:09F8, 0x02E9F8
    CLC
    LDA SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    ADC #$20
    STA SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    PLA
    TAY
    DEY
    BNE L_17:09CE
    PLA
    STA SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    RTS
L_17:0A08: ; 17:0A08, 0x02EA08
    LDA #$0E
    JSR LIB_BANK_0_FILES_COORDS_BATTLE_MENU?_UNK
    JSR L_17:0A67
    JSR L_17:0AE9
    BCS L_17:0A65
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS
    LDA MENU_SELECTED_SUBMENU_OPTION_INDEX_FINAL
    STA SCRIPT_PARTY_ATTRIBUTES+16,Y
    LDY MENU_SELECTED_SUBMENU_OPTION_INDEX_FINAL
    LDA [FPTR_5C_BATTLE_PARTY_SCRIPT?[2]],Y
    JSR SCRIPT_BATTLE_HELPER_PTR_CREATE_UNK_SIZE_0x8
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS
    JSR L_17:0C49
    BCS L_17:0A43
    JSR ENGINE_SCRIPT_HELP_MAPPER_R6_TO_0x00
    LDY #$05
    LDA [LIB_BCD2/EXTRA_FILE_STREAM_INDEX],Y
    JSR ENGINE_SET_MAPPER_R6_TO_0x16
    CMP #$00
    BEQ L_17:0A4C
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS
    STA SCRIPT_PARTY_ATTRIBUTES+29,Y
    JSR L_17:0962
    BCS L_17:0A65
    RTS
L_17:0A43: ; 17:0A43, 0x02EA43
    LDX SCRIPT_BATTLE_PARTY_ID_FOCUS
    JSR SUB_FILES_UNK
    LDX #$14
    BNE L_17:0A5E
L_17:0A4C: ; 17:0A4C, 0x02EA4C
    LDX #$10
    JSR ENGINE_SCRIPT_HELP_MAPPER_R6_TO_0x00
    LDY #$03
    LDA [LIB_BCD2/EXTRA_FILE_STREAM_INDEX],Y
    JSR ENGINE_SET_MAPPER_R6_TO_0x16
    CMP #$00
    BEQ L_17:0A5E
    LDX #$11
L_17:0A5E: ; 17:0A5E, 0x02EA5E
    TXA
    JSR LIB_BANK_0_FILES_COORDS_BATTLE_MENU?_UNK
    JSR SCRIPT_CTRL_WAIT_A/B_PRESSED
L_17:0A65: ; 17:0A65, 0x02EA65
    SEC
    RTS
L_17:0A67: ; 17:0A67, 0x02EA67
    LDY #$00
L_17:0A69: ; 17:0A69, 0x02EA69
    TYA
    PHA
    AND #$01
    TAX
    LDA $9FB2,X
    STA GFX_COORD_HORIZONTAL_OFFSET
    TYA
    LSR A
    TAX
    LDA $9FB4,X
    STA GFX_COORD_VERTICAL_OFFSET
    LDA [FPTR_5C_BATTLE_PARTY_SCRIPT?[2]],Y
    BEQ L_17:0A9C
    JSR SCRIPT_BATTLE_HELPER_PTR_CREATE_UNK_SIZE_0x8
    JSR ENGINE_SCRIPT_HELP_MAPPER_R6_TO_0x00
    LDA #$04
    STA R_**:$0588
    LDY #$00
    LDA [LIB_BCD2/EXTRA_FILE_STREAM_INDEX],Y
    STA R_**:$0589
    INY
    LDA [LIB_BCD2/EXTRA_FILE_STREAM_INDEX],Y
    STA R_**:$058A
    LDA #$0F
    JSR LIB_BANK_0_FILES_COORDS_BATTLE_MENU?_UNK
L_17:0A9C: ; 17:0A9C, 0x02EA9C
    PLA
    TAY
    INY
    CPY #$08
    BNE L_17:0A69
    RTS
SCRIPT_BATTLE_HELPER_PTR_CREATE_UNK_SIZE_0x8: ; 17:0AA4, 0x02EAA4
    LDX #$00 ; Seed clear.
    STX LIB_BCD/EXTRA_FILE_D ; Clear.
    LDX #$03 ; Count.
INDEX_NE_0x00: ; 17:0AAA, 0x02EAAA
    ASL A ; Shift.
    ROL LIB_BCD/EXTRA_FILE_D ; Rotate into.
    DEX ; Index--
    BNE INDEX_NE_0x00 ; !=, goto.
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
L_17:0ACC: ; 17:0ACC, 0x02EACC
    JSR ENGINE_SCRIPT_HELP_MAPPER_R6_TO_0x00
    LDA #$21
    STA BATTLE_ARRAY_UNK[4]
    LDY #$00
    LDA [LIB_BCD2/EXTRA_FILE_STREAM_INDEX],Y
    STA BATTLE_ARRAY_UNK+1
    INY
    LDA [LIB_BCD2/EXTRA_FILE_STREAM_INDEX],Y
    STA BATTLE_ARRAY_UNK+2
    LDA #$00
    STA BATTLE_ARRAY_UNK+3
    JMP ENGINE_SET_MAPPER_R6_TO_0x16
L_17:0AE9: ; 17:0AE9, 0x02EAE9
    LDA #$95
    STA FPTR_MENU_MASTER[2]
    LDA #$9F
    STA FPTR_MENU_MASTER+1
    LDA FPTR_5C_BATTLE_PARTY_SCRIPT?[2]
    STA FPTR_MENU_SUBMENU[2]
    LDA FPTR_5C_BATTLE_PARTY_SCRIPT?+1
    STA FPTR_MENU_SUBMENU+1
    JSR ENGINE_MENU_INIT_MASTER_PARTIAL
    BIT SCRIPT_MENU_STATUS
    BVS L_17:0B0E
    BMI L_17:0B05
    JMP L_17:0AE9
L_17:0B05: ; 17:0B05, 0x02EB05
    LDA #$0C
    JSR SCRIPT_BATTLE_MENU_TODO
    LDA MENU_SELECTED_SUBMENU_OPTION_INDEX_FINAL
    CLC
    RTS
L_17:0B0E: ; 17:0B0E, 0x02EB0E
    SEC
    RTS
L_17:0B10: ; 17:0B10, 0x02EB10
    LDY #$01
L_17:0B12: ; 17:0B12, 0x02EB12
    LDA [FPTR_5C_BATTLE_PARTY_SCRIPT?[2]],Y
    BEQ L_17:0B32
    TYA
    PHA
    LDA #$0E
    JSR LIB_BANK_0_FILES_COORDS_BATTLE_MENU?_UNK
    LDA #$12
    JSR LIB_BANK_0_FILES_COORDS_BATTLE_MENU?_UNK
    JSR L_17:0B61
    JSR L_17:0BC2
    PLA
    TAY
    CPX #$01
    BEQ L_17:0B39
    CPX #$02
    BEQ L_17:0B5F
L_17:0B32: ; 17:0B32, 0x02EB32
    INY
    CPY #$08
    BEQ L_17:0B10
    BNE L_17:0B12
L_17:0B39: ; 17:0B39, 0x02EB39
    LDY MENU_SELECTED_SUBMENU_OPTION_INDEX_FINAL
    LDA CHARACTER_NAMES_ARR[8],Y
    JSR LIB_PTR_CREATE_UNK
    JSR ENGINE_SCRIPT_HELP_MAPPER_R6_TO_0x00
    LDY #$05
    LDA [LIB_BCD2/EXTRA_FILE_STREAM_INDEX],Y
    BEQ L_17:0B57
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS
    STA SCRIPT_PARTY_ATTRIBUTES+29,Y
    PHA
    JSR ENGINE_SET_MAPPER_R6_TO_0x16
    PLA
    JMP L_17:0962
L_17:0B57: ; 17:0B57, 0x02EB57
    LDA #$10
    JSR LIB_BANK_0_FILES_COORDS_BATTLE_MENU?_UNK
    JSR SCRIPT_CTRL_WAIT_A/B_PRESSED
L_17:0B5F: ; 17:0B5F, 0x02EB5F
    SEC
    RTS
L_17:0B61: ; 17:0B61, 0x02EB61
    TYA
    ASL A
    ASL A
    ASL A
    STA LIB_BCD/EXTRA_FILE_BCD_A
    LDA #$80
    STA LIB_BCD/EXTRA_FILE_BCD_B
    LDX #$00
L_17:0B6D: ; 17:0B6D, 0x02EB6D
    LDA #$00
    STA CHARACTER_NAMES_ARR[8],X
    LDA [FPTR_5C_BATTLE_PARTY_SCRIPT?[2]],Y
    AND LIB_BCD/EXTRA_FILE_BCD_B
    BEQ L_17:0B7D
    LDA LIB_BCD/EXTRA_FILE_BCD_A
    STA CHARACTER_NAMES_ARR[8],X
L_17:0B7D: ; 17:0B7D, 0x02EB7D
    INC LIB_BCD/EXTRA_FILE_BCD_A
    INX
    LSR LIB_BCD/EXTRA_FILE_BCD_B
    BCC L_17:0B6D
    LDY #$00
L_17:0B86: ; 17:0B86, 0x02EB86
    TYA
    PHA
    AND #$01
    TAX
    LDA $9FB2,X
    STA GFX_COORD_HORIZONTAL_OFFSET
    TYA
    LSR A
    TAX
    LDA $9FB4,X
    STA GFX_COORD_VERTICAL_OFFSET
    LDA CHARACTER_NAMES_ARR[8],Y
    BEQ L_17:0BBA
    JSR LIB_PTR_CREATE_UNK
    JSR ENGINE_SCRIPT_HELP_MAPPER_R6_TO_0x00
    LDA #$04
    STA R_**:$0588
    LDY #$00
    LDA [LIB_BCD2/EXTRA_FILE_STREAM_INDEX],Y
    STA R_**:$0589
    INY
    LDA [LIB_BCD2/EXTRA_FILE_STREAM_INDEX],Y
    STA R_**:$058A
    LDA #$0F
    JSR LIB_BANK_0_FILES_COORDS_BATTLE_MENU?_UNK
L_17:0BBA: ; 17:0BBA, 0x02EBBA
    PLA
    TAY
    INY
    CPY #$08
    BNE L_17:0B86
    RTS
L_17:0BC2: ; 17:0BC2, 0x02EBC2
    LDA #$A7
    STA FPTR_MENU_MASTER[2]
    LDA #$9F
    STA FPTR_MENU_MASTER+1
    JSR ENGINE_MENU_INIT_MASTER_FULL
    LDA SCRIPT_MENU_STATUS
    AND #$06
    BNE L_17:0BE6
    LDA SCRIPT_MENU_STATUS
    AND #$81
    BNE L_17:0BE0
    BIT SCRIPT_MENU_STATUS
    BVS L_17:0BE3
    JMP L_17:0BC2
L_17:0BE0: ; 17:0BE0, 0x02EBE0
    LDX #$00
    RTS
L_17:0BE3: ; 17:0BE3, 0x02EBE3
    LDX #$02
    RTS
L_17:0BE6: ; 17:0BE6, 0x02EBE6
    LDA #$9D
    STA FPTR_MENU_MASTER[2]
    LDA #$9F
    STA FPTR_MENU_MASTER+1
    JSR ENGINE_MENU_INIT_MASTER_FULL
    LDA SCRIPT_MENU_STATUS
    AND #$08
    BNE L_17:0BC2
    BIT SCRIPT_MENU_STATUS
    BVS L_17:0C03
    BMI L_17:0C00
    JMP L_17:0BC2
L_17:0C00: ; 17:0C00, 0x02EC00
    LDX #$01
    RTS
L_17:0C03: ; 17:0C03, 0x02EC03
    LDX #$02
    RTS
BATTLE_SEED_UNKNOWN_UPDATE_PACKET_DISPLAY: ; 17:0C06, 0x02EC06
    LDA #$0A ; Seed ??
    JSR LIB_BANK_0_FILES_COORDS_BATTLE_MENU?_UNK ; Do library.
    JSR SUB_FILES_UNK ; Do sub.
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
    LDA $9EC7,Y ; TODO R16, R17, or R0?
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
L_17:0C49: ; 17:0C49, 0x02EC49
    JSR ENGINE_SCRIPT_HELP_MAPPER_R6_TO_0x00
    LDA SCRIPT_PARTY_ATTRIBUTES+17,Y
    STA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2]
    TAX
    SEC
    LDA #$00
L_17:0C55: ; 17:0C55, 0x02EC55
    ROL A
    DEX
    BNE L_17:0C55
    STA ALT_COUNT_UNK
    LDY #$02
    LDA [LIB_BCD2/EXTRA_FILE_STREAM_INDEX],Y
    JSR ENGINE_SET_MAPPER_R6_TO_0x16
    AND ALT_COUNT_UNK
    BEQ L_17:0C68
    CLC
    RTS
L_17:0C68: ; 17:0C68, 0x02EC68
    SEC
    RTS
SUB_TODO: ; 17:0C6A, 0x02EC6A
    JSR SUB_UNK ; Do ??
    BCS EXIT_CS ; Ret CS, goto.
    LDX #$08 ; Seed ??
L_17:0C71: ; 17:0C71, 0x02EC71
    TXA ; X to A.
    PHA ; Save it.
    JSR UNK_SUB_A ; Do.
    JSR UNK_SUB_B ; Do.
    LDA #$FF ; Seed ??
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load index.
    STA SCRIPT_PARTY_ATTRIBUTES+29,Y ; Set ??
    JSR SUB_UNK ; Do sub.
    BCS EXIT_STACK_FIX_CS
    PLA
    TAX
    DEX
    BNE L_17:0C71
    DEC SCRIPT_UNK_BATTLE?_OBJECT_ID_FOCUSED?
    BEQ L_17:0C93
    CLC
    RTS
EXIT_STACK_FIX_CS: ; 17:0C90, 0x02EC90
    PLA
EXIT_CS: ; 17:0C91, 0x02EC91
    SEC
    RTS
L_17:0C93: ; 17:0C93, 0x02EC93
    LDA 56_OBJECT_NAME_SIZE?
    CMP #$01
    BEQ EXIT_CS
    LDX #$64
    JSR ENGINE_WAIT_X_SETTLES
    LDA #$92
    JSR SCRIPT_REENTER_UNK
EXIT_CS: ; 17:0CA3, 0x02ECA3
    SEC
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
    STY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL? ; Store index.
    JSR SUB_SAVE_REGS_AND_DO_UNK ; Do ??
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
    JSR SCRIPT_REENTER_UNK
LOWER_CLEAR_ZZZ: ; 17:0D76, 0x02ED76
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS ; Load ??
    LDA SCRIPT_PARTY_ATTRIBUTES+29,Y ; Load ??
L_17:0D7B: ; 17:0D7B, 0x02ED7B
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
    STA FPTR_UNK_BANK_17_PTR[2] ; Store to.
    INY ; Stream++
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y ; Load from file.
    STA FPTR_UNK_BANK_17_PTR+1 ; Store to.
MAIN_SWITCH_UNK: ; 17:0D9C, 0x02ED9C
    LDY #$00 ; Stream reset.
    LDA [FPTR_UNK_BANK_17_PTR[2]],Y ; Load from file.
    LSR A ; Nibble down.
    LSR A
    LSR A
    LSR A
    JSR SWITCH_TABLE_PAST_JSR_HELPER ; Switch with.
    LOW(RTN_A_ADVANCE_SWITCH_FILE_0x1) ; Advance.
    HIGH(RTN_A_ADVANCE_SWITCH_FILE_0x1) ; 0x00
    LOW(RTN_B_FILE_SUBSWITCH_A) ; Subswitch.
    HIGH(RTN_B_FILE_SUBSWITCH_A) ; 0x01
    LOW(RTN_C)
    HIGH(RTN_C) ; 0x02
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
    LOW(RTN_J)
    HIGH(RTN_J) ; 0x09
    LOW(RTN_K)
    HIGH(RTN_K) ; 0x0A
    LOW(RTN_L)
    HIGH(RTN_L) ; 0x0B
    LOW(RTN_M)
    HIGH(RTN_M) ; 0x0C
JMP_SCRIPT_REENTER_UNK: ; 17:0DC1, 0x02EDC1
    JMP SCRIPT_REENTER_UNK ; Goto.
RTN_A_ADVANCE_SWITCH_FILE_0x1: ; 17:0DC4, 0x02EDC4
    LDA #$01
    JMP ADVANCE_FPTR_UNK_0x1_BY_A ; Advance exit.
RTN_B_FILE_SUBSWITCH_A: ; 17:0DC9, 0x02EDC9
    LDY #$00 ; Reset stream.
    LDA [FPTR_UNK_BANK_17_PTR[2]],Y ; Load from file.
    AND #$0F ; Keep lower.
    JSR SWITCH_TABLE_PAST_JSR_WITH_PTR[0]_AS_RET_CATCH ; Switch with lower.
    LOW(RTN_A_ALT)
    HIGH(RTN_A_ALT)
    LOW(RTN_B_ALT)
    HIGH(RTN_B_ALT)
    LOW(RTN_C_ALT)
    HIGH(RTN_C_ALT)
    LOW(RTN_D_ALT)
    HIGH(RTN_D_ALT)
    LOW(RTN_E_ALT)
    HIGH(RTN_E_ALT)
    LOW(RTN_F_ALT)
    HIGH(RTN_F_ALT)
    LOW(RTN_G_ALT)
    HIGH(RTN_G_ALT)
    LOW(RTN_H_ALT)
    HIGH(RTN_H_ALT)
    LOW(RTN_I_ALT)
    HIGH(RTN_I_ALT)
    LOW(RTN_J_ALT)
    HIGH(RTN_J_ALT)
    LOW(RTN_K_ALT)
    HIGH(RTN_K_ALT)
    LOW(RTN_L_ALT)
    HIGH(RTN_L_ALT)
    LOW(RTN_M_ALT)
    HIGH(RTN_M_ALT)
RTN_A_ALT: ; 17:0DEC, 0x02EDEC
    LDA #$01
    JMP HELPER_0x17_ADVANCE_A_AND_RESWITCH_MAIN ; Advance and reswitch.
RTN_C: ; 17:0DF1, 0x02EDF1
    LDY #$01 ; Stream header.
    LDA [FPTR_UNK_BANK_17_PTR[2]],Y ; Load from file.
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
    STA BATTLE_ARRAY_UNK[4] ; Seed ??
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
    JSR SCRIPT_REENTER_UNK ; Do script.
    JSR SCRIPT_ATTR_INVERT_TEST_UNK ; Do ??
    BCC SCRIPT_CC_A ; CC, goto.
    JSR SCRIPT_TEST_VALS_UNK ; Test TODO stats?
    BCC SCRIPT_CC_B ; CC, goto.
    JSR SCRIPT_LAUNCH_SUB_TODO ; Do ??
    LDA R_**:$0058 ; Load ??
    JSR LIB_DIRECT_ENTRY_TOSOLVE_BATTLE?_UNK ; Do lib.
    LDA #$00
    STA R_**:$0058 ; Clear ??
    LDA #$02 ; Advance AMT.
    JMP HELPER_0x17_ADVANCE_A_AND_RESWITCH_MAIN ; Goto.
SCRIPT_CC_A: ; 17:0E53, 0x02EE53
    LDA #$51 ; Script ??
    JMP SCRIPT_REENTER_UNK
SCRIPT_CC_B: ; 17:0E58, 0x02EE58
    LDA #$54 ; Script ??
    JMP SCRIPT_REENTER_UNK
RTN_D: ; 17:0E5D, 0x02EE5D
    LDY #$01 ; Stream index.
    LDA [FPTR_UNK_BANK_17_PTR[2]],Y
    JSR SCRIPT_BATTLE_HELPER_PTR_CREATE_UNK_SIZE_0x8
    JSR L_17:0ACC
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS
    BMI L_17:0E7B
    JSR ENGINE_WRAM_STATE_WRITEABLE
    LDY #$00
    LDA [FPTR_UNK_BANK_17_PTR[2]],Y
    AND #$0F
    CMP #$01
    BNE L_17:0E7B
    JSR L_17:14E5
L_17:0E7B: ; 17:0E7B, 0x02EE7B
    LDA #$63
    JSR SCRIPT_REENTER_UNK
    LDA R_**:$0058
    JSR LIB_DIRECT_ENTRY_TOSOLVE_BATTLE?_UNK
    LDA #$00
    STA R_**:$0058
    LDA #$02
    JMP HELPER_0x17_ADVANCE_A_AND_RESWITCH_MAIN
RTN_M: ; 17:0E8E, 0x02EE8E
    LDY #$01
    LDA [FPTR_UNK_BANK_17_PTR[2]],Y
    JSR SCRIPT_BATTLE_HELPER_PTR_CREATE_UNK_SIZE_0x8
    JSR L_17:0ACC
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS
    BMI L_17:0EE5
    LDY #$00
    LDA [FPTR_UNK_BANK_17_PTR[2]],Y
    AND #$0F
    JSR SWITCH_TABLE_PAST_JSR_HELPER
    LOW(RTN_A_ALT4)
    HIGH(RTN_A_ALT4)
    LOW(RTN_B_ALT4)
    HIGH(RTN_B_ALT4)
    LOW(RTN_C_ALT4?)
    HIGH(RTN_C_ALT4?)
RTN_A_ALT4: ; 17:0EAB, 0x02EEAB
    JSR RANDOMIZE_GROUP_A
    AND #$E0
    BNE L_17:0EE5
    JSR L_17:14E5
    LDA #$75
    JSR SCRIPT_REENTER_UNK
    JMP L_17:0EE5
RTN_B_ALT4: ; 17:0EBD, 0x02EEBD
    JSR RANDOMIZE_GROUP_A
    AND #$E0
    BNE L_17:0EE5
    JSR L_17:14E5
    LDA #$78
    JSR SCRIPT_REENTER_UNK
    JMP L_17:0EE5
RTN_C_ALT4?: ; 17:0ECF, 0x02EECF
    JSR ENGINE_WRAM_STATE_WRITEABLE
    DEC CURRENT_SAVE_MANIPULATION_PAGE+31
    JSR ENGINE_WRAM_STATE_WRITE_DISABLED
    LDA CURRENT_SAVE_MANIPULATION_PAGE+31
    BNE L_17:0EE5
    JSR L_17:14E5
    LDA #$91
    JSR SCRIPT_REENTER_UNK
L_17:0EE5: ; 17:0EE5, 0x02EEE5
    LDA #$02
    JMP HELPER_0x17_ADVANCE_A_AND_RESWITCH_MAIN
RTN_F_FILE_SUBSWITCH_C: ; 17:0EEA, 0x02EEEA
    LDY #$00
    LDA [FPTR_UNK_BANK_17_PTR[2]],Y
    AND #$0F
    JSR SWITCH_TABLE_PAST_JSR_WITH_PTR[0]_AS_RET_CATCH
    LOW(RTN_A_CATCH_ADVANCE_0x1)
    HIGH(RTN_A_CATCH_ADVANCE_0x1)
    LOW(RTN_B_ALT2) ; RTS, noop?
    HIGH(RTN_B_ALT2)
    LOW(RTN_C_ALT2)
    HIGH(RTN_C_ALT2)
    LOW(RTN_D_ALT2)
    HIGH(RTN_D_ALT2)
    LOW(RTN_E_ALT2)
    HIGH(RTN_E_ALT2)
    LOW(RTN_F_ALT2)
    HIGH(RTN_F_ALT2)
    LOW(RTN_G_ALT2)
    HIGH(RTN_G_ALT2)
    LOW(RTN_H_ALT2)
    HIGH(RTN_H_ALT2)
RTN_A_CATCH_ADVANCE_0x1: ; 17:0F03, 0x02EF03
    LDA #$01
    JMP HELPER_0x17_ADVANCE_A_AND_RESWITCH_MAIN
RTN_G_FILE_SUBSWITCH_AND_UNK: ; 17:0F08, 0x02EF08
    LDY #$01
    LDA [FPTR_UNK_BANK_17_PTR[2]],Y
    STA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2]
    DEY
    LDA [FPTR_UNK_BANK_17_PTR[2]],Y
    AND #$0F
    JSR SWITCH_TABLE_PAST_JSR_WITH_PTR[0]_AS_RET_CATCH
    LOW(RTN_A_ALT_3_CATCH_ADV_0x2)
    HIGH(RTN_A_ALT_3_CATCH_ADV_0x2)
    LOW(RTN_B_ALT3)
    HIGH(RTN_B_ALT3)
    LOW(RTN_C_ALT3)
    HIGH(RTN_C_ALT3)
    LOW(RTN_D_ALT3)
    HIGH(RTN_D_ALT3)
    LOW(RTN_E_ALT3)
    HIGH(RTN_E_ALT3)
    LOW(RTN_F_ALT3)
    HIGH(RTN_F_ALT3)
    LOW(RTN_G_ALT3)
    HIGH(RTN_G_ALT3)
    LOW(RTN_H_ALT3)
    HIGH(RTN_H_ALT3)
    LOW(RTN_I_ALT3)
    HIGH(RTN_I_ALT3)
    LOW(RTN_J_ALT3)
    HIGH(RTN_J_ALT3)
    LOW(RTN_K_ALT3)
    HIGH(RTN_K_ALT3)
RTN_A_ALT_3_CATCH_ADV_0x2: ; 17:0F2C, 0x02EF2C
    LDA #$02
    JMP HELPER_0x17_ADVANCE_A_AND_RESWITCH_MAIN
RTN_H: ; 17:0F31, 0x02EF31
    JSR L_17:0F53
    BCC L_17:0F3E
    JMP L_17:0F4E
RTN_I: ; 17:0F39, 0x02EF39
    JSR L_17:0F53
    BCC L_17:0F4E
L_17:0F3E: ; 17:0F3E, 0x02EF3E
    LDY #$01
    LDA [FPTR_UNK_BANK_17_PTR[2]],Y
    PHA
    INY
    LDA [FPTR_UNK_BANK_17_PTR[2]],Y
    STA FPTR_UNK_BANK_17_PTR+1
    PLA
    STA FPTR_UNK_BANK_17_PTR[2]
    JMP MAIN_SWITCH_UNK
L_17:0F4E: ; 17:0F4E, 0x02EF4E
    LDA #$03
    JMP HELPER_0x17_ADVANCE_A_AND_RESWITCH_MAIN
L_17:0F53: ; 17:0F53, 0x02EF53
    LDY #$00
    LDA [FPTR_UNK_BANK_17_PTR[2]],Y
    AND #$0F
    JSR SWITCH_TABLE_PAST_JSR_WITH_PTR[0]_AS_RET_CATCH
    LOW(RTN_A_ALT5_CATCH_NOOP)
    HIGH(RTN_A_ALT5_CATCH_NOOP)
    LOW(RTN_B_ALT5)
    HIGH(RTN_B_ALT5)
    LOW(RTN_C_ALT5)
    HIGH(RTN_C_ALT5)
    LOW(RTN_D_ALT5)
    HIGH(RTN_D_ALT5)
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
    LOW(RTN_J_ALT5)
    HIGH(RTN_J_ALT5)
    LOW(RTN_K_ALT5)
    HIGH(RTN_K_ALT5)
    LOW(RTN_L_ALT5)
    HIGH(RTN_L_ALT5)
    LOW(RTN_M_ALT5)
    HIGH(RTN_M_ALT5)
    LOW(RTN_O_ALT5)
    HIGH(RTN_O_ALT5)
    LOW(RTN_P_ALT5)
    HIGH(RTN_P_ALT5)
RTN_A_ALT5_CATCH_NOOP: ; 17:0F7A, 0x02EF7A
    .db 60
RTN_J: ; 17:0F7B, 0x02EF7B
    LDA FPTR_UNK_BANK_17_PTR+1
    PHA
    LDA FPTR_UNK_BANK_17_PTR[2]
    PHA
    JSR L_17:0FD3
    JSR MAIN_SWITCH_UNK
    PLA
    STA FPTR_UNK_BANK_17_PTR[2]
    PLA
    STA FPTR_UNK_BANK_17_PTR+1
    LDA #$03
    JMP HELPER_0x17_ADVANCE_A_AND_RESWITCH_MAIN
RTN_K: ; 17:0F92, 0x02EF92
    JSR L_17:0FD3
    JMP MAIN_SWITCH_UNK
RTN_L: ; 17:0F98, 0x02EF98
    LDY #$00
    LDA [FPTR_UNK_BANK_17_PTR[2]],Y
    AND #$0F
    TAX
    LDA #$01
    JSR ADVANCE_FPTR_UNK_0x1_BY_A
L_17:0FA4: ; 17:0FA4, 0x02EFA4
    TXA
    PHA
    LDA FPTR_UNK_BANK_17_PTR+1
    PHA
    LDA FPTR_UNK_BANK_17_PTR[2]
    PHA
    JSR MAIN_SWITCH_UNK
    LDA FPTR_UNK_BANK_17_PTR[2]
    STA LIB_BCD/EXTRA_FILE_BCD_A
    LDA FPTR_UNK_BANK_17_PTR+1
    STA LIB_BCD/EXTRA_FILE_BCD_B
    PLA
    STA FPTR_UNK_BANK_17_PTR[2]
    PLA
    STA FPTR_UNK_BANK_17_PTR+1
    PLA
    TAX
    DEX
    BNE L_17:0FA4
    LDA LIB_BCD/EXTRA_FILE_BCD_A
    STA FPTR_UNK_BANK_17_PTR[2]
    LDA LIB_BCD/EXTRA_FILE_BCD_B
    STA FPTR_UNK_BANK_17_PTR+1
    JMP MAIN_SWITCH_UNK
HELPER_0x17_ADVANCE_A_AND_RESWITCH_MAIN: ; 17:0FCD, 0x02EFCD
    JSR ADVANCE_FPTR_UNK_0x1_BY_A ; Advance passed.
    JMP MAIN_SWITCH_UNK ; Goto.
L_17:0FD3: ; 17:0FD3, 0x02EFD3
    LDY #$01
    LDA [FPTR_UNK_BANK_17_PTR[2]],Y
    PHA
    INY
    LDA [FPTR_UNK_BANK_17_PTR[2]],Y
    STA FPTR_UNK_BANK_17_PTR+1
    PLA
    STA FPTR_UNK_BANK_17_PTR[2]
    RTS
ADVANCE_FPTR_UNK_0x1_BY_A: ; 17:0FE1, 0x02EFE1
    CLC
    ADC FPTR_UNK_BANK_17_PTR[2]
    STA FPTR_UNK_BANK_17_PTR[2]
    LDA #$00
    ADC FPTR_UNK_BANK_17_PTR+1
    STA FPTR_UNK_BANK_17_PTR+1
    RTS
RTN_B_ALT: ; 17:0FED, 0x02EFED
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS
    JMP L_17:1513
RTN_C_ALT: ; 17:0FF2, 0x02EFF2
    LDY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    BPL L_17:0FF9
    JMP L_17:1555
L_17:0FF9: ; 17:0FF9, 0x02EFF9
    LDA #$01
    STA STREAM_REPLACE_COUNT?
    RTS
RTN_D_ALT: ; 17:0FFE, 0x02EFFE
    LDY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    BPL L_17:1005
    JMP L_17:15D3
L_17:1005: ; 17:1005, 0x02F005
    JMP L_17:16B2
RTN_E_ALT: ; 17:1008, 0x02F008
    LDY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    BPL L_17:100F
    JMP L_17:167C
L_17:100F: ; 17:100F, 0x02F00F
    JMP L_17:16F1
RTN_F_ALT: ; 17:1012, 0x02F012
    LDA #$2D
    JSR SCRIPT_REENTER_UNK
    JSR L_17:1069
    BCS L_17:1021
    LDA #$40
    JSR SCRIPT_REENTER_UNK
L_17:1021: ; 17:1021, 0x02F021
    RTS
RTN_G_ALT: ; 17:1022, 0x02F022
    LDA #$2E
    JSR SCRIPT_REENTER_UNK
    JSR L_17:1069
    BCS L_17:1031
    LDA #$41
    JSR SCRIPT_REENTER_UNK
L_17:1031: ; 17:1031, 0x02F031
    RTS
RTN_H_ALT: ; 17:1032, 0x02F032
    LDA #$02
    STA STREAM_REPLACE_COUNT?
    RTS
RTN_I_ALT: ; 17:1037, 0x02F037
    LDY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    BPL L_17:103E
    JMP L_17:15DA
L_17:103E: ; 17:103E, 0x02F03E
    JMP L_17:16BB
RTN_J_ALT: ; 17:1041, 0x02F041
    LDY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    BPL L_17:1048
    JMP L_17:15E1
L_17:1048: ; 17:1048, 0x02F048
    JMP L_17:16C4
RTN_K_ALT: ; 17:104B, 0x02F04B
    LDY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    BPL L_17:1052
    JMP L_17:15E8
L_17:1052: ; 17:1052, 0x02F052
    JMP L_17:16CD
RTN_L_ALT: ; 17:1055, 0x02F055
    LDY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    BPL L_17:105C
    JMP L_17:15EF
L_17:105C: ; 17:105C, 0x02F05C
    JMP L_17:16D6
RTN_M_ALT: ; 17:105F, 0x02F05F
    LDY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    BPL L_17:1066
    JMP L_17:15F6
L_17:1066: ; 17:1066, 0x02F066
    JMP L_17:16DF
L_17:1069: ; 17:1069, 0x02F069
    LDY #$80
L_17:106B: ; 17:106B, 0x02F06B
    CPY SCRIPT_BATTLE_PARTY_ID_FOCUS
    BEQ L_17:1076
    LDA SCRIPT_PARTY_ATTRIBUTES+30,Y
    AND #$01
    BNE L_17:107F
L_17:1076: ; 17:1076, 0x02F076
    TYA
    CLC
    ADC #$20
    TAY
    BNE L_17:106B
    CLC
    RTS
L_17:107F: ; 17:107F, 0x02F07F
    STY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    JSR L_17:1513
    LDY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    LDA SCRIPT_PARTY_ATTRIBUTES+30,Y
    AND #$FE
    STA SCRIPT_PARTY_ATTRIBUTES+30,Y
    LDA #$00
    STA SCRIPT_PARTY_ATTRIBUTES+29,Y
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS
    LDA SCRIPT_PARTY_ATTRIBUTES[32],Y
    LDY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    STA SCRIPT_PARTY_ATTRIBUTES[32],Y
    LDA #$42
    JSR SCRIPT_REENTER_UNK
    SEC
    RTS
SCRIPT_LAUNCH_SUB_TODO: ; 17:10A4, 0x02F0A4
    LDA #$19 ; Launch 19:07FC scripty. Display?
    LDX #$FB
    LDY #$A7
    JSR ENGINE_SCRIPT_LAUNCH_R7_A_PTR_XY_WITH_RESTORE ; Make R7, 0xA000.
    JMP SUB_SAVE_REGS_AND_DO_UNK ; Do ??
RTN_B_ALT5: ; 17:10B0, 0x02F0B0
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS
    LDA SCRIPT_PARTY_ATTRIBUTES[32],Y
    BEQ L_17:10CA
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y
    BMI L_17:10CA
RTN_H_ALT5: ; 17:10BC, 0x02F0BC
    LDY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    LDA SCRIPT_PARTY_ATTRIBUTES[32],Y
    BEQ L_17:10CA
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y
    BMI L_17:10CA
    CLC
    RTS
L_17:10CA: ; 17:10CA, 0x02F0CA
    SEC
    RTS
RTN_C_ALT5: ; 17:10CC, 0x02F0CC
    LDA FLAG_UNK_23
    BNE L_17:10F3
    LDY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y
    AND #$70
    BNE L_17:10F3
    LDA SCRIPT_PARTY_ATTRIBUTES+30,Y
    BMI L_17:10F3
    LDA SCRIPT_PARTY_ATTRIBUTES+11,Y
    STA LIB_BCD/EXTRA_FILE_BCD_A
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS
    LDA SCRIPT_PARTY_ATTRIBUTES+11,Y
    STA LIB_BCD2/EXTRA_FILE_STREAM_INDEX
    JSR L_17:11A2
    LDA LIB_BCD/EXTRA_FILE_BCD_A
    CMP LIB_BCD2/EXTRA_FILE_STREAM_INDEX
    BCS L_17:10F5
L_17:10F3: ; 17:10F3, 0x02F0F3
    CLC
    RTS
L_17:10F5: ; 17:10F5, 0x02F0F5
    SEC
    RTS
RTN_D_ALT5: ; 17:10F7, 0x02F0F7
    JSR L_17:1FE2
    BCS L_17:1111
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS
    LDA SCRIPT_PARTY_ATTRIBUTES+11,Y
    STA LIB_BCD/EXTRA_FILE_BCD_A
    LDY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    LDA SCRIPT_PARTY_ATTRIBUTES+11,Y
    STA LIB_BCD2/EXTRA_FILE_STREAM_INDEX
    JSR L_17:11A2
    LDA LIB_BCD2/EXTRA_FILE_STREAM_INDEX
    CMP LIB_BCD/EXTRA_FILE_BCD_A
L_17:1111: ; 17:1111, 0x02F111
    RTS
RTN_E_ALT6: ; 17:1112, 0x02F112
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS
    LDA SCRIPT_PARTY_ATTRIBUTES+30,Y
    AND #$80
    EOR #$80
    ROL A
    BCS L_17:1124
    JSR RANDOMIZE_GROUP_A
    AND #$80
    ROL A
L_17:1124: ; 17:1124, 0x02F124
    RTS
RTN_F_ALT5: ; 17:1125, 0x02F125
    LDA SCRIPT_BATTLE_PARTY_ID_FOCUS
    BMI L_17:112F
    LDA FLAG_UNK_23
    BEQ L_17:112F
    CLC
    RTS
L_17:112F: ; 17:112F, 0x02F12F
    SEC
    RTS
RTN_G_ALT5: ; 17:1131, 0x02F131
    LDY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    BMI L_17:114C
    LDA PARTY_ATTR_PTR[2],Y
    STA LIB_BCD/EXTRA_FILE_BCD_A
    LDA PARTY_ATTR_PTR+1,Y
    STA LIB_BCD/EXTRA_FILE_BCD_B
    LDY #$20
L_17:1141: ; 17:1141, 0x02F141
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y
    CMP #$68
    BEQ L_17:114E
    INY
    CPY #$28
    BNE L_17:1141
L_17:114C: ; 17:114C, 0x02F14C
    SEC
    RTS
L_17:114E: ; 17:114E, 0x02F14E
    CLC
    RTS
RTN_I_ALT5: ; 17:1150, 0x02F150
    LDY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    LDA SCRIPT_PARTY_ATTRIBUTES+2,Y
    AND #$80
    BNE L_17:1160
    LDA SCRIPT_PARTY_ATTRIBUTES+2,Y
    AND #$01
    BNE L_17:1162
L_17:1160: ; 17:1160, 0x02F160
    SEC
    RTS
L_17:1162: ; 17:1162, 0x02F162
    CLC
    RTS
RTN_J_ALT5: ; 17:1164, 0x02F164
    JSR RANDOMIZE_GROUP_A
    ASL A
    RTS
RTN_K_ALT5: ; 17:1169, 0x02F169
    LDY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    LDA SCRIPT_PARTY_ATTRIBUTES+2,Y
    AND #$80
    EOR #$80
    ROL A
    RTS
RTN_L_ALT5: ; 17:1174, 0x02F174
    LDY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    LDA SCRIPT_PARTY_ATTRIBUTES+2,Y
    AND #$04
    EOR #$04
    CMP #$01
    RTS
RTN_M_ALT5: ; 17:1180, 0x02F180
    LDA MAIN_FLAG_UNK
    BNE L_17:1186
    SEC
    RTS
L_17:1186: ; 17:1186, 0x02F186
    CLC
    RTS
RTN_O_ALT5: ; 17:1188, 0x02F188
    LDY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    LDA SCRIPT_PARTY_ATTRIBUTES+17,Y
    AND #$06
    EOR #$06
    CMP #$01
    RTS
RTN_P_ALT5: ; 17:1194, 0x02F194
    LDA 56_OBJECT_NAME_SIZE?
    CMP #$05
    BEQ L_17:11A0
    CMP #$06
    BEQ L_17:11A0
    SEC
    RTS
L_17:11A0: ; 17:11A0, 0x02F1A0
    CLC
    RTS
L_17:11A2: ; 17:11A2, 0x02F1A2
    LDA #$01
    STA LIB_BCD/EXTRA_FILE_BCD_B
    SEC
    LDA LIB_BCD/EXTRA_FILE_BCD_A
    SBC LIB_BCD2/EXTRA_FILE_STREAM_INDEX
    STA LIB_BCD/EXTRA_FILE_BCD_A
    LDA LIB_BCD/EXTRA_FILE_BCD_B
    SBC #$00
    LSR A
    ROR LIB_BCD/EXTRA_FILE_BCD_A
    SEC
    LDA LIB_BCD/EXTRA_FILE_BCD_A
    SBC #$66
    BCS L_17:11BD
    LDA #$00
L_17:11BD: ; 17:11BD, 0x02F1BD
    STA LIB_BCD/EXTRA_FILE_BCD_A
    JSR RANDOMIZE_GROUP_A
    STA LIB_BCD2/EXTRA_FILE_STREAM_INDEX
    RTS
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
RTN_B_ALT2: ; 17:11DF, 0x02F1DF
    RTS
RTN_C_ALT2: ; 17:11E0, 0x02F1E0
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y
    AND #$08
    BNE L_17:11EF
    LDA SCRIPT_PARTY_ATTRIBUTES+28,Y
    STA SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    RTS
L_17:11EF: ; 17:11EF, 0x02F1EF
    JSR RANDOMIZE_GROUP_A
    AND #$E0
    TAY
    LDA SCRIPT_PARTY_ATTRIBUTES[32],Y
    BEQ L_17:11EF
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y
    BMI L_17:11EF
    STY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    RTS
RTN_D_ALT2: ; 17:1202, 0x02F202
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y
    AND #$08
    BEQ L_17:1212
    JSR RANDOMIZE_GROUP_A
    AND #$80
    BNE L_17:122D
L_17:1212: ; 17:1212, 0x02F212
    LDX #$80
    LDA SCRIPT_BATTLE_PARTY_ID_FOCUS
    BPL L_17:121A
    LDX #$00
L_17:121A: ; 17:121A, 0x02F21A
    STX SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    RTS
RTN_E_ALT2: ; 17:121D, 0x02F21D
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y
    AND #$08
    BEQ L_17:122D
    JSR RANDOMIZE_GROUP_A
    AND #$80
    BNE L_17:1212
L_17:122D: ; 17:122D, 0x02F22D
    LDX #$00
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS
    BPL L_17:1235
    LDX #$80
L_17:1235: ; 17:1235, 0x02F235
    STX SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    RTS
RTN_F_ALT2: ; 17:1238, 0x02F238
    LDA SCRIPT_BATTLE_PARTY_ID_FOCUS
    STA SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    RTS
RTN_G_ALT2: ; 17:123D, 0x02F23D
    LDX #$00
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS
    BPL L_17:1245
    LDX #$80
L_17:1245: ; 17:1245, 0x02F245
    STX SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    RTS
RTN_H_ALT2: ; 17:1248, 0x02F248
    CLC
    LDA SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    ADC #$20
    STA SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    RTS
RTN_B_ALT3: ; 17:1250, 0x02F250
    LDY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    LDA SCRIPT_PARTY_ATTRIBUTES+9,Y
    STA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2]
    LDA SCRIPT_PARTY_ATTRIBUTES+10,Y
    STA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER+1
    SEC
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS
    LDA SCRIPT_PARTY_ATTRIBUTES+7,Y
    STA ALT_STUFF_COUNT?
    STA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY[8]
    SBC SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2]
    LDA SCRIPT_PARTY_ATTRIBUTES+8,Y
    STA ALT_COUNT_UNK
    STA RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY+1
    SBC SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER+1
    BCC L_17:12A8
    LSR SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER+1
    ROR SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2]
    SEC
    LDA ALT_STUFF_COUNT?
    SBC SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2]
    STA LIB_BCD/EXTRA_FILE_BCD_A
    LDA ALT_COUNT_UNK
    SBC SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER+1
    STA LIB_BCD/EXTRA_FILE_BCD_B
L_17:1284: ; 17:1284, 0x02F284
    LDA 56_OBJECT_NAME_SIZE?
    CMP #$01
    BNE L_17:1297
    JSR RANDOMIZE_GROUP_A
    AND #$07
    ORA #$04
    STA LIB_BCD/EXTRA_FILE_BCD_A
    LDA #$00
    STA LIB_BCD/EXTRA_FILE_BCD_B
L_17:1297: ; 17:1297, 0x02F297
    LDA LIB_BCD/EXTRA_FILE_BCD_A
    ORA LIB_BCD/EXTRA_FILE_BCD_B
    BNE L_17:129F
    INC LIB_BCD/EXTRA_FILE_BCD_A
L_17:129F: ; 17:129F, 0x02F29F
    LDA LIB_BCD/EXTRA_FILE_BCD_A
    STA SUB/MOD_VAL_UNK_WORD[2]
    LDA LIB_BCD/EXTRA_FILE_BCD_B
    STA SUB/MOD_VAL_UNK_WORD+1
    RTS
L_17:12A8: ; 17:12A8, 0x02F2A8
    ASL ALT_STUFF_COUNT?
    ROL ALT_COUNT_UNK
    CLC
    LDA ALT_STUFF_COUNT?
    ADC RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY[8]
    STA ALT_STUFF_COUNT?
    LDA ALT_COUNT_UNK
    ADC RENAME_THIS_ARR_SOMETHING_SANE_EVENTUALLY+1
    STA ALT_COUNT_UNK
    SEC
    LDA ALT_STUFF_COUNT?
    SBC SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2]
    STA LIB_BCD/EXTRA_FILE_BCD_A
    LDA ALT_COUNT_UNK
    SBC SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER+1
    STA LIB_BCD/EXTRA_FILE_BCD_B
    BCS L_17:12CE
    LDA #$00
    STA LIB_BCD/EXTRA_FILE_BCD_A
    STA LIB_BCD/EXTRA_FILE_BCD_B
L_17:12CE: ; 17:12CE, 0x02F2CE
    LSR LIB_BCD/EXTRA_FILE_BCD_B
    ROR LIB_BCD/EXTRA_FILE_BCD_A
    LSR LIB_BCD/EXTRA_FILE_BCD_B
    ROR LIB_BCD/EXTRA_FILE_BCD_A
    JMP L_17:1284
RTN_C_ALT3: ; 17:12D9, 0x02F2D9
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS
    LDA SCRIPT_PARTY_ATTRIBUTES+7,Y
    STA SUB/MOD_VAL_UNK_WORD[2]
    LDA SCRIPT_PARTY_ATTRIBUTES+8,Y
    STA SUB/MOD_VAL_UNK_WORD+1
    LDA 56_OBJECT_NAME_SIZE?
    CMP #$01
    BNE L_17:12F8
    JSR RANDOMIZE_GROUP_A
    AND #$0F
    ORA #$08
    STA SUB/MOD_VAL_UNK_WORD[2]
    LDA #$00
    STA SUB/MOD_VAL_UNK_WORD+1
L_17:12F8: ; 17:12F8, 0x02F2F8
    RTS
RTN_D_ALT3: ; 17:12F9, 0x02F2F9
    LDA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2]
    STA SUB/MOD_VAL_UNK_WORD[2]
    LDA #$00
    STA SUB/MOD_VAL_UNK_WORD+1
    RTS
RTN_E_ALT3: ; 17:1302, 0x02F302
    LDA 56_OBJECT_NAME_SIZE?
    CMP #$05
    BNE L_17:1318
    LDA 57_INDEX_UNK
    JSR SCRIPT_REENTER_UNK
    LDX 57_INDEX_UNK
    INX
    CPX #$9E
    BNE L_17:1316
    INC 56_OBJECT_NAME_SIZE?
L_17:1316: ; 17:1316, 0x02F316
    STX 57_INDEX_UNK
L_17:1318: ; 17:1318, 0x02F318
    RTS
RTN_F_ALT3: ; 17:1319, 0x02F319
    LDA R_**:$0057
    ORA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2]
    STA R_**:$0057
    RTS
RTN_G_ALT3: ; 17:1320, 0x02F320
    LDA #$6A
    JSR SCRIPT_REENTER_UNK
    LDA 56_OBJECT_NAME_SIZE?
    CMP #$02
    BNE L_17:1330
    LDA #$95
    JMP SCRIPT_REENTER_UNK
L_17:1330: ; 17:1330, 0x02F330
    CMP #$03
    BNE L_17:1339
    LDA #$94
    JMP SCRIPT_REENTER_UNK
L_17:1339: ; 17:1339, 0x02F339
    CMP #$04
    BNE L_17:1342
    LDA #$93
    JMP SCRIPT_REENTER_UNK
L_17:1342: ; 17:1342, 0x02F342
    CMP #$05
    BNE L_17:134B
    LDA #$01
    JMP SCRIPT_REENTER_UNK
L_17:134B: ; 17:134B, 0x02F34B
    CMP #$06
    BNE L_17:1354
    LDA #$01
    JMP SCRIPT_REENTER_UNK
L_17:1354: ; 17:1354, 0x02F354
    LDY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    BMI L_17:135D
    LDA #$90
    JMP SCRIPT_REENTER_UNK
L_17:135D: ; 17:135D, 0x02F35D
    LDY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    LDA SCRIPT_PARTY_ATTRIBUTES+7,Y
    STA BATTLE_ARRAY_UNK[4]
    LDA SCRIPT_PARTY_ATTRIBUTES+8,Y
    STA BATTLE_ARRAY_UNK+1
    LDA SCRIPT_PARTY_ATTRIBUTES+9,Y
    STA BATTLE_ARRAY_UNK+2
    LDA SCRIPT_PARTY_ATTRIBUTES+10,Y
    STA BATTLE_ARRAY_UNK+3
    LDA #$24
    JSR SCRIPT_REENTER_UNK
    LDA #$25
    JSR SCRIPT_REENTER_UNK
    LDY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    LDA SCRIPT_PARTY_ATTRIBUTES+2,Y
    PHA
    AND #$40
    BEQ L_17:1390
    LDA #$6B
    JSR SCRIPT_REENTER_UNK
L_17:1390: ; 17:1390, 0x02F390
    PLA
    PHA
    AND #$20
    BEQ L_17:139B
    LDA #$6C
    JSR SCRIPT_REENTER_UNK
L_17:139B: ; 17:139B, 0x02F39B
    PLA
    PHA
    AND #$10
    BEQ L_17:13A6
    LDA #$6D
    JSR SCRIPT_REENTER_UNK
L_17:13A6: ; 17:13A6, 0x02F3A6
    PLA
    PHA
    AND #$80
    BNE L_17:13B7
    PLA
    PHA
    AND #$01
    BEQ L_17:13B7
    LDA #$6F
    JSR SCRIPT_REENTER_UNK
L_17:13B7: ; 17:13B7, 0x02F3B7
    PLA
    LDA #$FF
    JMP SCRIPT_REENTER_UNK
    LDA #$90
    JMP SCRIPT_REENTER_UNK
RTN_H_ALT3: ; 17:13C2, 0x02F3C2
    LDX #$0F
    LDA SCRIPT_BATTLE_PARTY_ID_FOCUS
    BMI L_17:13CA
    LDX #$01
L_17:13CA: ; 17:13CA, 0x02F3CA
    TXA
    JMP LIB_DIRECT_ENTRY_TOSOLVE_BATTLE?_UNK
RTN_I_ALT3: ; 17:13CE, 0x02F3CE
    LDA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2]
    STA R_**:$0058
    RTS
RTN_J_ALT3: ; 17:13D3, 0x02F3D3
    LDA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2]
    JMP SCRIPT_REENTER_UNK
RTN_K_ALT3: ; 17:13D8, 0x02F3D8
    LDA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2]
    JMP LIB_DIRECT_ENTRY_TOSOLVE_BATTLE?_UNK
L_17:13DD: ; 17:13DD, 0x02F3DD
    TYA
    BMI L_17:13F0
    LDA SCRIPT_PARTY_ATTRIBUTES+17,Y
    CMP #$06
    BNE L_17:13F0
    LDA #$00
    STA 56_OBJECT_NAME_SIZE?
    LDX #$88
    JMP L_17:140B
L_17:13F0: ; 17:13F0, 0x02F3F0
    JSR L_17:14CA
    CMP #$01
    BNE L_17:13FC
    LDX #$19
    JMP L_17:140B
L_17:13FC: ; 17:13FC, 0x02F3FC
    CMP #$02
    BNE L_17:1405
    LDX #$1A
    JMP L_17:140B
L_17:1405: ; 17:1405, 0x02F405
    JSR L_17:142D
    JMP L_17:1496
L_17:140B: ; 17:140B, 0x02F40B
    LDA SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    PHA
    LDA SCRIPT_BATTLE_PARTY_ID_FOCUS
    PHA
    LDA FPTR_UNK_BANK_17_PTR+1
    PHA
    LDA FPTR_UNK_BANK_17_PTR[2]
    PHA
    STY SCRIPT_BATTLE_PARTY_ID_FOCUS
    TXA
    JSR L_17:0D7B
    PLA
    STA FPTR_UNK_BANK_17_PTR[2]
    PLA
    STA FPTR_UNK_BANK_17_PTR+1
    PLA
    STA SCRIPT_BATTLE_PARTY_ID_FOCUS
    PLA
    STA SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    TAY
    JMP L_17:1496
L_17:142D: ; 17:142D, 0x02F42D
    TYA
    PHA
    LDA #$00
    STA SCRIPT_PARTY_ATTRIBUTES+3,Y
    STA SCRIPT_PARTY_ATTRIBUTES+4,Y
    LDA #$80
    STA SCRIPT_PARTY_ATTRIBUTES+1,Y
    TYA
    BPL L_17:148B
    LDA #$00
    STA SCRIPT_PARTY_ATTRIBUTES[32],Y
    LDA PARTY_ATTR_PTR[2],Y
    STA LIB_BCD/EXTRA_FILE_BCD_A
    LDA PARTY_ATTR_PTR+1,Y
    STA LIB_BCD/EXTRA_FILE_BCD_B
    TYA
    PHA
    CLC
    LDY #$1A
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y
    ADC TRIO_FILE_OFFSET_UNK[3]
    STA TRIO_FILE_OFFSET_UNK[3]
    INY
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y
    ADC TRIO_FILE_OFFSET_UNK+1
    STA TRIO_FILE_OFFSET_UNK+1
    LDA #$00
    ADC TRIO_FILE_OFFSET_UNK+2
    STA TRIO_FILE_OFFSET_UNK+2
    CLC
    LDY #$1C
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y
    ADC R_**:$004C
    STA R_**:$004C
    INY
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y
    ADC R_**:$004D
    STA R_**:$004D
    LDY #$1E
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y
    BEQ L_17:147E
    STA SCRIPT_OVERWORLD_BATTLE_ENCOUNTER?
L_17:147E: ; 17:147E, 0x02F47E
    LDA #$06
    STA SOUND_EFFECT_REQUEST_ARRAY[5] ; Play weird going down effect.
    PLA
    TAY
    JSR L_17:1555
    JMP L_17:1490
L_17:148B: ; 17:148B, 0x02F48B
    LDA #$15
    JSR LIB_DIRECT_ENTRY_TOSOLVE_BATTLE?_UNK
L_17:1490: ; 17:1490, 0x02F490
    JSR SUB_SAVE_REGS_AND_DO_UNK
    PLA
    TAY
    RTS
L_17:1496: ; 17:1496, 0x02F496
    TYA
    PHA
    BMI L_17:14A9
    LDA SCRIPT_PARTY_ATTRIBUTES+17,Y
    CMP #$06
    BEQ L_17:14C7
    LDA #$10
    JSR SCRIPT_REENTER_UNK
    JMP L_17:14C7
L_17:14A9: ; 17:14A9, 0x02F4A9
    LDA 56_OBJECT_NAME_SIZE?
    CMP #$06
    BEQ L_17:14C7
    LDA PARTY_ATTR_PTR[2],Y
    STA LIB_BCD/EXTRA_FILE_BCD_A
    LDA PARTY_ATTR_PTR+1,Y
    STA LIB_BCD/EXTRA_FILE_BCD_B
    LDY #$0A
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y
    AND #$1C
    LSR A
    LSR A
    CLC
    ADC #$79
    JSR SCRIPT_REENTER_UNK
L_17:14C7: ; 17:14C7, 0x02F4C7
    PLA
    TAY
    RTS
L_17:14CA: ; 17:14CA, 0x02F4CA
    TYA
    PHA
    LDA PARTY_ATTR_PTR[2],Y
    STA LIB_BCD/EXTRA_FILE_BCD_A
    LDA PARTY_ATTR_PTR+1,Y
    STA LIB_BCD/EXTRA_FILE_BCD_B
    LDY #$08
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y
    AND #$1C
    LSR A
    LSR A
    STA LIB_BCD/EXTRA_FILE_BCD_A
    PLA
    TAY
    LDA LIB_BCD/EXTRA_FILE_BCD_A
    RTS
L_17:14E5: ; 17:14E5, 0x02F4E5
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS
    CLC
    LDA PARTY_ATTR_PTR[2],Y
    ADC #$20
    STA LIB_BCD/EXTRA_FILE_BCD_A
    LDA PARTY_ATTR_PTR+1,Y
    ADC #$00
    STA LIB_BCD/EXTRA_FILE_BCD_B
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS
    LDA SCRIPT_PARTY_ATTRIBUTES+16,Y
    TAY
L_17:14FC: ; 17:14FC, 0x02F4FC
    JSR ENGINE_WRAM_STATE_WRITEABLE
L_17:14FF: ; 17:14FF, 0x02F4FF
    CPY #$07
    BEQ L_17:150C
    INY
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y
    DEY
    STA [LIB_BCD/EXTRA_FILE_BCD_A],Y
    INY
    BNE L_17:14FF
L_17:150C: ; 17:150C, 0x02F50C
    LDA #$00
    STA [LIB_BCD/EXTRA_FILE_BCD_A],Y
    JMP ENGINE_WRAM_STATE_WRITE_DISABLED
L_17:1513: ; 17:1513, 0x02F513
    JSR SUB_MOVE_AND_MULTI_BY_0x8_UNK
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y
    AND #$7F
    STA SCRIPT_PARTY_ATTRIBUTES+1,Y
    LDA #$22
    STA LIB_BCD/EXTRA_FILE_BCD_A
    LDA #$FF
    STA LIB_BCD/EXTRA_FILE_BCD_B
    LDA #$FF
    STA LIB_BCD2/EXTRA_FILE_STREAM_INDEX
    JSR L_17:1589
    LDA #$00
    STA ENGINE_FLAG_LATCHY_GFX_FLAGS
    TYA
    PHA
    LDA SCRIPT_PARTY_ATTRIBUTES+26,Y
    AND #$03
    TAX
    LDY #$1F
    LDA [FPTR_5C_BATTLE_PARTY_SCRIPT?[2]],Y
    STA GFX_BANKS_EXTENSION[4],X
    PLA
    TAY
    LDA SCRIPT_PARTY_ATTRIBUTES+28,Y
    LDX SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER+1
    STA OBJ?_BYTE_0x0_STATUS?,X
    LDA #$01
    STA NMI_FLAG_EXECUTE_UPDATE_BUF_AND_MORE_TODO
    JSR ENGINE_NMI_0x01_SET/WAIT
    LDA #$80
    STA NMI_FLAG_EXECUTE_UPDATE_BUF_AND_MORE_TODO
    RTS
L_17:1555: ; 17:1555, 0x02F555
    JSR SUB_MOVE_AND_MULTI_BY_0x8_UNK
    LDA #$00
    LDX SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER+1
    STA OBJ?_BYTE_0x0_STATUS?,X
    LDA #$01
    STA NMI_FLAG_EXECUTE_UPDATE_BUF_AND_MORE_TODO
    JSR ENGINE_NMI_0x01_SET/WAIT
    LDA #$80
    STA NMI_FLAG_EXECUTE_UPDATE_BUF_AND_MORE_TODO
    LDA #$00
    STA SCRIPT_PARTY_ATTRIBUTES[32],Y
    LDA #$00
    STA LIB_BCD/EXTRA_FILE_BCD_A
    LDA #$23
    STA LIB_BCD/EXTRA_FILE_BCD_B
    LDA #$01
    STA LIB_BCD2/EXTRA_FILE_STREAM_INDEX
    JSR L_17:1589
    LDA SCRIPT_PARTY_ATTRIBUTES+26,Y
    AND #$03
    TAX
    LDA #$7C
    STA GFX_BANKS_EXTENSION[4],X
    RTS
L_17:1589: ; 17:1589, 0x02F589
    TYA
    PHA
    LDA SCRIPT_PARTY_ATTRIBUTES+26,Y
    AND #$03
    TAX
    LDY #$1F
    LDA [FPTR_5C_BATTLE_PARTY_SCRIPT?[2]],Y
    ORA #$80
    STA GFX_BANKS_EXTENSION[4],X
    PLA
    TAY
    LDA #$80
    STA ENGINE_FLAG_LATCHY_GFX_FLAGS
L_17:159F: ; 17:159F, 0x02F59F
    LDA LIB_BCD/EXTRA_FILE_BCD_A
    STA SCRIPT_REPLACE_LATCH_MOD_VAL?
    AND #$01
    BNE L_17:15AD
    LDA ENGINE_FLAG_LATCHY_GFX_FLAGS
    EOR #$40
    STA ENGINE_FLAG_LATCHY_GFX_FLAGS
L_17:15AD: ; 17:15AD, 0x02F5AD
    JSR ENGINE_NMI_0x01_SET/WAIT
    CLC
    LDA LIB_BCD/EXTRA_FILE_BCD_A
    ADC LIB_BCD2/EXTRA_FILE_STREAM_INDEX
    STA LIB_BCD/EXTRA_FILE_BCD_A
    CMP LIB_BCD/EXTRA_FILE_BCD_B
    BNE L_17:159F
    RTS
SUB_MOVE_AND_MULTI_BY_0x8_UNK: ; 17:15BC, 0x02F5BC
    LDA PARTY_ATTR_PTR[2],Y ; Move ??
    STA FPTR_5C_BATTLE_PARTY_SCRIPT?[2]
    LDA PARTY_ATTR_PTR+1,Y
    STA FPTR_5C_BATTLE_PARTY_SCRIPT?+1
    LDA SCRIPT_PARTY_ATTRIBUTES+26,Y ; Load ??
    AND #$03 ; Keep lower.
    STA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2] ; Store to.
    ASL A ; << 3, *8.
    ASL A
    ASL A
    STA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER+1 ; Store to.
    RTS ; Leave.
L_17:15D3: ; 17:15D3, 0x02F5D3
    LDA #$0F
    LDX #$03
    JMP L_17:1626
L_17:15DA: ; 17:15DA, 0x02F5DA
    LDA #$16
    LDX #$03
    JMP L_17:1626
L_17:15E1: ; 17:15E1, 0x02F5E1
    LDA #$12
    LDX #$03
    JMP L_17:1626
L_17:15E8: ; 17:15E8, 0x02F5E8
    LDA #$31
    LDX #$03
    JMP L_17:1626
L_17:15EF: ; 17:15EF, 0x02F5EF
    LDA #$28
    LDX #$03
    JMP L_17:1626
L_17:15F6: ; 17:15F6, 0x02F5F6
    LDA #$2A
    LDX #$03
    JMP L_17:1626
L_17:15FD: ; 17:15FD, 0x02F5FD
    LDX #$03
L_17:15FF: ; 17:15FF, 0x02F5FF
    TXA
    PHA
    LDA #$05
    STA SOUND_EFFECT_REQUEST_ARRAY[5] ; Play crit sound?
    JSR RANDOMIZE_GROUP_A
    AND #$03
    TAX
    INX
L_17:160D: ; 17:160D, 0x02F60D
    TXA
    PHA
    LDA #$01
    STA SOUND_EFFECT_REQUEST_ARRAY[5] ; Play hit sound?
    PLA
    PHA
    LDX #$03
    JSR L_17:1626
    PLA
    TAX
    DEX
    BNE L_17:160D
    PLA
    TAX
    DEX
    BNE L_17:15FF
    RTS
L_17:1626: ; 17:1626, 0x02F626
    STA LIB_BCD/EXTRA_FILE_BCD_B
    STX LIB_BCD/EXTRA_FILE_BCD_A
    LDA #$02
    JSR LIB_DIRECT_ENTRY_TOSOLVE_BATTLE?_UNK
    LDY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    JSR SUB_MOVE_AND_MULTI_BY_0x8_UNK
    JSR ENGINE_SETTLE_ALL_UPDATES?
    LDX LIB_BCD/EXTRA_FILE_BCD_A
L_17:1639: ; 17:1639, 0x02F639
    TXA
    PHA
    LDX SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER+1
    LDA OBJ?_BYTE_0x0_STATUS?,X
    PHA
    LDA #$00
    STA OBJ?_BYTE_0x0_STATUS?,X
    LDA #$01
    STA NMI_FLAG_EXECUTE_UPDATE_BUF_AND_MORE_TODO
    JSR ENGINE_NMI_0x01_SET/WAIT
    LDA #$7C
    LDX SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2]
    STA GFX_BANKS_EXTENSION[4],X
    LDA LIB_BCD/EXTRA_FILE_BCD_B
    JSR PALETTE_MOD_BG_COLOR_TO_A
    JSR ENGINE_NMI_0x01_SET/WAIT
    PLA
    LDX SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER+1
    STA OBJ?_BYTE_0x0_STATUS?,X
    LDA #$01
    STA NMI_FLAG_EXECUTE_UPDATE_BUF_AND_MORE_TODO
    JSR ENGINE_NMI_0x01_SET/WAIT
    LDY #$1F
    LDA [FPTR_5C_BATTLE_PARTY_SCRIPT?[2]],Y
    LDX SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2]
    STA GFX_BANKS_EXTENSION[4],X
    JSR PALETTE_MOD_TO_BLACK
    JSR ENGINE_NMI_0x01_SET/WAIT
    PLA
    TAX
    DEX
    BNE L_17:1639
    RTS
L_17:167C: ; 17:167C, 0x02F67C
    LDA #$02
    JSR LIB_DIRECT_ENTRY_TOSOLVE_BATTLE?_UNK
    JSR SUB_MOVE_AND_MULTI_BY_0x8_UNK
    LDY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    LDA SCRIPT_PARTY_ATTRIBUTES+28,Y
    PHA
    LDX SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER+1
    LDA OBJ?_BYTE_0x0_STATUS?,X
    LDY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    STA SCRIPT_PARTY_ATTRIBUTES+28,Y
    LDA #$00
    LDX SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER+1
    STA OBJ?_BYTE_0x0_STATUS?,X
    LDA #$01
    STA NMI_FLAG_EXECUTE_UPDATE_BUF_AND_MORE_TODO
    JSR ENGINE_NMI_0x01_SET/WAIT
    LDA #$80
    STA NMI_FLAG_EXECUTE_UPDATE_BUF_AND_MORE_TODO
    LDY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    JSR L_17:1513
    PLA
    LDY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    STA SCRIPT_PARTY_ATTRIBUTES+28,Y
    RTS
L_17:16B2: ; 17:16B2, 0x02F6B2
    LDX #$41
    LDY #$9F
    LDA #$0F
    JMP L_17:16FA
L_17:16BB: ; 17:16BB, 0x02F6BB
    LDX #$41
    LDY #$9F
    LDA #$16
    JMP L_17:16FA
L_17:16C4: ; 17:16C4, 0x02F6C4
    LDX #$41
    LDY #$9F
    LDA #$12
    JMP L_17:16FA
L_17:16CD: ; 17:16CD, 0x02F6CD
    LDX #$41
    LDY #$9F
    LDA #$31
    JMP L_17:16FA
L_17:16D6: ; 17:16D6, 0x02F6D6
    LDX #$41
    LDY #$9F
    LDA #$28
    JMP L_17:16FA
L_17:16DF: ; 17:16DF, 0x02F6DF
    LDX #$61
    LDY #$9F
    LDA #$2A
    JMP L_17:16FA
L_17:16E8: ; 17:16E8, 0x02F6E8
    LDX #$61
    LDY #$9F
    LDA #$0F
    JMP L_17:16FA
L_17:16F1: ; 17:16F1, 0x02F6F1
    LDX #$4B
    LDY #$9F
    LDA #$0F
    JMP L_17:16FA
L_17:16FA: ; 17:16FA, 0x02F6FA
    STA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2]
    STX LIB_BCD/EXTRA_FILE_BCD_A
    STY LIB_BCD/EXTRA_FILE_BCD_B
    LDA #$10
    JSR LIB_DIRECT_ENTRY_TOSOLVE_BATTLE?_UNK
    JSR ENGINE_SETTLE_ALL_UPDATES?
    LDY #$00
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y
    STA LIB_BCD2/EXTRA_FILE_STREAM_INDEX
    INY
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y
    STA LIB_BCD/EXTRA_FILE_D
    CLC
    LDA LIB_BCD/EXTRA_FILE_BCD_A
    ADC #$02
    STA LIB_BCD/EXTRA_FILE_BCD_A
    LDA LIB_BCD/EXTRA_FILE_BCD_B
    ADC #$00
    STA LIB_BCD/EXTRA_FILE_BCD_B
L_17:1720: ; 17:1720, 0x02F720
    LDY #$00
L_17:1722: ; 17:1722, 0x02F722
    TYA
    PHA
    AND #$02
    BEQ L_17:1730
    LDA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2]
    JSR PALETTE_MOD_BG_COLOR_TO_A
    JMP L_17:1733
L_17:1730: ; 17:1730, 0x02F730
    JSR PALETTE_MOD_TO_BLACK
L_17:1733: ; 17:1733, 0x02F733
    PLA
    TAY
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y
    STA NMI_FP_UNK+1
    INY
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y
    STA NMI_FP_UNK[2]
    INY
    LDA #$01
    STA NMI_FLAG_EXECUTE_UPDATE_BUF_AND_MORE_TODO
    JSR ENGINE_NMI_0x01_SET/WAIT
    CPY LIB_BCD/EXTRA_FILE_D
    BNE L_17:1722
    DEC LIB_BCD2/EXTRA_FILE_STREAM_INDEX
    BNE L_17:1720
    LDA #$00
    STA NMI_FP_UNK[2]
    STA NMI_FP_UNK+1
    JSR ENGINE_NMI_0x01_SET/WAIT
    JMP PALETTE_MOD_TO_BLACK
SUB_UNK: ; 17:175A, 0x02F75A
    LDA STREAM_REPLACE_COUNT? ; Load ??
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
    STA SCRIPT_PARTY_ATTRIBUTES+1 ; Set all attrs, party?
    STA **:$0621
    STA **:$0641
    STA **:$0661
    LDA 56_OBJECT_NAME_SIZE? ; Load ??
    CMP #$04 ; If _ #$04
    BNE VAL_NE_0x4 ; !=, goto.
    LDA #$03
    STA STREAM_REPLACE_COUNT? ; Set ??
    LDA #$04
    JSR LIB_DIRECT_ENTRY_TOSOLVE_BATTLE?_UNK ; Do lib.
    LDA #$8F
    JSR SCRIPT_REENTER_UNK ; Script ??
    JMP EXIT_CS ; Goto, RTS CS.
VAL_NE_0x4: ; 17:17A7, 0x02F7A7
    LDA #$00
    STA SCRIPT_BATTLE_PARTY_ID_FOCUS ; Clear ??
    LDA #$0E ; Seed ??
    JSR SCRIPT_REENTER_UNK ; Do.
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
    JSR SCRIPT_REENTER_UNK ; Do.
FLAG_ZERO: ; 17:17C9, 0x02F7C9
    LDA 56_OBJECT_NAME_SIZE? ; Load ??
    CMP #$06 ; If _ #$06
    BNE BATTLE_OVER? ; !=, goto.
    LDA #$00
    STA SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL? ; Clear ??
    JSR PARTY_RELATED?_UNK ; Do ??
    LDA #$20
    STA SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL? ; Set ??
    JSR PARTY_RELATED?_UNK
    LDA #$40
    STA SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL? ; Set ??
    JSR PARTY_RELATED?_UNK
    JMP EXIT_CS ; Goto, ret CS.
BATTLE_OVER?: ; 17:17E7, 0x02F7E7
    LDA #$05
    JSR SOUND_LIB_SET_NEW_SONG_ID ; Play sound good battle over?
    LDA #$0D
    JSR SCRIPT_REENTER_UNK ; Do ??
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
    LDY #$01
    LDA [FPTR_UNK_BANK_17_PTR[2]],Y
    JSR SWITCH_TABLE_PAST_JSR_WITH_PTR[0]_AS_RET_CATCH
    LOW(RTN_A_CATCH_ADVANCE_0x2)
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
    LOW(RTN_G)
    HIGH(RTN_G)
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
    LOW(RTN_T)
    HIGH(RTN_T)
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
    LOW(RTN_Z)
    HIGH(RTN_Z)
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
    LOW(RTN_AF)
    HIGH(RTN_AF)
    LOW(RTN_AG)
    HIGH(RTN_AG)
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
    JSR MOVE_AND_HARD_SWITCH
L_17:186B: ; 17:186B, 0x02F86B
    LDX SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    LDY #$03
    JSR DEEPER_SUB_UNK
    LDX #$0A
    LDA #$3E
    JMP SUB_UNK_LIBS
RTN_C: ; 17:1879, 0x02F879
    JSR MOVE_AND_HARD_SWITCH
    LDX SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    LDY #$05
    JSR DEEPER_SUB_UNK
    LDX #$0A
    LDA #$3D
    JMP SUB_UNK_LIBS
RTN_S: ; 17:188A, 0x02F88A
    JSR MOVE_AND_HARD_SWITCH
    LDX SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    LDY #$07
    JSR L_17:1DE8
    LDA #$20
    JMP SCRIPT_REENTER_UNK
RTN_D: ; 17:1899, 0x02F899
    JSR MOVE_AND_HARD_SWITCH
    LDX SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    LDY #$0C
    JSR L_17:1E3B
    LDX #$09
    LDA #$23
    JMP SUB_UNK_LIBS
RTN_P: ; 17:18AA, 0x02F8AA
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS
    JMP L_17:142D
RTN_E: ; 17:18AF, 0x02F8AF
    LDX SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    LDY #$07
    JSR L_17:1F00
    LDX #$09
    LDA #$20
    JMP SUB_UNK_LIBS
RTN_F: ; 17:18BD, 0x02F8BD
    LDX SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    LDY #$09
    JSR L_17:1F00
    LDX #$09
    LDA #$22
    JMP SUB_UNK_LIBS
RTN_G: ; 17:18CB, 0x02F8CB
    LDA #$FF
    STA SUB/MOD_VAL_UNK_WORD[2]
    STA SUB/MOD_VAL_UNK_WORD+1
    JMP L_17:186B
PARTY_RELATED?_UNK: ; 17:18D4, 0x02F8D4
    LDA #$FF
    STA SUB/MOD_VAL_UNK_WORD[2] ; Seed ??
    STA SUB/MOD_VAL_UNK_WORD+1
    LDA #$00
    LDX SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL? ; Load index.
    STA SCRIPT_PARTY_ATTRIBUTES+1,X ; Store ??
    LDY #$03 ; Load ??
    JSR DEEPER_SUB_UNK ; Goto.
    LDX #$0A ; Seed ??
    LDA #$00
    JSR SUB_UNK_LIBS ; Do ??
    LDX #$14
    JMP ENGINE_WAIT_X_SETTLES ; Wait and goto.
RTN_Q: ; 17:18F2, 0x02F8F2
    JSR MOVE_AND_HARD_SWITCH
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS
    SEC
    LDA SCRIPT_PARTY_ATTRIBUTES+3,Y
    SBC LIB_BCD/EXTRA_FILE_BCD_A
    STA SCRIPT_PARTY_ATTRIBUTES+3,Y
    LDA SCRIPT_PARTY_ATTRIBUTES+4,Y
    SBC LIB_BCD/EXTRA_FILE_BCD_B
    STA SCRIPT_PARTY_ATTRIBUTES+4,Y
    BCC L_17:1912
    ORA SCRIPT_PARTY_ATTRIBUTES+3,Y
    BEQ L_17:1912
    JMP SUB_SAVE_REGS_AND_DO_UNK
L_17:1912: ; 17:1912, 0x02F912
    JMP L_17:13DD
RTN_H: ; 17:1915, 0x02F915
    LDA 56_OBJECT_NAME_SIZE?
    CMP #$05
    BEQ L_17:193E
    CMP #$06
    BEQ L_17:193E
    JSR L_17:1FE2
    BCC L_17:193E
L_17:1924: ; 17:1924, 0x02F924
    LDX #$03
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS
    LDA SCRIPT_PARTY_ATTRIBUTES+17,Y
    CMP #$06
    BNE L_17:1931
    LDX #$3F
L_17:1931: ; 17:1931, 0x02F931
    STX LIB_BCD/EXTRA_FILE_BCD_A
    JSR RANDOMIZE_GROUP_A
    AND LIB_BCD/EXTRA_FILE_BCD_A
    STA SUB/MOD_VAL_UNK_WORD[2]
    LDA #$00
    STA SUB/MOD_VAL_UNK_WORD+1
L_17:193E: ; 17:193E, 0x02F93E
    LDA SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    PHA
    JSR MOVE_AND_HARD_SWITCH
    LDY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    LDA SCRIPT_PARTY_ATTRIBUTES+30,Y
    AND #$04
    BEQ L_17:1962
    LDA LIB_BCD/EXTRA_FILE_BCD_B
    PHA
    LDA LIB_BCD/EXTRA_FILE_BCD_A
    PHA
    LDA #$53
    JSR SCRIPT_REENTER_UNK
    PLA
    STA LIB_BCD/EXTRA_FILE_BCD_A
    PLA
    STA LIB_BCD/EXTRA_FILE_BCD_B
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS
    STY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
L_17:1962: ; 17:1962, 0x02F962
    LDA SCRIPT_PARTY_ATTRIBUTES+30,Y
    AND #$10
    BEQ L_17:196D
    LSR LIB_BCD/EXTRA_FILE_BCD_B
    ROR LIB_BCD/EXTRA_FILE_BCD_A
L_17:196D: ; 17:196D, 0x02F96D
    LDA SCRIPT_PARTY_ATTRIBUTES+30,Y
    AND #$08
    BEQ L_17:1978
    LSR LIB_BCD/EXTRA_FILE_BCD_B
    ROR LIB_BCD/EXTRA_FILE_BCD_A
L_17:1978: ; 17:1978, 0x02F978
    JSR L_17:1F74
    LDA LIB_BCD/EXTRA_FILE_BCD_A
    ORA LIB_BCD/EXTRA_FILE_BCD_B
    BNE L_17:1983
    INC LIB_BCD/EXTRA_FILE_BCD_A
L_17:1983: ; 17:1983, 0x02F983
    LDA LIB_BCD/EXTRA_FILE_BCD_A
    STA BATTLE_ARRAY_UNK[4]
    PHA
    LDA LIB_BCD/EXTRA_FILE_BCD_B
    STA BATTLE_ARRAY_UNK+1
    PHA
    LDA #$0C
    JSR SCRIPT_REENTER_UNK
    PLA
    STA LIB_BCD/EXTRA_FILE_BCD_B
    PLA
    STA LIB_BCD/EXTRA_FILE_BCD_A
    LDA 56_OBJECT_NAME_SIZE?
    CMP #$03
    BEQ L_17:19A5
    JSR L_17:1FEF
    BCS L_17:19C4
L_17:19A5: ; 17:19A5, 0x02F9A5
    JSR L_17:1FE2
    BCS L_17:19C4
    LDY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    SEC
    LDA SCRIPT_PARTY_ATTRIBUTES+3,Y
    SBC LIB_BCD/EXTRA_FILE_BCD_A
    STA SCRIPT_PARTY_ATTRIBUTES+3,Y
    LDA SCRIPT_PARTY_ATTRIBUTES+4,Y
    SBC LIB_BCD/EXTRA_FILE_BCD_B
    STA SCRIPT_PARTY_ATTRIBUTES+4,Y
    BCC L_17:1A00
    ORA SCRIPT_PARTY_ATTRIBUTES+3,Y
    BEQ L_17:1A00
L_17:19C4: ; 17:19C4, 0x02F9C4
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y
    AND #$0C
    BEQ L_17:19DF
    JSR RANDOMIZE_GROUP_A
    AND #$C0
    BNE L_17:19DF
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y
    AND #$F3
    STA SCRIPT_PARTY_ATTRIBUTES+1,Y
    LDA #$8D
    JSR SCRIPT_REENTER_UNK
L_17:19DF: ; 17:19DF, 0x02F9DF
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y
    AND #$10
    BEQ L_17:19FA
    JSR RANDOMIZE_GROUP_A
    AND #$C0
    BNE L_17:19FA
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y
    AND #$EF
    STA SCRIPT_PARTY_ATTRIBUTES+1,Y
    LDA #$61
    JSR SCRIPT_REENTER_UNK
L_17:19FA: ; 17:19FA, 0x02F9FA
    PLA
    STA SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    JMP SUB_SAVE_REGS_AND_DO_UNK
L_17:1A00: ; 17:1A00, 0x02FA00
    JSR L_17:13DD
    PLA
    STA SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    RTS
RTN_I: ; 17:1A07, 0x02FA07
    JSR MOVE_AND_HARD_SWITCH
    LDY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    JSR L_17:1F74
    LDX SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    LDY #$09
    JSR L_17:1E72
    LDA #$27
    JMP SCRIPT_REENTER_UNK
RTN_J: ; 17:1A1B, 0x02FA1B
    JSR MOVE_AND_HARD_SWITCH
    LDX SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    LDY #$0B
    JSR L_17:1EC4
    LDA #$26
    JMP SCRIPT_REENTER_UNK
RTN_K: ; 17:1A2A, 0x02FA2A
    JSR L_17:1FE2
    BCS L_17:1A39
    JSR L_17:1FEF
    BCS L_17:1A39
    LDY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    JMP L_17:13DD
L_17:1A39: ; 17:1A39, 0x02FA39
    JMP L_17:1924
RTN_L: ; 17:1A3C, 0x02FA3C
    JSR L_17:1FE2
    BCS L_17:1A6B
    JSR L_17:1FEF
    BCS L_17:1A6B
    LDY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    JSR RANDOMIZE_GROUP_A
    AND #$03
    TAX
    INX
    TXA
    SEC
    SBC SCRIPT_PARTY_ATTRIBUTES+3,Y
    LDA #$00
    SBC SCRIPT_PARTY_ATTRIBUTES+4,Y
    BCS L_17:1A6B
    TXA
    STA SCRIPT_PARTY_ATTRIBUTES+3,Y
    LDA #$00
    STA SCRIPT_PARTY_ATTRIBUTES+4,Y
    LDX #$00
    LDA #$38
    JMP SUB_UNK_LIBS
L_17:1A6B: ; 17:1A6B, 0x02FA6B
    JMP L_17:1DD8
RTN_M: ; 17:1A6E, 0x02FA6E
    LDX SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    LDY #$07
    JSR L_17:1F15
    LDA #$21
    JMP SCRIPT_REENTER_UNK
RTN_N: ; 17:1A7A, 0x02FA7A
    LDX SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    LDY #$09
    JSR L_17:1F15
    LDA #$27
    JMP SCRIPT_REENTER_UNK
RTN_R: ; 17:1A86, 0x02FA86
    JSR MOVE_AND_HARD_SWITCH
    LDX SCRIPT_BATTLE_PARTY_ID_FOCUS
    LDY #$07
    JSR L_17:1DE8
    LDA #$5C
    JMP SCRIPT_REENTER_UNK
RTN_O: ; 17:1A95, 0x02FA95
    JSR MOVE_AND_HARD_SWITCH
    LDY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    BMI L_17:1ADD
    LDA PARTY_ATTR_PTR[2],Y
    STA LIB_BCD2/EXTRA_FILE_STREAM_INDEX
    LDA PARTY_ATTR_PTR+1,Y
    STA LIB_BCD/EXTRA_FILE_D
    LDY #$11
    CLC
    LDA [LIB_BCD2/EXTRA_FILE_STREAM_INDEX],Y
    ADC LIB_BCD/EXTRA_FILE_BCD_A
    STA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2]
    INY
    LDA [LIB_BCD2/EXTRA_FILE_STREAM_INDEX],Y
    ADC LIB_BCD/EXTRA_FILE_BCD_B
    STA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER+1
    INY
    LDA [LIB_BCD2/EXTRA_FILE_STREAM_INDEX],Y
    ADC #$00
    STA ALT_STUFF_COUNT?
    BCC L_17:1AC7
    LDA #$FF
    STA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2]
    STA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER+1
    STA ALT_STUFF_COUNT?
L_17:1AC7: ; 17:1AC7, 0x02FAC7
    JSR ENGINE_WRAM_STATE_WRITEABLE
    LDY #$11
    LDA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2]
    STA [LIB_BCD2/EXTRA_FILE_STREAM_INDEX],Y
    INY
    LDA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER+1
    STA [LIB_BCD2/EXTRA_FILE_STREAM_INDEX],Y
    INY
    LDA ALT_STUFF_COUNT?
    STA [LIB_BCD2/EXTRA_FILE_STREAM_INDEX],Y
    JSR ENGINE_WRAM_STATE_WRITE_DISABLED
L_17:1ADD: ; 17:1ADD, 0x02FADD
    LDX #$0A
    LDA #$2F
    JMP SUB_UNK_LIBS
RTN_T: ; 17:1AE4, 0x02FAE4
    JSR L_17:1FE2
    BCS L_17:1AF7
    JSR L_17:1F58
    BCS L_17:1AF7
    LDA #$1B
    LDY #$00
    LDX #$80
    JMP L_17:1D7F
L_17:1AF7: ; 17:1AF7, 0x02FAF7
    JMP L_17:1DD8
RTN_U: ; 17:1AFA, 0x02FAFA
    JSR L_17:1FE2
    BCS L_17:1AF7
    JSR L_17:1F58
    BCS L_17:1AF7
    LDA #$4B
    LDY #$00
    LDX #$02
    JMP L_17:1D69
RTN_V: ; 17:1B0D, 0x02FB0D
    JSR L_17:1FE2
    BCS L_17:1AF7
    JSR L_17:1FEF
    BCS L_17:1AF7
    JSR L_17:1F66
    BCS L_17:1AF7
    LDA #$39
    LDY #$00
    LDX #$08
    JMP L_17:1D69
RTN_W: ; 17:1B25, 0x02FB25
    JSR L_17:1FE2
    BCS L_17:1AF7
    JSR L_17:1FEF
    BCS L_17:1AF7
    JSR L_17:1F66
    BCS L_17:1AF7
    LDA #$3B
    LDY #$00
    LDX #$10
    JMP L_17:1D69
RTN_X: ; 17:1B3D, 0x02FB3D
    JSR L_17:1FE2
    BCS L_17:1AF7
    JSR L_17:1FEF
    BCS L_17:1AF7
    JSR L_17:1F58
    BCS L_17:1AF7
    LDA #$49
    LDY #$00
    LDX #$20
    JMP L_17:1D69
RTN_Y: ; 17:1B55, 0x02FB55
    JSR L_17:1FE2
    BCS L_17:1AF7
    LDY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    LDA PARTY_ATTR_PTR[2],Y
    STA LIB_BCD/EXTRA_FILE_BCD_A
    LDA PARTY_ATTR_PTR+1,Y
    STA LIB_BCD/EXTRA_FILE_BCD_B
    LDY #$05
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y
    INY
    ORA [LIB_BCD/EXTRA_FILE_BCD_A],Y
    BEQ L_17:1AF7
    LDA #$4D
    LDY #$00
    LDX #$40
    JMP L_17:1D7F
RTN_Z: ; 17:1B78, 0x02FB78
    LDY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    LDA SCRIPT_PARTY_ATTRIBUTES+30,Y
    ORA #$08
    STA SCRIPT_PARTY_ATTRIBUTES+30,Y
    RTS
RTN_AA: ; 17:1B83, 0x02FB83
    LDA #$4F
    LDY #$0A
    LDX #$10
    JMP L_17:1D7F
RTN_AB: ; 17:1B8C, 0x02FB8C
    JSR L_17:1FE6
    BCS L_17:1B9A
    LDA #$17
    LDY #$0A
    LDX #$04
    JMP L_17:1D7F
L_17:1B9A: ; 17:1B9A, 0x02FB9A
    JMP L_17:1DD8
RTN_AC: ; 17:1B9D, 0x02FB9D
    JSR L_17:1FE2
    BCS L_17:1B9A
    JSR L_17:1FEF
    BCS L_17:1B9A
    LDA #$4E
    LDY #$00
    LDX #$20
    JMP L_17:1D7F
RTN_AD: ; 17:1BB0, 0x02FBB0
    JSR L_17:1FE2
    BCS L_17:1B9A
    JSR L_17:1FEF
    BCS L_17:1B9A
    LDA #$19
    LDY #$00
    LDX #$40
    JSR L_17:1D69
    BCS L_17:1BCC
    LDX SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    LDY #$09
    JSR L_17:1F00
L_17:1BCC: ; 17:1BCC, 0x02FBCC
    RTS
RTN_AE: ; 17:1BCD, 0x02FBCD
    LDY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    LDA SCRIPT_PARTY_ATTRIBUTES+17,Y
    CMP #$01
    BNE L_17:1BEA
    LDA SCRIPT_PARTY_ATTRIBUTES+30,Y
    AND #$02
    BNE L_17:1BEA
    LDA SCRIPT_PARTY_ATTRIBUTES+30,Y
    ORA #$02
    STA SCRIPT_PARTY_ATTRIBUTES+30,Y
    LDA #$74
    JMP SCRIPT_REENTER_UNK
L_17:1BEA: ; 17:1BEA, 0x02FBEA
    RTS
RTN_AF: ; 17:1BEB, 0x02FBEB
    JSR L_17:1F66
    BCS L_17:1B9A
    LDA #$67
    LDY #$00
    LDX #$04
    JMP L_17:1D69
RTN_AG: ; 17:1BF9, 0x02FBF9
    LDA #$5D
    LDY #$0A
    LDX #$02
    JMP L_17:1D95
RTN_AH: ; 17:1C02, 0x02FC02
    LDA #$61
    LDY #$0A
    LDX #$10
    JMP L_17:1D95
RTN_AI: ; 17:1C0B, 0x02FC0B
    LDA #$60
    LDY #$0A
    LDX #$20
    JMP L_17:1D95
RTN_AJ: ; 17:1C14, 0x02FC14
    LDA #$70
    LDY #$0A
    LDX #$02
    JMP L_17:1DAB
RTN_AK: ; 17:1C1D, 0x02FC1D
    LDA #$5E
    LDY #$0A
    LDX #$0C
    JMP L_17:1D95
RTN_AL: ; 17:1C26, 0x02FC26
    LDA #$69
    LDY #$02
    LDX #$10
    JMP L_17:1DAB
RTN_AN: ; 17:1C2F, 0x02FC2F
    LDA #$71
    LDY #$0A
    LDX #$40
    JMP L_17:1D95
RTN_AM: ; 17:1C38, 0x02FC38
    LDY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y
    AND #$80
    BEQ L_17:1C5A
    LDA #$00
    STA SCRIPT_PARTY_ATTRIBUTES+1,Y
    LDA #$FF
    STA SUB/MOD_VAL_UNK_WORD[2]
    STA SUB/MOD_VAL_UNK_WORD+1
    LDX SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    LDY #$03
    JSR DEEPER_SUB_UNK
    LDX #$0A
    LDA #$62
    JMP SUB_UNK_LIBS
L_17:1C5A: ; 17:1C5A, 0x02FC5A
    JMP L_17:1DD8
RTN_AQ: ; 17:1C5D, 0x02FC5D
    LDX 56_OBJECT_NAME_SIZE?
    CPX #$06
    BEQ L_17:1C85
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
L_17:1C85: ; 17:1C85, 0x02FC85
    LDA #$19
    JSR SOUND_LIB_SET_NEW_SONG_ID
    SEC
    LDA 57_INDEX_UNK
    SBC #$9E
    TAX
    JSR SCRIPT_BATTLE_HELPER_BG_COLORS?
    LDA #$03
    STA SOUND_EFFECT_REQUEST_ARRAY[5] ; SFX hit special?
    JSR L_17:16E8
    LDA 57_INDEX_UNK
    JSR SCRIPT_REENTER_UNK
    LDA #$2C
    JSR SOUND_LIB_SET_NEW_SONG_ID ; Giygas/star SFX?
    LDX 57_INDEX_UNK
    INX
    CPX #$A9
    BEQ L_17:1CAF
    STX 57_INDEX_UNK
    RTS
L_17:1CAF: ; 17:1CAF, 0x02FCAF
    JSR L_17:15FD
    LDA #$FF
    JSR SOUND_LIB_SET_NEW_SONG_ID ; No song.
    LDX #$C8
    JSR ENGINE_WAIT_X_SETTLES
    LDX #$A9
L_17:1CBE: ; 17:1CBE, 0x02FCBE
    STX 57_INDEX_UNK
    TXA
    JSR SCRIPT_REENTER_UNK
    LDX 57_INDEX_UNK
    INX
    CPX #$AC
    BNE L_17:1CBE
    LDY #$80
    JMP L_17:13DD
RTN_AO: ; 17:1CD0, 0x02FCD0
    LDX #$0A
    LDY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    LDA SCRIPT_PARTY_ATTRIBUTES+5,Y
    ORA SCRIPT_PARTY_ATTRIBUTES+6,Y
    BEQ L_17:1D28
    SEC
    LDA SCRIPT_PARTY_ATTRIBUTES+5,Y
    TAX
    SBC #$0A
    LDA SCRIPT_PARTY_ATTRIBUTES+6,Y
    SBC #$00
    BCC L_17:1CEC
    LDX #$0A
L_17:1CEC: ; 17:1CEC, 0x02FCEC
    STX BATTLE_ARRAY_UNK[4]
    LDX #$00
    STX BATTLE_ARRAY_UNK+1
    SEC
    LDA SCRIPT_PARTY_ATTRIBUTES+5,Y
    SBC BATTLE_ARRAY_UNK[4]
    STA SCRIPT_PARTY_ATTRIBUTES+5,Y
    LDA SCRIPT_PARTY_ATTRIBUTES+6,Y
    SBC BATTLE_ARRAY_UNK+1
    STA SCRIPT_PARTY_ATTRIBUTES+6,Y
    LDA #$48
    JSR SCRIPT_REENTER_UNK
    LDA BATTLE_ARRAY_UNK[4]
    STA LIB_BCD/EXTRA_FILE_BCD_A
    LDA BATTLE_ARRAY_UNK+1
    STA LIB_BCD/EXTRA_FILE_BCD_B
    LDX SCRIPT_BATTLE_PARTY_ID_FOCUS
    LDY #$05
    JSR DEEPER_SUB_UNK
    LDA SCRIPT_BATTLE_PARTY_ID_FOCUS
    STA SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    LDX #$0A
    LDA #$3D
    JMP SUB_UNK_LIBS
L_17:1D28: ; 17:1D28, 0x02FD28
    JMP L_17:1DD8
RTN_AP: ; 17:1D2B, 0x02FD2B
    LDY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    BMI L_17:1D3F
    JSR PARTY_FOCUS_NO_ATTRS_SET_UNK
    BCS L_17:1D3F
    JSR L_17:14FC
    JSR L_17:0ACC
    LDA #$81
    JMP SCRIPT_REENTER_UNK
L_17:1D3F: ; 17:1D3F, 0x02FD3F
    LDA #$59
    JMP SCRIPT_REENTER_UNK
RTN_AR: ; 17:1D44, 0x02FD44
    LDY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y
    AND #$08
    BNE L_17:1D5A
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y
    ORA #$08
    STA SCRIPT_PARTY_ATTRIBUTES+1,Y
    LDA #$39
    JSR SCRIPT_REENTER_UNK
L_17:1D5A: ; 17:1D5A, 0x02FD5A
    RTS
SUB_UNK_LIBS: ; 17:1D5B, 0x02FD5B
    PHA ; Save A.
    TXA ; X to A.
    BEQ X_EQ_0x00 ; == 0, goto.
    JSR LIB_DIRECT_ENTRY_TOSOLVE_BATTLE?_UNK ; Do ??
X_EQ_0x00: ; 17:1D62, 0x02FD62
    JSR SUB_SAVE_REGS_AND_DO_UNK ; Do ??
    PLA ; Pull value.
    JMP SCRIPT_REENTER_UNK ; Do ??
L_17:1D69: ; 17:1D69, 0x02FD69
    PHA
    JSR L_17:1DCC
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y
    AND LIB_BCD/EXTRA_FILE_BCD_A
    BNE L_17:1DC6
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y
    ORA LIB_BCD/EXTRA_FILE_BCD_A
    STA SCRIPT_PARTY_ATTRIBUTES+1,Y
    JMP L_17:1DBE
L_17:1D7F: ; 17:1D7F, 0x02FD7F
    PHA
    JSR L_17:1DCC
    LDA SCRIPT_PARTY_ATTRIBUTES+30,Y
    AND LIB_BCD/EXTRA_FILE_BCD_A
    BNE L_17:1DC6
    LDA SCRIPT_PARTY_ATTRIBUTES+30,Y
    ORA LIB_BCD/EXTRA_FILE_BCD_A
    STA SCRIPT_PARTY_ATTRIBUTES+30,Y
    JMP L_17:1DBE
L_17:1D95: ; 17:1D95, 0x02FD95
    PHA
    JSR L_17:1DCC
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y
    AND LIB_BCD/EXTRA_FILE_BCD_A
    BEQ L_17:1DC6
    LDA SCRIPT_PARTY_ATTRIBUTES+1,Y
    AND LIB_BCD/EXTRA_FILE_BCD_B
    STA SCRIPT_PARTY_ATTRIBUTES+1,Y
    JMP L_17:1DBE
L_17:1DAB: ; 17:1DAB, 0x02FDAB
    PHA
    JSR L_17:1DCC
    LDA SCRIPT_PARTY_ATTRIBUTES+30,Y
    AND LIB_BCD/EXTRA_FILE_BCD_A
    BEQ L_17:1DC6
    LDA SCRIPT_PARTY_ATTRIBUTES+30,Y
    AND LIB_BCD/EXTRA_FILE_BCD_B
    STA SCRIPT_PARTY_ATTRIBUTES+30,Y
L_17:1DBE: ; 17:1DBE, 0x02FDBE
    LDX R_**:$0058
    PLA
    JSR SUB_UNK_LIBS
    CLC
    RTS
L_17:1DC6: ; 17:1DC6, 0x02FDC6
    PLA
    JSR L_17:1DD8
    SEC
    RTS
L_17:1DCC: ; 17:1DCC, 0x02FDCC
    STX LIB_BCD/EXTRA_FILE_BCD_A
    TXA
    EOR #$FF
    STA LIB_BCD/EXTRA_FILE_BCD_B
    STY R_**:$0058
    LDY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    RTS
L_17:1DD8: ; 17:1DD8, 0x02FDD8
    LDA #$55
    JMP SCRIPT_REENTER_UNK
MOVE_AND_HARD_SWITCH: ; 17:1DDD, 0x02FDDD
    LDA SUB/MOD_VAL_UNK_WORD[2] ; Move ??
    STA LIB_BCD/EXTRA_FILE_BCD_A
    LDA SUB/MOD_VAL_UNK_WORD+1
    STA LIB_BCD/EXTRA_FILE_BCD_B
    JMP SCRIPT_HARD_SWITCH_TO_SOMETHING_HUGE ; Do hard switch.
L_17:1DE8: ; 17:1DE8, 0x02FDE8
    JSR EVEN_DEEPER_SUB_TODO
L_17:1DEB: ; 17:1DEB, 0x02FDEB
    CLC
    LDA SCRIPT_PARTY_ATTRIBUTES[32],X
    ADC LIB_BCD/EXTRA_FILE_BCD_A
    STA ALT_STUFF_COUNT?
    LDA SCRIPT_PARTY_ATTRIBUTES+1,X
    ADC LIB_BCD/EXTRA_FILE_BCD_B
    STA ALT_COUNT_UNK
    BCC L_17:1E02
    LDA #$FF
    STA ALT_STUFF_COUNT?
    STA ALT_COUNT_UNK
L_17:1E02: ; 17:1E02, 0x02FE02
    SEC
    LDA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2]
    SBC ALT_STUFF_COUNT?
    LDA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER+1
    SBC ALT_COUNT_UNK
    BCS L_17:1E15
    LDA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2]
    STA ALT_STUFF_COUNT?
    LDA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER+1
    STA ALT_COUNT_UNK
L_17:1E15: ; 17:1E15, 0x02FE15
    SEC
    LDA ALT_STUFF_COUNT?
    SBC SCRIPT_PARTY_ATTRIBUTES[32],X
    STA BATTLE_ARRAY_UNK[4]
    LDA ALT_COUNT_UNK
    SBC SCRIPT_PARTY_ATTRIBUTES+1,X
    STA BATTLE_ARRAY_UNK+1
    BCC L_17:1E38
    ORA BATTLE_ARRAY_UNK[4]
    BEQ L_17:1E38
    LDA ALT_STUFF_COUNT?
    STA SCRIPT_PARTY_ATTRIBUTES[32],X
    LDA ALT_COUNT_UNK
    STA SCRIPT_PARTY_ATTRIBUTES+1,X
    RTS
L_17:1E38: ; 17:1E38, 0x02FE38
    JMP CLEAR_BATTLE_UNK
L_17:1E3B: ; 17:1E3B, 0x02FE3B
    JSR EVEN_DEEPER_SUB_TODO
    CLC
    LDA SCRIPT_PARTY_ATTRIBUTES[32],X
    ADC LIB_BCD/EXTRA_FILE_BCD_A
    STA ALT_STUFF_COUNT?
    BCC L_17:1E4C
    LDA #$FF
    STA ALT_STUFF_COUNT?
L_17:1E4C: ; 17:1E4C, 0x02FE4C
    SEC
    LDA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2]
    SBC ALT_STUFF_COUNT?
    BCS L_17:1E57
    LDA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2]
    STA ALT_STUFF_COUNT?
L_17:1E57: ; 17:1E57, 0x02FE57
    LDA #$00
    STA BATTLE_ARRAY_UNK+1
    SEC
    LDA ALT_STUFF_COUNT?
    SBC SCRIPT_PARTY_ATTRIBUTES[32],X
    STA BATTLE_ARRAY_UNK[4]
    BCC L_17:1E6F
    BEQ L_17:1E6F
    LDA ALT_STUFF_COUNT?
    STA SCRIPT_PARTY_ATTRIBUTES[32],X
    RTS
L_17:1E6F: ; 17:1E6F, 0x02FE6F
    JMP CLEAR_BATTLE_UNK
L_17:1E72: ; 17:1E72, 0x02FE72
    JSR EVEN_DEEPER_SUB_TODO
    SEC
    LDA SCRIPT_PARTY_ATTRIBUTES[32],X
    SBC LIB_BCD/EXTRA_FILE_BCD_A
    STA ALT_STUFF_COUNT?
    LDA SCRIPT_PARTY_ATTRIBUTES+1,X
    SBC LIB_BCD/EXTRA_FILE_BCD_B
    STA ALT_COUNT_UNK
    BCS L_17:1E8C
    LDA #$00
    STA ALT_STUFF_COUNT?
    STA ALT_COUNT_UNK
L_17:1E8C: ; 17:1E8C, 0x02FE8C
    CPY #$03
    BEQ L_17:1E9E
    CPY #$05
    BEQ L_17:1E9E
    LDA ALT_STUFF_COUNT?
    ORA ALT_COUNT_UNK
    BNE L_17:1E9E
    LDA #$01
    STA ALT_STUFF_COUNT?
L_17:1E9E: ; 17:1E9E, 0x02FE9E
    SEC
    LDA SCRIPT_PARTY_ATTRIBUTES[32],X
    SBC ALT_STUFF_COUNT?
    STA BATTLE_ARRAY_UNK[4]
    LDA SCRIPT_PARTY_ATTRIBUTES+1,X
    SBC ALT_COUNT_UNK
    STA BATTLE_ARRAY_UNK+1
    BCC L_17:1EC1
    ORA BATTLE_ARRAY_UNK[4]
    BEQ L_17:1EC1
    LDA ALT_STUFF_COUNT?
    STA SCRIPT_PARTY_ATTRIBUTES[32],X
    LDA ALT_COUNT_UNK
    STA SCRIPT_PARTY_ATTRIBUTES+1,X
    RTS
L_17:1EC1: ; 17:1EC1, 0x02FEC1
    JMP CLEAR_BATTLE_UNK
L_17:1EC4: ; 17:1EC4, 0x02FEC4
    JSR EVEN_DEEPER_SUB_TODO
    SEC
    LDA SCRIPT_PARTY_ATTRIBUTES[32],X
    SBC LIB_BCD/EXTRA_FILE_BCD_A
    STA ALT_STUFF_COUNT?
    BEQ L_17:1ED3
    BCS L_17:1ED7
L_17:1ED3: ; 17:1ED3, 0x02FED3
    LDA #$01
    STA ALT_STUFF_COUNT?
L_17:1ED7: ; 17:1ED7, 0x02FED7
    LDA #$00
    STA BATTLE_ARRAY_UNK+1
    SEC
    LDA SCRIPT_PARTY_ATTRIBUTES[32],X
    SBC ALT_STUFF_COUNT?
    STA BATTLE_ARRAY_UNK[4]
    BEQ L_17:1EEF
    BCC L_17:1EEF
    LDA ALT_STUFF_COUNT?
    STA SCRIPT_PARTY_ATTRIBUTES[32],X
    RTS
L_17:1EEF: ; 17:1EEF, 0x02FEEF
    JMP CLEAR_BATTLE_UNK
DEEPER_SUB_UNK: ; 17:1EF2, 0x02FEF2
    JSR EVEN_DEEPER_SUB_TODO
    LDA LIB_BCD2/EXTRA_FILE_STREAM_INDEX
    STA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2]
    LDA LIB_BCD/EXTRA_FILE_D
    STA SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER+1
    JMP L_17:1DEB
L_17:1F00: ; 17:1F00, 0x02FF00
    TXA
    PHA
    JSR EVEN_DEEPER_SUB_TODO
    PLA
    TAX
    LDA LIB_BCD2/EXTRA_FILE_STREAM_INDEX
    STA LIB_BCD/EXTRA_FILE_BCD_A
    LDA LIB_BCD/EXTRA_FILE_D
    STA LIB_BCD/EXTRA_FILE_BCD_B
    JSR SCRIPT_HARD_SWITCH_TO_SOMETHING_HUGE
    JMP L_17:1DE8
L_17:1F15: ; 17:1F15, 0x02FF15
    TXA
    PHA
    JSR EVEN_DEEPER_SUB_TODO
    PLA
    TAX
    LDA LIB_BCD/EXTRA_FILE_D
    LSR A
    STA LIB_BCD/EXTRA_FILE_BCD_B
    LDA LIB_BCD2/EXTRA_FILE_STREAM_INDEX
    ROR A
    STA LIB_BCD/EXTRA_FILE_BCD_A
    JSR SCRIPT_HARD_SWITCH_TO_SOMETHING_HUGE
    JMP L_17:1E72
EVEN_DEEPER_SUB_TODO: ; 17:1F2C, 0x02FF2C
    LDA PARTY_ATTR_PTR[2],X ; Move ??
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
L_17:1F58: ; 17:1F58, 0x02FF58
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS
    LDA SCRIPT_PARTY_ATTRIBUTES+13,Y
    TAX
    LDY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    LDA SCRIPT_PARTY_ATTRIBUTES+14,Y
    JMP L_17:1F8C
L_17:1F66: ; 17:1F66, 0x02FF66
    LDY SCRIPT_BATTLE_PARTY_ID_FOCUS
    LDA SCRIPT_PARTY_ATTRIBUTES+13,Y
    TAX
    LDY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL?
    LDA SCRIPT_PARTY_ATTRIBUTES+15,Y
    JMP L_17:1F8C
L_17:1F74: ; 17:1F74, 0x02FF74
    LDA SCRIPT_PARTY_ATTRIBUTES+2,Y
    AND R_**:$0057
    BEQ L_17:1F87
    LSR LIB_BCD/EXTRA_FILE_BCD_B
    ROR LIB_BCD/EXTRA_FILE_BCD_A
    LDA LIB_BCD/EXTRA_FILE_BCD_A
    ORA LIB_BCD/EXTRA_FILE_BCD_B
    BNE L_17:1F87
    INC LIB_BCD/EXTRA_FILE_BCD_A
L_17:1F87: ; 17:1F87, 0x02FF87
    LDA #$00
    STA R_**:$0057
    RTS
L_17:1F8C: ; 17:1F8C, 0x02FF8C
    LSR A
    STA LIB_BCD/EXTRA_FILE_BCD_A
    STX SAVE_GAME_MOD_PAGE_PTR/MATH_HELPER[2]
    TXA
    SEC
    SBC LIB_BCD/EXTRA_FILE_BCD_A
    BCS L_17:1F99
    LDA #$00
L_17:1F99: ; 17:1F99, 0x02FF99
    STA LIB_BCD/EXTRA_FILE_BCD_B
    LDA #$00
    STA LIB_BCD/EXTRA_FILE_BCD_A
    STA LIB_BCD2/EXTRA_FILE_STREAM_INDEX
    JSR ENGINE_MATH_24BIT_DIVIDE?
    JSR RANDOMIZE_GROUP_A
    CMP LIB_BCD/EXTRA_FILE_BCD_A
    RTS
PARTY_FOCUS_NO_ATTRS_SET_UNK: ; 17:1FAA, 0x02FFAA
    JSR SCRIPT_ENEMY_FOCUS_INDEX_PTR_TO_NEXT_SLOT/DATA ; Do ??
    LDY #$00 ; Seed index.
VAL_NE_0x8: ; 17:1FAF, 0x02FFAF
    TYA ; Y to stack.
    PHA
    LDA [LIB_BCD/EXTRA_FILE_BCD_A],Y ; Load from file.
    BEQ DO_ITERATION ; == 0, goto.
    JSR SCRIPT_BATTLE_HELPER_PTR_CREATE_UNK_SIZE_0x8 ; Do ptr.
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
CLEAR_BATTLE_UNK: ; 17:1FD8, 0x02FFD8
    LDA #$00 ; Load ??
    STA BATTLE_ARRAY_UNK[4] ; Clear ??
    STA BATTLE_ARRAY_UNK+1
    CLC ; Ret CC.
    RTS
L_17:1FE2: ; 17:1FE2, 0x02FFE2
    LDA SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL? ; Load ??
    BPL EXIT_RET_CC_GOOD? ; Positive, goto.
L_17:1FE6: ; 17:1FE6, 0x02FFE6
    LDA 56_OBJECT_NAME_SIZE? ; Load ??
    LSR A ; >> 1, /2.
    BNE EXIT_RET_CS_BAD? ; != 0, goto.
EXIT_RET_CC_GOOD?: ; 17:1FEB, 0x02FFEB
    CLC ; Ret CC, found/good.
    RTS
EXIT_RET_CS_BAD?: ; 17:1FED, 0x02FFED
    SEC ; Ret CS, fail.
    RTS
L_17:1FEF: ; 17:1FEF, 0x02FFEF
    LDY SCRIPT_BATTLE_PARTY_ID_ATTR_COMMITTING/FOCUS_SPECIAL? ; Load focus?
    BMI RET_CC ; Negative, goto.
    LDA SCRIPT_PARTY_ATTRIBUTES+17,Y ; Load ??
    CMP #$06 ; If _ #$06
    BNE RET_CC ; !=, goto, ret CC.
    SEC ; Ret CS. TODO: Good/bad.
    RTS
RET_CC: ; 17:1FFC, 0x02FFFC
    CLC ; Ret CC. TODO: Good/bad.
    RTS
    .db FF ; 2 Bytes total unused. Wowza.
    .db FF
