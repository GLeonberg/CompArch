# Gregory Leonberg

.data 0x10000800
	OrinRow_0: .word 1,2,3,4,5,6
	OrinRow_1: .word 7,8,9,10,11,12
	OrinRow_2: .word 13,14,15,16,17,18
	OrinRow_3: .word 19,20,21,22,23,24
	OrinRow_4: .word 25,26,27,28,29,30
	OrinRow_5: .word 31,32,33,34,35,36
.data 0x10001000
	TransRow_0: .word 0,0,0,0,0,0
	TransRow_1: .word 0,0,0,0,0,0
	TransRow_2: .word 0,0,0,0,0,0
	TransRow_3: .word 0,0,0,0,0,0
	TransRow_4: .word 0,0,0,0,0,0
	TransRow_5: .word 0,0,0,0,0,0

.text 0x00400000

# OrinRow 0 -> TransRow 3 (reversed)
# OrinRow 1 -> TransRow 4(reversed)
# OrinRow 2 -> TransRow 5 (reversed)
# OrinRow 3 -> TransRow 0 (reversed)
# OrinRow 4 -> TransRow 1 (reversed)
# OrinRow 5 -> TransRow 2 (reversed)

.globl main
main:

# OrinRow 0 -> TransRow 3 (reversed)
la $t0 OrinRow_0
addi $t0, $t0, 20
la $t1 TransRow_3

li $t2, 0

loop0:
	beq $t2, 6, endLoop0
	lw $t3, 0($t0) # load val from OrinRow
	sw $t3, 0($t1) # store val in TransRow
	addi $t0, $t0, -4
	addi $t1, $t1, 4
	addi $t2, $t2, 1
	j loop0
endLoop0:

# OrinRow 1 -> TransRow 4 (reversed)
la $t0 OrinRow_1
addi $t0, $t0, 20
la $t1 TransRow_4

li $t2, 0

loop1:
	beq $t2, 6, endLoop1
	lw $t3, 0($t0) # load val from OrinRow
	sw $t3, 0($t1) # store val in TransRow
	addi $t0, $t0, -4
	addi $t1, $t1, 4
	addi $t2, $t2, 1
	j loop1
endLoop1:

# OrinRow 2 -> TransRow 5 (reversed)
la $t0 OrinRow_2
addi $t0, $t0, 20
la $t1 TransRow_5

li $t2, 0

loop2:
	beq $t2, 6, endLoop2
	lw $t3, 0($t0) # load val from OrinRow
	sw $t3, 0($t1) # store val in TransRow
	addi $t0, $t0, -4
	addi $t1, $t1, 4
	addi $t2, $t2, 1
	j loop2
endLoop2:

# OrinRow 3 -> TransRow 0 (reversed)
la $t0 OrinRow_3
addi $t0, $t0, 20
la $t1 TransRow_0

li $t2, 0

loop3:
	beq $t2, 6, endLoop3
	lw $t3, 0($t0) # load val from OrinRow
	sw $t3, 0($t1) # store val in TransRow
	addi $t0, $t0, -4
	addi $t1, $t1, 4
	addi $t2, $t2, 1
	j loop3
endLoop3:

# OrinRow 4 -> TransRow 1 (reversed)
la $t0 OrinRow_4
addi $t0, $t0, 20
la $t1 TransRow_1

li $t2, 0

loop4:
	beq $t2, 6, endLoop4
	lw $t3, 0($t0) # load val from OrinRow
	sw $t3, 0($t1) # store val in TransRow
	addi $t0, $t0, -4
	addi $t1, $t1, 4
	addi $t2, $t2, 1
	j loop4
endLoop4:

# OrinRow 5 -> TransRow 2 (reversed)
la $t0 OrinRow_5
addi $t0, $t0, 20
la $t1 TransRow_2

li $t2, 0

loop5:
	beq $t2, 6, endLoop5
	lw $t3, 0($t0) # load val from OrinRow
	sw $t3, 0($t1) # store val in TransRow
	addi $t0, $t0, -4
	addi $t1, $t1, 4
	addi $t2, $t2, 1
	j loop5
endLoop5:

# exit program
li $v0, 10
syscall
