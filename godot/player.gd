extends KinematicBody

var carried_object = null
var move_speed = 8
var view_sensitivity = 0.5
var pitch = 0
var is_holding

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

func _process(d):
	
	self.transform.origin.y = 1.8
	
	#Mensagens de interações
	if $Yaw/Camera/InteractionRay.is_colliding():
		var x = $Yaw/Camera/InteractionRay.get_collider()
		if x.has_method("pick_up") and carried_object == null:
			$interaction_text.set_text("[V]  Pick up: " + x.get_name())
		elif x.has_method("drop_it") and carried_object != null:
			$interaction_text.set_text("[C]  Drop it: " + carried_object.get_name())
		elif x.has_method("more_food") and carried_object == null:
			$interaction_text.set_text("[B]  More food: " + x.get_name())
		elif x.has_method("deliver") and carried_object == null:
			$interaction_text.set_text("[B]  More food: " + x.get_name())
		else:
			$interaction_text.set_text("")
	else:
		$interaction_text.set_text("")
		
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
		if carried_object != null:
			carried_object.pick_up(self,true)
		else:
			if $Yaw/Camera/InteractionRay.is_colliding():
				var x = $Yaw/Camera/InteractionRay.get_collider()
				if x.has_method("pick_up"):
					x.pick_up(self,true)
	
	# dropar objeto
	if event.is_action_pressed("drop_it"):
		if carried_object != null:
			if $Yaw/Camera/InteractionRay.is_colliding():
				var x = $Yaw/Camera/InteractionRay.get_collider()
				if x.has_method("drop_it"):
					x.drop_it(self,carried_object)
	
	# mais comida
	if event.is_action_pressed("more_food"):
		if $Yaw/Camera/InteractionRay.is_colliding():
			var caixa = $Yaw/Camera/InteractionRay.get_collider()
			caixa.more_food(self)
