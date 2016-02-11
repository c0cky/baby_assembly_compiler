# RAL program to compute the sum and average of a list of numbers
#
# Input: a list of nonzero numbers, terminated with 0
#
# Output: the number of entries, the sum of the entries, the average of the
#         entries, rounded to the nearest integer
#
# No check is made for divide by zero.
#
	move	r1, 0	# r1 is the accumulator
	move	r2, 0	# r2 is the counter
$read_loop:
	read	r0
	cmp	r0, 0
	beq	$output
	add	r1, r0
	add	r2, 1
	b	$read_loop
$output:
	write	r2
	write	r1
	move	r3, r2
	div	r3, 2	# r3 holds half the size of the list
	move	r4, r1	# save the sum in r4
	div	r1, r2	# r1 holds the floor of the average
	mod	r4, r2	# r4 holds the remainder of the average
	cmp	r4, r3
	ble	$skip
	add	r1, 1	# round average up
$skip:
	write	r1

