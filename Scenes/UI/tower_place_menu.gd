extends Control


signal set_placing(tower_type:BaseTower.TowerTypes)

func _on_placing_set(tower_type:BaseTower.TowerTypes):
	set_placing.emit(tower_type)


func _on_close_button_pressed() -> void:
	visible = false
	Globals.placing = 0
