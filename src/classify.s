.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
    li t0 5
    bne a0 t0 error2
    
    addi sp sp -76
    sw s0 0(sp)#ptr->str m0
    sw s1 4(sp)#ptr->str m1
    sw s2 8(sp)#ptr->str input
    sw s3 12(sp)#ptr->str output
    sw s4 16(sp)#a2
    sw s5 20(sp)#m0 rows
    sw s6 24(sp)#m0 cols
    sw s7 28(sp)#m1 rows
    sw s8 32(sp)#m1 cols
    sw s9 36(sp)#input rows
    sw s10 40(sp)#input cols
    sw s11 44(sp)#ptr->matrix m0
    sw ra 48(sp)
    #52 ptr->matrix m1
    #56 ptr->matrix input
    #60 rows
    #64 cols
    #68 ptr->matrix h
    #72 ptr->matrix o
    lw s0 4(a1)
    lw s1 8(a1)
    lw s2 12(a1)
    lw s3 16(a1)
    mv s4 a2
    
    # Read pretrained m0
    mv a0 s0
    addi a1 sp 60
    addi a2 sp 64
    jal ra read_matrix
    lw s5 60(sp)
    lw s6 64(sp)
    mv s11 a0
    # Read pretrained m1
    mv a0 s1
    addi a1 sp 60
    addi a2 sp 64
    jal ra read_matrix
    lw s7 60(sp)
    lw s8 64(sp)
    sw a0 52(sp)
    # Read input matrix
    mv a0 s2
    addi a1 sp 60
    addi a2 sp 64
    jal ra read_matrix
    lw s9 60(sp)
    lw s10 64(sp)
    sw a0 56(sp)
    # Compute h = matmul(m0, input)
    mul a0 s5 s10#s5->row h, s10->col h
    slli a0 a0 2
    jal ra malloc
    beq a0 x0 error1
    sw a0 68(sp)
    mv a0 s11
    mv a1 s5
    mv a2 s6
    lw a3 56(sp)
    mv a4 s9
    mv a5 s10
    lw a6 68(sp)
    jal ra matmul
    # Compute h = relu(h)
    lw a0 68(sp)
    mul a1 s5 s10
    jal ra relu
    # Compute o = matmul(m1, h)
    mul a0 s7 s10
    slli a0 a0 2
    jal ra malloc
    beq a0 x0 error1
    sw a0 72(sp)
    lw a0 52(sp)
    mv a1 s7
    mv a2 s8
    lw a3 68(sp)
    mv a4 s5
    mv a5 s10
    lw a6 72(sp)
    jal ra matmul
    # Write output matrix o
    mv a0 s3
    lw a1 72(sp)
    mv a2 s7
    mv a3 s10
    jal ra write_matrix
    # Compute and return argmax(o)
    lw a0 72(sp)
    mul a1 s7 s10
    jal ra argmax
    mv s0 a0
    # If enabled, print argmax(o) and newline
    beq s4 x0 print_arg
done:
    mv a0 s11
    jal ra free
    lw a0 52(sp)
    jal ra free
    lw a0 56(sp)
    jal ra free
    lw a0 68(sp)
    jal ra free
    lw a0 72(sp)
    jal ra free
    mv a0 s0
    lw s0 0(sp)#ptr->str m0
    lw s1 4(sp)#ptr->str m1
    lw s2 8(sp)#ptr->str input
    lw s3 12(sp)#ptr->str output
    lw s4 16(sp)#a2
    lw s5 20(sp)#m0 rows
    lw s6 24(sp)#m0 cols
    lw s7 28(sp)#m1 rows
    lw s8 32(sp)#m1 cols
    lw s9 36(sp)#input rows
    lw s10 40(sp)#input cols
    lw s11 44(sp)#ptr->matrix m0
    lw ra 48(sp)
    #52 ptr->matrix m1
    #56 ptr->matrix input
    #60 rows
    #64 cols
    #68 ptr->matrix h
    #72 ptr->matrix o
    addi sp sp 76
    jr ra
print_arg:
    jal ra print_int
    li a0 '\n'
    jal ra print_char
    j done
error1:
    li a0 26
    j exit
error2:
    li a0 31
    j exit
