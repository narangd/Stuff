#include "Dyeing.h"

// from header extern...
char DyeingSpot[DYEING_HEIGHT][DYEING_WIDTH] = {
	0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 1, 1, 0, 1, 1, 0,
	0, 0, 0, 1, 1, 0, 1, 1, 0,
	0, 1, 1, 1, 1, 1, 1, 1, 0,
	0, 1, 1, 1, 1, 1, 1, 1, 0,
	0, 1, 1, 1, 0, 1, 1, 0, 0,
	0, 1, 1, 0, 0, 1, 1, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0
};

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

void DyeHandkerchief(char aSpot[][DYEING_WIDTH]) {
	
}

void DisplayHandkerchief(char aSpot[][DYEING_WIDTH]) {
	
}
