.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the number of elements to use is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:

    # Prologue
    li t0 4 # std size
    mv t2 x0 #the ans
    li t3 1
    blt a2 t3 bad1
    blt a3 t3 bad2
    blt a4 t3 bad2
    mv t3 x0
    
loop_start:
    bge t3 a2 loop_end
    lw t4 0(a0)
    lw t5 0(a1)
    mul t6 t4 t5
    add t2 t2 t6
    
    mul t1 t0 a3#t1 tmp skip
    add a0 a0 t1
    
    mul t1 t0 a4
    add a1 a1 t1
    
    addi t3 t3 1
    j loop_start
   
bad1:
    li a0 36
    j exit
bad2:
    li a0 37
    j exit
loop_end:
    # Epilogue
    mv a0 t2
    jr ra
