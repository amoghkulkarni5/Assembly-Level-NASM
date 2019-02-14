
;               ASSIGNMENT 2 ( OVERLAPPED BLOCK TRANSFER WITH AND WITHOUT STRING INSRUCTIONS )

section .data

	msg1 db "1. Overlapped Block Transfer with String Instruction.",10,
	     db "2. Overlapped Block Transfer without String Instruction.",10,
	     db "3. Your Choice: "
	len1 equ $-msg1

	oldarray db 10,"Original Array and Addresses:-",10
	lenold equ $-oldarray

	newarray db 10,"New Array and Addresses:-",10
	lennew equ $-newarray

	colon db " : "
	colength equ $-colon

	space db " ",10
	spacelength equ $-space

	block db 10h,20h,30h,40h,50h,00h,00h                

section .bss
	
	num resb 02
	address resq 16
	choice resb 02

section .text
global _start
_start:

	MOV rax,1                                   ; Displaying Menu
	MOV rdi,1
	MOV rsi,msg1
	MOV rdx,len1
	syscall

	MOV rax,0				    ; Inputting choice from user
	MOV rdi,1
	MOV rsi,choice
	MOV rdx,02
	syscall

	CMP byte[choice],31H
	JE choice1
	JMP choice2

	; OVERLAPPED BLOCK TRANSFER WITH STRING INSTRUCTIONS

	choice1:

		MOV rax,1                                   ; Displaying "Old Array and Addresses"
		MOV rdi,1
		MOV rsi,oldarray
		MOV rdx,lenold
		syscall

		MOV rcx,05
		MOV rsi,block
		loop4: 
			MOV rbx,rsi
			PUSH rcx
			PUSH rsi
			CALL HtoA
			POP rsi
			MOV bl,byte[rsi]
			PUSH rsi
			CALL HtoA2
			POP rsi
			POP rcx
			INC rsi
		loop loop4

	MOV rcx,05                                         ; MOVING INSTRUCTIONS
	MOV rsi,block
	MOV rdi,rsi
	ADD rsi,04
	ADD rdi,06
	STD
	REP MOVSB

		MOV rax,1                                   ; Displaying "New Array and Addresses"
		MOV rdi,1
		MOV rsi,newarray
		MOV rdx,lennew
		syscall

		MOV rcx,05
		MOV rsi,block
		ADD rsi,02
		loop5: 
			MOV rbx,rsi
			PUSH rcx
			PUSH rsi
			CALL HtoA
			POP rsi
			MOV bl,byte[rsi]
			PUSH rsi
			CALL HtoA2
			POP rsi
			POP rcx
			INC rsi
		loop loop5

MOV rax,60                         
MOV rdi,0
syscall

	; OVERLAPPED BLOCK TRANSFER WITHOUT STRING INSTRUCTIONS

	choice2:

	MOV rax,1                                   ; Displaying "Old Array and Addresses"
	MOV rdi,1
	MOV rsi,oldarray
	MOV rdx,lenold
	syscall

	MOV rcx,05
	MOV rsi,block
	loop1: 
		MOV rbx,rsi
		PUSH rcx
		PUSH rsi
		CALL HtoA
		POP rsi
		MOV bl,byte[rsi]
		PUSH rsi
		CALL HtoA2
		POP rsi
		POP rcx
		INC rsi
	loop loop1

	MOV rsi,block
	MOV rdi,rsi
	ADD rsi,04
	ADD rdi,06
	MOV rcx,05
	loop2:
		MOV bl,byte[rsi]
		MOV byte[rdi],bl
		DEC rsi
		DEC rdi
	loop loop2

	MOV rax,1                                   ; Displaying "New Array and Addresses"
	MOV rdi,1
	MOV rsi,newarray
	MOV rdx,lennew
	syscall

	MOV rcx,05
	MOV rsi,block
	ADD rsi,02
	loop3: 
		MOV rbx,rsi
		PUSH rcx
		PUSH rsi
		CALL HtoA
		POP rsi
		MOV bl,byte[rsi]
		PUSH rsi
		CALL HtoA2
		POP rsi
		POP rcx
		INC rsi
	loop loop3

MOV rax,60                         
MOV rdi,0
syscall


  ; HELPER PROCEDURES

		; --- HEX TO ASCII FOR ADDRESSES --- 
HtoA:	MOV rcx,16
	MOV rdi,address
label2:	ROL rbx,04
	MOV al,bl
	AND al,0Fh
	CMP al,09h
	JBE a3
	add al,07h
a3: 	add al,30h
	MOV [rdi],al
	INC rdi
	loop label2
       				    ; Printing Address
			 MOV rax,1
			 MOV rdi,1
			 MOV rsi,address
			 MOV rdx,16
			 syscall
				    ; Printing " : "
			 MOV rax,1
			 MOV rdi,1
			 MOV rsi,colon
			 MOV rdx,colength
			 syscall
	ret


		;--- HEX TO ASCII FOR VALUE ---
HtoA2:	MOV rcx,02
	MOV rdi,num
label22:ROL bl,04
	MOV al,bl
	AND al,0Fh
	CMP al,09
	JBE a23
	add al,07h
a23: 	add al,30h
	MOV [rdi],al
	INC rdi
	loop label22
          			  ; Printing Value at Address
			 MOV rax,1
			 MOV rdi,1
			 MOV rsi,num
			 MOV rdx,02
			 syscall
				 ; PRINTING ON A NEW LINE
			 MOV rax,1
			 MOV rdi,1
			 MOV rsi,space
			 MOV rdx,spacelength
			 syscall
	ret









