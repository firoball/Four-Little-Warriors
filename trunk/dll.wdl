/////////////////////////////////////////////////////////////////////////
// Wrapper for bass.dll - Version 1.0 (03/31/02) update 12/18/05	   //
// created by Firoball - http://www.firoball.de - master@firoball.de   //
/////////////////////////////////////////////////////////////////////////

dllfunction _mod_load(x,y);
dllfunction _mod_init(x,y);
dllfunction _mod_unload();
dllfunction _mod_play(x);
dllfunction _mod_stop(x);
dllfunction _mod_volume(x);
dllfunction _mod_getname(x,y);
dllfunction _mod_amplify(x,y);
dllfunction _mod_pause(x);
dllfunction _mod_resume(x);

//Frequency Options
define MOD_LOWFREQ,		11025;
define MOD_MEDFREQ,		22050;
define MOD_HIGHFREQ,	44100; //default;


//Quality Flags (default: all turned off)
define MOD_INIT8BIT,	1;	//8Bit playback for slow systems
define MOD_INITMONO,	2;	//Mono playback for even slower systems
define MOD_INIT3D,		4;	//3D playback for faster system
define MOD_INITNOSYNC,	8; 	//turn this flag on to spare cpu time,
 							//but some mods won't work

//MOD Playback Flags (default: all turned off)
define MOD_LOADLOOP,	4;		//Loop MOD until stopped
define MOD_LOADSURROUND,512;	//Enable Surround


var_nsave dll_handle;
var_nsave mod_handle;

string modbase_str, "music\\track";
string modnr_str, "__";
string modxm_str, ".xm";
string MOD_Filename, "music\\trackXX.xm";

function volume_mod(mvol)
{
	_mod_volume(mvol);
}

function play_mod(temp)
{
	stop_mod();

	str_for_num(modnr_str,temp);
	str_cpy(MOD_Filename,modbase_str);
	str_cat(MOD_Filename,modnr_str);
	str_cat(MOD_Filename,modxm_str);

	mod_handle=_mod_load(MOD_Filename,MOD_LOADLOOP+MOD_LOADSURROUND);
	_mod_volume(mod_vol);
	_mod_play(mod_handle);
//	_mod_amplify(mod_handle,mod_vol);
}

function stop_mod()
{
	if (dll_handle == 0) {return;}
	_mod_stop(mod_handle);
}

function init_mod()
{
	dll_handle = dll_open("basswrap.dll");
	_mod_init(MOD_HIGHFREQ,MOD_INIT3D);
}

function close_mod()
{
	if (dll_handle == 0) {return;}
	_mod_unload();
	dll_close(dll_handle);
	dll_handle = 0;
}
/*
function modtest()
{
	mod_handle=_mod_load("d:\\mods\\muffler_pissi.xm",MOD_LOADLOOP+MOD_LOADSURROUND);
	_mod_play(mod_handle);
}

on_8 modtest;
*/