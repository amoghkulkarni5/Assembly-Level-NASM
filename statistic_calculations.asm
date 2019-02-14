%macro print 2

	MOV rax,1
	MOV rdi,1
	MOV rsi,%1
	MOV rdx,%2
	SYSCALL
	
%endmacro

%macro input 2

	MOV rax,0
	MOV rdi,2
	MOV rsi,%1
	MOV rdx,%2
	SYSCALL
	
%endmacro

section .data

	;array dd 123.12,78.42,128.11,14.15,98.12
	array dd 1.00,2.00,3.00,4.00,5.00
	arcnt dw 05
	h dd 100
	msg db "."
	len equ $-msg
	msg1 db "Mean is : "
	len1 equ $-msg1
	msg2 db "Variance is : "
	len2 equ $-msg2
	msg3 db "Standard Deviation is : "
	len3 equ $-msg3
	msgn db "",10
	lenn equ $-msgn
	cnt db 08
	
section .bss

	mean resd 01
	result rest 01
	var resd 01
	sd resd 01
	sum resb 02
	
section .text

global _start

_start:
	XOR rsi,rsi
	MOV rsi,array	
	
	FINIT
	
	FLDZ
	
	XOR rcx,rcx
	MOV cl,05
up1:
	FADD dword[rsi]
	
	ADD rsi,04
	
	LOOP up1
	
	FIDIV word[arcnt]
	
	FST dword[mean]
	
	FIMUL dword[h]
	
	FBSTP [result]
	
	print msg1,len1
	XOR rsi,rsi
	MOV rsi,result+08
at1:
	MOV bl,byte[rsi]
	CALL HtoA
	push rsi
	print sum,02
	pop rsi
	dec rsi
	dec byte[cnt]
	cmp byte[cnt],0
	jne at1
	
	MOV bl,[result]
	CALL HtoA
	print msg,len
	print sum,02
	print msgn,lenn
	
	MOV rsi,array
	
	FLDZ
	XOR rcx,rcx
	MOV cl,05
up2:
	FLD dword[rsi]
	
	FSUB dword[mean]
	
	FMUL st0
	
	FADDP
	
	ADD rsi,04
	loop up2
	
	FIDIV word[arcnt]
	
	FST dword[var]
	
	FIMUL dword[h]
	
	FBSTP [result]
	
	print msg2,len2
	XOR rsi,rsi
	MOV rsi,result+08
at1:
	MOV bl,byte[rsi]
	CALL HtoA
	push rsi
	print sum,02
	pop rsi
	dec rsi
	dec byte[cnt]
	cmp byte[cnt],0
	jne at1
	
	MOV bl,[result]
	CALL HtoA
	print msg,len
	print sum,02
	print msgn,lenn
	
	FLD dword[var]
	
	FSQRT
	
	FIMUL dword[h]
	
	FBSTP [result]
	
	print msg3,len3
	XOR rsi,rsi
	MOV rsi,result+08
at1:
	MOV bl,byte[rsi]
	CALL HtoA
	push rsi
	print sum,02
	pop rsi
	dec rsi
	dec byte[cnt]
	cmp byte[cnt],0
	jne at1
	
	MOV bl,[result]
	CALL HtoA
	print msg,len
	print sum,02
	print msgn,lenn
	
exit:

	MOV rax,60
	MOV rdi,0
	SYSCALL
	
	HtoA:
		XOR rcx,rcx
		mov rcx,02
		mov rdi,sum
	up3:
		rol bl,04
		mov al,bl
		and al,0Fh
		cmp al,09
		jbe a3
		add al,07h
	a3:
		add al,30h
		mov [rdi],al
		inc rdi
		loop up3
	ret
