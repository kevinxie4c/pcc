#include <io.h>

int hanoi(int n,char a,char b, char c)
{
	if(n)
	{
		hanoi(n-1,a,c,b);
		PutChar(a);
		PutString("->");
		PutCharLn(b);
		hanoi(n-1,c,b,a);
	}
	return 0;
}
	

int main()
{
	int n;
	n=GetInt();
	hanoi(n,'A','B','C');
	return 0;
}