////////////////////////////////////////////////////////////////////////////////
// ackwii.dll - Version 1.0 (5.1.07)
// created by Firoball - http://www.firoball.de - unsinnspala@firoball.de
////////////////////////////////////////////////////////////////////////////////

//DO NOT MODIFY THE FOLLOWING PART!!/////////////////////////////////////

dllfunction wiimote_connect();		//establish connection, return 1 if successful
dllfunction wiimote_disconnect();	//close connection
dllfunction wiimote_status(&mote, &chuk, &but);
dllfunction wiimote_led(led1, led2, led3, led4);
dllfunction wiimote_vibration(vib_on);
/* wiimote_status
mote: array of 5: wiimote motion sensor (xyz) and IR sensor (XY)
chuk: array of 5: nunchuk motion sensor (xyz) and analog stick (xy)
but: single var: button states for wiimote and nunchuk
*/

/////////////////////////////////////////////////////////////////////////


//The following sample script reads the button and sensor states of Wiimote
//and Nunchuk
//start/stop by pressing F12

//////////Prototypes
function wiimote_keys();
function wiimote_reset();
function wiimote_poll();
function wiimote_activate();
function wiimote_deactivate();

function print_list();

//////////Defines
define wUP,		1;
define wDOWN,	2;
define wLEFT,	4;
define wRIGHT,	8;
define wBUTA,	16;
define wBUTB,	32;
define wPLUS,	64;
define wMINUS,	128;
define wHOME,	256;
define wBUT1,	512;
define wBUT2,	1024;
define wBUTC,	2048;
define wBUTZ,	4096;

//////////Variables

string dll_str,	"ackwii.dll";	//name of dll (should be ackwii.dll)
var wii_connected = 0;
var wii_active = 0;

var wii_mote[5];
var wii_chuk[5];
var wii_buttons;

var wii_buttondown;

var key_wiiu;
var key_wiid;
var key_wiil;
var key_wiir;
var key_wiia;
var key_wiib;
var key_wiiplus;
var key_wiiminus;
var key_wiihome;
var key_wii1;
var key_wii2;
var key_wiic;
var key_wiiz;
var key_wiiany;
var wiimote_raw[3];
var wiiir_raw[2];
var wiichuk_raw[3];
var wiijoy_raw[2];

//////////Pointers
function* on_wiiu = null;
function* on_wiid = null;
function* on_wiil = null;
function* on_wiir = null;
function* on_wiia = null;
function* on_wiib = null;
function* on_wiiplus = null;
function* on_wiiminus = null;
function* on_wiihome = null;
function* on_wii1 = null;
function* on_wii2 = null;
function* on_wiic = null;
function* on_wiiz = null;
function* on_wiiany = null;

function* wiimote_motion = null;
function* wiimote_initmotion = null;

//////////Functions
function wiimote_keys()
{
	key_wiiu = (wii_buttons & wUP) / wUP;
	key_wiid = (wii_buttons & wDOWN) / wDOWN;
	key_wiil = (wii_buttons & wLEFT) / wLEFT;
	key_wiir = (wii_buttons & wRIGHT) / wRIGHT;
	key_wiia = (wii_buttons & wBUTA) / wBUTA;
	key_wiib = (wii_buttons & wBUTB) / wBUTB;
	key_wiiplus = (wii_buttons & wPLUS) / wPLUS;
	key_wiiminus = (wii_buttons & wMINUS) / wMINUS;
	key_wiihome = (wii_buttons & wHOME) / wHOME;
	key_wii1 = (wii_buttons & wBUT1) / wBUT1;
	key_wii2 = (wii_buttons & wBUT2) / wBUT2;
	key_wiic = (wii_buttons & wBUTC) / wBUTC;
	key_wiiz = (wii_buttons & wBUTZ) / wBUTZ;
	key_wiiany = min(key_wiiu + key_wiid + key_wiil + key_wiir + key_wiia +
		key_wiib + key_wiiplus + key_wiiminus + key_wiihome + key_wii1 + key_wii2 +
		key_wiic + key_wiiz, 1);
	wiimote_raw.x = wii_mote[0];
	wiimote_raw.y = wii_mote[1];
	wiimote_raw.z = wii_mote[2];
	wiiir_raw.x = wii_mote[3];
	wiiir_raw.y = wii_mote[4];
	wiichuk_raw.x = wii_chuk[0];
	wiichuk_raw.y = wii_chuk[1];
	wiichuk_raw.z = wii_chuk[2];
	wiijoy_raw.x = wii_chuk[3];
	wiijoy_raw.y = wii_chuk[4];
}

function wiimote_reset()
{
	wii_mote[0] = 0;
	wii_mote[1] = 0;
	wii_mote[2] = 0;
	wii_mote[3] = 0;
	wii_mote[4] = 0;
	wii_chuk[0] = 0;
	wii_chuk[1] = 0;
	wii_chuk[2] = 0;
	wii_chuk[3] = 0;
	wii_chuk[4] = 0;
	wii_buttons = 0;

	wii_buttondown = 0;
}

function wiimote_poll()
{
	if (key_wiiu) {
		if ((wii_buttondown & wUP) != wUP) {wii_buttondown |= wUP; on_wiiu(); on_wiiany();}
	} else {wii_buttondown &= ~wUP;}

	if (key_wiid) {
		if ((wii_buttondown & wDOWN) != wDOWN) {wii_buttondown |= wDOWN; on_wiid(); on_wiiany();}
	} else {wii_buttondown &= ~wDOWN;}

	if (key_wiil) {
		if ((wii_buttondown & wLEFT) != wLEFT){wii_buttondown |= wLEFT; on_wiil(); on_wiiany();}
	} else {wii_buttondown &= ~wLEFT;}

	if (key_wiir) {
		if ((wii_buttondown & wRIGHT) != wRIGHT){wii_buttondown |= wRIGHT; on_wiir(); on_wiiany();}
	} else {wii_buttondown &= ~wRIGHT;}

	if (key_wiia) {
		if ((wii_buttondown & wBUTA) != wBUTA){wii_buttondown |= wBUTA; on_wiia(); on_wiiany();}
	} else {wii_buttondown &= ~wBUTA;}

	if (key_wiib) {
		if ((wii_buttondown & wBUTB) != wBUTB){wii_buttondown |= wBUTB; on_wiib(); on_wiiany();}
	} else {wii_buttondown &= ~wBUTB;}

	if (key_wiiplus) {
		if ((wii_buttondown & wPLUS) != wPLUS) {wii_buttondown |= wPLUS; on_wiiplus(); on_wiiany();}
	} else {wii_buttondown &= ~wPLUS;}

	if (key_wiiminus) {
		if ((wii_buttondown & wMINUS) != wMINUS) {wii_buttondown |= wMINUS; on_wiiminus(); on_wiiany();}
	} else {wii_buttondown &= ~wMINUS;}

	if (key_wiihome) {
		if ((wii_buttondown & wHOME) != wHOME){wii_buttondown |= wHOME; on_wiihome(); on_wiiany();}
	} else {wii_buttondown &= ~wHOME;}

	if (key_wii1) {
		if ((wii_buttondown & wBUT1) != wBUT1){wii_buttondown |= wBUT1; on_wii1(); on_wiiany();}
	} else {wii_buttondown &= ~wBUT1;}

	if (key_wii2) {
		if ((wii_buttondown & wBUT2) != wBUT2){wii_buttondown |= wBUT2; on_wii2(); on_wiiany();}
	} else {wii_buttondown &= ~wBUT2;}

	if (key_wiic) {
		if ((wii_buttondown & wBUTC) != wBUTC){wii_buttondown |= wBUTC; on_wiic(); on_wiiany();}
	} else {wii_buttondown &= ~wBUTC;}

	if (key_wiiz) {
		if ((wii_buttondown & wBUTZ) != wBUTZ){wii_buttondown |= wBUTZ; on_wiiz(); on_wiiany();}
	} else {wii_buttondown &= ~wBUTZ;}

}

//Call function for activation of wiimote
function wiimote_activate()
{
	wii_active = 1;
	wii_connected = wiimote_connect();
	wait (1);
	if (!wii_connected)
	{
		wiimote_deactivate();
	}
	else
	{
		wiimote_initmotion();	//initialization of user routine - set to own function
		while (wii_active)
		{
			wiimote_keys();
			wiimote_poll();
			wiimote_status(wii_mote, wii_chuk, wii_buttons);
			wiimote_motion();	//user routine called every frame - set to own function
			wait (1);
	    }
	}
}

//Call function for shutdown of wiimote
//IMPORTANT! Put wait(1); before closing DLL!!!
function wiimote_deactivate()
{
	wii_active = 0;
	wait (1);
	wiimote_disconnect();
}


//////////Debug helpers

font wiifont = "bigfont.pcx", 10, 16;

//panel to show values retrieved from wiimote and nunchuk
panel wii_panel
{
	pos_x               0;
	pos_y               100;

	digits      0,0,5,wiifont,1,wiimote_raw.x;
	digits      50,0,5,wiifont,1,wiimote_raw.y;
	digits      100,0,5,wiifont,1,wiimote_raw.z;

	digits      0,25,5,wiifont,1,wiiir_raw.x;
	digits      50,25,5,wiifont,1,wiiir_raw.y;

	digits      0,50,5,wiifont,1,wiichuk_raw.x;
	digits      50,50,5,wiifont,1,wiichuk_raw.y;
	digits      100,50,5,wiifont,1,wiichuk_raw.z;

	digits      0,75,5,wiifont,1,wiijoy_raw.x;
	digits      50,75,5,wiifont,1,wiijoy_raw.y;

	digits      0,100,5,wiifont,1,wii_buttons;

	digits      0,125,1,wiifont,1,wii_connected;
	digits      50,125,1,wiifont,1,wii_active;

	flags       overlay,refresh;
}

//assign to on_wiib function pointer
//will record nunchuk and wiimote motion sensors as long as B button is pressed
function print_list()
{
	var listhndl;
	var tmp_fps;

	listhndl = file_open_write ("list.txt");
	tmp_fps = fps_max;
	fps_max = 30;
	wait (1);
	while (key_wiib)
	{
		file_str_write (listhndl, "mote x");
		file_var_write (listhndl, wiimote_raw.x);
		file_str_write (listhndl, " y");
		file_var_write (listhndl, wiimote_raw.y);
		file_str_write (listhndl, " z");
		file_var_write (listhndl, wiimote_raw.z);

		file_str_write (listhndl, "  chuk x");
		file_var_write (listhndl, wiichuk_raw.x);
		file_str_write (listhndl, " y");
		file_var_write (listhndl, wiichuk_raw.y);
		file_str_write (listhndl, " z");
		file_var_write (listhndl, wiichuk_raw.z);

    	file_str_write (listhndl, "
");
		wait(1);
	}
	fps_max = tmp_fps;
	file_close (listhndl);
}