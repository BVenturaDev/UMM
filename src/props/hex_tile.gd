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
	if not Globals.moving_tile:
		enable_highlighted()

func _on_Area_mouse_exited():
	if not Globals.moving_tile:
		disable_highlighted()
		
func enable_highlighted() -> void:
	shader.set_shader_param("is_highlighted", true)
	
func disable_highlighted() -> void:
	shader.set_shader_param("is_highlighted", false)
	
func enable_turn_used() -> void:
	disable_highlighted()
	disable_undergrowth()
	shader.set_shader_param("is_turn_used", true)

func disable_turn_used() -> void:
	shader.set_shader_param("is_turn_used", false)
	
func enable_undergrowth() -> void:
	shader.set_shader_param("is_undergrowth", true)

func disable_undergrowth() -> void:
	shader.set_shader_param("is_undergrowth", false)
	
func enable_grayed_out() -> void:
	disable_undergrowth()
	disable_highlighted()
	shader.set_shader_param("is_grayed_out", true)
	
func disable_grayed_out() -> void:
	shader.set_shader_param("is_grayed_out", false)
