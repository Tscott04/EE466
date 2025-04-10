# intSort.s
# Sorts an array of integers as WORD (4-bytes) and displays sorted array
# Stack filter through all ints in array
#---------------------------------------------------------

    .data
myArray: .word 4, 1, 3, 2, 16, 9, 10, 14, 8, 7
myArray_size: .word 10
intro_msg: .asciiz "Your starting array is: " # Intro Header
result_msg: .asciiz "The sorted arrayy is: " # Ending Header
newline: .asciiz "\n"  # Newline character

    .text
    .globl main

main:

        li $v0, 4                      # Load syscall code for printing a string
        la $a0, intro_msg              # Load address of intro_msg
        syscall                        # Print intro_msg to show initial array

        la $a0, myArray
        lw $a1, myArray_size
        jal array_print

array_print:
    add $t0, $zero, $zero      # i = 0

print_loop:
    beq $t0, $a1, print_done   # if i == size, done

    sll $t1, $t0, 2            # offset = i * 4
    add $t2, $a0, $t1          # address = base + offset
    lw $t3, 0($t2)             # load value from array[i] into $t3

    li $v0, 1                  # syscall to print int
    move $a0, $t3              # move value into $a0
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    addi $t0, $t0, 1
    j print_loop

print_done:
    jr $ra









