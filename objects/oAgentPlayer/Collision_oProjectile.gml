if(other.get_base_agent_property("Team") != get_base_agent_property("Team") && self.active_stats[$ "health_active"] != 0){
ApplyDamage(other[$ "Damage"]);
instance_destroy(other)
}
