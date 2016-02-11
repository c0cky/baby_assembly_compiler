        .alloc  numlist, 10
        loada   r0, numlist
        move    r1, r0
        add     r1, 10
$read_loop:
        cmp     r0, r1
        bge     $write_loop
        read    r2
        store   r2, (r0)
        add     r0, 1
        b       $read_loop
$write_loop:
        loada   r1, numlist
        cmp     r0, r1
        ble     $quit
        sub     r0, 1
        load    r2, (r0)
        write   r2
        b       $write_loop
$quit:
