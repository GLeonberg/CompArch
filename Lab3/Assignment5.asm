#-------------------------------------------
.data
#-------------------------------------------

	pi: .float 3.14159
	third: .float 0.333333333
	height: .asciiz "Enter the height: "
	rad: .asciiz "Enter the radius: "
	vol: .asciiz "The volume is: "

#-------------------------------------------
.text
#-------------------------------------------

.globl main
main:

# read radius into reg $f2
la $a0, rad
li $v0, 4
syscall
li $v0, 6
syscall
add.s $f2, $f0, $f30

# read height into reg $f4
la $a0, height
li $v0, 4
syscall
li $v0, 6
syscall
add.s $f4, $f0, $f30

# calculate the volume and store in reg $f6
l.s $f10, pi($0)
l.s $f8, third($0)
mul.s $f6, $f10, $f8
mul.s $f6, $f6, $f2
mul.s $f6, $f6, $f2
mul.s $f6, $f6, $f4

# print volume
la $a0, vol
li $v0, 4
syscall
add.s $f12, $f6, $f30
li $v0, 2
syscall

# exit program
li $v0, 10
syscall
