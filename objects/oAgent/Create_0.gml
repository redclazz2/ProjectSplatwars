/// @description Agent Definition
/*
	 ___   ___  ___  _  _  _____ 
	/   \ / __|| __|| \| ||_   _|
	| - || (_ || _| | .  |  | |  
	|_|_| \___||___||_|\_|  |_|  
	
	Base for every game object
*/

#region Properties
	agent_base_description = {}
	
	agent_base_description[$ "Team"] = self[$ "Team"] ?? AgentTeamTypes.NEUTRAL;
	agent_base_description[$ "TeamChannel"] = self[$ "TeamChannel"] ?? 
												AgentTeamChannelTypes.ALPHA;
#endregion

function get_base_agent_property(_prop){
	return agent_base_description[$ _prop];
}