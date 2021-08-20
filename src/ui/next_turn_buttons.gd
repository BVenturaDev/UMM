extends VBoxContainer

onready var next_20 = $next_turn_20
onready var spawn = $spawn_critter

func _process(_delta) -> void:
	if Globals.DEBUG:
		next_20.visible = true
		spawn.visible = true
	else:
		next_20.visible = false
		spawn.visible = false
