	move	r1, 0
	move	r2, 0
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
	div	r3, 2
	move	r4, r1
	div	r1, r2
	mod	r4, r2
	cmp	r4, r3
	ble	$skip
	add	r1, 1
$skip:
	write	r1
