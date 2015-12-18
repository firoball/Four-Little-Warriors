///////////////////////////////////////////////////////////////////////////////////
// ~ 4 Little Warriors ~ Item WDL
//
// Modified by Firoball  06/24/2007
///////////////////////////////////////////////////////////////////////////////////

//////////Prototypes
function Xhitswitch_event();
function Xstepswitch_event();

/////////Variables
var eventblock=0;
var itemlib[32];
var base_power = 1;
var total_pow = 0;
var speed;
var abspeed;

var telescan[5];
var scantype = standard_scan;	//type of scan
var teleangle;					//angle for player push - used by teleporter

string walk_str, "walk";

function init_item_stats(me);
function power_event();

string modelnr_str, "xx";
string mdl_str, ".mdl";
string wmb_str, ".wmb";
string modeltemp_str, "123456789012";

function load_model(basename_str, temp, modelent)
{
	str_cpy(modeltemp_str, basename_str);
	me = modelent;
	if (temp > 1 && temp <= 99)
	{
		str_for_num (modelnr_str, temp);
		str_cat (modeltemp_str, modelnr_str);
	}
	str_cat (modeltemp_str, mdl_str);
	ent_purge (me);
	ent_morph (me, modeltemp_str);
}

function load_entity(basename_str, temp, modelent)
{
	str_cpy (modeltemp_str, basename_str);
	me = modelent;
	if (temp > 1 && temp <= 99)
	{
		str_for_num (modelnr_str, temp);
		str_cat (modeltemp_str, modelnr_str);
	}
	str_cat (modeltemp_str, wmb_str);
	ent_purge (me);
	ent_morph (me, modeltemp_str);
}

function set_height()
{
	trace_mode = ignore_me + ignore_you + ignore_passents + ignore_passable + ignore_sprites + ignore_models + activate_sonar;
	vec_set (temp, my.x);
	temp.z -= 300;
	trace (my.x, temp);
	my.z = target.z - my.min_z;
}

define respawntime,skill1;
define powerlimit,skill2;
define dorespawn,flag1;
define starthidden,flag2;

// uses respawntime, powerlimit, dorespawn, starthidden
action power
{
	my.narrow = on;
	my.fat = off;
	my.enable_detect = on;
	my.enable_trigger = on;
	my.event = power_event;
	my.passable = on;
	my.trigger_range = 5;
	my.albedo = 15;
//	my.metal = on;
	my.pan = int (random (360));
	my.string1 = "power";

	load_model (my.string1, my.skill5, me);
	wait (1);
	set_height();

	if (polyshadows > 1)
	{
		my.shadow = on;
	}
	my.typ = item_pow;
	my.base_scale = 1;
	if (my.respawntime == 0)
	{
		my.respawntime = 128;
	}
	if (my.powerlimit == 0)
	{
		my.powerlimit = 10;
	}
	if (my.starthidden == on)
	{
		my.invisible = on;
		my.shadow = off;
	}

	if ((normal.x != 0) || (normal.y != 0))	//retrieved from set_height()
	{
		my.pan = 0;
		my.tilt = - asin (normal.x);
		my.roll = - asin (normal.y);
	}
	else
	{
		my.pan = 0;
		my.tilt = 0;
		my.roll = 0;
	}
	temp.pan = random (360);
	temp.tilt = 0;
	temp.roll = 0;
	ang_add (my.pan, temp);

	add_item(me);
	if (my.starthidden)
	{
		hide_item(me);
	}
	while (my.removed == off)
	{
		if (my.invisible == off)
		{
			total_pow += 1;
			if (polyshadows > 1)
			{
				my.shadow = on;
			}

			while (my.invisible == off && my.removed == off)
			{
				if (my.scale_x < max (1 , base_power))
				{
					my.scale_x = min (my.scale_x + time / 4, base_power);
				}
				else
				{
					my.scale_x=max(1,base_power);
				}
				my.scale_y = my.scale_x;
				my.scale_z = my.scale_x;
				my.ambient = abs (50 * sin(4 * timer)) + 30;
				wait (1);
			}
		}
		else
		{
			my.scale_x = 0.1;
			my.scale_y = 0.1;
			my.scale_z = 0.1;
			my.skill9 = (random (my.respawntime) + my.respawntime * 0.8);
			waitt (my.skill9);
			if (my.starthidden == off || total_pow < my.powerlimit)
			{
				my.invisible = off;
				show_item (me);
//								itemlist[my.slot_id+150]=1;
				ent_playsound (me, respawn_snd, 400);
				my.event = power_event;
//								set my.passable,off;
			}
		}
	}
	my.invisible = on;
	my.passable = on;
	my.event = null;
	my.shadow = off;
	delete_item (me);
	sleep (0.5);
	ent_remove (me);
}
function activate_magnet()
{
	my.transparent = on;
	my.ambient = 100;
	my.alpha = 80;
	my.bright = on;
	my.passable = on;
	vec_set (my.scale_x, your.scale_x);
//		my.entity2=your.entity1;
	you = your.entity1;	//player entity
	if (polyshadows > 1)
	{
		my.shadow = on;
	}
	while (my.invisible == off)
	{
		wait (1);
//		you=my.entity2;
		vec_set (temp, your.x);
		vec_sub (temp, my.x);
		vec_to_angle (my_angle, temp);
		my.speedx = 25 * cos(my_angle.pan) * cos(my_angle.tilt) * time;
		my.speedy = 25 * sin(my_angle.pan) * cos(my_angle.tilt) * time;
		my.speedz = 25 * sin(my_angle.tilt) * time;
		move_mode = ignore_you + ignore_passable + ignore_passents + ignore_maps + ignore_models + ignore_sprites;
		ent_move (nullvector, my.speedx);

		if (vec_length(temp) < 15)
		{
			my.invisible = on;
		}

	}
//		you=your.entity1;
//	you=my.entity2;
	ent_playsound (me, collect_snd, 600);
	your.pow += base_power;
	sleep (1);
	ent_purge(me);
	ent_remove(me);
}

string power_str[12];
function power_event()
{
	if (my.scale_x < 1) {return;}
	if (your.typ == plr || your.typ == golem || your.typ == box)
	{
		my.event = null;
		your.pow += base_power;
		total_pow -= 1;

		if (your.typ == plr && your.sfx == SFXmagnet)
		{
			my.entity1 = you;
//						your.pow+=base_power;
			wait (1);
			str_for_entfile (power_str, me);
			you = ent_create (power_str, my.x, activate_magnet);
		}
		if (your.typ == golem || (your.typ == plr && your.sfx != SFXmagnet))
		{
			ent_playsound (me, collect_snd, 600);
			effect(power_particle, 20, my.x, nullvector);
		}
		if (my.dorespawn == off && my.starthidden == off)
		{
			wait (4);
			my.removed = on;
		}
		else
		{
			hide_item (me);
			my.invisible = on;
			my.shadow = off;
		}
	}
}


///////////////////////////////////////////////////////////////////////////////////

//define respawntime, skill1;
define spawndelay, skill2;
define boxcontent, skill7;
//define dorespawn, flag1;

function itembox_event();

// uses respawntime, boxcontent, dorespawn, spawndelay;
action itembox
{
	my.string1 = "box";
	my.string2 = "dmgbox";
	my.spawndelay *= 16;
	my.invisible = on;
	my.passable = on;
	while (my.spawndelay > 0)
	{
		my.spawndelay -= time;
		wait (1);
	}
	load_model (my.string1, my.skill5, me);
	wait (1);
	if (polyshadows > 1) {my.shadow = on;}
	my.fat = off;
	my.narrow = on;
	my.invisible = off;
	my.passable = off;
	my.enable_impact = on;
	my.enable_push = on;
	my.enable_stuck = on;
	my.enable_entity = on;
	my.enable_scan = on;
	my.event = itembox_event;
	set_height();
	vec_set (my.posX, my.x);
	my.typ = box;
	my.trigger_range = 7;
	add_item (me);
	if (my.respawntime == 0) {my.respawntime = 20;}
	while (my.removed == off)
	{
		if (my.abspeedX != 0 || my.abspeedY != 0 || my.pushvecX != 0 || my.pushvecY != 0 || my.passable == off)
		{
			itembox_move();
		}
		wait (1);
	}
	my.invisible = on;
	my.passable = on;
	my.event = null;
	delete_item (me);
	sleep (0.25);
	ent_remove (me);
}

function anim_sprite()
{
	my.invisible = on;
	wait (1);
	my.ambient = 100;
	my.near = on;
	my.facing = on;
	my.bright = on;
	my.flare = on;

	my.invisible = off;
	if (my.lightred == 0)
	{
		my.lightred = 239;
		my.lightgreen = 177;
		my.lightblue = 16;
		my.lightrange = 100;
	}
	if (my.skill1 == 0) {my.skill1 = 9;}
	if (my.skill2 == 0) {my.skill2 = 1;}
	while (my.frame < my.skill1)
	{
		wait (1);
		my.frame += time * my.skill2;
		my.lightrange = max (my.lightrange - 5 * time, 0);
	}
	wait (1);
//		ent_purge(me);
	ent_remove(me);
}

function set_gravity()
{
		my.typ = your.contain;
		item();
		while (my.z > my.gravityZ)
		{
				wait (1);
				my.forceZ = -3;
				temp = min(time * 0.6, 1);
				my.speedZ += (time * my.forceZ) - (temp * my.speedZ);
				speed.X = 0;
				speed.Y = 0;
				speed.Z = my.speedZ * time;
				you = null;
				ent_move(nullvector, speed);
		}
		my.z = my.gravityZ;
}

function itembox_pushed(pushforce)
{
//	if (your.typ == player)
//	{
	if (scantype == teleport_scan)
	{
		pushforce *= 2;
		vec_set (my_angle, vector(teleangle, 0, 0));
	}
	else
	{
		vec_set (temp, my.x);
		vec_sub (temp, your.x);
		vec_to_angle (my_angle, temp);
	}
	my.pushvecX = pushforce * cos (my_angle.pan);
	my.pushvecY = pushforce * sin (my_angle.pan);
	my.pushvecZ = 0;
//	}
}

function itembox_move()
{
	if (my.z + my.min_z < ice_height + 5)
	{
		temp = min(time * 0.1, 1);
	}
	else
	{
		temp = min(time * 0.55, 1);
	}

	my.abspeedX += (time * my.pushvecX) - (temp * my.abspeedX);
	my.abspeedY += (time * my.pushvecY) - (temp * my.abspeedY);
	abspeed.x = my.abspeedx * time;
	abspeed.y = my.abspeedy * time;
	abspeed.z = 0;
	vec_set(my.pushvec, nullvector);

	you = null;
	move_mode = ignore_me + ignore_passents + ignore_passable + activate_trigger + glide;
	ent_move (nullvector, abspeed);

	trace_mode = ignore_me + ignore_you + ignore_passents + ignore_passable + ignore_sprites + ignore_models + activate_sonar + use_box;
	vec_set (temp, my.x);
	temp.z -= 300;
	trace (my.x, temp);
	my.z = target.z - my.min_z;

	if (my.abspeedX < 0.1 && my.abspeedX != 0 && my.abspeedX > -0.1 &&
	my.abspeedY < 0.1 && my.abspeedY != 0 && my.abspeedY > -0.1)
	{
		my.abspeedX = 0;
		my.abspeedY = 0;
	}
	if ((normal.x != 0) || (normal.y != 0))
	{
		vec_set (temp, nullvector);
		temp.pan = -my.pan;
		vec_rotate (normal, temp);
		my.tilt = -asin (normal.x);
		my.roll = -asin (normal.y);
	}
	else
	{
		my.tilt = 0;
		my.roll = 0;
	}
	//update itemlist
//	itemlist[my.slot_id] = my.x;
//	itemlist[my.slot_id + 50] = my.y;
//	itemlist[my.slot_id + 100] = my.z;
	wait(1);
}

function itembox_event()
{
	if (event_type==event_scan)
	{
		if (scantype == box_scan) {return;}
		if (scantype == teleport_scan)
		{
			itembox_pushed (PforceTele);
			return;
		}
		my.event = null;
		wait (1);
		my.event = itembox_event;
		if (you != null)
		{
			trace_mode = ignore_me + ignore_passents + activate_shoot;
			trace (my.x, your.x);
		}
		else
		{
			return;
		}
		if(you != null)
		{
			if (your.typ!=plr && your.typ!=explosion && your.typ != weapon) {return;}
//			wait (1);
			load_model(my.string2, my.skill5, me);
			my.passable = on;
			my.abspeedX = 0;
			my.abspeedY = 0;
			ent_playsound(me, box_snd, 600);
			you = ent_create ("smoke+15.pcx", my.x, anim_sprite);
			your.skill1 = 15;
			your.skill2 = 1.5;
			your.scale_x = 1.3;
			your.scale_y = 1.3;
			your.lightred = 2;

			vec_set(temp,my.x);
			temp.z += 150;
			you = ent_create ("box.mdl", temp, set_gravity);
			effect(xhit_event, 15, my.pos, nullvector);
			vec_set (your.skill46, my.x);
			your.skill48 += 25;
			my.event = null;
			my.enable_scan = 0;
			hide_item (me);
			wait (1);
			my.fat = off;
			my.narrow = on;

			sleep(1);
			my.transparent = on;
			my.shadow = 0;
			while (my.alpha > 0)
			{
				wait (1);
				my.alpha -= 3 * time;
			}
			if (my.dorespawn == 0)
			{
				my.removed = on;
				return;
			}
			else
			{
				my.invisible = on;
				my.tilt = 0;
				my.roll = 0;
				vec_set (my.x, my.posx);
				my.skill9 = random(my.skill1 / 2) + my.skill1 * 0.8;
				sleep (my.skill9);

				//spawn place occupied?
check_spawnplace:
				scantype = box_scan;

				my_pos.pan = 360;
				my_pos.tilt = 360;
				my_pos.Z = 30;

				scan_entity (my.x, my_pos);
				scantype = standard_scan;
				if (you != null)
				{
					sleep (1);
					goto check_spawnplace;
				}
				ent_playsound(me, respawn_snd, 400);
				load_model(my.string1, my.skill5, me);
				my.alpha = 100;
				my.passable = off;
				my.transparent = off;
				my.invisible = off;
				if (polyshadows > 1)
				{
					my.shadow = on;
				}
//				itemlist[my.slot_id+150]=1;
				show_item (me);
				wait (1);
				my.enable_scan = on;
				my.event = itembox_event;
				set_height();
				my.forcex = 0;
				my.forcey = 0;
				my.forcez = 0;
				if ((normal.x != 0) || (normal.y != 0))
				{
					vec_set(temp,nullvector);
					temp.pan = -my.pan;
					vec_rotate(normal,temp);
					my.tilt = -asin(normal.x);
					my.roll = -asin(normal.y);
				}
				else
				{
					my.tilt = 0;
					my.roll = 0;
				}
			}

		}
		return;
	}

	if (event_type == event_stuck || event_type == event_entity || event_type == event_push)
	{
		my.pushvecX = 0;
		my.pushvecY = 0;
		my.abspeedX = 0;
		my.abspeedX = 0;
		return;
	}

	if (event_type == event_impact)
	{
//		if (your.typ != player) {return;}
		itembox_pushed(PforcePushBox);
	}
}

////////////////////////////////////////////////////////////////

function spathway_event()
{
	wait (1);
	if (you == null) {return;}
	if (your.typ == golem && your.pan != my.pan && your.mode != Pmode_turn)
	{
		your.mode = Pmode_turn;
		your.entity1 = me;
		your.fPturn = on;
		your.temp_pan = my.pan;
//		your.x = my.x;
//		your.y = my.y;
//			your.entity1=me;	//?
	}
}

action spathway
{
	my.typ=pathway;
//	my.nofilter=1;
	my.oriented=1;
	ent_alphaset(1,30);
	my.enable_trigger=1;
	my.trigger_range=1;
	my.event=spathway_event;
	my.tilt=270;
	my.roll=0;
	my.passable=1;
}

function explosion_scan()
{
	my.counter = 0;
	while (my.scale_x < 3)
	{
		my.counter += 3 * time;
		while (my.counter >= 5)
		{
			my.narrow = off;
			my.fat = on;
			my_angle.pan = 360;
			my_angle.tilt = 360;
			my_angle.z = my.max_x*5;//2*sqrt(my.max_x*my.max_x+my.max_y*my.max_y);
			temp.pan = 0;
			temp.tilt = 0;
			temp.roll = 0;
			c_scan(my.x, temp, my_angle, SCAN_ENTS | IGNORE_ME);
			my.counter -= 3;
		}
		wait (1);
	}
}

function create_explosion()
{
	my.transparent = on;
	my.bright = on;
	my.trigger_range = 70;
	my.frame = 2;
	my.scale_x = 0.1;
	my.scale_y = 0.1;
	my.scale_z = 0.1;
	my.lightred = 239;
	my.lightgreen = 177;
	my.lightblue = 16;
	my.lightrange = 0;
	my.alpha = 90;
	my.ambient = 100;
	my.typ = explosion;
	set_height();
	wait (1);
	ent_playsound (me, explode_snd, 600);
	explosion_scan();
	while (my.scale_x < 3)
	{
		my.fat = off;
		my.narrow = on;
		wait (1);
		my.scale_x += 0.2 * time / fac_speed;
		my.scale_y += 0.2 * time / fac_speed;
		my.scale_z += 0.2 * time / fac_speed;
		my.pan += 4 * time * (3.1 - my.scale_x) * 5;
		my.lightrange = 60 * my.scale_x;
		my.alpha -= 3.5 * time;
		set_height();
	}
	my.scale_x = 3;
	my.scale_y = 3;
	my.scale_z = 3;

	while (my.alpha>0)
	{
		wait (1);
		my.alpha -= 5 * time;
	}
	wait (1);
	ent_purge(me);
	ent_remove(me);
}
///////////////////////////////////////////////////////////////////////////////////

function set_magnet()
{
//	my.invisible=1;
	my.unlit = on;
	my.bright = on;
	my.passable = on;
	my.oriented = on;
	my.nofilter = on;
	my.ambient = 100;
	my.tilt = -90;
//		wait (1);
	proc_late();
//	my.invisible=0;
	while (game_status != stat_gameover && your.sfx == SFXmagnet)
	{
		vec_set (my.x, your.x);
		my.z = your.z + 17 * sin (timer * 12 + my.skill10 * 180);
		my.roll += 10 * time;
		my.scale_x = 0.8 - abs (0.2 * sin (timer * 12 + my.skill10 * 180));
		my.scale_y = 0.8 - abs (0.2 * sin (timer * 12 + my.skill10 * 180));
		wait (1);
	}
	ent_purge(me);
	ent_remove(me);
}


function magnet_event()
{
	ent_playsound (me, powerup_snd, 600);
	my.sfx = SFXmagnet;
	you = ent_create("bluering.pcx", my.x, set_magnet);
	you = ent_create("redring.pcx", my.x, set_magnet);
	your.skill10 = 1;
	my.counter = (random (5) + 10) * 16;
	my.trigger_range = PtrigMagnet;
	while (my.counter > 0 && game_status != stat_gameover && my.sfx == SFXmagnet)
	{
		my.counter -= time;
		wait (1);
	}
	sleep (0.25);
	my.trigger_range = PtrigRange;
	if (my.sfx == SFXmagnet) {my.sfx = SFXnone;}
}

function ghost_event()
{

	ent_playsound (me, powerup_snd, 600);
	my.sfx = SFXghost;
	my.counter = (random (5) + 10) * 16;
	my.flare = on;
	my.shadow = off;
	while (my.counter > 0 && game_status != stat_gameover && my.sfx == SFXghost)
	{
		my.counter -= time;
		my.flare = (my.mode != Pmode_lock);
		if (my.flare)
		{
			my.alpha = 15 * abs (sin (timer * 4)) + 5;
		}
		wait (1);
	}
	if (polyshadows != 0)
	{
		my.shadow = on;
	}
	ent_playsound (me, powerend_snd, 600);
//	sleep (0.25);
	if (my.sfx == SFXghost) {my.sfx = SFXnone;}
	my.alpha = 50;
	my.flare = off;
}

function invul_event()
{
	my.ambient = 60;
	my.unlit = on;
	my.flare = on;
	my.passable = on;
	my.bright = on;
	my.anim_fac = 10;

	my.sndhandle = snd_loop (invul_snd, 35, 0);
	your.sfx = SFXinvul;
	proc_late();
	my.counter = (random (5) + 15) * 16;
	while (my.counter > 0 && game_status !=stat_gameover && your.sfx == SFXinvul)
	{
		vec_set (my.x, your.x);
		my.pan += 15 * time;
		my.anim_dist += time;
		if (my.anim_dist > my.anim_fac)
		{
			my.anim_dist -= my.anim_fac;
		}
		temp = 100 * my.anim_dist / my.anim_fac;

		ent_cycle (walk_str, temp);
		my.counter -= time;
		wait (1);
	}
	snd_stop (my.sndhandle);
	my.invisible = on;
	if (your.sfx == SFXinvul) {your.sfx = SFXnone;}
	wait (1);
	ent_purge(me);
	ent_remove(me);
}


function item_event()
{
	if (you == null) {return;}
	if (your.typ != plr) {return;}
	if (your.sfx == my.typ || your.mode == Pmode_ko) {return;}

	my.enable_trigger = off;
	my.invisible = on;
	my.passable = on;
	my.removed = on;
	effect (item_particle, 20, my.x, nullvector);

//player items
	if (my.typ == item_magnet || my.typ == item_ghost || my.typ == item_shield)
	{
		your.fPevent = on;
		your.sfx = my.typ + SFXprepare;
	}

//event items
	if (my.typ == item_highspeed)
	{
		event_ptr = you;
		event_trig = Ehighspeed;
		return;
	}
	if (my.typ == item_slowmotion)
	{
		event_ptr = you;
		event_trig = Eslowmotion;
		return;
	}
	if (my.typ == item_position)
	{
		event_ptr = you;
		event_trig = Eposition;
		return;
	}
	if (my.typ == item_rotate)
	{
		event_ptr = you;
		event_trig = Erotation;
		return;
	}
	if (my.typ == item_equalize)
	{
		event_ptr = you;
		event_trig = Eequalize;
		return;
	}
	if (my.typ == item_monopoly)
	{
		event_ptr = you;
		event_trig = Emonopoly;
		return;
	}
	if (my.typ == item_upsidedown)
	{
		event_ptr = you;
		event_trig = Eupsidedown;
		return;
	}
	if (my.typ == item_superpower)
	{
		event_ptr = you;
		event_trig = Esuperpower;
		return;
	}
	if (my.typ == item_mine)
	{
		wait(1);
		you = ent_create ("explode.mdl", my.x, create_explosion);
	}
	if (my.typ == item_fireball)
	{
		temp = 10 + int(random(3));
		if (your.ammo < temp || your.weapon_type != 1)
		{
			your.ammo = temp;
		}
		your.weapon_type = 1;
	}
	if (my.typ == item_acidball)
	{
		temp = 10 + int(random(3));
		if (your.ammo < temp || your.weapon_type != 2)
		{
			your.ammo=temp;
		}
		your.weapon_type = 2;
	}
	if (my.typ == item_lightning)
	{
		temp = 10 + int(random(3));
		if (your.ammo < temp || your.weapon_type != 3)
		{
			your.ammo=temp;
		}
		your.weapon_type = 3;
	}

	ent_playsound (me, item_snd, 600);
}

define busy, flag8;
define XTargetPos, skill1;
define YTargetPos, skill2;
define ZTargetPos, skill3;
define TargetAngle, skill4;

function Xteleport_event()
{
	//golems are reset if teleporter is busy
	if (my.busy && your.typ == golem)
	{
		your.fPreqReset = on;
		return;
	}
	if (my.busy) {return;} //already teleporting, teleporter locked

	my.busy = on;
	hide_item(me);
	if (your.typ == plr)
	{
		teledelay += 1;
	}
	wait (1);
	your.shadow = off;
	ent_playsound(me, tele1_snd, 600);
	your.flare = off;
	your.transparent = on;
	my.tempScale = your.scale_z;
	my.tempMode = your.mode;
	your.mode = Pmode_lock;
 	your.alpha = 50;
	wait (1);
	while (your.scale_z < 20)
	{
		wait (1);
		your.scale_z += 2 * time;
		your.alpha -= 5 * time;
	}
	your.scale_z = 20;
	your.alpha = 0;

	//avoid telefragging - push away objects
	scantype = teleport_scan;
	teleangle = my.TargetAngle;
	vec_set (telescan[0], my.XTargetPos);
	telescan[3] = 0;
	telescan[4] = 0;

	my_pos.pan = 360;
	my_pos.tilt = 360;
	my_pos.Z = 40;

	if (game_status != stat_gameover)
	{
		scan_entity (telescan, my_pos);
		scantype = standard_scan;
		wait (1);

		vec_set (your.x, my.XTargetPos);
		your.pan = my.TargetAngle;
	}
	ent_playsound(you, tele2_snd, 600);

	while (your.scale_z > my.tempScale)
	{
		wait (1);
		your.scale_z -= 2 * time;
		your.alpha += 5 * time;
	}
	your.alpha = 50;
//	your.z = my.ZTargetPos;
	your.scale_z = my.tempScale;
	your.mode = my.tempMode;
	your.transparent = off;
	if (your.sfx == SFXghost) {your.flare = on;}
	if (polyshadows != 0) {your.shadow = on;}
	if (your.typ == plr) {teledelay -= 1;}
	my.busy = off;
	show_item(me);
	player_fixZ(you);
	wait (1);
	your.fat = off;
	your.narrow = on;

	//dirty hack
	if (game_status == stat_gameover)
	{
		my.event = null;
	}

}

// uses XTargetPos, YTargetPos, ZTargetPos, TargetAngle
action Xteleport
{
	my.string1 = "beams";
	load_entity(my.string1, my.skill5, me);
	my.event = Xteleport_event;
	my.enable_sonar = on;
	my.typ = teleporter;
	my.part_timer = 0;
	my.fat = off;
	my.narrow = on;
	wait (1);	//make sure teleporter is added at end of item list
	add_item(me);
	while (camera.fog <= 10 || game_status != stat_gameover)
	{
		my.part_timer += time;
		while (my.part_timer >= 3)
		{
			my.lightrange = 50 + random(20);
			my.lightred = 32 + random(20);
			my.lightgreen = 140 + random(8) + random(12);
			my.lightblue = 86 + random(5) + random(15);
			effect(xteleport_particle, 3, my.x, nullvector);
			my.part_timer -= 3;
		}
		wait (1);
	}
	my.event = null;
	delete_item(me);
}

define dohighspeed,flag1;
define doslowmotion,flag2;
define doposition,flag3;
define dorotation,flag4;
define domonopoly,flag5;
define doequalize,flag6;
define doupsidedown,flag7;
define dosuperpower,flag8;

// uses dohighspeed, doslowmotion, doposition, dorotation, domonopoly, doequalize, doupsidedown, dosuperpower
action Xhitswitch
{
	my.string1 = "switch";
	load_entity(my.string1, my.skill5, me);
	wait (1);
	my.enable_scan = on;
	my.event = xhitswitch_event;
	trace_mode = ignore_me + ignore_you + ignore_passents + ignore_passable + ignore_sprites + ignore_models + use_box;
	vec_set (temp, my.x);
	temp.z -= 300;
	trace (my.x, temp);
	my.z = target.z;
	my.angTilt = my.tilt;
	my.tilt += 10;
	while(me)
	{
		my.ambient = 30 + 70 * sin(timer * 10);
		wait (1);
	}
}

function Xhitswitch_event()
{
	if (event_type == event_scan && (your.typ == plr || your.typ == golem))
	{
		if(you != null && scantype == standard_scan)
		{
			wait (1);
			if (your.typ != plr && your.typ != golem && your.typ != weapon)
			{
				return;
			}
			my.event = null;
			my.entity2 = you;
			trace_mode = activate_shoot + ignore_passents + ignore_passable + ignore_me;
			trace (my.x, your.x);

			if (you != null)
			{
				if (you == my.entity2)
				{
					my.enable_scan = off;
					sleep (0.5);
					ent_playsound(me, stepswitch_snd, 1000);
					while (my.tilt > my.angTilt - 10)
					{
						my.tilt -= time;
						my.tilt = max(my.tilt, my.angTilt - 10);
						wait (1);
					}
					sleep (0.5);
					while (eventblock!=0)
					{
						wait (1);
					}
					event_trig = int(random(8)) + 1;
					while (
								(event_trig == Ehighspeed && my.DoHighspeed == off)
							||  (event_trig == Eslowmotion && my.DoSlowmotion == off)
							||  (event_trig == Eposition && my.DoPosition == off)
							||  (event_trig == Erotation && my.DoRotation == off)
							||  (event_trig == Emonopoly && my.DoMonopoly == off)
							||  (event_trig == Eequalize && my.DoEqualize == off)
							||  (event_trig == Eupsidedown && my.DoUpsidedown == off)
							||  (event_trig == Esuperpower && my.DoSuperpower == off)
						  )
					{
						event_trig = int(random(8)) + 1;
					}
					event_ptr = you;

					sleep (1);
					while (my.tilt < my.angTilt + 10)
					{
						my.tilt += time;
						my.tilt = min(my.tilt, my.angTilt + 10);
						wait (1);
					}
					sleep (3);
					my.enable_scan = on;
				}
			}
			my.entity2 = null;
			my.event = Xhitswitch_event;
		}
	}
}

// uses dohighspeed, doslowmotion, doposition, dorotation, domonopoly, doequalize, doupsidedown, dosuperpower
action Xstepswitch
{
	my.string1 = "stepA";
//		my.string2="stepB";
	load_entity(my.string1, my.skill5, me);
	wait (1);
	my.enable_sonar = on;
	my.event = xstepswitch_event;
	trace_mode = ignore_me + ignore_you + ignore_passents + ignore_passable + ignore_sprites + ignore_models + use_box;
	vec_set (temp, my.x);
	temp.z -= 300;
	trace (my.x, temp);
	my.z = target.z;
	my.posz = my.z;
	while(me)
	{
		my.ambient = 30 + 70 * sin(timer * 10);
		wait (1);
	}
}

function Xstepswitch_event()
{
	if (event_type == event_sonar && (your.typ == plr || your.typ == golem))// && eventblock == 0)
	{
		my.event = null;
		my.enable_sonar = off;
		sleep (0.5);
//		load_entity(my.string2, my.skill5, me);
//		wait (1);
		ent_playsound(me, stepswitch_snd, 1000);
		while (my.z > my.posZ - 6)
		{
			my.z -= time;
			my.z = max(my.z, my.posZ - 6);
			wait (1);
		}
		sleep (0.5);
		while (eventblock!=0)
		{
			wait (1);
		}
		event_trig = int(random(8)) + 1;
		while (
					(event_trig == Ehighspeed && my.DoHighspeed == off)
				||  (event_trig == Eslowmotion && my.DoSlowmotion == off)
				||  (event_trig == Eposition && my.DoPosition == off)
				||  (event_trig == Erotation && my.DoRotation == off)
				||  (event_trig == Emonopoly && my.DoMonopoly == off)
				||  (event_trig == Eequalize && my.DoEqualize == off)
				||  (event_trig == Eupsidedown && my.DoUpsidedown == off)
				||  (event_trig == Esuperpower && my.DoSuperpower == off)
			  )
		{
			event_trig = int(random(8)) + 1;
		}
		event_ptr = you;

		sleep (1);
	//	load_entity(my.string1,my.skill5,me);
	//	wait (1);
		while (my.z < my.posz)
		{
			my.z += time;
			my.z = min(my.z, my.posz);
			wait (1);
		}
		sleep (3);
		my.enable_sonar = on;
		my.event = Xstepswitch_event;
	}
}

/////////////////////////////////////////////////////////
var max_items = 26; //highest item.typ value

function item()
{
	my.base_scale = 1;
	my.enable_trigger = on;
	my.trigger_range = ItrigRange;
	my.passable = on;
	my.unlit = on;
//	my.metal = on;
//	my.bright = on;
	if (polyshadows>1)
	{
			my.shadow = on;
	}
	if (my.typ == none)
	{
		my.typ = int (random(15));
		while (itemlib[my.typ] != 0)
 		{
			my.typ = int (random(15));
		}
		my.typ += 12;
	}
	my.typ = min (max_items, my.typ);
	my.typ = max (12, my.typ);

	add_item(me);
	init_item_stats(me);

	my.transparent = off;
	my.flare = off;

	my.event = item_event;
	my.ambient = 100;
	my.tilt = 0;
	my.counter = 10 * 16;
	while (my.invisible == off && my.counter > 0 && game_status!=stat_gameover && my.removed == off)
	{
		my.counter -= time;
		my.pan = 180 * sin (3 * timer);
		my.tilt = 50 * sin (10 * timer);
		my.roll = 10 * sin (5 * timer);
		if (my.typ != 23)
		{
			my.scale_x = my.base_scale + 0.2 * sin (5 * timer);
			my.scale_y = my.base_scale + 0.2 * cos (5 * timer);
		}
		wait (1);
	}
	if (my.removed == off)
	{
		my.alpha = 100;
		my.transparent = on;
		while(my.alpha > 0)
		{
			wait (1);
			my.alpha -= time * 6;
		}
		my.alpha = 0;
	}
	my.event = null;
	my.invisible = on;
	my.passable = on;
	my.shadow = off;
	my.event = null;
	delete_item (me);
	sleep (1);
	ent_remove (me);
}

//////////Disable Item appearance via WED//////////

function itemswitch()
{
	itemlib[my.skill8] = my.flag1;
	itemlib[1 + my.skill8] = my.flag2;
	itemlib[2 + my.skill8] = my.flag3;
	itemlib[3 + my.skill8] = my.flag4;
	itemlib[4 + my.skill8] = my.flag5;
	itemlib[5 + my.skill8] = my.flag6;
	itemlib[6 + my.skill8] = my.flag7;
	itemlib[7 + my.skill8] = my.flag8;
}

define NoMagnet, flag1;
define NoCape, flag2;
define NoShield, flag3;
define NoHighspeed, flag4;
define NoSlowmotion, flag5;
define NoPosition, flag6;
define NoRotation, flag7;
define NoMonopoly, flag8;

//uses: NoMagnet, NoCape, NoShield, NoHighspeed, NoSlowmotion, NoPosition, NoRotation, NoMonopoly
action itemswitch_1
{
	my.invisible = on;
	my.skill8 = 0;
	itemswitch();
	wait (1);
	ent_purge (me);
	ent_remove (me);
}

define NoEqualize, flag1;
define NoUpsidedown, flag2;
define NoSuperpower, flag3;
define NoMine, flag4;
define NoFireball, flag5;
define NoAcidball, flag6;
define NoLightning, flag7;

//uses: NoEqualize, NoUpsidedown, NoSuperpower, NoMine, NoFireball, NoAcidball, NoLightning
action itemswitch_2
{
	my.invisible = on;
	my.skill8 = 8;
	itemswitch();
	wait (1);
	ent_purge (me);
	ent_remove (me);
}

action Xobstacle
{
	my.typ = obstacle;
}