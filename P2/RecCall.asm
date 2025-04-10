# SUM.s
# Asks for a number n (n >= 1). Then it calculates and prints
# the Sum up to the nth term recursively.
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
        li $v0, 4                      # Load syscall code for printing a string
        la $a0, prompt                 # Load address of prompt message
        syscall                        # Print prompt message to ask for n

        li $v0, 5                      # Load syscall code for reading an integer
        syscall                        # Read integer input from user
        move $t0, $v0                  # Store user input (n) in $t0

        blt $t0, 1, invalid            # If n < 1, jump to invalid label to display error

        li $v0, 4                      # Load syscall code for printing a string
        la $a0, result_msg             # Load address of result message
        syscall                        # Print "Sum is: "

        move $a0, $t0                  # Pass n (stored in $t0) as argument to sum function
        jal sum                        # Call recursive sum function

        move $t1, $v0                  # Move returned result from sum into $t1

        li $v0, 1                      # Load syscall code for printing an integer
        move $a0, $t1                  # Move sum result into $a0 for printing
        syscall                        # Print sum result

        li $v0, 4                      # Load syscall code for printing a string
        la $a0, newline                # Load address of newline string
        syscall                        # Print newline

        j continue                     # Jump to continue label to ask user to continue or exit

    # Chen Liu Code
    #---------------------------------------------------------

sum:
    addi $sp, $sp, -8                 # Create stack frame (reserve space for $ra and $a0)
    sw $ra, 4($sp)                    # Save return address ($ra) on stack
    sw $a0, 0($sp)                    # Save current argument n ($a0) on stack

    li $t1, 1                         # Load constant 1 into $t1 for base case comparison
    beq $a0, $t1, base_case           # If n == 1, go to base_case

    addi $a0, $a0, -1                 # Decrement n (a0 = a0 - 1)
    jal sum                           # Recursive call: sum(n-1)

    lw $a0, 0($sp)                    # Restore original n from stack to $a0
    lw $ra, 4($sp)                    # Restore return address from stack to $ra
    addi $sp, $sp, 8                  # Free stack space (clean up stack frame)

    add $v0, $v0, $a0                 # Add n to sum(n-1), store result in $v0
    jr $ra                            # Return to caller

base_case:
    li $v0, 1                         # Base case: sum(1) = 1, load 1 into $v0
    lw $ra, 4($sp)                    # Restore return address from stack
    addi $sp, $sp, 8                  # Free stack space (clean up stack frame)
    jr $ra                            # Return to caller

    #---------------------------------------------------------

# Invalid Input Code
#---------------------------------------------------------

invalid:
            li $v0, 4                 # Load syscall code for printing a string
            la $a0, err_msg           # Load address of error message
            syscall                   # Print error message: "Error: n must be >= 1..."
            j main                    # Jump back to main to prompt for input again

# Prompt for entering another SUM
#---------------------------------------------------------

continue:
            li $v0, 4                 # Load syscall code for printing a string
            la $a0, continue_msg      # Load address of continuation prompt
            syscall                   # Print: "Do you want to continue? (1: Yes, 0: No): "

            li $v0, 5                 # Load syscall code for reading an integer
            syscall                   # Read user input (1 to continue, 0 to exit)
            beqz $v0, exit            # If input is 0 (false), jump to exit
            j main                    # If input is 1 (true), restart from main

# Exit code
#---------------------------------------------------------

exit:
            li $v0, 10                # Load syscall code for exiting program
            syscall                   # Exit program