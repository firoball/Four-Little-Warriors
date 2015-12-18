///////////////////////////////////////////////////////////////////////////////////
// ~ 4 Little Warriors ~ Logo WDL
//
// Modified by Firoball  10/30/2006 (created 01/03/2006)
///////////////////////////////////////////////////////////////////////////////////

//////////Prototypes
function logo_show();
function logo_anim(ent);
function logo_tune(hndl);

//////////Bindings
bind <logobg.pcx>;
bind <firoball.pcx>;
bind <acklogo.pcx>;
bind <dragon.pcx>;
bind <dragon.wav>;

//////////Sounds
sound dragon_snd = "dragon.wav";

//////////Variables
var_nsave dragon_snd_h;
var_nsave logo_done;

//////////Entities
entity logobg_ent
{
	type = "logobg.pcx";
	x = 100;
	y = 0;
	z = 0;
	scale_x = 2;
	scale_y = 1.5;
	albedo = 0;
	ambient = 100;
	layer = 3;
}

entity pic_ent
{
	type = "logobg.pcx";
	x = 600;
	y = 0;
	z = 0;
	pan = 180;
	albedo = 0;
	ambient = 100;
	layer = 4;
	flags = oriented;
}

entity firologo_ent
{
	type = "firoball.pcx";
	x = 600;
	y = -85;
	z = -120;
	scale_x = 0.8;
	scale_y = 0.8;
	albedo = 0;
	ambient = 100;
	layer = 5;
}

//////////Functions
function logo_show()
{
	logo_done = 0;
	logobg_ent.visible = on;

	ent_morph (pic_ent, "acklogo.pcx");
	sleep (2.5);
	pic_ent.alpha = 0;
	pic_ent.transparent = on;
	pic_ent.bright = on;
	pic_ent.scale_x = 1.5;
	pic_ent.scale_y = 1.5;
	pic_ent.visible = on;
	while (pic_ent.alpha < 100)
	{
		wait (1);
		pic_ent.alpha += 3 * time;
	}
	pic_ent.alpha = 100;

	sleep (1);

	while (pic_ent.alpha > 0)
	{
		wait (1);
		pic_ent.alpha -= 3 * time;
	}
	pic_ent.alpha = 0;
	pic_ent.transparent = off;
	pic_ent.visible = off;
	ent_purge (pic_ent);

	ent_morph (pic_ent, "dragon.pcx");
	pic_ent.flare = on;
	pic_ent.scale_x = 0.1;
	pic_ent.scale_y = 0.1;
	pic_ent.roll = 100;
	pic_ent.visible = on;
	while (pic_ent.alpha < 50)
	{
		wait (1);
		pic_ent.roll -= 4 * time;
		pic_ent.alpha += 2 * time;
		pic_ent.scale_x = .1 + pic_ent.alpha / 50;
		pic_ent.scale_y = pic_ent.scale_x;
	}
	pic_ent.scale_x = 1.1;
	pic_ent.scale_y = 1.1;
	pic_ent.roll = 0;
	pic_ent.alpha = 50;
	dragon_snd_h = snd_play (dragon_snd, 100, -100);
	logo_tune(dragon_snd_h);

	sleep (0.3);

	firologo_ent.alpha = 0;
	firologo_ent.flare = on;
	firologo_ent.visible = on;
	logo_anim (firologo_ent);
	while (firologo_ent.alpha < 50)
	{
		wait (1);
		firologo_ent.alpha += 2 * time;
	}
	firologo_ent.alpha = 50;
	sleep (2);

	while (pic_ent.alpha > 0)
	{
		wait (1);
		pic_ent.alpha -= 2 * time;
		firologo_ent.alpha = pic_ent.alpha;
	}
	pic_ent.alpha = 0;
	firologo_ent.alpha = 0;

	pic_ent.visible = off;
	firologo_ent.visible = off;
	sleep (0.3);
	logo_done = 1;
	logobg_ent.visible = off;

	pic_ent.flare = off;
	firologo_ent.flare = off;
	ent_purge (pic_ent);
	ent_purge (firologo_ent);
	ent_purge (logobg_ent);

}

function logo_anim(ent)
{
	me = ent;
	while (my.visible == on)
	{
		wait (1);
		my.scale_x = 0.8 + 0.05 * abs(sin(total_ticks * 10));
	}
}

function logo_tune(hndl)
{
	var balan;
	balan = -100;
	while (balan < 100)
	{
		wait (1);
		snd_tune (hndl, 100, 0, balan);
		balan += 5.7 * time;
	}
}