event_inherited()
//Variables para la posición del objeto más cercano
TargetPointX = 0;
TargetPointY = 0;
//Lista de los objetivos
Targets = ds_list_create();
//Bala del dummie
_Proyectile = new Projectile(self[$ "Team"],self[$ "TeamChannel"],300,-10,10,75,6,0.62,0.62,noone,false);
//Funcion instanciar bala
createBullet = function(){
create_projectile(_Proyectile,self.x,self.y,point_direction(self.x,self.y,TargetPointX,TargetPointY));
}
//Time Source para la bala
time_to_shoot = time_source_create(time_source_global,attack_speed,time_source_units_seconds,createBullet,[],-1);