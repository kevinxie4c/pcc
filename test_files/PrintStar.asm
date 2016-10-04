.386
.model flat,C
GetChar PROTO C
GetInt PROTO C
GetString PROTO C
PutChar PROTO C
PutCharLn PROTO C
PutInt PROTO C
PutIntLn PROTO C
PutString PROTO C
PutStringLn PROTO C
StringLength PROTO C
main PROTO C
.data
.code
PutStringLn PROC C
push ebp
mov ebp,esp
mov eax,[ebp+8]
push eax
call PutString
add esp,4
mov eax,10
push eax
call PutChar
add esp,4
mov eax,0
pop ebp
ret
PutStringLn ENDP
PutCharLn PROC C
push ebp
mov ebp,esp
mov eax,[ebp+8]
push eax
call PutChar
add esp,4
mov eax,10
push eax
call PutChar
add esp,4
mov eax,0
pop ebp
ret
PutCharLn ENDP
PutIntLn PROC C
push ebp
mov ebp,esp
mov eax,[ebp+8]
push eax
call PutInt
add esp,4
mov eax,10
push eax
call PutChar
add esp,4
mov eax,0
pop ebp
ret
PutIntLn ENDP
main PROC C
push ebp
mov ebp,esp
sub esp,12
lea eax,[ebp-4]
mov [ebp-12],eax
mov eax,1
mov ebx,[ebp-12]
mov [ebx],eax
LABEL1:
mov eax,[ebp-4]
mov [ebp-12],eax
mov eax,10
cmp [ebp-12],eax
mov eax,1
jle LABEL2
xor eax,eax
LABEL2:
mov [ebp-12],eax
mov eax,[ebp-12]
test eax,eax
jz LABEL0
lea eax,[ebp-8]
mov [ebp-12],eax
mov eax,1
mov ebx,[ebp-12]
mov [ebx],eax
LABEL4:
mov eax,[ebp-8]
mov [ebp-12],eax
mov eax,[ebp-4]
cmp [ebp-12],eax
mov eax,1
jle LABEL5
xor eax,eax
LABEL5:
mov [ebp-12],eax
mov eax,[ebp-12]
test eax,eax
jz LABEL3
mov eax,'*'
push eax
call PutChar
add esp,4
mov eax,[ebp-8]
inc DWORD PTR [ebp-8]
jmp LABEL4
LABEL3:
mov eax,10
push eax
call PutChar
add esp,4
mov eax,[ebp-4]
inc DWORD PTR [ebp-4]
jmp LABEL1
LABEL0:
mov eax,0
mov esp,ebp
pop ebp
ret
main ENDP
END main