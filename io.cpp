#include <cstdio>
#include <cstring>

extern "C" long GetString(long *s)
{
	char ts[256];
	int i;
	scanf("%s",ts);
	for(i=0;i<=strlen(ts);++i)
		s[i]=ts[i];
	return 0;
}

extern "C" long StringLength(long *s)
{
	long i;
	for(i=0;s[i]!=0;++i);
	return i;
}

extern "C" long PutString(long *s)
{
	char ts[256];
	int i;
	for(i=0;i<=StringLength(s);++i)
		ts[i]=s[i];
	printf("%s",ts);
	return 0;
}

extern "C" long PutStringLn(long *s)
{
	char ts[256];
	int i;
	for(i=0;i<=StringLength(s);++i)
		ts[i]=s[i];
	printf("%s\n",ts);
	return 0;
}

extern "C" long GetChar()
{
	long c;
	scanf("%c",&c);
	return c;
}

extern "C" long PutChar(long c)
{
	printf("%c",c);
	return 0;
}

extern "C" long PutCharLn(long c)
{
	printf("%c\n",c);
	return 0;
}

extern "C" long GetInt()
{
	long i;
	scanf("%d",&i);
	return i;
}

extern "C" long PutInt(long i)
{
	printf("%d",i);
	return 0;
}

extern "C" long PutIntLn(long i)
{
	printf("%d\n",i);
	return 0;
}
