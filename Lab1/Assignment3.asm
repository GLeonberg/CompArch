.data

	input: .asciiz "Please enter a positive number <= 1000: "
	even: .asciiz "The sum of all evens <= your num is: "
	odd: .asciiz "The sum of all odds <= your num is: "
	enter: .asciiz "\n"
	error: .asciiz "Invalid Input! Exiting Program!"

.text

main:
	# prompt for input
	ori $v0, $zero, 4
	la $a0, input
	syscall

	# get input
	ori $v0, $zero, 5
	syscall
	or $s0, $v0, $zero # move input to $s0

	# test for invalid input
	slti $t0, $s0, 1
	bne $t0, $zero, invalid
	slti $t0, $s0, 1001
	beq $t0, $zero, invalid
	

	ori $s4, $zero, 2 # 2 value for testing evens

	# $s1 for evensum total, $t0 for current even number
	evensum:
		beq $t0, $s0, oddsum # if num equal to input, done calc even sum
		addi $t0, $t0, 1 # increment even sum tester
		div $t0, $s4 # calc even number mod 2
		mfhi $t1 # load remainder into $t1
		bne $zero, $t1, evensum # if number is odd, check next number
		add $s1, $s1, $t0 # else add it to sum of evens
		j evensum

	# $s2 for oddsum total, $t4 for current odd number
	oddsum:
		beq $t4, $s0, end # if num equal to input, done calc odd sum
		addi $t4, $t4, 1 # increment odd sum tester
		div $t4, $s4 # calc odd number mod 2
		mfhi $t1 # load remainder into $t1
		beq $zero, $t1, oddsum # if number is even, check next number
		add $s2, $s2, $t4 # else add it to sum of odds
		j oddsum

	end:

	# print even sum
	la $a0, even
	ori $v0, $zero, 4
	syscall # print even string
	ori $v0, $zero, 1
	or $a0, $zero, $s1
	syscall # print even answer
	la $a0, enter
	ori $v0, $zero, 4
	syscall # print enter character

	# print odd sum
	la $a0, odd
	ori $v0, $zero, 4
	syscall # print odd string
	ori $v0, $zero, 1
	or $a0, $zero, $s2
	syscall # print odd answer
	la $a0, enter
	ori $v0, $zero, 4
	syscall # print enter character

	ori $v0, $zero, 10
	syscall

invalid:
	la $a0, error # load invalid message
	ori $v0, $zero, 4 # prep to print
	syscall # print invalid message
	ori $v0, $zero, 10 # prep to exit
	syscall # exit program