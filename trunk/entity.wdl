///////////////////////////////////////////////////////////////////////////////////
// ~ 4 Little Warriors ~ entity Definitions
//
// Modified by Firoball  02/05/2007
///////////////////////////////////////////////////////////////////////////////////
define entpan,180;

//temporary storage ONLY
entity player_ent
{
	type = "box.mdl";
	layer = 8;
}

//////////menu entities
entity inst1_ent
{
	type = "box.mdl";
	layer = 8;
	albedo = 0;
	ambient = 100;
	view = camera;
}

entity inst2_ent
{
	type = "box.mdl";
	layer = 9;
	albedo = 0;
	ambient = 100;
	view = camera;
}

entity inst3_ent
{
	type = "box.mdl";
	layer = 8;
	albedo = 0;
	ambient = 100;
	view = camera;
}

entity inst4_ent
{
	type = "box.mdl";
	layer = 9;
	albedo = 0;
	ambient = 100;
	view = camera;
}

entity inst5_ent
{
	type = "box.mdl";
	layer = 8;
	albedo = 0;
	ambient = 100;
	view = camera;
}

entity inst6_ent
{
	type = "box.mdl";
	layer = 9;
	albedo = 0;
	ambient = 100;
	view = camera;
}

entity inst7_ent
{
	type = "box.mdl";
	layer = 8;
	albedo = 0;
	ambient = 100;
	view = camera;
}

entity inst8_ent
{
	type = "box.mdl";
	layer = 9;
	albedo = 0;
	ambient = 100;
	view = camera;
}

entity inst9_ent
{
	type = "box.mdl";
	layer = 9;
	albedo = 0;
	ambient = 100;
	view = camera;
}

entity inst10_ent
{
	type = "box.mdl";
	layer = 9;
	albedo = 0;
	ambient = 100;
	view = camera;
}

entity inst11_ent
{
	type = "box.mdl";
	layer = 9;
	albedo = 0;
	ambient = 100;
	view = camera;
}

//////////
entity winner_ent
{
	type = "box.mdl";
	layer = 7;
	albedo = 0;
	ambient = 70;
	x = 630;
	y = 0;
	z = 165;
	pan = entpan;
	flags = flare, oriented, bright;
	view = camera;
}

entity menubg_ent
{
	type="menubg.tga";
	layer=1;
	ambient=100;
	alpha=10;
	albedo=0;
	x=400;
	y=0;
	z=0;
	scale_x=93;
	scale_y=1.4;
	view=camera;
}

entity yelbutton_ent
{
	type="firebtn.pcx";
	layer=9;
	ambient=100;
	ambient=70;
	view=camera;
	x=600;
	y=225;
	z=-150;
	scale_x=0.9;
	scale_y=0.9;
	alpha=0;
	pan=entpan;
	tilt=0;
	flags oriented,flare;
}

entity redbutton_ent
{
	type="firebtn.pcx";
	layer=9;
	ambient=100;
	ambient=70;
	view=camera;
	x=600;
	y=75;
	z=-150;
	scale_x=0.9;
	scale_y=0.9;
	alpha=0;
	pan=entpan;
	tilt=0;
	flags oriented,flare;
}

entity blubutton_ent
{
	type="firebtn.pcx";
	layer=9;
	ambient=100;
	ambient=70;
	view=camera;
	x=600;
	y=-75;
	z=-150;
	scale_x=0.9;
	scale_y=0.9;
	alpha=0;
	pan=entpan;
	tilt=0;
	flags oriented,flare;
}

entity grnbutton_ent
{
	type="firebtn.pcx";
	layer=9;
	ambient=100;
	ambient=70;
	view=camera;
	x=600;
	y=-225;
	z=-150;
	scale_x=0.9;
	scale_y=0.9;
 	alpha=0;
	pan=entpan;
	tilt=0;
	flags oriented,flare;
}

//Yellow Player selection
entity yelpanel_ent
{
	type="yelpanel.tga";
	layer=8;
	albedo=0;
	x=600;
	y=225;
	z=0;
	pan=entpan;
	view=camera;
	flags=oriented;
}

entity yelsel_ent
{
	type="sel_cpu.pcx";
	layer=9;
	ambient=100;
	albedo=0;
	x=600;
	y=225;
	z=80;
	scale_x=0.8;
	scale_y=0.8;
	pan=entpan;
	view=camera;
	flags=oriented;
}

entity yelmode_ent
{
	type="sel_joy0.pcx";
	layer=9;
	ambient=100;
	albedo=0;
	x=700;
	y=305;
	z=90;
	scale_x=1;
	scale_y=1;
	pan=entpan;
	view=camera;
	flags=oriented;
}

entity yelplayer_ent
{
	type="knight.mdl";
	skin=1;
	layer=9;
	ambient=0;
	albedo=50;
	x=360;
	y=135;
	z=-28;
	view=camera;
}

entity redpanel_ent
{
	type="redpanel.tga";
	layer=8;
	ambient=100;
	albedo=0;
	x=600;
	y=75;
	z=0;
	pan=entpan;
	view=camera;
	flags=oriented;
}

entity redsel_ent
{
	type="sel_cpu.pcx";
	layer=9;
	ambient=100;
	albedo=0;
	x=600;
	y=75;
	z=80;
	scale_x=0.8;
	scale_y=0.8;
	pan=entpan;
	view=camera;
	flags=oriented;
}

entity redmode_ent
{
	type="sel_joy0.pcx";
	layer=9;
	ambient=100;
	albedo=0;
	x=700;
	y=130;
	z=90;
	scale_x=1;
	scale_y=1;
	pan=entpan;
	view=camera;
	flags=oriented;
}

entity redplayer_ent
{
	type="knight.mdl";
	skin=2;
	layer=9;
	ambient=0;
	albedo=50;
	x=360;
	y=45;
	z=-28;
	view=camera;
}

entity blupanel_ent
{
	type="blupanel.tga";
	layer=8;
	albedo=0;
	x=600;
	y=-75;
	z=0;
	pan=entpan;
	view=camera;
	flags=oriented;
}

entity blusel_ent
{
	type="sel_cpu.pcx";
	layer=9;
	ambient=100;
	albedo=0;
	x=600;
	y=-75;
	z=80;
	scale_x=0.8;
	scale_y=0.8;
	pan=entpan;
	view=camera;
	flags=oriented;
}

entity blumode_ent
{
	type="sel_joy0.pcx";
	layer=9;
	ambient=100;
	albedo=0;
	x=700;
	y=-45;
	z=90;
	scale_x=1;
	scale_y=1;
	pan=entpan;
	view=camera;
	flags=oriented;
}

entity bluplayer_ent
{
	type="knight.mdl";
	skin=3;
	layer=9;
	ambient=0;
	albedo=50;
	x=360;
	y=-45;
	z=-28;
	view=camera;
}

entity grnpanel_ent
{
	type="grnpanel.tga";
	layer=8;
	ambient=100;
	albedo=0;
	x=600;
	y=-225;
	z=0;
	pan=entpan;
	view=camera;
	flags=oriented,overlay;
}

entity grnsel_ent
{
	type="sel_cpu.pcx";
	layer=9;
	ambient=100;
	albedo=0;
	x=600;
	y=-225;
	z=80;
	scale_x=0.8;
	scale_y=0.8;
	pan=entpan;
	view=camera;
	flags=oriented;
}

entity grnmode_ent
{
	type="sel_joy0.pcx";
	layer=9;
	ambient=100;
	albedo=0;
	x=700;
	y=-220;
	z=90;
	scale_x=1;
	scale_y=1;
	pan=entpan;
	view=camera;
	flags=oriented;
}

entity grnplayer_ent
{
	type="knight.mdl";
	skin=4;
	layer=9;
	ambient=0;
	albedo=50;
	x=360;
	y=-135;
	z=-28;
	view=camera;
}

entity pl1left_ent
{
	type="m_arrow.pcx";
	layer=10;
	ambient=70;
	view=camera;
	x=600;
	y=0;
	z=0;
	pan=entpan;
	tilt=0;
	roll=180;
	scale_x=0.4;
	scale_y=0.4;
	red=80;
	green=80;
	flags oriented,flare;
}

entity pl1right_ent
{
	type="m_arrow.pcx";
	layer=10;
	ambient=70;
	view=camera;
	x=600;
	y=0;
	z=0;
	pan=entpan;
	tilt=0;
	scale_x=0.4;
	scale_y=0.4;
	red=80;
	green=80;
	flags oriented,flare;
}

entity pl2left_ent
{
	type="m_arrow.pcx";
	layer=10;
	ambient=70;
	view=camera;
	x=600;
	y=0;
	z=0;
	pan=entpan;
	tilt=0;
	roll=180;
	scale_x=0.4;
	scale_y=0.4;
	red=80;
	flags oriented,flare;
}

entity pl2right_ent
{
	type="m_arrow.pcx";
	layer=10;
	ambient=70;
	view=camera;
	x=600;
	y=0;
	z=0;
	pan=entpan;
	tilt=0;
	scale_x=0.4;
	scale_y=0.4;
	red=80;
	flags oriented,flare;
}
entity pl3left_ent
{
	type="m_arrow.pcx";
	layer=10;
	ambient=70;
	view=camera;
	x=600;
	y=0;
	z=0;
	pan=entpan;
	tilt=0;
	roll=180;
	scale_x=0.4;
	scale_y=0.4;
	blue=80;
	flags oriented,flare;
}

entity pl3right_ent
{
	type="m_arrow.pcx";
	layer=10;
	ambient=70;
	view=camera;
	x=600;
	y=0;
	z=0;
	pan=entpan;
	tilt=0;
	scale_x=0.4;
	scale_y=0.4;
	blue=80;
	flags oriented,flare;
}
entity pl4left_ent
{
	type="m_arrow.pcx";
	layer=10;
	ambient=70;
	view=camera;
	x=600;
	y=0;
	z=0;
	pan=entpan;
	tilt=0;
	roll=180;
	scale_x=0.4;
	scale_y=0.4;
	green=80;
	flags oriented,flare;
}

entity pl4right_ent
{
	type="m_arrow.pcx";
	layer=10;
	ambient=70;
	view=camera;
	x=600;
	y=0;
	z=0;
	pan=entpan;
	tilt=0;
	scale_x=0.4;
	scale_y=0.4;
	green=80;
	flags oriented,flare;
}


entity header_ent
{
	type="stagesel.pcx";
	alpha=45;
	layer=8;
	ambient=100;
	albedo=0;
	x=550; //500;
	y=180; //160;
	z=210; //201;
	pan=entpan;
	view=camera;
	flags=flare,oriented;
}


entity controls_ent
{
	type="ctrlmen1.tga";
	alpha=45;
	flags=oriented;
	LAYER=8;
	AMBIENT=100;
	ALBEDO=0;
	X=500;
	Y=160;
	Z=-201;
	pan=entpan;
	VIEW=CAMERA;
}

entity level_ent
{
	TYPE="l1.pcx";
	LAYER=8;
	AMBIENT=80;
	ALBEDO=0;
	X=570;
	Y=0;
	Z=0;
	pan=entpan;
	VIEW=CAMERA;
	FLAGS=ORIENTED;
}
/*
entity menuarrow_right_ent
{
	TYPE="menarrow.mdl";
	FRAME=2;
	LAYER=8;
	AMBIENT=100;
	ALBEDO=0;
	X=130;
	Y=35;
	Z=0;
	PAN=90;
	ROLL=90;
	VIEW=CAMERA;
	FLAGS=METAL;
}

entity menuarrow_left_ent
{
	TYPE="menarrow.mdl";
	FRAME=2;
	LAYER=8;
	AMBIENT=100;
	ALBEDO=0;
	X=130;
	Y=-35;
	Z=0;
	PAN=-90;
	ROLL=90;
	VIEW=CAMERA;
	FLAGS=METAL;
}
*/
entity menu_ent
{
	TYPE="menu.tga";
	LAYER=7;
	AMBIENT=70;
	VIEW=CAMERA;
	X=500;
	Y=0;
	Z=100;
	pan=entpan;
	FLAGS OVERLAY;
}

entity menu1_ent
{
	TYPE="m_arrow.pcx";
	LAYER=7;
	AMBIENT=70;
	view=CAMERA;
	X=600;
	Y=0;
	Z=-120;
	pan=entpan;
	tilt=0;
	flags oriented,flare;
//	flags overlay,transparent;
}

entity menu2_ent
{
	type = "menu2.pcx";
	layer = 7;
	ambient = 70;
	view = camera;
	x = 600;
	y = 0;
	z = -120;
	pan = entpan;
	tilt = 10;
	flags = overlay, flare, bright;
	alpha = 35;
}

entity menu3_ent
{
	TYPE="m_arrow.pcx";
	LAYER=7;
	AMBIENT=70;
	view=CAMERA;
	X=600;
	Y=0;
	Z=-120;
	pan=entpan;
	tilt=0;
	roll=180;
	flags oriented,flare;
//	flags overlay,transparent;
}

entity border1_ent
{
	TYPE="border.tga";
	LAYER=4;
	AMBIENT=100;
	pan=entpan;
	scale_x=50;
	x=600;
	y=0;
	z=-240;
	view=CAMERA;
	FLAGS oriented;
}

entity border2_ent
{
	TYPE="border.tga";
	LAYER=4;
	AMBIENT=100;
	pan=entpan;
	roll=180;
	scale_x=50;
	x=600;
	y=0;
	z=240;
	view=CAMERA;
	FLAGS oriented;
}

entity warfare_ent
{
	TYPE="warfare.pcx";
	LAYER=8;
	AMBIENT=100;
	view=CAMERA;
	FLAGS oriented,flare;
}

entity three_ent
{
	TYPE="three.pcx";
	LAYER=8;
	AMBIENT=100;
	VIEW=CAMERA;
	X=50;
	Y=0;
	Z=0;
	FLAGS BRIGHT,FLARE;
}

entity two_ent
{
	TYPE="two.pcx";
	LAYER=9;
	AMBIENT=100;
	VIEW=CAMERA;
	X=50;
	Y=0;
	Z=0;
	FLAGS BRIGHT,FLARE;
}

entity one_ent
{
	TYPE="one.pcx";
	LAYER=10;
	AMBIENT=100;
	VIEW=CAMERA;
	X=50;
	Y=0;
	Z=0;
	FLAGS BRIGHT,FLARE;
}

entity go_ent
{
	TYPE="go.pcx";
	LAYER=11;
	AMBIENT=100;
	VIEW=CAMERA;
	X=50;
	Y=0;
	Z=0;
	FLAGS BRIGHT,FLARE;
}

entity event_ent
{
	TYPE="event1.pcx";
	LAYER=8;
	AMBIENT=100;
	VIEW=CAMERA;
	X=50;
	Y=0;
	Z=0;
	pan=entpan;
	flags bright, flare, oriented;
}