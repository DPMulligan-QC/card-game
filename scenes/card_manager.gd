extends Node2D
class_name card_manager

@onready var subscene
@onready var deck_instance:Deck
var dragged_card

func _process(delta: float) -> void:
	if dragged_card:
		var pos = get_global_mouse_position()
		dragged_card.position = pos

func raycast_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = 1
	var result = space_state.intersect_point(parameters)
	if result.size()>0:
		return result[result.size()-1].collider.get_parent()
	return null

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var card = raycast_for_card()
			if card:
				dragged_card = card
		else:
			dragged_card=null

func _ready() -> void:
	pass
