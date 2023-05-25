#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <regex.h>
#include <cuda.h>
#include "../src/includes/env.h"
#include "../src/includes/logic_data.cu"
#include "./llist_test.cu"
#include "./search_data_test.cu"
#include "./logic_data_test.cu"
#include "./json_search_data_test.cu"


#define SIZE 3

// NVIDIA P106-100
// Main function
int main()
{
  llist_test();
  searchData_test();
  logicData_test();
  json_search_data_test();
  return 0;
}


