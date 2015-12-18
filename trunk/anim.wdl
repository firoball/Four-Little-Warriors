///////////////////////////////////////////////////////////////////////////////////
// ~ 4 Little Warriors ~ Animation WDL
//
// Modified by Firoball  03/12/2007 (created 10/16/2003)
///////////////////////////////////////////////////////////////////////////////////

//////////Prototypes
function anim_menubg(); //animate scanlines
function anim_ent(cur_ent); //General Font panel animation
function anim_menu(); //Main Menu animation
function anim_optent(tempent);
function stop_optent(tempent);
function anim_level_ent(); //level selection animation
function anim_controls(control_ent); //animate control instruction display
function show_controls(control_ent); //show control instruction display
function hide_controls(control_ent); //hide control instruction display
function anim_header(header_ent); //animate menu headline
function show_header(header_str); //show menu headline
function hide_header(); //hide menu headline
function anim_panelmove(ent, &vec, dist, num);	//move arrow panels up/down for instr. menu
function anim_panelwalk(header_ent); //animate entity models (char screen)
function anim_panelrotate(header_ent,&vec); //rotate entity by given angle vector
function fadeout_panel(header_ent); //panel fading functions
function fadeout_flarepanel(header_ent);
function fadein_panel(header_ent);
function fadeinout_flarepanel(header_ent);
function fadein_flarepanel(header_ent);
function fadeout_playerpanels(header_ent);
function hide_greenpan();
function hide_redpan();
function hide_bluepan();
function hide_yelpan();

//////////Menu animation//////////

//animate scanlines
function anim_menubg()
{
	menubg_ent.visible=1;
	while (menubg_ent.visible!=0)
	{
		menubg_ent.alpha=abs(15*sin(timer*7));
		wait (1);
	}
	ent_purge(menubg_ent);
}

//General Font panel animation
function anim_ent(cur_ent)
{
	me=cur_ent;
	my.visible=1;
	var tempscale;
	tempscale=my.scale_x;
	while(my.visible==1)
	{
		wait (1);
		my.scale_x=tempscale+abs(0.03*sin(14*timer));
	}
	my.scale_x=tempscale;
	ent_purge(me);
}

//Main Menu animation
function anim_menu()
{
	proc_kill(4);
	menu2_ent.tilt=0;
	menu1_ent.z = -120;
	menu3_ent.z = -120;
	menu1_ent.alpha=50;
	menu2_ent.alpha=35;
	menu3_ent.alpha=50;

	while(menu2_ent.visible == 1 && menu2_ent.tilt == 0 && menu2_ent.alpha == 35)
	{
		menu2_ent.scale_x = 1 + abs (0.03 * sin(14 * timer));
		menu3_ent.y = 140 + abs (7 * sin (14 * timer));
		menu1_ent.y = -140 - abs (7 * sin (14 * timer));
		wait (1);
	}

}

entity* animent; //do not use elsewhere!!
function anim_optent(tempent)
{
	proc_kill(4);
	//e??xclusive_global;
	animent = tempent;
	animent.lightred = 230;
	animent.lightgreen = 210;
	animent.lightblue = 30;
	var offset;
	offset = timer;
	while(animent.lightred != 0)
	{
		animent.scale_x = 1 + abs(0.05 * sin(14 * (timer - offset)));
		wait (1);
	}
}

function stop_optent(tempent)
{
	animent = tempent;
	animent.lightred = 0;
	animent.lightgreen = 0;
	animent.lightblue = 0;
	animent.scale_x = 1;
}
//////////Level selection animation//////////

function anim_level_ent()
{
	proc_kill(4);
	menu1_ent.z = 0;
	menu3_ent.z = 0;
	menu1_ent.alpha = 50;
	menu3_ent.alpha = 50;
	menu1_ent.visible = on;
	menu3_ent.visible = on;
	level_ent.tilt=0;
	while (level_ent.visible==1 && level_ent.tilt==0)
	{
		menu3_ent.y = 170 + abs (7 * sin (14 * timer));
		menu1_ent.y = -170 - abs (7 * sin (14 * timer));

//		menuarrow_right_ent.y=40+abs(7*sin(7*timer));
//		menuarrow_left_ent.y=-40-abs(7*sin(7*timer));
//		menuarrow_right_ent.roll=90+25*sin(7*timer);
//		menuarrow_left_ent.roll=90+25*sin(7*timer);
		level_ent.pan=entpan+15*sin(7*timer);
		wait (1);
	}
}

//////////Control instructions//////////

//animate control instructions
function anim_controls(control_ent)
{
	me=control_ent;
	proc_kill(1);
	while (my.visible!=0)
	{
		my.tilt=5+5*sin(7*timer);
		my.scale_x=0.98+0.02*cos(7*timer);
		wait (1);
	}
}

function show_controls(control_ent)
{
	me=control_ent;
	proc_kill(1);
	my.visible=1;
	my.x=500;
	my.y=160;
	my.z=-230;
	anim_controls(me);
	while (my.z<-201)
	{
		wait (1);
		my.z+=3*time;
		my.z=min(-201,my.z);
	}
}

function hide_controls(control_ent)
{
	me=control_ent;
	proc_kill(1);
	my.x=500;
	my.y=160;
	my.z=-201;
	while (my.z>-230)
	{
		wait (1);
		my.z-=3*time;
		my.z=max(-230,my.z);
	}
	my.visible=0;
	ent_purge(me);
}

//////////Headline//////////

//animate headline
function anim_header(header_ent)
{
	me=header_ent;
	proc_kill(1);
	while (my.visible!=0)
	{
		my.tilt=-5+25*sin(7*timer);
		my.scale_x=0.95+0.05*cos(7*timer);
		wait (1);
	}
}

string header_str[12];
function show_header(header_str)
{
	me=header_ent;
	ent_morph(me,header_str);
	proc_kill(1);
	my.visible=1;
	my.x=550;
	my.y=400;
	my.z=210;
	anim_header(me);
	while (my.y>195)
	{
		wait (1);
		my.y-=20*time;
	}
	my.y=195;
}

function hide_header()
{
	me=header_ent;
	proc_kill(1);
	my.visible=1;
	while (my.y<400)
	{
		wait (1);
		my.y+=20*time;
	}
	my.y=400;
	my.visible=0;
	ent_purge(me);
}


//animate entity models
var panelmove;
function anim_panelmove(ent, &vec, dist, num)
{
	me = ent;
	var i;
	var j;
	var direction;
	var time_vec;
	i = my.z;
	j = num;
	direction = 0;
	vec_set (time_vec, vec);

	while (panelmove == 1)
	{
		wait (1);
		if (direction == 0) //down
		{
			my.z -= 5 * time;
			if (my.z <= i - dist)
			{
				my.z = i - dist;
				direction = 1;
				sleep (time_vec[1]);
			}
			continue;
		}
		if (direction == 1) //up
		{
			my.z += 5 * time;
			if (my.z >= i)
			{
				my.z = i;
				j -= 1;
				if (j == 0)
				{
					direction = 2;
				}
				else
				{
					direction = 0;
					sleep (time_vec[2]);
				}
			}
			continue;
		}
		if (direction == 2) //pause
		{
			j = num;
			sleep (time_vec[0]);
			direction = 0;
		}
	}
}

function anim_panelwalk(header_ent)
{
	me=header_ent;
	proc_kill(1);
	my.anim_fac=4.5;
	my.visible=1;
	while (my.visible==1)
	{
		my.pan+=3*time;
		my.anim_dist = my.total_dist + time/4;
		if (my.anim_dist > my.anim_fac)
		{
			my.anim_dist -= my.anim_fac;
		}
		temp = 100 * my.anim_dist/my.anim_fac;

		ent_cycle(walk_str,temp);
		my.total_dist=my.anim_dist;
		wait (1);
	}
}

function anim_panelrotate(header_ent,&vec)
{
	var angspeed[3];
	me=header_ent;
	proc_kill(1);
	vec_set(angspeed,vec);
	my.visible=1;
	while(my.visible==1)
	{
		my.pan+=angspeed[0]*time;
		my.tilt+=angspeed[1]*time;
		my.roll+=angspeed[2]*time;
		wait(1);
	}
}

//fadeout entites
function fadeout_panel(header_ent)
{
	me=header_ent;
//	my.alpha=100;
	my.transparent=1;
	while(my.alpha>0)
	{
		wait (1);
		my.alpha-=7*time;
	}
	my.visible=0;
	my.transparent=0;
	ent_purge(me);
}

function fadeout_flarepanel(header_ent)
{
	me=header_ent;
	my.alpha=50;
	my.flare=1;
	while(my.alpha>0)
	{
		wait (1);
		my.alpha-=3.5*time;
	}
	my.alpha = 0;
	my.visible=0;
	my.flare=0;
	ent_purge(me);
}
function fadein_panel(header_ent)
{
	me=header_ent;
	my.alpha=0;
	my.transparent=1;
	my.visible=1;
	while(my.alpha<100)
	{
		wait (1);
		my.alpha+=7*time;
	}
	my.alpha=100;
	my.transparent=0;
}

function fadeinout_flarepanel(header_ent)
{
	me=header_ent;
	my.alpha=0;
	my.flare=1;
	my.visible=1;
	while(my.visible==1)
	{
		while(my.alpha<50)
		{
			wait (1);
			my.alpha+=3.5*time;
		}
		my.alpha=50;
		while(my.alpha>0)
		{
			wait (1);
			my.alpha-=3.5*time;
		}
		my.alpha=0;
		wait(1);
	}
	my.alpha=0;
	my.flare=0;
	ent_purge(me);
}

function fadein_flarepanel(header_ent)
{
	me=header_ent;
	my.alpha=0;
	my.flare=1;
	my.visible=1;
	while(my.alpha<50)
	{
		wait (1);
		my.alpha+=3.5*time;
	}
	my.alpha=50;
}
//////////Player Selection Screen//////////

//fade out player models
//differs from general fadeout routine
//entity is not purged to avoid jerks
function fadeout_playerpanels(header_ent)
{
	me=header_ent;
	my.alpha=100;
	my.transparent=1;
	while(my.alpha>0)
	{
		wait (1);
		my.alpha-=7*time;
	}
	my.visible=0;
	my.transparent=0;
//		ent_purge(me);
}

function hide_greenpan()
{
	proc_kill(4);
		me=grnpanel_ent;
		my.visible=1;
		my.x=600;
		my.y=-225;
		my.z=0;
		while(my.y>-425)
		{
				wait (1);
				my.y-=12*time;
				my.y=max(my.y,-425);
				my.pan+=2*time;
		}
		my.visible=0;
		ent_purge(me);
		my.pan=entpan;
}

function hide_redpan()
{
	proc_kill(4);
		me=redpanel_ent;
		my.visible=1;
		my.x=600;
		my.y=75;
		my.z=0;
		while(my.z>-400)
		{
				wait (1);
				my.z-=24*time;
				my.z=max(my.z,-400);
				my.tilt-=2*time;
		}
		my.visible=0;
		my.tilt=0;
		ent_purge(me);
}

function hide_bluepan()
{
	proc_kill(4);
		me=blupanel_ent;
		my.visible=1;
		my.x=600;
		my.y=-75;
		my.z=0;
		while(my.z<400)
		{
				wait (1);
				my.z+=24*time;
				my.z=min(my.z,400);
				my.tilt+=2*time;
		}
		my.visible=0;
		my.tilt=0;
		ent_purge(me);
}

function hide_yelpan()
{
	proc_kill(4);
		me=yelpanel_ent;
		my.visible=1;
		my.x=600;
		my.y=225;
		my.z=0;
		while(my.y<425)
		{
				wait (1);
				my.y+=12*time;
				my.y=min(my.y,425);
				my.pan-=2*time;
		}
		my.visible=0;
		my.pan=entpan;
		ent_purge(me);
}

/*
function show_yelpan()
{
	proc_kill(4);
	me=yelpanel_ent;
	my.visible=1;
	my.x=600;
	my.y=425;
	my.z=0;
	while(my.y>225)
	{
		wait (1);
		my.y-=10*time;
		my.y=max(my.y,225);
	}
}

function show_bluepan()
{
	proc_kill(4);
	me=blupanel_ent;
	my.visible=1;
	my.x=600;
	my.y=-75;
	my.z=400;
	while(my.z>0)
	{
		wait (1);
		my.z-=20*time;
		my.z=max(my.z,0);
	}
	show_button(blubutton_ent);
}

function show_redpan()
{
	proc_kill(4);
	me=redpanel_ent;
	my.visible=1;
	my.x=600;
	my.y=75;
	my.z=-400;
	while(my.z<0)
	{
		wait (1);
		my.z+=20*time;
		my.z=min(my.z,0);
	}
	show_button(redbutton_ent);
}

function show_greenpan()
{
	proc_kill(4);
	me=grnpanel_ent;
	my.visible=1;
	my.x=600;
	my.y=-425;
	my.z=0;
	while(my.y<-225)
	{
		wait (1);
		my.y+=10*time;
		my.y=min(my.y,-225);
	}
	show_button(grnbutton_ent);
}

*/
