extends Control

var main = load("res://scenes/levels/main_menu.tscn")


func _on_Button_pressed():
	var _a = get_tree().change_scene_to(main)
