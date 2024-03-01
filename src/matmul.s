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
    blt a1 t0 error38
    blt a2 t0 error38
    blt a4 t0 error38
    blt a5 t0 error38
    bne a2 a4 error38
    #VARIABLES WE NEED IN FUNCTION, since we need to call other fucntions and use 
    #the a0 a1 a2 a3, we store all inputs into S for now 
    #S0:potiner to Matrix A
    #S1:Row of Matrix A
    #S2:Column of Matrix A 
    #S3:Pointer to matrix B
    #S4:row of matrix B
    #S5: COlumn of matrix B 
    addi sp sp -48
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp)
    sw s4 16(sp)
    sw s5 20(sp)
    #Tracker Variables
    sw s6 24(sp) #counter i
    sw s7 28(sp) #counter j
    sw s8 32(sp) #Pointer Incremenet Tracker A
    sw s9 36(sp) #Pointer Incremenet Tracker B
    sw s10 40(sp) #Result Arrat Oiubter 
    sw ra 44(sp)
    #Save all the inputs to S
    mv s0 a0
    mv s1 a1
    mv s2 a2
    mv s3 a3
    mv s4 a4
    mv s5 a5
    mv s6 x0    
    mv s7 x0
    addi s8 x0 4
    addi s9 x0 4
    mv s10 a6
outer_loop_start:
    beq s6 s1 outer_loop_end
    bge s6 s1 outer_loop_end
inner_loop_start:
    bge s7 s5 inner_loop_end
    #Finding the correct Vari for dot product 
    mv a0 s0 
    add a1 s3 x0
    add a2 s2 x0
    addi a3 s9 -3
    addi a4 s5 0
    jal dot

    #Put the result in a6 then increment 
    sw a0 0(s10)
    #result matrix increment 
    add s10 s8 s10
    #Matrix B increment
    add s3 s9 s3
    #Loop increment
    addi s7 s7 1
    j inner_loop_start
    
inner_loop_end:
    #next col
    addi s6 s6 1
    #Increment Matrix A Pointer 
    addi t0 s4 0 
    slli t0 t0 2
    add s0 s0 t0
    #Reset counter j
    addi s7 x0 0
    #move back
    slli t1 s5 2
    sub s3 s3 t1
    j outer_loop_start
outer_loop_end:
    # Epilogue
    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw s4 16(sp)
    lw s5 20(sp)
    lw s6 24(sp)
    lw s7 28(sp)
    lw s8 32(sp)
    lw s9 36(sp)
    lw s10 40(sp)
    lw ra 44(sp)
    addi sp sp 48
    jr ra

error38:
    li a0 38
    j exit
