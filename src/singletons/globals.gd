extends Node

# Constants
const DEBUG: bool = true
# Map size - *** MUST BE EVEN ***
const MAP_SIZE: int = 26

var grid: Object = null
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()

func capture_mouse() -> void:
	if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
func free_mouse() -> void:
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
