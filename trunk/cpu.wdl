///////////////////////////////////////////////////////////////////////////////////
// ~ 4 Little Warriors ~ Computer player WDL
//
// Modified by Firoball  04/23/2007
///////////////////////////////////////////////////////////////////////////////////

//////////Prototypes
function cpu_move();
function cpu_get_near_item(id);
function cpu_get_nearest_item();
function cpu_get_nearest_player();
function cpu_get_nearest_golem();
function cpu_get_leader();
function cpu_check_player_near_ofs();
function cpu_check_player_near();
function cpu_check_golem_near();
function cpu_check_golem_near_ofs();
function cpu_attack_target();
function cpu_select_target();
function cpu_check_mode();
function cpu_update_target_angle();
function cpu_turn();
function cpu_check_target();
function cpu_stuck();
function cpu_check_targetPtrs(itement);

//////////Variables
var tempslot;
var itemcounter;
var targetdist;
var cpuAction[3];
var playerNear;
var golemNear;

//////////Pointers
entity* tempptr;
entity* itemptr;
entity* tmpplr;
entity* plrTarget; //has to be set AFTER cpu_select_target!!
entity* playerNearest;
entity* golemNearest;

///////////////////////////////////////////////////////////////////////////////////


function cpu_move()
{
	var key_press;
	var key_blocktimer;
	var key_timer;
	my.enable_entity = on;
	my.enable_block = on;

	my.targetPtr = cpu_get_nearest_item();
//	tmpplr = my.targetPtr;
	plrTarget = my.targetPtr;
	cpu_update_target_angle();
	my.targetID = plrTarget.typ;//tmpplr.typ;
	key_blocktimer = 0;
	while (game_status != stat_gameover)
	{
		vec_set (cpuAction, vector (CPUnone, CPUnone, CPUnone));
//add new routines here!!
		cpu_check_mode();

		//deactivate attack mode
		if (my.mode == Pmode_lock || my.mode == Pmode_hit || my.mode == Pmode_critHit)
		{
			key_press = 0;
			key_blocktimer = 0;
			my.fPspecial = off;
		}

		if (cpuAction[Cfire] == CPUnone || cpuAction[Cfire] == CPUattack || cpuAction[Cfire] == CPUcrit)
		{
			//disable block
			if (key_press == 3)
			{
				key_press = 0;
				key_blocktimer = 0;
				if (my.fPblock)
				{
					key_timer = 3;
				 	my.fPblock = off;
				}
			}
		}

		key_timer = max (key_timer - time, 0);
		if (my.mode == Pmode_walk || my.mode == Pmode_charge)
		{
			if (cpuAction[Cfire] == CPUattack)
			{
				my.mode = Pmode_charge;
			}
			if (cpuAction[Cfire] == CPUcrit)
			{
				my.mode = Pmode_charge;
				if (my.stamina == 100)
				{
					my.fPspecial = on;
				}
			}
			if (cpuAction[Cfire] == CPUblock && my.fPblock == off && key_timer == 0 && key_press != 3)
			{
				my.fPprepareBlock = on;
		   		my.mode = Pmode_charge; //switch to fighting mode
				key_blocktimer += time;
				//enable block after certain amoint of time
				if (key_blocktimer > 3.5)
				{
					my.fPprepareBlock = off;
					key_press = 3;
					player_block();
				}
			}
		}

		if (my.mode != Pmode_hit && my.mode != Pmode_critHit && my.mode != Pmode_lock
			&& my.mode != Pmode_ko)
		{
			my.pan = ang (my.pan + cpuAction[Cturn] * PforcePan * time);

			if (cpuAction[Cmove] == CPUup)
			{
				my.forceX = PforceX;
			}
			if (cpuAction[Cmove] == CPUdown)
			{
				my.forceX = PforceXneg;
			}
		}
		player_move();
		wait (1);
	}
	my.transparent = off;
}

/////////////////////////////////////////////////////
function cpu_get_near_item(id)
{
	targetDist = 99999;
	i = 0;
	temp.z = -1;
	while (i < itemcount)
	{
		tempptr = ptr_for_handle (itemlist[i]);
		if(itemtype[i] == id && itemactive[i] != 0 && my.targetPtr != tempptr)
		{
			temp.x = vec_dist (tempptr.x, my.x);
			if (temp.x < targetdist /*&& temp.x > my.limitDist*/)
			{
				temp.z = i;
				targetDist = temp.x;
			}
		}
		i += 1;
	}
	if (temp.z == -1)
	{
		return (null);
//		return (cpu_get_nearest_player()); 	//no target found
	}
	else
	{
		return (ptr_for_handle(itemlist[temp.z]));	//new target
	}
}
var leader;
var itemindex;
function cpu_get_nearest_item()
{
	targetDist = 99999;
	i = 0;
	itemindex = -1;
	if (me == cpu_get_leader())
	{
		leader = 1;
	}
	else
	{
		leader = 0;
	}
	while (i < itemcount)
	{
		tempptr = ptr_for_handle (itemlist[i]);
		if(itemtype[i] != golem && itemactive[i] != 0 && my.targetPtr != tempptr)
		{
			//fix Z for items falling down after opening box
			if (itemtype[i] > item_pow && itemtype[i] < item_maxlimit && tempptr.z != tempptr.gravityZ)
			{
				vec_set (my_pos, tempptr.x);
				my_pos.z = tempptr.gravityZ;
				temp.x = vec_dist (my_pos, my.x);
			}
			else
			{
				temp.x = vec_dist (tempptr.x, my.x);
			}
			if (my.nextTargetID != none)
			{
				trace_mode = activate_shoot + ignore_passents + ignore_passable + ignore_me;
				trace (my.x, tempptr.x);

				//map entity border found
				if (you != null)
				{
					if (your.typ == obstacle)
					{
/*
			beep;
			vec_set (my_pos, your.x);
			vec_sub (my_pos, my.x);
			effect(xparticle_debug, 1, my.X, my_pos);
*/
						you = null;
					}
				}
				if (you != null/* && temp.x < targetDist*/)
				{

/*
			vec_set (my_pos, your.x);
			vec_sub (my_pos, my.x);
			effect(xparticle_debug, 1, my.X, my_pos);
*/
					if (your.typ == box || your.typ == teleporter || (your.typ > items && your.typ < item_maxlimit))
					{
						targetDist = temp.x;
/*
			vec_set (my_pos, your.x);
			vec_sub (my_pos, my.x);
			effect(xparticle_debug, 1, my.X, my_pos);
*/
						itemindex = i;
//						return (ptr_for_handle(itemlist[itemindex]));	//new target
					}
				}
			}
			else
			{
				if ((temp.x < targetdist && itemtype[i] != teleporter)
				&& !(  (tempptr.typ == item_shield && my.sfx == SFXinvul)
					|| (tempptr.typ == item_ghost && my.sfx == SFXghost)
					|| (tempptr.typ == item_magnet && my.sfx == SFXmagnet))
				&& (!(	   (tempptr.typ == item_equalize && leader == 1)
				   		|| (tempptr.typ == item_ghost && my.sfx == SFXinvul)
						|| tempptr.typ == item_mine)
					|| cpu_level < 3)
				)
				{
					itemindex = i;
					targetDist = temp.x;
				}
			}
		}
		i += 1;
	}
	if (itemindex == -1)
	{
		return (null);
	//		return (cpu_get_nearest_player()); 	//no target found
	}
	else
	{
		return (ptr_for_handle(itemlist[itemindex]));	//new target
	}
}

function cpu_get_nearest_player()
{
	//done directly with player pointers for better performance
	temp.x = 99999;
	temp.z = 0;	//BAD TEMPORARY FIX
	i = 0;
	while (i < 4)
	{
		tempptr = ptr_for_handle (playerlist[i]);
		if (my.nextTargetID != none)
		{
			trace_mode = activate_shoot + ignore_passents + ignore_passable + ignore_me;
			trace (my.x, tempptr.x);

			if (you != null)
			{
				if (your.typ == plr)
				{
					temp.x = temp.y;
					temp.z = i;
/*
			vec_set (my_pos, your.x);
			vec_sub (my_pos, my.x);
			effect(xparticle_debug, 1, my.X, my_pos);
*/
					return (ptr_for_handle(playerlist[temp.z]));	//new target
				}
			}
		}
		else
		{
			if (me != tempptr && (my.nextTargetID != none
			|| (tempptr.mode != Pmode_ko
				&& tempptr.sfx != SFXghost
				&& tempptr.sfx != SFXinvul
				&& tempptr.fPinvul == off
				&& tempptr.fPblock == off)
			|| cpu_level < 2
			))
			{
				temp.y = vec_dist (me, tempptr.x);
				if (temp.y < temp.x)
				{
					temp.x = temp.y;
					temp.z = i;
				}
			}
		}
		i += 1;
	}

	//do not allow self selection - DIRTY BUGFIX
	if (ptr_for_handle(playerlist[temp.z]) == me)
	{
		temp.z = (temp.z + 1) % 4;
	}
	//return pointer of nearest player
	return (ptr_for_handle(playerlist[temp.z]));
}

function cpu_get_nearest_golem()
{
	temp.x = 99999;
	temp.z = -1;
	i = 0;
	while (i < itemcount)
	{
		if (itemtype[i] == golem && itemactive[i] == 1)
		{
			tempptr = ptr_for_handle (itemlist[i]);
			temp.y = vec_dist (me, tempptr.x);
			if (my.nextTargetID != none)
			{
				trace_mode = activate_shoot + ignore_passents + ignore_passable + ignore_me;
				trace (my.x, tempptr.x);

				if (you != null)
				{
					if (your.typ == golem)
					{
						temp.x = temp.y;
						temp.z = i;
/*
			vec_set (my_pos, your.x);
			vec_sub (my_pos, my.x);
			effect(xparticle_debug, 1, my.X, my_pos);
*/
						return (ptr_for_handle(itemlist[temp.z]));	//new target
					}
				}
			}
			else
			{
				if (temp.y < temp.x
				&& ((tempptr.mode != Pmode_lock
					&& tempptr.mode != Pmode_die
					&& tempptr.mode != Pmode_hit
					&& tempptr.mode != Pmode_attack
					&& tempptr.mode != Pmode_turn)
					|| cpu_level < 3)
				)
				{
					temp.x = temp.y;
					temp.z = i;
				}
			}
		}
		i += 1;
	}
	if (temp.z < 0)
	{
		return (null);
		//no golem active
 //   	return (cpu_get_nearest_player()); 	//no target found
	}
	else
	{
		//return pointer of nearest golem
		return (ptr_for_handle(itemlist[temp.z]));
	}
}

function cpu_get_leader()
{
	//done directly with player pointers for better performance
	temp.x = 0;
	temp.z = 0;
	i = 0;
	while (i < 4)
	{
		tempptr = ptr_for_handle (playerlist[i]);
		if (tempptr.pow > temp.x)
		{
			temp.x = tempptr.pow;
			temp.z = i;
		}
		i += 1;
	}

	//return pointer of leader
	return (ptr_for_handle(playerlist[temp.z]));
}

function cpu_check_player_near_ofs()
{
	//done directly with player pointers for better performance
	temp = 0;
	i = 0;
	while (i < 4)
	{
		tempptr = ptr_for_handle (playerlist[i]);
		if (me != tempptr)
		{
			if (vec_dist (my.x, tempptr.x) < (distNear - 10) && tempptr.mode != Pmode_ko && tempptr.sfx != SFXghost)
			{
				if (tempptr.mode == Pmode_charge || tempptr.mode == Pmode_attack || tempptr.sfx == SFXinvul)
				{
					temp += 1;
				}
			}
		}
		i += 1;
	}
	return (temp);
}

function cpu_check_player_near()
{
	//done directly with player pointers for better performance
	temp = 0;
	i = 0;
	while (i < 4)
	{
		tempptr = ptr_for_handle (playerlist[i]);
		if (me != tempptr)
		{
			if (vec_dist (my.x, tempptr.x) < distNear
			&& (tempptr.mode != Pmode_ko
				&& tempptr.sfx != SFXghost
				&& tempptr.sfx != SFXinvul
				&& tempptr.fPinvul == off
				&& tempptr.fPblock == off)
			|| cpu_level < 2
			)
			{
				temp += 1;
			}
		}
		i += 1;
	}
	//return amount of near players
	return (temp);
}

function cpu_check_golem_near()
{
	temp = 0;
	i = 0;
	while (i < itemcount)
	{
		if (itemtype[i] == golem && itemactive[i] == 1)
		{
			tempptr = ptr_for_handle (itemlist[i]);
			if (vec_dist (my.x, tempptr.x) < distNear
			&& ((tempptr.mode != Pmode_lock
				&& tempptr.mode != Pmode_die
				&& tempptr.mode != Pmode_hit
				&& tempptr.mode != Pmode_attack
				&& tempptr.mode != Pmode_turn)
			|| cpu_level < 3)
			)
			{
				temp += 1;
			}
		}
		i += 1;
	}
	//return amount of near golems
	return (temp);
}

function cpu_check_golem_near_ofs()
{
	temp = 0;
	i = 0;
	while (i < itemcount)
	{
		if (itemtype[i] == golem && itemactive[i] == 1)
		{
			tempptr = ptr_for_handle (itemlist[i]);
			if (vec_dist (my.x, tempptr.x) < (distNear - 10) &&
			(
				tempptr.mode == Pmode_attack
				|| tempptr.mode == Pmode_charge
			))
			{
				temp += 1;
			}
		}
		i += 1;
	}
	//return amount of near golems
	return (temp);
}

function cpu_attack_target()
{
	//open box
	if (my.targetID == box)
	{
		cpuAction[Cfire] = CPUattack;
		return;
	}

	//activate switch trap
	if (my.targetID == switchtrap)
	{
		cpuAction[Cfire] = CPUattack;
		return;
	}

	//activate step trap
	if (my.targetID == steptrap)
	{
		//nothing to do
		cpuAction[Cfire] = CPUnone;
		return;
	}

	//attack golem/player
	if (my.targetID == golem || my.targetID == plr)
	{
		if ((cpu_check_golem_near() + cpu_check_player_near()) >= 1)
		{
			//at least 1 player/golem near and enough stamina --> special attack
			if (my.stamina >= PstaMax - 15 && cpu_level > 1)
			{
				cpuAction[Cfire] = CPUcrit;
			}
			else
			{
				cpuAction[Cfire] = CPUattack;
			}

			if (my.targetID == golem && cpu_level == 3)
			{
				my.cpuCounter = -timeScanGolem; //set to low value to inhibit scan for near items
			}
			return;
		}
	}

	cpuAction[Cfire] = CPUnone;
}

function cpu_select_target()
{
//plrTarget.unlit = off;
	playerNear = cpu_check_player_near();
	golemNear = cpu_check_golem_near();
	playerNearest = cpu_get_nearest_player();
	golemNearest = cpu_get_nearest_golem();
	if (my.cpucounter > 0)
	{
		my.cpucounter = 0;
	}
	//search for requested item if request is available (player stuck)
	if (my.nextTargetID != none)
	{
		if (my.nextTargetID == items)
		{
			tempent = cpu_get_nearest_item();
		}
		else
		{
			tempent = cpu_get_near_item(item_pow);
		}
		if (tempent == null)
		{
			tempent = cpu_get_nearest_golem();
		}
		if (tempent == null)
		{
			tempent = cpu_get_nearest_player();
		}
	 	my.nextTargetID = none;
		if (tempent != null)
		{
			my.targetPtr = tempent;
			my.targetID = tempent.typ;
			return;
		}
	}

	if (my.targetID == box && vec_dist (my.x, plrTarget.x) <= distNear)
	{
		tmpplr = cpu_get_nearest_item();
		if (tmpplr != null)
		{
			my.targetPtr = tmpplr;
			my.targetID = tmpplr.typ;
			return;
		}
	}

	tmpplr = cpu_get_leader();

	if ((my.sfx == SFXinvul && cpu_level > 1) || (cur_time < 480 && cpu_level == 3))
	{
		temp = vec_dist (my.x, tmpplr.x);
		if (temp <= distNear * 4 && tmpplr != me && tmpplr.fPblock == off && tmpplr.sfx!= SFXinvul && tmpplr.mode != Pmode_ko && tmpplr.fPinvul == off)
		{
			my.targetPtr = tmpplr;
			my.targetID = plr;
			return;
		}
		if (playerNear && playerNearest != null && my.attackLockCounter == 0)
		{
			//do not attack invulnerable players
//			if (playerNearest.fPblock == off && playerNearest.sfx != SFXinvul && playerNearest.mode != Pmode_ko && playerNearest.fPinvul == off)
//			{
				my.targetPtr = playerNearest;
				my.targetID = plr;
				return;
//			}
		}
		if (golemNear && golemNearest != null)
		{
			my.targetPtr = golemNearest;
			my.targetID = golem;
			return;
		}
	}

 	if (tmpplr == me)
	{
		tempent = cpu_get_near_item(box);
		if (tempent != null)
		{
			if (tempent.typ == box && vec_dist (tempent.x, my.x) <= distNear)
			{
				my.targetPtr = tempent;
				my.targetID = box;
				return;
			}
		}

		if (playerNear && playerNearest != null && my.attackLockCounter == 0)
		{
			//do not attack invulnerable players
//			if (playerNearest.fPblock == off && playerNearest.sfx != SFXinvul && playerNearest.mode != Pmode_ko && playerNearest.fPinvul == off)
//			{
				my.targetPtr = playerNearest;
				my.targetID = plr;
				return;
//			}
		}
		if (golemNear && golemNearest != null)
		{
			my.targetPtr = golemNearest;
			my.targetID = golem;
			return;
		}
		tempent = cpu_get_near_item(item_pow);
		if (tempent != null)
		{
			if (tempent.typ == item_pow /*&& (vec_dist (tempent.x, my.x) <= distNear || cpu_level == 1)*/)
			{
				my.targetPtr = tempent;
				my.targetID = item_pow;
				return;
			}
		}
		//todo: trap
		tempent = playerNearest;//cpu_get_near_item(item_pow);
		my.targetPtr = tempent;
		my.targetID = tempent.typ;

	}
	else
	{
		tempent = cpu_get_nearest_item();
		if (tempent != null)
		{
			if (tempent.typ != box && vec_dist (tempent.x, my.x) <= distNear)
			{
				my.targetPtr = tempent;
				my.targetID = tempent.typ;
				return;
			}
		}

		if (golemNear && golemNearest != null)
		{
			my.targetPtr = golemNearest;
			my.targetID = golem;
			return;
		}

		tempent = cpu_get_near_item(box);
		if (tempent != null)
		{
			if (tempent.typ == box && vec_dist (tempent.x, my.x) <= distNear)
			{
				my.targetPtr = tempent;
				my.targetID = box;
				return;
			}
		}

		tempent = cpu_get_near_item(item_pow);
		if (tempent != null)
		{
			if (tempent.typ == item_pow /*&& (vec_dist (tempent.x, my.x) <= distNear || cpu_level == 1)*/)
			{
				my.targetPtr = tempent;
				my.targetID = item_pow;
				return;
			}
		}

		if (playerNear && playerNearest != null && my.attackLockCounter == 0)
		{
			my.targetPtr = playerNearest;
			my.targetID = plr;
			return;
		}

		//todo: trap
		tempent = playerNearest;//cpu_get_near_item(item_pow);
		my.targetPtr = tempent;
		my.targetID = tempent.typ;
	}
}

var cpu_scanned_target;
function cpu_check_mode()
{
	plrTarget = my.targetPtr;
//plrTarget.unlit = on;

	my.stuckCounter = max (0, my.stuckCounter - time);
	my.attackLockCounter = max (0, my.attackLockCounter - time);

	if (my.fPselectTarget == off)
	{
		if ((my.mode == Pmode_charge || my.mode == Pmode_attack) && my.fPprepareBlock == off && my.fPblock == off)
		{
        	my.attackLockCounter = timeAttackLock;
	 //			cpu_turn();
	//	  cpu_check_target();
			return;
		}

		//defensive, golem or player near
		if (((cpu_check_player_near_ofs() && my.targetID != plr)
		|| (cpu_check_golem_near_ofs() && my.targetID != golem))
		&& cpu_level > 1 /*&& random(1) > 0.2 * cpu_level*/)
		{
			if ((my.stamina > 30 || my.fPblock || my.fPprepareBlock) && my.fPinvul == off && my.sfx != SFXinvul)
			{
				cpuAction[Cfire] = CPUblock;
			}
		}
	}
	if (my.mode == Pmode_walk || my.fPselectTarget)
	{
		if (my.fPselectTarget == off)
		{
			if (plrTarget.typ != plr)
			{
				if (itemactive[plrTarget.slot_id] == 1)
				{
					if (plrTarget.typ > item_pow && plrTarget.typ < item_maxlimit)
					{
						if (plrTarget.z != plrTarget.gravityZ)
						{
							//wait until item has fallen down
							return;
						}
					}
				}
			}

			if (vec_dist (my.x, plrTarget.x) > distNear)
			{
				my.cpucounter += time;
				if (my.cpucounter >= timeScan)
				{
					my.fPselectTarget = on;  //target selection enabled
					my.cpucounter -= timeScan;
					cpu_scanned_target = 1;
				}
			}

			if (plrTarget.typ != plr)
			{
				if (itemactive[plrTarget.slot_id] == 0)
				{
					my.fPselectTarget = on;
				}

			}
			else
			{
				if (plrTarget.mode == Pmode_ko
				|| plrTarget.mode == Pmode_hit
				|| plrTarget.sfx == SFXinvul
				|| plrTarget.sfx == SFXghost)
				{
					my.fPselectTarget = on;
				}
			}

		}
		if (my.fPselectTarget)
		{
			my.fPselectTarget = off;
			cpu_select_target(); //modifies my.targetPtr
			tempptr = my.targetPtr;
			//new target nearer?
			if (plrTarget != null)
			{
				if (plrTarget.typ != plr)
				{
					if (itemactive[plrTarget.slot_id] == 1
					&& vec_dist (tempptr.x, my.x) >  vec_dist (plrTarget.x, my.x)
					&& cpu_scanned_target == 1)
					{
						my.targetPtr = plrTarget;
					}
					else
					{
						plrTarget = my.targetPtr;
					}
				}
			}
			else
			{
				plrTarget = my.targetPtr;
			}
			cpu_scanned_target = 0;
			cpu_update_target_angle();
		}

		temp = vec_dist (my.x, plrTarget.x);
		if ((plrTarget.typ == teleporter && temp > distStep) || (plrTarget.typ != teleporter && temp > distReached))
		{
			if (my.targetID == box || my.targetID == golem || my.targetID == plr)
			{
				cpu_update_target_angle();
			}

			if (abs(ang(my.pan - my.targetPan)) < 30 || vec_dist (my.x, plrTarget.x) > distNear)
			{
				cpuAction[Cmove] = CPUup;
			}
			cpu_turn();
		}
		else
		{
			if (my.cpuCounter > 0)
			{
				my.cpuCounter = 0;
			}
			if (my.targetID == box || my.targetID == golem || my.targetID == plr)
			{
				cpu_update_target_angle();
			}
			cpu_turn();
			if (abs(ang(my.pan - my.targetPan)) < 30)
			{
				cpu_check_target();
			}
		}
	}
}

function cpu_update_target_angle()
{
	vec_set (temp, plrTarget.x);
	vec_sub (temp, my.x);
	vec_to_angle (my_angle, temp);
	my.targetPan = ang (my_angle.pan);
}

function cpu_turn()
{
	//avoid constant turning
	if (ang (my.pan - my.targetPan) > -2 && ang (my.pan - my.targetPan) < 2)
	{
		my.pan = my.targetPan;
		return;
	}

	if (ang (my.pan - my.targetPan) < 0)
	{
		cpuAction[Cturn] = CPUleft;
	}
	if (ang (my.pan - my.targetPan) > 0)
	{
		cpuAction[Cturn] = CPUright;
	}
}

function cpu_check_target()
{
	if (my.targetID > items || my.targetID == teleporter)// target collectable?
	{
		my.fPselectTarget = on; //select new target after attack/collection is over
		return;
	}
	else
	{
		cpu_attack_target();
		if (my.cpuCounter >= 0)
		{
			my.fPselectTarget = on; //select new target after attack/collection is over
		}
	}
}

function cpu_stuck()
{
	if (my.mode != Pmode_walk) {return;}
	my.stuckCounter += time + time;
	if (my.stuckCounter > timeStuck * 2)
	{
		my.stuckCounter = 0;
	 	my.nextTargetID = items;
		my.fPselectTarget = on;
		my.cpuCounter = -timeScanStuck; //set to very low value to inhibit scan for near items
	}
}

function cpu_check_targetPtrs(itement)
{
	//scan players for invalid pointers
	i = 0;
	tempptr = itement;
	while (i < 4)
	{
		tempent = ptr_for_handle(playerlist[i]);
		if (tempent.targetPtr == tempptr)
		{
			tempent.fPselectTarget = on;
		}
		i += 1;
	}
}