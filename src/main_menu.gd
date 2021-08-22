extends Spatial

onready var light = $WorldEnvironment/DirectionalLight
onready var options = $CanvasLayer/options_menu
onready var quit = $CanvasLayer/Menu_Options/VBoxContainer/quit_button
onready var credits = $CanvasLayer/Menu_Options/VBoxContainer/credits_button
onready var how_to = $CanvasLayer/Menu_Options/VBoxContainer/how_to_button
onready var how_to_panel = $CanvasLayer/how_to

var main_level = load("res://scenes/levels/main_level.tscn")
var zen_level = load("res://scenes/levels/zen_level.tscn")
var credits_level = load("res://scenes/ui/credits.tscn")

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


func _on_credits_button_pressed():
	var _a = get_tree().change_scene_to(credits_level)


func _on_how_to_button_pressed():
	how_to_panel.visible = true
