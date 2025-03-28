sum:

    addi $sp, $sp, -8 # adjust stack for 2 items
    sw $ra, 4($sp) # save return address
    sw $a0, 0($sp) # save argument

    slti $t0, $a0, 1 # test for n < 1
    beq $t0, $zero, L1

    addi $v0, $zero, 1 # if so, result is 1
    addi $sp, $sp, 8 # pop 2 items from stack
    jr $ra # and return

L1:

    addi $a0, $a0, -1 # else decrement n
    jal sum # recursive call

    lw $a0, 0($sp) # restore original n
    lw $ra, 4($sp) # and return address
    addi $sp, $sp, 8 # pop 2 items from stack

    add $v0, $a0, $v0 # changed to adding result

    jr $ra # and return