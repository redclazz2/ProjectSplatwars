/// @description Apply changes

/* Version 3
#region Apply changes to the Camera
camera_set_view_pos(  view_camera[0], view_x+ shakex, view_y+ shakey );
camera_set_view_size( view_camera[0], view_w, view_h );
camera_set_view_angle( view_camera[0], view_a );

#endregion
*/

//Ensure Shake & Offset values never go out of the room!
//"inroom" variable only applies to the view_x/y coords in the step event.
var clamped_view_x = clamp(view_x+ shakex+ view_xoff,0, room_width- view_w );
var clamped_view_y = clamp(view_y+ shakey+ view_yoff/*+ ysine*/,0, room_height- view_h);

#region Apply changes to the Camera
camera_set_view_pos(   view_camera[0], clamped_view_x,clamped_view_y );
camera_set_view_size(  view_camera[0], view_w, view_h );
camera_set_view_angle( view_camera[0], view_a );

#endregion


