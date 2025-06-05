extends Control
@onready var button:Button = $Button
var deck_name:String
var new_deck_button:bool = true

func set_args(_name:String):
	if _name!="":
		deck_name = _name
		button.text = deck_name
		new_deck_button = false



func _on_button_pressed() -> void:
	if new_deck_button:
		pass
		
