/* llist.h
 * Generic Linked List
 */
typedef struct lnode
{
  void* data;
  struct lnode* next;
} LNode;

typedef struct llist
{
  int size;
  LNode* head;
} LList;

LList* createList();
void addToList(LList* list, void* data);
void* removeFromList(LList* list);
void freeList(LList* list);
