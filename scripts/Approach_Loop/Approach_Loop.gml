/// @description  Approach_Loop(start, end, shift);
/// @param  start
/// @param  end
/// @param  shift
function Approach_Loop(argument0, argument1, argument2) {

	//returns 0 if value is greater than 'end'

	var _val	= argument0+ argument2;

	if ( _val > argument1 ){
		return 0;
	} else if ( _val < 0 ){
		return argument1;
	}else {
		return _val;
	}




}
