.data
myarray:    .word 4, 1, 3, 2, 16, 9, 10, 14, 8, 7
arraysize:  .word 10
newline:    .asciiz "\n"
comma:      .asciiz ", "
str1:       .asciiz "The original array is: "
str2:       .asciiz "The sorted array is: "

.text
.globl main

main:
    li $v0, 4
    la $a0, str1
    syscall

    jal print_array

    jal sort

    li $v0, 4
    la $a0, str2
    syscall

    jal print_array

    li $v0, 10
    syscall

####################################################
# Print array procedure
print_array:
    addi $sp, $sp, -8
    sw $ra, 4($sp)
    sw $s0, 0($sp)

    la $s0, myarray       # $s0 holds base address
    lw $t0, arraysize     # size in $t0
    li $t1, 0             # index = 0

print_loop:
    beq $t1, $t0, print_done

    mul $t2, $t1, 4
    add $t3, $s0, $t2
    lw $a0, 0($t3)

    li $v0, 1             # print integer
    syscall

    addi $t1, $t1, 1
    beq $t1, $t0, print_loop

    li $v0, 4             # print comma
    la $a0, comma
    syscall

    j print_loop

print_done:
    li $v0, 4
    la $a0, newline
    syscall

    lw $ra, 4($sp)
    lw $s0, 0($sp)
    addi $sp, $sp, 8
    jr $ra

####################################################
# Sort procedure (Bubble sort)
sort:
    addi $sp, $sp, -8
    sw $ra, 4($sp)
    sw $s0, 0($sp)

    la $s0, myarray
    lw $t6, arraysize
    addi $t6, $t6, -1     # n-1 outer loops

    li $t0, 0             # i = 0
outer_loop:
    beq $t0, $t6, sort_done
    li $t1, 0             # j = 0

inner_loop:
    lw $t2, arraysize
    addi $t2, $t2, -1
    sub $t2, $t2, $t0
    beq $t1, $t2, outer_next

    la $t3, myarray
    mul $t4, $t1, 4
    add $t3, $t3, $t4
    lw $t5, 0($t3)
    lw $t7, 4($t3)

    ble $t5, $t7, skip_swap

    move $a0, $t3
    jal swap

skip_swap:
    addi $t1, $t1, 1
    j inner_loop

outer_next:
    addi $t0, $t0, 1
    j outer_loop

sort_done:
    lw $ra, 4($sp)
    lw $s0, 0($sp)
    addi $sp, $sp, 8
    jr $ra

####################################################
# Swap procedure
swap:
    lw $t0, 0($a0)
    lw $t1, 4($a0)
    sw $t1, 0($a0)
    sw $t0, 4($a0)
    jr $ra
