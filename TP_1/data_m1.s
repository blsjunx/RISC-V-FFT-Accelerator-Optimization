.global _main_init
.text

/*
        Module              From          To         
      - SRAM I/O            0x0000_0000   0x0000_FFFF
      - SRAM 0              0x0100_0000   0x0100_FFFF
      - SRAM 1              0x0200_0000   0x0200_FFFF
      - SRAM W              0x0300_0000   0x0300_FFFF
      - SRAM 2              0x0400_0000   0x0400_FFFF
      - Dpath reg (port 0)  0x0500_0000   0x0500_0007
      - Dpath reg (port 1)  0x0600_0000   0x0600_0007
      - Dpath reg (port 2)  0x0700_0000   0x0700_0003
*/

_main_init:
    lui     s0,     0x00000
    lui     s1,     0x00000 
    addi    s1,     s1,     0x400
    lui     s2,     0x01000
    lui     s3,     0x03000
    lui     s4,     0x05000
    lui     s5,     0x06000
    lui     s6,     0x07000
    li      s7,     64
    li      s8,     6

start_fft:


/* Edit Code Below */
#------------------------------------------------
# Stage_0: SRAM_I/O --> FFT_engine (Dpath_reg) with Bit-Reversed Order
#------------------------------------------------
    # Load twiddle factor for stage_0 (W[0] = 0x3FFF0000)
    lw      t4,     0(s3)           # t4 = SRAM_W[0]

    # Butterfly 0: SRAM_IO[0] and SRAM_IO[32] --> SRAM_0[0], SRAM_0[1]
    lw      t2,     0(s0)           # t2 = SRAM_IO[0]
    lw      t3,     128(s0)         # t3 = SRAM_IO[32]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_IO[0]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_IO[32]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X = A + WB)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y = A - WB)
    sw      t2,     0(s2)           # SRAM_0[0] = X
    sw      t3,     4(s2)           # SRAM_0[1] = Y

    # Butterfly 1: SRAM_IO[16] and SRAM_IO[48] --> SRAM_0[2], SRAM_0[3]
    lw      t2,     64(s0)          # t2 = SRAM_IO[16]
    lw      t3,     192(s0)         # t3 = SRAM_IO[48]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_IO[16]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_IO[48]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X = A + WB)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y = A - WB)
    sw      t2,     8(s2)           # SRAM_0[2] = X
    sw      t3,     12(s2)          # SRAM_0[3] = Y

    # Butterfly 2: SRAM_IO[8] and SRAM_IO[40] --> SRAM_0[4], SRAM_0[5]
    lw      t2,     32(s0)          # t2 = SRAM_IO[8]
    lw      t3,     160(s0)         # t3 = SRAM_IO[40]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_IO[8]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_IO[40]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X = A + WB)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y = A - WB)
    sw      t2,     16(s2)          # SRAM_0[4] = X
    sw      t3,     20(s2)          # SRAM_0[5] = Y

    # Butterfly 3: SRAM_IO[24] and SRAM_IO[56] --> SRAM_0[6], SRAM_0[7]
    lw      t2,     96(s0)          # t2 = SRAM_IO[24]
    lw      t3,     224(s0)         # t3 = SRAM_IO[56]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_IO[24]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_IO[56]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X = A + WB)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y = A - WB)
    sw      t2,     24(s2)          # SRAM_0[6] = X
    sw      t3,     28(s2)          # SRAM_0[7] = Y

    # Butterfly 4: SRAM_IO[4] and SRAM_IO[36] --> SRAM_0[8], SRAM_0[9]
    lw      t2,     16(s0)          # t2 = SRAM_IO[4]
    lw      t3,     144(s0)         # t3 = SRAM_IO[36]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_IO[4]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_IO[36]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X = A + WB)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y = A - WB)
    sw      t2,     32(s2)          # SRAM_0[8] = X
    sw      t3,     36(s2)          # SRAM_0[9] = Y

    # Butterfly 5: SRAM_IO[20] and SRAM_IO[52] --> SRAM_0[10], SRAM_0[11]
    lw      t2,     80(s0)          # t2 = SRAM_IO[20]
    lw      t3,     208(s0)         # t3 = SRAM_IO[52]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_IO[20]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_IO[52]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X = A + WB)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y = A - WB)
    sw      t2,     40(s2)          # SRAM_0[10] = X
    sw      t3,     44(s2)          # SRAM_0[11] = Y

    # Butterfly 6: SRAM_IO[12] and SRAM_IO[44] --> SRAM_0[12], SRAM_0[13]
    lw      t2,     48(s0)          # t2 = SRAM_IO[12]
    lw      t3,     176(s0)         # t3 = SRAM_IO[44]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_IO[12]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_IO[44]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X = A + WB)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y = A - WB)
    sw      t2,     48(s2)          # SRAM_0[12] = X
    sw      t3,     52(s2)          # SRAM_0[13] = Y

    # Butterfly 7: SRAM_IO[28] and SRAM_IO[60] --> SRAM_0[14], SRAM_0[15]
    lw      t2,     112(s0)         # t2 = SRAM_IO[28]
    lw      t3,     240(s0)         # t3 = SRAM_IO[60]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_IO[28]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_IO[60]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X = A + WB)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y = A - WB)
    sw      t2,     56(s2)          # SRAM_0[14] = X
    sw      t3,     60(s2)          # SRAM_0[15] = Y

    # Butterfly 8: SRAM_IO[2] and SRAM_IO[34] --> SRAM_0[16], SRAM_0[17]
    lw      t2,     8(s0)           # t2 = SRAM_IO[2]
    lw      t3,     136(s0)         # t3 = SRAM_IO[34]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_IO[2]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_IO[34]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X = A + WB)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y = A - WB)
    sw      t2,     64(s2)          # SRAM_0[16] = X
    sw      t3,     68(s2)          # SRAM_0[17] = Y

    # Butterfly 9: SRAM_IO[18] and SRAM_IO[50] --> SRAM_0[18], SRAM_0[19]
    lw      t2,     72(s0)          # t2 = SRAM_IO[18]
    lw      t3,     200(s0)         # t3 = SRAM_IO[50]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_IO[18]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_IO[50]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X = A + WB)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y = A - WB)
    sw      t2,     72(s2)          # SRAM_0[18] = X
    sw      t3,     76(s2)          # SRAM_0[19] = Y

    # Butterfly 10: SRAM_IO[10] and SRAM_IO[42] --> SRAM_0[20], SRAM_0[21]
    lw      t2,     40(s0)          # t2 = SRAM_IO[10]
    lw      t3,     168(s0)         # t3 = SRAM_IO[42]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_IO[10]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_IO[42]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X = A + WB)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y = A - WB)
    sw      t2,     80(s2)          # SRAM_0[20] = X
    sw      t3,     84(s2)          # SRAM_0[21] = Y

    # Butterfly 11: SRAM_IO[26] and SRAM_IO[58] --> SRAM_0[22], SRAM_0[23]
    lw      t2,     104(s0)         # t2 = SRAM_IO[26]
    lw      t3,     232(s0)         # t3 = SRAM_IO[58]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_IO[26]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_IO[58]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X = A + WB)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y = A - WB)
    sw      t2,     88(s2)          # SRAM_0[22] = X
    sw      t3,     92(s2)          # SRAM_0[23] = Y

    # Butterfly 12: SRAM_IO[6] and SRAM_IO[38] --> SRAM_0[24], SRAM_0[25]
    lw      t2,     24(s0)          # t2 = SRAM_IO[6]
    lw      t3,     152(s0)         # t3 = SRAM_IO[38]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_IO[6]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_IO[38]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X = A + WB)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y = A - WB)
    sw      t2,     96(s2)          # SRAM_0[24] = X
    sw      t3,     100(s2)         # SRAM_0[25] = Y

    # Butterfly 13: SRAM_IO[22] and SRAM_IO[54] --> SRAM_0[26], SRAM_0[27]
    lw      t2,     88(s0)          # t2 = SRAM_IO[22]
    lw      t3,     216(s0)         # t3 = SRAM_IO[54]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_IO[22]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_IO[54]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X = A + WB)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y = A - WB)
    sw      t2,     104(s2)         # SRAM_0[26] = X
    sw      t3,     108(s2)         # SRAM_0[27] = Y

    # Butterfly 14: SRAM_IO[14] and SRAM_IO[46] --> SRAM_0[28], SRAM_0[29]
    lw      t2,     56(s0)          # t2 = SRAM_IO[14]
    lw      t3,     184(s0)         # t3 = SRAM_IO[46]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_IO[14]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_IO[46]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X = A + WB)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y = A - WB)
    sw      t2,     112(s2)         # SRAM_0[28] = X
    sw      t3,     116(s2)         # SRAM_0[29] = Y

    # Butterfly 15: SRAM_IO[30] and SRAM_IO[62] --> SRAM_0[30], SRAM_0[31]
    lw      t2,     120(s0)         # t2 = SRAM_IO[30]
    lw      t3,     248(s0)         # t3 = SRAM_IO[62]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_IO[30]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_IO[62]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X = A + WB)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y = A - WB)
    sw      t2,     120(s2)         # SRAM_0[30] = X
    sw      t3,     124(s2)         # SRAM_0[31] = Y

    # Butterfly 16: SRAM_IO[1] and SRAM_IO[33] --> SRAM_0[32], SRAM_0[33]
    lw      t2,     4(s0)           # t2 = SRAM_IO[1]
    lw      t3,     132(s0)         # t3 = SRAM_IO[33]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_IO[1]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_IO[33]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X = A + WB)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y = A - WB)
    sw      t2,     128(s2)         # SRAM_0[32] = X
    sw      t3,     132(s2)         # SRAM_0[33] = Y

    # Butterfly 17: SRAM_IO[17] and SRAM_IO[49] --> SRAM_0[34], SRAM_0[35]
    lw      t2,     68(s0)          # t2 = SRAM_IO[17]
    lw      t3,     196(s0)         # t3 = SRAM_IO[49]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_IO[17]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_IO[49]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X = A + WB)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y = A - WB)
    sw      t2,     136(s2)         # SRAM_0[34] = X
    sw      t3,     140(s2)         # SRAM_0[35] = Y

    # Butterfly 18: SRAM_IO[9] and SRAM_IO[41] --> SRAM_0[36], SRAM_0[37]
    lw      t2,     36(s0)          # t2 = SRAM_IO[9]
    lw      t3,     164(s0)         # t3 = SRAM_IO[41]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_IO[9]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_IO[41]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X = A + WB)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y = A - WB)
    sw      t2,     144(s2)         # SRAM_0[36] = X
    sw      t3,     148(s2)         # SRAM_0[37] = Y

    # Butterfly 19: SRAM_IO[25] and SRAM_IO[57] --> SRAM_0[38], SRAM_0[39]
    lw      t2,     100(s0)         # t2 = SRAM_IO[25]
    lw      t3,     228(s0)         # t3 = SRAM_IO[57]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_IO[25]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_IO[57]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X = A + WB)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y = A - WB)
    sw      t2,     152(s2)         # SRAM_0[38] = X
    sw      t3,     156(s2)         # SRAM_0[39] = Y

    # Butterfly 20: SRAM_IO[5] and SRAM_IO[37] --> SRAM_0[40], SRAM_0[41]
    lw      t2,     20(s0)          # t2 = SRAM_IO[5]
    lw      t3,     148(s0)         # t3 = SRAM_IO[37]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_IO[5]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_IO[37]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X = A + WB)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y = A - WB)
    sw      t2,     160(s2)         # SRAM_0[40] = X
    sw      t3,     164(s2)         # SRAM_0[41] = Y

    # Butterfly 21: SRAM_IO[21] and SRAM_IO[53] --> SRAM_0[42], SRAM_0[43]
    lw      t2,     84(s0)          # t2 = SRAM_IO[21]
    lw      t3,     212(s0)         # t3 = SRAM_IO[53]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_IO[21]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_IO[53]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X = A + WB)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y = A - WB)
    sw      t2,     168(s2)         # SRAM_0[42] = X
    sw      t3,     172(s2)         # SRAM_0[43] = Y

    # Butterfly 22: SRAM_IO[13] and SRAM_IO[45] --> SRAM_0[44], SRAM_0[45]
    lw      t2,     52(s0)          # t2 = SRAM_IO[13]
    lw      t3,     180(s0)         # t3 = SRAM_IO[45]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_IO[13]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_IO[45]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X = A + WB)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y = A - WB)
    sw      t2,     176(s2)         # SRAM_0[44] = X
    sw      t3,     180(s2)         # SRAM_0[45] = Y

    # Butterfly 23: SRAM_IO[29] and SRAM_IO[61] --> SRAM_0[46], SRAM_0[47]
    lw      t2,     116(s0)         # t2 = SRAM_IO[29]
    lw      t3,     244(s0)         # t3 = SRAM_IO[61]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_IO[29]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_IO[61]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X = A + WB)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y = A - WB)
    sw      t2,     184(s2)         # SRAM_0[46] = X
    sw      t3,     188(s2)         # SRAM_0[47] = Y

    # Butterfly 24: SRAM_IO[3] and SRAM_IO[35] --> SRAM_0[48], SRAM_0[49]
    lw      t2,     12(s0)          # t2 = SRAM_IO[3]
    lw      t3,     140(s0)         # t3 = SRAM_IO[35]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_IO[3]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_IO[35]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X = A + WB)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y = A - WB)
    sw      t2,     192(s2)         # SRAM_0[48] = X
    sw      t3,     196(s2)         # SRAM_0[49] = Y

    # Butterfly 25: SRAM_IO[19] and SRAM_IO[51] --> SRAM_0[50], SRAM_0[51]
    lw      t2,     76(s0)          # t2 = SRAM_IO[19]
    lw      t3,     204(s0)         # t3 = SRAM_IO[51]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_IO[19]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_IO[51]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X = A + WB)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y = A - WB)
    sw      t2,     200(s2)         # SRAM_0[50] = X
    sw      t3,     204(s2)         # SRAM_0[51] = Y

    # Butterfly 26: SRAM_IO[11] and SRAM_IO[43] --> SRAM_0[52], SRAM_0[53]
    lw      t2,     44(s0)          # t2 = SRAM_IO[11]
    lw      t3,     172(s0)         # t3 = SRAM_IO[43]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_IO[11]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_IO[43]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X = A + WB)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y = A - WB)
    sw      t2,     208(s2)         # SRAM_0[52] = X
    sw      t3,     212(s2)         # SRAM_0[53] = Y

    # Butterfly 27: SRAM_IO[27] and SRAM_IO[59] --> SRAM_0[54], SRAM_0[55]
    lw      t2,     108(s0)         # t2 = SRAM_IO[27]
    lw      t3,     236(s0)         # t3 = SRAM_IO[59]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_IO[27]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_IO[59]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X = A + WB)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y = A - WB)
    sw      t2,     216(s2)         # SRAM_0[54] = X
    sw      t3,     220(s2)         # SRAM_0[55] = Y

    # Butterfly 28: SRAM_IO[7] and SRAM_IO[39] --> SRAM_0[56], SRAM_0[57]
    lw      t2,     28(s0)          # t2 = SRAM_IO[7]
    lw      t3,     156(s0)         # t3 = SRAM_IO[39]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_IO[7]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_IO[39]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X = A + WB)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y = A - WB)
    sw      t2,     224(s2)         # SRAM_0[56] = X
    sw      t3,     228(s2)         # SRAM_0[57] = Y

    # Butterfly 29: SRAM_IO[23] and SRAM_IO[55] --> SRAM_0[58], SRAM_0[59]
    lw      t2,     92(s0)          # t2 = SRAM_IO[23]
    lw      t3,     220(s0)         # t3 = SRAM_IO[55]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_IO[23]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_IO[55]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X = A + WB)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y = A - WB)
    sw      t2,     232(s2)         # SRAM_0[58] = X
    sw      t3,     236(s2)         # SRAM_0[59] = Y

    # Butterfly 30: SRAM_IO[15] and SRAM_IO[47] --> SRAM_0[60], SRAM_0[61]
    lw      t2,     60(s0)          # t2 = SRAM_IO[15]
    lw      t3,     188(s0)         # t3 = SRAM_IO[47]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_IO[15]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_IO[47]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X = A + WB)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y = A - WB)
    sw      t2,     240(s2)         # SRAM_0[60] = X
    sw      t3,     244(s2)         # SRAM_0[61] = Y

    # Butterfly 31: SRAM_IO[31] and SRAM_IO[63] --> SRAM_0[62], SRAM_0[63]
    lw      t2,     124(s0)         # t2 = SRAM_IO[31]
    lw      t3,     252(s0)         # t3 = SRAM_IO[63]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_IO[31]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_IO[63]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X = A + WB)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y = A - WB)
    sw      t2,     248(s2)         # SRAM_0[62] = X
    sw      t3,     252(s2)         # SRAM_0[63] = Y

#------------------------------------------------
# Stage_1: SRAM_0 <--> FFT_engine (l=2, m=0~1)
#------------------------------------------------
    # m=0, i=0, 2, ..., 62 (32 butterflies)
    lw      t4,     0(s3)           # t4 = SRAM_W[0]
    lw      t2,     0(s2)           # t2 = SRAM_0[0]
    lw      t3,     8(s2)           # t3 = SRAM_0[2]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[0]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[2]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     0(s2)           # SRAM_0[0] = X
    sw      t3,     8(s2)           # SRAM_0[2] = Y

    lw      t2,     16(s2)          # t2 = SRAM_0[4]
    lw      t3,     24(s2)          # t3 = SRAM_0[6]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[4]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[6]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     16(s2)          # SRAM_0[4] = X
    sw      t3,     24(s2)          # SRAM_0[6] = Y

    lw      t2,     32(s2)          # t2 = SRAM_0[8]
    lw      t3,     40(s2)          # t3 = SRAM_0[10]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[8]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[10]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     32(s2)          # SRAM_0[8] = X
    sw      t3,     40(s2)          # SRAM_0[10] = Y

    lw      t2,     48(s2)          # t2 = SRAM_0[12]
    lw      t3,     56(s2)          # t3 = SRAM_0[14]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[12]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[14]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     48(s2)          # SRAM_0[12] = X
    sw      t3,     56(s2)          # SRAM_0[14] = Y

    lw      t2,     64(s2)          # t2 = SRAM_0[16]
    lw      t3,     72(s2)          # t3 = SRAM_0[18]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[16]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[18]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     64(s2)          # SRAM_0[16] = X
    sw      t3,     72(s2)          # SRAM_0[18] = Y

    lw      t2,     80(s2)          # t2 = SRAM_0[20]
    lw      t3,     88(s2)          # t3 = SRAM_0[22]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[20]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[22]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     80(s2)          # SRAM_0[20] = X
    sw      t3,     88(s2)          # SRAM_0[22] = Y

    lw      t2,     96(s2)          # t2 = SRAM_0[24]
    lw      t3,     104(s2)         # t3 = SRAM_0[26]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[24]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[26]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     96(s2)          # SRAM_0[24] = X
    sw      t3,     104(s2)         # SRAM_0[26] = Y

    lw      t2,     112(s2)         # t2 = SRAM_0[28]
    lw      t3,     120(s2)         # t3 = SRAM_0[30]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[28]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[30]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     112(s2)         # SRAM_0[28] = X
    sw      t3,     120(s2)         # SRAM_0[30] = Y

    lw      t2,     128(s2)         # t2 = SRAM_0[32]
    lw      t3,     136(s2)         # t3 = SRAM_0[34]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[32]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[34]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     128(s2)         # SRAM_0[32] = X
    sw      t3,     136(s2)         # SRAM_0[34] = Y

    lw      t2,     144(s2)         # t2 = SRAM_0[36]
    lw      t3,     152(s2)         # t3 = SRAM_0[38]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[36]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[38]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     144(s2)         # SRAM_0[36] = X
    sw      t3,     152(s2)         # SRAM_0[38] = Y

    lw      t2,     160(s2)         # t2 = SRAM_0[40]
    lw      t3,     168(s2)         # t3 = SRAM_0[42]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[40]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[42]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     160(s2)         # SRAM_0[40] = X
    sw      t3,     168(s2)         # SRAM_0[42] = Y

    lw      t2,     176(s2)         # t2 = SRAM_0[44]
    lw      t3,     184(s2)         # t3 = SRAM_0[46]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[44]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[46]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     176(s2)         # SRAM_0[44] = X
    sw      t3,     184(s2)         # SRAM_0[46] = Y

    lw      t2,     192(s2)         # t2 = SRAM_0[48]
    lw      t3,     200(s2)         # t3 = SRAM_0[50]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[48]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[50]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     192(s2)         # SRAM_0[48] = X
    sw      t3,     200(s2)         # SRAM_0[50] = Y

    lw      t2,     208(s2)         # t2 = SRAM_0[52]
    lw      t3,     216(s2)         # t3 = SRAM_0[54]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[52]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[54]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     208(s2)         # SRAM_0[52] = X
    sw      t3,     216(s2)         # SRAM_0[54] = Y

    lw      t2,     224(s2)         # t2 = SRAM_0[56]
    lw      t3,     232(s2)         # t3 = SRAM_0[58]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[56]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[58]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     224(s2)         # SRAM_0[56] = X
    sw      t3,     232(s2)         # SRAM_0[58] = Y

    lw      t2,     240(s2)         # t2 = SRAM_0[60]
    lw      t3,     248(s2)         # t3 = SRAM_0[62]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[60]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[62]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     240(s2)         # SRAM_0[60] = X
    sw      t3,     248(s2)         # SRAM_0[62] = Y

    # m=1, i=1, 3, ..., 63 (32 butterflies)
    lw      t4,     64(s3)          # t4 = SRAM_W[16]
    lw      t2,     4(s2)           # t2 = SRAM_0[1]
    lw      t3,     12(s2)          # t3 = SRAM_0[3]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[1]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[3]
    sw      t4,     0(s6)           # dpath_reg_2 = W[16]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     4(s2)           # SRAM_0[1] = X
    sw      t3,     12(s2)          # SRAM_0[3] = Y

    lw      t2,     20(s2)          # t2 = SRAM_0[5]
    lw      t3,     28(s2)          # t3 = SRAM_0[7]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[5]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[7]
    sw      t4,     0(s6)           # dpath_reg_2 = W[16]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     20(s2)          # SRAM_0[5] = X
    sw      t3,     28(s2)          # SRAM_0[7] = Y

    lw      t2,     36(s2)          # t2 = SRAM_0[9]
    lw      t3,     44(s2)          # t3 = SRAM_0[11]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[9]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[11]
    sw      t4,     0(s6)           # dpath_reg_2 = W[16]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     36(s2)          # SRAM_0[9] = X
    sw      t3,     44(s2)          # SRAM_0[11] = Y

    lw      t2,     52(s2)          # t2 = SRAM_0[13]
    lw      t3,     60(s2)          # t3 = SRAM_0[15]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[13]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[15]
    sw      t4,     0(s6)           # dpath_reg_2 = W[16]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     52(s2)          # SRAM_0[13] = X
    sw      t3,     60(s2)          # SRAM_0[15] = Y

    lw      t2,     68(s2)          # t2 = SRAM_0[17]
    lw      t3,     76(s2)          # t3 = SRAM_0[19]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[17]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[19]
    sw      t4,     0(s6)           # dpath_reg_2 = W[16]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     68(s2)          # SRAM_0[17] = X
    sw      t3,     76(s2)          # SRAM_0[19] = Y

    lw      t2,     84(s2)          # t2 = SRAM_0[21]
    lw      t3,     92(s2)          # t3 = SRAM_0[23]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[21]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[23]
    sw      t4,     0(s6)           # dpath_reg_2 = W[16]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     84(s2)          # SRAM_0[21] = X
    sw      t3,     92(s2)          # SRAM_0[23] = Y

    lw      t2,     100(s2)         # t2 = SRAM_0[25]
    lw      t3,     108(s2)         # t3 = SRAM_0[27]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[25]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[27]
    sw      t4,     0(s6)           # dpath_reg_2 = W[16]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     100(s2)         # SRAM_0[25] = X
    sw      t3,     108(s2)         # SRAM_0[27] = Y

    lw      t2,     116(s2)         # t2 = SRAM_0[29]
    lw      t3,     124(s2)         # t3 = SRAM_0[31]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[29]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[31]
    sw      t4,     0(s6)           # dpath_reg_2 = W[16]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     116(s2)         # SRAM_0[29] = X
    sw      t3,     124(s2)         # SRAM_0[31] = Y

    lw      t2,     132(s2)         # t2 = SRAM_0[33]
    lw      t3,     140(s2)         # t3 = SRAM_0[35]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[33]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[35]
    sw      t4,     0(s6)           # dpath_reg_2 = W[16]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     132(s2)         # SRAM_0[33] = X
    sw      t3,     140(s2)         # SRAM_0[35] = Y

    lw      t2,     148(s2)         # t2 = SRAM_0[37]
    lw      t3,     156(s2)         # t3 = SRAM_0[39]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[37]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[39]
    sw      t4,     0(s6)           # dpath_reg_2 = W[16]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     148(s2)         # SRAM_0[37] = X
    sw      t3,     156(s2)         # SRAM_0[39] = Y

    lw      t2,     164(s2)         # t2 = SRAM_0[41]
    lw      t3,     172(s2)         # t3 = SRAM_0[43]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[41]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[43]
    sw      t4,     0(s6)           # dpath_reg_2 = W[16]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     164(s2)         # SRAM_0[41] = X
    sw      t3,     172(s2)         # SRAM_0[43] = Y

    lw      t2,     180(s2)         # t2 = SRAM_0[45]
    lw      t3,     188(s2)         # t3 = SRAM_0[47]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[45]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[47]
    sw      t4,     0(s6)           # dpath_reg_2 = W[16]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     180(s2)         # SRAM_0[45] = X
    sw      t3,     188(s2)         # SRAM_0[47] = Y

    lw      t2,     196(s2)         # t2 = SRAM_0[49]
    lw      t3,     204(s2)         # t3 = SRAM_0[51]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[49]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[51]
    sw      t4,     0(s6)           # dpath_reg_2 = W[16]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     196(s2)         # SRAM_0[49] = X
    sw      t3,     204(s2)         # SRAM_0[51] = Y

    lw      t2,     212(s2)         # t2 = SRAM_0[53]
    lw      t3,     220(s2)         # t3 = SRAM_0[55]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[53]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[55]
    sw      t4,     0(s6)           # dpath_reg_2 = W[16]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     212(s2)         # SRAM_0[53] = X
    sw      t3,     220(s2)         # SRAM_0[55] = Y

    lw      t2,     228(s2)         # t2 = SRAM_0[57]
    lw      t3,     236(s2)         # t3 = SRAM_0[59]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[57]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[59]
    sw      t4,     0(s6)           # dpath_reg_2 = W[16]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     228(s2)         # SRAM_0[57] = X
    sw      t3,     236(s2)         # SRAM_0[59] = Y

    lw      t2,     244(s2)         # t2 = SRAM_0[61]
    lw      t3,     252(s2)         # t3 = SRAM_0[63]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[61]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[63]
    sw      t4,     0(s6)           # dpath_reg_2 = W[16]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     244(s2)         # SRAM_0[61] = X
    sw      t3,     252(s2)         # SRAM_0[63] = Y

#------------------------------------------------
# Stage_2: SRAM_0 <--> FFT_engine (l=4, m=0~3)
#------------------------------------------------
    # m=0, i=0, 4, ..., 60 (16 butterflies)
    lw      t4,     0(s3)           # t4 = SRAM_W[0]
    lw      t2,     0(s2)           # t2 = SRAM_0[0]
    lw      t3,     16(s2)          # t3 = SRAM_0[4]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[0]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[4]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     0(s2)           # SRAM_0[0] = X
    sw      t3,     16(s2)          # SRAM_0[4] = Y

    lw      t2,     32(s2)          # t2 = SRAM_0[8]
    lw      t3,     48(s2)          # t3 = SRAM_0[12]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[8]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[12]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     32(s2)          # SRAM_0[8] = X
    sw      t3,     48(s2)          # SRAM_0[12] = Y

    lw      t2,     64(s2)          # t2 = SRAM_0[16]
    lw      t3,     80(s2)          # t3 = SRAM_0[20]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[16]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[20]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     64(s2)          # SRAM_0[16] = X
    sw      t3,     80(s2)          # SRAM_0[20] = Y

    lw      t2,     96(s2)          # t2 = SRAM_0[24]
    lw      t3,     112(s2)         # t3 = SRAM_0[28]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[24]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[28]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     96(s2)          # SRAM_0[24] = X
    sw      t3,     112(s2)         # SRAM_0[28] = Y

    lw      t2,     128(s2)         # t2 = SRAM_0[32]
    lw      t3,     144(s2)         # t3 = SRAM_0[36]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[32]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[36]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     128(s2)         # SRAM_0[32] = X
    sw      t3,     144(s2)         # SRAM_0[36] = Y

    lw      t2,     160(s2)         # t2 = SRAM_0[40]
    lw      t3,     176(s2)         # t3 = SRAM_0[44]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[40]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[44]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     160(s2)         # SRAM_0[40] = X
    sw      t3,     176(s2)         # SRAM_0[44] = Y

    lw      t2,     192(s2)         # t2 = SRAM_0[48]
    lw      t3,     208(s2)         # t3 = SRAM_0[52]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[48]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[52]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     192(s2)         # SRAM_0[48] = X
    sw      t3,     208(s2)         # SRAM_0[52] = Y

    lw      t2,     224(s2)         # t2 = SRAM_0[56]
    lw      t3,     240(s2)         # t3 = SRAM_0[60]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[56]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[60]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     224(s2)         # SRAM_0[56] = X
    sw      t3,     240(s2)         # SRAM_0[60] = Y

    # m=1, i=1, 5, ..., 61 (16 butterflies)
    lw      t4,     32(s3)          # t4 = SRAM_W[8]
    lw      t2,     4(s2)           # t2 = SRAM_0[1]
    lw      t3,     20(s2)          # t3 = SRAM_0[5]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[1]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[5]
    sw      t4,     0(s6)           # dpath_reg_2 = W[8]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     4(s2)           # SRAM_0[1] = X
    sw      t3,     20(s2)          # SRAM_0[5] = Y

    lw      t2,     36(s2)          # t2 = SRAM_0[9]
    lw      t3,     52(s2)          # t3 = SRAM_0[13]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[9]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[13]
    sw      t4,     0(s6)           # dpath_reg_2 = W[8]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     36(s2)          # SRAM_0[9] = X
    sw      t3,     52(s2)          # SRAM_0[13] = Y

    lw      t2,     68(s2)          # t2 = SRAM_0[17]
    lw      t3,     84(s2)          # t3 = SRAM_0[21]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[17]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[21]
    sw      t4,     0(s6)           # dpath_reg_2 = W[8]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     68(s2)          # SRAM_0[17] = X
    sw      t3,     84(s2)          # SRAM_0[21] = Y

    lw      t2,     100(s2)         # t2 = SRAM_0[25]
    lw      t3,     116(s2)         # t3 = SRAM_0[29]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[25]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[29]
    sw      t4,     0(s6)           # dpath_reg_2 = W[8]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     100(s2)         # SRAM_0[25] = X
    sw      t3,     116(s2)         # SRAM_0[29] = Y

    lw      t2,     132(s2)         # t2 = SRAM_0[33]
    lw      t3,     148(s2)         # t3 = SRAM_0[37]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[33]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[37]
    sw      t4,     0(s6)           # dpath_reg_2 = W[8]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     132(s2)         # SRAM_0[33] = X
    sw      t3,     148(s2)         # SRAM_0[37] = Y

    lw      t2,     164(s2)         # t2 = SRAM_0[41]
    lw      t3,     180(s2)         # t3 = SRAM_0[45]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[41]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[45]
    sw      t4,     0(s6)           # dpath_reg_2 = W[8]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     164(s2)         # SRAM_0[41] = X
    sw      t3,     180(s2)         # SRAM_0[45] = Y

    lw      t2,     196(s2)         # t2 = SRAM_0[49]
    lw      t3,     212(s2)         # t3 = SRAM_0[53]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[49]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[53]
    sw      t4,     0(s6)           # dpath_reg_2 = W[8]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     196(s2)         # SRAM_0[49] = X
    sw      t3,     212(s2)         # SRAM_0[53] = Y

    lw      t2,     228(s2)         # t2 = SRAM_0[57]
    lw      t3,     244(s2)         # t3 = SRAM_0[61]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[57]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[61]
    sw      t4,     0(s6)           # dpath_reg_2 = W[8]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     228(s2)         # SRAM_0[57] = X
    sw      t3,     244(s2)         # SRAM_0[61] = Y

    # m=2, i=2, 6, ..., 62 (16 butterflies)
    lw      t4,     64(s3)          # t4 = SRAM_W[16]
    lw      t2,     8(s2)           # t2 = SRAM_0[2]
    lw      t3,     24(s2)          # t3 = SRAM_0[6]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[2]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[6]
    sw      t4,     0(s6)           # dpath_reg_2 = W[16]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     8(s2)           # SRAM_0[2] = X
    sw      t3,     24(s2)          # SRAM_0[6] = Y

    lw      t2,     40(s2)          # t2 = SRAM_0[10]
    lw      t3,     56(s2)          # t3 = SRAM_0[14]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[10]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[14]
    sw      t4,     0(s6)           # dpath_reg_2 = W[16]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     40(s2)          # SRAM_0[10] = X
    sw      t3,     56(s2)          # SRAM_0[14] = Y

    lw      t2,     72(s2)          # t2 = SRAM_0[18]
    lw      t3,     88(s2)          # t3 = SRAM_0[22]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[18]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[22]
    sw      t4,     0(s6)           # dpath_reg_2 = W[16]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     72(s2)          # SRAM_0[18] = X
    sw      t3,     88(s2)          # SRAM_0[22] = Y

    lw      t2,     104(s2)         # t2 = SRAM_0[26]
    lw      t3,     120(s2)         # t3 = SRAM_0[30]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[26]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[30]
    sw      t4,     0(s6)           # dpath_reg_2 = W[16]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     104(s2)         # SRAM_0[26] = X
    sw      t3,     120(s2)         # SRAM_0[30] = Y

    lw      t2,     136(s2)         # t2 = SRAM_0[34]
    lw      t3,     152(s2)         # t3 = SRAM_0[38]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[34]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[38]
    sw      t4,     0(s6)           # dpath_reg_2 = W[16]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     136(s2)         # SRAM_0[34] = X
    sw      t3,     152(s2)         # SRAM_0[38] = Y

    lw      t2,     168(s2)         # t2 = SRAM_0[42]
    lw      t3,     184(s2)         # t3 = SRAM_0[46]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[42]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[46]
    sw      t4,     0(s6)           # dpath_reg_2 = W[16]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     168(s2)         # SRAM_0[42] = X
    sw      t3,     184(s2)         # SRAM_0[46] = Y

    lw      t2,     200(s2)         # t2 = SRAM_0[50]
    lw      t3,     216(s2)         # t3 = SRAM_0[54]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[50]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[54]
    sw      t4,     0(s6)           # dpath_reg_2 = W[16]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     200(s2)         # SRAM_0[50] = X
    sw      t3,     216(s2)         # SRAM_0[54] = Y

    lw      t2,     232(s2)         # t2 = SRAM_0[58]
    lw      t3,     248(s2)         # t3 = SRAM_0[62]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[58]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[62]
    sw      t4,     0(s6)           # dpath_reg_2 = W[16]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     232(s2)         # SRAM_0[58] = X
    sw      t3,     248(s2)         # SRAM_0[62] = Y

    # m=3, i=3, 7, ..., 63 (16 butterflies)
    lw      t4,     96(s3)          # t4 = SRAM_W[24]
    lw      t2,     12(s2)          # t2 = SRAM_0[3]
    lw      t3,     28(s2)          # t3 = SRAM_0[7]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[3]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[7]
    sw      t4,     0(s6)           # dpath_reg_2 = W[24]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     12(s2)          # SRAM_0[3] = X
    sw      t3,     28(s2)          # SRAM_0[7] = Y

    lw      t2,     44(s2)          # t2 = SRAM_0[11]
    lw      t3,     60(s2)          # t3 = SRAM_0[15]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[11]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[15]
    sw      t4,     0(s6)           # dpath_reg_2 = W[24]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     44(s2)          # SRAM_0[11] = X
    sw      t3,     60(s2)          # SRAM_0[15] = Y

    lw      t2,     76(s2)          # t2 = SRAM_0[19]
    lw      t3,     92(s2)          # t3 = SRAM_0[23]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[19]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[23]
    sw      t4,     0(s6)           # dpath_reg_2 = W[24]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     76(s2)          # SRAM_0[19] = X
    sw      t3,     92(s2)          # SRAM_0[23] = Y

    lw      t2,     108(s2)         # t2 = SRAM_0[27]
    lw      t3,     124(s2)         # t3 = SRAM_0[31]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[27]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[31]
    sw      t4,     0(s6)           # dpath_reg_2 = W[24]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     108(s2)         # SRAM_0[27] = X
    sw      t3,     124(s2)         # SRAM_0[31] = Y

    lw      t2,     140(s2)         # t2 = SRAM_0[35]
    lw      t3,     156(s2)         # t3 = SRAM_0[39]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[35]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[39]
    sw      t4,     0(s6)           # dpath_reg_2 = W[24]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     140(s2)         # SRAM_0[35] = X
    sw      t3,     156(s2)         # SRAM_0[39] = Y

    lw      t2,     172(s2)         # t2 = SRAM_0[43]
    lw      t3,     188(s2)         # t3 = SRAM_0[47]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[43]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[47]
    sw      t4,     0(s6)           # dpath_reg_2 = W[24]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     172(s2)         # SRAM_0[43] = X
    sw      t3,     188(s2)         # SRAM_0[47] = Y

    lw      t2,     204(s2)         # t2 = SRAM_0[51]
    lw      t3,     220(s2)         # t3 = SRAM_0[55]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[51]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[55]
    sw      t4,     0(s6)           # dpath_reg_2 = W[24]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     204(s2)         # SRAM_0[51] = X
    sw      t3,     220(s2)         # SRAM_0[55] = Y

    lw      t2,     236(s2)         # t2 = SRAM_0[59]
    lw      t3,     252(s2)         # t3 = SRAM_0[63]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[59]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[63]
    sw      t4,     0(s6)           # dpath_reg_2 = W[24]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     236(s2)         # SRAM_0[59] = X
    sw      t3,     252(s2)         # SRAM_0[63] = Y

#------------------------------------------------
# Stage_3: SRAM_0 <--> FFT_engine (l=8, m=0~7)
#------------------------------------------------
    # m=0, i=0, 8, ..., 56 (8 butterflies)
    lw      t4,     0(s3)           # t4 = SRAM_W[0]
    lw      t2,     0(s2)           # t2 = SRAM_0[0]
    lw      t3,     32(s2)          # t3 = SRAM_0[8]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[0]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[8]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     0(s2)           # SRAM_0[0] = X
    sw      t3,     32(s2)          # SRAM_0[8] = Y

    lw      t2,     64(s2)          # t2 = SRAM_0[16]
    lw      t3,     96(s2)          # t3 = SRAM_0[24]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[16]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[24]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     64(s2)          # SRAM_0[16] = X
    sw      t3,     96(s2)          # SRAM_0[24] = Y

    lw      t2,     128(s2)         # t2 = SRAM_0[32]
    lw      t3,     160(s2)         # t3 = SRAM_0[40]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[32]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[40]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     128(s2)         # SRAM_0[32] = X
    sw      t3,     160(s2)         # SRAM_0[40] = Y

    lw      t2,     192(s2)         # t2 = SRAM_0[48]
    lw      t3,     224(s2)         # t3 = SRAM_0[56]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[48]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[56]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     192(s2)         # SRAM_0[48] = X
    sw      t3,     224(s2)         # SRAM_0[56] = Y

    # m=1, i=1, 9, ..., 57 (8 butterflies)
    lw      t4,     16(s3)          # t4 = SRAM_W[4]
    lw      t2,     4(s2)           # t2 = SRAM_0[1]
    lw      t3,     36(s2)          # t3 = SRAM_0[9]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[1]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[9]
    sw      t4,     0(s6)           # dpath_reg_2 = W[4]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     4(s2)           # SRAM_0[1] = X
    sw      t3,     36(s2)          # SRAM_0[9] = Y

    lw      t2,     68(s2)          # t2 = SRAM_0[17]
    lw      t3,     100(s2)         # t3 = SRAM_0[25]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[17]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[25]
    sw      t4,     0(s6)           # dpath_reg_2 = W[4]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     68(s2)          # SRAM_0[17] = X
    sw      t3,     100(s2)         # SRAM_0[25] = Y

    lw      t2,     132(s2)         # t2 = SRAM_0[33]
    lw      t3,     164(s2)         # t3 = SRAM_0[41]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[33]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[41]
    sw      t4,     0(s6)           # dpath_reg_2 = W[4]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     132(s2)         # SRAM_0[33] = X
    sw      t3,     164(s2)         # SRAM_0[41] = Y

    lw      t2,     196(s2)         # t2 = SRAM_0[49]
    lw      t3,     228(s2)         # t3 = SRAM_0[57]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[49]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[57]
    sw      t4,     0(s6)           # dpath_reg_2 = W[4]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     196(s2)         # SRAM_0[49] = X
    sw      t3,     228(s2)         # SRAM_0[57] = Y

    # m=2, i=2, 10, ..., 58 (8 butterflies)
    lw      t4,     32(s3)          # t4 = SRAM_W[8]
    lw      t2,     8(s2)           # t2 = SRAM_0[2]
    lw      t3,     40(s2)          # t3 = SRAM_0[10]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[2]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[10]
    sw      t4,     0(s6)           # dpath_reg_2 = W[8]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     8(s2)           # SRAM_0[2] = X
    sw      t3,     40(s2)          # SRAM_0[10] = Y

    lw      t2,     72(s2)          # t2 = SRAM_0[18]
    lw      t3,     104(s2)         # t3 = SRAM_0[26]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[18]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[26]
    sw      t4,     0(s6)           # dpath_reg_2 = W[8]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     72(s2)          # SRAM_0[18] = X
    sw      t3,     104(s2)         # SRAM_0[26] = Y

    lw      t2,     136(s2)         # t2 = SRAM_0[34]
    lw      t3,     168(s2)         # t3 = SRAM_0[42]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[34]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[42]
    sw      t4,     0(s6)           # dpath_reg_2 = W[8]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     136(s2)         # SRAM_0[34] = X
    sw      t3,     168(s2)         # SRAM_0[42] = Y

    lw      t2,     200(s2)         # t2 = SRAM_0[50]
    lw      t3,     232(s2)         # t3 = SRAM_0[58]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[50]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[58]
    sw      t4,     0(s6)           # dpath_reg_2 = W[8]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     200(s2)         # SRAM_0[50] = X
    sw      t3,     232(s2)         # SRAM_0[58] = Y

    # m=3, i=3, 11, ..., 59 (8 butterflies)
    lw      t4,     48(s3)          # t4 = SRAM_W[12]
    lw      t2,     12(s2)          # t2 = SRAM_0[3]
    lw      t3,     44(s2)          # t3 = SRAM_0[11]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[3]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[11]
    sw      t4,     0(s6)           # dpath_reg_2 = W[12]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     12(s2)          # SRAM_0[3] = X
    sw      t3,     44(s2)          # SRAM_0[11] = Y

    lw      t2,     76(s2)          # t2 = SRAM_0[19]
    lw      t3,     108(s2)         # t3 = SRAM_0[27]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[19]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[27]
    sw      t4,     0(s6)           # dpath_reg_2 = W[12]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     76(s2)          # SRAM_0[19] = X
    sw      t3,     108(s2)         # SRAM_0[27] = Y

    lw      t2,     140(s2)         # t2 = SRAM_0[35]
    lw      t3,     172(s2)         # t3 = SRAM_0[43]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[35]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[43]
    sw      t4,     0(s6)           # dpath_reg_2 = W[12]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     140(s2)         # SRAM_0[35] = X
    sw      t3,     172(s2)         # SRAM_0[43] = Y

    lw      t2,     204(s2)         # t2 = SRAM_0[51]
    lw      t3,     236(s2)         # t3 = SRAM_0[59]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[51]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[59]
    sw      t4,     0(s6)           # dpath_reg_2 = W[12]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     204(s2)         # SRAM_0[51] = X
    sw      t3,     236(s2)         # SRAM_0[59] = Y

    # m=4, i=4, 12, ..., 60 (8 butterflies)
    lw      t4,     64(s3)          # t4 = SRAM_W[16]
    lw      t2,     16(s2)          # t2 = SRAM_0[4]
    lw      t3,     48(s2)          # t3 = SRAM_0[12]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[4]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[12]
    sw      t4,     0(s6)           # dpath_reg_2 = W[16]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     16(s2)          # SRAM_0[4] = X
    sw      t3,     48(s2)          # SRAM_0[12] = Y

    lw      t2,     80(s2)          # t2 = SRAM_0[20]
    lw      t3,     112(s2)         # t3 = SRAM_0[28]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[20]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[28]
    sw      t4,     0(s6)           # dpath_reg_2 = W[16]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     80(s2)          # SRAM_0[20] = X
    sw      t3,     112(s2)         # SRAM_0[28] = Y

    lw      t2,     144(s2)         # t2 = SRAM_0[36]
    lw      t3,     176(s2)         # t3 = SRAM_0[44]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[36]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[44]
    sw      t4,     0(s6)           # dpath_reg_2 = W[16]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     144(s2)         # SRAM_0[36] = X
    sw      t3,     176(s2)         # SRAM_0[44] = Y

    lw      t2,     208(s2)         # t2 = SRAM_0[52]
    lw      t3,     240(s2)         # t3 = SRAM_0[60]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[52]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[60]
    sw      t4,     0(s6)           # dpath_reg_2 = W[16]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     208(s2)         # SRAM_0[52] = X
    sw      t3,     240(s2)         # SRAM_0[60] = Y

    # m=5, i=5, 13, ..., 61 (8 butterflies)
    lw      t4,     80(s3)          # t4 = SRAM_W[20]
    lw      t2,     20(s2)          # t2 = SRAM_0[5]
    lw      t3,     52(s2)          # t3 = SRAM_0[13]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[5]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[13]
    sw      t4,     0(s6)           # dpath_reg_2 = W[20]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     20(s2)          # SRAM_0[5] = X
    sw      t3,     52(s2)          # SRAM_0[13] = Y

    lw      t2,     84(s2)          # t2 = SRAM_0[21]
    lw      t3,     116(s2)         # t3 = SRAM_0[29]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[21]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[29]
    sw      t4,     0(s6)           # dpath_reg_2 = W[20]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     84(s2)          # SRAM_0[21] = X
    sw      t3,     116(s2)         # SRAM_0[29] = Y

    lw      t2,     148(s2)         # t2 = SRAM_0[37]
    lw      t3,     180(s2)         # t3 = SRAM_0[45]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[37]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[45]
    sw      t4,     0(s6)           # dpath_reg_2 = W[20]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     148(s2)         # SRAM_0[37] = X
    sw      t3,     180(s2)         # SRAM_0[45] = Y

    lw      t2,     212(s2)         # t2 = SRAM_0[53]
    lw      t3,     244(s2)         # t3 = SRAM_0[61]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[53]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[61]
    sw      t4,     0(s6)           # dpath_reg_2 = W[20]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     212(s2)         # SRAM_0[53] = X
    sw      t3,     244(s2)         # SRAM_0[61] = Y

    # m=6, i=6, 14, ..., 62 (8 butterflies)
    lw      t4,     96(s3)          # t4 = SRAM_W[24]
    lw      t2,     24(s2)          # t2 = SRAM_0[6]
    lw      t3,     56(s2)          # t3 = SRAM_0[14]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[6]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[14]
    sw      t4,     0(s6)           # dpath_reg_2 = W[24]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     24(s2)          # SRAM_0[6] = X
    sw      t3,     56(s2)          # SRAM_0[14] = Y

    lw      t2,     88(s2)          # t2 = SRAM_0[22]
    lw      t3,     120(s2)         # t3 = SRAM_0[30]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[22]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[30]
    sw      t4,     0(s6)           # dpath_reg_2 = W[24]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     88(s2)          # SRAM_0[22] = X
    sw      t3,     120(s2)         # SRAM_0[30] = Y

    lw      t2,     152(s2)         # t2 = SRAM_0[38]
    lw      t3,     184(s2)         # t3 = SRAM_0[46]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[38]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[46]
    sw      t4,     0(s6)           # dpath_reg_2 = W[24]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     152(s2)         # SRAM_0[38] = X
    sw      t3,     184(s2)         # SRAM_0[46] = Y

    lw      t2,     216(s2)         # t2 = SRAM_0[54]
    lw      t3,     248(s2)         # t3 = SRAM_0[62]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[54]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[62]
    sw      t4,     0(s6)           # dpath_reg_2 = W[24]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     216(s2)         # SRAM_0[54] = X
    sw      t3,     248(s2)         # SRAM_0[62] = Y

    # m=7, i=7, 15, ..., 63 (8 butterflies)
    lw      t4,     112(s3)         # t4 = SRAM_W[28]
    lw      t2,     28(s2)          # t2 = SRAM_0[7]
    lw      t3,     60(s2)          # t3 = SRAM_0[15]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[7]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[15]
    sw      t4,     0(s6)           # dpath_reg_2 = W[28]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     28(s2)          # SRAM_0[7] = X
    sw      t3,     60(s2)          # SRAM_0[15] = Y

    lw      t2,     92(s2)          # t2 = SRAM_0[23]
    lw      t3,     124(s2)         # t3 = SRAM_0[31]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[23]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[31]
    sw      t4,     0(s6)           # dpath_reg_2 = W[28]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     92(s2)          # SRAM_0[23] = X
    sw      t3,     124(s2)         # SRAM_0[31] = Y

    lw      t2,     156(s2)         # t2 = SRAM_0[39]
    lw      t3,     188(s2)         # t3 = SRAM_0[47]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[39]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[47]
    sw      t4,     0(s6)           # dpath_reg_2 = W[28]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     156(s2)         # SRAM_0[39] = X
    sw      t3,     188(s2)         # SRAM_0[47] = Y

    lw      t2,     220(s2)         # t2 = SRAM_0[55]
    lw      t3,     252(s2)         # t3 = SRAM_0[63]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[55]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[63]
    sw      t4,     0(s6)           # dpath_reg_2 = W[28]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     220(s2)         # SRAM_0[55] = X
    sw      t3,     252(s2)         # SRAM_0[63] = Y

#------------------------------------------------
# Stage_4: SRAM_0 <--> FFT_engine (l=16, m=0~15)
#------------------------------------------------
    # m=0, i=0, 16, ..., 48 (4 butterflies)
    lw      t4,     0(s3)           # t4 = SRAM_W[0]
    lw      t2,     0(s2)           # t2 = SRAM_0[0]
    lw      t3,     64(s2)          # t3 = SRAM_0[16]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[0]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[16]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     0(s2)           # SRAM_0[0] = X
    sw      t3,     64(s2)          # SRAM_0[16] = Y

    lw      t2,     128(s2)         # t2 = SRAM_0[32]
    lw      t3,     192(s2)         # t3 = SRAM_0[48]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[32]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[48]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     128(s2)         # SRAM_0[32] = X
    sw      t3,     192(s2)         # SRAM_0[48] = Y

    # m=1, i=1, 17, ..., 49 (4 butterflies)
    lw      t4,     8(s3)           # t4 = SRAM_W[2]
    lw      t2,     4(s2)           # t2 = SRAM_0[1]
    lw      t3,     68(s2)          # t3 = SRAM_0[17]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[1]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[17]
    sw      t4,     0(s6)           # dpath_reg_2 = W[2]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     4(s2)           # SRAM_0[1] = X
    sw      t3,     68(s2)          # SRAM_0[17] = Y

    lw      t2,     132(s2)         # t2 = SRAM_0[33]
    lw      t3,     196(s2)         # t3 = SRAM_0[49]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[33]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[49]
    sw      t4,     0(s6)           # dpath_reg_2 = W[2]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     132(s2)         # SRAM_0[33] = X
    sw      t3,     196(s2)         # SRAM_0[49] = Y

    # m=2, i=2, 18, ..., 50 (4 butterflies)
    lw      t4,     16(s3)          # t4 = SRAM_W[4]
    lw      t2,     8(s2)           # t2 = SRAM_0[2]
    lw      t3,     72(s2)          # t3 = SRAM_0[18]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[2]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[18]
    sw      t4,     0(s6)           # dpath_reg_2 = W[4]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     8(s2)           # SRAM_0[2] = X
    sw      t3,     72(s2)          # SRAM_0[18] = Y

    lw      t2,     136(s2)         # t2 = SRAM_0[34]
    lw      t3,     200(s2)         # t3 = SRAM_0[50]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[34]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[50]
    sw      t4,     0(s6)           # dpath_reg_2 = W[4]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     136(s2)         # SRAM_0[34] = X
    sw      t3,     200(s2)         # SRAM_0[50] = Y

    # m=3, i=3, 19, ..., 51 (4 butterflies)
    lw      t4,     24(s3)          # t4 = SRAM_W[6]
    lw      t2,     12(s2)          # t2 = SRAM_0[3]
    lw      t3,     76(s2)          # t3 = SRAM_0[19]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[3]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[19]
    sw      t4,     0(s6)           # dpath_reg_2 = W[6]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     12(s2)          # SRAM_0[3] = X
    sw      t3,     76(s2)          # SRAM_0[19] = Y

    lw      t2,     140(s2)         # t2 = SRAM_0[35]
    lw      t3,     204(s2)         # t3 = SRAM_0[51]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[35]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[51]
    sw      t4,     0(s6)           # dpath_reg_2 = W[6]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     140(s2)         # SRAM_0[35] = X
    sw      t3,     204(s2)         # SRAM_0[51] = Y

    # m=4, i=4, 20, ..., 52 (4 butterflies)
    lw      t4,     32(s3)          # t4 = SRAM_W[8]
    lw      t2,     16(s2)          # t2 = SRAM_0[4]
    lw      t3,     80(s2)          # t3 = SRAM_0[20]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[4]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[20]
    sw      t4,     0(s6)           # dpath_reg_2 = W[8]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     16(s2)          # SRAM_0[4] = X
    sw      t3,     80(s2)          # SRAM_0[20] = Y

    lw      t2,     144(s2)         # t2 = SRAM_0[36]
    lw      t3,     208(s2)         # t3 = SRAM_0[52]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[36]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[52]
    sw      t4,     0(s6)           # dpath_reg_2 = W[8]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     144(s2)         # SRAM_0[36] = X
    sw      t3,     208(s2)         # SRAM_0[52] = Y

    # m=5, i=5, 21, ..., 53 (4 butterflies)
    lw      t4,     40(s3)          # t4 = SRAM_W[10]
    lw      t2,     20(s2)          # t2 = SRAM_0[5]
    lw      t3,     84(s2)          # t3 = SRAM_0[21]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[5]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[21]
    sw      t4,     0(s6)           # dpath_reg_2 = W[10]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     20(s2)          # SRAM_0[5] = X
    sw      t3,     84(s2)          # SRAM_0[21] = Y

    lw      t2,     148(s2)         # t2 = SRAM_0[37]
    lw      t3,     212(s2)         # t3 = SRAM_0[53]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[37]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[53]
    sw      t4,     0(s6)           # dpath_reg_2 = W[10]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     148(s2)         # SRAM_0[37] = X
    sw      t3,     212(s2)         # SRAM_0[53] = Y

    # m=6, i=6, 22, ..., 54 (4 butterflies)
    lw      t4,     48(s3)          # t4 = SRAM_W[12]
    lw      t2,     24(s2)          # t2 = SRAM_0[6]
    lw      t3,     88(s2)          # t3 = SRAM_0[22]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[6]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[22]
    sw      t4,     0(s6)           # dpath_reg_2 = W[12]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     24(s2)          # SRAM_0[6] = X
    sw      t3,     88(s2)          # SRAM_0[22] = Y

    lw      t2,     152(s2)         # t2 = SRAM_0[38]
    lw      t3,     216(s2)         # t3 = SRAM_0[54]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[38]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[54]
    sw      t4,     0(s6)           # dpath_reg_2 = W[12]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     152(s2)         # SRAM_0[38] = X
    sw      t3,     216(s2)         # SRAM_0[54] = Y

    # m=7, i=7, 23, ..., 55 (4 butterflies)
    lw      t4,     56(s3)          # t4 = SRAM_W[14]
    lw      t2,     28(s2)          # t2 = SRAM_0[7]
    lw      t3,     92(s2)          # t3 = SRAM_0[23]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[7]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[23]
    sw      t4,     0(s6)           # dpath_reg_2 = W[14]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     28(s2)          # SRAM_0[7] = X
    sw      t3,     92(s2)          # SRAM_0[23] = Y

    lw      t2,     156(s2)         # t2 = SRAM_0[39]
    lw      t3,     220(s2)         # t3 = SRAM_0[55]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[39]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[55]
    sw      t4,     0(s6)           # dpath_reg_2 = W[14]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     156(s2)         # SRAM_0[39] = X
    sw      t3,     220(s2)         # SRAM_0[55] = Y

    # m=8, i=8, 24, ..., 56 (4 butterflies)
    lw      t4,     64(s3)          # t4 = SRAM_W[16]
    lw      t2,     32(s2)          # t2 = SRAM_0[8]
    lw      t3,     96(s2)          # t3 = SRAM_0[24]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[8]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[24]
    sw      t4,     0(s6)           # dpath_reg_2 = W[16]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     32(s2)          # SRAM_0[8] = X
    sw      t3,     96(s2)          # SRAM_0[24] = Y

    lw      t2,     160(s2)         # t2 = SRAM_0[40]
    lw      t3,     224(s2)         # t3 = SRAM_0[56]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[40]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[56]
    sw      t4,     0(s6)           # dpath_reg_2 = W[16]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     160(s2)         # SRAM_0[40] = X
    sw      t3,     224(s2)         # SRAM_0[56] = Y

    # m=9, i=9, 25, ..., 57 (4 butterflies)
    lw      t4,     72(s3)          # t4 = SRAM_W[18]
    lw      t2,     36(s2)          # t2 = SRAM_0[9]
    lw      t3,     100(s2)         # t3 = SRAM_0[25]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[9]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[25]
    sw      t4,     0(s6)           # dpath_reg_2 = W[18]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     36(s2)          # SRAM_0[9] = X
    sw      t3,     100(s2)         # SRAM_0[25] = Y

    lw      t2,     164(s2)         # t2 = SRAM_0[41]
    lw      t3,     228(s2)         # t3 = SRAM_0[57]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[41]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[57]
    sw      t4,     0(s6)           # dpath_reg_2 = W[18]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     164(s2)         # SRAM_0[41] = X
    sw      t3,     228(s2)         # SRAM_0[57] = Y

    # m=10, i=10, 26, ..., 58 (4 butterflies)
    lw      t4,     80(s3)          # t4 = SRAM_W[20]
    lw      t2,     40(s2)          # t2 = SRAM_0[10]
    lw      t3,     104(s2)         # t3 = SRAM_0[26]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[10]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[26]
    sw      t4,     0(s6)           # dpath_reg_2 = W[20]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     40(s2)          # SRAM_0[10] = X
    sw      t3,     104(s2)         # SRAM_0[26] = Y

    lw      t2,     168(s2)         # t2 = SRAM_0[42]
    lw      t3,     232(s2)         # t3 = SRAM_0[58]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[42]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[58]
    sw      t4,     0(s6)           # dpath_reg_2 = W[20]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     168(s2)         # SRAM_0[42] = X
    sw      t3,     232(s2)         # SRAM_0[58] = Y

    # m=11, i=11, 27, ..., 59 (4 butterflies)
    lw      t4,     88(s3)          # t4 = SRAM_W[22]
    lw      t2,     44(s2)          # t2 = SRAM_0[11]
    lw      t3,     108(s2)         # t3 = SRAM_0[27]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[11]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[27]
    sw      t4,     0(s6)           # dpath_reg_2 = W[22]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     44(s2)          # SRAM_0[11] = X
    sw      t3,     108(s2)         # SRAM_0[27] = Y

    lw      t2,     172(s2)         # t2 = SRAM_0[43]
    lw      t3,     236(s2)         # t3 = SRAM_0[59]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[43]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[59]
    sw      t4,     0(s6)           # dpath_reg_2 = W[22]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     172(s2)         # SRAM_0[43] = X
    sw      t3,     236(s2)         # SRAM_0[59] = Y

    # m=12, i=12, 28, ..., 60 (4 butterflies)
    lw      t4,     96(s3)          # t4 = SRAM_W[24]
    lw      t2,     48(s2)          # t2 = SRAM_0[12]
    lw      t3,     112(s2)         # t3 = SRAM_0[28]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[12]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[28]
    sw      t4,     0(s6)           # dpath_reg_2 = W[24]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     48(s2)          # SRAM_0[12] = X
    sw      t3,     112(s2)         # SRAM_0[28] = Y

    lw      t2,     176(s2)         # t2 = SRAM_0[44]
    lw      t3,     240(s2)         # t3 = SRAM_0[60]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[44]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[60]
    sw      t4,     0(s6)           # dpath_reg_2 = W[24]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     176(s2)         # SRAM_0[44] = X
    sw      t3,     240(s2)         # SRAM_0[60] = Y

    # m=13, i=13, 29, ..., 61 (4 butterflies)
    lw      t4,     104(s3)         # t4 = SRAM_W[26]
    lw      t2,     52(s2)          # t2 = SRAM_0[13]
    lw      t3,     116(s2)         # t3 = SRAM_0[29]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[13]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[29]
    sw      t4,     0(s6)           # dpath_reg_2 = W[26]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     52(s2)          # SRAM_0[13] = X
    sw      t3,     116(s2)         # SRAM_0[29] = Y

    lw      t2,     180(s2)         # t2 = SRAM_0[45]
    lw      t3,     244(s2)         # t3 = SRAM_0[61]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[45]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[61]
    sw      t4,     0(s6)           # dpath_reg_2 = W[26]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     180(s2)         # SRAM_0[45] = X
    sw      t3,     244(s2)         # SRAM_0[61] = Y

    # m=14, i=14, 30, ..., 62 (4 butterflies)
    lw      t4,     112(s3)         # t4 = SRAM_W[28]
    lw      t2,     56(s2)          # t2 = SRAM_0[14]
    lw      t3,     120(s2)         # t3 = SRAM_0[30]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[14]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[30]
    sw      t4,     0(s6)           # dpath_reg_2 = W[28]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     56(s2)          # SRAM_0[14] = X
    sw      t3,     120(s2)         # SRAM_0[30] = Y

    lw      t2,     184(s2)         # t2 = SRAM_0[46]
    lw      t3,     248(s2)         # t3 = SRAM_0[62]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[46]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[62]
    sw      t4,     0(s6)           # dpath_reg_2 = W[28]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     184(s2)         # SRAM_0[46] = X
    sw      t3,     248(s2)         # SRAM_0[62] = Y

    # m=15, i=15, 31, ..., 63 (4 butterflies)
    lw      t4,     120(s3)         # t4 = SRAM_W[30]
    lw      t2,     60(s2)          # t2 = SRAM_0[15]
    lw      t3,     124(s2)         # t3 = SRAM_0[31]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[15]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[31]
    sw      t4,     0(s6)           # dpath_reg_2 = W[30]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     60(s2)          # SRAM_0[15] = X
    sw      t3,     124(s2)         # SRAM_0[31] = Y

    lw      t2,     188(s2)         # t2 = SRAM_0[47]
    lw      t3,     252(s2)         # t3 = SRAM_0[63]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[47]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[63]
    sw      t4,     0(s6)           # dpath_reg_2 = W[30]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     188(s2)         # SRAM_0[47] = X
    sw      t3,     252(s2)         # SRAM_0[63] = Y

#------------------------------------------------
# Stage_5: SRAM_0 <--> FFT_engine (l=32, m=0~31)
#------------------------------------------------
    # m=0, i=0, 32 (2 butterflies)
    lw      t4,     0(s3)           # t4 = SRAM_W[0]
    lw      t2,     0(s2)           # t2 = SRAM_0[0]
    lw      t3,     128(s2)         # t3 = SRAM_0[32]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[0]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[32]
    sw      t4,     0(s6)           # dpath_reg_2 = W[0]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     0(s2)           # SRAM_0[0] = X
    sw      t3,     128(s2)         # SRAM_0[32] = Y

    # m=1, i=1, 33 (2 butterflies)
    lw      t4,     4(s3)           # t4 = SRAM_W[1]
    lw      t2,     4(s2)           # t2 = SRAM_0[1]
    lw      t3,     132(s2)         # t3 = SRAM_0[33]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[1]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[33]
    sw      t4,     0(s6)           # dpath_reg_2 = W[1]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     4(s2)           # SRAM_0[1] = X
    sw      t3,     132(s2)         # SRAM_0[33] = Y

    # m=2, i=2, 34 (2 butterflies)
    lw      t4,     8(s3)           # t4 = SRAM_W[2]
    lw      t2,     8(s2)           # t2 = SRAM_0[2]
    lw      t3,     136(s2)         # t3 = SRAM_0[34]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[2]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[34]
    sw      t4,     0(s6)           # dpath_reg_2 = W[2]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     8(s2)           # SRAM_0[2] = X
    sw      t3,     136(s2)         # SRAM_0[34] = Y

    # m=3, i=3, 35 (2 butterflies)
    lw      t4,     12(s3)          # t4 = SRAM_W[3]
    lw      t2,     12(s2)          # t2 = SRAM_0[3]
    lw      t3,     140(s2)         # t3 = SRAM_0[35]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[3]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[35]
    sw      t4,     0(s6)           # dpath_reg_2 = W[3]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     12(s2)          # SRAM_0[3] = X
    sw      t3,     140(s2)         # SRAM_0[35] = Y

    # m=4, i=4, 36 (2 butterflies)
    lw      t4,     16(s3)          # t4 = SRAM_W[4]
    lw      t2,     16(s2)          # t2 = SRAM_0[4]
    lw      t3,     144(s2)         # t3 = SRAM_0[36]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[4]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[36]
    sw      t4,     0(s6)           # dpath_reg_2 = W[4]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     16(s2)          # SRAM_0[4] = X
    sw      t3,     144(s2)         # SRAM_0[36] = Y

    # m=5, i=5, 37 (2 butterflies)
    lw      t4,     20(s3)          # t4 = SRAM_W[5]
    lw      t2,     20(s2)          # t2 = SRAM_0[5]
    lw      t3,     148(s2)         # t3 = SRAM_0[37]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[5]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[37]
    sw      t4,     0(s6)           # dpath_reg_2 = W[5]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     20(s2)          # SRAM_0[5] = X
    sw      t3,     148(s2)         # SRAM_0[37] = Y

    # m=6, i=6, 38 (2 butterflies)
    lw      t4,     24(s3)          # t4 = SRAM_W[6]
    lw      t2,     24(s2)          # t2 = SRAM_0[6]
    lw      t3,     152(s2)         # t3 = SRAM_0[38]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[6]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[38]
    sw      t4,     0(s6)           # dpath_reg_2 = W[6]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     24(s2)          # SRAM_0[6] = X
    sw      t3,     152(s2)         # SRAM_0[38] = Y

    # m=7, i=7, 39 (2 butterflies)
    lw      t4,     28(s3)          # t4 = SRAM_W[7]
    lw      t2,     28(s2)          # t2 = SRAM_0[7]
    lw      t3,     156(s2)         # t3 = SRAM_0[39]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[7]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[39]
    sw      t4,     0(s6)           # dpath_reg_2 = W[7]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     28(s2)          # SRAM_0[7] = X
    sw      t3,     156(s2)         # SRAM_0[39] = Y

    # m=8, i=8, 40 (2 butterflies)
    lw      t4,     32(s3)          # t4 = SRAM_W[8]
    lw      t2,     32(s2)          # t2 = SRAM_0[8]
    lw      t3,     160(s2)         # t3 = SRAM_0[40]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[8]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[40]
    sw      t4,     0(s6)           # dpath_reg_2 = W[8]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     32(s2)          # SRAM_0[8] = X
    sw      t3,     160(s2)         # SRAM_0[40] = Y

    # m=9, i=9, 41 (2 butterflies)
    lw      t4,     36(s3)          # t4 = SRAM_W[9]
    lw      t2,     36(s2)          # t2 = SRAM_0[9]
    lw      t3,     164(s2)         # t3 = SRAM_0[41]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[9]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[41]
    sw      t4,     0(s6)           # dpath_reg_2 = W[9]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     36(s2)          # SRAM_0[9] = X
    sw      t3,     164(s2)         # SRAM_0[41] = Y

    # m=10, i=10, 42 (2 butterflies)
    lw      t4,     40(s3)          # t4 = SRAM_W[10]
    lw      t2,     40(s2)          # t2 = SRAM_0[10]
    lw      t3,     168(s2)         # t3 = SRAM_0[42]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[10]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[42]
    sw      t4,     0(s6)           # dpath_reg_2 = W[10]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     40(s2)          # SRAM_0[10] = X
    sw      t3,     168(s2)         # SRAM_0[42] = Y

    # m=11, i=11, 43 (2 butterflies)
    lw      t4,     44(s3)          # t4 = SRAM_W[11]
    lw      t2,     44(s2)          # t2 = SRAM_0[11]
    lw      t3,     172(s2)         # t3 = SRAM_0[43]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[11]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[43]
    sw      t4,     0(s6)           # dpath_reg_2 = W[11]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     44(s2)          # SRAM_0[11] = X
    sw      t3,     172(s2)         # SRAM_0[43] = Y

    # m=12, i=12, 44 (2 butterflies)
    lw      t4,     48(s3)          # t4 = SRAM_W[12]
    lw      t2,     48(s2)          # t2 = SRAM_0[12]
    lw      t3,     176(s2)         # t3 = SRAM_0[44]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[12]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[44]
    sw      t4,     0(s6)           # dpath_reg_2 = W[12]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     48(s2)          # SRAM_0[12] = X
    sw      t3,     176(s2)         # SRAM_0[44] = Y

    # m=13, i=13, 45 (2 butterflies)
    lw      t4,     52(s3)          # t4 = SRAM_W[13]
    lw      t2,     52(s2)          # t2 = SRAM_0[13]
    lw      t3,     180(s2)         # t3 = SRAM_0[45]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[13]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[45]
    sw      t4,     0(s6)           # dpath_reg_2 = W[13]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     52(s2)          # SRAM_0[13] = X
    sw      t3,     180(s2)         # SRAM_0[45] = Y

    # m=14, i=14, 46 (2 butterflies)
    lw      t4,     56(s3)          # t4 = SRAM_W[14]
    lw      t2,     56(s2)          # t2 = SRAM_0[14]
    lw      t3,     184(s2)         # t3 = SRAM_0[46]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[14]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[46]
    sw      t4,     0(s6)           # dpath_reg_2 = W[14]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     56(s2)          # SRAM_0[14] = X
    sw      t3,     184(s2)         # SRAM_0[46] = Y

    # m=15, i=15, 47 (2 butterflies)
    lw      t4,     60(s3)          # t4 = SRAM_W[15]
    lw      t2,     60(s2)          # t2 = SRAM_0[15]
    lw      t3,     188(s2)         # t3 = SRAM_0[47]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[15]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[47]
    sw      t4,     0(s6)           # dpath_reg_2 = W[15]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     60(s2)          # SRAM_0[15] = X
    sw      t3,     188(s2)         # SRAM_0[47] = Y

    # m=16, i=16, 48 (2 butterflies)
    lw      t4,     64(s3)          # t4 = SRAM_W[16]
    lw      t2,     64(s2)          # t2 = SRAM_0[16]
    lw      t3,     192(s2)         # t3 = SRAM_0[48]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[16]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[48]
    sw      t4,     0(s6)           # dpath_reg_2 = W[16]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     64(s2)          # SRAM_0[16] = X
    sw      t3,     192(s2)         # SRAM_0[48] = Y

    # m=17, i=17, 49 (2 butterflies)
    lw      t4,     68(s3)          # t4 = SRAM_W[17]
    lw      t2,     68(s2)          # t2 = SRAM_0[17]
    lw      t3,     196(s2)         # t3 = SRAM_0[49]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[17]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[49]
    sw      t4,     0(s6)           # dpath_reg_2 = W[17]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     68(s2)          # SRAM_0[17] = X
    sw      t3,     196(s2)         # SRAM_0[49] = Y

    # m=18, i=18, 50 (2 butterflies)
    lw      t4,     72(s3)          # t4 = SRAM_W[18]
    lw      t2,     72(s2)          # t2 = SRAM_0[18]
    lw      t3,     200(s2)         # t3 = SRAM_0[50]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[18]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[50]
    sw      t4,     0(s6)           # dpath_reg_2 = W[18]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     72(s2)          # SRAM_0[18] = X
    sw      t3,     200(s2)         # SRAM_0[50] = Y

    # m=19, i=19, 51 (2 butterflies)
    lw      t4,     76(s3)          # t4 = SRAM_W[19]
    lw      t2,     76(s2)          # t2 = SRAM_0[19]
    lw      t3,     204(s2)         # t3 = SRAM_0[51]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[19]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[51]
    sw      t4,     0(s6)           # dpath_reg_2 = W[19]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     76(s2)          # SRAM_0[19] = X
    sw      t3,     204(s2)         # SRAM_0[51] = Y

    # m=20, i=20, 52 (2 butterflies)
    lw      t4,     80(s3)          # t4 = SRAM_W[20]
    lw      t2,     80(s2)          # t2 = SRAM_0[20]
    lw      t3,     208(s2)         # t3 = SRAM_0[52]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[20]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[52]
    sw      t4,     0(s6)           # dpath_reg_2 = W[20]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     80(s2)          # SRAM_0[20] = X
    sw      t3,     208(s2)         # SRAM_0[52] = Y

    # m=21, i=21, 53 (2 butterflies)
    lw      t4,     84(s3)          # t4 = SRAM_W[21]
    lw      t2,     84(s2)          # t2 = SRAM_0[21]
    lw      t3,     212(s2)         # t3 = SRAM_0[53]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[21]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[53]
    sw      t4,     0(s6)           # dpath_reg_2 = W[21]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     84(s2)          # SRAM_0[21] = X
    sw      t3,     212(s2)         # SRAM_0[53] = Y

    # m=22, i=22, 54 (2 butterflies)
    lw      t4,     88(s3)          # t4 = SRAM_W[22]
    lw      t2,     88(s2)          # t2 = SRAM_0[22]
    lw      t3,     216(s2)         # t3 = SRAM_0[54]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[22]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[54]
    sw      t4,     0(s6)           # dpath_reg_2 = W[22]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     88(s2)          # SRAM_0[22] = X
    sw      t3,     216(s2)         # SRAM_0[54] = Y

    # m=23, i=23, 55 (2 butterflies)
    lw      t4,     92(s3)          # t4 = SRAM_W[23]
    lw      t2,     92(s2)          # t2 = SRAM_0[23]
    lw      t3,     220(s2)         # t3 = SRAM_0[55]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[23]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[55]
    sw      t4,     0(s6)           # dpath_reg_2 = W[23]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     92(s2)          # SRAM_0[23] = X
    sw      t3,     220(s2)         # SRAM_0[55] = Y

    # m=24, i=24, 56 (2 butterflies)
    lw      t4,     96(s3)          # t4 = SRAM_W[24]
    lw      t2,     96(s2)          # t2 = SRAM_0[24]
    lw      t3,     224(s2)         # t3 = SRAM_0[56]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[24]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[56]
    sw      t4,     0(s6)           # dpath_reg_2 = W[24]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     96(s2)          # SRAM_0[24] = X
    sw      t3,     224(s2)         # SRAM_0[56] = Y

    # m=25, i=25, 57 (2 butterflies)
    lw      t4,     100(s3)         # t4 = SRAM_W[25]
    lw      t2,     100(s2)         # t2 = SRAM_0[25]
    lw      t3,     228(s2)         # t3 = SRAM_0[57]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[25]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[57]
    sw      t4,     0(s6)           # dpath_reg_2 = W[25]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     100(s2)         # SRAM_0[25] = X
    sw      t3,     228(s2)         # SRAM_0[57] = Y

    # m=26, i=26, 58 (2 butterflies)
    lw      t4,     104(s3)         # t4 = SRAM_W[26]
    lw      t2,     104(s2)         # t2 = SRAM_0[26]
    lw      t3,     232(s2)         # t3 = SRAM_0[58]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[26]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[58]
    sw      t4,     0(s6)           # dpath_reg_2 = W[26]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     104(s2)         # SRAM_0[26] = X
    sw      t3,     232(s2)         # SRAM_0[58] = Y

    # m=27, i=27, 59 (2 butterflies)
    lw      t4,     108(s3)         # t4 = SRAM_W[27]
    lw      t2,     108(s2)         # t2 = SRAM_0[27]
    lw      t3,     236(s2)         # t3 = SRAM_0[59]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[27]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[59]
    sw      t4,     0(s6)           # dpath_reg_2 = W[27]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     108(s2)         # SRAM_0[27] = X
    sw      t3,     236(s2)         # SRAM_0[59] = Y

    # m=28, i=28, 60 (2 butterflies)
    lw      t4,     112(s3)         # t4 = SRAM_W[28]
    lw      t2,     112(s2)         # t2 = SRAM_0[28]
    lw      t3,     240(s2)         # t3 = SRAM_0[60]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[28]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[60]
    sw      t4,     0(s6)           # dpath_reg_2 = W[28]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     112(s2)         # SRAM_0[28] = X
    sw      t3,     240(s2)         # SRAM_0[60] = Y

    # m=29, i=29, 61 (2 butterflies)
    lw      t4,     116(s3)         # t4 = SRAM_W[29]
    lw      t2,     116(s2)         # t2 = SRAM_0[29]
    lw      t3,     244(s2)         # t3 = SRAM_0[61]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[29]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[61]
    sw      t4,     0(s6)           # dpath_reg_2 = W[29]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     116(s2)         # SRAM_0[29] = X
    sw      t3,     244(s2)         # SRAM_0[61] = Y

    # m=30, i=30, 62 (2 butterflies)
    lw      t4,     120(s3)         # t4 = SRAM_W[30]
    lw      t2,     120(s2)         # t2 = SRAM_0[30]
    lw      t3,     248(s2)         # t3 = SRAM_0[62]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[30]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[62]
    sw      t4,     0(s6)           # dpath_reg_2 = W[30]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     120(s2)         # SRAM_0[30] = X
    sw      t3,     248(s2)         # SRAM_0[62] = Y

    # m=31, i=31, 63 (2 butterflies)
    lw      t4,     124(s3)         # t4 = SRAM_W[31]
    lw      t2,     124(s2)         # t2 = SRAM_0[31]
    lw      t3,     252(s2)         # t3 = SRAM_0[63]
    sw      t2,     0(s4)           # dpath_reg_0 = SRAM_0[31]
    sw      t3,     0(s5)           # dpath_reg_1 = SRAM_0[63]
    sw      t4,     0(s6)           # dpath_reg_2 = W[31]
    lw      t2,     4(s4)           # t2 = dpath_reg_0 (X)
    lw      t3,     4(s5)           # t3 = dpath_reg_1 (Y)
    sw      t2,     124(s2)         # SRAM_0[31] = X
    sw      t3,     252(s2)         # SRAM_0[63] = Y
/* Edit Code Above */

	mv      s11,    x0
store_output:
    bge     s11,    s7,     exit_store_output
    slli    s11,    s11,    2
    add     s9,     s2,     s11   
    srli    s11,    s11,    2 
    lw      t0,     0       (s9)
    slli    s11,    s11,    2
    add     s9,     s1,     s11
    srli    s11,    s11,    2
    sw      t0,     0       (s9)
    addi    s11,    s11,    1
    jal     x0,     store_output

exit_store_output:
    addi    s0,     s0,     256
    addi    s1,     s1,     256
    jal     x0,     start_fft