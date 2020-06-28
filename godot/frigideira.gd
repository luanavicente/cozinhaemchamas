extends RigidBody

var count_frigideira = 0
var meat

func drop_it(player,object):
	if "hamburguer_cru" in object.get_name():
		hold(player,object)

func _process(delta):
	if meat and meat.in_fryer:
		count_frigideira = count_frigideira + 1
		
	if meat and  "hamburguer_cru" in meat.get_name() and count_frigideira >= 300:
		meat.get_parent().remove_child(meat)
		var BURGUI = preload("res://hamburguer.tscn")
		var burgui_inst = BURGUI.instance()
		self.add_child(burgui_inst)
		burgui_inst.set_global_transform(self.get_node("holding").get_global_transform())
		burgui_inst.set_scale(Vector3(0.5,0.5,0.5))
		meat = burgui_inst
	if meat and meat.get_name() == "hamburguer" and count_frigideira >= 600:
		count_frigideira = 0
		meat.get_parent().remove_child(meat)
		var BURGUI_TOAST = preload("res://hamburguer_queimado.tscn")
		var burgui_toast_inst = BURGUI_TOAST.instance()
		self.add_child(burgui_toast_inst)
		burgui_toast_inst.set_global_transform(self.get_node("holding").get_global_transform())
		burgui_toast_inst.set_scale(Vector3(0.5,0.5,0.5))
		meat = burgui_toast_inst
	
func hold(player,object):
	object.holder = self
	object.is_holder_player = false
	object.picked_up = false
	object.in_fryer = true
	player.carried_object = null
	player.is_holding = false
	count_frigideira = 0
	meat = object
