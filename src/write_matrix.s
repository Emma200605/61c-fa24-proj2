.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:
ebreak
    # Prologue
    addi sp sp -28#-8store rows and cols
    sw s0 0(sp)#fp
    sw s1 4(sp)#p->mateix
    sw s2 8(sp)#rows
    sw s3 12(sp)#cols
    sw ra 16(sp)
    

    mv s1 a1
    mv s2 a2 
    mv s3 a3
    
    li a1 1
    jal ra fopen
    li t0 -1
    beq a0 t0 error1
    mv s0 a0
    
    sw s2 20(sp)
    sw s3 24(sp)
    
    addi a1 sp 20
    li a2 2
    li a3 4
    jal ra fwrite
    li t0 2
    bne a0 t0 error2
    
    mv a0 s0
    mv a1 s1
    mul a2 s2 s3
    li a3 4
    jal ra fwrite
    mul t0 s2 s3
    bne a0 t0 error2

    mv a0 s0
    jal ra fclose
    li t0 -1
    beq a0 t0 error3

    # Epilogue
    
    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw ra 16(sp)
    addi sp sp 28
    jr ra
error1:
    li a0 27
    j exit
error2:
    li a0 30
    j exit
error3:
    li a0 28
    j exit
