extends RigidBody

var counter = 0
var meat

func drop_it(player,object):
	if object.get_name() == "hamburguer_cru":
		hold(player,object)

func _process(delta):
	counter = counter + 1

	if meat and meat.get_name() == "hamburguer_cru" and counter >= 300:
		counter = 0
		meat.get_parent().remove_child(meat)
		var BURGUI = preload("res://hamburguer.tscn")
		var burgui_inst = BURGUI.instance()
		self.add_child(burgui_inst)
		burgui_inst.set_global_transform(self.get_node("holding").get_global_transform())
		burgui_inst.set_scale(Vector3(0.5,0.5,0.5))
		meat = burgui_inst
		
	
func hold(player,object):
	object.holder = self
	object.is_holder_player = false
	object.picked_up = false
	object.in_fryer = true
	player.carried_object = null
	player.is_holding = false
	counter = 0
	meat = object
