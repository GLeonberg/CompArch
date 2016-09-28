.globl main
 
main:

## read x1
li $v0, 4 # prep to print string
la $a0, promptx # load prompt
syscall # print prompt
li $v0, 5 # prep to read value
syscall # read int value
move $s0, $v0 # store x1 in $s0

## read y1
li $v0, 4 # prep to print string
la $a0, prompty # load prompt
syscall # print prompt
li $v0, 5 # prep to read value
syscall # read int value
move $s1, $v0 # store y1 in $s1

## read x2
li $v0, 4 # prep to print string
la $a0, promptx # load prompt
syscall # print prompt
li $v0, 5 # prep to read value
syscall # read int value
move $s2, $v0 # store x2 in $s2

## read y2
li $v0, 4 # prep to print string
la $a0, prompty # load prompt
syscall # print prompt
li $v0, 5 # prep to read value
syscall # read int value
move $s3, $v0 # store y2 in $s3

## calculate Manhattan distance
sub $t0, $s0, $s2 # x = x1 - x2
sub $t1, $s1, $s3 # y = y1 - y2
add $s4, $t0, $t1 # m = x + y

## print Manhattan distance
li $v0, 4 # prep to print string
la $a0, result # load result string
syscall # print result string
or $a0, $zero, $s4 # load result in $a0
li, $v0, 1 # prep to print result
syscall # print result

## exit program
li $v0, 10 # prep to exit
syscall # exit program

.data
promptx: .asciiz "Please enter the x value: "
prompty: .asciiz "Please enter the y value: "
result: .asciiz "The Manhattan distance is: "