class_name GRUB
extends Control

signal outro_finished

@export_file("*.tscn") var back_level:String

var currently_selected:int = 0
var select_theme_override:StyleBoxFlat
var slider_select_theme_override:StyleBoxFlat

@onready var options_container:VBoxContainer = $VBoxContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	select_theme_override = StyleBoxFlat.new()
	select_theme_override.bg_color = Color.WHITE
	
	slider_select_theme_override = StyleBoxFlat.new()
	slider_select_theme_override.border_color = Color(0.8, 0.8, 0.8)
	slider_select_theme_override.draw_center = false
	slider_select_theme_override.set_border_width_all(4)
	slider_select_theme_override.set_corner_radius_all(4)
	update_selection(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	check_menu_inputs()
	
	if Input.is_action_just_pressed("menu_select"):
		on_menu_select_pressed()
	
	if Input.is_action_just_pressed("menu_back"):
		switch_to_previous_scene()


func check_menu_inputs():
	if Input.is_action_just_pressed("menu_down") and currently_selected < get_visible_children_of_type(options_container, Label).size() - 1:
		update_selection(currently_selected + 1)
	elif Input.is_action_just_pressed("menu_up") and currently_selected > 0:
		update_selection(currently_selected - 1)


func switch_to_previous_scene():
	if back_level:
		play_outro()
		await outro_finished
		get_tree().change_scene_to_file(back_level)


func on_menu_select_pressed():
	match currently_selected:
		0:
			play_outro()
			await outro_finished
			get_tree().change_scene_to_file("res://Scenes/UI/GRUBMenu/new_menu.tscn")
		1:
			play_outro()
			await outro_finished
			get_tree().change_scene_to_file("res://Scenes/UI/GRUBMenu/Settings/settings.tscn")
		2:
			play_outro()
			await outro_finished
			get_tree().quit()


func get_visible_children_of_type(node:Node, type: Variant) -> Array:
	var matching_children: Array = []
	for child in node.get_children():
		if is_instance_of(child, type) and child.visible:
			matching_children.append(child)
	return matching_children


func update_selection(new_selection:int):
	var previous_select_node:Control = get_visible_children_of_type(options_container, Label)[currently_selected]
	previous_select_node.remove_theme_stylebox_override("normal")
	previous_select_node.add_theme_color_override("font_color", Color(1,1,1))
	currently_selected = new_selection
	var current_select_node:Control = get_visible_children_of_type(options_container, Label)[currently_selected]
	if current_select_node is Label:
		current_select_node.add_theme_stylebox_override("normal", select_theme_override)
		current_select_node.add_theme_color_override("font_color", Color(0,0,0))

func play_outro():
	var tween = get_tree().create_tween()
	tween.tween_property($ColorRect2, "custom_minimum_size", get_viewport_rect().size, .5)
	tween.tween_property($ColorRect2, "custom_minimum_size", get_viewport_rect().size, .25)
	await tween.finished
	outro_finished.emit()
