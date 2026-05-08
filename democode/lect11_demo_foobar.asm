# Equivalent to this C++ code:
#	int foo(int a0) {
#		return a0*a0 + 2;
#	}
#	int bar(int a0) {
#		return foo(2*a0) + 1;
#	}
#	int main() {
#		int user;
#		cin >> user;
#		if (user > 5) {
#			user += bar(user);
#		}
#		cout << user;
#		return 0;
#	}

.text
foo:    
# This function does not any function itself,
#    so, there's no need to save $ra
    mult $a0, $a0
    mflo $v0
    addi $v0, $v0, 2
    jr $ra

bar:
# This function calls foo(), so it NEEDS to save $ra
#    before it does the function call!

# ALWAYS PUSH AT THE START OF THE PROGRAM AND POP AT THE END!!!

# PUSH $ra into stack
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    sll $a0, $a0, 1
    jal foo
    addi $v0, $v0, 1

# POP $ra into stack
    lw $ra, 0($sp)
    addi $sp, $sp 4

    jr $ra

main:
# Get user variable, put in $v0
    li $v0, 5
    syscall

# Copy user into $a0 (it's going to be a function argument)
    move $a0, $v0

# Compare user to 5: if user <= 5 then go print, otherwise (x > 5), user is added to bar(user)
    li $t0, 5
    ble $a0, $t0, print

# Put a copy of $a0 (user) in $s0 to preserve it (b/c you need user to do: user = user + bar(user))
    move $s0, $a0
    jal bar

# Add returned value to user, i.e. user = user + bar(user)
    add $a0, $s0, $v0	# s0=user, v0=bar(user), a0=their sum, to be printed

# Print and Exit Program
print:
    li $v0, 1
    syscall

    li $v0, 10
    syscall