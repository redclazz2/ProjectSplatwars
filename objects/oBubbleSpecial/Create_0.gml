/// @description Bubble context definition

event_inherited();

function changeState(_newState) {
	bubbleState.CleanUp();
	delete bubbleState;
	bubbleState = _newState;
}

bubbleState = new BubbleInitializeState(self);
