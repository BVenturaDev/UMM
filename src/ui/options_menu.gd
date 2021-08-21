extends MarginContainer

func _on_Back_Button_pressed():
	self.visible = false
	if get_parent().name == "pause_menu":
		get_parent().get_child(1).visible = true
