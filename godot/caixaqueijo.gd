extends Spatial

var carried_object
var is_holding

func more_food(player):
	var QUEIJO = preload("res://queijo.tscn")
	var queijo_inst = QUEIJO.instance()
	self.add_child(queijo_inst)
	carried_object = queijo_inst
	queijo_inst.holder = self
	queijo_inst.is_holder_player = false
	queijo_inst.picked_up = false
	queijo_inst.in_plate = true
	player.carried_object = null
	is_holding = true
	carried_object.leave()
	queijo_inst.set_global_transform(self.get_node("top").get_global_transform())
	queijo_inst.set_scale(Vector3(0.5,0.5,0.5))

