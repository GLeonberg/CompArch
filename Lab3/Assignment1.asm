.text
.globl main
main:

# read a in $s0
li $v0, 5
syscall
move $s0, $v0

# read b in $s1
li $v0, 5
syscall
move $s1, $v0

# read c in $s2
li $v0, 5
syscall
move $s2, $v0

# $t0 = not(a or c)
or $t0, $s0, $s2
not $t0, $t0

# $t1 = not(b and c)
or $t1, $s1, $s2
not $t1, $t1

# $t2 = $t0 and $t1
and $t2, $t0, $t1

# print the answer from $t2
move $a0, $t2
li $v0, 1
syscall

# exit program
li $v0, 10
syscall
