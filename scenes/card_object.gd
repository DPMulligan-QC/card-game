extends Node2D
class_name card_object

var card_type:int

@onready var label_name:Label = $CardBackground/Label_Cover/Label_Name
@onready var label_cost:Label = $CardBackground/Label_Cover/Label_Cost
@onready var label_type:Label = $CardBackground/Label_Cover/Label_Type
@onready var label_text:Label = $CardBackground/Label_Cover/Label_Text
@onready var label_health:Label = $CardBackground/Label_Cover/Label_Health
@onready var label_power:Label = $CardBackground/Label_Cover/Label_Power
@onready var label_training:Label = $CardBackground/Label_Cover/Label_Training
@onready var parent_sprite:Sprite2D = $CardBackground
@onready var area:Area2D = $CardBackground/Area2D

@onready var menu_bg:Panel=$CardBackground/Panel_Menu

var base_health:int
var base_attack:int
var health:int
var concealed:bool = false
var card:Card
var menu_visible:bool=false

func _ready() -> void:
	pass

func set_args(input:Card, num:int):
	card = input
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
		base_health = health
		base_attack = card.baseData.attack
		label_health.text = str(health)
		label_power.text = str(card.baseData.attack)
		label_training.text = str(card.baseData.training)
		
	else:
		label_health.visible=false
		label_power.visible=false
		label_training.visible=false
	
	parent_sprite.global_position = Vector2(128.0 + float(num)*150.0,parent_sprite.global_position.y)
	
func toggle_concealment():
	if concealed:
		unveil()
	else:
		conceal()

func conceal():
	concealed = true
	card.conceal_self()
	label_name.visible = false
	label_cost.visible = false
	label_type.visible = false
	label_text.visible = false
	
	label_health.visible = false
	label_power.visible = false
	label_training.visible = false

func unveil():
	concealed = false
	card.unveil_self()
	label_name.visible = true
	label_cost.visible = true
	label_type.visible = true
	label_text.visible = true
	if card_type==0||card_type==1||card_type==6||card_type==5:
		label_health.visible = true
		label_power.visible = true
		label_training.visible = true
	

func take_damage(damage:int):
	health = health-damage
	label_health.text = str(health)
	
func heal():
	health = base_health
	label_health.text = str(health)

func buff(amt:int=1):
	base_health = base_health+amt
	health = health+amt
	base_attack = base_attack+amt
	label_health.text = str(health)
	label_power.text = str(base_attack)
	
func toggle_menu():
	var isvis:bool = menu_bg.visible
	if isvis:
		parent_sprite.scale = Vector2(1.0,1.0)
	else:
		parent_sprite.scale = Vector2(2.0,2.0)
	set_menu_visible(!isvis)

func set_menu_visible(isvis:bool=true):
	menu_visible = isvis
	menu_bg.visible=isvis


func _on_button_flip_pressed() -> void:
	if menu_bg.visible:
		toggle_concealment()


func _on_button_damage_pressed() -> void:
	if menu_bg.visible:
		take_damage(1)


func _on_button_heal_pressed() -> void:
	if menu_bg.visible:
		heal()


func _on_button_buff_pressed() -> void:
	if menu_bg.visible:
		buff(1)


func _on_button_debuff_pressed() -> void:
	if menu_bg.visible:
		buff(-1)
