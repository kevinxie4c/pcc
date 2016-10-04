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
string0 DWORD 'H','e','l','l','o',' ','W','o','r','l','d','!',0
.code
main PROC C
push ebp
mov ebp,esp
mov eax,'A'
push eax
call PutCharLn
add esp,4
mov eax,offset string0
push eax
call PutStringLn
add esp,4
mov eax,100
push eax
call PutIntLn
add esp,4
mov eax,0
pop ebp
ret
main ENDP
END main