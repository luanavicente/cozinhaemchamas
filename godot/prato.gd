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
	
	if not put_on_plate in on_plate:
		carried_object.get_parent().remove_child(carried_object)
		var player = object.get_parent()
		player.remove_child(object)
		player.is_holding = false
		player.carried_object = null

	var file
	match on_plate:
		'hamburguer':
			match put_on_plate:
				'pao':
					file = preload("res://pao_carne.tscn")
				'queijo':
					file = preload("res://hamburguer_queijo.tscn")
				'tomate':
					file = preload("res://hamburguer_tomate.tscn")
		'pao':
			match put_on_plate:
				'hamburguer':
					file = preload("res://pao_carne.tscn")
				'queijo':
					file = preload("res://pao_queijo.tscn")
				'tomate':
					file = preload("res://pao_tomate.tscn")
		'queijo':
			match put_on_plate:
				'hamburguer':
					file = preload("res://hamburguer_queijo.tscn")
				'pao':
					file = preload("res://pao_queijo.tscn")
				'tomate':
					file = preload("res://queijo_tomate.tscn")
		'tomate':
			match put_on_plate:
				'hamburguer':
					file = preload("res://hamburguer_tomate.tscn")
				'pao':
					file = preload("res://pao_tomate.tscn")
				'queijo':
					file = preload("res://queijo_tomate.tscn")
					
	var instance = file.instance()
	add_child(instance)
	instance.set_global_transform(self.get_node("holding").get_global_transform())
	instance.set_scale(Vector3(0.5,0.5,0.5))
				
