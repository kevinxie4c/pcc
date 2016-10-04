#include <io.h>
int gcd(int a,int b)
{
	if(a%b!=0)
		return gcd(b,a%b);
	else 
		return b;
}

int main()
{
	PutString("10 5: ");
	PutIntLn(gcd(10,5));
	PutString("5 10: ");
	PutIntLn(gcd(5,10));
	PutString("120 80: ");
	PutIntLn(gcd(120,80));
	PutString("2000 2400: ");
	PutIntLn(gcd(2000,2400));
	return 0;
}