extends Control

signal outro_finished

@export_file("*.tscn") var levels:Array[String] = []
@export var names:Array[String] = []
@export var level_requirements:Array[int] = []

var currently_selected:int = 0
var select_theme_override:StyleBoxFlat

@onready var options_container:VBoxContainer = $VBoxContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer
@onready var item:PackedScene = load("res://Scenes/UI/GRUBMenu/grub_level_menu_item.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("menu_back"):
		play_outro()
		await outro_finished
		if is_inside_tree():
			get_tree().change_scene_to_file("res://Scenes/UI/GRUBMenu/Grub.tscn")
	
	if Input.is_action_just_pressed("menu_down") and currently_selected < options_container.get_child_count() - 1:
		update_selection(currently_selected + 1)
	elif Input.is_action_just_pressed("menu_up") and currently_selected > 0:
		update_selection(currently_selected - 1)
	
	if Input.is_action_just_pressed("menu_select"):
		var child:GrubLevelMenuItem = options_container.get_child(currently_selected)
		if not child.is_locked:
			play_outro()
			await outro_finished
			get_tree().change_scene_to_file(levels[currently_selected])


func update_selection(new_selection:int):
	var previous_select_node:GrubLevelMenuItem = options_container.get_child(currently_selected)
	var label = previous_select_node.get_label()
	label.remove_theme_stylebox_override("normal")
	label.add_theme_color_override("font_color", Color(1,1,1))
	currently_selected = new_selection
	var current_select_node:GrubLevelMenuItem = options_container.get_child(currently_selected)
	var new_label = current_select_node.get_label()
	new_label.add_theme_stylebox_override("normal", select_theme_override)
	new_label.add_theme_color_override("font_color", Color(0,0,0))

func play_outro():
	var tween = get_tree().create_tween()
	tween.tween_property($ColorRect2, "custom_minimum_size", get_viewport_rect().size, .5)
	tween.tween_property($ColorRect2, "custom_minimum_size", get_viewport_rect().size, .25)
	await tween.finished
	outro_finished.emit()
