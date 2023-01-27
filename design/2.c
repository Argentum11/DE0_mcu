#include <stdio.h>
int main()
{
    int count = 0;
    int a = 22;
    int c = 3;
    int temp = 0;
    printf("%d / %d = ", a, c);
    while (1)
    {
        a = a - c;
        count++;
        if (a < 0)
        {
            break;
        }
    }
    count--;
    printf("%d ... ", count);
    temp = 0 - a;
    int mod = c - temp;
    printf("%d\n", a+c);
}
/* multiply
#include <stdio.h>
int main()
{
    int a = 5;
    int c = 3;
    int count = c;
    int answer = 0;
    while (1)
    {
        answer = answer + a;
        count--;
        if (count == 0)
        {
            break;
        }
    }
    printf("%d\n", answer);
}*/