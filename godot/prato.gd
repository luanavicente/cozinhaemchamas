extends Spatial

var carried_object
var is_holding
var is_completed
var is_carrying_batata

func drop_it(player,object):
	if object.get_name() == 'batatas':
		hold(player,object)
	else:
		if !is_holding:
			hold(player,object)
		else:
			change_models(player,object)

func deliver(player):
	if is_completed:
		remove_child(carried_object)
		if is_carrying_batata:
			remove_child(get_node("batatas"))
		is_completed = false
		is_holding = false
		carried_object = null
		is_carrying_batata = false

func _process(delta):
	self.transform.origin.y = 5.2
	self.transform.origin.x = 4.75
	self.transform.origin.z = -1.25
	
func hold(player,object):
	if object.get_name() == 'batatas':
		is_carrying_batata = true
		object.get_parent().remove_child(object)
		add_child(object)
		object.holder = self
		object.is_holder_player = false
		object.in_plate = true
		object.leave()
	else:
		carried_object = object
		carried_object.leave()
		is_holding = true
		
	is_completed_recipe(player)
	object.holder = self
	object.is_holder_player = false
	object.picked_up = false
	object.in_plate = true
	player.carried_object = null
	
func change_models(player,object):
	var on_plate = carried_object.get_name()
	var put_on_plate = object.get_name()
	
	if not put_on_plate in on_plate:
		carried_object.get_parent().remove_child(carried_object)
		object.get_parent().remove_child(object)
		player.is_holding = false
		player.carried_object = null
	
	if "@" in on_plate:
		on_plate = on_plate.substr(1,on_plate.length() - 3)
	
	if "@" in put_on_plate:
		put_on_plate = put_on_plate.substr(1,put_on_plate.length() - 3)
		
	var file
	match on_plate:
		'hamburguer':
			match put_on_plate:
				'pao':
					file = preload("res://pao_hamburguer.tscn")
				'queijo':
					file = preload("res://hamburguer_queijo.tscn")
				'tomate':
					file = preload("res://hamburguer_tomate.tscn")
				'hamburguer':
					return
		'pao':
			match put_on_plate:
				'hamburguer':
					file = preload("res://pao_hamburguer.tscn")
				'queijo':
					file = preload("res://pao_queijo.tscn")
				'tomate':
					file = preload("res://pao_tomate.tscn")
				'pao':
					return
		'queijo':
			match put_on_plate:
				'hamburguer':
					file = preload("res://hamburguer_queijo.tscn")
				'pao':
					file = preload("res://pao_queijo.tscn")
				'tomate':
					file = preload("res://queijo_tomate.tscn")
				'queijo':
					return
		'tomate':
			match put_on_plate:
				'hamburguer':
					file = preload("res://hamburguer_tomate.tscn")
				'pao':
					file = preload("res://pao_tomate.tscn")
				'queijo':
					file = preload("res://queijo_tomate.tscn")
				'tomate':
					return
		'pao_hamburguer':
			match put_on_plate:
				'queijo':
					file = preload("res://pao_hamburguer_queijo.tscn")
				'tomate':
					file = preload("res://pao_hamburguer_tomate.tscn")
				'pao','hamburguer':
					return
		'pao_queijo':
			match put_on_plate:
				'hamburguer':
					file = preload("res://pao_hamburguer_queijo.tscn")
				'tomate':
					file = preload("res://pao_queijo_tomate.tscn")
				'pao', 'queijo':
					return
		'pao_tomate':
			match put_on_plate:
				'hamburguer':
					file = preload("res://pao_hamburguer_tomate.tscn")
				'queijo':
					file = preload("res://pao_queijo_tomate.tscn")
				'pao', 'tomate':
					return
		'hamburguer_tomate':
			match put_on_plate:
				'queijo':
					file = preload("res://hamburguer_queijo_tomate.tscn")
				'pao':
					file = preload("res://pao_hamburguer_tomate.tscn")
				'hamburguer', 'tomate':
					return
		'hamburguer_queijo':
			match put_on_plate:
				'tomate':
					file = preload("res://hamburguer_queijo_tomate.tscn")
				'pao':
					file = preload("res://pao_hamburguer_queijo.tscn")
				'hamburguer', 'queijo':
					return
		'queijo_tomate':
			match put_on_plate:
				'hamburguer':
					file = preload("res://hamburguer_queijo_tomate.tscn")
				'pao':
					file = preload("res://pao_queijo_tomate.tscn")
				'queijo', 'tomate':
					return
		'pao_hamburguer_tomate':
			match put_on_plate:
				'queijo':
					file = preload("res://lanche.tscn")
				'pao', 'hamburguer', 'tomate':
					return
		'pao_hamburguer_queijo':
			match put_on_plate:
				'tomate':
					file = preload("res://lanche.tscn")
				'pao', 'hamburguer', 'queijo':
					return
		'pao_queijo_tomate':
			match put_on_plate:
				'hamburguer':
					file = preload("res://lanche.tscn")
				'pao', 'queijo', 'tomate':
					return
		'hamburguer_queijo_tomate':
			match put_on_plate:
				'pao':
					file = preload("res://lanche.tscn")
				'hamburguer', 'queijo', 'tomate':
					return

	#cria o modelo
	var instance = file.instance()
	add_child(instance)
	var teste = instance.get_name()
	carried_object = instance
	instance.holder = self
	instance.is_holder_player = false
	instance.in_plate = true
	instance.set_global_transform(self.get_node("holding").get_global_transform())
	instance.set_scale(Vector3(0.5,0.5,0.5))
	is_completed_recipe(player)
	
#vê se tá completo, dependendo da receita
func is_completed_recipe(player):
	if carried_object != null:
		match player.recipe_file:
			"cardapio":
				if !is_carrying_batata and carried_object.get_name() == "lanche":
					is_completed = true
				else:
					is_completed = false
			"cardapio2":
				if !is_carrying_batata and carried_object.get_name() == "pao_hamburguer_queijo":
					is_completed = true
				else:
					is_completed = false
			"cardapio3":
				if !is_carrying_batata and carried_object.get_name() == "pao_hamburguer":
					is_completed = true
				else:
					is_completed = false
			"cardapio4":
				if !is_carrying_batata and carried_object.get_name() == "pao_hamburguer_tomate":
					is_completed = true
				else:
					is_completed = false
			"cardapio5":
				if is_carrying_batata and carried_object.get_name() == "pao_hamburguer_tomate":
					is_completed = true
				else:
					is_completed = false
			"cardapio6":
				if is_carrying_batata and carried_object.get_name() == "lanche":
					is_completed = true
				else:
					is_completed = false
			"cardapio7":
				if is_carrying_batata and carried_object.get_name() == "pao_hamburguer_queijo":
					is_completed = true
				else:
					is_completed = false
			"cardapio8":
				if is_carrying_batata and carried_object.get_name() == "pao_hamburguer":
					is_completed = true
				else:
					is_completed = false
	else:
		is_completed = false
