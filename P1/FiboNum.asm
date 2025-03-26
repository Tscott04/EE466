# fibonacci.s
# Asks for a number n (n >= 1). Then it calculates and prints
# the Fibonacci sequence up to the nth term.
#---------------------------------------------------------

              .data
prompt:       .asciiz "Enter a number (n ≥ 1): "       # Prompt message
err_msg:      .asciiz "Error: n must be >= 1. Try again.\n"  # Error message
result_msg:   .asciiz "Fibonacci sequence: \n"          # Fibonacci result header
continue_msg: .asciiz "Do you want to continue? (1: Yes, 0: No): " # Continuation message
newline:      .asciiz "\n"                            # Newline character

            .text
            .globl main

main:
            li $v0, 4                   # Load syscall code for printing a string
            la $a0, prompt              # Load address of the prompt message
            syscall                     # Print the prompt

            li $v0, 5                   # Load syscall code for reading an integer
            syscall                     # Read user input
            move $t0, $v0               # Store user input (n) in $t0

            # Bound check for n > 0

            blt $t0, 1, invalid   # If n < 1, jump to invalid


            # Print Fibonacci Sequence

            li $v0, 4                   # Load syscall code for printing a string
            la $a0, result_msg          # Load address of Fibonacci message
            syscall                     # Print the message

            li $t2, 1                   # Fib(n-2) = 1 (by definition)
            li $t3, 1                   # Fib(n-1) = 1 (by definition)

            # Print first Fibonacci number
            li $v0, 1
            move $a0, $t2               # Load Fib(1) = 1 into argument register
            syscall                     # Print Fib(1)

            li $v0, 4                   # Print newline
            la $a0, newline
            syscall

            # If n == 1, skip and ask if user wants to continue
            beq $t0, 1, continue

            # Print second Fibonacci number
            li $v0, 1
            move $a0, $t3               # Load Fib(2) = 1 into argument register
            syscall                     # Print Fib(2)

            li $v0, 4                   # Print newline
            la $a0, newline
            syscall

            # Initialize loop counter
            li $t1, 2                   # i = 2 (since 1,1 already printed)

loop:
            bge $t1, $t0, continue  # If i >= n, go to continuation prompt

            add $t4, $t2, $t3           # Fib(i) = Fib(i-1) + Fib(i-2)
            move $t2, $t3               # Shift Fib(i-1) to Fib(i-2)
            move $t3, $t4               # Shift Fib(i) to Fib(i-1)

            li $v0, 1                   # Load syscall code for printing an integer
            move $a0, $t4               # Load computed Fibonacci number
            syscall                     # Print Fibonacci number

            li $v0, 4                   # Print newline
            la $a0, newline
            syscall

            addi $t1, $t1, 1            # Increment loop counter (i++)
            j loop                  # Repeat loop


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
