@tool
extends VBoxContainer

## The name of the tower (displayed under the button)
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

@export var cost:int = 10:
	set(value):
		cost = value
		if not Engine.is_editor_hint():
			$Label2.text = str(Globals.currency) + " / " + str(value)
		else:
			$Label2.text =  "10 / " + str(value)

@export var tower:BaseTower.TowerTypes = BaseTower.TowerTypes.NONE

signal set_placing(tower_type:BaseTower.TowerTypes)


func _on_place_button_pressed() -> void:
	set_placing.emit(tower)

func _process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		$Label2.text = str(Globals.currency) + " / " + str(cost)
		$Label2.modulate = Color(0, 1, 0) if Globals.currency >= cost else Color(1, 0, 0)
