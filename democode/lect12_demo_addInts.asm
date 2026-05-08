# addInts.asm
# Demo for CS 64, (c) 2026 by Z.Matni
# 
# Example of a recursive function using the call stack
# Equivalent C++ code:
#
# int addInts(int n) {
#    if (n <= 0) return 0;           // base case
#    return ( n + addInts(n-1) );    // recursive case }

.text

addInts:
# $a0: n
# $v0: result
# addInts(n) = sum of all numbers from 0 to n

    addiu $sp, $sp, -8 	# PUSH $ra and $s0 into stack
    sw $ra, 4($sp)
    sw $s0, 0($sp)

    move $s0, $a0       # preserve a0 (variable n)

    li $v0, 0					# Set initial value for v0 for accumulated sum
    ble $a0, $zero, return    	# If size <= 0, then you've reached the base case
		# Note: You can make the program more efficient
		#       if you make v0 = 1 and check for a0 <= 1

    addi $a0, $a0, -1   # n is now: n - 1
    jal addInts         # recursive call

return:
    add $v0, $v0, $s0   # add n to $v0

    lw $ra, 4($sp)      # POP $ra and $sa back from stack
    lw $s0, 0($sp)
    addiu $sp, $sp, 8

    jr $ra

main:
    li $a0, 3       # n = 3 (arbitrary, for this example)
    jal addInts     # call function for arg = 3, where do I expect the answer??

exit:
    move $a0, $v0	# print the answer (expected to be 1+2+3 = 6)
    li $v0, 1
    syscall

    li $v0, 10		# exit program
    syscall
