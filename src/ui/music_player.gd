extends Node

onready var fun_guy = $fun_guy
onready var sunny_hills = $sunny_hills

func _ready() -> void:
	var _a = fun_guy.connect("finished", self, "_finished_fun_guy")
	_a = sunny_hills.connect("finished", self, "_finished_sunny_hills")
	_pick_rand_song()

func _finished_fun_guy() -> void:
	_pick_rand_song()
	
func _finished_sunny_hills() -> void:
	_pick_rand_song()

func _pick_rand_song() -> void:
	if Globals.rng:
		var num: int = Globals.rng.randi_range(0, 1)
		if num == 0:
			fun_guy.play()
		else:
			sunny_hills.play()
	else:
		sunny_hills.play()
