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
sub esp,4
mov eax,4
mov [ebp-4],eax
mov eax,4
mov cl,al
shl DWORD PTR[ebp-4],cl
mov eax,[ebp-4]
push eax
call PutIntLn
add esp,4
mov eax,10
mov [ebp-4],eax
mov eax,2
mov cl,al
shr DWORD PTR[ebp-4],cl
mov eax,[ebp-4]
push eax
call PutIntLn
add esp,4
mov eax,99
mov [ebp-4],eax
mov eax,10
mov ebx,eax
xor edx,edx
mov eax,[ebp-4]
idiv ebx
mov [ebp-4],edx
mov eax,[ebp-4]
push eax
call PutIntLn
add esp,4
mov eax,0
mov esp,ebp
pop ebp
ret
main ENDP
END main