extends KinematicBody

var speed = 400
var direction = Vector3()

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
