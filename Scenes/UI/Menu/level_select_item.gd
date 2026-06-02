class_name LevelSelectItem
extends VBoxContainer

@export var scene_path:String = ""

@export var texture:Texture2D:
	set(value):
		texture = value
		$TextureButton.texture = value
		
@export var level_name:String:
	set(value):
		level_name = value
		$Label.text = value


func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file(scene_path)
