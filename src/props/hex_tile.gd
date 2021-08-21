extends Spatial
class_name Hex
onready var tile = $tile

var shader: Object = null
var highlighted: bool = false

func _ready() -> void:
	shader = tile.get_active_material(0)

# When the user left clicks the area alert parent
func _on_Area_input_event(_camera, var event: InputEvent, _click_position, _click_normal, _shape_idx):
	if event is InputEventMouseButton:
		# Make sure left click is pressed
		if event.is_pressed() and event.button_index == 1:
			get_parent().clicked()

func _input(var event: InputEvent) -> void:
	if event.is_action_pressed("ui_click") and highlighted:
		get_parent().clicked()

func _on_Area_mouse_entered():
	if not Globals.moving_tile:
		highlighted = true
		enable_highlighted()

func _on_Area_mouse_exited():
	if not Globals.moving_tile:
		highlighted = false
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

func enable_enemy_undergrowth() -> void:
	shader.set_shader_param("is_enemy_undergrowth", true)
func disable_enemy_undergrowth() -> void:
	shader.set_shader_param("is_enemy_undergrowth", false)

func enable_grayed_out() -> void:
	disable_undergrowth()
	disable_highlighted()
	shader.set_shader_param("is_grayed_out", true)
func disable_grayed_out() -> void:
	shader.set_shader_param("is_grayed_out", false)

# --- Border Functions ---
# Enable N
func enable_b_d_l() -> void:
	shader.set_shader_param("b_b_d_l" , true)
func disable_b_d_l() -> void:
	shader.set_shader_param("b_b_d_l", false)
	
# Enable NO
func enable_b_d_r() -> void:
	shader.set_shader_param("b_b_d_r" , true)
func disable_b_d_r() -> void:
	shader.set_shader_param("b_b_d_r", false)
# Enable NE
func enable_b_l() -> void:
	shader.set_shader_param("b_b_l" , true)
func disable_b_l() -> void:
	shader.set_shader_param("b_b_l", false)

# Enable SO
func enable_b_r() -> void:
	shader.set_shader_param("b_b_r" , true)
func disable_b_r() -> void:
	shader.set_shader_param("b_b_r" , false)
	
# Eable SE
func enable_b_u_l() -> void:
	shader.set_shader_param("b_b_u_l" , true)
func disable_b_u_l() -> void:
	shader.set_shader_param("b_b_u_l", false)
# Enable S
func enable_b_u_r() -> void:
	shader.set_shader_param("b_b_u_r" , true)
func disable_b_u_r() -> void:
	shader.set_shader_param("b_b_u_r", false)
