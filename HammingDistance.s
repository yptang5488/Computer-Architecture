.data
    test_data_1: .dword 0x0000000000100000, 0x00000000000FFFFF # HD(1048576, 1048575) = 21
    test_data_2: .dword 0x0000000000000001, 0x7FFFFFFFFFFFFFFE # HD(1, 9223372036854775806) = 63
    test_data_3: .dword 0x000000028370228F, 0x000000028370228F # HD(10795098767, 10795098767) = 0
    msg_string: .string "\nHamming Distance="
    
.text
main:
    addi sp, sp, -12
    
    # push pointers of test data onto the stack
    la t0, test_data_1
    sw t0, 0(sp)
    la t0, test_data_2
    sw t0, 4(sp)
    la t0, test_data_3
    sw t0, 8(sp)
 
    # initialize main_loop
    addi s0, zero, 3    # s0 : number of test case
    addi s1, zero, 0    # s1 : test case counter
    addi s2, sp, 0      # s2 : points to test_data_1

main_loop:
    la a0, msg_string
    li a7, 4            # print string
    ecall
    
    lw a0, 0(s2)        # a0 : pointer to the first data in test_data_1
    addi a1, a0, 8      # a1 : pointer to the second data in test_data_1
    jal ra, hd_func
    
    # print the result #
    li a7, 1            # print integer
    ecall               # print result of hd_cal (which is in a0)
    
    addi s2, s2, 4      # s2 : points to next test_data
    addi s1, s1, 1      # counter++
    bne s1, s0, main_loop
    
    addi sp, sp, 12
    li a7, 10
    ecall

# hamming distance function
hd_func:
    addi sp, sp, -36
    sw ra, 0(sp)
    sw s0, 4(sp)        # address of x0
    sw s1, 8(sp)        # address of x1
    sw s2, 12(sp)       # digit of x0
    sw s3, 16(sp)       # digit of x1
    sw s4, 20(sp)       # lower part of x0
    sw s5, 24(sp)       # higher part of x0
    sw s6, 28(sp)       # lower part of x1
    sw s7, 32(sp)       # higher part of x1

    # get address of x0 and x1
    mv s0, a0           # s0 : address of x0
    mv s1, a1           # s1 : address of x1

    # get x0_digit
    lw a0, 0(s0)        # a0 : lower part of x0
    lw a1, 4(s0)        # a1 : higher part of x0
    jal ra clz
    li s2, 64
    sub s2, s2, a0      # s2 : x0_digit (return value saved in a0)

    # get x1_digit
    lw a0, 0(s1)        # a0 : lower part of x1
    lw a1, 4(s1)        # a1 : higher part of x1
    jal ra clz
    li s3, 64
    sub s3, s3, a0      # s3 : x1_digit (return value saved in a0)
    
    # get x0(s5 s4) and x1(s7 s6)
    lw s4, 0(s0)
    lw s5, 4(s0)
    lw s6, 0(s1)
    lw s7, 4(s1)

    # compare with two digit
    slt t0, s2, s3
    bne t0, zero, x1_larger
    mv s3, zero         # s3: hd counter
    bgt s2, zero, hd_cal_loop
    
    # when digit is 0
    mv a0, s2            # save max_digit to a0
    j hd_func_end        

x1_larger:
    mv s2, s3          # s2 : max_digit
    mv s3, zero        # s3: hd counter
    bgt s2, zero, hd_cal_loop
    
    # when digit is 0
    mv a0, s2            # save max_digit to a0
    j hd_func_end

hd_func_end:
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    addi sp, sp, 36
    ret

# hamming distance calculation (result save in a0, a1)
hd_cal_loop:
    # when the current digit larger than 32
    addi t2, zero, 32
    bgt s2, t2, hd_getLSB_upper

    # hd_getLSB_lower : and with 1
    li t3, 0x00000001
    and t4, s4, t3
    and t5, s6, t3
    j hd_cal_shift

hd_getLSB_upper:
    # and with 1
    li t3, 0x00000001
    and t4, s5, t3
    and t5, s7, t3

hd_cal_shift:
    # (s5 s4) = x >> 1
    srli t0, s4, 1
    slli t1, s5, 31
    or s4, t0, t1       # s4 >> 1
    srli s5, s5, 1      # s5 >> 1

    # (s7 s6) = x >> 1
    srli t0, s6, 1
    slli t1, s7, 31
    or s6, t0, t1       # s6 >> 1
    srli s7, s7, 1      # s7 >> 1

    beq t4, t5, hd_check_loop
    addi s3, s3, 1
    
hd_check_loop:
    addi s2, s2, -1
    bne s2, zero, hd_cal_loop
    mv a0, s3            # save return value to a0
    j hd_func_end

# count leading zeros
clz:
    addi sp, sp, -4
    sw ra, 0(sp)
    beq a1, zero, clz_lower_set_one

clz_upper_set_one:
    srli t1, a1, 1
    or a1, a1, t1
    srli t1, a1, 2
    or a1, a1, t1
    srli t1, a1, 4
    or a1, a1, t1
    srli t1, a1, 8
    or a1, a1, t1
    srli t1, a1, 16
    or a1, a1, t1
    li a0, 0xffffffff
    j clz_count_ones

clz_lower_set_one:
    srli t0, a0, 1
    or a0, a0, t0
    srli t0, a0, 2
    or a0, a0, t0
    srli t0, a0, 4
    or a0, a0, t0
    srli t0, a0, 8
    or a0, a0, t0
    srli t0, a0, 16
    or a0, a0, t0

clz_count_ones:
    # x = (a1 a0)
    
    # x -= ((x >> 1) & 0x5555555555555555); # 
    srli t0, a0, 1
    slli t1, a1, 31
    or t0, t0, t1       # t0 >> 1
    srli t1, a1, 1      # t1 >> 1

    li t2, 0x55555555
    and t0, t0, t2
    and t1, t1, t2

    sltu t3, a0, t0     # t3 : borrow bit
    sub a0, a0, t0
    sub a1, a1, t1
    sub a1, a1, t3


    # x = ((x >> 2) & 0x3333333333333333) + (x & 0x3333333333333333); #
    srli t0, a0, 2
    slli t1, a1, 30
    or t0, t0, t1       # t0 >> 2
    srli t1, a1, 2      # t1 >> 2

    li t2, 0x33333333
    and t0, t0, t2
    and t1, t1, t2
    and t4, a0, t2
    and t5, a1, t2

    # (a1 a0) = (t1 t0) + (t5 t4)
    add a0, t0, t4
    sltu t3, a0, t0     # t3 : carry bit
    add a1, t1, t5
    add a1, a1, t3


    # x = ((x >> 4) + x) & 0x0f0f0f0f0f0f0f0f; #
    srli t0, a0, 4
    slli t1, a1, 28
    or t0, t0, t1       # t0 >> 4
    srli t1, a1, 4      # t1 >> 4
    
    add t0, t0, a0
    sltu t3, t0, a0     # t3 : carry bit
    add t1, t1, a1
    add t1, t1, t3

    li t2, 0x0f0f0f0f
    and a0, t0, t2
    and a1, t1, t2


    # x += (x >> 8); #
    srli t0, a0, 8
    slli t1, a1, 24
    or t0, t0, t1       # t0 >> 8
    srli t1, a1, 8      # t1 >> 8
    
    add a0, a0, t0
    sltu t3, a0, t0     # t3 : carry bit
    add a1, a1, t1
    add a1, a1, t3      # (a1 a0) += (t1 t0)


    # x += (x >> 16); #
    srli t0, a0, 16
    slli t1, a1, 16
    or t0, t0, t1       # t0 >> 16
    srli t1, a1, 16     # t1 >> 16
    
    add a0, a0, t0
    sltu t3, a0, t0     # t3 : carry bit
    add a1, a1, t1
    add a1, a1, t3      # (a1 a0) += (t1 t0)


    # x += (x >> 32); #
    # (t1 t0) = x >> 32
    mv t0, a1
    mv t1, zero
    
    add a0, a0, t0
    sltu t3, a0, t0     # t3 : carry bit
    add a1, a1, t1
    add a1, a1, t3      # (a1 a0) += (t1 t0)
    
    
    # return (64 - (x & 0x7f));
    # a0 = (x & 0x7f)
    andi a0, a0, 0x7f   
    li t0, 64
    sub a0, t0, a0      # a0 = (64 - (x & 0x7f))
    
    lw ra, 0(sp)
    addi sp, sp, 4
    ret
