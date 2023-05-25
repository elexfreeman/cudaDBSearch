#include <stdio.h>
#include "../src/includes/llist.cu"

int llist_test()
{
  printf("========== LList test START ============== \n");

  // create a new list
  LList* intList = createList();

  // add some integers to the list
  int x = 42;
  addToList(intList, (void*)&x);
  int y = 13;
  addToList(intList, (void*)&y);
  int z = 99;
  addToList(intList, (void*)&z);

  for(int k=0; k< 5; k++)
  {
    int* z = (int*)malloc(sizeof(int));
    *z = k;
    addToList(intList, (void*)z);
  }

  LNode* current_node = intList->head;
  while (current_node != NULL)
  {
    LNode* next_node = current_node->next;
    printf("%d\n", *((int*)current_node->data));
    current_node = next_node;
  }

  // free the memory used by the list
  freeList(intList);

  printf("============ END ================ \n");
  return 0;
}
