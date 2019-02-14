
section .data

msg1 db "Original Array: "
len1 equ $-msg1

msg2 db "Sorted Array: "
len2 equ $-msg2

errormsg db 10,"There was an Error in Opening File"
lenerror equ $-errormsg

menu db "Bubble Sort",10
     db "1. Ascending.",10
     db "2. Descending.",10
     db "Your Choice: "
lenmenu equ $-menu

filename db 'numbers.txt',0

section .bss

count resq 01
counter resq 01
choice resb 02
buffer resb 100
buffer2 resb 100
fd resq 01

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


section .txt
global _start:
_start:
	MOV rax,2
	MOV rdi,filename
	MOV rsi,2
	MOV rdx,0777
	SYSCALL
	
	BT rax,63
	JNC begin
	print errormsg,lenerror
	JMP exit
	
begin:	
	MOV qword[fd],rax
	
	MOV rax,0
	MOV rdi,[fd]
	MOV rsi,buffer
	MOV rdx,100
	SYSCALL
	
	MOV qword[count],rax
	MOV qword[counter],rax
	
	print msg1,len1
	print buffer,[count]
	
	print menu,lenmenu
	input choice,01
	CMP byte[choice],31h
	JE ascending
	
	descending:
			XOR rdi,rdi
			XOR rsi,rsi
			outer:
				MOV rdi,buffer
				MOV rsi,buffer
				INC rsi
				MOV rcx,qword[count]
				inner:
					MOV al,byte[rdi]
					MOV bl,byte[rsi]
					CMP al,bl
					JG label3
							; Swapping
					MOV dl,al
					MOV al,bl
					MOV bl,dl
					MOV [rdi],al
					MOV [rsi],bl
					
					label3: INC rdi
						INC rsi
				loop inner
			DEC qword[counter]
			CMP qword[counter],0
			JNE outer
			
			print msg2,len2
			print buffer,[count]
			JMP exit
	
	ascending:
			XOR rdi,rdi
			XOR rsi,rsi
			outera:
				MOV rdi,buffer
				MOV rsi,buffer
				INC rsi
				MOV rcx,qword[count]
				innera:
					MOV al,byte[rdi]
					MOV bl,byte[rsi]
					CMP al,bl
					JB label4
							; Swapping
					MOV dl,al
					MOV al,bl
					MOV bl,dl
					MOV [rdi],al
					MOV [rsi],bl
					
					label4: INC rdi
						INC rsi
				loop innera
			DEC qword[counter]
			CMP qword[counter],0
			JNE outera
			
			MOV rbx,buffer
			INC rbx
			print msg2,len2
			print rbx,[count]
				MOV rax,1
				MOV rdi,[fd]
				MOV rsi,rbx
				MOV rdx,[count]
			SYSCALL
			JMP exit2
	
	
exit:   
	MOV rax,1
	MOV rdi,[fd]
	MOV rsi,buffer
	MOV rdx,[count]
	SYSCALL
exit2:
	MOV rax,60
	MOV rdi,0
	SYSCALL

	


