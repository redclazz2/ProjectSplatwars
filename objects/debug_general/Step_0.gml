/// @description

if ( mouse_check_button_pressed( mb_left )){
//	part_burst( SYSTEM.DEFAULT, TYPE.PART_CLOUD, mouse_x,mouse_y, 10, 90, 360 );
}

#region Variables
///////////////////////////////
///---		Input		---///
/////////////////////////////
var kRestart, kExit, kPrev, kNext, kTab, kUp, kDown, kSpace;

kRestart = keyboard_check_pressed(ord("R"));
kExit    = keyboard_check_pressed(vk_escape);
kPrev    = keyboard_check_pressed( ord( "1" ));
kNext    = keyboard_check_pressed( ord( "2" ));

kTab	= keyboard_check_pressed( vk_tab );
kUp		= keyboard_check( vk_up );
kDown	= keyboard_check( vk_down );
kSpace  = keyboard_check_pressed( vk_space );

#endregion

#region Controls
//  **		Remove this when PAUSEMENU is imported into your project		** //
if (kRestart)
    room_restart();
if (kExit)
    game_end();

if ( kTab ){ // Toggle debug
	global.DEBUG = !global.DEBUG;
	
	if ( debug_alpha_set == 1 ) //Adjust the screen text alpha
		debug_alpha_set = 0;
	else
		debug_alpha_set = 1;
	
	nset[ 0 ] = ( debug_alpha_set ); //Set target value **Update in later version**
}

///////////////////////////////////
///---		Swap Rooms		---///
/////////////////////////////////
if (kPrev) {
    if (room == room_first){
        room_goto(room_last);
	}else{
        room_goto_previous();
	}
}
if (kNext) {
    if (room == room_last){
        room_goto(room_first);
	}else{
        room_goto_next();
	}
}


///////////////////////////////
///---		Other		---///
/////////////////////////////
if ( kSpace ){ 
	if ( global.TIME_SET == 1 )
		global.TIME_SET = 0.33; //press Ppace to slow down time to 0.4x
	else
		global.TIME_SET = 1;
}

#endregion