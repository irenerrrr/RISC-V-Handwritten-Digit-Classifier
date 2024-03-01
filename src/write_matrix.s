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
    #same logic with read 

    # Prologue
    addi sp sp -32
    sw s0 0(sp)
    sw s1 4(sp)#pointer to matrix mem
    sw s2 8(sp)#num row
    sw s3 12(sp)#num col
    sw s4 16(sp) #TEMP ROW useless 
    sw s5 20(sp) #TEMP COL useless
    sw s6 24(sp) #TEMP MATRIX useles
    sw ra 28(sp) #Useless
    

    mv s0 a0
    mv s1 a1
    mv s2 a2
    mv s3 a3
    #Same logic with read 
    #open file
    mv a0 s0 
    addi a1 x0 1 
    jal fopen
    addi t0 x0 -1 
    beq a0 t0 error27
    #[ROW, COL] for first two
    mv s0 a0 
    addi sp sp -8
    sw s2 0(sp)
    sw s3 4(sp)
    #write row
    mv a0 s0
    mv a1 sp 
    addi t2 x0 1
    mv a2 t2
    addi a3 x0 4
    jal fwrite
    addi t2 x0 1
    bne a0 t2 error30
    addi sp sp 4


    #write col 
    mv a0 s0 
    mv a1 sp
    addi t2 x0 1
    mv a2 t2
    addi a3 x0 4
    jal fwrite
    addi t2 x0 1
    bne a0 t2 error30
    addi sp sp 4

    mv a0 s0 
    mv a1 s1
    mul a2 s2 s3 
    addi a3 x0 4
    jal fwrite
    mul t0 s2 s3
    bne a0 t0 error30

    mv a0 s0 
    jal fclose
    addi t0 x0 0
    bne a0 t0 error28



    # Epilogue
    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw s4 16(sp)
    lw s5 20(sp)
    lw s6 24(sp)
    lw ra 28(sp)
    addi sp sp 32



    jr ra
error27:
    li a0 27
    j exit

error30:
    li a0 30
    j exit

error28:
    li a0 28
    j exit

    