extends Spatial

var carried_object
var is_holding
var is_completed

func drop_it(player,object):
	if !is_holding:
		hold(player,object)
	else:
		change_models(object)

func deliver(player):
	if is_completed:
		remove_child(get_node('lanche'))
		is_completed = false
		return 'Pedido entregue!'
	else:
		return ''

func _process(delta):
	self.transform.origin.y = 5.2
	self.transform.origin.x = 4.75
	self.transform.origin.z = -1.25
	
func hold(player,object):
	if object.get_name() != 'lanche':
		is_completed = false
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
	
	print(put_on_plate)
	print(on_plate)
	
	if not put_on_plate in on_plate:
		carried_object.get_parent().remove_child(carried_object)
		object.get_parent().remove_child(object)
		var player = object.holder
		player.is_holding = false
		player.carried_object = null

	var file
	match on_plate:
		'hamburguer':
			is_completed = false
			match put_on_plate:
				'pao':
					file = preload("res://pao_hamburguer.tscn")
				'queijo':
					file = preload("res://hamburguer_queijo.tscn")
				'tomate':
					file = preload("res://hamburguer_tomate.tscn")
		'pao':
			is_completed = false
			match put_on_plate:
				'hamburguer':
					file = preload("res://pao_hamburguer.tscn")
				'queijo':
					file = preload("res://pao_queijo.tscn")
				'tomate':
					file = preload("res://pao_tomate.tscn")
		'queijo':
			is_completed = false
			match put_on_plate:
				'hamburguer':
					file = preload("res://hamburguer_queijo.tscn")
				'pao':
					file = preload("res://pao_queijo.tscn")
				'tomate':
					file = preload("res://queijo_tomate.tscn")
		'tomate':
			is_completed = false
			match put_on_plate:
				'hamburguer':
					file = preload("res://hamburguer_tomate.tscn")
				'pao':
					file = preload("res://pao_tomate.tscn")
				'queijo':
					file = preload("res://queijo_tomate.tscn")
		'pao_hamburguer':
			is_completed = false
			match put_on_plate:
				'queijo':
					file = preload("res://pao_hamburguer_queijo.tscn")
				'tomate':
					file = preload("res://pao_hamburguer_tomate.tscn")
		'pao_queijo':
			is_completed = false
			match put_on_plate:
				'hamburguer':
					file = preload("res://pao_hamburguer_queijo.tscn")
				'tomate':
					file = preload("res://pao_queijo_tomate.tscn")
		'pao_tomate':
			is_completed = false
			match put_on_plate:
				'hamburguer':
					file = preload("res://pao_hamburguer_tomate.tscn")
				'queijo':
					file = preload("res://pao_queijo_tomate.tscn")
		'hamburguer_tomate':
			is_completed = false
			match put_on_plate:
				'queijo':
					file = preload("res://hamburguer_queijo_tomate.tscn")
				'pao':
					file = preload("res://pao_hamburguer_tomate.tscn")
		'hamburguer_queijo':
			is_completed = false
			match put_on_plate:
				'tomate':
					file = preload("res://hamburguer_queijo_tomate.tscn")
				'pao':
					file = preload("res://pao_hamburguer_queijo.tscn")
		'queijo_tomate':
			is_completed = false
			match put_on_plate:
				'hamburguer':
					file = preload("res://hamburguer_queijo_tomate.tscn")
				'pao':
					file = preload("res://pao_queijo_tomate.tscn")
		'pao_hamburguer_tomate':
			match put_on_plate:
				'queijo':
					is_completed = true
					file = preload("res://lanche.tscn")
		'pao_hamburguer_queijo':
			match put_on_plate:
				'tomate':
					is_completed = true
					file = preload("res://lanche.tscn")
		'pao_queijo_tomate':
			match put_on_plate:
				'hamburguer':
					is_completed = true
					file = preload("res://lanche.tscn")
		'hamburguer_queijo_tomate':
			match put_on_plate:
				'pao':
					is_completed = true
					file = preload("res://lanche.tscn")

	var instance = file.instance()
	add_child(instance)
	carried_object = instance
	instance.holder = self
	instance.is_holder_player = false
	instance.in_plate = true
	instance.set_global_transform(self.get_node("holding").get_global_transform())
	instance.set_scale(Vector3(0.5,0.5,0.5))
				
