
section .data

	msg1 db "Factorial is : "
	len1 equ $-msg1
	msg2 db " ",10
	len2 equ $-msg2
	
section .bss
	number resq 01
	result resq 01
	
%MACRO print 2
	MOV rax,1
	MOV rdi,1
	MOV rsi,%1
	MOV rdx,%2
	SYSCALL
%endMACRO

%MACRO input 2
	MOV rax,0
	MOV rdi,1
	MOV rsi,%1
	MOV rdx,%2
	SYSCALL
%endMACRO


section .text
GLOBAL _start
_start:
	
	POP rdi	   ; No of arguments
	POP rdi	   ; File path
	POP rdi	   ; Required Number
	CALL AtoH

	MOV rax,01h
	factorial:
		MUL rbx
		DEC rbx
		CMP rbx,01
		JB exit
		JMP factorial

exit: 	MOV rbx,rax
	CALL HtoA
	print msg1,len1
	print result,16
	
	MOV rax,60
	MOV rdi,0
	SYSCALL



					;Convert Hex to ASCII
HtoA:

	MOV rcx,16
	MOV rsi,result
	label2:
		ROL rbx,04
		MOV al,bl
		AND al,0FH
		CMP al,09
		JBE a1
		ADD al,07H
	a1:
		ADD al,30H
		MOV [rsi],al
		INC rsi
		LOOP label2
	RET

 				     ;Convert ASCII To HEX
AtoH:	MOV rcx,02 
	XOR rbx,rbx
	label: 	ROL bl,04
		MOV al,[rdi]
		CMP al,39h
		JBE a2
			CMP al,20h
			RET
		SUB al,07h
	a2:     SUB al,30h
		ADD bl,al
		INC rdi
		LOOP label
	RET
