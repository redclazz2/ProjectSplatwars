instance_destroy(main_weapon);
delete state_action;
delete stats;
delete active_stats;
delete latest_action;
time_source_stop(allow_health_regen_timer);
time_source_destroy(allow_health_regen_timer);
event_inherited();
