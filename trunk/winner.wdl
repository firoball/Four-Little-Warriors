///////////////////////////////////////////////////////////////////////////////////
// ~ 4 Little Warriors ~ Winner WDL
//
// modified by Firoball  10/06 /2005 (created 01/18/2004)
///////////////////////////////////////////////////////////////////////////////////

//////////Prototypes
function init_result();
function show_winnerpanels();
function fade_borders();
function focus_winner(ent);
function show_winner();
function anim_winner_ent();
function set_anykey();
function show_trophies();
function anim_trophy(tempent, offset);
function add_trophy(ypos, offset);
function hide_trophies();
function fade_winner();
function winner_teleport();
function winner_fx();
function winner_glow();
function winner_sword();
function winner_telering();
function winner_warp();
function winner_fade();
function winner_loader();
function winner_anykey();
function prepare_intro_loader();
function player_win();
function player_victory(tempent);
function player_lose(tempent);

//////////Variables
var winner;
var trophy_pos[5] = 150, 75, 0, -75, -150;
var trophy_handle[5];

//////////Strings
string trophybase_str[12];
string trophyname_str = "trophy";
string trophynr_str[1];
string trophyext_str = ".tga";
string winnermdl_str[12];
string win_str  "win";

//////////Pointers
entity* trophy_ent;
//entity* winplr_ent;

//////////Menu sequence animation
function init_result()
{
	proc_kill(4);
	on_esc = dummy;
	menu2_ent.visible = off;
	game_status = stat_gameover;
	clip_size = 0;
	events = Enone; //stop active event
	wait (1);
	cam_arc=0;
	camera.arc=60;
	snd_play (gong_snd, 90, 0);
	show_winnerpanels();
	show_winner();
	init_music (3);
//	wait (1);
	set_anykey();
}

function show_winnerpanels()
{
	fade_borders();

	menu_ent.bright = off;
	menu_ent.transparent = on;
	menu_ent.alpha = 70;
	menu_ent.X = 800;
	menu_ent.Y = -320;
	menu_ent.Z = -220;
	anim_title (menu_ent);
	init_warfare();
	warfare_ent.X = 800;
	warfare_ent.Y = -320;
	warfare_ent.Z = -220;
	warfare_ent.roll = 17;
	scale_warfare();
}

function fade_borders()
{
	border1_ent.alpha = 0;
	border2_ent.alpha = 0;
	border1_ent.visible = on;
	border2_ent.visible = on;
	while (border1_ent.alpha < 50 && border1_ent.visible)
	{
		wait (1);
		border1_ent.alpha += time + time;
		border2_ent.alpha += time + time;
	}
	border1_ent.alpha = 50;
	border2_ent.alpha = 50;
}

function focus_winner(ent)
{
	me = ent;
	var cdist;
	var cangle;
	var cpos;
	var wpos;
	var tresult;

	//fix winner angle because of scenemap
	if(my.pan > 90)
	{
		my.pan = 90;
	}
	else
	{
		if(my.pan > 0)
		{
			my.pan = 0;
		}
		else
		{
			if(my.pan > -90)
			{
				my.pan = -90;
			}
			else
			{
				my.pan = -180;
			}
		}
	}


	cdist=250;
	vec_set(cangle,vector(180,-15,0));
	cangle.pan=ang(cangle.pan+my.pan);
	vec_set(wpos,my.x);
//	tresult=1;
//	while(tresult!=0)
//	{
//		cangle.pan+=15;
		cpos.x=wpos.x-cdist*cos(cangle.pan)*cos(cangle.tilt);
		cpos.y=wpos.y-cdist*sin(cangle.pan)*cos(cangle.tilt);
		cpos.z=wpos.z-cdist*sin(cangle.tilt);
//		trace_mode=ignore_models+ignore_me+ignore_sprites;
//		tresult=trace(cpos,wpos);
//	}
	vec_set(camera.x,cpos);
	vec_set(camera.pan,cangle);
	cam_angle.pan=180;
	if (ang(camera.pan)<45 && ang(camera.pan)>=-45) {cam_angle.pan=0;}
	if (ang(camera.pan)<135 && ang(camera.pan)>=45) {cam_angle.pan=90;}
	if (ang(camera.pan)<-45 && ang(camera.pan)>=-135) {cam_angle.pan=-90;}
	if (scenemap != null)
	{
		scenemap.x=636*cos(cam_angle.pan);
		scenemap.y=636*sin(cam_angle.pan);
		scenemap.z=-32;
		scenemap.pan=cam_angle.pan;
	}
	camera.roll = 0;
	while(game_status == stat_gameover)
	{
		camera.pan = cangle.pan + 25 * sin (timer * 2);
		camera.tilt = cangle.tilt + 10 * cos (timer * 2);
		cpos.x = wpos.x - cdist * cos (camera.pan) * cos (camera.tilt);
		cpos.y = wpos.y - cdist * sin (camera.pan) * cos (camera.tilt);
		cpos.z = wpos.z - cdist * sin (camera.tilt);

		trace_mode = ignore_models + ignore_me + ignore_sprites + ignore_maps + ignore_passable;
		tresult = trace (wpos, cpos);
		you = null;
		if (content (cpos) == CONTENT_SOLID || tresult > (cdist - 50))
		{
			if (you == null)
			{
				tresult -= 10;
				camera.x = wpos.x - tresult * cos (camera.pan) * cos (camera.tilt);
				camera.y = wpos.y - tresult * sin (camera.pan) * cos (camera.tilt);
				camera.z = wpos.z - tresult * sin (camera.tilt);
			}
			else
			{
				vec_set (camera.x, cpos);
			}
		}
		else
		{
			vec_set (camera.x, cpos);
		}
		wait (1);
	}
}

function show_winner()
{
	if (pow[0] > pow[1] && pow[0] > pow[2] && pow[0] > pow[3])
	{
		winner = 0;
		player_victory (player1);
		player_lose (player2);
		player_lose (player3);
		player_lose (player4);
	}
	else{
	if (pow[1] > pow[0] && pow[1] > pow[2] && pow[1] > pow[3])
	{
		winner = 1;
		player_victory (player2);
		player_lose (player1);
		player_lose (player3);
		player_lose (player4);
	}
	else{
	if (pow[2] > pow[1] && pow[2] > pow[0] && pow[2] > pow[3])
	{
		winner = 2;
		player_victory (player3);
		player_lose (player1);
		player_lose (player2);
		player_lose (player4);
	}
	else{
	if (pow[3] > pow[1] && pow[3] > pow[2] && pow[3] > pow[0])
	{
		winner = 3;
		player_victory (player4);
		player_lose (player1);
		player_lose (player2);
		player_lose (player3);
	}
	else
	{
		winner = -1;
		golement = ent_create ("golem.mdl", center.x, init_golem);
		wait (1);
		focus_winner (golement);
		player_lose (player1);
		player_lose (player2);
		player_lose (player3);
		player_lose (player4);
	}
	}}}

	me = winner_ent;
	if (winner < 0)
	{
		ent_morph (me, "draw.pcx");
		anim_winner_ent();
	}
	else
	{
		player_won[winner] += 1;
		show_trophies();
//		ent_morph (me, "winner.pcx");
	}
}

function anim_winner_ent()
{
	me = winner_ent;
	my.alpha = 50;
	my.visible = on;

	while(my.visible == on && my.alpha > 0)
	{
		my.scale_x = 1 + abs (0.03 * sin (14 * timer));
		wait (1);
	}
	my.visible = off;
	ent_purge(me);
}

function set_anykey()
{
	sleep (3);
	ent_morph (menu2_ent, "anykey.pcx");
	anim_ent (menu2_ent);
	fadein_flarepanel(menu2_ent);
	while(menu2_ent.alpha < 50) {wait(1);}
	if (winner < 0)
	{
		on_anykey = level_reload;
		return;
	}
	if (player_won[winner] >= game_limit)
	{
		on_anykey = winner_loader;
	}
	else
	{
		on_anykey = level_reload;
	}
}

function show_trophies()
{
//entities are "borrowed" from isntructions menu
	reset_instents();
	trophy_handle[0] = handle(inst1_ent);
	trophy_handle[1] = handle(inst2_ent);
	trophy_handle[2] = handle(inst3_ent);
	trophy_handle[3] = handle(inst4_ent);
	trophy_handle[4] = handle(inst5_ent);

	temp.y = (5 - game_limit) / 2; //trophy start position
	temp = temp.y; //current trophy position
//init trophy panels
	while (temp < player_won[winner] + temp.y)
	{
		trophy_ent = ptr_for_handle (trophy_handle[temp]);
		trophy_ent.x = 1000;
		trophy_ent.y = trophy_pos[temp];
		trophy_ent.z = 265;
		trophy_ent.alpha = 50;
		trophy_ent.oriented = on;
		trophy_ent.roll = 210;
		trophy_ent.scale_x = 0.4;
		trophy_ent.scale_y = 0.3;
		ent_morph (trophy_ent, "inst_sw1.tga");
		trophy_ent.visible = on;
		anim_trophy(trophy_ent, temp);
		temp += 1;
	}
//hide last trophy (is added this turn but not yet visible)
	if (trophy_ent)
	{
		trophy_ent.visible = off;
	}
	temp.z = player_won[winner] + temp.y - 1; //last trophy position
	add_trophy (trophy_pos[temp.z], temp - 1);
	winner_ent.flare = off;
	winner_ent.bright = off;
//construct trophy background name according to game_limit
	str_cpy (trophybase_str, trophyname_str);
	str_for_num (trophynr_str, game_limit);
	str_cat (trophybase_str, trophynr_str);
	str_cat (trophybase_str, trophyext_str);
	ent_morph (winner_ent, trophybase_str);
	winner_ent.visible = on;
}

function anim_trophy(tempent, offset)
{
	me = tempent;
	var pos;
	var angle;
	pos = my.z;
	angle = my.roll;
	while (my.alpha > 0)
	{
		my.z = pos + 5 * sin (timer * 15 + offset * 20);
		my.roll = angle + 7 * cos (timer * 15 + offset * 30);
		wait (1);
	}
}

function add_trophy(ypos, offset)
{
	me = inst6_ent;
	var targetpos[3];
	var pos;
	var angle;
	my.x = 0;
	my.y = 0;
	my.z = 0;
	my.alpha = 50;
	my.oriented = on;
	my.roll = 210;
	my.tilt = 180;
	my.scale_x = 0.4;
	my.scale_y = 0.3;
	vec_set (targetpos[0], vector (1000, ypos, 250));
	ent_morph (me, "inst_sw1.tga");
	sleep (4);
	my.visible = on;
	while (my.x < targetpos[0])
	{
		wait (1);
		my.x += 50 * time;
		my.y += targetpos[1] / 20 * time;
		pos += targetpos[2] / 20 * time;
		my.z = pos + 5 * sin (timer * 15 + offset * 20);
		my.roll = angle + 7 * cos (timer * 15 + offset * 30);
		my.tilt += 54 * time;
	}
	my.visible = off;
	ent_purge (me);
	trophy_ent.visible = on;
//animate trophy background after trophy was addd
	snd_play (trophy_snd, 100, 0);
	winner_ent.scale_y = 1.2;
	while (winner_ent.scale_y > 1)
	{
		wait (1);
		winner_ent.scale_y -= 0.05 * time;
	}
	winner_ent.scale_y = 1;
	ent_morph (me, "box.mdl"); //bug workaround
}

function hide_trophies()
{
	fade_winner();
	if (winner < 0) {return;}
	while (menu2_ent.alpha > 0)
	{
		wait (1);
		temp = 0;
		while (temp < 5)
		{
			trophy_ent = ptr_for_handle(trophy_handle[temp]);
			trophy_ent.alpha = menu2_ent.alpha;
			temp += 1;
		}
	}
	temp = 0;
	while (temp < 5)
	{
		trophy_ent = ptr_for_handle(trophy_handle[temp]);
		trophy_ent.visible = off;
		ent_purge (trophy_ent);
		ent_morph (trophy_ent, "box.mdl"); //bug workaround
		temp += 1;
	}
}

function fade_winner()
{
	while (menu2_ent.alpha > 0)
	{
		wait (1);
		menu2_ent.alpha -= time + time;
		menu_ent.alpha = menu2_ent.alpha << 1;
		warfare_ent.alpha = menu_ent.alpha;
		winner_ent.alpha = menu2_ent.alpha;
		border1_ent.alpha = menu2_ent.alpha;
		border2_ent.alpha = menu2_ent.alpha;
	}

	menu2_ent.alpha = 0;
	menu2_ent.visible = off;
	menu_ent.visible = off;
	warfare_ent.visible = off;
	winner_ent.visible = off;
	border1_ent.visible = off;
	border2_ent.visible = off;
	ent_purge (menu2_ent);
	ent_purge (menu_ent);
	ent_purge (warfare_ent);
	ent_purge (border1_ent);
	ent_purge (border2_ent);
	ent_purge (winner_ent);
	ent_morph (winner_ent, "box.mdl"); //bug workaround
	winner_ent.flare = on;
	winner_ent.bright = on;
}

function winner_teleport()
{
	my.counter = 0;
	my.basePan = 3 * time;
	my.alpha = 0;
	my.bright = on;
	my.unlit = on;
	my.passable = on;
	my.flare = on;
	my.ambient = 100;
	my.pan = your.targetPan;
	my.scale_y = 2;
	my.scale_x = 0.1;
	vec_set (my.targetX, your.x);
	my.targetZ += 20;
	while (my.alpha < 50)
	{
		wait (1);
		my.alpha += time;
		my.pan += 3 * time;
		vec_set (my.x, vector (30, 0, 0));
		vec_rotate (my.x, my.pan);
		vec_add (my.x, my.targetX);
	}
	my.alpha = 50;
	while (my.counter < 48)
	{
		wait (1);
		my.counter += time;
		my.basePan += 0.05 * time;
		my.pan += my.basePan;
		vec_set (my.x, vector (30, 0, 0));
		vec_rotate (my.x, my.pan);
		vec_add (my.x, my.targetX);
	}
	while (my.alpha > 0)
	{
		wait (1);
		my.alpha -= time + time;
//		my.pan += 3 * time;
		my.pan += my.basePan;
		vec_set (my.x, vector (30, 0, 0));
		vec_rotate (my.x, my.pan);
		vec_add (my.x, my.targetX);
	}
	my.alpha = 0;
	my.invisible = on;
	ent_purge (me);
	ent_remove (me);
}

function winner_fx()
{
	var cnt;
	my.counter = 0;
	my.partTimer = 0;
	vec_set (my.targetX, my.x);
	my.targetZ -= 40;
	while (my.targetPan < 360)
	{
		my.targetPan += 45;
		vec_set (temp, vector (30, 0, 0));
		vec_rotate (temp, vector (my.targetPan, 0, 0));
		vec_add (temp, my.x);
		ent_create("teleport.pcx", temp, winner_teleport);
	}
	snd_play (winner1_snd, 100, 100);
	sleep (2);
	//show sword + glowing border
	vec_set (temp, vector (40, 0, 0));
	vec_rotate (temp, my.pan);
	vec_add (temp, my.x);
	temp.z += 25;
	ent_create ("inst_sw1.tga", temp, winner_sword);
	vec_set (temp, vector (37, 0, 0));
	vec_rotate (temp, my.pan);
	vec_add (temp, my.x);
	temp.z += 25;
	ent_create ("inst_sw2.pcx", temp, winner_glow);
}

function winner_glow()
{
	winner_sword();
	my.flare = on;
	my.bright = on;
	while (my.flag1 == off) //set by winner_sword()
	{
		wait (1);
		my.alpha = 35 + 15 * sin (timer * 7);
		if (my.flag2) //set by winner_sword()
		{
			snd_play (trophy_snd, 30, 100);
			my.flag2 = off;
		}
	}
}

function winner_sword()
{
	my.unlit = on;
	my.passable = on;
//	my.bright = on;
	my.scale_x = 0.05;
	my.scale_y = 0.05;
	my.ambient = 100;
	while (my.scale_x < 0.2)
	{
		wait (1);
		my.scale_x += 0.02 * time;
		my.scale_y += 0.02 * time;
	}
	my.scale_x = 0.2;
	my.scale_y = 0.2;
	my.flag2 = on;
	sleep (2);
	my.flag1 = on; //check for sword glowing
	while (my.alpha > 0)
	{
		wait (1);
		my.alpha -= 2 * time;
	}
	my.invisible = on;
	ent_purge (me);
	ent_remove (me);
}

function winner_telering()
{
	my.bright = on;
	my.passable = on;
	my.flare = on;
	my.oriented = on;
	my.unlit = on;
	my.tilt = 90;
	while (my.alpha > 0)
	{
		wait (1);
		my.alpha -= 2.8 * time;
		my.scale_x += 0.3 * time;
		my.scale_y += 0.3 * time;
		my.pan -= 8 * time;
	}
	my.invisible = on;
	ent_purge (me);
	ent_remove (me);
}

function winner_warp()
{
	my.counter = 0;
	ent_create ("telering.pcx", my.x, winner_telering);
	snd_play (winner2_snd, 100, 100);
	while (my.scale_x > 0)
	{
		wait (1);
		my.counter += time;
		while (my.counter > 1)
		{
			my.counter -= 1;
			ent_create (winnermdl_str, my.x, winner_fade);
		}
		my.scale_x = max (0, my.scale_x - 0.1 * time);
		my.scale_y = max (0, my.scale_x - 0.1 * time);
		my.scale_z = max (0, my.scale_x - 0.1 * time);
	}
	my.visible = off;
}

function winner_fade()
{
	my.alpha = 50;
	my.transparent = on;
	my.passable = on;
	vec_set (my.scale_x, your.scale_x);
	vec_set (my.pan, your.pan);
	my.frame = your.frame;
	my.skin = your.skin;
	while (my.alpha > 0)
	{
		wait (1);
		my.alpha -= 3 * time;
	}
	my.invisible = on;
	ent_remove(me);
}

function winner_loader()
{
	on_anykey = null;
	player_won[0] = 0;
	player_won[1] = 0;
	player_won[2] = 0;
	player_won[3] = 0;
	hide_trophies();
	fog_color = 1;
	while (camera.fog < 100)
	{
		wait (1);
		camera.fog += 3 * time;
	}
	camera.fog = 100;
	menubg_ent.visible = off;

	game_status = stat_winner;
	wait (1);
	level_load ("winner.wmb");
	wait (2);
	set_menucam (3);
	while (camera.fog > 0)
	{
		wait (1);
		camera.fog -= 3 * time;
	}
	fog_color = 0;
}

function winner_anykey()
{
	sleep (5);
	ent_morph (menu2_ent, "anykey.pcx");
	anim_ent (menu2_ent);
	fadein_flarepanel(menu2_ent);
	while(menu2_ent.alpha < 50) {wait(1);}
	on_anykey = prepare_intro_loader;
}

function prepare_intro_loader()
{
	on_anykey = null;
	fade_winner();
	intro_loader();
}
//////////Model animations
function player_win()
{
	my.anim_dist = 0;
	my.anim_fac = 6;
	while (me)
	{
		wait (1);
		my.anim_time += time / 8;
		if (my.anim_time > my.anim_fac)
		{
			my.anim_time -= my.anim_fac;
		}
		temp = 100 * my.anim_time / my.anim_fac;
		ent_cycle (win_str, temp);
	}
}

function player_victory(tempent)
{
	me = tempent;
	str_for_entfile(winnermdl_str, me);
	my.event = null;
	my.mode= Pmode_lock;
	my.anim_dist = 0;
	my.passable = on;
	focus_winner (me);
	while (me)
	{
		wait (1);
		my.anim_time += time / 8;
		if (my.anim_time > my.anim_fac)
		{
			my.anim_time -= my.anim_fac;
		}
		temp = 100 * my.anim_time / my.anim_fac;
		ent_cycle (victory_str, temp);
	}
}

function player_lose(tempent)
{
	me = tempent;
	my.event = null;
	my.mode = Pmode_lock;
	my.anim_time = 0;
	my.passable = on;
	ent_frame (hit_str, 100);
}

//////////Actions

//var win = 0;
action init_winner
{
//while (win == 0) {wait (1);}
/*
	if (game_status != stat_winner)
	{
		return;
	}
*/
	ent_morph (me, winnermdl_str);

//temp
//	ent_morph (me, "knight.mdl");
//	str_for_entfile(winnermdl_str, me);

	my.skin = winner + 1;
	show_winnerpanels();
	winner_anykey();
	player_win();
	sleep (4);
	winner_fx();
	sleep (6);
	winner_warp();
}