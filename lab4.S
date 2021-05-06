.global lab4
.syntax unified
#define x1 #18
#define x2 #-9
#define x3 #23
lab4:
	push {lr}
	bl task1
	bl task2
	pop {pc}
task1:
	push {lr}
	mov r0, x1
	mov r1, #0
	mov r2, x2
	mov r3, #0xFFFFFFFF
	// ~x3
	mvn r4, x3  
	mov r5, #0
	// F = (x1 | x2 / 2)/8 - 2(~x3 ^ 1) 
	// x2 / 2
	asr r2, #1
	lsr r3, #1
	// x1 | x2
	orr r0, r2
	orr r1, r3
	// (x1 | x2 / 2)/8
	asr r0, #3
	asr r1, #1
	asr r1, #1
	asr r1, #1
	// ~x3 ^ 1
	eor r4, #1
	eor r5, #1
	// 2(~x3 ^ 1) 
	lsl r4, #1
	lsl r5, #1
	// (x1 | x2 / 2)/8 - 2(~x3 ^ 1) 
	sub r0, r4
	sbc r1, r5 
	bl correction
	pop {pc}

correction:
	push {lr}
	bvc step2
	lsr r0, #1
	lsr r1, #1
step2:
	orr r0, #0
	bne step4
	orr r1, #0
	bne step4
step3:
	mov r0, #0b10110110
step4:
	add r1, #0b10110110
step5:
	and r5, r1, #0xc0000000
	beq step7
	eor r5, #0xc0000000
	beq step7
step6:
	lsr r0, #1
	lsr r1, #1
step7:
	bvs correction_end
	push {r0}
	push {r1}
	pop {r1}
	pop {r0}
correction_end:
	pop {pc}

task2:
	push {lr}
	mov r0, #10
	mov r1, #5
	mov r2, #20
program_a:
	// 1: r0 = r1 + r2
	add r0, r1, r2
	// 2: r0 = r2 / r1
	udiv r0, r2, r1
jmp3:
	// 3: r0 = r1 - r2
	sub r0, r1, r2
	bl program_b
	// 4: jmp1
	bmi jmp1

	// 6: r0 = r0 - 15
	sub r0, #15 
	b jmp2
jmp1:
	// 5: r0 = r1 * r2
	mul r0, r1, r2
	// 7: r0 = r0 + 10
	add r0, #10
jmp2:
	// 8: jmp3
	bvs jmp3
	// 9: r0 = r0 * 4
	lsl r0, #2
	pop {pc}
program_b:
	push {lr}
jmp5:
	// 10: r1 = r1 + 5	
	add r1, #5
	// 11: jmp4
	bne jmp4
	// 12: r1 = r1 - r2
	sub r1, r2
	bl program_c
jmp4:
	// 13: jmp5
	bmi jmp5
	// 14: r1 = r1 * 8
	lsl r1, #3
	// 15: r1 = r1 - 15
	sub r1, #15
	pop {pc}
program_c:
	push {lr}
	// 17: r2 = r1 + r0
	add r2, r1, r0
	// 18: r2 = r2 * 4
	lsl r2, #2
	pop {pc}
