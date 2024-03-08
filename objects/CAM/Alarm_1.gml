/// @description Debug buttons & Minimap

#region Mini-map
///////////////////////////////////
///---		Mini-map		---///
/////////////////////////////////
map_x	= window_get_width()/2;
map_y	= window_get_height()/2;
//map_w	= 125; set inside create event
map_h	= ( room_height/room_width )* map_w; //cross mult
map_coord[0]	= global.WINDOW_W- (map_margin+ map_w);	//x1
map_coord[1]	= global.WINDOW_H- (map_h)- map_margin;	//y1
map_coord[2]	= global.WINDOW_W- map_margin;			//x2
map_coord[3]	= global.WINDOW_H- map_margin;			//y2

#endregion

#region Debugger button values 
///////////////////////////////////////////
///---		Positional values		---/// *update in later version*
/////////////////////////////////////////
bstr[ 0 ]	= "SHAKE";
bx[ 0 ]		= 20
by[ 0 ]		= display_get_gui_height()- 60;
bw[ 0 ]		= 90; //width
bh[ 0 ]		= 40;  //height

bstr[ 1 ]	= "FOLLOW";
bx[ 1 ]		= bx[ 0 ] + 75+ bw[ 0 ];
by[ 1 ]		= by[ 0 ];
bw[ 1 ]		= bw[ 0 ]; //width
bh[ 1 ]		= bh[ 0 ];  //height

bstr[ 2 ]	= ""; //View info
bx[ 2 ]		= map_coord[0];
by[ 2 ]		= map_coord[1];
bw[ 2 ]		= map_coord[2]- map_coord[0];
bh[ 2 ]		= map_coord[3]- map_coord[1];


bc	= array_length_1d( bx ); 
bhover	= -1; //hovered button
bselect = -1; //selected button


///////////////////////////////
///---		Buttons		---///
/////////////////////////////
bc	= array_length_1d( bx ); 
bhover	= -1; //hovered button
bselect = -1; //selected button


///////////////////////////////////////
///---		Default values		---///
/////////////////////////////////////
for( var i=0; i<bc;i++;){
	btween[ i ]		= 0; //0-1 tweening var
	bbool[ i ]	= false; //toggle things on/off 
	byoff[ i ]	= 0;
	bxoff[ i ]	= 0;
	balpha[ i ]	= 1;
	bscale[ i ]	= 1;
}
#endregion
