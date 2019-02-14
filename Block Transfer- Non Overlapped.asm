 ;                               Assignment 2- Transfer of Blocks


section .data
	msg1 db "1. Non Overlapped Block Transfer with String Instruction.",10,
	     db "2. Non Overlapped Block Transfer without String Instruction.",10,
	     db "3. Your Choice: "
	len1 equ $-msg1

	msg2 db "Error, Wrong Input",10
	len2 equ $-msg2

	colon db " : "
	colength equ $-colon

	space db " ",10
	spacelength equ $-space

	oldarray db 10,"Original Array and Addresses:-",10
	lenold equ $-oldarray
	
	newarray db 10,"New Array and Addresses:-",10
	lennew equ $-newarray

	block db 10h,20h,30h,40h,50h                ; Array to be transfered
	block2 db 00h,00h,00h,00h,00h
	
section .bss
	choice resb 02
	address resq 16
	num resb 02

section .text
global _start
_start:

	MOV rax,1                                   ; Displaying Menu
	MOV rdi,1
	MOV rsi,msg1
	MOV rdx,len1
	syscall

	MOV rax,0                                   ; Inputting Choice as per the user
	MOV rdi,1
	MOV rsi,choice
	MOV rdx,02
	syscall 

	CMP byte[choice],32H
	JE choice2                                  ; Jump to Labels as per the input value
	JMP choice1
	


     ; Non Overlapped Block Transfer with String Instructions:-

	choice1:
		MOV rcx,05
		MOV rsi,block
		MOV rdi,block2
		CLD
		REP MOVSB

		 MOV rax,1              ; Displaying "Old array"
		 MOV rdi,1
	  	 MOV rsi,oldarray
		 MOV rdx,lenold
	         syscall

		 MOV rcx,05
		 MOV rsi,block
		loop12: 
			 MOV rbx,rsi
			 PUSH rcx
			 PUSH rsi
			 CALL HtoA
			 POP rsi			 			 
			 MOV bl,[rsi]
			 PUSH rsi
			 CALL HtoA2			    				
			 POP rsi
			 POP rcx
			 INC rsi
		loop loop12

	 MOV rax,1                                   ; Displaying New array and addresses
	 MOV rdi,1
  	 MOV rsi,newarray
	 MOV rdx,lennew
         syscall

		 MOV rcx,05
		 MOV rsi,block2
		loop11: 
			 MOV rbx,rsi
			 PUSH rcx
			 PUSH rsi
			 CALL HtoA
			 POP rsi			 			 
			 MOV bl,[rsi]
			 PUSH rsi
			 CALL HtoA2			    				
			 POP rsi
			 POP rcx
			 INC rsi
		loop loop11

MOV rax,60         
MOV rdi,0
syscall



     ; Non Overlapped Block Transfer without String Instructions:-

	choice2: 
		 MOV rax,1                                   ; Displaying "Old array"
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
			 MOV bl,[rsi]
			 PUSH rsi
			 CALL HtoA2			    				
			 POP rsi
			 POP rcx
			 INC rsi
		loop loop1

	 MOV rax,1                                   ; Displaying New array and addresses
	 MOV rdi,1
  	 MOV rsi,newarray
	 MOV rdx,lennew
         syscall
			; BLOCK TRANSFER
         MOV rcx,05
	 MOV rsi, block
         MOV rdx,block2
	loop2: MOV bl,byte[rsi]
	       MOV byte[rdx],bl
		INC rsi
		INC rdx
	       loop loop2

		 MOV rcx,05
		 MOV rsi,block2
		loop3: 
			 MOV rbx,rsi
			 PUSH rcx
			 PUSH rsi
			 CALL HtoA
			 POP rsi			 			 
			 MOV bl,[rsi]
			 PUSH rsi
			 CALL HtoA2			    				
			 POP rsi
			 POP rcx
			 INC rsi
		loop loop3

MOV rax,60         
MOV rdi,0
syscall

;   PROGRAM ENDS-----------------------------------------------------






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






	
