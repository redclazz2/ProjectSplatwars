/////////////////////////////////////////////////////////////////////////
/*			INFO		
	-This object is used to initialize global variables, macros, fonts, and ini-files ONCE.
	-Place this object inside the first room of your game. Make sure it is empty.
*////////////////////////////////////////////////////////////////////////

depth = -99999999;
surface_depth_disable( false );

#region Window Sizes
	global.WINDOW		= 0; //which size preset to choose 
	window_create_dimension( 0, 320, 180);
#endregion

#region		General
///////////////////////////////
///---		Globals		---///
/////////////////////////////

enum FONT{
	jasontomlee,
	pixel
	//-- Insert your font here --//
}

global.font[ FONT.jasontomlee ]	 = font_add_sprite( sfont_jasontomlee, ord(" "), 1, 1);
//global.font[ FONT.pixel ]		 =  font_add_sprite( sfont_pixel, ord(" "), 1, 1);

draw_set_font( global.font[ FONT.jasontomlee ] );

// Example of adding your own font 
// global.font[ FONT.pixel ] = font_add_sprite( sfont_pixel, ord(" "), 1, 1 );
// Inside the Draw Event: draw_set_font( global.font[ FONT.pixel ] );

///////////////////////////////
///---		Window		---///
/////////////////////////////
// Save display data ( save & load this data with PauseMenu_Intermediate );
//window_center();
//global.displayWidth  = display_get_width();
//global.displayHeight = display_get_height();


///////////////////////////////////
///---		Dialation		---///
/////////////////////////////////
// Used to dialate a wide variety of variables: Image speed, velocity, particle update speed, cam shake, etc..
global.DEBUG	= true;
global.TIME		= 1;
global.TIME_SET = 1;


///////////////////////////////////
///---		 Macros			---///
/////////////////////////////////
// (used for Platforming inside "oPlayer")
#macro XAXIS 0	//velocity
#macro YAXIS 1
#macro _INDEX 0 //image
#macro _SPEED 1

// Controls ( Example: Key[ _LEFT, _PRESSED ] ) 
#macro _LEFT 0
#macro _RIGHT 1
#macro _UP 2
#macro _DOWN 3
#macro _JUMP 4
#macro _ACTION1 5
#macro _ACTION2 6
#macro _KEY_1_COUNT 7 //make this the last macro


#macro _PREV 0
#macro _PRESSED 1
#macro _PRESS 2
#macro _RELEASED 3
#macro _KEY_2_COUNT 4 //make this the last macro



#endregion

// rPre --> Next Room
if(IS_DEBUG) room_goto(rm_debug);
else room_goto(rm_MainMenu);
