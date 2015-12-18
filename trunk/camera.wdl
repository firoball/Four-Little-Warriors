///////////////////////////////////////////////////////////////////////////////////
// ~ 4 Little Warriors ~ Camera WDL
//
// Modified by Firoball  05/04/2006 (created 01/09/2005)
///////////////////////////////////////////////////////////////////////////////////

//////////Prototypes
function cam_netmove(); //outdated
function set_camcalcpos();
function calc_2dlimits();
function calc_campos();
function camera_mode1();
function cam_move();

function cam_playmode();
function cam_getfurthestplayer();
function cam_calccenter();
function cam_setpos();
function cam_calcpos(&op1, &v1, &op2, &v2);


//////////Variables
var cam_angle;
var cam_arc;
var cam_mode = 1;
var netcampos[3];
var camang[3];
var camera_dist;
var field_min[3];
var field_max[3];
var campos;
var campos_2d;
var field_radius;
var player_camscreen1;
var player_camscreen2;
var player_camscreen3;
var player_camscreen4;
var player1_last;
var player2_last;
var player3_last;
var player4_last;
var campos_last;

var clientcam[3];
var clientcenter[3];

view camcalc
{
	pos_x 0;
	pos_y 0;
	arc 65;
	tilt CAMtilt;
	roll 0;
	layer 16;
	flags noshadow, noparticle;
}

function cam_netmove()
{
	proc_kill(4);
		while (game_status!=stat_gameover)
		{
				wait(1);

				if (base_speed==0.5)
				{
//						cam_arc=5*SIN((timer-time_cor)*12);
				}
				else
				{
						cam_arc=0;
				}
				CAmeRA.ARC=60+cam_arc;
				CAmeRA.PAN=cam_angle.PAN+7*SIN(timer*3);
				CAmeRA.TILT=-30+5*COS(timer*3);

				camera_dist=field_radius/tan(CAmeRA.ARC)+field_radius*0.33;
				camera_dist=max(camera_dist,300);
				camera.X+=0.7*(campos.X-camera_dist*COS(CAmeRA.PAN)-CAmeRA.X);
				camera.Y+=0.7*(campos.Y-camera_dist*SIN(CAmeRA.PAN)-CAmeRA.Y);
				camera.Z+=0.7*(campos.Z-camera_dist*TAN(CAmeRA.TILT)-CAmeRA.Z);

//				MOVE_VIEW CAmeRA,NULLVECTOR,clientcam;

		}
}



var camcalc_angle;
function set_camcalcpos()
{
	camcalc.x = -CAMmaxdist * cos(cam_angle.pan);
	camcalc.y = -CAMmaxdist * sin(cam_angle.pan);
	camcalc.z = -CAMmaxdist * tan(CAMtilt);
	camcalc_angle.pan = cam_angle.pan;
	camcalc.pan = cam_angle.pan;
	camcalc.tilt = CAMtilt;
}

function calc_2dlimits()
{
	camcalc.pan = camera.pan;
	camcalc.tilt = camera.tilt;
	if (camcalc_angle.pan != cam_angle.pan)
	{
		set_camcalcpos();
	}
//	camcalc.visible = 1;
	vec_set(player_camscreen1, player1.x);
	temp = vec_to_screen(player_camscreen1, camcalc);
	if (temp == 0 /*|| player1.mode == Pmode_lock*/) {vec_set(player_camscreen1, player1_last);}

	vec_set(player_camscreen2, player2.x);
	temp = vec_to_screen(player_camscreen2, camcalc);
	if (temp == 0 /*|| player2.mode == Pmode_lock*/) {vec_set(player_camscreen2, player2_last);}

	vec_set(player_camscreen3, player3.x);
	temp = vec_to_screen(player_camscreen3, camcalc);
	if (temp == 0 /*|| player3.mode == Pmode_lock*/) {vec_set(player_camscreen3, player3_last);}

	vec_set(player_camscreen4, player4.x);
	temp = vec_to_screen(player_camscreen4, camcalc);
	if (temp == 0 /*|| player4.mode == Pmode_lock*/) {vec_set(player_camscreen4, player4_last);}

	vec_set(campos_2d, campos);
	temp = vec_to_screen(campos_2d, camcalc);
	if (temp == 0) {vec_set(campos_2d, campos_last);}
//	camcalc.visible = 0;

//X
	temp.x = abs(player_camscreen1.x - campos_2d.x);

	temp.z = abs(player_camscreen2.x - campos_2d.x);
	if (temp.z > temp.x) {temp.x = temp.z;}
	temp.z = abs(player_camscreen3.x - campos_2d.x);
	if (temp.z > temp.x) {temp.x = temp.z;}
	temp.z = abs(player_camscreen4.x - campos_2d.x);
	if (temp.z > temp.x) {temp.x = temp.z;}

	field_radius.x = temp.x / screen_size.x * 1800;
//Y (only one direction)
	temp.y = player_camscreen1.y - campos_2d.y;
	temp.z = player_camscreen2.y - campos_2d.y;
	if (temp.z > temp.y) {temp.y = temp.z;}
	temp.z = player_camscreen3.y - campos_2d.y;
	if (temp.z > temp.y) {temp.y = temp.z;}
	temp.z = player_camscreen4.y - campos_2d.y;
	if (temp.z > temp.y) {temp.y = temp.z;}

	field_radius.y = temp.y / screen_size.y * 1980;
//backup if 3d -> 2d conversion fails
	vec_set(player1_last, player_camscreen1);
	vec_set(player2_last, player_camscreen2);
	vec_set(player3_last, player_camscreen3);
	vec_set(player4_last, player_camscreen4);
	vec_set(campos_last, campos_2d);
}

//place camera in the middle of players
var cam_plrZ[4];
function calc_campos()
{
	field_min.x=min(player1.x, player2.x);
	field_min.x=min(field_min.x, player3.x);
	field_min.x=min(field_min.x, player4.x);

	field_max.x=max(player1.x,player2.x);
	field_max.x=max(field_max.x,player3.x);
	field_max.x=max(field_max.x,player4.x);

	field_min.y=min(player1.y,player2.y);
	field_min.y=min(field_min.y,player3.y);
	field_min.y=min(field_min.y,player4.y);

	field_max.y=max(player1.y,player2.y);
	field_max.y=max(field_max.y,player3.y);
	field_max.y=max(field_max.y,player4.y);

	vec_set(campos, field_min);
	vec_add(campos, field_max);
	vec_scale(campos, 0.5);

	if (player1.mode != Pmode_lock)
	{
		cam_plrZ[0] = player1.z;
	}
	if (player2.mode != Pmode_lock)
	{
		cam_plrZ[1] = player2.z;
	}
	if (player3.mode != Pmode_lock)
	{
		cam_plrZ[2] = player3.z;
	}
	if (player4.mode != Pmode_lock)
	{
		cam_plrZ[3] = player4.z;
	}
	campos.z = min(100, (cam_plrZ[0] + cam_plrZ[1] + cam_plrZ[2] + cam_plrZ[3]) / 4);
//	if (campos.z > 100) {breakpoint;}
}


function camera_mode1()
{
	calc_campos();
	calc_2dlimits();
	if (field_radius.y > field_radius.x) {field_radius.x = field_radius.y;}
	camera.arc = 60 + cam_arc;
	camera.pan = cam_angle.pan + CAMpanmod * sin(timer * 3);
	camera.tilt = CAMtilt + CAMtiltmod * cos(timer * 3);
	camera_dist = field_radius * CAMdistfac + CAMdistmod;
	camera_dist = max(camera_dist, CAMmindist);
	camera_dist = min(camera_dist, CAMmaxdist);
}

var temp_cam_dist;
var temp_campos;
function cam_move()
{
	while(player1 == null || player2 == null || player3 == null || player4 == null)
	{
		wait (1);
	}

	camera.pan = cam_angle.pan + CAMpanmod * sin (timer * 3);
	camera.tilt = -30 + CAMtiltmod * cos (timer * 3);
	set_camcalcpos();
	camcalc.pan = camera.pan;
	camcalc.tilt = camera.tilt;
	wait (2);
	proc_kill(4);
	cam_mode = 2;
	camera_mode1();
	temp_cam_dist = camera_dist;
	camera_dist = CAMmaxdist;
	vec_set (temp_campos, campos);
	while (game_status != stat_gameover)
	{
		wait(1);
		proc_late();
		if (cam_mode == 0)
		{
			_move_straight();
			continue; //disable camera movement
		}

		if (cam_mode == 1)
		{
			camera_mode1();
//					cam_playmode();
		}

		if (cam_mode == 2)
		{
			vec_set (campos, temp_campos);
			camera.arc = 60 + cam_arc;
			camera.pan = cam_angle.pan + CAMpanmod * sin (timer * 3);
			camera.tilt = -30 + CAMtiltmod * cos (timer * 3);
			if (camera_dist > temp_cam_dist)
			{
				camera_dist -= 7 * time;
			}
			else
			{
				cam_mode = 1;
			}
			camera_dist = max(camera_dist, temp_cam_dist);
		}

		camera.x += 0.9 * (campos.x - camera_dist * cos(camera.pan) - camera.x);
		camera.y += 0.9 * (campos.y - camera_dist * sin(camera.pan) - camera.y);
		camera.z += 0.9 * (campos.z - camera_dist * tan(camera.tilt) - camera.z);
	}
}

entity* cam_plf;

function cam_playmode()
{
	camera.arc = 60 + cam_arc;
	camera.pan = cam_angle.pan + CAMpanmod * sin(timer * 3);
	camera.tilt = CAMtilt + CAMtiltmod * cos(timer * 3);
	camera_dist = cam_setpos();
	camera_dist = max(camera_dist,CAMmindist);
	camera_dist = min(camera_dist,CAMmaxdist);
}

function cam_getfurthestplayer()
{
	/* check player furthest away from camera via angle relative to cam */
	/* my_pos.y: angle positive or negative? */
	/* my_pos.pan: angle difference between cam/player, absolute value */

	vec_set(temp, player1.x);
	vec_sub(temp, camera.x);
	vec_to_angle(my_angle, temp);

	my_pos.pan = abs(ang(my_angle.pan - camera.pan));
	my_pos.y = sign(ang(my_angle.pan - camera.pan));
	cam_plf = player1;

	vec_set(temp, player2.x);
	vec_sub(temp, camera.x);
	vec_to_angle(my_angle, temp);
	i = abs(ang(my_angle.pan - camera.pan));
	if (i > my_pos.pan)
	{
		my_pos.pan = i;
		my_pos.y = sign(ang(my_angle.pan - camera.pan));
		cam_plf = player2;
	}

	vec_set(temp, player3.x);
	vec_sub(temp, camera.x);
	vec_to_angle(my_angle, temp);
	i = abs(ang(my_angle.pan - camera.pan));
	if (i > my_pos.pan)
	{
		my_pos.pan = i;
		my_pos.y = sign(ang(my_angle.pan - camera.pan));
		cam_plf = player3;
	}

	vec_set(temp, player4.x);
   	vec_sub(temp, camera.x);
	vec_to_angle(my_angle, temp);
	i = abs(ang(my_angle.pan - camera.pan));
	if (i > my_pos.pan)
	{
		my_pos.pan = i;
		my_pos.y = sign(ang(my_angle.pan - camera.pan));
		cam_plf = player4;
	}

}

function cam_calccenter()
{
	/* get center position between players */

	field_min.z = 0;
	field_max.z = 0;

	field_min.x=min(player1.x, player2.x);
	field_min.x=min(field_min.x, player3.x);
	field_min.x=min(field_min.x, player4.x);

	field_max.x=max(player1.x,player2.x);
	field_max.x=max(field_max.x,player3.x);
	field_max.x=max(field_max.x,player4.x);

	field_min.y=min(player1.y,player2.y);
	field_min.y=min(field_min.y,player3.y);
	field_min.y=min(field_min.y,player4.y);

	field_max.y=max(player1.y,player2.y);
	field_max.y=max(field_max.y,player3.y);
	field_max.y=max(field_max.y,player4.y);

	vec_set(temp,campos);

	vec_set(campos, field_min);
	vec_add(campos, field_max);
	vec_scale(campos, 0.5);

//	vec_lerp(campos, temp, campos, 0.4);
	campos.z = (player1.z + player2.z + player3.z + player4.z) / 4;
}
define CAMangleMod, 30;
function cam_setpos()
{
//var debug[3];
	/* get origin points for cam position calculation*/
	cam_getfurthestplayer();	/* cam_plf - entity ptr */
	cam_calccenter();			/* campos - vector */

	vec_set (temp, vector (20, 0, 0));
	vec_set (my_angle, temp);

	/* vector towards camera */
	vec_rotate (temp, vector(camera.pan, camera.tilt, 0));

	/* vector turned by +-(camera.arc + modifier) depending on my_pos.y (cam_getfurthestplayer) */
	vec_rotate (my_angle, vector(camera.pan + my_pos.y * (camera.arc - CAMangleMod), camera.tilt, 0));

	cam_calcpos(campos, temp, cam_plf.x, my_angle);	/* temp = new camera pos!! */
	return (vec_length(temp));
}

var cam_lastpos;
function cam_calcpos(&op2, &v2, &op1, &v1)
{
	/* calculate intersection of op1+lambda*v1 and op2+pi*v2 */
	i.z = (v2[1]*v1[0] - (v2[0]*v1[1]));
	//avoid division by zero
	if (i.z == 0)
	{
		i = cam_lastpos;
	}
	else
	{
		i = (op1[1]*v1[0] + v1[1]*op2[0] - (op1[0]*v1[1]) - (op2[1]*v1[0])) / i.z;
	}
	cam_lastpos = i;
	vec_scale(v2, i);
	vec_add(v2, op2);
}