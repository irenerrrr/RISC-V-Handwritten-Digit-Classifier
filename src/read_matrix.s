.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:
#s0: FILENAME
#s1 :rowp
#s2 :colp
#s3 :matrix
#s4 :byteCount
    #prologue
    addi sp sp -24
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp)
    sw s4 16(sp)
    sw ra 20(sp)

    #Save Pointer Head args to S
    mv s0 a0
    mv s1 a1
    mv s2 a2

    
    #fopen(file,0)
    mv a1 x0
    mv a0 s0 
    jal fopen
    addi t0 x0 -1
    beq a0 t0 error27
    mv s0 a0

    #row = fread(file,rowpointer,4) read numrow
    li a2 4
    mv a0 s0
    mv a1 s1
    jal fread
    li t0 4
    bne a0 t0 error29

    #col = fread(file,colpointer,4) read num col
    li a2 4
    mv a0 s0
    mv a1 s2
    jal fread
    li t0 4
    bne a0 t0 error29
    
    #malloc row*col*4bytes
    lw s1 0(s1)
    lw s2 0(s2)
    mul s4 s1 s2
    li t0 4
    mul s4 s4 t0
    mv a0 s4
    jal malloc
    beq a0 x0 error26
    mv s3 a0


    #fread(file,pointer,row*col*4)
    mv a0 s0
    mv a1 s3
    mv a2 s4
    jal fread
    bne a0 s4 error29
    mv a0 s0
    jal fclose
    bne a0 x0 error28

    #epilogue
    mv a0 s3
    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw s4 16(sp)
    lw ra 20(sp)
    addi sp sp 24
    jr ra

error26:
    li a0 26 
    j exit
error27:
    li a0 27 
    j exit
error28:
    li a0 28
    j exit
error29:
    li a0 29
    j exit

