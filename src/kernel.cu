#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>

#define SIZE 3

typedef struct
{
  int size;
  int** data;
} GpuArray;


// Define a struct to store data
typedef struct
{
	int size;
	int* array;
} Array;


// Define a kernel to add two arrays
__global__ void add_arrays(Array* d_arrays, int num_arrays)
{

	// Get the thread ID
	int thread_id = blockIdx.x * blockDim.x + threadIdx.x;

	// Check if the thread is within the bounds of the array
	if (thread_id < num_arrays)
	{
		// Add the two arrays
		for (int i = 0; i < d_arrays[thread_id].size; i++)
		{
			d_arrays[thread_id].array[i] = 5;
		}
	}
}


// Main function
int main()
{

  int** p_k = (int**)malloc(sizeof(int*));
  int*  k = (int*)malloc(sizeof(int)*SIZE);
  for(int i=0; i<SIZE; i++)
  {
    k[i] = i+3;
  }
  *p_k = k;

  for(int i=0; i<SIZE; i++)
  {
    printf(">>> k = %d, add = %p \n",(*p_k)[i], &p_k[i]);
  }

  GpuArray* dataList = (GpuArray*)malloc(SIZE*sizeof(GpuArray));
  for(int i=0; i<SIZE; i++)
  {
    (*dataList[i])->size = SIZE;
    dataList[i]->data = (int**)malloc(sizeof(int*));
    *dataList[i]->data = (int*)malloc(sizeof(int)*SIZE);
    for(int j=0; j<SIZE; j++)
    {
      (*dataList[i]->data)[j]  = j+1;
      printf(">>> k = %d, add = %p \n",(*dataList[i]->data)[j], &dataList[i]->data[j]);
    }
  }

}

