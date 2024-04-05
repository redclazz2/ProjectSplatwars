function AgentPlayerSubmerged(_character):AgentPlayerAction(_character) constructor{
	self.controllable_character.image_alpha = 0.4;
	current_optional_speed = self.controllable_character.stats[$ "speed_submerged"];	
	self.controllable_character.latest_action[$ "able_to_weapon"] = false;
}