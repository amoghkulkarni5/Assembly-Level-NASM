section .data
	msg1 db "Postive: "
	len1 equ $-msg1
	msg2 db 10,"Negative: "
	len2 equ $-msg2
	array dq 254698745632AD58h,0000111155554444h,854698745632AD58h,854698745632AD58h,2546987AA632AD58h,2546AAA45632AD58h,254BB7AA632AE58h
	pcount db 0
	ncount db 0
	arr_cnt equ 07h

section .bss
	num resb 02

section .text
global _start
_start:
                             ;Calculating Number of Positive and Negative Integers
	MOV rcx,arr_cnt
  	MOV rsi,array
    l1:	bt qword[rsi],63
	jnc label1
	inc byte[ncount]
	jmp label3

 label1: inc byte[pcount]
 label3: add rsi,08h
	loop l1              ;Calculation Ends, Pcount and Ncount obtained
	
	MOV bl,byte[pcount]        ; Move pcount to bl
	call HtoA            ;Convert Positive Count
	

	MOV rax,1            ;Display Positive Count
	MOV rdi,1
	MOV rsi,msg1
	MOV rdx,len1
	syscall

	MOV rax,1            ;Display Positive Count
	MOV rdi,1
	MOV rsi,num
	MOV rdx,02
	syscall

	MOV bl,byte[ncount]  ; Move ncount to bl
	call HtoA            ;Calling HtoA for Negative Count

	MOV rax,1            ;Display Negative Count
	MOV rdi,1
	MOV rsi,msg2
	MOV rdx,len2
        syscall

	MOV rax,1            ;Display Negative Count
	MOV rdi,1
	MOV rsi,num
	MOV rdx,02
	syscall

	MOV rax,60           ; EXIT
	MOV rdi,0
	syscall



HtoA:	MOV rcx,02
	MOV rdi,num
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


