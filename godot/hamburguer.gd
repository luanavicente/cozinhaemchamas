extends RigidBody

var picked_up
var in_plate
var in_trash = false
var is_holder_player
var holder
var position

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
	if in_trash:
		get_parent().remove_child(self)

	if holder:
		match holder.get_name():
			'Player':
				position = "Yaw/Camera/pickup_pos"
			'prato':
				position = "holding"
			'caixacarne':
				position = "top"
	if (picked_up or in_plate) and not in_trash:
		set_global_transform(holder.get_node(position).get_global_transform())
		if !is_holder_player:
			set_scale(Vector3(0.5,0.5,0.5))
			
func carry():
	$CollisionShape.set_disabled(true)
	holder.carried_object = self
	self.set_mode(1)
	picked_up = true

func leave():
	$CollisionShape.set_disabled(false)
	self.set_mode(0)
