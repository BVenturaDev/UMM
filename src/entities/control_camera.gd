extends Camera

const MAX_SPEED: float = 10.0
const ZOOM_SPEED: float = 7.5
const CAM_Y_MIN: float = 3.0
const CAM_Y_MAX: float = 8.0
const CAM_X_MIN: float = 1.0
const CAM_Z_MIN: float = 1.0
const ROT_AMOUNT: float = 0.035
const MAX_ANGLE: float = -60.0
const MIN_ANGLE: float = -40.0
const DEF_X_ANGLE: float = -50.0
const MAX_Y_ANGLE: float = 50.0
const MIN_Y_ANGLE: float = -50.0

var can_rot = false
var last_mouse: Vector2 = Vector2()

func _process(var delta: float) -> void:
	var stick_dir: Vector2 = Vector2()
	stick_dir.x = Input.get_action_strength("stick_right") - Input.get_action_strength("stick_left")
	stick_dir.y = Input.get_action_strength("stick_back") - Input.get_action_strength("stick_forward")
	stick_dir = stick_dir.normalized()
	var stick_mouse_move = Globals.stick_speed * stick_dir * delta
	if stick_mouse_move:
		get_viewport().warp_mouse(get_viewport().get_mouse_position() + stick_mouse_move)
		
	if not Globals.game_over and not Globals.options:
		if not can_rot:
			last_mouse = get_viewport().get_mouse_position()
		# Get movement inputs
		var in_dir: Vector2 = Vector2()
		in_dir.x = Input.get_action_strength("cam_right") - Input.get_action_strength("cam_left")
		in_dir.y = Input.get_action_strength("cam_backward") - Input.get_action_strength("cam_forward")
		in_dir = in_dir.normalized()
		
		var h_vel: Vector2 = in_dir * MAX_SPEED * delta
		if Globals.left_mobile_control:
			if not Globals.left_mobile_control.dir == Vector2():
				h_vel = Globals.left_mobile_control.dir * MAX_SPEED * delta
		
		transform.origin.x += h_vel.x
		transform.origin.z += h_vel.y
		
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
		
		if transform.origin.x < CAM_X_MIN:
			transform.origin.x = CAM_X_MIN	
		if transform.origin.z < CAM_Z_MIN:
			transform.origin.z = CAM_Z_MIN
		if Globals.grid:
			var max_x: float = (Globals.MAP_SIZE - 1) * Globals.grid.X_OFFSET
			if transform.origin.x > max_x:
				transform.origin.x = max_x
			var max_z: float = (Globals.MAP_SIZE) * Globals.grid.Z_OFFSET
			if transform.origin.z > max_z:
				transform.origin.z = max_z
		
		if Globals.right_mobile_control:
			if Globals.right_mobile_control.is_pressed:
				can_rot = true
				_do_cam_rot(Globals.right_mobile_control.dir * -20.0)
			else:
				_reset_rot()
		# Camera Rotation
		elif Input.is_action_pressed("ui_right_click"):
			# Capture the mouse for rotation
			Globals.capture_mouse()
			can_rot = true
			if not stick_mouse_move == Vector2():
				_do_cam_rot(stick_mouse_move * -2.0)
		else:
			_reset_rot()
		if Input.is_action_just_released("ui_right_click"):
			get_viewport().warp_mouse(last_mouse)

func _reset_rot() -> void:
	can_rot = false
	rotation.y = lerp(rotation.y, 0, ROT_AMOUNT)
	rotation.x = lerp(rotation.x, deg2rad(DEF_X_ANGLE), ROT_AMOUNT)
	Globals.free_mouse()
	
func _input(var event: InputEvent) -> void:
	if event is InputEventMouseMotion and can_rot and not Globals.game_over:
		_do_cam_rot(Vector2(-event.relative.x, -event.relative.y))

func _do_cam_rot(var vec: Vector2) -> void:
	# Calculate camera rotation
	rotate_y(deg2rad(vec.x * Globals.rot_speed))
	rotate_object_local(Vector3(1.0, 0, 0),  deg2rad(vec.y * Globals.rot_speed))
	# Keep camera from looking too far up or upside down
	if rotation.x < deg2rad(MAX_ANGLE):
		rotation.x = deg2rad(MAX_ANGLE)
	elif rotation.x > deg2rad(MIN_ANGLE):
		rotation.x = deg2rad(MIN_ANGLE)
	# Keep camera from looking too far left / right
	if rotation.y < deg2rad(MIN_Y_ANGLE):
		rotation.y = deg2rad(MIN_Y_ANGLE)
	elif rotation.y > deg2rad(MAX_Y_ANGLE):
		rotation.y = deg2rad(MAX_Y_ANGLE)
	# Stop camera tilt
	rotation.z = 0
