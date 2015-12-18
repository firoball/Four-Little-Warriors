///////////////////////////////////////////////////////////////////////////////////
// ~ 4 Little Warriors ~ Particle functions
//
// Modified by Firoball  10/25/2006
///////////////////////////////////////////////////////////////////////////////////

//////////Prototypes
function _menu_particle_event();

function lightning_alphafade();
function lightning_explo();

function Xparticle_move();
function Xparticle_event();

function teleport_particle_fader();
function Xteleport_particle();

function particleF_fader();
function XparticleF_event();

function particleA_fader();
function XparticleA_event();

function particleL_fader();
function XparticleL_event();

function move_steam();
function Xsteam_event();
function Xswampgas_event();

function move_lavagas();
function Xlavagas_event();

function Xsnow_event();

function part_alphafade();
function rank_particle();

function part_staminafade();
function Xstaminapart_event();

function part_Xblockfade();
function Xblock_event();

function collect_particle();
function item_particle();
function power_particle();

function part_shinefade();
function shine_particle();

function part_smokefade();
function smoke_particle();
function fixed_smoke_particle();

function Xhit_event();

function part_attackfade();
function Xattackpart_event();
function Xspecialattackpart_event();

function part_weaponfx();
function Xweaponpart_event();

function part_ammofade();
function Xammopart_event();

//////////Bitmaps
bmap steam_par = "steam.pcx";
bmap swampgas_par = "swampgas.pcx";
bmap green_particle_map = "part_grn.pcx";
bmap blue_particle_map = "part_blu.pcx";
bmap red_particle_map = "part_red.pcx";
bmap orange_particle_map = "part_org.pcx";
bmap brightorange_particle_map = "part_ora2.pcx";
bmap yellow_particle_map = "part_yel.pcx";
bmap brightyellow_particle_map = "part_yel2.pcx";
bmap white_particle_map = "part_whi.pcx";
bmap fire_particle_map = "firepart.pcx";
bmap smoke_particle_map = "part_smo.pcx";
bmap snow_particle_map = "part_snw.pcx";

function _menu_particle_event()
{
	if (my.ALPHA==50) {
		my.vel_z=random(200)+600;
		my.vel_x=random(200)-100;
		my.vel_y=random(200)-100;
//				my.X=my.X-120+random(40)*6;
//				my.Y=my.Y-120+random(40)*6;
		my.bmap=blue_particle_map;
		my.SIZE=8;
		my.FLARE=1;
		my.bright=1;
//				my.alpha=25+random(25);
//				my.beam=1;
		my.streak=1;
//				my.MOVE=1;
	}
	if (my.ALPHA>0) {
		my.ALPHA-=2.5*time;
		my.ALPHA=MAX(0,my.ALPHA);
		if (CAMERA.FOG>90)
		{
			my.lifespan=0;
		}
	} else {
		my.lifespan=0;
	}
}

function lightning_alphafade()
{
	my.alpha -= time+time+time+time;
	if (my.alpha <= 0) { my.lifespan = 0; }
}

function lightning_explo()
{
	my.vel_x=random(2)-1;
	my.vel_y=random(2)-1;
	my.vel_z=random(1);
	vec_normalize(my.vel_x,random(5));
	my.alpha = 25 + random(25);
	my.bmap=white_particle_map;
	my.size=3;
//		my.red=206;
//		my.green=240;
//		my.blue=248;
	my.flare = on;
	my.bright = on;
	my.streak=on;
		my.move = on;
//		my.gravity=0.9;
	my.function = lightning_alphafade;
}

//////////Particle Stuff


function Xparticle_move()
{
	my.vel_z -= 0.2 * time;
	my.alpha = max (my.alpha - time, 0);
}

function Xparticle_event()
{
	my.X = my.X-4+random(4)*2;
	my.Y = my.Y-4+random(4)*2;
	my.Z -= random(15);
	my.bmap = blue_particle_map;
	my.size = 4;
	my.vel_X = -1.5+random(3);
	my.vel_Y = -1.5+random(3);
	my.vel_Z = 2.5+random(1);
//	my.bright = on;
	my.flare = on;
	my.move = on;
	my.lifespan = 30;
	my.function = Xparticle_move;
}

action Xparticle
{
	my.invisible = on;
	my.passable = on;
	my.partTimer = 0;

	while (me)
	{
		my.partTimer += time;
		while (my.partTimer >=1)
		{
			effect (xparticle_event, 3, my.pos, nullvector);
			my.partTimer -= 1;
		}
		wait (1);
	}
}

function teleport_particle_fader()
{
	my.alpha-=time+time;
	if (my.alpha<=0)
	{
		my.lifespan=0;
	}
}

function Xteleport_particle()
{
	my.X = my.X - 16 + random(16) * 2;
	my.Y = my.Y - 16 + random(16) * 2;
	my.Z += random(15);
	my.lifespan = 30;
	if (random(2) < 1)
	{
		my.bmap = blue_particle_map;
	}
	else
	{
		my.bmap = green_particle_map;
	}
	my.size = 4.5;
	my.vel_Z = 1 + random(0.5);
	my.move = on;
	my.flare = on;
	my.bright = on;
	my.function = teleport_particle_fader;
}

function particleF_fader()
{
	my.size += time + time;
	my.alpha -= 4 * time;
	my.alpha = max (my.alpha, 0);
}

function XparticleF_event()
{
	my.X += random (20) * my.vel_y;
	my.Y += random (20) * my.vel_x;
	my.Z = my.Z - 6 + random(12);
	if (random(2) < 1)
	{
		my.vel_x *= -1 * random(1);
		my.vel_y *= -1 * random(1);
	}
	my.vel_z = 0;
	my.bmap = fire_particle_map;
	my.size = 10;
	my.flare = on;
	my.bright = on;
	my.lifespan = 20;
	my.move = on;
	my.function = particleF_fader;
}

function particleA_fader()
{
	my.vel_z -= 0.05 * time;
	my.alpha -= time + time;
	my.alpha = max (my.alpha, 0);
}

function XparticleA_event()
{
	my.X = my.X - 5 + random(10);
	my.Y = my.Y - 5 + random(10);
	my.Z = my.Z - 5 + random(10);
	my.bmap = green_particle_map;
	my.size = 4;
	my.flare = on;
	my.bright = on;
	my.lifespan = 25;
	my.move = on;
	my.streak = on;
	my.function = particleA_fader;
}

function particleL_fader()
{
	my.alpha -= time + time;
	my.alpha = max(my.alpha, 0);
}

function XparticleL_event()
{
	my.bmap = blue_particle_map;
	my.function = particleL_fader;
	my.alpha = 50;
	my.flare = on;
	my.size = 5;
	my.beam = on;
	my.bright = on;
}


function move_steam()
{
	my.alpha = max (my.alpha - 2.5 * time, 0);
	my.z += (1 + random(1)) * time;
}

function xsteam_event()
{
	my.x += random(16) - 8;
	my.y += random(16) - 8;
	my.z += random(16) - 16;
	my.size = 12;
	my.flare = on;
	my.move = on;
	my.bmap = steam_par;
	my.lifespan = 20;
	my.function = move_steam;
}

function Xswampgas_event()
{
	my.x += random(16) - 8;
	my.y += random(16) - 8;
	my.z += random(16) - 8;
	my.size = 15;
	my.flare = on;
	my.move = on;
	my.bmap = swampgas_par;
	my.lifespan = 20;
	my.function = move_steam;
}

function move_lavagas()
{
	my.alpha = max (my.alpha - time, 0);
//	my.z += (1 + random(1)) * time;
}

function Xlavagas_event()
{
	my.x += random(16) - 4;
	my.y += random(16) - 4;
	my.z += random(16) - 8;
	my.size = 9;
	my.flare = on;
	my.move = on;
	my.bmap = orange_particle_map;
	my.lifespan = 50;
	my.function = move_lavagas;
}

action Xswampgas
{
	my.invisible = on;
	my.passable = on;
	my.partTimer = 0;
	while (me)
	{
 		my.partTimer += time;
		while (my.partTimer >= 1)
		{
			effect(xswampgas_event, 3, my.pos, nullvector);
			my.partTimer -= 1;
		}
		wait (1);
	}
}

action Xlavagas
{
	my.passable = on;
	my.unlit = on;
//	my.bright = on;
	my.oriented = on;
	my.partTimer = 0;
	my.scale_x = 0.4;
	my.scale_y = 0.4;
	set_height();
	vec_set (my.posX, normal);
	if ((normal.x != 0) || (normal.y != 0))	//retrieved from set_height()
	{
		my.pan = 0;
		my.tilt = - asin (normal.x);
		my.roll = - asin (normal.y);
		vec_set (temp, vector (0, 90, 0));
		ang_add(my.pan, temp);
	}
	else
	{
		my.pan = 0;
		my.tilt = 90;
		my.roll = 0;
	}
	my.z = target.z + 3;

	while (me)
	{
		my.alpha = 35 + abs(15 * sin(timer * 5));
 		my.partTimer += time;
		while (my.partTimer >= 2)
		{
			effect(xlavagas_event, 3, my.x, my.posX);
			my.partTimer -= 2;
		}
		wait (1);
	}
}

function Xsnow_event()
{
	my.x = random(1400) - 700;
	my.y = random(1400) - 700;
	my.z = 400 - abs(random(10));
	my.vel_z = -4;
	my.size = 4;
	my.flare = on;
	my.move = on;
	my.bright = on;
	my.bmap = snow_particle_map;
	my.lifespan = 80;
	my.function = null;
}

action Xsnow
{
	my.passable = on;
	my.invisible = on;
	while (game_status != stat_gameover || camera.fog <= 30)
	{
		wait (1);
		vec_set (my_angle, camera.pan);
		vec_set (temp, vector(200, 0, 0));
		vec_rotate(temp, my_angle);
		vec_add (temp, camera.x);
		vec_set (my.x, temp);
 		my.partTimer += time;
		while (my.partTimer >= 3)
		{
			effect(Xsnow_event, 10, my.x, nullvector);
			my.partTimer -= 3;
		}
	}
}
function part_alphafade()
{
	my.alpha -= time + time + time;
	my.alpha = max(0, my.alpha);
	you = ptr_for_handle(my.skill_x);
	vec_set (my.x, your.x);
	if (my.alpha == 0 || game_status == stat_gameover)
	{
		my.lifespan=0;
	}
}

function rank_particle()
{
	my.skill_x = my.vel_x;
	my.vel_z = random(60) - 30;
	my.vel_x = random(60) - 30;
	my.vel_y = random(60) - 30;
	my.bmap = white_particle_map;
	my.size = 2;
	my.flare = on;
	my.alpha = 35;
	my.bright = on;
	my.streak = on;
	my.function = part_alphafade;
}

function part_staminafade()
{
	my.alpha -= 10 * time;
	my.alpha = max (0, my.alpha);
	if (my.alpha == 0 || game_status == stat_gameover)
	{
		my.lifespan=0;
	}
}

function Xstaminapart_event()
{
	my.skill_a = random (360);
	my.skill_b = random (360);
	my.skill_c = random (360);
	vec_set (my.vel_x, vector(8, 8, 8));
	vec_rotate (my.vel_x, my.skill_a);
	if (random (2) < 1)
	{
		my.bmap = brightyellow_particle_map;
	}
	else
	{
		my.bmap = brightorange_particle_map;
	}
	my.size = 2;
	my.flare = on;
	my.alpha = 50;
	my.bright = on;
	my.streak = on;
	my.move = on;
	my.function = part_staminafade;
}

function part_Xblockfade()
{
	my.alpha-=4*time;
	my.alpha=max(my.alpha,0);
	my.vel_z+=4*time;
	if (my.alpha<=0)
	{
		my.lifespan=0;
	}
}

function Xblock_event()
{
	my.bmap=white_particle_map;
	my.x+=20*cos(random(360));
	my.y+=20*sin(random(180)+random(180));
	my.vel_z=50+random(10);
	my.streak=1;
	my.size=2;
	my.flare=1;
	my.bright=1;
	my.alpha=40;
//		my.move=1;
	my.function=part_Xblockfade;
}

function collect_particle()
{
	my.vel_y=random(5)-2.5;
	my.vel_x=random(5)-2.5;
	my.vel_z=0;
	my.size=3;
//		my.transparent=1;
//		my.alpha=80;
	my.bright=1;
	my.flare=1;
	my.move=1;
	my.lifespan=10;
	my.function=lightning_alphafade;

}

function item_particle()
{
	my.bmap=blue_particle_map;
	collect_particle();
}

function power_particle()
{
	if (random(2)<1)
	{
		my.bmap=yellow_particle_map;
	}
	else
	{
		my.bmap=orange_particle_map;
	}
	collect_particle();
}

function part_shinefade()
{
	my.alpha-=time;
	my.alpha=max(0,my.alpha);
	if (my.alpha==0)
	{
		my.lifespan=0;
	}
}

function shine_particle()
{
	vec_add(my.x,my.vel_x);
	my.vel_z=random(80)-40;
	my.vel_x=random(80)-40;
	my.vel_y=random(80)-40;
	my.bmap=white_particle_map;
	my.SIZE=2;
	my.FLARE=1;
	my.alpha=35;
	my.bright=1;
	my.streak=1;
	my.function=part_shinefade;

}

function part_smokefade()
{
	my.size += time + time;
	my.alpha -= 3 * time;
	if (my.alpha <= 0)
	{
		my.lifespan = 0;
	}
}

function smoke_particle()
{
	my.Z-=5;
	my.vel_x=0.2+random(1);
	my.vel_y=0.2+random(1);
	if (int(random(2))==1)
	{
		my.vel_x*=-1;
		my.vel_y*=-1;
	}
	my.vel_z=3;
	my.bmap=smoke_particle_map;
	my.alpha=35;
	my.size=10;
	my.flare=1;
	my.move=1;
	my.function=part_smokefade;
}

function fixed_smoke_particle()
{
	my.x += int(random(5));
	my.y += int(random(5));
	my.z += int(random(5));
	my.bmap = smoke_particle_map;
	my.alpha = 35;
	my.size = 10;
	my.flare = on;
	my.move = off;
	my.function = part_smokefade;
}

function Xhit_event()
{
	my.X=my.X-10+random(20);
	my.Y=my.Y-10+random(20);
	my.Z+=30+random(15);
//		my.red=140;
//		my.green=50;
//		my.blue=20;
	if (int(random(2))==0)
	{
		my.bmap=orange_particle_map;
	} else {
		my.bmap=yellow_particle_map;
	}
	my.size=3;
	my.vel_Z=-2.5-random(1);
	my.vel_X=-1.5+random(3);
	my.vel_Y=-1.5+random(3);
	my.flare=1;
	my.bright=1;
//		my.streak=1;
	my.move=1;
	my.lifespan=15;
	my.function=lightning_alphafade;
}


function part_attackfade()
{
	my.alpha = max(0, my.alpha - 10 * time);
	if (my.alpha == 0)
	{
		my.lifespan=0;
	}
}

function Xattackpart_event()
{
	my.bmap = brightyellow_particle_map;
	my.function = part_attackfade;
	my.alpha = 50;
	my.flare = on;
	my.size = 5;
	my.beam = on;
	my.bright = on;
}

function Xspecialattackpart_event()
{
	my.bmap = brightorange_particle_map;
	my.function = part_attackfade;
	my.alpha = 50;
	my.flare = on;
	my.size = 5;
	my.beam = on;
	my.bright = on;
}

////////////////////////////////////////////
function part_weaponfx()
{
	you = my.skill_y; //no handle - speed issue
//position update
	vec_set (my.skill_a, vector (6, 0, 0));
	vec_rotate (my.skill_a, your.pan);
	vec_set (my.x, your.x);
	vec_add (my.x, my.skill_a);
//beam direction update
	vec_set (my.vel_x, vector (32, 0, 0));
	vec_rotate (my.vel_x, your.pan);
//effects
	my.alpha = 10 + abs(40 * cos(timer * 5));
	my.size = 3 + abs(3 * sin(timer * 7));
//current weapon mode still active?
	if (your.weapon_type != my.skill_x)
	{
		my.lifespan = 0;
	}
	else
	{
		my.lifespan = 10;
	}
}

function Xweaponpart_event()
{
	my.skill_x = my.vel_z; //weapon_type
	my.skill_y = my.vel_x; //pointer to emitting entity
	vec_set (my.vel_x, nullvector);
	if (my.skill_x == wep_fireball)
	{
		my.bmap = red_particle_map;
	}
	if (my.skill_x == wep_acidball)
	{
		my.bmap = green_particle_map;
	}
	if (my.skill_x == wep_lightning)
	{
		my.bmap = blue_particle_map;
	}
	my.flare = on;
	my.beam = on;
	my.bright = on;
	my.alpha = 50;
	my.function = part_weaponfx;
}

function part_ammofade()
{
	you = my.skill_d; //no handle - speed issue
	//position update
	vec_for_vertex(my.skill_x, you, your.skill1);
	vec_for_vertex (my.x, you, your.skill3);
	vec_add (my.x, my.skill_x);
	vec_scale (my.x, 0.5);

	my.alpha -= 5 * time;
	my.alpha = max (0, my.alpha);
	if (my.alpha == 0 || game_status == stat_gameover)
	{
		my.lifespan=0;
	}
}

function Xammopart_event()
{
	my.skill_d = my.vel_x;
	if (my.vel_z == wep_fireball)
	{
		my.bmap = red_particle_map;
	}
	if (my.vel_z == wep_acidball)
	{
		my.bmap = green_particle_map;
	}
	if (my.vel_z == wep_lightning)
	{
		my.bmap = blue_particle_map;
	}
	my.skill_a = random (360);
	my.skill_b = random (360);
	my.skill_c = random (360);
	vec_set (my.vel_x, vector(15, 15, 15));
	vec_rotate (my.vel_x, my.skill_a);
	my.size = 4;
	my.flare = on;
	my.alpha = 50;
	my.bright = on;
	my.streak = on;
//	my.move = on;
	my.function = part_ammofade;
}


function Xparticle_debug()
{
	my.bmap = red_particle_map;
	my.function = null;
	my.alpha = 50;
	my.flare = on;
	my.size = 5;
	my.beam = on;
	my.bright = on;
	my.lifespan = 100;
}