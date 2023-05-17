#ifndef _LOGIC_DATA_CU
#define _LOGIC_DATA_CU

#include <stdio.h>
#include <stdlib.h>
#include "./env.h"


#define C_EQUAL '='
#define L_EQUAL 1

#define C_AND '&'
#define L_AND 2

#define C_NOT_EQUAL '!'
#define L_NOT_EQUAL 3

#define C_OR '|'
#define L_OR 4

typedef struct
{
  char* key;
  int logic;
  void* value;
  int valueType;
} LogicItem;

typedef struct
{
  LogicItem* data;
  int count;
} LogicData;


LogicData* logicInit()
{
  LogicData* logicData = (LogicData*)malloc(sizeof(LogicData));
  logicData->count = 0;
  logicData->data = (LogicItem*)malloc(sizeof(LogicItem)*MAX_LOGIC_SIZE);

  return logicData;
}

void logicFree(LogicData* logicData)
{

  if(logicData->count!=0)
  {
    for(int k=0; k< logicData->count; k++)
    {
      free(logicData->data[k].key);
      free(logicData->data[k].value);
    }
    free(logicData->data);

  }
  free(logicData);
}

void logicAddInt(LogicData* logicData, char* key, int logic, int value)
{
  int len =  strlen(key);
  logicData->data[logicData->count].key = (char*)malloc(sizeof(char)*len);
  memcpy(logicData->data[logicData->count].key, key, len);

  logicData->data[logicData->count].logic = logic;
  logicData->data[logicData->count].valueType = VT_INT;

  int* valueTmp = (int*)malloc(sizeof(int));
  *valueTmp = value;
  logicData->data[logicData->count].value = valueTmp;
  logicData->count++;
}

void logicAddFloat(LogicData* logicData, char* key, int logic, float value)
{
  int len =  strlen(key);
  logicData->data[logicData->count].key = (char*)malloc(sizeof(char)*len);
  memcpy(logicData->data[logicData->count].key, key, len);

  logicData->data[logicData->count].logic = logic;
  logicData->data[logicData->count].valueType = VT_INT;

  float* valueTmp =  (float*)malloc(sizeof(float));
  *valueTmp = value;
  logicData->data[logicData->count].value = valueTmp;
  logicData->count++;
}

void logicAddString(LogicData* logicData, char* key, int logic, char* value)
{
  int len =  strlen(key);
  logicData->data[logicData->count].key = (char*)malloc(sizeof(char)*len);
  memcpy(logicData->data[logicData->count].key, key, len);

  logicData->data[logicData->count].logic = logic;
  logicData->data[logicData->count].valueType = VT_STRING;

  len =  strlen(value);
  logicData->data[logicData->count].value =  (char*)malloc(sizeof(char)*len);
  memcpy(logicData->data[logicData->count].value, value, len);
  logicData->count++;
}


void logicAddMiddle(LogicData* logicData, int logic)
{
  logicData->data[logicData->count].key = 0;
  logicData->data[logicData->count].logic = logic;
  logicData->data[logicData->count].valueType = VT_MIDDLE;
  logicData->data[logicData->count].value = 0;
  logicData->count++;
}

static char getLogicChar(int logic)
{
  if(logic==L_EQUAL) return C_EQUAL;
  if(logic==L_AND) return C_AND;
  if(logic==L_NOT_EQUAL) return C_NOT_EQUAL;
  if(logic==L_OR) return C_OR;
  return ' ';
}

void logicPrint(LogicData* logicData)
{
  char* logicStr = (char*)malloc(sizeof(char)*MAX_LOGIC_SIZE);

  for(int k=0; k<logicData->count; k++)
  {
    if(logicData->data[k].valueType==VT_INT)
    {
      sprintf(logicStr, "%s %s %c %d ",
              logicStr,
              logicData->data[k].key,
              getLogicChar(logicData->data[k].logic),
              *((int*)logicData->data[k].value)
             );
    }
    if(logicData->data[k].valueType==VT_STRING)
    {
      sprintf(logicStr, "%s %s %c '%s' ",
              logicStr,
              logicData->data[k].key,
              getLogicChar(logicData->data[k].logic),
              (char*)logicData->data[k].value
             );
    }
    if(logicData->data[k].valueType==VT_MIDDLE)
    {
      sprintf(logicStr, "%s %c ",
              logicStr,
              getLogicChar(logicData->data[k].logic)
             );
    }
  }
  printf("%s\n", logicStr);
  free(logicStr);
}

#endif
