.data
	prompt0:		.asciiz		"Please enter an integer. "
	prompt1:		.asciiz		"Please enter a second integer. "
	prompt2:		.asciiz		"The product is: "
	product:		.word		0
	counter:		.byte		0
	max:		.byte		32
	
.text

	la $t0, prompt0		# loading the strings into addresses
	la $t1, prompt1
	
	# $t0 - $t2 are your strings!
	
	li $v0, 4		# printing the first string
	move $a0, $t0
	syscall
	
	li $v0, 5		# issuing the system call to read an integer from the terminal
	syscall
	
	move $t0, $v0		# saving said integer into a temporary register (freeing up $v0 for more syscalls)
	
	li $v0, 4		# printing the second string
	move $a0, $t1
	syscall
	
	li $v0, 5		# reading an integer once again
	syscall
	
	move $t1, $v0		# saving the second integer
	
	lb $t2, counter
	
	lw $t3, product
	
	lb $t5, max
	
	# $t0 is your multiplicand and $t1 is your multiplier!
	# $t3 is your PRODUCT
	
	# $t2 is your COUNTER, it is used to keep track of the loop!
	# $t5 is the MAX, used to compare against the counter
	
loopTop:
	andi $t4, $t1, 0x1	# Storing the rightmost bit of the multiplier into $t4
	
	bne $t4, $zero, notEqual	# Checking to see if the rightmost digit is a one
	
	sll $t0, $t0, 1			# If the rightmost digit is equal to zero
	srl $t1, $t1, 1		
	addi $t2, $t2, 1
	
	bne $t2, $t5, loopTop		# If the loop hasn't gone through 32 repetitions, continuing the loop
	
	la $t6, prompt2		# Loading the final string into memory
	li $v0, 4		# Call to print string
	move $a0, $t6
	syscall			# Printing string
	
	li $v0, 1		# Call to print integer
	move $a0, $t3		# Moving the product into the argument register
	syscall			# Printing product
	
	li $v0, 10		# Exiting the program
	syscall
	
	
notEqual:				# If the rightmost digit is 1
	add $t3, $t0, $t3	# Adding the multiplicand to the product and storing in product
	sll $t0, $t0, 1		# Shifting the bits in the multiplicand to the left
	srl $t1, $t1, 1		# Shifting the bits in the multiplier to the right
	addi $t2, $t2, 1	# incrementing counter
	j loopTop 		# Jumping to loopTop
	