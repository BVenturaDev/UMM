extends Spatial

func _ready() -> void:
	assert(GameSignals.connect("enter_nature_turn", self, "_do_turn") == 0)

func _do_turn():
	print("It's my turn")
