#ifndef _SEARCH_DATA_CU
#define _SEARCH_DATA_CU

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "./env.h"
#include "./llist.cu"
/*
__global__ void mallocTest()
{
    char* ptr = (char*)malloc(123);
    printf(“Thread %d got pointer: %p\n”, threadIdx.x, ptr);
    free(ptr);
}

void main()
{
    // Set a heap size of 128 megabytes. Note that this must
    // be done before any kernel is launched.
    cudaThreadSetLimit(cudaLimitMallocHeapSize, 128*1024*1024);
    mallocTest<<<1, 5>>>();
    cudaThreadSynchronize();
}
*/
/*
SearchData* searchData : [
  {
    price: {
      valueType: VT_INT,
      data: 33,
    },
    tags: {
      valueType: VT_A_STRING,
      data:['supper', 'versal', 'hateyou'],
    }
  }
]
*/



typedef struct
{
  char* name;
  int valueType;
  void* data;
} SearchDataItem;


LList* searchDataInit()
{
  return createList();
}

void searchDataAdd(LList* searchData, SearchDataItem* item)
{
  addToList(searchData, (void*)item);
}


void searchDataAddInt(LList* searchData, char* name, int data)
{
  SearchDataItem* item = (SearchDataItem*)malloc(sizeof(SearchDataItem));
  item->data = (void*)malloc(sizeof(int));
  cudaMemcpy(item->data, &data, sizeof(int), cudaMemcpyHostToHost);
  item->name = name;
  item->valueType = VT_INT;

  addToList(searchData, (void*)item);
}

void searchDataAddFloat(LList* searchData, char* name, float data)
{
  SearchDataItem* item = (SearchDataItem*)malloc(sizeof(SearchDataItem));
  item->data = (void*)malloc(sizeof(float));
  cudaMemcpy(item->data, &data, sizeof(float), cudaMemcpyHostToHost);
  item->name = name;
  item->valueType = VT_FLOAT;

  addToList(searchData, (void*)item);
}

void searchDataAddStr(LList* searchData, char* name, char* data)
{
  SearchDataItem* item = (SearchDataItem*)malloc(sizeof(SearchDataItem));

  item->data = data;
  item->name = name;
  item->valueType = VT_STRING;

  addToList(searchData, (void*)item);
}

void searchDataPrint(LList* searchData)
{
  LNode* currentNode = searchData->head;
  SearchDataItem* item = 0;
  int i = 0;
  while (currentNode != NULL)
  {
    LNode* nextNode = currentNode->next;
    SearchDataItem* item = (SearchDataItem*)currentNode->data;
    if(item->valueType == VT_INT)
    {
      printf("%d:%s=%d \n", i, item->name, *((int*)item->data));
    }
    if(item->valueType == VT_STRING)
    {
      printf("%d:%s=%s \n", i, item->name, (char*)item->data);
    }
    if(item->valueType == VT_FLOAT)
    {
      printf("%d:%s=%f \n", i, item->name, *((float*)item->data));
    }

    i++;
    currentNode = nextNode;
  }
}

void searchDataFree(LList* searchData)
{
  LNode* currentNode = searchData->head;
  while (currentNode != NULL)
  {
    LNode* next_node = currentNode->next;
    SearchDataItem* item = (SearchDataItem*)currentNode->data;
    if(item == NULL)
    {
      continue;
    }

    if(item->name != NULL)
    {
      printf("free name \n");
      free(item->name);
    }
    if(item->data != NULL)
    {
      printf("free data \n");
      free(item->data);
    }

    currentNode = next_node;
  }
  freeList(searchData);
}

#endif
