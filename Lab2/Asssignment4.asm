.data
	string1: .space 100
	string2: .space 100
	string3: .space 100
	prompt: .asciiz "\nPlease enter a string: \n"

.text

main:

	# prompt for first string
	ori $v0, $zero, 4
	la $a0, prompt
	syscall
	
	# read first string
	ori $a1, $zero, 100 # set string length 100
	la $a0, string1 # set string address to string1
	ori $v0, $zero, 8 # prep to read string
	syscall # read in up to 100 char string and store in string1

	# prompt for second string
	ori $v0, $zero, 4
	la $a0, prompt
	syscall

	# read second string
	ori $a1, $zero, 100 # set string length 100
	la $a0, string2 # set string address to string2
	ori $v0, $zero, 8 # prep to read string
	syscall # read in up to 100 char string and store in string1
	
	ori $s0, $zero, 100 # 100 as sentinel for loop

	readLoop:	
		beq $t0, $s0, endLoop
		lb $t1, string1($t0) # read $t0-th char of string1 into $t1
		lb $t2, string2($t0) # read $t0-th char of string2 into $t2

		beq $t1, $t2, equalChars
		# print non-matching character
		ori $v0, $zero, 11
		or $a0, $zero, $t2
		syscall
		
		# increment non-matching char counter
		addi $t3, $t3, 1

		equalChars:
		addi $t0, $t0, 1 # increment $t0
		j readLoop

	endLoop:








