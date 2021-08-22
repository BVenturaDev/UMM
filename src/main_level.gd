extends Spatial

onready var light = $WorldEnvironment/DirectionalLight
onready var pause_menu = $CanvasLayer/pause_menu

func _ready():
	Globals.game_over = false
	if Globals.BUILD_MOBILE:
		light.hide()
	else:
		light.show()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		pause_menu.visible = true
