#pragma once
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>



//stackBottom->마지막



typedef struct node
{
	void* dataPtr;
	struct node* link;
}STACK_NODE;

typedef struct
{
	int count;
	STACK_NODE* top;
	STACK_NODE* bottom;   //bottom 포인터 생성

}STACK;

STACK* createStack(void);
bool pushStack(STACK* stack, void* dataInPtr);
void* popStack(STACK* stack);
void* stackTop(STACK* stack);
bool emptyStack(STACK* stack);
bool fullStack(STACK* stack);
int stackCount(STACK* stack);
STACK* destroyStack(STACK* stack);
void* stackBottom(STACK* stack);

STACK* createStack(void)
{
	STACK* stack;

	stack = (STACK*)malloc(sizeof(STACK));
	if (stack)
	{
		stack->count = 0;
		stack->top = NULL;
		stack->bottom = NULL;  //초기화
	}
	return stack;
}

bool pushStack(STACK* stack, void* dataInPtr)
{
	STACK_NODE* newPtr;
	newPtr = (STACK_NODE*)malloc(sizeof(STACK_NODE));

	if (!newPtr)
		return false;
	newPtr->dataPtr = dataInPtr;
	newPtr->link = stack->top;
	stack->top = newPtr;

	(stack->count)++;

	if (stack->count == 1)
		stack->bottom = stack->top;      //stackcount =1 -> top=bottom일때

	return true;
}

void* popStack(STACK* stack)
{
	void* dataOutPtr;
	STACK_NODE* temp;

	if (stack->count == 0)
		dataOutPtr = NULL;
	else
	{
		temp = stack->top;
		dataOutPtr = stack->top->dataPtr;
		stack->top = stack->top->link;
		free(temp);
		(stack->count)--;
	}
	return dataOutPtr;
}

void* stackTop(STACK* stack)
{
	if (stack->count == 0)
		return NULL;
	else
		return stack->top->dataPtr;
}

bool emptyStack(STACK* stack)
{
	return (stack->count == 0);
}

bool fullStack(STACK* stack)
{
	STACK_NODE* temp;
	if ((temp =
		(STACK_NODE*)malloc(sizeof(*(stack->top)))))
	{
		free(temp);
		return false;
	}
	return true;
}


int stackCount(STACK* stack)
{
	return stack->count;
}

STACK* destroyStack(STACK* stack)
{
	STACK_NODE* temp;
	if (stack)
	{
		while (stack->top != NULL)
		{
			free(stack->top->dataPtr);
			temp = stack->top;
			stack->top = stack->top->link;
			free(temp);
		}
		free(stack);
	}
	return NULL;
}


void* stackBottom(STACK* stack)   //bottom값 반환
{
	void* dataOutPtr;
	STACK_NODE* temp;

	if (stack->count == 0)
		dataOutPtr = NULL;
	else
	{
		temp = stack->bottom;
		dataOutPtr = stack->bottom->dataPtr;
	}
	return dataOutPtr;
}