extends Node


var is_wave_running:bool = false
var current_wave_number:int = 0
var is_level_complete:bool = false

var placing:BaseTower.TowerTypes = BaseTower.TowerTypes.NONE

func set_placing(tower_type:BaseTower.TowerTypes):
	placing = tower_type
