if(other[$ "Team"] != get_base_agent_property("Team")){
var newLifeStat = maxLife - other[$ "Damage"]
if (newLifeStat < 0){
instance_destroy();
}else{
maxLife = newLifeStat;
}
}
instance_destroy(other)