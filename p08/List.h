
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
	int nSize;
} List ;

List* ListCreate();
Node* ListCreateNode();
void ListFree(List** ppList);
void ListFreeNode(Node** ppNode);

void ListInsertData(List* pList, void* pNewData);
Node* ListRemoveNode(List* pList, Node* pRemoveNode);
Node* ListPopHead(List* pList);

#endif
