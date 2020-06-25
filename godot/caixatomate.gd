extends Spatial

var carried_object
var is_holding

func more_food(player):
	var TOMATE = preload("res://hamburguer.tscn")
	var tomate_inst = TOMATE.instance()
	self.add_child(tomate_inst)
	carried_object = tomate_inst
	tomate_inst.holder = self
	tomate_inst.is_holder_player = false
	tomate_inst.picked_up = false
	tomate_inst.in_plate = true
	player.carried_object = null
	is_holding = true
	carried_object.leave()
	tomate_inst.set_global_transform(self.get_node("top").get_global_transform())
	tomate_inst.set_scale(Vector3(0.5,0.5,0.5))
