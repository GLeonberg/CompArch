#-------------------------------------------
.data
#-------------------------------------------

	prompt: .asciiz "Please enter a number: "
	ans: .asciiz "The answer is: "
	null: .asciiz "No numbers bigger than input!"
	arr: .float 1.35 2.67 3.566 4.56 5.98 9.43 12.34 15.54 23.87 34.33

#-------------------------------------------	
.text
#-------------------------------------------

.globl main
main:

	# print prompt
	la $a0, prompt
	li $v0, 4
	syscall

	# read user input into reg $f0
	li $v0, 6
	syscall

	# iterate along arr and calculate sum
	iterArr:

		l.s $f1, arr($s0) # load number from arr

		# exit if null termination reached
		c.eq.s $f1, $f31
		bc1t end

		# else check if current element greater than input
		c.lt.s $f0, $f1
		bc1f next
		add.s $f12, $f12, $f1
		addi $t0, $t0, 1 # increment flag

		next: addi $s0, $s0, 4 # increment pointer to next element

		j iterArr

	end:

		beq $t0, $zero, flag

		# print answer text
		la $a0, ans
		li $v0, 4
		syscall

		# print answer number
		li $v0, 2
		syscall

		j endProg
	
	# print message saying no numbers bigger in arr
	flag:
		la $a0, null
		li $v0, 4
		syscall

	# exit program
	endProg:
		li $v0, 10
		syscall
