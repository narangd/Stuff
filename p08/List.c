#include "List.h"

#include <stdlib.h>

List* ListCreate() {
	return calloc(1, sizeof(List));
}
Node* ListCreateNode() {
	return calloc(1, sizeof(Node));
}
void ListFree(List** ppList) {
	List* pList = *ppList;
	while (pList->pHead != NULL) {
		Node* pNode = ListPopHead(pList);
		ListFreeNode(pList, &pNode);
	}
	pList->pTail = NULL;
	free(pList);
	*ppList = NULL;
}
void ListFreeNode(List* list, Node** ppNode) {
	Node* pNode = *ppNode;
	ListRemoveNode(list, pNode);
	free(pNode);
	*ppNode = NULL;
}

void ListInsertData(List* list, void* newData) {
	// create Node  and insert Data.
	Node* newNode = ListCreateNode();
	newNode->pData = newData;
	
	// Node insert to List.
	if (list->pTail == NULL) {
		list->pTail = list->pHead = newNode;
	} else {
		list->pTail->pNext = newNode;
		newNode->pPrev = list->pTail;
		list->pTail = newNode;
	}
	list->size++;
}

void ListRemoveNode(List* list, Node* removeNode) {
	// Node remove from List.
	if (list->pTail == NULL) {
		return;
	} else {
		// don't care NULL.
		if (removeNode->pPrev != NULL) {
			removeNode->pPrev->pNext = removeNode->pNext;
		}
		if (removeNode->pNext != NULL) {
			removeNode->pNext->pPrev = removeNode->pPrev;
		}
		removeNode->pNext = removeNode->pPrev = NULL;
	}
	list->size--;
}

Node* ListPopHead(List* pList) {
	Node* pNode = pList->pHead;
	if (pNode != NULL) {
		pList->pHead = pNode->pNext;
	} else {
		pList->pHead = NULL;
	}
	return pNode;
}
//Node* ListPop(List* list) {
//	
//}
