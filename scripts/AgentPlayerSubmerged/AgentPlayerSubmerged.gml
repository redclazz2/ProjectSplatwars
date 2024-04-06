function AgentPlayerSubmerged(_character):AgentPlayerAction(_character) constructor{
	self.controllable_character.image_alpha = 0.4;
	current_optional_speed = self.controllable_character.stats[$ "speed_submerged"];	
	self.controllable_character.latest_action[$ "able_to_weapon"] = false;
	
	self.controllable_character.active_stats[$ "health_regen"] = 
		self.controllable_character.stats[$ "health_regen_submerged"];
	self.controllable_character.active_stats[$ "health_regen_cooldown"] = 
		self.controllable_character.stats[$ "health_regen_cooldown_submerged"];
		
	self.controllable_character.ModifyHealthRegenTimer();
}