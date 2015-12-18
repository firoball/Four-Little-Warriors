///////////////////////////////////////////////////////////////////////////////////
// ~ 4 Little Warriors ~ Main WDL
//
// Modified by Firoball  08/06/2007
///////////////////////////////////////////////////////////////////////////////////

define demoversion;
define WARNLEVEL, 2;
//define showlogo;
//define no_key;
//define ufoview;
//define birdview;
//define no_hud;

//var helper[3];

//////////Prototypes
function intro_loader();
function level_reload();
function level_loader();
function anim_count(count_ent);
function anim_title(cur_ent);
function time_passed();
function init_scenemap(temp,uspd,vspd,br);
function init_music(temp);
function set_field();
function timecheck();
function wiimote_on(){return;}	//dummy for wiihack

//////////Subfolders
 
path "models";
path "samples";
path "entities";
path "panels";
path "sprites";
path "system";
path "music";

/*
resource "wrs_levels.wrs";
resource "wrs_panel.wrs";
resource "wrs_sprites.wrs";
resource "wrs_models.wrs";
resource "wrs_entities.wrs";
resource "wrs_sounds.wrs";
*/
//savedir "d:\\captures";
savedir "config";

font warrior_fnt = "bigfont.pcx", 10, 16;
font warrior2_fnt = "bigfont2.pcx", 10, 13;

bind "player.txt";
//bind <dplayer.txt>;
bind "items.txt";
bind "keymap.dat";

function dummy() {return;}

include "define.wdl";


///////////////////////////////////////////////////////////////////////////////////


//pointers
entity* player1;
entity* player2;
entity* player3;
entity* player4;
entity* netstart1;
entity* netstart2;
entity* netstart3;
entity* netstart4;
entity* center;
entity* golement;
entity* scenemap;
entity* tempent;
entity* cur_ent;
entity* count_ent;

//engine variables
var video_mode = DEFvid_res;
//var video_mode=V1024x768;

ifdef video2;
var video_mode = V320x240;
endif;
ifdef video5;
var video_mode = V512x384;
endif;
ifdef video6;
var video_mode = V640x480;
endif;
ifdef video7;
var video_mode = V800x600;
endif;
ifdef video8;
var video_mode = V1024x768;
endif;
ifdef video9;
var video_mode = V1280x960;
endif;
ifdef video10;
var video_mode = V1600x1200;
endif;
var video_depth = DEFvid_depth;

//engine variables
var tex_share = 1;
var max_entities = 250;
//var video_depth = 32;
var turb_speed = 0.3;
var mip_shaded = 2;//0.5;
var mip_flat = 2;//0.5;
var warn_level = WARNLEVEL;
//var clip_range = 2000;
var clip_size = 0;
var fps_max = 200; //should be 100 - bugfix. see starter fct.

//Game status variables
var demoplay;
var game_status;
var mod_fac[3] = 320, 3, 1;
var sta[4];
var pow[4];
var ammo[4];
var rank[4];
var player_won[4];
var event_trig;
entity* event_ptr;

ifdef demoversion;
var demoversion = 1;
ifelse;
var demoversion = 0;
endif;

//d3d settings
//var d3d_triplebuffer = 1;
var d3d_mipmapping = 3;
var d3d_lightres = 1;
//var d3d_texlimit = 256;

ifdef alphadepth;
	var d3d_alphadepth = 16;
ifelse;
	var d3d_alphadepth = 32;
endif;
//var d3d_shadowdepth = 16;

//internal settings
var_nsave key_wiiany; 	//required by wiihack
var_nsave wiimote_ena;	//required by wiihack

var base_speed = 1;
var orig_speed = 1;
var fac_speed = 1;
var water_height;
var ice_height;
var mirror_active;
var max_golems = 4;
var player_active = 1;
var teledelay;
var total_golems = 0;
var level_fog[2] = 0, 0;
var track;	//current music track, read only
var enable_mod = DEFmusic_device;
var player_ctl_mode[4] = 0, 0, 0, 0;

//game options
var_info game_speed = DEFgame_speed;
var_info cpu_level = DEFcpu_level;
var_info time_limit = DEFtime_limit; //minutes
var_info game_limit = DEFgame_limit;
var_info music_device = DEFmusic_device;
var_info mod_vol = 80;
var_info snd_vol = 50;
var_info cd_vol = 50;
var_info polyshadows = DEFpolyshadows;
var_info visualFX = DEFvisualFX;
var_info vid_depth = DEFvid_depth;
var_info vid_res = video_mode;//DEFvid_res;
var_info player_ctl_type[4] = ctl_key1, ctl_key2, ctl_mouse, ctl_joy1;
var_info player_keys[25];

//time variables
var cur_time;
var disp_time;
var timer;

//global temp variables
var i; //loop counter
entity* tempptr; //entity pointer storage

//network helpers
var client_music;
var netmode = 0; //1=server 2=client 0=no network
var clientno;
var clientok[5];
var serverok[5];

string load_level_str[12];
string new_level_str[12];

sound beep_sound = "ding.wav";

sound item_snd = "crystal.wav";
sound gong_snd = "go.wav";
sound one_snd = "1new.wav";//"one.wav";
sound two_snd = "2new.wav";//"two.wav";
sound three_snd = "3new.wav";//"three.wav";
sound warriors_snd = "4lwnew.wav";//"warriors.wav";
sound golem_snd = "golem.wav";
sound golemdie_snd = "golemdie.wav";
sound golematk_snd = "golematk.wav";
sound collect_snd = "collect.wav";
sound powerup_snd = "powerup.wav";
sound powerend_snd = "powerend.wav";
sound explode_snd = "explode.wav";
sound bounce_snd = "bounce.wav";
sound lfizzle_snd = "lfizzle.wav";
sound lbuzz_snd = "lbuzz.wav";
sound box_snd = "box.wav";
sound invul_snd = "invul.wav";
sound respawn_snd = "respawn.wav";
sound tele1_snd = "tele1.wav";
sound tele2_snd = "tele2neu.wav";
sound event_snd = "special.wav";
sound trophy_snd = "trophy.wav";
sound winner1_snd = "startwin.wav";
sound winner2_snd = "telewin.wav";
sound accept_snd = "accept.wav";
sound cancel_snd = "cancel.wav";
sound leftright_snd = "leftright.wav";
sound updown_snd = "updown.wav";
sound countdown_snd = "cntdown.wav";
sound stepswitch_snd = "switch.wav";

include "logo.wdl";
include "dll.wdl";
include "particle.wdl";
include "entity.wdl";
include "itemlist.wdl";
include "item.wdl";
include "movement.wdl";
include "camera.wdl";
include "movectrl.wdl";
include "control.wdl";
include "weapon.wdl";
include "event.wdl";
include "cpu.wdl";
include "golem.wdl";
include "winner.wdl";
//include <file.wdl>;
include "anim.wdl";
include "hud.wdl";
include "database.wdl";
include "menu.wdl";
include "keygen.wdl";
include "mainmenu.wdl";
include "instmenu.wdl";
include "optmenu.wdl";
include "credits.wdl";
include "eyecandy.wdl";

//include <scrap.wdl>; //record movie by pressing P
//include <keys.wdl>;	//for debugging only
include "dummy.wdl"; //lock standard keys
include "wiihack.wdl";	//die scheisse geht net!


//////////Version
string version_str = "Ver.11";
text version_txt
{
	pos_x = 5;
	pos_y = 5;
	layer = 16;
	strings = 1;
	string version_str;
	font = warrior2_fnt;
}

///////////////////////////////////////////////////////////////////////////////

function main()
{
	key_init();	//initialize input devices
	init_keymap();		//control.wdl
//	game_load("config", 0);
	video_switch (vid_res, vid_depth, 0);

	//fix video_depth and video_mode for windowed mode - in case mode cannot be set
	if (vid_depth != video_depth)
	{
		vid_depth = video_depth;
	}
	if (vid_res != video_mode)
	{
		vid_res = video_mode;
	}
//fps_max bugfix disabled for windowed mode
//	if (video_screen == 2)
//	{
		fps_max = 100;
//	}
	// set volume levels
	sound_vol = snd_vol;


//		scrap_movie(); //temp
	//load item names from text file
//	get_item_stats();
	version_txt.visible = on;

	ifdef showlogo;
	logo_show();
	while (logo_done != 1) {wait (1);}
	endif;

	ifndef no_key;
	key_check();
	while (key_done != 1) {wait (1);}
	demoversion = 1 - key_valid;
	endif;

	load_level "intro.wmb";
	if (music_device == 1)
	{
		init_mod();
		volume_mod(mod_vol);
	}
	if (music_device == 0)
	{
		cd_player();
		cdaudio_vol = cd_vol;
	}

	fog_color = 4;
	camera.fog = 100;
	wait (1);


	time_passed();
	wait (1);
ifdef wiimote;
	wiimote_on();
endif;
	game_status=stat_menu;
	show_mainmenu();
	version_txt.visible = off;
}


function intro_loader()
{
//	on_anykey = null;
//	fade_winner();
	mirror_active = 0;
	fog_color = 1;
	while (camera.fog < 100)
	{
		wait (1);
		camera.fog += 3 * time;
	}
	camera.fog = 100;
	menubg_ent.visible = off;
	reset_instents();
	game_status = stat_menu;
	wait (1);
	level_load ("intro.wmb");
	wait (1);
	show_mainmenu();
}

function level_reload()
{
	on_anykey = null;

	hide_trophies();
	level_loader();
}

function level_loader()
{
	clear_itemlist();
	total_pow = 0;
	total_golems = 0;
	fog_color = 1;

	while (camera.fog < 100)
	{
		wait (1);
		camera.fog += 3 * time;
	}

	game_status = stat_loadlevel;
	menubg_ent.visible = off;
	camera.fog = 100;
	cam_arc = 0;
	camera.arc = 60;
	level_load (level_str);

	wait (1);
	clip_size = 0.5;
	while (camera.fog > level_fog[fogStr])
	{
		wait (1);
		camera.fog -= 3 * time;
	}
	base_speed = game_speed * 0.3 + 0.4;
	orig_speed = base_speed;
	fac_speed = (4 - game_speed) * 0.3 + 0.4;

	camera.fog = level_fog[fogStr];
	fog_color = level_fog[fogCol];
	set_field();

	snd_play (three_snd, 100, -70);
	anim_count (three_ent);
	sleep (1);

	snd_play (two_snd, 100, 70);
	anim_count (two_ent);
	sleep (1);

	snd_play (one_snd, 100, -70);
	anim_count (one_ent);
	sleep (1);

	snd_play (gong_snd, 90, 0);
	anim_count (go_ent);

	game_status = stat_running;
	timecheck();
	set_display();
	event_listener();
		sleep (1);
	if (demoplay != 1)
	{
		on_esc = prepare_cancel_game;
	}
	else
	{
		prepare_cancel_demogame();
	}
}

function anim_count(count_ent)
{
	my = count_ent;
	my.scale_x = 1;
	my.scale_y = 1;
	my.alpha = 50;
	my.visible = on;
	my.x = 350;

	while (my.alpha > 0)
	{
		wait (1);
		my.alpha -= 2.5 * time;
		my.x += 15 * time;
		if (me == go_ent)
		{
			my.scale_x += 0.15 * time;
			my.scale_y -= 0.05 * time;
		}
	}
	my.alpha = 0;
	my.visible = off;
	ent_purge (me);
}

function anim_title(cur_ent)
{
	me = cur_ent;
	mod_fac.x = my.x;
	my.visible = on;
	while (my.visible==1)
	{
		my.pan = 180 - 10 * cos (timer * 3);
		my.roll = 10 * sin (timer * 2);
		my.scale_y = 0.7 + abs (0.3 * cos (timer * 4));
		my.scale_x = 0.7 + abs (0.3 * cos (timer * 3));
		my.x = mod_fac.x / (camera.arc / 60);
		wait (1);
	}
	my.x = mod_fac.x;
}

function time_passed()
{
	timer = 0;
	while (1)
	{
		timer += time;
		wait (1);
	}
}

function set_scenemap()
{
	my.passable = on;
	scenemap = me;
	my.x = 636 * cos (cam_angle.pan);
	my.y = 636 * sin (cam_angle.pan);
	my.z = - 32;
	my.pan = cam_angle.pan;
	my.ambient = 100;
	my.albedo = 0;
	wait (1);
	if (my.flag3) //bright scene map?
	{
//		my.unlit = on;
//		my.bright = on;
		while (game_status != stat_gameover)
		{
			wait (1);
			vec_set (my.x, camera.x);
			my.pan = cam_angle.pan + ang (cam_angle.pan - camera.pan);
			my.tilt = /*-75 + */ang (-camera.tilt);
		}
//		my.bright = off;
//		my.unlit = off;
	}

}

string scenebase_str, "scene";
string scenenr_str, "__";
string scenewmb_str, ".wmb";
string scenetemp_str, "sceneXX.wmb";

function init_scenemap(temp, uspd, vspd, flg)
{
	if (temp < 1)
	{
		scenemap = null;
		return;
	}
	if (temp > 99)
	{
		temp = 1;
	}

	str_for_num (scenenr_str, temp);
	str_cpy (scenetemp_str, scenebase_str);
	str_cat (scenetemp_str, scenenr_str);
	str_cat (scenetemp_str, scenewmb_str);
	you = ent_create (scenetemp_str, center.x, set_scenemap);

	if ((flg & 1) == 1)
	{
		your.unlit = on;
		your.bright = on;
	}
	if ((flg & 2) == 2)
	{
		your.nofog = on;
	}
	if (uspd != 0 || vspd != 0)
	{
		your.uvspeed = on;
		your.speed_u = uspd;
		your.speed_v = vspd;
	}
// space scenemap
	if (temp == 98)
	{
		your.flag3 = on;
	}
}

function cd_player()
{
	proc_kill(4);
	cd_play (track, 0);
	while (enable_mod == 0)
	{
		cd_play (0, 0);	//loop playback
		if (cd_track == 0 || cd_track != track)
		{
			cd_play (track, track);
		}
		sleep (1);
	}
	cd_play (0,1); //stop playback
}

function init_music(temp)
{
	enable_mod = music_device;
	if (temp < 1 ||temp > maxTrack)
	{
		track = defaultTrack;
	}
	else
	{
		track = temp;
	}
// CD Audio activated?
	if (enable_mod == 1)
	{
		play_mod (track);
	}
	if (enable_mod == 0)
	{
		cd_play (0, 99);
	}
}




///////////////////////////////////////////////////////////////////////////////////

function set_field()
{
	while (game_status!=stat_gameover)
	{
		field.pan=180;
		if (ang(camera.pan)<45 && ang(camera.pan)>=-45) {field.pan=0;}
		if (ang(camera.pan)<135 && ang(camera.pan)>=45) {field.pan=90;}
		if (ang(camera.pan)<-45 && ang(camera.pan)>=-135) {field.pan=-90;}
		wait (1);
	}
}

var temp_second;
function timecheck()
{
	if (demoplay == 1)
	{
		cur_time = 976;		//1 minute
	}
	else
	{
		cur_time = time_limit * 960 + 16;
	}
	temp_second = 0;
	while (cur_time > 16 && game_status != stat_leave)
	{
		cur_time -= time;
		disp_time.minute = int (cur_time / 960);
		disp_time.second = int (cur_time / 16) % 60;
		if (disp_time.second != temp_second)
		{
			if (disp_time.minute == 0 && disp_time.second < 11 && disp_time.second > 0)
			{
				if (demoplay == 1)
				{
					cancel_game();
				}
				else
				{
					snd_play (countdown_snd, 70, 0);
				}
			}
		}
		temp_second = disp_time.second;
		wait (1);
	}
	if (game_status != stat_leave)
	{
 		init_result();
	}
}

//////////Entity Actions

action play_music
{
	my.invisible = on;
	my.passable = on;
	init_music(my.skill2);
}

define ScenemapID,skill1;
define LevelMusic,skill2;
define GolemLimit,skill3;
define Scene_Uspd,skill4;
define Scene_Vspd,skill5;
define FogColor,skill6;
define FogStrength,skill7;
define SceneBright,flag1;
define SceneNofog,flag2;
define useMirror,flag3;

// uses ScenemapID, LevelMusic, GolemLimit, Scene_Uspd, Scene_Vspd, SceneBright, SceneNofog, FogColor, FogStrength, useMirror
action init_level
{
	my.invisible = on;
	my.passable = on;

//get user settings
	camera.pan = my.pan;
	cam_angle.pan = camera.pan;
	my.x = 0;
	my.y = 0;
	my.z = 50;
	center = me; //set to map center for winner sequence
	temp = (my.sceneBright == 1) + ((my.sceneNofog == 1) << 1);
	init_scenemap (my.scenemapID, my.Scene_Uspd, my.Scene_Vspd, temp);
	init_music (my.LevelMusic);
	max_golems = my.GolemLimit;
	level_fog[fogCol] = min (max (my.FogColor, 0), 4);
	level_fog[fogStr] = min (max (my.FogStrength, 0), 100);
	if (max_golems < 1 || max_golems > 10)
	{
		max_golems = 4;
	}
	water_height = -10000;	//modified by xwater action
	ice_height = -10000;	//modified by xice action
	if (my.useMirror == on)
	{
		mirror_active = 1;
		init_mirror_z();
	}
//	wait (1);
//	ent_remove (me);
}

//