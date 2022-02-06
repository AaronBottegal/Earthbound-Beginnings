    LDA #$05
    STA **:$07F1
    LDA CURRENT_SAVE_MANIPULATION_PAGE+542
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    LDY #$F0
    LDA #$A5
    LSR ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    BCC 13:0014
    LDA #$96
    STA **:$0600,Y
    INY
    CPY #$F8
    BCC 13:000C
    LDA #$00
    STA **:$0600,Y
    LDX #$00
    JSR 1E:19F1
    BCS 13:0084
    JSR CREATE_PTR_UNK
    TXA
    PHA
    LDY #$3F
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    STA **:$0600,Y
    DEY
    BPL 13:002F
    LDX #$80
    LDY #$28
    LDA **:$0600,Y
    STA **:$0029
    JSR $A08F
    INY
    CPY #$2C
    BCC 13:003B
    JSR 1E:03E6
    LDA #$F5
    LDX #$A0
    JSR $AC44
    LDA #$C0
    STA **:$0029
    JSR $A0B3
    LDA #$19
    LDX #$A1
    STA FPTR_SPRITES?[2]
    STX FPTR_SPRITES?+1
    JSR MENU_SELECTION
    BIT **:$0083
    BVS 13:008B
    LDA FPTR_UNK_84_MENU_SELECTION?
    BEQ 13:0082
    JSR $A0B3
    BCS 13:0074
    JSR $A0B3
    LDX #$0A
    LDY #$03
    STX PACKET_HPOS_COORD?
    STY PACKET_YPOS_COORD?
    JSR 1F:0F7C
    JMP $A064
    PLA
    TAX
    INX
    CPX #$04
    BCC 13:0023
    BCS 13:0021
    PLA
    JMP LIB_UNK
    TYA
    PHA
    TXA
    PHA
    JSR $BBDF
    LDY #$00
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    STA SAVE_GAME_MOD_PAGE_PTR[2]
    INY
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    STA SAVE_GAME_MOD_PAGE_PTR+1
    PLA
    TAX
    LDY #$00
    LDA [SAVE_GAME_MOD_PAGE_PTR[2]],Y
    STA **:$0600,X
    INX
    INY
    CPY #$10
    BCC 13:00A5
    PLA
    TAY
    RTS
    LDX #$40
    STX ARR_BITS_TO_UNK[8]
    JSR 1E:1CCD
    LDX ARR_BITS_TO_UNK[8]
    AND **:$0600,Y
    BEQ 13:00C4
    JSR $A08F
    INC **:$0029
    BNE 13:00E1
    LDA #$C0
    STA **:$0029
    CPX #$41
    BCS 13:00DB
    RTS
    LDA #$00
    STA **:$0600,X
    CLC
    TXA
    ADC #$10
    TAX
    CPX #$80
    BCC 13:00D1
    BCS 13:00E5
    CPX #$80
    BCC 13:00B5
    LDA #$FE
    LDX #$A0
    STA FPTR_PACKET_CREATION[2]
    STX FPTR_PACKET_CREATION+1
    JSR ENGINE_CREATE_UPDATE_BUF_INIT_DEC?
    CMP #$00
    BNE 13:00ED
    RTS
    .db 20
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
    LDA #$80
    BIT **:$00D4
    BNE 13:0167
    LDX **:$00D2
    LDY **:$00D1
    CPX #$06
    BCC 13:0167
    CPY #$90
    BCC 13:0167
    ORA **:$00D4
    STA **:$00D4
    LDA #$2F
    JSR ENGINE_UNK
    LDX #$7C
    JSR $A445
    LDX #$7E
    JSR $A445
    LDX #$80
    JSR $A445
    LDA #$37
    STA **:$002C
    JSR $ADC1
    BIT **:$0083
    BVS 13:0168
    LDA FPTR_UNK_84_MENU_SELECTION?
    BEQ 13:0168
    JSR $BE57
    LDX #$86
    JSR $A445
    JMP $AC4B
    RTS
    LDX #$82
    JSR $A445
    LDX #$84
    JSR $A445
    JSR $AB30
    JMP LIB_UNK
    LDA #$05
    STA **:$07F1
    JSR 1E:026C
    LDA #$B0
    LDX #$A1
    STA FPTR_SPRITES?[2]
    STX FPTR_SPRITES?+1
    JSR MENU_SELECTION
    BIT **:$0083
    BMI 13:0192
    JMP LIB_UNK
    LDA #$FF
    JSR ENGINE_POS_TO_UPDATE_UNK
    LDA FPTR_UNK_84_MENU_SELECTION?
    ASL A
    TAX
    LDA $A1A5,X
    PHA
    LDA $A1A4,X
    PHA
    RTS
    .db E9
    .db A1
    .db 0E
    .db A2
    .db 61
    .db A2
    .db 04
    .db A0
    .db 37
    .db A2
    .db B9
    .db A1
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
    JSR ENGINE_SCRIPT_LAUNCH_R7_A_PTR_XY
    JMP LIB_UNK
    JSR 1F:0266
    BCS 13:01E4
    JSR $A9C7
    BEQ 13:01E9
    ASL A
    ASL A
    BCC 13:01E9
    AND #$3C
    BEQ 13:01E9
    LDA #$35
    STA **:$0034
    JSR $AB0F
    BCS 13:01E9
    JMP LIB_UNK
    JSR $AB48
    BCC 13:01E1
    RTS
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
    JMP LIB_UNK
    JSR 1F:020F
    JSR $A9C7
    BNE 13:021D
    JSR $A9D6
    JMP LIB_UNK
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
    JMP LIB_UNK
    JSR $B8E6
    BCC 13:0240
    JMP LIB_UNK
    JSR $A92D
    LDY #$07
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    STA **:$0043
    SEC
    LDY #$16
    LDA [FPTR_SPRITES?[2]],Y
    SBC **:$0043
    INY
    LDA [FPTR_SPRITES?[2]],Y
    SBC #$00
    BCC 13:025D
    JSR $A3BC
    JMP $A90C
    LDX #$10
    JMP $A909
    JSR 13:17B6
    BCC 13:026A
    JMP LIB_UNK
    JSR 1E:03C7
    JSR $A964
    JSR $A972
    BEQ 13:0281
    LDA **:$0029
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
    BIT **:$0083
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
    LDA FPTR_UNK_84_MENU_SELECTION?
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
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    BNE 13:02F1
    LDY #$02
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    AND #$3F
    BEQ 13:02E1
    LDX **:$0028
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
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE+2
    LDY #$02
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    LDX **:$0028
    AND $AA74,X
    BEQ 13:0310
    JSR $BC3A
    BCS 13:0310
    LDX #$1C
    JSR $A445
    LDA #$04
    STA **:$07F3
    JMP $A90C
    LDX #$1E
    JMP $A909
    LDX **:$6707
    DEX
    BEQ 13:0375
    LDA **:$0029
    CMP #$03
    BEQ 13:0365
    JSR $AA4E
    BCS 13:037A
    JSR $A979
    BCS 13:036A
    JSR $A9A3
    CMP **:$0042
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
    LDA **:$0028
    CMP **:$0042
    BEQ 13:0356
    LDX #$28
    JMP $A909
    LDX #$0C
    JMP $A909
    JMP $A26A
    LDY #$02
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
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
    LDA **:$0029
    ADC #$E8
    STA FPTR_PACKET_CREATION[2]
    LDA #$00
    ADC #$03
    STA RTN_ARG_UNK
    JSR $AD1A
    JMP $A90C
    LDY #$04
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
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
    JSR $AA7C
    JMP $AD1A
    JSR $AA7C
    JMP $AD29
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
    JSR ENGINE_ENABLE_WRAM_WITH_WRITES
    LDA #$0A
    STA CURRENT_SAVE_MANIPULATION_PAGE+25
    JSR ENGINE_ENABLE_WRAM_NO_WRITES
    LDX #$16
    JMP $A445
    JSR $A990
    JSR ENGINE_ENABLE_WRAM_WITH_WRITES
    LDY #$2C
    LDA [FPTR_SPRITES?[2]],Y
    STA **:$73D8,Y
    INY
    CPY #$30
    BCC 13:0480
    JSR ENGINE_ENABLE_WRAM_NO_WRITES
    LDA #$40
    STA ENGINE_FLAG_20_SETUP_UNK
    LDA #$01
    STA SWITCH_INIT_PORTION?
    LDX #$48
    JMP $A445
    LDA FPTR_UNK_84_MENU_SELECTION?
    BNE 13:04CA
    LDA #$03
    JSR $B058
    BCC 13:04C5
    LDA **:$0029
    JSR $B058
    JSR ENGINE_ENABLE_WRAM_WITH_WRITES
    LDA #$03
    STA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    LDY #$2C
    LDA **:$73D8,Y
    STA [FPTR_SPRITES?[2]],Y
    INY
    CPY #$30
    BCC 13:04B3
    JSR ENGINE_ENABLE_WRAM_NO_WRITES
    LDX #$44
    JMP $A445
    LDX #$46
    JMP $A445
    LDA #$14
    JMP $A542
    LDA FPTR_UNK_84_MENU_SELECTION?
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
    JSR ENGINE_ENABLE_WRAM_WITH_WRITES
    DEC CURRENT_SAVE_MANIPULATION_PAGE+31
    PHP
    JSR ENGINE_ENABLE_WRAM_NO_WRITES
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
    STA **:$002A
    STY **:$002B
    JSR $AA7C
    JSR $AA4E
    BCS 13:056A
    LDA **:$002A
    BMI 13:0592
    JSR $A964
    JSR $A972
    BMI 13:056F
    JSR $A92D
    JSR $AD1A
    JSR $A9A3
    LDY #$01
    LDA [FPTR_SPRITES?[2]],Y
    AND **:$002A
    BEQ 13:0577
    JSR ENGINE_ENABLE_WRAM_WITH_WRITES
    LDA **:$002A
    PHP
    EOR #$FF
    AND [FPTR_SPRITES?[2]],Y
    STA [FPTR_SPRITES?[2]],Y
    PLP
    BPL 13:05B5
    JSR $A6E0
    JSR ENGINE_ENABLE_WRAM_NO_WRITES
    LDA #$07
    STA **:$07F1
    LDX **:$002B
    JSR $A445
    JMP $BC04
    STY **:$002A
    JSR $AA7C
    JSR $AA4E
    BCS 13:056A
    JSR $A964
    JSR $A972
    BMI 13:056F
    JSR $A92D
    JSR $AD1A
    JSR $A9A3
    LDY **:$002A
    LDA #$05
    JSR $A912
    CLC
    LDA [FPTR_SPRITES?[2]],Y
    ADC **:$002A
    STA SAVE_GAME_MOD_PAGE_PTR[2]
    BCC 13:05F7
    CLC
    LDA **:$002A
    SBC SAVE_GAME_MOD_PAGE_PTR[2]
    STA **:$002A
    JSR ENGINE_ENABLE_WRAM_WITH_WRITES
    CLC
    LDA [FPTR_SPRITES?[2]],Y
    ADC **:$002A
    STA [FPTR_SPRITES?[2]],Y
    JSR ENGINE_ENABLE_WRAM_NO_WRITES
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
    STA **:$002A
    STY **:$002B
    JSR $AA4E
    BCS 13:0659
    JSR $A9B1
    LDX #$0E
    JSR $A445
    JSR $A92D
    LDA **:$002A
    BMI 13:067E
    JSR $A972
    BMI 13:065E
    JMP $A59B
    LDY #$14
    JSR $A6A5
    LDY #$03
    JSR $A6B4
    JSR ENGINE_ENABLE_WRAM_WITH_WRITES
    LDY #$14
    JSR $A6D1
    JSR ENGINE_ENABLE_WRAM_NO_WRITES
    LDA #$07
    STA **:$07F1
    LDX #$34
    JSR $A445
    LDX #$30
    JMP $A44B
    CLC
    LDA [FPTR_SPRITES?[2]],Y
    ADC **:$002A
    STA SAVE_GAME_MOD_PAGE_PTR[2]
    INY
    LDA [FPTR_SPRITES?[2]],Y
    ADC **:$002B
    STA SAVE_GAME_MOD_PAGE_PTR+1
    RTS
    SEC
    LDA [FPTR_SPRITES?[2]],Y
    SBC SAVE_GAME_MOD_PAGE_PTR[2]
    STA ARR_BITS_TO_UNK[8]
    INY
    LDA [FPTR_SPRITES?[2]],Y
    SBC SAVE_GAME_MOD_PAGE_PTR+1
    STA ARR_BITS_TO_UNK+1
    BCS 13:06D0
    LDA **:$002A
    ADC ARR_BITS_TO_UNK[8]
    STA **:$002A
    LDA **:$002B
    ADC ARR_BITS_TO_UNK+1
    STA **:$002B
    RTS
    CLC
    LDA [FPTR_SPRITES?[2]],Y
    ADC **:$002A
    STA [FPTR_SPRITES?[2]],Y
    INY
    LDA [FPTR_SPRITES?[2]],Y
    ADC **:$002B
    STA [FPTR_SPRITES?[2]],Y
    RTS
    LDY #$03
    LDA [FPTR_SPRITES?[2]],Y
    LDY #$14
    STA [FPTR_SPRITES?[2]],Y
    LDY #$04
    LDA [FPTR_SPRITES?[2]],Y
    LDY #$15
    STA [FPTR_SPRITES?[2]],Y
    LDA ENGINE_FPTR_30[2]
    PHA
    LDA ENGINE_FPTR_30+1
    PHA
    JSR 1E:18D3
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
    JSR ENGINE_UNK
    JSR 1E:1977
    JSR ENGINE_ENABLE_WRAM_WITH_WRITES
    PLA
    STA ENGINE_FPTR_30+1
    PLA
    STA ENGINE_FPTR_30[2]
    RTS
    LDA **:$0028
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
    JSR ENGINE_ENABLE_WRAM_WITH_WRITES
    LDY #$16
    JSR $A6D1
    JSR ENGINE_ENABLE_WRAM_NO_WRITES
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
    JSR ENGINE_ENABLE_WRAM_WITH_WRITES
    LDX #$03
    LDA $A803,X
    STA CURRENT_SAVE_MANIPULATION_PAGE+4,X
    DEX
    BPL 13:07E7
    JSR 1E:19FA
    JSR 1E:18CE
    LDA #$02
    STA SWITCH_INIT_PORTION?
    LDA #$40
    STA ENGINE_FLAG_20_SETUP_UNK
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
    JSR ENGINE_UNK
    LDX #$72
    JMP $A445
    PLA
    PLA
    LDX #$78
    JSR $A445
    JMP $A834
    LDA #$05
    STA **:$07F1
    LDA **:$0014
    CMP #$01
    BEQ 13:0843
    CMP #$02
    BEQ 13:0843
    LDX #$7A
    JMP $A909
    JSR $AB30
    JSR ENGINE_PALETTE_FADE_OUT?
    JSR SETTLE_SPRITES_OFFSCREEN/CLEAR_RAM
    LDX #$00
    LDY #$08
    JSR 1F:0ECC
    LDA #$06
    ORA ENGINE_PPU_MASK_COPY
    STA ENGINE_PPU_MASK_COPY
    LDA #$5B
    LDX #$02
    JSR ENGINE_SET_MAPPER_BANK_X_VAL_A
    JSR PPU_READ_INTO_$0110_HELPER_LOOP_UNK
    LDA #$E3
    LDX #$A8
    JSR ENGINE_SET_GFX_BANKS_FPTR_AX
    LDA #$DF
    STA SPRITE_PAGE+1
    LDA #$00
    STA SPRITE_PAGE+2
    LDX #$40
    LDA **:$6785
    JSR $A8D4
    SBC #$08
    STA SPRITE_PAGE+3
    LDX #$80
    LDA **:$6787
    JSR $A8D4
    SBC #$21
    STA SPRITE_PAGE[256]
    LDA #$E9
    LDX #$A8
    JSR ENGINE_SETTLE_AND_PALETTE_FROM_PTR
    LDA #$00
    STA CONTROL_ACCUMULATED?[2]
    LDX #$08
    JSR ENGINE_DELAY_X_FRAMES
    LDA #$DF
    EOR SPRITE_PAGE+1
    STA SPRITE_PAGE+1
    BIT CONTROL_ACCUMULATED?[2]
    BVC 13:0899
    LDA #$00
    STA CONTROL_ACCUMULATED?[2]
    LDA #$F0
    STA SPRITE_PAGE[256]
    JSR ENGINE_SETTLE_UPDATES?
    JSR 1F:0DDF
    JSR ENGINE_PALETTE_SCRIPT_TO_UPLOADED
    LDA #$F9
    AND ENGINE_PPU_MASK_COPY
    STA ENGINE_PPU_MASK_COPY
    LDA #$7E
    LDX #$04
    JSR ENGINE_SET_MAPPER_BANK_X_VAL_A
    LDA #$00
    STA **:$07F7
    JSR SETTLE_SPRITES_OFFSCREEN/CLEAR_RAM
    JMP ENGINE_SETTLE_UPDATES_TODO
    SEC
    BPL 13:08E2
    TAY
    TXA
    ORA SPRITE_PAGE+2
    STA SPRITE_PAGE+2
    TYA
    SBC #$07
    RTS
    .db 00
    .db 78
    .db 58
    .db 59
    .db 5A
    .db 00
    .db 0F
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
    .db 20
    .db 45
    LDY ENGINE_FLAG_20_SETUP_UNK
    BMI 13:08BA ; TODO: Bad inst? Mistake?
    JMP LIB_UNK
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    LDA #$00
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    JSR 1F:12ED
    LDA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    STA **:$002A
    LDA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    STA **:$002B
    RTS
    LDA #$E8
    LDX #$03
    STA **:$002A
    STX **:$002B
    RTS
    JSR ENGINE_ENABLE_WRAM_WITH_WRITES
    JSR $A964
    LDA #$04
    STA **:$6D20
    CLC
    LDA FPTR_SPRITES?[2]
    ADC #$38
    STA **:$6D21
    LDA FPTR_SPRITES?+1
    ADC #$00
    STA **:$6D22
    JSR $BBDF
    LDY #$00
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    STA SAVE_GAME_MOD_PAGE_PTR[2]
    INY
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    STA SAVE_GAME_MOD_PAGE_PTR+1
    LDY #$00
    LDA [SAVE_GAME_MOD_PAGE_PTR[2]],Y
    STA **:$6D24,Y
    INY
    CMP #$00
    BNE 13:0957
    JMP ENGINE_ENABLE_WRAM_NO_WRITES
    LDA **:$0028
    JSR CREATE_PTR_UNK
    LDA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    STA FPTR_SPRITES?[2]
    LDA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    STA FPTR_SPRITES?+1
    RTS
    LDY #$01
    LDA [FPTR_SPRITES?[2]],Y
    AND #$F0
    RTS
    LDA #$00
    JSR $B058
    BCS 13:09A1
    JSR ENGINE_ENABLE_WRAM_WITH_WRITES
    LDA **:$0029
    STA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    CLC
    JMP ENGINE_ENABLE_WRAM_NO_WRITES
    JSR $B0A3
    BNE 13:09A1
    LDA **:$0029
    JSR $B058
    BCS 13:09A1
    JSR ENGINE_ENABLE_WRAM_WITH_WRITES
    JSR $B07E
    CLC
    JMP ENGINE_ENABLE_WRAM_NO_WRITES
    SEC
    RTS
    LDA **:$0028
    PHA
    LDA **:$0042
    STA **:$0028
    JSR $A990
    PLA
    STA **:$0028
    RTS
    JSR ENGINE_ENABLE_WRAM_WITH_WRITES
    SEC
    LDY #$16
    LDA [FPTR_SPRITES?[2]],Y
    SBC **:$0043
    STA [FPTR_SPRITES?[2]],Y
    INY
    LDA [FPTR_SPRITES?[2]],Y
    SBC #$00
    STA [FPTR_SPRITES?[2]],Y
    JMP ENGINE_ENABLE_WRAM_NO_WRITES
    TAY
    BEQ 13:09D3
    TAX
    LDY #$00
    LDA [ENGINE_FPTR_30[2]],Y
    AND #$3F
    TAY
    TXA
    CPY #$20
    RTS
    JSR $AB3E
    JSR 1F:0772
    AND LUT_INDEX_TO_BITS_0x80-0x01,X
    BNE 13:09FD
    LDA #$04
    JSR 1F:02C2
    LDX #$66
    JSR $A445
    LDA #$0A
    STA **:$07F1
    LDY #$06
    LDA [ENGINE_FPTR_32[2]],Y
    AND #$7F
    STA **:$0029
    BNE 13:0A05
    JSR $AA3F
    LDX #$76
    JSR $A445
    JMP $AB30
    JSR $BB8C
    LDX #$68
    JSR $A445
    LDX #$00
    JSR 1E:19F1
    BCS 13:0A1F
    STA **:$0028
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
    STA **:$07F1
    JMP $AB30
    JSR ENGINE_ENABLE_WRAM_WITH_WRITES
    JSR 1F:0772
    ORA LUT_INDEX_TO_BITS_0x80-0x01,X
    STA CURRENT_SAVE_MANIPULATION_PAGE+544,Y
    JMP ENGINE_ENABLE_WRAM_NO_WRITES
    LDA **:$0028
    STA **:$0042
    LDA **:$6707
    CMP #$02
    BCC 13:0A6A
    LDA FPTR_PACKET_CREATION[2]
    PHA
    LDA RTN_ARG_UNK
    PHA
    JSR $B763
    PLA
    STA RTN_ARG_UNK
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
    .db BD
    .db 87
    .db AA
    .db 85
    .db 74
    .db BD
    .db 88
    .db AA
    .db 85
    .db 73
    .db 60
    .db 00
    .db 00
    .db 85
    .db 03
    .db 86
    .db 03
    .db 87
    .db 03
    .db 00
    .db 00
    .db D7
    .db 03
    .db DB
    .db 03
    .db C7
    .db 06
    .db C8
    .db 06
    .db D0
    .db 06
    .db C9
    .db 06
    .db 8E
    .db 03
    .db 8F
    .db 03
    .db 90
    .db 03
    .db 91
    .db 03
    .db 92
    .db 03
    .db 93
    .db 03
    .db 94
    .db 03
    .db 95
    .db 03
    .db 96
    .db 03
    .db 97
    .db 03
    .db 98
    .db 03
    .db AF
    .db 06
    .db B0
    .db 06
    .db B1
    .db 06
    .db B2
    .db 06
    .db B3
    .db 06
    .db B4
    .db 06
    .db B5
    .db 06
    .db B6
    .db 06
    .db B7
    .db 06
    .db B8
    .db 06
    .db B9
    .db 06
    .db BA
    .db 06
    .db BB
    .db 06
    .db BC
    .db 06
    .db BD
    .db 06
    .db BE
    .db 06
    .db A7
    .db 06
    .db A8
    .db 06
    .db A5
    .db 06
    .db AA
    .db 06
    .db A9
    .db 06
    .db C1
    .db 06
    .db A6
    .db 06
    .db C3
    .db 06
    .db C4
    .db 06
    .db C5
    .db 06
    .db C6
    .db 06
    .db BF
    .db 06
    .db C0
    .db 06
    .db 99
    .db 03
    .db 9A
    .db 03
    .db 9B
    .db 03
    .db CB
    .db 06
    .db 9D
    .db 03
    .db CC
    .db 06
    .db CD
    .db 06
    .db CA
    .db 06
    .db A1
    .db 03
    .db CF
    .db 06
    .db CE
    .db 06
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
    JSR 13:0B3E
    LDY #$14
    LDA [ENGINE_FPTR_30[2]],Y
    AND #$0F
    TAY
    LDA [ENGINE_FPTR_32[2]],Y
    BEQ 13:0B23
    JSR $AB5E
    JMP $AB19
    LDA **:$0021
    BEQ 13:0B30
    JSR 1F:0266
    LDA #$40
    STA **:$0034
    BNE 13:0B0F
    LDA **:$002C
    BEQ 13:0B3C
    LDA #$00
    STA **:$002C
    CLC
    JMP WAIT_ANY_BUTTONS_PRESSED_RET_PRESSED
    SEC
    RTS
    JSR 1F:0655
    LDY #$01
    LDA [ENGINE_FPTR_30[2]],Y
    JMP BANK_R6_UNK
    JSR $AB3E
    LDY #$1C
    LDA [ENGINE_FPTR_30[2]],Y
    TAY
    JMP $AB19
    JSR 1F:0266
    JSR $AB3E
    LDY **:$0035
    JMP $AB19
    ASL A
    TAX
    LDA RTN_TBL_H,X
    PHA
    LDA RTN_TBL_K,X
    PHA
    RTS
RTN_TBL_K: ; 13:0B69, 0x026B69
    .db 2F
RTN_TBL_H: ; 13:0B6A, 0x026B6A
    .db AB
    .db 87
    .db AC
    .db 8C
    .db AC
    .db B6
    .db AC
    .db B9
    .db AC
    .db 53
    .db AC
    .db 53
    .db AC
    .db 40
    .db AC
    .db 0C
    .db AD
    .db A1
    .db AD
    .db 70
    .db AC
    .db 70
    .db AC
    .db 60
    .db AC
    .db 69
    .db AC
    .db 40
    .db AC
    .db 4A
    .db AC
    .db 22
    .db AE
    .db 34
    .db AE
    .db 49
    .db AE
    .db 6B
    .db AE
    .db 5D
    .db AE
    .db 79
    .db AE
    .db 89
    .db AE
    .db 8C
    .db B4
    .db AC
    .db B0
    .db 96
    .db AE
    .db BC
    .db AE
    .db 04
    .db B5
    .db E3
    .db B0
    .db 9D
    .db AE
    .db C4
    .db AE
    .db 83
    .db B4
    .db 95
    .db B1
    .db 71
    .db B1
    .db 83
    .db B1
    .db AB
    .db AF
    .db B7
    .db AF
    .db B5
    .db AE
    .db D2
    .db AE
    .db 8D
    .db AF
    .db DA
    .db AE
    .db ED
    .db AE
    .db 14
    .db AF
    .db 2E
    .db AF
    .db DB
    .db AF
    .db D0
    .db AF
    .db E9
    .db AF
    .db F4
    .db AF
    .db 0B
    .db B0
    .db 3B
    .db B0
    .db 5D
    .db AF
    .db 27
    .db B0
    .db 70
    .db AC
    .db 70
    .db AC
    .db D7
    .db B3
    .db F9
    .db AD
    .db BC
    .db B1
    .db D7
    .db B1
    .db D0
    .db B0
    .db 34
    .db B2
    .db 2A
    .db B4
    .db 1F
    .db B4
    .db 45
    .db B2
    .db 56
    .db AC
    .db 70
    .db AC
    .db EA
    .db B4
    .db 3F
    .db B4
    .db 58
    .db B4
    .db 71
    .db B4
    .db 10
    .db B5
    .db 8F
    .db B2
    .db FB
    .db B2
    .db 22
    .db B3
    .db 38
    .db B3
    .db 49
    .db B3
    .db A7
    .db B3
    .db B4
    .db B3
    .db 16
    .db B3
    .db 31
    .db B4
    .db E7
    .db B3
    .db A8
    .db B5
    .db 49
    .db B6
    .db E1
    .db B5
    .db FF
    .db B5
    .db F0
    .db B5
    .db 45
    .db B5
    .db 9F
    .db B4
    .db A8
    .db B4
    .db A9
    .db AE
    .db 28
    .db B6
    .db 94
    .db B6
    .db AB
    .db B6
    .db B3
    .db B6
    .db BB
    .db B6
    .db 40
    .db AC
    .db C3
    .db B6
    .db C8
    .db B5
    .db 3F
    .db B6
    .db FC
    .db B1
    .db 22
    .db B2
    .db DA
    .db B6
    .db E9
    .db B6
    .db 0B
    .db B7
    .db 24
    .db B7
    .db 2C
    .db B7
    .db 34
    .db B7
    .db 3E
    .db B7
    .db 50
    .db B7
LOCKUP?: ; 13:0C41, 0x026C41
    .db 4C ; JMP Self?
    .db 41
    .db AC
    STA FPTR_PACKET_CREATION[2]
    STX FPTR_PACKET_CREATION+1
    JMP ENGINE_CREATE_UPDATE_BUF_INIT_INC?
    JSR $AB30
    JSR ENGINE_PALETTE_FADE_OUT?
    JMP VECTOR_RESET
    INY
    INY
    RTS
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    CLC
    ADC #$04
    STA **:$0021
    INY
    RTS
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    CLC
    ADC #$C0
    JMP $AC6D
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    CMP **:$0029
    BNE 13:0C88
    TXA
    LSR A
    CMP **:$0034
    BNE 13:0C88
    INY
    INY
    RTS
    BCS 13:0C77
    BCC 13:0C88
    BCC 13:0C77
    BCS 13:0C88
    BNE 13:0C77
    BEQ 13:0C88
    BEQ 13:0C77
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
    STA **:$0035
    INY
    PLA
    STA ENGINE_FPTR_32+1
    PLA
    STA ENGINE_FPTR_32[2]
    TYA
    PHA
    LDY **:$0035
    JSR $AB19
    PLA
    TAY
    PLA
    STA ENGINE_FPTR_32+1
    PLA
    STA ENGINE_FPTR_32[2]
    RTS
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
    JSR FINALIZE_PACKET_PALETTE_WAIT_0x1
    LDA NMI_GFX_COUNTER
    BNE 13:0CD0
    LDA SCRIPT_R6_UNK
    LDX #$02
    JSR ENGINE_SET_MAPPER_BANK_X_VAL_A
    LDA SCRIPT_R7_UNK
    LDX #$03
    JSR ENGINE_SET_MAPPER_BANK_X_VAL_A
    JMP ENGINE_PALETTE_UPLOAD_WITH_WAIT_HELPER
    AND [SCRIPT_FLAG_0x22,X]
    ???
    BIT ENGINE_FLAG_25_SKIP_UNK
    BIT UNK_NONZERO_SKIP
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
    STA RTN_ARG_UNK
    INY
    STY **:$0035
    LDA **:$002C
    BNE 13:0D21
    JSR $BC0A
    LDA #$08
    CMP **:$002C
    BEQ 13:0D7B
    STA **:$002C
    LDY PACKET_YPOS_COORD?
    CPY #$1B
    BCC 13:0D36
    JSR $AD98
    DEC **:$002D
    BMI 13:0D84
    LDA **:$002D
    BNE 13:0D40
    LDY PACKET_YPOS_COORD?
    CPY #$19
    BCS 13:0D84
    JSR 1E:0AA2
    LDA #$16
    STA **:$0070
    LDA #$00
    STA ENGINE_PACKINATOR_ARG_SEED_0xA0_PRE_COUNT
    JSR RTN_IDFK
    JSR 1E:07AF
    CMP #$00
    BEQ 13:0D61
    LDY #$00
    LDA [FPTR_PACKET_CREATION[2]],Y
    CMP #$03
    BEQ 13:0D75
    CMP #$00
    BNE 13:0D29
    JSR $AB41
    LDA #$00
    STA **:$0070
    STA ENGINE_PACKINATOR_ARG_SEED_0xA0_PRE_COUNT
    LDY **:$0035
    SEC
    LDA PACKET_YPOS_COORD?
    SBC #$13
    LSR A
    STA **:$002D
    RTS
    INC FPTR_PACKET_CREATION[2]
    BNE 13:0D7B
    INC RTN_ARG_UNK
    LDY PACKET_YPOS_COORD?
    CPY #$1B
    BCC 13:0D84
    JSR $AD98
    JSR $AD6C
    LDA #$91
    LDX #$AD
    JSR $ADC5
    JMP $AD40
    .db 01
    .db 01
    .db 00
    .db 00
    .db C0
    .db 3B
    .db 12
    LDX #$04
    JSR 1E:07C1
    DEC PACKET_YPOS_COORD?
    DEC PACKET_YPOS_COORD?
    RTS
    STY **:$0035
    JSR $ADAE
    LDY **:$0035
    LDA FPTR_UNK_84_MENU_SELECTION?
    JMP $AC86
    LDA #$DF
    LDX #$AD
    STA FPTR_PACKET_CREATION[2]
    STX RTN_ARG_UNK
    LDA #$09
    JSR $AD27
    LDA #$EC
    LDX #$AD
    BNE 13:0DC5
    LDA #$F3
    LDX #$AD
    STA FPTR_SPRITES?[2]
    STX FPTR_SPRITES?+1
    LDY #$06
    LDA [FPTR_SPRITES?[2]],Y
    STA PACKET_HPOS_COORD?
    LDA #$D1
    LDX #$F0
    STA FPTR_UNK_84_MENU?[2]
    STX FPTR_UNK_84_MENU?+1
    JSR 1F:0F4B
    LDA #$08
    STA PACKET_HPOS_COORD?
    RTS
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
    .db 02
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
    STA RTN_ARG_UNK
    INY
    STY **:$0035
    LDA #$37
    JSR $AD27
    JSR $ADC1
    LDY **:$0035
    BIT **:$0083
    BVS 13:0E20
    LDA FPTR_UNK_84_MENU_SELECTION?
    BNE 13:0E1C
    INY
    INY
    RTS
    LDA [ENGINE_FPTR_32[2]],Y
    TAY
    RTS
    JMP $AC88
    JSR ENGINE_ENABLE_WRAM_WITH_WRITES
    JSR $AE58
    ORA LUT_INDEX_TO_BITS_0x80-0x01,X
    STA CURRENT_SAVE_MANIPULATION_PAGE+512,Y
    LDY **:$0035
    INY
    JMP ENGINE_ENABLE_WRAM_NO_WRITES
    JSR ENGINE_ENABLE_WRAM_WITH_WRITES
    JSR $AE58
    ORA LUT_INDEX_TO_BITS_0x80-0x01,X
    EOR LUT_INDEX_TO_BITS_0x80-0x01,X
    STA CURRENT_SAVE_MANIPULATION_PAGE+512,Y
    LDY **:$0035
    INY
    JMP ENGINE_ENABLE_WRAM_NO_WRITES
    JSR $AE58
    LDY **:$0035
    AND LUT_INDEX_TO_BITS_0x80-0x01,X
    EOR LUT_INDEX_TO_BITS_0x80-0x01,X
    JMP $AC86
    INY
    STY **:$0035
    JMP 1F:0646
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    TAX
    INY
    JSR ENGINE_ENABLE_WRAM_WITH_WRITES
    INC CURRENT_SAVE_MANIPULATION_PAGE+608,X
    JMP ENGINE_ENABLE_WRAM_NO_WRITES
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    TAX
    INY
    JSR ENGINE_ENABLE_WRAM_WITH_WRITES
    DEC CURRENT_SAVE_MANIPULATION_PAGE+608,X
    JMP ENGINE_ENABLE_WRAM_NO_WRITES
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    TAX
    INY
    JSR ENGINE_ENABLE_WRAM_WITH_WRITES
    LDA #$00
    STA CURRENT_SAVE_MANIPULATION_PAGE+608,X
    JMP ENGINE_ENABLE_WRAM_NO_WRITES
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    TAX
    INY
    LDA CURRENT_SAVE_MANIPULATION_PAGE+608,X
    CMP [ENGINE_FPTR_32[2]],Y
    JMP $AC7A
    JSR $B032
    LDY **:$0035
    INY
    RTS
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    STA **:$002A
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    STA **:$002B
    INY
    RTS
    LDA CURRENT_SAVE_MANIPULATION_PAGE+16
    STA **:$002A
    LDA CURRENT_SAVE_MANIPULATION_PAGE+17
    STA **:$002B
    INY
    RTS
    JSR $AFC4
    LDY **:$0035
    INY
    RTS
    INY
    LDA **:$0028
    CMP [ENGINE_FPTR_32[2]],Y
    JMP $AC86
    SEC
    INY
    LDA **:$002A
    SBC [ENGINE_FPTR_32[2]],Y
    INY
    LDA **:$002B
    SBC [ENGINE_FPTR_32[2]],Y
    JMP $AC7A
    INY
    LDA **:$0029
    CMP [ENGINE_FPTR_32[2]],Y
    JMP $AC86
    CLC
    LDA CURRENT_SAVE_MANIPULATION_PAGE+16
    ADC **:$002A
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    LDA CURRENT_SAVE_MANIPULATION_PAGE+17
    ADC **:$002B
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    BCS 13:0F12
    BCC 13:0EFF
    SEC
    LDA CURRENT_SAVE_MANIPULATION_PAGE+16
    SBC **:$002A
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    LDA CURRENT_SAVE_MANIPULATION_PAGE+17
    SBC **:$002B
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    BCC 13:0F12
    JSR ENGINE_ENABLE_WRAM_WITH_WRITES
    LDA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    STA CURRENT_SAVE_MANIPULATION_PAGE+16
    LDA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    STA CURRENT_SAVE_MANIPULATION_PAGE+17
    JSR ENGINE_ENABLE_WRAM_NO_WRITES
    INY
    INY
    RTS
    JMP $AC88
    CLC
    LDA CURRENT_SAVE_MANIPULATION_PAGE+18
    ADC **:$002A
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    LDA CURRENT_SAVE_MANIPULATION_PAGE+19
    ADC **:$002B
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    LDA CURRENT_SAVE_MANIPULATION_PAGE+20
    ADC #$00
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE+2
    BCS 13:0F12
    BCC 13:0F47
    SEC
    LDA CURRENT_SAVE_MANIPULATION_PAGE+18
    SBC **:$002A
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    LDA CURRENT_SAVE_MANIPULATION_PAGE+19
    SBC **:$002B
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    LDA CURRENT_SAVE_MANIPULATION_PAGE+20
    SBC #$00
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE+2
    BCC 13:0F12
    JSR ENGINE_ENABLE_WRAM_WITH_WRITES
    LDA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    STA CURRENT_SAVE_MANIPULATION_PAGE+18
    LDA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    STA CURRENT_SAVE_MANIPULATION_PAGE+19
    LDA ENGINE_PALETTE_FPTR/BITS/GEN_USE+2
    STA CURRENT_SAVE_MANIPULATION_PAGE+20
    INY
    INY
    JMP ENGINE_ENABLE_WRAM_NO_WRITES
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    STA SAVE_GAME_MOD_PAGE_PTR[2]
    STY **:$0035
    LDA **:$002A
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    LDA **:$002B
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    JSR 1F:10F1
    LDA #$64
    STA SAVE_GAME_MOD_PAGE_PTR[2]
    JSR ENGINE_NUMS_UNK_MODULO?
    LDY **:$0035
    INY
    LDA ENGINE_PALETTE_FPTR/BITS/GEN_USE+2
    BNE 13:0F87
    LDA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    STA **:$002A
    LDA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    STA **:$002B
    RTS
    LDA #$FF
    STA **:$002A
    STA **:$002B
    RTS
    JSR $AFC4
    LDX #$00
    JSR 1E:19F1
    BCS 13:0FA5
    STA **:$0028
    TXA
    PHA
    LDA **:$0029
    JSR $B058
    PLA
    TAX
    BCC 13:101E
    INX
    CPX #$04
    BCC 13:0F93
    BCS 13:1023
    JSR $AFC4
    LDA **:$0029
    JSR $B058
    BCC 13:101E
    BCS 13:1023
    JSR $AFC4
    LDA **:$0029
    JSR $B063
    BCS 13:1023
    BCC 13:101E
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    STA **:$0029
    STY **:$0035
    JSR $BBC3
    JMP $BB8C
    STY **:$0035
    LDA #$00
    JSR $B058
    BCS 13:1023
    BCC 13:0FFE
    STY **:$0035
    JSR $B0A3
    PHP
    JSR $AB41
    PLP
    BNE 13:1023
    BEQ 13:0FEC
    STY **:$0035
    LDA **:$0029
    JSR $B058
    BCS 13:1023
    BCC 13:1015
    STY **:$0035
    LDA #$00
    JSR $B063
    BCS 13:1023
    JSR ENGINE_ENABLE_WRAM_WITH_WRITES
    LDA **:$0029
    STA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    LDY **:$0035
    INY
    INY
    JMP ENGINE_ENABLE_WRAM_NO_WRITES
    STY **:$0035
    LDA **:$0029
    JSR $B063
    BCS 13:1023
    JSR ENGINE_ENABLE_WRAM_WITH_WRITES
    JSR $B07E
    JSR ENGINE_ENABLE_WRAM_NO_WRITES
    LDY **:$0035
    INY
    INY
    RTS
    LDY **:$0035
    JMP $AC88
    JSR $B032
    JSR $A728
    BCC 13:101E
    BCS 13:1023
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    STA **:$0028
    STY **:$0035
    JMP $BB6F
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    STY **:$0035
    PHA
    LDA **:$0028
    JSR $B089
    PLA
    TAY
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    BEQ 13:1023
    STA **:$0029
    JSR $BBC3
    JSR $BB8C
    JMP $B01E
    PHA
    LDA **:$0028
    JSR $B089
    PLA
    LDY #$08
    BNE 13:1068
    JSR $B09A
    LDY #$50
    STY SAVE_GAME_MOD_PAGE_PTR[2]
    LDY #$00
    CMP [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    BEQ 13:1076
    INY
    CPY SAVE_GAME_MOD_PAGE_PTR[2]
    BCC 13:106C
    RTS
    CLC
    RTS
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    DEY
    STA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    INY
    INY
    CPY SAVE_GAME_MOD_PAGE_PTR[2]
    BCC 13:1078
    LDA #$00
    DEY
    STA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    RTS
    JSR CREATE_PTR_UNK
    CLC
    LDA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    ADC #$20
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    LDA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    ADC #$00
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    RTS
    LDX #$B0
    STX ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    LDX #$76
    STX ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    RTS
    JSR $BBDF
    LDY #$02
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    AND #$80
    RTS
    LDA #$18
    STA **:$002C
    LDA PACKET_HPOS_COORD?
    PHA
    LDA PACKET_YPOS_COORD?
    PHA
    STY **:$0035
    JSR $B763
    PLA
    STA PACKET_YPOS_COORD?
    PLA
    STA PACKET_HPOS_COORD?
    BCS 13:10CC
    JSR $BB6F
    LDY **:$0035
    INY
    INY
    RTS
    LDY **:$0035
    JMP $AC88
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    STY **:$0035
    TAX
    CPX #$04
    BCS 13:10CC
    LDA CURRENT_SAVE_MANIPULATION_PAGE+8,X
    BEQ 13:10CC
    STA **:$0028
    BNE 13:10C4
    STY **:$0035
    JSR $BC28
    LDX #$07
    LDA $B15E,X
    STA ARR_BITS_TO_UNK[8],X
    DEX
    BPL 13:10EB
    LDA #$66
    LDX #$B1
    STA FPTR_PACKET_CREATION[2]
    STX RTN_ARG_UNK
    LDA #$1C
    JSR $AD27
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
    STA FPTR_UNK_84_MENU_SELECTION?
    LDX #$0C
    STX PACKET_HPOS_COORD?
    JSR 1F:0F7C
    LDA **:$0083
    AND #$0C
    BEQ 13:1146
    LDX FPTR_UNK_84_MENU_SELECTION?
    LDY ARR_BITS_TO_UNK+4,X
    AND #$08
    BEQ 13:1136
    INY
    CPY #$BA
    BNE 13:113D
    LDY #$B0
    BNE 13:113D
    DEY
    CPY #$AF
    BNE 13:113D
    LDY #$B9
    TYA
    STA ARR_BITS_TO_UNK+4,X
    JSR ENGINE_POS_TO_UPDATE_UNK
    JMP $B118
    JSR 1F:11A4
    LDA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    STA **:$002A
    LDA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    STA **:$002B
    LDX #$08
    STX PACKET_HPOS_COORD?
    LDY **:$0035
    LDA #$40
    BIT **:$0083
    JMP $AC86
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
    JSR $B87F
    JMP $B1A5
    LDA #$22
    STA **:$002C
    STY **:$0035
    LDA PACKET_HPOS_COORD?
    PHA
    LDA PACKET_YPOS_COORD?
    PHA
    JSR $B814
    JMP $B1A5
    LDA #$20
    STA **:$002C
    STY **:$0035
    LDA PACKET_HPOS_COORD?
    PHA
    LDA PACKET_YPOS_COORD?
    PHA
    JSR $B7B6
    PLA
    STA PACKET_YPOS_COORD?
    PLA
    STA PACKET_HPOS_COORD?
    BCS 13:11B8
    JSR $BBC3
    JSR $BB8C
    LDY **:$0035
    INY
    INY
    RTS
    LDY **:$0035
    JMP $AC88
    STY **:$0035
    LDX #$00
    JSR 1E:19F1
    BCS 13:11D1
    TAY
    TXA
    PHA
    TYA
    JSR $B1E1
    PLA
    TAX
    BCC 13:11B3
    INX
    CPX #$04
    BCC 13:11C1
    BCS 13:11B8
    STY **:$0035
    JSR $B1E8
    BCS 13:11B8
    BCC 13:11B3
    JSR $B089
    LDY #$08
    BNE 13:11ED
    JSR $B09A
    LDY #$50
    STY SAVE_GAME_MOD_PAGE_PTR[2]
    LDY #$00
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    BNE 13:11FB
    INY
    CPY SAVE_GAME_MOD_PAGE_PTR[2]
    BCC 13:11F1
    RTS
    CLC
    RTS
    STY **:$0035
    JSR $B5C4
    JSR ENGINE_ENABLE_WRAM_WITH_WRITES
    LDY #$28
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    BEQ 13:121B
    STA CURRENT_SAVE_MANIPULATION_PAGE+640
    STY ENGINE_PALETTE_FPTR/BITS/GEN_USE+2
    JSR $BC5A
    JSR $AB41
    LDY **:$0035
    INY
    INY
    RTS
    LDY **:$0035
    JSR ENGINE_ENABLE_WRAM_NO_WRITES
    JMP $AC88
    LDA CURRENT_SAVE_MANIPULATION_PAGE+640
    BEQ 13:1220
    STA **:$0029
    STY **:$0035
    JSR $BBC3
    JSR $BB8C
    JMP $B216
    JSR ENGINE_ENABLE_WRAM_WITH_WRITES
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    STY **:$0035
    JSR STREAM_UNK
    LDY **:$0035
    INY
    JMP ENGINE_ENABLE_WRAM_NO_WRITES
    JSR ENGINE_ENABLE_WRAM_WITH_WRITES
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    PHA
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    INY
    STY **:$0035
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
    LDA **:$0035
    STA [ENGINE_FPTR_30[2]],Y
    LDA **:$6795
    ASL A
    ASL A
    ASL A
    TAX
    LDA 1F:0BF1,X
    LSR A
    LSR A
    STA **:$6799
    JSR ENGINE_ENABLE_WRAM_NO_WRITES
    PLA
    PLA
    JMP $AB23
    LDA MAPPER_BANK_VALS+1
    JSR $B29C
    LDY **:$0035
    INY
    INY
    JMP ENGINE_ENABLE_WRAM_NO_WRITES
    TAX
    STY **:$0035
    JSR ENGINE_ENABLE_WRAM_WITH_WRITES
    TXA
    EOR UNK_NONZERO_SKIP
    AND #$7F
    BNE 13:12AA
    RTS
    STX UNK_NONZERO_SKIP
    LDY #$1C
    LDA **:$0035
    STA [ENGINE_FPTR_30[2]],Y
    JSR $B2C3
    ORA #$80
    STA **:$0021
    JSR ENGINE_ENABLE_WRAM_NO_WRITES
    PLA
    PLA
    PLA
    PLA
    JMP $AB30
    SEC
    LDA ENGINE_FPTR_30[2]
    SBC #$80
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    LDA ENGINE_FPTR_30+1
    SBC #$67
    ASL ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    ROL A
    ASL ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    ROL A
    ASL ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    ROL A
    RTS
    STX **:$6796
    STY **:$6797
    STA **:$6780
    ASL A
    ASL A
    TAX
    LDA ROUTINE_ATTR_A,X
    STA **:$6788
    LDA ROUTINE_ATTR_B,X
    STA **:$6794
    LDY **:$0035
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    STA **:$6795
    STA **:$6799
    RTS
    LDA #$74
    JSR $B29C
    LDA #$09
    LDX #$FC
    LDY #$8A
    JSR $B2D8
    LDA #$0F
    STA **:$679A
    LDX #$10
    JSR 1E:0DAF
    JMP $B295
    JSR ENGINE_ENABLE_WRAM_WITH_WRITES
    LDA #$F8
    STA **:$679A
    INY
    JMP ENGINE_ENABLE_WRAM_NO_WRITES
    LDA #$74
    JSR $B29C
    LDA #$0A
    LDX #$1C
    LDY #$8B
    JSR $B2D8
    LDX #$08
    JSR 1E:0DAF
    JMP $B295
    LDA #$74
    JSR $B29C
    LDA #$0B
    LDX #$3C
    LDY #$8B
    JSR $B2D8
    JMP $B295
    STY **:$0035
    LDA #$F0
    STA UNK_NONZERO_SKIP
    LDA #$3F
    STA SCRIPT_R6_ROUTINE_SELECT
    JSR ENGINE_ENABLE_WRAM_WITH_WRITES
    LDA #$00
    STA **:$67C0
    STA **:$67E0
    LDA #$0D
    LDY #$00
    JSR $B38B
    LDA #$0E
    LDY #$20
    JSR $B38B
    SEC
    LDA **:$0029
    SBC #$8F
    STA **:$679E
    LDA #$00
    STA **:$679F
    STA **:$679A
    JSR $BBD4
    LDX #$10
    JSR 1E:0DAF
    LDY **:$0035
    INY
    JMP ENGINE_ENABLE_WRAM_NO_WRITES
    STA **:$6780,Y
    ASL A
    ASL A
    TAX
    LDA #$28
    STA **:$6796,Y
    LDA #$8A
    STA **:$6797,Y
    LDA ROUTINE_ATTR_A,X
    STA **:$6788,Y
    LDA ROUTINE_ATTR_B,X
    STA **:$6794,Y
    RTS
    LDA #$F2
    JSR $B29C
    LDA #$0F
    JSR $B2DE
    JMP $B295
    INY
    STY **:$0035
    LDA [ENGINE_FPTR_32[2]],Y
    ORA #$80
    STA ENGINE_FLAG_20_SETUP_UNK
    LDX #$00
    STX UNK_NONZERO_SKIP
    JSR 1E:0DAF
    LDA ENGINE_FPTR_30[2]
    PHA
    LDA ENGINE_FPTR_30+1
    PHA
    JSR HUGE_ASS_STREAMS_THINGY_IDFK
    PLA
    STA ENGINE_FPTR_30+1
    PLA
    STA ENGINE_FPTR_30[2]
    LDY **:$0035
    INY
    RTS
    STY **:$0035
    LDY #$02
    LDA [ENGINE_FPTR_32[2]],Y
    AND #$3F
    LDY **:$0035
    CMP **:$6795
    JMP $AC86
    STY **:$0035
    LDY #$00
    LDA [ENGINE_FPTR_32[2]],Y
    AND #$C0
    LDY #$04
    CMP [ENGINE_FPTR_30[2]],Y
    BNE 13:141B
    LDY #$01
    LDA [ENGINE_FPTR_32[2]],Y
    LDY #$05
    CMP [ENGINE_FPTR_30[2]],Y
    BNE 13:141B
    LDY #$02
    LDA [ENGINE_FPTR_32[2]],Y
    AND #$C0
    LDY #$06
    CMP [ENGINE_FPTR_30[2]],Y
    BNE 13:141B
    LDY #$03
    LDA [ENGINE_FPTR_32[2]],Y
    LDY #$07
    CMP [ENGINE_FPTR_30[2]],Y
    BNE 13:141B
    LDY **:$0035
    INY
    INY
    RTS
    LDY **:$0035
    JMP $AC88
    JSR ENGINE_ENABLE_WRAM_WITH_WRITES
    INY
    JSR 1F:06A1
    INY
    JMP ENGINE_ENABLE_WRAM_NO_WRITES
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    STA SWITCH_INIT_PORTION?
    INY
    RTS
    STY **:$0035
    JSR ENGINE_ENABLE_WRAM_WITH_WRITES
    JSR 1E:19FA
    LDY **:$0035
    INY
    JMP ENGINE_ENABLE_WRAM_NO_WRITES
    JSR $B032
    LDA ENGINE_FPTR_30[2]
    PHA
    LDA ENGINE_FPTR_30+1
    PHA
    LDA **:$0028
    JSR 1E:1759
    PLA
    STA ENGINE_FPTR_30+1
    PLA
    STA ENGINE_FPTR_30[2]
    LDY **:$0035
    JMP $AC7E
    JSR $B032
    LDA ENGINE_FPTR_30[2]
    PHA
    LDA ENGINE_FPTR_30+1
    PHA
    LDA **:$0028
    JSR 1E:178D
    PLA
    STA ENGINE_FPTR_30+1
    PLA
    STA ENGINE_FPTR_30[2]
    LDY **:$0035
    JMP $AC7E
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    STA R_**:$0048
    JSR $B2C3
    STA **:$0021
    INY
    STY **:$0035
    PLA
    PLA
    JMP $AB30
    STY **:$0035
    JSR $BC28
    LDY **:$0035
    INY
    RTS
    JSR ENGINE_ENABLE_WRAM_WITH_WRITES
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    AND #$3F
    TAX
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    STA CURRENT_SAVE_MANIPULATION_PAGE[768],X
    INY
    JMP ENGINE_ENABLE_WRAM_NO_WRITES
    STY **:$0035
    JSR $BE57
    LDY **:$0035
    INY
    RTS
    STY **:$0035
    JSR $B5C4
    LDY #$10
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    JSR 1E:1B40
    JSR $B5C4
    LDY #$11
    SEC
    LDA SAVE_GAME_MOD_PAGE_PTR[2]
    SBC [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    STA **:$002A
    INY
    LDA SAVE_GAME_MOD_PAGE_PTR+1
    SBC [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    STA **:$002B
    JSR $AB41
    JSR ENGINE_ENABLE_WRAM_WITH_WRITES
    LDX #$03
    LDA CURRENT_SAVE_MANIPULATION_PAGE+4,X
    STA CURRENT_SAVE_MANIPULATION_PAGE+12,X
    DEX
    BPL 13:14D0
    LDA #$00
    STA CURRENT_SAVE_MANIPULATION_PAGE+21
    STA CURRENT_SAVE_MANIPULATION_PAGE+22
    STA CURRENT_SAVE_MANIPULATION_PAGE+23
    JSR ENGINE_ENABLE_WRAM_NO_WRITES
    LDY **:$0035
    INY
    RTS
    JSR ENGINE_ENABLE_WRAM_WITH_WRITES
    LDX #$03
    LDA CURRENT_SAVE_MANIPULATION_PAGE+12,X
    STA CURRENT_SAVE_MANIPULATION_PAGE+4,X
    DEX
    BPL 13:14F0
    LDA #$20
    STA ENGINE_FLAG_20_SETUP_UNK
    LDA #$00
    STA SCRIPT_FLAG_0x22
    INY
    JMP ENGINE_ENABLE_WRAM_NO_WRITES
    LDA CURRENT_SAVE_MANIPULATION_PAGE+21
    ORA CURRENT_SAVE_MANIPULATION_PAGE+22
    ORA CURRENT_SAVE_MANIPULATION_PAGE+23
    JMP $AC82
    STY **:$0035
    LDA **:$002A
    STA SAVE_GAME_MOD_PAGE_PTR[2]
    LDA **:$002B
    STA SAVE_GAME_MOD_PAGE_PTR+1
    LDX #$01
    JSR 1E:19F1
    BCS 13:153D
    JSR CREATE_PTR_UNK
    LDY #$01
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    BMI 13:153D
    CLC
    LDA SAVE_GAME_MOD_PAGE_PTR[2]
    ADC **:$002A
    STA **:$002A
    LDA SAVE_GAME_MOD_PAGE_PTR+1
    ADC **:$002B
    STA **:$002B
    BCC 13:153D
    JSR $AF87
    INX
    CPX #$04
    BCC 13:151D
    LDY **:$0035
    INY
    RTS
    STY **:$0035
    LDX #$3C
    JSR ENGINE_DELAY_X_FRAMES
    JSR ENGINE_PALETTE_FADE_OUT?
    JSR $B561
    JSR $BC0A
    LDA #$55
    STA **:$002C
    JSR ENGINE_PALETTE_FORWARD_TO_TARGET
    LDY **:$0035
    INY
    RTS
ENGINE_IDK: ; 13:1561, 0x027561
    JSR ENGINE_ENABLE_WRAM_WITH_WRITES ; Do with writes.
    LDX #$00 ; Count loops.
LOOP_LT: ; 13:1566, 0x027566
    LDA CURRENT_SAVE_MANIPULATION_PAGE+8,X ; Load save offset.
    BEQ SAVE_OFFSET_EQ_0x00 ; == 0, goto.
    JSR CREATE_PTR_UNK ; Create ptr.
    LDY #$01 ; Seed index.
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y ; Load from PTR.
    BMI SAVE_OFFSET_EQ_0x00 ; If negative, goto.
    JSR STREAM_EXPAND_0x03->0x14_0x4->0x15 ; Alt A.
    JSR STREAM_EXPAND_0x05->0x16_0x06->0x17 ; Alt B.
SAVE_OFFSET_EQ_0x00: ; 13:157A, 0x02757A
    INX ; ++
    CPX #$04 ; If _ #$04
    BCC LOOP_LT ; <, goto.
    JSR ENGINE_ENABLE_WRAM_NO_WRITES ; Re-disable.
    LDA #$20 ; Val ??
    JMP ENGINE_UNK ; Goto.
STREAM_EXPAND_0x03->0x14_0x4->0x15: ; 13:1587, 0x027587
    LDY #$03
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    LDY #$14
    STA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    LDY #$04
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    LDY #$15
    STA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    RTS
STREAM_EXPAND_0x05->0x16_0x06->0x17: ; 13:1598, 0x027598
    LDY #$05
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    LDY #$16
    STA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    LDY #$06
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    LDY #$17
    STA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    RTS
    JSR $B5C2
    SEC
    LDY #$14
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    LDY #$03
    SBC [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    LDY #$15
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    LDY #$04
    SBC [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    LDY **:$0035
    JMP $AC7A
    STY **:$0035
    LDA **:$0028
    JMP CREATE_PTR_UNK
    JSR $B5C2
    SEC
    LDY #$16
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    LDY #$05
    SBC [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    LDY #$17
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    LDY #$06
    SBC [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    LDY **:$0035
    JMP $AC7A
    INY
    JSR $B5C2
    LDY #$01
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    LDY **:$0035
    AND [ENGINE_FPTR_32[2]],Y
    JMP $AC86
    INY
    JSR $B5C2
    LDY #$10
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    LDY **:$0035
    CMP [ENGINE_FPTR_32[2]],Y
    JMP $AC7A
    INY
    JSR $B5C2
    JSR ENGINE_ENABLE_WRAM_WITH_WRITES
    LDY **:$0035
    LDA [ENGINE_FPTR_32[2]],Y
    PHP
    LDY #$01
    PHA
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    TAX
    PLA
    AND [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    STA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    PLP
    BMI 13:1623
    JSR $B587
    TXA
    BPL 13:1623
    JSR $A6F0
    LDY **:$0035
    INY
    JMP ENGINE_ENABLE_WRAM_NO_WRITES
    INY
    JSR $B5C2
    JSR ENGINE_ENABLE_WRAM_WITH_WRITES
    LDY **:$0035
    LDA [ENGINE_FPTR_32[2]],Y
    LDY #$01
    ORA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    STA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    LDY **:$0035
    INY
    JMP ENGINE_ENABLE_WRAM_NO_WRITES
    INY
    JSR $B5C2
    LDX #$16
    LDY #$05
    BNE 13:1652
    INY
    JSR $B5C2
    LDX #$14
    LDY #$03
    STX ENGINE_PALETTE_FPTR/BITS/GEN_USE+2
    STY ENGINE_TO_DECIMAL_INDEX_POSITION
    CLC
    LDY **:$0035
    LDA [ENGINE_FPTR_32[2]],Y
    LDY ENGINE_PALETTE_FPTR/BITS/GEN_USE+2
    ADC [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    STA SAVE_GAME_MOD_PAGE_PTR[2]
    INY
    LDA #$00
    ADC [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    STA SAVE_GAME_MOD_PAGE_PTR+1
    SEC
    LDY ENGINE_TO_DECIMAL_INDEX_POSITION
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    SBC SAVE_GAME_MOD_PAGE_PTR[2]
    INY
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    SBC SAVE_GAME_MOD_PAGE_PTR+1
    BCS 13:1681
    LDY ENGINE_TO_DECIMAL_INDEX_POSITION
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    STA SAVE_GAME_MOD_PAGE_PTR[2]
    INY
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    STA SAVE_GAME_MOD_PAGE_PTR+1
    JSR ENGINE_ENABLE_WRAM_WITH_WRITES
    LDY ENGINE_PALETTE_FPTR/BITS/GEN_USE+2
    LDA SAVE_GAME_MOD_PAGE_PTR[2]
    STA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    INY
    LDA SAVE_GAME_MOD_PAGE_PTR+1
    STA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    LDY **:$0035
    INY
    JMP ENGINE_ENABLE_WRAM_NO_WRITES
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    JSR STORE_IF_MISMATCH_OTHERWISE_WAIT_MENU_DEPTH?
    JSR ENGINE_ENABLE_WRAM_WITH_WRITES
    LDA CURRENT_SAVE_MANIPULATION_PAGE+4
    AND #$C0
    ORA [ENGINE_FPTR_32[2]],Y
    STA CURRENT_SAVE_MANIPULATION_PAGE+4
    INY
    JMP ENGINE_ENABLE_WRAM_NO_WRITES
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    STA **:$07F0
    INY
    RTS
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    STA **:$07F1
    INY
    RTS
    INY
    LDA [ENGINE_FPTR_32[2]],Y
    STA **:$07F3
    INY
    RTS
    JSR ENGINE_ENABLE_WRAM_WITH_WRITES
    LDA #$20
    ORA CURRENT_SAVE_MANIPULATION_PAGE+112
    STA CURRENT_SAVE_MANIPULATION_PAGE+112
    LDA #$20
    ORA CURRENT_SAVE_MANIPULATION_PAGE+176
    STA CURRENT_SAVE_MANIPULATION_PAGE+176
    INY
    JMP ENGINE_ENABLE_WRAM_NO_WRITES
    STY **:$0035
    LDA #$19
    LDX #$C1
    LDY #$A6
    JSR ENGINE_SCRIPT_LAUNCH_R7_A_PTR_XY
    LDY **:$0035
    INY
    RTS
    LDA CURRENT_SAVE_MANIPULATION_PAGE+542
    CMP #$FF
    BEQ 13:16F4
    JMP $AC88
    JSR ENGINE_ENABLE_WRAM_WITH_WRITES
    LDX #$03
    LDA $B708,X
    STA CURRENT_SAVE_MANIPULATION_PAGE+12,X
    DEX
    BPL 13:16F9
    JSR ENGINE_ENABLE_WRAM_NO_WRITES
    INY
    INY
    RTS
    .db D2
    .db 00
    .db 80
    .db 47
    LDA #$66
    STA **:$002C
    STY **:$0035
    LDA PACKET_HPOS_COORD?
    PHA
    LDA PACKET_YPOS_COORD?
    PHA
    JSR $B9E4
    PLA
    STA PACKET_YPOS_COORD?
    PLA
    STA PACKET_HPOS_COORD?
    LDY **:$0035
    INY
    RTS
    JSR ENGINE_SETTLE_UPDATES?
    JSR ENGINE_PALETTE_FADE_SKIP_INDEX_0xE?
    INY
    RTS
    JSR $BD3B
    JSR ENGINE_PALETTE_UPLOAD_WITH_WAIT_HELPER
    INY
    RTS
    LDX #$10
    JSR SCRIPT_INVERT_X_SCROLL_SETTLE
    DEX
    BNE 13:1737
    INY
    RTS
    STY **:$0035
    LDA #$19
    LDX #$CB
    LDY #$A5
    JSR ENGINE_SCRIPT_LAUNCH_R7_A_PTR_XY
    JSR $AB41
    LDY **:$0035
    INY
    RTS
    STY **:$0035
    LDA #$19
    LDX #$C0
    LDY #$A6
    JSR ENGINE_SCRIPT_LAUNCH_R7_A_PTR_XY
    JSR $AB41
    LDY **:$0035
    INY
    RTS
    LDX #$02
    LDY #$19
    STX PACKET_HPOS_COORD?
    STY PACKET_YPOS_COORD?
    LDX #$02
    LDA **:$6704,X
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
    JSR 1E:03C0
    JSR $AB41
    LDA #$AC
    LDX #$B7
    STA FPTR_SPRITES?[2]
    STX FPTR_SPRITES?+1
    JSR MENU_SELECTION
    BIT **:$0083
    BMI 13:179E
    SEC
    RTS
    LDA #$FF
    JSR ENGINE_POS_TO_UPDATE_UNK
    LDX FPTR_UNK_84_MENU_SELECTION?
    LDA **:$6704,X
    STA **:$0028
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
    JSR 1E:03B2
    LDX #$FF
    INX
    CPX #$03
    BCC 13:17C2
    LDX #$00
    JSR 1E:19F1
    BCS 13:17BB
    STA **:$0028
    STX SLOT/DATA_OFFSET_USE?
    JSR $BB21
    JSR $B803
    JSR $BB40
    JSR $BAF9
    LDX SLOT/DATA_OFFSET_USE?
    LDA #$06
    BIT **:$0083
    BVS 13:17F4
    BMI 13:17BB
    BEQ 13:17BB
    JSR $B803
    JSR $BB0E
    BIT **:$0083
    BVS 13:17F4
    BMI 13:17F6
    LDX SLOT/DATA_OFFSET_USE?
    JMP $B7C2
    SEC
    RTS
    LDA #$FF
    JSR ENGINE_POS_TO_UPDATE_UNK
    LDY FPTR_UNK_84_MENU_SELECTION?
    LDA [FPTR_UNK_84_MENU?[2]],Y
    STA **:$0029
    CLC
    RTS
    JSR $B5C4
    CLC
    LDA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    ADC #$20
    STA FPTR_UNK_84_MENU?[2]
    LDA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    ADC #$00
    STA FPTR_UNK_84_MENU?+1
    RTS
    JSR 1E:03B9
    JSR $AB41
    SEC
    LDA **:$0035
    ADC ENGINE_FPTR_32[2]
    STA FPTR_UNK_84_MENU?[2]
    LDA #$00
    ADC ENGINE_FPTR_32+1
    STA FPTR_UNK_84_MENU?+1
    LDY #$03
    STY PACKET_YPOS_COORD?
    LDY **:$0035
    INY
    STY **:$0035
    LDA [ENGINE_FPTR_32[2]],Y
    STA **:$0029
    BEQ 13:1853
    LDA #$0C
    STA **:$0070
    LDX #$03
    STX PACKET_HPOS_COORD?
    JSR $BBAF
    JSR $BBC3
    LDA #$00
    STA **:$0070
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
    BIT **:$0083
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
    JSR 1E:03B2
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
    BIT **:$0083
    BVS 13:18C5
    BMI 13:188B
    BEQ 13:188B
    JSR $B8CA
    JSR $BB0E
    BIT **:$0083
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
    SBC **:$00A0
    ???
    CPX 1F:13EF
    SBC MAPPER_BANK_VALS+4
    BRK
    JSR 1E:03B2
    LDX #$FF
    INX
    CPX #$03
    BCC 13:18F2
    LDX #$00
    LDA CURRENT_SAVE_MANIPULATION_PAGE+8,X
    BEQ 13:18EB
    CMP #$03
    BCS 13:18EB
    STA **:$0028
    STX SLOT/DATA_OFFSET_USE?
    JSR $BB21
    JSR $B935
    JSR $BB40
    JSR $BAF9
    LDX SLOT/DATA_OFFSET_USE?
    LDA #$06
    BIT **:$0083
    BVS 13:1930
    BMI 13:18EB
    BEQ 13:18EB
    JSR $B935
    LDY #$01
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    AND #$F0
    BNE 13:192B
    JSR $BB0E
    BIT **:$0083
    BVS 13:1930
    BMI 13:1932
    LDX SLOT/DATA_OFFSET_USE?
    JMP $B8F2
    SEC
    RTS
    JMP $B7F6
    JSR $B5C4
    CLC
    LDA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    ADC #$30
    STA FPTR_UNK_84_MENU?[2]
    LDA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
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
    JSR 1E:03B2
    LDA #$D1
    LDX #$B9
    JSR $AC44
    JSR $B9AF
    JSR $BB40
    LDA #$DC
    LDX #$B9
    JSR $BB12
    BIT **:$0083
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
    JSR 1E:03CE
    LDA #$B6
    LDX #$BA
    JSR $AC44
    JSR ENGINE_CREATE_UPDATE_BUF_INIT_INC?
    LDX #$00
    JSR $BA72
    JSR $BA72
    JSR ENGINE_ENABLE_WRAM_WITH_WRITES
    LDA #$00
    STA CURRENT_SAVE_MANIPULATION_PAGE+49
    STA SLOT/DATA_OFFSET_USE?
    LDY #$10
    LDA #$A2
    STA CURRENT_SAVE_MANIPULATION_PAGE+32,Y
    DEY
    BPL 13:1A07
    STA **:$00D6
    JSR $BA8D
    JSR MENU_SELECTION
    JMP $BA1E
    JSR $BA8D
    JSR 1F:0F7C
    BIT **:$0083
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
    LDY FPTR_UNK_84_MENU_SELECTION?
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
    STA **:$00D6
    LDA #$F0
    STA SPRITE_PAGE+4
    JSR ENGINE_ENABLE_WRAM_NO_WRITES
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
    JMP MENU_SELECTION
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
    LDA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    ADC #$38
    STA FPTR_PACKET_CREATION[2]
    LDA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    ADC #$00
    STA FPTR_PACKET_CREATION+1
    LDA #$07
    LDX #$09
    LDY #$03
    STA **:$0070
    STX PACKET_HPOS_COORD?
    STY PACKET_YPOS_COORD?
    JMP ENGINE_CREATE_UPDATE_BUF_INIT_INC?
    LDA #$0B
    LDX #$07
    LDY #$05
    STA **:$0070
    STY PACKET_YPOS_COORD?
    LDY #$00
    STX PACKET_HPOS_COORD?
    STY FPTR_UNK_84_MENU_SELECTION?
    LDA [FPTR_UNK_84_MENU?[2]],Y
    STA **:$0029
    JSR $BBAF
    LDX #$13
    CPX PACKET_HPOS_COORD?
    BNE 13:1B63
    INC PACKET_YPOS_COORD?
    INC PACKET_YPOS_COORD?
    LDX #$07
    LDY FPTR_UNK_84_MENU_SELECTION?
    INY
    CPY #$08
    BCC 13:1B4C
    LDA #$00
    STA **:$0070
    RTS
    JSR $B5C4
    JSR ENGINE_ENABLE_WRAM_WITH_WRITES
    LDA #$04
    STA **:$6D00
    CLC
    LDA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    ADC #$38
    STA **:$6D01
    LDA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    ADC #$00
    STA **:$6D02
    JMP ENGINE_ENABLE_WRAM_NO_WRITES
    JSR $BBDF
    LDY #$00
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    STA SAVE_GAME_MOD_PAGE_PTR[2]
    INY
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    STA SAVE_GAME_MOD_PAGE_PTR+1
    JSR ENGINE_ENABLE_WRAM_WITH_WRITES
    LDY #$00
    LDA [SAVE_GAME_MOD_PAGE_PTR[2]],Y
    STA **:$6D04,Y
    INY
    CMP #$00
    BNE 13:1B9F
    JSR ENGINE_ENABLE_WRAM_NO_WRITES
    JMP $AB41
    JSR $BBDF
    LDY #$00
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    STA FPTR_PACKET_CREATION[2]
    INY
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    STA FPTR_PACKET_CREATION+1
    JSR ENGINE_CREATE_UPDATE_BUF_INIT_INC?
    JMP $AB41
    JSR $BBDF
    LDY #$06
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    STA **:$002A
    INY
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    STA **:$002B
    JMP $AB41
    JSR $BBDF
    LDY #$02
    JSR 1F:06A9
    JMP $AB41
    JSR $BBF0
    CLC
    LDA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    ADC #$00
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    LDA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    ADC #$98
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    RTS
    LDA **:$0029
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    LDA #$00
    ASL ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    ROL A
    ASL ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    ROL A
    ASL ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    ROL A
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    JMP 1E:1E8B
    JSR WAIT_ANY_BUTTONS_PRESSED_RET_PRESSED
    JMP 1E:03D5
    LDA FPTR_PACKET_CREATION[2]
    PHA
    LDA RTN_ARG_UNK
    PHA
    JSR 1E:03A0
    PLA
    STA RTN_ARG_UNK
    PLA
    STA FPTR_PACKET_CREATION[2]
    LDA #$00
    STA **:$002D
    LDX #$08
    LDY #$13
    STX PACKET_HPOS_COORD?
    STY PACKET_YPOS_COORD?
    JMP $AB41
    LDA PACKET_HPOS_COORD?
    PHA
    LDA PACKET_YPOS_COORD?
    PHA
    JSR 1E:03DF
    PLA
    STA PACKET_YPOS_COORD?
    PLA
    STA PACKET_HPOS_COORD?
    JMP $AB41
    LDA ENGINE_PALETTE_FPTR/BITS/GEN_USE+2
    AND #$3F
    STA ARR_BITS_TO_UNK+3
    LDA ENGINE_PALETTE_FPTR/BITS/GEN_USE+2
    AND #$C0
    ASL A
    ROL A
    ROL A
    ADC #$28
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE+2
    LDA **:$0029
    JSR $B058
    BCS 13:1C59
    TYA
    ADC #$20
    STA ARR_BITS_TO_UNK+2
    BCC 13:1C5E
    RTS
    LDA #$00
    STA ARR_BITS_TO_UNK+3
    JSR $B5C4
    LDA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    LDX ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    STA ARR_BITS_TO_UNK[8]
    STX ARR_BITS_TO_UNK+1
    LDY ENGINE_PALETTE_FPTR/BITS/GEN_USE+2
    LDA [ARR_BITS_TO_UNK[8]],Y
    JSR $BBF2
    JSR $BBE2
    LDY #$03
    LDA [ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]],Y
    AND #$3F
    STA ENGINE_TO_DECIMAL_INDEX_POSITION
    JSR ENGINE_ENABLE_WRAM_WITH_WRITES
    LDX ENGINE_PALETTE_FPTR/BITS/GEN_USE+2
    LDA $BCC0,X
    BMI 13:1CA6
    TAY
    SEC
    LDA [ARR_BITS_TO_UNK[8]],Y
    SBC ENGINE_TO_DECIMAL_INDEX_POSITION
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
    LDA ENGINE_TO_DECIMAL_INDEX_POSITION
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
    LDY ENGINE_PALETTE_FPTR/BITS/GEN_USE+2
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
    LDY ENGINE_PALETTE_FPTR/BITS/GEN_USE+2
    STA [ARR_BITS_TO_UNK[8]],Y
    CLC
    JMP ENGINE_ENABLE_WRAM_NO_WRITES
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
    STA **:$07F0
    JMP ENGINE_PALETTE_FADE_OUT?
    LDA #$10
    STA **:$07F1 ; Set ??
    LDA #$34 ; Palette data.
    JSR PALETTE_TO_COLOR_A_AND_FORWARDED ; Do.
    LDA **:$0006
    BEQ VAL_EQ_0x00 ; == 0, goto.
    LDA #$19 ; Launch 19:01F7, ??
    LDX #$F7
    LDY #$A1
    JSR ENGINE_SCRIPT_LAUNCH_R7_A_PTR_XY ; Launch it.
VAL_EQ_0x00: ; 13:1D2C, 0x027D2C
    LDX #$3C
    JMP ENGINE_DELAY_X_FRAMES ; Engine delay, leave.
    JSR SCRIPT_PALETTE_COLOR ; Do ??
SCRIPT_SET_??_PALETTE_FADE_OUT: ; 13:1D34, 0x027D34
    LDA #$20
    STA ENGINE_FLAG_20_SETUP_UNK ; Set ??
    JMP ENGINE_PALETTE_FADE_OUT? ; Palette fade out.
SCRIPT_PALETTE_COLOR: ; 13:1D3B, 0x027D3B
    JSR ENGINE_PALETTE_SCRIPT_TO_TARGET ; To target.
    LDA #$02
    STA **:$07F0 ; Set ??
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
    STA **:$07F0 ; Set ??
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
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2]
    STX ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
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
    JSR ENGINE_SETTLE_UPDATES?
    LDA #$01
    STA **:$0305,X ; Set ??
    LDA **:$0303,X ; Load.
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
    ADC **:$0306,X ; Add A to.
    STA **:$0306,X ; Store result.
    TYA ; Y val to A.
    ADC **:$0307,X ; Add A to.
    STA **:$0307,X ; Store carry result.
    CLC ; Prep add.
    TXA ; Index to A.
    ADC #$08 ; Index mod, goto.
    TAX ; Val to X.
    CPX #$28 ; If _ #$28
    BCC INDEX_LT_0x28 ; <, goto.
    LDA #$08
    STA NMI_FLAG_E5_TODO ; Set flag ??
    PLA ; Pull A.
    TAY ; To Y.
    DEY ; --
    BNE COUNT_NONZERO ; != 0, goto.
    JSR SETTLE_SPRITES_OFFSCREEN/CLEAR_RAM ; Do.
    JSR ENGINE_PALETTE_FADE_OUT? ; Fade out.
    LDX #$5A
    JMP ENGINE_DELAY_X_FRAMES ; Abuse RTS.
    LDA #$11 ; Seed color.
    JSR ENGINE_BG_COLOR_A
    LDA #$03
    STA **:$07F0 ; Set ??
    JSR ENGINE_0x300_OBJECTS_UNK? ; Do ??
    LDX #$08 ; Index.
    LDY #$07 ; Data index/loop.
DATA_POSITIVE: ; 13:1DEA, 0x027DEA
    LDA ROM_DATA_LUT_UNK,Y ; Move data.
    STA **:$0305,X
    DEY ; Data--
    LDA ROM_DATA_LUT_UNK,Y ; Move data.
    STA **:$0304,X
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
    JSR STORE_IF_MISMATCH_OTHERWISE_WAIT_MENU_DEPTH? ; Do.
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
    JSR ENGINE_ENABLE_WRAM_WITH_WRITES ; Enable.
    SEC ; Prep sub.
    LDY #$00 ; Reset stream.
    LDA [SAVE_GAME_MOD_PAGE_PTR[2]],Y ; Load 0x7400
    SBC ENGINE_PALETTE_FPTR/BITS/GEN_USE[2] ; Sub with.
    STA [SAVE_GAME_MOD_PAGE_PTR[2]],Y ; Store back to.
    INY ; Stream++
    LDA [SAVE_GAME_MOD_PAGE_PTR[2]],Y ; 2x
    SBC ENGINE_PALETTE_FPTR/BITS/GEN_USE+1 ; Sub with.
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
    JMP ENGINE_ENABLE_WRAM_NO_WRITES ; Leave, no writes.
SAVEGAME_LOAD_AND_CHECKSUM[A]: ; 13:1E88, 0x027E88
    JSR SAVEGAME_INIT_FPTRS ; Set up ptrs.
    JSR ENGINE_ENABLE_WRAM_WITH_WRITES ; Enable WRAM writes.
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
    JSR ENGINE_ENABLE_WRAM_NO_WRITES ; No more WRAM writes.
    JSR SAVEGAME_LOADED_CHECKSUM ; Check check it, yeah.
    LDA SAVE_SLOT_DATA_UNK_A ; Load save slot data.
    AND #$F0 ; Keep upper.
    CMP #$B0 ; If _ #$B0
    BNE EXIT_FAIL_DIRECT ; !=, goto. TODO: Carry matters?
    LDA SAVE_SLOT_DATA_UNK_B ; Load other.
    CMP #$E9 ; If _ #$E9
    BNE EXIT_FAIL_DIRECT ; !=, goto.
    LDA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2] ; Load slot value added up.
    ORA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1 ; Combine with other bits. == 0, pass exit. Else, failed.
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
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2] ; Clear checksum.
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1
    LDX #$03 ; Pages to add together count.
LOOP_ALL_PAGES: ; 13:1EDE, 0x027EDE
    LDY #$00 ; Stream index reset.
LOOP_PAGE_STREAM: ; 13:1EE0, 0x027EE0
    CLC ; Prep add.
    LDA [SAVE_GAME_MOD_PAGE_PTR[2]],Y ; Load from file.
    ADC ENGINE_PALETTE_FPTR/BITS/GEN_USE[2] ; Add with.
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE[2] ; Store back.
    INY ; Stream++
    LDA [SAVE_GAME_MOD_PAGE_PTR[2]],Y ; Load from file.
    ADC ENGINE_PALETTE_FPTR/BITS/GEN_USE+1 ; Add with.
    STA ENGINE_PALETTE_FPTR/BITS/GEN_USE+1 ; Store to.
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
