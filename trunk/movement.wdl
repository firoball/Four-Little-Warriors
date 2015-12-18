///////////////////////////////////////////////////////////////////////////////////
// ~ 4 Little Warriors ~ Movement WDL
//
// Modified by Firoball  04/23/2007
///////////////////////////////////////////////////////////////////////////////////

//////////Prototypes
//function calc_dist(&my_pos,&my_angle,&temp2); //not used (yet?)
function playerFX_sta();
function playerFX_speed();
function playerFX_slow();
function playerFX_block();
function player_mark();
function particle_flash();
function water_ripple();
function vertex_attach();
function set_rank();
function player_move();
function player_force();
function player_effects();
function player_invul();
function player_block();
function player_walk();
function player_charge();
function player_attack();
function player_hit();
function player_ko();
function player_anim_hit();
function player_anim_critHit();
function player_pushed(pushforce);
function player_anim_blend(anim_frame, override);
function player_item_event();
function player_event();
function player_fixZ(ent);
function move_shadow();
function drop_shadow();

//////////Variables
var rot_pow = 0;
var field;
//var my_height;
var events = 0;
var players;


//////////Sounds
sound tap_snd = "tap.wav";
sound attack_snd = "attack.wav";
sound sp_attack_snd = "sattack.wav";
sound ouch_snd = "ouchnew.wav";
sound crithit_snd = "crithit.wav";
sound block_snd = "block.wav";
sound blockact_snd = "blockact.wav";
sound stamina_snd = "stamina.wav";
sound weapon_snd = "weapon.wav";
//////////Strings
string wait_str, "wait";
string walk_str, "walk";
string charge_str, "charge";
string attack_str, "attack";
string hit_str, "hit";
string die_str, "die";
string victory_str, "victory";
string lose_str, "lose";
string guard_str, "guard";

text player_anim_txt
{
	strings 10;
	string walk_str, charge_str, attack_str, "", hit_str, hit_str, wait_str, "", hit_str, die_str;
}

//////////Functions
/*
function calc_dist(&my_pos,&my_angle,&temp2)
{
	//my_pos=movement distance
	//my_angle=new player position
	//temp2=target position
	vec_set (temp,my_angle);
	vec_sub (temp,my_pos); //get old position
	if(vec_length(my_pos)==0)
	{
		return (0);
	}
	temp3=(my_pos[0]*(temp2[0]-temp.x)+my_pos[1]*(temp2[1]-temp.y)+my_pos[2]*(temp2[2]-temp.z))
		/ (my_pos[0]*my_pos[0]+my_pos[1]*my_pos[1]+my_pos[2]*my_pos[2]); // Calculate Multiplier
	vec_scale(my_pos,temp3);
	vec_add(my_pos,temp);
	temp3=vec_dist(my_pos,temp2);
	return (temp3);
}
*/

function playerFX_sta()
{
	my.skin = your.skin;
	my.frame = your.frame;
	my.pan = your.pan;
	my.scale_z = your.scale_z;
	my.ambient = 100;
	my.unlit = 1;
	my.alpha = 50;
	my.transparent = on;
	my.passable = on;
	while(my.alpha > 0)
	{
		wait (1);
		my.alpha -= 5 * time;
		my.scale_x += 0.1 * time;
		my.scale_y += 0.1 * time;
		my.scale_z += 0.1 * time;
		vec_set (my.x, your.x);
		my.next_frame = your.next_frame;
		my.frame = your.frame;
		my.pan = your.pan;
	}
	my.alpha = 0;
	ent_remove(me);
}

function playerFX_speed()
{
	my.skin = your.skin;
	my.frame = your.frame;
	my.pan = your.pan;
	my.scale_z = your.scale_z;
	my.ambient = 100;
	my.unlit = 1;
	my.alpha = 50;
	my.transparent = on;
	my.passable = on;
	while(my.alpha > 0)
	{
		wait (1);
		my.alpha -= 14 * time;
	}
	my.alpha = 0;
	ent_remove(me);
}

function playerFX_slow()
{
	my.passable = on;
	my.oriented = on;
//	my.nofilter = on;
	my.bright = 1;
	my.flare = on;
	my.ambient = 100;
	my.tilt = -90;
	my.x = your.x;
	my.y = your.y;
	my.z = your.z + your.min_z + 10;
	my.lightred=0;
	my.lightgreen=50;
	my.lightblue=180;
	my.lightrange=40;
	proc_late();
	while (base_speed < orig_speed && game_status != stat_gameover)
	{
		my.x=your.x;
		my.y=your.y;
		my.z=your.z + your.min_z + 10;
		my.pan += 3 * time;
		my.scale_x = 0.8 + 0.2 * sin(15 * total_ticks);
		my.scale_y = 0.8 + 0.2 * cos(15 * total_ticks);
		my.invisible = (your.mode == Pmode_ko);
		wait(1);
	}
	ent_purge(me);
	ent_remove(me);
}

function playerFX_block()
{
	my.unlit = on;
	my.flare = on;
	my.passable = on;
	my.bright = on;
	my.ambient = 100;
	my.alpha = 50;
	ent_playsound (me, blockact_snd, 500);
	proc_late();
	while (your.fPblock && game_status != stat_gameover)
	{
		vec_set (my.x, your.x);
		my.pan += 10 * time;
		my.alpha = 40 + 10 * abs (sin (timer * 5));
		wait (1);
	}
	ent_purge(me);
	ent_remove(me);
}

function player_mark()
{
	my.passable = on;
	my.bright = on;

	while (game_status != stat_gameover)
	{
		wait (1);
		vec_set (my.x, your.x);
		my.z += 70;
		my.scale_x = 0.5;
		my.scale_y = 0.4 + abs(0.2 * sin(timer * 15));
	}
	wait (1);
	ent_purge(me);
	ent_remove(me);
}

function particle_flash()
{
	my.partTimer += time;
	if (my.partTimer >= 0.2)
	{
		vec_for_vertex (temp, me, swordVertex);
		vec_set (my.targetX, temp);
		vec_sub (my.posX, my.targetX);
		if (your.fPspecial)
		{
			effect (Xspecialattackpart_event, 1, temp, my.posX);
		}
		else
		{
			effect (Xattackpart_event, 1, temp, my.posX);
		}
		vec_set (my.posX, temp);
		while (my.partTimer >= 0.2)
		{
			my.partTimer -= 0.2;
		}
	}
}

function water_ripple()
{
	my.unlit = on;
	my.oriented = on;
	my.passable = on;
	my.bright = on;
	my.tilt = -90;
	my.scale_x = 0.8;
	my.scale_y = 0.8;
	my.alpha = 40;

	my.x = your.x;
	my.y = your.y;
	my.z = water_height + 3;

	my.wtr_entity = your.wtr_entity;

	while ((my.wtr_entity & 1) == 1 || my.alpha > 0)
	{
		wait (1);
		if (you != null)
		{
			my.x = your.x;
			my.y = your.y;
			my.wtr_entity = your.wtr_entity;
		}
		else
		{
			my.wtr_entity -= (my.wtr_entity & 1);
		}
		my.z = water_height + 3;
		my.frame = cycle (my.frame + 0.3 * time, 1, 6);
		//fade entity
		if ((my.wtr_entity & 1) == 0 || my.alpha < 40)
		{
			my.alpha = max (0, my.alpha - 10 * time);
		}
	}
	wait (1);
	ent_remove (me);
}

var hand_pos[3] = 0,0,0;
function vertex_attach()
{
	proc_late();
	my.passable=on;
	my.metal=on;
	while(you)
	{
		if (my.weapon_type != your.weapon_type)
		{
			my.weapon_type = your.weapon_type;
			my.fWeaponFX = off;
		}
		vec_for_vertex(temp, you, your.skill1);
		//1st center vertex for weapon attachment
		vec_for_vertex (hand_pos, you, your.skill2);
		//vertex between thumb and pointer finger (relative to 1st vertex)
		vec_for_vertex (my_pos, you, your.skill3);
		//2nd center vertex for weapon attachment
		vec_sub (hand_pos, temp);
		vec_add (my_pos, temp);
		vec_scale (my_pos, 0.5);
		vec_set (my.x, my_pos);
		vec_to_angle (my.pan,hand_pos);
		my.flare = (your.flare == on);
		my.transparent = (your.transparent == on);
		my.invisible = (your.invisible == on);
		my.alpha = your.alpha;
		my.ambient = your.ambient;
		my.shadow = (your.shadow == on);

		if (my.weapon_type != 0 && my.fWeaponFX == off)
		{
			vec_set (temp, vector (me, 0, my.weapon_type)); // no handle due to performance
			effect (Xweaponpart_event, 1, my.x, temp);
			my.fWeaponFX = on;
		}

		if (your.mode == Pmode_attack && game_status != stat_gameover)
		{
			particle_flash();
		}
		else
		{
			vec_for_vertex (my.posX, me, swordVertex);
		}
		wait(1);
	}
	ent_purge(me);
	ent_remove(me);
}

function set_rank()
{
//rank[x] is calculated by HUD
	if (me == player1) {temp = 0;}
	if (me == player2) {temp = 1;}
	if (me == player3) {temp = 2;}
	if (me == player4) {temp = 3;}
	if (rank[temp] == 0 && my.sfx != SFXghost)
	{
		my.partcount += time;
		while (my.partcount >= 1)
		{
			temp.x = handle(me);
			temp.y = 0;
			temp.z = 0;
			effect(rank_particle, 3, my.x, temp);
			my.partcount -= 1;
		}
	}
}


///////////////////////////////////////////////////////////////////////////////////
var temp_pos;
function player_move()
{
	if (my.ammo > 0)
	{
		if (my.wpn_timer != 0)
		{
			my.wpn_timer += time * base_speed;
		}
		if (my.wpn_timer >= 24)
		{
			ent_playsound (me, weapon_snd, 500);
			vec_for_vertex(temp, me, my.skill1);
			vec_for_vertex (my_pos, me, my.skill3);
			vec_add (my_pos, temp);
			vec_scale (my_pos, 0.5);
			effect (Xammopart_event, 30, my_pos, vector(me, 0, my.weapon_type));
			my.wpn_timer = 0;
		}
	}
	vec_set (temp_pos, my.x);

	if (my.mode != Pmode_lock)
	{
		player_force();
	}
	else
	{
		my.speedX = 0;
		my.fPspecial = off;
		my.fPblock = off;
		return;
	}

	if (my.fPblock)
	{
		my.stamina = max (0, my.stamina - PstaBlock * time);
		if (my.stamina == 0) {my.fPblock = off;}
	}
	if (my.stamina < PstaMax)
	{
		my.stamina = min (PstaMax, my.stamina + PstaRecover * time);
		if (my.stamina == PstaMax)
		{
			ent_playsound (me, stamina_snd, 500);
			effect (Xstaminapart_event, 30, my.x, nullvector);
		}
	}

	if (my.fPinvul && my.invulTimer > 0)
	{
		player_invul();
	}

	if (visualFX != 0)
	{
		player_effects();
	}
	if (my.mode == Pmode_walk)
	{
		player_walk();
	}
	if (my.mode == Pmode_charge)
	{
		player_charge();
	}
	if (my.mode == Pmode_attack)
	{
		player_attack();
	}
/* moved to player event
	if (my.mode == Pmode_initHit)
	{
		player_hit();
	}
*/
	if (my.mode == Pmode_hit)
	{
		player_anim_hit();
	}
	if (my.mode == Pmode_critHit)
	{
		player_anim_critHit();
	}
	if (my.mode == Pmode_ko)
	{
		player_ko();
	}
	if (my.fPevent)
	{
		player_item_event();
	}
	if (my.typ == plr)
	{
		set_rank();
	}
	my.forceX = 0;
}



var speed;
var abspeed;
//string helper_str[100];

function player_force()
{
	temp = min(time * 0.55, 1);
	if ((my.icefloor & 2) == 2 && (my.pushvecX != 0 || my.pushvecY != 0))
	{
		my.pushvecX *= 0.4;
		my.pushvecY *= 0.4;
	}

	if ((my.icefloor & 2) == 2 && my.pushvecX == 0 && my.pushvecY == 0)
	{
		temp = min(time * 0.1, 1);
		my.forceX *= 0.2;
		my.pushvecX = my.forceX * cos (my.pan) * time;
		my.pushvecY = my.forceX * sin (my.pan) * time;
		my.pushvecZ = 0;
//		my.forceX *= 0.5;
	}

	if (my.mode == Pmode_walk || my.mode == Pmode_charge)
	{
		if (my.mode == Pmode_charge) {my.forceX *= 0.5;}
		if (my.typ == plr) {my.forceX *= base_speed;}
		my.speedX += (time * my.forceX) - (temp * my.speedX);
	//	my.speedy += (time * my.forcey) - (temp * my.speedy);
	//	my.speedz += (time * my.forcez) - (temp * my.speedz);
		speed.x = my.speedx * time;
		speed.y = 0;//my.speedy*time;
		speed.z = 0;
	}
	else
	{
		my.speedX = 0;
		vec_set(speed, nullvector);
	}

	my.abspeedX += (/*time * */my.pushvecX) - (temp * my.abspeedX);
	my.abspeedY += (/*time * */my.pushvecY) - (temp * my.abspeedY);
//	my.abspeedz += (time * my.pushvecZ) - (temp * my.abspeedz);
	abspeed.x = my.abspeedx * time;
	abspeed.y = my.abspeedy * time;
	abspeed.z = 0;
	vec_set(my.pushvec, nullvector);

	you = null;
	move_mode = ignore_me + ignore_passents + ignore_passable + activate_trigger + glide;
	ent_move (speed, abspeed);

/* dirty bugfix */
	my.x = clamp(my.x, -365, 365);
	my.y = clamp(my.y, -365, 365);
/* end dirty bugfix */

	trace_mode = ignore_me + ignore_you + ignore_passents + ignore_passable + ignore_sprites + ignore_models + activate_sonar + use_box;
	vec_set (temp, my.x);
	temp.z -= 300;
	trace (my.x, temp);
/*
if (me==player1) {
helper.x = ice_height;
helper.y = my.z + my.min_z;
helper.z = my.icefloor;
}
*/
	my.z = target.z - my.min_z; /*+ 5;*/

	if (my.speed < 0.1 && my.speed != 0 && my.speed > -0.1) {my.speed = 0;}
	if (my.abspeedX < 0.1 && my.abspeedX != 0 && my.abspeedX > -0.1 &&
		my.abspeedY < 0.1 && my.abspeedY != 0 && my.abspeedY > -0.1)
	{
		my.abspeedX = 0;
		my.abspeedY = 0;
	}
}

string entname[12];
function player_effects()
{
	//ice sliding
	if ((my.z + my.min_z < ice_height + 5) && (my.icefloor & 2) == 0)
	{
		my.icefloor |= 2;
	}

	if ((my.z + my.min_z > ice_height + 8) && (my.icefloor & 2) == 2)
	{
		my.icefloor -= (my.icefloor & 2);
	}

	//water ripple effect
	if ((my.z + my.min_z < water_height) && (my.wtr_entity & 1) == 0)
	{
		my.wtr_entity |= 1;
		ent_create("ripple+5.tga", my.x, water_ripple);
	}

	if ((my.z + my.min_z > water_height + 3) && (my.wtr_entity & 1) == 1)
	{
		my.wtr_entity -= (my.wtr_entity & 1);
	}

	//highspeed event
	if (base_speed > orig_speed && speed >= 0.01 && my.typ != golem)
	{
		my.speedTimer += time;
		while (my.speedTimer >= 1)
		{
			my.speedTimer -= 1;
			if (my.transparent == off && my.invisible == off && my.flare == off)
			{
				str_for_entfile(entname, me);
				you = ent_create(entname, my.x, playerFX_speed);
			}
		}
	}
	else
	{
		my.speedTimer = 0;
	}

	//slowmotion_event
	if (base_speed >= orig_speed) {my.fPslow = off;}
	if (base_speed < orig_speed && my.fPslow == off && my.typ != golem)
	{
		my.fPslow = on;
		you = ent_create("bluering.pcx", my.x, playerFX_slow);
	}

	//stamina maxed
	if (my.stamina == PstaMax && my.typ != golem && my.fPinvul == off && my.mode == Pmode_walk)
	{
		my.staTimer += time;
		while (my.staTimer >= 20)
		{
			my.staTimer -= 20;
			if (my.transparent != 1 && my.invisible != 1 && my.flare != 1)
			{
				str_for_entfile(entname, me);
				you = ent_create(entname, my.x, playerFX_sta);
			}
		}
	}
	else
	{
		my.staTimer = 0;
	}
}

//invulnerability after critical hit
function player_invul()
{
	my.invulTimer = max (my.invulTimer - time, 0);
	if ((int(my.invulTimer) & 7) < 4)
	{
		my.transparent = on;
	}
	else
	{
		my.transparent = off;
	}
	if (my.invulTimer == 0)
	{
		my.transparent = off;
		my.fPinvul = off;
	}
}

//block initialization
function player_block()
{
	if (my.stamina < 20)
	{
		if (my.mode == Pmode_charge)
		{
			my.mode = Pmode_walk;
		}
		return;
	}
	if (my.fPblock) {return;}
	my.fPblock = on;
	ent_create ("block.mdl", my.x, playerFX_block);
}

function player_walk()
{
	if (my.speed == 0)
	{
		my.anim_dist = my.total_dist + time * base_speed / 6;
		if (my.anim_dist > my.anim_fac)
		{
			my.anim_dist -= my.anim_fac;
		}
		temp = 100 * my.anim_dist / my.anim_fac;
		ent_cycle(wait_str, temp);
		player_anim_blend(temp, pMode_wait); //override walk_mode
	}
	else
	{
		my.anim_dist = my.total_dist + abs(speed.x) / (my.max_x - my.min_x);
		if (my.anim_dist > my.anim_fac)
		{
			my.anim_dist -= my.anim_fac;
		}
		temp = 100 * my.anim_dist / my.anim_fac;
		ent_cycle(walk_str, temp);
		player_anim_blend(temp, my.mode);

		if (my.anim_dist < my.total_dist && my.typ!=golem)
		{
			ent_playsound (me, tap_snd, 500);
		}
		if ((my.anim_dist > my.anim_fac * 0.5) && (my.total_dist < my.anim_fac * 0.5)
					&& my.typ!=golem)
		{
			ent_playsound (me, tap_snd, 500);
		}

	}
	my.total_dist = my.anim_dist;
}

function player_charge()
{
	my.anim_time += time;
	if (my.anim_time > 5)
	{
		my.anim_time = 0;
 		if (my.fPblock)
		{
			my.mode = Pmode_walk;
		}
		else
		{
 			my.mode = Pmode_attack;
			my.temp_pan = my.pan;
			if (my.fPspecial)
			{
				ent_playsound (me, sp_attack_snd, 500);
			}
			else
			{
				ent_playsound (me, attack_snd, 500);
			}
//			you = ent_create("flash2.mdl", my.POS, attach_flash);
		}
		return;
	}
	temp = 100 * my.anim_time / 5;

	ent_frame(charge_str, temp);
	player_anim_blend(temp, my.mode);
}

function player_attack()
{
	if (my.fPspecial) //special attack
	{
		my.anim_time += time * 0.5;
	}
	else
	{
		my.anim_time += time;
	}
	temp = 100 * my.anim_time / (5 * fac_speed);
	ent_frame(attack_str, temp);
	player_anim_blend(temp, my.mode);
	if (my.fPspecial) //turn player for special attack
	{
		my.pan = ang(my.temp_pan + temp * 3.6);
	}
	if (temp >= 50 && my.fPattacked != 1)
	{
		my.fPattacked = on; //player already has attacked
		my.attack_pow = my.stamina / 20;
		if (my.fPspecial)
		{
			my_pos.pan = 360;
			my.stamina = max(my.stamina - PstaCrit, 0);
		}
		else
		{
			my_pos.pan = 90;
			my.stamina = max(my.stamina - PstaAttack, 0);
		}
//		my_angle.pan = my.pan;
//		my_angle.tilt = 0;
		my_pos.tilt = 160;
		my_pos.Z = 100;
		result = 0;
		scan_entity (my.x, /*my_angle, */my_pos);
//my.pow = result;
		if (result > 80 || result == 0) //next enemy too far away or not in sight?
		{
		//activate weapons when special attack is not active
			if (my.ammo > 0 && my.wpn_timer == 0 && my.fPspecial == off)
			{
				if (my.weapon_type == wep_fireball)
				{
					my.wpn_timer = 1;
					shoot_fireball();
				}
				if (my.weapon_type == wep_acidball)
				{
					my.wpn_timer = 1;
					shoot_acidball();
				}
				if (my.weapon_type == wep_lightning)
				{
					my.wpn_timer = 1;
					shoot_lightning();
				}
			}
		}
	}
	if (my.anim_time > 5 * fac_speed)
	{
		my.mode = Pmode_walk;
		my.anim_time = 0;
//		my.pan = my.temp_pan;
		my.fPspecial = off;
		my.fPattacked = off;
		return;
	}

}

function player_hit()
{
	if (my.mode == Pmode_critHit || my.mode == Pmode_lock) {return;}
//	my.mode = Pmode_initHit;

	if (my.fPblock)
	{
		my.stamina = max (0, my.stamina - PstaBlockHit);
		vec_set (temp, my.x);
		temp.z += my.min_z;
		effect (Xblock_event, 30, temp, nullvector);
		ent_playsound (me, block_snd, 500);
		my.mode = Pmode_walk;
		return;
	}

	if (your.typ == plr)
	{
		if (your.fPspecial)
		{
			player_pushed(PforceCrit);
			my.mode = Pmode_critHit;
			ent_playsound (me, crithit_snd, 600);
		}
		else
		{
			player_pushed(PforceHit);
			my.mode = Pmode_hit;
			ent_playsound (me, ouch_snd, 500);
		}
	}
	else
	{
		if (your.typ == golem || your.typ == explosion)
		{
			player_pushed(PforceCrit);
			my.mode = Pmode_critHit;
			ent_playsound (me, crithit_snd, 600);
		}
		else
		{
			my.mode = Pmode_hit;
			ent_playsound (me, ouch_snd, 500);
		}
	}

	if (your.typ != explosion && your.typ != weapon)
	{
		temp = max(my.pow / (8 - your.attack_pow), 1);
		if (my.pow - temp >= 0)
		{
			your.pow += temp;
		}
	}
	else
	{
		temp = max (my.pow / 10, 1);
		if (your.typ == explosion)
		{
			temp = max (my.pow / 5, 1);
		}
		if (your.typ == weapon)
		{
			tempent = ptr_for_handle (your.player_ref);
			if (tempent != me) /* player could hit himself with weapon */
			{
				tempent.pow += temp;
			}
		}
	}
	my.pow = max (my.pow - temp, 0);

	effect (Xhit_event, 15, my.pos, nullvector);
	my.anim_time = 0;
//	ent_playsound (me, ouch_snd, 500);
}

function player_ko()
{
	my.anim_time += time;
	if (my.anim_time > 48)
	{
		my.fPinvul = on;
		my.invulTimer = PinvulTime;
		my.mode = Pmode_walk;
		my.anim_time = 0;
	}
}

function player_anim_hit()
{
	my.anim_time += time;
	if (my.anim_time > 6 * fac_speed)
	{
		my.mode = Pmode_walk;
		my.anim_time = 0;
		return;
	}
	temp = 20 * my.anim_time / (6 * fac_speed);
	ent_frame (hit_str, temp);
	player_anim_blend(temp, my.mode);
}

function player_anim_critHit()
{
	my.anim_time += time;
	if (my.anim_time > 20 * fac_speed)
	{
		my.mode = Pmode_ko;
		my.sfx = SFXnone; //disable any active sfx
		return;
	}
	temp = 100 * my.anim_time / (20 * fac_speed);
	ent_frame (hit_str, temp);
	player_anim_blend(temp, my.mode);
}

function player_pushed(pushforce)
{
	if (scantype == teleport_scan)
	{
		vec_set (my_angle, vector(teleangle, 0, 0));
	}
	else
	{
		if (your.typ == plr || your.typ == golem)
		{
			vec_set (temp, my.x);
			vec_sub (temp, your.x);
			vec_to_angle (my_angle, temp);
		}
		else
		{
			return;
		}
	}
	my.pushvecX = pushforce * cos (my_angle.pan);
	my.pushvecY = pushforce * sin (my_angle.pan);
	my.pushvecZ = 0;
}

//animFrame:	percentage of old animation frame
//curMode:		override current mode by adding given factor to current mode
function player_anim_blend(animFrame, curMode)
{
	//blending phase finished or mode change during blending phase?
	if (my.blendTimer != 0 || my.lastMode != curMode)
	{
		//mode has changed during blending phase?
		if (my.lastMode != curMode)
		{
			my.oldMode = my.lastMode;
			my.lastMode = curMode;
			my.blendTimer = 5;
		}

		//increment timer and blend animation
		my.blendTimer = max(0, my.blendTimer - (time + time));
		ent_blend (player_anim_txt.string[my.oldMode], my.last_anim_time, my.blendTimer * 20);
		if (my.blendTimer == 0)
		{
			//blending finished
			my.oldMode = curMode;
		}
	}
	else
	{
		//get last frame percentage
		my.last_anim_time = animFrame;
	}
}

///////////////////////////////////////////////////////////////////////////////////

function player_item_event()
{
	my.fPevent = off;
	if (my.mode == Pmode_lock || my.mode == Pmode_ko) {return;}

	if (my.sfx == pSFXmagnet)
	{
		magnet_event();
		return;
	}
	if (my.sfx == pSFXghost)
	{
		ghost_event();
		return;
	}
	if (my.sfx == pSFXinvul)
	{
		ent_create("invul.mdl", my.x, invul_event);
		return;
	}
}

function player_event()
{
	if (my.mode == Pmode_lock) {return;}

	//CPU only - attack if colliding with entity
	if (event_type == event_entity && my.mode == Pmode_walk)
	{
		if (your.typ == plr || your.typ == golem || your.typ == box)
		{
			return;
		}
		cpu_stuck();
		return;
	}

	//target is not reachable, search new target
	if (event_type == event_block)
	{
		cpu_stuck();
		return;
	}

	//CPU and human player
	if (event_type == event_scan)
	{
		if (scantype == box_scan) {return;}
		if (scantype == teleport_scan)
		{
			player_pushed(PforceTele);
			return;
		}
		if(you != null && my.mode != Pmode_ko && my.mode != Pmode_critHit && my.mode != Pmode_hit && my.sfx != SFXinvul && my.fPinvul == off && my.fPspecial == off && scantype == standard_scan)
		{
			wait (1);
			if (my.mode == Pmode_lock) {return;} //check if player mode changed after wait
			if (your.typ != plr && your.typ != explosion && your.typ != golem && your.typ != weapon)
			{
				return;
			}
			my.entity2 = you;
			trace_mode = activate_shoot + ignore_passents + ignore_passable + ignore_me;
			trace (my.x, your.x);

			if (you != null)
			{
				if (you == my.entity2)
				{
					player_hit();
				}
				return;
			}
			my.entity2 = null;
		}
	}

	if (event_type == event_impact)
	{
		if (you != null)
		{
			player_pushed(PforcePush * time);
		}
	}
}

function player_fixZ(ent)
{
	me = ent;
	trace_mode = ignore_me + ignore_you + ignore_passents + ignore_passable + ignore_sprites + ignore_models + activate_sonar;
	vec_set (temp, my.x);
	temp.z -= 300;
	trace (my.x, temp);
	my.z = target.z - my.min_z /*+ 5*/;
}

//////////Blob Shadow
function move_shadow()
{
	proc_late();
	my.passable = on;
	my.oriented = on;
	my.unlit = on;
	my.ambient=-100;
	my.scale_y = (your.max_x - your.min_x) / (my.max_x - my.min_x) - 0.05;
	my.scale_x = my.scale_y;
	my.scale_z = 1.0;
	my.tilt = 90;
	while (you != null)
	{
		my.invisible = off;
		if (your.invisible && your.typ == golem || your.flare)
		{
			my.invisible = on;
		}
		my.pan = your.pan;
		tempent = you;
		trace_mode = ignore_me + ignore_you + ignore_passents + ignore_passable + ignore_sprites + ignore_models;
		vec_set (temp, tempent.x);
		temp.z -= 1000;
		trace (tempent.x, temp);
		you = tempent;
		if ((normal.x != 0) || (normal.y != 0))
		{
			my.pan = 0;
			my.tilt = - asin(normal.x);
			my.roll = - asin(normal.y);
			temp.pan = you.pan;
			temp.tilt = 90;
			temp.roll = 0;
			ang_rotate(my.pan, temp);
		}
		else
		{
			my.pan = you.pan;
			my.tilt = 90;
			my.roll = 0;
		}
		my.x = your.x;
		my.y = your.y;
		my.z = target.z + 3;
		wait(1);
	}
	ent_remove(me);
}

function drop_shadow()
{
	wait(1);
	you = ent_create("shadow.tga", my.x, move_shadow);
}