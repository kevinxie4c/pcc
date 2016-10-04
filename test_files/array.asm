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
main PROC C
push ebp
mov ebp,esp
sub esp,224
lea eax,[ebp-204]
mov [ebp-212],eax
mov eax,0
mov ebx,[ebp-212]
mov [ebx],eax
LABEL1:
mov eax,[ebp-204]
mov [ebp-212],eax
mov eax,5
cmp [ebp-212],eax
mov eax,1
jl LABEL2
xor eax,eax
LABEL2:
mov [ebp-212],eax
mov eax,[ebp-212]
test eax,eax
jz LABEL0
mov DWORD PTR [ebp-212],0
mov eax,[ebp-204]
imul eax,40
add [ebp-212],eax
mov eax,0
imul eax,4
add [ebp-212],eax
mov esi,[ebp-212]
lea eax,[ebp+esi-200]
mov [ebp-212],eax
mov eax,1
mov ebx,[ebp-212]
mov [ebx],eax
mov eax,[ebp-204]
inc DWORD PTR [ebp-204]
jmp LABEL1
LABEL0:
lea eax,[ebp-204]
mov [ebp-212],eax
mov eax,0
mov ebx,[ebp-212]
mov [ebx],eax
LABEL4:
mov eax,[ebp-204]
mov [ebp-212],eax
mov eax,10
cmp [ebp-212],eax
mov eax,1
jl LABEL5
xor eax,eax
LABEL5:
mov [ebp-212],eax
mov eax,[ebp-212]
test eax,eax
jz LABEL3
mov DWORD PTR [ebp-212],0
mov eax,0
imul eax,40
add [ebp-212],eax
mov eax,[ebp-204]
imul eax,4
add [ebp-212],eax
mov esi,[ebp-212]
lea eax,[ebp+esi-200]
mov [ebp-212],eax
mov eax,1
mov ebx,[ebp-212]
mov [ebx],eax
mov eax,[ebp-204]
inc DWORD PTR [ebp-204]
jmp LABEL4
LABEL3:
lea eax,[ebp-204]
mov [ebp-212],eax
mov eax,1
mov ebx,[ebp-212]
mov [ebx],eax
LABEL7:
mov eax,[ebp-204]
mov [ebp-212],eax
mov eax,5
cmp [ebp-212],eax
mov eax,1
jl LABEL8
xor eax,eax
LABEL8:
mov [ebp-212],eax
mov eax,[ebp-212]
test eax,eax
jz LABEL6
lea eax,[ebp-208]
mov [ebp-212],eax
mov eax,1
mov ebx,[ebp-212]
mov [ebx],eax
LABEL10:
mov eax,[ebp-208]
mov [ebp-212],eax
mov eax,10
cmp [ebp-212],eax
mov eax,1
jl LABEL11
xor eax,eax
LABEL11:
mov [ebp-212],eax
mov eax,[ebp-212]
test eax,eax
jz LABEL9
mov DWORD PTR [ebp-212],0
mov eax,[ebp-204]
imul eax,40
add [ebp-212],eax
mov eax,[ebp-208]
imul eax,4
add [ebp-212],eax
mov esi,[ebp-212]
lea eax,[ebp+esi-200]
mov [ebp-212],eax
mov DWORD PTR [ebp-216],0
mov eax,[ebp-204]
mov [ebp-220],eax
mov eax,1
sub [ebp-220],eax
mov eax,[ebp-220]
imul eax,40
add [ebp-216],eax
mov eax,[ebp-208]
imul eax,4
add [ebp-216],eax
mov esi,[ebp-216]
mov eax,[ebp+esi-200]
mov [ebp-216],eax
mov DWORD PTR [ebp-220],0
mov eax,[ebp-204]
imul eax,40
add [ebp-220],eax
mov eax,[ebp-208]
mov [ebp-224],eax
mov eax,1
sub [ebp-224],eax
mov eax,[ebp-224]
imul eax,4
add [ebp-220],eax
mov esi,[ebp-220]
mov eax,[ebp+esi-200]
add [ebp-216],eax
mov eax,[ebp-216]
mov ebx,[ebp-212]
mov [ebx],eax
mov eax,[ebp-208]
inc DWORD PTR [ebp-208]
jmp LABEL10
LABEL9:
mov eax,[ebp-204]
inc DWORD PTR [ebp-204]
jmp LABEL7
LABEL6:
lea eax,[ebp-204]
mov [ebp-212],eax
mov eax,0
mov ebx,[ebp-212]
mov [ebx],eax
LABEL13:
mov eax,[ebp-204]
mov [ebp-212],eax
mov eax,5
cmp [ebp-212],eax
mov eax,1
jl LABEL14
xor eax,eax
LABEL14:
mov [ebp-212],eax
mov eax,[ebp-212]
test eax,eax
jz LABEL12
lea eax,[ebp-208]
mov [ebp-212],eax
mov eax,0
mov ebx,[ebp-212]
mov [ebx],eax
LABEL16:
mov eax,[ebp-208]
mov [ebp-212],eax
mov eax,10
cmp [ebp-212],eax
mov eax,1
jl LABEL17
xor eax,eax
LABEL17:
mov [ebp-212],eax
mov eax,[ebp-212]
test eax,eax
jz LABEL15
mov DWORD PTR [ebp-212],0
mov eax,[ebp-204]
imul eax,40
add [ebp-212],eax
mov eax,[ebp-208]
imul eax,4
add [ebp-212],eax
mov esi,[ebp-212]
mov eax,[ebp+esi-200]
push eax
call PutInt
add esp,4
mov eax,9
push eax
call PutChar
add esp,4
mov eax,[ebp-208]
inc DWORD PTR [ebp-208]
jmp LABEL16
LABEL15:
mov eax,10
push eax
call PutChar
add esp,4
mov eax,[ebp-204]
inc DWORD PTR [ebp-204]
jmp LABEL13
LABEL12:
mov eax,0
mov esp,ebp
pop ebp
ret
main ENDP
END main