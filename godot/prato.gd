extends Spatial

var carried_object
var is_holding

func drop_it(player,object):
	if !is_holding:
		hold(player,object)
	else:
		change_models(object)

func _process(delta):
	self.transform.origin.y = 5.2
	self.transform.origin.x = 4.75
	self.transform.origin.z = -1.25
	
func hold(player,object):
	carried_object = object
	object.holder = self
	object.is_holder_player = false
	object.picked_up = false
	object.in_plate = true
	player.carried_object = null
	is_holding = true
	carried_object.leave()
	
func change_models(object):
	var on_plate = carried_object.get_name()
	var put_on_plate = object.get_name()
	
	match on_plate:
		'hamburguer':
			carried_object.get_parent().remove_child(carried_object)
			match put_on_plate:
				'hamburguer':
					pass
				'pao':
					var player = object.get_parent()
					player.remove_child(object)
					player.is_holding = false
					player.carried_object = null
					
					var PAO_BURGUI = preload("res://batatas.tscn")
					var pao_burgui_inst = PAO_BURGUI.instance()
					add_child(pao_burgui_inst)
					pao_burgui_inst.set_global_transform(self.get_node("holding").get_global_transform())
					pao_burgui_inst.set_scale(Vector3(0.3,0.3,0.3))

				'queijo':
					pass
				'tomate':
					pass
		'pao':
			match put_on_plate:
				'hamburguer':
					pass
				'pao':
					pass
				'queijo':
					pass
				'tomate':
					pass
		'queijo':
			match put_on_plate:
				'hamburguer':
					pass
				'pao':
					pass
				'queijo':
					pass
				'tomate':
					pass
		'tomate':
			match put_on_plate:
				'hamburguer':
					pass
				'pao':
					pass
				'queijo':
					pass
				'tomate':
					pass
