draw_self();
//Debugging
if(is_debugging){
draw_rectangle(x-trigger_size/2,y-trigger_size/2,x+trigger_size/2,y+trigger_size/2,true);
draw_rectangle(TargetPointX-16,TargetPointY-16,TargetPointX+16,TargetPointY+16,true);
}