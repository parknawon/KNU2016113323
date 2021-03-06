
#include "pch.h"
#include <iostream>
#include <stdio.h> 
#include "stacksADT.h" 

const char closMiss1[] = "Close ')' missing at line"; 
const char openMiss1[] = "Open '(' missing at line";
const char closMiss2[] = "Close ']' missing at line";  //경고문자추가
const char openMiss2[] = "Open '[' missing at line";
const char closMiss3[] = "Close '}' missing at line";
const char openMiss3[] = "Open '{' missing at line";

int main(void)
{
STACK* stack1; 
STACK* stack2;  //스택생성 추가
STACK* stack3;

char token; 
char* dataPtr; 
char fileID[25]; 
FILE* fpIn; 
int lineCount = 1; 

stack1 = createStack(); 
stack2 = createStack();   //스택생성 추가
stack3 = createStack();

printf("Enter file ID for file to be parsed: "); 
scanf("%s", fileID);

fpIn = fopen(fileID, "r"); 
if (!fpIn)
	printf("Error opening %s\n", fileID), exit(100); 

while ((token = fgetc(fpIn)) != EOF)
{
	if (token == '\n')
		lineCount++;
	if (token == '(')
	{
		dataPtr = (char*)malloc(sizeof(char));
		pushStack(stack1, dataPtr);
	}
	else if (token == '[')     //push추가
	{
		dataPtr = (char*)malloc(sizeof(char));
		pushStack(stack2, dataPtr);
	}
	else if (token == '{')
	{
		dataPtr = (char*)malloc(sizeof(char));
		pushStack(stack3, dataPtr);
	}
	else
	{
		if (token == ')')
		{
			if (emptyStack(stack1))
			{
				printf("%s %d\n", openMiss1, lineCount);
				return 1;
			}
			else
				popStack(stack1);
		}
		else if (token == ']')       //opne오류 확인 및 pop추가
		{
			if (emptyStack(stack2))
			{
				printf("%s %d\n", openMiss2, lineCount);
				return 1;
			}
			else
				popStack(stack2);
		}
		else if (token == '}')
		{
			if (emptyStack(stack3))
			{
				printf("%s %d\n", openMiss3, lineCount);
				return 1;
			}
			else
				popStack(stack3);
		}
		
	}
}
	if (!emptyStack(stack1))
	{
		printf("%s %d\n", closMiss1, lineCount);
		return 1;
	}
	else if (!emptyStack(stack2))       //closed오류 확인 추가
	{
		printf("%s %d\n", closMiss2, lineCount);
		return 1;
	}
	else if (!emptyStack(stack3))
	{
		printf("%s %d\n", closMiss3, lineCount);
		return 1;
	}

	destroyStack(stack1);
	destroyStack(stack2);   //스택파괴 추가
	destroyStack(stack3);
	printf("Parsing is OK: %d Lines parsed.\n", lineCount);
	return 0;
}



