depth = -1;
_drawManager = new IUserInterface(self);

change_user_interface = function(_new){
	if(_new != undefined) _drawManager = _new;
}