.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:
    # Error checks
    li t0 1
    blt a1 t0 error1
    blt a2 t0 error1
    blt a4 t0 error1
    blt a5 t0 error1
    bne a2 a4 error1 

    # Prologue
    addi sp sp -24
    sw ra 0(sp)
    sw s0 4(sp)#a0
    sw s1 8(sp)#a1
    sw s2 12(sp)#a3
    sw s3 16(sp)#a5
    sw s5 20(sp)#a2=a4
    
    mv s0 a0
    mv s1 a1
    mv s2 a3
    mv s3 a5
    mv t4 a6
    mv s5 a2
    
    mv t0 x0
    
    mv t2 a0#p->arr0
   # mv t3 a3#p->arr1
    
outer_loop_start:
    bge t0 s1 outer_loop_end
    mv t1 x0
inner_loop_start:
    bge t1 s3 inner_loop_end
    slli t3 t1 2
    add t3 t3 s2
    mv a0 t2
    mv a1 t3
    mv a2 s5
    li a3 1
    mv a4 s3
    #Prologue
    addi sp sp -20
    sw t0 0(sp)
    sw t1 4(sp)
    sw t2 8(sp)
    sw t3 12(sp)
    sw t4 16(sp)
    
    jal dot
    #Epilogue
    lw t0 0(sp)
    lw t1 4(sp)
    lw t2 8(sp)
    lw t3 12(sp)
    lw t4 16(sp)
    addi sp sp 20
    
    sw a0 0(t4)
    addi t4 t4 4
    addi t1 t1 1
    j inner_loop_start
inner_loop_end: 
    slli t5 s5 2
    add t2 t2 t5
    
    addi t0 t0 1
    j outer_loop_start
    
error1:
    li a0 38
    j exit

outer_loop_end:

    # Epilogue
    lw ra 0(sp)
    lw s0 4(sp)#a0
    lw s1 8(sp)#a1
    lw s2 12(sp)#a3
    lw s3 16(sp)#a5
    lw s5 20(sp)#a2=a4
    addi sp sp 24

    jr ra
