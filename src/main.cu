#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>

#define SIZE 3

typedef struct
{
  int size;
  void* p_array;
} GpuArray;


// Define a struct to store data
typedef struct
{
  int size;
  int* array;
} Array;


// Define a kernel to add two arrays
__global__ void add_arrays(GpuArray* d_data, int* d_out)
{
  int thread_id = threadIdx.x;
//  int size = (d_data[thread_id].p_array)[0].size;
//  d_out[thread_id] = d_data[thread_id].size;
  d_out[thread_id] = ((int*)d_data[thread_id].p_array)[0];
}

GpuArray initDevArray(GpuArray data)
{

  //https://forums.developer.nvidia.com/t/dynamic-array-inside-struct/10455/6
  GpuArray d_data;
  d_data.size = data.size;
  d_data.p_array = 0;

  cudaMalloc(&d_data.p_array, sizeof(int)*data.size);
  cudaMemcpy(d_data.p_array, data.p_array, sizeof(int)*data.size, cudaMemcpyHostToDevice);

  return d_data;
}

void exmplePtoP()
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
}


// Main function
int main()
{

  GpuArray* h_dataList = (GpuArray*)malloc(SIZE*sizeof(GpuArray));

  for(int i=0; i<SIZE; i++)
  {
    h_dataList[i].size = SIZE;
    h_dataList[i].p_array = (int*)malloc(sizeof(int)*SIZE);
    for(int j=0; j<SIZE; j++)
    {
      ((int*)h_dataList[i].p_array)[j]  = 5;
      printf(">>> j=%d, k = %d, add = %p \n",
             i,
             ((int*)h_dataList[i].p_array)[j],
             &((int*)h_dataList[i].p_array)[j]);
    }
  }

  cudaSetDevice(0);

  GpuArray* h_dataListWithDevData = (GpuArray*)malloc(SIZE*sizeof(GpuArray));
  for(int k=0; k< SIZE; k++)
  {
    h_dataListWithDevData[k]  = initDevArray(h_dataList[k]);
  }

  GpuArray* d_data = 0;
  cudaMalloc(&d_data, sizeof(GpuArray)*SIZE);
  cudaMemcpy(d_data, h_dataListWithDevData, sizeof(GpuArray)*SIZE, cudaMemcpyHostToDevice);
  printf("dev = %p \n", d_data );

  int* h_out = (int*)malloc(SIZE*sizeof(int));
  int* d_out = 0;
  cudaMalloc(&d_out, sizeof(int)*SIZE);
  printf("dev_out = %p \n", d_out );

  add_arrays <<<1, SIZE >>>(d_data, d_out);
  cudaDeviceSynchronize();

  // Copy the arrays from the device back to the host
  cudaMemcpy(h_out, d_out, SIZE* sizeof(int), cudaMemcpyDeviceToHost);

  for(int k=0; k< SIZE; k++)
  {
    printf("out = %d \n", h_out[k] );
  }

  for(int k=0; k< SIZE; k++)
  {
    cudaFree(h_dataListWithDevData[k].p_array);
    free(h_dataList[k].p_array);
  }

  cudaFree(d_data);
  cudaFree(d_out);

  free(h_out);
  free(h_dataListWithDevData);
  free(h_dataList);

  return 0;
}

