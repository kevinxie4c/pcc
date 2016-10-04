#include <io.h>

int swap(int *a,int *b)
{
	int t;
	*a=*a^*b;
	*b=*a^*b;
	*a=*a^*b;
	return 0;
}

int main()
{
	int n,m;
	n=10;
	m=12;
	PutString("(n,m)=(");
	PutInt(n);
	PutChar(',');
	PutInt(m);
	PutStringLn(")");
	PutStringLn("swap");
	swap(&n,&m);
	PutString("(n,m)=(");
	PutInt(n);
	PutChar(',');
	PutInt(m);
	PutStringLn(")");
	return 0;
}