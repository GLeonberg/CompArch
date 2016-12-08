# Gregory Leonberg
# gdl35
# 159-00-5392

.data 0x10000480
ArrA: .word 1 2 3 4 5 6 7
ArrB: .word 4 5 6 7 8 9 10 
.text
.globl main
main:
la $2, ArrA
la $3, ArrB
li $6, 1 # result=1
li $4, 7 #number of elements
loop:
lw $5, 0($2)
lw $7, 0($3)
sub $5, $5, $7
mul $6,$6,$5 #result= result * ArrA[i]-ArrB[i]
addi $2,$2,4
addi $3,$3,4
addi $4,$4,-1
bgt $4, $0, loop#end of program
li $2, 10
syscall
