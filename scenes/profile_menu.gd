extends Control

@onready var slot1_select_button:Button=$Panel_Background/Button_Profile_Select1
@onready var slot2_select_button:Button=$Panel_Background/Button_Profile_Select2
@onready var slot3_select_button:Button=$Panel_Background/Button_Profile_Select3

@onready var slot1_delete_button:Button=$Panel_Background/Button_Profile_Select1/Button_Profile_Delete1
@onready var slot2_delete_button:Button=$Panel_Background/Button_Profile_Select2/Button_Profile_Delete2
@onready var slot3_delete_button:Button=$Panel_Background/Button_Profile_Select3/Button_Profile_Delete3

@onready var subscene
@onready var subscene_instance
@onready var name_instance:name_entry

var chosen_name:String
var save_slot:int

var profile_found = [false, false, false]


	
func repaint():
	global_manager.load_slots()
	if global_manager.is_valid_slot(1):
		if global_manager.get_slot_name(1).length()<2:
			profile_found[0] = false;
			slot1_delete_button.visible = false
			slot1_select_button.text = "CREATE NEW"
		else:
			profile_found[0] = true;
			slot1_delete_button.visible = true
			slot1_select_button.text = global_manager.get_slot_name(1)
	if global_manager.is_valid_slot(2):
		if global_manager.get_slot_name(2).length()<2:
			profile_found[1] = false;
			slot2_delete_button.visible = false
			slot2_select_button.text = "CREATE NEW"
		else:
			profile_found[1] = true;
			slot2_delete_button.visible = true
			slot2_select_button.text = global_manager.get_slot_name(2)
	if global_manager.is_valid_slot(3):
		if global_manager.get_slot_name(3).length()<2:
			profile_found[2] = false;
			slot3_delete_button.visible = false
			slot3_select_button.text = "CREATE NEW"
		else:
			profile_found[2] = true;
			slot3_delete_button.visible = true
			slot3_select_button.text = global_manager.get_slot_name(3)
			
	
	
func _ready() -> void:
	repaint()

func close_name_panel():
	repaint()
	get_tree().root.remove_child(name_instance)

func name_entered():
	chosen_name = name_instance.name_entered
	global_manager.set_slot_name(chosen_name,save_slot)
	close_name_panel()
	


func _on_button_profile_select_1_pressed() -> void:
	if profile_found[0]:
		global_manager.load_profile(1)
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	else:
		create_name_entry_panel(1)


func _on_button_profile_select_2_pressed() -> void:
	if profile_found[1]:
		global_manager.load_profile(2)
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	else:
		create_name_entry_panel(2)


func _on_button_profile_select_3_pressed() -> void:
	if profile_found[2]:
		global_manager.load_profile(3)
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	else:
		create_name_entry_panel(3)
		

func create_name_entry_panel(slot:int):
	save_slot = slot
	subscene = load("res://scenes/name_entry.tscn")
	name_instance = subscene.instantiate() as name_entry
	name_instance.cancel.connect(close_name_panel)
	name_instance.complete.connect(name_entered)
	get_tree().root.add_child(name_instance)
	name_instance.set_args(slot)


func _on_button_profile_delete_1_pressed() -> void:
	global_manager.delete_slot(1)
	#await get_tree().create_timer(1).timeout
	repaint()


func _on_button_profile_delete_2_pressed() -> void:
	global_manager.delete_slot(2)
	#await get_tree().create_timer(1).timeout
	repaint()


func _on_button_profile_delete_3_pressed() -> void:
	global_manager.delete_slot(3)
	#await get_tree().create_timer(1).timeout
	repaint()
