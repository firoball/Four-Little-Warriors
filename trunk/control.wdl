///////////////////////////////////////////////////////////////////////////////////
// ~ 4 Little Warriors ~ Control WDL
//
// modified by Firoball  04/27/2006 (created 01/07/2005)
///////////////////////////////////////////////////////////////////////////////////

//////////Prototypes

//////////Strings

string dbkey_str = "";
string ctl_key1_str;
string ctl_key2_str;
string ctl_key3_str;
string ctl_key4_str;
string ctl_key5_str;

string key_desc1_str = "Forward  - ";
string key_desc2_str = "Backward - ";
string key_desc3_str = "Left	 - ";
string key_desc4_str = "Right	- ";
string key_desc5_str = "Attack   - ";

string key_hdr_str;
string key_hdr1_str = "Keyboard 1";
string key_hdr2_str = "Keyboard 2";
string key_hdr3_str = "Joystick 1";
string key_hdr4_str = "Joystick 2";
string key_hdr5_str = "Mouse";

string empty_str = " ";
string key_info_str;
string key_temp_str[20];

//include "control.c";

//////////Database
/*
database keymap_db
{
	datafile "keymap.dat";
	separator "#";
	string "keyname";
}

dataview dbkeymap_view {database keymap_db;}
*/
//////////Texts

text key_ctl_txt
{
	pos_x 0;
	pos_y 0;
	strings 5;
	string ctl_key1_str, ctl_key2_str, ctl_key3_str, ctl_key4_str, ctl_key5_str;
	font warrior_fnt;
//	flags center_x;
	flags = filter;
}

text key_hdr_txt
{
	pos_x 0;
	pos_y 300;
	strings 1;
	string key_hdr_str;
	font warrior_fnt;
}

text key_desc_txt
{
	pos_x 300;
	pos_y 0;
	strings 5;
	string key_desc1_str, key_desc2_str, key_desc3_str, key_desc4_str, key_desc5_str;
	font warrior_fnt;
	flags = filter;
}

text key_header_txt
{
	pos_x 0;
	pos_y 150;
	strings 5;
	string key_hdr1_str, key_hdr2_str, key_hdr3_str, key_hdr4_str, key_hdr5_str;
	font warrior_fnt;
	flags = filter;
}

text key_map_txt
{
	strings = 1000;
}

text key_msg_txt
{
	pos_x 0;
	pos_y 300;
	strings 1;
	string key_info_str;
	font warrior_fnt;
	flags center_x;
}

//////////Functions

string temp_str[20]; 
function init_keymap()
{
	var tmp_hndl;
	var val;
	var loop;
	
	val = 1;
	loop = 0;
	tmp_hndl = file_open_game("keymap.dat");

	while(val != -1)
	{
		val = file_str_read(tmp_hndl, temp_str);
		str_cpy(key_map_txt.string[loop], temp_str);
		loop += 1;
	}
	file_close(tmp_hndl);
//	str_cpy(delimit_str, "
//	");
//	txt_load(key_map_txt, "keymap.dat");
}

function show_keylayout(ctl)
{
	var index;
	index = 5 * ctl;

	if (ctl == ctl_key1 || ctl == ctl_key2 || ctl == ctl_mouse)
	{
		str_cpy (key_ctl_txt.string[0], key_desc_txt.string[0]);
		str_cat (key_ctl_txt.string[0], key_map_txt.string[player_keys[index]]);

		str_cpy (key_ctl_txt.string[1], key_desc_txt.string[1]);
		str_cat (key_ctl_txt.string[1], key_map_txt.string[player_keys[index + 1]]);
	}
	else
	{
		str_cpy (key_ctl_txt.string[0], empty_str);
		str_cpy (key_ctl_txt.string[1], empty_str);
	}
	if (ctl == ctl_key1 || ctl == ctl_key2)
	{
		str_cpy (key_ctl_txt.string[2], key_desc_txt.string[2]);
		str_cat (key_ctl_txt.string[2], key_map_txt.string[player_keys[index + 2]]);

		str_cpy (key_ctl_txt.string[3], key_desc_txt.string[3]);
		str_cat (key_ctl_txt.string[3], key_map_txt.string[player_keys[index + 3]]);
	}
	else
	{
		str_cpy (key_ctl_txt.string[2], empty_str);
		str_cpy (key_ctl_txt.string[3], empty_str);
	}
	str_cpy (key_ctl_txt.string[4], key_desc_txt.string[4]);
	str_cat (key_ctl_txt.string[4], key_map_txt.string[player_keys[index + 4]]);

	key_ctl_txt.pos_x = screen_size.x * 0.5 - 100;
	key_ctl_txt.pos_y = screen_size.y * 0.48;
	key_ctl_txt.visible = on;

	str_cpy (key_info_str, " ");
	key_msg_txt.pos_x = screen_size.x * 0.5;
	key_msg_txt.pos_y = key_ctl_txt.pos_y + 95;
	key_msg_txt.visible = on;

	str_cpy (key_hdr_str, key_header_txt.string[ctl]);
	key_hdr_txt.pos_x = key_ctl_txt.pos_x - 115;
	key_hdr_txt.pos_y = key_ctl_txt.pos_y;
	key_hdr_txt.visible = on;
}

function hide_keylayout()
{
	key_ctl_txt.visible = off;
	key_msg_txt.visible = off;
	key_hdr_txt.visible = off;
}


string* key_temp_strpoi;

var key_ready;
function player_setkey(str, ctl, key)
{
	var key_valid;

	proc_kill(4);
	key_valid = 0;
	key_temp_strpoi = str;

	while (key_valid == 0)
	{
		key_valid = 1;
		while (key_any == 0)
		{
			wait (1);
		}
		//esc pressed?
		if (key_lastpressed == 1)
		{
			show_keylayout(ctl);
			while (key_any == 1)
			{
				wait (1);
			}
			keyopt_set_keys();
			str_cpy(key_info_str, " ");
			return;
		}
		//limit allowed keys for selected device
		if ((ctl == ctl_key1 || ctl == ctl_key2) && key_lastpressed > 255)
		{
			key_valid = 0;
		}

		if (ctl == ctl_joy1 && (key_lastpressed > 265 || key_lastpressed < 256))
		{
			key_valid = 0;
		}

		if (ctl == ctl_joy2 && (key_lastpressed > 275 || key_lastpressed < 266))
		{
			key_valid = 0;
		}

		if (ctl == ctl_mouse && (key_lastpressed > 282 || key_lastpressed < 280))
		{
			key_valid = 0;
		}
		wait (1);
	}
//	str_for_key (key_temp_str, key_lastpressed);
	str_cpy (key_temp_strpoi, key_desc_txt.string[key]);
	str_cat (key_temp_strpoi, key_map_txt.string[key_lastpressed]);

	while (key_any == 1)
	{
		wait (1);
	}
	player_keys[5 * ctl + key] = key_lastpressed;
	str_cpy (key_info_str, "Done");
	snd_play (accept_snd, 100, 0);
	sleep (1);
	key_ready = 1;
}

function key_change(keytype)
{
	var keyindex;

	proc_kill(4);
	key_ready = 0;
	while (key_any == 1)
	{
		wait (1);
	}

	while (keyindex < 5)
	{
		//skip unused keys for mouse and joystick
		if (keytype == ctl_mouse && keyindex == 2)
		{
			keyindex += 2;
		}

		if ((keytype == ctl_joy1 || keytype == ctl_joy2) && keyindex == 0)
		{
			keyindex += 4;
		}

		snd_play (updown_snd, 100, 0);

		str_cpy(key_info_str, "Press new button");
		str_cpy(key_ctl_txt.string[keyindex], key_desc_txt.string[keyindex]);
		str_cat(key_ctl_txt.string[keyindex], "???");

		player_setkey(key_ctl_txt.string[keyindex], keytype, keyindex);
		while (key_ready == 0)
		{
			wait (1);
		}
		key_ready = 0;
		keyindex += 1;
	}
	keyopt_set_keys();
	wait (-3);
	str_cpy(key_info_str, " ");
}

function key_init()
{
	player_ctl_type[0] = ctl_key1;
	player_ctl_type[1] = ctl_key2;
	player_ctl_type[2] = ctl_mouse;
	player_ctl_type[3] = ctl_joy1;

	//ctl_key1
	player_keys[0] = 72;
	player_keys[1] = 80;
	player_keys[2] = 75;
	player_keys[3] = 77;
	player_keys[4] = 29;

	//ctl_key2
	player_keys[5] = 17;
	player_keys[6] = 31;
	player_keys[7] = 30;
	player_keys[8] = 32;
	player_keys[9] = 16;

	//ctl_joy1
	player_keys[14] = 256;

	//ctl_joy2
	player_keys[19] = 266;

	//ctl_mouse
	player_keys[20] = 281;
	player_keys[21] = 282;
	player_keys[24] = 280;
}