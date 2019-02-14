
section .data

msg1 db 10,"File deleted",10
len1 equ $-msg1

msg2 db 10,"File Copied",10
len2 equ $-msg2

msg3 db 10,"Contents of File: ",10
len3 equ $-msg3

errormsg db 10,"There was an Error in Opening File"
lenerror equ $-errormsg


section .bss
count resq 01
counter resq 01
buffer resb 100
buffer2 resb 100
fd1 resq 01
fd2 resq 01
file1 resq 01
file2 resq 01




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
global _start:
_start:
	POP rdi
	POP rdi
	POP rdi
	CMP byte[rdi],43h
	JE copyblock
	CMP byte[rdi],44h
	JE deleteblock
	JMP printblock
	
	copyblock: 
		MOV rsi,file1
		POP rdi
		loop1:	MOV bl,byte[rdi]		;Copying character by character of file1's name
			MOV byte[rsi],bl
			INC rsi
			INC rdi
			CMP byte[rdi],20h
		JNE loop1
		
		POP rdi
		MOV rsi,file2
		loop2:	MOV bl,byte[rdi]		;Copying character by character of file2's name
			MOV byte[rsi],bl
			INC rsi
			INC rdi
			CMP byte[rdi],20h
		JNE loop2
		
		
				; FIRST FILE	
	firstfile:		
		print file1,16
		MOV rax,2
		MOV rdi,file1
		MOV rsi,2
		MOV rdx,0777
		SYSCALL
		
		BT rax,63		; If there is an error in opening first file, jump to exit
		JC error

		MOV qword[fd1],rax
			
		MOV rax,2
		MOV rdi,file2
		MOV rsi,2
		MOV rdx,0777
check:		SYSCALL
		
		BT rax,63		; If there is an error in opening SECOND file, jump to exit
		JC error
		
		MOV qword[fd2],rax
		
		
		MOV rax,0		; System call for copying contents of file to buffer
		MOV rdi,[fd1]
		MOV rsi,buffer
		MOV rdx,100		
		SYSCALL 
		
		MOV qword[counter],rax
		print buffer,qword[counter]
				
		MOV rax,0		; System call for copying contents of file2 to buffer2
		MOV rdi,[fd1]
		MOV rsi,buffer2
		MOV rdx,100		
		SYSCALL 
					; System call for copying contents to file2
		MOV rax,1
		MOV rdi,[fd2]
		MOV rsi,buffer
		MOV rdx,[counter]
		SYSCALL
	
		print msg2,len2
		JMP exit

					;If there is any error
		error:
			print errormsg,lenerror
			JMP exit
	
	deleteblock:
		POP rdi
		MOV rsi,file1
		loop6:	MOV bl,byte[rdi]		;Copying character by character
			MOV byte[rsi],bl
			INC rsi
			INC rdi
			CMP byte[rdi],20h
		JNE loop6
			
		MOV rax,87
		MOV rdi,file1
		SYSCALL
		
		print msg1,len1
		JMP exit
	
	
	printblock:
		POP rdi
		MOV rsi,file1
		loop4:	MOV bl,byte[rdi]		;Copying character by character
			MOV byte[rsi],bl
			INC rsi
			INC rdi
			CMP byte[rdi],20h
		JNE loop4
		
		MOV rax,2
		MOV rdi,file1
		MOV rsi,2
		MOV rdx,0777
		SYSCALL
		
		BT rax,63		; If there is an error in opening first file, jump to exit
		JC error

		MOV qword[fd1],rax
			
		MOV rax,0		; System call for copying contents of file to buffer
		MOV rdi,[fd1]
		MOV rsi,buffer
		MOV rdx,100		
		SYSCALL 
		
		MOV qword[count],rax
		
		print msg3,len3
		print buffer,qword[count]
		JMP exit




exit: 
	MOV rax,60
	MOV rdi,0
	SYSCALL
