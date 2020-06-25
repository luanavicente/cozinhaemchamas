
extends RigidBody

var picked_up
var in_plate
var is_holder_player
var holder

func pick_up(player,is_player):
	if in_plate and is_player:
		holder.is_holding = false
	
	holder = player
	is_holder_player = is_player

	if picked_up and is_holder_player:
		leave()
	else:
		carry()

func _process(delta):
	if picked_up or in_plate:
		if is_holder_player:
			set_global_transform(holder.get_node("Yaw/Camera/pickup_pos").get_global_transform())
		else:
			set_global_transform(holder.get_node("holding").get_global_transform())
			set_scale(Vector3(0.5,0.5,0.5))
			
func carry():
	$CollisionShape.set_disabled(true)
	holder.carried_object = self
	self.set_mode(1)
	picked_up = true

func leave():
	$CollisionShape.set_disabled(false)
	self.set_mode(0)
