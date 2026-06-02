extends Node


var is_wave_running:bool = false
var current_wave_number:int = 0
var is_level_complete:bool = false

var placing:BaseTower.TowerTypes = BaseTower.TowerTypes.NONE

var currency:int = 0

# This set of variables are used to selectively disable parts of the game,
# likely for tutorial purposes

var is_upgrades_enabled = true
var is_start_wave_enabled = true
var is_inspector_enabled = true


func set_placing(tower_type:BaseTower.TowerTypes):
	placing = tower_type


func reset_selective_disable_variables():
	is_start_wave_enabled = true
	is_inspector_enabled = true
	is_upgrades_enabled = true
