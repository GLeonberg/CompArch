.text
.globl main
main:

# read a in $s0 and store copy in $t0
li $v0, 5
syscall
move $s0, $v0
or $t0, $s0, $zero

# read b in $s1
li $v0, 5
syscall
move $s1, $v0

multLoop:
	addi $s1, $s1, -1
	beq $s1, $zero, end
	add $s0, $s0, $t0
	j multLoop
end:

# print answer
li $v0, 1
move $a0, $s0
syscall

# exit program
li $v0, 10
syscall
