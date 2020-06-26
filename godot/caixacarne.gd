extends Spatial

var carried_object
var is_holding

func more_food(player):
	var BURGUI = preload("res://hamburguer_cru.tscn")
	var burgui_inst = BURGUI.instance()
	self.add_child(burgui_inst)
	carried_object = burgui_inst
	burgui_inst.holder = self
	burgui_inst.is_holder_player = false
	burgui_inst.picked_up = false
	player.carried_object = null
	is_holding = true
	carried_object.leave()
	burgui_inst.set_global_transform(self.get_node("top").get_global_transform())
	burgui_inst.set_scale(Vector3(0.5,0.5,0.5))

