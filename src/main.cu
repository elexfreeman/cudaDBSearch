#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <regex.h>
#include <cuda.h>
#include "./includes/env.h"
#include "./includes/logic_data.cu"

#define SIZE 3

// NVIDIA P106-100
// Main function
int main()
{
  LogicData* logicData = logicInit();
  printf("123 <> \n");
  printf("count %d \n", logicData->count);

  logicAddInt(logicData, "FIELD", L_EQUAL, 10);
  logicAddMiddle(logicData, L_AND);
  logicAddInt(logicData, "P1", L_EQUAL, 33);
  logicAddMiddle(logicData, L_OR);
  logicAddString(logicData, "P2", L_EQUAL, "char data");

  logicPrint(logicData);
  logicFree(logicData);

  return 0;
}

