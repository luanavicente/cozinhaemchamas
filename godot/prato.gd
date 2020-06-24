extends Spatial

var carried_object
var is_holding

func drop_it(player,object):
	if !is_holding:
		hold(player,object)

func _process(delta):
	pass
	
func hold(player,object):
	carried_object = object
	object.holder = self
	object.is_holder_player = false
	player.carried_object = null
	is_holding = true