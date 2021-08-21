extends Control

onready var window = $build_popup
onready var food_amount_text = $build_popup/VBoxContainer/HBoxContainer2/food_amount
onready var cur_food_text = $build_popup/VBoxContainer/HBoxContainer/cur_food_label
onready var cur_attack_food_text = $build_popup/VBoxContainer/HBoxContainer3/attack_food_amount
onready var food_slider = $build_popup/VBoxContainer/HBoxContainer2/HSlider
onready var attack_slider = $build_popup/VBoxContainer/HBoxContainer3/HSlider2
onready var kill_shroom = $build_popup/VBoxContainer/kill_shroom
onready var gather_shroom = $build_popup/VBoxContainer/gather_shroom_button
onready var poison_shroom = $build_popup/VBoxContainer/poison_shroom
onready var scout_shroom = $build_popup/VBoxContainer/scout_shroom
onready var slider_cont = $build_popup/VBoxContainer/HBoxContainer2
onready var move_food_butt = $build_popup/VBoxContainer/move_food_button
onready var attack_cont = $build_popup/VBoxContainer/HBoxContainer3
onready var attack_butt = $build_popup/VBoxContainer/attack_button

var food_move_amount: int = 0
var food_attack_amount: int = 0
var tile_food: int = 0
var selected_tile: Tile = null

func _ready() -> void:
	Globals.build_ui = self

func make_build_menu(var cur_food: int, var tile: Tile) -> void:
	if Globals.DEBUG and tile.cur_shroom:
		kill_shroom.visible = true
	else:
		kill_shroom.visible = false
		
	if tile.cur_resource and cur_food > Globals.BUILD_GATHER_COST and not tile.cur_shroom and not tile.critter:
		gather_shroom.visible = true
	else:
		gather_shroom.visible = false
		
	if cur_food > Globals.BUILD_POISON_COST and not tile.cur_shroom and not tile.critter:
		poison_shroom.visible = true
		if tile.enemies.size() > 0:
			scout_shroom.visible = true
		else:
			scout_shroom.visible = false
	else:
		poison_shroom.visible = false
		scout_shroom.visible = false
		
	if tile.food_amount > 1:
		slider_cont.visible = true
		move_food_butt.visible = true
		if cur_food > Globals.BUILD_SCOUT_COST and tile.enemies.size() > 0:
			attack_cont.visible = true
			attack_butt.visible = true
		else:
			attack_cont.visible = false
			attack_butt.visible = false
	else:
		slider_cont.visible = false
		move_food_butt.visible = false
		attack_cont.visible = false
		attack_butt.visible = false
		
	tile_food = cur_food
	
	cur_food_text.text = str(tile.food_amount)
	if tile.food_amount <= Globals.MAX_FOOD_MOVE:
		food_slider.max_value = tile.food_amount - 1
		food_slider.value = tile.food_amount - 1
		attack_slider.max_value = tile.food_amount - 1
		attack_slider.value = tile.food_amount - 1

	else:
		food_slider.max_value = Globals.MAX_FOOD_MOVE
		food_slider.value = Globals.MAX_FOOD_MOVE
		attack_slider.max_value = Globals.MAX_FOOD_MOVE
		attack_slider.value = Globals.MAX_FOOD_MOVE
	selected_tile = tile
	window.popup()

func _on_HSlider_value_changed(value):
	food_move_amount = int(value)
	food_amount_text.text = str(food_move_amount)

func _on_HSlider2_value_changed(value):
	food_attack_amount = int(value)
	cur_attack_food_text.text = str(food_attack_amount)

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

func _on_attack_button_pressed():
	if selected_tile:
		var amount: int = int(attack_slider.value)
		selected_tile.attack(amount)

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
	_close_menu()


func _on_RequestFood_pressed() -> void:
	if selected_tile:
		selected_tile.region_food_request(
			selected_tile.region_neighbors,
			5)
