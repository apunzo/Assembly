# Antonio Punzo
# Homework #7 -Arrays and Loops
# Oct. 27, 2014
# Base program for Homework #7 Floating Point values V2 
# Register legend
#$v0 = register for syscall codes 
#$a0 = store address of memory for syscall code to reference
#$s0 = base address of memory/memory address for val1
#$s2 = value for floating point value 1
#$s3 = value for floating point value 2
#$s4 = sign bit for floating point value 1
#$s5 = exponent bits for floating point value 1
#$s6 = significand with implicit 1 for floating point value 1
#$t0 = mask values to calculate sign bit, exponent bits, and significand
#$t4 = sign bit for floating point value 2
#$t5 = exponent bits for floating point value 2
#$t6 = significand with implicit 1 for floating point value 2
#$f0 = temporary storage for floating point values 1 and 2 to be stored
#$f12 = temporary storage for floating point values 1 and 2 to be printed


	.data
val1:	.word	00000000				# first floating-point value
val2:	.word	00000000				# second floating-point value
sign:	.word	0x80000000
exp:	.word	0x7f800000
signf:	.word	0x007fffff
signf2:	.word	0x00800000
result:	.word	00000000
strng1: .asciiz "This Program Will Multiply Two Floating Point Numbers\n Enter a floating point number:"	# input prompt #1 for user
strng2: .asciiz "Enter another floating-point number:"	# input prompt #2 for user
strng3: .asciiz "The Answer is\n"	# output message

	.text
main:	
	lui	$s0, 0x1001		# base address of memory
	jal	getval			# call subroutine to read values from user input
	
	# Seperation of first floating point value into sign bit, exponent and significand
	
	
	lw	$t0, 8($s0)		# load word from $s0 with offset 8 to $t0
	and	$s4,$s2,$t0		# Extract sign bit
	lw	$t0, 12($s0)		# load word from $s0 with offset 12 to $t0
	and	$s5,$s2,$t0		# Extract exponent
	srl	$s5,$s5,23		# Shift exponent to LSB
	lw	$t0,16($s0)		# load word from $s0 with offset 16 to $t0
	and	$s6,$s2,$t0		# Extract significand
	lw	$t0,20($s0)		# load word from $s0 with offset 20 to $t0
	or	$s6,$s6,$t0		# add the implicit 1 to significand
	
	# Seperation of second floating point value into sign bit, exponent and significand
	
	
	lw	$t0, 8($s0)		# load word from $s0 with offset 8 to $t0
	and	$t4,$s3,$t0		# Extract sign bit
	lw	$t0, 12($s0)		# load word from $s0 with offset 12 to $t0
	and	$t5,$s3,$t0		# Extract exponent
	srl	$t5,$t5,23		# Shift exponent to LSB
	lw	$t0, 16($s0)		# load word from $s0 with offset 16 to $t0
	and	$t6,$s3,$t0		# Extract significand
	lw	$t0, 20($s0)		# load word from $s0 with offset 24 to $t0
	or	$t6,$t6,$t0		# add the implicit 1 to significand
	
	jal	printval		# call subroutine to print values in I/O
	

exit:	
	ori	$v0, $zero, 10
	syscall
	
# subroutine getval to read data values from user input
getval:
	li	$v0,4		# syscall code for printing string in $v0
	la	$a0, strng1	# load address of strng1 in $a0
	syscall 		# print strng1 on console
	li	$v0, 6		# syscall code for reading single float
	syscall			# read single float value placed in $v0
	
	
	mfc1	$s2, $f0	# copy value in FPR($f0) to a GPR($s2)
	sw	$s2, 0($s0)	# store value from $s2 in memory $s0
	
	li	$v0,4		# syscall code for printint string in $v0
	la	$a0, strng2	# load address of strng2 in $a0
	syscall 		# print strng2 on console
	
	li	$v0, 6		# syscall code for reading single float
	syscall			# read single float value placed in $v0
	
	mfc1	$s3, $f0	# copy value in FPR($f0) to a GPR($s3)
	sw	$s3, 4($s0)	# store value from $s3 in memory $s0 offset by 4 
	jr	$ra		# return from subroutine

# subroutine printval to print data values to console
printval:
	
	mtc1	$s2,$f0		# copy value in GPR($s2) to FPR($f0)
	mtc1	$s3,$f1		# copy value in GPR($s3) to FPR($f1)
	mul.s	$f12,$f1,$f0	# mutiply the values in $f0 and $f1 and store answer in $f12
	swc1	$f12,24($s0)	# store answer from $f12 to base address offset by 24 in memory
	
	li	$v0,4		# syscall code for printint string in $v0
	la	$a0, strng3	# load the address of strng3 in $a0
	syscall 		# print string 3 on console
	
	
	
	li	$v0, 2		# syscall code for reading floating-point value
	syscall			# print float point value from $s0 to console

	
	jr	$ra		# return from subroutine
	
