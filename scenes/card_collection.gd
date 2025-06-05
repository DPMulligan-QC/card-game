extends Control
class_name my_decks

var cards_selected:Array[Card]
var selecting_to_play:bool = false
signal cancelled
signal selected
@onready var deck_list:Array[Control] = []

func _ready() -> void:
	pass
	#cardExample.populate_base(0)
	

func set_args(to_play:bool):
	selecting_to_play = to_play

func _on_button_back_pressed() -> void:
	if selecting_to_play:
		cancelled.emit()
	else:	
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	

func build_collection_buttons():
	pass
