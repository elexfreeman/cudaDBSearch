#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>

#define SIZE 3

typedef struct
{
  int size;
  int* p_array;
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
  d_out[thread_id] = d_data[thread_id].p_array[0];
}

GpuArray initDevArray(GpuArray data)
{

  //https://forums.developer.nvidia.com/t/dynamic-array-inside-struct/10455/6
  GpuArray d_data;
  d_data.size = data.size;
  d_data.p_array = 0;

  //array
  cudaMalloc(&d_data.p_array, sizeof(int)*data.size);
//  printf("malloc \n");
  cudaMemcpy(d_data.p_array, data.p_array, sizeof(int)*data.size, cudaMemcpyHostToDevice);
  printf("malloc %p \n", d_data.p_array);
  // var
//  GpuArray* d_data = 0;
//  cudaMalloc(&d_data, sizeof(GpuArray));
//  cudaMemcpy(d_data, &h_data, sizeof(GpuArray), cudaMemcpyHostToDevice);

  return d_data;
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

  GpuArray* h_dataList = (GpuArray*)malloc(SIZE*sizeof(GpuArray));

  for(int i=0; i<SIZE; i++)
  {
    h_dataList[i].size = SIZE;
    h_dataList[i].p_array = (int*)malloc(sizeof(int)*SIZE);
    for(int j=0; j<SIZE; j++)
    {
      h_dataList[i].p_array[j]  = 5;
      printf(">>> j=%d, k = %d, add = %p \n",i,h_dataList[i].p_array[j], &h_dataList[i].p_array[j]);
    }
  }

  cudaSetDevice(0);

  GpuArray* h_dataListWithDevData = (GpuArray*)malloc(SIZE*sizeof(GpuArray));
  for(int k=0; k< SIZE; k++)
  {
    GpuArray temp = initDevArray(h_dataList[k]);
    h_dataListWithDevData[k].size  = temp.size;
    printf(" size = %d ", temp.size );
    h_dataListWithDevData[k].p_array  = temp.p_array;
  }

  GpuArray* d_data = 0;
  printf("dev = %d \n", d_data );
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

  return 0;


  // Initialize the number of arrays
  printf("+++++ a \n");
  // Allocate memory for the arrays on the host
  Array* h_arrays = (Array*)malloc(sizeof(Array) * SIZE);

  printf("b \n");
  // Initialize the arrays on the host
  for (int i = 0; i < SIZE; i++)
  {
    printf("c");
    h_arrays[i].size = SIZE;
    h_arrays[i].array = (int*)malloc(sizeof(int) * h_arrays[i].size);
    for (int j = 0; j < h_arrays[i].size; j++)
    {
      h_arrays[i].array[j] = 2;
    }
    printf("0");
    int* d_array = 0;
    // Allocate memory for the arrays on the device
    cudaMalloc(&d_array, sizeof(Array) * SIZE);
    printf("1");
    // Copy the arrays from the host to the device
    cudaMemcpy(d_array, h_arrays[i].array, sizeof(Array) * SIZE, cudaMemcpyHostToDevice);
    printf("2");
    free(h_arrays[i].array);
    printf("3");
    h_arrays[i].array = d_array;
    printf("4");
  }

  // Allocate memory for the arrays on the device
  Array* d_arrays = 0;
  cudaMalloc(&d_arrays, sizeof(Array) * SIZE);


  // Copy the arrays from the host to the device
  cudaMemcpy(d_arrays, h_arrays, sizeof(Array) * SIZE, cudaMemcpyHostToDevice);

  // Launch the kernel
//  add_arrays << <1024, 1024 >> >(d_arrays, SIZE);

  // Copy the arrays from the device back to the host
  cudaMemcpy(h_arrays, d_arrays, sizeof(Array) * SIZE, cudaMemcpyDeviceToHost);

  int* tmp = 0;
  for (int i = 0; i < SIZE; i++)
  {
    tmp = (int*)malloc(sizeof(int)* SIZE);
    cudaMemcpy(h_arrays[i].array, tmp, sizeof(Array) * SIZE, cudaMemcpyDeviceToHost);
    for (int j = 0; j < SIZE; j++)
    {
      printf("Array %d, element %d: %d\n", i, j, tmp[j]);
    }
    cudaFree(h_arrays[i].array);

    h_arrays[i].array = (int*)malloc(sizeof(int)* SIZE);
    cudaMemcpy(h_arrays[i].array, tmp, SIZE, cudaMemcpyHostToHost );
    free(tmp);
  }

//  // Print the arrays
//  for (int i = 0; i < SIZE; i++)
//  {
//    for (int j = 0; j < h_arrays[i].size; j++)
//    {
//      printf("Array %d, element %d: %d\n", i, j, h_arrays[i].array[j]);
//    }
//  }


  // Free the memory on the host and device
  for (int i = 0; i < SIZE; i++)
  {
    free(h_arrays[i].array);
  }

  free(h_arrays);
  cudaFree(d_arrays);


  // Return success
  return 0;
}


