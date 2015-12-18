///////////////////////////////////////////////////////////////////////////////////
// ~ 4 Little Warriors ~ InstMenu WDL
//
// modified by Firoball  03/12/2007 (created 10/29/2003)
///////////////////////////////////////////////////////////////////////////////////

//////////Prototypes
function show_instructions();
function show_inst1();
function show_inst2();
function show_inst3();
function show_inst4();
function hide_inst1();
function hide_inst2();
function hide_inst3();
function hide_inst4();
function hide_instructions();
function fadeout_instmenu();
function anim_instmenu();
function instmenu_particle();
function Xinstmenupart_event();
function part_instmenufade();
function move_instmenulight();
function Xinstmenulight_event();
function purge_instents();
function reset_instents();
function reset_instent(ent);
function inst2_itemfader();

//////////Definitions
define pdist,skill1;
define ptimer,skill2;
define pcenter,skill3;
define pcenterX,skill3;
define pcenterY,skill4;
define pcenterZ,skill5;

//////////Entity Actions
action Xinstmenulight
{
	my.invisible=1;
	my.passable=1;
	my.skill1=0;
	while(1)
	{
		if(menu_active==2)
		{
			my.skill1+=time;
			if(my.skill1>=1)
			{
				effect(Xinstmenulight_event,3,my.x,nullvector);
				my.skill1-=1;
			}
		}
		wait (1);
	}
}

//////////Menu initialization
function show_instructions()
{
	snd_play (accept_snd, 100, 0);
	hide_menu();
	set_menucam(2);
	show_header("menu3.pcx");
	menu2_ent.z-=60;
	anim_instmenu();
	instmenu_particle();
	anim_menubg();
	show_inst1();
}

//////////Instruction pages
function show_inst1()
{
	reset_instents();

	inst1_ent.x=300;
	inst1_ent.y=115;
	inst1_ent.z=30;
	inst2_ent.x=300;
	inst2_ent.y=20;
	inst2_ent.z=60;
	inst3_ent.x=400;
	inst3_ent.y=-160;
	inst3_ent.z=20;
	inst4_ent.x=300;
	inst4_ent.y=-30;
	inst4_ent.z=-50;
	inst5_ent.x=600;
	inst5_ent.y=85;
	inst5_ent.z=50;
	inst6_ent.x=600;
	inst6_ent.y=-115;
	inst6_ent.z=15;
	inst7_ent.x=600;
	inst7_ent.y=65;
	inst7_ent.z=-85;

	ent_morph(inst1_ent,"golem.mdl");
	ent_morph(inst2_ent,"mine.mdl");
	ent_morph(inst3_ent,"box.mdl");
	ent_morph(inst4_ent,"power.mdl");
	ent_morph(inst5_ent,"inst_t11.pcx");
	ent_morph(inst6_ent,"inst_t12.pcx");
	ent_morph(inst7_ent,"inst_t13.pcx");
	ent_morph(menu2_ent,"anykey.pcx");
	inst2_ent.frame=2;
	inst2_ent.tilt=-15;
	inst2_ent.roll=10;
	inst3_ent.roll=-10;
	inst3_ent.tilt=10;
	inst3_ent.pan=40;
	fadein_panel(inst1_ent);
	fadein_panel(inst2_ent);
	fadein_panel(inst3_ent);
	fadein_panel(inst4_ent);
	fadein_flarepanel(inst5_ent);
	fadein_flarepanel(inst6_ent);
	fadein_flarepanel(inst7_ent);
	fadein_flarepanel(menu2_ent);
	anim_ent(menu2_ent);
	anim_panelwalk(inst1_ent);
	vec_set(temp.x,nullvector);
	temp.x=6;
	anim_panelrotate(inst2_ent,temp);
	temp.x=-6;
	anim_panelrotate(inst4_ent,temp);

	waitt(48);
	while(key_any == 0 && key_wiiany == 0)
	{
		wait(1);
	}
	hide_inst1();
}

function show_inst2()
{
	reset_instents();

	inst1_ent.x=300;
	inst1_ent.y=20;
	inst1_ent.z=40;
	inst2_ent.x=300;
	inst2_ent.y=10;
	inst2_ent.z=40;
	inst3_ent.x=300;
	inst3_ent.y=40;
	inst3_ent.z=-40;
	inst4_ent.x=300;
	inst4_ent.y=30;
	inst4_ent.z=-55;
	inst5_ent.x=400;
	inst5_ent.y=-120;
	inst5_ent.z=50;
	inst6_ent.x=600;
	inst6_ent.y=150;
	inst6_ent.z=35;
	inst7_ent.x=600;
	inst7_ent.y=-140;
	inst7_ent.z=-40;
	inst8_ent.x=600;
	inst8_ent.y=170;
	inst8_ent.z=-85;

	ent_morph(inst1_ent,"arrow.mdl");
	ent_morph(inst2_ent,"arrow.mdl");
	ent_morph(inst3_ent,"cape.mdl");
	ent_morph(inst4_ent,"shield.mdl");
	ent_morph(inst5_ent,"knight.mdl");
	ent_morph(inst6_ent,"inst_t21.pcx");
	ent_morph(inst7_ent,"inst_t22.pcx");
	ent_morph(inst8_ent,"inst_t23.pcx");
	ent_morph(menu2_ent,"anykey.pcx");
	inst1_ent.frame=2;
	inst2_ent.frame=2;
	inst4_ent.pan=180;
	fadein_panel(inst1_ent);
//	fadein_panel(inst2_ent);
	fadein_panel(inst3_ent);
	fadein_panel(inst4_ent);
	fadein_panel(inst5_ent);
	fadein_flarepanel(inst6_ent);
	fadein_flarepanel(inst7_ent);
	fadein_flarepanel(inst8_ent);
	fadein_flarepanel(menu2_ent);
	inst1_ent.tilt=-25;
	inst2_ent.tilt=-25;
	inst1_ent.roll=25;
	inst2_ent.roll=25;
	anim_ent(menu2_ent);
	anim_panelwalk(inst5_ent);
	vec_set(temp.x,nullvector);
	temp.x=6;
	anim_panelrotate(inst1_ent,temp);
	temp.x=-6;
	anim_panelrotate(inst2_ent,temp);
	temp.x=6;
	anim_panelrotate(inst3_ent,temp);
	temp.x=-6;
	anim_panelrotate(inst4_ent,temp);
	inst2_itemfader();

	waitt(48);
	while(key_any == 0 && key_wiiany == 0)
	{
		wait(1);
	}
	hide_inst2();
}

function show_inst3()
{
	reset_instents();

	inst1_ent.x=700;
	inst1_ent.y=100;
	inst1_ent.z=110;
	inst7_ent.x=700;
	inst7_ent.y=100;
	inst7_ent.z=10;
	inst3_ent.x=700;
	inst3_ent.y=100;
	inst3_ent.z=-90;
	inst4_ent.x=600;
	inst4_ent.y=-5;
	inst4_ent.z=95;
	inst5_ent.x=600;
	inst5_ent.y=-50;
	inst5_ent.z=23;
	inst6_ent.x=600;
	inst6_ent.y=5;
	inst6_ent.z=-75;
	inst2_ent.x=700;
	inst2_ent.y=100;
	inst2_ent.z=160;
	inst8_ent.x=700;
	inst8_ent.y=100;
	inst8_ent.z=60;
	inst9_ent.x=700;
	inst9_ent.y=100;
	inst9_ent.z=-40;

	ent_morph(inst1_ent,"button.tga");
	ent_morph(inst7_ent,"button.tga");
	ent_morph(inst3_ent,"button.tga");
	ent_morph(inst4_ent,"inst_t31.pcx");
	ent_morph(inst5_ent,"inst_t32.tga");
	ent_morph(inst6_ent,"inst_t33.pcx");
	ent_morph(inst2_ent,"butarrow.pcx");
	ent_morph(inst8_ent,"butarrow.pcx");
	ent_morph(inst9_ent,"butarrow.pcx");
	ent_morph(menu2_ent,"anykey.pcx");

	fadein_flarepanel(inst1_ent);
	fadein_flarepanel(inst2_ent);
	fadein_flarepanel(inst3_ent);
	fadein_flarepanel(inst4_ent);
	fadein_flarepanel(inst5_ent);
	fadein_flarepanel(inst6_ent);
	fadein_flarepanel(inst7_ent);
	fadein_flarepanel(inst8_ent);
	fadein_flarepanel(inst9_ent);
	fadein_flarepanel(menu2_ent);
	anim_ent(menu2_ent);

	sleep(1.5);

	panelmove = 1;
	vec_set(temp, vector(4, 0, 0));
	anim_panelmove(inst2_ent, temp, 25, 1);
	vec_set(temp, vector(3.17, 0, 0.2));
	anim_panelmove(inst8_ent, temp, 25, 2);
	vec_set(temp, vector(0.5, 3.5, 0));
	anim_panelmove(inst9_ent, temp, 25, 1);
	sleep(1.5);

	while(key_any == 0 && key_wiiany == 0)
	{
		wait(1);
	}
	hide_inst3();
}

function show_inst4()
{
	reset_instents();

	inst1_ent.x=550;
	inst1_ent.y=5;
	inst1_ent.z=40;
	inst2_ent.x=620;
	inst2_ent.y=-110;
	inst2_ent.z=40;
	inst3_ent.x=620;
	inst3_ent.y=-110;
	inst3_ent.z=40;

	ent_morph(inst1_ent,"inst_t41.pcx");
	ent_morph(inst2_ent,"inst_sw1.tga");
	ent_morph(inst3_ent,"inst_sw2.pcx");
	ent_morph(menu2_ent,"anykey.pcx");
	inst2_ent.oriented=1;
	inst3_ent.oriented=1;
	inst2_ent.roll=20;
	inst3_ent.roll=20;
	fadein_flarepanel(inst1_ent);
	fadein_panel(inst2_ent);
	fadein_flarepanel(menu2_ent);
	anim_ent(menu2_ent);
	inst3_ent.bright=1;
	fadeinout_flarepanel(inst3_ent);

	waitt(48);
	while(key_any == 0 && key_wiiany == 0)
	{
		wait(1);
	}
	hide_inst4();
}

function hide_inst1()
{
	snd_play (accept_snd, 100, 0);
	fadeout_panel(inst1_ent);
	fadeout_panel(inst2_ent);
	fadeout_panel(inst3_ent);
	fadeout_panel(inst4_ent);
	fadeout_flarepanel(inst5_ent);
	fadeout_flarepanel(inst6_ent);
	fadeout_flarepanel(inst7_ent);
	fadeout_flarepanel(menu2_ent);
	while(menu2_ent.visible==1)
	{
		wait(1);
	}
	wait (1);
	show_inst2();
}

function hide_inst2()
{
	snd_play (accept_snd, 100, 0);
	inst2_itemfader();
	fadeout_panel(inst1_ent);
	fadeout_panel(inst2_ent);
	fadeout_panel(inst3_ent);
	fadeout_panel(inst4_ent);
	fadeout_panel(inst5_ent);
	fadeout_flarepanel(inst6_ent);
	fadeout_flarepanel(inst7_ent);
	fadeout_flarepanel(inst8_ent);
	fadeout_flarepanel(menu2_ent);
	while(menu2_ent.visible==1)
	{
		wait(1);
	}
	wait (1);
	show_inst3();
}

function hide_inst3()
{
	snd_play (accept_snd, 100, 0);
	fadeout_flarepanel(inst1_ent);
	fadeout_flarepanel(inst2_ent);
	fadeout_flarepanel(inst3_ent);
	fadeout_flarepanel(inst4_ent);
	fadeout_flarepanel(inst5_ent);
	fadeout_flarepanel(inst6_ent);
	fadeout_flarepanel(inst7_ent);
	fadeout_flarepanel(inst8_ent);
	fadeout_flarepanel(inst9_ent);
	fadeout_flarepanel(menu2_ent);
	while(menu2_ent.visible==1)
	{
		wait(1);
	}
	wait (1);
	panelmove = 0;
	show_inst4();
}

function hide_inst4()
{
	snd_play (accept_snd, 100, 0);
	fadeout_flarepanel(inst1_ent);
	fadeout_panel(inst2_ent);
	fadeout_flarepanel(inst3_ent);
	fadeout_flarepanel(menu2_ent);
	hide_header();
	fadeout_instmenu();
	while(menu2_ent.visible==1)
	{
		wait(1);
	}
	wait (1);
	hide_instructions();

}

function hide_instructions()
{
	menu2_ent.z+=60;
	show_quickmenu();
	menubg_ent.visible=0;
	header_ent.visible=0;
	reset_instents();
}

function fadeout_instmenu()
{
	fog_color=1;
	camera.fog=0;
	while (camera.fog<100)
	{
		wait (1);
		camera.fog+=5*time;
	}
	camera.fog=100;
}
//////////Background animation
function anim_instmenu()
{
	camera.pan=0;
	while(menu_active==2)
	{
		camera.pan+=time;
		camera.tilt=8*sin(timer*3)-3;
		camera.x=menu_center[2*6]-520*cos(camera.pan)*cos(camera.tilt);
		camera.y=menu_center[2*6+1]-520*sin(camera.pan)*cos(camera.tilt);
		camera.z=menu_center[2*6+2]-520*sin(camera.tilt);
		wait(1);
	}
}

function instmenu_part1()
{
	my.invisible=1;
	my.passable=1;
	my.lightrange=75;
	my.red=180;
	my.green=150;
	my.blue=10;
	vec_set(my.pcenter,menu_center[2*6]);
	while(menu_active==2)
	{
		my.pan+=4*time;
		my.tilt=15*sin(timer*5);
		my.pdist=25+abs(20*cos(timer));
		my.ptimer+=time;
		if (my.ptimer>=1)
		{
			my.x=my.pcenterX-my.pdist*cos(my.pan)*cos(my.tilt);
			my.y=my.pcenterY-my.pdist*sin(my.pan)*cos(my.tilt);
			my.z=my.pcenterZ-my.pdist*sin(my.tilt);
			effect(Xinstmenupart_event,1,my.x,nullvector);
			my.ptimer-=1;
		}
		wait(1);
	}
	ent_purge(me);
	ent_remove(me);
}

function instmenu_part2()
{
	my.invisible=1;
	my.passable=1;
	my.lightrange=75;
	my.red=180;
	my.green=150;
	my.blue=10;
	vec_set(my.pcenter,menu_center[2*6]);
	while(menu_active==2)
	{
		my.pan-=5*time;
		my.tilt=75*sin(timer*3+110);
		my.pdist=25+abs(20*cos(timer));
		my.ptimer+=time;
		if (my.ptimer>=1)
		{
			my.x=my.pcenterX-my.pdist*cos(my.pan)*cos(my.tilt);
			my.y=my.pcenterY-my.pdist*sin(my.pan)*cos(my.tilt);
			my.z=my.pcenterZ-my.pdist*sin(my.tilt);
			effect(Xinstmenupart_event,1,my.x,nullvector);
			my.ptimer-=1;
		}
		wait(1);
	}
	ent_purge(me);
	ent_remove(me);
}

function instmenu_particle()
{
	ent_create("box.mdl",nullvector,instmenu_part1);
	ent_create("box.mdl",nullvector,instmenu_part2);
}

function Xinstmenupart_event()
{
	my.bmap=orange_particle_map;
	my.function=part_instmenufade;
	my.flare=1;
	my.size=15;
	my.bright=1;
}

function part_instmenufade()
{
	my.alpha-=time;
	my.alpha=max(0,my.alpha);
	if (my.alpha==0)
	{
		my.lifespan=0;
	}
}

function move_instmenulight()
{
	my.alpha-=2.5*time;
	my.z+=(1+random(1))*time;
	my.alpha=max(0,my.alpha);
	if (my.alpha==0)
	{
		my.lifespan=0;
	}
}

function Xinstmenulight_event()
{
	my.x+=random(16)-8;
	my.y+=random(16)-8;
	my.z+=random(16)-8;
	my.size=12;
	my.flare=1;
	my.bmap=green_particle_map;
	my.move=1;
	my.bright=1;
	my.lifespan=20;
	my.function=move_instmenulight;
}

function purge_instents()
{
	ent_purge(inst1_ent);
	ent_purge(inst2_ent);
	ent_purge(inst3_ent);
	ent_purge(inst4_ent);
	ent_purge(inst5_ent);
	ent_purge(inst6_ent);
	ent_purge(inst7_ent);
	ent_purge(inst8_ent);
	ent_purge(inst9_ent);
}

function reset_instents()
{
	purge_instents();
	reset_instent(inst1_ent);
	reset_instent(inst2_ent);
	reset_instent(inst3_ent);
	reset_instent(inst4_ent);
	reset_instent(inst5_ent);
	reset_instent(inst6_ent);
	reset_instent(inst7_ent);
	reset_instent(inst8_ent);
	reset_instent(inst9_ent);
}

function reset_instent(ent)
{
	me = ent;
	vec_set(my.x,nullvector);
	vec_set(my.pan,nullvector);
	my.scale_x = 1;
	my.scale_y = 1;
	my.scale_z = 1;
	my.ambient = 100;
	my.alpha = 0;
	my.frame = 1;
	my.flare = off;
	my.transparent = off;
	my.oriented = off;
	my.bright = off;
	my.visible = off;
}

var inst2_active;
function inst2_itemfader()
{
	if(inst2_active==1)
	{
		inst2_active=0;
		inst1_ent.transparent=0;
		inst2_ent.transparent=0;
		return;
	}

	inst2_active=1;
	var i=17;
	var fade_active=1;
	inst2_ent.alpha=0;
	inst2_ent.transparent=1;
	inst2_ent.visible=1;
	init_entity_stats(i-2,inst1_ent);
	init_entity_stats(i-1,inst2_ent);

	while(inst1_ent.alpha<100)
	{
		wait(1);
	}
	inst1_ent.transparent=1;
	inst2_ent.transparent=1;

	while(inst2_active==1)
	{
		if(inst1_ent.alpha<100 && fade_active==0)
		{
			inst1_ent.alpha=min(inst1_ent.alpha+3*time,100);
 			inst2_ent.alpha=max(100-inst1_ent.alpha,0);
			if(inst1_ent.alpha==100)
			{
				fade_active=1;
				init_entity_stats(i,inst2_ent);
				i+=1;
			}
		}

		if(inst1_ent.alpha>0 && fade_active==1)
		{
			inst1_ent.alpha=max(inst1_ent.alpha-3*time,0);
			inst2_ent.alpha=min(100-inst1_ent.alpha,100);
			if(inst1_ent.alpha==0)
			{
				fade_active=0;
				init_entity_stats(i,inst1_ent);
				i+=1;
			}
		}

		if(i>22)
		{
	 		i=15;
		}
		wait(1);
	}
}