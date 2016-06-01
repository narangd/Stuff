
#ifndef LiST_
#define LiST_

typedef struct Node {
	struct Node* pNext;
	struct Node* pPrev;
//	union {
//		void* pData;
//		int nData;
//		float dData;
//	} unData;
	void* pData;
} Node;

typedef struct List {
	Node* pHead;
	Node* pTail;
	int size;
} List ;

List* ListCreate();
Node* ListCreateNode();
void ListFree(List** ppList);
void ListFreeNode(List* pList, Node** ppNode);

void ListInsertData(List* pList, void* newData);
void ListRemoveNode(List* pList, Node* pRemoveNode);
Node* ListPopHead(List* pList);

#endif
