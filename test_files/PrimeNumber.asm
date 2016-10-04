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
_f DWORD 4004 DUP(0)
.code
main PROC C
push ebp
mov ebp,esp
sub esp,16
mov DWORD PTR [ebp-12],0
mov eax,0
imul eax,4
add [ebp-12],eax
mov esi,[ebp-12]
lea eax,[esi+_f]
mov [ebp-12],eax
mov DWORD PTR [ebp-16],0
mov eax,1
imul eax,4
add [ebp-16],eax
mov esi,[ebp-16]
lea eax,[esi+_f]
mov [ebp-16],eax
mov eax,1
mov ebx,[ebp-16]
mov [ebx],eax
mov ebx,[ebp-12]
mov [ebx],eax
lea eax,[ebp-4]
mov [ebp-12],eax
mov eax,0
mov ebx,[ebp-12]
mov [ebx],eax
LABEL1:
mov eax,[ebp-4]
mov [ebp-12],eax
mov eax,1001
cmp [ebp-12],eax
mov eax,1
jl LABEL2
xor eax,eax
LABEL2:
mov [ebp-12],eax
mov eax,[ebp-12]
test eax,eax
jz LABEL0
mov DWORD PTR [ebp-12],0
mov eax,[ebp-4]
imul eax,4
add [ebp-12],eax
mov esi,[ebp-12]
mov eax,[esi+_f]
cmp eax,0
mov eax,1
jz LABEL3
mov eax,0
LABEL3:
test eax,eax
jz LABEL4
mov eax,[ebp-4]
push eax
call PutInt
add esp,4
mov eax,' '
push eax
call PutChar
add esp,4
lea eax,[ebp-8]
mov [ebp-12],eax
mov eax,[ebp-4]
mov [ebp-16],eax
mov eax,1
mov cl,al
shl DWORD PTR[ebp-16],cl
mov eax,[ebp-16]
mov ebx,[ebp-12]
mov [ebx],eax
LABEL7:
mov eax,[ebp-8]
mov [ebp-12],eax
mov eax,1001
cmp [ebp-12],eax
mov eax,1
jl LABEL8
xor eax,eax
LABEL8:
mov [ebp-12],eax
mov eax,[ebp-12]
test eax,eax
jz LABEL6
mov DWORD PTR [ebp-12],0
mov eax,[ebp-8]
imul eax,4
add [ebp-12],eax
mov esi,[ebp-12]
lea eax,[esi+_f]
mov [ebp-12],eax
mov eax,1
mov ebx,[ebp-12]
mov [ebx],eax
lea eax,[ebp-8]
mov [ebp-12],eax
mov eax,[ebp-8]
mov [ebp-16],eax
mov eax,[ebp-4]
add [ebp-16],eax
mov eax,[ebp-16]
mov ebx,[ebp-12]
mov [ebx],eax
jmp LABEL7
LABEL6:
LABEL4:
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