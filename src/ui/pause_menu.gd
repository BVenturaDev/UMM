extends Control

onready var options = $options_menu
onready var menu = $Menu_Options

var main_menu = load("res://scenes/levels/main_menu.tscn")

func _on_options_button_pressed():
	menu.visible = false
	options.visible = true

func _on_quit_button_pressed():
	get_tree().quit()

func _on_resume_button_pressed():
	visible = false

func _on_main_menu_button_pressed():
	var _a = get_tree().change_scene_to(main_menu)

func _on_restart_button_pressed():
	var _a = get_tree().reload_current_scene()
