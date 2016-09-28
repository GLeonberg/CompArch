# Exercise1 is used in assignments 1 and 2 .text 0x00400000
# Calculates the value of 18 factorial	
 .globl main
 
main:
	lw $10, Number1($0) #load 18 into reg $t2 
	ori $11, $0, 1 # load 1 into $t3
	ori $9, $0, 1 # load 1 into $t1

# compute the factorial of Number ($10)!
factloop:
	bge $11, $10, factexit # exit if $t3 >= $t2
	mul $9, $10, $9 # $t1 = $t2 * $t1
	sub $10, $10, 1 # $t2--
	j factloop # jump to factloop

# the computation of the factorial is over
# Is the result in $9 correct? The result in $9 is in hexadecimal form
factexit:
 	li $2, 10 # load 10 into $v0
 	syscall # exit program
 	
 	.data 0x10000000
 	.align 2
	Number1: .word 18
