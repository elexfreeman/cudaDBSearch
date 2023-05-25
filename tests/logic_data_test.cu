#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../src/includes/env.h"
#include "../src/includes/logic_data.cu"


int logicData_test()
{
  printf("========== LogicData test START ============== \n");
  LogicData* logicData = logicInit();
  printf("count %d \n", logicData->count);

  logicAddInt(logicData, strdup("FIELD"), L_EQUAL, 10);
  logicAddMiddle(logicData, L_AND);
  logicAddInt(logicData, strdup("P1"), L_EQUAL, 33);
  logicAddMiddle(logicData, L_OR);
  logicAddString(logicData, strdup("P2"), L_EQUAL, strdup("char data"));

  logicPrint(logicData);
  logicFree(logicData);
  printf("============ END ================ \n");

  return 0;
}


