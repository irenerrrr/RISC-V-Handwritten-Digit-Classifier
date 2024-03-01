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
    addi sp, sp, -8
    sw ra 0(sp)
    sw s3 4(sp) #Sum traicker 

    mv s3 x0

    addi t1 x0 4  # t9 = sizeof(int）

    #set a temp variabel to 1 
    addi t2 x0 1

    blt a2 t2 error36 #error36
    blt a3 t2 error37 #error37
    blt a4 t2 error37 #error37

    mul a3 a3 t1 #a2 = a2 * 4
    mul a4 a4 t1 #a3 = a3 * 4

    bge a2 x0 loop_start

    #default error 36, check for error 37


loop_start:

    beq a2 x0 loop_end #Check for end case

    lw t0 0(a0) #Grab the cur element of arry0
    lw t1 0(a1) #Grab the cur element of arry1

    mul t0 t0 t1 #Multiply the two elements

    add s3 s3 t0 #Add the result to the sum

    #update pointer 
    add a0 a0 a3
    add a1 a1 a4

    addi a2 a2 -1
    
    
    j loop_start


loop_end:


    # Epilogue
    mv a0 s3 

    lw ra 0(sp)
    lw s3 4(sp)
    addi sp sp 8

    jr ra

error37: 
    li a0 37
    j exit

error36: 
    li a0 36
    j exit

