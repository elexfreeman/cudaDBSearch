#ifndef _SEARCH_DATA_CU
#define _SEARCH_DATA_CU

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "./env.h"
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
      valueType: 'int',
      data: 33,
    },
    tags: ['supper', 'versal', 'hateyou'],
  },
  {
    price: 200,
    tags: ['live', 'in', 'my', 'dream'],
  },
  {
    heart: 1,
    tags: ['live', 'in', 'my', 'dream'],
    soul: 2,
  },
  {
    heart: 3,
    youmyheart: [1, 3, 7],
    voyje: 2.33,
  },
]
*/



typedef struct
{
  char* name;
  int valueType;
  void* data;
} SearchDataItem;


typedef struct
{
  SearchDataItem* dataItem;
  int count;
} SearchData;


#endif
