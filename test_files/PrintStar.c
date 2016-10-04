#include <io.h>

int main()
{
	int i,j;
	i=1;
	while(i<=10)
	{
		j=1;
		while(j<=i)
		{
			PutChar('*');
			j++;
		}
		PutChar(10);
		i++;
	}
	return 0;
}