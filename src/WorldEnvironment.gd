extends WorldEnvironment

func _process(_delta):
	if Globals.lights:
		environment.ambient_light_energy = 2.0
	else:
		environment.ambient_light_energy = 4.0
