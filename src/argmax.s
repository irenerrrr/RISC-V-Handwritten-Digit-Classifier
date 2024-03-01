.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    # Prologue
    addi sp, sp, -4
    sw ra, 0(sp)
    #Initialize variables 
    addi t0 x0 0 #value of current max
    addi t1 x0 0 #index of current max 
    mv t2 a0 #pointer to current element
    mv t3 a1 #number of elements left 
    addi t4 x0 1 #temp variable of 1
    #check if error 36
    bge t3 t4 loop_start #if greater than 
    li a0 36 
    j exit

loop_start:
    beq t3 x0 loop_end #end if 0 item
    lw t5 0(t2) #t5 = (current VALUE)
    ble t5 t0 loop_continue #if current is less than max contirnue 
    addi t0 t5 0 #update max
    addi a0 t1 0 #update index 
    addi t1 t1 1 #update index 
    addi t2 t2 4 #update pointer
    addi t3 t3 -1 #update number of elements left
    j loop_start


loop_continue:
    addi t2 t2 4 #update pointer
    addi t1 t1 1 #update index 
    addi t3 t3 -1 #update number of elements left
    j loop_start


loop_end:
    #free ra
    lw ra 0(sp)
    addi sp sp 4



    jr ra
