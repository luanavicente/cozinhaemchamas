extends RigidBody
	
var count_fritadeira = 0
var fries

func drop_it(player,object):
	if "batatas_cruas" in object.get_name():
		hold(player,object)

func _process(delta):
	self.transform.origin.y = 4.813
	self.transform.origin.x = -2.788
	self.transform.origin.z = -8.431
	
	if fries and fries.in_fryer:
		count_fritadeira += 1
		
	if fries and  "batatas_cruas" in fries.get_name() and count_fritadeira >= 300:
		fries.get_parent().remove_child(fries)
		var PAPAS = preload("res://batatas.tscn")
		var papas_inst = PAPAS.instance()
		self.add_child(papas_inst)
		papas_inst.set_global_transform(self.get_node("holding").get_global_transform())
		papas_inst.set_scale(Vector3(0.3,0.3,0.3))
		fries = papas_inst
	if fries and fries.get_name() == "batatas" and count_fritadeira >= 600:
		count_fritadeira = 0
		fries.get_parent().remove_child(fries)
		var PAPAS_TOAST = preload("res://batatas_queimadas.tscn")
		var papas_toast_inst = PAPAS_TOAST.instance()
		self.add_child(papas_toast_inst)
		papas_toast_inst.set_global_transform(self.get_node("holding").get_global_transform())
		papas_toast_inst.set_scale(Vector3(0.3,0.3,0.3))
		fries = papas_toast_inst
	
func hold(player,object):
	object.holder = self
	object.is_holder_player = false
	object.picked_up = false
	object.in_fryer = true
	player.carried_object = null
	player.is_holding = false
	count_fritadeira = 0
	fries = object
