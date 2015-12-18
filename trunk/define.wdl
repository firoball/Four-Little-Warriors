///////////////////////////////////////////////////////////////////////////////////
// ~ 4 Little Warriors ~ Define WDL
//
// Modified by Firoball  04/23/2006 (created 01/16/2005)
///////////////////////////////////////////////////////////////////////////////////

//Video modes
define V320x200, 1;
define V320x240, 2;
define V320x400, 3;
define V400x300, 4;
define V512x384, 5;
define V640x480, 6;
define V800x600, 7;
define V1024x768, 8;
define V1280x960, 9;
define V1600x1200, 10;

//game status
define stat_intro, 10;
define stat_menu, 20;
define stat_running, 30;
define stat_gameover, 40;
define stat_loadlevel, 50;
define stat_winner, 60;
define stat_leave, 70;

//Player Movement
define PforceX, 8;
define PforceXneg, -3.5;
define PforcePan, 15;
define PforcePush, 3;
define PforcePushBox, 4.5;
define PforceHit, 15;
define PforceCrit, 50;
define PforceTele, 50;

//Player Stamina
define PstaBlock, 2;
define PstaRecover, 1;
define PstaAttack, 20;
define PstaCrit, 80;
define PstaBlockHit, 5;
define PstaMax, 100;

//Player States
define Pmode_lock, 11;//-1;
define Pmode_walk, 0;
define Pmode_charge, 1;
define Pmode_attack, 2;
define Pmode_initHit, 3;
define Pmode_hit, 4;//3.5;
define Pmode_critHit, 5;//4;
define Pmode_wait, 6; //DO NOT POLL, not used directly
define Pmode_turn, 10;//5;
define Pmode_ko, 8;
define Pmode_die, 9;

//Player Flags
define fPprepareBlock, flag1; //cpu only
define fPselectTarget, flag2; //cpu only
define fPspecial, flag3;
define fPblock, flag4;
define fPinvul, flag5;
define fPevent, flag6;
define fPslow, flag7;
define fPattacked, flag8;
define removed, flag7;	//items only

//Golem Flags (golem partly uses player flags)
define fPturn, flag3;
define fPdead, flag4;
define fPreqReset, flag5;
define fPreqTurn, flag6;

//Aux flags
define enableSlide, flag8;

//Player aux
define PinvulTime, 64;
define swordVertex, 15;
define PtrigRange, 10;
define PtrigMagnet, 150;
define ItrigRange, 5;

//CPU
define Cfire, 0;
define Cturn, 1;
define Cmove, 2;

define CPUnone, 0;
define CPUright, -1;
define CPUleft, 1;
define CPUup, 1;
define CPUdown, -1;
define CPUattack, 1;
define CPUcrit, 2;
define CPUblock, 3;

//Events
define Enone, 0;
define Ehighspeed, 1;
define Eslowmotion, 2;
define Erotation, 3;
define Eposition, 4;
define Emonopoly, 5;
define Eequalize, 6;
define Eupsidedown, 7;
define Esuperpower, 8;

//Event time limits
define EtimeHighspeed, 15;
define EtimeSlowmotion, 15;
define EtimeUpsideDown, 15;
define EtimeSuperpower, 15;

//XMove
define angX, skill12;
define angY, skill13;
define angZ, skill14;

//Player
// note only!! define used_by_weapon_attach, skill1;
// note only!! define used_by_weapon_attach, skill2;
// note only!! define used_by_weapon_attach, skill3;
define staTimer, skill4;
//skill5 already used by load_model, but only required after loading of level
define last_anim_time, skill5;	//blend animation
define invulTimer, skill6;
define contain, skill7;
define cpucounter, skill7;
define typ, skill8;
define lastMode, skill9;		//blend animation
define pow, skill10;
define health, skill10;
define maxhealth, skill11; 		//golem only
define targetPtr, skill11; 		//used by cpu, pointer to current target
define temp_pan, skill12;		//temporary angle (used when attacking)
define nextTargetID, skill13;	//cpu only: manually force new target ID
define stuckCounter, skill14;	//cpu only: register whether player is stuck
define pushvec, skill15;
define pushvecX, skill15;
define pushvecY, skill16;
define pushvecZ, skill17;
define attack_pow, skill18;
define slot_id, skill19;
define limitdist, skill20;
define nestptr, skill20;
define targetID, skill21;
define itemdist, skill22;
define abspeed, skill23;		//absolute speed vector
define abspeedX, skill23;
define abspeedY, skill24;
define abspeedZ, skill25;
define stamina, skill26;
define partcount, skill27;
define sfx, skill28;
define wpn_timer, skill29;
define base_scale, skill30;
//define force, skill30;
define forceX, skill30;			//force vector (only x component required)
define attackLockCounter, skill31;
define wtr_entity, skill32;		//attached water entity
define icefloor, skill32;		//walking on ice
define speed, skill33;			//relative speed vector
define speedX, skill33;
define speedY, skill34;
define speedZ, skill35;
define anim_dist, skill36;		//animation walk cycle
define total_dist, skill37;		//animation walk cycle
define anim_time, skill38;		//animation timer
define speedTimer, skill39;		//effects timer highspeed
define partTimer, skill39;		//effects timer attack
define mode, skill40;			//current player mode
define anim_fac, skill41;		//factor for animation speed
define targetPan, skill42; 		//CPU
define counter, skill43;		//winner sequence
define blendTimer, skill44;		//timer for frame blending
define sndhandle, skill45;		//sound handle for invulnerability
define oldMode, skill46;		//previous mode, needed for frame blending
define weapon_type, skill47;
define ammo, skill48;
define basePan, skill48; //used by winner sequence

//Entities
//define reserved,skill9;	//itembox - to be fixed
define targetX, skill12; //target vector for various uses
define targetY, skill13;
define targetZ, skill14;
define moveCounter, skill26; //lightning weapon only
//define forceX, skill30; //already defined
define forceY, skill31; //not used by player
define forceZ, skill32; //not used by player
define soundTimer, skill39;	//crow sound, island level
define forceFac, skill39;   //lightning weapon
define partCounter, skill40;//weapon
define part_timer, skill40;
define anim_mode, skill40;	//intro_golem animation (eyecandy)
define acidball_lock, skill41;	//used by weapon: acidball
define tempScale, skill45;
define tempMode, skill46;
// note only!! define used_by_itembox,skill46;
// note only!! define used_by_itembox,skill47;
// note only!! define used_by_itembox,skill48;
define bounceCount, skill48; //used by weapon: acidball
define gravityZ, skill48;	//used by items coming from boxes
define posX, skill43;	//position vector
define posY, skill44;
define posZ, skill45;
define angPan, skill43;	//angle vector
define angTilt, skill44;
define angRoll, skill45;
define player_ref, skill47;	//lightning weapon - player pointer

//special abilities (must correspond to item id!!)
define SFXnone, 0;
define SFXmagnet, 12;
define SFXghost, 13;
define SFXinvul, 14;

//prepare special abilities (= SFX + SFXprepare!!)
define SFXprepare, 100;
define pSFXmagnet, 112;
define pSFXghost, 113;
define pSFXinvul, 114;

//item id / type id
define none, 0;
define plr, 1;
define pathway, 2;
define teleporter, 4;
define box, 5;
define golem, 6;
define switchtrap, 7;
define steptrap, 8;
define items, 10;
define item_pow, 11;
define item_magnet, 12;
define item_ghost, 13;
define item_shield, 14;
define item_highspeed, 15;
define item_slowmotion, 16;
define item_position, 17;
define item_rotate, 18;
define item_equalize, 20;
define item_monopoly, 19;
define item_upsidedown, 21;
define item_superpower, 22;
define item_mine, 23;
define item_fireball, 24;
define item_acidball, 25;
define item_lightning, 26;
define item_maxlimit, 27;
define obstacle, 96;
define weapon, 97;
define explosion, 98;
define water, 99;

//weapons
define wep_none, 0;
define wep_fireball, 1;
define wep_acidball, 2;
define wep_lightning, 3;

//assigned controls
define ctl_key1, 0;
define ctl_key2, 1;
define ctl_joy1, 2;
define ctl_joy2, 3;
define ctl_mouse, 4;

define k_up, 0;
define k_down, 1;
define k_left, 2;
define k_right, 3;
define k_fire, 4;

//Camera
define CAMmaxdist, 770;
define CAMmindist, 300;
define CAMtilt, -30;
define CAMpanmod, 3;//7;
define CAMtiltmod, 5;
define CAMdistmod, 200;
define CAMdistfac, 0.95;

//Music
define defaultTrack, 10;//16;
define maxTrack, 7;

//Panels
define panelWidth, 155;
define panelHeight, 62;
define rankWidth, 32;

//Time
define minute, x;
define second, y;

//CPU
define distNear, 70;
define distReached, 40;
define distStep, 15;
define timeScan, 6;
define timeStuck, 5;
define timeScanStuck, 20;
define timeScanGolem, 24;
define timeAttackLock, 8;

//Fog
define FogCol, 0;
define FogStr, 1;

//Scan types
define standard_scan, 0;
define teleport_scan, 1;
define box_scan, 2;

//Weapon
define fWeaponFX, flag8;

//Game Options
define DEFcpu_level, 2;
define DEFtime_limit, 3;
define DEFgame_limit, 3;
define DEFgame_speed, 2;
//Video Options
define DEFvid_depth, 16;
define DEFvid_res, 8;//V1024x768;
define DEFpolyshadows, 2;
define DEFvisualFX, 1;
//Audio Options
define DEFmusic_device, 1;
//Levels
define DEFmaxlevels, 5;
define DEFdemolvl1, 1;
define DEFdemolvl2, 2;
//Models (needed only for demo)
define DEFdemomdl1, 1;
define DEFdemomdl2, 3;