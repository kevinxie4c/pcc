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
hanoi PROTO C
main PROTO C
.data
string0 DWORD '-','>',0
.code
hanoi PROC C
push ebp
mov ebp,esp
sub esp,4
mov eax,[ebp+8]
test eax,eax
jz LABEL0
mov eax,[ebp+16]
push eax
mov eax,[ebp+20]
push eax
mov eax,[ebp+12]
push eax
mov eax,[ebp+8]
mov [ebp-4],eax
mov eax,1
sub [ebp-4],eax
mov eax,[ebp-4]
push eax
call hanoi
add esp,16
mov eax,[ebp+12]
push eax
call PutChar
add esp,4
mov eax,offset string0
push eax
call PutString
add esp,4
mov eax,[ebp+16]
push eax
call PutCharLn
add esp,4
mov eax,[ebp+12]
push eax
mov eax,[ebp+16]
push eax
mov eax,[ebp+20]
push eax
mov eax,[ebp+8]
mov [ebp-4],eax
mov eax,1
sub [ebp-4],eax
mov eax,[ebp-4]
push eax
call hanoi
add esp,16
LABEL0:
mov eax,0
mov esp,ebp
pop ebp
ret
hanoi ENDP
main PROC C
push ebp
mov ebp,esp
sub esp,8
lea eax,[ebp-4]
mov [ebp-8],eax
call GetInt
mov ebx,[ebp-8]
mov [ebx],eax
mov eax,'C'
push eax
mov eax,'B'
push eax
mov eax,'A'
push eax
mov eax,[ebp-4]
push eax
call hanoi
add esp,16
mov eax,0
mov esp,ebp
pop ebp
ret
main ENDP
END main