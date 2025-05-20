extends Control

var resolutions
@onready var option_button_resolutions:OptionButton = $Panel_Background/OptionButton_Resolutions

func _ready() -> void:
	
	resolutions = {
		"2560x1440":Vector2i(2560,1440),
		"1920x1080":Vector2i(1920,1080),
		"128x720":Vector2i(1280,720)
	}
	
	add_resolutions()


func add_resolutions():
	for r in resolutions:
		option_button_resolutions.add_item(r)

func _on_button_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")



func _on_option_button_resolutions_item_selected(index: int) -> void:
	var size = resolutions.get(option_button_resolutions.get_item_text(index))
	DisplayServer.window_set_size(size)
	
	
