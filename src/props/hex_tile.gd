extends Spatial

onready var tile = $tile

var shader: Object = null

func _ready() -> void:
	shader = tile.get_active_material(0)

# When the user left clicks the area alert parent
func _on_Area_input_event(_camera, var event: InputEvent, _click_position, _click_normal, _shape_idx):
	if event is InputEventMouseButton:
		# Make sure left click is pressed
		if event.is_pressed() and event.button_index == 1:
			get_parent().clicked()

func _on_Area_mouse_entered():
	shader.set_shader_param("is_highlighted", true)

func _on_Area_mouse_exited():
	shader.set_shader_param("is_highlighted", false)
