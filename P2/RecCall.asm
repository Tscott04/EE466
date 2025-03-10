# SUM.s
# Asks for a number n (n >= 1). Then it calculates and prints
# the Sum up to the nth term recursivly.
#---------------------------------------------------------

              .data
prompt:       .asciiz "Enter a number (n ≥ 1): "       # Prompt message
err_msg:      .asciiz "Error: n must be >= 1. Try again.\n"  # Error message
result_msg:   .asciiz "Sum is: "          # Recursive Sum Result Header
continue_msg: .asciiz "Do you want to continue? (1: Yes, 0: No): " # Continuation message
newline:      .asciiz "\n"                            # Newline character

            .text
            .globl main

main:
        li $v0, 4
        la $a0, prompt
        syscall

        li $v0, 5
        syscall
        move $t0, $v0        # store input number in $t0

        blt $t0, 1, invalid

        li $v0, 4
        la $a0, result_msg
        syscall

        move $a0, $t0        # pass n in $a0 to sum
        jal sum              # computes sum from 1 to n

        move $t1, $v0        # save result from sum into $t1, previous error saved 1 into $a0 and caused base case issue.

        li $v0, 1            # syscall code for print_int
        move $a0, $t1        # move saved result into $a0
        syscall

        li $v0, 4
        la $a0, newline
        syscall

        j continue

    #Chen Liu Code

sum:
    addi $sp, $sp, -8
    sw $ra, 4($sp)
    sw $a0, 0($sp)

    li $t1, 1
    beq $a0, $t1, base_case

    addi $a0, $a0, -1
    jal sum

    lw $a0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8

    add $v0, $v0, $a0
    jr $ra

base_case:
    li $v0, 1
    lw $ra, 4($sp)
    addi $sp, $sp, 8
    jr $ra

# Invalid Input Code

invalid:
            li $v0, 4                   # Load syscall code for printing a string
            la $a0, err_msg             # Load address of error message
            syscall                     # Print error message
            j main                      # Restart program

# Prompt for entering another SUM #

continue:
            li $v0, 4                   # Load syscall code for printing a string
            la $a0, continue_msg        # Load address of continuation prompt
            syscall                     # Print continuation prompt

            li $v0, 5                   # Load syscall code for reading an integer
            syscall                     # Read user input
            beqz $v0, exit              # If input is 0, exit program
            j main                      # Otherwise, restart program

# Exit code

exit:
            li $v0, 10                  # Load syscall code for exiting program
            syscall                     # Exit
