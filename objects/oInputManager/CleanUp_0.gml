delete controllable_state;
vMovementStick.destroy();
vAimStick.destroy();

pubsub_unsubscribe("CreateLocalControllableCharacter");
pubsub_unsubscribe("EnableLocalInputListening");
pubsub_unsubscribe("DestroyLocalControllableCharacter");