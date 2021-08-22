extends Spatial

onready var light = $WorldEnvironment/DirectionalLight
onready var pause_menu = $CanvasLayer/pause_menu

func _ready():
	Globals.options = false
	Globals.game_over = false
	if Globals.BUILD_MOBILE:
		light.hide()
	else:
		light.show()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if pause_menu.visible == false:
			pause_menu.visible = true
			Globals.options = true
		else:
			pause_menu.visible = false
			Globals.options = false
