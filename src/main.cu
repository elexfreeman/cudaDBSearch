#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <regex.h>
#include <cuda.h>
#include "./includes/logicData.cu"

#define SIZE 3




// Main function
int main()
{
  LogicData* logicData = logicInit();
  printf("123 <> \n");
  printf("count %d \n", logicData->count);

  logicAddInt(logicData, "FIELD", L_EQUAL, 10);
  printf("count %d \n", logicData->count);


  logicFree(logicData);

  return 0;
}

