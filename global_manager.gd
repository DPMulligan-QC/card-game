extends Node


var gmPath = load("res://GlobalManager.cs")
var gm = gmPath.new()

var card_count:int = gm.GetCardCount()
var current_slot:int
var drafting:bool = true
var chosen_deck:Deck
var credits:int
var life:int

var names:Dictionary = {}
@onready var json_path:String
@onready var json_text:String
@onready var json_object:JSON
@onready var json_dictionary:Dictionary
@onready var const_card_data:Variant



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
	var json_path = "res://databases/card_data.json"
	
	assert(FileAccess.file_exists(json_path), str("CARD.POPULATE():  FILE DOES NOT EXIST AT PATH ", json_path))
	var file = FileAccess.open(json_path,FileAccess.READ)
	json_text = file.get_as_text()
	#print("json text output: " , json_text)
	json_object = JSON.new()
	json_object.parse(json_text)
	json_dictionary= json_object.data
	for id in gm.GetCardCount():
		const_card_data = json_dictionary[str(id)]
		if(const_card_data):
			var _name:String = const_card_data["name"]
			if _name:
				names[_name] = id

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
	
func get_card_array_from_name(name:String) -> Array[Card]: #id,number
	var output:Array[Card] = []
	if gm.HasDeck(name):
		var dicc:Dictionary = gm.GetCardDict(name)
		var arr:Array[int] = dicc.keys()
		for i in arr:
			for n in dicc[i]:
				output.push_back(build_card_from_id(i))
		
	return output

func deck_count()->int:
	if gm.SavedDeckCount() != null:
		return gm.SavedDeckCount()
	else:
		return 0
	
func has_deck(_name:String)->bool:
	return gm.HasDeck(_name)
	
func get_deck_name(index:int)->String:
	return gm.GetDeckNameFromIndex(index)

func get_card_dict_from_name(index:String)->Dictionary:
	return gm.GetCardDict(index)

func delete_deck(name:String):
	gm.DeleteDeck(name)

enum e_sort{ID_ASCENDING = 0, ID_DESCENDING, COST_ASCENDING,COST_DESCENDING,A_Z,Z_A}

func swap(m1 : Object, m2 : Object, a : Array) -> Array:
	var i = a.find(m1)
	a[a.find(m2)] = m1
	a[i] = m2
	return a

func swap_by_index(i1 : int, i2 : int, a : Array) -> Array:
	var temp = a[i1].duplicate()
	a[i1] = a[i2]
	a[i2] = temp
	return a

func card_preview_selection_sort(previews:Array[card_preview], sortby:e_sort)->Array[card_preview]:
	   #     // Assume the current position holds
	#    // the minimum element
	#    int min_idx = i;

	 #   // Iterate through the unsorted portion
	  #  // to find the actual minimum
	   # for (int j = i + 1; j < n; ++j) {
		#    if (arr[j] < arr[min_idx]) {

		 #       // Update min_idx if a smaller
		  #      // element is found
		   #     min_idx = j; 
		   # }
		#}

  #$      // Move minimum element to its
	#    // correct position
	 #   swap(arr[i], arr[min_idx]);
	#}
#}
	var output:Array[card_preview] = clean_array(previews.duplicate(true))
	var i:int = 0
	var n:int = output.size()
	match sortby:
		global_manager.e_sort.ID_ASCENDING:
			while i<n:
				var min_indx:int = i
				var j:int = i+1
				while j<n:
					if int(output[j].card.baseData.id)<int(output[min_indx].card.baseData.id):
						output = swap_by_index(j, min_indx, output)
					j=j+1
				i=i+1
		global_manager.e_sort.ID_DESCENDING:
			while i<n:
				var min_indx:int = i
				var j:int = i+1
				while j<n:
					if int(output[j].card.baseData.id)<int(output[min_indx].card.baseData.id):
						output = swap_by_index(j, min_indx, output)
					j=j+1
				i=i+1
			output.reverse()
		global_manager.e_sort.COST_ASCENDING:
			while i<n:
				var min_indx:int = i
				var j:int = i+1
				while j<n:
					if int(output[j].card.baseData.cost)<int(output[min_indx].card.baseData.cost):
						output = swap_by_index(j, min_indx, output)
					j=j+1
				i=i+1
		global_manager.e_sort.COST_DESCENDING:
			while i<n:
				var min_indx:int = i
				var j:int = i+1
				while j<n:
					if int(output[j].card.baseData.cost)<int(output[min_indx].card.baseData.cost):
						output = swap_by_index(j, min_indx, output)
					j=j+1
				i=i+1
			output.reverse()
		global_manager.e_sort.A_Z:
			while i<n:
				var min_indx:int = i
				var j:int = i+1
				while j<n:
					if output[j].card.baseData.name<output[min_indx].card.baseData.name:
						output = swap_by_index(j, min_indx, output)
					j=j+1
				i=i+1
		global_manager.e_sort.Z_A:
			while i<n:
				var min_indx:int = i
				var j:int = i+1
				while j<n:
					if output[j].card.baseData.name<output[min_indx].card.baseData.name:
						output = swap_by_index(j, min_indx, output)
					j=j+1
				i=i+1
			output.reverse()

	return output
	
func clean_array(dirty_array: Array[card_preview]) -> Array[card_preview]:
	var cleaned_array:Array[card_preview] = []
	for item in dirty_array:
		if is_instance_valid(item):
			cleaned_array.push_back(item)
	return cleaned_array
