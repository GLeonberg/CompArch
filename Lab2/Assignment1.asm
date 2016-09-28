.data
	prompt: .asciiz "Please enter a non-negative integer\n"
	answer: "The answer is: "
	invalid: .asciiz "Invalid input! Exiting Program!\n"

.text

j main
inv:
	la $a0, invalid # load invalid string address
	ori $v0, $zero, 4 # set syscall to print string
	syscall # print invalid input message

	ori $v0, $zero 10 # prep to exit
	syscall # eit program

zeroCase:
	or $s1, $zero, $zero
	j exit

main:
	la $a0, prompt # load prompt address into $a0
	ori $v0, $zero,4 # load 4 into $v0
	syscall # print prompt

	ori $v0, $zero, 5 # read user input integer
	syscall # read int
	or $s0, $v0, $zero # load user input into $s0

	slt $t0, $s0, $zero # check if user input negative
	bne $zero, $t0, inv # if so, jump to invalid

	beq $s0, $zero, zeroCase
	
loop:
	add $s1, $s1, $s0 # add user input variable to sum
	addi $s0, $s0, -1 # decrement user input variable
	beq $zero, $s0, exit # exit once user input is zero
	j loop # go back to loop

exit: 
	ori $v0, $zero, 4
	la $a0, answer
	syscall # print answer string

	ori $v0, $zero, 1
	or $a0, $zero, $s1
	syscall # print answer

	ori $v0, $zero, 10
	syscall # exit program
