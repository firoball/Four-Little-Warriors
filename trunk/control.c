
#include <acknex.h>

STRING* key_map_str[300]; 

function init_keymap()
{

	var tmp_hndl;
	var ret;
	int i;
	
	tmp_hndl = file_open_read("bla.txt");

	for(i = 0; ret != -1; i++)
	{
		key_map_str[i] = str_create("#10");
		ret = file_str_read(tmp_hndl, key_map_str[i]);
	}
}