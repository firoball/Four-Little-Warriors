// don't forget to INCLUDE scrap.wdl
// and insert scrap_movie(); in main

var Count = 11000;
var Count1 = 0;
var Count2 = 0;
var Count3 = 0;
var Count4 = 0;
var Count5 = 0;
var Count6 = 0;
var Count7 = 0;
var Count8 = 0;
var Count9 = 0;


function scrap_movie ()
{
	WHILE (1)
	{

		IF (Count == 11000 && KEY_p == 1) {WAIT (2); Count = 0;}
		WHILE (KEY_p == 1) {WAIT (1);}
		WHILE (count < 10000)
		{

		Count1 = Count - 1000;
		Count2 = Count - 2000;
		Count3 = Count - 3000;
		Count4 = Count - 4000;
		Count5 = Count - 5000;
		Count6 = Count - 6000;
		Count7 = Count - 7000;
		Count8 = Count - 8000;
		Count9 = Count - 9000;

		IF (Count < 10) {screenshot "Mv000",Count;}
		IF (Count >= 10 && Count < 100) {screenshot "Mv00",Count;}
		IF (Count >= 100 && Count < 1000) {screenshot "Mv0", Count;}
		IF (Count >= 1000 && Count < 1010) {screenshot "Mv100", Count1;}
		IF (Count >= 1010 && Count < 1100) {screenshot "Mv10", Count1;}
		IF (Count >= 1100 && Count < 2000) {screenshot "Mv1", Count1;}

		IF (Count >= 2000 && Count < 2010) {screenshot "Mv200", Count2;}
		IF (Count >= 2010 && Count < 2100) {screenshot "Mv020", Count2;}
		IF (Count >= 2100 && Count < 3000) {screenshot "Mv002", Count2;}

		IF (Count >= 3000 && Count < 3010) {screenshot "Mv300", Count3;}
		IF (Count >= 3010 && Count < 3100) {screenshot "Mv30", Count3;}
		IF (Count >= 3100 && Count < 4000) {screenshot "Mv3", Count3;}

		IF (Count >= 4000 && Count < 4010) {screenshot "Mv400", Count4;}
		IF (Count >= 4010 && Count < 4100) {screenshot "Mv40", Count4;}
		IF (Count >= 4100 && Count < 5000) {screenshot "Mv4", Count4;}

		IF (Count >= 5000 && Count < 5010) {screenshot "Mv500", Count5;}
		IF (Count >= 5010 && Count < 5100) {screenshot "Mv50", Count5;}
		IF (Count >= 5100 && Count < 6000) {screenshot "Mv5", Count5;}

		IF (Count >= 6000 && Count < 6010) {screenshot "Mv600", Count6;}
		IF (Count >= 6010 && Count < 6100) {screenshot "Mv60", Count6;}
		IF (Count >= 6100 && Count < 7000) {screenshot "Mv6", Count6;}

		IF (Count >= 7000 && Count < 7010) {screenshot "Mv700", Count7;}
		IF (Count >= 7010 && Count < 7100) {screenshot "Mv70", Count7;}
		IF (Count >= 7100 && Count < 8000) {screenshot "Mv7", Count7;}

		IF (Count >= 8000 && Count < 8010) {screenshot "Mv800", Count8;}
		IF (Count >= 8010 && Count < 8100) {screenshot "Mv80", Count8;}
		IF (Count >= 8100 && Count < 9000) {screenshot "Mv8", Count8;}

		IF (Count >= 9000 && Count < 9010) {screenshot "Mv900", Count9;}
		IF (Count >= 9010 && Count < 9100) {screenshot "Mv90", Count9;}
		IF (Count >= 9100 && Count < 10000) {screenshot "Mv9", Count9;}

		Count += 1;
		IF (KEY_p == 1) {WAIT (2); Count = 11000;}
		WHILE (KEY_p == 1) {WAIT (1);}
		WAIT (1);
		}
	WAIT (1);
	}
}