
#ifndef DYEING_
#define DYEING_

#define DYEING_WIDTH    9
#define DYEING_HEIGHT   8

// ¿°»ö...
 // to "handkerchief"(¼Õ¼ö°Ç) 
extern char aDyeingSpot[DYEING_HEIGHT][DYEING_WIDTH];
enum DyeingColor {
	WHITE=0, GRAY=1, CHANGE=2
};

int DyeingIsComplete(char aSpot[][DYEING_WIDTH]);
//void DyeHandkerchief(char aSpot[][DYEING_WIDTH]);
void DisplayHandkerchief(char aSpot[][DYEING_WIDTH]);
//void DyeingSpotInitialize(char aSpot[][DYEING_WIDTH]);

#endif
