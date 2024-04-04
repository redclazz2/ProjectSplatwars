function AgentPlayerWalk(_character):AgentPlayerAction(_character) constructor{
	self.controllable_character.sprite_index = sPlayerWalk;
	self.controllable_character.active_stats[$ "speed_active"] =
		self.controllable_character.stats[$ "speed_walking"];
}