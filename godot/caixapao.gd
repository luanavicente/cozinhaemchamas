extends Spatial

var carried_object
var is_holding

func more_food(player):
	var PAO = preload("res://pao.tscn")
	var pao_inst = PAO.instance()
	self.add_child(pao_inst)
	carried_object = pao_inst
	pao_inst.holder = self
	pao_inst.is_holder_player = false
	pao_inst.picked_up = false
	pao_inst.in_plate = true
	player.carried_object = null
	is_holding = true
	pao_inst.leave()
	pao_inst.set_global_transform(self.get_node("top").get_global_transform())
	pao_inst.set_scale(Vector3(0.5,0.5,0.5))

