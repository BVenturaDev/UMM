extends Spatial

const FOOD_AMOUNT: int = 10

onready var model = $critter_model

func _ready() -> void:
	model.start_dead()
