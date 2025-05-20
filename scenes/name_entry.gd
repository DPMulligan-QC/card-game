extends Control
class_name name_entry
signal complete
signal cancel
var save_slot:int
var name_entered:String
@onready var line:LineEdit = $Panel_Background/LineEdit
@onready var accept:Button = $Panel_Background/Button_Accept
@onready var title:Label = $Panel_Background/Label

func set_args(slot:int):
	save_slot=slot
	line.visible = true
	accept.visible = true
	title.visible = true


func _on_button_back_pressed() -> void:
	cancel.emit()


func _on_button_accept_pressed() -> void:
	if line.text.length()<3:
		title.text = "NAME MUST CONTAIN AT LEAST 3 CHARACTERS"
	elif line.text.contains("<") || line.text.contains(">") || line.text.contains(":") || line.text.contains("\"") || line.text.contains("/") || line.text.contains("\\") || line.text.contains("|") || line.text.contains("?") || line.text.contains("*"):
		title.text = "NAME CONTAINS INVALID CHARACTER"
	else:
		name_entered = line.text
		complete.emit()
