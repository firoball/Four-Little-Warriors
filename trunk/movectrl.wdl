///////////////////////////////////////////////////////////////////////////////////
// ~ 4 Little Warriors ~ Movement Control WDL
//
// Modified by Firoball  02/07/2006 (created 02/18/2005)
///////////////////////////////////////////////////////////////////////////////////

//////////Prototypes
function init_basics();
function select_movement(pl);
function key1_move();
function key2_move();
function mouse_move();
function joy1_move();
function joy2_move();
/*
function init_netplayer(); //outdated
function create_netplayer(); //outdated
function player_netmove(); //outdated
*/
//////////Variables
var playerlist[4];
var joy_buf[3];

//////////Player init

function init_basics()
{
	my.scale_z = 0.9;
	my.typ = plr;
	my.anim_fac = 4.5;
	my.stamina = 0;
	my.mode = Pmode_walk;
	my.oldMode = my.mode;
 	my.lastMode = my.mode;
	my.narrow = on;
	my.fat = off;
	my.enable_shoot = on;
	my.enable_scan = on;
	my.enable_detect = on;
	my.enable_stuck = on;
	my.enable_impact = on;
	my.enable_push = on;
	my.event = player_event;
	my.push = 0;
	my.ambient = 0;
	my.trigger_range = PtrigRange;
	you = ent_create("sword.mdl", nullvector, vertex_attach);
	if (polyshadows != 0) {my.shadow = on;}
	else {drop_shadow();}
//	add_item (me);
}

//////////Movement Control routines

function select_movement(pl)
{
	if(player_ctl_type[pl] == ctl_key1)
	{
		key1_move();
		return;
	}
	if(player_ctl_type[pl] == ctl_key2)
	{
		key2_move();
		return;
	}
	if(player_ctl_type[pl] == ctl_mouse)
	{
		mouse_move();
		return;
	}
	if(player_ctl_type[pl] == ctl_joy1)
	{
		joy1_move(player_ctl_mode[pl]);
		return;
	}
	if(player_ctl_type[pl] == ctl_joy2)
	{
		joy2_move(player_ctl_mode[pl]);
		return;
	}
}

function key1_move(test)
{
	var index;
	var key_press;
	var key_timer;
	var key_blocktimer;
	index = 5 * ctl_key1;
	key_press = 0;
	key_timer = 0;
	key_blocktimer = 0;
	while (game_status != stat_gameover)
	{
		//deactivate attack mode
		if (my.mode == Pmode_lock || my.mode == Pmode_hit || my.mode == Pmode_critHit)
		{
			key_press = 0;
			key_timer = 0;
			key_blocktimer = 0;
			my.fPspecial = off;
		}

		if (!key_pressed(player_keys[index + k_fire]))
		{
			//disable block
			if (key_press == 3)
			{
				key_press = 0;
				key_blocktimer = 0;
			 	my.fPblock = off;
			}
			//key released too long?
			if (key_press == 2)
			{
				key_timer += time;
				if (key_timer > 3) {key_press = 0;}
			}
			//key released 1st time, start key_timer
			if (key_press == 1)
			{
				key_blocktimer = 0;
				key_press = 2;
			}
		}

		//prepare attack if block is _not_active and modes are ok
		if (key_pressed(player_keys[index + k_fire]) && key_press != 3 &&
			(my.mode == Pmode_walk || my.mode == Pmode_charge))
		{
			//trigger special attack
			if (key_press == 2)
			{
				if (my.stamina == 100) {my.fPspecial = on;}
				key_press = 0;
				key_timer = 0;
			}
			else
			{
				key_timer = 0;
				key_press = 1;
		   		my.mode = Pmode_charge; //switch to fighting mode
				key_blocktimer += time;
				//enable block after certain amoint of time
				if (key_blocktimer > 3.5)
				{
					key_press = 3;
					player_block();
				}
			}
  		}
		if (my.mode != Pmode_hit && my.mode != Pmode_critHit && my.mode != Pmode_lock && my.mode != Pmode_ko)
		{
			if (key_pressed(player_keys[index + k_right]))
			{
				my.pan = ang(my.pan - PforcePan * time);
			}
			if (key_pressed(player_keys[index + k_left]))
			{
				my.pan = ang(my.pan + PforcePan * time);
			}
			if (key_pressed(player_keys[index + k_up]))
			{
				my.forceX = PforceX;
			}
			if (key_pressed(player_keys[index + k_down]))
			{
				my.forceX = PforceXneg;
			}
		}
		player_move();
		wait (1);
	}
	my.transparent = off;
	my.fPblock = off;
}

function key2_move()
{
	var index;
	var key_press;
	var key_timer;
	var key_blocktimer;
	index = 5 * ctl_key2;
	key_press = 0;
	key_timer = 0;
	key_blocktimer = 0;
	while (game_status != stat_gameover)
	{
		if (my.mode == Pmode_lock || my.mode == Pmode_hit || my.mode == Pmode_critHit)
		{
			key_press = 0;
			key_timer = 0;
			key_blocktimer = 0;
			my.fPspecial = off;
		}

		if (!key_pressed(player_keys[index + k_fire]))
		{
			if (key_press == 3)
			{
				key_press = 0;
				key_blocktimer = 0;
			 	my.fPblock = off;
			}
			if (key_press == 2)
			{
				key_timer += time;
				if (key_timer > 3) {key_press = 0;}
			}
			if (key_press == 1)
			{
				key_blocktimer = 0;
				key_press = 2;
			}
		}

		if (key_pressed(player_keys[index + k_fire]) && key_press != 3 &&
			(my.mode == Pmode_walk || my.mode == Pmode_charge))
		{
			if (key_press == 2)
			{
				if (my.stamina == 100) {my.fPspecial = on;}
				key_press = 0;
				key_timer = 0;
			}
			else
			{
				key_timer = 0;
				key_press = 1;
		   		my.mode = Pmode_charge; //switch to fighting mode
				key_blocktimer += time;
				if (key_blocktimer > 3.5)
				{
					key_press = 3;
					player_block();
				}
			}
		}
		if (my.mode != Pmode_hit && my.mode != Pmode_critHit && my.mode != Pmode_lock && my.mode != Pmode_ko)
		{
			if (key_pressed(player_keys[index + k_right]))
			{
				my.pan = ang(my.pan - PforcePan * time);
			}
			if (key_pressed(player_keys[index + k_left]))
			{
				my.pan = ang(my.pan + PforcePan * time);
			}
			if (key_pressed(player_keys[index + k_up]))
			{
				my.forceX = PforceX;
			}
			if (key_pressed(player_keys[index + k_down]))
			{
				my.forceX = PforceXneg;
			}
		}
		player_move();
		wait (1);
	}
	my.transparent = off;
	my.fPblock = off;
}

function mouse_move()
{
	var index;
	var key_press;
	var key_timer;
	var key_blocktimer;
	index = 5 * ctl_mouse;
	key_press = 0;
	key_timer = 0;
	key_blocktimer = 0;
	while (game_status != stat_gameover)
	{
		if (my.mode == Pmode_lock || my.mode == Pmode_hit || my.mode == Pmode_critHit)
		{
			key_press = 0;
			key_timer = 0;
			key_blocktimer = 0;
			my.fPspecial = off;
		}

		if (!key_pressed(player_keys[index + k_fire]))
		{
			if (key_press == 3)
			{
				key_press = 0;
				key_blocktimer = 0;
			 	my.fPblock = off;
			}
			if (key_press == 2)
			{
				key_timer += time;
				if (key_timer > 3) {key_press = 0;}
			}
			if (key_press == 1)
			{
				key_blocktimer = 0;
				key_press = 2;
			}
		}

		if (key_pressed(player_keys[index + k_fire]) && key_press != 3 &&
			(my.mode == Pmode_walk || my.mode == Pmode_charge))
		{
			if (key_press == 2)
			{
				if (my.stamina == 100) {my.fPspecial = on;}
				key_press = 0;
				key_timer = 0;
			}
			else
			{
				key_timer = 0;
				key_press = 1;
		   		my.mode = Pmode_charge; //switch to fighting mode
				key_blocktimer += time;
				if (key_blocktimer > 3.5)
				{
					key_press = 3;
					player_block();
				}
			}
		}
		if (my.mode != Pmode_hit && my.mode != Pmode_critHit && my.mode != Pmode_lock && my.mode != Pmode_ko)
		{
			if (mouse_force.x < -0.01)
			{
				my.pan = ang(my.pan + (PforcePan * 0.27 + PforcePan * 0.63 * time));
			}
			if (mouse_force.x > 0.01)
			{
				my.pan = ang(my.pan - (PforcePan * 0.27 + PforcePan * 0.63 * time));
			}
/*
			if (mouse_force.x > 0.01)
			{
				my.pan = ang(my.pan - (PforcePan * 0.25 + PforcePan * 0.75 * time));
			}
			if (mouse_force.x < -0.01)
			{
				my.pan = ang(my.pan + (PforcePan * 0.25 + PforcePan * 0.75 * time));
			}
*/
			if (key_pressed(player_keys[index + k_up]))
			{
				my.forceX = PforceX;
			}
			if (key_pressed(player_keys[index + k_down]))
			{
				my.forceX = PforceXneg;
			}
		}
		player_move();
		wait (1);
	}
	my.transparent = off;
	my.fPblock = off;
}

function joy1_move(joymode)
{
	var index;
	var key_press;
	var key_timer;
	var key_blocktimer;
	index = 5 * ctl_joy1;
	key_press = 0;
	key_timer = 0;
	key_blocktimer = 0;
	while (game_status != stat_gameover)
	{
		if (my.mode == Pmode_lock || my.mode == Pmode_hit || my.mode == Pmode_critHit)
		{
			key_press = 0;
			key_timer = 0;
			key_blocktimer = 0;
			my.fPspecial = off;
		}

		if (!key_pressed(player_keys[index + k_fire]))
		{
			if (key_press == 3)
			{
				key_press = 0;
				key_blocktimer = 0;
			 	my.fPblock = off;
			}
			if (key_press == 2)
			{
				key_timer += time;
				if (key_timer > 3) {key_press = 0;}
			}
			if (key_press == 1)
			{
				key_blocktimer = 0;
				key_press = 2;
			}
		}

		if (key_pressed(player_keys[index + k_fire]) && key_press != 3 &&
			(my.mode == Pmode_walk || my.mode == Pmode_charge))
		{
			if (key_press == 2)
			{
				if (my.stamina == 100) {my.fPspecial = on;}
				key_press = 0;
				key_timer = 0;
			}
			else
			{
				key_timer = 0;
				key_press = 1;
		   		my.mode = Pmode_charge; //switch to fighting mode
				key_blocktimer += time;
				if (key_blocktimer > 3.5)
				{
					key_press = 3;
					player_block();
				}
			}
		}
		if (my.mode != Pmode_hit && my.mode != Pmode_critHit && my.mode != Pmode_lock && my.mode != Pmode_ko)
		{
			if (joymode ==0)
			{
				//original mode
	            if (joy_raw.x < -50)
	            {
	                my.pan = ang(my.pan + PforcePan * time);
	            }
	            if (joy_raw.x > 50)
	            {
	                my.pan = ang(my.pan - PforcePan * time);
	            }
	            if (joy_raw.y < -50)
	            {
	                my.forceX = PforceX;
	            }
	            if (joy_raw.y > 50)
	            {
	                my.forceX = PforceXneg;
	            }
			}
			else
			{
				//analog mode
	            if (joy_raw.x < 50 && joy_raw.x > -50)
	            {
	                joy_buf.x = 0;
	            }
	            else
	            {
	                joy_buf.x = clamp(joy_raw.x, -240, 240);
	            }

	            if (joy_raw.y < 50 && joy_raw.y > -50)
	            {
	                joy_buf.y = 0;
	            }
	            else
	            {
	                joy_buf.y = clamp(joy_raw.y, -240, 240);
	            }
	            if (joy_buf.x != 0 || joy_buf.y != 0)
	            {
	                vec_to_angle(my_angle, joy_buf);
	                temp = 1;
	                if (camera.pan > -135 && camera.pan <= -45 || camera.pan > 45 && camera.pan <= 135)
	                {
	                    temp = -1;
	                }
	                my.pan = ang(my_angle.pan - cam_angle/*camera*/.pan - 90 * temp);
	                if (joy_buf.x > 150 || joy_buf.x < -150 || joy_buf.y > 150 || joy_buf.y < -150)
	                {
	                    my.forceX = PforceX;
	                }
	            }

			}
		}
		player_move();
		wait (1);
	}
	my.transparent = off;
	my.fPblock = off;
}

function joy2_move(joymode)
{
	var index;
	var key_press;
	var key_timer;
	var key_blocktimer;
	index = 5 * ctl_joy2;
	key_press = 0;
	key_timer = 0;
	key_blocktimer = 0;
	while (game_status != stat_gameover)
	{
		if (my.mode == Pmode_lock || my.mode == Pmode_hit || my.mode == Pmode_critHit)
		{
			key_press = 0;
			key_timer = 0;
			key_blocktimer = 0;
			my.fPspecial = off;
		}

		if (!key_pressed(player_keys[index + k_fire]))
		{
			if (key_press == 3)
			{
				key_press = 0;
				key_blocktimer = 0;
			 	my.fPblock = off;
				my.fPspecial = off;
			}
			if (key_press == 2)
			{
				key_timer += time;
				if (key_timer > 3) {key_press = 0;}
			}
			if (key_press == 1)
			{
				key_blocktimer = 0;
				key_press = 2;
			}
		}

		if (key_pressed(player_keys[index + k_fire]) && key_press != 3 &&
			(my.mode == Pmode_walk || my.mode == Pmode_charge))
		{
			if (key_press == 2)
			{
				if (my.stamina == 100) {my.fPspecial = on;}
				key_press = 0;
				key_timer = 0;
			}
			else
			{
				key_timer = 0;
				key_press = 1;
		   		my.mode = Pmode_charge; //switch to fighting mode
				key_blocktimer += time;
				if (key_blocktimer > 3.5)
				{
					key_press = 3;
					player_block();
				}
			}
		}
		if (my.mode != Pmode_hit && my.mode != Pmode_critHit && my.mode != Pmode_lock && my.mode != Pmode_ko)
		{
			if (joymode ==0)
			{
				//original mode
	            if (joy2_raw.x < -50)
	            {
	                my.pan = ang(my.pan + PforcePan * time);
	            }
	            if (joy2_raw.x > 50)
	            {
	                my.pan = ang(my.pan - PforcePan * time);
	            }
	            if (joy2_raw.y < -50)
	            {
	                my.forceX = PforceX;
	            }
	            if (joy2_raw.y > 50)
	            {
	                my.forceX = PforceXneg;
	            }
			}
			else
			{
				//analog mode
	            if (joy2_raw.x < 50 && joy2_raw.x > -50)
	            {
	                joy_buf.x = 0;
	            }
	            else
	            {
	                joy_buf.x = clamp(joy2_raw.x, -240, 240);
	            }

	            if (joy2_raw.y < 50 && joy2_raw.y > -50)
	            {
	                joy_buf.y = 0;
	            }
	            else
	            {
	                joy_buf.y = clamp(joy2_raw.y, -240, 240);
	            }
	            if (joy_buf.x != 0 || joy_buf.y != 0)
	            {
	                vec_to_angle(my_angle, joy_buf);
	                temp = 1;
	                if (camera.pan > -135 && camera.pan <= -45 || camera.pan > 45 && camera.pan <= 135)
	                {
	                    temp = -1;
	                }
	                my.pan = ang(my_angle.pan - cam_angle/*camera*/.pan - 90 * temp);
	                if (joy_buf.x > 150 || joy_buf.x < -150 || joy_buf.y > 150 || joy_buf.y < -150)
	                {
	                    my.forceX = PforceX;
	                }
	            }

			}
		}
		player_move();
		wait (1);
	}
	my.transparent = off;
	my.fPblock = off;
}

//////////Network functions
/*
function init_netplayer()
{
		players+=1;
		init_basics();
		if (players==1) {
				player1=me;
				my.SKIN=1;
				my.INVISIBLE=1;
				while (netstart1==NULL) {wait(1);}
				VEC_SET(my.X,netstart1.X);
				my.INVISIBLE=0;
		}
		player2=netstart2;
		player3=netstart3;
//		player3.pow=my.client;
		player4=netstart4;
		if (players==2) {
				player2=me;
				my.SKIN=2;
				my.INVISIBLE=1;
				while (netstart2==NULL) {wait(1);}
				VEC_SET(my.X,netstart2.X);
				my.INVISIBLE=0;
		}
		if (players==3) {
				player3=me;
				my.SKIN=3;
				my.INVISIBLE=1;
				while (netstart3==NULL) {wait(1);}
				VEC_SET(my.X,netstart3.X);
				my.INVISIBLE=0;
		}
		if (players==4) {
				player4=me;
				my.SKIN=4;
				my.INVISIBLE=1;
				while (netstart4==NULL) {wait(1);}
				VEC_SET(my.X,netstart4.X);
				my.INVISIBLE=0;
		}
//		VEC_SET (netcampos,CAmeRA.X);
//		SEND_var (netcampos);
		wait(1);
		trace_mode= ignore_me+ignore_you+ignore_passents+ignore_passable
			+ ignore_sprites+ignore_models+activate_sonar;
		vec_set (temp,my.x);
		temp.Z-=300;
		trace (my.x,temp);
		my.Z=TARGET.Z-my.MIN_Z+5;
		if (my.INVISIBLE==1) {
				my.PASSABLE=1;
				return;
		} else {
				drop_shadow();
				while (game_status!=stat_running) {wait(1);}
				player_netmove();
//				drop_shadow();
//				you=ent_create("invul.mdl",my.x,invul);
		}
}
*/
///////////////////////////////////////////////////////////////////////////////////
/*
function create_netplayer()
{
		VEC_SET (temp,NULLVECTOR);
		you=ent_create("player.mdl",temp,init_netplayer);
		player1=you;
		while (player1) {
				player1.netFire=KEY_CTRL;
				player1.netX=KEY_CUL-KEY_CUR;
				player1.netY=KEY_CUU-KEY_CUD;
				SEND player1.netFire;
				SEND player1.netX;
				SEND player1.netY;
				ifDEF SERVER;
				cam_move();
				ENDif;
				ifNDEF SERVER;
				cam_netmove();
				ENDif;
				wait(1);
		}
}
function player_netmove()
{
		while (game_status!=stat_gameover)
		{
				my.forceX=0;
				if (my.netFire!=0 && my.mode==0) {my.mode=1;} //switch to fighting mode
				if (my.mode!=3 && my.mode!=4 && my.mode!=-1) {
						if (my.netX==-1) {my.PAN=ANG(field.PAN)-90; my.forceX=10;}
						if (my.netX==1) {my.PAN=ANG(field.PAN)+90; my.forceX=10;}
						if (my.netY==1) {my.PAN=ANG(field.PAN); my.forceX=10;}
						if (my.netY==-1) {my.PAN=ANG(field.PAN)-180; my.forceX=10;}
				}
				player_move();
				wait(1);
		}
}
*/
///////////////////////////////////////////////////////////////////////////////////

//////////Actions

define attachcenter, skill1;
define attachdirection, skill2;
// uses attachcenter, attachdirection
action init_player1
{
ifdef server;
	if (my.invisible==0)
	{
		my.invisible=1;
		my.passable=1;
		netstart1=me;
		return;
	}
endif;
	player1=me;
	playerlist[0] = handle(me);
	dbselect_player(0);
	init_basics();
	my.skin=1;
	wait(1);
	trace_mode= ignore_me+ignore_you+ignore_passents+ignore_passable+
		ignore_sprites+ignore_models+activate_sonar;
	vec_set (temp,my.x);
	temp.z-=300;
	trace (my.x,temp);
	my.z=target.z-my.min_z/*+5*/;
	if (my.invisible==1)
	{
		my.passable=1;
		cam_move();
		return;
	}
	else
	{
		cam_move();
		while (game_status!=stat_running) {wait(1);}
		if ((player_active&1)==1)
		{
			select_movement(0);
		}
		else
		{
			cpu_move();
		}
		if (player_won[0] == game_limit - 1 && game_limit > 1)
		{
			ent_create("exmark.tga", my.x, player_mark);
		}
	}
}

// uses attachcenter, attachdirection
action init_player2
{
ifdef server;
	if (my.invisible==0)
	{
		my.invisible=1;
		my.passable=1;
		netstart2=me;
		return;
	}
endif;
	player2=me;
	playerlist[1] = handle(me);
	dbselect_player(1);
	init_basics();
	my.skin=2;
	wait(1);
	trace_mode= ignore_me+ignore_you+ignore_passents+ignore_passable+
		ignore_sprites+ignore_models+activate_sonar;
	vec_set (temp,my.x);
	temp.z-=300;
	trace (my.x,temp);
	my.z=target.z-my.min_z/*+5*/;
	if (my.invisible==1)
	{
		my.passable=1;
		return;
	}
	else
	{
		while (game_status!=stat_running) {wait(1);}
		if ((player_active&2)==2)
		{
			select_movement(1);
		}
		else
		{
			cpu_move();
		}
		if (player_won[1] == game_limit - 1 && game_limit > 1)
		{
			ent_create("exmark.tga", my.x, player_mark);
		}
	}
}

// uses attachcenter, attachdirection
action init_player3
{
ifdef server;
	if (my.invisible==0)
	{
		my.invisible=1;
		my.passable=1;
		netstart3=me;
		return;
	}
endif;
	player3=me;
	playerlist[2] = handle(me);
	dbselect_player(2);
	init_basics();
	my.skin=3;
	wait(1);
	trace_mode= ignore_me+ignore_you+ignore_passents+ignore_passable+
		ignore_sprites+ignore_models+activate_sonar;
	vec_set (temp,my.x);
	temp.z-=300;
	trace (my.x,temp);
	my.z=target.z-my.min_z/*+5*/;
	if (my.invisible==1)
	{
		my.passable=1;
		return;
	}
	else
	{
		while (game_status!=stat_running) {wait(1);}
		if ((player_active&4)==4)
		{
			select_movement(2);
		}
		else
		{
			cpu_move();
		}
		if (player_won[2] == game_limit - 1 && game_limit > 1)
		{
			ent_create("exmark.tga", my.x, player_mark);
		}
	}
}

// uses attachcenter, attachdirection
action init_player4
{
ifdef server;
	if (my.invisible==0)
	{
		my.invisible=1;
		my.passable=1;
		netstart4=me;
		return;
	}
endif;
	player4=me;
	playerlist[3] = handle(me);
	dbselect_player(3);
	init_basics();
	my.skin=4;
	wait(1);
	trace_mode= ignore_me+ignore_you+ignore_passents+ignore_passable+
		ignore_sprites+ignore_models+activate_sonar;
	vec_set (temp,my.x);
	temp.z-=300;
	trace (my.x,temp);
	my.z=target.z-my.min_z/*+5*/;
	if (my.invisible==1)
	{
		my.passable=1;
		return;
	}
	else
	{
		while (game_status!=stat_running) {wait(1);}
		if ((player_active&8)==8)
		{
			select_movement(3);
		}
		else
		{
			cpu_move();
		}
		if (player_won[3] == game_limit - 1 && game_limit > 1)
		{
			ent_create("exmark.tga", my.x, player_mark);
		}
	}
}