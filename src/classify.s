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
    #Make Pointer to everything 
    #Make array tracking the size of each matrix 
    #[m0Row, m0Col, m1Row, m1Col, inputRow, inputCol]
    addi t0 x0 5
    bne a0 t0 error31
    
    addi sp sp -36
    sw s0 0(sp) #argc
    sw s1 4(sp) #a1
    sw s2 8(sp) #a2
    sw s3 12(sp) #pointer m0
    sw s4 16(sp) #pointer m1
    sw s5 20(sp) #pointer input 
    sw s7 24(sp) #pointer h
    sw s8 28(sp) #pointer o
    sw ra 32(sp) #ra
    #initialize an array to store the size of each matrix [m0Row, m0Col, m1Row, m1Col, inputRow, inputCol]
    #                                                       0      4      8     12      16        20
    addi sp sp -24
    mv s1 a1
    mv s2 a2

    #(m0name, n0row, m0col)
    lw a0 4(s1)
    addi a1 sp 0
    addi a2 sp 4
    jal read_matrix
    mv s3 a0
   
   
    # Read pretrained m1
    lw a0 8(s1)
    #(m1name, n1row, m1col)
    addi a1 sp 8
    addi a2 sp 12
    jal read_matrix
    mv s4 a0
    
    
    # Read input matrix
    lw a0 12(s1)
    #(inputname, nrow, ncol)
    addi a1 sp 16
    addi a2 sp 20
    jal read_matrix
    mv s5 a0
    
    
    #malloc m0row * inputcol * 4 for hstep1
    lw t0 0(sp)
    lw t1 20(sp)
    mul t0 t0 t1
    slli t0 t0 2
    mv a0 t0
    jal malloc
    beq a0 x0 error26
    mv s7 a0  

    # Compute h = matmul(m0, input)  
    mv a0 s3
    lw a1 0(sp) #m0col
    lw a2 4(sp) #inputrow
    mv a3 s5
    lw a4 16(sp) #inputcol
    lw a5 20(sp)
    mv a6 s7
    jal matmul

    # Compute h = relu(h)
    lw t0 0(sp)
    lw t1 20(sp)
    mul t0 t0 t1
    mv a0 s7
    mv a1 t0
    jal relu
    
    #malloc for O
    lw t0 8(sp)
    lw t1 20(sp)
    mul t0 t0 t1
    slli t0 t0 2
    mv a0 t0
    jal malloc
    beq a0 x0 error26
    mv s8 a0


    # Compute o = matmul(m1, h)
    #(m1, m1row, m1col, h, hrow, hcol, o)
    mv a0 s4
    lw a1 8(sp) 
    lw a2 12(sp) 
    mv a3 s7
    lw a4 0(sp)
    lw a5 20(sp)
    mv a6 s8
    jal matmul


    # Write output matrix o
    lw a0 16(s1)
    mv a1 s8
    lw a2 8(sp)
    lw a3 20(sp)
    jal write_matrix


    # Compute and return argmax(o)
    lw t0 8(sp)
    lw t1 20(sp)
    mul t0 t0 t1
    mv a0 s8
    mv a1 t0
    jal argmax
    mv s0 a0 #saved in output

    



    # If enabled, print argmax(o) and newline default print
    addi t0 x0 1
    beq s2 t0 NOprint 

    mv a0 s0
    jal print_int
    li a0 '\n'
    jal print_char


NOprint:
    #free all pointers
    mv a0 s3
    jal free
    mv a0 s4
    jal free
    mv a0 s5
    jal free
    mv a0 s7
    jal free
    mv a0 s8
    jal free

    mv a0 s0

    

    addi sp sp 24
    
    lw s0 0(sp) #argc
    lw s1 4(sp) #a1
    lw s2 8(sp) #a2
    lw s3 12(sp) #pointer m0
    lw s4 16(sp) #pointer m1
    lw s5 20(sp) #pointer input 
    lw s7 24(sp) #pointer h
    lw s8 28(sp) #pointer o
    lw ra 32(sp)
    addi sp sp 36





    jr ra 


    error31:
        li a0 31
        j exit

    error26:
        li a0 26
        j exit


