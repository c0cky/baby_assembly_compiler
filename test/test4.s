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
	b	$read_loop
$start_sorting:
	.alloc	i
	move	r1, 0
	store	r1, i
$outer_loop:
	load	r1, i
	add	r1, 1
	cmp	r1, r4
	bge	$done_sorting
	store	r1, i
	loada	r0, list
	add	r0, r1
	load	r2, (r0)
$inner_loop:
	cmp	r1, 0
	beq	$finish_inner
	sub	r0, 1
	load	r3, (r0)
	add	r0, 1
	cmp	r3, r2
	ble	$finish_inner
	store	r3, (r0)
	sub	r0, 1
	sub	r1, 1
	b	$inner_loop
$finish_inner:
	store	r2, (r0)
	b	$outer_loop
$done_sorting:
	loada	r0, list
	move	r1, 0
$write_loop:
	cmp	r1, r4
	bge	$quit
	load	r2, (r0)
	write	r2
	add	r0, 1
	add	r1, 1
	b	$write_loop
$quit:
