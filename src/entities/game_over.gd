extends CanvasLayer

var win = preload("res://scenes/ui/win_screen.tscn")
var lose = preload("res://scenes/ui/lose_screen.tscn")

func _ready() -> void:
	var _a = GameSignals.connect("game_finished_with_winner", self, "_game_over")

func _game_over(var winner) -> void:
	Globals.game_over = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	var new_ui
	if winner.name == "player":
		new_ui = win.instance()
	else:
		new_ui = lose.instance()
	add_child(new_ui)