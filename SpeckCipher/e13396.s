@Speck Cipher...

.text

@------------------------------------------------------------------------------------------------
@this function rotates the given value left three times... 
rotateLeft:

@storing previous values of lr and below registers... 
	sub sp,sp,#16
	str r4,[sp,#0]
	str r5,[sp,#4]
	str r6,[sp,#8]
	str lr,[sp,#12]

	mov r6,#0


loop:
	cmp r6,#3
	beq exit

	add r6,r6,#1

	mov r4,r0

	lsr r0,r0,#31
	cmp r0,#1
	bne loop1
	mov r0,#1
	b loopCon

loopCon:

	mov r5,r1
	
	lsr r1,r1,#31
	cmp r1,#1
	bne loop2
	mov r1,#1
	b loopCon1

loopCon1:
	lsl r4,r4,#1
	add r4,r4,r1

	lsl r5,r5,#1

	add r5,r5,r0
	mov r0,r4
	mov r1,r5
	b loop

loop1:
	mov r0,#0
	b loopCon
loop2:
	mov r1,#0
	b loopCon1

exit:

	ldr r4,[sp,#0]
	ldr r5,[sp,#4]
	ldr r6,[sp,#8]
	ldr lr,[sp,#12]

	add sp,sp,#16

	mov pc,lr
@------------------------------------------------------------------------------------------------
@this function rotates the given value right eight times...

rotateRight:

@storing previous values of lr and below registers... 
	sub sp,sp,#16
	str r4,[sp,#0]
	str r5,[sp,#4]
	str r6,[sp,#8]
	str lr,[sp,#12]

	mov r6,#0


loopr:
	cmp r6,#8
	beq exit1

	add r6,r6,#1
	mov r4,r0

	and r4,r4,#1
	cmp r4,#1
	bne loopr1
	mov r4,#1
	b loopConr

loopConr:	
	
	
	mov r5,r1

	and r5,r5,#1
	cmp r5,#1
	bne loopr2
	mov r5,#1
	b loopConr1

loopConr1:

	lsl r5,r5,#31
	lsr r0,r0,#1

	add r0,r5,r0

	lsl r4,r4,#31
	lsr r1,r1,#1

	add r1,r4,r1

	b loopr

loopr1:
	mov r4,#0
	b loopConr
loopr2:
	mov r5,#0
	b loopConr1

exit1:

	ldr r4,[sp,#0]
	ldr r5,[sp,#4]
	ldr r6,[sp,#8]
	ldr lr,[sp,#12]

	add sp,sp,#16

	mov pc,lr

	.global main

main:
@------------------------------------------------------------------------------------------------
@storing previous values of lr and below registers... 
	
	sub sp,sp,#36
	str lr,[sp,#0]
	str r4,[sp,#4]
	str r5,[sp,#8]
	str r6,[sp,#12]
	str r7,[sp,#16]
	str r8,[sp,#20]
	str r9,[sp,#24]
	str r10,[sp,#28]
	str r11,[sp,#32]

		ldr	r0, =format1
		bl 	printf

		sub	sp, sp, #8 @allocating memory for getting inputs...

		ldr	r0, =formats @getting first 64bits of the key...
		mov	r1, sp	
		bl	scanf

		ldr	r5, [sp,#4] @loading the values into two registers...
		ldr	r4, [sp]

		ldr	r0, =formats @getting next 64bits of the key...	
		mov	r1, sp	
		bl	scanf
		
		ldr	r7, [sp,#4] @loading the values into two registers...
		ldr	r6, [sp]
	
		ldr	r0, =format2 @printing before getting the input...
		bl 	printf

		ldr	r0, =formats @getting first 64bits of the plain text...		
		mov	r1, sp	
		bl	scanf

		ldr	r9, [sp,#4] @loading the values into two registers...
		ldr	r8, [sp]

		ldr	r0, =formats @getting next 64bits of the plain text...	
		mov	r1, sp	
		bl	scanf

		ldr	r11, [sp,#4] @loading the values into two registers...
		ldr	r10, [sp]

		add sp,sp,#8 @restore the stack after getting inputs...
@------------------------------------------------------------------------------------------------
@encrypting process...

@doing one process before encrypting...
		mov r0,r8
		mov r1,r9
		bl rotateRight
		mov r8,r0
		mov r9,r1

		adds r8,r8,r10
		adc r9,r9,r11

		eor r8,r8,r6
		eor r9,r9,r7

		mov r0,r10
		mov r1,r11
		bl rotateLeft
		mov r10,r0
		mov r11,r1

		eor r10,r8,r10
		eor r11,r9,r11

		mov r12,#0
@encrypting process continued for 31 times...
encloop:
		cmp r12,#31
		beq exit2

		mov r0,r4
		mov r1,r5
		bl rotateRight
		mov r4,r0
		mov r5,r1

		adds r4,r4,r6
		adc r5,r5,r7

		eor r4,r4,r12
		eor r5,r5,#0

		mov r0,r6
		mov r1,r7
		bl rotateLeft
		mov r6,r0
		mov r7,r1

		eor r6,r6,r4
		eor r7,r7,r5

		mov r0,r8
		mov r1,r9
		bl rotateRight
		mov r8,r0
		mov r9,r1

		adds r8,r8,r10
		adc r9,r9,r11

		eor r8,r8,r6
		eor r9,r9,r7

		mov r0,r10
		mov r1,r11
		bl rotateLeft
		mov r10,r0
		mov r11,r1

		eor r10,r8,r10
		eor r11,r9,r11

		add r12,r12,#1
		b encloop

		
exit2:

	@printing the cipher text after encrypting....
		mov r1,r8
		mov r2,r9
		ldr	r0, =format3 			
		bl 	printf
 		
		mov r1,r10
		mov r2,r11
		ldr	r0, =format4
		bl 	printf

	mov	r0, #0 @restore values and releasing the stack...   
	ldr	lr, [sp, #0]
	ldr r4, [sp,#4]
	ldr r5, [sp,#8]
	ldr r6, [sp,#12]
	ldr r7, [sp,#16]
	ldr r8,[sp,#20]
	ldr r9,[sp,#24]
	ldr r10,[sp,#28]
	ldr r11,[sp,#32]
	add	sp, sp, #36
	mov	pc, lr

.data
	format1: .asciz "Enter the key:\n"
	formats: .asciz "%llx"
	format2: .asciz "Enter the plain text:\n"
	format3: .asciz "Cipher text is:\n%llx "
	format4: .asciz "%llx\n"
