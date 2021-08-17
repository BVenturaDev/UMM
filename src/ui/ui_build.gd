extends Control

const MAX_FOOD_MOVE: int = 10

onready var window = $build_popup
onready var food_amount_text = $build_popup/VBoxContainer/HBoxContainer2/food_amount
onready var cur_food_text = $build_popup/VBoxContainer/HBoxContainer/cur_food_label
onready var food_slider = $build_popup/VBoxContainer/HBoxContainer2/HSlider

var food_move_amount: int = 0
var tile_food: int = 0
var selected_tile: Object = null

func _ready() -> void:
	Globals.build_ui = self

func make_build_menu(var cur_food: int, var tile: Object) -> void:
	tile_food = cur_food
	cur_food_text.text = str(cur_food)
	if cur_food < MAX_FOOD_MOVE:
		food_slider.max_value = cur_food
	else:
		food_slider.max_value = MAX_FOOD_MOVE
	selected_tile = tile
	window.popup()

func _on_HSlider_value_changed(value):
	food_move_amount = int(value)
	food_amount_text.text = str(food_move_amount)

func _on_close_button_pressed():
	window.visible = false
	selected_tile = null
	food_move_amount = 0
	tile_food = 0
