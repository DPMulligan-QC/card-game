extends Control
class_name editor_card_button
@onready var button:Button = $Button
var card_name:String
var card_id:int
var card_count:int = 1

func _ready() -> void:
	repaint()

func set_args(_card_id:int,_card_name:String):
	if _card_name!="":
		card_name = _card_name
		card_id=_card_id
		card_count=1
		#repaint()

func repaint():
	button.text = str(card_name, " x",card_count)
	
	
