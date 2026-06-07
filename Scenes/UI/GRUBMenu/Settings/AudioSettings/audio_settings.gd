extends GRUB

var currently_open_id:int = -1


func _ready() -> void:
	super._ready()
	$VBoxContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/Slider2.set_value(GlobalAudio.get_volume())


func on_menu_select_pressed():
	match currently_selected:
		0:
			play_outro()
			await outro_finished
			get_tree().change_scene_to_file("res://Scenes/UI/GRUBMenu/Settings/settings.tscn")
		1:
			options_container.get_children()[2].visible = true
			currently_open_id = 2
		2:
			play_outro()
			await outro_finished

func check_menu_inputs():
	if Input.is_action_just_pressed("menu_down") and currently_selected < get_children_of_type(options_container, Label).size() - 1:
		update_selection(currently_selected + 1)
		if currently_open_id >= 0:
			options_container.get_children()[currently_open_id].visible = false
			currently_open_id = -1
	elif Input.is_action_just_pressed("menu_up") and currently_selected > 0:
		update_selection(currently_selected - 1)
		if currently_open_id >= 0:
			options_container.get_children()[currently_open_id].visible = false
			currently_open_id = -1
	
	if Input.is_action_just_pressed("menu_left"):
		if currently_open_id:
			var node = options_container.get_children()[currently_open_id]
			if node is SliderContainer:
				node.decrement()
				if currently_open_id == 2:
					GlobalAudio.set_volume(node.get_value())
	elif Input.is_action_just_pressed("menu_right"):
		if currently_open_id:
			var node = options_container.get_children()[currently_open_id]
			if node is SliderContainer:
				node.increment()
				if currently_open_id == 2:
					GlobalAudio.set_volume(node.get_value())
	
