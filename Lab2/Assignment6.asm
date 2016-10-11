#-----------------------------------------------------------
.data 0x10000000
#-----------------------------------------------------------
	enter: .asciiz "\n"
	search: .asciiz "\nEnter number to search: "
	nfind: .asciiz "\nNumber not found! Adding to array\n"
	yfind: .asciiz "\nNumber was found at location: "
	array: .word 4, 5, 23, 5, 8, 3, 15, 67, 8, 9, 0xFFFF

#------------------- ----------------------------------------
.text 0x00400000
#-----------------------------------------------------------

.globl main

main:
	
	# print sorted array
	la $a0, array
	jal sort
	la $a0, array
	jal printArr

startProg:
	# get user input
	la $a0, search
	ori $v0, $zero, 4
	syscall
	ori $v0, $zero, 5
	syscall
	or $s0, $v0, $zero # user input in $s0

	blt $s0, $zero, endProg # exit condition when user enters negative number

	# search array for $s0 and load result in $s1
	la $a0, array
	or $a1, $s0, $zero
	jal find
	or $s1, $v0, $zero

	# check if we need to append the number
	blt $s1, $zero, insertNum
	
	# print message saying we found the number and get another input
	la $a0, yfind
	ori $v0, $zero, 4
	syscall
	ori $v0, $zero, 1
	or $a0, $s1, $zero
	syscall
	j startProg

	# print message saying not found, append number, sort array, back to top
	insertNum:
		la $a0, nfind
		ori $v0, $zero, 4
		syscall
		la $a0, array
		or $a1, $zero, $s0
		jal append
		la $a0, array
		jal sort
		la $a0, array
		jal printArr
		j startProg

	endProg:
		ori $v0, $zero, 10
		syscall


#-----------------------------------------------------------
sort: # takes $a0 as base of array to sort via bubbleSort
#-----------------------------------------------------------

	# load argument into $t0
	add $t0, $a0, $zero

	# zero out needed registers	
	add $t1, $zero, $zero
	add $t2, $zero, $zero
	add $t3, $zero, $zero
	add $t4, $zero, $zero
	add $t5, $zero, $zero
	add $t6, $zero, $zero
	add $t7, $zero, $zero
	add $t8, $zero, $zero

	# calc len of array
	add $a3, $t0, $zero
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal len
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	add $t0, $zero, $v0 # length in $t0
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
			add $t5, $a0, $t2
			add $t6, $a0, $t2
			addi $t6, $t6, 4

			# if arr[i] < arr[i+1], swap
			lw $t3, 0($t5)
			lw $t4, 0($t6)

			bgt $t3, $t4, swapVals
			j endIn
			
			swapVals :
				or $a1, $t5, $zero
				or $a2, $t6, $zero 
				addi $sp, $sp, -4
				sw $ra, 0($sp)	
				jal swap
				lw $ra, 0($sp)
				addi $sp, $sp, 4

			endIn:
				
				addi $t8, $t8, 1
				mul $t2, $t8, 4
				j inBubble

	endOut:
		addi $s1, $s1, 1
		j outBubble

	endSort:
		jr $ra
	
#-----------------------------------------------------------
swap: # takes $a1, $a2 as pointers of words to swap
#-----------------------------------------------------------
	lw $t0, 0($a1)
	lw $t1, 0($a2)
	sw $t0, 0($a2)
	sw $t1, 0($a1)
	jr $ra

#-----------------------------------------------------------
len: # calculates length of array with base address $a3
#-----------------------------------------------------------

	# zero out needed registers for function
	add $t0, $zero, $zero
	add $t1, $zero, $zero
	add $t2, $zero, $zero
	add $t3, $zero, $zero

	# calculate length
	lenLoop:
		mul $t3, $t2, 4
		add $t1, $a3, $t3
		lw $t0, 0($t1)
		beq $t0, 0xFFFF, endLen
		addi $t2, $t2, 1
		j lenLoop

	endLen:
		add $v0, $zero, $t2
		jr $ra

#-----------------------------------------------------------
printArr: # prints array with base pointer $a0
#-----------------------------------------------------------

	# set needed registers to zero
	or $t0, $zero, $zero

	# load argument into $t1
	or $t1, $zero, $a0

	# print numbers in arr if not equal to sentinel 0xFFFF
	printLoop:
		lw $t0, 0($t1)
		beq $t0, 0xFFFF, endPrint
		
		# print number
		ori $v0, $zero, 4
		la $a0, enter
		syscall
		ori $v0, $zero, 1
		or $a0, $zero, $t0
		syscall

		# continue loop
		addi $t1, $t1, 4
		j printLoop

	endPrint:
		jr $ra

#-------------------------------------------------------------
find: # finds value $a1 in array with base $a0, or returns -1
#-------------------------------------------------------------

	# clear needed registers
	or $t1, $zero, $zero
	or $t2, $zero, $a0 # use $t2 for addressing array
	or $t3, $zero, $zero

	findLoop:
		
		lw $t1, 0($t2)
		beq $t1, 0xFFFF, notFound
		beq $t1, $a1, found
		addi $t2, $t2, 4 # increment pointer
		addi $t3, $t3, 1 # increment counter
		j findLoop

	notFound:	
		addi $v0, $zero, -1
		jr $ra

	found:
		add $v0, $zero, $t3
		jr $ra

#-----------------------------------------------------------
append: # appends $a1 at end of array with base $a0
#-----------------------------------------------------------

# clear needed registers
or $t0, $zero, $zero
or $t1, $zero, $zero

# store return address
addi $sp, $sp, -4
sw $ra, 0($sp)

# calculate length
add $a3, $zero, $a0
jal len

# move sentinel number 1 over and add user input
mul $v0, $v0, 4
add $v0, $v0, $a0
lw $t0, 0($v0) # load sentinel into $t0
sw $a1, 0($v0)
addi $v0, $v0, 4
sw $t0, 0($v0)

# return to calling function / main
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra
