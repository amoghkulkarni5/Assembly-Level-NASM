
GLOBAL frequency,lines,spaces,answer

section .data

	msg4 db 10,"Enter character: "
	len4 equ $-msg4

;-------------------------------------------------------------------

section .bss
	character resb 02
	answer resw 01
	
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

EXTERN buffer,count


	frequency:
		XOR rcx,rcx
		XOR rax,rax
		XOR rbx,rbx

		print msg4,len4
		input character,02
		MOV rcx,[count]
		MOV rsi,buffer
		MOV dl,byte[character]
		XOR rax,rax
		loop1:
			CMP byte[rsi],dl
			JNE label1
			INC ax                ;RAX stores frequency
		label1: INC rsi
		loop loop1
	MOV [answer],ax
	RET

	lines:
		XOR rcx,rcx
		XOR rax,rax
		XOR rbx,rbx

		MOV rcx,[count]
		MOV rsi,buffer
		XOR rax,rax
		loop2:
			CMP byte[rsi],10
			JNE label2
			INC ax                		;RAX stores frequency
		label2: INC rsi
		loop loop2
	MOV [answer],ax
	RET

	spaces:
		XOR rcx,rcx
		XOR rax,rax
		XOR rbx,rbx

		MOV rcx,[count]
		MOV rsi,buffer
		XOR rax,rax
		loop3:
			CMP byte[rsi],20h
			JNE label3
			INC ax                		;RAX stores frequency
		label3: INC rsi
		loop loop3
	move:
	MOV word[answer],ax
	RET

	











