extends CharacterBody3D

const MAX_SPEED = 30.0
const ACCELERATION = 30.0
const FRICTION = 4.0
const ROTATION_SPEED = 3.0

func _physics_process(delta):
	# Get input direction
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if input_dir.length() > 0:
		# Calculate desired direction based on input
		var target_dir = Vector3(input_dir.x, 0, input_dir.y).normalized()
		
		# Accelerate towards the target direction
		velocity.x = move_toward(velocity.x, target_dir.x * MAX_SPEED, ACCELERATION * delta)
		velocity.z = move_toward(velocity.z, target_dir.z * MAX_SPEED, ACCELERATION * delta)

		# Rotate smoothly towards the input direction
		if target_dir.length() > 0:
			var target_rotation = target_dir.signed_angle_to(Vector3.FORWARD, Vector3.UP)
			rotation.y = lerp_angle(rotation.y, target_rotation, ROTATION_SPEED * delta)
	else:
		# Apply friction when there's no input
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		velocity.z = move_toward(velocity.z, 0, FRICTION * delta)

	# Apply movement
	move_and_slide()
