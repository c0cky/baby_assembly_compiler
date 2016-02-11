# Insertion-sort program to sort a list of 50 numbers given as input
#
# To alter the number of items to sort, edit the constant occurring in the next
# two lines.
	.alloc	list, 50
	move	r4, 50
	loada	r0, list
	move	r1, 0
$read_loop:
	cmp	r1, r4
	bge	$start_sorting
	read	r2
	store	r2, (r0)
	add	r0, 1
	add	r1, 1
	b	$read_loop	# 10
$start_sorting:
	.alloc	i
	move	r1, 0
	store	r1, i
$outer_loop:			# first i many items sorted
	load	r1, i
	add	r1, 1
	cmp	r1, r4
	bge	$done_sorting
	store	r1, i
	loada	r0, list
	add	r0, r1		# r0 points to first unsorted item
	load	r2, (r0)	# store this item in r2
$inner_loop:			# r2 == item to insert, r0 points to vacant slot
	cmp	r1, 0
	beq	$finish_inner	# 22
	sub	r0, 1
	load	r3, (r0)	# r3 holds the entry below the slot
	add	r0, 1
	cmp	r3, r2
	ble	$finish_inner	# done if entry below is <= item to insert
	store	r3, (r0)	# put entry below into slot
	sub	r0, 1
	sub	r1, 1		# 30
	b	$inner_loop
$finish_inner:
	store	r2, (r0)	# put item to insert into vacant slot
	b	$outer_loop
$done_sorting:
	loada	r0, list
	move	r1, 0
$write_loop:
	cmp	r1, r4
	bge	$quit
	load	r2, (r0)
	write	r2
	add	r0, 1		# 40
	add	r1, 1
	b	$write_loop
$quit:
