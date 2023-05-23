#ifndef _LLIST_CU
#define _LLIST_CU
/* llist.c
 * Generic Linked LList implementation
 */

#include <stdlib.h>
#include <stdio.h>
#include "./llist.h"

LList* createList()
{
  LList* new_list = (LList*)malloc(sizeof(LList));
  new_list->size = 0;
  new_list->head = NULL;
  return new_list;
}

void addToList(LList* list, void* data)
{
  LNode* new_node = (LNode*)malloc(sizeof(LNode));
  new_node->data = data;
  new_node->next = list->head;
  list->head = new_node;
  list->size++;
}

void* removeFromList(LList* list)
{
  if (list->size == 0)
  {
    return NULL;
  }
  LNode* node_to_remove = list->head;
  void* data = node_to_remove->data;
  list->head = node_to_remove->next;
  free(node_to_remove);
  list->size--;
  return data;
}

void freeList(LList* list)
{
  LNode* current_node = list->head;
  while (current_node != NULL)
  {
    LNode* next_node = current_node->next;
    free(current_node);
    current_node = next_node;
  }
  free(list);
}
#endif
