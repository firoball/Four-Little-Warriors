include <ackwii.wdl>;

function wiimote_on();
function wiimote_off();

function init_mc();
function cap_motion();
function wii_schedule();
function wii_select_player();
function wii_select_plr_ena();
function wii_select_plr_dis();
function wii_select_plr_inc();
function wii_select_plr_dec();
function wii_move();
function wii_aux();

var_nsave wii_handle;
var_nsave wiimote_ena;

var wii_vibration;

//////////temporary
function wiimote_on()
{
	wii_handle = dll_open(dll_str);
	if (wii_handle != 0)
	{
		wiimote_ena = 1;
//	on_f12 = wiimote_off;
//	on_wiib = print_list;
		wiimote_motion = cap_motion;
		wiimote_initmotion = init_mc;
		wiimote_activate();
//	wii_panel.visible = on;
		wait (4);
	    wiimote_led(1, 0, 0, 0);
	}
}

function wiimote_off()
{
//	on_f12 = wiimote_on;
    wiimote_led(0, 0, 0, 0);
	wiimote_vibration(0);
	wiimote_deactivate();
	wait (1);
	dll_close(wii_handle);
//	wii_panel.visible = off;
//	wiimote_ena = 0; //intended
}

//on_f12 wiimote_on;


//motion capture
var mc_timer;
var mc_active;

var mc_attackX[2];
var mc_attackY[2];
var mc_attackZ[2];
var mc_attackTime;
var mc_attackStep;

var mc_specialX[2];
var mc_specialY[2];
var mc_specialZ[2];
var mc_specialTime;
var mc_specialStep;

var mc_block[3];
var mc_blockTime;
var mc_blockTimer;

var wii_attack;
var wii_special;
var wii_block;

function init_mc()
{
	mc_timer = 0;
	mc_active = 0;

	mc_attackX[0] = 100;	mc_attackY[0] = /*-5*/50;	mc_attackZ[0] = 150;
	mc_attackX[1] = 700;	mc_attackY[1] = 600;	mc_attackZ[1] = 500;
	mc_attackTime = 0.3 * 16;
	mc_attackStep = 0;

	mc_specialX[0] = 100;	mc_specialY[0] = -150;	mc_specialZ[0] = 150;
	mc_specialX[1] = 300;	mc_specialY[1] = 500;	mc_specialZ[1] = 600;
	mc_specialTime = 0.3 * 16;
	mc_specialStep = 0;

	mc_block.x = 100; 		mc_block.y = -170; 		mc_block.z = 180;
	mc_blockTime = 0.1 * 16;

	wii_schedule();

}

function cap_motion()
{
	if (mc_active != 0)
	{
		mc_timer += time;
	}
	else
	{
		mc_timer = 0;
	}

	//normal attack, step 0
	if (mc_specialStep == 0)
	{
	    if (abs(wiimote_raw.x) < mc_attackX[0] && wiimote_raw.y < mc_attackY[0] && wiimote_raw.z < mc_attackZ[0])
	    {
	        mc_timer = 0;
	        mc_active = 1;
	        mc_attackStep = 1;
	    }
    }
    //normal attack, step 1
	if (mc_attackStep == 1)
	{
		if (mc_timer <= mc_attackTime)
		{
	        if (abs(wiimote_raw.x) < mc_attackX[1] && wiimote_raw.y > mc_attackY[1] && wiimote_raw.z > mc_attackZ[1])
	        {
	            wii_attack = 1;
	            mc_active = 0;
		        mc_attackStep = 0;
	        }
	    }
	    else
	    {
	        mc_active = 0;
	        mc_attackStep = 0;
	    }
	}

	//special attack, step 0
	if (mc_attackStep == 0)
	{
	    if (abs(wiimote_raw.x) < mc_specialX[0] && wiimote_raw.y > mc_specialY[0] && wiimote_raw.z > mc_specialZ[0])
	    {
	        mc_timer = 0;
	        mc_active = 1;
	        mc_specialStep = 1;
	    }
	}

    //special attack, step 1
	if (mc_specialStep == 1)
	{
		if (mc_timer <= mc_specialTime)
		{
	        if (wiimote_raw.x > mc_specialX[1] && wiimote_raw.y > mc_specialY[1] && wiimote_raw.z < mc_specialZ[1])
	        {
	            wii_special = 1;
	            mc_active = 0;
		        mc_specialStep = 0;
	        }
	    }
	    else
	    {
	        mc_active = 0;
	        mc_specialStep = 0;
	    }
	}

	//block
	if (abs(wiichuk_raw.x) < mc_block.x && wiichuk_raw.y < mc_block.y && wiichuk_raw.z < mc_block.z)
	{
		if (mc_blockTimer >= mc_blockTime)
		{
			wii_block = 1;
		}
		else
		{
        	mc_blockTimer += time;
		}

	}
	else
	{
		mc_blockTimer = 0;
		wii_block = 0;
	}

}

var wii_plsel = 0;
entity* wii_ent;
function wii_schedule()
{
	while(wii_active)
	{
		while((game_status == stat_running) && ((player_active & pow(2, wii_plsel)) == pow(2, wii_plsel)) &&
		 (player1 != null) && (player2 != null) && (player3 != null) && (player4 != null))
		{
			on_wiib = on_esc;
        	on_wiiany = on_anykey;
			me = ptr_for_handle(playerlist[wii_plsel]);
			wii_move();
			wii_aux();
			me = null;
			wait (1);
		}

		while((game_status == stat_running) && (player_active == 0) &&
		 (player1 != null) && (player2 != null) && (player3 != null) && (player4 != null))
	    {
				//no player active
	            on_wiib = on_esc;
	            on_wiiany = on_anykey;
	            wait (1);
		}

		while(game_status == stat_menu)
		{
			if (wii_vibration == 1)
			{
				wii_vibration = 0;
				wiimote_vibration(0);
			}
			on_wiiu = on_cuu;
			on_wiid = on_cud;
			on_wiil = on_cul;
			on_wiir = on_cur;
			on_wiib = on_esc;
			if (on_y != null)
			{
				on_wiia = on_y;
			}
			else
			{
				on_wiia = on_enter;
			}
			on_wiiany = on_anykey;
			wii_select_plr_ena();

			if(yelpanel_ent.visible==1 && yelpanel_ent.y==225)
			{
				wii_select_player();
			}

	        if (wiimote_ena == 0)
	        {
	            wiimote_off(); //dirty hack to prevent dll failure on shutdown
	            wiimote_ena = 1;
	        }
			wait (1);
		}
		while(game_status == stat_gameover || game_status == stat_winner)
		{
			wiimote_vibration(0);
			on_wiib = on_esc;
			on_wiiany = on_anykey;
			wait (1);
		}
		on_wiiu = null;
		on_wiid = null;
		on_wiil = null;
		on_wiir = null;
		on_wiia = null;
		on_wiib = null;
		on_wiiany = null;
		wii_select_plr_dis();
		wait (1);
	}
}

function wii_select_player()
{
	set_playerfuncs(wii_plsel);
	if (ctl_listener[wii_plsel] == 1)
	{
		on_wiiu = player_up;
		on_wiid = player_down;
		on_wiil = player_left;
		on_wiir = player_right;
		on_wiihome = player_fire;
	}
	else
	{
		on_wiiu = null;
		on_wiid = null;
		on_wiil = null;
		on_wiir = null;
		on_wiihome = null;
	}
	if (on_esc == dummy || (player_ready & pow(2, wii_plsel)) == pow(2, wii_plsel))
	{
		on_wiihome = null;
	}
    if ((player_ready & pow(2, wii_plsel)) != pow(2, wii_plsel) && ctl_listener[wii_plsel] == 0)
	{
		if (wii_plsel == 0)
		{
			on_wiihome = activate_player1;
		}
		if (wii_plsel == 1)
		{
			on_wiihome = activate_player2;
		}
		if (wii_plsel == 2)
		{
			on_wiihome = activate_player3;
		}
		if (wii_plsel == 3)
		{
			on_wiihome = activate_player4;
		}
	}

}

var wii_plsel_act;

function wii_select_plr_ena()
{
	if (wii_plsel_act == 0)
	{
		wii_plsel_act = 1;
		on_wiiminus = wii_select_plr_dec;
		on_wiiplus = wii_select_plr_inc;
	}
}

function wii_select_plr_dis()
{
	on_wiiminus = null;
	on_wiiplus = null;
	wii_plsel_act = 0;
}

function wii_select_plr_inc()
{
	wii_plsel = clamp(wii_plsel + 1, 0, 3);
	wiimote_led(wii_plsel == 0, wii_plsel == 1, wii_plsel == 2, wii_plsel == 3);
//	wiimote_led(1, wii_plsel > 0, wii_plsel > 1, wii_plsel > 2);
}

function wii_select_plr_dec()
{
	wii_plsel = clamp(wii_plsel - 1, 0, 3);
	wiimote_led(wii_plsel == 0, wii_plsel == 1, wii_plsel == 2, wii_plsel == 3);
//	wiimote_led(1, wii_plsel > 0, wii_plsel > 1, wii_plsel > 2);
}

var wii_blocktimer;
var wiijoy_buf[3];
var wii_blockactive;

function wii_move()
{

	if (my.mode == Pmode_lock || my.mode == Pmode_hit || my.mode == Pmode_critHit)
	{
		wii_blocktimer = 0;
		my.fPspecial = off;
	}

	if (wii_block == 0)
	{
		wii_blocktimer = 0;
		if (my.mode != Pmode_charge && !key_pressed(player_keys[player_ctl_type[wii_plsel] + k_fire]))
		{
			my.fPblock = off;
		}
	}

	if (wii_attack == 1 &&
		(my.mode == Pmode_walk || my.mode == Pmode_charge))
	{
		wii_attack = 0;
		my.mode = Pmode_charge;
	}

	if (wii_special == 1 &&
		(my.mode == Pmode_walk || my.mode == Pmode_charge))
	{
		wii_special = 0;
		my.mode = Pmode_charge; //switch to fighting mode
		if (my.stamina == 100) {my.fPspecial = on;}
	}

	if (wii_block == 1 && wii_blocktimer <= 3.5 &&
		(my.mode == Pmode_walk /*|| my.mode == Pmode_charge*/))
	{
		wii_blockactive = 1;
//		my.mode = Pmode_charge;
		wii_blocktimer += time;
		if (wii_blocktimer > 3.5)
		{
			wii_blockactive = 0;
			player_block();
		}
	}
	if (my.mode != Pmode_hit && my.mode != Pmode_critHit && my.mode != Pmode_lock && my.mode != Pmode_ko)
	{
/*
		//normal movement code - not playable with analogue stick
		if (wiijoy_raw.x < -50)
		{
			my.pan = ang(my.pan + PforcePan * time);
		}
		if (wiijoy_raw.x > 50)
		{
			my.pan = ang(my.pan - PforcePan * time);
		}
		if (wiijoy_raw.y > 50)
		{
			my.forceX = PforceX;
		}
		if (wiijoy_raw.y < -50)
		{
			my.forceX = PforceXneg;
		}
*/
		if (wiijoy_raw.x < 50 && wiijoy_raw.x > -50)
		{
			wiijoy_buf.x = 0;
		}
		else
		{
			wiijoy_buf.x = clamp(wiijoy_raw.x, -240, 240);
		}

		if (wiijoy_raw.y < 50 && wiijoy_raw.y > -50)
		{
			wiijoy_buf.y = 0;
		}
		else
		{
			wiijoy_buf.y = clamp(wiijoy_raw.y, -240, 240);
		}
		if (wiijoy_buf.x != 0 || wiijoy_buf.y != 0)
		{
			vec_to_angle(my_angle, wiijoy_buf);
			temp = 1;
			if (camera.pan > -135 && camera.pan <= -45 || camera.pan > 45 && camera.pan <= 135)
			{
				temp = -1;
			}
			my.pan = ang(my_angle.pan - cam_angle/*camera*/.pan - 90 * temp);
			if (wiijoy_buf.x > 150 || wiijoy_buf.x < -150 || wiijoy_buf.y > 150 || wiijoy_buf.y < -150)
			{
				my.forceX = PforceX;
			}
		}
	}
}

var wii_maxstamina;
function wii_aux()
{
	if ((my.mode == Pmode_critHit || my.mode == Pmode_hit) && wii_vibration == 0)
	{
		wii_vibration = 1;
		wiimote_vibration(1);
	}

	if (my.mode != Pmode_critHit && my.mode != Pmode_hit && wii_vibration == 1)
	{
		wii_vibration = 0;
		wiimote_vibration(0);
	}

	if (my.stamina == PstaMax && wii_maxstamina == 0)
	{
		wii_maxstamina = 1;
		wiimote_vibration(1);
		sleep (0.1);
        wiimote_vibration(0);
	}
	if (my.stamina < PstaMax)
	{
		wii_maxstamina = 0;
	}

}