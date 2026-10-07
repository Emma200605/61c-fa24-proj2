.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:
    # Prologue
    addi sp sp -32#-8 rows+cols
    sw ra 0(sp)
    sw s0 4(sp)#fp
    sw a1 8(sp)
    sw a2 12(sp)
    sw s1 16(sp)#malloc ptr->the asw
    sw s2 20(sp)#size of matrix
    
    li a1 0
    jal ra fopen
    li t0 -1
    beq a0 t0 error2
    mv s0 a0
    
    addi a1 sp 24
    li a2 8
    jal ra fread
    
    li t0 8
    bne a0 t0 error4
    
    lw t1 24(sp)
    lw t2 28(sp)
    
    lw t3 8(sp)
    lw t4 12(sp)
    
    sw t1 0(t3)
    sw t2 0(t4)    

    mul s2 t1 t2
    slli s2 s2 2
    mv a0 s2
    
    jal ra malloc
    beq a0 x0 error1
    
    mv s1 a0
    mv a1 s1
    mv a0 s0
    mv a2 s2

    jal ra fread
    bne a0 s2 error4
    
    mv a0 s0
    jal ra fclose
    li t0 -1
    beq a0 t0 error3



    # Epilogue
    mv a0 s1
    
    lw ra 0(sp)
    lw s0 4(sp)
    lw a1 8(sp)
    lw a2 12(sp)
    lw s1 16(sp)
    lw s2 20(sp)
    addi sp sp 32
    jr ra
error1:#malloc
    li a0 26
    j exit
error2:#fopen
    li a0 27
    j exit
error3:#fclose
    li a0 28
    j exit
error4:#fread
    li a0 29
    j exit
    
    
