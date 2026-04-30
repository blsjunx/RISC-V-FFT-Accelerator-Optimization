#core2

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
    add x0, x0, x0
start_fft:

#twiddle 선언
lw s7, 0(s3)  # w[0]

add x0, x0, x0
add x0, x0, x0

#------------------------------------------------
# Stage_0: SRAM_I/O --> SRAM_0 (Bit-Reversed) --> FFT_engine (Dpath_reg)
#------------------------------------------------
# Butterfly 22: SRAM_0[44], SRAM_0[45] with W[0]
lw t0, 52(s0)       
lw t1, 180(s0)   

add x0, x0, x0
lw t6, 32(s3)
lw a0, 40(s3)
lw a1, 48(s3)
add x0, x0, x0
add x0, x0, x0

sw t0, 176(s2)      # SRAM_0[44] = SRAM_IO[13] (preloaded)
sw t1, 180(s2)      # SRAM_0[45] = SRAM_IO[45] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 176(s2)      # t2 = SRAM_0[44]
lw t3, 180(s2)      # t3 = SRAM_0[45]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[44]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[45]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a4, 72(s3)
lw t0, 116(s0)      # Preload t0 = SRAM_IO[29] for Butterfly 23
lw t1, 244(s0)      # Preload t1 = SRAM_IO[61] for Butterfly 23
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 176(s2)      # SRAM_0[44] = X
sw t3, 180(s2)      # SRAM_0[45] = Y

# Butterfly 23: SRAM_0[46], SRAM_0[47] with W[0]
sw t0, 184(s2)      # SRAM_0[46] = SRAM_IO[29] (preloaded)
sw t1, 188(s2)      # SRAM_0[47] = SRAM_IO[61] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 184(s2)      # t2 = SRAM_0[46]
lw t3, 188(s2)      # t3 = SRAM_0[47]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[46]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[47]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a5, 80(s3)
lw t0, 12(s0)       # Preload t0 = SRAM_IO[3] for Butterfly 24
lw t1, 140(s0)      # Preload t1 = SRAM_IO[35] for Butterfly 24
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 184(s2)      # SRAM_0[46] = X
sw t3, 188(s2)      # SRAM_0[47] = Y

# Butterfly 24: SRAM_0[48], SRAM_0[49] with W[0]
sw t0, 192(s2)      # SRAM_0[48] = SRAM_IO[3] (preloaded)
sw t1, 196(s2)      # SRAM_0[49] = SRAM_IO[35] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 192(s2)      # t2 = SRAM_0[48]
lw t3, 196(s2)      # t3 = SRAM_0[49]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[48]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[49]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a6, 88(s3)
lw t0, 76(s0)       # Preload t0 = SRAM_IO[19] for Butterfly 25
lw t1, 204(s0)      # Preload t1 = SRAM_IO[51] for Butterfly 25
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 192(s2)      # SRAM_0[48] = X
sw t3, 196(s2)      # SRAM_0[49] = Y

# Butterfly 25: SRAM_0[50], SRAM_0[51] with W[0]
sw t0, 200(s2)      # SRAM_0[50] = SRAM_IO[19] (preloaded)
sw t1, 204(s2)      # SRAM_0[51] = SRAM_IO[51] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 200(s2)      # t2 = SRAM_0[50]
lw t3, 204(s2)      # t3 = SRAM_0[51]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[50]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[51]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a7, 96(s3)
lw t0, 44(s0)       # Preload t0 = SRAM_IO[11] for Butterfly 26
lw t1, 172(s0)      # Preload t1 = SRAM_IO[43] for Butterfly 26
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 200(s2)      # SRAM_0[50] = X
sw t3, 204(s2)      # SRAM_0[51] = Y

# Butterfly 26: SRAM_0[52], SRAM_0[53] with W[0]
sw t0, 208(s2)      # SRAM_0[52] = SRAM_IO[11] (preloaded)
sw t1, 212(s2)      # SRAM_0[53] = SRAM_IO[43] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 208(s2)      # t2 = SRAM_0[52]
lw t3, 212(s2)      # t3 = SRAM_0[53]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[52]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[53]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw ra, 104(s3)
lw t0, 108(s0)      # Preload t0 = SRAM_IO[27] for Butterfly 27
lw t1, 236(s0)      # Preload t1 = SRAM_IO[59] for Butterfly 27
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 208(s2)      # SRAM_0[52] = X
sw t3, 212(s2)      # SRAM_0[53] = Y

# Butterfly 27: SRAM_0[54], SRAM_0[55] with W[0]
sw t0, 216(s2)      # SRAM_0[54] = SRAM_IO[27] (preloaded)
sw t1, 220(s2)      # SRAM_0[55] = SRAM_IO[59] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 216(s2)      # t2 = SRAM_0[54]
lw t3, 220(s2)      # t3 = SRAM_0[55]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[54]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[55]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw sp, 112(s3)
lw t0, 28(s0)       # Preload t0 = SRAM_IO[7] for Butterfly 28
lw t1, 156(s0)      # Preload t1 = SRAM_IO[39] for Butterfly 28
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 216(s2)      # SRAM_0[54] = X
sw t3, 220(s2)      # SRAM_0[55] = Y

# Butterfly 28: SRAM_0[56], SRAM_0[57] with W[0]
sw t0, 224(s2)      # SRAM_0[56] = SRAM_IO[7] (preloaded)
sw t1, 228(s2)      # SRAM_0[57] = SRAM_IO[39] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 224(s2)      # t2 = SRAM_0[56]
lw t3, 228(s2)      # t3 = SRAM_0[57]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[56]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[57]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw gp, 120(s3)
lw t0, 92(s0)       # Preload t0 = SRAM_IO[23] for Butterfly 29
lw t1, 220(s0)      # Preload t1 = SRAM_IO[55] for Butterfly 29
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 224(s2)      # SRAM_0[56] = X
sw t3, 228(s2)      # SRAM_0[57] = Y

# Butterfly 29: SRAM_0[58], SRAM_0[59] with W[0]
sw t0, 232(s2)      # SRAM_0[58] = SRAM_IO[23] (preloaded)
sw t1, 236(s2)      # SRAM_0[59] = SRAM_IO[55] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 232(s2)      # t2 = SRAM_0[58]
lw t3, 236(s2)      # t3 = SRAM_0[59]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[58]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[59]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw s9, 8(s3)
lw t0, 60(s0)       # Preload t0 = SRAM_IO[15] for Butterfly 30
lw t1, 188(s0)      # Preload t1 = SRAM_IO[47] for Butterfly 30
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 232(s2)      # SRAM_0[58] = X
sw t3, 236(s2)      # SRAM_0[59] = Y

# Butterfly 30: SRAM_0[60], SRAM_0[61] with W[0]
sw t0, 240(s2)      # SRAM_0[60] = SRAM_IO[15] (preloaded)
sw t1, 244(s2)      # SRAM_0[61] = SRAM_IO[47] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 240(s2)      # t2 = SRAM_0[60]
lw t3, 244(s2)      # t3 = SRAM_0[61]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[60]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[61]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw s10, 16(s3)
lw t0, 124(s0)      # Preload t0 = SRAM_IO[31] for Butterfly 31
lw t1, 252(s0)      # Preload t1 = SRAM_IO[63] for Butterfly 31
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 240(s2)      # SRAM_0[60] = X
sw t3, 244(s2)      # SRAM_0[61] = Y

# Butterfly 31: SRAM_0[62], SRAM_0[63] with W[0]
sw t0, 248(s2)      # SRAM_0[62] = SRAM_IO[31] (preloaded)
sw t1, 252(s2)      # SRAM_0[63] = SRAM_IO[63] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 248(s2)      # t2 = SRAM_0[62]
lw t3, 252(s2)      # t3 = SRAM_0[63]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[62]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[63]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw s11, 24(s3)
lw a2, 56(s3)
lw a3, 64(s3)
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 248(s2)      # SRAM_0[62] = X
sw t3, 252(s2)      # SRAM_0[63] = Y

add x0, x0, x0
add x0, x0, x0
add x0, x0, x0
add x0, x0, x0

add x0, x0, x0

#------------------------------------------------
# Stage_1: SRAM_0 <--> FFT_engine (32 butterflies)
#------------------------------------------------
 # m=0 group: twiddle factor W[0], butterflies (0,2), (4,6), ..., (60,62)

# Butterfly 0: (0,2)
lw t0, 0(s2)     # load SRAM0[0]
lw t1, 8(s2)     # load SRAM0[2]
sw t0, 0(s4)     # store to datapath input 0
sw t1, 0(s5)     # store to datapath input 1
sw s7, 0(s6)     # store twiddle factor W[0]
lw s8, 16(s2)    # preload SRAM0[4] for next butterfly
lw t2, 4(s4)     # load result X from datapath
lw t3, 4(s5)     # load result Y from datapath
sw t2, 0(s2)     # store X to SRAM0[0]
sw t3, 8(s2)     # store Y to SRAM0[2]

# Butterfly 1: (4,6)
lw t1, 24(s2)    # load SRAM0[6]
sw s8, 0(s4)     # store preloaded SRAM0[4]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 32(s2)    # preload SRAM0[8]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 16(s2)    # store to SRAM0[4]
sw t3, 24(s2)    # store to SRAM0[6]

# Butterfly 2: (8,10)
lw t1, 40(s2)    # load SRAM0[10]
sw s8, 0(s4)     # store preloaded SRAM0[8]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 48(s2)    # preload SRAM0[12]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 32(s2)    # store to SRAM0[8]
sw t3, 40(s2)    # store to SRAM0[10]

# Butterfly 3: (12,14)
lw t1, 56(s2)    # load SRAM0[14]
sw s8, 0(s4)     # store preloaded SRAM0[12]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 64(s2)    # preload SRAM0[16]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 48(s2)    # store to SRAM0[12]
sw t3, 56(s2)    # store to SRAM0[14]

# Butterfly 4: (16,18)
lw t1, 72(s2)    # load SRAM0[18]
sw s8, 0(s4)     # store preloaded SRAM0[16]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 80(s2)    # preload SRAM0[20]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 64(s2)    # store to SRAM0[16]
sw t3, 72(s2)    # store to SRAM0[18]

# Butterfly 5: (20,22)
lw t1, 88(s2)    # load SRAM0[22]
sw s8, 0(s4)     # store preloaded SRAM0[20]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 96(s2)    # preload SRAM0[24]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 80(s2)    # store to SRAM0[20]
sw t3, 88(s2)    # store to SRAM0[22]

# Butterfly 6: (24,26)
lw t1, 104(s2)   # load SRAM0[26]
sw s8, 0(s4)     # store preloaded SRAM0[24]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 112(s2)   # preload SRAM0[28]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 96(s2)    # store to SRAM0[24]
sw t3, 104(s2)   # store to SRAM0[26]

# Butterfly 7: (28,30)
lw t1, 120(s2)   # load SRAM0[30]
sw s8, 0(s4)     # store preloaded SRAM0[28]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 128(s2)   # preload SRAM0[32]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 112(s2)   # store to SRAM0[28]
sw t3, 120(s2)   # store to SRAM0[30]

# Butterfly 8: (32,34)
lw t1, 136(s2)   # load SRAM0[34]
sw s8, 0(s4)     # store preloaded SRAM0[32]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 144(s2)   # preload SRAM0[36]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 128(s2)   # store to SRAM0[32]
sw t3, 136(s2)   # store to SRAM0[34]

# Butterfly 9: (36,38)
lw t1, 152(s2)   # load SRAM0[38]
sw s8, 0(s4)     # store preloaded SRAM0[36]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 160(s2)   # preload SRAM0[40]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 144(s2)   # store to SRAM0[36]
sw t3, 152(s2)   # store to SRAM0[38]

# Butterfly 10: (40,42)
lw t1, 168(s2)   # load SRAM0[42]
sw s8, 0(s4)     # store preloaded SRAM0[40]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 100(s2)    # preload SRAM0[25]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 160(s2)   # store to SRAM0[40]
sw t3, 168(s2)   # store to SRAM0[42]

# Stage_2: s=2, d=4, g=4, b=8, twiddle W[m*8]

# Group m=0: twiddle W[0]
# Butterfly 3: (25,29)
lw t1, 116(s2)    # SRAM0[29]
sw s8, 0(s4)      # SRAM0[25]
sw t1, 0(s5)
sw t6, 0(s6)
lw s8, 132(s2)    # preload SRAM0[33]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 100(s2)
sw t3, 116(s2)

# Butterfly 4: (33,37)
lw t1, 148(s2)    # SRAM0[37]
sw s8, 0(s4)      # SRAM0[33]
sw t1, 0(s5)
sw t6, 0(s6)
lw s8, 164(s2)    # preload SRAM0[41]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 132(s2)
sw t3, 148(s2)

# Butterfly 5: (41,45)
lw t1, 180(s2)    # SRAM0[45]
sw s8, 0(s4)      # SRAM0[41]
sw t1, 0(s5)
sw t6, 0(s6)
lw s8, 196(s2)    # preload SRAM0[49]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 164(s2)
sw t3, 180(s2)

# Butterfly 6: (49,53)
lw t1, 212(s2)    # SRAM0[53]
sw s8, 0(s4)      # SRAM0[49]
sw t1, 0(s5)
sw t6, 0(s6)
lw s8, 228(s2)    # preload SRAM0[57]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 196(s2)
sw t3, 212(s2)

# Butterfly 7: (57,61)
lw t1, 244(s2)    # SRAM0[61]
sw s8, 0(s4)      # SRAM0[57]
sw t1, 0(s5)
sw t6, 0(s6)
lw s8, 8(s2)      # preload SRAM0[2] for next group (m=2)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 228(s2)
sw t3, 244(s2)

# Group m=2: twiddle W[16]

# Butterfly 0: (2,6)
lw t1, 24(s2)     # SRAM0[6]
sw s8, 0(s4)
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 40(s2)     # preload SRAM0[10]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 8(s2)
sw t3, 24(s2)

# Butterfly 1: (10,14)
lw t1, 56(s2)     # SRAM0[14]
sw s8, 0(s4)      # SRAM0[10]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 72(s2)     # preload SRAM0[18]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 40(s2)
sw t3, 56(s2)

# Butterfly 2: (18,22)
lw t1, 88(s2)     # SRAM0[22]
sw s8, 0(s4)      # SRAM0[18]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 104(s2)    # preload SRAM0[26]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 72(s2)
sw t3, 88(s2)

# Butterfly 3: (26,30)
lw t1, 120(s2)    # SRAM0[30]
sw s8, 0(s4)      # SRAM0[26]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 136(s2)    # preload SRAM0[34]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 104(s2)
sw t3, 120(s2)

# Butterfly 4: (34,38)
lw t1, 152(s2)    # SRAM0[38]
sw s8, 0(s4)      # SRAM0[34]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 168(s2)    # preload SRAM0[42]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 136(s2)
sw t3, 152(s2)

# Butterfly 5: (42,46)
lw t1, 184(s2)    # SRAM0[46]
sw s8, 0(s4)      # SRAM0[42]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 148(s2)    # preload SRAM0[37]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 168(s2)
sw t3, 184(s2)

# Stage_3: s=3, d=8, g=8, b=4, twiddle W[m*4]

# Group m=0: twiddle W[0]

# Butterfly 2: (37,45)
lw t1, 180(s2)    # SRAM0[45]
sw s8, 0(s4)      # SRAM0[37]
sw t1, 0(s5)
sw a5, 0(s6)
lw s8, 212(s2)    # preload SRAM0[53]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 148(s2)
sw t3, 180(s2)

# Butterfly 3: (53,61)
lw t1, 244(s2)    # SRAM0[61]
sw s8, 0(s4)      # SRAM0[53]
sw t1, 0(s5)
sw a5, 0(s6)
lw s8, 24(s2)     # preload SRAM0[6] for next group (m=6)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 212(s2)
sw t3, 244(s2)

# Group m=6: twiddle W[24]

# Butterfly 0: (6,14)
lw t1, 56(s2)     # SRAM0[14]
sw s8, 0(s4)
sw t1, 0(s5)
sw a7, 0(s6)
lw s8, 88(s2)     # preload SRAM0[22]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 24(s2)
sw t3, 56(s2)

# Butterfly 1: (22,30)
lw t1, 120(s2)    # SRAM0[30]
sw s8, 0(s4)      # SRAM0[22]
sw t1, 0(s5)
sw a7, 0(s6)
lw s8, 152(s2)    # preload SRAM0[38]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 88(s2)
sw t3, 120(s2)

# Butterfly 2: (38,46)
lw t1, 184(s2)    # SRAM0[46]
sw s8, 0(s4)      # SRAM0[38]
sw t1, 0(s5)
sw a7, 0(s6)
lw s8, 216(s2)    # preload SRAM0[54]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 152(s2)
sw t3, 184(s2)

# Butterfly 3: (54,62)
lw t1, 248(s2)    # SRAM0[62]
sw s8, 0(s4)      # SRAM0[54]
sw t1, 0(s5)
sw a7, 0(s6)
lw s8, 28(s2)     # preload SRAM0[7] for next group (m=7)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 216(s2)
sw t3, 248(s2)

# Group m=7: twiddle W[28]

# Butterfly 0: (7,15)
lw t1, 60(s2)     # SRAM0[15]
sw s8, 0(s4)
sw t1, 0(s5)
sw sp, 0(s6)
lw s8, 92(s2)     # preload SRAM0[23]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 28(s2)
sw t3, 60(s2)

# Butterfly 1: (23,31)
lw t1, 124(s2)    # SRAM0[31]
sw s8, 0(s4)      # SRAM0[23]
sw t1, 0(s5)
sw sp, 0(s6)
lw s8, 156(s2)    # preload SRAM0[39]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 92(s2)
sw t3, 124(s2)

# Butterfly 2: (39,47)
lw t1, 188(s2)    # SRAM0[47]
sw s8, 0(s4)      # SRAM0[39]
sw t1, 0(s5)
sw sp, 0(s6)
lw s8, 220(s2)    # preload SRAM0[55]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 156(s2)
sw t3, 188(s2)

# Butterfly 3: (55,63)
lw t1, 252(s2)    # SRAM0[63]
sw s8, 0(s4)      # SRAM0[55]
sw t1, 0(s5)
sw sp, 0(s6)
lw s8, 0(s2)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 220(s2)
sw t3, 252(s2)

# Stage_4: s=4, d=16, g=16, b=2, twiddle W[m*2]

# Butterfly 0: (0,16)
lw t1, 64(s2)     # SRAM0[16]
sw s8, 0(s4)
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 128(s2)    # preload SRAM0[32]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 0(s2)
sw t3, 64(s2)

# Butterfly 1: (32,48)
lw t1, 192(s2)    # SRAM0[48]
sw s8, 0(s4)      # SRAM0[32]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 4(s2)      # preload SRAM0[1] for next group (m=1)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 128(s2)
sw t3, 192(s2)

# Group m=1: twiddle W[2]

# Butterfly 0: (1,17)
lw t1, 68(s2)     # SRAM0[17]
sw s8, 0(s4)
sw t1, 0(s5)
sw s9, 0(s6)
lw s8, 132(s2)    # preload SRAM0[33]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 4(s2)
sw t3, 68(s2)

# Butterfly 1: (33,49)
lw t1, 196(s2)    # SRAM0[49]
sw s8, 0(s4)      # SRAM0[33]
sw t1, 0(s5)
sw s9, 0(s6)
lw s8, 8(s2)      # preload SRAM0[2] for next group (m=2)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 132(s2)
sw t3, 196(s2)

# Group m=2: twiddle W[4]

# Butterfly 0: (2,18)
lw t1, 72(s2)     # SRAM0[18]
sw s8, 0(s4)
sw t1, 0(s5)
sw s10, 0(s6)
lw s8, 136(s2)    # preload SRAM0[34]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 8(s2)
sw t3, 72(s2)

# Butterfly 1: (34,50)
lw t1, 200(s2)    # SRAM0[50]
sw s8, 0(s4)      # SRAM0[34]
sw t1, 0(s5)
sw s10, 0(s6)
lw s8, 12(s2)     # preload SRAM0[3] for next group (m=3)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 136(s2)
sw t3, 200(s2)

# Group m=3: twiddle W[6]

# Butterfly 0: (3,19)
lw t1, 76(s2)     # SRAM0[19]
sw s8, 0(s4)
sw t1, 0(s5)
sw s11, 0(s6)
lw s8, 140(s2)    # preload SRAM0[35]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 12(s2)
sw t3, 76(s2)

# Butterfly 1: (35,51)
lw t1, 204(s2)    # SRAM0[51]
sw s8, 0(s4)      # SRAM0[35]
sw t1, 0(s5)
sw s11, 0(s6)
lw s8, 16(s2)     # preload SRAM0[4] for next group (m=4)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 140(s2)
sw t3, 204(s2)

# Group m=4: twiddle W[8]

# Butterfly 0: (4,20)
lw t1, 80(s2)     # SRAM0[20]
sw s8, 0(s4)
sw t1, 0(s5)
sw t6, 0(s6)
lw s8, 144(s2)    # preload SRAM0[36]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 16(s2)
sw t3, 80(s2)

# Butterfly 1: (36,52)
lw t1, 208(s2)    # SRAM0[52]
sw s8, 0(s4)      # SRAM0[36]
sw t1, 0(s5)
sw t6, 0(s6)
lw s8, 20(s2)     # preload SRAM0[5] for next group (m=5)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 144(s2)
sw t3, 208(s2)

# Group m=5: twiddle W[10]

# Butterfly 0: (5,21)
lw t1, 84(s2)     # SRAM0[21]
sw s8, 0(s4)
sw t1, 0(s5)
sw a0, 0(s6)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 20(s2)
sw t3, 84(s2)

add x0, x0, x0
add x0, x0, x0


#------------------------------------------------
# Stage_5: 
#------------------------------------------------

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
add x0, x0, x0
add x0, x0, x0
lw      t5,     44(s2)          # t5 = SRAM_0[11] (store for next m)
lw      t6,     172(s2)         # t6 = SRAM_0[43] (store for next m)

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
sw      t5,     44(s1)          # SRAM_I/O[11] = X (from m=11)
sw      t6,     172(s1)         # SRAM_I/O[43] = Y (from m=11)
lw      t5,     48(s2)          # t5 = SRAM_0[12] (store for next m)
lw      t6,     176(s2)         # t6 = SRAM_0[44] (store for next m)

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
sw      t5,     48(s1)          # SRAM_I/O[12] = X (from m=12)
sw      t6,     176(s1)         # SRAM_I/O[44] = Y (from m=12)
lw      t5,     52(s2)          # t5 = SRAM_0[13] (store for next m)
lw      t6,     180(s2)         # t6 = SRAM_0[45] (store for next m)

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
sw      t5,     52(s1)          # SRAM_I/O[13] = X (from m=13)
sw      t6,     180(s1)         # SRAM_I/O[45] = Y (from m=13)
lw      t5,     56(s2)          # t5 = SRAM_0[14] (store for next m)
lw      t6,     184(s2)         # t6 = SRAM_0[46] (store for next m)

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
sw      t5,     56(s1)          # SRAM_I/O[14] = X (from m=14)
sw      t6,     184(s1)         # SRAM_I/O[46] = Y (from m=14)
lw      t5,     60(s2)          # t5 = SRAM_0[15] (store for next m)
lw      t6,     188(s2)         # t6 = SRAM_0[47] (store for next m)

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
sw      t5,     60(s1)          # SRAM_I/O[15] = X (from m=15)
sw      t6,     188(s1)         # SRAM_I/O[47] = Y (from m=15)
lw      t5,     64(s2)          # t5 = SRAM_0[16] (store for next m)
lw      t6,     192(s2)         # t6 = SRAM_0[48] (store for next m)

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
sw      t5,     64(s1)          # SRAM_I/O[16] = X (from m=16)
sw      t6,     192(s1)         # SRAM_I/O[48] = Y (from m=16)
lw      t5,     68(s2)          # t5 = SRAM_0[17] (store for next m)
lw      t6,     196(s2)         # t6 = SRAM_0[49] (store for next m)

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
sw      t5,     68(s1)          # SRAM_I/O[17] = X (from m=17)
sw      t6,     196(s1)         # SRAM_I/O[49] = Y (from m=17)
lw      t5,     72(s2)          # t5 = SRAM_0[18] (store for next m)
lw      t6,     200(s2)         # t6 = SRAM_0[50] (store for next m)

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
sw      t5,     72(s1)          # SRAM_I/O[18] = X (from m=18)
sw      t6,     200(s1)         # SRAM_I/O[50] = Y (from m=18)
lw      t5,     76(s2)          # t5 = SRAM_0[19] (store for next m)
lw      t6,     204(s2)         # t6 = SRAM_0[51] (store for next m)

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
sw      t5,     76(s1)          # SRAM_I/O[19] = X (from m=19)
sw      t6,     204(s1)         # SRAM_I/O[51] = Y (from m=19)
lw      t5,     80(s2)          # t5 = SRAM_0[20] (store for next m)
lw      t6,     208(s2)         # t6 = SRAM_0[52] (store for next m)

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
sw      t5,     80(s1)          # SRAM_I/O[20] = X (from m=20)
sw      t6,     208(s1)         # SRAM_I/O[52] = Y (from m=20)
lw      t5,     84(s2)          # t5 = SRAM_0[21] (store for next m)
lw      t6,     212(s2)         # t6 = SRAM_0[53] (store for next m)
sw      t5,     84(s1)          # SRAM_I/O[21] = X (from m=21)
sw      t6,     212(s1)         # SRAM_I/O[53] = Y (from m=21)


#set1 start
addi s0, s0, 256
addi s1, s1, 256

#twiddle 선언
lw s7, 0(s3)  # w[0]

add x0, x0, x0
add x0, x0, x0

#------------------------------------------------
# Stage_0: SRAM_I/O --> SRAM_0 (Bit-Reversed) --> FFT_engine (Dpath_reg)
#------------------------------------------------
# Butterfly 22: SRAM_0[44], SRAM_0[45] with W[0]
lw t0, 52(s0)       
lw t1, 180(s0)   

add x0, x0, x0
lw t6, 32(s3)
lw a0, 40(s3)
lw a1, 48(s3)
add x0, x0, x0
add x0, x0, x0

sw t0, 176(s2)      # SRAM_0[44] = SRAM_IO[13] (preloaded)
sw t1, 180(s2)      # SRAM_0[45] = SRAM_IO[45] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 176(s2)      # t2 = SRAM_0[44]
lw t3, 180(s2)      # t3 = SRAM_0[45]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[44]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[45]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a4, 72(s3)
lw t0, 116(s0)      # Preload t0 = SRAM_IO[29] for Butterfly 23
lw t1, 244(s0)      # Preload t1 = SRAM_IO[61] for Butterfly 23
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 176(s2)      # SRAM_0[44] = X
sw t3, 180(s2)      # SRAM_0[45] = Y

# Butterfly 23: SRAM_0[46], SRAM_0[47] with W[0]
sw t0, 184(s2)      # SRAM_0[46] = SRAM_IO[29] (preloaded)
sw t1, 188(s2)      # SRAM_0[47] = SRAM_IO[61] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 184(s2)      # t2 = SRAM_0[46]
lw t3, 188(s2)      # t3 = SRAM_0[47]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[46]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[47]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a5, 80(s3)
lw t0, 12(s0)       # Preload t0 = SRAM_IO[3] for Butterfly 24
lw t1, 140(s0)      # Preload t1 = SRAM_IO[35] for Butterfly 24
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 184(s2)      # SRAM_0[46] = X
sw t3, 188(s2)      # SRAM_0[47] = Y

# Butterfly 24: SRAM_0[48], SRAM_0[49] with W[0]
sw t0, 192(s2)      # SRAM_0[48] = SRAM_IO[3] (preloaded)
sw t1, 196(s2)      # SRAM_0[49] = SRAM_IO[35] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 192(s2)      # t2 = SRAM_0[48]
lw t3, 196(s2)      # t3 = SRAM_0[49]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[48]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[49]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a6, 88(s3)
lw t0, 76(s0)       # Preload t0 = SRAM_IO[19] for Butterfly 25
lw t1, 204(s0)      # Preload t1 = SRAM_IO[51] for Butterfly 25
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 192(s2)      # SRAM_0[48] = X
sw t3, 196(s2)      # SRAM_0[49] = Y

# Butterfly 25: SRAM_0[50], SRAM_0[51] with W[0]
sw t0, 200(s2)      # SRAM_0[50] = SRAM_IO[19] (preloaded)
sw t1, 204(s2)      # SRAM_0[51] = SRAM_IO[51] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 200(s2)      # t2 = SRAM_0[50]
lw t3, 204(s2)      # t3 = SRAM_0[51]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[50]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[51]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a7, 96(s3)
lw t0, 44(s0)       # Preload t0 = SRAM_IO[11] for Butterfly 26
lw t1, 172(s0)      # Preload t1 = SRAM_IO[43] for Butterfly 26
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 200(s2)      # SRAM_0[50] = X
sw t3, 204(s2)      # SRAM_0[51] = Y

# Butterfly 26: SRAM_0[52], SRAM_0[53] with W[0]
sw t0, 208(s2)      # SRAM_0[52] = SRAM_IO[11] (preloaded)
sw t1, 212(s2)      # SRAM_0[53] = SRAM_IO[43] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 208(s2)      # t2 = SRAM_0[52]
lw t3, 212(s2)      # t3 = SRAM_0[53]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[52]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[53]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw ra, 104(s3)
lw t0, 108(s0)      # Preload t0 = SRAM_IO[27] for Butterfly 27
lw t1, 236(s0)      # Preload t1 = SRAM_IO[59] for Butterfly 27
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 208(s2)      # SRAM_0[52] = X
sw t3, 212(s2)      # SRAM_0[53] = Y

# Butterfly 27: SRAM_0[54], SRAM_0[55] with W[0]
sw t0, 216(s2)      # SRAM_0[54] = SRAM_IO[27] (preloaded)
sw t1, 220(s2)      # SRAM_0[55] = SRAM_IO[59] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 216(s2)      # t2 = SRAM_0[54]
lw t3, 220(s2)      # t3 = SRAM_0[55]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[54]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[55]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw sp, 112(s3)
lw t0, 28(s0)       # Preload t0 = SRAM_IO[7] for Butterfly 28
lw t1, 156(s0)      # Preload t1 = SRAM_IO[39] for Butterfly 28
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 216(s2)      # SRAM_0[54] = X
sw t3, 220(s2)      # SRAM_0[55] = Y

# Butterfly 28: SRAM_0[56], SRAM_0[57] with W[0]
sw t0, 224(s2)      # SRAM_0[56] = SRAM_IO[7] (preloaded)
sw t1, 228(s2)      # SRAM_0[57] = SRAM_IO[39] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 224(s2)      # t2 = SRAM_0[56]
lw t3, 228(s2)      # t3 = SRAM_0[57]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[56]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[57]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw gp, 120(s3)
lw t0, 92(s0)       # Preload t0 = SRAM_IO[23] for Butterfly 29
lw t1, 220(s0)      # Preload t1 = SRAM_IO[55] for Butterfly 29
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 224(s2)      # SRAM_0[56] = X
sw t3, 228(s2)      # SRAM_0[57] = Y

# Butterfly 29: SRAM_0[58], SRAM_0[59] with W[0]
sw t0, 232(s2)      # SRAM_0[58] = SRAM_IO[23] (preloaded)
sw t1, 236(s2)      # SRAM_0[59] = SRAM_IO[55] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 232(s2)      # t2 = SRAM_0[58]
lw t3, 236(s2)      # t3 = SRAM_0[59]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[58]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[59]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw s9, 8(s3)
lw t0, 60(s0)       # Preload t0 = SRAM_IO[15] for Butterfly 30
lw t1, 188(s0)      # Preload t1 = SRAM_IO[47] for Butterfly 30
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 232(s2)      # SRAM_0[58] = X
sw t3, 236(s2)      # SRAM_0[59] = Y

# Butterfly 30: SRAM_0[60], SRAM_0[61] with W[0]
sw t0, 240(s2)      # SRAM_0[60] = SRAM_IO[15] (preloaded)
sw t1, 244(s2)      # SRAM_0[61] = SRAM_IO[47] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 240(s2)      # t2 = SRAM_0[60]
lw t3, 244(s2)      # t3 = SRAM_0[61]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[60]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[61]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw s10, 16(s3)
lw t0, 124(s0)      # Preload t0 = SRAM_IO[31] for Butterfly 31
lw t1, 252(s0)      # Preload t1 = SRAM_IO[63] for Butterfly 31
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 240(s2)      # SRAM_0[60] = X
sw t3, 244(s2)      # SRAM_0[61] = Y

# Butterfly 31: SRAM_0[62], SRAM_0[63] with W[0]
sw t0, 248(s2)      # SRAM_0[62] = SRAM_IO[31] (preloaded)
sw t1, 252(s2)      # SRAM_0[63] = SRAM_IO[63] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 248(s2)      # t2 = SRAM_0[62]
lw t3, 252(s2)      # t3 = SRAM_0[63]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[62]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[63]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw s11, 24(s3)
lw a2, 56(s3)
lw a3, 64(s3)
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 248(s2)      # SRAM_0[62] = X
sw t3, 252(s2)      # SRAM_0[63] = Y

add x0, x0, x0
add x0, x0, x0
add x0, x0, x0
add x0, x0, x0

add x0, x0, x0

#------------------------------------------------
# Stage_1: SRAM_0 <--> FFT_engine (32 butterflies)
#------------------------------------------------
 # m=0 group: twiddle factor W[0], butterflies (0,2), (4,6), ..., (60,62)

# Butterfly 0: (0,2)
lw t0, 0(s2)     # load SRAM0[0]
lw t1, 8(s2)     # load SRAM0[2]
sw t0, 0(s4)     # store to datapath input 0
sw t1, 0(s5)     # store to datapath input 1
sw s7, 0(s6)     # store twiddle factor W[0]
lw s8, 16(s2)    # preload SRAM0[4] for next butterfly
lw t2, 4(s4)     # load result X from datapath
lw t3, 4(s5)     # load result Y from datapath
sw t2, 0(s2)     # store X to SRAM0[0]
sw t3, 8(s2)     # store Y to SRAM0[2]

# Butterfly 1: (4,6)
lw t1, 24(s2)    # load SRAM0[6]
sw s8, 0(s4)     # store preloaded SRAM0[4]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 32(s2)    # preload SRAM0[8]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 16(s2)    # store to SRAM0[4]
sw t3, 24(s2)    # store to SRAM0[6]

# Butterfly 2: (8,10)
lw t1, 40(s2)    # load SRAM0[10]
sw s8, 0(s4)     # store preloaded SRAM0[8]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 48(s2)    # preload SRAM0[12]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 32(s2)    # store to SRAM0[8]
sw t3, 40(s2)    # store to SRAM0[10]

# Butterfly 3: (12,14)
lw t1, 56(s2)    # load SRAM0[14]
sw s8, 0(s4)     # store preloaded SRAM0[12]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 64(s2)    # preload SRAM0[16]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 48(s2)    # store to SRAM0[12]
sw t3, 56(s2)    # store to SRAM0[14]

# Butterfly 4: (16,18)
lw t1, 72(s2)    # load SRAM0[18]
sw s8, 0(s4)     # store preloaded SRAM0[16]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 80(s2)    # preload SRAM0[20]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 64(s2)    # store to SRAM0[16]
sw t3, 72(s2)    # store to SRAM0[18]

# Butterfly 5: (20,22)
lw t1, 88(s2)    # load SRAM0[22]
sw s8, 0(s4)     # store preloaded SRAM0[20]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 96(s2)    # preload SRAM0[24]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 80(s2)    # store to SRAM0[20]
sw t3, 88(s2)    # store to SRAM0[22]

# Butterfly 6: (24,26)
lw t1, 104(s2)   # load SRAM0[26]
sw s8, 0(s4)     # store preloaded SRAM0[24]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 112(s2)   # preload SRAM0[28]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 96(s2)    # store to SRAM0[24]
sw t3, 104(s2)   # store to SRAM0[26]

# Butterfly 7: (28,30)
lw t1, 120(s2)   # load SRAM0[30]
sw s8, 0(s4)     # store preloaded SRAM0[28]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 128(s2)   # preload SRAM0[32]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 112(s2)   # store to SRAM0[28]
sw t3, 120(s2)   # store to SRAM0[30]

# Butterfly 8: (32,34)
lw t1, 136(s2)   # load SRAM0[34]
sw s8, 0(s4)     # store preloaded SRAM0[32]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 144(s2)   # preload SRAM0[36]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 128(s2)   # store to SRAM0[32]
sw t3, 136(s2)   # store to SRAM0[34]

# Butterfly 9: (36,38)
lw t1, 152(s2)   # load SRAM0[38]
sw s8, 0(s4)     # store preloaded SRAM0[36]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 160(s2)   # preload SRAM0[40]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 144(s2)   # store to SRAM0[36]
sw t3, 152(s2)   # store to SRAM0[38]

# Butterfly 10: (40,42)
lw t1, 168(s2)   # load SRAM0[42]
sw s8, 0(s4)     # store preloaded SRAM0[40]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 100(s2)    # preload SRAM0[25]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 160(s2)   # store to SRAM0[40]
sw t3, 168(s2)   # store to SRAM0[42]

# Stage_2: s=2, d=4, g=4, b=8, twiddle W[m*8]

# Group m=0: twiddle W[0]
# Butterfly 3: (25,29)
lw t1, 116(s2)    # SRAM0[29]
sw s8, 0(s4)      # SRAM0[25]
sw t1, 0(s5)
sw t6, 0(s6)
lw s8, 132(s2)    # preload SRAM0[33]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 100(s2)
sw t3, 116(s2)

# Butterfly 4: (33,37)
lw t1, 148(s2)    # SRAM0[37]
sw s8, 0(s4)      # SRAM0[33]
sw t1, 0(s5)
sw t6, 0(s6)
lw s8, 164(s2)    # preload SRAM0[41]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 132(s2)
sw t3, 148(s2)

# Butterfly 5: (41,45)
lw t1, 180(s2)    # SRAM0[45]
sw s8, 0(s4)      # SRAM0[41]
sw t1, 0(s5)
sw t6, 0(s6)
lw s8, 196(s2)    # preload SRAM0[49]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 164(s2)
sw t3, 180(s2)

# Butterfly 6: (49,53)
lw t1, 212(s2)    # SRAM0[53]
sw s8, 0(s4)      # SRAM0[49]
sw t1, 0(s5)
sw t6, 0(s6)
lw s8, 228(s2)    # preload SRAM0[57]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 196(s2)
sw t3, 212(s2)

# Butterfly 7: (57,61)
lw t1, 244(s2)    # SRAM0[61]
sw s8, 0(s4)      # SRAM0[57]
sw t1, 0(s5)
sw t6, 0(s6)
lw s8, 8(s2)      # preload SRAM0[2] for next group (m=2)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 228(s2)
sw t3, 244(s2)

# Group m=2: twiddle W[16]

# Butterfly 0: (2,6)
lw t1, 24(s2)     # SRAM0[6]
sw s8, 0(s4)
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 40(s2)     # preload SRAM0[10]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 8(s2)
sw t3, 24(s2)

# Butterfly 1: (10,14)
lw t1, 56(s2)     # SRAM0[14]
sw s8, 0(s4)      # SRAM0[10]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 72(s2)     # preload SRAM0[18]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 40(s2)
sw t3, 56(s2)

# Butterfly 2: (18,22)
lw t1, 88(s2)     # SRAM0[22]
sw s8, 0(s4)      # SRAM0[18]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 104(s2)    # preload SRAM0[26]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 72(s2)
sw t3, 88(s2)

# Butterfly 3: (26,30)
lw t1, 120(s2)    # SRAM0[30]
sw s8, 0(s4)      # SRAM0[26]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 136(s2)    # preload SRAM0[34]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 104(s2)
sw t3, 120(s2)

# Butterfly 4: (34,38)
lw t1, 152(s2)    # SRAM0[38]
sw s8, 0(s4)      # SRAM0[34]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 168(s2)    # preload SRAM0[42]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 136(s2)
sw t3, 152(s2)

# Butterfly 5: (42,46)
lw t1, 184(s2)    # SRAM0[46]
sw s8, 0(s4)      # SRAM0[42]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 148(s2)    # preload SRAM0[37]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 168(s2)
sw t3, 184(s2)

# Stage_3: s=3, d=8, g=8, b=4, twiddle W[m*4]

# Group m=0: twiddle W[0]

# Butterfly 2: (37,45)
lw t1, 180(s2)    # SRAM0[45]
sw s8, 0(s4)      # SRAM0[37]
sw t1, 0(s5)
sw a5, 0(s6)
lw s8, 212(s2)    # preload SRAM0[53]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 148(s2)
sw t3, 180(s2)

# Butterfly 3: (53,61)
lw t1, 244(s2)    # SRAM0[61]
sw s8, 0(s4)      # SRAM0[53]
sw t1, 0(s5)
sw a5, 0(s6)
lw s8, 24(s2)     # preload SRAM0[6] for next group (m=6)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 212(s2)
sw t3, 244(s2)

# Group m=6: twiddle W[24]

# Butterfly 0: (6,14)
lw t1, 56(s2)     # SRAM0[14]
sw s8, 0(s4)
sw t1, 0(s5)
sw a7, 0(s6)
lw s8, 88(s2)     # preload SRAM0[22]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 24(s2)
sw t3, 56(s2)

# Butterfly 1: (22,30)
lw t1, 120(s2)    # SRAM0[30]
sw s8, 0(s4)      # SRAM0[22]
sw t1, 0(s5)
sw a7, 0(s6)
lw s8, 152(s2)    # preload SRAM0[38]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 88(s2)
sw t3, 120(s2)

# Butterfly 2: (38,46)
lw t1, 184(s2)    # SRAM0[46]
sw s8, 0(s4)      # SRAM0[38]
sw t1, 0(s5)
sw a7, 0(s6)
lw s8, 216(s2)    # preload SRAM0[54]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 152(s2)
sw t3, 184(s2)

# Butterfly 3: (54,62)
lw t1, 248(s2)    # SRAM0[62]
sw s8, 0(s4)      # SRAM0[54]
sw t1, 0(s5)
sw a7, 0(s6)
lw s8, 28(s2)     # preload SRAM0[7] for next group (m=7)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 216(s2)
sw t3, 248(s2)

# Group m=7: twiddle W[28]

# Butterfly 0: (7,15)
lw t1, 60(s2)     # SRAM0[15]
sw s8, 0(s4)
sw t1, 0(s5)
sw sp, 0(s6)
lw s8, 92(s2)     # preload SRAM0[23]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 28(s2)
sw t3, 60(s2)

# Butterfly 1: (23,31)
lw t1, 124(s2)    # SRAM0[31]
sw s8, 0(s4)      # SRAM0[23]
sw t1, 0(s5)
sw sp, 0(s6)
lw s8, 156(s2)    # preload SRAM0[39]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 92(s2)
sw t3, 124(s2)

# Butterfly 2: (39,47)
lw t1, 188(s2)    # SRAM0[47]
sw s8, 0(s4)      # SRAM0[39]
sw t1, 0(s5)
sw sp, 0(s6)
lw s8, 220(s2)    # preload SRAM0[55]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 156(s2)
sw t3, 188(s2)

# Butterfly 3: (55,63)
lw t1, 252(s2)    # SRAM0[63]
sw s8, 0(s4)      # SRAM0[55]
sw t1, 0(s5)
sw sp, 0(s6)
lw s8, 0(s2)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 220(s2)
sw t3, 252(s2)

# Stage_4: s=4, d=16, g=16, b=2, twiddle W[m*2]

# Butterfly 0: (0,16)
lw t1, 64(s2)     # SRAM0[16]
sw s8, 0(s4)
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 128(s2)    # preload SRAM0[32]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 0(s2)
sw t3, 64(s2)

# Butterfly 1: (32,48)
lw t1, 192(s2)    # SRAM0[48]
sw s8, 0(s4)      # SRAM0[32]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 4(s2)      # preload SRAM0[1] for next group (m=1)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 128(s2)
sw t3, 192(s2)

# Group m=1: twiddle W[2]

# Butterfly 0: (1,17)
lw t1, 68(s2)     # SRAM0[17]
sw s8, 0(s4)
sw t1, 0(s5)
sw s9, 0(s6)
lw s8, 132(s2)    # preload SRAM0[33]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 4(s2)
sw t3, 68(s2)

# Butterfly 1: (33,49)
lw t1, 196(s2)    # SRAM0[49]
sw s8, 0(s4)      # SRAM0[33]
sw t1, 0(s5)
sw s9, 0(s6)
lw s8, 8(s2)      # preload SRAM0[2] for next group (m=2)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 132(s2)
sw t3, 196(s2)

# Group m=2: twiddle W[4]

# Butterfly 0: (2,18)
lw t1, 72(s2)     # SRAM0[18]
sw s8, 0(s4)
sw t1, 0(s5)
sw s10, 0(s6)
lw s8, 136(s2)    # preload SRAM0[34]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 8(s2)
sw t3, 72(s2)

# Butterfly 1: (34,50)
lw t1, 200(s2)    # SRAM0[50]
sw s8, 0(s4)      # SRAM0[34]
sw t1, 0(s5)
sw s10, 0(s6)
lw s8, 12(s2)     # preload SRAM0[3] for next group (m=3)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 136(s2)
sw t3, 200(s2)

# Group m=3: twiddle W[6]

# Butterfly 0: (3,19)
lw t1, 76(s2)     # SRAM0[19]
sw s8, 0(s4)
sw t1, 0(s5)
sw s11, 0(s6)
lw s8, 140(s2)    # preload SRAM0[35]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 12(s2)
sw t3, 76(s2)

# Butterfly 1: (35,51)
lw t1, 204(s2)    # SRAM0[51]
sw s8, 0(s4)      # SRAM0[35]
sw t1, 0(s5)
sw s11, 0(s6)
lw s8, 16(s2)     # preload SRAM0[4] for next group (m=4)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 140(s2)
sw t3, 204(s2)

# Group m=4: twiddle W[8]

# Butterfly 0: (4,20)
lw t1, 80(s2)     # SRAM0[20]
sw s8, 0(s4)
sw t1, 0(s5)
sw t6, 0(s6)
lw s8, 144(s2)    # preload SRAM0[36]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 16(s2)
sw t3, 80(s2)

# Butterfly 1: (36,52)
lw t1, 208(s2)    # SRAM0[52]
sw s8, 0(s4)      # SRAM0[36]
sw t1, 0(s5)
sw t6, 0(s6)
lw s8, 20(s2)     # preload SRAM0[5] for next group (m=5)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 144(s2)
sw t3, 208(s2)

# Group m=5: twiddle W[10]

# Butterfly 0: (5,21)
lw t1, 84(s2)     # SRAM0[21]
sw s8, 0(s4)
sw t1, 0(s5)
sw a0, 0(s6)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 20(s2)
sw t3, 84(s2)

add x0, x0, x0
add x0, x0, x0


#------------------------------------------------
# Stage_5: 
#------------------------------------------------

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
add x0, x0, x0
add x0, x0, x0
lw      t5,     44(s2)          # t5 = SRAM_0[11] (store for next m)
lw      t6,     172(s2)         # t6 = SRAM_0[43] (store for next m)

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
sw      t5,     44(s1)          # SRAM_I/O[11] = X (from m=11)
sw      t6,     172(s1)         # SRAM_I/O[43] = Y (from m=11)
lw      t5,     48(s2)          # t5 = SRAM_0[12] (store for next m)
lw      t6,     176(s2)         # t6 = SRAM_0[44] (store for next m)

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
sw      t5,     48(s1)          # SRAM_I/O[12] = X (from m=12)
sw      t6,     176(s1)         # SRAM_I/O[44] = Y (from m=12)
lw      t5,     52(s2)          # t5 = SRAM_0[13] (store for next m)
lw      t6,     180(s2)         # t6 = SRAM_0[45] (store for next m)

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
sw      t5,     52(s1)          # SRAM_I/O[13] = X (from m=13)
sw      t6,     180(s1)         # SRAM_I/O[45] = Y (from m=13)
lw      t5,     56(s2)          # t5 = SRAM_0[14] (store for next m)
lw      t6,     184(s2)         # t6 = SRAM_0[46] (store for next m)

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
sw      t5,     56(s1)          # SRAM_I/O[14] = X (from m=14)
sw      t6,     184(s1)         # SRAM_I/O[46] = Y (from m=14)
lw      t5,     60(s2)          # t5 = SRAM_0[15] (store for next m)
lw      t6,     188(s2)         # t6 = SRAM_0[47] (store for next m)

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
sw      t5,     60(s1)          # SRAM_I/O[15] = X (from m=15)
sw      t6,     188(s1)         # SRAM_I/O[47] = Y (from m=15)
lw      t5,     64(s2)          # t5 = SRAM_0[16] (store for next m)
lw      t6,     192(s2)         # t6 = SRAM_0[48] (store for next m)

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
sw      t5,     64(s1)          # SRAM_I/O[16] = X (from m=16)
sw      t6,     192(s1)         # SRAM_I/O[48] = Y (from m=16)
lw      t5,     68(s2)          # t5 = SRAM_0[17] (store for next m)
lw      t6,     196(s2)         # t6 = SRAM_0[49] (store for next m)

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
sw      t5,     68(s1)          # SRAM_I/O[17] = X (from m=17)
sw      t6,     196(s1)         # SRAM_I/O[49] = Y (from m=17)
lw      t5,     72(s2)          # t5 = SRAM_0[18] (store for next m)
lw      t6,     200(s2)         # t6 = SRAM_0[50] (store for next m)

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
sw      t5,     72(s1)          # SRAM_I/O[18] = X (from m=18)
sw      t6,     200(s1)         # SRAM_I/O[50] = Y (from m=18)
lw      t5,     76(s2)          # t5 = SRAM_0[19] (store for next m)
lw      t6,     204(s2)         # t6 = SRAM_0[51] (store for next m)

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
sw      t5,     76(s1)          # SRAM_I/O[19] = X (from m=19)
sw      t6,     204(s1)         # SRAM_I/O[51] = Y (from m=19)
lw      t5,     80(s2)          # t5 = SRAM_0[20] (store for next m)
lw      t6,     208(s2)         # t6 = SRAM_0[52] (store for next m)

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
sw      t5,     80(s1)          # SRAM_I/O[20] = X (from m=20)
sw      t6,     208(s1)         # SRAM_I/O[52] = Y (from m=20)
lw      t5,     84(s2)          # t5 = SRAM_0[21] (store for next m)
lw      t6,     212(s2)         # t6 = SRAM_0[53] (store for next m)
sw      t5,     84(s1)          # SRAM_I/O[21] = X (from m=21)
sw      t6,     212(s1)         # SRAM_I/O[53] = Y (from m=21)


#set1 start
addi s0, s0, 256
addi s1, s1, 256

#twiddle 선언
lw s7, 0(s3)  # w[0]

add x0, x0, x0
add x0, x0, x0

#------------------------------------------------
# Stage_0: SRAM_I/O --> SRAM_0 (Bit-Reversed) --> FFT_engine (Dpath_reg)
#------------------------------------------------
# Butterfly 22: SRAM_0[44], SRAM_0[45] with W[0]
lw t0, 52(s0)       
lw t1, 180(s0)   

add x0, x0, x0
lw t6, 32(s3)
lw a0, 40(s3)
lw a1, 48(s3)
add x0, x0, x0
add x0, x0, x0

sw t0, 176(s2)      # SRAM_0[44] = SRAM_IO[13] (preloaded)
sw t1, 180(s2)      # SRAM_0[45] = SRAM_IO[45] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 176(s2)      # t2 = SRAM_0[44]
lw t3, 180(s2)      # t3 = SRAM_0[45]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[44]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[45]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a4, 72(s3)
lw t0, 116(s0)      # Preload t0 = SRAM_IO[29] for Butterfly 23
lw t1, 244(s0)      # Preload t1 = SRAM_IO[61] for Butterfly 23
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 176(s2)      # SRAM_0[44] = X
sw t3, 180(s2)      # SRAM_0[45] = Y

# Butterfly 23: SRAM_0[46], SRAM_0[47] with W[0]
sw t0, 184(s2)      # SRAM_0[46] = SRAM_IO[29] (preloaded)
sw t1, 188(s2)      # SRAM_0[47] = SRAM_IO[61] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 184(s2)      # t2 = SRAM_0[46]
lw t3, 188(s2)      # t3 = SRAM_0[47]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[46]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[47]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a5, 80(s3)
lw t0, 12(s0)       # Preload t0 = SRAM_IO[3] for Butterfly 24
lw t1, 140(s0)      # Preload t1 = SRAM_IO[35] for Butterfly 24
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 184(s2)      # SRAM_0[46] = X
sw t3, 188(s2)      # SRAM_0[47] = Y

# Butterfly 24: SRAM_0[48], SRAM_0[49] with W[0]
sw t0, 192(s2)      # SRAM_0[48] = SRAM_IO[3] (preloaded)
sw t1, 196(s2)      # SRAM_0[49] = SRAM_IO[35] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 192(s2)      # t2 = SRAM_0[48]
lw t3, 196(s2)      # t3 = SRAM_0[49]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[48]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[49]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a6, 88(s3)
lw t0, 76(s0)       # Preload t0 = SRAM_IO[19] for Butterfly 25
lw t1, 204(s0)      # Preload t1 = SRAM_IO[51] for Butterfly 25
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 192(s2)      # SRAM_0[48] = X
sw t3, 196(s2)      # SRAM_0[49] = Y

# Butterfly 25: SRAM_0[50], SRAM_0[51] with W[0]
sw t0, 200(s2)      # SRAM_0[50] = SRAM_IO[19] (preloaded)
sw t1, 204(s2)      # SRAM_0[51] = SRAM_IO[51] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 200(s2)      # t2 = SRAM_0[50]
lw t3, 204(s2)      # t3 = SRAM_0[51]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[50]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[51]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a7, 96(s3)
lw t0, 44(s0)       # Preload t0 = SRAM_IO[11] for Butterfly 26
lw t1, 172(s0)      # Preload t1 = SRAM_IO[43] for Butterfly 26
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 200(s2)      # SRAM_0[50] = X
sw t3, 204(s2)      # SRAM_0[51] = Y

# Butterfly 26: SRAM_0[52], SRAM_0[53] with W[0]
sw t0, 208(s2)      # SRAM_0[52] = SRAM_IO[11] (preloaded)
sw t1, 212(s2)      # SRAM_0[53] = SRAM_IO[43] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 208(s2)      # t2 = SRAM_0[52]
lw t3, 212(s2)      # t3 = SRAM_0[53]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[52]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[53]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw ra, 104(s3)
lw t0, 108(s0)      # Preload t0 = SRAM_IO[27] for Butterfly 27
lw t1, 236(s0)      # Preload t1 = SRAM_IO[59] for Butterfly 27
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 208(s2)      # SRAM_0[52] = X
sw t3, 212(s2)      # SRAM_0[53] = Y

# Butterfly 27: SRAM_0[54], SRAM_0[55] with W[0]
sw t0, 216(s2)      # SRAM_0[54] = SRAM_IO[27] (preloaded)
sw t1, 220(s2)      # SRAM_0[55] = SRAM_IO[59] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 216(s2)      # t2 = SRAM_0[54]
lw t3, 220(s2)      # t3 = SRAM_0[55]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[54]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[55]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw sp, 112(s3)
lw t0, 28(s0)       # Preload t0 = SRAM_IO[7] for Butterfly 28
lw t1, 156(s0)      # Preload t1 = SRAM_IO[39] for Butterfly 28
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 216(s2)      # SRAM_0[54] = X
sw t3, 220(s2)      # SRAM_0[55] = Y

# Butterfly 28: SRAM_0[56], SRAM_0[57] with W[0]
sw t0, 224(s2)      # SRAM_0[56] = SRAM_IO[7] (preloaded)
sw t1, 228(s2)      # SRAM_0[57] = SRAM_IO[39] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 224(s2)      # t2 = SRAM_0[56]
lw t3, 228(s2)      # t3 = SRAM_0[57]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[56]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[57]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw gp, 120(s3)
lw t0, 92(s0)       # Preload t0 = SRAM_IO[23] for Butterfly 29
lw t1, 220(s0)      # Preload t1 = SRAM_IO[55] for Butterfly 29
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 224(s2)      # SRAM_0[56] = X
sw t3, 228(s2)      # SRAM_0[57] = Y

# Butterfly 29: SRAM_0[58], SRAM_0[59] with W[0]
sw t0, 232(s2)      # SRAM_0[58] = SRAM_IO[23] (preloaded)
sw t1, 236(s2)      # SRAM_0[59] = SRAM_IO[55] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 232(s2)      # t2 = SRAM_0[58]
lw t3, 236(s2)      # t3 = SRAM_0[59]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[58]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[59]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw s9, 8(s3)
lw t0, 60(s0)       # Preload t0 = SRAM_IO[15] for Butterfly 30
lw t1, 188(s0)      # Preload t1 = SRAM_IO[47] for Butterfly 30
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 232(s2)      # SRAM_0[58] = X
sw t3, 236(s2)      # SRAM_0[59] = Y

# Butterfly 30: SRAM_0[60], SRAM_0[61] with W[0]
sw t0, 240(s2)      # SRAM_0[60] = SRAM_IO[15] (preloaded)
sw t1, 244(s2)      # SRAM_0[61] = SRAM_IO[47] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 240(s2)      # t2 = SRAM_0[60]
lw t3, 244(s2)      # t3 = SRAM_0[61]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[60]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[61]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw s10, 16(s3)
lw t0, 124(s0)      # Preload t0 = SRAM_IO[31] for Butterfly 31
lw t1, 252(s0)      # Preload t1 = SRAM_IO[63] for Butterfly 31
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 240(s2)      # SRAM_0[60] = X
sw t3, 244(s2)      # SRAM_0[61] = Y

# Butterfly 31: SRAM_0[62], SRAM_0[63] with W[0]
sw t0, 248(s2)      # SRAM_0[62] = SRAM_IO[31] (preloaded)
sw t1, 252(s2)      # SRAM_0[63] = SRAM_IO[63] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 248(s2)      # t2 = SRAM_0[62]
lw t3, 252(s2)      # t3 = SRAM_0[63]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[62]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[63]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw s11, 24(s3)
lw a2, 56(s3)
lw a3, 64(s3)
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 248(s2)      # SRAM_0[62] = X
sw t3, 252(s2)      # SRAM_0[63] = Y

add x0, x0, x0
add x0, x0, x0
add x0, x0, x0
add x0, x0, x0

add x0, x0, x0

#------------------------------------------------
# Stage_1: SRAM_0 <--> FFT_engine (32 butterflies)
#------------------------------------------------
 # m=0 group: twiddle factor W[0], butterflies (0,2), (4,6), ..., (60,62)

# Butterfly 0: (0,2)
lw t0, 0(s2)     # load SRAM0[0]
lw t1, 8(s2)     # load SRAM0[2]
sw t0, 0(s4)     # store to datapath input 0
sw t1, 0(s5)     # store to datapath input 1
sw s7, 0(s6)     # store twiddle factor W[0]
lw s8, 16(s2)    # preload SRAM0[4] for next butterfly
lw t2, 4(s4)     # load result X from datapath
lw t3, 4(s5)     # load result Y from datapath
sw t2, 0(s2)     # store X to SRAM0[0]
sw t3, 8(s2)     # store Y to SRAM0[2]

# Butterfly 1: (4,6)
lw t1, 24(s2)    # load SRAM0[6]
sw s8, 0(s4)     # store preloaded SRAM0[4]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 32(s2)    # preload SRAM0[8]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 16(s2)    # store to SRAM0[4]
sw t3, 24(s2)    # store to SRAM0[6]

# Butterfly 2: (8,10)
lw t1, 40(s2)    # load SRAM0[10]
sw s8, 0(s4)     # store preloaded SRAM0[8]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 48(s2)    # preload SRAM0[12]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 32(s2)    # store to SRAM0[8]
sw t3, 40(s2)    # store to SRAM0[10]

# Butterfly 3: (12,14)
lw t1, 56(s2)    # load SRAM0[14]
sw s8, 0(s4)     # store preloaded SRAM0[12]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 64(s2)    # preload SRAM0[16]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 48(s2)    # store to SRAM0[12]
sw t3, 56(s2)    # store to SRAM0[14]

# Butterfly 4: (16,18)
lw t1, 72(s2)    # load SRAM0[18]
sw s8, 0(s4)     # store preloaded SRAM0[16]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 80(s2)    # preload SRAM0[20]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 64(s2)    # store to SRAM0[16]
sw t3, 72(s2)    # store to SRAM0[18]

# Butterfly 5: (20,22)
lw t1, 88(s2)    # load SRAM0[22]
sw s8, 0(s4)     # store preloaded SRAM0[20]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 96(s2)    # preload SRAM0[24]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 80(s2)    # store to SRAM0[20]
sw t3, 88(s2)    # store to SRAM0[22]

# Butterfly 6: (24,26)
lw t1, 104(s2)   # load SRAM0[26]
sw s8, 0(s4)     # store preloaded SRAM0[24]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 112(s2)   # preload SRAM0[28]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 96(s2)    # store to SRAM0[24]
sw t3, 104(s2)   # store to SRAM0[26]

# Butterfly 7: (28,30)
lw t1, 120(s2)   # load SRAM0[30]
sw s8, 0(s4)     # store preloaded SRAM0[28]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 128(s2)   # preload SRAM0[32]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 112(s2)   # store to SRAM0[28]
sw t3, 120(s2)   # store to SRAM0[30]

# Butterfly 8: (32,34)
lw t1, 136(s2)   # load SRAM0[34]
sw s8, 0(s4)     # store preloaded SRAM0[32]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 144(s2)   # preload SRAM0[36]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 128(s2)   # store to SRAM0[32]
sw t3, 136(s2)   # store to SRAM0[34]

# Butterfly 9: (36,38)
lw t1, 152(s2)   # load SRAM0[38]
sw s8, 0(s4)     # store preloaded SRAM0[36]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 160(s2)   # preload SRAM0[40]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 144(s2)   # store to SRAM0[36]
sw t3, 152(s2)   # store to SRAM0[38]

# Butterfly 10: (40,42)
lw t1, 168(s2)   # load SRAM0[42]
sw s8, 0(s4)     # store preloaded SRAM0[40]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 100(s2)    # preload SRAM0[25]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 160(s2)   # store to SRAM0[40]
sw t3, 168(s2)   # store to SRAM0[42]

# Stage_2: s=2, d=4, g=4, b=8, twiddle W[m*8]

# Group m=0: twiddle W[0]
# Butterfly 3: (25,29)
lw t1, 116(s2)    # SRAM0[29]
sw s8, 0(s4)      # SRAM0[25]
sw t1, 0(s5)
sw t6, 0(s6)
lw s8, 132(s2)    # preload SRAM0[33]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 100(s2)
sw t3, 116(s2)

# Butterfly 4: (33,37)
lw t1, 148(s2)    # SRAM0[37]
sw s8, 0(s4)      # SRAM0[33]
sw t1, 0(s5)
sw t6, 0(s6)
lw s8, 164(s2)    # preload SRAM0[41]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 132(s2)
sw t3, 148(s2)

# Butterfly 5: (41,45)
lw t1, 180(s2)    # SRAM0[45]
sw s8, 0(s4)      # SRAM0[41]
sw t1, 0(s5)
sw t6, 0(s6)
lw s8, 196(s2)    # preload SRAM0[49]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 164(s2)
sw t3, 180(s2)

# Butterfly 6: (49,53)
lw t1, 212(s2)    # SRAM0[53]
sw s8, 0(s4)      # SRAM0[49]
sw t1, 0(s5)
sw t6, 0(s6)
lw s8, 228(s2)    # preload SRAM0[57]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 196(s2)
sw t3, 212(s2)

# Butterfly 7: (57,61)
lw t1, 244(s2)    # SRAM0[61]
sw s8, 0(s4)      # SRAM0[57]
sw t1, 0(s5)
sw t6, 0(s6)
lw s8, 8(s2)      # preload SRAM0[2] for next group (m=2)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 228(s2)
sw t3, 244(s2)

# Group m=2: twiddle W[16]

# Butterfly 0: (2,6)
lw t1, 24(s2)     # SRAM0[6]
sw s8, 0(s4)
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 40(s2)     # preload SRAM0[10]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 8(s2)
sw t3, 24(s2)

# Butterfly 1: (10,14)
lw t1, 56(s2)     # SRAM0[14]
sw s8, 0(s4)      # SRAM0[10]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 72(s2)     # preload SRAM0[18]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 40(s2)
sw t3, 56(s2)

# Butterfly 2: (18,22)
lw t1, 88(s2)     # SRAM0[22]
sw s8, 0(s4)      # SRAM0[18]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 104(s2)    # preload SRAM0[26]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 72(s2)
sw t3, 88(s2)

# Butterfly 3: (26,30)
lw t1, 120(s2)    # SRAM0[30]
sw s8, 0(s4)      # SRAM0[26]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 136(s2)    # preload SRAM0[34]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 104(s2)
sw t3, 120(s2)

# Butterfly 4: (34,38)
lw t1, 152(s2)    # SRAM0[38]
sw s8, 0(s4)      # SRAM0[34]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 168(s2)    # preload SRAM0[42]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 136(s2)
sw t3, 152(s2)

# Butterfly 5: (42,46)
lw t1, 184(s2)    # SRAM0[46]
sw s8, 0(s4)      # SRAM0[42]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 148(s2)    # preload SRAM0[37]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 168(s2)
sw t3, 184(s2)

# Stage_3: s=3, d=8, g=8, b=4, twiddle W[m*4]

# Group m=0: twiddle W[0]

# Butterfly 2: (37,45)
lw t1, 180(s2)    # SRAM0[45]
sw s8, 0(s4)      # SRAM0[37]
sw t1, 0(s5)
sw a5, 0(s6)
lw s8, 212(s2)    # preload SRAM0[53]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 148(s2)
sw t3, 180(s2)

# Butterfly 3: (53,61)
lw t1, 244(s2)    # SRAM0[61]
sw s8, 0(s4)      # SRAM0[53]
sw t1, 0(s5)
sw a5, 0(s6)
lw s8, 24(s2)     # preload SRAM0[6] for next group (m=6)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 212(s2)
sw t3, 244(s2)

# Group m=6: twiddle W[24]

# Butterfly 0: (6,14)
lw t1, 56(s2)     # SRAM0[14]
sw s8, 0(s4)
sw t1, 0(s5)
sw a7, 0(s6)
lw s8, 88(s2)     # preload SRAM0[22]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 24(s2)
sw t3, 56(s2)

# Butterfly 1: (22,30)
lw t1, 120(s2)    # SRAM0[30]
sw s8, 0(s4)      # SRAM0[22]
sw t1, 0(s5)
sw a7, 0(s6)
lw s8, 152(s2)    # preload SRAM0[38]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 88(s2)
sw t3, 120(s2)

# Butterfly 2: (38,46)
lw t1, 184(s2)    # SRAM0[46]
sw s8, 0(s4)      # SRAM0[38]
sw t1, 0(s5)
sw a7, 0(s6)
lw s8, 216(s2)    # preload SRAM0[54]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 152(s2)
sw t3, 184(s2)

# Butterfly 3: (54,62)
lw t1, 248(s2)    # SRAM0[62]
sw s8, 0(s4)      # SRAM0[54]
sw t1, 0(s5)
sw a7, 0(s6)
lw s8, 28(s2)     # preload SRAM0[7] for next group (m=7)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 216(s2)
sw t3, 248(s2)

# Group m=7: twiddle W[28]

# Butterfly 0: (7,15)
lw t1, 60(s2)     # SRAM0[15]
sw s8, 0(s4)
sw t1, 0(s5)
sw sp, 0(s6)
lw s8, 92(s2)     # preload SRAM0[23]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 28(s2)
sw t3, 60(s2)

# Butterfly 1: (23,31)
lw t1, 124(s2)    # SRAM0[31]
sw s8, 0(s4)      # SRAM0[23]
sw t1, 0(s5)
sw sp, 0(s6)
lw s8, 156(s2)    # preload SRAM0[39]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 92(s2)
sw t3, 124(s2)

# Butterfly 2: (39,47)
lw t1, 188(s2)    # SRAM0[47]
sw s8, 0(s4)      # SRAM0[39]
sw t1, 0(s5)
sw sp, 0(s6)
lw s8, 220(s2)    # preload SRAM0[55]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 156(s2)
sw t3, 188(s2)

# Butterfly 3: (55,63)
lw t1, 252(s2)    # SRAM0[63]
sw s8, 0(s4)      # SRAM0[55]
sw t1, 0(s5)
sw sp, 0(s6)
lw s8, 0(s2)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 220(s2)
sw t3, 252(s2)

# Stage_4: s=4, d=16, g=16, b=2, twiddle W[m*2]

# Butterfly 0: (0,16)
lw t1, 64(s2)     # SRAM0[16]
sw s8, 0(s4)
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 128(s2)    # preload SRAM0[32]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 0(s2)
sw t3, 64(s2)

# Butterfly 1: (32,48)
lw t1, 192(s2)    # SRAM0[48]
sw s8, 0(s4)      # SRAM0[32]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 4(s2)      # preload SRAM0[1] for next group (m=1)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 128(s2)
sw t3, 192(s2)

# Group m=1: twiddle W[2]

# Butterfly 0: (1,17)
lw t1, 68(s2)     # SRAM0[17]
sw s8, 0(s4)
sw t1, 0(s5)
sw s9, 0(s6)
lw s8, 132(s2)    # preload SRAM0[33]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 4(s2)
sw t3, 68(s2)

# Butterfly 1: (33,49)
lw t1, 196(s2)    # SRAM0[49]
sw s8, 0(s4)      # SRAM0[33]
sw t1, 0(s5)
sw s9, 0(s6)
lw s8, 8(s2)      # preload SRAM0[2] for next group (m=2)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 132(s2)
sw t3, 196(s2)

# Group m=2: twiddle W[4]

# Butterfly 0: (2,18)
lw t1, 72(s2)     # SRAM0[18]
sw s8, 0(s4)
sw t1, 0(s5)
sw s10, 0(s6)
lw s8, 136(s2)    # preload SRAM0[34]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 8(s2)
sw t3, 72(s2)

# Butterfly 1: (34,50)
lw t1, 200(s2)    # SRAM0[50]
sw s8, 0(s4)      # SRAM0[34]
sw t1, 0(s5)
sw s10, 0(s6)
lw s8, 12(s2)     # preload SRAM0[3] for next group (m=3)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 136(s2)
sw t3, 200(s2)

# Group m=3: twiddle W[6]

# Butterfly 0: (3,19)
lw t1, 76(s2)     # SRAM0[19]
sw s8, 0(s4)
sw t1, 0(s5)
sw s11, 0(s6)
lw s8, 140(s2)    # preload SRAM0[35]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 12(s2)
sw t3, 76(s2)

# Butterfly 1: (35,51)
lw t1, 204(s2)    # SRAM0[51]
sw s8, 0(s4)      # SRAM0[35]
sw t1, 0(s5)
sw s11, 0(s6)
lw s8, 16(s2)     # preload SRAM0[4] for next group (m=4)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 140(s2)
sw t3, 204(s2)

# Group m=4: twiddle W[8]

# Butterfly 0: (4,20)
lw t1, 80(s2)     # SRAM0[20]
sw s8, 0(s4)
sw t1, 0(s5)
sw t6, 0(s6)
lw s8, 144(s2)    # preload SRAM0[36]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 16(s2)
sw t3, 80(s2)

# Butterfly 1: (36,52)
lw t1, 208(s2)    # SRAM0[52]
sw s8, 0(s4)      # SRAM0[36]
sw t1, 0(s5)
sw t6, 0(s6)
lw s8, 20(s2)     # preload SRAM0[5] for next group (m=5)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 144(s2)
sw t3, 208(s2)

# Group m=5: twiddle W[10]

# Butterfly 0: (5,21)
lw t1, 84(s2)     # SRAM0[21]
sw s8, 0(s4)
sw t1, 0(s5)
sw a0, 0(s6)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 20(s2)
sw t3, 84(s2)

add x0, x0, x0
add x0, x0, x0


#------------------------------------------------
# Stage_5: 
#------------------------------------------------

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
add x0, x0, x0
add x0, x0, x0
lw      t5,     44(s2)          # t5 = SRAM_0[11] (store for next m)
lw      t6,     172(s2)         # t6 = SRAM_0[43] (store for next m)

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
sw      t5,     44(s1)          # SRAM_I/O[11] = X (from m=11)
sw      t6,     172(s1)         # SRAM_I/O[43] = Y (from m=11)
lw      t5,     48(s2)          # t5 = SRAM_0[12] (store for next m)
lw      t6,     176(s2)         # t6 = SRAM_0[44] (store for next m)

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
sw      t5,     48(s1)          # SRAM_I/O[12] = X (from m=12)
sw      t6,     176(s1)         # SRAM_I/O[44] = Y (from m=12)
lw      t5,     52(s2)          # t5 = SRAM_0[13] (store for next m)
lw      t6,     180(s2)         # t6 = SRAM_0[45] (store for next m)

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
sw      t5,     52(s1)          # SRAM_I/O[13] = X (from m=13)
sw      t6,     180(s1)         # SRAM_I/O[45] = Y (from m=13)
lw      t5,     56(s2)          # t5 = SRAM_0[14] (store for next m)
lw      t6,     184(s2)         # t6 = SRAM_0[46] (store for next m)

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
sw      t5,     56(s1)          # SRAM_I/O[14] = X (from m=14)
sw      t6,     184(s1)         # SRAM_I/O[46] = Y (from m=14)
lw      t5,     60(s2)          # t5 = SRAM_0[15] (store for next m)
lw      t6,     188(s2)         # t6 = SRAM_0[47] (store for next m)

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
sw      t5,     60(s1)          # SRAM_I/O[15] = X (from m=15)
sw      t6,     188(s1)         # SRAM_I/O[47] = Y (from m=15)
lw      t5,     64(s2)          # t5 = SRAM_0[16] (store for next m)
lw      t6,     192(s2)         # t6 = SRAM_0[48] (store for next m)

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
sw      t5,     64(s1)          # SRAM_I/O[16] = X (from m=16)
sw      t6,     192(s1)         # SRAM_I/O[48] = Y (from m=16)
lw      t5,     68(s2)          # t5 = SRAM_0[17] (store for next m)
lw      t6,     196(s2)         # t6 = SRAM_0[49] (store for next m)

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
sw      t5,     68(s1)          # SRAM_I/O[17] = X (from m=17)
sw      t6,     196(s1)         # SRAM_I/O[49] = Y (from m=17)
lw      t5,     72(s2)          # t5 = SRAM_0[18] (store for next m)
lw      t6,     200(s2)         # t6 = SRAM_0[50] (store for next m)

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
sw      t5,     72(s1)          # SRAM_I/O[18] = X (from m=18)
sw      t6,     200(s1)         # SRAM_I/O[50] = Y (from m=18)
lw      t5,     76(s2)          # t5 = SRAM_0[19] (store for next m)
lw      t6,     204(s2)         # t6 = SRAM_0[51] (store for next m)

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
sw      t5,     76(s1)          # SRAM_I/O[19] = X (from m=19)
sw      t6,     204(s1)         # SRAM_I/O[51] = Y (from m=19)
lw      t5,     80(s2)          # t5 = SRAM_0[20] (store for next m)
lw      t6,     208(s2)         # t6 = SRAM_0[52] (store for next m)

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
sw      t5,     80(s1)          # SRAM_I/O[20] = X (from m=20)
sw      t6,     208(s1)         # SRAM_I/O[52] = Y (from m=20)
lw      t5,     84(s2)          # t5 = SRAM_0[21] (store for next m)
lw      t6,     212(s2)         # t6 = SRAM_0[53] (store for next m)
sw      t5,     84(s1)          # SRAM_I/O[21] = X (from m=21)
sw      t6,     212(s1)         # SRAM_I/O[53] = Y (from m=21)


