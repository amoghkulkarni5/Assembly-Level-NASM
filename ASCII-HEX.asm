
section .data
	msg1 db 10,"Enter num1: "
	len1 equ $-msg1
	msg2 db "Enter num2: "
	len2 equ $-msg2
	msg3 db 10,"Addition is: "
	len3 equ $-msg3

section .bss
	num1 resb 3
	sum resb 2
	no resb 1

section .text
global _start
_start: 
	MOV rax,1                    ;Print Enter number 1
	MOV rdi,1
	MOV rsi,msg1
	MOV rdx,len1
	syscall 

	MOV rax,0		     ;Input number 1
	MOV rdi,1
	MOV rsi,num1
	MOV rdx,3
	syscall

	call AtoH
	MOV [no],bl

	MOV rax,1                    ;Print Enter number 2
	MOV rdi,1
	MOV rsi,msg2
	MOV rdx,len2
	syscall 

	MOV rax,0		     ;Input number 2
	MOV rdi,1
	MOV rsi,num1
	MOV rdx,3
	syscall

	call AtoH             	     ; Conver num2 and add
	add bl,[no]

	call HtoA                    ;Convert to ASCII    

	MOV rax,1                    ;Print Addition is
	MOV rdi,1
	MOV rsi,msg3
	MOV rdx,len3
	syscall 

	MOV rax,1                    ;Print sum
	MOV rdi,1
	MOV rsi,sum
	MOV rdx,02
	syscall 

	MOV rax,60
	MOV rdi,0
	syscall

 				     ;Convert ASCII To HEX
AtoH:	MOV rcx,02 
	MOV rsi,num1
	XOR rbx,rbx
label: 	rol bl,04
	MOV al,[rsi]
	CMP al,39h
	JBE a2
	sub al,07h
a2:     sub al,30h
	add bl,al
	inc rsi
	loop label
	ret
	
HtoA:	MOV rcx,02
	MOV rdi,sum
label2:	ROL bl,04
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
