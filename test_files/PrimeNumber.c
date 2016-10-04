#include <io.h>

int f[1001];

int main()
{
	int i,j;
	f[0]=f[1]=1;
	i=0;
	while(i<1001)
	{
		if(!f[i])
		{
			PutInt(i);
			PutChar(' ');
			j=i<<1;
			while(j<1001)
			{
				f[j]=1;
				j=j+i;
			}
		}
		i++;
	}
	return 0;
}