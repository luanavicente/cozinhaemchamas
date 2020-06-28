extends KinematicBody

var carried_object = null
var move_speed = 8
var view_sensitivity = 0.5
var pitch = 0
var is_holding
var is_carrying_batata
var timer = 300
var count_entrega = 0
var count_hamburguer = 0
var count_batata = 0
var entregou = false
var recipe_file = "cardapio"
var frigideira 
var frigideira2
var fritadeira
var mensagem = ""
var mensagem_frigideira = ""
var mensagem_frigideira2 = ""
var mensagem_fritadeira = ""
var mensagem_interacao = ""
var mensagem_entrega = ""

#mover
var speed = 400
var direction = Vector3()
var facing = Vector3(0,0,0)

# Controls
var velocity = Vector3()
var yaw = 0
var look_vector = Vector3()

# Physics
var gravity = -40

#slope variables
const MAX_SLOPE_ANGLE = 60
	
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	change_recipe()
	frigideira = get_parent().get_node('frigideira')
	frigideira2 = get_parent().get_node('frigideira2')
	fritadeira = get_parent().get_node('fritadeira')

func _process(d):
	self.transform.origin.y = 1.8
	
	if entregou:
		count_entrega = count_entrega + 1
	
	var is_showing_message = false
	
	#mensagem de entrega
	if entregou and count_entrega == 1:
		mensagem_entrega = "Prato entregue! Parabéns!\nVeja o pedido novo!"
		change_recipe()
		is_showing_message = true
	elif entregou and count_entrega < timer:
		mensagem_entrega = "Prato entregue! Parabéns!\nVeja o pedido novo!"
		is_showing_message = true
	elif entregou and count_entrega >= timer:
		is_showing_message = true
		entregou = false
		count_entrega = 0
		$interaction_text.set_text("")
	
	#Mensagens frigideira
	if frigideira.meat and frigideira.meat.get_name() == "hamburguer_queimado" and not frigideira.meat.in_trash:
			mensagem_frigideira = "Frigideira 1: O hamburguer queimou. Jogue no lixo! "
	elif frigideira.meat and frigideira.meat.in_fryer:
		if frigideira.count_frigideira < 300: 
			mensagem_frigideira = "Frigideira 1: O hamburguer está fritando!"
		elif frigideira.count_frigideira > 300 and frigideira.count_frigideira < 420: 
			mensagem_frigideira =  "Frigideira 1: O hamburguer está pronto!"
		elif frigideira.count_frigideira > 420 and frigideira.count_frigideira < 600: 
			mensagem_frigideira = "Frigideira 1: O hamburguer está queimando!"
	
	#Mensagens frigideira2
	if frigideira2.meat and frigideira2.meat.get_name() == "hamburguer_queimado" and not frigideira2.meat.in_trash:
			mensagem_frigideira2 = "Frigideira 2: O hamburguer queimou. Jogue no lixo! "
	elif frigideira2.meat and frigideira2.meat.in_fryer:
		if frigideira2.count_frigideira < 300: 
			mensagem_frigideira2 = "Frigideira 2: O hamburguer está fritando!"
		elif frigideira2.count_frigideira > 300 and frigideira2.count_frigideira < 420: 
			mensagem_frigideira2 =  "Frigideira 2: O hamburguer está pronto!"
		elif frigideira2.count_frigideira > 420 and frigideira2.count_frigideira < 600: 
			mensagem_frigideira2 = "Frigideira 2: O hamburguer está queimando!"

	#Mensagens fritadeira
	if fritadeira.fries and fritadeira.fries.get_name() == "batatas_queimadas" and not fritadeira.fries.in_trash:
			mensagem_fritadeira = "Fritadeira: A batata queimou. Jogue no lixo! "
	elif fritadeira.fries and fritadeira.fries.in_fryer:
		if fritadeira.count_fritadeira < 300: 
			mensagem_fritadeira = "Fritadeira: A batata está fritando!"
		elif fritadeira.count_fritadeira > 300 and fritadeira.count_fritadeira < 420: 
			mensagem_fritadeira =  "Fritadeira: A batata está pronta!"
		elif fritadeira.count_fritadeira > 420 and fritadeira.count_fritadeira < 600: 
			mensagem_fritadeira = "Fritadeira: A batata está queimando!"
	#Mensagens de interações
	if !is_showing_message and $Yaw/Camera/InteractionRay.is_colliding():
		var x = $Yaw/Camera/InteractionRay.get_collider()
		
		if x.has_method("pick_up") and carried_object == null:
			mensagem_interacao = "[V]  Pegar: " + x.get_name()
		elif x.has_method("drop_it") and carried_object != null:
			if ('frigideira' in x.get_name() and not('hamburguer_cru' in carried_object.get_name())) or ('fritadeira' in x.get_name() and not('batatas_cruas' in carried_object.get_name())) or (x.get_name() == 'prato' and ("cru" in carried_object.get_name() or "queimad" in carried_object.get_name() or "@" in carried_object.get_name())):
				mensagem_interacao = "Não é possível colocar " + carried_object.get_name() + " aqui"
			else:
				mensagem_interacao = "[C]  Colocar: " + carried_object.get_name()
		elif x.has_method("more_food") and carried_object == null:
			mensagem_interacao = "[B]  Pegar mais comida: " + x.get_name()
		elif x.has_method("deliver") and carried_object == null and x.is_completed:
			mensagem_interacao = "[Espaço]  Entregar: " + x.get_name()
		else:
			mensagem_interacao = ""
	elif !is_showing_message:
		mensagem_interacao = ""
	
	if mensagem_frigideira:
		mensagem = mensagem_frigideira 
	if mensagem_frigideira2:
		mensagem += "\n" + mensagem_frigideira2
	if mensagem_fritadeira:
		mensagem += "\n" + mensagem_fritadeira  
	if mensagem_interacao:
		mensagem += "\n" + mensagem_interacao 
	if mensagem_entrega:
		mensagem = mensagem_entrega 
			
	$interaction_text.set_text(mensagem)
	
	mensagem = ""
	mensagem_interacao = ""
	mensagem_entrega = ""
	mensagem_frigideira = ""
	mensagem_frigideira2 = ""
	mensagem_fritadeira = "" 
		
	var dir = (get_node("Yaw/Camera/look_at").get_global_transform().origin - get_node("Yaw/Camera").get_global_transform().origin).normalized()
	look_vector = dir
	
#move a câmera com o mouse
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		yaw = fmod(yaw - event.relative.x * view_sensitivity, 360)
		pitch = max(min(pitch - event.relative.y * view_sensitivity, 89), -89)
		$Yaw.rotation = Vector3(0, deg2rad(yaw), 0)
		$Yaw/Camera.rotation = Vector3(deg2rad(pitch), 0, 0)

#anda pra lá e pra cá
func _physics_process(delta):
	var up = Input.is_action_pressed("ui_up")
	var down = Input.is_action_pressed("ui_down")
	var left = Input.is_action_pressed("ui_left")
	var right = Input.is_action_pressed("ui_right")

	var aim = $Yaw/Camera.get_camera_transform().basis

	direction = Vector3()

	if up:
		direction -= aim[2]
	if down:
		direction += aim[2]
	if left:
		direction -= aim[0]
	if right:
		direction += aim[0]

	var hvel = velocity
	hvel.y = 0
	var target = direction * move_speed

	hvel = hvel.linear_interpolate(target, move_speed * delta)
	velocity.x = hvel.x
	velocity.z = hvel.z

	velocity = move_and_slide(velocity, Vector3(0, 1, 0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))

#gravidade
func _apply_gravity(delta):
	velocity.y += delta * gravity

#interações
func _input(event):

	# pegar objeto
	if event.is_action_pressed("pick_up"):
		if carried_object == null:
			if $Yaw/Camera/InteractionRay.is_colliding():
				var x = $Yaw/Camera/InteractionRay.get_collider()
				if x.has_method("pick_up"):
					x.pick_up(self,true)
	
	# dropar objeto
	if event.is_action_pressed("drop_it"):
		if carried_object != null:
			if $Yaw/Camera/InteractionRay.is_colliding():
				var x = $Yaw/Camera/InteractionRay.get_collider()
				if x.get_name() in ['prato','lixo', 'frigideira', 'frigideira2', 'fritadeira'] and x.has_method("drop_it"):
					x.drop_it(self,carried_object)
	
	# mais comida
	if event.is_action_pressed("more_food"):
		if carried_object == null:
			if $Yaw/Camera/InteractionRay.is_colliding():
				var caixa = $Yaw/Camera/InteractionRay.get_collider()
				if caixa.get_name() in ['caixapao','caixacarne','caixabatata','caixaqueijo','caixatomate']:
					caixa.more_food(self)
				
	# deliver
	if event.is_action_pressed("deliver"):
		if carried_object == null:
			if $Yaw/Camera/InteractionRay.is_colliding():
				var prato = $Yaw/Camera/InteractionRay.get_collider()
				if prato.get_name() == 'prato' and prato.is_completed:
					entregou = true
					prato.deliver(self)

func change_recipe():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var random = 8#rng.randi_range(1, 8)
	var file
	match random:
		1:
			file = preload("res://cardapio.tscn")
			recipe_file = "cardapio"
		2:
			file = preload("res://cardapio2.tscn")
			recipe_file = "cardapio2"
		3:
			file = preload("res://cardapio3.tscn")
			recipe_file = "cardapio3"
		4:
			file = preload("res://cardapio4.tscn")
			recipe_file = "cardapio4"
		5:
			file = preload("res://cardapio5.tscn")
			recipe_file = "cardapio5"
		6:
			file = preload("res://cardapio6.tscn")
			recipe_file = "cardapio6"
		7:
			file = preload("res://cardapio7.tscn")
			recipe_file = "cardapio7"
		8:
			file = preload("res://cardapio8.tscn")
			recipe_file = "cardapio8"
	
	var instance = file.instance()
	var position_cardapio = get_parent().get_node('position_cardapio')
	
	for i in range(0, position_cardapio.get_child_count()):
		position_cardapio.get_child(i).queue_free()
	
	position_cardapio.add_child(instance)
	instance.set_global_transform(position_cardapio.get_global_transform())
	instance.set_scale(Vector3(1,1,1))
	
	
	
	
	
	
	
