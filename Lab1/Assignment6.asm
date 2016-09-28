.data 0x10000000
src: .word 5 4 3 2 1 0
dest: .word 0
	
.text 0x00400000
.globl main

or $a0, $zero, $zero # make sure $a0 is zero

main:
	lw $v1, src($a0) # read the next word
	addi $v0, $v0, 1 # increase the counter
	sw $v1, dest($a0) # store the word to the destination
	addi $a0, $a0, 4 # move the pointer to the next word
	addi $a1,$a1, 4 # move the pointer to the next word
	bne $v1, $zero, main # if the word is not 0 repeat the loop
	
	sub $v0, $v0, 1 # cancel counting of zero
	or $s0, $v0, $zero # load counter into $s0
	li $v0, 10 # prep to exit
	syscall # exit program