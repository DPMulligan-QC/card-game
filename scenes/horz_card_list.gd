extends Control
class_name horz_list


signal finished
signal canceled
@onready var cards:Array[Card] =[]
@onready var card_previews:Array[card_preview]=[]
@onready var container:HBoxContainer = $Panel_Background/ScrollContainer/HBoxContainer
@onready var accept_button:Button = $Panel_Background/Button_Accept
@onready var label:Label = $Panel_Background/Label
@onready var scroll_container:ScrollContainer = $Panel_Background/ScrollContainer

var selected_card_preview:card_preview
var selected_card:Card

var recruiting:bool
var from_standby:bool
var search_deck:bool
var copy:bool

func set_args(card_input:Array[Card], recruit:bool, from_stand:bool, selection_make:bool, searching_deck:bool, _copy:bool) -> void:
	recruiting = recruit
	copy=_copy
	from_standby=from_stand
	search_deck = searching_deck
	if recruiting:
		label.text = "SELECT A CARD."
	elif from_stand:
		label.text = "STANDBY ZONE.\nYOU MAY PAY 3CR TO SELECT A CARD AND RETURN IT TO YOUR HAND.\n"
	elif searching_deck:
		label.text = "SEARCHING DECK"
	elif copy:
		label.text = "COPY SELECTED CARD TO BOARD."
	else:
		label.text = "COLLECTION."
	
	for cardo in card_input:
		cards.push_front(cardo)
		var subscene = load("res://scenes/card_preview.tscn")
		var new_card:card_preview = subscene.instantiate()
		new_card.set_args(cardo,selection_make,self)
		container.add_child(new_card)
		card_previews.push_front(new_card)
	
	if !recruiting && !from_standby && !search_deck:
		accept_button.disabled = true
		accept_button.disabled = false

func deselect_all_previews():
	for cardo in card_previews:
		cardo.unpress()



func _on_button_back_pressed() -> void:
	canceled.emit()
	



func _on_button_accept_pressed() -> void:
	finished.emit()
