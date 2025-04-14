extends CharacterBody3D

#How fast the player moves (m/s)
@export var speed = 14
#downard acceleration when in the air (m/s^2)
@export var fall_acceleration = 75

var target_velocity = Vector3.ZERO

func _physics_process(delta):
	var direction = Vector3.ZERO
	
	#check for each move input and update accordingly
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x += -1
	if Input.is_action_pressed("move_back"):
		#in 3D XZ is the ground plane. (positive is backwards like 2D's Y)
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z += -1
	
	#normalize
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.basis = Basis.looking_at(direction) #affects the roration of the node
	
	#ground velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	#veritcal velocity
	if not is_on_floor(): #if in air, fall towards floor
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	
	#move char
	velocity = target_velocity
	move_and_slide() #part of characterbody3d class, moves char smoothly
