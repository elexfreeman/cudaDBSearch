#include <stdio.h>
#include "../src/includes/llist.cu"
#include "../src/includes/search_data.cu"

int searchData_test()
{
  printf("========== searchData test START ============== \n");
  // create a new list
  LList* searchData = searchDataInit();

  searchDataAddInt(searchData, strdup("int val 1"), 1);
  searchDataAddInt(searchData, strdup("int val 2"), 2);
  searchDataAddFloat(searchData, strdup("float val 1"), 2.22);
  searchDataAddStr(searchData, strdup("String val 1"), strdup("String val data"));
  searchDataAddStr(searchData, strdup("String val 2"), strdup("String val data add new"));

  searchDataPrint(searchData);

  searchDataFree(searchData);

  printf("============ END ================ \n");


  return 0;
}

