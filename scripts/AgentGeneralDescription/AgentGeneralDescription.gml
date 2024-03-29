function AgentDescription(_Team,_TeamChannel) constructor{
	Team = _Team;
	TeamChannel = _TeamChannel;
}

function AgentControllableDescription (
	_Team,
	_TeamChannel,
	_InputManager,
	_ControllableType
	):AgentDescription(_Team,_TeamChannel) constructor{
	
	InputManager = _InputManager;
	ControllableType = _ControllableType;
}