#define MAX_LOGIC_SIZE 200
#define C_EQUAL "="
#define L_EQUAL 1
#define C_AND "&"
#define L_AND 2

#define VT_STRING 1
#define VT_INT 2
#define VT_FLOAT 3


typedef struct
{
  int key;
  int logic;
  void* value;
  int valueType;
} LogicItem;

typedef struct
{
  char* name;
  int valueType;
  int key;
} FieldItem;


typedef struct
{
  LogicItem* data;
  int count;
  FieldItem* fieldData;
  int fieldCount;
} LogicData;

LogicData* logicInit()
{
  LogicData* logicData = (LogicData*)malloc(sizeof(LogicData));
  logicData->count = 0;
  logicData->fieldCount = 0;
  logicData->data = (LogicItem*)malloc(sizeof(LogicItem)*MAX_LOGIC_SIZE);
  logicData->fieldData = (FieldItem*)malloc(sizeof(FieldItem)*MAX_LOGIC_SIZE);

  return logicData;
}

void logicFree(LogicData* logicData)
{
  if(logicData->fieldCount!=0)
  {
    for(int k=0; k< logicData->fieldCount; k++)
    {
      free(logicData->fieldData[k].name);
    }
    free(logicData->fieldData);
  }

  if(logicData->count!=0)
  {
    for(int k=0; k< logicData->count; k++)
    {
      free(logicData->data[k].value);
    }
    free(logicData->data);

  }
  free(logicData);
}

int logicGetFieldItemKey(LogicData* logicData, char* name)
{
  int out = -1;
  for(int k=0; k< logicData->fieldCount; k++)
  {
    if(strcmp(logicData->fieldData[k].name, name)==0)
    {
      out = k;
      break;
    }
  }
  return out;
}

void logicAddField(LogicData* logicData, char* fieldName, int valueType)
{
  int key = logicGetFieldItemKey(logicData, fieldName);

  if(key >=0) return;

  logicData->fieldData[logicData->fieldCount].key = logicData->fieldCount;
  logicData->fieldData[logicData->fieldCount].valueType = valueType;

  int len =  strlen(fieldName);
  logicData->fieldData[logicData->fieldCount].name = (char*)malloc(sizeof(char)*len);
  memcpy(logicData->fieldData[logicData->fieldCount].name, fieldName, len);

  logicData->fieldCount++;
}

void logicAddInt(LogicData* logicData, char* fieldName, int logic, int value)
{
  int key = logicGetFieldItemKey(logicData, fieldName);
  logicData->data[logicData->count].key = key;
  logicData->data[logicData->count].logic = logic;
  logicData->data[logicData->count].valueType = VT_INT;

  int* valueTmp = (int*)malloc(sizeof(int));
  *valueTmp = value;
  logicData->data[logicData->count].value = valueTmp;
  logicData->count++;
}

void logicAddFloat(LogicData logicData, int key, int logic, float value)
{
  logicData.data[logicData.count].key = key;
  logicData.data[logicData.count].logic = logic;
  logicData.data[logicData.count].valueType = VT_INT;

  float* valueTmp =  (float*)malloc(sizeof(float));
  *valueTmp = value;
  logicData.data[logicData.count].value = valueTmp;
  logicData.count++;
}


void logicAddMiddle(LogicData logicData, int logic)
{
  logicData.data[logicData.count].key = -1;
  logicData.data[logicData.count].logic = logic;
  logicData.data[logicData.count].valueType = -1;
  logicData.data[logicData.count].value = 0;
  logicData.count++;
}

