extends Node


var gmPath = load("res://GlobalManager.cs")
var gm = gmPath.new()

var card_count:int = gm.GetCardCount()
var current_slot:int
var drafting:bool = true
var chosen_deck:Deck
var credits:int
var life:int

func build_card_from_id(id:int)->Card:
	var output:Card = Card.new()
	output.populate_base(id)
	return output

func is_valid_slot(slotNum:int)->bool:
	return gm.DoesSlotExist(slotNum)
	
func set_slot_name(newName:String, slotNum:int):
	gm.SetName(newName, slotNum)
	
func get_slot_name(slotNum:int)->String:
	return gm.GetName(slotNum)
	

func load_slots():
	gm.RefreshSlots()

func save_player_slot(slot:int):
	gm.SaveToSlot(slot)

func save_settings():
	gm.SaveSettings()
	
func _ready() -> void:
	gm._Ready()

func delete_slot(slot:int):
	gm.DeleteSlot(slot)
	
func load_profile(slot:int):
	gm.LoadProfileToCurrent(slot)
	current_slot = slot
	
func save_current_slot():
	gm.SaveToSlot(current_slot)
	
func give_current_slot_full_collection():
	gm.GivePlayerFullCollection()

func get_current_slot_cards() -> Array[int]:
	return gm.GetCurrentSlotCollection()

func clear_deck():
	chosen_deck.cards.clear()
	
func init_deck():
	if chosen_deck:
		chosen_deck.queue_free()
	chosen_deck = Deck.new()
	

func random_deck(use_collection:bool):
	if !chosen_deck:
		init_deck()
	
	if use_collection:
		var card_inventory:Array[int] = global_manager.get_current_slot_cards()
		for i in card_inventory:
			chosen_deck.cards.push_back(build_card_from_id(i))

	chosen_deck.cards.shuffle()
	


func start_diddle():
	credits = 5
	life = 15
	if !chosen_deck:
		random_deck(true)
		

func save_deck(cards:Dictionary, name:String) -> bool:
	return gm.AddNewDeck(cards,name)
	
func get_deck(cards:Dictionary, name:String) -> Array[Card]: #id,number
	var output:Array[Card] = []
	var dicc:Dictionary = gm.GetDeck(name)
	var arr:Array[int] = dicc.keys()
	for i in arr:
		for n in dicc[i]:
			output.push_back(build_card_from_id(i))
		
	return output
	
