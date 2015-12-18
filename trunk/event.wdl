///////////////////////////////////////////////////////////////////////////////////
// ~ 4 Little Warriors ~ Event WDL
//
// modified by Firoball  04/23/2007
///////////////////////////////////////////////////////////////////////////////////

//////////Prototypes
function event_listener();
function anim_event(eventtype);
function event_upsidedown();
function event_rotate();
function activate_equalize();
function event_equalize();
function activate_monopoly();
function event_monopoly();//(modelent);
function exchange_pos(object1, object2);
function event_position();
function event_highspeed();
function event_slowmotion();
function event_superpower();

//////////Variables
var eventtype;
var event_temp;
var timecounter;
var upsidedowncount;
var time_cor;
var tempscale[4];
var tempmode[4];
//var eventblock;

//////////Strings
string eventnr_str, "xx";
string pcx_str, ".pcx";
string eventtemp_str, "123456789012";
string event_str, "event";

//////////Pointers
entity* monopoly_ent;

//////////Functions
function event_listener()
{
	proc_kill(4);
	while(game_status != stat_gameover)
	{
		if (event_trig != Enone && eventblock == 0)
		{
			snd_play (event_snd, 70, 0);
			events = event_trig;
			anim_event(event_trig);
			if (event_trig == Ehighspeed)
			{
				event_highspeed();
			}
			if (event_trig == Eslowmotion)
			{
				event_slowmotion();
			}
			if (event_trig == Erotation)
			{
				event_rotate();
			}
			if (event_trig == Eposition)
			{
				event_position();
			}
			if (event_trig == Emonopoly)
			{
				event_monopoly();
			}
			if (event_trig == Eequalize)
			{
				event_equalize();
			}
			if (event_trig == Eupsidedown)
			{
				event_upsidedown();
			}
			if (event_trig == Esuperpower)
			{
				event_superpower();
			}
			event_trig = Enone;
			wait (1);
			event_ptr = null;
		}
		event_trig = Enone;
		sleep (0.2);
	}
	event_trig = Enone;
	events = event_trig;
	event_ptr = null;
}

function anim_event(eventtype)
{
		eventblock=1;
		my=event_ent;
		str_cpy(eventtemp_str,event_str);
		str_for_num (eventnr_str,eventtype);
		str_cat (eventtemp_str,eventnr_str);
		str_cat (eventtemp_str,pcx_str);
		ent_purge(me);
		ent_morph(me,eventtemp_str);
		my.scale_x=1;
		my.scale_y=1;
		my.alpha=50;
		ifndef no_hud;
		my.visible=1;
		endif;
		vec_set (my.pan,nullvector);
		my.pan=entpan;
		my.y=0;
		my.z=0;
		my.x=350;
		event_temp=my.x;
		if (eventtype==6)
		{
				my.scale_x=4.5;
		}
		if (eventtype==5)
		{
				my.scale_y=5;
		}
		if (eventtype==8)
		{
				my.x=250;
		}
	if (eventtype==1)
		{
			my.pan=entpan-65;
		my.x=600;
				my.y=300;
		}
/*
		if (eventtype==1)
		{
				my.visible=1;
				my.y=250;
				my.pan=180;
				while (my.y>-250)
				{
						wait(1);
						my.y-=20*time;
						my.x=350+abs(50*sin(timer*5));
				}
				my.y=160;
				my.visible=0;
				ent_purge (me);
				eventblock=0;
				return;
		}
*/
	my.skill4=timer;
		while (my.alpha>0 && game_status != stat_gameover)
		{
				wait(1);
				my.alpha-=2.5*time;
		if (eventtype==1)
				{
//		  my.x=350-350*abs(cos((timer-my.skill4)*3));
//		  my.y=100*cos((timer-my.skill4)*3);
					my.pan=(130*sin((timer-my.skill4)*3)+(entpan-65));
			my.x=250+350*abs(sin(my.pan));
			my.y=300*sin(my.pan-(180-entpan));

		}
				if (eventtype==4)
				{
			my.pan+=21*time;
				}
				if (eventtype==6)
				{
						my.scale_x-=0.4*time;
						my.scale_x=max(my.scale_x,1);
				}
				if (eventtype==2)
				{
						my.scale_x=0.75+0.25*sin(timer*15);
						my.scale_y=0.75+0.5*cos(timer*20);
						my.x=event_temp/(camera.arc/60);
				}
				if (eventtype==3)
				{
						my.x+=15*time;
						my.roll+=15*time;
				}
				if (eventtype==7)
				{
						my.roll=45*sin(timer*15);
				}
				if (eventtype==8)
				{
						my.x+=25*time;
						my.scale_x+=0.02*time;
						my.tilt-=3*time;
				}
				if (eventtype==5)
				{
						my.scale_y-=0.45*time;
						my.scale_y=max(my.scale_y,1);
				}
		}
		my.alpha=0;
		my.visible=0;

		ent_purge (me);
		eventblock=0;
}


function event_upsidedown()
{
	proc_kill(4);
	camera.roll = 180;
	while (upsidedowncount < 32 && game_status != stat_gameover)
	{
		camera.roll = 180 + (32 - upsidedowncount) * sin (upsidedowncount * 40) / 8;
		upsidedowncount += time;
		wait (1);
	}
	camera.roll = 180;
	timecounter = EtimeUpsidedown * 16;
	while (timecounter > 0 && events == Eupsidedown && game_status != stat_gameover)
	{
		timecounter -= time;
		wait (1);
	}
	if (events == Eupsidedown) {events = Enone;}
	camera.roll = 0;
	while (upsidedowncount > 0 && game_status != stat_gameover)
	{
		camera.roll = upsidedowncount * sin(upsidedowncount * 40) / 8;
		upsidedowncount -= time;
		upsidedowncount = max (upsidedowncount, 0);
		wait (1);
	}
	camera.roll = 0;
}

function event_rotate()
{
	proc_kill(4);
	temp = int (random (3));
	if (temp == 0)
	{
		cam_angle.pan += 90;
	}
	if (temp==1)
	{
		cam_angle.pan -= 90;
	}
	if (temp==2)
	{
		cam_angle.pan += 180;
	}
	cam_angle.pan = ang (cam_angle.pan);
	if (scenemap != null)
	{
		scenemap.x = 636 * cos (cam_angle.pan);
		scenemap.y = 636 * sin (cam_angle.pan);
		scenemap.z = -32;
		scenemap.pan = cam_angle.pan;
	}
}

///////////////////////////////////////////////////////////////////////////////////

function activate_equalize(ent)
{
	proc_kill(4);
	me = ent;
	my.transparent = on;
	my.alpha = 0;
	my.bright = on;
	my.passable = on;
	my.ambient = 70;
	my.scale_x = 3.5;
	my.scale_y = 3.5;
	my.scale_z = 3.5;
//	my.frame = 2;
	ifndef no_hud;
	my.visible = on;
	endif;
	while(my.alpha < 100 && game_status != stat_gameover)
	{
		wait (1);
		my.alpha += 8 * time;
		my.alpha = min (my.alpha, 100);
		my.pan += 6 * time;
	}
	while(my.alpha>0 && game_status != stat_gameover)
	{
		wait (1);
		my.alpha -= 8 * time;
		my.alpha = max (my.alpha, 0);
		my.pan += 6 * time;
	}
	my.visible = off;
	wait (1);
	ent_purge (me);
//	ent_remove (me);
}

function event_equalize()
{
	temp = 0.8 * (player1.pow + player2.pow + player3.pow + player4.pow) / 4;
	player1.pow = player1.pow * 0.2 + temp;
	player2.pow = player2.pow * 0.2 + temp;
	player3.pow = player3.pow * 0.2 + temp;
	player4.pow = player4.pow * 0.2 + temp;

	vec_set (temp, vector(400, 0, 0));
	vec_set (inst1_ent.x, temp);
	rel_to_screen (temp, camera);
	temp.z = 200;
	vec_for_screen (temp, camera);
	ent_morph(inst1_ent, "spower.mdl");
	activate_equalize(inst1_ent);

	monopoly_ent = player1;
	you = ent_create ("spower.mdl", temp.x, activate_monopoly);

	monopoly_ent = player2;
	you = ent_create ("spower.mdl", temp.x, activate_monopoly);

	monopoly_ent = player3;
	you = ent_create ("spower.mdl", temp.x, activate_monopoly);

	monopoly_ent = player4;
	you = ent_create ("spower.mdl", temp.x, activate_monopoly);
}

///////////////////////////////////////////////////////////////////////////////////

function activate_monopoly()
{
	if (game_status==stat_gameover) {return;}
	you = monopoly_ent;
	my.transparent = on;
	my.ambient = 100;
	my.alpha = 80;
	my.bright = on;
	my.passable = on;
	my.frame = 2;
	while (game_status != stat_gameover)
	{
		wait (1);
		vec_set (temp, your.x);
		vec_sub (temp, my.x);
		vec_to_angle (my_angle, temp);
		my.speedX = 25 * cos (my_angle.pan) * cos (my_angle.tilt) * time;
		my.speedY = 25 * sin (my_angle.pan) * cos (my_angle.tilt) * time;
		my.speedZ = 25 * sin (my_angle.tilt) * time;
		move_mode = ignore_you + ignore_passable + ignore_passents + ignore_maps + ignore_models + ignore_sprites + glide;
		ent_move (nullvector, my.speedX);

		if (vec_length (temp) < 15)
		{
			break;
		}
	}
	my.invisible = on;
	if (game_status != stat_gameover)
	{
	  	ent_playsound (me, collect_snd, 600);
		sleep (1);
	}
	wait (1);
	ent_purge (me);
	ent_remove (me);
}

function event_monopoly()//(modelent)
{
//	you = modelent;
//	if (you != player1 && you != player2 && you != player3 && you != player4)
	if (event_ptr == null)
	{
		temp = int (random (4));
		if (temp==0) {you = player1;}
		if (temp==1) {you = player2;}
		if (temp==2) {you = player3;}
		if (temp==3) {you = player4;}
	}
	else
	{
		you = event_ptr;
	}
	temp = 0.15 * (player1.pow + player2.pow + player3.pow + player4.pow);
	player1.pow = player1.pow * 0.85;
	player2.pow = player2.pow * 0.85;
	player3.pow = player3.pow * 0.85;
	player4.pow = player4.pow * 0.85;
	your.pow += temp;
	monopoly_ent = you;

	if(you == player1)
	{
		ent_create ("spower.mdl", player2.x, activate_monopoly);
		ent_create ("spower.mdl", player3.x, activate_monopoly);
		ent_create ("spower.mdl", player4.x, activate_monopoly);
		return;
	}
	if(you == player2)
	{
		ent_create ("spower.mdl", player1.x, activate_monopoly);
		ent_create ("spower.mdl", player3.x, activate_monopoly);
		ent_create ("spower.mdl", player4.x, activate_monopoly);
		return;
	}
	if(you == player3)
	{
		ent_create ("spower.mdl", player2.x, activate_monopoly);
		ent_create ("spower.mdl", player1.x, activate_monopoly);
		ent_create ("spower.mdl", player4.x, activate_monopoly);
		return;
	}
	if(you == player4)
	{
		ent_create ("spower.mdl", player2.x, activate_monopoly);
		ent_create ("spower.mdl", player3.x, activate_monopoly);
		ent_create ("spower.mdl", player1.x, activate_monopoly);
		return;
	}
}

///////////////////////////////////////////////////////////////////////////////////
function exchange_pos(object1, object2)
{
	me = object1;
	you = object2;

	vec_set (my_pos.x, my.x);
	my_angle.pan = my.pan;

	vec_set (my.x, your.x);
	my.pan = your.pan;

	vec_set (your.x, my_pos.x);
	your.pan = my_angle.pan;
}

var tempscale[4];
var tempmode[4];

function event_position()
{
	while (teledelay != 0)
	{
		wait (1);
	}
	proc_kill(4);
	teledelay += 1;
	snd_play (tele1_snd, 50, 0);
	player1.shadow = off;
	player2.shadow = off;
	player3.shadow = off;
	player4.shadow = off;
	player1.flare = off;
	player2.flare = off;
	player3.flare = off;
	player4.flare = off;
	player1.transparent = on;
	player2.transparent = on;
	player3.transparent = on;
	player4.transparent = on;
	tempscale[0] = player1.scale_z;
	tempscale[1] = player2.scale_z;
	tempscale[2] = player3.scale_z;
	tempscale[3] = player4.scale_z;
	tempmode[0] = player1.mode;
	tempmode[1] = player2.mode;
	tempmode[2] = player3.mode;
	tempmode[3] = player4.mode;
	player1.mode = Pmode_lock;
	player2.mode = Pmode_lock;
	player3.mode = Pmode_lock;
	player4.mode = Pmode_lock;
	player1.alpha = 50;
	player2.alpha = 50;
	player3.alpha = 50;
	player4.alpha = 50;
	wait (1);
	while (player1.scale_z < 20 && game_status != stat_gameover)
	{
		wait (1);
		player1.scale_z += 2 * time;
		player2.scale_z += 2 * time;
		player3.scale_z += 2 * time;
		player4.scale_z += 2 * time;
		player1.alpha -= 5 * time;
		player2.alpha -= 5 * time;
		player3.alpha -= 5 * time;
		player4.alpha -= 5 * time;
	}

	player1.scale_z = tempscale[0];
	player2.scale_z = tempscale[1];
	player3.scale_z = tempscale[2];
	player4.scale_z = tempscale[3];
	player1.alpha = 0;
	player2.alpha = 0;
	player3.alpha = 0;
	player4.alpha = 0;
	if (game_status != stat_gameover)
	{
		temp = int(random (3));
		if (temp==0)
		{
			exchange_pos(player1, player2);
			exchange_pos(player3, player4);
		}
		if (temp==1)
		{
			exchange_pos(player1, player3);
			exchange_pos(player2, player4);
		}
		if (temp==2)
		{
			exchange_pos(player1, player4);
			exchange_pos(player3, player2);
		}
	}
	player1.scale_z = 20;
	player2.scale_z = 20;
	player3.scale_z = 20;
	player4.scale_z = 20;

	snd_play (tele2_snd, 50, 0);

	while (player1.scale_z > tempscale[0]  && game_status != stat_gameover)
	{
		wait (1);
		player1.scale_z -= 2 * time;
		player2.scale_z -= 2 * time;
		player3.scale_z -= 2 * time;
		player4.scale_z -= 2 * time;
		player1.alpha += 5 * time;
		player2.alpha += 5 * time;
		player3.alpha += 5 * time;
		player4.alpha += 5 * time;
	}

	player1.scale_z = tempscale[0];
	player2.scale_z = tempscale[1];
	player3.scale_z = tempscale[2];
	player4.scale_z = tempscale[3];
	player1.transparent = off;
	player2.transparent = off;
	player3.transparent = off;
	player4.transparent = off;
	player1.alpha = 50;
	player2.alpha = 50;
	player3.alpha = 50;
	player4.alpha = 50;
	if (player1.sfx == SFXghost) {player1.flare = on;}
	if (player2.sfx == SFXghost) {player2.flare = on;}
	if (player3.sfx == SFXghost) {player3.flare = on;}
	if (player4.sfx == SFXghost) {player4.flare = on;}
	if (polyshadows != 0)
	{
		player1.shadow = on;
		player2.shadow = on;
		player3.shadow = on;
		player4.shadow = on;
	}
//	wait (1);
	player1.mode = tempmode[0];
	player2.mode = tempmode[1];
	player3.mode = tempmode[2];
	player4.mode = tempmode[3];
	events = Enone;
	teledelay -= 1;
	wait (1);
	player1.fat = off;
	player1.narrow = on;
	player2.fat = off;
	player2.narrow = on;
	player3.fat = off;
	player3.narrow = on;
	player4.fat = off;
	player4.narrow = on;

	player_fixZ(player1);
	player_fixZ(player2);
	player_fixZ(player3);
	player_fixZ(player4);
}


///////////////////////////////////////////////////////////////////////////////////

function event_highspeed()
{
	proc_kill(4);
	timecounter = EtimeHighspeed * 16;
	base_speed *= 1.5;
	base_power = 1;

	while (timecounter > 0 && base_speed > orig_speed && events == Ehighspeed && game_status != stat_gameover)
	{
		timecounter -= time;
		wait(1);
	}
	if (events == Ehighspeed) {events = Enone;}
	if (base_speed > orig_speed)
	{
		base_speed = orig_speed;
	}
}

///////////////////////////////////////////////////////////////////////////////////

function event_slowmotion()
{
	proc_kill(4);
	timecounter = EtimeSlowmotion * 16;
	base_speed *= 0.5;
	base_power = 1;
	time_cor = timer;
	while (timecounter > 0 && base_speed < orig_speed && events == Eslowmotion && game_status != stat_gameover)
	{
		timecounter -= time;
		cam_arc = 5 * sin ((timer - time_cor) * 12);
		wait(1);
	}
	if (events == Eslowmotion) {events = Enone;}
	if (base_speed < orig_speed)
	{
		base_speed = orig_speed;
	}
	cam_arc = 0;
}

///////////////////////////////////////////////////////////////////////////////////

function event_superpower()
{
	proc_kill(4);
	timecounter = EtimeSuperpower * 16;
	base_power = 1.5;
	base_speed = orig_speed;
	while (timecounter > 0 && events == Esuperpower && game_status != stat_gameover)
	{
		timecounter -= time;
		wait(1);
	}
	if (base_power == 1.5) {base_power = 1;}
	if (events == Esuperpower) {events = Enone;}
}

///////////////////////////////////////////////////////////////////////////////////