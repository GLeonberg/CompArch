.data
	prompt: .asciiz "Please enter an integer (<= 100)\n"
	answer: "The answer is: "
	invalid: .asciiz "Invalid input! Exiting Program!\n"
	none: .asciiz "No answers exist (but input was techinally valid)!"

.text

j main
inv:
	la $a0, invalid # load invalid string address
	ori $v0, $zero, 4 # set syscall to print string
	syscall # print invalid input message

	ori $v0, $zero 10 # prep to exit
	syscall # exit program

noans:
	la $a0, none # load none string address
	ori $v0, $zero, 4 # set to print string
	syscall # print no answers string

	ori $v0, $zero 10 # prep to exit
	syscall # exit program

main:
	# getting input
	la $a0, prompt # load prompt address into $a0
	ori $v0, $zero,4 # load 4 into $v0
	syscall # print prompt

	ori $v0, $zero, 5 # read user input integer
	syscall # read int
	or $s0, $v0, $zero # load user input into $s0

	# input checking
	ori $t1, $zero, 100 # load 100 into $t1 as temp
	sgt $t0, $s0, $t1 # check if user input less than 100
	bne $t0, $zero, inv # jump to invalid branch

	slt $t0, $s0, $zero # check if user input negative
	bne $t0, $zero, inv # if so, jump to invalid branch

	beq $s0, $zero, noans # if user inputs zero, no valid answers
	ori $s4, $zero, 1 # load 1 into $s4 for temp use
	beq $s4, $s0, noans # if user inputs one, no valid answers
	
	
	# start making primes
	addi $s1, $s1, 1

	primegen:
		or $s2, $zero, $zero # reset $s2 to zero
		ori $s2, $s2, 2 # start checking for primes with 2
		beq $s1, $s0, exit # exit once potential prime equal to user input
		addi $s1, $s1, 1 # s1 is potential prime number

		primeCheck:
			beq $s2, $s1, cont # exit if number is prime after testing
	
			div $s1, $s2 # modulus of potential prime by tester
			mfhi $t0 # load modulus into $t0
			beq $t0, $zero, primegen # if number is not prime, try next one
			addi $s2, $s2, 1 # increment prime tester
			j primeCheck
		
		cont:
			or $s3, $zero, $s1 # load prime into $s3
			j primegen # check for next prime
	
exit:
	ori $v0, $zero, 4
	la $a0, answer
	syscall # print answer string

	ori $v0, $zero, 1
	or $a0, $zero, $s3
	syscall # print closest prime

	ori $v0, $zero, 10
	syscall # exit program	
