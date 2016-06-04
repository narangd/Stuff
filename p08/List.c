#include "List.h"

#include <stdlib.h>

List* ListCreate() {
	return (List*)calloc(1, sizeof(List));
}
Node* ListCreateNode() {
	return (Node*)calloc(1, sizeof(Node));
}
void ListFree(List** ppList) {
	List* pList = *ppList;
	while (pList->pHead != NULL) {
		Node* pNode = ListPopHead(pList);
		ListFreeNode(&pNode);
	}
	pList->pTail = NULL;
	free(pList);
	*ppList = NULL;
}
void ListFreeNode(Node** ppNode) {
	Node* pNode = *ppNode;
	if (pNode != NULL) {
		pNode->pNext = pNode->pPrev = pNode->pData = NULL;
	}
	free(pNode);
	pNode = NULL;
}

void ListInsertData(List* pList, void* pNewData) {
	// create Node  and insert Data.
	Node* pNewNode = ListCreateNode();
	pNewNode->pData = pNewData;
	
	// Node insert to List.
	if (pList->pTail == NULL) {
		pList->pTail = pList->pHead = pNewNode;
	} else {
		pList->pTail->pNext = pNewNode;
		pNewNode->pPrev = pList->pTail;
		pList->pTail = pNewNode;
	}
	pList->nSize++;
}

Node* ListRemoveNode(List* pList, Node* pRemoveNode) {
	Node* pNextNode = NULL;
	// Node remove from List.
	if (pList->pTail != NULL) {
		if (pRemoveNode->pPrev != NULL) {
			pRemoveNode->pPrev->pNext = pRemoveNode->pNext;
		}
		if (pRemoveNode->pNext != NULL) {
			pRemoveNode->pNext->pPrev = pRemoveNode->pPrev;
		}
		
		pNextNode = pRemoveNode->pNext;
		pRemoveNode->pNext = pRemoveNode->pPrev = NULL;
		
		pList->nSize--;
		if (pList->nSize <= 0) {
			pList->pHead = pList->pTail = NULL;
		}
	}
	return pNextNode;
}

Node* ListPopHead(List* pList) {
	Node* pNode = pList->pHead;
	if (pNode != NULL) {
		pList->pHead = pNode->pNext;
		pList->nSize--;
		
		pNode->pNext = pNode->pPrev = NULL;
	}
	return pNode;
}
//Node* ListPop(List* list) {
//	
//}
