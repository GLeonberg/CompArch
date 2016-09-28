# Used in assignment 4
# Registers used: $t0 - used to hold the first number.
# $t1 - used to hold the second number.
# $t2 - used to hold the difference of the $t1 and $t0.
# $v0 - syscall parameter and return value.
# $a0 - syscall parameter.
.globl main
 
main:

# print prompt for user input
li $v0, 4 # syscall for print string
la $a0, request # load prompt
syscall # print string

## Get first number from user, put into $t0.
li $v0, 5 # load syscall read_int into $v0.
syscall # make the syscall.
move $t0, $v0 # move the number read into $t0.

## Get second number from user, put into $t1.
li $v0, 5 # load syscall read_int into $v0.
syscall # make the syscall.
move $t1, $v0 # move the number read into $t1.

# print result
li $v0, 4 # prep to print
la $a0, output # load output text
syscall # print output text
li $v0, 1 # prep to print int
add $a0, $t0, $t1 # store sum in $a0
syscall # print sum

li $v0, 10 # prep to exit
syscall # exit program

.data
request: .asciiz "Please enter two integers: \n"
output: .asciiz "The result is: "
