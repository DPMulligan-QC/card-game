extends Control
class_name deck_editor


							# [id, count]
@onready var cards:Dictionary[int,int] ={}
@onready var loaded_cards:Array[Card] = []
@onready var card_id_to_button:Dictionary[int,editor_card_button] ={}
@onready var deck_list:VBoxContainer = $Panel_Background/Panel_Side/ScrollContainer_Deck/card_list_deck
@onready var save_button:Button = $Panel_Background/Panel_Side/Button_Save
#@onready var scroll_container:ScrollContainer = $Panel_Background/ScrollContainer
@onready var card_array:Array[Card]=[]
@onready var names:Dictionary[String,int]
#all possible card previews
@onready var card_previews:Array[card_preview]=[]
#only what is displayed after applying filters
@onready var displayed_card_previews:Array[card_preview]=[]
@onready var grid:GridContainer = $Panel_Background/ScrollContainer/GridContainer
@onready var line_edit:LineEdit = $Panel_Background/Panel_Side/LineEdit
@onready var label_count:Label = $Panel_Background/Label_Count



var sort_by:global_manager.e_sort = global_manager.e_sort.ID_ASCENDING
var deck_name:String = "New Deck"
var search_text:String = ""
var card_count:int = 0
var is_ready:bool = false
var card_type:int = 0 # 0 = all types, 1 = units, 2 = man, 3 = machine, 4 = tactics, 5 = field, 6 = trap, 7 = instant, 8 = arms, 9 = weapon, 10 = vehicle
signal save
signal exit
signal delete
enum filter_type{
	DEFAULT
}
enum sort_type{
	SORT_ALPHABETICAL
}

var filters:Array #array of filters

func add_card(id:int):

	var newCard:Card = global_manager.build_card_from_id(id)
	var restrict = newCard.baseData.restrict
	if cards.has(id):
		if restrict:
			if restrict > cards[id]:
				cards.set(id,cards[id]+1)
				card_count = card_count+1
		elif cards[id]<5:
			cards.set(id,cards[id]+1)
			card_count = card_count+1
		if card_id_to_button.has(id):
			var button:editor_card_button = card_id_to_button[id]
			button.card_count = cards[id]
			button.repaint()
	else:
		cards[id] = 1
		card_count = card_count+1
		var subscene = load("res://scenes/card_in_editor.tscn")
		var new_button:editor_card_button = subscene.instantiate() as editor_card_button
		deck_list.add_child(new_button)
		new_button.set_args(id,newCard.baseData.name)
		card_id_to_button[id] = new_button
		new_button.repaint()
		new_button.button.pressed.connect(deck_list_pressed.bind(new_button))
		
	if is_ready:
		label_count.text = str(card_count,"/50 CARDS MINIMUM")

func remove_card(id:int, button:editor_card_button):
	card_count = card_count-1
	if is_ready:
		label_count.text = str(card_count,"/50 CARDS MINIMUM")
	if cards.has(id):
		var count:int = cards[id]
		if count>1:
			cards.set(id,cards[id]-1)
			button.card_count = button.card_count-1
			button.repaint()
		else:
			cards.erase(id)
			if card_id_to_button.has(id):
				card_id_to_button.erase(id)
			deck_list.remove_child(button)
			
		

func deck_list_pressed(button:editor_card_button):
	#var cname = button.card_id
	remove_card(button.card_id, button)
	

func init_grid():
	for id in global_manager.names.size():
		var card_data:Card = global_manager.build_card_from_id(id)
		card_array.push_front(card_data)
		var subscene = load("res://scenes/card_preview.tscn")
		var new_card:card_preview = subscene.instantiate()
		new_card.set_args_collection(card_data,self)
		grid.add_child(new_card)
		card_previews.push_front(new_card)
		new_card.added.connect(add_card.bind(new_card.card.baseData.id))
	
func populate_grid():
	
	displayed_card_previews.clear()
	displayed_card_previews = []
#filtewr search text
	if search_text!= "" && search_text!= "..." :
		for kiddo:card_preview in card_previews: #iterate all cards
			if str(kiddo.card.baseData.name).containsn(search_text) || str(kiddo.card.baseData.description).containsn(search_text):
				var dupe:card_preview = kiddo.duplicate()
				dupe.set_args_collection(kiddo.card,self)
				#dupe.card =
				displayed_card_previews.push_front(dupe)
	else:
		for kiddo:card_preview in card_previews:
			var dupe:card_preview = kiddo.duplicate()
			dupe.set_args_collection(kiddo.card,self)
				#dupe.card =
			displayed_card_previews.push_front(dupe)

	
#filter type
	var to_remove:Array[card_preview] = []
	match card_type: # 0 = all types, 1 = units, 2 = man, 3 = machine, 4 = tactics, 5 = field, 6 = trap, 7 = instant, 8 = arms, 9 = weapon, 10 = vehicle
		0:
			pass
		1:
			for kiddo in displayed_card_previews: 
				var type:int = int(kiddo.card.baseData.type)
				if type!=0 && type!=1:
					to_remove.push_front(kiddo)
		2:
			for kiddo in displayed_card_previews:
				var type:int = int(kiddo.card.baseData.type)
				if type!=0:
					to_remove.push_front(kiddo)
		3:
			for kiddo in displayed_card_previews: 
				var type:int = int(kiddo.card.baseData.type)
				if type!=1:
					to_remove.push_front(kiddo)
		4: 
			for kiddo in displayed_card_previews: 
				var type:int = int(kiddo.card.baseData.type)
				if type!=2 && type!=3&& type!=4:
					to_remove.push_front(kiddo)
		5: # 0 = all types, 1 = units, 2 = man, 3 = machine, 4 = tactics, 5 = field, 6 = trap, 7 = instant, 8 = arms, 9 = weapon, 10 = vehicle
			for kiddo in displayed_card_previews: #iterate all cards and search for name
				var type:int = int(kiddo.card.baseData.type)
				if type!=2:
					to_remove.push_front(kiddo)
		6:
			for kiddo in displayed_card_previews: #iterate all cards and search for name
				var type:int = int(kiddo.card.baseData.type)
				if type!=3:
					to_remove.push_front(kiddo)
		7:
			for kiddo in displayed_card_previews: #iterate all cards and search for name
				var type:int = int(kiddo.card.baseData.type)
				if type!=4:
					to_remove.push_front(kiddo)
		8:
			for kiddo in displayed_card_previews: #iterate all cards and search for name
				var type:int = int(kiddo.card.baseData.type)
				if type!=5 && type!=6:
					to_remove.push_front(kiddo)
		9:
			for kiddo in displayed_card_previews: #iterate all cards and search for name
				var type:int = int(kiddo.card.baseData.type)
				if type!=6:
					to_remove.push_front(kiddo)
		10:
			for kiddo in displayed_card_previews: #iterate all cards and search for name
				var type:int = int(kiddo.card.baseData.type)
				if type!=5:
					to_remove.push_front(kiddo)
				#END TYPE FILTER
	for kiddo in to_remove:
		if displayed_card_previews.has(kiddo):
			displayed_card_previews.erase(kiddo)
#sort
	displayed_card_previews = global_manager.card_preview_selection_sort(displayed_card_previews,sort_by)
#display results on grid
	for kiddo in displayed_card_previews:
		grid.add_child(kiddo)
		kiddo.added.connect(add_card.bind(kiddo.card.baseData.id))

func wipe_grid():
	for kiddo in grid.get_children():
		kiddo.added.disconnect(add_card.bind(kiddo.card.baseData.id))
		grid.remove_child(kiddo)

func set_args(_name:String = "New Deck"):
	deck_name=_name
	loaded_cards = global_manager.get_card_array_from_name(_name)


func _ready() -> void:
	line_edit.text = deck_name
	init_grid()
	label_count.text = str(card_count,"/50 CARDS MINIMUM")
	is_ready = true
	loaded_cards = global_manager.get_card_array_from_name(deck_name)
	for cardo in loaded_cards:
		add_card(cardo.baseData.id)

func _on_button_cancel_pressed() -> void:
	exit.emit()


func _on_button_save_pressed() -> void:
#	deck_name = line_edit.text
	global_manager.save_deck(cards,deck_name)
	save.emit()
	exit.emit()

	


func _on_button_delete_pressed() -> void:
	global_manager.delete_deck(deck_name)
	delete.emit()
	exit.emit()



func _on_line_edit_text_changed(new_text: String) -> void:
	deck_name = new_text

func _on_line_edit_search_text_changed(new_text: String) -> void:
	search_text = new_text
	wipe_grid()
	populate_grid()

func set_sort(sort:global_manager.e_sort):
	sort_by = sort
	wipe_grid()
	populate_grid()
	
func _on_option_button_sort_by_item_selected(index: int) -> void:
	if index!= int(sort_by):
		set_sort(index)
		


func _on_option_button_card_type_item_selected(index: int) -> void:
	card_type = index
	wipe_grid()
	populate_grid()
