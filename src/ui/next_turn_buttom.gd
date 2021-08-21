extends TextureButton

func _ready() -> void:
# warning-ignore:return_value_discarded
	GameSignals.connect("enter_player_turn", self, "_enable_button")
# warning-ignore:return_value_discarded
	GameSignals.connect("exit_player_turn", self, "_disable_button")

func _enable_button():
	self.disabled = false

func _disable_button():
	self.disabled = true

func _on_next_turn_buttom_pressed() -> void:
	GameSignals.emit_signal("next_turn")
	if not Globals.game_over:
		if Globals.moving_tile:
			Globals.moving_tile.stop_move_food()
