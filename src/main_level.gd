extends Spatial

onready var light = $WorldEnvironment/DirectionalLight
onready var pause_menu = $CanvasLayer/pause_menu
onready var left_control = $left_mobile_joystick
onready var right_control = $right_mobile_joystick

func _ready():
	Globals.options = false
	Globals.game_over = false
	Globals.moving_tile = null
	if Globals.BUILD_MOBILE:
		left_control.cont.visible = true
		right_control.cont.visible = true
		Globals.left_mobile_control = left_control
		Globals.right_mobile_control = right_control

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		_toggle_pause()

func _toggle_pause() -> void:
	if pause_menu.visible == false:
		pause_menu.visible = true
		pause_menu.options.visible = false
		pause_menu.menu.visible = true
		Globals.options = true
	else:
		pause_menu.visible = false
		Globals.options = false

func _on_menu_butt_pressed() -> void:
	_toggle_pause()
