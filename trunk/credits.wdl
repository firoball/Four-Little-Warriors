///////////////////////////////////////////////////////////////////////////////////
// ~ 4 Little Warriors ~ Credits WDL
//
// Modified by Firoball  03/14/2007 (created 01/04/2006)
///////////////////////////////////////////////////////////////////////////////////

//////////Prototypes
function show_credits();
function hide_credits();
function credits_part();
function Xcreditspart_event();
function credits_anim();

//////////Functions
function show_credits()
{
	snd_play (accept_snd, 100, 0);
	hide_menu();
	set_menucam(3);
	show_header("menu4.pcx");
	reset_instents();
	ent_morph (inst1_ent, "lcredits.tga");
	ent_morph (inst2_ent, "rcredits.tga");
	ent_morph(menu2_ent,"anykey.pcx");
	inst1_ent.x = 500;
	inst1_ent.y = 220;
	inst1_ent.z = 0;
	inst2_ent.x = 500;
	inst2_ent.y = -200;
	inst2_ent.z = 0;
	menu2_ent.z -= 60;
	fadein_flarepanel(inst1_ent);
	fadein_flarepanel(inst2_ent);
	fadein_flarepanel(menu2_ent);
	anim_ent(menu2_ent);
	wait (1);
	ent_create ("box.mdl", camera.x, credits_part);

	sleep (3);
	while(key_any == 0 && key_wiiany == 0)
	{
		wait(1);
	}
	hide_credits();
}

function hide_credits()
{
	snd_play (accept_snd, 100, 0);
	fadeout_flarepanel(inst1_ent);
	fadeout_flarepanel(inst2_ent);
	fadeout_flarepanel(menu2_ent);
	hide_header();
	fadeout_instmenu();
	while(menu2_ent.visible==1)
	{
		wait(1);
	}
	reset_instents();
	menu2_ent.z += 60;
	header_ent.visible = off;
	wait (1);
	show_quickmenu();
}

function credits_part()
{
	my.passable = on;
	my.unlit = on;
	my.ambient = 100;
	my.invisible = on;
	vec_set (my.pan, camera.pan);
	vec_set (my.posX, my.x);
	while (menu2_ent.visible)
	{
		temp.x = 0;
		temp.y = 15 * sin (timer * 6);
		temp.z = 15 * cos (timer * 8);
		vec_rotate (temp.x, my.pan);
		vec_add (temp, my.posX);
		vec_set (my.x, temp);
		vec_set (camera.x, my.x);
		my.partTimer += time;
		my.partCounter += time;

		if (my.partTimer > 2)
		{
			my.partTimer -= 2;
			my.partcount = 0;
			while (my.partcount < 360)
			{
				vec_set (my_angle, vector (my.pan, 0, my.partcount + int (random (15))));
				vec_set (temp, vector (0, 0, 60));
				vec_rotate (temp, my_angle);
				vec_add (temp, my.x);

				vec_set (my_pos, vector (8, 0, 0));
				vec_rotate (my_pos, my.pan);
				effect(Xcreditspart_event, 1, temp, my_pos);
				my.partcount += 20;
			}
		}

		if (my.partCounter > 48)
		{
			my.partCounter -= 48;
			str_cpy(modeltemp_str, "credits");
			str_for_num (modelnr_str, my.anim_time);
			str_cat (modeltemp_str, modelnr_str);
			str_cat (modeltemp_str, pcx_str);
			ent_create (modeltemp_str, my.x, credits_anim);
			my.anim_time = (my.anim_time + 1) % 10;
		}
		wait (1);
	}
	wait (1);
	ent_remove (me);
}

function Xcreditspart_event()
{
	my.bmap = white_particle_map;
	my.flare = on;
	my.bright = on;
	my.move = on;
	my.size = 1;
	my.lifespan = 300;
	my.function = part_instmenufade;
}

function credits_anim()
{
	my.alpha = 100;
	my.bright = on;
	my.flare = on;
	my.z -= 10;
	vec_set (my.pan, vector (your.pan + 180, 0, 0));
	vec_set (my.speedX, vector (-8 * time, 0, 0));
	vec_rotate (my.speedX, my.pan);
	my.tilt = 60;
	my.oriented = on;
	my.scale_x = 0.3;
	my.scale_y = 0.3;
	while (my.alpha > 0)
	{
		wait (1);
		my.alpha -= 2 * time;
		ent_move (nullvector, my.speedX);
	}
	my.alpha = 0;
	ent_purge (me);
	ent_remove (me);
}