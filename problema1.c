#include <stdio.h>

int main ()
{
	int pago, horast, va, nose;
	
	printf("Cuantas horas trabajo a la semana?");
	scanf("%i",&horast);
	
	if(horast>40)
	{
		va = horast - 40;
		nose = va * 200;
		
		pago = ((120*40)+(nose));
	}
	else if(horast<40)
	{
		pago = horast * 120;
	}
	
	printf("\n\n El sueldo de la persona es de: %i",&pago);
	return 0;
}
