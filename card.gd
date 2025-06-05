extends Node
class_name Card
var cardBasePath = load("res://CardBase.cs")
var baseData = cardBasePath.new()
signal unveil
signal conceal
signal advance
signal eliminate
signal block
signal maintenance
signal impulse

@onready var json_path:String
@onready var json_text:String
@onready var json_object:JSON
@onready var json_dictionary:Dictionary
@onready var const_card_data:Variant


func _ready() -> void:
	pass


func populate_base(_id:int, _json_path:String  = "res://databases/card_data.json"):
	json_path = _json_path
	
	assert(FileAccess.file_exists(json_path), str("CARD.POPULATE():  FILE DOES NOT EXIST AT PATH ", json_path))
	
	var file = FileAccess.open(json_path,FileAccess.READ)
	json_text = file.get_as_text()
	#print("json text output: " , json_text)
	json_object = JSON.new()
	json_object.parse(json_text)
	json_dictionary= json_object.data
	const_card_data = json_dictionary[str(_id)]
	
	if(const_card_data):
		
		var _name:String = const_card_data["name"]
		var _description:String = const_card_data["text"]
		var _cost:String
		var temp = const_card_data["cost"]
		if typeof(temp)==TYPE_FLOAT:
			_cost = str(int(temp))
		else:
			_cost = str(temp)
		var _type:int = const_card_data["type"]

		if _type==0 || _type==1|| _type==5|| _type==6:
			var _attack:int = const_card_data["attack"]
			var _training:int = const_card_data["training"]
			var _health:int = const_card_data["health"]
			baseData.PopulateData(_id, _name, _description, _cost, _attack, _training, _health, _type)
			#print(str("ID: ", baseData.id, ",  ", baseData.name, ",   type:", _type,",    cost: ", baseData.cost, ",    \n\n",baseData.description,
			#"\n\nattack: ", baseData.attack, ",   training:", baseData.training,",    health: ", baseData.health,"\n\n\n\n"))
		else:
			baseData.PopulateData(_id, _name, _description, _cost, _type)
			#print(str("ID: ", baseData.id, ",  ", baseData.name, ",   type:", _type,",    cost: ", baseData.cost, ",    \n\n",baseData.description, "\n\n\n\n"))

	else:
		print("CONST CARD DATA FAILED TO PARSE!!!")
		

func conceal_self():
	baseData.Conceal()
	conceal.emit()
	
func unveil_self():
	baseData.Expose()
	unveil.emit()
