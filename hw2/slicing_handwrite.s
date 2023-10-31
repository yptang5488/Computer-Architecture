# run on Ripes
.data
test0: .word 255, 0, 128, 1
test1: .word 167, 133, 111, 144, 140, 135, 159, 154, 148
test2: .word 50, 100, 150, 200, 250, 255

testStr: .string "Test "
colonStr: .string ": "
newlineStr: .string "\n"
spaceStr: .string " "

.text


main:
    la a4, test0          # a4: the base address of test0
    addi a1, x0, 4        # a1: the size of test0
    addi a2, x0, 0        # a2: caseNum = 0
    jal ra, bit_plane_slicing
    
    la a4, test1          # a4: the base address of test1
    addi a1, x0, 9        # a1: the size of test1
    addi a2, x0, 1        # a2: caseNum = 1
    jal ra, bit_plane_slicing
    
    la a4, test2          # a4: the base address of test2
    addi a1, x0, 6        # a1: the size of test2
    addi a2, x0, 2        # a2: caseNum = 2
    jal ra, bit_plane_slicing
    
    li a7, 10             # Exit program
    ecall
    
bit_plane_slicing:
    addi s0, x0, -1       # s0: max = -1
    add s1, x0, x0        # s1: i = 0
clzLoop:
    slli t2, s1, 2        # t2: array offset = i*4
    add t2, t2, a4        # t2: base addr + offset
    lw s4, 0(t2)          # s4: arr[i]
    
    addi sp, sp, -4
    sw ra, 0(sp)
    add a0, x0, s4        # load arr[i] to parameter register a0
    jal ra, count_leading_zeros    
    lw ra, 0(sp)
    addi sp, sp, 4
    
    add s2, x0, a3        # s2: LZ
    addi t1, x0, 31       # t1: 32 - 1
    sub s3, t1, s2        # s3: MSB = 32 - 1 - LZ 
    sw s3, 0(t2)          # arr[i] = MSB
    blt s3, s0, goOn
    add s0, x0, s3        # if(max < MSB) max = MSB
goOn:
    addi s1, s1, 1        # i = i + 1
    blt s1, a1, clzLoop
    
    addi sp, sp, -4
    sw ra, 0(sp)
    jal ra, printLoopOutside    # printf("Test %d: ", caseNum) || printf("\n")
    lw ra, 0(sp)
    addi sp, sp, 4
    
    add s1, x0, x0        # s1: i = 0
reconLoop:
    slli t2, s1, 2        # t2: array offset = i*4
    add t2, t2, a4        # t2: base addr + offset
    lw s4, 0(t2)          # s4: arr[i]
    beq s4, s0, isEqual   # if(arr[i] == max)
    add s4, x0, x0        # arr[i] = 0
    j goOn2
isEqual:
    addi s4, x0, 255      # arr[i] = 255
goOn2:
    addi sp, sp, -4
    sw ra, 0(sp)
    jal ra, printLoopInside    # printf("%u ", arr[i])
    lw ra, 0(sp)
    addi sp, sp, 4
    
    addi s1, s1, 1        # i = i + 1
    blt s1, a1, reconLoop    
    ret

    
count_leading_zeros:
    srli t0, a0, 1        # t0: x >> 1
    or a0, a0, t0         # a0: x |= (x >> 1)
    
    srli t0, a0, 2        # t0: x >> 2
    or a0, a0, t0
    
    srli t0, a0, 4        # t0: x >> 4
    or a0, a0, t0
    
    srli t0, a0, 8        # t0: x >> 8
    or a0, a0, t0
    
    srli t0, a0, 16       # t0: x >> 16
    or a0, a0, t0
count_ones:
    srli t0, a0, 1        # t0: x >> 1
    lui t1, 0x55555       # t1: 0x55555555
    ori t1, t1, 0x555
    and t0, t0, t1        # t0: (x >> 1) & 0x55555555
    sub a0, a0, t0
    
    srli t0, a0, 2        # t0: x >> 2
    lui t1, 0x33333       # t1: 0x33333333
    ori t1, t1, 0x333
    and t0, t0, t1        # t0: (x >> 2) & 0x33333333
    and t4, a0, t1        # t4: x & 0x33333333
    add a0, t0, t4
    
    srli t0, a0, 4        # t0: x >> 4
    add t0, t0, a0        # t0: (x >> 4) + x
    lui t1, 0x0f0f0       # t1: 0x0f0f0f0f
    ori t1, t1, 0x787
    addi t1, t1, 0x788
    and a0, t0, t1        # a0: ((x >> 4) + x) & 0x0f0f0f0f
    
    srli t0, a0, 8        # t0: x >> 8
    add a0, a0, t0
    
    srli t0, a0, 16       # t0: x >> 16
    add a0, a0, t0
    
    andi t0, a0, 0x7f     # t0: x & 0x7f
    addi t1, x0, 32       # t1: 32
    sub  a3, t1, t0       # a3: return (32 - (x & 0x7f))
    ret
    
printLoopOutside:
    la a0, newlineStr
    li a7, 4
    ecall
    la a0, testStr
    li a7, 4
    ecall
    add a0, x0, a2
    li a7, 1
    ecall
    la a0, colonStr
    li a7, 4
    ecall
    ret
    
printLoopInside:
    add a0, x0, s4
    li a7, 1
    ecall
    la a0, spaceStr
    li a7, 4
    ecall
    ret
    