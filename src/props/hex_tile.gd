extends Spatial

"""
TO BE ADDED
func _on_Area_mouse_entered():
	pass # Show Mouse Hover Graphically

func _on_Area_mouse_exited():
	pass # Remove Mouse Hover Graphic
"""

# When the user left clicks the area alert parent
func _on_Area_input_event(_camera, var event: InputEvent, _click_position, _click_normal, _shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			get_parent().clicked()
