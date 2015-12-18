///////////////////////////////////////////////////////////////////////////////////
// ~ 4 Little Warriors ~ Head-up Display WDL
//
// modified by Firoball 03/19/07 (created 05/17/2001)
///////////////////////////////////////////////////////////////////////////////////

//////////Prototypes
function hudinit_handles();
function init_display();
function set_hudrank(tempent);
function set_display();
function show_display();
function hide_display();
function purge_display();

//////////Variables
//var playerpan_handle[4];
var playerpic_handle[4];
/*
VAR powold1;
VAR powold2;
VAR powold3;
VAR powold4;
VAR ammoold1;
VAR ammoold2;
VAR ammoold3;
VAR ammoold4;
*/

//////////Fonts
font debug_font = "bigfont.pcx", 10, 16;
font time_font = "timefont.tga", 15, 24;

//////////Bitmaps
bmap time_bg_map = "dots.tga";
bmap chargebar_map = "charge.pcx";
bmap winbar_map = "winbar.tga";
//bmap chargemax_map = "charge2.pcx";
bmap leftpanel_map = "panel_l.tga";
bmap rightpanel_map = "panel_r.tga";
bmap timefix_map = "timefix.tga";
bmap rank_map = "rank.tga";

//var panshift;

//////////Panels
panel timefix_pan
{
	pos_x = 0;
	pos_y = 0;
	bmap = timefix_map;
	flags = overlay;
}

panel time_pan
{
	pos_x = 0;
	pos_y = 0;
	bmap = time_bg_map;
	digits = -30, 0, 2, time_font, 1, disp_time.minute;
	digits = 15, 0, 2, time_font, 1, disp_time.second;
	flags = overlay;
}

panel player1_pan
{
	pos_x = 0;
	pos_y = 0;
	digits = 85, 6, 3, time_font, 1, pow[0];
	hbar = 80, 52, 50, chargebar_map, 4, ammo[0];
	hbar = 77, 39, 50, chargebar_map, 0.5, sta[0];
	hbar = 1, 63, 50, winbar_map, 10, player_won[0];
	bmap = leftpanel_map;
	flags = overlay;
	layer = 5;
}

panel player2_pan
{
	pos_x = 0;
	pos_y = 0;
	digits = 25, 6, 3, time_font, 1, pow[1];
	hbar = 28, 52, 50, chargebar_map, 4, ammo[1];
	hbar = 25, 39, 50, chargebar_map, 0.5, sta[1];
	hbar = 104, 63, 50, winbar_map, 10, player_won[1];
	bmap = rightpanel_map;
	flags = overlay;
	layer = 5;
}

panel player3_pan
{
	pos_x = 0;
	pos_y = 0;
	digits = 85, 6, 3, time_font, 1, pow[2];
	hbar = 80, 52, 50, chargebar_map, 4, ammo[2];
	hbar = 77, 39, 50, chargebar_map, 0.5, sta[2];
	hbar = 1, -10, 50, winbar_map, 10, player_won[2];
	bmap = leftpanel_map;
	flags = overlay;
	layer = 5;
}

panel player4_pan
{
	pos_x = 0;
	pos_y = 0;
	digits = 25, 6, 3, time_font, 1, pow[3];
	hbar = 28, 52, 50, chargebar_map, 4, ammo[3];
	hbar = 25, 39, 50, chargebar_map, 0.5, sta[3];
	hbar = 104, -10, 50, winbar_map, 10, player_won[3];
	bmap = rightpanel_map;
	flags = overlay;
	layer = 5;
}

panel playerpic1_pan
{
	pos_x = 0;
	pos_y = 0;
	bmap = leftpanel_map; //dummy
	window = 0, 37, 32, 19, rank_map, rank[0], 0;
	flags = overlay;
	layer = 6;
}

panel playerpic2_pan
{
	pos_x = 0;
	pos_y = 0;
	bmap = leftpanel_map; //dummy
	window = 14, 37, 32, 19, rank_map, rank[1], 0;
	flags = overlay;
	layer = 6;
}

panel playerpic3_pan
{
	pos_x = 0;
	pos_y = 0;
	bmap = leftpanel_map; //dummy
	window = 0, 37, 32, 19, rank_map, rank[2], 0;
	flags = overlay;
	layer = 6;
}

panel playerpic4_pan
{
	pos_x = 0;
	pos_y = 0;
	bmap = leftpanel_map; //dummy
	window = 14, 37, 32, 19, rank_map, rank[3], 0;
	flags = overlay;
	layer = 6;
}

//var levelnr;
//var helper[3];

panel debug_panel
{
		POS_X				0;
		POS_Y				100;
//		DIGITS		0,0,3,debug_font,160,fps;
//		DIGITS		5,0,5,debug_font,1,sound_vol;
//		DIGITS		5,15,5,debug_font,1,mod_vol;

//		DIGITS		150,0,5,debug_font,1,D3D_TEXSIZE.X;
//		DIGITS		190,0,5,debug_font,1,D3D_TEXSIZE.Y;
//		DIGITS		230,0,5,debug_font,1,D3D_TEXSIZE.Z;

//		DIGITS		250,0,5,debug_font,1,player_running[0];
//		DIGITS		5,45,5,debug_font,1,helper.x;
//		DIGITS		5,60,5,debug_font,1,helper.y;
//		DIGITS		5,75,5,debug_font,1,helper.z;
//		DIGITS		380,0,5,debug_font,1,levelnr;

		DIGITS		266,0,2,debug_font,1,enable_mod;
		DIGITS		286,0,2,debug_font,1,music_device;
		DIGITS		306,0,2,debug_font,1,dll_handle;
//		FLAGS		OVERLAY,REFRESH,VISIBLE;
}

string helper_str[100];
text debug_text
{
	strings 1;
	string helper_str;
	font debug_font;
	pos_x 0;
	pos_y 60;
	layer = 16;
	flags visible;
}

//////////Functions
function hudinit_handles()
{
/*
	playerpan_handle[0] = handle(player1_pan);
	playerpan_handle[1] = handle(player2_pan);
	playerpan_handle[2] = handle(player3_pan);
	playerpan_handle[3] = handle(player4_pan);
*/
	playerpic_handle[0] = handle(playerpic1_pan);
	playerpic_handle[1] = handle(playerpic2_pan);
	playerpic_handle[2] = handle(playerpic3_pan);
	playerpic_handle[3] = handle(playerpic4_pan);
}

function init_display()
{
	time_pan.pos_x = screen_size.x / 2 - 8;
	time_pan.pos_y = 6;
	timefix_pan.pos_x = time_pan.pos_x + 15;
	timefix_pan.pos_y = 6;
	player1_pan.pos_x = 0;
	player2_pan.pos_x = screen_size.x - panelWidth;
	player3_pan.pos_x = 0;
	player4_pan.pos_x = screen_size.x - panelWidth;
	player1_pan.pos_y = 0;
	player2_pan.pos_y = 0;
	player3_pan.pos_y = screen_size.y - panelHeight;
	player4_pan.pos_y = screen_size.y - panelHeight;

	playerpic1_pan.pos_x = player1_pan.pos_x + 3;
	playerpic1_pan.pos_y = player1_pan.pos_y + 3;
	playerpic2_pan.pos_x = player2_pan.pos_x + 106;
	playerpic2_pan.pos_y = player2_pan.pos_y + 3;
	playerpic3_pan.pos_x = player3_pan.pos_x + 3;
	playerpic3_pan.pos_y = player3_pan.pos_y + 3;
	playerpic4_pan.pos_x = player4_pan.pos_x + 106;
	playerpic4_pan.pos_y = player4_pan.pos_y + 3;
}

function set_hudrank(tempent)
{
	me = tempent;
	temp = 0;
	if (int (my.pow) < int (player1.pow) && me != player1) {temp += rankWidth;}
	if (int (my.pow) < int (player2.pow) && me != player2) {temp += rankWidth;}
	if (int (my.pow) < int (player3.pow) && me != player3) {temp += rankWidth;}
	if (int (my.pow) < int (player4.pow) && me != player4) {temp += rankWidth;}

	if (me == player1) {rank[0] = temp;}
	if (me == player2) {rank[1] = temp;}
	if (me == player3) {rank[2] = temp;}
	if (me == player4) {rank[3] = temp;}
}

function set_display()
{
	var i;
	while (player1 == null || player2 == null || player3 == null || player4 == null)
	{
		wait (1);
	}
	init_display();
	show_display();
	while (game_status != stat_gameover && game_status != stat_leave)
	{
		i = 0;
		while (i < 4)
		{
			tempptr = ptr_for_handle(playerlist[i]);
			set_hudrank(tempptr);
			pow[i] = int (tempptr.pow);
			ammo[i] = tempptr.ammo;
			sta[i] = tempptr.stamina;
			i += 1;
		}
		wait (1);
/*
								IFDEF SERVER;
								powold1=powdisp1;
								powold2=powdisp2;
								powold3=powdisp3;
								powold4=powdisp4;
								ammoold1=ammo1;
								ammoold2=ammo2;
								ammoold3=ammo3;
								ammoold4=ammo4;
								ENDIF;
*/
		ifndef no_hud;
		timefix_pan.visible = (disp_time.second < 10);
		endif;
/*
								IFDEF SERVER;
								IF (powold1!=powdisp1) {SEND_VAR (powdisp1);}
								IF (powold2!=powdisp2) {SEND_VAR (powdisp2);}
								IF (powold3!=powdisp3) {SEND_VAR (powdisp3);}
								IF (powold4!=powdisp4) {SEND_VAR (powdisp4);}
								IF (ammoold1!=ammo1) {SEND_VAR (ammo1);}
								IF (ammoold2!=ammo2) {SEND_VAR (ammo2);}
								IF (ammoold3!=ammo3) {SEND_VAR (ammo3);}
								IF (ammoold4!=ammo4) {SEND_VAR (ammo4);}
								ENDIF;
*/


		}
		hide_display();
		purge_display();
	}
}

function show_display()
{
	ifdef no_hud;
	return;
	endif;

	time_pan.visible = on;
	player1_pan.visible = on;
	player2_pan.visible = on;
	player3_pan.visible = on;
	player4_pan.visible = on;
	playerpic1_pan.visible = on;
	playerpic2_pan.visible = on;
	playerpic3_pan.visible = on;
	playerpic4_pan.visible = on;
}

function hide_display()
{
	time_pan.visible = off;
	timefix_pan.visible = off;
	player1_pan.visible = off;
	player2_pan.visible = off;
	player3_pan.visible = off;
	player4_pan.visible = off;
	playerpic1_pan.visible = off;
	playerpic2_pan.visible = off;
	playerpic3_pan.visible = off;
	playerpic4_pan.visible = off;
}

function purge_display()
{
	bmap_purge (timefix_map);
	bmap_purge (time_bg_map);
	bmap_purge (chargebar_map);
	bmap_purge (leftpanel_map);
	bmap_purge (rightpanel_map);
	bmap_purge (rank_map);
	bmap_purge (playerpic1_pan.bmap);
	bmap_purge (playerpic2_pan.bmap);
	bmap_purge (playerpic3_pan.bmap);
	bmap_purge (playerpic4_pan.bmap);
}