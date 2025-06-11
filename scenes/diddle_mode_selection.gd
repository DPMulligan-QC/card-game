extends Control


func _on_button_draft_pressed() -> void:
	global_manager.drafting = true
	get_tree().change_scene_to_file("res://scenes/game_board.tscn")
	

func _on_button_constructed_pressed() -> void:
	global_manager.drafting = false
	var subscene = load("res://scenes/card_collection.tscn")
	var collection_instance:my_decks= subscene.instantiate() as my_decks
	collection_instance.set_args(true)
	get_tree().root.add_child(collection_instance)
	collection_instance.cancelled.connect(constructed_cancelled.bind(collection_instance))
	collection_instance.selected.connect(on_deck_selected.bind(collection_instance, collection_instance.cards_selected))
	
	

func constructed_cancelled(coll:my_decks):
	if coll:
		get_tree().root.remove_child(coll)
	
func on_deck_selected(coll:my_decks,deck_got:Array[Card]):
	global_manager.chosen_deck = Deck.new()
	global_manager.chosen_deck.load_deck(deck_got)
	if coll:
		get_tree().root.remove_child(coll)
	get_tree().change_scene_to_file("res://scenes/game_board.tscn")

func _on_button_back_pressed() -> void:
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
