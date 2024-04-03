delete controllable_state;
vMovementStick.destroy();
vAimStick.destroy();
if(controllable_type == InputTypes.LOCAL){
	pubsub_unsubscribe("CreateLocalControllableCharacter");
	pubsub_unsubscribe("EnableLocalInputListening");
	pubsub_unsubscribe("DestroyLocalControllableCharacter");
}