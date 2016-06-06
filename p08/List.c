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
		pNode->pNext = NULL;
		pNode->pPrev = NULL;
		pNode->pData = NULL;
		free(pNode); // free Node.
		pNode = NULL;
	}
}

void ListInsertData(List* pList, void* pNewData) {
	// create Node  and insert Data.
	Node* pNewNode = ListCreateNode();
	pNewNode->pData = pNewData;
	
	// Node insert to List.
	if (pList->pTail == NULL) {
		pList->pTail = pNewNode;
		pList->pHead = pNewNode;
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
	if (pRemoveNode != NULL && pList->pHead != NULL) {
		if (pRemoveNode->pPrev == NULL) {
			pList->pHead = pRemoveNode->pNext;
		} else {
			pRemoveNode->pPrev->pNext = pRemoveNode->pNext;
		}
		if (pRemoveNode->pNext == NULL) {
			pList->pTail = pRemoveNode->pPrev;
		} else {
			pRemoveNode->pNext->pPrev = pRemoveNode->pPrev;
		}
		
		pNextNode = pRemoveNode->pNext;
		pRemoveNode->pNext = NULL;
		pRemoveNode->pPrev = NULL;
		
		pList->nSize--;
	}
	return pNextNode;
}

Node* ListPopHead(List* pList) {
	Node* pHeadNode = pList->pHead;
	if (pHeadNode != NULL) {
		pList->pHead = pHeadNode->pNext;
		pList->nSize--;
		
		pHeadNode->pNext = NULL;
		pHeadNode->pPrev = NULL;
	}
	return pHeadNode;
}
//Node* ListPop(List* list) {
//	
//}
