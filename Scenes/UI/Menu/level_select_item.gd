class_name LevelSelectItem
extends Control

@export var scene_path:String = ""

@export var texture:Texture2D:
	set(value):
		texture = value
		$VBoxContainer/TextureButton.texture = value
		
@export var level_name:String:
	set(value):
		level_name = value
		$VBoxContainer/Label.text = value

@export var is_locked:bool = true


func _ready() -> void:
	$TextureRect.visible = is_locked


func _on_texture_button_pressed() -> void:
	if not is_locked:
		get_tree().change_scene_to_file(scene_path)
