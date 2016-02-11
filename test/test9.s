	.alloc	list, 10
	loada	r0, list
$foo:
	move	r1, r0
	add	r1, 10
$foo:
	cmp	r0, r1
	bgt	$bar
	load	r2, a
	.alloc	a
	.alloc	list
$quit:
