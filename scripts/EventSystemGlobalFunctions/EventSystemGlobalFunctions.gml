#region Event System Functions
	function pubsub_subscribe(_event, _func) {
	    with (oGeneralManager) {
	        subscribe(other, _event, _func);
	        return true;
	    }
	    return false;
	}

function pubsub_unsubscribe(_event) {
    with (oGeneralManager) {
        unsubscribe(other, _event);
        return true;
    }
    return false;
}

function pubsub_unsubscribe_all() {
	with (oGeneralManager) {
        unsubscribe_all(other);
        return true;
    }
    return false;
}

function pubsub_publish(_event, _data) {
    with (oGeneralManager) {
        publish(_event, _data);
        return true;
    }
    return false;
}
#endregion