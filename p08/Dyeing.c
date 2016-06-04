#include "Dyeing.h"

#include <stdio.h>

// from header extern...
char aDyeingSpot[DYEING_HEIGHT][DYEING_WIDTH] = {
	0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 1, 1, 0, 1, 1, 0,
	0, 0, 0, 1, 1, 0, 1, 1, 0,
	0, 1, 1, 1, 1, 1, 1, 1, 0,
	0, 1, 1, 1, 1, 1, 1, 1, 0,
	0, 1, 1, 1, 0, 1, 1, 0, 0,
	0, 1, 1, 0, 0, 1, 1, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0
};
// 6*7 =>42
// 42 - 11 => 31.

int DyeingIsComplete(char aSpot[][DYEING_WIDTH]) {
	int w, h;
	for (h=1; h<DYEING_HEIGHT-1; h++) {
		for (w=1; w<DYEING_WIDTH-1; w++) {
			if (aSpot[h][w]) {
				return 0;
			}
		}
	}
	return 1;
}

void DisplayHandkerchief(char aSpot[][DYEING_WIDTH]) {
	int h, w;
	
	printf("������������������������\n");
	for (h=0; h<DYEING_HEIGHT; h++) {
		printf("����");
		for (w=0; w<DYEING_WIDTH; w++) {
			switch (aSpot[h][w]) {
				case WHITE:
					printf("��");
					break;
				case GRAY:
					printf("��");
					break;
				case CHANGE:
					printf("��");
					aSpot[h][w] = WHITE;
					break;
			} // end of switch.
		} // end of width loop.
		printf("��\n");
	} // end of height loop.
	printf("������������������������\n");
}
