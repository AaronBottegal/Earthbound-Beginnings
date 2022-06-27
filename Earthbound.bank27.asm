    JMP JMP_SOUND_SEQUENCE_A
    JMP JMP_SOUND_SEQUENCE_B_INIT_FULL_DMC?
    JMP JMP_SOUND_SEQUENCE_C
ENTRY_SQ1_WRITE_PTR_YX_SEEDED: ; 1B:0009, 0x036009
    LDA #$00 ; SQ1
    BEQ CHANNEL_SEEDED
ENTRY_TRI_WRITE_PTR_YX_SEEDED: ; 1B:000D, 0x03600D
    LDA #$08 ; Triangle.
    BNE CHANNEL_SEEDED
ENTRY_NOISE_WRITE_PTR_YX_SEEDED: ; 1B:0011, 0x036011
    LDA #$0C ; Noise.
    BNE CHANNEL_SEEDED
ENTRY_SQ2_WRITE_PTR_YX_SEEDED: ; 1B:0015, 0x036015
    LDA #$04 ; SQ2.
CHANNEL_SEEDED: ; 1B:0017, 0x036017
    STA SOUND_PTR_REGISTER/DATA[2] ; Store to register ptr.
    LDA #$40
    STA SOUND_PTR_REGISTER/DATA+1 ; Set PTR H.
    STY SND_DATA_8100_PTR[2] ; Move ptr for data.
    STA SND_DATA_8100_PTR+1
    LDY #$00 ; Stream index.
VAL_NE_0x4: ; 1B:0023, 0x036023
    LDA [SND_DATA_8100_PTR[2]],Y ; Move 8100 ptr to channel.
    STA [SOUND_PTR_REGISTER/DATA[2]],Y
    INY ; Stream++
    TYA ; Val to A.
    CMP #$04 ; If _ #$04
    BNE VAL_NE_0x4 ; !=, goto.
    RTS ; Leave.
SUB_PRD/L_DATA_STUFFS_TODO: ; 1B:002E, 0x03602E
    LDA SND_UNK_NSE_PRD/TRI_L_DATA? ; Load.
    AND #$02 ; Keep bit.
    STA SND_UNK_7FF ; Store to.
    LDA SND_UNK_BC ; Load ??
    AND #$02 ; Keep bit.
    EOR SND_UNK_7FF ; Invert with.
    CLC
    BEQ ROTATE_CLEAR ; == 0, goto.
    SEC ; Rotate carry in.
ROTATE_CLEAR: ; 1B:0040, 0x036040
    ROR SND_UNK_NSE_PRD/TRI_L_DATA? ; Rotate into.
    ROR SND_UNK_BC ; Rotate into.
    RTS ; Leave.
SOUND_INDEX_FORWARD_TO_TARGET: ; 1B:0045, 0x036045
    LDX SND_INDEX_WORKING_ON? ; Load index.
    INC SND_TIMER_A[5],X ; ++
    LDA SND_TIMER_A[5],X ; Load.
    CMP SND_TIMER_A_TARGET[6],X ; If _ target
    BNE RTS ; !=, leave.
    LDA #$00
    STA SND_TIMER_A[5],X ; Clear timer.
RTS: ; 1B:0057, 0x036057
    RTS ; Leave.
SOUND_DATA_ZEROS_UNK: ; 1B:0058, 0x036058
    BRK
    BRK
JMP_SOUND_SEQUENCE_C: ; 1B:005A, 0x03605A
    LDA #$0F
    STA APU_STATUS ; Enable channels.
    LDA #$55 ; 0101.0101
    STA SND_UNK_NSE_PRD/TRI_L_DATA? ; Sert ??
    LDA #$00
    STA SOUND_UNK_786 ; Clear ??
    STA SOUND_UNK_78B
    TAY ; Clear index.
VAL_NE_0x14: ; 1B:006C, 0x03606C
    LDA SOUND_DATA_ZEROS_UNK,Y ; Move zeros.
    STA ARR_UNK[20],Y ; Store to ??
    INY ; Data++
    TYA ; Y to A.
    CMP #$14 ; If _ #$14
    BNE VAL_NE_0x14 ; !=, loop.
    JSR JMP_SOUND_SEQUENCE_B_INIT_FULL_DMC? ; Do sequence ??
    RTS ; Leave.
    BRK
    BRK
SONG_INIT_ID_CHECK_AND_INIT_STUFFS: ; 1B:007E, 0x03607E
    LDA SOUND_MAIN_SONG_INIT_ID ; Load ??
    CMP #$25 ; If _ #$25
    BNE RTS ; !=, leave.
    JSR JMP_SOUND_SEQUENCE_B_INIT_FULL_DMC? ; Do.
    STA SOUND_MAIN_SONG_INIT_ID ; Store result.
    LDA #$11 ; Set ??
    STA SOUND_EFFECT_REQUEST_ARRAY+1
RTS: ; 1B:0090, 0x036090
    RTS ; Leave.
JMP_SOUND_SEQUENCE_A: ; 1B:0091, 0x036091
    LDA #$C0
    STA APU_FSEQUENCE ; Set sequence.
    JSR SUB_PRD/L_DATA_STUFFS_TODO ; Do.
    JSR SONG_INIT_ID_CHECK_AND_INIT_STUFFS ; Do.
    JSR SONG_ID_AND_TODO ; Do ID and ??
    LDA #$00 ; Seed clear.
    LDX #$06 ; Index.
VAL_NONZERO: ; 1B:00A3, 0x0360A3
    STA **:$07EF,X ; Store to requests addr - 1
    DEX ; Index--
    BNE VAL_NONZERO ; != 0, do more.
    RTS ; Leave.
JMP_SOUND_SEQUENCE_B_INIT_FULL_DMC?: ; 1B:00AA, 0x0360AA
    JSR INIT_A_BIT_WITH_CTRL ; Init.
HELPER_INIT_CTRLS_AND_TRI_AND_DMC: ; 1B:00AD, 0x0360AD
    JSR INIT_CTRLS_AND_TRI ; Init.
    LDA #$00
    STA APU_DMC_LOAD ; Clear DMC.
    STA SND_UNK_79C ; Clear ??
    RTS ; Leave.
INIT_A_BIT_WITH_CTRL: ; 1B:00B9, 0x0360B9
    LDA #$00
    STA SND_DISABLE_WRITE_ARR_UNK ; Clear/init?
    STA SND_UNK_7C9
    STA SND_UNK_7CA
    STA SOUND_MAIN_SONG_CURRENTLY_PLAYING_ID
    STA SND_SQUARES_UPDATING_COUNT
    TAY ; Clear index.
VAL_NE_0x6: ; 1B:00CB, 0x0360CB
    LDA #$00 ; Load clear.
    STA SOUND_ARRAY_TODO_UNK[7],Y ; Store to index.
    INY ; Data++
    TYA ; Index to A.
    CMP #$06 ; If _ #$06
    BNE VAL_NE_0x6 ; !=, goto.
    RTS ; Leave.
INIT_CTRLS_AND_TRI: ; 1B:00D7, 0x0360D7
    LDA #$00
    STA APU_DMC_LOAD ; Clear ??
    LDA #$10
    STA APU_SQ1_CTRL ; Set constant volume.
    STA APU_SQ2_CTRL
    STA APU_NSE_CTRL
    LDA #$00
    STA APU_TRI_CTRL ; Clear tri ctrl.
    RTS
    LDX SND_INDEX_WORKING_ON? ; Load index.
    STA SND_TIMER_A_TARGET[6],X ; Store val to target.
    TXA ; Index to A.
    STA SND_ARR_INDEX_UNK,X ; Store index to self?
    TYA ; Y to A.
    BEQ NO_MORE_UPDATES_A ; == 0, goto.
    TXA ; Index to A.
    BEQ ENTRY_WRITE_NOISE_PAST ; == 0, goto.
    CMP #$01 ; If _ #$01
    BEQ ENTRY_WRITE_SQ1_PAST ; ==, goto.
    CMP #$02 ; If _ #$02
    BEQ ENTRY_WRITE_SQ2_PAST ; ==, goto.
    CMP #$03 ; If _ #$03
    BEQ ENTRY_WRITE_TRI_PAST ; ==, goto.
    RTS ; Leave.
ENTRY_WRITE_SQ1_PAST: ; 1B:0109, 0x036109
    JSR ENTRY_SQ1_WRITE_PTR_YX_SEEDED ; Write.
    BEQ NO_MORE_UPDATES_A ; == 0, goto.
ENTRY_WRITE_SQ2_PAST: ; 1B:010E, 0x03610E
    JSR ENTRY_SQ2_WRITE_PTR_YX_SEEDED
    BEQ NO_MORE_UPDATES_A
ENTRY_WRITE_TRI_PAST: ; 1B:0113, 0x036113
    JSR ENTRY_TRI_WRITE_PTR_YX_SEEDED
    BEQ NO_MORE_UPDATES_A
ENTRY_WRITE_NOISE_PAST: ; 1B:0118, 0x036118
    JSR ENTRY_NOISE_WRITE_PTR_YX_SEEDED
NO_MORE_UPDATES_A: ; 1B:011B, 0x03611B
    LDA SND_UNK_BF ; Move ??
    STA SOUND_ARRAY_TODO_UNK[7],X
    LDA #$00 ; Clear ??
    STA SND_TIMER_A[5],X
WRITE_ARRAYS_UNK: ; 1B:0125, 0x036125
    STA SND_ARR_UNK_7DF,X ; Clear ??
    STA SND_ARR_UNK_7E3,X
    STA SND_ARR_UNK_7E7,X
    STA SND_SQUARES_UPDATING_COUNT
    RTS ; Leave.
    JSR SOUND_INDEX_FORWARD_TO_TARGET ; Do forward.
    BNE RTS ; != 0, goto.
    LDA #$00
    STA SOUND_ARRAY_TODO_UNK[7] ; Clear ??
    LDA #$10
    STA APU_NSE_CTRL ; Set noise ctrl.
RTS: ; 1B:0141, 0x036141
    RTS ; Leave.
    STA SND_TIMER_A_TARGET+4 ; A to.
    JSR ENTRY_SQ2_WRITE_PTR_YX_SEEDED ; Do seeded.
    LDA SND_UNK_BF ; Move ??
    STA SOUND_ARRAY_TODO_UNK+4
    LDX #$01 ; Set disable.
    STX SND_DISABLE_WRITE_ARR_UNK
    INX ; += 1
    STX SND_UNK_7C9 ; Set ??
    LDA #$00
    STA SND_TIMER_A+4 ; Clear timer.
    STA SOUND_ARRAY_TODO_UNK+1 ; And ??
    LDX #$01 ; Seed ??
    JMP WRITE_ARRAYS_UNK ; Arrays write.
    JSR SUB_HELP_SQ1_CTRL_AND_VARS_WITH_INC ; With inc.
    JSR SET_SQUARE_2_CTRL_AND_VAR_CLEAR_UNK ; Do SQ2.
    INC SND_SQUARES_UPDATING_COUNT ; ++
    LDA #$00
    STA SOUND_ARRAY_TODO_UNK+4 ; Clear request.
    LDX #$01 ; Array index.
    LDA #$7F ; Load CTRL.
    STA APU_SQ1_CTRL,X ; Set register sweep SQ1+SQ2
    STA APU_SQ2_CTRL,X
    RTS ; Leave.
    JSR SOUND_INDEX_FORWARD_TO_TARGET ; Forward.
    BNE RTS ; Nonezero, leave.
SUB_HELP_SQ1_CTRL_AND_VARS_WITH_INC: ; 1B:0181, 0x036181
    LDA #$10
    STA APU_SQ1_CTRL ; Set CTRL.
    LDA #$00
    STA SND_DISABLE_WRITE_ARR_UNK ; Clear ??
    STA SOUND_ARRAY_TODO_UNK+1 ; Clear ??
    INC SND_SQUARES_UPDATING_COUNT ; ++
RTS: ; 1B:0191, 0x036191
    RTS ; Leave.
SET_SQUARE_2_CTRL_AND_VAR_CLEAR_UNK: ; 1B:0192, 0x036192
    LDA #$10
    STA APU_SQ2_CTRL ; Set SQ2 CTRL.
    LDA #$00
    STA SND_UNK_7C9 ; Clear ??
    STA SOUND_ARRAY_TODO_UNK+2 ; Clear ??
    RTS
VAL_GTE_0x3F: ; 1B:01A0, 0x0361A0
    JMP JMP_SOUND_SEQUENCE_B_INIT_FULL_DMC?
SONG_ID_AND_TODO: ; 1B:01A3, 0x0361A3
    LDA SOUND_MAIN_SONG_INIT_ID ; Load.
    TAY ; To Y.
    CMP #$3F ; If _ #$3F
    BCS VAL_GTE_0x3F ; >=, goto.
    TYA ; Back to A.
    BEQ VAL_EQ_0x00 ; == 0, goto.
    STA SOUND_MAIN_SONG_CURRENTLY_PLAYING_ID ; Store to, ID?
    CMP #$19 ; If _ #$19
    BEQ VAL_EQ_0x19 ; ==, goto.
    CMP #$19 ; If _ #$19
    BCC VAL_LT_0x19 ; <, goto.
VAL_EQ_0x19: ; 1B:01B9, 0x0361B9
    STA SND_UNK_BF ; Store val ??
    SEC ; Prep sub.
    SBC #$19 ; Sub with, rebase.
    STA SND_REBASED_UNK ; Store to rebased.
    JMP ENTRY_REBASED ; Goto ??
VAL_LT_0x19: ; 1B:01C4, 0x0361C4
    CMP #$06 ; If _ #$06
    BNE VAL_NE_0x6 ; !=, goto.
    LDA COUNT_LOOPS?_UNK ; Load ??
    CMP #$01 ; If _ #$01
    BEQ Y_TO_A_AND_STORE ; ==, goto.
    LDA #$07 ; Load ??
    BNE VAL_NE_0x6 ; !=, goto.
Y_TO_A_AND_STORE: ; 1B:01D3, 0x0361D3
    TYA ; Y to A.
VAL_NE_0x6: ; 1B:01D4, 0x0361D4
    STA SND_UNK_BF ; Store val to.
    STA SND_REBASED_UNK ; Store ??
    DEC SND_REBASED_UNK ; --
ENTRY_REBASED: ; 1B:01DC, 0x0361DC
    LDA #$7F
    STA CHANNELS_SWEEP_COPY ; Set sweep copy.
    STA SOUND_UNK_7C1_SWEEP_SQ2? ; Set ??
    JSR REINIT_STUFFS_AND_MOVE_STUFF_TODO ; Do.
VAL_NONZERO: ; 1B:01E7, 0x0361E7
    JMP TO_NAME_IDK ; Goto.
VAL_EQ_0x00: ; 1B:01EA, 0x0361EA
    LDA SOUND_ARRAY_TODO_UNK+5 ; Load ??
    BNE VAL_NONZERO ; != 0, goto.
    RTS ; Leave if zero.
NOISE_CTRL_DATA: ; 1B:01F0, 0x0361F0
    .db 00
NOISE_LOOP_DATA: ; 1B:01F1, 0x0361F1
    .db 10
NOISE_LENGTH_DATA: ; 1B:01F2, 0x0361F2
    .db 01
    .db 18
    .db 00
    .db 01
    .db 38
    .db 00
    .db 03
    .db 40
    .db 00
    .db 06
    .db 58
    .db 01
    .db 03
    .db 40
    .db 02
    .db 04
    .db 40
    .db 13
    .db 05
    .db 40
    .db 14
    .db 0A
    .db 40
    .db 14
    .db 08
    .db 40
    .db 12
    .db 0E
    .db 08
    .db 16
    .db 0E
    .db 28
    .db 16
    .db 0B
    .db 18
    .db 1D
    .db 01
    .db 28
    .db 16
    .db 01
    .db 28
    .db 13
    .db 01
    .db 38
    .db 12
    .db 01
    .db 38
L_1B:0221: ; 1B:0221, 0x036221
    LDA SOUND_ARRAY_TODO_UNK+5 ; Load song.
    CMP #$01 ; If _ #$01
    BEQ RTS ; ==, goto.
    TXA ; X to A.
    CMP #$03 ; If _ #$03
    BEQ RTS ; ==, leave.
    LDA SOUND_ARR_UNK_79A,X ; Load arr.
    AND #$E0 ; Keep 1110.0000
    BEQ RTS ; == 0, leave.
    STA SOUND_PTR_REGISTER/DATA[2] ; Store to.
    LDA SOUND_ARR_7C3,X ; Load ??
    CMP #$02 ; If _ #$02
    BEQ VAL_EQ_0x2 ; ==, goto.
    LDY SOUND_BE_WRITE_INDEXER_UNK ; Load other index.
    LDA CHANNELS_LTIMER_COPY,Y ; Load timer LO.
    STA SOUND_PTR_REGISTER/DATA+1 ; Store to.
    JSR TIMER_L_DATA_CHECK_UNK ; Do sub.
VAL_EQ_0x2: ; 1B:0247, 0x036247
    INC SND_ARR_UNK_7D1,X ; ++
RTS: ; 1B:024A, 0x03624A
    RTS ; Leave.
VAL_EQ_0x80/0xC0: ; 1B:024B, 0x03624B
    LDA SND_DATA_8100_PTR[2] ; Load ??
    CMP #$31 ; If _ #$31
    BNE VAL_NE_0x31 ; !=, goto.
    LDA #$27 ; Seed on ??
VAL_NE_0x31: ; 1B:0253, 0x036253
    TAY ; To Y index.
    LDA DATA_ARR_UNK,Y ; Load ??
    PHA ; Save it.
    LDA SOUND_ARR_7C3,X ; Load ??
    CMP #$46 ; If _ #$46
    BNE VAL_NE_0x46 ; !=, goto.
    PLA ; Pull saved.
    LDA #$00 ; Load ??
    BEQ Y_TO_ARR_UNK ; Always taken, goto.
VAL_NE_0x46: ; 1B:0264, 0x036264
    PLA ; Pull value.
    JMP Y_TO_ARR_UNK ; Go store it.
VAL_EQ_0x40: ; 1B:0268, 0x036268
    LDA SND_DATA_8100_PTR[2] ; Load ??
    TAY ; To Y index.
    CMP #$10 ; If _ #$10
    BCS VAL_GTE_0x10 ; >=, goto.
    LDA TIMER_L_VALS?,Y ; Load mod.
    JMP TEST_WRITE_TIMER_L? ; Write.
VAL_GTE_0x10: ; 1B:0275, 0x036275
    LDA #$F6 ; Load ??
    BNE TEST_WRITE_TIMER_L? ; Write it.
VAL_EQ_0x60: ; 1B:0279, 0x036279
    LDA SOUND_ARR_7C3,X ; Load ??
    CMP #$4C ; If _ #$4C
    BCC VAL_LT_0x4C ; <, goto.
    LDA #$FE ; Seed timer L.
    BNE TEST_WRITE_TIMER_L? ; Always taken, goto.
VAL_LT_0x4C: ; 1B:0284, 0x036284
    LDA #$FE ; Seed timer L.
    BNE TEST_WRITE_TIMER_L? ; Always taken, goto.
TIMER_L_DATA_CHECK_UNK: ; 1B:0288, 0x036288
    LDA SND_ARR_UNK_7D1,X ; Move ??
    STA SND_DATA_8100_PTR[2] ; Store to.
    LDA SOUND_PTR_REGISTER/DATA[2] ; Load ??
    CMP #$20 ; If _ #$20
    BEQ VAL_EQ_0x20 ; ==, goto.
    CMP #$A0 ; If _ #$A0
    BEQ VAL_EQ_0xA0 ; ==, goto.
    CMP #$60 ; If _ #$60
    BEQ VAL_EQ_0x60 ; ==, goto.
    CMP #$40 ; If _ #$40
    BEQ VAL_EQ_0x40 ; ==, goto.
    CMP #$80 ; If _ #$80
    BEQ VAL_EQ_0x80/0xC0 ; ==, goto.
    CMP #$C0 ; If _ #$C0
    BEQ VAL_EQ_0x80/0xC0 ; ==, goto.
VAL_EQ_0x20: ; 1B:02A7, 0x0362A7
    LDA SND_DATA_8100_PTR[2] ; Load.
    CMP #$0A ; If _ #$0A
    BNE VAL_NE_0xA ; !=, goto.
    LDA #$00 ; Seed clear.
VAL_NE_0xA: ; 1B:02AF, 0x0362AF
    TAY ; Clear index.
    LDA SOUND_DATA_UNK,Y ; Load ??
    JMP Y_TO_ARR_UNK ; Goto.
VAL_EQ_0xA0: ; 1B:02B6, 0x0362B6
    LDA SND_DATA_8100_PTR[2] ; Load.
    CMP #$2B ; If _ #$2B
    BNE VAL_NE_0x2B
    LDA #$21 ; Seed data.
VAL_NE_0x2B: ; 1B:02BE, 0x0362BE
    TAY ; To Y index.
    LDA SOUND_DATA_UNK_B,Y
Y_TO_ARR_UNK: ; 1B:02C2, 0x0362C2
    PHA ; Save A.
    TYA ; Y to A.
    STA SND_ARR_UNK_7D1,X ; Save Y.
    PLA ; Pull saved.
TEST_WRITE_TIMER_L?: ; 1B:02C8, 0x0362C8
    PHA ; Save passed.
    LDA SND_DISABLE_WRITE_ARR_UNK,X ; Load ??
    BNE EXIT_PULL ; !=, disabled, exit.
    PLA ; Pull passed.
    CLC ; Prep add.
    ADC SOUND_PTR_REGISTER/DATA+1 ; Add with.
    LDY SOUND_BE_WRITE_INDEXER_UNK ; Load index.
    STA APU_SQ1_LTIMER,Y ; Store to timer L.
    RTS ; Leave.
EXIT_PULL: ; 1B:02D8, 0x0362D8
    PLA ; Pull saved.
    RTS ; Leave.
DATA_ARR_UNK: ; 1B:02DA, 0x0362DA
    .db 09
    .db 08
    .db 07
    .db 06
    .db 05
    .db 04
    .db 03
    .db 02
    .db 02
    .db 01
    .db 01
    .db 00
SOUND_DATA_UNK_B: ; 1B:02E6, 0x0362E6
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
    .db 01
    .db 00
    .db 00
    .db 00
    .db 00
    .db FF
    .db 00
    .db 00
    .db 00
    .db 00
    .db 01
    .db 01
    .db 00
    .db 00
    .db 00
    .db FF
    .db FF
    .db 00
SOUND_DATA_UNK: ; 1B:0307, 0x036307
    .db 00
    .db 01
    .db 01
    .db 02
    .db 01
    .db 00
    .db FF
    .db FF
    .db FE
    .db FF
TIMER_L_VALS?: ; 1B:0311, 0x036311
    .db 00
    .db FF
    .db FE
    .db FD
    .db FC
    .db FB
    .db FA
    .db F9
    .db F8
    .db F7
    .db F6
    .db F5
    .db F6
    .db F7
    .db F6
    .db F5
SUB_TODO_A: ; 1B:0321, 0x036321
    LDA SND_REBASED_UNK ; Load rebased.
    TAY ; To Y.
    LDA REBASE_DATA_UNK_A,Y ; Load zero.
    TAY ; To Y index.
    LDX #$00 ; Load alt index.
INDEX_NE_0xA: ; 1B:032B, 0x03632B
    LDA DATA_MOVE_UNK_A,Y ; Move ??
    STA SND_ARR_UNK_LARGER?[10],X
    INY ; Data++
    INX ; Data++
    TXA ; X to A.
    CMP #$0A ; If _ #$0A
    BNE INDEX_NE_0xA ; !=, goto.
    RTS ; Leave.
VAL_EQ_0xFF: ; 1B:0339, 0x036339
    LDA #$FF
    STA SND_ARR_DATA_PTR[4],X ; Move ??
    JMP WRITE_A_TO_PAIR_LOOP_UNK ; Goto.
REINIT_STUFFS_AND_MOVE_STUFF_TODO: ; 1B:0341, 0x036341
    JSR HELPER_INIT_CTRLS_AND_TRI_AND_DMC ; Init.
    LDA SND_UNK_BF ; Move ??
    STA SOUND_ARRAY_TODO_UNK+5
    CMP #$33 ; If _ #$33
    BEQ SEED_INDEX_CLEARS ; ==, goto.
    CMP #$19 ; If _ #$19
    BEQ VAL_EQ_0x19 ; ==, goto.
    CMP #$19 ; If _ #$19
    BCC VAL_LT_0x19 ; <, goto.
VAL_EQ_0x19: ; 1B:0355, 0x036355
    JSR SUB_TODO_A ; Do ??
    JMP REENTRY_FLAG_SET_UNK ; Reentry.
SEED_INDEX_CLEARS: ; 1B:035B, 0x03635B
    LDX #$00 ; Seed index clears.
    LDY #$00
VAL_NE_INDEX: ; 1B:035F, 0x03635F
    LDA DATA_ARR_UNK,Y ; Move ??
    STA SND_ARR_UNK_LARGER?[10],X ; Store to.
    INY ; Data++
    INX ; Index++
    TXA ; X to A.
    CMP #$0A ; If _ #$0A
    BNE VAL_NE_INDEX ; !=, goto.
    JMP REENTRY_FLAG_SET_UNK ; Reender.
VAL_LT_0x19: ; 1B:036F, 0x03636F
    LDA SND_REBASED_UNK ; Load based.
    TAY ; To Y.
    LDA ROM_DATA_UNK,Y ; Load data.
    TAY ; To Y.
    LDX #$00 ; Reset index.
MOVE_DATA_LOOP: ; 1B:0379, 0x036379
    LDA DATA_MOVE_UNK_A,Y ; Move data.
    STA SND_ARR_UNK_LARGER?[10],X
    INY ; Data++
    INX ; Index++
    TXA ; X to A.
    CMP #$0A ; If _ #$0A
    BNE MOVE_DATA_LOOP ; !=, loop.
REENTRY_FLAG_SET_UNK: ; 1B:0386, 0x036386
    LDA #$01
    STA SND_FLAGS_ARR_CHANNELS_RELATED?[4] ; Store flags.
    STA SND_FLAGS_ARR_CHANNELS_RELATED?+1
    STA SND_FLAGS_ARR_CHANNELS_RELATED?+2
    STA SND_FLAGS_ARR_CHANNELS_RELATED?+3
    LDA #$00
    STA R_**:$00BA ; Clear ??
    LDY #$08 ; Data index.
LOOP_INDEX_CLEAR: ; 1B:039A, 0x03639A
    STA 7A7_ARR_UNK,Y ; Clear.
    DEY ; Index--
    BNE LOOP_INDEX_CLEAR ; !=, goto.
    TAX ; To X index.
VAL_NE_0x8: ; 1B:03A1, 0x0363A1
    LDA SOUND_CHANNEL_DATA_PTRS_L,X ; Move L.
    STA SND_ENGINE_PRIMARY_USE_PTR_A[2]
    LDA SOUND_CHANNEL_DATA_PTRS_H,X ; Load H.
    CMP #$FF ; If _ #$FF
    BEQ VAL_EQ_0xFF ; ==, goto, skip.
    STA SND_ENGINE_PRIMARY_USE_PTR_A+1 ; Store H.
    LDY FPTR_STREAM_INDEX ; Load stream index.
    LDA [SND_ENGINE_PRIMARY_USE_PTR_A[2]],Y ; Load from file.
    STA SND_ARR_DATA_PTR[4],X ; Store to ??
    INY ; Stream++
    LDA [SND_ENGINE_PRIMARY_USE_PTR_A[2]],Y ; Load from file.
WRITE_A_TO_PAIR_LOOP_UNK: ; 1B:03BA, 0x0363BA
    STA SND_ARR_DATA_PTR+1,X ; A to arr, pair.
    INX ; Index += 2
    INX
    TXA ; Index to A.
    CMP #$08 ; If _ #$08
    BNE VAL_NE_0x8 ; !=, goto.
    RTS ; Leave.
SQUARE_SWEEP_AND_TIMER_MOVE: ; 1B:03C5, 0x0363C5
    LDA SND_SQUARES_UPDATING_COUNT ; Load.
    BEQ RTS ; == 0, leave.
    CMP #$01 ; If _ #$01
    BEQ UPDATING_0x1 ; ==, goto.
    LDA #$7F
    STA APU_SQ2_SWEEP ; Disable sweep max settings.
    LDA SQ2_TIMER_COPY ; Move timer.
    STA APU_SQ2_LTIMER
    LDA SQ2_LENGTH_COPY ; Move length.
    STA APU_SQ2_LENGTH
UPDATING_0x1: ; 1B:03DF, 0x0363DF
    LDA #$7F ; Same for this.
    STA APU_SQ1_SWEEP
    LDA CHANNELS_LTIMER_COPY
    STA APU_SQ1_LTIMER
    LDA CHANNELS_LENGTH_COPY
    STA APU_SQ1_LENGTH
    LDA #$00
    STA SND_SQUARES_UPDATING_COUNT ; Reset count.
RTS: ; 1B:03F5, 0x0363F5
    RTS ; Leave.
L_1B:03F6: ; 1B:03F6, 0x0363F6
    TXA ; X to A.
    CMP #$02 ; If _ #$02
    BCS RTS ; >=, goto.
    LDA SOUND_ARR_UNK_79A,X ; Load at index.
    AND #$1F ; Keep lower.
    BEQ RTS ; == 0, goto.
    STA SOUND_PTR_REGISTER/DATA+1 ; Store nonzero.
    LDA SOUND_ARR_7C3,X ; Load ??
    CMP #$02 ; If _ #$02
    BEQ VAL_EQ_0x2 ; ==, goto.
    LDY #$00 ; Clear.
DATA_DEC: ; 1B:040D, 0x03640D
    DEC SOUND_PTR_REGISTER/DATA+1 ; --
    BEQ DEC_0x00 ; == 0, goto.
    INY ; Stream++
    INY
    BNE DATA_DEC ; != 0, goto.
DEC_0x00: ; 1B:0415, 0x036415
    LDA SND_ARR_PTR_L,Y ; Move ptr.
    STA SND_DATA_8100_PTR[2]
    LDA SND_ARR_PTR_H,Y
    STA SND_DATA_8100_PTR+1
    LDA SND_ARR_DATA_INDEX_UNK,X ; Load.
    LSR A ; >> 1, /2.
    TAY ; To Y index.
    LDA [SND_DATA_8100_PTR[2]],Y ; Load from stream.
    STA SND_NIBBLY_TEMP ; Store to.
    CMP #$FF ; If _ #$FF
    BEQ VAL_EQ_0xFF ; ==, goto.
    CMP #$F0 ; If _ #$F0
    BEQ VAL_EQ_0xF0 ; ==, goto.
    LDA SND_ARR_DATA_INDEX_UNK,X ; Load.
    AND #$01 ; Keep lower.
    BNE VAL_NE_0x1 ; !=, goto.
    LSR SND_NIBBLY_TEMP ; Nibble down.
    LSR SND_NIBBLY_TEMP
    LSR SND_NIBBLY_TEMP
    LSR SND_NIBBLY_TEMP
VAL_NE_0x1: ; 1B:043F, 0x03643F
    LDA SND_NIBBLY_TEMP ; Load nibble for command/data.
    AND #$0F ; Keep lower.
    STA SOUND_PTR_REGISTER/DATA[2] ; Store to ptr/register.
    LDA SOUND_ARR_UNK_79D_UPPER_NIBBLE_UNK,X ; Load.
    AND #$F0 ; Keep upper.
    ORA SOUND_PTR_REGISTER/DATA[2] ; Combine with.
    TAY ; To Y index.
VAL_SEEDED_ALT_WITH_INC: ; 1B:044D, 0x03644D
    INC SND_ARR_DATA_INDEX_UNK,X ; ++
DATA_WRITE_SEEDED: ; 1B:0450, 0x036450
    LDA SND_DISABLE_WRITE_ARR_UNK,X ; Load.
    BNE RTS ; != 0, goto.
    TYA ; Y to A.
    LDY SOUND_BE_WRITE_INDEXER_UNK ; Load index to write.
    STA APU_SQ1_CTRL,Y ; Write to sound channel loaded.
RTS: ; 1B:045B, 0x03645B
    RTS ; Leave.
VAL_EQ_0xFF: ; 1B:045C, 0x03645C
    LDY SOUND_ARR_UNK_79D_UPPER_NIBBLE_UNK,X ; Load index.
    BNE DATA_WRITE_SEEDED ; != 0, goto.
VAL_EQ_0xF0: ; 1B:0461, 0x036461
    LDY #$10 ; Seed ??
    BNE DATA_WRITE_SEEDED
VAL_EQ_0x2: ; 1B:0465, 0x036465
    LDY #$10 ; Seed ??
    BNE VAL_SEEDED_ALT_WITH_INC ; != 0, goto.
FILE_CONSUME_NEXT: ; 1B:0469, 0x036469
    INY ; Index++
    LDA [SND_ENGINE_PRIMARY_USE_PTR_A[2]],Y ; Load from file.
    STA SOUND_CHANNEL_DATA_PTRS_L,X ; Store to.
    INY ; Stream++
    LDA [SND_ENGINE_PRIMARY_USE_PTR_A[2]],Y ; Load from file.
    STA SOUND_CHANNEL_DATA_PTRS_H,X ; Store to, PTR H.
    LDA SOUND_CHANNEL_DATA_PTRS_L,X ; Move loaded to primary.
    STA SND_ENGINE_PRIMARY_USE_PTR_A[2]
    LDA SOUND_CHANNEL_DATA_PTRS_H,X
    STA SND_ENGINE_PRIMARY_USE_PTR_A+1
    TXA ; X to A.
    LSR A ; >> 1, /2.
    TAX ; To X index.
    LDA #$00 ; Seed ??
    TAY ; Clear Y.
    STA FPTR_STREAM_INDEX,X ; Load from index.
    JMP ENTRY_SEEDED ; Goto.
EXIT_INIT_UNK: ; 1B:048B, 0x03648B
    JSR JMP_SOUND_SEQUENCE_B_INIT_FULL_DMC? ; Init.
RTS: ; 1B:048E, 0x03648E
    RTS ; Leave.
REENTER_UNK: ; 1B:048F, 0x03648F
    TXA ; X to A.
    ASL A ; << 1, *2.
    TAX ; To X index.
    LDA SOUND_CHANNEL_DATA_PTRS_L,X ; Move ptr to use.
    STA SND_ENGINE_PRIMARY_USE_PTR_A[2]
    LDA SOUND_CHANNEL_DATA_PTRS_H,X
    STA SND_ENGINE_PRIMARY_USE_PTR_A+1
    TXA ; X to A.
    LSR A ; >> 1, /2.
    TAX ; To X again.
    INC FPTR_STREAM_INDEX,X ; ++ ??
    INC FPTR_STREAM_INDEX,X ; += 2 total.
    LDY FPTR_STREAM_INDEX,X ; Load stream index.
ENTRY_SEEDED: ; 1B:04A8, 0x0364A8
    TXA ; X to A.
    ASL A ; << 1, *2.
    TAX ; To X index.
    LDA [SND_ENGINE_PRIMARY_USE_PTR_A[2]],Y ; Load from file.
    STA SND_ARR_DATA_PTR[4],X ; Store to arr.
    INY ; Stream++
    LDA [SND_ENGINE_PRIMARY_USE_PTR_A[2]],Y ; Load from file.
    STA SND_ARR_DATA_PTR+1,X ; Store to arr.
    CMP #$00 ; If _ #$00
    BEQ EXIT_INIT_UNK ; ==, goto.
    CMP #$FF ; If _ #$FF
    BEQ FILE_CONSUME_NEXT ; ==, goto.
    TXA ; X to A.
    LSR A ; >> 1, /2.
    TAX ; To X index.
    LDA #$00 ; Clear ??
    STA SND_ARR_B6_FPTR_INDEXES,X
    LDA #$01 ; Set flag ?? done?
    STA SND_FLAGS_ARR_CHANNELS_RELATED?[4],X
    BNE CLEAR_COMPLETE ; != 0, goto. Always taken.
EXIT_JMP: ; 1B:04CD, 0x0364CD
    JMP REENTER_UNK ; Goto.
TO_NAME_IDK: ; 1B:04D0, 0x0364D0
    JSR SQUARE_SWEEP_AND_TIMER_MOVE ; Do.
    LDA #$00 ; Clear A/X.
    TAX ; To X too.
    STA SOUND_BE_WRITE_INDEXER_UNK ; Clear.
    BEQ CLEAR_COMPLETE ; == 0, goto.
VAL_EQ_0xFF: ; 1B:04DA, 0x0364DA
    TXA ; X to A.
    LSR A ; >> 1, /2.
    TAX ; To X index.
REENTRY_LONG: ; 1B:04DD, 0x0364DD
    INX ; X++
    TXA ; X to A.
    CMP #$04 ; If _ #$04
    BEQ RTS ; == 0, SQ1, goto.
    LDA SOUND_BE_WRITE_INDEXER_UNK ; Load.
    CLC ; Prep add.
    ADC #$04 ; Add with.
    STA SOUND_BE_WRITE_INDEXER_UNK ; Store to, index using.
CLEAR_COMPLETE: ; 1B:04EA, 0x0364EA
    TXA ; X to A.
    ASL A ; << 1, *2.
    TAX ; To X index.
    LDA SND_ARR_DATA_PTR[4],X ; Move ptr.
    STA SND_ENGINE_PRIMARY_USE_PTR_A[2]
    LDA SND_ARR_DATA_PTR+1,X ; Move pair.
    STA SND_ENGINE_PRIMARY_USE_PTR_A+1
    LDA SND_ARR_DATA_PTR+1,X ; Load index.
    CMP #$FF ; If _ #$FF
    BEQ VAL_EQ_0xFF ; ==, goto.
    TXA ; X to A.
    LSR A ; >> 2
    TAX ; To X index.
    DEC SND_FLAGS_ARR_CHANNELS_RELATED?[4],X ; --
    BNE FLAG_NONZERO ; != 0, ,skip still.
    LDA #$00
    STA SND_ARR_DATA_INDEX_UNK,X ; Clear ?? when 0x00
    STA SND_ARR_UNK_7D1,X
REENTRY_LOOP: ; 1B:050E, 0x03650E
    JSR STREAM_CONSUME_UNK ; Do sub.
    BEQ EXIT_JMP
    CMP #$9F ; If _ #$9F
    BEQ VAL_EQ_0x9F ; ==, goto.
    CMP #$9E ; If _ #$9E
    BEQ STREAM_UPDATE_UNK ; ==, goto.
    CMP #$9C ; If _ #$9C
    BEQ VAL_EQ_0x9C ; ==, goto.
    TAY ; To Y index.
    CMP #$FF ; If _ #$FF
    BEQ VAL_EQ_0xFF ; ==, goto.
    AND #$C0 ; Keep upper.
    CMP #$C0 ; If _ #$C0
    BEQ VAL_EQ_0xC0 ; ==, goto.
    JMP VAL_NOT_FLAGGY? ; Goto.
VAL_EQ_0xFF: ; 1B:052D, 0x03652D
    LDA SND_TIMER_ARR_UNK,X ; Load.
    BEQ EXIT_GOTO ; == 0, goto.
    DEC SND_TIMER_ARR_UNK,X ; --
    LDA SND_ARR_UNK_7B0,X ; Move ??
    STA SND_ARR_B6_FPTR_INDEXES,X
    BNE EXIT_GOTO ; != 0, goto.
VAL_EQ_0xC0: ; 1B:053D, 0x03653D
    TYA ; Y to A.
    AND #$3F ; Keep lower.
    STA SND_TIMER_ARR_UNK,X ; Store 0011.1111
    DEC SND_TIMER_ARR_UNK,X ; --
    LDA SND_ARR_B6_FPTR_INDEXES,X ; Move ??
    STA SND_ARR_UNK_7B0,X
EXIT_GOTO: ; 1B:054C, 0x03654C
    JMP REENTRY_LOOP ; Goto.
FLAG_NONZERO: ; 1B:054F, 0x03654F
    JSR L_1B:03F6 ; Do subs.
    JSR L_1B:0221 ; Do.
    JMP REENTRY_LONG ; Goto.
EXIT_DMCEE_THINGS: ; 1B:0558, 0x036558
    JMP DO_DMC_STUFFS ; Goto.
EXIT_GOTO_B: ; 1B:055B, 0x03655B
    JMP SET_UNK_HELPER ; Goto.
VAL_EQ_0x9F: ; 1B:055E, 0x03655E
    JSR STREAM_CONSUME_UNK ; Set stream.
    STA SOUND_ARR_UNK_79A,X ; Store result.
    JSR STREAM_CONSUME_UNK ; Set stream.
    STA SOUND_ARR_UNK_79D_UPPER_NIBBLE_UNK,X ; Store to.
    JMP REENTRY_LOOP ; Goto.
    JSR STREAM_CONSUME_UNK ; Do.
    JSR STREAM_CONSUME_UNK ; Do.
    JMP REENTRY_LOOP ; Goto.
STREAM_UPDATE_UNK: ; 1B:0576, 0x036576
    JSR STREAM_CONSUME_UNK ; Do.
    STA SOUND_DELTA_UNK_791 ; Store to.
    JMP REENTRY_LOOP ; Goto.
VAL_EQ_0x9C: ; 1B:057F, 0x03657F
    JSR STREAM_CONSUME_UNK ; Stream.
    STA SND_ARR_UNK_LARGER?[10] ; Store.
    JMP REENTRY_LOOP ; Goto.
VAL_NOT_FLAGGY?: ; 1B:0588, 0x036588
    TYA ; Y to A.
    AND #$B0 ; Keep 0111.0000
    CMP #$B0 ; If _ 0111.0000
    BNE VAL_NE ; !=, goto.
    TYA ; Y to A.
    AND #$0F ; Keep lower.
    CLC ; Prep add.
    ADC SOUND_DELTA_UNK_791 ; Add with.
    TAY ; A to Y.
    LDA SOUND_DATA_ARR_UNK,Y ; Move from Y to X.
    STA SOUND_ARR_UNK_7B8,X
    TAY ; A to Y.
    TXA ; X to A.
    CMP #$02 ; If _ #$02
    BEQ EXIT_GOTO_B ; ==, goto.
ENTER_UNK: ; 1B:05A3, 0x0365A3
    JSR STREAM_CONSUME_UNK ; Do ??
    TAY ; A to Y.
VAL_NE: ; 1B:05A7, 0x0365A7
    TYA ; Y to A.
    STA SOUND_ARR_7C3,X ; Store ??
    TXA ; X to A.
    CMP #$03 ; If _ #$03
    BEQ EXIT_DMCEE_THINGS ; ==, goto.
    PHA ; Save A.
    LDX SOUND_BE_WRITE_INDEXER_UNK ; Load ??
    LDA DATA_TIMER_L/UNK,Y ; Load ??
    BEQ VAL_EQ_0x00 ; ==, goto.
    LDA SND_ARR_UNK_LARGER?[10] ; Load ??
    BPL VAL_POSITIVE ; Positive, goto.
    AND #$7F ; Keep lower.
    STA SND_DATA_8100_PTR+1 ; Store to.
    TYA ; Y to A.
    CLC ; Prep add.
    SBC SND_DATA_8100_PTR+1 ; Sub with extra.
    JMP ENTRY_SET ; Goto.
VAL_POSITIVE: ; 1B:05C8, 0x0365C8
    TYA ; Y to A.
    CLC ; Prep add.
    ADC SND_ARR_UNK_LARGER?[10] ; Add with.
ENTRY_SET: ; 1B:05CD, 0x0365CD
    TAY ; A to Y.
    LDA DATA_TIMER_L/UNK,Y ; Move data.
    STA CHANNELS_LTIMER_COPY,X
    LDA LENGTH_DATA?,Y ; Move.
    ORA #$08 ; Set ??
    STA CHANNELS_LENGTH_COPY,X ; Store to.
VAL_EQ_0x00: ; 1B:05DC, 0x0365DC
    TAY ; A to Y.
    PLA ; Save A.
    TAX ; To X too.
    TYA ; Y to A.
    BNE VALUE_NE ; !=, goto.
    LDA #$00
    STA SOUND_PTR_REGISTER/DATA[2] ; Clear ??
    TXA ; X to A.
    CMP #$02 ; If _ #$02
    BEQ VAL_EQ_0x2 ; ==, goto.
    LDA #$10
    STA SOUND_PTR_REGISTER/DATA[2] ; Set ??
    BNE VAL_EQ_0x2 ; !=, goto.
VALUE_NE: ; 1B:05F1, 0x0365F1
    LDA SOUND_ARR_UNK_79D_UPPER_NIBBLE_UNK,X ; Move ??
    STA SOUND_PTR_REGISTER/DATA[2]
VAL_EQ_0x2: ; 1B:05F6, 0x0365F6
    TXA ; X to A.
    DEC SND_DISABLE_WRITE_ARR_UNK,X ; --
    CMP SND_DISABLE_WRITE_ARR_UNK,X ; If _ arr
    BEQ DO_DISABLE? ; ==, goto.
    INC SND_DISABLE_WRITE_ARR_UNK,X ; ++
    LDY SOUND_BE_WRITE_INDEXER_UNK ; Load.
    TXA ; X to A.
    CMP #$02 ; If _ #$02
    BEQ VAL_EQ_0x2 ; ==, goto.
    LDA SOUND_ARR_UNK_79A,X ; Load ??
    AND #$1F ; Keep lower.
    BEQ VAL_EQ_0x2 ; == 0, goto.
    LDA SOUND_PTR_REGISTER/DATA[2] ; Load ??
    CMP #$10 ; If _ #$10
    BEQ VAL_EQ_0x10 ; == 0, goto.
    AND #$F0 ; Keep upper.
    ORA #$00 ; Set nothing.
    BNE VAL_EQ_0x10 ; != 0, goto. Wtf is this code.
VAL_EQ_0x2: ; 1B:061C, 0x03661C
    LDA SOUND_PTR_REGISTER/DATA[2] ; Move A to channel.
VAL_EQ_0x10: ; 1B:061E, 0x03661E
    STA APU_SQ1_CTRL,Y
    LDA CHANNELS_SWEEP_COPY,X ; Move B.
    STA APU_SQ1_SWEEP,Y
    LDA CHANNELS_LTIMER_COPY,Y ; Move C.
    STA APU_SQ1_LTIMER,Y
    LDA CHANNELS_LENGTH_COPY,Y ; Move D.
    STA APU_SQ1_LENGTH,Y
DO_MOVE_RELATED: ; 1B:0633, 0x036633
    LDA SOUND_ARR_UNK_7B8,X ; Move to another.
    STA SND_FLAGS_ARR_CHANNELS_RELATED?[4],X
    JMP REENTRY_LONG ; Goto.
DO_DISABLE?: ; 1B:063C, 0x03663C
    INC SND_DISABLE_WRITE_ARR_UNK,X ; Set disable.
    JMP DO_MOVE_RELATED ; Goto.
SET_UNK_HELPER: ; 1B:0642, 0x036642
    LDA SND_UNK_79C ; Load ??
    AND #$1F ; Keep lower.
    BNE OUTPUT_UPDATE_UNK ; != 0, goto.
    LDA SND_UNK_79C ; Load ??
    AND #$C0 ; Keep upper.
    BNE UPPER_NONZERO ; != 0, goto.
UPPER_EQ_0xC0: ; 1B:0650, 0x036650
    TYA ; Y to A.
    BNE Y_NONZERO ; != 0, goto.
UPPER_NONZERO: ; 1B:0653, 0x036653
    CMP #$C0 ; If _ #$C0
    BEQ UPPER_EQ_0xC0 ; ==, goto.
    LDA #$FF ; Seed ??
    BNE OUTPUT_UPDATE_UNK ; Always taken.
Y_NONZERO: ; 1B:065B, 0x03665B
    CLC ; Prep add.
    ADC #$FF ; Sdd with.
    ASL A ; << 2, *4.
    ASL A
    CMP #$3C ; If _ #$3C
    BCC OUTPUT_UPDATE_UNK ; <, goto.
    LDA #$3C ; Seed max.
OUTPUT_UPDATE_UNK: ; 1B:0666, 0x036666
    STA SOUND_UNK_79F ; Store ??
    JMP ENTER_UNK ; Goto.
DO_DMC_STUFFS: ; 1B:066C, 0x03666C
    TYA ; Save Y.
    PHA
    JSR SUB_DO_DMC_HELPER ; Do ??
    PLA
    AND #$3F ; Range.
    TAY ; To Y again.
    JSR SUB_WRITE_DATA_TO_NOISE ; Do sub.
    JMP DO_MOVE_RELATED
SUB_WRITE_DATA_TO_NOISE: ; 1B:067B, 0x03667B
    LDA SOUND_ARRAY_TODO_UNK[7] ; Load ??
    BNE RTS ; != 0, leave.
    LDA NOISE_CTRL_DATA,Y ; Move data to register.
    STA APU_NSE_CTRL
    LDA NOISE_LOOP_DATA,Y
    STA APU_NSE_LOOP
    LDA NOISE_LENGTH_DATA,Y
    STA APU_NSE_LENGTH
RTS: ; 1B:0692, 0x036692
    RTS ; Leave.
SUB_DO_DMC_HELPER: ; 1B:0693, 0x036693
    TYA ; Y to A.
    AND #$C0 ; Keep upper.
    CMP #$40 ; If _ #$40
    BEQ UPPER_EQ_0x40 ; ==, goto.
    CMP #$80 ; If _ #$80
    BEQ VAL_EQ_0x80
    RTS ; Leave.
UPPER_EQ_0x40: ; 1B:069F, 0x03669F
    LDA #$0E
    STA SOUND_PTR_REGISTER/DATA+1 ; Set ??
    LDA #$07 ; Seed DMC.
    LDY #$00
    BEQ START_DMC_SAMPLE ; Always taken, goto.
VAL_EQ_0x80: ; 1B:06A9, 0x0366A9
    LDA #$0E
    STA SOUND_PTR_REGISTER/DATA+1 ; Set ??
    LDA #$0F ; Seed DMC.
    LDY #$02
START_DMC_SAMPLE: ; 1B:06B1, 0x0366B1
    STA APU_DMC_LENGTH ; Set DMC.
    STY APU_DMC_ADDR
    LDA SOUND_SAMPLE_FLAG_DONT_RESET_LEVEL ; Load ??
    BNE VAL_NONZERO ; != 0, leave.
    LDA SOUND_PTR_REGISTER/DATA+1 ; Move CTRL.
    STA APU_DMC_CTRL
    LDA #$0F ; Move status.
    STA APU_STATUS
    LDA #$00 ; Set load.
    STA APU_DMC_LOAD
    LDA #$1F ; Set status.
    STA APU_STATUS
VAL_NONZERO: ; 1B:06D0, 0x0366D0
    RTS ; Leave.
STREAM_CONSUME_UNK: ; 1B:06D1, 0x0366D1
    LDY SND_ARR_B6_FPTR_INDEXES,X ; Load index for.
    INC SND_ARR_B6_FPTR_INDEXES,X ; Index array to.
    LDA [SND_ENGINE_PRIMARY_USE_PTR_A[2]],Y ; Load from stream.
    RTS ; Leave.
SND_ARR_PTR_L: ; 1B:06DA, 0x0366DA
    .db 4C
SND_ARR_PTR_H: ; 1B:06DB, 0x0366DB
    .db 87
    .db 53
    .db 87
    .db 77
    .db 87
    .db 8A
    .db 87
    .db 9C
    .db 87
    .db A2
    .db 87
    .db 45
    .db 87
    .db A4
    .db 87
    .db AD
    .db 87
    .db 9F
    .db 87
    .db B6
    .db 87
    .db C3
    .db 87
    .db D1
    .db 87
    .db DE
    .db 87
    .db EA
    .db 87
    .db F4
    .db 87
    .db 3F
    .db 88
    .db 47
    .db 88
    .db 0D
    .db 88
    .db 5B
    .db 88
    .db 22
    .db 88
    .db 18
    .db 87
    .db 5D
    .db 87
    .db 3C
    .db 87
    .db 35
    .db 87
    .db 22
    .db 87
    .db 1E
    .db 87
    .db 73
    .db 87
    .db 93
    .db 87
    .db 6B
    .db 88
    .db 7F
    .db 88
    .db 76
    .db 11
    .db 11
    .db 14
    .db 31
    .db FF
    .db 33
    .db 45
    .db 66
    .db FF
    .db 43
    .db 33
    .db 22
    .db 22
    .db 22
    .db 22
    .db 22
    .db 21
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
    .db F0
    .db 23
    .db 33
    .db 32
    .db 22
    .db 22
    .db 22
    .db FF
    .db 98
    .db 76
    .db 63
    .db 22
    .db 87
    .db 76
    .db 53
    .db 11
    .db F0
    .db 23
    .db 56
    .db 78
    .db 88
    .db 88
    .db 87
    .db FF
    .db 23
    .db 34
    .db 56
    .db 77
    .db 65
    .db 54
    .db FF
    .db 5A
    .db 98
    .db 88
    .db 77
    .db 66
    .db 66
    .db 65
    .db 55
    .db 55
    .db FF
    .db 11
    .db 11
    .db 22
    .db 22
    .db 33
    .db 33
    .db 44
    .db 44
    .db 44
    .db 45
    .db 55
    .db 55
    .db 55
    .db 66
    .db 66
    .db 77
    .db 78
    .db 88
    .db 76
    .db 54
    .db 32
    .db FF
    .db 11
    .db 11
    .db 22
    .db FF
    .db 11
    .db 11
    .db 22
    .db 22
    .db 33
    .db 33
    .db 44
    .db 44
    .db 44
    .db 45
    .db 55
    .db 55
    .db 55
    .db 66
    .db 66
    .db 77
    .db 78
    .db 88
    .db FF
    .db F9
    .db 87
    .db 77
    .db 77
    .db 66
    .db 65
    .db 55
    .db 44
    .db FF
    .db C8
    .db 76
    .db 66
    .db 66
    .db 55
    .db 55
    .db 55
    .db 44
    .db FF
    .db A8
    .db 76
    .db FF
    .db 74
    .db 32
    .db FF
    .db 99
    .db FF
    .db DC
    .db BA
    .db 99
    .db 88
    .db 87
    .db 76
    .db 55
    .db 44
    .db FF
    .db 23
    .db 44
    .db 33
    .db 33
    .db 33
    .db 33
    .db 33
    .db 32
    .db FF
    .db 77
    .db 76
    .db 65
    .db 55
    .db 44
    .db 43
    .db 32
    .db 22
    .db 11
    .db 11
    .db 11
    .db 11
    .db F0
    .db 54
    .db 43
    .db 33
    .db 33
    .db 32
    .db 22
    .db 22
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db F0
    .db 43
    .db 33
    .db 22
    .db 22
    .db 22
    .db 21
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db F0
    .db 32
    .db 22
    .db 22
    .db 21
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db F0
    .db 21
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db F0
    .db 99
    .db 88
    .db 77
    .db 76
    .db 66
    .db 55
    .db 54
    .db 44
    .db 33
    .db 33
    .db 33
    .db 32
    .db 22
    .db 22
    .db 22
    .db 22
    .db 21
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db F0
    .db 65
    .db 55
    .db 54
    .db 44
    .db 33
    .db 33
    .db 33
    .db 33
    .db 22
    .db 22
    .db 22
    .db 22
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db F0
    .db FB
    .db BA
    .db AA
    .db 99
    .db 99
    .db 99
    .db 98
    .db 88
    .db 77
    .db 77
    .db 77
    .db 66
    .db 66
    .db 66
    .db 55
    .db 54
    .db 44
    .db 44
    .db 43
    .db 33
    .db 33
    .db 22
    .db 22
    .db 22
    .db 22
    .db 11
    .db 11
    .db 11
    .db F0
    .db 23
    .db 45
    .db 55
    .db 44
    .db 33
    .db 33
    .db 22
    .db FF
    .db 87
    .db 65
    .db 43
    .db 21
    .db 44
    .db 33
    .db 21
    .db 11
    .db 32
    .db 21
    .db 11
    .db 11
    .db 21
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db FF
    .db 66
    .db 65
    .db 42
    .db 21
    .db 32
    .db 21
    .db 11
    .db 11
    .db 21
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db FF
    .db A8
    .db 75
    .db 43
    .db 21
    .db 43
    .db 33
    .db 21
    .db 11
    .db 32
    .db 21
    .db 11
    .db 11
    .db 21
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db 11
    .db FF
    .db 12
    .db 33
    .db 33
    .db 34
    .db 44
    .db 44
    .db 44
    .db 44
    .db 44
    .db 44
    .db 44
    .db 44
    .db 44
    .db 44
    .db 44
    .db 22
    .db FF
LENGTH_DATA?: ; 1B:0890, 0x036890
    .db 07
DATA_TIMER_L/UNK: ; 1B:0891, 0x036891
    .db F0
    .db 00
    .db 00
    .db 06
    .db AE
    .db 06
    .db 4E
    .db 05
    .db F3
    .db 05
    .db 9E
    .db 05
    .db 4D
    .db 05
    .db 01
    .db 04
    .db B9
    .db 04
    .db 75
    .db 04
    .db 35
    .db 03
    .db F8
    .db 03
    .db BF
    .db 03
    .db 89
    .db 03
    .db 57
    .db 03
    .db 27
    .db 02
    .db F9
    .db 02
    .db CF
    .db 02
    .db A6
    .db 02
    .db 80
    .db 02
    .db 5C
    .db 02
    .db 3A
    .db 02
    .db 1A
    .db 01
    .db FC
    .db 01
    .db DF
    .db 01
    .db C4
    .db 01
    .db AB
    .db 01
    .db 93
    .db 01
    .db 7C
    .db 01
    .db 67
    .db 01
    .db 52
    .db 01
    .db 3F
    .db 01
    .db 2D
    .db 01
    .db 1C
    .db 01
    .db 0C
    .db 00
    .db FD
    .db 00
    .db EE
    .db 00
    .db E1
    .db 00
    .db D4
    .db 00
    .db C8
    .db 00
    .db BD
    .db 00
    .db B2
    .db 00
    .db A8
    .db 00
    .db 9F
    .db 00
    .db 96
    .db 00
    .db 8D
    .db 00
    .db 85
    .db 00
    .db 7E
    .db 00
    .db 76
    .db 00
    .db 70
    .db 00
    .db 69
    .db 00
    .db 63
    .db 00
    .db 5E
    .db 00
    .db 58
    .db 00
    .db 53
    .db 00
    .db 4F
    .db 00
    .db 4A
    .db 00
    .db 46
    .db 00
    .db 42
    .db 00
    .db 3E
    .db 00
    .db 3A
    .db 00
    .db 37
    .db 00
    .db 34
    .db 00
    .db 31
    .db 00
    .db 2E
    .db 00
    .db 2B
    .db 00
    .db 29
    .db 00
    .db 0A
    .db 00
    .db 01
SOUND_DATA_ARR_UNK: ; 1B:091A, 0x03691A
    .db 04
    .db 08
    .db 10
    .db 20
    .db 40
    .db 18
    .db 30
    .db 0C
    .db 0A
    .db 05
    .db 02
    .db 01
    .db 05
    .db 0A
    .db 14
    .db 28
    .db 50
    .db 1E
    .db 3C
    .db 0F
    .db 0C
    .db 06
    .db 03
    .db 02
    .db 06
    .db 0C
    .db 18
    .db 30
    .db 60
    .db 24
    .db 48
    .db 12
    .db 10
    .db 08
    .db 03
    .db 01
    .db 04
    .db 02
    .db 00
    .db 90
    .db 07
    .db 0E
    .db 1C
    .db 38
    .db 70
    .db 2A
    .db 54
    .db 15
    .db 12
    .db 09
    .db 03
    .db 01
    .db 02
    .db 07
    .db 0F
    .db 1E
    .db 3C
    .db 78
    .db 2D
    .db 5A
    .db 16
    .db 14
    .db 0A
    .db 03
    .db 01
    .db 08
    .db 08
    .db 10
    .db 20
    .db 40
    .db 80
    .db 30
    .db 60
    .db 18
    .db 15
    .db 0A
    .db 04
    .db 01
    .db 02
    .db C0
    .db 09
    .db 12
    .db 24
    .db 48
    .db 90
    .db 36
    .db 6C
    .db 1B
    .db 18
    .db 0A
    .db 14
    .db 28
    .db 50
    .db A0
    .db 3C
    .db 78
    .db 1E
    .db 1A
    .db 0D
    .db 05
    .db 01
    .db 02
    .db 17
    .db 0B
    .db 16
    .db 2C
    .db 58
    .db B0
    .db 42
    .db 84
    .db 21
    .db 1D
    .db 0E
    .db 05
    .db 01
    .db 02
    .db 17
ROM_DATA_UNK: ; 1B:098F, 0x03698F
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
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
    .db 00
REBASE_DATA_UNK_A: ; 1B:09A7, 0x0369A7
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
DATA_MOVE_UNK_A: ; 1B:09C3, 0x0369C3
    .db 00
    .db 28
    .db BF
    .db 8C
    .db B1
    .db 8C
    .db D1
    .db 8C
    .db DD
    .db 8C
DATA_ARR_UNK: ; 1B:09CD, 0x0369CD
    .db 00
    .db 18
    .db 6B
    .db 8E
    .db 79
    .db 8E
    .db 87
    .db 8E
    .db 9F
    .db 8E
    .db 9F
    .db B3
    .db B1
    .db B4
    .db 5A
    .db B3
    .db 64
    .db 62
    .db B4
    .db 5A
    .db B3
    .db 50
    .db 4C
    .db B4
    .db 4C
    .db B3
    .db 48
    .db 46
    .db B4
    .db 46
    .db 50
    .db 00
    .db 9F
    .db 0E
    .db B1
    .db B3
    .db 34
    .db 42
    .db 54
    .db 50
    .db 32
    .db 42
    .db B4
    .db 4A
    .db B3
    .db 30
    .db 42
    .db B4
    .db 50
    .db B3
    .db 2E
    .db 38
    .db B4
    .db 40
    .db 00
    .db C8
    .db B4
    .db 02
    .db FF
    .db 00
    .db C8
    .db B4
    .db 01
    .db FF
    .db 00
    .db 9C
    .db 8D
    .db 00
    .db 9F
    .db 13
    .db B5
    .db B2
    .db 68
    .db 6C
    .db 70
    .db 76
    .db B4
    .db 6C
    .db B2
    .db 80
    .db 7E
    .db 7A
    .db 70
    .db B4
    .db 76
    .db B2
    .db 7A
    .db 7E
    .db 80
    .db B3
    .db 76
    .db B6
    .db 68
    .db B2
    .db 72
    .db 70
    .db 68
    .db B4
    .db 5E
    .db B2
    .db 02
    .db B3
    .db 62
    .db 66
    .db 68
    .db 72
    .db B2
    .db 70
    .db 72
    .db 76
    .db 70
    .db 6C
    .db 70
    .db 72
    .db 6C
    .db B2
    .db 62
    .db 72
    .db 70
    .db 5E
    .db B3
    .db 6C
    .db 66
    .db B3
    .db 68
    .db 9F
    .db 0C
    .db B5
    .db B2
    .db 5E
    .db 9F
    .db 0D
    .db B5
    .db B2
    .db 6C
    .db 9F
    .db 0E
    .db B5
    .db B4
    .db 68
    .db 02
    .db 02
    .db 00
    .db 9F
    .db 10
    .db B5
    .db B2
    .db 68
    .db 6C
    .db 70
    .db 76
    .db B4
    .db 6C
    .db B2
    .db 80
    .db 7E
    .db 7A
    .db 70
    .db B4
    .db 76
    .db B2
    .db 7A
    .db 7E
    .db 80
    .db B3
    .db 76
    .db B6
    .db 68
    .db B2
    .db 72
    .db 70
    .db 68
    .db B4
    .db 5E
    .db B2
    .db 02
    .db B3
    .db 62
    .db 66
    .db 68
    .db 72
    .db B2
    .db 70
    .db 72
    .db 76
    .db 70
    .db 6C
    .db 70
    .db 72
    .db 6C
    .db B2
    .db 62
    .db 72
    .db 70
    .db 5E
    .db B3
    .db 6C
    .db 66
    .db B3
    .db 68
    .db B2
    .db 5E
    .db 6C
    .db B4
    .db 68
    .db 00
    .db B2
    .db 50
    .db 58
    .db 5E
    .db 68
    .db 42
    .db 50
    .db 5A
    .db 62
    .db 4A
    .db 50
    .db 58
    .db 62
    .db 40
    .db 4E
    .db 58
    .db 5E
    .db 42
    .db 50
    .db 5A
    .db 58
    .db 02
    .db 58
    .db 5E
    .db 68
    .db 42
    .db 50
    .db 5A
    .db 4E
    .db 02
    .db 54
    .db 5E
    .db 66
    .db 42
    .db 5A
    .db 46
    .db 5E
    .db 4A
    .db 62
    .db 4E
    .db 66
    .db 50
    .db 58
    .db 5E
    .db 58
    .db 46
    .db 4E
    .db 54
    .db 5E
    .db 42
    .db 50
    .db 5A
    .db 50
    .db 46
    .db 54
    .db 5E
    .db 66
    .db 9F
    .db 0C
    .db B1
    .db 50
    .db 5E
    .db 02
    .db 02
    .db 9F
    .db 1A
    .db B1
    .db B4
    .db 58
    .db 02
    .db 02
    .db 00
    .db 9F
    .db 0C
    .db B1
    .db B2
    .db 50
    .db 58
    .db 5E
    .db 68
    .db 42
    .db 50
    .db 5A
    .db 62
    .db 4A
    .db 50
    .db 58
    .db 62
    .db 40
    .db 4E
    .db 58
    .db 5E
    .db 42
    .db 50
    .db 5A
    .db 58
    .db 02
    .db 58
    .db 5E
    .db 68
    .db 42
    .db 50
    .db 5A
    .db 4E
    .db 02
    .db 54
    .db 5E
    .db 66
    .db 42
    .db 5A
    .db 46
    .db 5E
    .db 4A
    .db 62
    .db 4E
    .db 66
    .db 50
    .db 58
    .db 5E
    .db 58
    .db 46
    .db 4E
    .db 54
    .db 5E
    .db 42
    .db 50
    .db 5A
    .db 50
    .db 46
    .db 54
    .db 5E
    .db 66
    .db 50
    .db 5E
    .db 02
    .db 02
    .db 70
    .db 68
    .db 5E
    .db 58
    .db 00
    .db D0
    .db B4
    .db 02
    .db FF
    .db 00
    .db 9F
    .db A7
    .db F6
    .db C3
    .db B3
    .db 4A
    .db B2
    .db 4C
    .db 50
    .db B3
    .db 50
    .db 54
    .db B3
    .db 46
    .db B2
    .db 4A
    .db 4C
    .db B3
    .db 4A
    .db 42
    .db B3
    .db 42
    .db B2
    .db 46
    .db 3C
    .db B2
    .db 40
    .db 42
    .db 46
    .db 4A
    .db B3
    .db 40
    .db 3C
    .db B4
    .db 38
    .db FF
    .db B3
    .db 4A
    .db B2
    .db 50
    .db 5A
    .db B3
    .db 54
    .db 4C
    .db B3
    .db 50
    .db B2
    .db 46
    .db 4C
    .db B6
    .db 4A
    .db B1
    .db 4A
    .db 46
    .db B3
    .db 42
    .db B2
    .db 46
    .db 4A
    .db B3
    .db 46
    .db 3C
    .db 42
    .db 40
    .db 42
    .db 46
    .db 9F
    .db A7
    .db F3
    .db B4
    .db 4A
    .db B3
    .db 46
    .db 50
    .db B4
    .db 4A
    .db 46
    .db 9F
    .db 09
    .db F2
    .db B4
    .db 46
    .db 00
    .db 9F
    .db A7
    .db B2
    .db C2
    .db B1
    .db 5A
    .db 50
    .db 4A
    .db 42
    .db 38
    .db 42
    .db 4A
    .db 50
    .db 5A
    .db 54
    .db 4C
    .db 42
    .db 3C
    .db 42
    .db 4C
    .db 54
    .db 58
    .db 50
    .db 46
    .db 40
    .db 38
    .db 40
    .db 46
    .db 50
    .db 50
    .db 4A
    .db 42
    .db 38
    .db 32
    .db 38
    .db 42
    .db 4A
    .db 50
    .db 4A
    .db 42
    .db 3C
    .db 36
    .db 3C
    .db 42
    .db 4A
    .db 4E
    .db 46
    .db 3C
    .db 36
    .db 2E
    .db 36
    .db 3C
    .db 46
    .db 50
    .db 46
    .db 40
    .db 38
    .db 2E
    .db 38
    .db 40
    .db 46
    .db 50
    .db 4C
    .db 46
    .db 40
    .db 38
    .db 34
    .db 2E
    .db 28
    .db FF
    .db C2
    .db B0
    .db 5A
    .db 50
    .db 4A
    .db 42
    .db 38
    .db 42
    .db 4A
    .db 50
    .db FF
    .db C2
    .db 5A
    .db 54
    .db 4C
    .db 42
    .db 3C
    .db 42
    .db 4C
    .db 54
    .db FF
    .db C2
    .db 58
    .db 50
    .db 46
    .db 40
    .db 38
    .db 40
    .db 46
    .db 50
    .db FF
    .db C2
    .db 50
    .db 4A
    .db 42
    .db 38
    .db 32
    .db 38
    .db 42
    .db 4A
    .db FF
    .db 50
    .db 4A
    .db 42
    .db 3C
    .db 38
    .db 32
    .db 2A
    .db 24
    .db 20
    .db 24
    .db 2A
    .db 32
    .db 3C
    .db 42
    .db 4A
    .db 50
    .db 54
    .db 4E
    .db 46
    .db 42
    .db 3C
    .db 36
    .db 2E
    .db 2A
    .db 24
    .db 2E
    .db 36
    .db 3C
    .db 42
    .db 46
    .db 4E
    .db 54
    .db C2
    .db 50
    .db 46
    .db 40
    .db 38
    .db 2E
    .db 38
    .db 40
    .db 46
    .db FF
    .db C2
    .db 50
    .db 4C
    .db 46
    .db 40
    .db 38
    .db 34
    .db 2E
    .db 28
    .db FF
    .db 00
    .db 9F
    .db A9
    .db B2
    .db C2
    .db B2
    .db 5A
    .db 50
    .db 4A
    .db 50
    .db 5A
    .db 4C
    .db 46
    .db 4C
    .db FF
    .db 9F
    .db 0E
    .db B1
    .db 5A
    .db 4C
    .db 46
    .db 4C
    .db 00
    .db C2
    .db B4
    .db 42
    .db 34
    .db 38
    .db 42
    .db 3C
    .db 46
    .db 38
    .db B3
    .db 38
    .db 34
    .db FF
    .db B3
    .db 2A
    .db B2
    .db 2E
    .db 32
    .db B3
    .db 34
    .db 1C
    .db B3
    .db 20
    .db B2
    .db 28
    .db 2E
    .db B6
    .db 2A
    .db B2
    .db 28
    .db 24
    .db 20
    .db B3
    .db 1E
    .db B4
    .db 2E
    .db 20
    .db B3
    .db 38
    .db 34
    .db B3
    .db 42
    .db B2
    .db 46
    .db 4A
    .db B3
    .db 4C
    .db 34
    .db B3
    .db 38
    .db B2
    .db 40
    .db 46
    .db B6
    .db 42
    .db B2
    .db 40
    .db 3C
    .db 38
    .db B3
    .db 36
    .db B4
    .db 2E
    .db 20
    .db 32
    .db 2A
    .db 26
    .db 2A
    .db 26
    .db 26
    .db 00
    .db C7
    .db B3
    .db 41
    .db 04
    .db B5
    .db 41
    .db B1
    .db 04
    .db B3
    .db 07
    .db FF
    .db B3
    .db 41
    .db B5
    .db 81
    .db B0
    .db 41
    .db 41
    .db B1
    .db 81
    .db 41
    .db 01
    .db 41
    .db 01
    .db 41
    .db 81
    .db 01
    .db C8
    .db B2
    .db 44
    .db 04
    .db 81
    .db 04
    .db B1
    .db 04
    .db 41
    .db 44
    .db 01
    .db B2
    .db 81
    .db 04
    .db FF
    .db C4
    .db B3
    .db 01
    .db 04
    .db FF
    .db 00
    .db 5C
    .db 8A
    .db EB
    .db 8C
    .db D7
    .db 89
    .db 2D
    .db 8B
    .db 5C
    .db 8A
    .db 11
    .db 8A
    .db 00
    .db 00
    .db E3
    .db 8A
    .db 2C
    .db 8D
    .db ED
    .db 89
    .db 80
    .db 8B
    .db C6
    .db 8B
    .db 24
    .db 8C
    .db 0E
    .db 8A
    .db E3
    .db 8A
    .db 9B
    .db 8A
    .db FA
    .db 8D
    .db 24
    .db 8E
    .db 04
    .db 8A
    .db 3A
    .db 8C
    .db 28
    .db 8B
    .db 28
    .db 8B
    .db 48
    .db 8E
    .db 4D
    .db 8E
    .db 09
    .db 8A
    .db 81
    .db 8C
    .db 48
    .db 8E
    .db 48
    .db 8E
    .db 48
    .db 8E
    .db 9F
    .db 10
    .db B1
    .db C2
    .db B2
    .db 50
    .db 54
    .db 58
    .db 5E
    .db B4
    .db 54
    .db B2
    .db 68
    .db 66
    .db 62
    .db 58
    .db B4
    .db 5E
    .db B2
    .db 62
    .db 66
    .db 68
    .db B3
    .db 5E
    .db B6
    .db 50
    .db B2
    .db 5A
    .db 58
    .db 50
    .db B4
    .db 46
    .db B2
    .db 02
    .db B3
    .db 4A
    .db 4E
    .db 50
    .db 5A
    .db B2
    .db 58
    .db 5A
    .db 5E
    .db 58
    .db 54
    .db 58
    .db 5A
    .db 54
    .db B2
    .db 4A
    .db 5A
    .db 58
    .db 46
    .db B3
    .db 54
    .db 4E
    .db B3
    .db 50
    .db B2
    .db 46
    .db 54
    .db B4
    .db 50
    .db FF
    .db 00
    .db 9F
    .db B4
    .db B1
    .db B2
    .db 5E
    .db 70
    .db 5E
    .db 70
    .db 62
    .db 72
    .db 62
    .db 72
    .db 62
    .db 70
    .db 62
    .db 70
    .db 5E
    .db 70
    .db 5E
    .db 70
    .db 62
    .db 72
    .db 62
    .db B3
    .db 5E
    .db B2
    .db 70
    .db 5E
    .db 70
    .db 62
    .db 72
    .db 62
    .db B3
    .db 66
    .db B2
    .db 76
    .db 66
    .db 76
    .db 62
    .db 72
    .db 62
    .db B3
    .db 72
    .db B2
    .db 62
    .db B3
    .db 72
    .db B2
    .db 5E
    .db 70
    .db 5E
    .db 70
    .db 5A
    .db 6C
    .db 5A
    .db 6C
    .db 62
    .db 72
    .db 62
    .db 72
    .db 66
    .db 76
    .db 66
    .db 76
    .db 68
    .db 70
    .db 76
    .db 70
    .db 80
    .db 76
    .db 70
    .db 68
    .db 9F
    .db A9
    .db B2
    .db B1
    .db 46
    .db 40
    .db 46
    .db 40
    .db 4A
    .db 40
    .db 46
    .db 40
    .db 46
    .db 42
    .db 46
    .db 42
    .db 4A
    .db 42
    .db 46
    .db 42
    .db 46
    .db 40
    .db 46
    .db 40
    .db 4A
    .db 40
    .db 46
    .db 40
    .db 46
    .db 40
    .db 46
    .db 40
    .db 4A
    .db 40
    .db 46
    .db 40
    .db 46
    .db 42
    .db 46
    .db 42
    .db 4A
    .db 42
    .db B5
    .db 46
    .db B1
    .db 40
    .db 46
    .db 40
    .db 4A
    .db 40
    .db B5
    .db 46
    .db B1
    .db 42
    .db 46
    .db 42
    .db 4A
    .db 42
    .db B5
    .db 46
    .db B1
    .db 3C
    .db 46
    .db 3C
    .db 4A
    .db 3C
    .db B2
    .db 46
    .db B1
    .db 4A
    .db 42
    .db 4A
    .db 42
    .db 4E
    .db 42
    .db 4E
    .db 42
    .db 50
    .db 42
    .db 50
    .db 42
    .db 54
    .db 42
    .db 54
    .db 42
    .db 58
    .db 50
    .db 46
    .db 40
    .db 50
    .db 46
    .db 40
    .db 38
    .db 3C
    .db 46
    .db 4E
    .db 46
    .db 54
    .db 4E
    .db 46
    .db 4E
    .db 4A
    .db 38
    .db 4A
    .db 38
    .db 4A
    .db 38
    .db 4A
    .db 38
    .db 4E
    .db 3C
    .db 4E
    .db 3C
    .db 4E
    .db 3C
    .db 4E
    .db 3C
    .db 50
    .db 40
    .db 50
    .db 40
    .db 50
    .db 40
    .db 50
    .db 40
    .db 50
    .db 46
    .db 40
    .db 38
    .db 46
    .db 40
    .db 38
    .db 40
    .db 00
    .db 9F
    .db A0
    .db 00
    .db B4
    .db 50
    .db 5A
    .db B4
    .db 4A
    .db B6
    .db 40
    .db B1
    .db 40
    .db 02
    .db B6
    .db 42
    .db B4
    .db 50
    .db B2
    .db 02
    .db B6
    .db 42
    .db B4
    .db 46
    .db B2
    .db 02
    .db B3
    .db 42
    .db 46
    .db 4A
    .db 4E
    .db B4
    .db 50
    .db 46
    .db B4
    .db 42
    .db 46
    .db 50
    .db B6
    .db 38
    .db B2
    .db 02
    .db 00
    .db 9F
    .db A0
    .db 00
    .db C2
    .db B4
    .db 38
    .db 42
    .db 32
    .db 28
    .db B6
    .db 2A
    .db B4
    .db 38
    .db B2
    .db 02
    .db B6
    .db 2A
    .db B4
    .db 2E
    .db B2
    .db 02
    .db B3
    .db 2A
    .db 2E
    .db 32
    .db 36
    .db B4
    .db 38
    .db 2E
    .db B4
    .db 2A
    .db 2E
    .db 38
    .db 20
    .db FF
    .db 00
    .db D0
    .db B4
    .db 01
    .db FF
    .db 00
    .db C8
    .db B3
    .db 01
    .db 04
    .db FF
    .db C8
    .db B3
    .db 01
    .db 04
    .db FF
    .db B3
    .db 01
    .db B1
    .db 25
    .db 28
    .db 2B
    .db 2E
    .db CF
    .db B1
    .db 2E
    .db 2E
    .db B2
    .db 01
    .db B1
    .db 25
    .db 28
    .db 2B
    .db 2B
    .db FF
    .db 00
    .db BB
    .db 8E
    .db 28
    .db 90
    .db 7E
    .db 93
    .db B8
    .db 93
    .db 03
    .db 94
    .db FF
    .db FF
    .db 73
    .db 8E
    .db FB
    .db 8E
    .db AA
    .db 90
    .db 3D
    .db 91
    .db 6B
    .db 91
    .db 45
    .db 94
    .db FF
    .db FF
    .db 81
    .db 8E
    .db 46
    .db 8F
    .db 76
    .db 8F
    .db 76
    .db 8F
    .db E8
    .db 8F
    .db 05
    .db 90
    .db E8
    .db 8F
    .db 0F
    .db 90
    .db E4
    .db 91
    .db 29
    .db 92
    .db AF
    .db 8E
    .db FF
    .db FF
    .db 99
    .db 8E
    .db 86
    .db 8F
    .db AA
    .db 8F
    .db 79
    .db 92
    .db 9F
    .db 92
    .db 33
    .db 93
    .db B5
    .db 8E
    .db FF
    .db FF
    .db A9
    .db 8E
    .db B4
    .db 02
    .db 02
    .db 02
    .db 02
    .db 00
    .db B4
    .db 01
    .db 01
    .db 01
    .db 01
    .db 00
    .db 9F
    .db 04
    .db 13
    .db C4
    .db B2
    .db 02
    .db B5
    .db 24
    .db 28
    .db 20
    .db B1
    .db 02
    .db 20
    .db B5
    .db 28
    .db B2
    .db 02
    .db B5
    .db 24
    .db 28
    .db B3
    .db 1E
    .db 20
    .db FF
    .db B4
    .db 2C
    .db 2C
    .db B1
    .db 2C
    .db 2C
    .db 02
    .db 02
    .db B3
    .db 2C
    .db B1
    .db 02
    .db 2E
    .db 28
    .db 2A
    .db 3C
    .db 3A
    .db 38
    .db 36
    .db B4
    .db 2C
    .db 2C
    .db B1
    .db 2C
    .db 2C
    .db 02
    .db 02
    .db B3
    .db 2C
    .db B1
    .db 38
    .db B5
    .db 38
    .db B1
    .db 38
    .db B4
    .db 38
    .db B5
    .db 02
    .db 00
    .db 9F
    .db 04
    .db 13
    .db C4
    .db B1
    .db 0C
    .db 0C
    .db 2C
    .db 0C
    .db 0C
    .db 2E
    .db 0C
    .db 0C
    .db 28
    .db 0C
    .db 0C
    .db 0C
    .db 28
    .db 2E
    .db 0C
    .db 0C
    .db 0C
    .db 0C
    .db 2C
    .db 0C
    .db 0C
    .db 2E
    .db 0C
    .db 0C
    .db B3
    .db 2E
    .db 2E
    .db FF
    .db B4
    .db 24
    .db 22
    .db B1
    .db 1E
    .db 1E
    .db 02
    .db 02
    .db B3
    .db 1E
    .db B1
    .db 02
    .db 16
    .db 10
    .db 12
    .db 24
    .db 22
    .db 20
    .db B4
    .db 1E
    .db B1
    .db 24
    .db B4
    .db 22
    .db B1
    .db 1E
    .db 1E
    .db 02
    .db 02
    .db B3
    .db 1E
    .db B1
    .db 2E
    .db B5
    .db 32
    .db B1
    .db 28
    .db B4
    .db 2A
    .db B5
    .db 02
    .db 00
    .db 9F
    .db A0
    .db 00
    .db B4
    .db 24
    .db B3
    .db 3C
    .db B1
    .db 3C
    .db 4A
    .db 54
    .db 4A
    .db B4
    .db 24
    .db B3
    .db 1E
    .db 20
    .db B4
    .db 24
    .db B3
    .db 3C
    .db B1
    .db 02
    .db 4A
    .db 54
    .db 4A
    .db B4
    .db 3C
    .db B3
    .db 1E
    .db BA
    .db 46
    .db 44
    .db 42
    .db 40
    .db 3E
    .db 3C
    .db 3A
    .db 38
    .db 36
    .db 34
    .db 32
    .db 30
    .db 2E
    .db 2C
    .db 2A
    .db 26
    .db 00
    .db 9F
    .db 00
    .db 00
    .db CC
    .db B1
    .db 24
    .db 24
    .db FF
    .db B8
    .db 1E
    .db 24
    .db 2E
    .db 20
    .db 24
    .db 2E
    .db 00
    .db C6
    .db B2
    .db 01
    .db 04
    .db FF
    .db B1
    .db 81
    .db 41
    .db 81
    .db 81
    .db 41
    .db 81
    .db 81
    .db 41
    .db 41
    .db 01
    .db 04
    .db 01
    .db C5
    .db B2
    .db 01
    .db 04
    .db FF
    .db C8
    .db B0
    .db 81
    .db FF
    .db B1
    .db 81
    .db 41
    .db B0
    .db 81
    .db 81
    .db B1
    .db 41
    .db 00
    .db C8
    .db 44
    .db 04
    .db 84
    .db 04
    .db 44
    .db 44
    .db 84
    .db 04
    .db FF
    .db C5
    .db B1
    .db 44
    .db 44
    .db 84
    .db 44
    .db FF
    .db 44
    .db 44
    .db C4
    .db B0
    .db 81
    .db FF
    .db B1
    .db 81
    .db C2
    .db 84
    .db 44
    .db 44
    .db FF
    .db 44
    .db C5
    .db 44
    .db 44
    .db 84
    .db 44
    .db FF
    .db 44
    .db 44
    .db C4
    .db B0
    .db 81
    .db FF
    .db C2
    .db B1
    .db 84
    .db 44
    .db 01
    .db 01
    .db FF
    .db 04
    .db 01
    .db 04
    .db 01
    .db 81
    .db 41
    .db B0
    .db 81
    .db 41
    .db 81
    .db 41
    .db 00
    .db 9F
    .db 00
    .db 00
    .db C5
    .db B1
    .db 1E
    .db B0
    .db 1E
    .db 36
    .db FF
    .db B1
    .db 1E
    .db 32
    .db 32
    .db 36
    .db 32
    .db 32
    .db 32
    .db 2E
    .db 2E
    .db 02
    .db C2
    .db B1
    .db 2E
    .db B0
    .db 2E
    .db 2E
    .db FF
    .db 00
    .db B1
    .db 02
    .db 2E
    .db 28
    .db 2A
    .db 3C
    .db 3A
    .db 38
    .db 36
    .db 00
    .db 9F
    .db A0
    .db 00
    .db B1
    .db 28
    .db B5
    .db 2A
    .db B1
    .db 2E
    .db B4
    .db 32
    .db BA
    .db 32
    .db 30
    .db 2E
    .db 2C
    .db 2A
    .db 28
    .db 26
    .db 24
    .db 22
    .db 20
    .db 1E
    .db 1C
    .db 00
    .db 9F
    .db 04
    .db 13
    .db B2
    .db 02
    .db B5
    .db 24
    .db 20
    .db 28
    .db 24
    .db B1
    .db 20
    .db 24
    .db 02
    .db 02
    .db B5
    .db 24
    .db 20
    .db B4
    .db 1A
    .db B2
    .db 02
    .db B5
    .db 24
    .db 20
    .db 28
    .db 24
    .db B1
    .db 20
    .db 24
    .db 02
    .db 02
    .db B5
    .db 24
    .db 20
    .db B3
    .db 1A
    .db B1
    .db 2E
    .db 2E
    .db 2E
    .db 2E
    .db 9F
    .db 0D
    .db 13
    .db 2E
    .db 2E
    .db 2E
    .db 2E
    .db 2E
    .db 2E
    .db 2E
    .db 2E
    .db 2E
    .db 2E
    .db 2E
    .db 2E
    .db 9F
    .db 04
    .db 13
    .db 2E
    .db 2E
    .db 2E
    .db 2E
    .db 9F
    .db 0D
    .db 13
    .db 2E
    .db 2E
    .db 2E
    .db 2E
    .db 2E
    .db 2E
    .db 2E
    .db 2E
    .db 9F
    .db 0C
    .db 13
    .db 2E
    .db 2E
    .db 2E
    .db 2E
    .db 2E
    .db 2E
    .db 2E
    .db 2E
    .db 9F
    .db 04
    .db 13
    .db B2
    .db 12
    .db B5
    .db 36
    .db 32
    .db 38
    .db 36
    .db B1
    .db 32
    .db 36
    .db B2
    .db 16
    .db B5
    .db 36
    .db 32
    .db B4
    .db 2A
    .db 9F
    .db A7
    .db F3
    .db B2
    .db 04
    .db B5
    .db 42
    .db 40
    .db 38
    .db B3
    .db 3C
    .db B1
    .db 02
    .db B2
    .db 08
    .db B5
    .db 42
    .db 40
    .db 46
    .db B3
    .db 3C
    .db B1
    .db 02
    .db 00
    .db 9F
    .db 04
    .db 13
    .db B1
    .db 0C
    .db 0C
    .db 2C
    .db 0C
    .db 0C
    .db 28
    .db 0C
    .db 0C
    .db 2E
    .db 0C
    .db 0C
    .db 2C
    .db 0C
    .db 0C
    .db 28
    .db 2C
    .db 0C
    .db 0C
    .db 2C
    .db 0C
    .db 0C
    .db 28
    .db 0C
    .db 0C
    .db B4
    .db 20
    .db B1
    .db 0C
    .db 0C
    .db 2C
    .db 0C
    .db 0C
    .db 28
    .db 0C
    .db 0C
    .db 2E
    .db 0C
    .db 0C
    .db 2C
    .db 0C
    .db 0C
    .db 28
    .db 2C
    .db 0C
    .db 0C
    .db 2C
    .db 0C
    .db 0C
    .db 28
    .db 0C
    .db 0C
    .db B3
    .db 20
    .db 9F
    .db 04
    .db 13
    .db B1
    .db 06
    .db 06
    .db 06
    .db 08
    .db 9F
    .db 0D
    .db 13
    .db 08
    .db 9F
    .db 0C
    .db 13
    .db 24
    .db 9F
    .db 0D
    .db 13
    .db 08
    .db 08
    .db 9F
    .db 0C
    .db 13
    .db 24
    .db 9F
    .db 0D
    .db 13
    .db 08
    .db 08
    .db 9F
    .db 0C
    .db 13
    .db 24
    .db 9F
    .db 0D
    .db 13
    .db 08
    .db 08
    .db 08
    .db 08
    .db 9F
    .db 04
    .db 13
    .db B1
    .db 06
    .db 06
    .db 06
    .db 08
    .db 9F
    .db 0D
    .db 13
    .db 08
    .db 9F
    .db 0C
    .db 13
    .db 24
    .db 9F
    .db 0D
    .db 13
    .db 08
    .db 08
    .db 9F
    .db 0C
    .db 13
    .db 24
    .db 9F
    .db 0D
    .db 13
    .db 08
    .db 08
    .db 9F
    .db 0C
    .db 13
    .db 24
    .db 9F
    .db 0C
    .db 13
    .db 08
    .db 08
    .db 08
    .db 08
    .db 9F
    .db 1D
    .db 13
    .db 08
    .db 08
    .db 08
    .db 08
    .db 00
    .db 9F
    .db 1D
    .db 13
    .db B1
    .db 12
    .db 12
    .db 2E
    .db 12
    .db 12
    .db 2A
    .db 12
    .db 12
    .db 32
    .db 12
    .db 12
    .db 2E
    .db 12
    .db 12
    .db 2A
    .db 2E
    .db 16
    .db 16
    .db 2E
    .db 16
    .db 16
    .db 2A
    .db 16
    .db 16
    .db 24
    .db 16
    .db 16
    .db B0
    .db 16
    .db 16
    .db B1
    .db 16
    .db B0
    .db 16
    .db 16
    .db 9F
    .db 04
    .db 13
    .db B1
    .db 16
    .db 1A
    .db 00
    .db 9F
    .db B9
    .db B2
    .db C4
    .db B0
    .db 50
    .db 46
    .db 42
    .db 46
    .db FF
    .db C2
    .db 50
    .db 46
    .db 42
    .db 38
    .db 2E
    .db 2A
    .db 2E
    .db 38
    .db FF
    .db C2
    .db 50
    .db 46
    .db 50
    .db 46
    .db 42
    .db 46
    .db 50
    .db 46
    .db FF
    .db C2
    .db 50
    .db 46
    .db 42
    .db 38
    .db 2E
    .db 2A
    .db 2E
    .db 38
    .db FF
    .db 9F
    .db BE
    .db F1
    .db B2
    .db 4A
    .db 4E
    .db B1
    .db 54
    .db B5
    .db 58
    .db B2
    .db 5C
    .db 54
    .db B1
    .db 4E
    .db B5
    .db 54
    .db 9F
    .db B0
    .db F2
    .db B5
    .db 54
    .db B3
    .db 54
    .db B1
    .db 02
    .db B5
    .db 54
    .db B3
    .db 54
    .db B1
    .db 02
    .db 9F
    .db A9
    .db F2
    .db B4
    .db 2C
    .db 02
    .db 9F
    .db AF
    .db B1
    .db B3
    .db 3C
    .db 44
    .db 38
    .db 44
    .db 9F
    .db AE
    .db B1
    .db 36
    .db 44
    .db 9F
    .db AD
    .db B1
    .db 34
    .db 44
    .db 9F
    .db AC
    .db B1
    .db 3C
    .db 44
    .db 38
    .db 44
    .db 36
    .db 44
    .db 9F
    .db AD
    .db B1
    .db 34
    .db 44
    .db 9F
    .db BC
    .db B2
    .db B4
    .db 4A
    .db 9F
    .db BC
    .db B1
    .db 32
    .db 24
    .db 00
    .db 9F
    .db A0
    .db 00
    .db B4
    .db 24
    .db B3
    .db 3C
    .db B1
    .db 3C
    .db 4A
    .db 54
    .db 4A
    .db B4
    .db 24
    .db 24
    .db B4
    .db 24
    .db B3
    .db 3C
    .db B1
    .db 3C
    .db 4A
    .db 54
    .db 4A
    .db B4
    .db 24
    .db B3
    .db 24
    .db 9F
    .db 00
    .db 00
    .db B1
    .db 1E
    .db 1E
    .db 1E
    .db 20
    .db 20
    .db 38
    .db 20
    .db 20
    .db 38
    .db 20
    .db 20
    .db 20
    .db 20
    .db 20
    .db 20
    .db 20
    .db 1E
    .db 1E
    .db 1E
    .db 20
    .db 20
    .db 38
    .db 20
    .db 20
    .db 38
    .db 20
    .db 20
    .db 20
    .db 20
    .db 20
    .db 20
    .db 20
    .db 20
    .db 20
    .db 20
    .db 20
    .db 00
    .db 2A
    .db 2A
    .db 2A
    .db B0
    .db 2A
    .db 2A
    .db B1
    .db 2A
    .db 2A
    .db 2A
    .db 2A
    .db 2A
    .db 42
    .db B0
    .db 2A
    .db 2A
    .db B1
    .db 2A
    .db 2A
    .db 2A
    .db 2A
    .db B0
    .db 2A
    .db 2A
    .db C7
    .db B1
    .db 2E
    .db B0
    .db 2E
    .db 2E
    .db FF
    .db B1
    .db 2E
    .db 32
    .db 9F
    .db A0
    .db 00
    .db B4
    .db 34
    .db 1C
    .db 38
    .db 20
    .db 9F
    .db A0
    .db 00
    .db B2
    .db 36
    .db B3
    .db 32
    .db B2
    .db 02
    .db 32
    .db B3
    .db 2E
    .db B2
    .db 02
    .db B5
    .db 2E
    .db B3
    .db 2A
    .db B1
    .db 02
    .db B5
    .db 28
    .db B3
    .db 26
    .db B1
    .db 02
    .db B4
    .db 24
    .db 24
    .db C4
    .db B4
    .db 24
    .db 3C
    .db FF
    .db 24
    .db 02
    .db 02
    .db 00
    .db B2
    .db 44
    .db 04
    .db C5
    .db 01
    .db 04
    .db FF
    .db B1
    .db 81
    .db 41
    .db 81
    .db 81
    .db 41
    .db 81
    .db 81
    .db 41
    .db 41
    .db 01
    .db 04
    .db 01
    .db C5
    .db B2
    .db 01
    .db 04
    .db FF
    .db BA
    .db 81
    .db 81
    .db C7
    .db B0
    .db 81
    .db FF
    .db B1
    .db 81
    .db 41
    .db 81
    .db 81
    .db 00
    .db 44
    .db 44
    .db 84
    .db 44
    .db 44
    .db 04
    .db 84
    .db 44
    .db 44
    .db 04
    .db 84
    .db 04
    .db 84
    .db 44
    .db 81
    .db 81
    .db 04
    .db 44
    .db 84
    .db 44
    .db 44
    .db 04
    .db 84
    .db 44
    .db 84
    .db 44
    .db 84
    .db 44
    .db BA
    .db 81
    .db 81
    .db B0
    .db 81
    .db 81
    .db 81
    .db B1
    .db 44
    .db B0
    .db 81
    .db 28
    .db B1
    .db 44
    .db 04
    .db 84
    .db 44
    .db 44
    .db 04
    .db 84
    .db 44
    .db 04
    .db 44
    .db 84
    .db 44
    .db 04
    .db 44
    .db 84
    .db 04
    .db 44
    .db 04
    .db 84
    .db 04
    .db 44
    .db 44
    .db 84
    .db 04
    .db B0
    .db 04
    .db 01
    .db 44
    .db 41
    .db 84
    .db 01
    .db 44
    .db 2E
    .db 04
    .db 44
    .db 04
    .db 41
    .db 44
    .db 41
    .db 44
    .db 41
    .db B0
    .db 44
    .db 2B
    .db 28
    .db 2E
    .db 04
    .db 2B
    .db 28
    .db 2E
    .db 01
    .db 2B
    .db 28
    .db 2E
    .db 04
    .db 2B
    .db 28
    .db 2E
    .db 44
    .db 2B
    .db 28
    .db 2E
    .db 04
    .db 2B
    .db 28
    .db 2E
    .db 01
    .db 2B
    .db 84
    .db 2E
    .db 84
    .db 2B
    .db 44
    .db 2E
    .db 44
    .db 2B
    .db 28
    .db 2E
    .db 04
    .db 2B
    .db 28
    .db 2E
    .db 01
    .db 2B
    .db 28
    .db 2E
    .db 04
    .db 2B
    .db 28
    .db 2E
    .db 44
    .db 2B
    .db 28
    .db 2E
    .db 04
    .db 2B
    .db 28
    .db 2E
    .db 81
    .db 41
    .db 25
    .db 81
    .db 41
    .db 44
    .db 84
    .db 2E
    .db 00
    .db 44
    .db 2B
    .db 2E
    .db 2B
    .db 44
    .db 2B
    .db 2E
    .db 2B
    .db 2E
    .db 2B
    .db 2E
    .db 2B
    .db 04
    .db 2B
    .db 2E
    .db 28
    .db 44
    .db 2B
    .db 2E
    .db 2B
    .db 44
    .db 2B
    .db 2E
    .db 2B
    .db 28
    .db 2B
    .db 2E
    .db 2B
    .db 28
    .db 81
    .db 84
    .db 81
    .db B1
    .db 44
    .db 04
    .db 81
    .db 44
    .db 01
    .db 41
    .db 81
    .db 01
    .db 44
    .db 04
    .db 81
    .db 44
    .db 01
    .db B0
    .db 41
    .db 41
    .db B2
    .db 81
    .db B0
    .db 44
    .db 25
    .db 25
    .db 28
    .db 28
    .db 28
    .db 28
    .db 2B
    .db 2B
    .db 2B
    .db 2B
    .db 2B
    .db 2E
    .db 2E
    .db 2E
    .db 2E
    .db 2E
    .db 2E
    .db 2E
    .db 2E
    .db 2E
    .db 2E
    .db 00
    .db 9F
    .db 0D
    .db F1
    .db C4
    .db B0
    .db 54
    .db 3C
    .db 54
    .db 54
    .db 3C
    .db 54
    .db 3C
    .db 3C
    .db FF
    .db 9F
    .db 04
    .db 15
    .db B5
    .db 16
    .db B3
    .db 12
    .db B1
    .db 02
    .db B5
    .db 10
    .db B3
    .db 0E
    .db B1
    .db 02
    .db 9F
    .db 1D
    .db 12
    .db B4
    .db 0C
    .db 9F
    .db A9
    .db B1
    .db B4
    .db 24
    .db 9E
    .db 35
    .db 9F
    .db BC
    .db B1
    .db B4
    .db 4A
    .db 54
    .db 4A
    .db 54
    .db B4
    .db 4A
    .db 54
    .db 4A
    .db 54
    .db 24
    .db 24
    .db 02
    .db 00
    .db 9F
    .db 0F
    .db F1
    .db B2
    .db 50
    .db 58
    .db 5E
    .db 68
    .db 42
    .db 50
    .db 5A
    .db 62
    .db 4A
    .db 50
    .db 58
    .db 62
    .db 40
    .db 4E
    .db 58
    .db 5E
    .db 42
    .db 50
    .db 5A
    .db 58
    .db 02
    .db 58
    .db 5E
    .db 68
    .db 42
    .db 50
    .db 5A
    .db 4E
    .db 02
    .db 54
    .db 5E
    .db 66
    .db 9F
    .db 0E
    .db F1
    .db 42
    .db 5A
    .db 46
    .db 5E
    .db 4A
    .db 62
    .db 4E
    .db 66
    .db 50
    .db 58
    .db 5E
    .db 58
    .db 46
    .db 4E
    .db 54
    .db 5E
    .db 9F
    .db 0D
    .db F1
    .db 42
    .db 50
    .db 5A
    .db 50
    .db 46
    .db 54
    .db 5E
    .db 66
    .db 50
    .db 5E
    .db 02
    .db 02
    .db 70
    .db 68
    .db 5E
    .db 58
    .db 00
    .db B2
    .db 50
    .db 58
    .db 5E
    .db 68
    .db 42
    .db 50
    .db 5A
    .db 62
    .db 4A
    .db 50
    .db 58
    .db 62
    .db 40
    .db 4E
    .db 58
    .db 5E
    .db 42
    .db 50
    .db 5A
    .db 58
    .db 02
    .db 58
    .db 5E
    .db 68
    .db 42
    .db 50
    .db 5A
    .db 4E
    .db 02
    .db 54
    .db 5E
    .db 66
    .db 42
    .db 5A
    .db 46
    .db 5E
    .db 4A
    .db 62
    .db 4E
    .db 66
    .db 50
    .db 58
    .db 5E
    .db 58
    .db 46
    .db 4E
    .db 54
    .db 5E
    .db 42
    .db 50
    .db 5A
    .db 50
    .db 46
    .db 54
    .db 5E
    .db 66
    .db 50
    .db 5E
    .db 02
    .db 02
    .db 70
    .db 68
    .db 5E
    .db 58
    .db 00
    .db 9F
    .db BF
    .db B0
    .db B2
    .db 50
    .db 54
    .db 58
    .db 5E
    .db B6
    .db 54
    .db B2
    .db 02
    .db B2
    .db 68
    .db 66
    .db 62
    .db 58
    .db B3
    .db 5E
    .db 02
    .db B2
    .db 62
    .db 66
    .db 68
    .db B3
    .db 5E
    .db B6
    .db 50
    .db B2
    .db 5A
    .db 58
    .db 50
    .db B4
    .db 46
    .db B2
    .db 02
    .db B3
    .db 4A
    .db 4E
    .db 50
    .db 5A
    .db B2
    .db 58
    .db 5A
    .db 5E
    .db 58
    .db 54
    .db 58
    .db 5A
    .db 54
    .db B2
    .db 4A
    .db 5A
    .db 58
    .db 46
    .db B3
    .db 54
    .db 4E
    .db B3
    .db 50
    .db B2
    .db 46
    .db 54
    .db B3
    .db 50
    .db 02
    .db 00
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
    .db FF
