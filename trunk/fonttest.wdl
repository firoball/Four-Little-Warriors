//////////Fonts
PATH "panels";
font key_fnt = "keyfont.pcx", 20, 25;

//////////Texts
text key_entername_txt
{
	layer = 16;
	string "hallali";
	font key_fnt;
	flags visible;
}

text key_entercode_txt
{
	layer = 16;
	string "hallali";
	font key_fnt;
	flags = filter, visible;
}

function main()
{
	screen_color.blue = 150;

	while(1)
	{
		wait(1);
	}
}