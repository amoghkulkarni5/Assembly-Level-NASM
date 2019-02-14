;  			ASSIGNMENT 3 (BCD TO HEX, HEX TO BCD CONVERSION)

section .data
	msg1 db 10,"1. Hex to BCD."
	     db 10,"2. BCD to Hex."
	     db 10, "Your Choice: "
	len1 equ $-msg1

	inputbcd db 10,"Enter 5 digit BCD Number: "
	bcdlen equ $-inputbcd

	inputhex db 10,"Input Hex Number: "
	hexlen equ $-inputhex

	outputbcd db 10,"Equivalent BCD Number is: "
	opbcdlen equ $-outputbcd

	outputhex db 10,"Equivalent Hex Number is: "
	ophexlen equ $-outputhex

	newline1 db " ",10
	newlinelength equ $-newline1

	lastmsg db 10,"Do you want to try again?"
		db 10,"1. Yes"
		db 10,"2. No"
		db 10,"Your Choice: "
	lastlen equ $-lastmsg

	count db 0h
	multi db 0Ah

section .bss

	choice resb 02
	choice1 resb 02
	bcd resb 06
	hex1 resb 05
	hex resb 04

%MACRO newline 0
	MOV rax,1
	MOV rdi,1
	MOV rsi,newline1
	MOV rdx,newlinelength
	SYSCALL
%endMACRO

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
global _start
_start: 
	print msg1,len1
	input choice,02
	CMP byte[choice],31H
	JE HEXToBCD
	JMP BCDToHEX


HEXToBCD:

	print inputhex,hexlen
	input hex1,05
	call AtoH
	MOV rax,rbx
	XOR rdx,rdx
	XOR rbx,rbx
	XOR rcx,rcx
	MOV rbx,0Ah
	loop1:
		DIV rbx
		PUSH rdx
		INC byte[count]
		XOR rdx,rdx
		CMP rax,0h
		JNZ loop1
	XOR rcx,rcx
	MOV cl,byte[count]
	MOV rsi,bcd
	loop2: 
		POP rax
		ADD rax,30h
		MOV [rsi],rax
		INC rsi
	loop loop2
	print outputbcd,opbcdlen
	print bcd,05
	JMP exit
		
BCDToHEX:
	print inputbcd,bcdlen
	input bcd,05
	XOR rax,rax
	XOR rcx,rcx
	MOV rcx,05
	MOV rbx,0Ah
	MOV rsi,bcd
	loop3:
		XOR rdx,rdx
		MUL rbx
		XOR rdx,rdx
		MOV dl,byte[rsi]
		SUB dl,30h
		ADD rax,rdx
		INC rsi
	loop loop3
	MOV rbx,rax
	call HtoA
	newline
	print outputhex,ophexlen
	print hex,04
	JMP exit


exit:
	print lastmsg,lastlen
	input choice1,02
	CMP byte[choice1],31h
	JE _start
	MOV rax,60
	MOV rdi,0
	SYSCALL

 		;Convert ASCII To HEX For HEX Number
AtoH:	MOV rcx,04 
	MOV rsi,hex1
	XOR rbx,rbx
label: 	ROL bx,04
	MOV al,[rsi]
	CMP al,39h
	JBE a2
	SUB al,07h
a2:     SUB al,30h
	ADD bl,al
	INC rsi
	LOOP label
	RET

		;Convert HEX To ASCII For BCD Number
HtoA:	MOV rcx,04
	MOV rdi,hex
label2:	ROL bx,04
	MOV al,bl
	AND al,0Fh
	CMP al,09h
	JBE a3
	add al,07h
a3: 	add al,30h
	MOV [rdi],al
	INC rdi
	loop label2
	ret

