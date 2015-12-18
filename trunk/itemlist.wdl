///////////////////////////////////////////////////////////////////////////////////
// ~ 4 Little Warriors ~ Itemlist WDL
//
// Modified by Firoball  03/02/2006 (created 04/13/2005)
///////////////////////////////////////////////////////////////////////////////////

//////////Prototypes
function add_item(tempent);
function hide_item(tempent);
function show_item(tempent);
function clear_itemlist();
function delete_item(tempent);

//////////Variables
define itemMaxSlots, 100;

var itemlist[itemMaxSlots];
var itemtype[itemMaxSlots];
var itemactive[itemMaxSlots];
var itemcount = 0;
var_nsave listhndl;
entity* templist;

//////////Functions//////////
function add_item(tempent)
{
	if (itemcount == itemMaxSlots) {return;}
	tempptr = tempent;
	tempptr.slot_id = itemcount;
	itemlist[itemcount] = handle(tempptr);
	itemtype[itemcount] = tempptr.typ;
	itemactive[itemcount] = 1;
	itemcount += 1;
}

function hide_item(tempent)
{
	tempptr = tempent;
	itemactive[tempptr.slot_id] = 0;
}

function show_item(tempent)
{
	tempptr = tempent;
	itemactive[tempptr.slot_id] = 1;
}

function clear_itemlist()
{
	itemcount = 0;
}

function delete_item(tempent)
{
	tempptr = tempent;
	if (tempptr.slot_id >= itemcount || itemcount == 0) {return;}
	cpu_check_targetPtrs(tempptr);	//check cpu player target pointers
	itemcount -= 1;
	itemlist[tempptr.slot_id] = itemlist[itemcount];
	itemtype[tempptr.slot_id] = itemtype[itemcount];
	itemactive[tempptr.slot_id] = itemactive[itemcount];
	templist = ptr_for_handle(itemlist[tempptr.slot_id]);
	templist.slot_id = tempptr.slot_id;
}
