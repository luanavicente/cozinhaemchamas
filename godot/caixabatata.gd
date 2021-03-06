extends Spatial

var carried_object
var is_carrying_batata

func more_food(player):
	var BATATA = preload("res://batatas_cruas.tscn")
	var batata_inst = BATATA.instance()
	self.add_child(batata_inst)
	carried_object = batata_inst
	batata_inst.holder = self
	batata_inst.is_holder_player = false
	batata_inst.picked_up = false
	player.carried_object = null
	is_carrying_batata = true
	carried_object.leave()
	batata_inst.set_global_transform(self.get_node("top").get_global_transform())
	batata_inst.set_scale(Vector3(0.5,0.5,0.5))
