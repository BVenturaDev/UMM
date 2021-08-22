extends CanvasLayer

onready var pause = $pause_menu
onready var snd_win = $win_sound
onready var snd_lose = $lose_sound

var win = preload("res://scenes/ui/win_screen.tscn")
var lose = preload("res://scenes/ui/lose_screen.tscn")

func _ready() -> void:
	var _a = GameSignals.connect("game_finished_with_winner", self, "_game_over")

func _game_over(var winner) -> void:
	pause.show()
	Globals.game_over = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	var new_ui
	if winner.name == "player":
		snd_win.play()
		new_ui = win.instance()
	else:
		snd_lose.play()
		new_ui = lose.instance()
	add_child(new_ui)


func _on_tactical_ui_tactical_menu_hided() -> void:
	$next_turn_buttons.show()


func _on_tactical_ui_tactical_menu_showed() -> void:
	$next_turn_buttons.hide()
