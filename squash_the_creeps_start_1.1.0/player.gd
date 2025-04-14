extends CharacterBody3D

#How fast the player moves (m/s)
@export var speed = 14
#downard acceleration when in the air (m/s^2)
@export var fall_acceleration = 75
#vertical impluse applied to char when jumping (m/s)
@export var jump_impluse = 20
#vertical impluse applied to char when bouncing on mob (m/s)
@export var bounce_impluse = 16

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
	
	#jumping!
	if is_on_floor() and Input.is_action_pressed("jump"):
		target_velocity.y = jump_impluse
	
	#iterate through all collisions that occurred this frame:
	for index in range(get_slide_collision_count()):
		#store collsion with player
		var collision = get_slide_collision(index)
		
		#if duplicate collisons, mob is deleted after the first collision
		#2nd call to get_collider will return null, returning a null pointer
		#when collision.get_collider().is_in_group("mob") is called
		#this prevents processing of duplicates
		if collision.get_collider() == null:
			continue
		
		#if collider is with a mob
		if collision.get_collider().is_in_group("mob"):
			var mob = collision.get_collider()
			#check if hitting from above
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				mob.squash()
				target_velocity.y = bounce_impluse
				break # prevent further duplicates
		
	
	move_and_slide() #part of characterbody3d class, moves char smoothly
