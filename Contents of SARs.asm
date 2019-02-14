;                               Assignment 6 (Printing contents of SARs)

section .data

msg1 db 10,"Contents of GDTR are:- "
len1 equ $-msg1

msg2 db 10,"Contents of LDTR are: "
len2 equ $-msg2

msg3 db 10,"Contents of IDTR are: "
len3 equ $-msg3

msg5 db 10,"Contents of MSW are: "
len5 equ $-msg5

msg6 db 10,"Contents of Task Register are: "
len6 equ $-msg6

upper db 10,"Upper (32 bits): "
lenupper equ $-upper

lower db 10,"Lower (16 bits): "
lenlower equ $-lower

msg4 db 10,"Thank You",10
len4 equ $-msg4

protection db 10,"Protection is Enabled"
lenpro equ $-protection

noprotection db 10,"Protection is not Enabled"
lennopro equ $-noprotection

line db 10," "
linelen equ $-line 

section .bss

temp resb 04
temp2 resb 02
gdtr resb 06
idtr resb 06
ldtr resb 02
tr resb 02
msw resw 01

%MACRO print 2
	MOV rax,1
	MOV rdi,1
	MOV rsi,%1
	MOV rdx,%2
	SYSCALL
%endMACRO

%MACRO newline 0
	MOV rax,1
	MOV rdi,1
	MOV rsi,line
	MOV rdx,linelen
	SYSCALL
%endMACRO




section .txt
global _start
_start:
	SMSW [msw]
	XOR rax,rax
	MOV ax,word[msw]
	
	BT ax,0
	JC label1
	
	print noprotection,lennopro
	newline
	JMP next1
	
	label1: print protection,lenpro		;Printing MSW
		newline
		XOR rbx,rbx
		XOR rax,rax
		MOV bx,word[msw]
		call HtoA16
		print msg5,len5
		print temp2,04
		newline
		
	next1:  
				; Storing and printing GDTR, Upper 32 bits, then lower 16 bits
		SGDT [gdtr]
		
		XOR rbx,rbx
		MOV ebx,dword[gdtr+2]
		XOR rax,rax
		call HtoA32
		print msg1,len1
		print upper,lenupper
		print temp,08
		
		XOR rax,rax
		XOR rbx,rbx
		MOV bx,word[gdtr]
		call HtoA16
		print lower,lenlower
		print temp2,04
		newline
		
				; Storing and printing IDTR, Upper 32 bits then lower 16 bits
		
		SIDT [idtr]
		
		XOR rbx,rbx
		MOV ebx,dword[idtr+2]
		XOR rax,rax
		call HtoA32
		print msg3,len3
		print upper,lenupper
		print temp,08
		
		XOR rax,rax
		XOR rbx,rbx
		MOV bx,word[idtr]
		call HtoA16
		print lower,lenlower
		print temp2,04
		newline
		
				; Storing and printing LDTR
				
		SLDT [ldtr]
				
		XOR rbx,rbx
		MOV bx,word[ldtr]
		XOR rax,rax
		call HtoA16
		print msg2,len2
		print temp2,04
		newline
		
				; Storing and printing TR
				
		STR [tr]
				
		XOR rbx,rbx
		MOV bx,word[tr]
		XOR rax,rax
		call HtoA16
		print msg6,len6
		print temp2,04
		newline
		
	

exit:   print msg4,len4
	MOV rax,60
	MOV rdi,0
	SYSCALL
	
	
	
			;Convert HEX To ASCII For 32 BITS
HtoA32:	MOV rcx,08
	MOV rdi,temp
label32:ROL ebx,04
	MOV al,bl
	AND al,0Fh
	CMP al,09h
	JBE a3
	add al,07h
a3: 	add al,30h
	MOV [rdi],al
	INC rdi
	loop label32
	ret
	
				;Convert HEX To ASCII For 16 BITS
HtoA16:	MOV rcx,04
	MOV rdi,temp2
label16:ROL bx,04
	MOV al,bl
	AND al,0Fh
	CMP al,09h
	JBE a1
	add al,07h
a1: 	add al,30h
	MOV [rdi],al
	INC rdi
	loop label16
	ret
	


