.data
	prompt0:		.asciiz		"Please enter an integer. "
	prompt1:		.asciiz		"Please enter a second integer. "
	prompt2:		.asciiz		"The product is: "
	
.text

	la $t0, prompt0		# loading the strings into addresses
	la $t1, prompt1
	la $t2, prompt2
	
	li $v0, 4		# printing the first string
	move $a0, $t0
	syscall
	
	li $v0, 5		# issuing the system call to read an integer from the terminal
	syscall
	
	move $t3, $v0		# saving said integer into a temporary register (freeing up $v0 for more syscalls)
	
	li $v0, 4		# printing the second string
	move $a0, $t1
	syscall
	
	li $v0, 5		# reading an integer once again
	syscall
	
	move $t4, $v0		# saving the second integer
	
	mult $t3, $t4		# multiplying the two numbers entered
	mflo $t5
	
	li $v0, 4		# printing the final string 
	move $a0, $t2
	syscall
	
	li $v0, 1		# printing the product of the two numbers
	move $a0, $t5
	syscall
	
	li $v0 10 		# exiting the program
	syscall
