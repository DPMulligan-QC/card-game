extends Control
class_name my_decks

var saved_decks:Array[deck_selector]
var cards_selected:Array[Card]
var selecting_to_play:bool = false


signal cancelled
signal selected
@onready var deck_list:Array[Control] = []
@onready var container:GridContainer = $Panel_Background/GridContainer



func repaint():
	if container!=null:
		for kiddo in container.get_children():
			container.remove_child(kiddo)
	for i in global_manager.deck_count():
		var subscene = load("res://scenes/deck_select_button.tscn")
		var new_button:deck_selector = subscene.instantiate()
		new_button.set_args(global_manager.get_deck_name(i),i,!selecting_to_play)
		#func set_args(_name:String, _index:int, _to_edit:bool):
		container.add_child(new_button)
		saved_decks.push_back(new_button)
		new_button.editor_closed.connect(repaint)
		new_button.select_this.connect(deck_selected.bind(new_button.index))
	
	var subscene = load("res://scenes/deck_select_button.tscn")
	var new_button:deck_selector = subscene.instantiate()
	new_button.set_args("",global_manager.deck_count(),false)
	new_button.select_this.connect(new_deck)
	container.add_child(new_button)
	saved_decks.push_front(new_button)
	new_button.editor_closed.connect(repaint)
	
	
func _ready() -> void:
	repaint()
	

func set_args(to_play:bool):
	selecting_to_play = to_play
	if selecting_to_play:
		pass
#	for i in global_manager.deck_count():
#		var subscene = load("res://scenes/deck_select_button.tscn")
#		var new_button:deck_selector = subscene.instantiate()
#		new_button.set_args(global_manager.get_deck_name(i),i,!selecting_to_play)
#		#func set_args(_name:String, _index:int, _to_edit:bool):
#		container.add_child(new_button)
#		saved_decks.push_back(new_button)
#		new_button.select_this.connect(deck_selected.bind(new_button.index))
	
#	var subscene = load("res://scenes/deck_select_button.tscn")
#	var new_button:deck_selector = subscene.instantiate()
#	new_button.set_args("",global_manager.deck_count(),false)
#	new_button.select_this.connect(new_deck)
#	container.add_child(new_button)Deck.new
#	saved_decks.push_front(new_button)

func _on_button_back_pressed() -> void:
	if selecting_to_play:
		cancelled.emit()
	else:	
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	

func new_deck():
	pass
#	var subscene = load("res://scenes/deckbuilding_cardlist.tscn")
#	var editor:deck_editor = subscene.instantiate() as deck_editor
#	editor.set_args("New Deck")
#	get_tree().root.add_child(editor)

func deck_selected(index:int):
	global_manager.chosen_deck = Deck.new()
	global_manager.chosen_deck.load_deck(cards_selected)
	selected.emit()
