extends GRUB

@export_file("*.tscn") var levels:Array[String] = []
@export var names:Array[String] = []
@export var level_requirements:Array[int] = []

@onready var item:PackedScene = load("res://Scenes/UI/GRUBMenu/grub_level_menu_item.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	for i:int in levels.size():
		var label:GrubLevelMenuItem = item.instantiate()
		label.text = names[i]
		
		var required_level = level_requirements[i]
		if required_level == -1 or Globals.levels_complete[required_level]:
			label.is_locked = false
		
		options_container.add_child(label)
	
	
	select_theme_override = StyleBoxFlat.new()
	select_theme_override.bg_color = Color.WHITE
	update_selection(0)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN
	
	if event is InputEventMouseMotion:
		var node:Control = get_viewport().gui_get_hovered_control()
		if node is Label:
			var id = get_filtered_index(node.get_parent(), GrubLevelMenuItem)
			update_selection(id)
		else:
			update_selection(-1)


func check_menu_inputs():
	if (Input.is_action_just_pressed("menu_down") or Input.is_action_just_pressed("menu_up")) and currently_selected < 0:
		update_selection(last_selected)
	elif Input.is_action_just_pressed("menu_down") and currently_selected < get_visible_children_of_type(options_container, GrubLevelMenuItem).size() - 1:
		update_selection(currently_selected + 1)
	elif Input.is_action_just_pressed("menu_up") and currently_selected > 0:
		update_selection(currently_selected - 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	check_menu_inputs()
	
	if Input.is_action_just_pressed("menu_select"):
		on_menu_select_pressed()
	if Input.is_action_just_pressed("menu_select_mouse"):
		var node:Control = get_viewport().gui_get_hovered_control()
		if node is Label:
			var id = get_filtered_index(node.get_parent(), GrubLevelMenuItem)
			update_selection(id)
		else:
			update_selection(-1)
		on_mouse_menu_select_pressed()
	
	if Input.is_action_just_pressed("menu_back"):
		switch_to_previous_scene()


func on_menu_select_pressed():
	if currently_selected >= 0:
		var child:GrubLevelMenuItem = options_container.get_child(currently_selected)
		if not child.is_locked:
			var new_level = levels[currently_selected]
			play_outro()
			await outro_finished
			get_tree().change_scene_to_file(new_level)


func on_mouse_menu_select_pressed():
	on_menu_select_pressed()


func update_selection(new_selection:int):
	var children:Array = get_visible_children_of_type(options_container, GrubLevelMenuItem)
	if children.size() > 0:
		var previous_select_node:GrubLevelMenuItem = children[last_selected]
		previous_select_node.get_label().remove_theme_stylebox_override("normal")
		previous_select_node.get_label().add_theme_color_override("font_color", Color(1,1,1))
		currently_selected = new_selection
		if currently_selected >= 0:
			var current_select_node:Control = get_visible_children_of_type(options_container, GrubLevelMenuItem)[currently_selected]
			if current_select_node is GrubLevelMenuItem:
				current_select_node.get_label().add_theme_stylebox_override("normal", select_theme_override)
				current_select_node.get_label().add_theme_color_override("font_color", Color(0,0,0))
			last_selected = currently_selected

func play_outro():
	var tween = get_tree().create_tween()
	tween.tween_property($ColorRect2, "custom_minimum_size", get_viewport_rect().size, .5)
	tween.tween_property($ColorRect2, "custom_minimum_size", get_viewport_rect().size, .25)
	await tween.finished
	outro_finished.emit()
