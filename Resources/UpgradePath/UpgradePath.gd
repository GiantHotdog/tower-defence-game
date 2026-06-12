class_name UpgradePath
extends Resource

@export var upgrades:Array[Upgrade]

var current_upgrade:int = 0


func get_next_upgrade() -> Upgrade:
	var returning = null
	if not is_path_finished():
		returning = upgrades[current_upgrade]
		current_upgrade += 1
	return returning


func get_next_upgrade_description() -> String:
	var returning = ""
	if not is_path_finished():
		returning = upgrades[current_upgrade].description
	return returning


func is_path_finished() -> bool:
	return current_upgrade >= get_upgrade_count()


func get_upgrade_count() -> int:
	return upgrades.size()


func get_current_upgrade_count() -> int:
	return current_upgrade


func get_next_upgrade_cost() -> int:
	if not is_path_finished():
		return upgrades[current_upgrade].cost
	else:
		return -1
