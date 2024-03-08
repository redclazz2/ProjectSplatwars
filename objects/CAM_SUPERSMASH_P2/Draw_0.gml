draw_self();
draw_text(x,y+6, "Player 2");
draw_text(x,y+12, "Press to Drag");


if(instance_exists(CAM)){
with(CAM){target_second= other.id;}	
}