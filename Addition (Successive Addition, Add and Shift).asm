section .data

	msg1 db 10,"Multiplication",10,"1. Successive Addition.",10,"2. Add and Shift.",10,"Your Choice: "
	len1 equ $-msg1

	msg2 db 10,"Do you want to try again? (y/n): "
	len2 equ $-msg2

	msg3 db 10,"Enter 2 digit Multiplicand: "
	len3 equ $-msg3
	
	msg4 db "Enter 2 digit Multiplier: "
	len4 equ $-msg4

	lastmsg db 10,"Do you want to try again?"
		db 10,"1. Yes"
		db 10,"2. No"
		db 10,"Your Choice: "
	lastlen equ $-lastmsg
;------------------------------------------------------------------

section .bss

	choice resb 02
	buffer resb 03
	multiplicand resb 02
	multiplier resb 02
	result resd 01
	choice1 resb 02
	temp resb 01

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

;-------------------------------------------------------------------

section .text
global _start
_start:

	XOR rax,rax
	XOR rbx,rbx
	XOR rdx,rdx
	print msg1,len1
	input choice,02
	CMP byte[choice],31h
	JE succadd
	JMP addshift

	succadd:
		print msg3,len3			; Enter Multiplicand and convert to hex, store result in ACC
		input buffer,03
		call AtoH
		MOV rsi,multiplicand
		MOV [rsi],bl

		XOR rbx,rbx
		XOR rax,rax

		print msg4,len4
		input buffer,03
		call AtoH
		MOV rsi,multiplier
		MOV [rsi],rbx

		XOR rax,rax
		MOV cl,byte[multiplier]
		MOV rsi,multiplicand
		loop1: ADD rax,[rsi]
		loop loop1
		MOV rbx,rax
		call HtoA
		print result,04
	JMP exit


	addshift:
		print msg3,len3			; Accepting Input Numbers
		input buffer,03
		call AtoH
		MOV rsi,temp
		MOV [rsi],bl

		XOR rbx,rbx
		XOR rax,rax

		print msg4,len4
		input buffer,03
		call AtoH
		XOR rax,rax
		XOR rdx,rdx
  						; Main loop
		MOV dl,byte[temp]
		MOV cx,08h
		loop2:
			SAR bl,1
			JNC label3
			ADD rax,rdx
		    label3:  SAL dx,1
		loop loop2
	
		XOR rbx,rbx
		MOV rbx,rax
		call HtoA
		print result,04

;--------------------------- EXIT Call --------------------------------


exit:
	print lastmsg,lastlen
	input choice1,02
	CMP byte[choice1],31h
	JE _start
	MOV rax,60
	MOV rdi,0
	SYSCALL



;-----------------------Helper Functions--------------------------------


 				     ;Convert ASCII To HEX for Multiplicand
AtoH:	MOV rcx,02
	XOR rsi,rsi
	MOV rsi,buffer
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
			
HtoA:	MOV rcx,04
	MOV rdi,result
	label2:	ROL bx,04
		MOV al,bl
		AND al,0Fh
		CMP al,09h
		JBE a3
		ADD al,07h
	a3: 	ADD al,30h
		MOV [rdi],al
		INC rdi
	LOOP label2
	RET





