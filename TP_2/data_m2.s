#core1

.global _main_init
.text

/*
        Module              From          To         
      - SRAM I/O            0x0000_0000   0x0000_FFFF
      - SRAM 0              0x0100_0000   0x0100_FFFF
      - SRAM W              0x0300_0000   0x0300_FFFF
      - Dpath reg (port 0)  0x0500_0000   0x0500_0007
      - Dpath reg (port 1)  0x0600_0000   0x0600_0007
      - Dpath reg (port 2)  0x0700_0000   0x0700_0003
*/
# s2 ~ s11 총 12개
# t0 ~ t6 총 7개
_main_init:
    lui     s0,     0x00000 # SRAM_I/O input 시작주소
    lui     s1,     0x00000 
    addi    s1,     s1,     0x400 # SRAM_I/O output 시작주소
    lui     s2,     0x01000 # SRAM_0 시작주소
    lui     s3,     0x03000 # SRAM_W 시작주소
    lui     s4,     0x05000 # port 0
    lui     s5,     0x06000 # port 1
    lui     s6,     0x07000 # port 2
    add x0, x0, x0
start_fft:

#twiddle 선언
lw s7, 0(s3)  # w[0]
add x0, x0, x0

#------------------------------------------------
# Stage_0: SRAM_I/O --> SRAM_0 (Bit-Reversed) --> FFT_engine (Dpath_reg)
#------------------------------------------------
# Butterfly 11: SRAM_0[22], SRAM_0[23] with W[0]
lw t0, 104(s0)      # Preload t0 = SRAM_IO[26] for Butterfly 11
lw t1, 232(s0)      # Preload t1 = SRAM_IO[58] for Butterfly 11

lw s10, 16(s3)
lw s11, 24(s3)
lw t6, 32(s3)

sw t0, 88(s2)       # SRAM_0[22] = SRAM_IO[26]
sw t1, 92(s2)       # SRAM_0[23] = SRAM_IO[58]
add x0, x0, x0
lw t2, 88(s2)       # t2 = SRAM_0[22]
lw t3, 92(s2)       # t3 = SRAM_0[23]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[22]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[23]
sw s7, 0(s6)        # dpath_reg_2 = W[0]
lw a0, 40(s3)
lw t0, 24(s0)       # Preload t0 = SRAM_IO[6] for Butterfly 12
lw t1, 152(s0)      # Preload t1 = SRAM_IO[38] for Butterfly 12
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 88(s2)       # SRAM_0[22] = X
sw t3, 92(s2)       # SRAM_0[23] = Y

# Butterfly 12: SRAM_0[24], SRAM_0[25] with W[0]
sw t0, 96(s2)       # SRAM_0[24] = SRAM_IO[6] (preloaded)
sw t1, 100(s2)      # SRAM_0[25] = SRAM_IO[38] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 96(s2)       # t2 = SRAM_0[24]
lw t3, 100(s2)      # t3 = SRAM_0[25]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[24]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[25]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a1, 48(s3)
lw t0, 88(s0)       # Preload t0 = SRAM_IO[22] for Butterfly 13
lw t1, 216(s0)      # Preload t1 = SRAM_IO[54] for Butterfly 13
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 96(s2)       # SRAM_0[24] = X
sw t3, 100(s2)      # SRAM_0[25] = Y

# Butterfly 13: SRAM_0[26], SRAM_0[27] with W[0]
sw t0, 104(s2)      # SRAM_0[26] = SRAM_IO[22] (preloaded)
sw t1, 108(s2)      # SRAM_0[27] = SRAM_IO[54] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 104(s2)      # t2 = SRAM_0[26]
lw t3, 108(s2)      # t3 = SRAM_0[27]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[26]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[27]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a2, 56(s3)
lw t0, 56(s0)       # Preload t0 = SRAM_IO[14] for Butterfly 14
lw t1, 184(s0)      # Preload t1 = SRAM_IO[46] for Butterfly 14
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 104(s2)      # SRAM_0[26] = X
sw t3, 108(s2)      # SRAM_0[27] = Y

# Butterfly 14: SRAM_0[28], SRAM_0[29] with W[0]
sw t0, 112(s2)      # SRAM_0[28] = SRAM_IO[14] (preloaded)
sw t1, 116(s2)      # SRAM_0[29] = SRAM_IO[46] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 112(s2)      # t2 = SRAM_0[28]
lw t3, 116(s2)      # t3 = SRAM_0[29]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[28]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[29]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a3, 64(s3)
lw t0, 120(s0)      # Preload t0 = SRAM_IO[30] for Butterfly 15
lw t1, 248(s0)      # Preload t1 = SRAM_IO[62] for Butterfly 15
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 112(s2)      # SRAM_0[28] = X
sw t3, 116(s2)      # SRAM_0[29] = Y

# Butterfly 15: SRAM_0[30], SRAM_0[31] with W[0]
sw t0, 120(s2)      # SRAM_0[30] = SRAM_IO[30] (preloaded)
sw t1, 124(s2)      # SRAM_0[31] = SRAM_IO[62] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 120(s2)      # t2 = SRAM_0[30]
lw t3, 124(s2)      # t3 = SRAM_0[31]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[30]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[31]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a4, 72(s3)
lw t0, 4(s0)        # Preload t0 = SRAM_IO[1] for Butterfly 16
lw t1, 132(s0)      # Preload t1 = SRAM_IO[33] for Butterfly 16
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 120(s2)      # SRAM_0[30] = X
sw t3, 124(s2)      # SRAM_0[31] = Y

# Butterfly 16: SRAM_0[32], SRAM_0[33] with W[0]
sw t0, 128(s2)      # SRAM_0[32] = SRAM_IO[1] (preloaded)
sw t1, 132(s2)      # SRAM_0[33] = SRAM_IO[33] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 128(s2)      # t2 = SRAM_0[32]
lw t3, 132(s2)      # t3 = SRAM_0[33]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[32]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[33]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a5, 80(s3)
lw t0, 68(s0)       # Preload t0 = SRAM_IO[17] for Butterfly 17
lw t1, 196(s0)      # Preload t1 = SRAM_IO[49] for Butterfly 17
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 128(s2)      # SRAM_0[32] = X
sw t3, 132(s2)      # SRAM_0[33] = Y

# Butterfly 17: SRAM_0[34], SRAM_0[35] with W[0]
sw t0, 136(s2)      # SRAM_0[34] = SRAM_IO[17] (preloaded)
sw t1, 140(s2)      # SRAM_0[35] = SRAM_IO[49] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 136(s2)      # t2 = SRAM_0[34]
lw t3, 140(s2)      # t3 = SRAM_0[35]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[34]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[35]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a6, 88(s3)
lw t0, 36(s0)       # Preload t0 = SRAM_IO[9] for Butterfly 18
lw t1, 164(s0)      # Preload t1 = SRAM_IO[41] for Butterfly 18
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 136(s2)      # SRAM_0[34] = X
sw t3, 140(s2)      # SRAM_0[35] = Y

# Butterfly 18: SRAM_0[36], SRAM_0[37] with W[0]
sw t0, 144(s2)      # SRAM_0[36] = SRAM_IO[9] (preloaded)
sw t1, 148(s2)      # SRAM_0[37] = SRAM_IO[41] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 144(s2)      # t2 = SRAM_0[36]
lw t3, 148(s2)      # t3 = SRAM_0[37]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[36]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[37]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a7, 96(s3)
lw t0, 100(s0)      # Preload t0 = SRAM_IO[25] for Butterfly 19
lw t1, 228(s0)      # Preload t1 = SRAM_IO[57] for Butterfly 19
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 144(s2)      # SRAM_0[36] = X
sw t3, 148(s2)      # SRAM_0[37] = Y

# Butterfly 19: SRAM_0[38], SRAM_0[39] with W[0]
sw t0, 152(s2)      # SRAM_0[38] = SRAM_IO[25] (preloaded)
sw t1, 156(s2)      # SRAM_0[39] = SRAM_IO[57] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 152(s2)      # t2 = SRAM_0[38]
lw t3, 156(s2)      # t3 = SRAM_0[39]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[38]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[39]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw ra, 104(s3)
lw t0, 20(s0)       # Preload t0 = SRAM_IO[5] for Butterfly 20
lw t1, 148(s0)      # Preload t1 = SRAM_IO[37] for Butterfly 20
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 152(s2)      # SRAM_0[38] = X
sw t3, 156(s2)      # SRAM_0[39] = Y

# Butterfly 20: SRAM_0[40], SRAM_0[41] with W[0]
sw t0, 160(s2)      # SRAM_0[40] = SRAM_IO[5] (preloaded)
sw t1, 164(s2)      # SRAM_0[41] = SRAM_IO[37] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 160(s2)      # t2 = SRAM_0[40]
lw t3, 164(s2)      # t3 = SRAM_0[41]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[40]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[41]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw sp, 112(s3)
lw t0, 84(s0)       # Preload t0 = SRAM_IO[21] for Butterfly 21
lw t1, 212(s0)      # Preload t1 = SRAM_IO[53] for Butterfly 21
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 160(s2)      # SRAM_0[40] = X
sw t3, 164(s2)      # SRAM_0[41] = Y

# Butterfly 21: SRAM_0[42], SRAM_0[43] with W[0]
sw t0, 168(s2)      # SRAM_0[42] = SRAM_IO[21] (preloaded)
sw t1, 172(s2)      # SRAM_0[43] = SRAM_IO[53] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 168(s2)      # t2 = SRAM_0[42]
lw t3, 172(s2)      # t3 = SRAM_0[43]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[42]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[43]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw gp, 120(s3)
lw s9, 8(s3)
add x0, x0, x0
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 168(s2)      # SRAM_0[42] = X
sw t3, 172(s2)      # SRAM_0[43] = Y

add x0, x0, x0
#------------------------------------------------
# Stage_1: SRAM_0 <--> FFT_engine (32 butterflies)
#------------------------------------------------
 # m=0 group: twiddle factor W[0], butterflies (0,2), (4,6), ..., (60,62)

# Butterfly 6: (25,27)
lw t0, 100(s2)   
lw t1, 108(s2)   # load SRAM0[27]
sw t0, 0(s4)     # load SRAM0[25]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 116(s2)   # preload SRAM0[29]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 100(s2)   # store to SRAM0[25]
sw t3, 108(s2)   # store to SRAM0[27]

# Butterfly 7: (29,31)
lw t1, 124(s2)   # load SRAM0[31]
sw s8, 0(s4)     # store preloaded SRAM0[29]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 132(s2)   # preload SRAM0[33]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 116(s2)   # store to SRAM0[29]
sw t3, 124(s2)   # store to SRAM0[31]

# Butterfly 8: (33,35)
lw t1, 140(s2)   # load SRAM0[35]
sw s8, 0(s4)     # store preloaded SRAM0[33]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 148(s2)   # preload SRAM0[37]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 132(s2)   # store to SRAM0[33]
sw t3, 140(s2)   # store to SRAM0[35]

# Butterfly 9: (37,39)
lw t1, 156(s2)   # load SRAM0[39]
sw s8, 0(s4)     # store preloaded SRAM0[37]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 164(s2)   # preload SRAM0[41]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 148(s2)   # store to SRAM0[37]
sw t3, 156(s2)   # store to SRAM0[39]

# Butterfly 10: (41,43)
lw t1, 172(s2)   # load SRAM0[43]
sw s8, 0(s4)     # store preloaded SRAM0[41]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 180(s2)   # preload SRAM0[45]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 164(s2)   # store to SRAM0[41]
sw t3, 172(s2)   # store to SRAM0[43]

# Butterfly 11: (45,47)
lw t1, 188(s2)   # load SRAM0[47]
sw s8, 0(s4)     # store preloaded SRAM0[45]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 196(s2)   # preload SRAM0[49]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 180(s2)   # store to SRAM0[45]
sw t3, 188(s2)   # store to SRAM0[47]

# Butterfly 12: (49,51)
lw t1, 204(s2)   # load SRAM0[51]
sw s8, 0(s4)     # store preloaded SRAM0[49]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 212(s2)   # preload SRAM0[53]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 196(s2)   # store to SRAM0[49]
sw t3, 204(s2)   # store to SRAM0[51]

# Butterfly 13: (53,55)
lw t1, 220(s2)   # load SRAM0[55]
sw s8, 0(s4)     # store preloaded SRAM0[53]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 228(s2)   # preload SRAM0[57]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 212(s2)   # store to SRAM0[53]
sw t3, 220(s2)   # store to SRAM0[55]

# Butterfly 14: (57,59)
lw t1, 236(s2)   # load SRAM0[59]
sw s8, 0(s4)     # store preloaded SRAM0[57]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 244(s2)   # preload SRAM0[61]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 228(s2)   # store to SRAM0[57]
sw t3, 236(s2)   # store to SRAM0[59]

# Butterfly 15: (61,63)
lw t1, 252(s2)   # load SRAM0[63]
sw s8, 0(s4)     # store preloaded SRAM0[61]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 0(s2)     # preload SRAM0[0]
lw t2, 4(s4)     
lw t3, 4(s5)
sw t2, 244(s2)   # store to SRAM0[61]
sw t3, 252(s2)   # store to SRAM0[63]

# Stage_2: s=2, d=4, g=4, b=8, twiddle W[m*8]

# Group m=0: twiddle W[0]

# Butterfly 0: (0,4)
lw t1, 16(s2)     # SRAM0[4]
sw s8, 0(s4)      # SRAM0[0]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 32(s2)     # preload SRAM0[8]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 0(s2)
sw t3, 16(s2)

# Butterfly 1: (8,12)
lw t1, 48(s2)     # SRAM0[12]
sw s8, 0(s4)      # SRAM0[8]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 64(s2)     # preload SRAM0[16]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 32(s2)
sw t3, 48(s2)

# Butterfly 2: (16,20)
lw t1, 80(s2)     # SRAM0[20]
sw s8, 0(s4)      # SRAM0[16]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 96(s2)     # preload SRAM0[24]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 64(s2)
sw t3, 80(s2)

# Butterfly 3: (24,28)
lw t1, 112(s2)    # SRAM0[28]
sw s8, 0(s4)      # SRAM0[24]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 128(s2)    # preload SRAM0[32]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 96(s2)
sw t3, 112(s2)

# Butterfly 4: (32,36)
lw t1, 144(s2)    # SRAM0[36]
sw s8, 0(s4)      # SRAM0[32]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 160(s2)    # preload SRAM0[40]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 128(s2)
sw t3, 144(s2)

# Butterfly 5: (40,44)
lw t1, 176(s2)    # SRAM0[44]
sw s8, 0(s4)      # SRAM0[40]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 192(s2)    # preload SRAM0[48]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 160(s2)
sw t3, 176(s2)

# Butterfly 6: (48,52)
lw t1, 208(s2)    # SRAM0[52]
sw s8, 0(s4)      # SRAM0[48]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 224(s2)    # preload SRAM0[56]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 192(s2)
sw t3, 208(s2)

# Butterfly 7: (56,60)
lw t1, 240(s2)    # SRAM0[60]
sw s8, 0(s4)      # SRAM0[56]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 4(s2)      # preload SRAM0[1] for next group (m=1)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 224(s2)
sw t3, 240(s2)

# Group m=1: twiddle W[8]

# Butterfly 0: (1,5)
lw t1, 20(s2)     # SRAM0[5]
sw s8, 0(s4)
sw t1, 0(s5)
sw t6, 0(s6)
lw s8, 36(s2)     # preload SRAM0[9]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 4(s2)
sw t3, 20(s2)

# Butterfly 1: (9,13)
lw t1, 52(s2)     # SRAM0[13]
sw s8, 0(s4)      # SRAM0[9]
sw t1, 0(s5)
sw t6, 0(s6)
lw s8, 68(s2)     # preload SRAM0[17]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 36(s2)
sw t3, 52(s2)

# Butterfly 2: (17,21)
lw t1, 84(s2)     # SRAM0[21]
sw s8, 0(s4)      # SRAM0[17]
sw t1, 0(s5)
sw t6, 0(s6)
lw s8, 200(s2)    # preload SRAM0[50]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 68(s2)
sw t3, 84(s2)

# Stage_3: s=3, d=8, g=8, b=4, twiddle W[m*4]

# Group m=0: twiddle W[0]

# Butterfly 3: (50,58)
lw t1, 232(s2)    # SRAM0[58]
sw s8, 0(s4)      # SRAM0[50]
sw t1, 0(s5)
sw t6, 0(s6)
lw s8, 12(s2)     # preload SRAM0[3] for next group (m=3)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 200(s2)
sw t3, 232(s2)

# Group m=3: twiddle W[12]

# Butterfly 0: (3,11)
lw t1, 44(s2)     # SRAM0[11]
sw s8, 0(s4)
sw t1, 0(s5)
sw a1, 0(s6)
lw s8, 76(s2)     # preload SRAM0[19]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 12(s2)
sw t3, 44(s2)

# Butterfly 1: (19,27)
lw t1, 108(s2)    # SRAM0[27]
sw s8, 0(s4)      # SRAM0[19]
sw t1, 0(s5)
sw a1, 0(s6)
lw s8, 140(s2)    # preload SRAM0[35]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 76(s2)
sw t3, 108(s2)

# Butterfly 2: (35,43)
lw t1, 172(s2)    # SRAM0[43]
sw s8, 0(s4)      # SRAM0[35]
sw t1, 0(s5)
sw a1, 0(s6)
lw s8, 204(s2)    # preload SRAM0[51]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 140(s2)
sw t3, 172(s2)

# Butterfly 3: (51,59)
lw t1, 236(s2)    # SRAM0[59]
sw s8, 0(s4)      # SRAM0[51]
sw t1, 0(s5)
sw a1, 0(s6)
lw s8, 16(s2)     # preload SRAM0[4] for next group (m=4)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 204(s2)
sw t3, 236(s2)

# Group m=4: twiddle W[16]

# Butterfly 0: (4,12)
lw t1, 48(s2)     # SRAM0[12]
sw s8, 0(s4)
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 80(s2)     # preload SRAM0[20]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 16(s2)
sw t3, 48(s2)

# Butterfly 1: (20,28)
lw t1, 112(s2)    # SRAM0[28]
sw s8, 0(s4)      # SRAM0[20]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 144(s2)    # preload SRAM0[36]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 80(s2)
sw t3, 112(s2)

# Butterfly 2: (36,44)
lw t1, 176(s2)    # SRAM0[44]
sw s8, 0(s4)      # SRAM0[36]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 208(s2)    # preload SRAM0[52]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 144(s2)
sw t3, 176(s2)

# Butterfly 3: (52,60)
lw t1, 240(s2)    # SRAM0[60]
sw s8, 0(s4)      # SRAM0[52]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 20(s2)     # preload SRAM0[5] for next group (m=5)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 208(s2)
sw t3, 240(s2)

# Group m=5: twiddle W[20]

# Butterfly 0: (5,13)
lw t1, 52(s2)     # SRAM0[13]
sw s8, 0(s4)
sw t1, 0(s5)
sw a5, 0(s6)
lw s8, 84(s2)     # preload SRAM0[21]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 20(s2)
sw t3, 52(s2)

# Butterfly 1: (21,29)
lw t1, 116(s2)    # SRAM0[29]
sw s8, 0(s4)      # SRAM0[21]
sw t1, 0(s5)
sw a5, 0(s6)
lw s8, 44(s2)     # preload SRAM0[11] for next group (m=11)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 84(s2)
sw t3, 116(s2)

# Stage_4: s=4, d=16, g=16, b=2, twiddle W[m*2]

# Butterfly 0: (11,27)
lw t1, 108(s2)    # SRAM0[27]
sw s8, 0(s4)
sw t1, 0(s5)
sw a6, 0(s6)
lw s8, 172(s2)    # preload SRAM0[43]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 44(s2)
sw t3, 108(s2)

# Butterfly 1: (43,59)
lw t1, 236(s2)    # SRAM0[59]
sw s8, 0(s4)      # SRAM0[43]
sw t1, 0(s5)
sw a6, 0(s6)
lw s8, 48(s2)     # preload SRAM0[12] for next group (m=12)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 172(s2)
sw t3, 236(s2)

# Group m=12: twiddle W[24]

# Butterfly 0: (12,28)
lw t1, 112(s2)    # SRAM0[28]
sw s8, 0(s4)
sw t1, 0(s5)
sw a7, 0(s6)
lw s8, 176(s2)    # preload SRAM0[44]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 48(s2)
sw t3, 112(s2)

# Butterfly 1: (44,60)
lw t1, 240(s2)    # SRAM0[60]
sw s8, 0(s4)      # SRAM0[44]
sw t1, 0(s5)
sw a7, 0(s6)
lw s8, 52(s2)     # preload SRAM0[13] for next group (m=13)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 176(s2)
sw t3, 240(s2)

# Group m=13: twiddle W[26]

# Butterfly 0: (13,29)
lw t1, 116(s2)    # SRAM0[29]
sw s8, 0(s4)
sw t1, 0(s5)
sw ra, 0(s6)
lw s8, 180(s2)    # preload SRAM0[45]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 52(s2)
sw t3, 116(s2)

# Butterfly 1: (45,61)
lw t1, 244(s2)    # SRAM0[61]
sw s8, 0(s4)      # SRAM0[45]
sw t1, 0(s5)
sw ra, 0(s6)
lw s8, 56(s2)     # preload SRAM0[14] for next group (m=14)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 180(s2)
sw t3, 244(s2)

# Group m=14: twiddle W[28]

# Butterfly 0: (14,30)
lw t1, 120(s2)    # SRAM0[30]
sw s8, 0(s4)
sw t1, 0(s5)
sw sp, 0(s6)
lw s8, 184(s2)    # preload SRAM0[46]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 56(s2)
sw t3, 120(s2)

# Butterfly 1: (46,62)
lw t1, 248(s2)    # SRAM0[62]
sw s8, 0(s4)      # SRAM0[46]
sw t1, 0(s5)
sw sp, 0(s6)
lw s8, 60(s2)     # preload SRAM0[15] for next group (m=15)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 184(s2)
sw t3, 248(s2)

# Group m=15: twiddle W[30]

# Butterfly 0: (15,31)
lw t1, 124(s2)    # SRAM0[31]
sw s8, 0(s4)
sw t1, 0(s5)
sw gp, 0(s6)
lw s8, 188(s2)    # preload SRAM0[47]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 60(s2)
sw t3, 124(s2)

# Butterfly 1: (47,63)
lw t1, 252(s2)    # SRAM0[63]
sw s8, 0(s4)      # SRAM0[47]
sw t1, 0(s5)
sw gp, 0(s6)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 188(s2)
sw t3, 252(s2)


#------------------------------------------------
# Stage_5: 
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
add x0, x0, x0
add x0, x0, x0
lw      t5,     0(s2)           # t5 = SRAM_0[0] (store for next m)
lw      t6,     128(s2)         # t6 = SRAM_0[32] (store for next m)

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
sw      t5,     0(s1)           # SRAM_I/O[0] = X (from m=0)
sw      t6,     128(s1)         # SRAM_I/O[32] = Y (from m=0)
lw      t5,     4(s2)           # t5 = SRAM_0[1] (store for next m)
lw      t6,     132(s2)         # t6 = SRAM_0[33] (store for next m)

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
sw      t5,     4(s1)           # SRAM_I/O[1] = X (from m=1)
sw      t6,     132(s1)         # SRAM_I/O[33] = Y (from m=1)
lw      t5,     8(s2)           # t5 = SRAM_0[2] (store for next m)
lw      t6,     136(s2)         # t6 = SRAM_0[34] (store for next m)

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
sw      t5,     8(s1)           # SRAM_I/O[2] = X (from m=2)
sw      t6,     136(s1)         # SRAM_I/O[34] = Y (from m=2)
lw      t5,     12(s2)          # t5 = SRAM_0[3] (store for next m)
lw      t6,     140(s2)         # t6 = SRAM_0[35] (store for next m)

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
sw      t5,     12(s1)          # SRAM_I/O[3] = X (from m=3)
sw      t6,     140(s1)         # SRAM_I/O[35] = Y (from m=3)
lw      t5,     16(s2)          # t5 = SRAM_0[4] (store for next m)
lw      t6,     144(s2)         # t6 = SRAM_0[36] (store for next m)

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
sw      t5,     16(s1)          # SRAM_I/O[4] = X (from m=4)
sw      t6,     144(s1)         # SRAM_I/O[36] = Y (from m=4)
lw      t5,     20(s2)          # t5 = SRAM_0[5] (store for next m)
lw      t6,     148(s2)         # t6 = SRAM_0[37] (store for next m)

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
sw      t5,     20(s1)          # SRAM_I/O[5] = X (from m=5)
sw      t6,     148(s1)         # SRAM_I/O[37] = Y (from m=5)
lw      t5,     24(s2)          # t5 = SRAM_0[6] (store for next m)
lw      t6,     152(s2)         # t6 = SRAM_0[38] (store for next m)

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
sw      t5,     24(s1)          # SRAM_I/O[6] = X (from m=6)
sw      t6,     152(s1)         # SRAM_I/O[38] = Y (from m=6)
lw      t5,     28(s2)          # t5 = SRAM_0[7] (store for next m)
lw      t6,     156(s2)         # t6 = SRAM_0[39] (store for next m)

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
sw      t5,     28(s1)          # SRAM_I/O[7] = X (from m=7)
sw      t6,     156(s1)         # SRAM_I/O[39] = Y (from m=7)
lw      t5,     32(s2)          # t5 = SRAM_0[8] (store for next m)
lw      t6,     160(s2)         # t6 = SRAM_0[40] (store for next m)

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
sw      t5,     32(s1)          # SRAM_I/O[8] = X (from m=8)
sw      t6,     160(s1)         # SRAM_I/O[40] = Y (from m=8)
lw      t5,     36(s2)          # t5 = SRAM_0[9] (store for next m)
lw      t6,     164(s2)         # t6 = SRAM_0[41] (store for next m)

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
sw      t5,     36(s1)          # SRAM_I/O[9] = X (from m=9)
sw      t6,     164(s1)         # SRAM_I/O[41] = Y (from m=9)
lw      t5,     40(s2)          # t5 = SRAM_0[10] (store for next m)
lw      t6,     168(s2)         # t6 = SRAM_0[42] (store for next m)

add x0, x0, x0
add x0, x0, x0
add x0, x0, x0

# Final store for m=31
sw      t5,     40(s1)         # SRAM_I/O[31] = X (from m=31)
sw      t6,     168(s1)         # SRAM_I/O[63] = Y (from m=31)

add x0, x0, x0


#set1 start
addi s0, s0, 256
addi s1, s1, 256

#twiddle 선언
lw s7, 0(s3)  # w[0]
add x0, x0, x0

#------------------------------------------------
# Stage_0: SRAM_I/O --> SRAM_0 (Bit-Reversed) --> FFT_engine (Dpath_reg)
#------------------------------------------------
# Butterfly 11: SRAM_0[22], SRAM_0[23] with W[0]
lw t0, 104(s0)      # Preload t0 = SRAM_IO[26] for Butterfly 11
lw t1, 232(s0)      # Preload t1 = SRAM_IO[58] for Butterfly 11

lw s10, 16(s3)
lw s11, 24(s3)
lw t6, 32(s3)

sw t0, 88(s2)       # SRAM_0[22] = SRAM_IO[26]
sw t1, 92(s2)       # SRAM_0[23] = SRAM_IO[58]
add x0, x0, x0
lw t2, 88(s2)       # t2 = SRAM_0[22]
lw t3, 92(s2)       # t3 = SRAM_0[23]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[22]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[23]
sw s7, 0(s6)        # dpath_reg_2 = W[0]
lw a0, 40(s3)
lw t0, 24(s0)       # Preload t0 = SRAM_IO[6] for Butterfly 12
lw t1, 152(s0)      # Preload t1 = SRAM_IO[38] for Butterfly 12
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 88(s2)       # SRAM_0[22] = X
sw t3, 92(s2)       # SRAM_0[23] = Y

# Butterfly 12: SRAM_0[24], SRAM_0[25] with W[0]
sw t0, 96(s2)       # SRAM_0[24] = SRAM_IO[6] (preloaded)
sw t1, 100(s2)      # SRAM_0[25] = SRAM_IO[38] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 96(s2)       # t2 = SRAM_0[24]
lw t3, 100(s2)      # t3 = SRAM_0[25]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[24]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[25]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a1, 48(s3)
lw t0, 88(s0)       # Preload t0 = SRAM_IO[22] for Butterfly 13
lw t1, 216(s0)      # Preload t1 = SRAM_IO[54] for Butterfly 13
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 96(s2)       # SRAM_0[24] = X
sw t3, 100(s2)      # SRAM_0[25] = Y

# Butterfly 13: SRAM_0[26], SRAM_0[27] with W[0]
sw t0, 104(s2)      # SRAM_0[26] = SRAM_IO[22] (preloaded)
sw t1, 108(s2)      # SRAM_0[27] = SRAM_IO[54] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 104(s2)      # t2 = SRAM_0[26]
lw t3, 108(s2)      # t3 = SRAM_0[27]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[26]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[27]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a2, 56(s3)
lw t0, 56(s0)       # Preload t0 = SRAM_IO[14] for Butterfly 14
lw t1, 184(s0)      # Preload t1 = SRAM_IO[46] for Butterfly 14
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 104(s2)      # SRAM_0[26] = X
sw t3, 108(s2)      # SRAM_0[27] = Y

# Butterfly 14: SRAM_0[28], SRAM_0[29] with W[0]
sw t0, 112(s2)      # SRAM_0[28] = SRAM_IO[14] (preloaded)
sw t1, 116(s2)      # SRAM_0[29] = SRAM_IO[46] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 112(s2)      # t2 = SRAM_0[28]
lw t3, 116(s2)      # t3 = SRAM_0[29]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[28]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[29]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a3, 64(s3)
lw t0, 120(s0)      # Preload t0 = SRAM_IO[30] for Butterfly 15
lw t1, 248(s0)      # Preload t1 = SRAM_IO[62] for Butterfly 15
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 112(s2)      # SRAM_0[28] = X
sw t3, 116(s2)      # SRAM_0[29] = Y

# Butterfly 15: SRAM_0[30], SRAM_0[31] with W[0]
sw t0, 120(s2)      # SRAM_0[30] = SRAM_IO[30] (preloaded)
sw t1, 124(s2)      # SRAM_0[31] = SRAM_IO[62] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 120(s2)      # t2 = SRAM_0[30]
lw t3, 124(s2)      # t3 = SRAM_0[31]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[30]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[31]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a4, 72(s3)
lw t0, 4(s0)        # Preload t0 = SRAM_IO[1] for Butterfly 16
lw t1, 132(s0)      # Preload t1 = SRAM_IO[33] for Butterfly 16
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 120(s2)      # SRAM_0[30] = X
sw t3, 124(s2)      # SRAM_0[31] = Y

# Butterfly 16: SRAM_0[32], SRAM_0[33] with W[0]
sw t0, 128(s2)      # SRAM_0[32] = SRAM_IO[1] (preloaded)
sw t1, 132(s2)      # SRAM_0[33] = SRAM_IO[33] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 128(s2)      # t2 = SRAM_0[32]
lw t3, 132(s2)      # t3 = SRAM_0[33]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[32]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[33]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a5, 80(s3)
lw t0, 68(s0)       # Preload t0 = SRAM_IO[17] for Butterfly 17
lw t1, 196(s0)      # Preload t1 = SRAM_IO[49] for Butterfly 17
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 128(s2)      # SRAM_0[32] = X
sw t3, 132(s2)      # SRAM_0[33] = Y

# Butterfly 17: SRAM_0[34], SRAM_0[35] with W[0]
sw t0, 136(s2)      # SRAM_0[34] = SRAM_IO[17] (preloaded)
sw t1, 140(s2)      # SRAM_0[35] = SRAM_IO[49] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 136(s2)      # t2 = SRAM_0[34]
lw t3, 140(s2)      # t3 = SRAM_0[35]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[34]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[35]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a6, 88(s3)
lw t0, 36(s0)       # Preload t0 = SRAM_IO[9] for Butterfly 18
lw t1, 164(s0)      # Preload t1 = SRAM_IO[41] for Butterfly 18
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 136(s2)      # SRAM_0[34] = X
sw t3, 140(s2)      # SRAM_0[35] = Y

# Butterfly 18: SRAM_0[36], SRAM_0[37] with W[0]
sw t0, 144(s2)      # SRAM_0[36] = SRAM_IO[9] (preloaded)
sw t1, 148(s2)      # SRAM_0[37] = SRAM_IO[41] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 144(s2)      # t2 = SRAM_0[36]
lw t3, 148(s2)      # t3 = SRAM_0[37]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[36]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[37]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a7, 96(s3)
lw t0, 100(s0)      # Preload t0 = SRAM_IO[25] for Butterfly 19
lw t1, 228(s0)      # Preload t1 = SRAM_IO[57] for Butterfly 19
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 144(s2)      # SRAM_0[36] = X
sw t3, 148(s2)      # SRAM_0[37] = Y

# Butterfly 19: SRAM_0[38], SRAM_0[39] with W[0]
sw t0, 152(s2)      # SRAM_0[38] = SRAM_IO[25] (preloaded)
sw t1, 156(s2)      # SRAM_0[39] = SRAM_IO[57] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 152(s2)      # t2 = SRAM_0[38]
lw t3, 156(s2)      # t3 = SRAM_0[39]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[38]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[39]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw ra, 104(s3)
lw t0, 20(s0)       # Preload t0 = SRAM_IO[5] for Butterfly 20
lw t1, 148(s0)      # Preload t1 = SRAM_IO[37] for Butterfly 20
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 152(s2)      # SRAM_0[38] = X
sw t3, 156(s2)      # SRAM_0[39] = Y

# Butterfly 20: SRAM_0[40], SRAM_0[41] with W[0]
sw t0, 160(s2)      # SRAM_0[40] = SRAM_IO[5] (preloaded)
sw t1, 164(s2)      # SRAM_0[41] = SRAM_IO[37] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 160(s2)      # t2 = SRAM_0[40]
lw t3, 164(s2)      # t3 = SRAM_0[41]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[40]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[41]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw sp, 112(s3)
lw t0, 84(s0)       # Preload t0 = SRAM_IO[21] for Butterfly 21
lw t1, 212(s0)      # Preload t1 = SRAM_IO[53] for Butterfly 21
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 160(s2)      # SRAM_0[40] = X
sw t3, 164(s2)      # SRAM_0[41] = Y

# Butterfly 21: SRAM_0[42], SRAM_0[43] with W[0]
sw t0, 168(s2)      # SRAM_0[42] = SRAM_IO[21] (preloaded)
sw t1, 172(s2)      # SRAM_0[43] = SRAM_IO[53] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 168(s2)      # t2 = SRAM_0[42]
lw t3, 172(s2)      # t3 = SRAM_0[43]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[42]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[43]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw gp, 120(s3)
lw s9, 8(s3)
add x0, x0, x0
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 168(s2)      # SRAM_0[42] = X
sw t3, 172(s2)      # SRAM_0[43] = Y

add x0, x0, x0
#------------------------------------------------
# Stage_1: SRAM_0 <--> FFT_engine (32 butterflies)
#------------------------------------------------
 # m=0 group: twiddle factor W[0], butterflies (0,2), (4,6), ..., (60,62)

# Butterfly 6: (25,27)
lw t0, 100(s2)   
lw t1, 108(s2)   # load SRAM0[27]
sw t0, 0(s4)     # load SRAM0[25]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 116(s2)   # preload SRAM0[29]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 100(s2)   # store to SRAM0[25]
sw t3, 108(s2)   # store to SRAM0[27]

# Butterfly 7: (29,31)
lw t1, 124(s2)   # load SRAM0[31]
sw s8, 0(s4)     # store preloaded SRAM0[29]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 132(s2)   # preload SRAM0[33]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 116(s2)   # store to SRAM0[29]
sw t3, 124(s2)   # store to SRAM0[31]

# Butterfly 8: (33,35)
lw t1, 140(s2)   # load SRAM0[35]
sw s8, 0(s4)     # store preloaded SRAM0[33]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 148(s2)   # preload SRAM0[37]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 132(s2)   # store to SRAM0[33]
sw t3, 140(s2)   # store to SRAM0[35]

# Butterfly 9: (37,39)
lw t1, 156(s2)   # load SRAM0[39]
sw s8, 0(s4)     # store preloaded SRAM0[37]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 164(s2)   # preload SRAM0[41]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 148(s2)   # store to SRAM0[37]
sw t3, 156(s2)   # store to SRAM0[39]

# Butterfly 10: (41,43)
lw t1, 172(s2)   # load SRAM0[43]
sw s8, 0(s4)     # store preloaded SRAM0[41]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 180(s2)   # preload SRAM0[45]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 164(s2)   # store to SRAM0[41]
sw t3, 172(s2)   # store to SRAM0[43]

# Butterfly 11: (45,47)
lw t1, 188(s2)   # load SRAM0[47]
sw s8, 0(s4)     # store preloaded SRAM0[45]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 196(s2)   # preload SRAM0[49]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 180(s2)   # store to SRAM0[45]
sw t3, 188(s2)   # store to SRAM0[47]

# Butterfly 12: (49,51)
lw t1, 204(s2)   # load SRAM0[51]
sw s8, 0(s4)     # store preloaded SRAM0[49]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 212(s2)   # preload SRAM0[53]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 196(s2)   # store to SRAM0[49]
sw t3, 204(s2)   # store to SRAM0[51]

# Butterfly 13: (53,55)
lw t1, 220(s2)   # load SRAM0[55]
sw s8, 0(s4)     # store preloaded SRAM0[53]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 228(s2)   # preload SRAM0[57]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 212(s2)   # store to SRAM0[53]
sw t3, 220(s2)   # store to SRAM0[55]

# Butterfly 14: (57,59)
lw t1, 236(s2)   # load SRAM0[59]
sw s8, 0(s4)     # store preloaded SRAM0[57]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 244(s2)   # preload SRAM0[61]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 228(s2)   # store to SRAM0[57]
sw t3, 236(s2)   # store to SRAM0[59]

# Butterfly 15: (61,63)
lw t1, 252(s2)   # load SRAM0[63]
sw s8, 0(s4)     # store preloaded SRAM0[61]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 0(s2)     # preload SRAM0[0]
lw t2, 4(s4)     
lw t3, 4(s5)
sw t2, 244(s2)   # store to SRAM0[61]
sw t3, 252(s2)   # store to SRAM0[63]

# Stage_2: s=2, d=4, g=4, b=8, twiddle W[m*8]

# Group m=0: twiddle W[0]

# Butterfly 0: (0,4)
lw t1, 16(s2)     # SRAM0[4]
sw s8, 0(s4)      # SRAM0[0]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 32(s2)     # preload SRAM0[8]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 0(s2)
sw t3, 16(s2)

# Butterfly 1: (8,12)
lw t1, 48(s2)     # SRAM0[12]
sw s8, 0(s4)      # SRAM0[8]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 64(s2)     # preload SRAM0[16]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 32(s2)
sw t3, 48(s2)

# Butterfly 2: (16,20)
lw t1, 80(s2)     # SRAM0[20]
sw s8, 0(s4)      # SRAM0[16]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 96(s2)     # preload SRAM0[24]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 64(s2)
sw t3, 80(s2)

# Butterfly 3: (24,28)
lw t1, 112(s2)    # SRAM0[28]
sw s8, 0(s4)      # SRAM0[24]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 128(s2)    # preload SRAM0[32]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 96(s2)
sw t3, 112(s2)

# Butterfly 4: (32,36)
lw t1, 144(s2)    # SRAM0[36]
sw s8, 0(s4)      # SRAM0[32]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 160(s2)    # preload SRAM0[40]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 128(s2)
sw t3, 144(s2)

# Butterfly 5: (40,44)
lw t1, 176(s2)    # SRAM0[44]
sw s8, 0(s4)      # SRAM0[40]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 192(s2)    # preload SRAM0[48]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 160(s2)
sw t3, 176(s2)

# Butterfly 6: (48,52)
lw t1, 208(s2)    # SRAM0[52]
sw s8, 0(s4)      # SRAM0[48]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 224(s2)    # preload SRAM0[56]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 192(s2)
sw t3, 208(s2)

# Butterfly 7: (56,60)
lw t1, 240(s2)    # SRAM0[60]
sw s8, 0(s4)      # SRAM0[56]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 4(s2)      # preload SRAM0[1] for next group (m=1)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 224(s2)
sw t3, 240(s2)

# Group m=1: twiddle W[8]

# Butterfly 0: (1,5)
lw t1, 20(s2)     # SRAM0[5]
sw s8, 0(s4)
sw t1, 0(s5)
sw t6, 0(s6)
lw s8, 36(s2)     # preload SRAM0[9]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 4(s2)
sw t3, 20(s2)

# Butterfly 1: (9,13)
lw t1, 52(s2)     # SRAM0[13]
sw s8, 0(s4)      # SRAM0[9]
sw t1, 0(s5)
sw t6, 0(s6)
lw s8, 68(s2)     # preload SRAM0[17]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 36(s2)
sw t3, 52(s2)

# Butterfly 2: (17,21)
lw t1, 84(s2)     # SRAM0[21]
sw s8, 0(s4)      # SRAM0[17]
sw t1, 0(s5)
sw t6, 0(s6)
lw s8, 200(s2)    # preload SRAM0[50]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 68(s2)
sw t3, 84(s2)

# Stage_3: s=3, d=8, g=8, b=4, twiddle W[m*4]

# Group m=0: twiddle W[0]

# Butterfly 3: (50,58)
lw t1, 232(s2)    # SRAM0[58]
sw s8, 0(s4)      # SRAM0[50]
sw t1, 0(s5)
sw t6, 0(s6)
lw s8, 12(s2)     # preload SRAM0[3] for next group (m=3)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 200(s2)
sw t3, 232(s2)

# Group m=3: twiddle W[12]

# Butterfly 0: (3,11)
lw t1, 44(s2)     # SRAM0[11]
sw s8, 0(s4)
sw t1, 0(s5)
sw a1, 0(s6)
lw s8, 76(s2)     # preload SRAM0[19]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 12(s2)
sw t3, 44(s2)

# Butterfly 1: (19,27)
lw t1, 108(s2)    # SRAM0[27]
sw s8, 0(s4)      # SRAM0[19]
sw t1, 0(s5)
sw a1, 0(s6)
lw s8, 140(s2)    # preload SRAM0[35]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 76(s2)
sw t3, 108(s2)

# Butterfly 2: (35,43)
lw t1, 172(s2)    # SRAM0[43]
sw s8, 0(s4)      # SRAM0[35]
sw t1, 0(s5)
sw a1, 0(s6)
lw s8, 204(s2)    # preload SRAM0[51]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 140(s2)
sw t3, 172(s2)

# Butterfly 3: (51,59)
lw t1, 236(s2)    # SRAM0[59]
sw s8, 0(s4)      # SRAM0[51]
sw t1, 0(s5)
sw a1, 0(s6)
lw s8, 16(s2)     # preload SRAM0[4] for next group (m=4)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 204(s2)
sw t3, 236(s2)

# Group m=4: twiddle W[16]

# Butterfly 0: (4,12)
lw t1, 48(s2)     # SRAM0[12]
sw s8, 0(s4)
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 80(s2)     # preload SRAM0[20]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 16(s2)
sw t3, 48(s2)

# Butterfly 1: (20,28)
lw t1, 112(s2)    # SRAM0[28]
sw s8, 0(s4)      # SRAM0[20]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 144(s2)    # preload SRAM0[36]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 80(s2)
sw t3, 112(s2)

# Butterfly 2: (36,44)
lw t1, 176(s2)    # SRAM0[44]
sw s8, 0(s4)      # SRAM0[36]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 208(s2)    # preload SRAM0[52]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 144(s2)
sw t3, 176(s2)

# Butterfly 3: (52,60)
lw t1, 240(s2)    # SRAM0[60]
sw s8, 0(s4)      # SRAM0[52]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 20(s2)     # preload SRAM0[5] for next group (m=5)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 208(s2)
sw t3, 240(s2)

# Group m=5: twiddle W[20]

# Butterfly 0: (5,13)
lw t1, 52(s2)     # SRAM0[13]
sw s8, 0(s4)
sw t1, 0(s5)
sw a5, 0(s6)
lw s8, 84(s2)     # preload SRAM0[21]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 20(s2)
sw t3, 52(s2)

# Butterfly 1: (21,29)
lw t1, 116(s2)    # SRAM0[29]
sw s8, 0(s4)      # SRAM0[21]
sw t1, 0(s5)
sw a5, 0(s6)
lw s8, 44(s2)     # preload SRAM0[11] for next group (m=11)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 84(s2)
sw t3, 116(s2)

# Stage_4: s=4, d=16, g=16, b=2, twiddle W[m*2]

# Butterfly 0: (11,27)
lw t1, 108(s2)    # SRAM0[27]
sw s8, 0(s4)
sw t1, 0(s5)
sw a6, 0(s6)
lw s8, 172(s2)    # preload SRAM0[43]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 44(s2)
sw t3, 108(s2)

# Butterfly 1: (43,59)
lw t1, 236(s2)    # SRAM0[59]
sw s8, 0(s4)      # SRAM0[43]
sw t1, 0(s5)
sw a6, 0(s6)
lw s8, 48(s2)     # preload SRAM0[12] for next group (m=12)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 172(s2)
sw t3, 236(s2)

# Group m=12: twiddle W[24]

# Butterfly 0: (12,28)
lw t1, 112(s2)    # SRAM0[28]
sw s8, 0(s4)
sw t1, 0(s5)
sw a7, 0(s6)
lw s8, 176(s2)    # preload SRAM0[44]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 48(s2)
sw t3, 112(s2)

# Butterfly 1: (44,60)
lw t1, 240(s2)    # SRAM0[60]
sw s8, 0(s4)      # SRAM0[44]
sw t1, 0(s5)
sw a7, 0(s6)
lw s8, 52(s2)     # preload SRAM0[13] for next group (m=13)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 176(s2)
sw t3, 240(s2)

# Group m=13: twiddle W[26]

# Butterfly 0: (13,29)
lw t1, 116(s2)    # SRAM0[29]
sw s8, 0(s4)
sw t1, 0(s5)
sw ra, 0(s6)
lw s8, 180(s2)    # preload SRAM0[45]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 52(s2)
sw t3, 116(s2)

# Butterfly 1: (45,61)
lw t1, 244(s2)    # SRAM0[61]
sw s8, 0(s4)      # SRAM0[45]
sw t1, 0(s5)
sw ra, 0(s6)
lw s8, 56(s2)     # preload SRAM0[14] for next group (m=14)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 180(s2)
sw t3, 244(s2)

# Group m=14: twiddle W[28]

# Butterfly 0: (14,30)
lw t1, 120(s2)    # SRAM0[30]
sw s8, 0(s4)
sw t1, 0(s5)
sw sp, 0(s6)
lw s8, 184(s2)    # preload SRAM0[46]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 56(s2)
sw t3, 120(s2)

# Butterfly 1: (46,62)
lw t1, 248(s2)    # SRAM0[62]
sw s8, 0(s4)      # SRAM0[46]
sw t1, 0(s5)
sw sp, 0(s6)
lw s8, 60(s2)     # preload SRAM0[15] for next group (m=15)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 184(s2)
sw t3, 248(s2)

# Group m=15: twiddle W[30]

# Butterfly 0: (15,31)
lw t1, 124(s2)    # SRAM0[31]
sw s8, 0(s4)
sw t1, 0(s5)
sw gp, 0(s6)
lw s8, 188(s2)    # preload SRAM0[47]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 60(s2)
sw t3, 124(s2)

# Butterfly 1: (47,63)
lw t1, 252(s2)    # SRAM0[63]
sw s8, 0(s4)      # SRAM0[47]
sw t1, 0(s5)
sw gp, 0(s6)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 188(s2)
sw t3, 252(s2)


#------------------------------------------------
# Stage_5: 
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
add x0, x0, x0
add x0, x0, x0
lw      t5,     0(s2)           # t5 = SRAM_0[0] (store for next m)
lw      t6,     128(s2)         # t6 = SRAM_0[32] (store for next m)

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
sw      t5,     0(s1)           # SRAM_I/O[0] = X (from m=0)
sw      t6,     128(s1)         # SRAM_I/O[32] = Y (from m=0)
lw      t5,     4(s2)           # t5 = SRAM_0[1] (store for next m)
lw      t6,     132(s2)         # t6 = SRAM_0[33] (store for next m)

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
sw      t5,     4(s1)           # SRAM_I/O[1] = X (from m=1)
sw      t6,     132(s1)         # SRAM_I/O[33] = Y (from m=1)
lw      t5,     8(s2)           # t5 = SRAM_0[2] (store for next m)
lw      t6,     136(s2)         # t6 = SRAM_0[34] (store for next m)

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
sw      t5,     8(s1)           # SRAM_I/O[2] = X (from m=2)
sw      t6,     136(s1)         # SRAM_I/O[34] = Y (from m=2)
lw      t5,     12(s2)          # t5 = SRAM_0[3] (store for next m)
lw      t6,     140(s2)         # t6 = SRAM_0[35] (store for next m)

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
sw      t5,     12(s1)          # SRAM_I/O[3] = X (from m=3)
sw      t6,     140(s1)         # SRAM_I/O[35] = Y (from m=3)
lw      t5,     16(s2)          # t5 = SRAM_0[4] (store for next m)
lw      t6,     144(s2)         # t6 = SRAM_0[36] (store for next m)

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
sw      t5,     16(s1)          # SRAM_I/O[4] = X (from m=4)
sw      t6,     144(s1)         # SRAM_I/O[36] = Y (from m=4)
lw      t5,     20(s2)          # t5 = SRAM_0[5] (store for next m)
lw      t6,     148(s2)         # t6 = SRAM_0[37] (store for next m)

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
sw      t5,     20(s1)          # SRAM_I/O[5] = X (from m=5)
sw      t6,     148(s1)         # SRAM_I/O[37] = Y (from m=5)
lw      t5,     24(s2)          # t5 = SRAM_0[6] (store for next m)
lw      t6,     152(s2)         # t6 = SRAM_0[38] (store for next m)

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
sw      t5,     24(s1)          # SRAM_I/O[6] = X (from m=6)
sw      t6,     152(s1)         # SRAM_I/O[38] = Y (from m=6)
lw      t5,     28(s2)          # t5 = SRAM_0[7] (store for next m)
lw      t6,     156(s2)         # t6 = SRAM_0[39] (store for next m)

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
sw      t5,     28(s1)          # SRAM_I/O[7] = X (from m=7)
sw      t6,     156(s1)         # SRAM_I/O[39] = Y (from m=7)
lw      t5,     32(s2)          # t5 = SRAM_0[8] (store for next m)
lw      t6,     160(s2)         # t6 = SRAM_0[40] (store for next m)

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
sw      t5,     32(s1)          # SRAM_I/O[8] = X (from m=8)
sw      t6,     160(s1)         # SRAM_I/O[40] = Y (from m=8)
lw      t5,     36(s2)          # t5 = SRAM_0[9] (store for next m)
lw      t6,     164(s2)         # t6 = SRAM_0[41] (store for next m)

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
sw      t5,     36(s1)          # SRAM_I/O[9] = X (from m=9)
sw      t6,     164(s1)         # SRAM_I/O[41] = Y (from m=9)
lw      t5,     40(s2)          # t5 = SRAM_0[10] (store for next m)
lw      t6,     168(s2)         # t6 = SRAM_0[42] (store for next m)

add x0, x0, x0
add x0, x0, x0
add x0, x0, x0

# Final store for m=31
sw      t5,     40(s1)         # SRAM_I/O[31] = X (from m=31)
sw      t6,     168(s1)         # SRAM_I/O[63] = Y (from m=31)

add x0, x0, x0


#set1 start
addi s0, s0, 256
addi s1, s1, 256

#twiddle 선언
lw s7, 0(s3)  # w[0]
add x0, x0, x0

#------------------------------------------------
# Stage_0: SRAM_I/O --> SRAM_0 (Bit-Reversed) --> FFT_engine (Dpath_reg)
#------------------------------------------------
# Butterfly 11: SRAM_0[22], SRAM_0[23] with W[0]
lw t0, 104(s0)      # Preload t0 = SRAM_IO[26] for Butterfly 11
lw t1, 232(s0)      # Preload t1 = SRAM_IO[58] for Butterfly 11

lw s10, 16(s3)
lw s11, 24(s3)
lw t6, 32(s3)

sw t0, 88(s2)       # SRAM_0[22] = SRAM_IO[26]
sw t1, 92(s2)       # SRAM_0[23] = SRAM_IO[58]
add x0, x0, x0
lw t2, 88(s2)       # t2 = SRAM_0[22]
lw t3, 92(s2)       # t3 = SRAM_0[23]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[22]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[23]
sw s7, 0(s6)        # dpath_reg_2 = W[0]
lw a0, 40(s3)
lw t0, 24(s0)       # Preload t0 = SRAM_IO[6] for Butterfly 12
lw t1, 152(s0)      # Preload t1 = SRAM_IO[38] for Butterfly 12
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 88(s2)       # SRAM_0[22] = X
sw t3, 92(s2)       # SRAM_0[23] = Y

# Butterfly 12: SRAM_0[24], SRAM_0[25] with W[0]
sw t0, 96(s2)       # SRAM_0[24] = SRAM_IO[6] (preloaded)
sw t1, 100(s2)      # SRAM_0[25] = SRAM_IO[38] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 96(s2)       # t2 = SRAM_0[24]
lw t3, 100(s2)      # t3 = SRAM_0[25]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[24]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[25]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a1, 48(s3)
lw t0, 88(s0)       # Preload t0 = SRAM_IO[22] for Butterfly 13
lw t1, 216(s0)      # Preload t1 = SRAM_IO[54] for Butterfly 13
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 96(s2)       # SRAM_0[24] = X
sw t3, 100(s2)      # SRAM_0[25] = Y

# Butterfly 13: SRAM_0[26], SRAM_0[27] with W[0]
sw t0, 104(s2)      # SRAM_0[26] = SRAM_IO[22] (preloaded)
sw t1, 108(s2)      # SRAM_0[27] = SRAM_IO[54] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 104(s2)      # t2 = SRAM_0[26]
lw t3, 108(s2)      # t3 = SRAM_0[27]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[26]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[27]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a2, 56(s3)
lw t0, 56(s0)       # Preload t0 = SRAM_IO[14] for Butterfly 14
lw t1, 184(s0)      # Preload t1 = SRAM_IO[46] for Butterfly 14
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 104(s2)      # SRAM_0[26] = X
sw t3, 108(s2)      # SRAM_0[27] = Y

# Butterfly 14: SRAM_0[28], SRAM_0[29] with W[0]
sw t0, 112(s2)      # SRAM_0[28] = SRAM_IO[14] (preloaded)
sw t1, 116(s2)      # SRAM_0[29] = SRAM_IO[46] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 112(s2)      # t2 = SRAM_0[28]
lw t3, 116(s2)      # t3 = SRAM_0[29]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[28]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[29]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a3, 64(s3)
lw t0, 120(s0)      # Preload t0 = SRAM_IO[30] for Butterfly 15
lw t1, 248(s0)      # Preload t1 = SRAM_IO[62] for Butterfly 15
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 112(s2)      # SRAM_0[28] = X
sw t3, 116(s2)      # SRAM_0[29] = Y

# Butterfly 15: SRAM_0[30], SRAM_0[31] with W[0]
sw t0, 120(s2)      # SRAM_0[30] = SRAM_IO[30] (preloaded)
sw t1, 124(s2)      # SRAM_0[31] = SRAM_IO[62] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 120(s2)      # t2 = SRAM_0[30]
lw t3, 124(s2)      # t3 = SRAM_0[31]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[30]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[31]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a4, 72(s3)
lw t0, 4(s0)        # Preload t0 = SRAM_IO[1] for Butterfly 16
lw t1, 132(s0)      # Preload t1 = SRAM_IO[33] for Butterfly 16
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 120(s2)      # SRAM_0[30] = X
sw t3, 124(s2)      # SRAM_0[31] = Y

# Butterfly 16: SRAM_0[32], SRAM_0[33] with W[0]
sw t0, 128(s2)      # SRAM_0[32] = SRAM_IO[1] (preloaded)
sw t1, 132(s2)      # SRAM_0[33] = SRAM_IO[33] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 128(s2)      # t2 = SRAM_0[32]
lw t3, 132(s2)      # t3 = SRAM_0[33]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[32]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[33]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a5, 80(s3)
lw t0, 68(s0)       # Preload t0 = SRAM_IO[17] for Butterfly 17
lw t1, 196(s0)      # Preload t1 = SRAM_IO[49] for Butterfly 17
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 128(s2)      # SRAM_0[32] = X
sw t3, 132(s2)      # SRAM_0[33] = Y

# Butterfly 17: SRAM_0[34], SRAM_0[35] with W[0]
sw t0, 136(s2)      # SRAM_0[34] = SRAM_IO[17] (preloaded)
sw t1, 140(s2)      # SRAM_0[35] = SRAM_IO[49] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 136(s2)      # t2 = SRAM_0[34]
lw t3, 140(s2)      # t3 = SRAM_0[35]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[34]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[35]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a6, 88(s3)
lw t0, 36(s0)       # Preload t0 = SRAM_IO[9] for Butterfly 18
lw t1, 164(s0)      # Preload t1 = SRAM_IO[41] for Butterfly 18
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 136(s2)      # SRAM_0[34] = X
sw t3, 140(s2)      # SRAM_0[35] = Y

# Butterfly 18: SRAM_0[36], SRAM_0[37] with W[0]
sw t0, 144(s2)      # SRAM_0[36] = SRAM_IO[9] (preloaded)
sw t1, 148(s2)      # SRAM_0[37] = SRAM_IO[41] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 144(s2)      # t2 = SRAM_0[36]
lw t3, 148(s2)      # t3 = SRAM_0[37]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[36]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[37]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a7, 96(s3)
lw t0, 100(s0)      # Preload t0 = SRAM_IO[25] for Butterfly 19
lw t1, 228(s0)      # Preload t1 = SRAM_IO[57] for Butterfly 19
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 144(s2)      # SRAM_0[36] = X
sw t3, 148(s2)      # SRAM_0[37] = Y

# Butterfly 19: SRAM_0[38], SRAM_0[39] with W[0]
sw t0, 152(s2)      # SRAM_0[38] = SRAM_IO[25] (preloaded)
sw t1, 156(s2)      # SRAM_0[39] = SRAM_IO[57] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 152(s2)      # t2 = SRAM_0[38]
lw t3, 156(s2)      # t3 = SRAM_0[39]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[38]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[39]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw ra, 104(s3)
lw t0, 20(s0)       # Preload t0 = SRAM_IO[5] for Butterfly 20
lw t1, 148(s0)      # Preload t1 = SRAM_IO[37] for Butterfly 20
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 152(s2)      # SRAM_0[38] = X
sw t3, 156(s2)      # SRAM_0[39] = Y

# Butterfly 20: SRAM_0[40], SRAM_0[41] with W[0]
sw t0, 160(s2)      # SRAM_0[40] = SRAM_IO[5] (preloaded)
sw t1, 164(s2)      # SRAM_0[41] = SRAM_IO[37] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 160(s2)      # t2 = SRAM_0[40]
lw t3, 164(s2)      # t3 = SRAM_0[41]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[40]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[41]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw sp, 112(s3)
lw t0, 84(s0)       # Preload t0 = SRAM_IO[21] for Butterfly 21
lw t1, 212(s0)      # Preload t1 = SRAM_IO[53] for Butterfly 21
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 160(s2)      # SRAM_0[40] = X
sw t3, 164(s2)      # SRAM_0[41] = Y

# Butterfly 21: SRAM_0[42], SRAM_0[43] with W[0]
sw t0, 168(s2)      # SRAM_0[42] = SRAM_IO[21] (preloaded)
sw t1, 172(s2)      # SRAM_0[43] = SRAM_IO[53] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 168(s2)      # t2 = SRAM_0[42]
lw t3, 172(s2)      # t3 = SRAM_0[43]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[42]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[43]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw gp, 120(s3)
lw s9, 8(s3)
add x0, x0, x0
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 168(s2)      # SRAM_0[42] = X
sw t3, 172(s2)      # SRAM_0[43] = Y

add x0, x0, x0
#------------------------------------------------
# Stage_1: SRAM_0 <--> FFT_engine (32 butterflies)
#------------------------------------------------
 # m=0 group: twiddle factor W[0], butterflies (0,2), (4,6), ..., (60,62)

# Butterfly 6: (25,27)
lw t0, 100(s2)   
lw t1, 108(s2)   # load SRAM0[27]
sw t0, 0(s4)     # load SRAM0[25]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 116(s2)   # preload SRAM0[29]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 100(s2)   # store to SRAM0[25]
sw t3, 108(s2)   # store to SRAM0[27]

# Butterfly 7: (29,31)
lw t1, 124(s2)   # load SRAM0[31]
sw s8, 0(s4)     # store preloaded SRAM0[29]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 132(s2)   # preload SRAM0[33]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 116(s2)   # store to SRAM0[29]
sw t3, 124(s2)   # store to SRAM0[31]

# Butterfly 8: (33,35)
lw t1, 140(s2)   # load SRAM0[35]
sw s8, 0(s4)     # store preloaded SRAM0[33]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 148(s2)   # preload SRAM0[37]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 132(s2)   # store to SRAM0[33]
sw t3, 140(s2)   # store to SRAM0[35]

# Butterfly 9: (37,39)
lw t1, 156(s2)   # load SRAM0[39]
sw s8, 0(s4)     # store preloaded SRAM0[37]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 164(s2)   # preload SRAM0[41]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 148(s2)   # store to SRAM0[37]
sw t3, 156(s2)   # store to SRAM0[39]

# Butterfly 10: (41,43)
lw t1, 172(s2)   # load SRAM0[43]
sw s8, 0(s4)     # store preloaded SRAM0[41]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 180(s2)   # preload SRAM0[45]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 164(s2)   # store to SRAM0[41]
sw t3, 172(s2)   # store to SRAM0[43]

# Butterfly 11: (45,47)
lw t1, 188(s2)   # load SRAM0[47]
sw s8, 0(s4)     # store preloaded SRAM0[45]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 196(s2)   # preload SRAM0[49]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 180(s2)   # store to SRAM0[45]
sw t3, 188(s2)   # store to SRAM0[47]

# Butterfly 12: (49,51)
lw t1, 204(s2)   # load SRAM0[51]
sw s8, 0(s4)     # store preloaded SRAM0[49]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 212(s2)   # preload SRAM0[53]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 196(s2)   # store to SRAM0[49]
sw t3, 204(s2)   # store to SRAM0[51]

# Butterfly 13: (53,55)
lw t1, 220(s2)   # load SRAM0[55]
sw s8, 0(s4)     # store preloaded SRAM0[53]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 228(s2)   # preload SRAM0[57]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 212(s2)   # store to SRAM0[53]
sw t3, 220(s2)   # store to SRAM0[55]

# Butterfly 14: (57,59)
lw t1, 236(s2)   # load SRAM0[59]
sw s8, 0(s4)     # store preloaded SRAM0[57]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 244(s2)   # preload SRAM0[61]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 228(s2)   # store to SRAM0[57]
sw t3, 236(s2)   # store to SRAM0[59]

# Butterfly 15: (61,63)
lw t1, 252(s2)   # load SRAM0[63]
sw s8, 0(s4)     # store preloaded SRAM0[61]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 0(s2)     # preload SRAM0[0]
lw t2, 4(s4)     
lw t3, 4(s5)
sw t2, 244(s2)   # store to SRAM0[61]
sw t3, 252(s2)   # store to SRAM0[63]

# Stage_2: s=2, d=4, g=4, b=8, twiddle W[m*8]

# Group m=0: twiddle W[0]

# Butterfly 0: (0,4)
lw t1, 16(s2)     # SRAM0[4]
sw s8, 0(s4)      # SRAM0[0]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 32(s2)     # preload SRAM0[8]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 0(s2)
sw t3, 16(s2)

# Butterfly 1: (8,12)
lw t1, 48(s2)     # SRAM0[12]
sw s8, 0(s4)      # SRAM0[8]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 64(s2)     # preload SRAM0[16]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 32(s2)
sw t3, 48(s2)

# Butterfly 2: (16,20)
lw t1, 80(s2)     # SRAM0[20]
sw s8, 0(s4)      # SRAM0[16]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 96(s2)     # preload SRAM0[24]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 64(s2)
sw t3, 80(s2)

# Butterfly 3: (24,28)
lw t1, 112(s2)    # SRAM0[28]
sw s8, 0(s4)      # SRAM0[24]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 128(s2)    # preload SRAM0[32]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 96(s2)
sw t3, 112(s2)

# Butterfly 4: (32,36)
lw t1, 144(s2)    # SRAM0[36]
sw s8, 0(s4)      # SRAM0[32]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 160(s2)    # preload SRAM0[40]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 128(s2)
sw t3, 144(s2)

# Butterfly 5: (40,44)
lw t1, 176(s2)    # SRAM0[44]
sw s8, 0(s4)      # SRAM0[40]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 192(s2)    # preload SRAM0[48]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 160(s2)
sw t3, 176(s2)

# Butterfly 6: (48,52)
lw t1, 208(s2)    # SRAM0[52]
sw s8, 0(s4)      # SRAM0[48]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 224(s2)    # preload SRAM0[56]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 192(s2)
sw t3, 208(s2)

# Butterfly 7: (56,60)
lw t1, 240(s2)    # SRAM0[60]
sw s8, 0(s4)      # SRAM0[56]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 4(s2)      # preload SRAM0[1] for next group (m=1)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 224(s2)
sw t3, 240(s2)

# Group m=1: twiddle W[8]

# Butterfly 0: (1,5)
lw t1, 20(s2)     # SRAM0[5]
sw s8, 0(s4)
sw t1, 0(s5)
sw t6, 0(s6)
lw s8, 36(s2)     # preload SRAM0[9]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 4(s2)
sw t3, 20(s2)

# Butterfly 1: (9,13)
lw t1, 52(s2)     # SRAM0[13]
sw s8, 0(s4)      # SRAM0[9]
sw t1, 0(s5)
sw t6, 0(s6)
lw s8, 68(s2)     # preload SRAM0[17]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 36(s2)
sw t3, 52(s2)

# Butterfly 2: (17,21)
lw t1, 84(s2)     # SRAM0[21]
sw s8, 0(s4)      # SRAM0[17]
sw t1, 0(s5)
sw t6, 0(s6)
lw s8, 200(s2)    # preload SRAM0[50]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 68(s2)
sw t3, 84(s2)

# Stage_3: s=3, d=8, g=8, b=4, twiddle W[m*4]

# Group m=0: twiddle W[0]

# Butterfly 3: (50,58)
lw t1, 232(s2)    # SRAM0[58]
sw s8, 0(s4)      # SRAM0[50]
sw t1, 0(s5)
sw t6, 0(s6)
lw s8, 12(s2)     # preload SRAM0[3] for next group (m=3)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 200(s2)
sw t3, 232(s2)

# Group m=3: twiddle W[12]

# Butterfly 0: (3,11)
lw t1, 44(s2)     # SRAM0[11]
sw s8, 0(s4)
sw t1, 0(s5)
sw a1, 0(s6)
lw s8, 76(s2)     # preload SRAM0[19]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 12(s2)
sw t3, 44(s2)

# Butterfly 1: (19,27)
lw t1, 108(s2)    # SRAM0[27]
sw s8, 0(s4)      # SRAM0[19]
sw t1, 0(s5)
sw a1, 0(s6)
lw s8, 140(s2)    # preload SRAM0[35]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 76(s2)
sw t3, 108(s2)

# Butterfly 2: (35,43)
lw t1, 172(s2)    # SRAM0[43]
sw s8, 0(s4)      # SRAM0[35]
sw t1, 0(s5)
sw a1, 0(s6)
lw s8, 204(s2)    # preload SRAM0[51]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 140(s2)
sw t3, 172(s2)

# Butterfly 3: (51,59)
lw t1, 236(s2)    # SRAM0[59]
sw s8, 0(s4)      # SRAM0[51]
sw t1, 0(s5)
sw a1, 0(s6)
lw s8, 16(s2)     # preload SRAM0[4] for next group (m=4)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 204(s2)
sw t3, 236(s2)

# Group m=4: twiddle W[16]

# Butterfly 0: (4,12)
lw t1, 48(s2)     # SRAM0[12]
sw s8, 0(s4)
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 80(s2)     # preload SRAM0[20]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 16(s2)
sw t3, 48(s2)

# Butterfly 1: (20,28)
lw t1, 112(s2)    # SRAM0[28]
sw s8, 0(s4)      # SRAM0[20]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 144(s2)    # preload SRAM0[36]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 80(s2)
sw t3, 112(s2)

# Butterfly 2: (36,44)
lw t1, 176(s2)    # SRAM0[44]
sw s8, 0(s4)      # SRAM0[36]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 208(s2)    # preload SRAM0[52]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 144(s2)
sw t3, 176(s2)

# Butterfly 3: (52,60)
lw t1, 240(s2)    # SRAM0[60]
sw s8, 0(s4)      # SRAM0[52]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 20(s2)     # preload SRAM0[5] for next group (m=5)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 208(s2)
sw t3, 240(s2)

# Group m=5: twiddle W[20]

# Butterfly 0: (5,13)
lw t1, 52(s2)     # SRAM0[13]
sw s8, 0(s4)
sw t1, 0(s5)
sw a5, 0(s6)
lw s8, 84(s2)     # preload SRAM0[21]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 20(s2)
sw t3, 52(s2)

# Butterfly 1: (21,29)
lw t1, 116(s2)    # SRAM0[29]
sw s8, 0(s4)      # SRAM0[21]
sw t1, 0(s5)
sw a5, 0(s6)
lw s8, 44(s2)     # preload SRAM0[11] for next group (m=11)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 84(s2)
sw t3, 116(s2)

# Stage_4: s=4, d=16, g=16, b=2, twiddle W[m*2]

# Butterfly 0: (11,27)
lw t1, 108(s2)    # SRAM0[27]
sw s8, 0(s4)
sw t1, 0(s5)
sw a6, 0(s6)
lw s8, 172(s2)    # preload SRAM0[43]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 44(s2)
sw t3, 108(s2)

# Butterfly 1: (43,59)
lw t1, 236(s2)    # SRAM0[59]
sw s8, 0(s4)      # SRAM0[43]
sw t1, 0(s5)
sw a6, 0(s6)
lw s8, 48(s2)     # preload SRAM0[12] for next group (m=12)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 172(s2)
sw t3, 236(s2)

# Group m=12: twiddle W[24]

# Butterfly 0: (12,28)
lw t1, 112(s2)    # SRAM0[28]
sw s8, 0(s4)
sw t1, 0(s5)
sw a7, 0(s6)
lw s8, 176(s2)    # preload SRAM0[44]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 48(s2)
sw t3, 112(s2)

# Butterfly 1: (44,60)
lw t1, 240(s2)    # SRAM0[60]
sw s8, 0(s4)      # SRAM0[44]
sw t1, 0(s5)
sw a7, 0(s6)
lw s8, 52(s2)     # preload SRAM0[13] for next group (m=13)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 176(s2)
sw t3, 240(s2)

# Group m=13: twiddle W[26]

# Butterfly 0: (13,29)
lw t1, 116(s2)    # SRAM0[29]
sw s8, 0(s4)
sw t1, 0(s5)
sw ra, 0(s6)
lw s8, 180(s2)    # preload SRAM0[45]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 52(s2)
sw t3, 116(s2)

# Butterfly 1: (45,61)
lw t1, 244(s2)    # SRAM0[61]
sw s8, 0(s4)      # SRAM0[45]
sw t1, 0(s5)
sw ra, 0(s6)
lw s8, 56(s2)     # preload SRAM0[14] for next group (m=14)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 180(s2)
sw t3, 244(s2)

# Group m=14: twiddle W[28]

# Butterfly 0: (14,30)
lw t1, 120(s2)    # SRAM0[30]
sw s8, 0(s4)
sw t1, 0(s5)
sw sp, 0(s6)
lw s8, 184(s2)    # preload SRAM0[46]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 56(s2)
sw t3, 120(s2)

# Butterfly 1: (46,62)
lw t1, 248(s2)    # SRAM0[62]
sw s8, 0(s4)      # SRAM0[46]
sw t1, 0(s5)
sw sp, 0(s6)
lw s8, 60(s2)     # preload SRAM0[15] for next group (m=15)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 184(s2)
sw t3, 248(s2)

# Group m=15: twiddle W[30]

# Butterfly 0: (15,31)
lw t1, 124(s2)    # SRAM0[31]
sw s8, 0(s4)
sw t1, 0(s5)
sw gp, 0(s6)
lw s8, 188(s2)    # preload SRAM0[47]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 60(s2)
sw t3, 124(s2)

# Butterfly 1: (47,63)
lw t1, 252(s2)    # SRAM0[63]
sw s8, 0(s4)      # SRAM0[47]
sw t1, 0(s5)
sw gp, 0(s6)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 188(s2)
sw t3, 252(s2)


#------------------------------------------------
# Stage_5: 
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
add x0, x0, x0
add x0, x0, x0
lw      t5,     0(s2)           # t5 = SRAM_0[0] (store for next m)
lw      t6,     128(s2)         # t6 = SRAM_0[32] (store for next m)

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
sw      t5,     0(s1)           # SRAM_I/O[0] = X (from m=0)
sw      t6,     128(s1)         # SRAM_I/O[32] = Y (from m=0)
lw      t5,     4(s2)           # t5 = SRAM_0[1] (store for next m)
lw      t6,     132(s2)         # t6 = SRAM_0[33] (store for next m)

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
sw      t5,     4(s1)           # SRAM_I/O[1] = X (from m=1)
sw      t6,     132(s1)         # SRAM_I/O[33] = Y (from m=1)
lw      t5,     8(s2)           # t5 = SRAM_0[2] (store for next m)
lw      t6,     136(s2)         # t6 = SRAM_0[34] (store for next m)

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
sw      t5,     8(s1)           # SRAM_I/O[2] = X (from m=2)
sw      t6,     136(s1)         # SRAM_I/O[34] = Y (from m=2)
lw      t5,     12(s2)          # t5 = SRAM_0[3] (store for next m)
lw      t6,     140(s2)         # t6 = SRAM_0[35] (store for next m)

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
sw      t5,     12(s1)          # SRAM_I/O[3] = X (from m=3)
sw      t6,     140(s1)         # SRAM_I/O[35] = Y (from m=3)
lw      t5,     16(s2)          # t5 = SRAM_0[4] (store for next m)
lw      t6,     144(s2)         # t6 = SRAM_0[36] (store for next m)

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
sw      t5,     16(s1)          # SRAM_I/O[4] = X (from m=4)
sw      t6,     144(s1)         # SRAM_I/O[36] = Y (from m=4)
lw      t5,     20(s2)          # t5 = SRAM_0[5] (store for next m)
lw      t6,     148(s2)         # t6 = SRAM_0[37] (store for next m)

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
sw      t5,     20(s1)          # SRAM_I/O[5] = X (from m=5)
sw      t6,     148(s1)         # SRAM_I/O[37] = Y (from m=5)
lw      t5,     24(s2)          # t5 = SRAM_0[6] (store for next m)
lw      t6,     152(s2)         # t6 = SRAM_0[38] (store for next m)

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
sw      t5,     24(s1)          # SRAM_I/O[6] = X (from m=6)
sw      t6,     152(s1)         # SRAM_I/O[38] = Y (from m=6)
lw      t5,     28(s2)          # t5 = SRAM_0[7] (store for next m)
lw      t6,     156(s2)         # t6 = SRAM_0[39] (store for next m)

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
sw      t5,     28(s1)          # SRAM_I/O[7] = X (from m=7)
sw      t6,     156(s1)         # SRAM_I/O[39] = Y (from m=7)
lw      t5,     32(s2)          # t5 = SRAM_0[8] (store for next m)
lw      t6,     160(s2)         # t6 = SRAM_0[40] (store for next m)

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
sw      t5,     32(s1)          # SRAM_I/O[8] = X (from m=8)
sw      t6,     160(s1)         # SRAM_I/O[40] = Y (from m=8)
lw      t5,     36(s2)          # t5 = SRAM_0[9] (store for next m)
lw      t6,     164(s2)         # t6 = SRAM_0[41] (store for next m)

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
sw      t5,     36(s1)          # SRAM_I/O[9] = X (from m=9)
sw      t6,     164(s1)         # SRAM_I/O[41] = Y (from m=9)
lw      t5,     40(s2)          # t5 = SRAM_0[10] (store for next m)
lw      t6,     168(s2)         # t6 = SRAM_0[42] (store for next m)

add x0, x0, x0
add x0, x0, x0
add x0, x0, x0

# Final store for m=31
sw      t5,     40(s1)         # SRAM_I/O[31] = X (from m=31)
sw      t6,     168(s1)         # SRAM_I/O[63] = Y (from m=31)

