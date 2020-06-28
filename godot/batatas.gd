extends RigidBody

var picked_up
var in_plate
var is_holder_player
var in_fryer = true
var in_trash = false
var holder
var position

func pick_up(player,is_player):
	if in_plate and is_player:
		holder.is_carrying_batata = false
		holder.is_completed_recipe(player)

	holder = player
	is_holder_player = is_player

	if picked_up and is_holder_player:
		leave()
	else:
		carry()

func _process(delta):
	if $CollisionShape47 and picked_up:
		$CollisionShape47.set_scale(Vector3(0.001,0.001,0.001))
	if in_trash:
		get_parent().remove_child(self)
	
	if holder:
		match holder.get_name():
			'Player':
				position = "Yaw/Camera/pickup_pos"
			'prato':
				position = "holding_batata"
			'fritadeira':
				position = "holding"
	if (picked_up or in_plate) and not in_trash:
		set_global_transform(holder.get_node(position).get_global_transform())
		if !is_holder_player:
			set_scale(Vector3(0.3,0.3,0.3))
			
func carry():
	$CollisionShape.set_disabled(true)
	holder.carried_object = self
	self.set_mode(1)
	picked_up = true
	in_fryer = false

func leave():
	$CollisionShape.set_disabled(false)
	self.set_mode(0)
