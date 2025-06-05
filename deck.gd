extends Node
class_name Deck
@onready var cards:Array[Card] =[]

func set_args(card_input:Array[int]) -> void:
	for i in card_input:
		cards.push_back(global_manager.build_card_from_id(i))

func shuffle():
	cards.shuffle()
	
func load_deck(card_input:Array[Card]):
	cards = card_input

func recruit(size:int)->Array[Card]:
	var output:Array[Card] = []
	for i in size*2:
		if cards.size()>0:
			output.push_back(cards.pop_front())
	return output
