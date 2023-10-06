
00000000 <main>:
    0:        ff410113        addi x2 x2 -12
    4:        10000297        auipc x5 0x10000
    8:        ffc28293        addi x5 x5 -4
    c:        00512023        sw x5 0 x2
    10:        10000297        auipc x5 0x10000
    14:        00028293        addi x5 x5 0
    18:        00512223        sw x5 4 x2
    1c:        10000297        auipc x5 0x10000
    20:        00428293        addi x5 x5 4
    24:        00512423        sw x5 8 x2
    28:        00300413        addi x8 x0 3
    2c:        00000493        addi x9 x0 0
    30:        00010913        addi x18 x2 0

00000034 <main_loop>:
    34:        10000517        auipc x10 0x10000
    38:        ffc50513        addi x10 x10 -4
    3c:        00400893        addi x17 x0 4
    40:        00000073        ecall
    44:        00092503        lw x10 0 x18
    48:        00850593        addi x11 x10 8
    4c:        024000ef        jal x1 36 <hd_func>
    50:        00100893        addi x17 x0 1
    54:        00000073        ecall
    58:        00490913        addi x18 x18 4
    5c:        00148493        addi x9 x9 1
    60:        fc849ae3        bne x9 x8 -44 <main_loop>
    64:        00c10113        addi x2 x2 12
    68:        00a00893        addi x17 x0 10
    6c:        00000073        ecall

00000070 <hd_func>:
    70:        fdc10113        addi x2 x2 -36
    74:        00112023        sw x1 0 x2
    78:        00812223        sw x8 4 x2
    7c:        00912423        sw x9 8 x2
    80:        01212623        sw x18 12 x2
    84:        01312823        sw x19 16 x2
    88:        01412a23        sw x20 20 x2
    8c:        01512c23        sw x21 24 x2
    90:        01612e23        sw x22 28 x2
    94:        03712023        sw x23 32 x2
    98:        00050413        addi x8 x10 0
    9c:        00058493        addi x9 x11 0
    a0:        00042503        lw x10 0 x8
    a4:        00442583        lw x11 4 x8
    a8:        0e4000ef        jal x1 228 <clz>
    ac:        04000913        addi x18 x0 64
    b0:        40a90933        sub x18 x18 x10
    b4:        0004a503        lw x10 0 x9
    b8:        0044a583        lw x11 4 x9
    bc:        0d0000ef        jal x1 208 <clz>
    c0:        04000993        addi x19 x0 64
    c4:        40a989b3        sub x19 x19 x10
    c8:        00042a03        lw x20 0 x8
    cc:        00442a83        lw x21 4 x8
    d0:        0004ab03        lw x22 0 x9
    d4:        0044ab83        lw x23 4 x9
    d8:        013922b3        slt x5 x18 x19
    dc:        00029a63        bne x5 x0 20 <x1_larger>
    e0:        00000993        addi x19 x0 0
    e4:        05204663        blt x0 x18 76 <hd_cal_loop>
    e8:        00090513        addi x10 x18 0
    ec:        0180006f        jal x0 24 <hd_func_end>

000000f0 <x1_larger>:
    f0:        00098913        addi x18 x19 0
    f4:        00000993        addi x19 x0 0
    f8:        03204c63        blt x0 x18 56 <hd_cal_loop>
    fc:        00090513        addi x10 x18 0
    100:        0040006f        jal x0 4 <hd_func_end>

00000104 <hd_func_end>:
    104:        00012083        lw x1 0 x2
    108:        00412403        lw x8 4 x2
    10c:        00812483        lw x9 8 x2
    110:        00c12903        lw x18 12 x2
    114:        01012983        lw x19 16 x2
    118:        01412a03        lw x20 20 x2
    11c:        01812a83        lw x21 24 x2
    120:        01c12b03        lw x22 28 x2
    124:        02012b83        lw x23 32 x2
    128:        02410113        addi x2 x2 36
    12c:        00008067        jalr x0 x1 0

00000130 <hd_cal_loop>:
    130:        02000393        addi x7 x0 32
    134:        0123ca63        blt x7 x18 20 <hd_getLSB_upper>
    138:        00100e13        addi x28 x0 1
    13c:        01ca7eb3        and x29 x20 x28
    140:        01cb7f33        and x30 x22 x28
    144:        0100006f        jal x0 16 <hd_cal_shift>

00000148 <hd_getLSB_upper>:
    148:        00100e13        addi x28 x0 1
    14c:        01cafeb3        and x29 x21 x28
    150:        01cbff33        and x30 x23 x28

00000154 <hd_cal_shift>:
    154:        001a5293        srli x5 x20 1
    158:        01fa9313        slli x6 x21 31
    15c:        0062ea33        or x20 x5 x6
    160:        001ada93        srli x21 x21 1
    164:        001b5293        srli x5 x22 1
    168:        01fb9313        slli x6 x23 31
    16c:        0062eb33        or x22 x5 x6
    170:        001bdb93        srli x23 x23 1
    174:        01ee8463        beq x29 x30 8 <hd_check_loop>
    178:        00198993        addi x19 x19 1

0000017c <hd_check_loop>:
    17c:        fff90913        addi x18 x18 -1
    180:        fa0918e3        bne x18 x0 -80 <hd_cal_loop>
    184:        00098513        addi x10 x19 0
    188:        f7dff06f        jal x0 -132 <hd_func_end>

0000018c <clz>:
    18c:        ffc10113        addi x2 x2 -4
    190:        00112023        sw x1 0 x2
    194:        02058a63        beq x11 x0 52 <clz_lower_set_one>

00000198 <clz_upper_set_one>:
    198:        0015d313        srli x6 x11 1
    19c:        0065e5b3        or x11 x11 x6
    1a0:        0025d313        srli x6 x11 2
    1a4:        0065e5b3        or x11 x11 x6
    1a8:        0045d313        srli x6 x11 4
    1ac:        0065e5b3        or x11 x11 x6
    1b0:        0085d313        srli x6 x11 8
    1b4:        0065e5b3        or x11 x11 x6
    1b8:        0105d313        srli x6 x11 16
    1bc:        0065e5b3        or x11 x11 x6
    1c0:        fff00513        addi x10 x0 -1
    1c4:        02c0006f        jal x0 44 <clz_count_ones>

000001c8 <clz_lower_set_one>:
    1c8:        00155293        srli x5 x10 1
    1cc:        00556533        or x10 x10 x5
    1d0:        00255293        srli x5 x10 2
    1d4:        00556533        or x10 x10 x5
    1d8:        00455293        srli x5 x10 4
    1dc:        00556533        or x10 x10 x5
    1e0:        00855293        srli x5 x10 8
    1e4:        00556533        or x10 x10 x5
    1e8:        01055293        srli x5 x10 16
    1ec:        00556533        or x10 x10 x5

000001f0 <clz_count_ones>:
    1f0:        00155293        srli x5 x10 1
    1f4:        01f59313        slli x6 x11 31
    1f8:        0062e2b3        or x5 x5 x6
    1fc:        0015d313        srli x6 x11 1
    200:        555553b7        lui x7 0x55555
    204:        55538393        addi x7 x7 1365
    208:        0072f2b3        and x5 x5 x7
    20c:        00737333        and x6 x6 x7
    210:        00553e33        sltu x28 x10 x5
    214:        40550533        sub x10 x10 x5
    218:        406585b3        sub x11 x11 x6
    21c:        41c585b3        sub x11 x11 x28
    220:        00255293        srli x5 x10 2
    224:        01e59313        slli x6 x11 30
    228:        0062e2b3        or x5 x5 x6
    22c:        0025d313        srli x6 x11 2
    230:        333333b7        lui x7 0x33333
    234:        33338393        addi x7 x7 819
    238:        0072f2b3        and x5 x5 x7
    23c:        00737333        and x6 x6 x7
    240:        00757eb3        and x29 x10 x7
    244:        0075ff33        and x30 x11 x7
    248:        01d28533        add x10 x5 x29
    24c:        00553e33        sltu x28 x10 x5
    250:        01e305b3        add x11 x6 x30
    254:        01c585b3        add x11 x11 x28
    258:        00455293        srli x5 x10 4
    25c:        01c59313        slli x6 x11 28
    260:        0062e2b3        or x5 x5 x6
    264:        0045d313        srli x6 x11 4
    268:        00a282b3        add x5 x5 x10
    26c:        00a2be33        sltu x28 x5 x10
    270:        00b30333        add x6 x6 x11
    274:        01c30333        add x6 x6 x28
    278:        0f0f13b7        lui x7 0xf0f1
    27c:        f0f38393        addi x7 x7 -241
    280:        0072f533        and x10 x5 x7
    284:        007375b3        and x11 x6 x7
    288:        00855293        srli x5 x10 8
    28c:        01859313        slli x6 x11 24
    290:        0062e2b3        or x5 x5 x6
    294:        0085d313        srli x6 x11 8
    298:        00550533        add x10 x10 x5
    29c:        00553e33        sltu x28 x10 x5
    2a0:        006585b3        add x11 x11 x6
    2a4:        01c585b3        add x11 x11 x28
    2a8:        01055293        srli x5 x10 16
    2ac:        01059313        slli x6 x11 16
    2b0:        0062e2b3        or x5 x5 x6
    2b4:        0105d313        srli x6 x11 16
    2b8:        00550533        add x10 x10 x5
    2bc:        00553e33        sltu x28 x10 x5
    2c0:        006585b3        add x11 x11 x6
    2c4:        01c585b3        add x11 x11 x28
    2c8:        00058293        addi x5 x11 0
    2cc:        00000313        addi x6 x0 0
    2d0:        00550533        add x10 x10 x5
    2d4:        00553e33        sltu x28 x10 x5
    2d8:        006585b3        add x11 x11 x6
    2dc:        01c585b3        add x11 x11 x28
    2e0:        07f57513        andi x10 x10 127
    2e4:        04000293        addi x5 x0 64
    2e8:        40a28533        sub x10 x5 x10
    2ec:        00012083        lw x1 0 x2
    2f0:        00410113        addi x2 x2 4
    2f4:        00008067        jalr x0 x1 0
