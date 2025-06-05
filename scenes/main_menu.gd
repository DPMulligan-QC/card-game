extends Control
@onready var title_text:Label = $Panel_Background/Label

@onready var subscene
@onready var card_scene:card_object
var cards:Array[Card]

func _ready() -> void:
	var card_inventory:Array[int] = global_manager.get_current_slot_cards()
	
	for i in card_inventory:
		cards.push_back(global_manager.build_card_from_id(i))
	#cardExample.populate_base(0)



func _on_button_quit_pressed() -> void:
	title_text.text = "no escape lol"


func _on_button_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/settings.tscn")




func _on_button_deck_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/card_collection.tscn")




func _on_button_play_pressed() -> void:
	#global_manager.give_current_slot_full_collection()
	#global_manager.save_current_slot()
	get_tree().change_scene_to_file("res://scenes/diddle_mode_selection.tscn")
#	var card_inventory:Array[int] = global_manager.get_current_slot_cards()
#	
#	for i in card_inventory:
#		cards.push_back(global_manager.build_card_from_id(i))

#	cards.shuffle()

#	subscene = load("res://scenes/card_mockup.tscn")
#	card_scene = subscene.instantiate()
#	get_tree().root.add_child(card_scene)
#	card_scene.set_args(cards.pop_back())
	
	
	
