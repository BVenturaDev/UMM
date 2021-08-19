extends Control

const MAX_FOOD_MOVE: int = 10

onready var window = $build_popup
onready var food_amount_text = $build_popup/VBoxContainer/HBoxContainer2/food_amount
onready var cur_food_text = $build_popup/VBoxContainer/HBoxContainer/cur_food_label
onready var food_slider = $build_popup/VBoxContainer/HBoxContainer2/HSlider
onready var kill_shroom = $build_popup/VBoxContainer/kill_shroom
onready var gather_shroom = $build_popup/VBoxContainer/gather_shroom_button
onready var poison_shroom = $build_popup/VBoxContainer/poison_shroom
onready var scout_shroom = $build_popup/VBoxContainer/scout_shroom
onready var slider_cont = $build_popup/VBoxContainer/HBoxContainer2
onready var move_food_butt = $build_popup/VBoxContainer/move_food_button

var food_move_amount: int = 0
var tile_food: int = 0
var selected_tile: Object = null

func _ready() -> void:
	Globals.build_ui = self

func make_build_menu(var cur_food: int, var tile: Object) -> void:
	if Globals.DEBUG and tile.cur_shroom:
		kill_shroom.visible = true
	else:
		kill_shroom.visible = false
		
	if tile.cur_resource and cur_food > 5 and not tile.cur_shroom:
		gather_shroom.visible = true
	else:
		gather_shroom.visible = false
		
	if cur_food > 5 and not tile.cur_shroom:
		poison_shroom.visible = true
		scout_shroom.visible = true
	else:
		poison_shroom.visible = false
		scout_shroom.visible = false
		
	if cur_food < 2:
		slider_cont.visible = false
		move_food_butt.visible = false
	else:
		slider_cont.visible = true
		move_food_butt.visible = true
		
	tile_food = cur_food
	cur_food_text.text = str(cur_food)
	if cur_food < MAX_FOOD_MOVE:
		food_slider.max_value = cur_food - 1
		food_slider.value = cur_food - 1
	else:
		food_slider.max_value = MAX_FOOD_MOVE
		food_slider.value = MAX_FOOD_MOVE
	selected_tile = tile
	window.popup()

func _on_HSlider_value_changed(value):
	food_move_amount = int(value)
	food_amount_text.text = str(food_move_amount)

func _on_close_button_pressed():
	_close_menu()

func _close_menu() -> void:
	window.visible = false
	selected_tile = null
	food_move_amount = 0
	tile_food = 0
	
func _on_gather_shroom_button_pressed():
	if selected_tile:
		selected_tile.build_gather_shroom()
	_close_menu()

func _on_move_food_button_pressed():
	if selected_tile:
		var amount: int = int(food_slider.value)
		selected_tile.move_food(amount)
	_close_menu()

func _on_poison_shroom_pressed():
	if selected_tile:
		selected_tile.build_poison_shroom()
	_close_menu()

func _on_scout_shroom_pressed():
	if selected_tile:
		selected_tile.build_scout_shroom()
	_close_menu()

func _on_kill_shroom_pressed():
	if selected_tile:
		if selected_tile.cur_shroom:
			selected_tile.cur_shroom.kill()
