;
; password.asm
;
; Created: 2/18/2018 3:28:43 PM
; Author : Elias
;
LDI R16, HIGH(RAMEND)
OUT SPH, R16
LDI R16, LOW(RAMEND)
OUT SPL, R16
SER R16
OUT DDRB, R16	;PORTB output
CLR R16
OUT DDRA, R16	;PINA input

LDI R20, 0		;Uses R20 as counter for number of inputs


start:
LDI R21, 3
SUB R21, R20
BREQ eval		;Evaluates password if counter is reached
IN R16, PINA
LDI R17, 0xFF
SUB R17, R16
BRNE input		;Jumps to input if any buttons pressed

OUT PORTB, R16
	JMP start


input:
	MOV R18, R16	;Loads input into R18
	PUSH R16		;Pushes input onto stack pointer
	INC R20			;Increments counter
again:
	IN R16, PINA		
	MOV R17, R18
	SUB R17, R16
	BRNE start	;Evaluates if input has changed, jumps back to start if it has.
	JMP again


eval:
	POP R1
	LDI R16, 0b11111110
	SUB R1, r16
	BRNE wrong
	POP R1
	LDI R16, 0b11111110
	SUB R1, r16
	BRNE wrong
	POP R1
	LDI R16, 0b11111110
	SUB R1, r16
	BRNE wrong
	RJMP right

wrong:
	LDI R16, 0x55
	RJMP blink

right:
	LDI R16, 0xFF
	RJMP blink

blink:
	COM R16
	OUT PORTB, R16
	CALL delay
	RJMP blink



delay:
	LDI R30, 0xFF
	LDI R31, 0xFF
	LDI R29, 0x10
L0:
	DEC R30
	BRNE L0
	DEC R31
	BRNE L0
	DEC R29
	BRNE L0
	RET