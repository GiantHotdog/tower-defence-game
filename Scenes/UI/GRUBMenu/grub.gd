extends Control

signal outro_finished


var currently_selected:int = 0
var select_theme_override:StyleBoxFlat

@onready var options_container:VBoxContainer = $VBoxContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	select_theme_override = StyleBoxFlat.new()
	select_theme_override.bg_color = Color.WHITE
	update_selection(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("menu_down") and currently_selected < options_container.get_child_count() - 1:
		update_selection(currently_selected + 1)
	elif Input.is_action_just_pressed("menu_up") and currently_selected > 0:
		update_selection(currently_selected - 1)
	
	if Input.is_action_just_pressed("menu_select"):
		match currently_selected:
			0:
				play_outro()
				await outro_finished
				get_tree().change_scene_to_file("res://Scenes/UI/GRUBMenu/new_menu.tscn")
			2:
				play_outro()
				await outro_finished
				get_tree().quit()


func update_selection(new_selection:int):
	var previous_select_node:Label = options_container.get_child(currently_selected)
	previous_select_node.remove_theme_stylebox_override("normal")
	previous_select_node.add_theme_color_override("font_color", Color(1,1,1))
	currently_selected = new_selection
	var current_select_node:Label = options_container.get_child(currently_selected)
	current_select_node.add_theme_stylebox_override("normal", select_theme_override)
	current_select_node.add_theme_color_override("font_color", Color(0,0,0))

func play_outro():
	var tween = get_tree().create_tween()
	tween.tween_property($ColorRect2, "custom_minimum_size", get_viewport_rect().size, .5)
	tween.tween_property($ColorRect2, "custom_minimum_size", get_viewport_rect().size, .25)
	await tween.finished
	outro_finished.emit()
