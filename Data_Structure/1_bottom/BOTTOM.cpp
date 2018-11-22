#include "pch.h"
#include <iostream>
#include <stdio.h>
#include <stdbool.h>
#include "stacksADT.h"


int main(void)
{
	bool done = false;
	int* dataPtr;

	STACK* stack;

	stack = createStack();

	while (!done)
	{
		dataPtr = (int*)malloc(sizeof(int));
		printf(" Enter the number : <EOF> to stop: ");
		if ((scanf_s("%d", dataPtr)) == EOF
			|| fullStack(stack))
			done = true;
		else
			pushStack(stack, dataPtr);
	}//data입력

		dataPtr = (int*)stackBottom(stack);
		printf(" BOTTOM : %d ", *dataPtr);  //bottom값 반환

	return 0;


}