///////////////////////////////////////////////////////////////////////////////////
// ~ 4 Little Warriors ~ OptMenu WDL
//
// modified by Firoball  03/15/2007 (created 01/17/2004)
///////////////////////////////////////////////////////////////////////////////////

//////////Prototypes
function show_options();
function show_quickoptions();
function hide_option_ents();
function hide_options();
function anim_optmenu();
function move_optmenulight();
function load_optpanel(ent, base_str, index);
function Xoptmenulight_event();
function Xoptmenupart_event();
function part_optmenufade();

function show_optmenu();
function exec_optmenu();
function optmenu_up();
function optmenu_down();

function show_gameopt();
function hide_gameopt();
function gameopt_exec();
function gameopt_left();
function gameopt_right();
function update_gameopt();

function show_keyopt();
function hide_keyopt();
function keyopt_plr_done();
function keyopt_set_keys();
function keyopt_exec();
function keyopt_left();
function keyopt_right();
function update_keyopt();

function show_vidopt();
function hide_vidopt();
function vidopt_exec();
function vidopt_left();
function vidopt_right();
function update_vidopt();

function show_audopt();
function hide_audopt();
function audopt_exec();
function audopt_left();
function audopt_right();
function update_audopt();

//////////Definitions
define tvec1, skill10;
define tvec2, skill13;
define tvec3, skill16;
define tvec4, skill19;
define tvec5, skill22;
define tvec6, skill25;

/////////Variables
var optent[6]; //store view entity pointers

//////////Function Pointers
function* m_left;
function* m_right;

//////////Menu initialization
function show_options()
{
	m_switch = switch_menu;//reused from mainmenu.wdl
	m_exec = exec_optmenu;
	m_cancel = hide_options;

	snd_play (accept_snd, 100, 0);
	hide_menu();
	set_menucam(1);
	show_header("menu2.pcx");
	anim_optmenu();
	anim_menubg();

	str_cpy (menubase_str, "option");
	menusel = 1;
	menusel.z = 5;
	menu2_ent.flare = on;
	swap_menu(menu2_ent);

	menu1_ent.visible = on;
	menu2_ent.visible = on;
	menu3_ent.visible = on;

	anim_menu();
	set_menu_keys();
}

function show_quickoptions()
{
	stop_optent(ptr_for_handle(optent[menusel-1]));
	temp = 0;
	while (temp < optent.length)
	{
		optent[temp] = 0;
		temp += 1;
	}
	m_switch = switch_menu;//reused from mainmenu.wdl
	m_exec = exec_optmenu;
	m_cancel = hide_options;

	str_cpy (menubase_str, "option");
	menusel = menusel.y;	//retrieve old menu position
	menusel.z = 5;
	menu2_ent.flare = on;
	swap_menu(menu2_ent);

	menu1_ent.visible = on;
	menu2_ent.visible = on;
	menu3_ent.visible = on;

	anim_menu();
	set_menu_keys();
}

function hide_option_ents()
{
	unset_menu_keys();
	menu1_ent.visible = off;
	menu2_ent.visible = off;
	menu3_ent.visible = off;
}

function hide_options()
{
	snd_play (cancel_snd, 100, 0);
	hide_option_ents();
	show_quickmenu();
	menubg_ent.visible = off;
	header_ent.visible = off;
	game_save("config", 0, SV_INFO);
}

//////////Menu Controlling

function show_optmenu()
{
	snd_play (accept_snd, 100, 0);
	menusel.y = menusel; //store old menu position
	menusel = 1;
	hide_option_ents();
	sleep (1);
	tempent = ptr_for_handle(optent[menusel-1]);
	anim_optent(tempent);

	on_esc = m_cancel;
	on_enter = m_exec;
	on_cul = m_left;
	on_cur = m_right;
	on_cuu = optmenu_up;
	on_cud = optmenu_down;
}

function exec_optmenu()
{
//	unset_menu_keys();
	if (menusel == 1)
	{
		show_gameopt();
		return;
	}
	if (menusel == 2)
	{
		show_keyopt();
		return;
	}
	if (menusel == 3)
	{
		show_vidopt();
		return;
	}
	if (menusel == 4)
	{
		show_audopt();
		return;
	}
	if (menusel == 5)
	{
		hide_options();
		return;
	}
}

function optmenu_up()
{
	snd_play (updown_snd, 100, 0);
	stop_optent(ptr_for_handle(optent[menusel-1]));
	menusel -= 1;
	if (menusel < 1)
	{
		menusel = menusel.z;
	}
	anim_optent(ptr_for_handle(optent[menusel-1]));
}

function optmenu_down()
{
	snd_play (updown_snd, 100, 0);
	stop_optent(ptr_for_handle(optent[menusel-1]));
	menusel += 1;
	if (menusel > menusel.z)
	{
		menusel = 1;
	}
	anim_optent(ptr_for_handle(optent[menusel-1]));
}

//////////Game Options
function show_gameopt()
{
	snd_play (accept_snd, 100, 0);
	m_cancel = hide_gameopt;
	m_exec = gameopt_exec;
	m_left = gameopt_left;
	m_right = gameopt_right;
	menusel.z = 6;
	show_optmenu();
	reset_instents(); //reused from instruction menu

	inst1_ent.x = 700;
	inst1_ent.y = 0;
	inst1_ent.z = 150;

	inst2_ent.x = 700;
	inst2_ent.y = 0;
	inst2_ent.z = 70;

	inst3_ent.x = 700;
	inst3_ent.y = 0;
	inst3_ent.z = -10;

	inst4_ent.x = 700;
	inst4_ent.y = 0;
	inst4_ent.z = -180;

	inst5_ent.x = 700;
	inst5_ent.y = 0;
	inst5_ent.z = -230;

	inst6_ent.x = 700;
	inst6_ent.y = 0;
	inst6_ent.z = 110;

	inst7_ent.x = 700;
	inst7_ent.y = 25;
	inst7_ent.z = 30;

	inst8_ent.x = 700;
	inst8_ent.y = 0;
	inst8_ent.z = -50;

	inst9_ent.x = 700;
	inst9_ent.y = -15;
	inst9_ent.z = 27;

	inst10_ent.x = 700;
	inst10_ent.y = 0;
	inst10_ent.z = -90;

	inst11_ent.x = 700;
	inst11_ent.y = 0;
	inst11_ent.z = -130;

	ent_morph(inst1_ent,"opt_dif.pcx");
	ent_morph(inst2_ent,"opt_time.pcx");
	ent_morph(inst3_ent,"opt_game.pcx");
	ent_morph(inst4_ent,"opt_default.pcx");
	ent_morph(inst5_ent,"opt_back.pcx");
	ent_morph(inst9_ent,"opt_min.pcx");
	ent_morph(inst10_ent,"opt_speed.pcx");

	optent[0] = handle(inst1_ent);
	optent[1] = handle(inst2_ent);
	optent[2] = handle(inst3_ent);
	optent[3] = handle(inst10_ent);
	optent[4] = handle(inst4_ent);
	optent[5] = handle(inst5_ent);

	update_gameopt();
	temp  = 0;
	while (temp < menusel.z)
	{
		fadein_flarepanel(ptr_for_handle(optent[temp]));
		temp += 1;
	}
	fadein_flarepanel(inst6_ent);
	fadein_flarepanel(inst7_ent);
	fadein_flarepanel(inst8_ent);
	fadein_flarepanel(inst9_ent);
	fadein_flarepanel(inst11_ent);
}

function hide_gameopt()
{
	snd_play (cancel_snd, 100, 0);
	unset_menu_keys();
	fadeout_flarepanel(inst1_ent);
	fadeout_flarepanel(inst2_ent);
	fadeout_flarepanel(inst3_ent);
	fadeout_flarepanel(inst4_ent);
	fadeout_flarepanel(inst5_ent);
	fadeout_flarepanel(inst6_ent);
	fadeout_flarepanel(inst7_ent);
	fadeout_flarepanel(inst8_ent);
	fadeout_flarepanel(inst9_ent);
	fadeout_flarepanel(inst10_ent);
	fadeout_flarepanel(inst11_ent);
	while(inst1_ent.visible == on)
	{
		wait(1);
	}
	show_quickoptions();
}

function gameopt_exec()
{
	//1 2 3 4 no functionality
	if (menusel == 5)
	{
		snd_play (accept_snd, 100, 0);
		cpu_level = DEFcpu_level;
		time_limit = DEFtime_limit;
		game_limit = DEFgame_limit;
		game_speed = DEFgame_speed;
		update_gameopt();
	}

	if (menusel ==  6)
	{
		hide_gameopt();
	}
}

function gameopt_left()
{
	//difficulty
	if (menusel == 1)
	{
		snd_play (leftright_snd, 100, -100);
		cpu_level -= 1;
		if (cpu_level < 1)
		{
			cpu_level = 3;
		}
	}

	//Time Limit
	if (menusel == 2)
	{
		snd_play (leftright_snd, 100, -100);
		time_limit -= 1;
		if (time_limit < 1)
		{
			time_limit = 5;
		}
	}

	//Game Limit
	if (menusel == 3)
	{
		snd_play (leftright_snd, 100, -100);
		game_limit -= 2;
		if (game_limit < 1)
		{
			game_limit = 5;
		}
	}

	//Game Speed
	if (menusel == 4)
	{
		snd_play (leftright_snd, 100, -100);
		game_speed -= 1;
		if (game_speed < 1)
		{
			game_speed = 3;
		}
	}
	update_gameopt();
}

function gameopt_right()
{
	//difficulty
	if (menusel == 1)
	{
		snd_play (leftright_snd, 100, 100);
		cpu_level += 1;
		if (cpu_level > 3)
		{
			cpu_level = 1;
		}
	}

	//Time Limit
	if (menusel == 2)
	{
		snd_play (leftright_snd, 100, 100);
		time_limit += 1;
		if (time_limit > 5)
		{
			time_limit = 1;
		}
	}

	//Game Limit
	if (menusel == 3)
	{
		snd_play (leftright_snd, 100, 100);
		game_limit += 2;
		if (game_limit > 5)
		{
			game_limit = 1;
		}
	}

	//Game Speed
	if (menusel == 4)
	{
		snd_play (leftright_snd, 100, -100);
		game_speed += 1;
		if (game_speed > 3)
		{
			game_speed = 1;
		}
	}
	update_gameopt();
}

function update_gameopt()
{
	load_optpanel(inst6_ent, "num", cpu_level);
	load_optpanel(inst7_ent, "num", time_limit);
	load_optpanel(inst8_ent, "num", game_limit);
	load_optpanel(inst11_ent, "speed", game_speed);
}

//////////Key Layout
var_nsave cur_plr;			//current_selected player
var_nsave cur_layout;		//current selected layout
var_nsave cur_plr_ctl;		//current selected player key layout

function show_keyopt()
{
	snd_play (accept_snd, 100, 0);
	m_cancel = hide_keyopt;
	m_exec = keyopt_exec;
	m_left = keyopt_left;
	m_right = keyopt_right;
	menusel.z = 4;
	cur_plr = 0;
	cur_layout = 0;
	cur_plr_ctl = 0;
//	init_keymap();		//control.wdl
	show_optmenu();
	reset_instents(); //reused from instruction menu

	inst1_ent.x = 700;
	inst1_ent.y = 0;
	inst1_ent.z = 150;

	inst2_ent.x = 700;
	inst2_ent.y = 0;
	inst2_ent.z = 50;

	inst3_ent.x = 700;
	inst3_ent.y = 0;
	inst3_ent.z = -150;

	inst4_ent.x = 700;
	inst4_ent.y = 0;
	inst4_ent.z = -200;

	inst5_ent.x = 700;
	inst5_ent.y = -35;
	inst5_ent.z = 100;

	inst6_ent.x = 700;
	inst6_ent.y = 35;
	inst6_ent.z = 100;

	ent_morph(inst1_ent,"opt_player.pcx");
	ent_morph(inst2_ent,"opt_layout.pcx");
	ent_morph(inst3_ent,"opt_default.pcx");
	ent_morph(inst4_ent,"opt_back.pcx");

	optent[0] = handle(inst1_ent);
	optent[1] = handle(inst2_ent);
	optent[2] = handle(inst3_ent);
	optent[3] = handle(inst4_ent);
	optent[4] = handle(inst5_ent);

	wait (1);	//required for database select
	update_keyopt();
	hide_keylayout();	//control.wdl
	temp  = 0;
	while (temp < menusel.z + 1)
	{
		fadein_flarepanel(ptr_for_handle(optent[temp]));
		temp += 1;
	}
	fadein_flarepanel(inst6_ent);
	sleep (1);
	show_keylayout(cur_layout);	//control.wdl
}

function hide_keyopt()
{
	snd_play (cancel_snd, 100, 0);
	unset_menu_keys();
	fadeout_flarepanel(inst1_ent);
	fadeout_flarepanel(inst2_ent);
	fadeout_flarepanel(inst3_ent);
	fadeout_flarepanel(inst4_ent);
	fadeout_flarepanel(inst5_ent);
	fadeout_flarepanel(inst6_ent);
	hide_keylayout();
	while(inst1_ent.visible == on)
	{
		wait(1);
	}
	show_quickoptions();
}

function keyopt_plr_done()
{
	snd_play (accept_snd, 100, 0);
	stop_optent(ptr_for_handle(optent[menusel-1]));
	menusel = 1;
	anim_optent(ptr_for_handle(optent[menusel-1]));
	cur_plr_ctl = player_ctl_type[cur_plr];
	update_keyopt();

	on_esc = m_cancel;
	on_cuu = optmenu_up;
	on_cud = optmenu_down;
}

function keyopt_set_keys()
{
	on_esc = m_cancel;
	on_enter = m_exec;
	on_cul = m_left;
	on_cur = m_right;
	on_cuu = optmenu_up;
	on_cud = optmenu_down;
}

function keyopt_exec()
{
//assign player control - submenu (must be first here)
	if (menusel == 5)
	{
		player_ctl_type[cur_plr] = cur_plr_ctl;
		keyopt_plr_done();
		return;
	}

	if (menusel == 1)
	{
		snd_play (accept_snd, 100, 0);
		on_esc = keyopt_plr_done;
		on_cuu = null;
		on_cud = null;
		stop_optent(ptr_for_handle(optent[menusel-1]));
		menusel = 5;
		anim_optent(ptr_for_handle(optent[menusel-1]));
	}

	if (menusel == 2)
	{
		snd_play (accept_snd, 100, 0);
		unset_menu_keys();
		key_change (cur_layout);
	}

	if (menusel == 3)
	{
		snd_play (accept_snd, 100, 0);
		key_init();	//control.wdl
		show_keylayout(cur_layout);	//control.wdl
	}

	if (menusel == 4)
	{
		hide_keyopt();
	}

}

function keyopt_left()
{
	//player
	if (menusel == 1)
	{
		snd_play (leftright_snd, 100, -100);
		cur_plr -= 1;
		if (cur_plr < 0)
		{
			cur_plr = 3;
		}
		cur_plr_ctl = player_ctl_type[cur_plr];
	}

	//key layout
	if (menusel == 2)
	{
		snd_play (leftright_snd, 100, -100);
		cur_layout -= 1;
		if (cur_layout < 0)
		{
			cur_layout = 4;
		}
	}

	//player control
	if (menusel == 5)
	{
		snd_play (leftright_snd, 100, -100);
		cur_plr_ctl -= 1;
		if (cur_plr_ctl < 0)
		{
			cur_plr_ctl = 4;
		}
	}
	update_keyopt();
}

function keyopt_right()
{
	//player
	if (menusel == 1)
	{
		snd_play (leftright_snd, 100, 100);
		cur_plr += 1;
		if (cur_plr > 3)
		{
			cur_plr = 0;
		}
		cur_plr_ctl = player_ctl_type[cur_plr];
	}

	//key layout
	if (menusel == 2)
	{
		snd_play (leftright_snd, 100, 100);
		cur_layout += 1;
		if (cur_layout > 4)
		{
			cur_layout = 0;
		}
	}

	//player control
	if (menusel == 5)
	{
		snd_play (leftright_snd, 100, 100);
		cur_plr_ctl += 1;
		if (cur_plr_ctl > 4)
		{
			cur_plr_ctl = 0;
		}
	}
	update_keyopt();
}

function update_keyopt()
{
	load_optpanel(inst5_ent, "sel_pl", cur_plr_ctl);
	load_optpanel(inst6_ent, "opt_plr", cur_plr);
	show_keylayout(cur_layout);	//control.wdl
}

//////////Video Options
function show_vidopt()
{
	snd_play (accept_snd, 100, 0);
	m_cancel = hide_vidopt;
	m_exec = vidopt_exec;
	m_left = vidopt_left;
	m_right = vidopt_right;
	menusel.z = 5;
	show_optmenu();
	reset_instents(); //reused from instruction menu

	inst1_ent.x = 700;
	inst1_ent.y = 0;
	inst1_ent.z = 150;
	inst2_ent.x = 700;
	inst2_ent.y = 0;
	inst2_ent.z = 70;
	inst3_ent.x = 700;
	inst3_ent.y = 0;
	inst3_ent.z = -10;
	inst4_ent.x = 700;
	inst4_ent.y = 0;
	inst4_ent.z = -90;
	inst5_ent.x = 700;
	inst5_ent.y = 0;
	inst5_ent.z = -200;
	inst6_ent.x = 700;
	inst6_ent.y = 0;
	inst6_ent.z = 110;
	inst7_ent.x = 700;
	inst7_ent.y = 0;
	inst7_ent.z = 30;
	inst8_ent.x = 700;
	inst8_ent.y = 0;
	inst8_ent.z = -50;
	inst9_ent.x = 700;
	inst9_ent.y = 0;
	inst9_ent.z = -140;
	ent_morph(inst1_ent,"opt_res.pcx");
	ent_morph(inst2_ent,"opt_col.pcx");
	ent_morph(inst3_ent,"opt_shadow.pcx");
	ent_morph(inst4_ent,"opt_sfx.pcx");
	ent_morph(inst5_ent,"opt_back.pcx");

	optent[0] = handle(inst1_ent);
	optent[1] = handle(inst2_ent);
	optent[2] = handle(inst3_ent);
	optent[3] = handle(inst4_ent);
	optent[4] = handle(inst5_ent);

	update_vidopt();
	temp  = 0;
	while (temp < menusel.z)
	{
		fadein_flarepanel(ptr_for_handle(optent[temp]));
		temp += 1;
	}
	fadein_flarepanel(inst6_ent);
	fadein_flarepanel(inst7_ent);
	fadein_flarepanel(inst8_ent);
	fadein_flarepanel(inst9_ent);
}

function hide_vidopt()
{
	snd_play (cancel_snd, 100, 0);
	unset_menu_keys();
	fadeout_flarepanel(inst1_ent);
	fadeout_flarepanel(inst2_ent);
	fadeout_flarepanel(inst3_ent);
	fadeout_flarepanel(inst4_ent);
	fadeout_flarepanel(inst5_ent);
	fadeout_flarepanel(inst6_ent);
	fadeout_flarepanel(inst7_ent);
	fadeout_flarepanel(inst8_ent);
	fadeout_flarepanel(inst9_ent);
	while(inst1_ent.visible == on)
	{
		wait(1);
	}
	//restore valid values
	vid_res = video_mode;
	vid_depth = video_depth;

	show_quickoptions();
}

function vidopt_exec()
{
	//3 4 no functionality
	if (menusel == 1)
	{
		snd_play (accept_snd, 100, 0);
		temp = video_mode;
		if (video_switch (vid_res, 0, 0) == 0)
		{
			vid_res = temp;
			video_switch (vid_res, 0, 0);
		}
		update_vidopt();
	}

	if (menusel == 2)
	{
		snd_play (accept_snd, 100, 0);
		temp = video_depth;
		if (video_switch (0, vid_depth, 0) == 0)
		{
			vid_depth = temp;
			video_switch (0, vid_depth, 0);
		}
		update_vidopt();
	}

	if (menusel ==  5)
	{
		hide_vidopt();
	}
}

function vidopt_left()
{
	//resolution
	if (menusel == 1)
	{
		snd_play (leftright_snd, 100, -100);
		vid_res -= 1;
 		if (vid_res == 10)	//skip 1400x1050
		{
			vid_res -= 1;
		}
		if (vid_res < 5)
		{
			vid_res = 11;
		}
	}

	//color depth
	if (menusel == 2)
	{
		snd_play (leftright_snd, 100, -100);
		vid_depth = 48 - vid_depth;
	}

	//shadows
	if (menusel == 3)
	{
		snd_play (leftright_snd, 100, -100);
		polyshadows -= 1;
		if (polyshadows < 0)
		{
			polyshadows = 2;
		}
	}

	//special fx
	if (menusel == 4)
	{
		snd_play (leftright_snd, 100, -100);
		visualFX = 1 - visualFX;
	}
	update_vidopt();
}

function vidopt_right()
{
	//resolution
	if (menusel == 1)
	{
		snd_play (leftright_snd, 100, 100);
		vid_res += 1;
		if (vid_res == 10)	//skip 1400x1050
		{
			vid_res += 1;
		}
		if (vid_res > 11)
		{
			vid_res = 5;
		}
	}

	//color depth
	if (menusel == 2)
	{
		snd_play (leftright_snd, 100, 100);
		vid_depth = 48 - vid_depth;
	}

	//shadows
	if (menusel == 3)
	{
		snd_play (leftright_snd, 100, 100);
		polyshadows += 1;
		if (polyshadows > 2)
		{
			polyshadows = 0;
		}
	}

	//special fx
	if (menusel == 4)
	{
		snd_play (leftright_snd, 100, 100);
		visualFX = 1 - visualFX;
	}
	update_vidopt();
}

function update_vidopt()
{
	load_optpanel(inst6_ent, "video", vid_res);
	load_optpanel(inst7_ent, "bit", vid_depth);
	load_optpanel(inst8_ent, "shadow", polyshadows);
	load_optpanel(inst9_ent, "onoff", visualFX);
}

//////////Audio Options
function show_audopt()
{
	snd_play (accept_snd, 100, 0);
	m_cancel = hide_audopt;
	m_exec = audopt_exec;
	m_left = audopt_left;
	m_right = audopt_right;
	menusel.z = 5;
	show_optmenu();
	reset_instents(); //reused from instruction menu
	music_device = enable_mod;

	inst1_ent.x = 700;
	inst1_ent.y = 0;
	inst1_ent.z = 150;
	inst2_ent.x = 700;
	inst2_ent.y = 0;
	inst2_ent.z = 70;
	inst3_ent.x = 700;
	inst3_ent.y = 0;
	inst3_ent.z = -10;
	inst4_ent.x = 700;
	inst4_ent.y = 0;
	inst4_ent.z = -90;
	inst5_ent.x = 700;
	inst5_ent.y = 0;
	inst5_ent.z = -200;
	inst6_ent.x = 700;
	inst6_ent.y = 0;
	inst6_ent.z = 30;
	inst6_ent.pan = 180;
	inst7_ent.x = 700;
	inst7_ent.y = 0;
	inst7_ent.z = -50;
	inst7_ent.pan = 180;
	inst8_ent.x = 700;
	inst8_ent.y = 0;
	inst8_ent.z = -140;
	inst8_ent.pan = 180;
	inst9_ent.x = 700;
	inst9_ent.y = 0;
	inst9_ent.z = 110;
	ent_morph(inst1_ent,"opt_src.pcx");
	ent_morph(inst2_ent,"opt_snd.pcx");
	ent_morph(inst3_ent,"opt_mus.pcx");
	ent_morph(inst4_ent,"opt_cd.pcx");
	ent_morph(inst5_ent,"opt_back.pcx");
	ent_morph(inst6_ent,"volume.mdl");
	ent_morph(inst7_ent,"volume.mdl");
	ent_morph(inst8_ent,"volume.mdl");

	optent[0] = handle(inst1_ent);
	optent[1] = handle(inst2_ent);
	optent[2] = handle(inst3_ent);
	optent[3] = handle(inst4_ent);
	optent[4] = handle(inst5_ent);

	update_audopt();
	temp  = 0;
	while (temp < menusel.z)
	{
		fadein_flarepanel(ptr_for_handle(optent[temp]));
		temp += 1;
	}
	fadein_flarepanel(inst6_ent);
	fadein_flarepanel(inst7_ent);
	fadein_flarepanel(inst8_ent);
	fadein_flarepanel(inst9_ent);
}

function hide_audopt()
{
	snd_play (cancel_snd, 100, 0);
	unset_menu_keys();
	fadeout_flarepanel(inst1_ent);
	fadeout_flarepanel(inst2_ent);
	fadeout_flarepanel(inst3_ent);
	fadeout_flarepanel(inst4_ent);
	fadeout_flarepanel(inst5_ent);
	fadeout_flarepanel(inst6_ent);
	fadeout_flarepanel(inst7_ent);
	fadeout_flarepanel(inst8_ent);
	fadeout_flarepanel(inst9_ent);
	while(inst1_ent.visible == on)
	{
		wait(1);
	}
	//restore valid values
	music_device = enable_mod;

	show_quickoptions();
}

function audopt_exec()
{
	if (menusel == 1)
	{
		snd_play (accept_snd, 100, 0);
		if (music_device == 1)
		{
			init_mod();
			init_music(track);
		}
		else
		{
			if (enable_mod == 1)
			{
				stop_mod();
ifndef wiimote;
				close_mod();
endif;
			}
			if (music_device == 0)
			{
				init_music(track);
				cd_player();
			}
			else
			{
            	enable_mod = music_device;
			}
		}
		return;
	}

	if (menusel ==  5)
	{
		hide_audopt();
		return;
	}

	sound_vol = snd_vol;
	if (enable_mod == 1)
	{
		volume_mod(mod_vol);
	}
	if (enable_mod == 0)
	{
		cdaudio_vol = cd_vol;
	}
}

function audopt_left()
{
	//music source
	if (menusel == 1)
	{
		snd_play (leftright_snd, 100, -100);
		music_device -= 1;
		if (music_device < 0)
		{
			music_device = 2;
		}
	}

	//sound vol
	if (menusel == 2)
	{
		snd_vol = max (snd_vol - 10, 0);
		audopt_exec();
		snd_play (leftright_snd, 100, -100);
	}

	//music vol
	if (menusel == 3)
	{
		mod_vol = max (mod_vol - 10, 0);
		audopt_exec();
		snd_play (leftright_snd, 100, -100);
	}

	//cd vol
	if (menusel == 4)
	{
		cd_vol = max (cd_vol - 10, 0);
		audopt_exec();
		snd_play (leftright_snd, 100, -100);
	}
	update_audopt();
}

function audopt_right()
{
	//music source
	if (menusel == 1)
	{
		snd_play (leftright_snd, 100, 100);
		music_device += 1;
		if (music_device >2)
		{
			music_device = 0;
		}
	}

	//sound vol
	if (menusel == 2)
	{
		snd_vol = min (snd_vol + 10, 100);
		audopt_exec();
		snd_play (leftright_snd, 100, 100);
	}

	//music vol
	if (menusel == 3)
	{
		mod_vol = min (mod_vol + 10, 100);
		audopt_exec();
		snd_play (leftright_snd, 100, 100);
	}

	//cd vol
	if (menusel == 4)
	{
		cd_vol = min (cd_vol + 10, 100);
		audopt_exec();
		snd_play (leftright_snd, 100, 100);
	}
	update_audopt();
}

function update_audopt()
{
	inst6_ent.frame = 1 + snd_vol / 10;
	inst7_ent.frame = 1 + mod_vol / 10;
	inst8_ent.frame = 1 + cd_vol / 10;
	load_optpanel(inst9_ent, "src", music_device);
}

//////////Aux functions
function load_optpanel(ent, base_str, index)
{
	me = ent;
	str_cpy(modeltemp_str, base_str);
	str_for_num (modelnr_str, index);
	str_cat (modeltemp_str,modelnr_str);
	str_cat (modeltemp_str,pcx_str);
	ent_purge(me);
	ent_morph(me, modeltemp_str);
}

//////////Background animation
function Xoptmenupart_event()
{
	my.bmap=red_particle_map;
	my.function=part_optmenufade;
	my.move = on;
	my.flare = on;
	my.size = 10;
	my.alpha = 30;
//	my.beam = on;
	my.bright = on;
}

function part_optmenufade()
{
	my.alpha-=time+time;
	my.alpha=max(0,my.alpha);
	if (my.alpha==0)
	{
		my.lifespan=0;
	}
}

function anim_optmenu()
{
	var rot;
	var cpan;
	rot=0;
	cpan=0;
	camera.pan=90;
	while(menu_active==1)
	{
		rot=ang(rot+2*time);
		cpan=ang(cpan+time*0.25);
		camera.tilt=-abs(15*cos(rot))-5;
		temp.x=-100*cos(rot)*cos(camera.tilt);
		temp.y=-420*sin(rot)*cos(camera.tilt);
		camera.z=menu_center[1*6+2]-500*sin(camera.tilt);
		camera.x=temp.x*cos(cpan)-(temp.y*sin(cpan))+menu_center[1*6];
		camera.y=temp.x*sin(cpan)+(temp.y*cos(cpan))+menu_center[1*6+1];
		vec_set(temp,menu_center[1*6]);
		vec_sub(temp,camera.x);
		vec_to_angle(camera.pan,temp);
		camera.roll=25*cos(rot);
		wait(1);
	}
}
/*
[xneu] =   [cos a	-sin a] * [x]
[yneu]	  [sin a	  cos a]	[y]
*/

function move_optmenulight()
{
	my.alpha-=2.5*time;
	my.z+=(1+random(1))*time;
}

function Xoptmenulight_event()
{
	my.x+=random(16)-8;
	my.y+=random(16)-8;
	my.z+=random(16)-8;
	my.size=12;
	my.flare=1;
	my.bmap=orange_particle_map;
	my.move=1;
	my.bright=1;
	my.lifespan=20;
	my.function=move_optmenulight;
}

//////////Entity Actions
action Xoptmenurot
{
	my.ambient=100;
	my.transparent=1;
	my.alpha=20+abs(50*cos(timer*5));
	my.skill1=0;
	vec_set(my.tvec1,vector(2,0,0));
	vec_set(my.tvec2,vector(0,2,0));
	vec_set(my.tvec3,vector(-2,0,0));
	vec_set(my.tvec4,vector(0,-2,0));
	vec_set(my.tvec5,vector(0,0,2));
	vec_set(my.tvec6,vector(0,0,-2));

	while(1)
	{
		if(menu_active==1)
		{
			my.alpha=20+abs(50*cos(timer*5));
			my.pan-=7*time;
			my.tilt=45*cos(timer*3);
			my.roll=45*cos(timer*5);
			my.skill1+=time;

			if(my.skill1>=1)
			{
				vec_set(temp,my.tvec1);
				vec_rotate(temp,my.pan);
				effect(Xoptmenupart_event,1,my.x,temp);

				vec_set(temp,my.tvec2);
				vec_rotate(temp,my.pan);
				effect(Xoptmenupart_event,1,my.x,temp);

				vec_set(temp,my.tvec3);
				vec_rotate(temp,my.pan);
				effect(Xoptmenupart_event,1,my.x,temp);

				vec_set(temp,my.tvec4);
				vec_rotate(temp,my.pan);
				effect(Xoptmenupart_event,1,my.x,temp);

				vec_set(temp,my.tvec5);
				vec_rotate(temp,my.pan);
				effect(Xoptmenupart_event,1,my.x,temp);

				vec_set(temp,my.tvec6);
				vec_rotate(temp,my.pan);
				effect(Xoptmenupart_event,1,my.x,temp);

				my.skill1-=1;
			}

		}
		wait(1);
	}

}

action Xoptmenulight
{
	my.invisible=1;
	my.passable=1;
	my.skill1=0;
	while(1)
	{
		if(menu_active==1)
		{
			my.skill1+=time;
			if(my.skill1>=1)
			{
				effect(Xoptmenulight_event,3,my.x,nullvector);
				my.skill1-=1;
			}
		}
		wait (1);
	}
}