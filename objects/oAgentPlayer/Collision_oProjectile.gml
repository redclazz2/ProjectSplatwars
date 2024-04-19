if(other.get_base_agent_property("Team") != get_base_agent_property("Team")){
ApplyDamage(other[$ "Damage"]);
instance_destroy(other)
}
