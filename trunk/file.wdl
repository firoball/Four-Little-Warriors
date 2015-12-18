///////////////////////////////////////////////////////////////////////////////////
// ~ 4 Little Warriors ~ File Access WDL
//
// Modified by Firoball 03/26/2006
///////////////////////////////////////////////////////////////////////////////////

FONT bigfont, <bigfont.pcx>,10,16;//<menufont.pcx>,12,15;

STRING curname_str, "Enter level Name!!";
STRING n1_str, "Enter level Name here (max 30)";
STRING n2_str, "Enter level Name here (max 30)";
STRING n3_str, "Enter level Name here (max 30)";
STRING n4_str, "Enter level Name here (max 30)";
STRING n5_str, "Enter level Name here (max 30)";
STRING n6_str, "Enter level Name here (max 30)";
STRING n7_str, "Enter level Name here (max 30)";
STRING n8_str, "Enter level Name here (max 30)";
STRING n9_str, "Enter level Name here (max 30)";
STRING n10_str, "Enter level Name here (max 30)";
STRING n11_str, "Enter level Name here (max 30)";
STRING n12_str, "Enter level Name here (max 30)";
STRING n13_str, "Enter level Name here (max 30)";
STRING n14_str, "Enter level Name here (max 30)";
STRING n15_str, "Enter level Name here (max 30)";
STRING n16_str, "Enter level Name here (max 30)";
STRING n17_str, "Enter level Name here (max 30)";
STRING n18_str, "Enter level Name here (max 30)";
STRING n19_str, "Enter level Name here (max 30)";
STRING n20_str, "Enter level Name here (max 30)";
STRING curpic_str, "            ";
STRING p1_str, "            ";
STRING p2_str, "            ";
STRING p3_str, "            ";
STRING p4_str, "            ";
STRING p5_str, "            ";
STRING p6_str, "            ";
STRING p7_str, "            ";
STRING p8_str, "            ";
STRING p9_str, "            ";
STRING p10_str, "            ";
STRING p11_str, "            ";
STRING p12_str, "            ";
STRING p13_str, "            ";
STRING p14_str, "            ";
STRING p15_str, "            ";
STRING p16_str, "            ";
STRING p17_str, "            ";
STRING p18_str, "            ";
STRING p19_str, "            ";
STRING p20_str, "            ";
STRING curdesc_str, "1234567890123456789012345678901234567890123456789012345678901234567890";
STRING d1_str, "1234567890123456789012345678901234567890123456789012345678901234567890";
STRING d2_str, "1234567890123456789012345678901234567890123456789012345678901234567890";
STRING d3_str, "1234567890123456789012345678901234567890123456789012345678901234567890";
STRING d4_str, "1234567890123456789012345678901234567890123456789012345678901234567890";
STRING d5_str, "1234567890123456789012345678901234567890123456789012345678901234567890";
STRING d6_str, "1234567890123456789012345678901234567890123456789012345678901234567890";
STRING d7_str, "1234567890123456789012345678901234567890123456789012345678901234567890";
STRING d8_str, "1234567890123456789012345678901234567890123456789012345678901234567890";
STRING d9_str, "1234567890123456789012345678901234567890123456789012345678901234567890";
STRING d10_str, "1234567890123456789012345678901234567890123456789012345678901234567890";
STRING d11_str, "1234567890123456789012345678901234567890123456789012345678901234567890";
STRING d12_str, "1234567890123456789012345678901234567890123456789012345678901234567890";
STRING d13_str, "1234567890123456789012345678901234567890123456789012345678901234567890";
STRING d14_str, "1234567890123456789012345678901234567890123456789012345678901234567890";
STRING d15_str, "1234567890123456789012345678901234567890123456789012345678901234567890";
STRING d16_str, "1234567890123456789012345678901234567890123456789012345678901234567890";
STRING d17_str, "1234567890123456789012345678901234567890123456789012345678901234567890";
STRING d18_str, "1234567890123456789012345678901234567890123456789012345678901234567890";
STRING d19_str, "1234567890123456789012345678901234567890123456789012345678901234567890";
STRING d20_str, "1234567890123456789012345678901234567890123456789012345678901234567890";

STRING lvlname_str,"Enter level Name here!";
STRING lvldesc_str, "1234567890123456789012345678901234567890123456789012345678901234567890";
STRING lvlfname_str, "            ";
STRING lvlselect_str, "Select Stage";

TEXT name_txt
{
        FONT bigfont;
        STRINGS 20;
        STRING n1_str,n2_str,n3_str,n4_str,n5_str,n6_str,n7_str,n8_str,n9_str,n10_str,n11_str,n12_str,n13_str,n14_str,n15_str,n16_str,n17_str,n18_str,n19_str,n20_str;
}

TEXT picture_txt
{
        FONT bigfont;
        STRINGS 20;
        STRING p1_str,p2_str,p3_str,p4_str,p5_str,p6_str,p7_str,p8_str,p9_str,p10_str,p11_str,p12_str,p13_str,p14_str,p15_str,p16_str,p17_str,p18_str,p19_str,p20_str;
}

TEXT description_txt
{
        FONT bigfont;
        STRINGS 20;
        STRING d1_str,d2_str,d3_str,d4_str,d5_str,d6_str,d7_str,d8_str,d9_str,d10_str,d11_str,d12_str,d13_str,d14_str,d15_str,d16_str,d17_str,d18_str,d19_str,d20_str;
}

TEXT lvldesc_txt
{
        LAYER 7;
        POS_X=320;
        POS_Y=400;
        FONT bigfont;
        STRING lvldesc_str;
//        FLAGS CENTER_X,VISIBLE;
}

TEXT lvlname_txt
{
        LAYER 7;
        POS_X=320;
        POS_Y=6;
        FONT bigfont;
        STRING lvlname_str;
//        FLAGS CENTER_X,VISIBLE;
}

TEXT lvlselect_txt
{
        LAYER 7;
        POS_X=5;
        POS_Y=108;
        FONT bigfont;
        STRING lvlselect_str;
}

STRING reglevel_str, "reglevel.dat";
STRING levels_str, "levels.dat";
STRING levelnrdat_str, "levelnr.dat";
var filehandle;
var filecount=1;
var levnum;
var maxlev;
var nullvar=0;
var curlev=1;
SYNONYM lvlpic {TYPE ENTITY;}
function select_lev_right();
function select_lev_left();
/*
BMAP levpan_map, <menubase.pcx>;
BMAP levtop_map, <menutop.pcx>;

PANEL levpan_pan
{
POS_X -2;
POS_Y 100;
LAYER 6;
BMAP levpan_map;
FLAGS OVERLAY,REFRESH;
}

PANEL levtop_pan
{
POS_X 0;
POS_Y -2;
LAYER 6;
BMAP levtop_map;
FLAGS OVERLAY,REFRESH;
}
*/
///////////////////////////////////////////////////////////////////////////////////

FUNCTION get_levels()
{
        filehandle=file_open_game(reglevel_str);
//file did not exist...
        IF (filehandle==0)
        {
                str_cpy(lvlname_str,"error loading data: fnf");
                RETURN;
        }

//check number of new level, cancel if 0
        levnum=file_var_read(filehandle);
        IF (levnum<=0)
        {
                file_close(filehandle);
                str_cpy(lvlname_str,"error loading data: dnf");
                RETURN;
        }

//reading string data
        filecount=1;
        WHILE (filecount<=levnum)
        {
                file_str_read(filehandle,name_txt.STRING[filecount]);
                file_str_read(filehandle,picture_txt.STRING[filecount]);
                file_str_read(filehandle,description_txt.STRING[filecount]);
                filecount+=1;
                WAIT (1);
        }
        file_close(filehandle);

//write 0 at beginning to set an empty level list
        filehandle=file_open_write(reglevel_str);
        file_var_write(filehandle,nullvar);
        file_close(filehandle);

//add data to user level list
        filecount=1;
        filehandle=file_open_append(levels_str);
        WHILE (filecount<=levnum)
        {
                file_str_write(filehandle,name_txt.STRING[filecount]);
                file_str_write(filehandle,"\n");
                file_str_write(filehandle,picture_txt.STRING[filecount]);
                file_str_write(filehandle,"\n");
                file_str_write(filehandle,description_txt.STRING[filecount]);
                file_str_write(filehandle,"\n");
                filecount+=1;
                WAIT (1);
        }
        file_close(filehandle);

//write number of registered user levels
        filehandle=file_open_game(levelnrdat_str);
        maxlev=0;
        IF (filehandle!=0)
        {
                maxlev=file_var_read(filehandle);
                file_close(filehandle);
        }
        maxlev+=levnum;
        filehandle=file_open_write(levelnrdat_str);
        file_var_write(filehandle,maxlev);
        file_close(filehandle);

//data loaded and added
        str_cpy(lvlname_str,"User level data loaded");
}

///////////////////////////////////////////////////////////////////////////////////

FUNCTION load_leveldata()
{
        filehandle=file_open_game(levelnrdat_str);
        IF (filehandle==0)
        {
                str_cpy(lvlname_str,"No User Levels found");
                RETURN;
        }
        maxlev=file_var_read(filehandle);
        maxlev=MIN(maxlev,20);
        file_close(filehandle);
        filehandle=file_open_game(levels_str);
//file did not exist...
        IF (filehandle==0)
        {
                str_cpy(lvlname_str,"No User Levels found");
                RETURN;
        }
        filecount=1;
        WHILE (filecount<=maxlev)
        {
                file_str_read(filehandle,name_txt.STRING[filecount]);
                file_str_read(filehandle,picture_txt.STRING[filecount]);
                file_str_read(filehandle,description_txt.STRING[filecount]);
                filecount+=1;
                WAIT (1);
        }
        file_close(filehandle);
        return;
//temp
        show_menu();
//
        ON_CUR=select_lev_right;
        ON_CUL=select_lev_left;
        display_level(1);
/*
        str_cpy (lvlname_str,name_txt.STRING[1]);
        str_cpy (lvldesc_str,description_txt.STRING[1]);
        str_cpy (lvlfname_str,picture_txt.STRING[1]);
        levpan_pan.VISIBLE=1;
        lvlselect_txt.VISIBLE=1;
        levtop_pan.POS_X=SCREEN_SIZE.X/2-150;
        lvlname_txt.POS_X=SCREEN_SIZE.X/2;
        levtop_pan.VISIBLE=1;
//        CALL _show_menu;
        LOAD_LEVEL lvlfname_str;
*/
}

///////////////////////////////////////////////////////////////////////////////////

FUNCTION display_level(curlev)
{
        str_cpy (lvlname_str,name_txt.STRING[curlev]);
        str_cpy (lvldesc_str,description_txt.STRING[curlev]);
        str_cpy (lvlfname_str,picture_txt.STRING[curlev]);
//        levpan_pan.VISIBLE=1;
        lvlselect_txt.VISIBLE=1;
//        levtop_pan.POS_X=SCREEN_SIZE.X/2-150;
        lvlname_txt.POS_X=SCREEN_SIZE.X/2;
//        levtop_pan.VISIBLE=1;
        WAITT (16);
//        LOAD_LEVEL lvlfname_str;
}

FUNCTION select_lev_right()
{
        curlev+=1;
        IF (curlev>maxlev)
        {
                curlev=1;
        }
//        WAIT 1;
        display_level(curlev);
}

FUNCTION select_lev_left()
{
        curlev-=1;
        IF (curlev<1)
        {
                curlev=maxlev;
        }
//        WAIT 1;
        display_level(curlev);
}