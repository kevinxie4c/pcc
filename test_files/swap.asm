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
swap PROTO C
.data
string0 DWORD '(','n',',','m',')','=','(',0
string1 DWORD ')',0
string2 DWORD 's','w','a','p',0
string3 DWORD '(','n',',','m',')','=','(',0
string4 DWORD ')',0
.code
swap PROC C
push ebp
mov ebp,esp
sub esp,12
mov eax,[ebp+8]
mov [ebp-8],eax
mov eax,[ebp+8]
mov eax,[eax]
mov [ebp-12],eax
mov eax,[ebp+12]
mov eax,[eax]
xor [ebp-12],eax
mov eax,[ebp-12]
mov ebx,[ebp-8]
mov [ebx],eax
mov eax,[ebp+12]
mov [ebp-8],eax
mov eax,[ebp+8]
mov eax,[eax]
mov [ebp-12],eax
mov eax,[ebp+12]
mov eax,[eax]
xor [ebp-12],eax
mov eax,[ebp-12]
mov ebx,[ebp-8]
mov [ebx],eax
mov eax,[ebp+8]
mov [ebp-8],eax
mov eax,[ebp+8]
mov eax,[eax]
mov [ebp-12],eax
mov eax,[ebp+12]
mov eax,[eax]
xor [ebp-12],eax
mov eax,[ebp-12]
mov ebx,[ebp-8]
mov [ebx],eax
mov eax,0
mov esp,ebp
pop ebp
ret
swap ENDP
main PROC C
push ebp
mov ebp,esp
sub esp,12
lea eax,[ebp-4]
mov [ebp-12],eax
mov eax,10
mov ebx,[ebp-12]
mov [ebx],eax
lea eax,[ebp-8]
mov [ebp-12],eax
mov eax,12
mov ebx,[ebp-12]
mov [ebx],eax
mov eax,offset string0
push eax
call PutString
add esp,4
mov eax,[ebp-4]
push eax
call PutInt
add esp,4
mov eax,','
push eax
call PutChar
add esp,4
mov eax,[ebp-8]
push eax
call PutInt
add esp,4
mov eax,offset string1
push eax
call PutStringLn
add esp,4
mov eax,offset string2
push eax
call PutStringLn
add esp,4
lea eax,DWORD PTR [ebp-8]
push eax
lea eax,DWORD PTR [ebp-4]
push eax
call swap
add esp,8
mov eax,offset string3
push eax
call PutString
add esp,4
mov eax,[ebp-4]
push eax
call PutInt
add esp,4
mov eax,','
push eax
call PutChar
add esp,4
mov eax,[ebp-8]
push eax
call PutInt
add esp,4
mov eax,offset string4
push eax
call PutStringLn
add esp,4
mov eax,0
mov esp,ebp
pop ebp
ret
main ENDP
END main