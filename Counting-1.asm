GLOBAL buffer,count

section .data

	msg1 db 10,"What would you like to do in story.txt?"
	     db 10,"1. Count Number of Blank Spaces"
	     db 10,"2. Count Number of Lines"
	     db 10,"3. Count frequency of a particular character"
	     db 10,"Your Choice: " 
	len1 equ $-msg1

	msg2 db 10,"No of characters are: "
	len2 equ $-msg2

	msg3 db 10,"No of lines are: "
	len3 equ $-msg3

	msg4 db 10,"No of spaces are: "
	len4 equ $-msg4

	errormsg db 10,"There was an error in opening the file."
	errlen equ $-errormsg

	lastmsg db 10,"Do you want to try again?"
		db 10,"1. Yes"
		db 10,"2. No"
		db 10,"Your Choice: "
	lastlen equ $-lastmsg

	fname db 'story.txt', 0
	
;------------------------------------------------------------------

section .bss

	choice resb 02
	choice1 resb 02
	count resq 01
	buffer resb 100
	temp resb 01
	fd resq 01
	ans resb 02

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
EXTERN lines, spaces, frequency, answer
global _start

_start:

	MOV rax,2
	MOV rdi,fname
	MOV rsi,2
	MOV rdx,0777
	syscall				;File descriptor values are stored now in rax

	bt rax,63			;Tests 63rd bit, whether file is successfully opened or not
	JNC start
	print errormsg,errlen
	JMP exit

start:
	MOV qword[fd],rax              ;Descriptor of file to memory location given by 'fd'

	MOV rax,0
	MOV rdi,[fd]
	MOV rsi,buffer
	MOV rdx,100
	SYSCALL

	MOV [count],rax
	brk:
	print msg1,len1
	input choice,02
	
	CMP byte[choice],31h
	JE label1
	CMP byte[choice],32h
	JE label2
	CMP byte[choice],33h
	JE label3
	JMP exit
	

	label1: call spaces
		XOR rbx,rbx
		MOV bx,[answer]
		call HtoA
		print msg4,len4
		print ans,02
		JMP exit
		
	label2: call lines
		XOR rbx,rbx
		MOV bx,[answer]
		call HtoA
		print msg3,len3
		print ans,02
		JMP exit
		
	label3: call frequency
		XOR rbx,rbx
		MOV bx,[answer]
		call HtoA
		print msg2,len2	
		print ans,02
		JMP exit



;--------------------------- EXIT Call --------------------------------


exit:
	print lastmsg,lastlen
	input choice1,02
	CMP byte[choice1],31h
	JE _start
	MOV rax,60
	MOV rdi,0
	SYSCALL
	
	
	
HtoA:	MOV rcx,02
	MOV rdi,ans
	label4:	ROL bl,04
		MOV al,bl
		AND al,0Fh
		CMP al,09h
		JBE a3
		add al,07h
		a3: 	add al,30h
			MOV [rdi],al
			INC rdi
	loop label4
	RET
