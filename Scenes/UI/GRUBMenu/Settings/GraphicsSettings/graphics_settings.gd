extends GRUB

var currently_open_id:int = -1

var is_selecting:bool = false

func _ready() -> void:
	super._ready()
	match DisplayServer.window_get_vsync_mode():
		DisplayServer.VSYNC_ENABLED:
			$VBoxContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/OptionControl.set_value(0)
		DisplayServer.VSYNC_DISABLED:
			$VBoxContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/OptionControl.set_value(1)
	


func _process(delta: float) -> void:
	super._process(delta)


func on_menu_select_pressed():
	if currently_open_id == -1:
		match currently_selected:
			0:
				options_container.get_children()[1].get_highlight_panel().add_theme_stylebox_override("panel", slider_select_theme_override)
				currently_open_id = 1
				options_container.get_children()[1].visible = true
				options_container.get_children()[1].display_options()
				is_selecting = true
			1:
				play_outro()
				await outro_finished
				switch_to_previous_scene()
			2:
				play_outro()
				await outro_finished
				switch_to_previous_scene()
	else:
		remove_select_themes()


func on_mouse_menu_select_pressed():
	if currently_open_id == -1:
		match currently_selected:
			0:
				options_container.get_children()[1].get_highlight_panel().add_theme_stylebox_override("panel", slider_select_theme_override)
				currently_open_id = 1
				options_container.get_children()[1].visible = true
				is_selecting = true
			1:
				play_outro()
				await outro_finished
				switch_to_previous_scene()
			2:
				play_outro()
				await outro_finished
				switch_to_previous_scene()
	elif not is_selecting and not options_container.get_children()[currently_open_id].is_hovered():
		remove_select_themes()


func check_menu_inputs():
	if not options_container.get_children()[currently_open_id] is OptionContainer:
		if Input.is_action_just_pressed("menu_down") and currently_selected < get_visible_children_of_type(options_container, Label).size() - 1:
			update_selection(currently_selected + 1)
			remove_select_themes()
		elif Input.is_action_just_pressed("menu_up") and currently_selected > 0:
			update_selection(currently_selected - 1)
			remove_select_themes()
	else:
		if Input.is_action_just_pressed("menu_down"):
			var node = options_container.get_children()[currently_open_id]
			if node is OptionContainer:
				node.increment()
				if currently_open_id == 1:
					update_vsync(node)
		elif Input.is_action_just_pressed("menu_up"):
			var node = options_container.get_children()[currently_open_id]
			if node is OptionContainer:
				node.decrement()
				if currently_open_id == 1:
					update_vsync(node)
	


func remove_select_themes():
	if currently_open_id >= 0:
		options_container.get_children()[currently_open_id].hide_options()
		options_container.get_children()[currently_open_id].get_highlight_panel().remove_theme_stylebox_override("panel")
		options_container.get_children()[currently_open_id].visible = false
		currently_open_id = -1


func update_vsync(node:OptionContainer):
	match node.get_value():
		0:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		1:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	
	Globals.write_config("preferences.cfg", "GraphicsSettings", "vsync_mode", node.get_value())


func _on_option_control_item_selected(node: OptionContainer) -> void:
	remove_select_themes()
