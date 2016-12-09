# Gregory Leonberg

.data
	space: .asciiz " "
	A: .word 2, -4, 4, 7, 11, 8
.text
.globl main
	main:
	# load base of array into $t0
	la $t9, A
	addi $t0, $zero, 6 # length in $t0
	addi $t7, $t0, -1 # len-1 for bubbleSort
	add $s1, $zero, $zero
	add $t2, $zero, $zero
	outBubble:
		beq $s1, $t7, endSort
		or $t8, $zero, $zero
		or $t2, $zero, $zero
		inBubble:
			beq $t8, $t7, endOut
			# pointers to values from arrays to check
			add $t5, $t9, $t2
			add $t6, $t9, $t2
			addi $t6, $t6, 4
			# if arr[i] < arr[i+1], swap
			lw $t3, 0($t5)
			lw $t4, 0($t6)
			bgt $t3, $t4, swapVals
			j endIn
			swapVals :
				lw $t0, 0($t5)
				lw $t1, 0($t6)
				sw $t0, 0($t6)
				sw $t1, 0($t5)
			endIn:
				addi $t8, $t8, 1
				mul $t2, $t8, 4
				j inBubble
	endOut:
		addi $s1, $s1, 1
		j outBubble
	endSort:
		# exit program
		li $v0, 10
		syscall
