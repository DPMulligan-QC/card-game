extends Control
class_name deck_selector
@onready var button:Button = $Button
var deck_name:String = "NEW DECK"
var index:int
var new_deck_button:bool = true
var to_edit:bool = false

signal select_this
signal editor_closed
func set_args(_name:String, _index:int, _to_edit:bool):
	to_edit = _to_edit
	if _name!="":
		deck_name = _name
		new_deck_button = false
		index = _index
	else:
		index=-1
	



func _on_button_pressed() -> void:
	if new_deck_button:
		var subscene = load("res://scenes/deckbuilding_cardlist.tscn")
		var editor:deck_editor = subscene.instantiate() as deck_editor
		editor.deck_name="New Deck"
		editor.exit.connect(_on_editor_closed.bind(editor))
		get_tree().root.add_child(editor)
	elif to_edit:
		var subscene = load("res://scenes/deckbuilding_cardlist.tscn")
		var editor:deck_editor = subscene.instantiate() as deck_editor
		editor.set_args(deck_name)
		editor.exit.connect(_on_editor_closed.bind(editor))
		get_tree().root.add_child(editor)
	else:
		select_this.emit()
		var deck:Deck = Deck.new()
		deck.load_deck(global_manager.get_card_array_from_name(deck_name))
		deck.shuffle()
		global_manager.chosen_deck = deck
		

func _on_editor_closed(editor:deck_editor):
	editor_closed.emit()
	editor.queue_free()
	#get_tree().root.remove_child(editor)
	
	
func _ready() -> void:
	button.text = deck_name
