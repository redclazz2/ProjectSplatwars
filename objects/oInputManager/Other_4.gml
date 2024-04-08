if(controllable_type == InputTypes.LOCAL){
	pubsub_subscribe("CreateLocalControllableCharacter",EventControllableCharacterCreate);
	pubsub_subscribe("EnableLocalInputListening",EventToggleInputListening);
	pubsub_subscribe("DestroyLocalControllableCharacter",EventControllableCharacterDestroy);
}

if(controllable_type == InputTypes.REMOTE){
	//Remote Character Creation
	//TODO
}
