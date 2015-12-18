///////////////////////////////////////////////////////////////////////////////////
// ~ 4 Little Warriors ~ Key generator WDL
//
// Modified by Firoball  06/27/2007 (created 05/31/2007)
///////////////////////////////////////////////////////////////////////////////////

//////////Prototypes
function key_check();
function key_read(hndl);
function key_write(hndl);
function key_decode(str);
function key_encode(str);
function key_validate();
function key_showdialog();
function key_hidedialog();
function key_gencode(str);
function key_extractstr(str, i);
function key_swapbit(i, x, y);

//////////Bindings
bind <logobg.pcx>;

//////////Entities
entity logobg_ent
{
	type = "logobg.pcx";
	x = 100;
	y = 0;
	z = 0;
	scale_x = 2;
	scale_y = 1.5;
	albedo = 0;
	ambient = 100;
	layer = 3;
}

//////////Variables
var_nsave key_code;
var_nsave key_done;

var_nsave key_count;
var_nsave keyvar_i;
var_nsave key_valid;

var_nsave key_handle;

//////////Strings
string key_tempstr[100];
string key_numstr[20];

string key_inamestr[100];
string key_icodestr[100];

string key_enamestr[100];
string key_ecodestr[100];

string key_namestr[100];
string key_codestr[100];

string key_nl_str = "\n";
string key_unreg1_str = "No valid key file found!";
string key_unreg2_str = "Please enter registry information or";
string key_unreg3_str = "press ESC to play restricted version.";
string key_entername_str = "Enter name:";
string key_entercode_str = "Enter code:";

string register_str[100];
string key_encstr[100];

//////////Fonts
font key_fnt = "keyfont.pcx", 20, 25;

//////////Texts
/*
text key_debug_txt
{
	layer = 16;
	strings = 2;
	string key_enamestr;
	string key_inamestr;
//	string key_namestr;
//	string key_codestr;
	font warrior2_fnt;
	flags visible;
}
*/
text key_entername_txt
{
	layer = 16;
	string key_inamestr;
	font key_fnt;
}

text key_entercode_txt
{
	layer = 16;
	string key_icodestr;
	font key_fnt;
	flags = filter;
}

text unreg_txt
{
	layer = 16;
	strings 3;
	string key_unreg1_str, key_unreg2_str, key_unreg3_str;
	font warrior2_fnt;
}

text key_name_txt
{
	layer = 16;
	string key_entername_str;
	font warrior2_fnt;
	flags = filter;
}

text key_code_txt
{
	layer = 16;
	string key_entercode_str;
	font warrior2_fnt;
	flags = filter;
}

text register_txt
{
	pos_x = 5;
	pos_y = 5;
	layer = 16;
	string register_str;
	font warrior2_fnt;
}

//////////Functions

function key_check()
{
	key_done = 0;
	key_valid = 0;
	str_cpy(register_str, "Unregistered Version");

	key_handle = file_open_read("4lwkey");
	if (!key_handle)
	{
		//no keyfile found
		key_showdialog();
		inkey (key_inamestr);
		if (result == 13)	//inkey finished with enter or tab?
		{
			key_code_txt.visible = on;
			key_entercode_txt.visible = on;
			inkey(key_icodestr);
			if (result == 13)
			{
				key_gencode(key_inamestr);
				key_validate();
			}
		}
	}
	else
	{
		key_read(key_handle);
		file_close(key_handle);
		key_gencode(key_inamestr);
		key_validate();
	}

	sleep (0.3);
	key_hidedialog();
	key_done = 1;
}

function key_read(hndl)
{
	//dummy read ins
	file_str_read(hndl, key_namestr);
	file_str_read(hndl, key_namestr);

	file_str_read(hndl, key_enamestr);
	file_str_read(hndl, key_ecodestr);

	//decode strings
	key_decode(key_enamestr);
	key_decode(key_ecodestr);
	str_cpy(key_inamestr, key_enamestr);
	str_cpy(key_icodestr, key_ecodestr);
}

function key_write(hndl)
{
	//encode strings
	str_cpy(key_enamestr, key_inamestr);
	str_cpy(key_ecodestr, key_icodestr);
	key_encode(key_enamestr);
	key_encode(key_ecodestr);

	//write key info
	file_str_write(hndl, "4LW keyfile");
	file_str_write(hndl, "\n");
	file_str_write(hndl, "--------------");
	file_str_write(hndl, "\n");
	file_str_write(hndl, key_enamestr);
	file_str_write(hndl, "\n");
	file_str_write(hndl, key_ecodestr);
	file_str_write(hndl, "\n");
	file_str_write(hndl, "--------------");
	file_str_write(hndl, "\n");
	file_str_write(hndl, "DO NOT MODIFY!");
}

function key_decode(str)
{
	var i;
	var j;
	j = str_len (str);
	str_cpy (key_encstr, str);
	str_cpy (str, "");
	str_cpy (key_numstr, "");

	while (i < j)
	{
		str_cpy (key_tempstr, key_encstr);
		str_clip (key_tempstr, i);
		temp = str_to_asc(key_tempstr);
        temp = (255 - temp) - (i % 2) * 3;
		cycle (temp, 0, 255);
		str_for_asc (key_numstr, temp);
		str_cat (str, key_numstr);
		i += 1;
	}
}

function key_encode(str)
{
	var i;
	var j;
	j = str_len (str);
	str_cpy (key_encstr, str);
	str_cpy (str, "");
	str_cpy (key_numstr, "");

	while (i < j)
	{
		str_cpy (key_tempstr, key_encstr);
		str_clip (key_tempstr, i);
		temp = str_to_asc(key_tempstr);
        temp = (255 - temp) - (i % 2) * 3;
		cycle (temp, 0, 255);
		str_for_asc (key_numstr, temp);
		str_cat (str, key_numstr);
		i += 1;
	}
}

function key_validate()
{
	if (str_cmp(key_codestr, key_icodestr))
	{
		str_cpy (register_str, "Registered to:\n");
		str_cat (register_str, key_inamestr);
		key_valid = 1;

		if (!file_open_read("4lwkey"))
		{
			snd_play (accept_snd, 100, 0);
			key_handle = file_open_write("4lwkey");
			key_write(key_handle);
			file_close(key_handle);
		}

	}
	else
	{
		key_handle = file_open_read("4lwkey");
		if (key_handle)
		{
			file_close(key_handle);
			str_cpy (register_str, "Invalid key file!\n");
			str_cat (register_str, "Please restart game!");
			file_delete("4lwkey");
		}

    	snd_play (cancel_snd, 100, 0);
	}

	return (key_valid);
}

function key_showdialog()
{
	logobg_ent.visible = on;

	key_entername_txt.visible = on;
	key_entername_txt.pos_x = screen_size.x / 2 - 9 * key_entername_txt.char_x;
	key_entername_txt.pos_y = screen_size.y / 2 - key_entername_txt.char_y;

	key_entercode_txt.visible = on;
	key_entercode_txt.pos_x = screen_size.x / 2 - 9 * key_entercode_txt.char_x;
	key_entercode_txt.pos_y = screen_size.y / 2 + key_entercode_txt.char_y;

	unreg_txt.visible = on;
	unreg_txt.center_x = on;
	unreg_txt.pos_x = screen_size.x / 2;
	unreg_txt.pos_y = key_entername_txt.pos_y - 3.5 * key_entername_txt.char_y;

	key_name_txt.visible = on;
    key_name_txt.pos_x = screen_size.x / 2 - 18 * key_name_txt.char_x;
	key_name_txt.pos_y = unreg_txt.pos_y + unreg_txt.char_y * 5;

    key_code_txt.visible = on;
    key_code_txt.pos_x = screen_size.x / 2 - 18 * key_code_txt.char_x;
	key_code_txt.pos_y = key_name_txt.pos_y + key_code_txt.char_y * 4;

}

function key_hidedialog()
{
	logobg_ent.visible = off;
	key_entername_txt.visible = off;
	key_entercode_txt.visible = off;
	unreg_txt.visible = off;
	key_name_txt.visible = off;
	key_code_txt.visible = off;
}

function key_gencode(str)
{
	var i;
	var j;
	var kcode;
	var kcode2;
	var kcodefac;

	str_cpy (key_namestr, str);
	str_cpy (key_codestr, "");
	i = 0;
	j = str_len (key_namestr);
    kcode = 0;
	kcodefac = 0;

	while (i < j)
	{
		temp = key_extractstr(key_namestr, i);
		temp = key_swapbit(temp, (i & 7), (7 - ((i * 2) & 7)));
		kcode += temp + temp * 1087 - i;
		while (kcode > 100000)
		{
			kcodefac += 1;
			kcode -= 100000;
		}
		if (i < j && i < 5)
		{
			kcode2 += (temp % 10) * pow(10, i);
		}
		i += 1;
	}

	str_for_num(key_numstr, kcode2);
    str_cat(key_codestr, key_numstr);

	if (kcodefac > 0)
	{
		str_for_num(key_numstr, kcodefac);
	    str_cat(key_codestr, key_numstr);
//		str_cat(key_codestr, "...");
	}
	str_for_num(key_numstr, kcode);
    str_cat(key_codestr, key_numstr);
}

function key_extractstr(str, i)
{
	str_cpy (key_tempstr, str);
	str_clip (key_tempstr, i);
	temp = str_to_asc(key_tempstr);

	return (temp);
}

function key_swapbit(j, b1, b2)
{
	temp.x = j;
    temp.y = temp.x & (1 << b1);
	temp.z = temp.x & (1 << b2);
	temp.x -= temp.y;
	temp.x -= temp.z;

    temp.y = (temp.y >> b1) << b2;
	temp.z = (temp.z >> b2) << b1;
	temp.x += temp.y;
	temp.x += temp.z;

	return (temp.x);
}