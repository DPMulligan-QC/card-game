extends Node2D
class_name game_board
var hovered_card:card_object
var card_man:card_manager
var cards_in_play:Array[card_object]
var card_tokens_in_play:Array[card_object]=[]
var deck:Deck
var isAndroid:bool=false
var fingie:Vector2 = Vector2(2.0,2.0)
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

@onready var hand_hider:Button = $PanelContainer/Panel/Button_Hand_Hider

var dragged_card:card_object

var card_count:int=0

func _process(delta: float) -> void:
	if dragged_card && dragged_card.parent_sprite:
		if !isAndroid:
			var pos = get_global_mouse_position()
			dragged_card.parent_sprite.position = pos
		elif fingie:
			dragged_card.parent_sprite.position = fingie

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
						for card_get in card_tokens_in_play:
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
	if event is InputEventKey && event.pressed:
		if event.keycode == KEY_ESCAPE:
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		else:	
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
				elif event.keycode == KEY_M:
					card.toggle_menu()
	elif event is InputEventScreenTouch:	
		var cast = event as InputEventScreenTouch
		isAndroid=true
		var card = raycast_for_card()
		if card:
			if cast.double_tap:
				if hovered_card:
					if hovered_card!=card:
						hovered_card.set_menu_visible(false)
						hovered_card.parent_sprite.scale = Vector2(1.0,1.0)
						hovered_card = card
						card.parent_sprite.scale = Vector2(2.0,2.0)
						card.set_menu_visible(true)
					else:
						card.toggle_menu()
				else:	
					hovered_card = card
					card.parent_sprite.scale = Vector2(2.0,2.0)
					card.set_menu_visible(true)	
					
			elif cast.pressed:
#				if hovered_card:
#					hovered_card.set_menu_visible(false)
#					hovered_card.parent_sprite.scale = Vector2(1.0,1.0)
#					hovered_card = null
				fingie = cast.position
				dragged_card = card
				if !dragged_card.concealed:
					for card_get in cards_in_play:
						card_get.z_index = 0
					for card_get in card_tokens_in_play:
						card_get.z_index = 0
					dragged_card.z_index = 1
			elif dragged_card:
				#dragged_card.parent_sprite.scale = Vector2(1.0,1.0)
				if dragged_card.area.overlaps_area(standby_zone_area):
					dragged_card.visible = false
					if !card_tokens_in_play.has(dragged_card):
						standby_zone.push_front(dragged_card.card)
						cards_in_play.erase(dragged_card)
					else:
						card_tokens_in_play.erase(dragged_card)
					get_tree().root.remove_child(dragged_card)
					#dragged_card.queue_free()
				dragged_card=null


		
	elif event is InputEventScreenDrag:
		if dragged_card!=null:
			fingie = event.position
#			if hovered_card:
#				hovered_card.set_menu_visible(true)
#			hovered_card = null
#			for c in cards_in_play:
#				release_dragged_card(c)
#			for c in card_tokens_in_play:
#				release_dragged_card(c)
				
#			var card = raycast_for_card()
#			if card:
#				hovered_card = card
#				if !dragged_card.concealed:
#					dragged_card.parent_sprite.scale = Vector2(2.0,2.0)
#					for card_get in cards_in_play:
#						card_get.z_index = 0
#					for card_get in card_tokens_in_play:
#						card_get.z_index = 0
#					dragged_card.z_index = 1
			
#		elif dragged_card :

#			if event.is_canceled():
#				dragged_card.parent_sprite.scale = Vector2(1.0,1.0)
#				if dragged_card.area.overlaps_area(standby_zone_area):
#					dragged_card.visible = false
#					standby_zone.push_front(dragged_card.card)
#					cards_in_play.erase(dragged_card)
#					get_tree().root.remove_child(dragged_card)
#			else:
#				fingie = event.position
		
					

func _ready() -> void:
	my_credits = starting_credits
	my_life = starting_life
	for i in global_manager.card_count:
		cards_db.push_back(global_manager.build_card_from_id(i))
		
	deck=Deck.new()	

#  TEST MODE ////////////////////////////			
#	deck = global_manager.chosen_deck
#  DRAFT MODE ////////////////////////////	
	if global_manager.drafting || global_manager.chosen_deck == null:
		global_manager.random_deck(true)
		global_manager.chosen_deck.shuffle()
		deck.set_args([])
		next_draft()
	#  CONSTRUCTED MODE ////////////////////////////	
	else:
		deck.load_deck(global_manager.chosen_deck.cards)
		deck.shuffle()
		#draw_card(2)

func next_draft():
	var subscene = load("res://scenes/horz_card_list.tscn")
	list_instance= subscene.instantiate() as horz_list
	get_tree().root.add_child(list_instance)
	
	list_instance.set_args([global_manager.chosen_deck.cards.pop_front(),global_manager.chosen_deck.cards.pop_front(),global_manager.chosen_deck.cards.pop_front(),global_manager.chosen_deck.cards.pop_front()],false,false,true,false,false)
	list_instance.canceled.connect(on_list_cancel.bind(list_instance))
	list_instance.finished.connect(add_card_from_list_instance)	
	list_instance.label.text = str("DRAFT (",card_count+1,"/50)")
	

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
				on_list_cancel(list_instance)
		elif list_instance.search_deck:
			get_tree().root.add_child(card_scene)
			cards_in_play.push_back(card_scene)
			card_scene.set_args(list_instance.selected_card,0)
		
			if list_instance.search_deck:
				deck.cards.erase(deck.cards[deck.cards.find(list_instance.selected_card)])#I'M GONNA THROW UP
				on_list_cancel(list_instance)
		elif list_instance.recruiting:
			for cardo in list_instance.card_previews:
				if cardo.selected || cardo == list_instance.selected_card_preview:
					get_tree().root.add_child(card_scene)
					cards_in_play.push_back(card_scene)
					card_scene.set_args(cardo.card,0)	
				else:
					standby_zone.push_front(cardo.card)
			on_list_cancel(list_instance)
		elif list_instance.copy:
			get_tree().root.add_child(card_scene)
			card_tokens_in_play.push_back(card_scene)
			card_scene.set_args(list_instance.selected_card,0)
			on_list_cancel(list_instance)
		else:
			deck.cards.push_front(list_instance.selected_card)
			card_count = card_count+1
			if(card_count < 50):
				on_list_cancel(list_instance)
				next_draft()
			else:
				on_list_cancel(list_instance)
				deck.shuffle()
				card_man = card_manager.new()
	
	
		
	

func murder_list_instance():
	if list_instance:
		get_tree().root.remove_child(list_instance)

func _on_button_search_standby_pressed() -> void:
	var subscene = load("res://scenes/horz_card_list.tscn")
	list_instance= subscene.instantiate() as horz_list
	get_tree().root.add_child(list_instance)
	list_instance.set_args(standby_zone,false,true,true,false,false)
	list_instance.canceled.connect(on_list_cancel.bind(list_instance))
	list_instance.finished.connect(add_card_from_list_instance)


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
	list_instance.set_args(deck.cards,false,false,true,true,false)
	list_instance.canceled.connect(on_list_cancel.bind(list_instance))
	list_instance.finished.connect(add_card_from_list_instance)
	list_instance.scroll_container.position = Vector2(0.0,365.0)

func on_list_cancel(listref:horz_list):
	if listref:
		get_tree().root.remove_child(listref)
		
func _on_button_shuffle_pressed() -> void:
	deck.shuffle()


func _on_button_reset_pressed() -> void:
	# return cards in play to deck
	for i in cards_in_play.size():
		cards_in_play[0].visible = false
		standby_zone.push_front(cards_in_play[0].card)
		get_tree().root.remove_child(cards_in_play[0])
		cards_in_play.remove_at(0)
		
	#return standby zone to deck
	for i in standby_zone.size():
		deck.cards.push_front(standby_zone.pop_front())
	
	#remove tokens from play
	for i in card_tokens_in_play.size():
		card_tokens_in_play[0].visible = false
		get_tree().root.remove_child(card_tokens_in_play[0])
		card_tokens_in_play.remove_at(0)
	
	#shuffle
	deck.shuffle()
	
	#reset resources
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
	listo.set_args(cards_db,false,false,true,false,true)
	listo.canceled.connect(close_list.bind(listo))
	listo.finished.connect(copy_card_from_list.bind(listo))
	listo.scroll_container.position = Vector2(0.0,365.0)

func on_list_choose(list:horz_list):
	if list && list.selected_card:
		var subscene = load("res://scenes/card_mockup.tscn")
		var card_scene:card_object = subscene.instantiate()
		if list.from_standby:
			get_tree().root.add_child(card_scene)
			cards_in_play.push_back(card_scene)
			card_scene.set_args(list.selected_card,0)
		
			if list.from_standby:
				standby_zone.erase(standby_zone[standby_zone.find(list.selected_card)])#i'm gonna throw up.
				on_list_cancel(list)
		elif list.search_deck:
			get_tree().root.add_child(card_scene)
			cards_in_play.push_back(card_scene)
			card_scene.set_args(list.selected_card,0)
		
			if list.search_deck:
				deck.cards.erase(deck.cards[deck.cards.find(list.selected_card)])#I'M GONNA THROW UP
				on_list_cancel(list)
		elif list.recruiting:
			for cardo in list.card_previews:
				if cardo.selected || cardo == list.selected_card_preview:
					get_tree().root.add_child(card_scene)
					cards_in_play.push_back(card_scene)
					card_scene.set_args(cardo.card,0)	
				else:
					standby_zone.push_front(cardo.card)
			on_list_cancel(list)
		elif list.copy:
			get_tree().root.add_child(card_scene)
			card_tokens_in_play.push_back(card_scene)
			card_scene.set_args(list.selected_card,0)
			on_list_cancel(list)
		else:
			deck.cards.push_front(list.selected_card)
			card_count = card_count+1
			if(card_count < 50):
				on_list_cancel(list)
				next_draft()
			else:
				on_list_cancel(list)
				deck.shuffle()
				card_man = card_manager.new()

func _on_button_copy_card_pressed() -> void:
	var subscene = load("res://scenes/horz_card_list.tscn")
	list_instance= subscene.instantiate() as horz_list
	get_tree().root.add_child(list_instance)
	list_instance.set_args(cards_db,false,false,true,false,true)
	list_instance.canceled.connect(on_list_cancel.bind(list_instance))
	list_instance.finished.connect(on_list_choose.bind(list_instance))


func _on_button_hide_hand_pressed() -> void:
	hand_hider.visible = !hand_hider.visible
	
func release_dragged_card(the_card:card_object = dragged_card):
				the_card.parent_sprite.scale = Vector2(1.0,1.0)
				if the_card.area.overlaps_area(standby_zone_area) && !card_tokens_in_play.has(the_card):
					the_card.visible = false
					standby_zone.push_front(the_card.card)
					cards_in_play.erase(the_card)
					get_tree().root.remove_child(the_card)
				elif the_card == dragged_card:
					dragged_card = null
	
