extends Spatial

# When the user left clicks the area alert parent
func _on_Area_input_event(_camera, var event: InputEvent, _click_position, _click_normal, _shape_idx):
	if event is InputEventMouseButton:
		# Make sure left click is pressed
		if event.is_pressed() and event.button_index == 1:
			get_parent().clicked()

func _on_Area_mouse_entered():
	pass # Replace with function body.

func _on_Area_mouse_exited():
	pass # Replace with function body.
