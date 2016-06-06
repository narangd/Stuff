#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "Dyeing.h"
#include "List.h"

int main() {

	int h, w;
	int nCount, nColoredNearbyCount=0;
	List* pColoredList = ListCreate();
	Node* pCurrentNode;
	Node* pNexttNode;
	char* pCurrentSpot;
	
//	// test.
//	for (w=0; w<5; w++) {
//		struct AA* a = calloc(1, sizeof(struct AA));
//		a->A = w;
//		ListInsertData(pColoredList, a);
//		
//		pCurrentNode = pColoredList->pHead;
//		while (pCurrentNode != NULL) {
//			printf("[%d]->", *(int*)pCurrentNode->pData);
//			pCurrentNode = pCurrentNode->pNext;
//		}
//		printf("\n");
//	}
//	
//	// removing....
//	while (pColoredList->pHead != NULL) {
//		int i, size = rand() % pColoredList->nSize;
//		
//		pCurrentNode = pColoredList->pHead;
//		for (i=0; i<size; i++) { // 사이즈 만큼. 
//			pCurrentNode = pCurrentNode->pNext;
//		}
//		{
//			struct AA* pAA = (struct AA*)pCurrentNode->pData;
//			printf("[remove:%d]", pAA->A);
//			pNexttNode = ListRemoveNode(pColoredList, pCurrentNode);
//			ListFreeNode(&pCurrentNode);
//		}
//		
//		// display... 
//		pCurrentNode = pColoredList->pHead;
//		while (pCurrentNode != NULL) {
//			struct AA* pAA = (struct AA*)pCurrentNode->pData;
//			printf("[%d]->", pAA->A);
//			pCurrentNode = pCurrentNode->pNext;
//		}
//		printf("\n");
//	}
//	printf("\nafter... size:%d\n", pColoredList->nSize);
	
	// insert spot into list.
	for (h=0; h<DYEING_HEIGHT; h++) {
		for (w=0; w<DYEING_WIDTH; w++) {
			if (aDyeingSpot[h][w] == GRAY) {
				ListInsertData(pColoredList, &aDyeingSpot[h][w]);
			}
		} // end of width loop.
	} // end of height loop.
	
	
	nCount = 0;
	while ( pColoredList->nSize > 0 ) {
	printf("손수건의 더러운 곳의 수: %d\n", pColoredList->nSize);
		nCount ++;
		
		// looping until last node.
		pCurrentNode = pColoredList->pHead;
		while (pCurrentNode != NULL) {
			pCurrentSpot = (char*)pCurrentNode->pData;
			
			nColoredNearbyCount = 0;
			if ( *(pCurrentSpot-1)            == WHITE ) nColoredNearbyCount++;
			if ( *(pCurrentSpot+1)            == WHITE ) nColoredNearbyCount++;
			if ( *(pCurrentSpot-DYEING_WIDTH) == WHITE ) nColoredNearbyCount++;
			if ( *(pCurrentSpot+DYEING_WIDTH) == WHITE ) nColoredNearbyCount++;
			// left, right, up, down.
			
			if (nColoredNearbyCount >= 2) {
				*pCurrentSpot = CHANGE;
				// pCurrentNode is next node.
				pNexttNode = ListRemoveNode(pColoredList, pCurrentNode);
				ListFreeNode(&pCurrentNode);
				pCurrentNode = pNexttNode;
				continue;
			}
			
			pCurrentNode = pCurrentNode->pNext;
		}
		
		printf("\n %d초 경과후의 예상결과\n", nCount);
		DisplayHandkerchief(aDyeingSpot);

		//Sleep(1000);       // break time
		system("pause");
		system("cls");     // console clear
	} // end of list loop.
	printf("총 걸린 시간은 : %d초 입니다\n", nCount);

	ListFree(&pColoredList);

	return 0;
}

