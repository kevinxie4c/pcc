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
gcd PROTO C
main PROTO C
.data
string0 DWORD '1','0',' ','5',':',' ',0
string1 DWORD '5',' ','1','0',':',' ',0
string2 DWORD '1','2','0',' ','8','0',':',' ',0
string3 DWORD '2','0','0','0',' ','2','4','0','0',':',' ',0
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
gcd PROC C
push ebp
mov ebp,esp
sub esp,4
mov eax,[ebp+8]
mov [ebp-4],eax
mov eax,[ebp+12]
mov ebx,eax
xor edx,edx
mov eax,[ebp-4]
idiv ebx
mov [ebp-4],edx
mov eax,[ebp-4]
mov [ebp-4],eax
mov eax,0
cmp [ebp-4],eax
mov eax,1
jne LABEL0
xor eax,eax
LABEL0:
mov [ebp-4],eax
mov eax,[ebp-4]
test eax,eax
jz LABEL1
mov eax,[ebp+8]
mov [ebp-4],eax
mov eax,[ebp+12]
mov ebx,eax
xor edx,edx
mov eax,[ebp-4]
idiv ebx
mov [ebp-4],edx
mov eax,[ebp-4]
push eax
mov eax,[ebp+12]
push eax
call gcd
add esp,8
mov esp,ebp
pop ebp
ret
jmp LABEL2
LABEL1:
mov eax,[ebp+12]
mov esp,ebp
pop ebp
ret
LABEL2:
gcd ENDP
main PROC C
push ebp
mov ebp,esp
mov eax,offset string0
push eax
call PutString
add esp,4
mov eax,5
push eax
mov eax,10
push eax
call gcd
add esp,8
push eax
call PutIntLn
add esp,4
mov eax,offset string1
push eax
call PutString
add esp,4
mov eax,10
push eax
mov eax,5
push eax
call gcd
add esp,8
push eax
call PutIntLn
add esp,4
mov eax,offset string2
push eax
call PutString
add esp,4
mov eax,80
push eax
mov eax,120
push eax
call gcd
add esp,8
push eax
call PutIntLn
add esp,4
mov eax,offset string3
push eax
call PutString
add esp,4
mov eax,2400
push eax
mov eax,2000
push eax
call gcd
add esp,8
push eax
call PutIntLn
add esp,4
mov eax,0
pop ebp
ret
main ENDP
END main