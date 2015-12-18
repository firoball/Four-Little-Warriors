///////////////////////////////////////////////////////////////////////////////////
// ~ 4 Little Warriors ~ Golem WDL
//
// Modified by Firoball  08/06/2007 (created 01/29/2005)
///////////////////////////////////////////////////////////////////////////////////

//////////Prototypes
function golem_loop();
function golem_move();
function golem_event();
function golem_hit();
function golem_die();
function golem_ko();
function golem_anim_hit();
function golem_attack();
function golem_lose();
function golem_turn();
function reset_golem();
function golem_effects();

//////////
function golem_loop()
{
	my.temp_pan = my.pan;
	while (game_status != stat_gameover && my.fPdead == off)
	{
//helper.x = my.pan;
//helper.y = my.temp_pan;
		golem_move();
		wait (1);
	}
	if (my.fPdead)
	{
		ent_remove(me);
	}
	else
	{
		golem_lose();
	}
}

function golem_move()
{
	my.health = min(my.health, my.maxhealth);
	
	if (visualFX != 0)
	{
		golem_effects();
	}

	if (my.fPreqReset)
	{
		reset_golem();
		my.fPreqReset = off;
		return;
	}
	if (my.mode == Pmode_lock)
	{
		my.temp_pan = my.pan;
	   	return;
	}
	if (my.fPreqTurn)	//triggered by event
	{
		my.mode = Pmode_turn;
		my.temp_pan = ang(my.pan + 180);
		my.fPreqTurn = off;
	}
	if (my.mode == Pmode_walk)
	{
		my.forcex = pforcex / 2;
		player_force();
		player_walk();
	}
	if (my.mode == Pmode_turn)
	{
		golem_turn();
	}
/* moved to golem event
		if (my.mode == Pmode_initHit)
		{
			golem_hit();
		}
*/
	if (my.mode == Pmode_hit)
	{
		golem_anim_hit();
	}
	if (my.mode == Pmode_attack)
	{
		golem_attack();
	}
	if (my.mode == Pmode_die)
	{
		golem_die();
	}
	if (my.mode == Pmode_ko)
	{
		golem_ko();
	}
}

function golem_event()
{
	if (my.mode == Pmode_lock) {return;}

	//golem has been attacked?
	if (event_type == event_scan)
	{
		if (scantype == box_scan) {return;}
		if (scantype == teleport_scan)
		{
			wait (1);
			my.forceX = 50;
			return;
		}
		wait (1);
//		if (my.mode == Pmode_lock) {return;} //check if golem mode changed after wait
		if (you == null || my.mode == Pmode_lock || my.mode == Pmode_die || my.mode == Pmode_hit || my.mode == Pmode_attack || my.mode == Pmode_turn)
		{
			return;
		}
		if (your.typ != plr && your.typ != explosion && your.typ != golem && your.typ != weapon)
		{
			return;
		}
		my.entity2 = you;
		trace_mode = activate_shoot + ignore_passents + ignore_passable + ignore_me;
		trace (my.x, your.x);
		if(you != null)
		{
			if (you == my.entity2)
			{
				golem_hit();
			}
		}
		my.entity2 = null;
		return;
	}

	if (event_type == event_block && my.mode != Pmode_turn)
	{
		my.fPreqTurn = on;
		return;
	}

	if (event_type == event_entity && my.mode != Pmode_turn)
	{
		if (your.typ == golem)
		{
			my.event = null;
			wait (1);
			if (my.mode == Pmode_lock) {return;} //check if golem mode changed after wait
			my.fPreqReset = on;
			return;
		}

		if (your.typ == weapon || your.typ == teleporter)
		{
			return;
		}

		if (your.typ != plr)
		{
			my.fPreqTurn = on;
			return;
		}
		else
		{
			if (your.mode != Pmode_walk) {return;}
			if (your.sfx == SFXinvul)
			{
				my.fPreqTurn = on;
				return;
			}
			vec_set (temp, your.x);
			vec_sub (temp, my.x);
			vec_to_angle (temp, temp);
			if (abs (ang(temp.pan - my.pan)) < 55)
			{
				my.mode = Pmode_attack;
				ent_playsound (me, golematk_snd, 600);
			}
		}
		return;
	}
/*
	if (event_type == event_trigger && you != null && my.mode != Pmode_turn)
	{
		if (your.typ == pathway)
		{
			my.mode = pMode_turn;
			my.temp_pan = your.pan;
			my.x = your.x;
			my.y = your.y;
		}
	}
*/
}

function golem_hit()
{
	if (your.typ != plr && your.typ != explosion && your.typ != weapon) {return;}

	my.mode = Pmode_hit;
	effect (Xhit_event, 15, my.pos, nullvector);
	my.anim_time = 0;

	temp = 1;
	if (your.typ == explosion)
	{
		temp = max (my.health / 2, 1);
	}
	if (your.typ == weapon)
	{
		temp = max (my.maxhealth / 2, 1);
	}
	if (your.typ == plr)
	{
		temp = your.attack_pow ;
	}
	my.health = max (my.health - temp, 0);
	my.ambient = min ((100 / my.maxhealth) * my.health, 100);

	if (my.health <= 0)
	{
		total_golems = max(total_golems - 1, 0); //security check
		if (your.typ == plr)
		{
			your.pow += my.maxhealth;
		}
		if (your.typ == weapon)
		{
			tempent = ptr_for_handle(your.player_ref);
			tempent.pow += my.maxhealth;
		}
		hide_item (me);
		my.event = null;
		my.mode = Pmode_die;
		my.passable = on;
		ent_playsound (me, golemdie_snd, 600);
	}
	else
	{
		ent_playsound (me, golem_snd, 600);
	}
}

function golem_die()
{
	my.anim_time += time;
	if (my.anim_time >= 30)
	{
		my.mode = Pmode_ko;
		my.alpha = 100;
		my.transparent = on;
		my.shadow = off;
		return;
	}
	temp = 100 * my.anim_time / 30;
	ent_frame(die_str, temp);
	player_anim_blend(temp, my.mode);
}

function golem_ko()
{
	if (my.alpha > 0)
	{
		my.alpha -= time + time;
	}
	else
	{
		delete_item (me);
		my.fPdead = on;
	}
}

function golem_anim_hit()
{
	my.anim_time += time;
	if (my.anim_time >= 15)
	{
		my.anim_time = 0;
		if (my.pan != my.temp_pan)
		{
			my.mode = Pmode_turn;
		}
		else
		{
			my.mode = Pmode_walk;
		}
		return;
	}
	temp = 100 * my.anim_time / 15;
	ent_frame (hit_str, temp);
	player_anim_blend(temp, my.mode);
}

function golem_attack()
{
	my.anim_time += time;
	if (my.anim_time > 10)
	{
		my.anim_time = 0;
		my.mode = Pmode_walk;
		my.fPattacked = off;
		return;
	}
	temp = 100 * my.anim_time / 10;
	ent_frame (attack_str, temp);
	player_anim_blend(temp, my.mode);

	if (temp >= 50 && my.fPattacked == off)
	{
		my.fPattacked = on; //golem already has attacked
		my.attack_pow = 3;

		my_pos.pan = 90;
		my_pos.tilt = 160;
		my_pos.Z = 100;
		result = 0;
		scan_entity (my.x, my_pos);
	}
}

function golem_lose()
{
	proc_kill(1);
	delete_item (me);
	my.event = null;
	my.mode = Pmode_lock;
	my.anim_time = 0;
	my.passable = on;
	while(me)
	{
		wait (1);
		my.anim_time += time;
		if (my.anim_time > 20)
		{
			my.anim_time -= 20;
		}
		temp = 100 * my.anim_time / 20;
		ent_cycle(lose_str, temp);
	}
}

function golem_turn()
{
	//adjust golem position to direction arrow
	if (my.fPturn)
	{
		tempent = my.entity1;
		my.x = tempent.x;
		my.y = tempent.y;
		my.fPturn = off;
	}
	temp = ang (my.temp_pan - my.pan);
	if (temp == 0)
	{
		my.temp_pan = my.pan;
		my.mode = pmode_walk;
		return;
	}

	my.forceX = 12;
	my.pan += sign(temp) * my.forceX * time;

	if ((ang (my.temp_pan - my.pan) >= 0 && temp < 0) || (ang (my.temp_pan - my.pan) <= 0 && temp > 0))
	{
		my.pan = my.temp_pan;
		my.mode = pmode_walk;
		return;
	}
}

define spawntime, skill1;
define occupied, flag1;
define downtime, skill12;

function reset_golem()
{
	my.mode = Pmode_lock;
	my.transparent = on;
	my.passable = on;
	my.event = null;
	hide_item (me);
	while(my.scale_x > 0.1)
	{
		wait (1);
		my.scale_x -= 0.2 * time;
		my.scale_y -= 0.2 * time;
	}
	my.scale_x = 0.1;
	my.scale_y = 0.1;
	my.shadow = off;
	my.invisible = on;
	tempent = ptr_for_handle(my.nestptr);
	my.pan = tempent.pan;
	my.temp_pan = my.pan;
	my.x = tempent.x + 50 * cos(my.pan);
	my.y = tempent.y + 50 * sin(my.pan);
	my.z = 150;
	trace_mode = ignore_me + ignore_you + ignore_passents + ignore_passable +
		ignore_sprites + ignore_models + activate_sonar;
	vec_set (temp,my.x);
	temp.z -= 300;
	trace (my.X, temp);
	my.z = target.z - my.min_z + 3;
	while(tempent.occupied)
	{
		wait (1);
		tempent = ptr_for_handle(my.nestptr);
	}
	my.invisible = off;
	tempent.occupied = on;
	if (polyshadows != 0)
	{
		my.shadow = on;
	}
	my.scale_x = 1;
	my.scale_y = 1;
	my.passable = off;
	my.transparent = off;
	my.event = golem_event;
	my.mode = Pmode_walk;
	show_item (me);
	wait (1);
	my.fat = off;
	my.narrow = on;
}

function golem_effects()
{
	//water ripple effect
	if ((my.z + my.min_z < water_height) && my.wtr_entity == 0)
	{
		my.wtr_entity = 1;
		ent_create("ripple+5.tga", my.x, water_ripple);
	}

	if ((my.z + my.min_z > water_height + 3) && my.wtr_entity == 1)
	{
		my.wtr_entity = 0;
	}

}
//////////Actions
action init_golem
{
	total_golems += 1;
	my.typ = golem;
	golement = me;
	my.scale_x = 1;
	my.scale_y = 1;
	wait (1);
	my.fat = off;
	my.narrow = on;
	my.anim_fac = 2.5;
	my.mode = Pmode_walk;
	my.oldMode = my.mode;
 	my.lastMode = my.mode;
	my.health = 7;
	my.maxhealth = 10;//my.health;
	my.enable_stuck = on;
	my.enable_scan = on;
	my.enable_entity = on;
	my.enable_block = on;
	my.event = golem_event;
	my.trigger_range = 17;
	my.ambient = 100;

	trace_mode = ignore_me + ignore_you + ignore_passents + ignore_passable +
		ignore_sprites + ignore_models + activate_sonar;
	vec_set (temp,my.x);
	temp.z -= 300;
	trace (my.X, temp);
	my.z = target.z - my.min_z; /*+ 3*/;
//create and animate golem when required for winning sequnce
	if (game_status == stat_gameover)
	{
		golem_lose();
		if (polyshadows != 0) {my.shadow = on;}
		else {drop_shadow();}
		return;
	}
	add_item (me);
	while (game_status != stat_running) {wait (1);}
//max_golems=1; //DEBUG
	golem_loop();
	if (polyshadows != 0) {my.shadow = on;}
	else {drop_shadow();}
}

// uses spawntime
action golem_nest
{
	if (polyshadows > 1)
	{
		my.shadow = on;
	}
	if (my.spawntime == 0)
	{
		my.spawntime = 80;
	}
	my.unlit = on;
	my.ambient = 50;
	my.string1 = "nest";
	load_model(my.string1, my.skill5, me);
	while (game_status != stat_running) {wait (1);}
	while (game_status != stat_gameover)
	{
		if (total_golems < max_golems && my.occupied == off)
		{
			wait (1);
			temp.x = my.x + 20 * cos (my.pan);
			temp.y = my.y + 20 * sin (my.pan);
			temp.z = my.z;
			you = ent_create ("golem.mdl", temp, init_golem);
			your.pan = my.pan;
			your.nestptr = handle(me);
			my.occupied = on;
		}
		if (my.occupied)
		{
			my.downtime = min (my.downtime + time, my.spawntime);
		}
		if (my.downtime == my.spawntime)
		{
			my.occupied = off;
			my.downtime = 0;
		}
		wait (1);
	}
}