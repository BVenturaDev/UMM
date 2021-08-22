extends HSlider

export(String) var bus_name = "Master"
# This path can link to an AudioStreamPlayer node to play after the volume has changed. 
# For a music volume slider it should not be used (music should be playing while in the menu), 
# but for a sounds volume slider it helps the user adjust to the right volume. 
func _ready():
	if Globals.volume:
		value = Globals.volume

func _on_VolumeSlider_value_changed(value: float) -> void:
	Globals.volume = value

