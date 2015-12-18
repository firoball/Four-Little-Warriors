///////////////////////////////////////////////////////////////////////////////////
// ~ 4 Little Warriors ~ Database WDL
//
// Modified by Firoball  06/04/2007		(created 10/17/2002)
///////////////////////////////////////////////////////////////////////////////////

//////////Prototypes
function dbinit_handles();
function dbinit();
function dbset_names();
function dbset_model();
function dbselect_player_inc();
function dbselect_player_dec();
function dbdetect_models();
function dbselect_model(plr, nr);
function dbselect_model_inc();
function dbselect_model_dec();
function dbselect_player(pl);
function get_item_stats();
function init_item_stats(ent);
function init_entity_stats(id, e);

//////////Variables
var dbitem_flags[16];
var dbitem_skin[16];
var dbitem_frame[16];

var db_sel[4] = 1,1,1,1;
var db_player = 0;

var playerent_handle[4];
var typ_offset;

//////////Strings
string dbselect_str = "";
string dbselect1_str[12];
string dbselect2_str[12];
string dbselect3_str[12];
string dbselect4_str[12];
string dbselpan1_str[16];
string dbselpan2_str[16];
string dbselpan3_str[16];
string dbselpan4_str[16];
string dbplayer_str[1];

string dbitem1_str[12];
string dbitem2_str[12];
string dbitem3_str[12];
string dbitem4_str[12];
string dbitem5_str[12];
string dbitem6_str[12];
string dbitem7_str[12];
string dbitem8_str[12];
string dbitem9_str[12];
string dbitem10_str[12];
string dbitem11_str[12];
string dbitem12_str[12];
string dbitem13_str[12];
string dbitem14_str[12];
string dbitem15_str[12];
string dbitem16_str[12];

//////////Pointers
panel* temp_panel;
entity* temp_entity;

//////////Fonts
font dummyfont, "dummyfnt.pcx",1,1;

//////////Database
/*
database player_db
{
	datafile "player.txt";
	separator ",";
	string "mdlname";
	string "cnt";
	string "dir";
	string "cnt2";
	string "pcx";
}

database item_db
{
	datafile "items.txt";
	separator ",";
	string "typ";
	string "skin";
	string "flags";
	string "mdl";
}

dataview dbplayer_view {database player_db;}
dataview dbitem_view {database item_db;}
*/

string database_str = "just a dummy!";
//////////Texts
//dummy text string array for item names
text dbitemsel_txt
{
	font dummyfont;
	strings 16;
	string dbitem1_str, dbitem2_str, dbitem3_str, dbitem4_str,
		dbitem5_str, dbitem6_str, dbitem7_str, dbitem8_str,
		dbitem9_str, dbitem10_str, dbitem11_str, dbitem12_str,
		dbitem13_str, dbitem14_str, dbitem15_str, dbitem16_str;
}

//dummy text string array for player models
text dbplayersel_txt
{
	font dummyfont;
	strings 4;
	string dbselect1_str, dbselect2_str, dbselect3_str, dbselect4_str;
}

//dummy text string array for player panels
text dbpanelsel_txt
{
	font dummyfont;
	strings 4;
	string dbselpan1_str, dbselpan2_str, dbselpan3_str, dbselpan4_str;
}

text dbhelppos0_txt
{
	font dummyfont;
//	dataview dbplayer_view;
//	viewpos 0;
strings 5;
string database_str, database_str, database_str, database_str, database_str;
}

text dbhelppos1_txt
{
	font dummyfont;
//	dataview dbplayer_view;
//	viewpos 1;
strings 5;
string database_str, database_str, database_str, database_str, database_str;
}

text dbhelppos2_txt
{
	font dummyfont;
//	dataview dbplayer_view;
//	viewpos 2;
strings 5;
string database_str, database_str, database_str, database_str, database_str;
}

text dbhelppos3_txt
{
	font dummyfont;
//	dataview dbplayer_view;
//	viewpos 3;
strings 5;
string database_str, database_str, database_str, database_str, database_str;

}

text dbhelppos4_txt
{
	font dummyfont;
//	dataview dbplayer_view;
//	viewpos 4;
strings 5;
string database_str, database_str, database_str, database_str, database_str;

}

text dbitempos0_txt
{
	font dummyfont;
//	dataview dbitem_view;
//	viewpos 0;
strings 5;
string database_str, database_str, database_str, database_str, database_str;

}


text dbitempos1_txt
{
	font dummyfont;
//	dataview dbitem_view;
//	viewpos 1;
strings 5;
string database_str, database_str, database_str, database_str, database_str;

}

text dbitempos2_txt
{
	font dummyfont;
//	dataview dbitem_view;
//	viewpos 2;
strings 5;
string database_str, database_str, database_str, database_str, database_str;

}

text dbitempos3_txt
{
	font dummyfont;
//	dataview dbitem_view;
//	viewpos 3;
strings 5;
string database_str, database_str, database_str, database_str, database_str;

}

/*
text dbnamehelp_txt
{
		pos_x=200;
		font debug_font;
		strings 8;
		string dbselect1_str, dbselect2_str, dbselect3_str, dbselect4_str;
		string dbselpan1_str, dbselpan2_str, dbselpan3_str, dbselpan4_str;
		flags visible;
}
*/

//////////Functions
function dbinit_handles()
{
	hudinit_handles();
	playerent_handle[0] = handle(yelplayer_ent);
	playerent_handle[1] = handle(redplayer_ent);
	playerent_handle[2] = handle(bluplayer_ent);
	playerent_handle[3] = handle(grnplayer_ent);
}

function dbinit()
{
//select all available entries for model list

	dbinit_handles();
	dbhelppos0_txt.visible = on;
	dbhelppos1_txt.visible = on;
	dbhelppos2_txt.visible = on;
	dbhelppos3_txt.visible = on;
	dbhelppos4_txt.visible = on;

//	select dbplayer_view, "mdlname", dbselect_str;
	wait (1);
	dbhelppos0_txt.visible = off;
	dbhelppos1_txt.visible = off;
	dbhelppos2_txt.visible = off;
	dbhelppos3_txt.visible = off;
	dbhelppos4_txt.visible = off;

//initialize strings
	db_player = 0;
	while (db_player < 4)
	{
		db_sel[db_player] = 1;
		dbset_names();
		dbset_model();
		db_player += 1;
	}
	db_player = 0;

//morph correct models
//	dbset_models();
}

function dbset_names()
{
	//player model (<db>.mdl)
	str_cpy (dbplayersel_txt.string[db_player], dbhelppos0_txt.string[db_sel[db_player]]);
	str_cat (dbplayersel_txt.string[db_player], ".mdl");

	//player panel (<db>_panX.<db>)
	str_for_num (dbplayer_str, db_player + 1);
	str_cpy (dbpanelsel_txt.string[db_player], dbhelppos0_txt.string[db_sel[db_player]]);
	str_cat (dbpanelsel_txt.string[db_player], "_pan");
	str_cat (dbpanelsel_txt.string[db_player], dbplayer_str);
	str_cat (dbpanelsel_txt.string[db_player], ".");
	str_cat (dbpanelsel_txt.string[db_player], dbhelppos4_txt.string[db_sel[db_player]]);
}

function dbset_model()
{
	temp_entity = ptr_for_handle(playerent_handle[db_player]);
	ent_morph (temp_entity, dbplayersel_txt.string[db_player]);
}

function dbselect_player_inc()
{
	db_player += 1;
	db_player &= 3;
}

function dbselect_player_dec()
{
	db_player -= 1;
	if (db_player < 0)
	{
		db_player = 3;
	}
}

function dbdetect_models()
{
   var i;

   i = 0;
   while (str_cmpi (dbhelppos0_txt.string[i+1], "ENDOFFILE") != 1)
   {
   	i += 1;
   }
   return (i);
}

function dbselect_model(dbplr, dbnr)
{
	db_player = dbplr;

	db_sel[db_player] = dbnr;
	dbset_names();
	dbset_model();
}

//won't work without dbinit() called once
function dbselect_model_inc()
{
	if (demoversion == 1)
	{
	    if (db_sel[db_player] == DEFdemomdl1)
	    {
	        db_sel[db_player] = DEFdemomdl2;
	    }
	}
	else
	{
	    db_sel[db_player] += 1;
	    if (str_cmpi (dbhelppos0_txt.string[db_sel[db_player]], "ENDOFFILE") == 1)
	    {
	        db_sel[db_player] -= 1;
	    }
	}
	dbset_names();
	dbset_model();
}

//won't work without dbinit() called once
function dbselect_model_dec()
{
	if (demoversion == 1)
	{
	    if (db_sel[db_player] == DEFdemomdl2)
	    {
	        db_sel[db_player] = DEFdemomdl1;
	    }
	}
	else
	{
	    db_sel[db_player] -= 1;
	    db_sel[db_player] = max(db_sel[db_player], 1);
	}
	dbset_names();
	dbset_model();
}


//Functions for morphing each player correctly on level startup

function dbselect_player(pl)
{
	ent_morph (me, dbplayersel_txt.string[pl]);
	ent_morph (player_ent, dbpanelsel_txt.string[pl]);
	temp_panel = ptr_for_handle(playerpic_handle[pl]);
	temp_panel.bmap = bmap_for_entity (player_ent, 0);
	my.skill1 = str_to_num (dbhelppos1_txt.string[db_sel[pl]]);
	my.skill2 = str_to_num (dbhelppos2_txt.string[db_sel[pl]]);
	my.skill3 = str_to_num (dbhelppos3_txt.string[db_sel[pl]]);
	if (my.skill1 == 0) {my.skill1 = 96;}
	if (my.skill2 == 0) {my.skill2 = 109;}
	if (my.skill3 == 0) {my.skill3 = 108;}
}


//////////
function get_item_stats()
{
	var i;

	//select all available entries for model list
	dbitempos0_txt.visible = on;
	dbitempos1_txt.visible = on;
	dbitempos2_txt.visible = on;
	dbitempos3_txt.visible = on;

//	select dbplayer_view, "mdlname", dbselect_str;
	wait (1);
	dbitempos0_txt.visible = off;
	dbitempos1_txt.visible = off;
	dbitempos2_txt.visible = off;
	dbitempos3_txt.visible = off;

	while(i < max_items - 10)
	{
		dbitem_frame[i] = str_to_num (dbitempos0_txt.string[i + 1]);
		dbitem_skin[i] = str_to_num(dbitempos1_txt.string[i + 1]);
		dbitem_flags[i] = str_to_num(dbitempos2_txt.string[i + 1]);
		str_cpy (dbitemsel_txt.string[i], dbitempos3_txt.string[i + 1]);
		str_cat (dbitemsel_txt.string[i], ".mdl");
		i += 1;
	}
}

function init_item_stats(ent)
{
	tempent = ent;
	if(tempent.typ < 11)
	{
		return;
	}
	typ_offset = tempent.typ - 11;

//init flags
	temp = dbitem_flags[typ_offset] & 1;
	tempent.transparent = (temp == 1);

	temp = dbitem_flags[typ_offset] & 2;
	tempent.bright = (temp == 2);

	temp = dbitem_flags[typ_offset] & 4;
	tempent.overlay = (temp == 4);

	temp = dbitem_flags[typ_offset] & 8;
	tempent.flare = (temp == 8);

	tempent.skin = dbitem_skin[typ_offset];
	tempent.frame = dbitem_frame[typ_offset];
	ent_morph (tempent, dbitemsel_txt.string[typ_offset]);
}

function init_entity_stats(id, e)
{
	me = e;
	if (id < 11)
	{
		return;
	}
	typ_offset = id - 11;

	my.skin = dbitem_skin[typ_offset];
	my.frame = dbitem_frame[typ_offset];
	ent_morph (me, dbitemsel_txt.string[typ_offset]);

}