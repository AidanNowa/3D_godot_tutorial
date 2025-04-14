extends CharacterBody3D

@export var min_speed = 10 #m/s
@export var max_speed = 18 #m/s

#when player jumps on mob
signal squashed

func _physics_process(delta):
	move_and_slide()
	
#function called from the main scene
func initialize(start_position, player_position):
	#position mob at start_position and rotate it towards player
	look_at_from_position(start_position, player_position, Vector3.UP)
	#rotate mob randomly within range of +/-45 deg to add variation
	rotate_y(randf_range(-PI/4, PI/4))
	
	#calc a random int
	var random_speed = randi_range(min_speed, max_speed)
	velocity = Vector3.FORWARD * random_speed
	#rotate the velocity vector based on the mob's Y rotation to move in direction mob is looking
	velocity = velocity.rotated(Vector3.UP, rotation.y)
	
	$AnimationPlayer.speed_scale = random_speed / min_speed

func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free() #del mob when off screen
	
func squash():
	squashed.emit()
	queue_free()
