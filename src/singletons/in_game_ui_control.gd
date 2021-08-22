extends Node

var tactica_ui: Control
var turn_options: Control

func _process(_delta: float) -> void:
	if is_instance_valid(tactica_ui) and is_instance_valid(turn_options):
		if tactica_ui.visible == true:
			turn_options.visible = false
		else:
			turn_options.visible = true
