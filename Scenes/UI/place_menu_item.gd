@tool
extends VBoxContainer

@export var tower_name:String = "Base Tower":
	set(value):
		tower_name = value
		$Label.text = value

@export var tower_icon:Texture2D:
	set(value):
		tower_icon = value
		$PlaceButton.texture_normal = value

@export var tower_color:Color = Color(1, 1, 1):
	set(value):
		tower_color = value
		$PlaceButton.modulate = value

@export var tower:BaseTower.TowerTypes = BaseTower.TowerTypes.NONE

signal set_placing(tower_type:BaseTower.TowerTypes)


func _on_place_button_pressed() -> void:
	set_placing.emit(tower)
