extends Spatial

onready var tile = $tile
#onready var tile2 = $tile.get_surface_material(0).next_pass

var shader: Object = null
var shader2: Object = null

func _ready() -> void:
	shader = tile.get_active_material(0)
#	shader2 = tile.get_active_material(0).shader.get("next_pass")
	shader2 = tile.get_surface_material(0).next_pass

# When the user left clicks the area alert parent
func _on_Area_input_event(_camera, var event: InputEvent, _click_position, _click_normal, _shape_idx):
	if event is InputEventMouseButton:
		# Make sure left click is pressed
		if event.is_pressed() and event.button_index == 1:
			get_parent().clicked()
			enable_grayed_out()

func _on_Area_mouse_entered():
	if not Globals.moving_tile:
		shader.set_shader_param("is_highlighted", true)

func _on_Area_mouse_exited():
	if not Globals.moving_tile:
		shader.set_shader_param("is_highlighted", false)
		disable_grayed_out()

func enable_grayed_out() -> void:
	shader2.set_shader_param("is_selected", true)
#	tile2.set_shader_param("is_selected", true)

func disable_grayed_out() -> void:
	shader2.set_shader_param("is_selected", false)
#	tile2.set_shader_param("is_selected", false)
