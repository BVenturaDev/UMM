extends Control

onready var options = $options_menu
onready var menu = $Menu_Options
onready var quit = $Menu_Options/VBoxContainer/quit_button
onready var resume = $Menu_Options/VBoxContainer/resume_button

var main_menu = load("res://scenes/levels/main_menu.tscn")

func _ready():
	if Globals.BUILD_MOBILE:
		quit.hide()
	else:
		quit.show()

func _process(_delta):
	if Globals.game_over:
		resume.hide()
	else:
		resume.show()

func _on_options_button_pressed():
	menu.visible = false
	options.visible = true

func _on_quit_button_pressed():
	get_tree().quit()

func _on_resume_button_pressed():
	visible = false
	Globals.options = false

func _on_main_menu_button_pressed():
	var _a = get_tree().change_scene_to(main_menu)

func _on_restart_button_pressed():
	var _a = get_tree().reload_current_scene()
