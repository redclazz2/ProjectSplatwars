if(other.get_base_agent_property("Team") != get_base_agent_property("Team")){
newLifeStat = maxLife - other[$ "Damage"]
if(newLifeStat < 0){
instance_destroy();
}else{
maxLife = newLifeStat;
}
instance_destroy(other)
}
