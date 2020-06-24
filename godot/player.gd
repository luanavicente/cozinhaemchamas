extends KinematicBody

var carried_object = null

# Controls
var velocity = Vector3()
var yaw = 0
var look_vector = Vector3()

# Physics
var gravity = -40

func _ready():
	pass

func _process(d):

	#interações
	if $Yaw/Camera/InteractionRay.is_colliding():
		var x = $Yaw/Camera/InteractionRay.get_collider()
		if x.has_method("pick_up"):
			$interaction_text.set_text("[V]  Pick up: " + x.get_name())
		else:
			if x.has_method("drop_it") and carried_object != null:
				$interaction_text.set_text("[C]  Drop it: " + carried_object.get_name())
			else:
				$interaction_text.set_text("")
	else:
		$interaction_text.set_text("")
	var dir = (get_node("Yaw/Camera/look_at").get_global_transform().origin - get_node("Yaw/Camera").get_global_transform().origin).normalized()
	look_vector = dir

func _physics_process(delta):
	_process_movements(delta)

#mover
var speed = 400
var direction = Vector3()
var facing = Vector3(0,0,0)

func _process_movements(delta):
	direction = Vector3(0,0,0)
	if Input.is_action_pressed("ui_left"):
		rotate_y(deg2rad(90*delta))
	if Input.is_action_pressed("ui_right"):
		rotate_y(deg2rad(-90*delta))
	if Input.is_action_pressed("ui_up"):
		facing = -global_transform.basis.z
	if Input.is_action_pressed("ui_down"):
		facing = global_transform.basis.z
	move_and_slide(facing*delta*speed,Vector3(0,0,1))
	facing = Vector3(0,0,0)

#gravidade
func _apply_gravity(delta):
	velocity.y += delta * gravity

#interações
func _input(event):

	# pegar objeto
	if event.is_action_pressed("pick_up"):
		if carried_object != null:
			carried_object.pick_up(self,'im_player')
		else:
			if $Yaw/Camera/InteractionRay.is_colliding():
				var x = $Yaw/Camera/InteractionRay.get_collider()
				if x.has_method("pick_up"):
					x.pick_up(self,'im_player')
	
	# dropar objeto
	if event.is_action_pressed("drop_it"):
		if carried_object != null:
			if $Yaw/Camera/InteractionRay.is_colliding():
				var x = $Yaw/Camera/InteractionRay.get_collider()
				if x.has_method("drop_it"):
					x.drop_it(self,carried_object)

	# interagir - frigideira, prato
	if event.is_action_pressed("interact"):
		if $Yaw/Camera/InteractionRay.is_colliding():
			var x = $Yaw/Camera/InteractionRay.get_collider()
			print("COLLIDING")
			print(x.get_name())
			if x.has_method("interact"):
				x.interact(self)
