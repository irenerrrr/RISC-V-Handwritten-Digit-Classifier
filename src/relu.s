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

#Decrement the total length of array each time we add 4 to the pointer, replacing 0s along the way
relu:
    addi sp, sp, -4
    sw ra, 0(sp)
    
    addi t0 a1 0    #initialize t0 to the initial length of array
    addi t1 a0 0     #initialize t1 to the initial pointer to array
    addi t4 x0 1 #set this to 1 temp
    
    bge a1 t4 loop_start #if length of array is greater than 1, move to loop_start 
    
    li a0 36 
    j exit #if length of array is less than 1 error out with 36

loop_start:
    lw t2 0(t1) #Save the first element value in t2 
    bge t2 x0 loop_continue #if > 0, move to continue

    sw x0 0(t1) #replace the value with 0
    j loop_continue



loop_continue:
    addi t0 t0 -1 #array legnth temp --
    addi t1 t1 4 #adding to the pointer to access next value
    beq t0 x0 loop_end 
    j loop_start #loop back to start




loop_end:
    lw ra 0(sp)
    addi sp sp 4
    
    jr ra




    
