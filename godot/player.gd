extends KinematicBody

var speed = 300
var direction = Vector3()
var facing = Vector3(0,0,0)
var velocity = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
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
