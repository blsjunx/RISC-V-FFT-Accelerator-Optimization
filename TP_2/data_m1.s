#core0

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
    
start_fft:

#twiddle 선언
lw s7, 0(s3)  # w[0]

#------------------------------------------------
# Stage_0: SRAM_I/O --> SRAM_0 (Bit-Reversed) --> FFT_engine (Dpath_reg)
#------------------------------------------------
# Butterfly 0: SRAM_0[0], SRAM_0[1] with W[0]
lw t0, 0(s0)        # t0 = SRAM_IO[0]
lw t1, 128(s0)      # t1 = SRAM_IO[32]

sw t0, 0(s2)        # SRAM_0[0] = SRAM_IO[0]
sw t1, 4(s2)        # SRAM_0[1] = SRAM_IO[32]
add x0, x0, x0
lw t2, 0(s2)        # t2 = SRAM_0[0]
lw t3, 4(s2)        # t3 = SRAM_0[1]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[0]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[1]
sw s7, 0(s6)        # dpath_reg_2 = W[0]
lw s9, 8(s3)        # twiddle load
lw t0, 64(s0)       # Preload t0 = SRAM_IO[16] for Butterfly 1
lw t1, 192(s0)      # Preload t1 = SRAM_IO[48] for Butterfly 1
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 0(s2)        # SRAM_0[0] = X
sw t3, 4(s2)        # SRAM_0[1] = Y

# Butterfly 1: SRAM_0[2], SRAM_0[3] with W[0]
sw t0, 8(s2)        # SRAM_0[2] = SRAM_IO[16] (preloaded)
sw t1, 12(s2)       # SRAM_0[3] = SRAM_IO[48] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 8(s2)        # t2 = SRAM_0[2]
lw t3, 12(s2)       # t3 = SRAM_0[3]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[2]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[3]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw s10, 16(s3)
lw t0, 32(s0)       # Preload t0 = SRAM_IO[8] for Butterfly 2
lw t1, 160(s0)      # Preload t1 = SRAM_IO[40] for Butterfly 2
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 8(s2)        # SRAM_0[2] = X
sw t3, 12(s2)       # SRAM_0[3] = Y

# Butterfly 2: SRAM_0[4], SRAM_0[5] with W[0]
sw t0, 16(s2)       # SRAM_0[4] = SRAM_IO[8] (preloaded)
sw t1, 20(s2)       # SRAM_0[5] = SRAM_IO[40] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 16(s2)       # t2 = SRAM_0[4]
lw t3, 20(s2)       # t3 = SRAM_0[5]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[4]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[5]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw s11, 24(s3)
lw t0, 96(s0)       # Preload t0 = SRAM_IO[24] for Butterfly 3
lw t1, 224(s0)      # Preload t1 = SRAM_IO[56] for Butterfly 3
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 16(s2)       # SRAM_0[4] = X
sw t3, 20(s2)       # SRAM_0[5] = Y

# Butterfly 3: SRAM_0[6], SRAM_0[7] with W[0]
sw t0, 24(s2)       # SRAM_0[6] = SRAM_IO[24] (preloaded)
sw t1, 28(s2)       # SRAM_0[7] = SRAM_IO[56] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 24(s2)       # t2 = SRAM_0[6]
lw t3, 28(s2)       # t3 = SRAM_0[7]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[6]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[7]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw t6, 32(s3)
lw t0, 16(s0)       # Preload t0 = SRAM_IO[4] for Butterfly 4
lw t1, 144(s0)      # Preload t1 = SRAM_IO[36] for Butterfly 4
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 24(s2)       # SRAM_0[6] = X
sw t3, 28(s2)       # SRAM_0[7] = Y

# Butterfly 4: SRAM_0[8], SRAM_0[9] with W[0]
sw t0, 32(s2)       # SRAM_0[8] = SRAM_IO[4] (preloaded)
sw t1, 36(s2)       # SRAM_0[9] = SRAM_IO[36] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 32(s2)       # t2 = SRAM_0[8]
lw t3, 36(s2)       # t3 = SRAM_0[9]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[8]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[9]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a0, 40(s3)
lw t0, 80(s0)       # Preload t0 = SRAM_IO[20] for Butterfly 5
lw t1, 208(s0)      # Preload t1 = SRAM_IO[52] for Butterfly 5
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 32(s2)       # SRAM_0[8] = X
sw t3, 36(s2)       # SRAM_0[9] = Y

# Butterfly 5: SRAM_0[10], SRAM_0[11] with W[0]
sw t0, 40(s2)       # SRAM_0[10] = SRAM_IO[20] (preloaded)
sw t1, 44(s2)       # SRAM_0[11] = SRAM_IO[52] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 40(s2)       # t2 = SRAM_0[10]
lw t3, 44(s2)       # t3 = SRAM_0[11]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[10]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[11]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a1, 48(s3)
lw t0, 48(s0)       # Preload t0 = SRAM_IO[12] for Butterfly 6
lw t1, 176(s0)      # Preload t1 = SRAM_IO[44] for Butterfly 6
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 40(s2)       # SRAM_0[10] = X
sw t3, 44(s2)       # SRAM_0[11] = Y

# Butterfly 6: SRAM_0[12], SRAM_0[13] with W[0]
sw t0, 48(s2)       # SRAM_0[12] = SRAM_IO[12] (preloaded)
sw t1, 52(s2)       # SRAM_0[13] = SRAM_IO[44] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 48(s2)       # t2 = SRAM_0[12]
lw t3, 52(s2)       # t3 = SRAM_0[13]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[12]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[13]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a2, 56(s3)
lw t0, 112(s0)      # Preload t0 = SRAM_IO[28] for Butterfly 7
lw t1, 240(s0)      # Preload t1 = SRAM_IO[60] for Butterfly 7
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 48(s2)       # SRAM_0[12] = X
sw t3, 52(s2)       # SRAM_0[13] = Y

# Butterfly 7: SRAM_0[14], SRAM_0[15] with W[0]
sw t0, 56(s2)       # SRAM_0[14] = SRAM_IO[28] (preloaded)
sw t1, 60(s2)       # SRAM_0[15] = SRAM_IO[60] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 56(s2)       # t2 = SRAM_0[14]
lw t3, 60(s2)       # t3 = SRAM_0[15]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[14]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[15]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a3, 64(s3)
lw t0, 8(s0)        # Preload t0 = SRAM_IO[2] for Butterfly 8
lw t1, 136(s0)      # Preload t1 = SRAM_IO[34] for Butterfly 8
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 56(s2)       # SRAM_0[14] = X
sw t3, 60(s2)       # SRAM_0[15] = Y

# Butterfly 8: SRAM_0[16], SRAM_0[17] with W[0]
sw t0, 64(s2)       # SRAM_0[16] = SRAM_IO[2] (preloaded)
sw t1, 68(s2)       # SRAM_0[17] = SRAM_IO[34] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 64(s2)       # t2 = SRAM_0[16]
lw t3, 68(s2)       # t3 = SRAM_0[17]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[16]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[17]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a4, 72(s3)
lw t0, 72(s0)       # Preload t0 = SRAM_IO[18] for Butterfly 9
lw t1, 200(s0)      # Preload t1 = SRAM_IO[50] for Butterfly 9
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 64(s2)       # SRAM_0[16] = X
sw t3, 68(s2)       # SRAM_0[17] = Y

# Butterfly 9: SRAM_0[18], SRAM_0[19] with W[0]
sw t0, 72(s2)       # SRAM_0[18] = SRAM_IO[18] (preloaded)
sw t1, 76(s2)       # SRAM_0[19] = SRAM_IO[50] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 72(s2)       # t2 = SRAM_0[18]
lw t3, 76(s2)       # t3 = SRAM_0[19]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[18]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[19]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a5, 80(s3)
lw t0, 40(s0)       # Preload t0 = SRAM_IO[10] for Butterfly 10
lw t1, 168(s0)      # Preload t1 = SRAM_IO[42] for Butterfly 10
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 72(s2)       # SRAM_0[18] = X
sw t3, 76(s2)       # SRAM_0[19] = Y

# Butterfly 10: SRAM_0[20], SRAM_0[21] with W[0]
sw t0, 80(s2)       # SRAM_0[20] = SRAM_IO[10] (preloaded)
sw t1, 84(s2)       # SRAM_0[21] = SRAM_IO[42] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 80(s2)       # t2 = SRAM_0[20]
lw t3, 84(s2)       # t3 = SRAM_0[21]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[20]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[21]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a6, 88(s3)
lw a7, 96(s3)
lw ra, 104(s3)
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 80(s2)       # SRAM_0[20] = X
sw t3, 84(s2)       # SRAM_0[21] = Y

lw sp, 112(s3)
lw gp, 120(s3)

add x0, x0, x0

#------------------------------------------------
# Stage_1: SRAM_0 <--> FFT_engine (32 butterflies)
#------------------------------------------------
 # m=0 group: twiddle factor W[0], butterflies (0,2), (4,6), ..., (60,62)

lw t0, 176(s2)
# Butterfly 11: (44,46)
lw t1, 184(s2)   # load SRAM0[46]
sw t0, 0(s4)     
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 192(s2)   # preload SRAM0[48]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 176(s2)   # store to SRAM0[44]
sw t3, 184(s2)   # store to SRAM0[46]

# Butterfly 12: (48,50)
lw t1, 200(s2)   # load SRAM0[50]
sw s8, 0(s4)     # store preloaded SRAM0[48]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 208(s2)   # preload SRAM0[52]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 192(s2)   # store to SRAM0[48]
sw t3, 200(s2)   # store to SRAM0[50]

# Butterfly 13: (52,54)
lw t1, 216(s2)   # load SRAM0[54]
sw s8, 0(s4)     # store preloaded SRAM0[52]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 224(s2)   # preload SRAM0[56]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 208(s2)   # store to SRAM0[52]
sw t3, 216(s2)   # store to SRAM0[54]

# Butterfly 14: (56,58)
lw t1, 232(s2)   # load SRAM0[58]
sw s8, 0(s4)     # store preloaded SRAM0[56]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 240(s2)   # preload SRAM0[60]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 224(s2)   # store to SRAM0[56]
sw t3, 232(s2)   # store to SRAM0[58]

# Butterfly 15: (60,62)
lw t1, 248(s2)   # load SRAM0[62]
sw s8, 0(s4)     # store preloaded SRAM0[60]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 4(s2)     # preload SRAM0[1] for next group (m=1)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 240(s2)   # store to SRAM0[60]
sw t3, 248(s2)   # store to SRAM0[62]

# m=1 group: twiddle factor W[16], butterflies (1,3), (5,7), ..., (61,63)

# Butterfly 0: (1,3)
lw t1, 12(s2)    # load SRAM0[3]
sw s8, 0(s4)
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 20(s2)    # preload SRAM0[5]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 4(s2)     # store to SRAM0[1]
sw t3, 12(s2)    # store to SRAM0[3]

# Butterfly 1: (5,7)
lw t1, 28(s2)    # load SRAM0[7]
sw s8, 0(s4)     # store preloaded SRAM0[5]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 36(s2)    # preload SRAM0[9]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 20(s2)    # store to SRAM0[5]
sw t3, 28(s2)    # store to SRAM0[7]

# Butterfly 2: (9,11)
lw t1, 44(s2)    # load SRAM0[11]
sw s8, 0(s4)     # store preloaded SRAM0[9]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 52(s2)    # preload SRAM0[13]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 36(s2)    # store to SRAM0[9]
sw t3, 44(s2)    # store to SRAM0[11]

# Butterfly 3: (13,15)
lw t1, 60(s2)    # load SRAM0[15]
sw s8, 0(s4)     # store preloaded SRAM0[13]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 68(s2)    # preload SRAM0[17]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 52(s2)    # store to SRAM0[13]
sw t3, 60(s2)    # store to SRAM0[15]

# Butterfly 4: (17,19)
lw t1, 76(s2)    # load SRAM0[19]
sw s8, 0(s4)     # store preloaded SRAM0[17]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 84(s2)    # preload SRAM0[21]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 68(s2)    # store to SRAM0[17]
sw t3, 76(s2)    # store to SRAM0[19]

# Butterfly 5: (21,23)
lw t1, 92(s2)    # load SRAM0[23]
sw s8, 0(s4)     # store preloaded SRAM0[21]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 200(s2)    # preload SRAM0[50]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 84(s2)    # store to SRAM0[21]
sw t3, 92(s2)    # store to SRAM0[23]


# Stage_2: s=2, d=4, g=4, b=8, twiddle W[m*8]

# Group m=0: twiddle W[0]

# Butterfly 6: (50,54)
lw t1, 216(s2)    # SRAM0[54]
sw s8, 0(s4)      # SRAM0[50]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 232(s2)    # preload SRAM0[58]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 200(s2)
sw t3, 216(s2)

# Butterfly 7: (58,62)
lw t1, 248(s2)    # SRAM0[62]
sw s8, 0(s4)      # SRAM0[58]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 12(s2)     # preload SRAM0[3] for next group (m=3)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 232(s2)
sw t3, 248(s2)

# Group m=3: twiddle W[24]

# Butterfly 0: (3,7)
lw t1, 28(s2)     # SRAM0[7]
sw s8, 0(s4)
sw t1, 0(s5)
sw a7, 0(s6)
lw s8, 44(s2)     # preload SRAM0[11]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 12(s2)
sw t3, 28(s2)

# Butterfly 1: (11,15)
lw t1, 60(s2)     # SRAM0[15]
sw s8, 0(s4)      # SRAM0[11]
sw t1, 0(s5)
sw a7, 0(s6)
lw s8, 76(s2)     # preload SRAM0[19]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 44(s2)
sw t3, 60(s2)

# Butterfly 2: (19,23)
lw t1, 92(s2)     # SRAM0[23]
sw s8, 0(s4)      # SRAM0[19]
sw t1, 0(s5)
sw a7, 0(s6)
lw s8, 108(s2)    # preload SRAM0[27]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 76(s2)
sw t3, 92(s2)

# Butterfly 3: (27,31)
lw t1, 124(s2)    # SRAM0[31]
sw s8, 0(s4)      # SRAM0[27]
sw t1, 0(s5)
sw a7, 0(s6)
lw s8, 140(s2)    # preload SRAM0[35]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 108(s2)
sw t3, 124(s2)

# Butterfly 4: (35,39)
lw t1, 156(s2)    # SRAM0[39]
sw s8, 0(s4)      # SRAM0[35]
sw t1, 0(s5)
sw a7, 0(s6)
lw s8, 172(s2)    # preload SRAM0[43]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 140(s2)
sw t3, 156(s2)

# Butterfly 5: (43,47)
lw t1, 188(s2)    # SRAM0[47]
sw s8, 0(s4)      # SRAM0[43]
sw t1, 0(s5)
sw a7, 0(s6)
lw s8, 204(s2)    # preload SRAM0[51]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 172(s2)
sw t3, 188(s2)

# Butterfly 6: (51,55)
lw t1, 220(s2)    # SRAM0[55]
sw s8, 0(s4)      # SRAM0[51]
sw t1, 0(s5)
sw a7, 0(s6)
lw s8, 236(s2)    # preload SRAM0[59]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 204(s2)
sw t3, 220(s2)

# Butterfly 7: (59,63)
lw t1, 252(s2)    # SRAM0[63]
sw s8, 0(s4)      # SRAM0[59]
sw t1, 0(s5)
sw a7, 0(s6)
lw s8, 0(s2)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 236(s2)
sw t3, 252(s2)

# Stage_3: s=3, d=8, g=8, b=4, twiddle W[m*4]

# Group m=0: twiddle W[0]

# Butterfly 0: (0,8)
lw t1, 32(s2)     # SRAM0[8]
sw s8, 0(s4)
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 64(s2)     # preload SRAM0[16]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 0(s2)
sw t3, 32(s2)

# Butterfly 1: (16,24)
lw t1, 96(s2)     # SRAM0[24]
sw s8, 0(s4)      # SRAM0[16]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 128(s2)    # preload SRAM0[32]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 64(s2)
sw t3, 96(s2)

# Butterfly 2: (32,40)
lw t1, 160(s2)    # SRAM0[40]
sw s8, 0(s4)      # SRAM0[32]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 192(s2)    # preload SRAM0[48]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 128(s2)
sw t3, 160(s2)

# Butterfly 3: (48,56)
lw t1, 224(s2)    # SRAM0[56]
sw s8, 0(s4)      # SRAM0[48]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 4(s2)      # preload SRAM0[1] for next group (m=1)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 192(s2)
sw t3, 224(s2)

# Group m=1: twiddle W[4]

# Butterfly 0: (1,9)
lw t1, 36(s2)     # SRAM0[9]
sw s8, 0(s4)
sw t1, 0(s5)
sw s10, 0(s6)
lw s8, 68(s2)     # preload SRAM0[17]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 4(s2)
sw t3, 36(s2)

# Butterfly 1: (17,25)
lw t1, 100(s2)    # SRAM0[25]
sw s8, 0(s4)      # SRAM0[17]
sw t1, 0(s5)
sw s10, 0(s6)
lw s8, 132(s2)    # preload SRAM0[33]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 68(s2)
sw t3, 100(s2)

# Butterfly 2: (33,41)
lw t1, 164(s2)    # SRAM0[41]
sw s8, 0(s4)      # SRAM0[33]
sw t1, 0(s5)
sw s10, 0(s6)
lw s8, 196(s2)    # preload SRAM0[49]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 132(s2)
sw t3, 164(s2)

# Butterfly 3: (49,57)
lw t1, 228(s2)    # SRAM0[57]
sw s8, 0(s4)      # SRAM0[49]
sw t1, 0(s5)
sw s10, 0(s6)
lw s8, 8(s2)      # preload SRAM0[2] for next group (m=2)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 196(s2)
sw t3, 228(s2)

# Group m=2: twiddle W[8]

# Butterfly 0: (2,10)
lw t1, 40(s2)     # SRAM0[10]
sw s8, 0(s4)
sw t1, 0(s5)
sw t6, 0(s6)
lw s8, 72(s2)     # preload SRAM0[18]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 8(s2)
sw t3, 40(s2)

# Butterfly 1: (18,26)
lw t1, 104(s2)    # SRAM0[26]
sw s8, 0(s4)      # SRAM0[18]
sw t1, 0(s5)
sw t6, 0(s6)
lw s8, 136(s2)    # preload SRAM0[34]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 72(s2)
sw t3, 104(s2)

# Butterfly 2: (34,42)
lw t1, 168(s2)    # SRAM0[42]
sw s8, 0(s4)      # SRAM0[34]
sw t1, 0(s5)
sw t6, 0(s6)
lw s8, 148(s2)    # preload SRAM0[37]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 136(s2)
sw t3, 168(s2)

# Stage_4: s=4, d=16, g=16, b=2, twiddle W[m*2]

# Group m=0: twiddle W[0]

# Butterfly 1: (37,53)
lw t1, 212(s2)    # SRAM0[53]
sw s8, 0(s4)      # SRAM0[37]
sw t1, 0(s5)
sw a0, 0(s6)
lw s8, 24(s2)     # preload SRAM0[6] for next group (m=6)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 148(s2)
sw t3, 212(s2)

# Group m=6: twiddle W[12]

# Butterfly 0: (6,22)
lw t1, 88(s2)     # SRAM0[22]
sw s8, 0(s4)
sw t1, 0(s5)
sw a1, 0(s6)
lw s8, 152(s2)    # preload SRAM0[38]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 24(s2)
sw t3, 88(s2)

# Butterfly 1: (38,54)
lw t1, 216(s2)    # SRAM0[54]
sw s8, 0(s4)      # SRAM0[38]
sw t1, 0(s5)
sw a1, 0(s6)
lw s8, 28(s2)     # preload SRAM0[7] for next group (m=7)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 152(s2)
sw t3, 216(s2)

# Group m=7: twiddle W[14]

# Butterfly 0: (7,23)
lw t1, 92(s2)     # SRAM0[23]
sw s8, 0(s4)
sw t1, 0(s5)
sw a2, 0(s6)
lw s8, 156(s2)    # preload SRAM0[39]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 28(s2)
sw t3, 92(s2)

# Butterfly 1: (39,55)
lw t1, 220(s2)    # SRAM0[55]
sw s8, 0(s4)      # SRAM0[39]
sw t1, 0(s5)
sw a2, 0(s6)
lw s8, 32(s2)     # preload SRAM0[8] for next group (m=8)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 156(s2)
sw t3, 220(s2)

# Group m=8: twiddle W[16]

# Butterfly 0: (8,24)
lw t1, 96(s2)     # SRAM0[24]
sw s8, 0(s4)
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 160(s2)    # preload SRAM0[40]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 32(s2)
sw t3, 96(s2)

# Butterfly 1: (40,56)
lw t1, 224(s2)    # SRAM0[56]
sw s8, 0(s4)      # SRAM0[40]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 36(s2)     # preload SRAM0[9] for next group (m=9)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 160(s2)
sw t3, 224(s2)

# Group m=9: twiddle W[18]

# Butterfly 0: (9,25)
lw t1, 100(s2)    # SRAM0[25]
sw s8, 0(s4)
sw t1, 0(s5)
sw a4, 0(s6)
lw s8, 164(s2)    # preload SRAM0[41]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 36(s2)
sw t3, 100(s2)

# Butterfly 1: (41,57)
lw t1, 228(s2)    # SRAM0[57]
sw s8, 0(s4)      # SRAM0[41]
sw t1, 0(s5)
sw a4, 0(s6)
lw s8, 40(s2)     # preload SRAM0[10] for next group (m=10)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 164(s2)
sw t3, 228(s2)

# Group m=10: twiddle W[20]

# Butterfly 0: (10,26)
lw t1, 104(s2)    # SRAM0[26]
sw s8, 0(s4)
sw t1, 0(s5)
sw a5, 0(s6)
lw s8, 168(s2)    # preload SRAM0[42]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 40(s2)
sw t3, 104(s2)

# Butterfly 1: (42,58)
lw t1, 232(s2)    # SRAM0[58]
sw s8, 0(s4)      # SRAM0[42]
sw t1, 0(s5)
sw a5, 0(s6)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 168(s2)
sw t3, 232(s2)

add x0, x0, x0
add x0, x0, x0
add x0, x0, x0
add x0, x0, x0


#------------------------------------------------
# Stage_5: 
#------------------------------------------------

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
add x0, x0, x0
add x0, x0, x0
lw      t5,     88(s2)          # t5 = SRAM_0[22] (store for next m)
lw      t6,     216(s2)         # t6 = SRAM_0[54] (store for next m)

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
sw      t5,     88(s1)          # SRAM_I/O[22] = X (from m=22)
sw      t6,     216(s1)         # SRAM_I/O[54] = Y (from m=22)
lw      t5,     92(s2)          # t5 = SRAM_0[23] (store for next m)
lw      t6,     220(s2)         # t6 = SRAM_0[55] (store for next m)

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
sw      t5,     92(s1)          # SRAM_I/O[23] = X (from m=23)
sw      t6,     220(s1)         # SRAM_I/O[55] = Y (from m=23)
lw      t5,     96(s2)          # t5 = SRAM_0[24] (store for next m)
lw      t6,     224(s2)         # t6 = SRAM_0[56] (store for next m)

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
sw      t5,     96(s1)          # SRAM_I/O[24] = X (from m=24)
sw      t6,     224(s1)         # SRAM_I/O[56] = Y (from m=24)
lw      t5,     100(s2)         # t5 = SRAM_0[25] (store for next m)
lw      t6,     228(s2)         # t6 = SRAM_0[57] (store for next m)

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
sw      t5,     100(s1)         # SRAM_I/O[25] = X (from m=25)
sw      t6,     228(s1)         # SRAM_I/O[57] = Y (from m=25)
lw      t5,     104(s2)         # t5 = SRAM_0[26] (store for next m)
lw      t6,     232(s2)         # t6 = SRAM_0[58] (store for next m)

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
sw      t5,     104(s1)         # SRAM_I/O[26] = X (from m=26)
sw      t6,     232(s1)         # SRAM_I/O[58] = Y (from m=26)
lw      t5,     108(s2)         # t5 = SRAM_0[27] (store for next m)
lw      t6,     236(s2)         # t6 = SRAM_0[59] (store for next m)

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
sw      t5,     108(s1)         # SRAM_I/O[27] = X (from m=27)
sw      t6,     236(s1)         # SRAM_I/O[59] = Y (from m=27)
lw      t5,     112(s2)         # t5 = SRAM_0[28] (store for next m)
lw      t6,     240(s2)         # t6 = SRAM_0[60] (store for next m)

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
sw      t5,     112(s1)         # SRAM_I/O[28] = X (from m=28)
sw      t6,     240(s1)         # SRAM_I/O[60] = Y (from m=28)
lw      t5,     116(s2)         # t5 = SRAM_0[29] (store for next m)
lw      t6,     244(s2)         # t6 = SRAM_0[61] (store for next m)

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
sw      t5,     116(s1)         # SRAM_I/O[29] = X (from m=29)
sw      t6,     244(s1)         # SRAM_I/O[61] = Y (from m=29)
lw      t5,     120(s2)         # t5 = SRAM_0[30] (store for next m)
lw      t6,     248(s2)         # t6 = SRAM_0[62] (store for next m)

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
sw      t5,     120(s1)         # SRAM_I/O[30] = X (from m=30)
sw      t6,     248(s1)         # SRAM_I/O[62] = Y (from m=30)
lw      t5,     124(s2)         # t5 = SRAM_0[31] (store for final)
lw      t6,     252(s2)         # t6 = SRAM_0[63] (store for final)

add x0, x0, x0
add x0, x0, x0
add x0, x0, x0

# Final store for m=31
sw      t5,     124(s1)         # SRAM_I/O[31] = X (from m=31)
sw      t6,     252(s1)         # SRAM_I/O[63] = Y (from m=31)

add x0, x0, x0
add x0, x0, x0
add x0, x0, x0
add x0, x0, x0
add x0, x0, x0


#set1 start_fft
addi s0, s0, 256
addi s1, s1, 256

#twiddle 선언
lw s7, 0(s3)  # w[0]

#------------------------------------------------
# Stage_0: SRAM_I/O --> SRAM_0 (Bit-Reversed) --> FFT_engine (Dpath_reg)
#------------------------------------------------
# Butterfly 0: SRAM_0[0], SRAM_0[1] with W[0]
lw t0, 0(s0)        # t0 = SRAM_IO[0]
lw t1, 128(s0)      # t1 = SRAM_IO[32]

sw t0, 0(s2)        # SRAM_0[0] = SRAM_IO[0]
sw t1, 4(s2)        # SRAM_0[1] = SRAM_IO[32]
add x0, x0, x0
lw t2, 0(s2)        # t2 = SRAM_0[0]
lw t3, 4(s2)        # t3 = SRAM_0[1]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[0]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[1]
sw s7, 0(s6)        # dpath_reg_2 = W[0]
lw s9, 8(s3)        # twiddle load
lw t0, 64(s0)       # Preload t0 = SRAM_IO[16] for Butterfly 1
lw t1, 192(s0)      # Preload t1 = SRAM_IO[48] for Butterfly 1
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 0(s2)        # SRAM_0[0] = X
sw t3, 4(s2)        # SRAM_0[1] = Y

# Butterfly 1: SRAM_0[2], SRAM_0[3] with W[0]
sw t0, 8(s2)        # SRAM_0[2] = SRAM_IO[16] (preloaded)
sw t1, 12(s2)       # SRAM_0[3] = SRAM_IO[48] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 8(s2)        # t2 = SRAM_0[2]
lw t3, 12(s2)       # t3 = SRAM_0[3]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[2]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[3]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw s10, 16(s3)
lw t0, 32(s0)       # Preload t0 = SRAM_IO[8] for Butterfly 2
lw t1, 160(s0)      # Preload t1 = SRAM_IO[40] for Butterfly 2
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 8(s2)        # SRAM_0[2] = X
sw t3, 12(s2)       # SRAM_0[3] = Y

# Butterfly 2: SRAM_0[4], SRAM_0[5] with W[0]
sw t0, 16(s2)       # SRAM_0[4] = SRAM_IO[8] (preloaded)
sw t1, 20(s2)       # SRAM_0[5] = SRAM_IO[40] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 16(s2)       # t2 = SRAM_0[4]
lw t3, 20(s2)       # t3 = SRAM_0[5]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[4]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[5]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw s11, 24(s3)
lw t0, 96(s0)       # Preload t0 = SRAM_IO[24] for Butterfly 3
lw t1, 224(s0)      # Preload t1 = SRAM_IO[56] for Butterfly 3
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 16(s2)       # SRAM_0[4] = X
sw t3, 20(s2)       # SRAM_0[5] = Y

# Butterfly 3: SRAM_0[6], SRAM_0[7] with W[0]
sw t0, 24(s2)       # SRAM_0[6] = SRAM_IO[24] (preloaded)
sw t1, 28(s2)       # SRAM_0[7] = SRAM_IO[56] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 24(s2)       # t2 = SRAM_0[6]
lw t3, 28(s2)       # t3 = SRAM_0[7]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[6]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[7]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw t6, 32(s3)
lw t0, 16(s0)       # Preload t0 = SRAM_IO[4] for Butterfly 4
lw t1, 144(s0)      # Preload t1 = SRAM_IO[36] for Butterfly 4
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 24(s2)       # SRAM_0[6] = X
sw t3, 28(s2)       # SRAM_0[7] = Y

# Butterfly 4: SRAM_0[8], SRAM_0[9] with W[0]
sw t0, 32(s2)       # SRAM_0[8] = SRAM_IO[4] (preloaded)
sw t1, 36(s2)       # SRAM_0[9] = SRAM_IO[36] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 32(s2)       # t2 = SRAM_0[8]
lw t3, 36(s2)       # t3 = SRAM_0[9]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[8]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[9]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a0, 40(s3)
lw t0, 80(s0)       # Preload t0 = SRAM_IO[20] for Butterfly 5
lw t1, 208(s0)      # Preload t1 = SRAM_IO[52] for Butterfly 5
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 32(s2)       # SRAM_0[8] = X
sw t3, 36(s2)       # SRAM_0[9] = Y

# Butterfly 5: SRAM_0[10], SRAM_0[11] with W[0]
sw t0, 40(s2)       # SRAM_0[10] = SRAM_IO[20] (preloaded)
sw t1, 44(s2)       # SRAM_0[11] = SRAM_IO[52] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 40(s2)       # t2 = SRAM_0[10]
lw t3, 44(s2)       # t3 = SRAM_0[11]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[10]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[11]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a1, 48(s3)
lw t0, 48(s0)       # Preload t0 = SRAM_IO[12] for Butterfly 6
lw t1, 176(s0)      # Preload t1 = SRAM_IO[44] for Butterfly 6
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 40(s2)       # SRAM_0[10] = X
sw t3, 44(s2)       # SRAM_0[11] = Y

# Butterfly 6: SRAM_0[12], SRAM_0[13] with W[0]
sw t0, 48(s2)       # SRAM_0[12] = SRAM_IO[12] (preloaded)
sw t1, 52(s2)       # SRAM_0[13] = SRAM_IO[44] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 48(s2)       # t2 = SRAM_0[12]
lw t3, 52(s2)       # t3 = SRAM_0[13]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[12]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[13]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a2, 56(s3)
lw t0, 112(s0)      # Preload t0 = SRAM_IO[28] for Butterfly 7
lw t1, 240(s0)      # Preload t1 = SRAM_IO[60] for Butterfly 7
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 48(s2)       # SRAM_0[12] = X
sw t3, 52(s2)       # SRAM_0[13] = Y

# Butterfly 7: SRAM_0[14], SRAM_0[15] with W[0]
sw t0, 56(s2)       # SRAM_0[14] = SRAM_IO[28] (preloaded)
sw t1, 60(s2)       # SRAM_0[15] = SRAM_IO[60] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 56(s2)       # t2 = SRAM_0[14]
lw t3, 60(s2)       # t3 = SRAM_0[15]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[14]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[15]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a3, 64(s3)
lw t0, 8(s0)        # Preload t0 = SRAM_IO[2] for Butterfly 8
lw t1, 136(s0)      # Preload t1 = SRAM_IO[34] for Butterfly 8
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 56(s2)       # SRAM_0[14] = X
sw t3, 60(s2)       # SRAM_0[15] = Y

# Butterfly 8: SRAM_0[16], SRAM_0[17] with W[0]
sw t0, 64(s2)       # SRAM_0[16] = SRAM_IO[2] (preloaded)
sw t1, 68(s2)       # SRAM_0[17] = SRAM_IO[34] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 64(s2)       # t2 = SRAM_0[16]
lw t3, 68(s2)       # t3 = SRAM_0[17]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[16]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[17]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a4, 72(s3)
lw t0, 72(s0)       # Preload t0 = SRAM_IO[18] for Butterfly 9
lw t1, 200(s0)      # Preload t1 = SRAM_IO[50] for Butterfly 9
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 64(s2)       # SRAM_0[16] = X
sw t3, 68(s2)       # SRAM_0[17] = Y

# Butterfly 9: SRAM_0[18], SRAM_0[19] with W[0]
sw t0, 72(s2)       # SRAM_0[18] = SRAM_IO[18] (preloaded)
sw t1, 76(s2)       # SRAM_0[19] = SRAM_IO[50] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 72(s2)       # t2 = SRAM_0[18]
lw t3, 76(s2)       # t3 = SRAM_0[19]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[18]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[19]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a5, 80(s3)
lw t0, 40(s0)       # Preload t0 = SRAM_IO[10] for Butterfly 10
lw t1, 168(s0)      # Preload t1 = SRAM_IO[42] for Butterfly 10
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 72(s2)       # SRAM_0[18] = X
sw t3, 76(s2)       # SRAM_0[19] = Y

# Butterfly 10: SRAM_0[20], SRAM_0[21] with W[0]
sw t0, 80(s2)       # SRAM_0[20] = SRAM_IO[10] (preloaded)
sw t1, 84(s2)       # SRAM_0[21] = SRAM_IO[42] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 80(s2)       # t2 = SRAM_0[20]
lw t3, 84(s2)       # t3 = SRAM_0[21]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[20]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[21]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a6, 88(s3)
lw a7, 96(s3)
lw ra, 104(s3)
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 80(s2)       # SRAM_0[20] = X
sw t3, 84(s2)       # SRAM_0[21] = Y

lw sp, 112(s3)
lw gp, 120(s3)

add x0, x0, x0

#------------------------------------------------
# Stage_1: SRAM_0 <--> FFT_engine (32 butterflies)
#------------------------------------------------
 # m=0 group: twiddle factor W[0], butterflies (0,2), (4,6), ..., (60,62)

lw t0, 176(s2)
# Butterfly 11: (44,46)
lw t1, 184(s2)   # load SRAM0[46]
sw t0, 0(s4)     
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 192(s2)   # preload SRAM0[48]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 176(s2)   # store to SRAM0[44]
sw t3, 184(s2)   # store to SRAM0[46]

# Butterfly 12: (48,50)
lw t1, 200(s2)   # load SRAM0[50]
sw s8, 0(s4)     # store preloaded SRAM0[48]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 208(s2)   # preload SRAM0[52]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 192(s2)   # store to SRAM0[48]
sw t3, 200(s2)   # store to SRAM0[50]

# Butterfly 13: (52,54)
lw t1, 216(s2)   # load SRAM0[54]
sw s8, 0(s4)     # store preloaded SRAM0[52]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 224(s2)   # preload SRAM0[56]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 208(s2)   # store to SRAM0[52]
sw t3, 216(s2)   # store to SRAM0[54]

# Butterfly 14: (56,58)
lw t1, 232(s2)   # load SRAM0[58]
sw s8, 0(s4)     # store preloaded SRAM0[56]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 240(s2)   # preload SRAM0[60]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 224(s2)   # store to SRAM0[56]
sw t3, 232(s2)   # store to SRAM0[58]

# Butterfly 15: (60,62)
lw t1, 248(s2)   # load SRAM0[62]
sw s8, 0(s4)     # store preloaded SRAM0[60]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 4(s2)     # preload SRAM0[1] for next group (m=1)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 240(s2)   # store to SRAM0[60]
sw t3, 248(s2)   # store to SRAM0[62]

# m=1 group: twiddle factor W[16], butterflies (1,3), (5,7), ..., (61,63)

# Butterfly 0: (1,3)
lw t1, 12(s2)    # load SRAM0[3]
sw s8, 0(s4)
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 20(s2)    # preload SRAM0[5]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 4(s2)     # store to SRAM0[1]
sw t3, 12(s2)    # store to SRAM0[3]

# Butterfly 1: (5,7)
lw t1, 28(s2)    # load SRAM0[7]
sw s8, 0(s4)     # store preloaded SRAM0[5]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 36(s2)    # preload SRAM0[9]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 20(s2)    # store to SRAM0[5]
sw t3, 28(s2)    # store to SRAM0[7]

# Butterfly 2: (9,11)
lw t1, 44(s2)    # load SRAM0[11]
sw s8, 0(s4)     # store preloaded SRAM0[9]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 52(s2)    # preload SRAM0[13]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 36(s2)    # store to SRAM0[9]
sw t3, 44(s2)    # store to SRAM0[11]

# Butterfly 3: (13,15)
lw t1, 60(s2)    # load SRAM0[15]
sw s8, 0(s4)     # store preloaded SRAM0[13]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 68(s2)    # preload SRAM0[17]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 52(s2)    # store to SRAM0[13]
sw t3, 60(s2)    # store to SRAM0[15]

# Butterfly 4: (17,19)
lw t1, 76(s2)    # load SRAM0[19]
sw s8, 0(s4)     # store preloaded SRAM0[17]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 84(s2)    # preload SRAM0[21]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 68(s2)    # store to SRAM0[17]
sw t3, 76(s2)    # store to SRAM0[19]

# Butterfly 5: (21,23)
lw t1, 92(s2)    # load SRAM0[23]
sw s8, 0(s4)     # store preloaded SRAM0[21]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 200(s2)    # preload SRAM0[50]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 84(s2)    # store to SRAM0[21]
sw t3, 92(s2)    # store to SRAM0[23]


# Stage_2: s=2, d=4, g=4, b=8, twiddle W[m*8]

# Group m=0: twiddle W[0]

# Butterfly 6: (50,54)
lw t1, 216(s2)    # SRAM0[54]
sw s8, 0(s4)      # SRAM0[50]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 232(s2)    # preload SRAM0[58]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 200(s2)
sw t3, 216(s2)

# Butterfly 7: (58,62)
lw t1, 248(s2)    # SRAM0[62]
sw s8, 0(s4)      # SRAM0[58]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 12(s2)     # preload SRAM0[3] for next group (m=3)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 232(s2)
sw t3, 248(s2)

# Group m=3: twiddle W[24]

# Butterfly 0: (3,7)
lw t1, 28(s2)     # SRAM0[7]
sw s8, 0(s4)
sw t1, 0(s5)
sw a7, 0(s6)
lw s8, 44(s2)     # preload SRAM0[11]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 12(s2)
sw t3, 28(s2)

# Butterfly 1: (11,15)
lw t1, 60(s2)     # SRAM0[15]
sw s8, 0(s4)      # SRAM0[11]
sw t1, 0(s5)
sw a7, 0(s6)
lw s8, 76(s2)     # preload SRAM0[19]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 44(s2)
sw t3, 60(s2)

# Butterfly 2: (19,23)
lw t1, 92(s2)     # SRAM0[23]
sw s8, 0(s4)      # SRAM0[19]
sw t1, 0(s5)
sw a7, 0(s6)
lw s8, 108(s2)    # preload SRAM0[27]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 76(s2)
sw t3, 92(s2)

# Butterfly 3: (27,31)
lw t1, 124(s2)    # SRAM0[31]
sw s8, 0(s4)      # SRAM0[27]
sw t1, 0(s5)
sw a7, 0(s6)
lw s8, 140(s2)    # preload SRAM0[35]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 108(s2)
sw t3, 124(s2)

# Butterfly 4: (35,39)
lw t1, 156(s2)    # SRAM0[39]
sw s8, 0(s4)      # SRAM0[35]
sw t1, 0(s5)
sw a7, 0(s6)
lw s8, 172(s2)    # preload SRAM0[43]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 140(s2)
sw t3, 156(s2)

# Butterfly 5: (43,47)
lw t1, 188(s2)    # SRAM0[47]
sw s8, 0(s4)      # SRAM0[43]
sw t1, 0(s5)
sw a7, 0(s6)
lw s8, 204(s2)    # preload SRAM0[51]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 172(s2)
sw t3, 188(s2)

# Butterfly 6: (51,55)
lw t1, 220(s2)    # SRAM0[55]
sw s8, 0(s4)      # SRAM0[51]
sw t1, 0(s5)
sw a7, 0(s6)
lw s8, 236(s2)    # preload SRAM0[59]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 204(s2)
sw t3, 220(s2)

# Butterfly 7: (59,63)
lw t1, 252(s2)    # SRAM0[63]
sw s8, 0(s4)      # SRAM0[59]
sw t1, 0(s5)
sw a7, 0(s6)
lw s8, 0(s2)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 236(s2)
sw t3, 252(s2)

# Stage_3: s=3, d=8, g=8, b=4, twiddle W[m*4]

# Group m=0: twiddle W[0]

# Butterfly 0: (0,8)
lw t1, 32(s2)     # SRAM0[8]
sw s8, 0(s4)
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 64(s2)     # preload SRAM0[16]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 0(s2)
sw t3, 32(s2)

# Butterfly 1: (16,24)
lw t1, 96(s2)     # SRAM0[24]
sw s8, 0(s4)      # SRAM0[16]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 128(s2)    # preload SRAM0[32]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 64(s2)
sw t3, 96(s2)

# Butterfly 2: (32,40)
lw t1, 160(s2)    # SRAM0[40]
sw s8, 0(s4)      # SRAM0[32]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 192(s2)    # preload SRAM0[48]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 128(s2)
sw t3, 160(s2)

# Butterfly 3: (48,56)
lw t1, 224(s2)    # SRAM0[56]
sw s8, 0(s4)      # SRAM0[48]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 4(s2)      # preload SRAM0[1] for next group (m=1)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 192(s2)
sw t3, 224(s2)

# Group m=1: twiddle W[4]

# Butterfly 0: (1,9)
lw t1, 36(s2)     # SRAM0[9]
sw s8, 0(s4)
sw t1, 0(s5)
sw s10, 0(s6)
lw s8, 68(s2)     # preload SRAM0[17]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 4(s2)
sw t3, 36(s2)

# Butterfly 1: (17,25)
lw t1, 100(s2)    # SRAM0[25]
sw s8, 0(s4)      # SRAM0[17]
sw t1, 0(s5)
sw s10, 0(s6)
lw s8, 132(s2)    # preload SRAM0[33]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 68(s2)
sw t3, 100(s2)

# Butterfly 2: (33,41)
lw t1, 164(s2)    # SRAM0[41]
sw s8, 0(s4)      # SRAM0[33]
sw t1, 0(s5)
sw s10, 0(s6)
lw s8, 196(s2)    # preload SRAM0[49]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 132(s2)
sw t3, 164(s2)

# Butterfly 3: (49,57)
lw t1, 228(s2)    # SRAM0[57]
sw s8, 0(s4)      # SRAM0[49]
sw t1, 0(s5)
sw s10, 0(s6)
lw s8, 8(s2)      # preload SRAM0[2] for next group (m=2)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 196(s2)
sw t3, 228(s2)

# Group m=2: twiddle W[8]

# Butterfly 0: (2,10)
lw t1, 40(s2)     # SRAM0[10]
sw s8, 0(s4)
sw t1, 0(s5)
sw t6, 0(s6)
lw s8, 72(s2)     # preload SRAM0[18]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 8(s2)
sw t3, 40(s2)

# Butterfly 1: (18,26)
lw t1, 104(s2)    # SRAM0[26]
sw s8, 0(s4)      # SRAM0[18]
sw t1, 0(s5)
sw t6, 0(s6)
lw s8, 136(s2)    # preload SRAM0[34]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 72(s2)
sw t3, 104(s2)

# Butterfly 2: (34,42)
lw t1, 168(s2)    # SRAM0[42]
sw s8, 0(s4)      # SRAM0[34]
sw t1, 0(s5)
sw t6, 0(s6)
lw s8, 148(s2)    # preload SRAM0[37]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 136(s2)
sw t3, 168(s2)

# Stage_4: s=4, d=16, g=16, b=2, twiddle W[m*2]

# Group m=0: twiddle W[0]

# Butterfly 1: (37,53)
lw t1, 212(s2)    # SRAM0[53]
sw s8, 0(s4)      # SRAM0[37]
sw t1, 0(s5)
sw a0, 0(s6)
lw s8, 24(s2)     # preload SRAM0[6] for next group (m=6)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 148(s2)
sw t3, 212(s2)

# Group m=6: twiddle W[12]

# Butterfly 0: (6,22)
lw t1, 88(s2)     # SRAM0[22]
sw s8, 0(s4)
sw t1, 0(s5)
sw a1, 0(s6)
lw s8, 152(s2)    # preload SRAM0[38]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 24(s2)
sw t3, 88(s2)

# Butterfly 1: (38,54)
lw t1, 216(s2)    # SRAM0[54]
sw s8, 0(s4)      # SRAM0[38]
sw t1, 0(s5)
sw a1, 0(s6)
lw s8, 28(s2)     # preload SRAM0[7] for next group (m=7)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 152(s2)
sw t3, 216(s2)

# Group m=7: twiddle W[14]

# Butterfly 0: (7,23)
lw t1, 92(s2)     # SRAM0[23]
sw s8, 0(s4)
sw t1, 0(s5)
sw a2, 0(s6)
lw s8, 156(s2)    # preload SRAM0[39]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 28(s2)
sw t3, 92(s2)

# Butterfly 1: (39,55)
lw t1, 220(s2)    # SRAM0[55]
sw s8, 0(s4)      # SRAM0[39]
sw t1, 0(s5)
sw a2, 0(s6)
lw s8, 32(s2)     # preload SRAM0[8] for next group (m=8)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 156(s2)
sw t3, 220(s2)

# Group m=8: twiddle W[16]

# Butterfly 0: (8,24)
lw t1, 96(s2)     # SRAM0[24]
sw s8, 0(s4)
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 160(s2)    # preload SRAM0[40]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 32(s2)
sw t3, 96(s2)

# Butterfly 1: (40,56)
lw t1, 224(s2)    # SRAM0[56]
sw s8, 0(s4)      # SRAM0[40]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 36(s2)     # preload SRAM0[9] for next group (m=9)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 160(s2)
sw t3, 224(s2)

# Group m=9: twiddle W[18]

# Butterfly 0: (9,25)
lw t1, 100(s2)    # SRAM0[25]
sw s8, 0(s4)
sw t1, 0(s5)
sw a4, 0(s6)
lw s8, 164(s2)    # preload SRAM0[41]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 36(s2)
sw t3, 100(s2)

# Butterfly 1: (41,57)
lw t1, 228(s2)    # SRAM0[57]
sw s8, 0(s4)      # SRAM0[41]
sw t1, 0(s5)
sw a4, 0(s6)
lw s8, 40(s2)     # preload SRAM0[10] for next group (m=10)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 164(s2)
sw t3, 228(s2)

# Group m=10: twiddle W[20]

# Butterfly 0: (10,26)
lw t1, 104(s2)    # SRAM0[26]
sw s8, 0(s4)
sw t1, 0(s5)
sw a5, 0(s6)
lw s8, 168(s2)    # preload SRAM0[42]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 40(s2)
sw t3, 104(s2)

# Butterfly 1: (42,58)
lw t1, 232(s2)    # SRAM0[58]
sw s8, 0(s4)      # SRAM0[42]
sw t1, 0(s5)
sw a5, 0(s6)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 168(s2)
sw t3, 232(s2)

add x0, x0, x0
add x0, x0, x0
add x0, x0, x0
add x0, x0, x0


#------------------------------------------------
# Stage_5: 
#------------------------------------------------

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
add x0, x0, x0
add x0, x0, x0
lw      t5,     88(s2)          # t5 = SRAM_0[22] (store for next m)
lw      t6,     216(s2)         # t6 = SRAM_0[54] (store for next m)

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
sw      t5,     88(s1)          # SRAM_I/O[22] = X (from m=22)
sw      t6,     216(s1)         # SRAM_I/O[54] = Y (from m=22)
lw      t5,     92(s2)          # t5 = SRAM_0[23] (store for next m)
lw      t6,     220(s2)         # t6 = SRAM_0[55] (store for next m)

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
sw      t5,     92(s1)          # SRAM_I/O[23] = X (from m=23)
sw      t6,     220(s1)         # SRAM_I/O[55] = Y (from m=23)
lw      t5,     96(s2)          # t5 = SRAM_0[24] (store for next m)
lw      t6,     224(s2)         # t6 = SRAM_0[56] (store for next m)

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
sw      t5,     96(s1)          # SRAM_I/O[24] = X (from m=24)
sw      t6,     224(s1)         # SRAM_I/O[56] = Y (from m=24)
lw      t5,     100(s2)         # t5 = SRAM_0[25] (store for next m)
lw      t6,     228(s2)         # t6 = SRAM_0[57] (store for next m)

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
sw      t5,     100(s1)         # SRAM_I/O[25] = X (from m=25)
sw      t6,     228(s1)         # SRAM_I/O[57] = Y (from m=25)
lw      t5,     104(s2)         # t5 = SRAM_0[26] (store for next m)
lw      t6,     232(s2)         # t6 = SRAM_0[58] (store for next m)

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
sw      t5,     104(s1)         # SRAM_I/O[26] = X (from m=26)
sw      t6,     232(s1)         # SRAM_I/O[58] = Y (from m=26)
lw      t5,     108(s2)         # t5 = SRAM_0[27] (store for next m)
lw      t6,     236(s2)         # t6 = SRAM_0[59] (store for next m)

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
sw      t5,     108(s1)         # SRAM_I/O[27] = X (from m=27)
sw      t6,     236(s1)         # SRAM_I/O[59] = Y (from m=27)
lw      t5,     112(s2)         # t5 = SRAM_0[28] (store for next m)
lw      t6,     240(s2)         # t6 = SRAM_0[60] (store for next m)

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
sw      t5,     112(s1)         # SRAM_I/O[28] = X (from m=28)
sw      t6,     240(s1)         # SRAM_I/O[60] = Y (from m=28)
lw      t5,     116(s2)         # t5 = SRAM_0[29] (store for next m)
lw      t6,     244(s2)         # t6 = SRAM_0[61] (store for next m)

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
sw      t5,     116(s1)         # SRAM_I/O[29] = X (from m=29)
sw      t6,     244(s1)         # SRAM_I/O[61] = Y (from m=29)
lw      t5,     120(s2)         # t5 = SRAM_0[30] (store for next m)
lw      t6,     248(s2)         # t6 = SRAM_0[62] (store for next m)

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
sw      t5,     120(s1)         # SRAM_I/O[30] = X (from m=30)
sw      t6,     248(s1)         # SRAM_I/O[62] = Y (from m=30)
lw      t5,     124(s2)         # t5 = SRAM_0[31] (store for final)
lw      t6,     252(s2)         # t6 = SRAM_0[63] (store for final)

add x0, x0, x0
add x0, x0, x0
add x0, x0, x0

# Final store for m=31
sw      t5,     124(s1)         # SRAM_I/O[31] = X (from m=31)
sw      t6,     252(s1)         # SRAM_I/O[63] = Y (from m=31)

add x0, x0, x0
add x0, x0, x0
add x0, x0, x0
add x0, x0, x0
add x0, x0, x0


#set1 start_fft
addi s0, s0, 256
addi s1, s1, 256

#twiddle 선언
lw s7, 0(s3)  # w[0]

#------------------------------------------------
# Stage_0: SRAM_I/O --> SRAM_0 (Bit-Reversed) --> FFT_engine (Dpath_reg)
#------------------------------------------------
# Butterfly 0: SRAM_0[0], SRAM_0[1] with W[0]
lw t0, 0(s0)        # t0 = SRAM_IO[0]
lw t1, 128(s0)      # t1 = SRAM_IO[32]

sw t0, 0(s2)        # SRAM_0[0] = SRAM_IO[0]
sw t1, 4(s2)        # SRAM_0[1] = SRAM_IO[32]
add x0, x0, x0
lw t2, 0(s2)        # t2 = SRAM_0[0]
lw t3, 4(s2)        # t3 = SRAM_0[1]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[0]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[1]
sw s7, 0(s6)        # dpath_reg_2 = W[0]
lw s9, 8(s3)        # twiddle load
lw t0, 64(s0)       # Preload t0 = SRAM_IO[16] for Butterfly 1
lw t1, 192(s0)      # Preload t1 = SRAM_IO[48] for Butterfly 1
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 0(s2)        # SRAM_0[0] = X
sw t3, 4(s2)        # SRAM_0[1] = Y

# Butterfly 1: SRAM_0[2], SRAM_0[3] with W[0]
sw t0, 8(s2)        # SRAM_0[2] = SRAM_IO[16] (preloaded)
sw t1, 12(s2)       # SRAM_0[3] = SRAM_IO[48] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 8(s2)        # t2 = SRAM_0[2]
lw t3, 12(s2)       # t3 = SRAM_0[3]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[2]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[3]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw s10, 16(s3)
lw t0, 32(s0)       # Preload t0 = SRAM_IO[8] for Butterfly 2
lw t1, 160(s0)      # Preload t1 = SRAM_IO[40] for Butterfly 2
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 8(s2)        # SRAM_0[2] = X
sw t3, 12(s2)       # SRAM_0[3] = Y

# Butterfly 2: SRAM_0[4], SRAM_0[5] with W[0]
sw t0, 16(s2)       # SRAM_0[4] = SRAM_IO[8] (preloaded)
sw t1, 20(s2)       # SRAM_0[5] = SRAM_IO[40] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 16(s2)       # t2 = SRAM_0[4]
lw t3, 20(s2)       # t3 = SRAM_0[5]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[4]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[5]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw s11, 24(s3)
lw t0, 96(s0)       # Preload t0 = SRAM_IO[24] for Butterfly 3
lw t1, 224(s0)      # Preload t1 = SRAM_IO[56] for Butterfly 3
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 16(s2)       # SRAM_0[4] = X
sw t3, 20(s2)       # SRAM_0[5] = Y

# Butterfly 3: SRAM_0[6], SRAM_0[7] with W[0]
sw t0, 24(s2)       # SRAM_0[6] = SRAM_IO[24] (preloaded)
sw t1, 28(s2)       # SRAM_0[7] = SRAM_IO[56] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 24(s2)       # t2 = SRAM_0[6]
lw t3, 28(s2)       # t3 = SRAM_0[7]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[6]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[7]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw t6, 32(s3)
lw t0, 16(s0)       # Preload t0 = SRAM_IO[4] for Butterfly 4
lw t1, 144(s0)      # Preload t1 = SRAM_IO[36] for Butterfly 4
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 24(s2)       # SRAM_0[6] = X
sw t3, 28(s2)       # SRAM_0[7] = Y

# Butterfly 4: SRAM_0[8], SRAM_0[9] with W[0]
sw t0, 32(s2)       # SRAM_0[8] = SRAM_IO[4] (preloaded)
sw t1, 36(s2)       # SRAM_0[9] = SRAM_IO[36] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 32(s2)       # t2 = SRAM_0[8]
lw t3, 36(s2)       # t3 = SRAM_0[9]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[8]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[9]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a0, 40(s3)
lw t0, 80(s0)       # Preload t0 = SRAM_IO[20] for Butterfly 5
lw t1, 208(s0)      # Preload t1 = SRAM_IO[52] for Butterfly 5
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 32(s2)       # SRAM_0[8] = X
sw t3, 36(s2)       # SRAM_0[9] = Y

# Butterfly 5: SRAM_0[10], SRAM_0[11] with W[0]
sw t0, 40(s2)       # SRAM_0[10] = SRAM_IO[20] (preloaded)
sw t1, 44(s2)       # SRAM_0[11] = SRAM_IO[52] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 40(s2)       # t2 = SRAM_0[10]
lw t3, 44(s2)       # t3 = SRAM_0[11]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[10]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[11]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a1, 48(s3)
lw t0, 48(s0)       # Preload t0 = SRAM_IO[12] for Butterfly 6
lw t1, 176(s0)      # Preload t1 = SRAM_IO[44] for Butterfly 6
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 40(s2)       # SRAM_0[10] = X
sw t3, 44(s2)       # SRAM_0[11] = Y

# Butterfly 6: SRAM_0[12], SRAM_0[13] with W[0]
sw t0, 48(s2)       # SRAM_0[12] = SRAM_IO[12] (preloaded)
sw t1, 52(s2)       # SRAM_0[13] = SRAM_IO[44] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 48(s2)       # t2 = SRAM_0[12]
lw t3, 52(s2)       # t3 = SRAM_0[13]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[12]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[13]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a2, 56(s3)
lw t0, 112(s0)      # Preload t0 = SRAM_IO[28] for Butterfly 7
lw t1, 240(s0)      # Preload t1 = SRAM_IO[60] for Butterfly 7
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 48(s2)       # SRAM_0[12] = X
sw t3, 52(s2)       # SRAM_0[13] = Y

# Butterfly 7: SRAM_0[14], SRAM_0[15] with W[0]
sw t0, 56(s2)       # SRAM_0[14] = SRAM_IO[28] (preloaded)
sw t1, 60(s2)       # SRAM_0[15] = SRAM_IO[60] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 56(s2)       # t2 = SRAM_0[14]
lw t3, 60(s2)       # t3 = SRAM_0[15]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[14]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[15]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a3, 64(s3)
lw t0, 8(s0)        # Preload t0 = SRAM_IO[2] for Butterfly 8
lw t1, 136(s0)      # Preload t1 = SRAM_IO[34] for Butterfly 8
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 56(s2)       # SRAM_0[14] = X
sw t3, 60(s2)       # SRAM_0[15] = Y

# Butterfly 8: SRAM_0[16], SRAM_0[17] with W[0]
sw t0, 64(s2)       # SRAM_0[16] = SRAM_IO[2] (preloaded)
sw t1, 68(s2)       # SRAM_0[17] = SRAM_IO[34] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 64(s2)       # t2 = SRAM_0[16]
lw t3, 68(s2)       # t3 = SRAM_0[17]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[16]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[17]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a4, 72(s3)
lw t0, 72(s0)       # Preload t0 = SRAM_IO[18] for Butterfly 9
lw t1, 200(s0)      # Preload t1 = SRAM_IO[50] for Butterfly 9
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 64(s2)       # SRAM_0[16] = X
sw t3, 68(s2)       # SRAM_0[17] = Y

# Butterfly 9: SRAM_0[18], SRAM_0[19] with W[0]
sw t0, 72(s2)       # SRAM_0[18] = SRAM_IO[18] (preloaded)
sw t1, 76(s2)       # SRAM_0[19] = SRAM_IO[50] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 72(s2)       # t2 = SRAM_0[18]
lw t3, 76(s2)       # t3 = SRAM_0[19]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[18]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[19]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a5, 80(s3)
lw t0, 40(s0)       # Preload t0 = SRAM_IO[10] for Butterfly 10
lw t1, 168(s0)      # Preload t1 = SRAM_IO[42] for Butterfly 10
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 72(s2)       # SRAM_0[18] = X
sw t3, 76(s2)       # SRAM_0[19] = Y

# Butterfly 10: SRAM_0[20], SRAM_0[21] with W[0]
sw t0, 80(s2)       # SRAM_0[20] = SRAM_IO[10] (preloaded)
sw t1, 84(s2)       # SRAM_0[21] = SRAM_IO[42] (preloaded)
lw t4, 0(s3)        # t4 = SRAM_W[0]
lw t2, 80(s2)       # t2 = SRAM_0[20]
lw t3, 84(s2)       # t3 = SRAM_0[21]
sw t2, 0(s4)        # dpath_reg_0 = SRAM_0[20]
sw t3, 0(s5)        # dpath_reg_1 = SRAM_0[21]
sw t4, 0(s6)        # dpath_reg_2 = W[0]
lw a6, 88(s3)
lw a7, 96(s3)
lw ra, 104(s3)
lw t2, 4(s4)        # t2 = dpath_reg_0 (X = A + WB)
lw t3, 4(s5)        # t3 = dpath_reg_1 (Y = A - WB)
sw t2, 80(s2)       # SRAM_0[20] = X
sw t3, 84(s2)       # SRAM_0[21] = Y

lw sp, 112(s3)
lw gp, 120(s3)

add x0, x0, x0

#------------------------------------------------
# Stage_1: SRAM_0 <--> FFT_engine (32 butterflies)
#------------------------------------------------
 # m=0 group: twiddle factor W[0], butterflies (0,2), (4,6), ..., (60,62)

lw t0, 176(s2)
# Butterfly 11: (44,46)
lw t1, 184(s2)   # load SRAM0[46]
sw t0, 0(s4)     
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 192(s2)   # preload SRAM0[48]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 176(s2)   # store to SRAM0[44]
sw t3, 184(s2)   # store to SRAM0[46]

# Butterfly 12: (48,50)
lw t1, 200(s2)   # load SRAM0[50]
sw s8, 0(s4)     # store preloaded SRAM0[48]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 208(s2)   # preload SRAM0[52]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 192(s2)   # store to SRAM0[48]
sw t3, 200(s2)   # store to SRAM0[50]

# Butterfly 13: (52,54)
lw t1, 216(s2)   # load SRAM0[54]
sw s8, 0(s4)     # store preloaded SRAM0[52]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 224(s2)   # preload SRAM0[56]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 208(s2)   # store to SRAM0[52]
sw t3, 216(s2)   # store to SRAM0[54]

# Butterfly 14: (56,58)
lw t1, 232(s2)   # load SRAM0[58]
sw s8, 0(s4)     # store preloaded SRAM0[56]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 240(s2)   # preload SRAM0[60]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 224(s2)   # store to SRAM0[56]
sw t3, 232(s2)   # store to SRAM0[58]

# Butterfly 15: (60,62)
lw t1, 248(s2)   # load SRAM0[62]
sw s8, 0(s4)     # store preloaded SRAM0[60]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 4(s2)     # preload SRAM0[1] for next group (m=1)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 240(s2)   # store to SRAM0[60]
sw t3, 248(s2)   # store to SRAM0[62]

# m=1 group: twiddle factor W[16], butterflies (1,3), (5,7), ..., (61,63)

# Butterfly 0: (1,3)
lw t1, 12(s2)    # load SRAM0[3]
sw s8, 0(s4)
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 20(s2)    # preload SRAM0[5]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 4(s2)     # store to SRAM0[1]
sw t3, 12(s2)    # store to SRAM0[3]

# Butterfly 1: (5,7)
lw t1, 28(s2)    # load SRAM0[7]
sw s8, 0(s4)     # store preloaded SRAM0[5]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 36(s2)    # preload SRAM0[9]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 20(s2)    # store to SRAM0[5]
sw t3, 28(s2)    # store to SRAM0[7]

# Butterfly 2: (9,11)
lw t1, 44(s2)    # load SRAM0[11]
sw s8, 0(s4)     # store preloaded SRAM0[9]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 52(s2)    # preload SRAM0[13]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 36(s2)    # store to SRAM0[9]
sw t3, 44(s2)    # store to SRAM0[11]

# Butterfly 3: (13,15)
lw t1, 60(s2)    # load SRAM0[15]
sw s8, 0(s4)     # store preloaded SRAM0[13]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 68(s2)    # preload SRAM0[17]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 52(s2)    # store to SRAM0[13]
sw t3, 60(s2)    # store to SRAM0[15]

# Butterfly 4: (17,19)
lw t1, 76(s2)    # load SRAM0[19]
sw s8, 0(s4)     # store preloaded SRAM0[17]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 84(s2)    # preload SRAM0[21]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 68(s2)    # store to SRAM0[17]
sw t3, 76(s2)    # store to SRAM0[19]

# Butterfly 5: (21,23)
lw t1, 92(s2)    # load SRAM0[23]
sw s8, 0(s4)     # store preloaded SRAM0[21]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 200(s2)    # preload SRAM0[50]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 84(s2)    # store to SRAM0[21]
sw t3, 92(s2)    # store to SRAM0[23]


# Stage_2: s=2, d=4, g=4, b=8, twiddle W[m*8]

# Group m=0: twiddle W[0]

# Butterfly 6: (50,54)
lw t1, 216(s2)    # SRAM0[54]
sw s8, 0(s4)      # SRAM0[50]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 232(s2)    # preload SRAM0[58]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 200(s2)
sw t3, 216(s2)

# Butterfly 7: (58,62)
lw t1, 248(s2)    # SRAM0[62]
sw s8, 0(s4)      # SRAM0[58]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 12(s2)     # preload SRAM0[3] for next group (m=3)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 232(s2)
sw t3, 248(s2)

# Group m=3: twiddle W[24]

# Butterfly 0: (3,7)
lw t1, 28(s2)     # SRAM0[7]
sw s8, 0(s4)
sw t1, 0(s5)
sw a7, 0(s6)
lw s8, 44(s2)     # preload SRAM0[11]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 12(s2)
sw t3, 28(s2)

# Butterfly 1: (11,15)
lw t1, 60(s2)     # SRAM0[15]
sw s8, 0(s4)      # SRAM0[11]
sw t1, 0(s5)
sw a7, 0(s6)
lw s8, 76(s2)     # preload SRAM0[19]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 44(s2)
sw t3, 60(s2)

# Butterfly 2: (19,23)
lw t1, 92(s2)     # SRAM0[23]
sw s8, 0(s4)      # SRAM0[19]
sw t1, 0(s5)
sw a7, 0(s6)
lw s8, 108(s2)    # preload SRAM0[27]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 76(s2)
sw t3, 92(s2)

# Butterfly 3: (27,31)
lw t1, 124(s2)    # SRAM0[31]
sw s8, 0(s4)      # SRAM0[27]
sw t1, 0(s5)
sw a7, 0(s6)
lw s8, 140(s2)    # preload SRAM0[35]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 108(s2)
sw t3, 124(s2)

# Butterfly 4: (35,39)
lw t1, 156(s2)    # SRAM0[39]
sw s8, 0(s4)      # SRAM0[35]
sw t1, 0(s5)
sw a7, 0(s6)
lw s8, 172(s2)    # preload SRAM0[43]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 140(s2)
sw t3, 156(s2)

# Butterfly 5: (43,47)
lw t1, 188(s2)    # SRAM0[47]
sw s8, 0(s4)      # SRAM0[43]
sw t1, 0(s5)
sw a7, 0(s6)
lw s8, 204(s2)    # preload SRAM0[51]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 172(s2)
sw t3, 188(s2)

# Butterfly 6: (51,55)
lw t1, 220(s2)    # SRAM0[55]
sw s8, 0(s4)      # SRAM0[51]
sw t1, 0(s5)
sw a7, 0(s6)
lw s8, 236(s2)    # preload SRAM0[59]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 204(s2)
sw t3, 220(s2)

# Butterfly 7: (59,63)
lw t1, 252(s2)    # SRAM0[63]
sw s8, 0(s4)      # SRAM0[59]
sw t1, 0(s5)
sw a7, 0(s6)
lw s8, 0(s2)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 236(s2)
sw t3, 252(s2)

# Stage_3: s=3, d=8, g=8, b=4, twiddle W[m*4]

# Group m=0: twiddle W[0]

# Butterfly 0: (0,8)
lw t1, 32(s2)     # SRAM0[8]
sw s8, 0(s4)
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 64(s2)     # preload SRAM0[16]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 0(s2)
sw t3, 32(s2)

# Butterfly 1: (16,24)
lw t1, 96(s2)     # SRAM0[24]
sw s8, 0(s4)      # SRAM0[16]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 128(s2)    # preload SRAM0[32]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 64(s2)
sw t3, 96(s2)

# Butterfly 2: (32,40)
lw t1, 160(s2)    # SRAM0[40]
sw s8, 0(s4)      # SRAM0[32]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 192(s2)    # preload SRAM0[48]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 128(s2)
sw t3, 160(s2)

# Butterfly 3: (48,56)
lw t1, 224(s2)    # SRAM0[56]
sw s8, 0(s4)      # SRAM0[48]
sw t1, 0(s5)
sw s7, 0(s6)
lw s8, 4(s2)      # preload SRAM0[1] for next group (m=1)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 192(s2)
sw t3, 224(s2)

# Group m=1: twiddle W[4]

# Butterfly 0: (1,9)
lw t1, 36(s2)     # SRAM0[9]
sw s8, 0(s4)
sw t1, 0(s5)
sw s10, 0(s6)
lw s8, 68(s2)     # preload SRAM0[17]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 4(s2)
sw t3, 36(s2)

# Butterfly 1: (17,25)
lw t1, 100(s2)    # SRAM0[25]
sw s8, 0(s4)      # SRAM0[17]
sw t1, 0(s5)
sw s10, 0(s6)
lw s8, 132(s2)    # preload SRAM0[33]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 68(s2)
sw t3, 100(s2)

# Butterfly 2: (33,41)
lw t1, 164(s2)    # SRAM0[41]
sw s8, 0(s4)      # SRAM0[33]
sw t1, 0(s5)
sw s10, 0(s6)
lw s8, 196(s2)    # preload SRAM0[49]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 132(s2)
sw t3, 164(s2)

# Butterfly 3: (49,57)
lw t1, 228(s2)    # SRAM0[57]
sw s8, 0(s4)      # SRAM0[49]
sw t1, 0(s5)
sw s10, 0(s6)
lw s8, 8(s2)      # preload SRAM0[2] for next group (m=2)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 196(s2)
sw t3, 228(s2)

# Group m=2: twiddle W[8]

# Butterfly 0: (2,10)
lw t1, 40(s2)     # SRAM0[10]
sw s8, 0(s4)
sw t1, 0(s5)
sw t6, 0(s6)
lw s8, 72(s2)     # preload SRAM0[18]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 8(s2)
sw t3, 40(s2)

# Butterfly 1: (18,26)
lw t1, 104(s2)    # SRAM0[26]
sw s8, 0(s4)      # SRAM0[18]
sw t1, 0(s5)
sw t6, 0(s6)
lw s8, 136(s2)    # preload SRAM0[34]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 72(s2)
sw t3, 104(s2)

# Butterfly 2: (34,42)
lw t1, 168(s2)    # SRAM0[42]
sw s8, 0(s4)      # SRAM0[34]
sw t1, 0(s5)
sw t6, 0(s6)
lw s8, 148(s2)    # preload SRAM0[37]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 136(s2)
sw t3, 168(s2)

# Stage_4: s=4, d=16, g=16, b=2, twiddle W[m*2]

# Group m=0: twiddle W[0]

# Butterfly 1: (37,53)
lw t1, 212(s2)    # SRAM0[53]
sw s8, 0(s4)      # SRAM0[37]
sw t1, 0(s5)
sw a0, 0(s6)
lw s8, 24(s2)     # preload SRAM0[6] for next group (m=6)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 148(s2)
sw t3, 212(s2)

# Group m=6: twiddle W[12]

# Butterfly 0: (6,22)
lw t1, 88(s2)     # SRAM0[22]
sw s8, 0(s4)
sw t1, 0(s5)
sw a1, 0(s6)
lw s8, 152(s2)    # preload SRAM0[38]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 24(s2)
sw t3, 88(s2)

# Butterfly 1: (38,54)
lw t1, 216(s2)    # SRAM0[54]
sw s8, 0(s4)      # SRAM0[38]
sw t1, 0(s5)
sw a1, 0(s6)
lw s8, 28(s2)     # preload SRAM0[7] for next group (m=7)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 152(s2)
sw t3, 216(s2)

# Group m=7: twiddle W[14]

# Butterfly 0: (7,23)
lw t1, 92(s2)     # SRAM0[23]
sw s8, 0(s4)
sw t1, 0(s5)
sw a2, 0(s6)
lw s8, 156(s2)    # preload SRAM0[39]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 28(s2)
sw t3, 92(s2)

# Butterfly 1: (39,55)
lw t1, 220(s2)    # SRAM0[55]
sw s8, 0(s4)      # SRAM0[39]
sw t1, 0(s5)
sw a2, 0(s6)
lw s8, 32(s2)     # preload SRAM0[8] for next group (m=8)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 156(s2)
sw t3, 220(s2)

# Group m=8: twiddle W[16]

# Butterfly 0: (8,24)
lw t1, 96(s2)     # SRAM0[24]
sw s8, 0(s4)
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 160(s2)    # preload SRAM0[40]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 32(s2)
sw t3, 96(s2)

# Butterfly 1: (40,56)
lw t1, 224(s2)    # SRAM0[56]
sw s8, 0(s4)      # SRAM0[40]
sw t1, 0(s5)
sw a3, 0(s6)
lw s8, 36(s2)     # preload SRAM0[9] for next group (m=9)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 160(s2)
sw t3, 224(s2)

# Group m=9: twiddle W[18]

# Butterfly 0: (9,25)
lw t1, 100(s2)    # SRAM0[25]
sw s8, 0(s4)
sw t1, 0(s5)
sw a4, 0(s6)
lw s8, 164(s2)    # preload SRAM0[41]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 36(s2)
sw t3, 100(s2)

# Butterfly 1: (41,57)
lw t1, 228(s2)    # SRAM0[57]
sw s8, 0(s4)      # SRAM0[41]
sw t1, 0(s5)
sw a4, 0(s6)
lw s8, 40(s2)     # preload SRAM0[10] for next group (m=10)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 164(s2)
sw t3, 228(s2)

# Group m=10: twiddle W[20]

# Butterfly 0: (10,26)
lw t1, 104(s2)    # SRAM0[26]
sw s8, 0(s4)
sw t1, 0(s5)
sw a5, 0(s6)
lw s8, 168(s2)    # preload SRAM0[42]
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 40(s2)
sw t3, 104(s2)

# Butterfly 1: (42,58)
lw t1, 232(s2)    # SRAM0[58]
sw s8, 0(s4)      # SRAM0[42]
sw t1, 0(s5)
sw a5, 0(s6)
lw t2, 4(s4)
lw t3, 4(s5)
sw t2, 168(s2)
sw t3, 232(s2)

add x0, x0, x0
add x0, x0, x0
add x0, x0, x0
add x0, x0, x0


#------------------------------------------------
# Stage_5: 
#------------------------------------------------

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
add x0, x0, x0
add x0, x0, x0
lw      t5,     88(s2)          # t5 = SRAM_0[22] (store for next m)
lw      t6,     216(s2)         # t6 = SRAM_0[54] (store for next m)

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
sw      t5,     88(s1)          # SRAM_I/O[22] = X (from m=22)
sw      t6,     216(s1)         # SRAM_I/O[54] = Y (from m=22)
lw      t5,     92(s2)          # t5 = SRAM_0[23] (store for next m)
lw      t6,     220(s2)         # t6 = SRAM_0[55] (store for next m)

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
sw      t5,     92(s1)          # SRAM_I/O[23] = X (from m=23)
sw      t6,     220(s1)         # SRAM_I/O[55] = Y (from m=23)
lw      t5,     96(s2)          # t5 = SRAM_0[24] (store for next m)
lw      t6,     224(s2)         # t6 = SRAM_0[56] (store for next m)

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
sw      t5,     96(s1)          # SRAM_I/O[24] = X (from m=24)
sw      t6,     224(s1)         # SRAM_I/O[56] = Y (from m=24)
lw      t5,     100(s2)         # t5 = SRAM_0[25] (store for next m)
lw      t6,     228(s2)         # t6 = SRAM_0[57] (store for next m)

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
sw      t5,     100(s1)         # SRAM_I/O[25] = X (from m=25)
sw      t6,     228(s1)         # SRAM_I/O[57] = Y (from m=25)
lw      t5,     104(s2)         # t5 = SRAM_0[26] (store for next m)
lw      t6,     232(s2)         # t6 = SRAM_0[58] (store for next m)

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
sw      t5,     104(s1)         # SRAM_I/O[26] = X (from m=26)
sw      t6,     232(s1)         # SRAM_I/O[58] = Y (from m=26)
lw      t5,     108(s2)         # t5 = SRAM_0[27] (store for next m)
lw      t6,     236(s2)         # t6 = SRAM_0[59] (store for next m)

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
sw      t5,     108(s1)         # SRAM_I/O[27] = X (from m=27)
sw      t6,     236(s1)         # SRAM_I/O[59] = Y (from m=27)
lw      t5,     112(s2)         # t5 = SRAM_0[28] (store for next m)
lw      t6,     240(s2)         # t6 = SRAM_0[60] (store for next m)

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
sw      t5,     112(s1)         # SRAM_I/O[28] = X (from m=28)
sw      t6,     240(s1)         # SRAM_I/O[60] = Y (from m=28)
lw      t5,     116(s2)         # t5 = SRAM_0[29] (store for next m)
lw      t6,     244(s2)         # t6 = SRAM_0[61] (store for next m)

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
sw      t5,     116(s1)         # SRAM_I/O[29] = X (from m=29)
sw      t6,     244(s1)         # SRAM_I/O[61] = Y (from m=29)
lw      t5,     120(s2)         # t5 = SRAM_0[30] (store for next m)
lw      t6,     248(s2)         # t6 = SRAM_0[62] (store for next m)

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
sw      t5,     120(s1)         # SRAM_I/O[30] = X (from m=30)
sw      t6,     248(s1)         # SRAM_I/O[62] = Y (from m=30)
lw      t5,     124(s2)         # t5 = SRAM_0[31] (store for final)
lw      t6,     252(s2)         # t6 = SRAM_0[63] (store for final)

add x0, x0, x0
add x0, x0, x0
add x0, x0, x0

# Final store for m=31
sw      t5,     124(s1)         # SRAM_I/O[31] = X (from m=31)
sw      t6,     252(s1)         # SRAM_I/O[63] = Y (from m=31)



