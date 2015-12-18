///////////////////////////////////////////////////////////////////////////////////
// ~ 4 Little Warriors ~ Keys WDL
//
// modified by Firoball  04/16/2007 (created 03/26/2006)
///////////////////////////////////////////////////////////////////////////////////

view chasecam
{
    pos_x 0;
    pos_y 0;
    layer 16;
}

//////////Variables
var cameradist[3];
var cameraangle[3];

//////////Functions
function show_birdcam(ent)
{
	proc_kill(4);
	you = ent;
    vec_set (cameradist, vector(-270, 0, 0));
    vec_to_angle (cameraangle, cameradist);

	camera.visible = off;
    chasecam.visible = on;

	chasecam.pan = your.pan;
    while (game_status != stat_gameover)
    {
    	wait (1);
        vec_set (chasecam.x, cameradist[0]);
        vec_rotate (chasecam.x, your.pan);
		vec_add (chasecam.x, your.x);

//        vec_set (chasecam.pan, cameraangle);
		chasecam.pan += (your.pan - chasecam.pan) * 0.3 * time;
		chasecam.tilt = -45;
		if (scenemap != null)
		{
	        scenemap.pan = chasecam.pan;
	        scenemap.x = 636 * cos (scenemap.pan);
	        scenemap.y = 636 * sin (scenemap.pan);
		}
    }
    chasecam.visible = off;
    camera.visible = on;
	if (scenemap != null)
	{
	    scenemap.x = 636 * cos (cam_angle.pan);
	    scenemap.y = 636 * sin (cam_angle.pan);
	    scenemap.pan = cam_angle.pan;
	}
}

function show_ufocam(ent)
{
	proc_kill(4);
	you = ent;
    vec_set (cameradist, vector(20, 0, 0));
    vec_to_angle (cameraangle, cameradist);

	camera.visible = off;
    chasecam.visible = on;

    while (game_status != stat_gameover)
    {
    	wait (1);
        vec_set (chasecam.x, cameradist[0]);
        vec_rotate (chasecam.x, your.pan);
		vec_add (chasecam.x, your.x);

        vec_set (chasecam.pan, cameraangle);
		ang_add (chasecam.pan, your.pan);
		if (scenemap != null)
		{
	        scenemap.pan = chasecam.pan;
	        scenemap.x = 636 * cos (scenemap.pan);
	        scenemap.y = 636 * sin (scenemap.pan);
		}
    }
    chasecam.visible = off;
    camera.visible = on;
	if (scenemap != null)
	{
	    scenemap.x = 636 * cos (cam_angle.pan);
	    scenemap.y = 636 * sin (cam_angle.pan);
	    scenemap.pan = cam_angle.pan;
	}
}

var manual_pan[3];
function chase_inc()
{
	manual_pan[0] += 90;
}

function chase_dec()
{
	manual_pan[0] -= 90;
}

var dist_toggle;
function dist_zoom()
{
	if (dist_toggle == 0)
	{
    	vec_set (cameradist, vector(-150, 0, 60));
		dist_toggle = 1;
	}
	else
	{
    	vec_set (cameradist, vector(-300, 0, 100));
		dist_toggle = 0;
	}
}

on_plus = chase_inc;
on_minus = chase_dec;
on_space = dist_zoom;


function show_chasecam(i)
{
	proc_kill(4);
   vec_set (cameradist, vector(-300, 0, 100));
	vec_set (temp, nullvector);
   vec_sub (temp, cameradist);
   vec_to_angle (cameraangle, temp);

	you = ptr_for_handle(playerlist[i]);
	camera.visible = off;
   chasecam.visible = on;
	vec_set(manual_pan, nullvector);

    while (chasecam.visible && game_status != stat_gameover)
    {
    	wait (1);
        vec_set (chasecam.x, cameradist[0]);
		vec_set (temp, manual_pan);
		vec_add (temp, your.pan);
        vec_rotate (chasecam.x, temp);
		vec_add (chasecam.x, your.x);

        vec_set (chasecam.pan, cameraangle);
		ang_add (chasecam.pan, temp);
		if (scenemap != null)
		{
	        scenemap.pan = chasecam.pan;
	        scenemap.x = 636 * cos (scenemap.pan);
	        scenemap.y = 636 * sin (scenemap.pan);
		}
    }
    chasecam.visible = off;
    camera.visible = on;
	if (scenemap != null)
	{
	    scenemap.x = 636 * cos (cam_angle.pan);
	    scenemap.y = 636 * sin (cam_angle.pan);
	    scenemap.pan = cam_angle.pan;
	}
}

function hide_chasecam()
{
	camera.visible = on;
    chasecam.visible = off;
}

function chase_pl1()
{
	if (chasecam.visible)
    {
    	hide_chasecam();
    }
    else
    {
    	show_chasecam(0);
    }
}

function chase_pl2()
{
	if (chasecam.visible)
    {
    	hide_chasecam();
    }
    else
    {
    	show_chasecam(1);
    }
}

function chase_pl3()
{
	if (chasecam.visible)
    {
    	hide_chasecam();
    }
    else
    {
    	show_chasecam(2);
    }
}

function chase_pl4()
{
	if (chasecam.visible)
    {
    	hide_chasecam();
    }
    else
    {
    	show_chasecam(3);
    }
}

function temp_winner()
{
//	win = 1;
	winner = 0;
	str_cpy (winnermdl_str, "knight.mdl");
	winner_loader();
}

FUNCTION trigger_cutscene() {cur_time = 0;}

function print_itemlist()
{
	var i;
    i = 0;
	listhndl = file_open_write ("itemlist.txt");
    file_str_write (listhndl, "Items currently stored: ");
    file_var_write (listhndl, itemcount);
    while (i < itemcount)
    {
    	file_str_write (listhndl, "
        ");
		file_str_write (listhndl, "type ");
        file_var_write (listhndl, itemtype[i]);
		file_str_write (listhndl, "active ");
        file_var_write (listhndl, itemactive[i]);
		templist = ptr_for_handle (itemlist[i]);
		file_str_write (listhndl, "x ");
        file_var_write (listhndl, templist.x);
		file_str_write (listhndl, "y ");
        file_var_write (listhndl, templist.y);
		file_str_write (listhndl, "z ");
        file_var_write (listhndl, templist.z);
    	i += 1;
    }
	file_close (listhndl);
}

function event_equalize_trig()
{
	event_trig = Eequalize;
}

//////////Keys
on_1 chase_pl1;
on_2 chase_pl2;
on_3 chase_pl3;
on_4 chase_pl4;

on_6 temp_winner;
ON_7 trigger_cutscene;
//on_8 = show_trophies;
on_9 print_itemlist;


ON_E event_equalize_trig;
ON_R event_rotate;
/*
ON_T event_slowmotion;
ON_Y event_highspeed;
ON_U event_superpower;
on_I event_upsidedown;
ON_O event_monopoly;
ON_P event_position;
*/

//ON_F7 get_levels;
//ON_F8 load_leveldata;