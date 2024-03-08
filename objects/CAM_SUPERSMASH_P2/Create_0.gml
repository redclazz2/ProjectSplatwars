/// @description A dummy 2nd character object to test out the SuperSmash Cam

//Set this object as the second target object inside the Camera
if(instance_exists(CAM)){
with(CAM){target_second= other.id;}	
}