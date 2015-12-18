///////////////////////////////////////////////////////////////////////////////////
// ~ 4 Little Warriors ~ eyecandy WDL
//
// Modified by Firoball  10/24/2006
///////////////////////////////////////////////////////////////////////////////////

//////////Prototypes
function actor_sound();
function actor_move();
function actor_anim();
function Xbird_path();
function Xufo_move();
function Xufo_smoke();
function Xufo_sound();
function pushable_event();
function pushable_pushed(pushforce);

//////////Sounds
sound seagull1_snd, "seagull1.wav";
sound seagull2_snd, "seagull2.wav";
sound crow_snd, "crow.wav";
sound space1_snd, "space1.wav";
sound space2_snd, "space2.wav";
sound ufo_snd, "ufo.wav";

function actor_sound()
{

	if (my.skill6 < 1 && my.skill7 < 1) {return;}
	waitt (my.skill9);
	while(me)
	{
		if (my.skill6 > 0)
		{
			ent_playsound (me, seagull1_snd, 400); //TEMP!!
			my.skill10 = my.skill8 + random (16) - 8;
			waitt (my.skill10);
		}
		if (my.skill7 > 0)
		{
			ent_playsound (me, seagull2_snd, 400); //TEMP!!
			my.skill10 = my.skill8 + random (16) - 8;
			waitt (my.skill10);
		}
		wait (1);
	}
}
/*
function actor_turn(&my_angle) {
		temp.x=ang(my_angle[0]-my.pan);
		temp.y=ang(my_angle[0]-my.tilt);
		if (temp.x==0 && temp.y==0) {return;}
		if (temp.x > 0)
		{
				MY.forceX = my.skill1;
		} else {
				MY.forceX = -my.skill1;
		}
		if (temp.y > 0)
		{
				MY.forceY = my.skill1;
		} else {
				MY.forceY = -my.skill1;
		}
		if (temp.x!=0) {MY.PAN +=MY.forceX*TIME;}
		if (temp.y!=0) {MY.PAN +=MY.forceY*TIME<h4><h4></h4></h4>;}
		if ((ANG(my_angle[0]-MY.PAN)>=0&&temp.x<0)||(ang(my_angle[0]-my.pan)<=0&&temp.x>0))
		{
			MY.PAN=my_angle[0];
		}
		if ((ANG(my_angle[1]-MY.tilt)>=0&&temp.y<0)||(ang(my_angle[1]-my.tilt)<=0&&temp.y>0))
		{
			MY.tilt=my_angle[1];
		}
}
*/
function actor_move()
{
	temp = min (time * 0.55, 1);
	my.speedX += (time * my.forceX) - (temp * my.speedX);
	speed.X = my.speedX * time;
	speed.Y = 0;
	speed.Z = 0;
	you = null;
	ent_move (speed, nullvector);
}

function actor_anim()
{
	my.anim_dist = my.total_dist + abs(speed.x) / (my.max_x - my.min_x);
	if (my.anim_dist > my.anim_fac)
	{
		my.anim_dist -= my.anim_fac;
	}
	temp = 100 * my.anim_dist / my.anim_fac;
	ent_cycle(walk_str, temp);

	my.total_dist = my.anim_dist;
}

function Xbird_path()
{
	temp.pan = 360;
	temp.tilt = 180;
	temp.z = 1000;
	result = scan_path (my.x, temp);
	ent_waypoint (my.targetX, my.skill4);
	if (result == 0) {return;}
	ifdef birdview;
	show_birdcam(me);
	endif;
	while (me)
	{
		temp.x = my.targetX - my.x;
		temp.y = my.targetY - my.y;
		temp.z = my.targetZ - my.Z;
		result = vec_to_angle (my_angle, temp);
		if (result < 25 && my.flag4 == 0) {ent_nextpoint (my.targetX);}
		if (result < 25 && my.flag4) {ent_prevpoint (my.targetX);}
		my.pan = my_angle.pan;
		my.tilt = my_angle.tilt;
//		actor_turn(my_angle);
		my.forceX = my.skill1;
		actor_move();
		actor_anim();
		wait(1);
	}
}

define flyspeed, skill1;
define animspeed, skill2;
define modelskin, skill3;
define startpoint, skill4;
define ambientsound1, skill6;
define ambientsound2, skill7;
define sounddelay, skill8;
define soundinitdelay, skill9;
define ambientsoundvolume, skill10;
define altflydirection, flag4;

// uses flyspeed, animspeed, modelskin, startpoint, ambientsound1, ambientsound2
// uses sounddelay, soundinitdelay
// uses ambientsoundvolume, altflydirection
action Xbird
{
	my.forceX = my.skill1;
	my.anim_fac = my.skill2;
	my.skin = my.skill3;
//	my.string1 = "box";  //TEMP!!!
	my.passable = on;
//	load_model (my.string1, my.skill5,me);
	if (polyshadows>1)
	{
		my.shadow = on;
	}
	wait (1);
	actor_sound();
	Xbird_path();
}

define flylimit, skill2;
define ufowait, skill3;
define startupdelay, skill4;

function Xufo_move()
{
	while (me)
	{
		ifdef ufoview;
		show_ufocam(me);
		endif;
		while (my.x < my.flylimit && my.x > -my.flylimit && my.y < my.flylimit && my.y > -my.flylimit)
		{
			temp = min(time * 0.55, 1);
			my.forceY = 4 * cos(timer * 10);
			my.speedX += (time * my.forceX) - (temp * my.speedX);
			my.speedY += (time * my.forceY) - (temp * my.speedY);
		//	my.speedz += (time * my.forcez) - (temp * my.speedz);
			speed.x = my.speedX * time;
			speed.y = my.speedY * time;
			speed.z = 0;
			move_mode = ignore_me + ignore_you + ignore_passents + ignore_passable;
			ent_move (speed, nullvector);
			my.roll = 30 * sin(timer * 6);
			Xufo_smoke();
			wait (1);
		}
		my.invisible = on;
		temp = my.ufowait * 0.8 + abs(random(0.2 * my.ufowait));
		sleep (temp);
		vec_set (my.x, my.posX);
		my.invisible = off;
	}
}

function Xufo_smoke()
{
	my.partcount += time;
	while (my.partcount >= 1)
	{
		effect (fixed_smoke_particle, 1, my.x, nullvector);
		my.partcount -= 1;
	}
}

function Xufo_sound()
{
	while(me)
	{
		if (my.invisible == off)
		{
			ent_playsound(me, ufo_snd, 1000);
			sleep(2);
		}
		wait (1);
	}
}

//uses flyspeed, flylimit , ufowait, startupdelay
action Xufo
{
	my.passable = on;
	my.invisible = on;
	my.unlit = on;
	my.ambient = 80;
	my.metal = on;
	my.forceX = my.flyspeed;
	vec_set (my.posX, my.x);
	sleep(my.startupdelay);
	my.invisible = off;
	Xufo_move();
	Xufo_sound();
}

define AnimFrames, skill1;
//define AnimSpeed, skill2;
define Lred, skill3;
define Lgreen, skill4;
define Lblue, skill5;
define Lrange, skill6;
define FlickerOffset, skill7;
define ShowSmoke, flag1;

// uses AnimFrames, AnimSpeed, Lred, Lgreen, Lblue, Lrange, FlickerOffset, ShowSmoke
action Xanim_fire
{
	my.ambient = 100;
	my.facing = on;
	my.bright = on;
	my.flare = on;
	my.passable = on;

	if (my.Lrange != 0)
	{
		my.lightred = my.Lred;
		my.lightgreen = my.Lgreen;
		my.lightblue = my.Lblue;
		my.lightrange = my.Lrange;
		if (my.lightred == 0)
		{
				my.lightred = 239;
				my.lightgreen = 177;
				my.lightblue = 16;
		}
	}
	if (my.AnimFrames == 0) {my.AnimFrames = 9;}
	if (my.AnimSpeed == 0) {my.AnimSpeed = 1;}
	while (me)
	{
		my.frame += time * my.AnimSpeed;
		if (my.frame > my.AnimFrames)
		{
			my.frame -= my.AnimFrames;
		}
		if (my.Lrange != 0)
		{
			my.lightrange = my.Lrange / 2 + my.Lrange / 2 * abs (sin (5 * my.Flickeroffset));
			my.Flickeroffset += time << 2;
		}

		if (my.ShowSmoke)
		{
			my.partcount += time;
			while (my.partcount >= 2)
			{
				effect (smoke_particle, 1, my.x, nullvector);
				my.partcount -= 2;
			}
		}
		wait (1);
	}
}

action Xshine
{
	while(1)
	{
		my.partcount+=time;
		while (my.partcount>=1)
		{
			temp.x=0;
			temp.y=0;
			temp.z=-10;
			effect(shine_particle,2,my.x,temp);
			my.partcount-=1;
		}
	wait (1);
	}

}

action _golem_anim
{
	ent_morph(me,"golem.mdl");
	my.anim_fac=15;
	my.oldMode = 0;
	while(1)
	{
		my.anim_dist = my.total_dist + time / 4;
		if (my.anim_dist > my.anim_fac)
		{
			my.anim_mode += 1;
			my.anim_mode &= 3;
			my.anim_dist -= my.anim_fac;
		}
		temp = 100 * my.anim_dist/my.anim_fac;

		if (my.anim_mode == 3)
		{
			ent_cycle(guard_str, temp);
		}
		else
		{
			ent_cycle(wait_str, temp);
		}
		my.total_dist=my.anim_dist;

//////////frame blending
		//blending phase finished?
		if (my.blendTimer != 0)
		{

			//inrement timer and blend animation
			my.blendTimer = max(0, my.blendTimer - (time + time));
			if (my.anim_mode == 3)
			{
				ent_blend (wait_str, my.last_anim_time, my.blendTimer * 20);
			}
			else
			{
				ent_blend (guard_str, my.last_anim_time, my.blendTimer * 20);
			}
			if (my.blendTimer == 0)
			{
				//blending finished
				my.oldMode = my.anim_mode;
			}
		}
		else
		{
			//mode has changed? - init timer
			if (my.oldMode != my.anim_mode && (my.oldMode == 3 || my.anim_mode == 3))
			{
				my.blendTimer = 5;
			}
			//get last frame percentage
			my.last_anim_time = temp;
		}

		wait (1);
	}
}

define SoundVol, skill1;
//define SoundDelay, skill8;
//define soundinitdelay, skill9;

// uses SoundVol, SoundDelay, soundinitdelay
action Wcrow
{
	my.soundTimer = my.soundinitdelay * 16;
	my.SoundDelay *= 16;
	my.passable = on;
	my.invisible = on;
	while (me)
	{
		wait (1);
		my.soundTimer +=  time;
		if (my.soundTimer >= my.SoundDelay)
		{
			my.soundTimer -= my.SoundDelay + random (32);
			snd_play(crow_snd, my.SoundVol, 0);
		}
	}
	ent_purge (me);
	ent_remove (me);
}

// uses SoundVol, SoundDelay, soundinitdelay
action Wspace
{
	my.soundTimer = my.soundinitdelay * 16;
	my.SoundDelay *= 16;
	my.passable = on;
	my.invisible = on;
	my.mode = 0;
	while (me)
	{
		wait (1);
		my.soundTimer +=  time;
		if (my.soundTimer >= my.SoundDelay)
		{
			my.soundTimer -= my.SoundDelay + random (32);
			if (my.mode == 0)
			{
				snd_play(space1_snd, my.SoundVol, 0);
			}
			else
			{
				snd_play(space2_snd, my.SoundVol, 0);
			}
			my.mode = (my.mode + 1) & 1;
		}
	}
	ent_purge (me);
	ent_remove (me);
}

define xmovefac, skill1;
define ymovefac, skill2;
define zmovefac, skill3;
define panfac, skill4;
define tiltfac, skill5;
define rollfac, skill6;
define movespeed, skill7;
define degoffset, skill8;
define objectskin, skill9;

// uses xmovefac, ymovefac, zmovefac, panfac, tiltfac, rollfac, movespeed, degoffset, objectskin
action Xmove
{
/*
skill1-3: move strength
skill4-6: rotation strength
skill7:   speed
skill8:   offset in degrees
skill9:   skin
*/
	if (my.skill9 < 1) {my.skill9 = 1;}
	my.skin = my.skill9;
	vec_set (my.posx, my.x);
	vec_set (my.angx, my.pan);
	while (1)
	{
		my.x = my.posx + my.skill1 * sin (timer * my.skill7 + my.skill8);
		my.y = my.posy + my.skill2 * sin (timer * my.skill7 + my.skill8);
		my.z = my.posz + my.skill3 * sin (timer * my.skill7 + my.skill8);
		my.pan = my.angx + my.skill4 * sin (timer * my.skill7 + my.skill8);
		my.tilt = my.angy + my.skill5 * sin (timer * my.skill7 + my.skill8);
		my.roll = my.angz + my.skill6 * sin (timer * my.skill7 + my.skill8);
		wait (1);
	}
}

define waterambient,skill1;
define wateralpha,skill2;

// uses waterambient, wateralpha
action Xwater
{
	if (my.skill1 == 0) {my.skill1 = 50;} //ambient
	if (my.skill2 == 0) {my.skill2 = 50;} //alpha
	my.albedo = 0;
	my.unlit = on;
	my.bright = on;
	my.passable = on;
	my.transparent = on;
	my.typ = water;
	my.alpha  = my.skill2;
	my.ambient = my.skill1;
	vec_set (my.posX, my.x);
	my.z = my.posZ + 3 * sin (timer * 3);
	wait (1);
	while (1)
	{
		my.z = my.posZ + 3 * sin (timer * 3);
		water_height = my.z;
		wait (1);
	}
}

action Xice
{
	ice_height = my.z;
}

function pushable_event()
{
	if (event_type==event_scan)
	{
		if (scantype == teleport_scan)
		{
			pushable_pushed (PforceTele);
			return;
		}
	}

	if (event_type == event_impact)
	{
		pushable_pushed(PforcePushBox);
	}

}

function pushable_pushed(pushforce)
{
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
}


define OnlyPushOnIce, flag1;
define Weight, skill1;

//uses OnlyPushOnIce, Weight
action Xpushable
{
	my.fat = off;
	my.narrow = on;
	my.enable_impact = on;
	my.enable_scan = on;
	my.event = pushable_event;
	set_height();
	while (my.OnlyPushOnIce == off || my.z + my.min_z < ice_height + 5)
	{
		if (my.abspeedX != 0 || my.abspeedY != 0 || my.pushvecX != 0 || my.pushvecY != 0 || my.passable == off)
		{
			if (my.z + my.min_z < ice_height + 5)
			{
				temp = min(time * 0.1, 1);
			}
			else
			{
				temp = min(time * 0.55, 1);
			}

			my.pushvecX -= my.pushvecX * my.weight / 10;
			my.pushvecY -= my.pushvecY * my.weight / 10;
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
		}
		wait(1);
	}
}

	}


}

view mirror {}

function init_mirror_z()
{
	camera.portal = mirror;
	mirror.noshadow = on;
	mirror.portalclip = on;
	while (mirror_active == 1)
	{
		proc_late();
		mirror.genius = camera.genius;
		mirror.aspect = -camera.aspect;
		mirror.arc = camera.arc;
		mirror.fog = camera.fog;
		mirror.x = camera.x;
		mirror.y = camera.y;
		mirror.z = 2 * camera.portal_z - camera.z;
		mirror.pan = camera.pan;
		mirror.tilt = -camera.tilt;
		mirror.roll = -camera.roll;
		wait(1);
	}
	camera.portal = null;
}

action Xdecal
{
	my.decal = on;
}