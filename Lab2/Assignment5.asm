##--------------------------------------------------------------------------
.data 0x10000000
##--------------------------------------------------------------------------
	string1: .space 100
	string2: .space 100
	prompt: .asciiz "\nSet a password: \n"
	inv: .asciiz "Invalid Characters in Password!\n"
	len: .asciiz "Password must be 8-12 characters!\n"
	reenter: .asciiz "Re-enter the password\n"	
	notEqStr: .asciiz "\n\nThe passwords are not equal! \n Please re-enter the password: \n"
	stillNot: .asciiz "Still not equal!\n"
	ending: .asciiz "\n\nEnding Program!"
	none: .asciiz "\nNo attempts left. Setup Failed\n"
	good: .asciiz "\nPassword is set up\n"

##--------------------------------------------------------------------------
.text 0x00400000
##--------------------------------------------------------------------------

.globl begin

begin:
	# prompt for first string
	ori $v0, $zero, 4
	la $a0, prompt
	syscall
	
	# read first string
	ori $a1, $zero, 100 # set string length 100
	la $a0, string1 # set string address to string1
	ori $v0, $zero, 8 # prep to read string
	syscall # read in up to 100 char string and store in string1
	
	# check first string for invalid characters
	or $v0, $zero, $zero
	la $a0, string1 # argument for checkString	
	jal checkChar # check characters in first input
	add $s0, $v0, $zero # $s0 holds bad character flag

	# check first string for length
	la $a0, string1 # argument for checkLen
	jal checkLen # check length of first input
	addi $t0, $v0, -1 # load string length into $t0 (remove counting of newline)
	blt $t0, 8, badLen
	bgt $t0, 12, badLen
	j goodLen

	badLen:
		la $a0, len
		ori $v0, $zero, 4
		syscall
		j begin

	goodLen:
		bne $s0, $zero, begin

begin2:
	bgt $t7, 2, noMoreAtt
	# prompt for second string
	ori $v0, $zero, 4
	la $a0, reenter
	syscall
	
	# read second string
	ori $a1, $zero, 100 # set string length 100
	la $a0, string2 # set string address to string1
	ori $v0, $zero, 8 # prep to read string
	syscall # read in up to 100 char string and store in string1

	# check second string for character validity
	or $v0, $zero, $zero
	la $a0, string2 # argument for checkString	
	jal checkChar # check characters in first input
	add $s0, $v0, $zero # $s0 holds bad character flag

	# check second string for length validity
	la $a0, string2 # argument for checkLen
	jal checkLen # check length of first input
	addi $t0, $v0, -1 # load string length into $t0 (remove counting of newline)
	blt $t0, 8, badLen2
	bgt $t0, 12, badLen2
	j goodLen2

	badLen2:   
		la $a0, notEqStr
		ori $v0, $zero, 4
		syscall
		addi $t7, $t7, 1
		j begin2

	goodLen2:
		beq $s0, $zero, check2
		addi $t7, $t7, 1
		bne $s0, $zero, begin2
	
	# check second string matches first string
check2:
	la $a0, string1
	la $a1, string2
	jal strCmp 
	
	bne $v0, $zero, begin2
	
	# success message
	la $a0, good
	addi $v0, $zero, 4	
	syscall

	# end of program
	exit:
	addi $v0, $zero, 10
	syscall

##--------------------------------------------------------------------------
checkChar:
##--------------------------------------------------------------------------
	or $t0, $zero, $a0 # load base address of string into $t0
	addi $t1, $zero, 10
	checkLoop:
		lb $t2, 0($t0) # load character
		beq $t2, $t1, end # end checking once newline terminated

		blt $t2, 65, bad # check if definitely bad
		bgt $t2, 122, bad # check if definitely bad
		bgt $t2, 90, maybeBad # check for in between bad characters
		j notBad # if none of the above, definitely not bad

		maybeBad: blt $t2, 97, bad # check in between upper and lower case     
					j notBad # else not bad

		bad:	
			# print message saying bad input
			la $a0, inv
			ori $v0, $zero, 4
			syscall
			addi $v0, $zero, 1 # set flag in $v0 to say bad characters
			j end

		notBad:
			addi $t0, $t0, 1
			j checkLoop

		end: 
			jr $ra

##--------------------------------------------------------------------------
checkLen:
##--------------------------------------------------------------------------
	or $t0, $zero, $a0 # load base address of string in $t0
	add $t1, $zero, $zero # load zero into counter $t1

	lenLoop:
		
		lb $t3, 0($t0) # load character into $t3
		beq $t3, $zero, endFunc # end if character is null
		addi $t1, $t1, 1 # increment length counter
		addi $t0, $t0, 1 # increment pointer
		j lenLoop

		endFunc:
			add $v0, $t1, $zero # set length as return variable
			jr $ra

##--------------------------------------------------------------------------
strCmp:	
##--------------------------------------------------------------------------
		or $t8, $zero, $zero
		or $v0, $zero, $zero
		# load arguments into local registers
		or $t5, $a0, $zero
		or $t6, $a1, $zero

		# constant maxLen
		addi $s0, $zero, 100

cmpStart:

		beq $t8, $s0, endLoop
		lb $t1, 0($t5) # read $t0-th char of string1 into $t1
		lb $t2, 0($t6) # read $t0-th char of string2 into $t2
		
		beq $t1, $zero, maybeGood
		j cont
		maybeGood:
		beq $t2, $t1, endLoop
		cont:
		bne $t1, $t2, notEq
		
		# if chars are equal, check next set of chars
		equalChars:
			addi $t8, $t8, 1 # increment $t0
			# increment pointers
			add $t5, $a0, $t8
			add $t6, $a1, $t8
			j cmpStart

		# exiting loop
		endLoop:
			bne $t3, $zero, notEq # if strings not equal, tell user
			jr $ra # else go to end of program

		notEq:
			la $a0, notEqStr
			addi $v0, $zero, 4	
			syscall # tell user not equal
			addi $v0, $zero, 1 # set flag
			addi $t7, $t7, 1 # add to number of second pass attempts counter
			jr $ra

##--------------------------------------------------------------------------
noMoreAtt:
##--------------------------------------------------------------------------
	la $a0, none
	addi $v0, $zero, 4	
	syscall
	j exit
