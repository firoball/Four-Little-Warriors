///////////////////////////////////////////////////////////////////////////////////
// ~ 4 Little Warriors ~ MainMenu WDL
//
// modified by Firoball  06/04/2007 (created 12/02/2003)
///////////////////////////////////////////////////////////////////////////////////

//////////Prototypes
function init_warfare();
function anim_warfare();
function scale_warfare();
function shake_camera();
function fade_menu();
function fade_demomenu();
function swap_menu(tempent);
function switch_menu();
function sel_menu_left();
function sel_menu_right();
function exec_menu();
function hide_menu();		//hide menu interface
function show_menu();		//show menu interface
function show_quickmenu();	//show background and directly show menu interface
function show_mainmenu();	//fade in background and display menu slowly
function set_menu_keys();
function unset_menu_keys();
function quit_game();
function no_quit();
function quit();
function start_gamedemo();
function demo_counter();
function set_menucam(i);

//////////Variables
var democount;
var menu_center[24];
var menu_active; //0 = main menu 1 = options 2 = instructions
var menusel[3] = 1, 0, 4; //[2] = menu entries

/////////Strings
string menubase_str;

//////////Function pointers
function* m_switch;
function* m_exec;
function* m_cancel;

//////////Texts
string demotxt_str = "Wait for demoplay to see more of this game!";
string order1_str = "Want to play more? Visit";
string order2_str = "WWW.4WARRIORS.DE";
string order3_str = "and get the registered version today!";
text demo_txt
{
	strings = 4;
	string demotxt_str, order1_str, order2_str, order3_str;
	font = warrior2_fnt;
	alpha = 90;
	flags = center_x, transparent;
}

//////////Menu animations
function init_warfare()
{
	warfare_ent.x = 400;
	warfare_ent.y = 200;
	warfare_ent.z = 80;
	warfare_ent.pan = 180;
	warfare_ent.roll = 67;
	warfare_ent.alpha = 50;
	warfare_ent.oriented = on;
	warfare_ent.visible = on;
}

function anim_warfare()
{
	init_warfare();
	while (warfare_ent.x < 600)
	{
		wait (1);
		warfare_ent.x += 12 * time;
		warfare_ent.y -= 12 * time;
		warfare_ent.z += 6 * time;
		warfare_ent.roll -= 3 * time;
		warfare_ent.scale_x = 0.8 + 0.2 * abs (sin (timer * 5));
	}
	scale_warfare();
	shake_camera();
}

function scale_warfare()
{
		warfare_ent.alpha = 50;
		while (warfare_ent.visible! = 0)
		{
				warfare_ent.scale_x = 0.8+0.2*abs(sin(timer*5));
				wait (1);
		}
		ent_purge(warfare_ent);
}

function shake_camera()
{
	var i;
	var cam_old[3];
	var fps;

	i = 0;
	vec_set (cam_old, camera.x);
	fps = fps_max;

	//not time corrected - intended, as time correction looks bad
	fps_max = 30;
	fps_lock = on;
	while (i < 5)
	{
		i += 1;
		camera.x = cam_old[0] + random (10) - 5;
		camera.y = cam_old[1] + random (10) - 5;
		camera.z = cam_old[2] + random (10) - 5;
		camera.roll = random(10) - 5;
		wait (2);
	}
	fps_lock = off;
	fps_max = fps;
	vec_set (camera.x, cam_old);
	camera.roll = 0;
}

function fade_menu()
{
	snd_play (accept_snd, 100, 0);
	while(menu2_ent.alpha > 0)
	{
		wait (1);
		menu2_ent.alpha -= 4 * time;
		menu3_ent.Y += 5 * time;
		menu1_ent.Y -= 5 * time;
		menu3_ent.alpha = max(menu3_ent.alpha - 6 * time, 0);
		menu1_ent.alpha = menu3_ent.alpha;
		menu_ent.alpha = menu2_ent.alpha << 1;
		warfare_ent.alpha = menu2_ent.alpha;
	}
	menu2_ent.alpha = 0;
	menu_ent.alpha = 0;
	warfare_ent.alpha = 0;
	while(camera.fog<75)
	{
		wait (1);
	}

	hide_menu();
}

function fade_demomenu()
{
	while(menu2_ent.alpha > 0)
	{
		wait (1);
		menu2_ent.alpha -= 4 * time;
		menu3_ent.alpha = max(menu3_ent.alpha - 6 * time, 0);
		menu1_ent.alpha = menu3_ent.alpha;
		menu_ent.alpha = menu2_ent.alpha << 1;
		warfare_ent.alpha = menu2_ent.alpha;
	}
	menu2_ent.alpha = 0;
	menu_ent.alpha = 0;
	warfare_ent.alpha = 0;
	while(camera.fog<75)
	{
		wait (1);
	}

	hide_menu();
}

function swap_menu(tempent)
{
	me = tempent;
	str_cpy(modeltemp_str,menubase_str);
	str_for_num (modelnr_str,menusel);
	str_cat (modeltemp_str,modelnr_str);
	str_cat (modeltemp_str,pcx_str);
	ent_purge(me);
	ent_morph(me,modeltemp_str);
}


function switch_menu()
{
	me = menu2_ent;
	unset_menu_keys();
	proc_kill(1);
	democount = 0;
	while (my.tilt >- 80)
	{
		wait (1);
		my.tilt -= 18 * time;
		my.scale_x = 1 + abs(0.03 * sin(14 * timer));
		menu3_ent.y += 10 * time;
		menu1_ent.y -= 10 * time;
		menu3_ent.alpha = max(menu3_ent.alpha - 10 * time, 0);
		menu1_ent.alpha = menu3_ent.alpha;
	}
	menu3_ent.alpha = 0;
	menu1_ent.alpha = 0;
	my.tilt = 100;
	swap_menu(me);
	wait (1);
	while (my.tilt>10)
	{
		wait (1);
		my.tilt -= 18*time;
		my.scale_x = 1 + abs(0.03 * sin(14 * timer));
	}
	my.tilt = 10;
	set_menu_keys();
	menu3_ent.alpha = 50;
	menu1_ent.alpha = 50;
	democount = 0;
	anim_menu();
}

//////////Menu Controlling
function sel_menu_left()
{
	snd_play (leftright_snd, 100, -100);
	menusel -= 1;
	if (menusel < 1)
	{
		menusel = menusel.z;
	}
	m_switch();
}

function sel_menu_right()
{
	snd_play (leftright_snd, 100, 100);
	menusel += 1;
	if (menusel > menusel.z)
	{
		menusel = 1;
	}
	m_switch();
}


function exec_menu()
{
	democount = 0;
	unset_menu_keys();
	if (menusel == 1)
	{
		fade_menu();
		select_menu();
		return;
	}

	if (menusel == 2)
	{
		show_options();
		return;
	}

	if (menusel == 3)
	{
		show_instructions();
		return;
	}

	if (menusel == 4)
	{
		show_credits();
		return;
	}

	if (menusel == 5)
	{
		quit_game();
		return;
	}
}

//////////Hide and show menu
function hide_menu()
{
	unset_menu_keys();
	menu_ent.visible = off;
	warfare_ent.visible = off;
	menu1_ent.visible = off;
	menu2_ent.visible = off;
	menu3_ent.visible = off;
	if (demoversion == 1)
	{
		demo_txt.visible = off;
	}
	register_txt.visible = off;
}

function show_menu()
{
	m_switch = switch_menu;
	m_exec = exec_menu;
	m_cancel = quit_game;
	str_cpy (menubase_str, "menu");
	democount = 0;
	menusel = 1;
	menusel.z = 5;
	menu_ent.alpha = 100;
	menu_ent.flare = 1;
	menu_ent.x = 600;//320;
	menu_ent.y = 0;
	menu_ent.z = 180;
	menu2_ent.flare = 1;
	anim_title(menu_ent);

	menu1_ent.visible = 1;
	swap_menu(menu2_ent);
	menu2_ent.visible = 1;
	menu3_ent.visible = 1;
	if (warfare_ent.visible == 0)
	{
		warfare_ent.visible = 1;
		scale_warfare();
	}
	anim_menu();
	set_menu_keys();
	demo_counter();
	if (demoversion == 1)
	{
	    demo_txt.pos_x = screen_size.x / 2;
	    demo_txt.pos_y = screen_size.y - 60;
	    demo_txt.visible = on;
	}
	register_txt.visible = on;

}

function show_quickmenu()
{
	set_menucam(0);
	fog_color = 0;
	camera.fog = 0;
	show_menu();
}

function show_mainmenu()
{
	set_menucam(0);
	while (camera.fog>0)
	{
		camera.fog -= 3*time;
		wait (1);
	}

	fog_color = 0;
	waitt (16);
	anim_warfare();
	waitt (16);
	snd_play(warriors_snd,100,0);
	show_menu();
}

function set_menu_keys()
{
	on_cur = sel_menu_right;
	on_cul = sel_menu_left;
	on_enter = m_exec;
	on_esc = m_cancel;
}

function unset_menu_keys()
{
	on_n = null;
	on_z = null;
	on_y = null;
	on_j = null;
	on_cuu = null;
	on_cud = null;
	on_cur = null;
	on_cul = null;
	on_enter = dummy;
	on_esc = dummy;
}

////////////////////Quit Game////////////////

function quit_game()
{
	democount = 0;
	snd_play (cancel_snd, 100, 0);
	on_cur = null;
	on_cul = null;
	on_enter = dummy;
	menu1_ent.visible = 0;
	menu2_ent.visible = 0;
	menu3_ent.visible = 0;

	ent_morph(menu2_ent,"menu6.pcx");
	anim_ent(menu2_ent);

	on_esc = no_quit;
	on_n = no_quit;
	on_z = quit;
	on_y = quit;
	on_j = quit;
}

function no_quit()
{
	democount = 0;
	snd_play (cancel_snd, 100, 0);
	menu2_ent.visible = 0;
	on_n = null;
	on_z = null;
	on_y = null;
	on_j = null;
	on_cuu = null;
	on_cud = null;
	on_enter = dummy;
	show_menu();
}

function quit()
{
	ifndef wiimote;
	if (enable_mod == 1)
	{
		close_mod();
	}
	endif; 
	if (wiimote_ena != 0)
	{
		wiimote_ena = 0;
		wait(3);
	}
	exit;
}

//////////Show game demo
function start_gamedemo()
{
	var demonr;

	unset_menu_keys();
	fade_demomenu();
	//select player models
	dbinit();
	//random selection
	wait (1);
	demonr = dbdetect_models();
	dbselect_model(0, int(random(demonr)+1));
 	dbselect_model(1, int(random(demonr)+1));
	dbselect_model(2, int(random(demonr)+1));
	dbselect_model(3, int(random(demonr)+1));

	player_active = 0;	//only cpu players
	demoplay = 1;
	levelnr = int(abs(random(DEFmaxLevels))+1);
	str_cpy (leveltemp_str,levelbase_str);
	str_for_num (levelnr_str,levelnr);
	str_cat (leveltemp_str,levelnr_str);
	str_cpy (level_str,leveltemp_str);
	str_cat (level_str,wmb_str);
	player_won[0] = 0;
	player_won[1] = 0;
	player_won[2] = 0;
	player_won[3] = 0;
	level_loader();

}

function demo_counter()
{
	proc_kill(4);
	democount = 0;
	while (menu_ent.visible && demoplay == 0)
	{
		democount += time;
		if (democount > 320) // 20 seconds
		{
			start_gamedemo();
		}
		wait (1);
	}
	democount = 0;
}
//////////Menu background switching
function set_menucam(i)
{
	menu_active = i;
	vec_set (camera.x, menu_center[i * 6]);
	vec_set (camera.pan, menu_center[i * 6 + 3]);
	vec_set (cam_angle.pan, camera.pan);
}

define ArrayIndex, skill1;

// uses	ArrayIndex
action set_menu_pos
{
	vec_set (menu_center[my.ArrayIndex * 6], my.x);
	vec_set (menu_center[my.ArrayIndex * 6 + 3], my.pan);
	my.visible = off;
	wait (1);
	ent_remove(me);
}