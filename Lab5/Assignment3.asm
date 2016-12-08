# Gregory Leonberg

.data 0x10000860
	Vector_A: .word 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
.data 0x1000A000
	Matrix_B: .word 26,27,28,29,30
.data 0x1000A100
	.word 31,32,33,34,35
.data 0x1000A200
	.word 36,37,38,39,40
.data 0x1000A300
	.word 41,42,43,44,45
.data 0x1000A400
	.word 46,47,48,49,50
.data 0x1000B000
	Vector_C: .word 0

.text 0x00400000

# implements [C] = [A] .* [B]
.globl main
main:

# loop counters
li $t0, 0
li $t1, 0

# base addresses
la $t2, Vector_A
la $t3, Matrix_B
la $t4, Vector_C

# loop for rows
outer:
	beq $t1, 5, endOuter
	li $t0, 0 # reset inner loop counter

	# loop for each row
	row: 
		beq $t0, 5, endRow
		lw $t5, 0($t2) # load element from A
		lw $t6, 0($t3) # load element from B
		mul $t7, $t5, $t6 # find product
		sw $t7, 0($t4) # store result in C
		addi $t2, $t2, 4 # increment A pointer
		addi $t3, $t3, 4 # increment B pointer
		addi $t4, $t4, 4 # increment C pointer
		addi $t0, $t0, 1 # increment counter
		j row
	endRow:

	addi $t3, $t3, 236 # go to next line in B
	addi $t1, $t1, 1 # increment counter
	j outer

endOuter:

	# exit program
	li $v0, 10
	syscall
