///////////////////////////////////////////////////////////////////////////////////
// ~ 4 Little Warriors ~ Weapon WDL
//
// Modified by Firoball  03/28/2006 (created 03/04/2005)
///////////////////////////////////////////////////////////////////////////////////

//////////Prototypes
function lightning_event();
function emit_lightningparticle();
function move_lightning();
function spawn_lightning();
function shoot_lightning();

function explode_acidball();
function acidball_event();
function emit_acidparticle();
function move_acidball();
function shoot_acidball();

function explode_fireball();
function fireball_event();
function emit_fireparticle();
function move_fireball();
function shoot_fireball();

function weapon_scan();

//////////Functions
function emit_lightningparticle()
{
	my.part_timer = 0;
	while(game_status != stat_gameover && my.removed == off)
	{
		my.part_timer += time;
		if (my.part_timer >= 0.2)
		{
			vec_set (temp, my.x);
			vec_sub (temp, my.posX);
			effect(xparticlel_event, 1, my.posX, temp);
			vec_set (my.posX, my.x);
			while (my.part_timer >= 0.2)
			{
				my.part_timer -= 0.2;
			}
		}
		wait(1);
	}
}

function lightning_event()
{
	my.event = null;
	ent_playsound (me, lbuzz_snd, 600);
	my.removed = on;
	wait(1);
	effect (lightning_explo, 100, my.x, nullvector);
	weapon_scan();
}

function move_lightning()
{
	my.typ = item_lightning;
	init_item_stats(me);
	my.typ = weapon;
	my.narrow = off;
	my.fat = on;
	my.invisible = on;
	my.passable = on;
//	my.transparent = on;
//	my.alpha = 70;
//	my.bright = on;
//	my.typ = weapon;
	ent_playsound (me, lfizzle_snd, 600);
	if (your.typ == weapon)	/* triggered by weapon */
	{
		/* get player_ref from parent entity */
		tempent = ptr_for_handle(your.player_ref);
		my.player_ref = handle(tempent);
	}
	else					/* triggered by player */
	{
		my.player_ref = handle(you);
	}
	wait(1);

	my.x += your.x + 45 * cos(my.pan);
	my.y += your.y + 45 * sin(my.pan);
	my.z = your.z + 5;

	/* outside arena */
	if (abs(my.x) > 365 || abs(my.y) > 365)
	{
		wait(1);
		ent_remove(me);
		return;
	}

	my.passable = off;
	my.overlay = on; //?
	my.ambient = 100;
	my.event = lightning_event;
	my.enable_entity = on;
	my.enable_block = on;
	my.invisible = off;
	my.temp_pan = my.pan;
	my.partCounter = 0;
	vec_set (my.posX, your.x);
	emit_lightningparticle();
	while (game_status != stat_gameover && my.removed == off)
	{
		my.alpha = 30 + abs(30 * sin(timer * 15));
		my.scale_x = 1 + abs(0.5 * sin(timer * 17));
		my.moveCounter += time;
		if (my.moveCounter > 1)
		{
			my.pan = my.temp_pan + 45 * sin(timer * 60);
			my.moveCounter -= 1;
			if (my.invisible == off)
			/* collided lightning cannot create children */
			{
				spawn_lightning();
			}
		}
		my.forcex = my.forceFac;
		temp = min(time * 0.55, 1);
		my.speedx += (time * my.forcex) - (temp * my.speedx);
		speed.x = my.speedx * time;
		speed.y = 0;
		speed.z = 0;
		my.roll += 15 * time;
		ent_move (speed, nullvector);
		wait(1);
	}
	wait (2);
	my.invisible = on;
	my.passable = on;
	sleep(1);	//allow playback of sound
	ent_purge(me);
	ent_remove(me);
}

function spawn_lightning()
{
	if (int (random(12)) < 1)
	{
		you = ent_create ("lightnin.mdl", my.x, move_lightning);
		your.pan = my.pan;
		if (random(2) <1)
		{
			your.pan += random(15) + 40;
		}
		else
		{
			your.pan -= random(15) + 40;
		}
		your.x = 0;
		your.y = 0;
		your.forceFac = 20;
	}
}

function shoot_lightning()
{
	wait(1);
	my.ammo -= 1;
	if (my.ammo == 0)
	{
		my.weapon_type = 0;
	}
	you = ent_create ("box.mdl", my.x, move_lightning);
	your.typ = item_lightning;
	init_item_stats(you);
	your.typ = weapon;
	your.pan = my.pan;
	your.x = 0;
	your.y = 0;
	your.forceFac = 20;
}

/////////////////////////////////////////////////////

function explode_acidball()
{
	my.passable = on;
	my.lightred = 1;
	my.lightgreen = 100;
	my.lightblue = 0;
	my.lightrange = 100;
	anim_sprite();
	ent_playsound (me, bounce_snd, 600);
}

function emit_acidparticle()
{
	my.part_timer = 0;
	while(game_status != stat_gameover)
	{
		my.part_timer += time;
		while (my.part_timer >= 0.5)
		{
			effect(XparticleA_event, 6, my.pos, nullvector);
			my.part_timer -= 0.5;
		}
		wait(1);
	}
}

function acidball_event()
{
	if (my.acidball_lock > 2)
	{
		my.event = null;
		my.removed = on;
		return;
	}
	vec_to_angle (my_angle, bounce);
	my.pan = my_angle.pan + random(10);
	my.bounceCount -= 1;
	my.forceFac += 2;
	wait(1);
	tempent = ptr_for_handle(my.player_ref);
	weapon_scan();
	you = ent_create("explo+9.pcx", my.x, explode_acidball);
	if (my.bounceCount < 1)
	{
		my.event = null;
		my.removed = on;
		return;
	}
	my.acidball_lock += 1;
	sleep (0.1);
	my.acidball_lock -= 1;
}

function move_acidball()
{
	my.typ = item_acidball;
	init_item_stats(me);
	my.typ = weapon;
	my.narrow = off;
	my.fat = on;
	my.player_ref = handle(you);
	my.invisible = on;
	my.passable = on;
	if (polyshadows > 1)
	{
		my.shadow = on;
	}
	wait(1);
	my.x += your.x + 45 * cos (my.pan);
	my.y += your.y + 45 * sin (my.pan);
	my.z = your.z + 5;

	/* outside arena */
	if (abs(my.x) > 365 || abs(my.y) > 365)
	{
		wait(1);
		ent_remove(me);
		return;
	}

//	my.overlay = on; //?
//	my.bright = on;
	my.ambient = 100;
	my.event = acidball_event;
	my.enable_entity = on;
	my.enable_block = on;
	my.invisible = off;
	my.passable = off;
	emit_acidparticle();
	while (game_status != stat_gameover && my.removed == off)
	{
//todo: change particle function
//		temp = 6 * time;
//		effect (xparticlea_event, temp, my.pos, nullvector);
		my.forcex = my.forceFac;
		temp = min(time*0.55,1);
		my.speedx += (time * my.forcex) - (temp * my.speedx);
		speed.x = my.speedx * time;
		speed.y = 0;
		speed.z = 0;
		my.roll += 10 * time;
		ent_move (speed, nullvector);
		wait(1);
	}
	wait(2);
	ent_purge(me);
	ent_remove(me);
}

function shoot_acidball()
{
	wait(1);
	my.ammo -= 1;
	if (my.ammo == 0)
	{
		my.weapon_type = 0;
	}
	you = ent_create ("box.mdl", my.x, move_acidball);
	your.pan = my.pan;
	your.x = 0;
	your.y = 0;
	your.bounceCount = 10;
	your.forceFac = 10; //base_force
}

//////////////////////////////////////////////////////77

function explode_fireball()
{
	my.passable = on;
	anim_sprite();
	ent_playsound (me, explode_snd, 600);
}

function emit_fireparticle()
{
	my.part_timer = 0;
	while(game_status != stat_gameover)
	{
		my.part_timer += time;
		while (my.part_timer >= 1)
		{
			temp.x = cos(my.pan + 90);
			temp.y = sin(my.pan + 90);
			temp.z = 0;
			effect(xparticlef_event, 2, my.pos, temp);
			my.part_timer -= 1;
		}
		wait(1);
	}
}

function fireball_event()
{
	my.event = null;
	wait(1);
	tempent = ptr_for_handle(my.player_ref);
	if (vec_dist(tempent.x, my.x) > 60)
	{
		weapon_scan();
		you = ent_create("explo+9.pcx", my.x, explode_fireball);
	}
	my.removed = on;
}

function move_fireball()
{
	my.typ = item_fireball;
	init_item_stats(me);
	my.typ = weapon;
	my.narrow = off;
	my.fat = on;
//	my.typ = weapon;
	my.player_ref = handle(you);
	my.invisible = on;
	my.passable = on;
	wait (1);
	if (polyshadows > 1)
	{
		my.shadow = on;
	}
	my.x += your.x + 30 * cos(my.pan);
	my.y += your.y + 30 * sin(my.pan);
	my.z = your.z + 5;

	/* outside arena */
	if (abs(my.x) > 365 || abs(my.y) > 365)
	{
		wait(1);
		ent_remove(me);
		return;
	}

//	my.overlay = on;
//	my.bright = on;
	my.ambient = 100;
	my.event = fireball_event;
	my.enable_entity = on;
	my.enable_block = on;
	my.invisible = off;
	my.passable = off;
	emit_fireparticle();

	while (game_status != stat_gameover && my.removed == off)
	{
		my.forcex = 20;
		temp = min(time * 0.55, 1);
		my.speedx += (time * my.forcex) - (temp * my.speedx);
		speed.x = my.speedx * time;
		speed.y = 0;
		speed.z = 0;
		my.roll += 10 * time;
		ent_move (speed, nullvector);
		wait(1);
	}
	wait(2);
	ent_purge(me);
	ent_remove(me);
}

function shoot_fireball()
{
	wait(1);
	my.ammo -= 1;
	if (my.ammo == 0)
	{
		my.weapon_type = 0;
	}

	you = ent_create("box.mdl", my.x, move_fireball);
	your.pan = my.pan - 25;
	your.x = 20 * cos(my.pan - 90);
	your.y = 20 * sin(my.pan - 90);

	you = ent_create("box.mdl", my.x, move_fireball);
	your.pan = my.pan;
	your.x = 0;
	your.y = 0;

	you = ent_create("box.mdl", my.x, move_fireball);
	your.pan = my.pan + 25;
	your.x = 20 * cos(my.pan + 90);
	your.y = 20 * sin(my.pan + 90);
}

function weapon_scan()
{
	my_angle.pan = 360;
	my_angle.tilt = 360;
	my_angle.z = 60;
	scan_entity (my.pos, my_angle);
}