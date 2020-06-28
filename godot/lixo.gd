extends StaticBody


func drop_it(player,object):
	hold(player,object)

func _process(delta):
	pass
	
func hold(player,object):
	object.in_trash = true
	player.carried_object = null
