extends Spatial

onready var light = $WorldEnvironment/DirectionalLight

func _ready():
	if Globals.BUILD_MOBILE:
		light.hide()
	else:
		light.show()

func _on_Timer_timeout():
	GameSignals.emit_signal("next_turn")
