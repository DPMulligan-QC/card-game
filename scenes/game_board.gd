extends Node2D
class_name game_board

var card_man:card_manager
var cards_in_play:Array[card_object]
var deck:Deck

var standby_zone:Array[Card] = []
var cards_db:Array[Card] = []

var starting_life:int = 15
var my_life:int = 15
var my_credits:int = 5
var their_life:int = 15
var starting_credits:int = 5

@onready var standby_zone_area:Area2D = $PanelContainer/Panel/Sprite2D_Standby/Area2D_Standby
var list_instance:horz_list
	
@onready var credit_label:Label = $PanelContainer/Panel/Label_My_Credits
@onready var my_life_label:Label = $PanelContainer/Panel/Label_My_Life

@onready var their_life_label:Label = $PanelContainer/Panel/Label_Their_Life

var dragged_card:card_object

var card_count:int=0

func _process(delta: float) -> void:
	if dragged_card:
		var pos = get_global_mouse_position()
		dragged_card.parent_sprite.position = pos

func raycast_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = 1
	var result = space_state.intersect_point(parameters)
	if result.size()>0:
		return result[0].collider.get_parent().get_owner() as card_object
	return null

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT || event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				var card = raycast_for_card()
				if card:
					dragged_card = card
					if !dragged_card.concealed:
						if event.button_index == MOUSE_BUTTON_RIGHT:
							dragged_card.parent_sprite.scale = Vector2(2.0,2.0)
						for card_get in cards_in_play:
							card_get.z_index = 0
						dragged_card.z_index = 1
			elif dragged_card:
				if event.button_index == MOUSE_BUTTON_RIGHT:	
					dragged_card.parent_sprite.scale = Vector2(1.0,1.0)
				if dragged_card.area.overlaps_area(standby_zone_area):
					dragged_card.visible = false
					standby_zone.push_front(dragged_card.card)
					cards_in_play.erase(dragged_card)
					get_tree().root.remove_child(dragged_card)
					#dragged_card.queue_free()
				dragged_card=null
	elif event is InputEventKey && event.pressed:
		
		var card = raycast_for_card()
		if card:
			if event.keycode == KEY_SPACE:
				card.toggle_concealment()
			elif event.keycode == KEY_D:
				card.take_damage(1)
			elif event.keycode == KEY_H:
				card.heal()
			elif event.keycode == KEY_B:
				card.buff(1)
			elif event.keycode == KEY_V:
				card.buff(-1)
					

func _ready() -> void:
	my_credits = starting_credits
	my_life = starting_life
	for i in global_manager.card_count:	
		cards_db.push_back(global_manager.build_card_from_id(i)) 
	
	deck=Deck.new()
	
	if global_manager.drafting || global_manager.chosen_deck == null:	
		global_manager.random_deck(true)
		global_manager.chosen_deck.shuffle()
		deck.set_args([])
		next_draft()
	else:
		deck.load_deck(global_manager.chosen_deck.cards)
		deck.shuffle()
	#draw_card(2)

func next_draft():
	var subscene = load("res://scenes/horz_card_list.tscn")
	list_instance= subscene.instantiate() as horz_list
	get_tree().root.add_child(list_instance)
	
	list_instance.set_args([global_manager.chosen_deck.cards.pop_front(),global_manager.chosen_deck.cards.pop_front(),global_manager.chosen_deck.cards.pop_front(),global_manager.chosen_deck.cards.pop_front()],false,false,true,false)
	list_instance.canceled.connect(murder_list_instance)
	list_instance.finished.connect(add_card_from_list_instance)	
	

func draw_card(amt:int):
	
	for i in amt:
		var subscene = load("res://scenes/card_mockup.tscn")
		var card_scene:card_object = subscene.instantiate()
		get_tree().root.add_child(card_scene)
		cards_in_play.push_back(card_scene)
		card_scene.set_args(deck.cards.pop_front(), min(cards_in_play.size(),10))
		

func refresh_credit_ui():
	credit_label.text = str(my_credits,"cr")
	
func refresh_life_ui():
	my_life_label.text = str(my_life,"/",starting_life)
	

func refresh_enemy_life_ui():
	their_life_label.text = str(their_life,"/",starting_life)

func _on_button_add_credit_pressed() -> void:
	my_credits= my_credits+1
	refresh_credit_ui()
	

func _on_button_lose_credit_pressed() -> void:
	my_credits= my_credits-1
	refresh_credit_ui()


func _on_button_next_turn_pressed() -> void:
	my_credits= my_credits+5
	refresh_credit_ui()
	




func _on_button_add_life_pressed() -> void:
	my_life = my_life+1
	refresh_life_ui()


func _on_button_draw_pressed() -> void:
	draw_card(1)

func add_card_from_list_instance():
	if list_instance && list_instance.selected_card:
		var subscene = load("res://scenes/card_mockup.tscn")
		var card_scene:card_object = subscene.instantiate()
		if list_instance.from_standby:
			get_tree().root.add_child(card_scene)
			cards_in_play.push_back(card_scene)
			card_scene.set_args(list_instance.selected_card,0)
		
			if list_instance.from_standby:
				standby_zone.erase(standby_zone[standby_zone.find(list_instance.selected_card)])#i'm gonna throw up.
				murder_list_instance()
		elif list_instance.search_deck:
			get_tree().root.add_child(card_scene)
			cards_in_play.push_back(card_scene)
			card_scene.set_args(list_instance.selected_card,0)
		
			if list_instance.search_deck:
				deck.cards.erase(deck.cards[deck.cards.find(list_instance.selected_card)])#I'M GONNA THROW UP
				murder_list_instance()
		elif list_instance.recruiting:
			for cardo in list_instance.card_previews:
				if cardo.selected || cardo == list_instance.selected_card_preview:
					get_tree().root.add_child(card_scene)
					cards_in_play.push_back(card_scene)
					card_scene.set_args(cardo.card,0)	
				else:
					standby_zone.push_front(cardo.card)
			murder_list_instance()
		else:
			deck.cards.push_front(list_instance.selected_card)
			card_count = card_count+1
			if(card_count < 50):
				murder_list_instance()
				next_draft()
			else:
				murder_list_instance()
				deck.shuffle()
				card_man = card_manager.new()
	
	
		
	

func murder_list_instance():
	if list_instance:
		get_tree().root.remove_child(list_instance)

func _on_button_search_standby_pressed() -> void:
	var subscene = load("res://scenes/horz_card_list.tscn")
	list_instance= subscene.instantiate() as horz_list
	get_tree().root.add_child(list_instance)
	list_instance.set_args(standby_zone,false,true,true,false)
	list_instance.canceled.connect(murder_list_instance)
	list_instance.finished.connect(add_card_from_list_instance)
	list_instance.scroll_container.position = Vector2(0.0,365.0)


func _on_button_add_their_life_pressed() -> void:
	their_life = their_life+1
	refresh_enemy_life_ui()


func _on_button_sub_their_life_pressed() -> void:
	their_life = their_life-1
	refresh_enemy_life_ui()


func _on_button_lose_life_pressed() -> void:
	my_life = my_life-1
	refresh_life_ui()


func _on_button_search_deck_pressed() -> void:
	var subscene = load("res://scenes/horz_card_list.tscn")
	list_instance= subscene.instantiate() as horz_list
	get_tree().root.add_child(list_instance)
	list_instance.set_args(deck.cards,false,false,true,true)
	list_instance.canceled.connect(murder_list_instance)
	list_instance.finished.connect(add_card_from_list_instance)
	list_instance.scroll_container.position = Vector2(0.0,365.0)


func _on_button_shuffle_pressed() -> void:
	deck.shuffle()


func _on_button_reset_pressed() -> void:
	for i in cards_in_play.size():
		cards_in_play[0].visible = false
		standby_zone.push_front(cards_in_play[0].card)
		get_tree().root.remove_child(cards_in_play[0])
		cards_in_play.remove_at(0)
		
		
	for i in standby_zone.size():
		deck.cards.push_front(standby_zone.pop_front())
	
	deck.shuffle()
	
	my_life = 15
	my_credits = 5
	their_life = 15
	refresh_enemy_life_ui()
	refresh_life_ui()
	refresh_credit_ui()

func copy_card_from_list(listo:horz_list):
	
	if listo:
		if listo.selected_card:
			var subscene = load("res://scenes/card_mockup.tscn")
			var card_scene:card_object = subscene.instantiate()
			get_tree().root.add_child(card_scene)
			cards_in_play.push_back(card_scene)
			card_scene.set_args(listo.selected_card,0)
		get_tree().root.remove_child(listo)

func close_list(listo:horz_list):
	if listo:
		get_tree().root.remove_child(listo)


func _on_button_add_card_pressed() -> void:
	var subscene = load("res://scenes/horz_card_list.tscn")
	var listo= subscene.instantiate() as horz_list
	get_tree().root.add_child(listo)
	listo.set_args(cards_db,false,false,true,false)
	listo.canceled.connect(close_list.bind(listo))
	listo.finished.connect(copy_card_from_list.bind(listo))
	listo.scroll_container.position = Vector2(0.0,365.0)
