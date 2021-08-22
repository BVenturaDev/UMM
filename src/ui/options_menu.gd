extends MarginContainer

onready var cam_slider = $MarginContainer/HotkeysContainer/SettingsContainer/CamRotContainer/CamSlider
onready var stick_slider = $MarginContainer/HotkeysContainer/SettingsContainer/StickContainer/StickSlider
onready var lights_check = $MarginContainer/HotkeysContainer/SettingsContainer/LightChecksContainer/LightsContainer/LightsCheckBox
onready var shadows_check = $MarginContainer/HotkeysContainer/SettingsContainer/LightChecksContainer/ShadowContainer/ShadowsCheckBox

func _ready():
	cam_slider.value = Globals.rot_speed
	stick_slider.value = Globals.stick_speed
	lights_check.pressed = Globals.lights
	shadows_check.pressed = Globals.shadows

func _on_Back_Button_pressed():
	self.visible = false
	Globals.options = false
	if get_parent().name == "pause_menu":
		get_parent().get_child(1).visible = true

func _on_ShadowsCheckBox_toggled(button_pressed):
	Globals.shadows = button_pressed

func _on_LightsCheckBox_toggled(button_pressed):
	Globals.lights = button_pressed


func _on_CamSlider_value_changed(value):
	Globals.rot_speed = value

func _on_StickSlider_value_changed(value):
	Globals.stick_speed = value
