#-------------------------------------------
.data
#-------------------------------------------
	prompt: .asciiz "Please enter a number: "
	ans: .asciiz "The cube root is: "
	epsilon: .float 0.00001
	two: .float 2.0
	divthree: .float 0.3333333

#-------------------------------------------
.text
#-------------------------------------------

.globl main
main:

# read N into $f0
la $a0, prompt
li $v0, 4
syscall
li $v0, 6
syscall

# load input into xi
add.s $f1, $f0, $f31

# load epsilon
l.s $f2 epsilon

# load needed constants
l.s $f4, two
l.s $f5, divthree

#-------------------------------------------
#-------------------------------------------

calc:
	
	# calculate x(i+1), store in $f6
		mul.s $f6, $f4, $f1

		# intermediate term
		mul.s $f7, $f1, $f1
		div.s $f7, $f0, $f7

		# recombine to finish calc of x(i+1)
		add.s $f6, $f6, $f7
		mul.s $f6, $f6, $f5

	# |x(i+1) - x(i)| in reg $f7
	sub.s $f7, $f6, $f1
	abs.s $f7, $f7

	c.lt.s $f7, $f2 # check if difference less than epsilon
	bc1t end # if so, done
	add.s $f1, $f6, $f31 # otherwise set x(i) = x(i+1)
	j calc # and iterate again

end:

	# print answer
	la $a0, ans
	li $v0, 4
	syscall
	add.s $f12, $f6, $f31
	li $v0, 2
	syscall

	# exit progra
	li $v0, 10
	syscall
