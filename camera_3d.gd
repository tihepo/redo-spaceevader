extends Camera3D

@export var target: CharacterBody3D
@export var base_follow_speed: float = 0.15  # Base speed of following
@export var offset: Vector3 = Vector3(0, 15, 0)  # Camera offset from the player
@export var distance_factor: float = 2.0  # How much the speed increases with distance
@export var overshoot_factor: float = 0.75  # Overshoot, to look further in the direction the player travels

func _process(delta: float) -> void:
	if target:
		# Desired position based on the target's position plus the offset
		var target_position = target.global_transform.origin + offset
		
		target_position += target.velocity * overshoot_factor

		# Calculate the distance between the camera and the target position
		var distance_to_target = global_transform.origin.distance_to(target_position)

		# Adjust the speed based on the distance to the target
		var adjusted_speed = base_follow_speed + (distance_to_target * distance_factor)
		
		# Smoothly move the camera towards the target position, with adjusted speed
		global_transform.origin = global_transform.origin.move_toward(target_position, adjusted_speed * delta)


func _ready():
	_on_size_changed()
	get_tree().get_root().size_changed.connect(_on_size_changed)

func _on_size_changed():
	# Make sure the camera always fit the viewport rect, both in very wide and very tall views
	var window_size = get_viewport().size
	var aspect_ratio = float(window_size.x) / window_size.y

	# Decide which one to keep based on the window size
	if aspect_ratio > 1:
		# Wider window, keep height and adjust width
		self.keep_aspect = Camera3D.KEEP_HEIGHT
	else:
		# Taller window, keep width and adjust height
		self.keep_aspect = Camera3D.KEEP_WIDTH
