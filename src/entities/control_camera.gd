extends Camera

const MAX_SPEED: float = 10.0
const ZOOM_SPEED: float = 7.5
const ROT_SPEED: float = 0.09
const CAM_Y_MIN: float = 2.0
const CAM_Y_MAX: float = 20.0

var can_rot = false

func _process(var delta: float) -> void:
	# Get movement inputs
	var in_dir: Vector2 = Vector2()
	in_dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	in_dir.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	# Apply horizontal movement
	var dir: Vector3 = Vector3()
	dir += transform.basis.x * in_dir.x
	dir += transform.basis.z * in_dir.y
	dir = dir.normalized()
	var h_vel: Vector3 = dir * MAX_SPEED * delta
	transform.origin += h_vel
	
	# Apply zoom
	if Input.is_action_just_released("ui_zoom_in") or Input.is_action_pressed("ui_zoom_in"):
		transform.origin.y -= ZOOM_SPEED * delta
	elif Input.is_action_just_released("ui_zoom_out")or Input.is_action_pressed("ui_zoom_out"):
		transform.origin.y += ZOOM_SPEED * delta
		
	# Keep camera in range
	if transform.origin.y < CAM_Y_MIN:
		transform.origin.y = CAM_Y_MIN
	elif transform.origin.y > CAM_Y_MAX:
		transform.origin.y = CAM_Y_MAX
		
	# Camera Rotation
	if Input.is_action_pressed("ui_right_click"):
		# Capture the mouse for rotation
		Globals.capture_mouse()
		can_rot = true
	else:
		can_rot = false
		Globals.free_mouse()
		
func _input(var event: InputEvent) -> void:
	if event is InputEventMouseMotion and can_rot:
		# Calculate camera rotation
		rotate_y(deg2rad(-event.relative.x * ROT_SPEED))
		rotate_x(deg2rad(-event.relative.y * ROT_SPEED))
		# Keep camera from looking too far up or upside down
		rotation.x = clamp(rotation.x, deg2rad(-90.0), deg2rad(45.0))
		# Stop camera tilt
		rotation.z = 0
