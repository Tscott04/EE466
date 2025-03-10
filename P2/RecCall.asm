# SUM.s
# Asks for a number n (n >= 1). Then it calculates and prints
# the Sum up to the nth term.
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
        move $t0, $v0

        blt $t0, 1, invalid

        li $v0, 4
        la $a0, result_msg
        syscall

        move $a0, $t0
        jal sum               # computes sum from 1 to n

        # $v0 has the sum result
        li $v0, 1
        move $a0, $v0
        syscall

        li $v0, 4
        la $a0, newline
        syscall

        j continue

    #Chen Liu Code

sum:
    addi $sp, $sp, -8         # make space on stack
    sw $ra, 4($sp)            # save return address
    sw $a0, 0($sp)            # save argument n

    # Base case: if n == 1, return 1
    li $t1, 1
    beq $a0, $t1, base_case

    # Recursive case:
    addi $a0, $a0, -1         # n = n - 1
    jal sum                   # sum(n - 1)

    lw $a0, 0($sp)            # restore original n
    lw $ra, 4($sp)            # restore return address
    addi $sp, $sp, 8          # pop 2 items from stack

    add $v0, $v0, $a0         # sum = sum(n - 1) + n
    jr $ra

base_case:
    li $v0, 1                 # return 1
    lw $ra, 4($sp)
    addi $sp, $sp, 8
    jr $ra
        # Loop Code

loop:
        addi $a0, $a0, -1 # else decrement n
        jal sum # recursive call

        lw $a0, 0($sp) # restore original n
        lw $ra, 4($sp) # and return address
        addi $sp, $sp, 8 # pop 2 items from stack

        add $v0, $a0, $v0 # changed to adding result

        jr $ra # and return

# Invalid Input Code

invalid:
            li $v0, 4                   # Load syscall code for printing a string
            la $a0, err_msg             # Load address of error message
            syscall                     # Print error message
            j main                      # Restart program

# Prompt for entering another Fib #

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
