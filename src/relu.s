.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    # Prologue
    addi t0 x0 1
    blt a1 t0 bad
    mv t0 x0

loop_start:
    bge t0 a1 loop_end
    lw t1 0(a0)
    blt t1 x0 set_zero
loop_continue:
    addi t0 t0 1   
    addi a0 a0 4
    jal x0 loop_start
set_zero:
    sw x0 0(a0)
    jal x0 loop_continue
bad:
    li a0 36
    j exit
    
loop_end:

    # Epilogue
    jr ra
