class_name TowerPlaceMenu
extends Control


signal set_placing(tower_type:BaseTower.TowerTypes)

func _on_placing_set(tower_type:BaseTower.TowerTypes):
	set_placing.emit(tower_type)
	visible = false


func _on_close_button_pressed() -> void:
	close()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("cancel_place"):
		if Globals.placing != BaseTower.TowerTypes.NONE:
			cancel_place()
		else:
			_on_close_button_pressed()


func close():
	visible = false
	Globals.placing = BaseTower.TowerTypes.NONE


func cancel_place():
	visible = true
	Globals.placing = BaseTower.TowerTypes.NONE
