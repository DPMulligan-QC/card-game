extends Control

var cards:Array[Card]
func _ready() -> void:
	var card_inventory:Array[int] = global_manager.get_current_slot_cards()
	
	for i in card_inventory:
		cards.push_back(global_manager.build_card_from_id(i))
	#cardExample.populate_base(0)
	

func _on_button_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
