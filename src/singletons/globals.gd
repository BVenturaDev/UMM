extends Node

# Constants
const DEBUG: bool = false
const DEBUG_SM: bool = false
# Game variables
const BUILD_MOBILE: bool = true
const BUILD_GATHER_COST = 5
const BUILD_POISON_COST = 5
const BUILD_SCOUT_COST = 5
# Map size - *** MUST BE EVEN ***
const PERCENTAGE_TILES_FOR_VICTORY := 75.0

const MAP_SIZE: int = 10
const MAX_FOOD_MOVE: int = 10

var main_menu: bool = false
var grid: Object
var player: Object
var ai: Object
var build_ui: Object
var rng = RandomNumberGenerator.new()
var moving_tile: Object = null
var game_over: bool = false
var options: bool = false

onready var victory_condition: int= (PERCENTAGE_TILES_FOR_VICTORY / 100) * pow(Globals.MAP_SIZE, 2)

func _ready() -> void:
	rng.seed = randi()
	rng.randomize()

func capture_mouse() -> void:
	if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func free_mouse() -> void:
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func check_winner(fungus: Fungus) -> void:
	if fungus.owned_tiles.size() >= victory_condition:
		GameSignals.emit_signal("game_finished_with_winner", fungus.my_owner)
