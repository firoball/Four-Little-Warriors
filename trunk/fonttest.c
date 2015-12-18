#include <acknex.h>"

#define PRAGMA_PATH "panels"
FONT* key_fnt = "keyfont.pcx";

TEXT* key_entername_txt =
{
	layer = 16;
	string = "hallo";
	font = key_fnt;
	flags = VISIBLE;
}

TEXT* key_entercode_txt =
{
	pos_y = 50;
	layer = 16;
	string = "hallo";
	font key_fnt;
	flags = FILTER | VISIBLE;
}

void main ()
{
	video_mode = 7; 
	screen_color.blue = 150;

	while(1)
	wait(1);
}