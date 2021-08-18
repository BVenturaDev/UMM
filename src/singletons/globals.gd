extends Node

# Constants
const DEBUG: bool = true
const DEBUG_SM: bool = false
# Map size - *** MUST BE EVEN ***
const MAP_SIZE: int = 26

var grid: Object
var build_ui: Object
var rng = RandomNumberGenerator.new()
var moving_tile: Object = null

func _ready() -> void:
	rng.seed = randi()
	rng.randomize()

func capture_mouse() -> void:
	if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func free_mouse() -> void:
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
