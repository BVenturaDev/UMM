extends Spatial

onready var light = $WorldEnvironment/DirectionalLight
onready var options = $CanvasLayer/options_menu
onready var quit = $CanvasLayer/Menu_Options/VBoxContainer/quit_button

var main_level = preload("res://scenes/levels/main_level.tscn")
var zen_level = preload("res://scenes/levels/zen_level.tscn")

func _ready():
	if Globals.BUILD_MOBILE:
		light.hide()
		quit.hide()
	else:
		light.show()
		quit.show()

func _on_Timer_timeout():
	GameSignals.emit_signal("next_turn")


func _on_options_button_pressed():
	options.visible = true

func _on_quit_button_pressed():
	get_tree().quit()


func _on_play_button_pressed():
	var _a = get_tree().change_scene_to(main_level)


func _on_zen_button_pressed():
	var _a = get_tree().change_scene_to(zen_level)
