extends VBoxContainer

onready var next_turn = $HBoxContainer/next_turn_button
onready var next_20 = $next_turn_20
onready var spawn = $spawn_critter
onready var turn_lable = $HBoxContainer/TurnLabel

func _process(_delta) -> void:
	if Globals.player and turn_lable:
		turn_lable.text = str(Globals.player.num_turns - 1)
	if Globals.DEBUG:
		next_20.visible = true
		spawn.visible = true
	else:
		next_20.visible = false
		spawn.visible = false


func _on_First_Turn_timeout():
	next_turn.emit_signal("pressed")
