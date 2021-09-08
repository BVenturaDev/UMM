extends CanvasLayer

onready var touch := $Control/TouchScreenButton
onready var paddle := $paddle
onready var cont := $Control

var dir: Vector2 = Vector2()
var texture_center: Vector2 = Vector2()
var is_pressed: bool = false

func _ready() -> void:
	if not Globals.BUILD_MOBILE:
		cont.visible = false
	else:
		texture_center = cont.rect_position + Vector2(64, 64)

func _input(event) -> void:
	if event is InputEventScreenTouch or event is InputEventScreenDrag and cont.visible:
		if touch.is_pressed():
			is_pressed = true
			dir = calculate_move_vector(event.position)
			limit_paddle(event.position)
	
	if event is InputEventScreenTouch:
		if not event.pressed:
			is_pressed = false
			paddle.visible = false
			dir = Vector2()

func calculate_move_vector(event_position) -> Vector2:
	# Get the distance from center of joystick and return a normalized vector (-1.0 - 1.0)
	return (event_position - texture_center).normalized()
	
func limit_paddle(event_position) -> void:
	var limit: int = 64
	if texture_center.distance_to(event_position) > limit:
		var limit_vector = dir * limit
		paddle.position = texture_center + limit_vector
	else:
		paddle.position = event_position
	paddle.visible = true
