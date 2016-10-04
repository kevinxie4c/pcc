#include <io.h>

int main()
{
	int a[5][10];
	int i,j;
	i=0;
	while(i<5)
	{
		a[i][0]=1;
		i++;
	}
	i=0;
	while(i<10)
	{
		a[0][i]=1;
		i++;
	}
	i=1;
	while(i<5)
	{
		j=1;
		while(j<10)
		{
			a[i][j]=a[i-1][j]+a[i][j-1];
			j++;
		}
		i++;
	}
	i=0;
	while(i<5)
	{
		j=0;
		while(j<10)
		{
			PutInt(a[i][j]);
			PutChar(9);
			j++;
		}
		PutChar(10);
		i++;
	}
	return 0;
}