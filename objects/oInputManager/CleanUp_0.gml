delete controllable_state;

if(controllable_type == InputTypes.LOCAL){
	pubsub_unsubscribe("CreateLocalControllableCharacter");
	pubsub_unsubscribe("EnableLocalInputListening");
	pubsub_unsubscribe("DestroyLocalControllableCharacter");
	
	if(PLATFORM_TARGET == 1){
		vMovementStick.destroy();
		vAimStick.destroy();
	}
}