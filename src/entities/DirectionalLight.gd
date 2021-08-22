extends DirectionalLight

func _process(_delta):
	visible = Globals.lights
	shadow_enabled = Globals.shadows
		
