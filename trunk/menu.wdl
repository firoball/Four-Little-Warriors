///////////////////////////////////////////////////////////////////////////////////
// ~ 4 Little Warriors ~ Menu WDL
//
// modified by Firoball  08/06/2007
///////////////////////////////////////////////////////////////////////////////////

//////////Prototypes - Current Level Cancel
function prepare_cancel_game();
function prepare_cancel_demogame();
function cancel_game();

//////////Prototypes - Player selection
function player_pl1up();
function player_pl1down();
function player_pl1left();
function player_pl1right();
function player_pl1ready();

function player_pl2up();
function player_pl2down();
function player_pl2left();
function player_pl2right();
function player_pl2ready();

function player_pl3up();
function player_pl3down();
function player_pl3left();
function player_pl3right();
function player_pl3ready();

function player_pl4up();
function player_pl4down();
function player_pl4left();
function player_pl4right();
function player_pl4ready();

function set_playerfuncs(pl);
function joy1_listener(pl);
function joy2_listener(pl);
function mouse_listener(pl);
function activation_set_ctl(pl);
function activate_player1();
function activate_player2();
function activate_player3();
function activate_player4();
function activate_playerkeys();
function select_player();

function show_state(ent);
function hide_state(ent);
function show_states();
function hide_states();

function show_assigned_control(tempent, pl);
function show_joymode(tempent, pl);
function hide_joymode(tempent);
function hide_joymodes();
function show_joymodes();

function show_button(ent);
function hide_button(ent);
function show_buttons();
function hide_buttons();
function show_ready(ent);
function unset_plkeys(index);

function show_pl1arrows();
function hide_pl1arrows();
function show_pl2arrows();
function hide_pl2arrows();
function show_pl3arrows();
function hide_pl3arrows();
function show_pl4arrows();
function hide_pl4arrows();
function check_plarrows();
function hide_playerarrows();
function show_playerpanels();
function hide_playerpanels();

function run_level();
function cancel_level();
function select_level();
function select_level_right();
function select_level_left();
function set_level();
function change_display();


//////////Global Variables
var playmenu_ver[3] = 114, 80, -30;			//vertical stops player selection
var playmenu_hor[4] = 225, 75, -75, -225;	//horizontal stops player selection
var ctl_listener[4];
var player_ready;
var p1sel;
var p2sel;
var p3sel;
var p4sel;

//////////Function pointers
function* player_up;
function* player_down;
function* player_left;
function* player_right;
function* player_fire;

//////////Strings
string network_str[50];
string temp_str[50];
string join_str," joined the game.";

string empty_str " ";

//////////Cancel current level
function prepare_cancel_game()
{
	snd_play (accept_snd, 100, 0);
	ent_morph(menu2_ent, "leave.pcx");
	anim_ent(menu2_ent);
	menu2_ent.flare = on;
	menu2_ent.alpha = 50;
	menu2_ent.visible = on;
	on_esc = cancel_game;
	sleep (2);
	if (game_status != stat_gameover && game_status != stat_leave && game_status != stat_menu)
	{
		fadeout_flarepanel(menu2_ent);
		on_esc = prepare_cancel_game;
	}
}

function prepare_cancel_demogame()
{
	ent_morph(menu2_ent, "demo.pcx");
	anim_ent(menu2_ent);
	menu2_ent.flare = on;
	menu2_ent.alpha = 50;
	menu2_ent.visible = on;
	on_anykey = cancel_game;
}

function cancel_game()
{
	on_anykey = null;
	fadeout_flarepanel(menu2_ent);
	if (demoplay != 1)
	{
		on_esc = dummy;
		snd_play (cancel_snd, 100, 0);
	}
	demoplay = 0;
	fog_color = 1;
	game_status = stat_leave;
	while (camera.fog < 100)
	{
		wait (1);
		camera.fog += 3 * time;
	}
	camera.fog = 100;
	game_status = stat_gameover;
	wait (2);
	intro_loader();
}

////////////////////Level Select////////////////

var levelmax = DEFmaxlevels; //number of levels currently available
var levelnr=1;


string levelbase_str, "l";
string levelnr_str, "xx";
//string wmb_str, ".wmb";
string leveltemp_str, "12345678";
string level_str, "123456789012";


function run_level()
{
	snd_play (accept_snd, 100, 0);
	select_level();
//	if (levelnr<600)
//	{
		str_cpy (leveltemp_str,levelbase_str);
		str_for_num (levelnr_str,levelnr);
		str_cat (leveltemp_str,levelnr_str);
		str_cpy (level_str,leveltemp_str);
		str_cat (level_str,wmb_str);
//	}
//	else
//	{
//		str_cpy (level_str,picture_txt.string[curlev]);
//	}
	player_won[0] = 0;
	player_won[1] = 0;
	player_won[2] = 0;
	player_won[3] = 0;
	level_loader();
}

function select_level_right()
{
	snd_play (leftright_snd, 100, 100);
	if (demoversion == 1)
	{
	    if (levelnr == DEFdemolvl1)
	    {
	        levelnr = DEFdemolvl2;
	    }
	    else
	    {
	        levelnr = DEFdemolvl1;
	    }
	}
	else
	{
		levelnr+=1;
		if (levelnr>levelmax)
		{
//				if (levelnr<600)
//				{
//						levelnr=600;
//						curlev=0;
//				}
//				curlev+=1;
//				if (curlev>maxlev)
//				{
						levelnr=1;
//						curlev=1;
//				}
		}
	}
	change_display();
}

function select_level_left()
{
		snd_play (leftright_snd, 100, -100);
	if (demoversion == 1)
	{
	    if (levelnr == DEFdemolvl1)
	    {
	        levelnr = DEFdemolvl2;
	    }
	    else
	    {
	        levelnr = DEFdemolvl1;
	    }
	}
	else
	{
		 //		if (levelnr<600)
//  		{
				levelnr-=1;
				if (levelnr<1)
				{
//						levelnr=levelmax;
//						levelnr=600;
//						curlev=maxlev+1;
//				}
//		}
//		if (levelnr>=600)
//		{
//				curlev-=1;
//				if (curlev<1)
//				{
						levelnr=levelmax;
//						curlev=0;
//				}
		}
	}
	change_display();
}

string paneltemp_str, "123456789012";
string levelnr_str, "xxx";
string l_str, "l";

function set_level()
{
		if (levelnr<1) {levelnr=1;}
		if (levelnr>levelmax && levelnr<600) {levelnr=levelmax;}

		str_cpy(paneltemp_str,l_str);
		str_for_num (levelnr_str,levelnr);
		str_cat (paneltemp_str,levelnr_str);
		str_cat (paneltemp_str,pcx_str);

		ent_purge(level_ent);
		ent_morph(level_ent,paneltemp_str);
//		if (levelnr>=600) //user level loaded
//		{
//				ent_morph (level_ent,lvlfname_str);
//		str_cpy (lvlname_str,name_txt.STRING[curlev]);
//		str_cpy (lvldesc_str,description_txt.STRING[curlev]);
//		str_cpy (lvlfname_str,picture_txt.STRING[curlev]);
//				ent_morph (level_ent,"l2.pcx");
//		}
		level_ent.visible = on;
}

function change_display()
{
	on_cur = null;
	on_cul = null;
	on_enter = dummy;
	on_esc = dummy;
	hide_controls(controls_ent);
	while (level_ent.tilt < 90)
	{
		wait (1);
		level_ent.pan = entpan + 15 * sin(7 * timer);
		level_ent.tilt -= 9 * time;
		menu1_ent.y -= 10 * time;
		menu3_ent.y += 10 * time;
		menu1_ent.alpha = max (menu1_ent.alpha - 10 * time, 0);
		menu3_ent.alpha = menu1_ent.alpha;
		if (level_ent.tilt < -90)
		{
			menu1_ent.visible = off;
			menu3_ent.visible = off;
			level_ent.tilt = 90;
			level_ent.visible=0;
			ent_purge(level_ent);
			set_level();
		}
	}

	show_controls(controls_ent);
	while (level_ent.tilt > 0)
	{
		wait (1);
		level_ent.pan = entpan + 15 * sin(7 * timer);
		level_ent.tilt -= 9 * time;
	}
	level_ent.tilt=0;
	anim_level_ent();
	waitt (4);
	if (key_cur!=0)
	{
		select_level_right();
		return;
	}
	if (key_cul!=0)
	{
		select_level_left();
		return;
	}
	on_enter = run_level;
	on_esc = cancel_level;
	on_cur = select_level_right;
	on_cul = select_level_left;
}



function select_player_done()
{
//player is not required to be ready in single player mode
	var ready; // only for single player game
	ready = 0;
	if ((player_active&15)==1)
	{
		pl1left_ent.visible=0;
		pl1right_ent.visible=0;
		ready = 1;
	}
	if ((player_active&15)==2)
	{
		pl2left_ent.visible=0;
		pl2right_ent.visible=0;
		ready = 1;
	}
	if ((player_active&15)==4)
	{
		pl3left_ent.visible=0;
		pl3right_ent.visible=0;
		ready = 1;
	}
	if ((player_active&15)==8)
	{
		pl4left_ent.visible=0;
		pl4right_ent.visible=0;
		ready = 1;
	}
//only close menu if all human players are ready
	if (!ready)
	{
		if (((15-(player_active&15))|player_ready)!=15)
		{
			return;
		}
	}
	snd_play (accept_snd, 100, 0);
	select_player();
	while (yelpanel_ent.visible==1)
	{
		wait (1);
	}
	select_level();
}

function select_menu()
{
	snd_play (accept_snd, 100, 0);
	camera.fog = 0;
	fog_color = 4;
	while (camera.fog < 100)
	{
		wait (1);
		camera.fog += 4 * time;
	}
	camera.fog = 100;
	load_level "menu.wmb";
	anim_menubg();
	cam_arc = 0;
	camera.arc = 60;
//proceed to player selection
	player_active = 0;
	levelnr = 1;
	select_player();
}

function cancel_player()
{
	snd_play (cancel_snd, 100, 0);
	select_player();
	hide_playerarrows();
	intro_loader();
}

//////////Player selection//////////

//Player1
function player_pl1up()
{
	p1sel.y=max(0,p1sel.y-1);
	if (p1sel.y == 1 && ((player_ctl_type[0] != ctl_joy1 && player_ctl_type[0] != ctl_joy2) || p1sel.x != 0))
	{
		p1sel.y -= 1;
	}
	pl1left_ent.z=playmenu_ver[p1sel.y];
	pl1right_ent.z=playmenu_ver[p1sel.y];
}

function player_pl1down()
{
	p1sel.y=min(2,p1sel.y+1);
	if (p1sel.y == 1 && ((player_ctl_type[0] != ctl_joy1 && player_ctl_type[0] != ctl_joy2) || p1sel.x != 0))
	{
		p1sel.y += 1;
	}
	pl1left_ent.z=playmenu_ver[p1sel.y];
	pl1right_ent.z=playmenu_ver[p1sel.y];
}

function player_pl1left()
{
	if (p1sel.y==0)
	{
		temp.y=p1sel.x;
		p1sel.x=max(0,p1sel.x-1);
		while(1)
		{
			temp=1<<p1sel.x;
			if ((player_active&temp)==temp && p1sel.x!=0) {p1sel.x-=1;}
			else {break;}
			if (p1sel.x<0) {p1sel.x=temp.y;} //reset selector to own panel
		}
		return;
	}

	if (p1sel.y==1)
	{
		player_ctl_mode[0] = 1 - player_ctl_mode[0];
		show_joymode(yelmode_ent, 0);
		return;
	}

	if (p1sel.y==2)
	{
		db_player=p1sel.x;
		dbselect_model_dec();
		return;
	}
}

function player_pl1right()
{
	if (p1sel.y==0)
	{
		temp.y=p1sel.x;
		p1sel.x=min(3,p1sel.x+1);
		while(1)
		{
			temp=1<<p1sel.x;
			if ((player_active&temp)==temp && p1sel.x!=0) {p1sel.x+=1;}
			else {break;}
			if (p1sel.x>3) {p1sel.x=temp.y;} //reset selector to own panel
		}
		return;
	}

	if (p1sel.y==1)
	{
		player_ctl_mode[0] = 1 - player_ctl_mode[0];
		show_joymode(yelmode_ent, 0);
		return;
	}

	if (p1sel.y==2)
	{
		db_player=p1sel.x;
		dbselect_model_inc();
	}
}

function player_pl1ready()
{
	var index;
	index = player_ctl_type[0] * 5;
	player_ready|=1;
	pl1left_ent.visible=0;
	pl1right_ent.visible=0;
	unset_plkeys(index);
	show_ready(yelbutton_ent);
	key_set(player_keys[index + k_fire], null);
	ctl_listener[0] = 0;
}

//Player2
function player_pl2up()
{
	p2sel.y=max(0,p2sel.y-1);
	if (p2sel.y == 1 && ((player_ctl_type[1] != ctl_joy1 && player_ctl_type[1] != ctl_joy2) || p2sel.x != 1))
	{
		p2sel.y -= 1;
	}
	pl2left_ent.z=playmenu_ver[p2sel.y];
	pl2right_ent.z=playmenu_ver[p2sel.y];
}

function player_pl2down()
{
	p2sel.y=min(2,p2sel.y+1);
	if (p2sel.y == 1 && ((player_ctl_type[1] != ctl_joy1 && player_ctl_type[1] != ctl_joy2) || p2sel.x != 1))
	{
		p2sel.y += 1;
	}
	pl2left_ent.z=playmenu_ver[p2sel.y];
	pl2right_ent.z=playmenu_ver[p2sel.y];
}

function player_pl2left()
{
	if (p2sel.y==0)
	{
		temp.y=p2sel.x;
		p2sel.x=max(0,p2sel.x-1);
		while(1)
		{
			temp=1<<p2sel.x;
			if ((player_active&temp)==temp && p2sel.x!=1) {p2sel.x-=1;}
			else {break;}
			if (p2sel.x<0) {p2sel.x=temp.y;} //reset selector to own panel
		}
		return;
	}

	if (p2sel.y==1)
	{
		player_ctl_mode[1] = 1 - player_ctl_mode[1];
		show_joymode(redmode_ent, 0);
		return;
	}

	if (p2sel.y==2)
	{
		db_player=p2sel.x;
		dbselect_model_dec();
		return;
	}
}

function player_pl2right()
{
	if (p2sel.y==0)
	{
		temp.y=p2sel.x;
		p2sel.x=min(3,p2sel.x+1);
		while(1)
		{
			temp=1<<p2sel.x;
			if ((player_active&temp)==temp && p2sel.x!=1) {p2sel.x+=1;}
			else {break;}
			if (p2sel.x>3) {p2sel.x=temp.y;} //reset selector to own panel
		}
		return;
	}

	if (p2sel.y==1)
	{
		player_ctl_mode[1] = 1 - player_ctl_mode[1];
		show_joymode(redmode_ent, 0);
		return;
	}

	if (p2sel.y==2)
	{
		db_player=p2sel.x;
		dbselect_model_inc();
	}
}

function player_pl2ready()
{
	var index;
	index = player_ctl_type[1] * 5;
	player_ready|=2;
	pl2left_ent.visible=0;
	pl2right_ent.visible=0;
	unset_plkeys(index);
	show_ready(redbutton_ent);
	key_set(player_keys[index + k_fire], null);
	ctl_listener[1] = 0;
}

//Player3
function player_pl3up()
{
	p3sel.y=max(0,p3sel.y-1);
	if (p3sel.y == 1 && ((player_ctl_type[2] != ctl_joy1 && player_ctl_type[2] != ctl_joy2) || p3sel.x != 2))
	{
		p3sel.y -= 1;
	}
	pl3left_ent.z=playmenu_ver[p3sel.y];
	pl3right_ent.z=playmenu_ver[p3sel.y];
}

function player_pl3down()
{
	p3sel.y=min(2,p3sel.y+1);
	if (p3sel.y == 1 && ((player_ctl_type[2] != ctl_joy1 && player_ctl_type[2] != ctl_joy2) || p3sel.x != 2))
	{
		p3sel.y += 1;
	}
	pl3left_ent.z=playmenu_ver[p3sel.y];
	pl3right_ent.z=playmenu_ver[p3sel.y];
}

function player_pl3left()
{
	if (p3sel.y==0)
	{
		temp.y=p3sel.x;
		p3sel.x=max(0,p3sel.x-1);
		while(1)
		{
			temp=1<<p3sel.x;
			if ((player_active&temp)==temp && p3sel.x!=2) {p3sel.x-=1;}
			else {break;}
			if (p3sel.x<0) {p3sel.x=temp.y;} //reset selector to last panel
		}
		return;
	}

	if (p3sel.y==1)
	{
		player_ctl_mode[2] = 1 - player_ctl_mode[2];
		show_joymode(blumode_ent, 0);
		return;
	}

	if (p3sel.y==2)
	{
		db_player=p3sel.x;
		dbselect_model_dec();
		return;
	}
}

function player_pl3right()
{
	if (p3sel.y==0)
	{
		temp.y=p3sel.x;
		p3sel.x=min(3,p3sel.x+1);
		while(1)
		{
			temp=1<<p3sel.x;
			if ((player_active&temp)==temp && p3sel.x!=2) {p3sel.x+=1;}
			else {break;}
			if (p3sel.x>3) {p3sel.x=temp.y;} //reset selector to last panel
		}
		return;
	}

	if (p3sel.y==1)
	{
		player_ctl_mode[2] = 1 - player_ctl_mode[2];
		show_joymode(blumode_ent, 0);
		return;
	}

	if (p3sel.y==2)
	{
		db_player=p3sel.x;
		dbselect_model_inc();
	}
}

function player_pl3ready()
{
	var index;
	index = player_ctl_type[2] * 5;
	player_ready|=4;
	pl3left_ent.visible=0;
	pl3right_ent.visible=0;
	unset_plkeys(index);
	show_ready(blubutton_ent);
	key_set(player_keys[index + k_fire], null);
	ctl_listener[2] = 0;
}

//Player4
function player_pl4up()
{
	p4sel.y=max(0,p4sel.y-1);
	if (p4sel.y == 1 && ((player_ctl_type[3] != ctl_joy1 && player_ctl_type[3] != ctl_joy2) || p4sel.x != 3))
	{
		p4sel.y -= 1;
	}
	pl4left_ent.z=playmenu_ver[p4sel.y];
	pl4right_ent.z=playmenu_ver[p4sel.y];
}

function player_pl4down()
{
	p4sel.y=min(2,p4sel.y+1);
	if (p4sel.y == 1 && ((player_ctl_type[3] != ctl_joy1 && player_ctl_type[3] != ctl_joy2) || p4sel.x != 3))
	{
		p4sel.y += 1;
	}
	pl4left_ent.z=playmenu_ver[p4sel.y];
	pl4right_ent.z=playmenu_ver[p4sel.y];
}

function player_pl4left()
{
	if (p4sel.y==0)
	{
		temp.y=p4sel.x;
		p4sel.x=max(0,p4sel.x-1);
		while(1)
		{
			temp=1<<p4sel.x;
			if ((player_active&temp)==temp && p4sel.x!=3) {p4sel.x-=1;}
			else {break;}
			if (p4sel.x<0) {p4sel.x=temp.y;} //reset selector to last panel
		}
		return;
	}

	if (p4sel.y==1)
	{
		player_ctl_mode[3] = 1 - player_ctl_mode[3];
		show_joymode(grnmode_ent, 0);
		return;
	}

	if (p4sel.y==2)
	{
		db_player=p4sel.x;
		dbselect_model_dec();
		return;
	}
}

function player_pl4right()
{
	if (p4sel.y==0)
	{
		temp.y=p4sel.x;
		p4sel.x=min(3,p4sel.x+1);
		while(1)
		{
			temp=1<<p4sel.x;
			if ((player_active&temp)==temp && p4sel.x!=3) {p4sel.x+=1;}
			else {break;}
			if (p4sel.x>3) {p4sel.x=temp.y;} //reset selector to own panel
		}
		return;
	}

	if (p4sel.y==1)
	{
		player_ctl_mode[3] = 1 - player_ctl_mode[3];
		show_joymode(grnmode_ent, 0);
		return;
	}

	if (p4sel.y==2)
	{
		db_player=p4sel.x;
		dbselect_model_inc();
	}
}

function player_pl4ready()
{
	var index;
	index = player_ctl_type[3] * 5;
	player_ready|=8;
	pl4left_ent.visible=0;
	pl4right_ent.visible=0;
	unset_plkeys(index);
	show_ready(grnbutton_ent);
	key_set(player_keys[index + k_fire], null);
	ctl_listener[3] = 0;
}

//////////Activate player selection//////////
function set_playerfuncs(pl)
{
	if (pl == 0)
	{
		player_up = player_pl1up;
		player_down = player_pl1down;
		player_left = player_pl1left;
		player_right = player_pl1right;
		player_fire = player_pl1ready;
		return;
	}

	if (pl == 1)
	{
		player_up = player_pl2up;
		player_down = player_pl2down;
		player_left = player_pl2left;
		player_right = player_pl2right;
		player_fire = player_pl2ready;
		return;
	}

	if (pl == 2)
	{
		player_up = player_pl3up;
		player_down = player_pl3down;
		player_left = player_pl3left;
		player_right = player_pl3right;
		player_fire = player_pl3ready;
		return;
	}

	if (pl == 3)
	{
		player_up = player_pl4up;
		player_down = player_pl4down;
		player_left = player_pl4left;
		player_right = player_pl4right;
		player_fire = player_pl4ready;
		return;
	}

}

function joy1_listener(pl)
{
	while (ctl_listener[pl] == 1)
	{
		wait (1);
	 	set_playerfuncs(pl);

		if (joy_raw.x < -50)
		{
			player_left();
			while (joy_raw.x < -50) {wait(1);}
			continue;
		}

		if (joy_raw.x > 50)
		{
			player_right();
			while (joy_raw.x > 50) {wait(1);}
			continue;
		}

		if (joy_raw.y < -50)
		{
			player_up();
			while (joy_raw.y < -50) {wait(1);}
			continue;
		}

		if (joy_raw.y > 50)
		{
			player_down();
			while (joy_raw.y > 50) {wait(1);}
			continue;
		}
	}
}

function joy2_listener(pl)
{
	while (ctl_listener[pl] == 1)
	{
		wait (1);
	 	set_playerfuncs(pl);

		if (joy2_raw.x < -50)
		{
			player_left();
			while (joy2_raw.x < -50) {wait(1);}
			continue;
		}

		if (joy2_raw.x > 50)
		{
			player_right();
			while (joy2_raw.x > 50) {wait(1);}
			continue;
		}

		if (joy2_raw.y < -50)
		{
			player_up();
			while (joy2_raw.y < -50) {wait(1);}
			continue;
		}

		if (joy2_raw.y > 50)
		{
			player_down();
			while (joy2_raw.y > 50) {wait(1);}
			continue;
		}
	}
}
define mouse_fac, 0.2;
define mouse_sleep, 0.2;
function mouse_listener(pl)
{
	while (ctl_listener[pl] == 1)
	{
		wait (1);
	 	set_playerfuncs(pl);

		if (mouse_force.x < -mouse_fac)
		{
			player_left();
			sleep(mouse_sleep);
			continue;
		}

		if (mouse_force.x > mouse_fac)
		{
			player_right();
			sleep(mouse_sleep);
			continue;
		}

		if (mouse_force.y > mouse_fac)
		{
			player_up();
			sleep(mouse_sleep);
			continue;
		}

		if (mouse_force.y < -mouse_fac)
		{
			player_down();
			sleep(mouse_sleep);
			continue;
		}
	}
}

function activation_set_ctl(pl)
{
	var index;
	index = player_ctl_type[pl] * 5;
	ctl_listener[pl] = 1;

	set_playerfuncs(pl);
	if (player_ctl_type[pl] == ctl_key1 || player_ctl_type[pl] == ctl_key2)
	{
		key_set(player_keys[index + k_up], player_up);
		key_set(player_keys[index + k_down], player_down);
		key_set(player_keys[index + k_left], player_left);
		key_set(player_keys[index + k_right], player_right);
	}

	if (player_ctl_type[pl] == ctl_joy1)
	{
		joy1_listener(pl);
	}

	if (player_ctl_type[pl] == ctl_joy2)
	{
		joy2_listener(pl);
	}

	if (player_ctl_type[pl] == ctl_mouse)
	{
		mouse_listener(pl);
	}
	key_set(player_keys[index + k_fire], player_fire);
}

function activate_player1()
{
	var index;
	index = player_ctl_type[0] * 5;
	player_active|=1;
	yelbutton_ent.visible=0;
	show_assigned_control(yelsel_ent, 0);
	if (player_ctl_type[0] == ctl_joy1 || player_ctl_type[0] == ctl_joy2)
	{
		show_joymode(yelmode_ent, 0);
	}
	p1sel.x=0;
	p1sel.y=0;
	pl1left_ent.z=playmenu_ver[p1sel.y];
	pl1right_ent.z=playmenu_ver[p1sel.y];
	show_pl1arrows();
	check_plarrows();
	activation_set_ctl(0);
}

function activate_player2()
{
	var index;
	index = player_ctl_type[1] * 5;
	player_active|=2;
	redbutton_ent.visible=0;
	show_assigned_control(redsel_ent, 1);
	if (player_ctl_type[1] == ctl_joy1 || player_ctl_type[1] == ctl_joy2)
	{
		show_joymode(redmode_ent, 1);
	}
	p2sel.x=1;
	p2sel.y=0;
	pl2left_ent.z=playmenu_ver[p2sel.y];
	pl2right_ent.z=playmenu_ver[p2sel.y];
	show_pl2arrows();
	check_plarrows();
	activation_set_ctl(1);
}

function activate_player3()
{
	var index;
	index = player_ctl_type[2] * 5;
	player_active|=4;
	blubutton_ent.visible=0;
	show_assigned_control(blusel_ent, 2);
	if (player_ctl_type[2] == ctl_joy1 || player_ctl_type[2] == ctl_joy2)
	{
		show_joymode(blumode_ent, 2);
	}
	p3sel.x=2;
	p3sel.y=0;
	pl3left_ent.z=playmenu_ver[p3sel.y];
	pl3right_ent.z=playmenu_ver[p3sel.y];
	show_pl3arrows();
	check_plarrows();
	activation_set_ctl(2);
}

function activate_player4()
{
	var index;
	index  = player_ctl_type[3] * 5;
	player_active|=8;
	grnbutton_ent.visible=0;
	show_assigned_control(grnsel_ent, 3);
	if (player_ctl_type[3] == ctl_joy1 || player_ctl_type[3] == ctl_joy2)
	{
		show_joymode(grnmode_ent, 3);
	}
	p4sel.x=3;
	p4sel.y=0;
	pl4left_ent.z=playmenu_ver[p4sel.y];
	pl4right_ent.z=playmenu_ver[p4sel.y];
	show_pl4arrows();
	check_plarrows();
	activation_set_ctl(3);
}

function activate_playerkeys()
{
	var index;
	ctl_listener[0] = 0;
	ctl_listener[1] = 0;
	ctl_listener[2] = 0;
	ctl_listener[3] = 0;
	if((player_active&1)==1){activate_player1();}
	else
	{
		index  = player_ctl_type[0] * 5;
		key_set(player_keys[index + k_fire], activate_player1);
	}

	if((player_active&2)==2){activate_player2();}
	else
	{
		index  = player_ctl_type[1] * 5;
		key_set(player_keys[index + k_fire], activate_player2);
	}

	if((player_active&4)==4){activate_player3();}
	else
	{
		index  = player_ctl_type[2] * 5;
		key_set(player_keys[index + k_fire], activate_player3);
	}

	if((player_active&8)==8){activate_player4();}
	else
	{
		index  = player_ctl_type[3] * 5;
		key_set(player_keys[index + k_fire], activate_player4);
	}
}

function select_player()
{
	var index;
	if (yelpanel_ent.visible==0)
	{
		wait (1);
		player_ready=0;
		ent_morph(controls_ent,"ctrlmen1.tga");
		show_header("playsel.pcx");
		show_controls(controls_ent);
		show_playerpanels();
		activate_playerkeys();
		on_enter=select_player_done;
		on_esc=cancel_player;
	}
	else
	{
		on_cur = null;
		on_cul = null;
		on_enter = dummy;
		on_esc = dummy;

		index  = player_ctl_type[0] * 5;
		key_set(player_keys[index + k_fire], null);

		index  = player_ctl_type[1] * 5;
		key_set(player_keys[index + k_fire], null);

		index  = player_ctl_type[2] * 5;
		key_set(player_keys[index + k_fire], null);

		index  = player_ctl_type[3] * 5;
		key_set(player_keys[index + k_fire], null);

		hide_header();
		hide_controls(controls_ent);
		hide_playerpanels();
	}
}

function cancel_level()
{
		snd_play (cancel_snd, 100, 0);
		ON_CUR = NULL;
		ON_CUL = NULL;
		ON_ENTER = dummy;
		on_esc = dummy;
		hide_header();
		hide_controls(controls_ent);
		while (level_ent.TILT>-90)
		{
				wait (1);
				level_ent.PAN=entpan+15*SIN(7*timer);
				level_ent.TILT-=9*TIME;
//				menuarrow_right_ent.Y+=10*TIME;
//				menuarrow_left_ent.Y-=10*TIME;
				menu1_ent.y -= 10 * time;
				menu3_ent.Y += 10 * time;
				menu1_ent.alpha = max (menu1_ent.alpha - 5 * time, 0);
				menu3_ent.alpha = menu1_ent.alpha;
		}
		level_ent.TILT=-90;
		level_ent.VISIBLE=0;
		ent_purge(level_ent);
/*
		menuarrow_right_ent.visible=0;
		ent_purge(menuarrow_right_ent);
		menuarrow_left_ent.visible=0;
		ent_purge(menuarrow_left_ent);
*/
		menu1_ent.visible = off;
		ent_purge(menu1_ent);
		menu3_ent.visible = off;
		ent_purge(menu3_ent);
		while (header_ent.visible==1)
		{
				wait (1);
		}
		select_player();
}

function select_level()
{
		if (level_ent.visible==0)
		{
			wait (1);
//				ent_morph(stageselect_ent,"stagesel.pcx");
			ent_morph(controls_ent,"ctrlmen2.tga");

//				menuarrow_right_ent.visible=1;
//				menuarrow_left_ent.visible=1;
			show_header("stagesel.pcx");
			show_controls(controls_ent);
			if (demoversion == 1)
			{
				levelnr = DEFdemolvl1;
	        }
			else
			{
				levelnr = 1;
			}
			set_level();
			anim_level_ent();
			on_cur = select_level_right;
			on_cul = select_level_left;
			on_enter = run_level;
			on_esc = cancel_level;
		}
		else
		{

				on_cur = null;
				on_cul = null;
				on_enter = dummy;
				on_esc = dummy;
				menu1_ent.visible = off;
				menu3_ent.visible = off;
				ent_purge(menu1_ent);
				ent_purge(menu3_ent);
/*
				menuarrow_right_ent.visible=0;
				menuarrow_left_ent.visible=0;
				ent_purge(menuarrow_right_ent);
				ent_purge(menuarrow_left_ent);
*/
				level_ent.visible=0;
				hide_header();
				hide_controls(controls_ent);
				ent_purge(level_ent);
		}
}

var menucounter=0;

///////////////////////Player Select////////////////////

//////////states//////////
function show_state(ent)
{
	me=ent;
	if (my.visible==1) {return;}
	my.flare=1;
	my.alpha=50;
	my.visible=1;
}

function hide_state(ent)
{
	me=ent;
	if (my.visible!=1) {return;}
	while(my.alpha>0)
	{
		wait (1);
		my.alpha-=time+time+time;
	}
	my.alpha=0;
	my.visible=0;
	ent_purge(me);
}

function show_states()
{
//network not implemented yet --> sel_net.pcx
	if((player_active&1)==1) {show_assigned_control(yelsel_ent, 0);}
	else {ent_morph(yelsel_ent,"sel_cpu.pcx");}

	if((player_active&2)==2) {show_assigned_control(redsel_ent, 1);}
	else {ent_morph(redsel_ent,"sel_cpu.pcx");}

	if((player_active&4)==4) {show_assigned_control(blusel_ent, 2);}
	else {ent_morph(blusel_ent,"sel_cpu.pcx");}

	if((player_active&8)==8) {show_assigned_control(grnsel_ent, 3);}
	else {ent_morph(grnsel_ent,"sel_cpu.pcx");}

	wait (1);
	show_state(yelsel_ent);
	show_state(redsel_ent);
	show_state(blusel_ent);
	show_state(grnsel_ent);
}

function hide_states()
{
	hide_state(yelsel_ent);
	hide_state(redsel_ent);
	hide_state(blusel_ent);
	hide_state(grnsel_ent);
}

function show_assigned_control(tempent, pl)
{
	me = tempent;

	str_cpy(modeltemp_str, "sel_pl");
	str_for_num (modelnr_str, player_ctl_type[pl]);
	str_cat (modeltemp_str, modelnr_str);
	str_cat (modeltemp_str, ".pcx");
	ent_purge(me);
	ent_morph(me, modeltemp_str);
}

function show_joymode(tempent, pl)
{
	me = tempent;

	my.flare = on;
	my.alpha = 50;
	my.visible = on;
	str_cpy(modeltemp_str, "sel_joy");
	str_for_num (modelnr_str, player_ctl_mode[pl]);
	str_cat (modeltemp_str, modelnr_str);
	str_cat (modeltemp_str, ".pcx");
	ent_purge(me);
	ent_morph(me, modeltemp_str);
}

function hide_joymode(tempent)
{
	me = tempent;

	if (my.visible == off) {return;}
	while(my.alpha > 0)
	{
		wait (1);
		my.alpha -= time + time + time;
	}
	my.alpha = 0;
	my.visible = off;
	ent_purge(me);
}

function show_joymodes()
{
	if((player_active&1)==1 && (player_ctl_type[0] == ctl_joy1 || player_ctl_type[0] == ctl_joy2))
	{show_joymode(yelmode_ent, 0);}
	else {hide_joymode(yelmode_ent);}

	if((player_active&2)==2 && (player_ctl_type[1] == ctl_joy1 || player_ctl_type[1] == ctl_joy2))
	{show_joymode(redmode_ent, 1);}
	else {hide_joymode(redmode_ent);}

	if((player_active&4)==4 && (player_ctl_type[2] == ctl_joy1 || player_ctl_type[2] == ctl_joy2))
	{show_joymode(blumode_ent, 2);}
	else {hide_joymode(blumode_ent);}

	if((player_active&8)==8 && (player_ctl_type[3] == ctl_joy1 || player_ctl_type[3] == ctl_joy2))
	{show_joymode(grnmode_ent, 3);}
	else {hide_joymode(grnmode_ent);}

}

function hide_joymodes()
{
	hide_joymode(yelmode_ent);
	hide_joymode(redmode_ent);
	hide_joymode(blumode_ent);
	hide_joymode(grnmode_ent);
}

//////////buttons//////////

function show_button(ent)
{
	me=ent;
	if (my.visible==1) {return;}
	ent_morph(me,"firebtn.pcx");
	my.z=-150;
	my.alpha=50;
	my.visible=1;
	anim_ent(me);
}

function hide_button(ent)
{
	me = ent;
	if (my.visible == off) {return;}
	while(my.alpha > 0)
	{
		wait (1);
		my.alpha -= time + time + time;
	}
	my.alpha = off;
	my.visible = off;
	ent_purge(me);
}

function show_buttons()
{
	yelbutton_ent.y=225;
	redbutton_ent.y=75;
	blubutton_ent.y=-75;
	grnbutton_ent.y=-225;
	if((player_active&1)==0)
	{
		show_button(yelbutton_ent);
	}
	if((player_active&2)==0)
	{
		show_button(redbutton_ent);
	}
	if((player_active&4)==0)
	{
		show_button(blubutton_ent);
	}
	if((player_active&8)==0)
	{
		show_button(grnbutton_ent);
	}
}

function hide_buttons()
{
	hide_button(yelbutton_ent);
	hide_button(redbutton_ent);
	hide_button(blubutton_ent);
	hide_button(grnbutton_ent);
}

function show_ready(ent)
{
	me=ent;
	ent_purge(me);
	ent_morph(me,"sel_plok.pcx");
	my.alpha=50;
	my.visible=1;
	my.z=-110;
	my.y-=50;
}

function unset_plkeys(index)
{
	key_set(player_keys[index + k_up], null);
	key_set(player_keys[index + k_down], null);
	key_set(player_keys[index + k_left], null);
	key_set(player_keys[index + k_right], null);
}

//////////menu arrow markers//////////

function show_pl1arrows()
{
	pl1left_ent.alpha=50;
	pl1right_ent.alpha=50;
	pl1left_ent.visible=1;
	pl1right_ent.visible=1;
	while(pl1left_ent.visible==1)
	{
		pl1left_ent.Y=(playmenu_hor[p1sel.x]+60)+ABS(7*SIN(14*timer));
		pl1right_ent.Y=(playmenu_hor[p1sel.x]-60)-ABS(7*SIN(14*timer));
		wait(1);
	}
}

function hide_pl1arrows()
{
	var index;
	index  = player_ctl_type[0] * 5;
	while(pl1left_ent.alpha>0)
	{
		wait (1);
		pl1left_ent.alpha-=time+time+time;
		pl1right_ent.alpha-=time+time+time;
	}
	pl1left_ent.alpha=0;
	pl1right_ent.alpha=0;
	pl1left_ent.visible=0;
	pl1right_ent.visible=0;
	unset_plkeys(index);
}

function show_pl2arrows()
{
	pl2left_ent.alpha=50;
	pl2right_ent.alpha=50;
	pl2left_ent.visible=1;
	pl2right_ent.visible=1;
	while(pl2left_ent.visible==1)
	{
		pl2left_ent.Y=(playmenu_hor[p2sel.x]+60)+ABS(7*SIN(14*timer));
		pl2right_ent.Y=(playmenu_hor[p2sel.x]-60)-ABS(7*SIN(14*timer));
		wait(1);
	}
}

function hide_pl2arrows()
{
	var index;
	index  = player_ctl_type[1] * 5;
	while(pl2left_ent.alpha>0)
	{
		wait (1);
		pl2left_ent.alpha-=time+time+time;
		pl2right_ent.alpha-=time+time+time;
	}
	pl2left_ent.alpha=0;
	pl2right_ent.alpha=0;
	pl2left_ent.visible=0;
	pl2right_ent.visible=0;
	unset_plkeys(index);
}

function show_pl3arrows()
{
	pl3left_ent.alpha=50;
	pl3right_ent.alpha=50;
	pl3left_ent.visible=1;
	pl3right_ent.visible=1;
	while(pl3left_ent.visible==1)
	{
		pl3left_ent.Y=(playmenu_hor[p3sel.x]+60)+ABS(7*SIN(14*timer));
		pl3right_ent.Y=(playmenu_hor[p3sel.x]-60)-ABS(7*SIN(14*timer));
		wait(1);
	}
}

function hide_pl3arrows()
{
	var index;
	index  = player_ctl_type[2] * 5;
	while(pl3left_ent.alpha>0)
	{
		wait (1);
		pl3left_ent.alpha-=time+time+time;
		pl3right_ent.alpha-=time+time+time;
	}
	pl3left_ent.alpha=0;
	pl3right_ent.alpha=0;
	pl3left_ent.visible=0;
	pl3right_ent.visible=0;
	unset_plkeys(index);
}

function show_pl4arrows()
{
	pl4left_ent.alpha=50;
	pl4right_ent.alpha=50;
	pl4left_ent.visible=1;
	pl4right_ent.visible=1;
	while(pl4left_ent.visible==1)
	{
		pl4left_ent.Y=(playmenu_hor[p4sel.x]+60)+ABS(7*SIN(14*timer));
		pl4right_ent.Y=(playmenu_hor[p4sel.x]-60)-ABS(7*SIN(14*timer));
		wait(1);
	}
}

function hide_pl4arrows()
{
	var index;
	index  = player_ctl_type[3] * 5;
	while(pl4left_ent.alpha>0)
	{
		wait (1);
		pl4left_ent.alpha-=time+time+time;
		pl4right_ent.alpha-=time+time+time;
	}
	pl4left_ent.alpha=0;
	pl4right_ent.alpha=0;
	pl4left_ent.visible=0;
	pl4right_ent.visible=0;
	unset_plkeys(index);
}

function check_plarrows()
{
//move selection arrows back to start in case new player joined
	temp=1<<p1sel.x;
	if ((player_active&temp)==temp && p1sel.x!=0) {p1sel.x=0;}
	temp=1<<p2sel.x;
	if ((player_active&temp)==temp && p2sel.x!=1) {p2sel.x=1;}
	temp=1<<p3sel.x;
	if ((player_active&temp)==temp && p3sel.x!=2) {p3sel.x=2;}
	temp=1<<p4sel.x;
	if ((player_active&temp)==temp && p4sel.x!=3) {p4sel.x=3;}
}

function hide_playerarrows()
{
	hide_pl1arrows();
	hide_pl2arrows();
	hide_pl3arrows();
	hide_pl4arrows();
}

//////////Main Player selection show/hide routines//////////

function show_playerpanels()
{
	dbinit();
	show_buttons();
	show_states();
	show_joymodes();
	yelpanel_ent.y=225;
	grnpanel_ent.y=-225;
	redpanel_ent.z=0;
	blupanel_ent.z=0;
	yelpanel_ent.visible=1;
	redpanel_ent.visible=1;
	blupanel_ent.visible=1;
	grnpanel_ent.visible=1;
	yelplayer_ent.visible=1;
	redplayer_ent.visible=1;
	bluplayer_ent.visible=1;
	grnplayer_ent.visible=1;
	anim_panelwalk(yelplayer_ent);
	anim_panelwalk(redplayer_ent);
	anim_panelwalk(bluplayer_ent);
	anim_panelwalk(grnplayer_ent);
}

function hide_playerpanels()
{
	hide_yelpan();
	hide_redpan();
	hide_bluepan();
	hide_greenpan();
	hide_buttons();
	hide_joymodes();
	hide_states();
	fadeout_playerpanels(yelplayer_ent);
	fadeout_playerpanels(redplayer_ent);
	fadeout_playerpanels(bluplayer_ent);
	fadeout_playerpanels(grnplayer_ent);
}

//////////Main Player/Level selection screen animation//////////

action _menu_item
{
	my.passable = on;
	my.unlit = on;
	my.ambient = 100;
	my.typ = int(random(17) + 10);

	/* create box */
	if (my.typ == 10)
	{
		my.frame = 1;
	}
	/* any other item */
	if (my.typ > 10)
	{
		init_item_stats(me);
	}
	my.z = your.z + your.min_z;
	my.forcez = 18 + random(10);
	while (my.z < your.z + your.max_z)
	{
		temp = min(time * 0.55,1);
		my.speedz += (time * my.forcez) - (temp * my.speedz);
		speed.x = 0;
		speed.y = 0;
		speed.z = my.speedz * time;
		my.pan = 180 * sin(3 * timer);
		my.tilt = 50 * sin(10 * timer);
		my.roll = 10 * sin(5 * timer);
		ent_move(nullvector, speed);
		wait (1);
	}
	wait (1);
	ent_remove(me);
}

action _anim_menu
{
	menucounter = 0;
	camera.fog = 55;
	fog_color = 4;
	my.ambient = 100;
	my.uvspeed = on;
	my.speed_v = 18;
	while(1)
	{
		camera.x = 70 * sin(3 * timer);
		camera.y = 70 * cos(3 * timer);
		camera.z = 0;
		camera.pan += time * 6 * abs(sin(2 * timer));
		camera.tilt = -90 + 15 * cos(3 * timer);
		menucounter += time;
		if (menucounter > 8)
		{
			temp.x = 110 * cos(7 * timer);
			temp.y = 110 * sin(6 * timer);
			temp.z = my.z + my.min_z;
			ent_create ("box.mdl", temp, _menu_item);
			menucounter -= 8;
		}
	wait (1);
	}
}

action _menu_particle
{
	my.invisible = on;
	my.passable = on;
	while(1)
	{
		my.partTimer += time;
		while (my.partTimer >= 1)
		{
			effect(_menu_particle_event, 3, my.x, nullvector);
			my.partTimer -= 1;
		}
		wait (1);
	}
}




//////////outdated
/*
function set_clientintrocam()
{
		client_music=-10;
		wait(1);
		camera.z=-500; //to prevent graphic bugs
		while (client_music==-10)
		{
				wait(1);
		}
		vec_set (camera.x,campos);
		camera.pan=camang.pan;
		camera.tilt=camang.tilt;
		camera.roll=camang.roll;

		init_music(client_music);
}
*/