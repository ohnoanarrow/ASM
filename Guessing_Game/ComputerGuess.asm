.data
	welcome:		.asciiz		"\nThink of an integer between 1-100, and I will guess it."
	instructions:	.asciiz		"\nIf I guess too high, enter 1. If it's too low, enter -1. If it's correct, enter 0."
	guess:		.asciiz		"\nIs your number "
	question:		.asciiz		"?"
	toohigh:		.asciiz		"\nI guess that was too high."
	toolow:		.asciiz		"\nYou're right, that was too low."
	justright:		.asciiz		"\nAh! So your answer is "
	next:		.asciiz		"! It took me "
	tries:		.asciiz		" tries to guess that."
	playagain:	.asciiz		"\nPlay again? (y/n)"
	y:		.asciiz		"y"
	farewell:		.asciiz		"Alrighty then. So long, and thanks for all the fish."
	
.text

Beginning:
	
	li $t0, 0		#Counter
	
	li $s0, 100		#This is the high/max value
	li $s1, 1		#This is the low/min value	
	
	jal PROC_START
	jal PROC_COMPUTE
	jal PROC_INPUT
	jal PROC_SUCCESS
	jal PROC_PLAYAGAIN
	
	beq $v0, $t2, Beginning	#Restarts the program (If the user entered y)
	
	la $a0, farewell
	li $v0, 4
	syscall
	
	li $v0, 10
	syscall
	
PROC_START:
	#Prologue
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	
	#Function Body
	la $a0, welcome
	li $v0, 4
	syscall
	
	la $a0, instructions
	li $v0, 4
	syscall
	
	#Epilogue
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
PROC_COMPUTE:
	#Prologue
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	
	#Funciton Body
	addi $t0, $t0, 1
	
	la $a0, guess
	li $v0, 4
	syscall
	
	#The equation I'm using will take a max and a min value, add them together, and then divide by two
	#This will have the program start its guess at half of the highest number, and work in halves from there
	add $s2, $s0, $s1	#Computes the first guess for the computer
	div $s2, $s2, 2
	
	move $a0, $s2	#Prints the guess 
	li $v0, 1
	syscall
	
	la $a0, question
	li $v0, 4
	syscall
	
	#Epilogue
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
PROC_INPUT:
	#Prologue
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	
	#Function Body
	li $v0, 5
	syscall
	
	bgt $v0, $zero, high		#If the guess is too high
	
	blt $v0, $zero, low		#If the guess is too low
	
	beq $v0, $zero, correct 	#If the guess is correct
	
high:
	la $a0, toohigh			#Computes a new number lower than the first then asks for user input again
	li $v0, 4
	syscall
	
	subi $s0, $s2, 1
	
	jal PROC_COMPUTE
	j PROC_INPUT

low:
	la $a0, toolow			#Computes a new number higher than the first then asks for user input again
	li $v0, 4
	syscall
	
	addi $s1, $s2, 1
	
	jal PROC_COMPUTE
	j PROC_INPUT

correct:
	
	#Epilogue
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
PROC_SUCCESS:
	#Prologue
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	
	#Function Body
	la $a0, justright
	li $v0, 4
	syscall
	
	move $a0, $s2			#Prints the guess
	li $v0, 1
	syscall
	
	la $a0, next
	li $v0, 4
	syscall
	
	move $a0, $t0			#Prints how many tries it took
	li $v0, 1
	syscall
	
	la $a0, tries
	li $v0, 4
	syscall
	
	#Epilogue
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra

PROC_PLAYAGAIN:
	#Prologue
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	
	#Function Body
	la $a0, playagain
	li $v0, 4
	syscall
	
	li $v0, 12			#Lets the user input a character y or n
	syscall
	
	la $t1, y
	lb $t2, 0($t1)			#Saves the letter y in $t2
	
	#Epilogue
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra