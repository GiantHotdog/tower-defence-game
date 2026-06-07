extends GRUB

var currently_open_id:int = -1
var slide_select_theme_override:StyleBoxFlat

func _ready() -> void:
	super._ready()
	slide_select_theme_override = StyleBoxFlat.new()
	slide_select_theme_override.border_width_bottom = 5
	slide_select_theme_override.border_color = Color.WHITE
	$VBoxContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/Slider2.set_value(GlobalAudio.get_volume())


func on_menu_select_pressed():
	if currently_open_id == -1:
		match currently_selected:
			0:
				options_container.get_children()[1].get_highlight_panel().add_theme_stylebox_override("panel", slider_select_theme_override)
				currently_open_id = 1
			1:
				play_outro()
				await outro_finished
				switch_to_previous_scene()
			2:
				play_outro()
				await outro_finished
				switch_to_previous_scene()
	else:
		options_container.get_children()[currently_open_id].get_highlight_panel().remove_theme_stylebox_override("panel")
		currently_open_id = -1

func check_menu_inputs():
	if Input.is_action_just_pressed("menu_down") and currently_selected < get_children_of_type(options_container, Label).size() - 1:
		update_selection(currently_selected + 1)
		if currently_open_id >= 0:
			options_container.get_children()[currently_open_id].get_highlight_panel().remove_theme_stylebox_override("panel")
			currently_open_id = -1
	elif Input.is_action_just_pressed("menu_up") and currently_selected > 0:
		update_selection(currently_selected - 1)
		if currently_open_id >= 0:
			options_container.get_children()[currently_open_id].get_highlight_panel().remove_theme_stylebox_override("panel")
			currently_open_id = -1
	
	if Input.is_action_just_pressed("menu_left"):
		if currently_open_id:
			var node = options_container.get_children()[currently_open_id]
			if node is SliderContainer:
				node.decrement()
				if currently_open_id == 1:
					GlobalAudio.set_volume(node.get_value())
	elif Input.is_action_just_pressed("menu_right"):
		if currently_open_id:
			var node = options_container.get_children()[currently_open_id]
			if node is SliderContainer:
				node.increment()
				if currently_open_id == 1:
					GlobalAudio.set_volume(node.get_value())
	
