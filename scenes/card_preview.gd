extends Node
class_name card_preview

var card_type:int

var can_be_selected:bool
@onready var label_name:Label = $Panel_Cover/Label_Name
@onready var label_cost:Label = $Panel_Cover/Label_Cost
@onready var label_type:Label = $Panel_Cover/Label_Type
@onready var label_text:Label = $Panel_Cover/Label_Text
@onready var label_health:Label = $Panel_Cover/Label_Health
@onready var label_power:Label = $Panel_Cover/Label_Power
@onready var label_training:Label = $Panel_Cover/Label_Training
@onready var panel_cover:Panel = $Panel_Cover
@onready var button:Button = $Panel_Cover/Button

var list:horz_list
var health:int
var selected:bool = false
var card:Card

func _ready() -> void:
	populate()

func set_args(input:Card, this_is_selectable:bool, _list:horz_list):
	can_be_selected = this_is_selectable
	#button.disabled = !can_be_selected
	card = input
	list=_list
	

func unpress():
	button.set_pressed_no_signal(false)
	selected = false




		


func populate():
	label_name.text = card.baseData.name
	label_cost.text = str(card.baseData.cost,"cr")
	label_text.text = card.baseData.description
	card_type = card.baseData.GetCardType()
	match card_type:
		0:
			label_type.text = "UNIT - MAN"
		1:
			label_type.text = "UNIT - MACHINE"
		2:
			label_type.text = "TACTIC - FIELD"
		3:
			label_type.text = "TACTIC - TRAP"
		4:
			label_type.text = "TACTIC - INSTANT"
		5:
			label_type.text = "ARMS - VEHICLE"
		6:
			label_type.text = "ARMS - WEAPON"
	
	if card_type==0 || card_type==1|| card_type==5|| card_type==6:
		health = card.baseData.health
		label_health.text = str(health)
		label_power.text = str(card.baseData.attack)
		label_training.text = str(card.baseData.training)
		
	else:
		label_health.visible=false
		label_power.visible=false
		label_training.visible=false
	


func _on_button_toggled(toggled_on: bool) -> void:
	selected = toggled_on
	if selected:
		list.deselect_all_previews()
		list.selected_card = card
		list.selected_card_preview = self
	else:
		list.selected_card = null
		list.selected_card_preview = null
