#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "Dyeing.h"
#include "List.h"

#define WIDTH    9
#define HEIGHT   8

//char DyeingSpot[HEIGHT][WIDTH] = {
//	0, 0, 0, 0, 0, 0, 0, 0, 0,
//	0, 0, 0, 1, 1, 0, 1, 1, 0,
//	0, 0, 0, 1, 1, 0, 1, 1, 0,
//	0, 1, 1, 1, 1, 1, 1, 1, 0,
//	0, 1, 1, 1, 1, 1, 1, 1, 0,
//	0, 1, 1, 1, 0, 1, 1, 0, 0,
//	0, 1, 1, 0, 0, 1, 1, 0, 0,
//	0, 0, 0, 0, 0, 0, 0, 0, 0
//};
//enum Color {
//	WHITE=0, GRAY=1, CHANGE=2
//};
//
//int DyeingIsColored(char spot[][WIDTH]);

int main() {
	char *current;

	int h, w;
	int count = 0, color_count=0;
	int data = 10;
	
	// test 
	List* list = ListCreate();
	
	ListInsertData(list, &data);
	
	printf("list size : %d\n", list->size);
	printf("list head : %d\n", *(int*)(list->pHead->pData));
//	
//	for (w=0; w<1000000; w++) {
//		ListInsertData(list, &w);
//	}
//	printf("list size : %d\n", list->size);
//	system("pause");
	
	ListFree(&list);
	system("pause");

//	while ( !isColored(spot) ) {
//		count ++;
//
//		// print console
//		printf("\n %d초 경과후의 예상결과\n", count);
//		printf("　┌─────────┐\n");
//		for (h=0; h<HEIGHT; h++) {
//			printf("　│");
//			for (w=0; w<WIDTH; w++) {
//				current = &spot[h][w];
//				
//				if (*current == WHITE || *current == CHANGE) {
//					*current = WHITE;
//					printf("■");
//				} else { // GRAY 
//					color_count = 0;
//
//					if (w>0 && w<WIDTH-1 && h>0 && h<HEIGHT-1) {
//						if (*(current-1) != GRAY) color_count++;
//						if (*(current+1) != GRAY) color_count++;
//						if (*(current-WIDTH) != GRAY) color_count++;
//						if (*(current+WIDTH) != GRAY) color_count++;
//					}
//
//					if (color_count >= 2) {
//						*current = CHANGE;
//						printf("▨");
//					} else {
//						*current = CHANGE;
//						printf("　");
//					}
//				}
//			}
//			printf("│\n");
//		}
//		printf("　└─────────┘\n");
//
//		//Sleep(1000);       // break time
//		system("pause");
//		system("cls");     // console clear
//	}
//	printf("총 걸린 시간은 : %d초 입니다\n", count);

	return 0;
}

int isColored(char spot[][WIDTH]) {
	int w, h;
	for (h=1; h<HEIGHT-1; h++) {
		for (w=1; w<WIDTH-1; w++) {
			if (spot[h][w]) {
				return 0;
			}
		}
	}
	return 1;
}

