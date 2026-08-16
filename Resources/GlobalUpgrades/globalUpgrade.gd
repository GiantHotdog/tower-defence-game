class_name GlobalUpgrade
extends Resource

enum ValidIds { NULL, XP_GAIN_10_PC_INCREASE, XP_GAIN_20_PC_INCREASE, SIGTERM_COOLDOWN_10_PC_DECREASE}
enum UpgradeClass { NULL, XP_GAIN, SIGTERM_COOLDOWN}

## The upgrade's id, used for comparison between upgrades
@export var id:ValidIds = ValidIds.NULL

@export var upgradeClass:UpgradeClass = UpgradeClass.NULL
## The upgrade's name
@export var name:String = ""
## The upgrade's description (shown on hover)
@export_multiline var description:String = ""

## The cost in levels to unlock this upgrade
@export var cost:int = 1
## The maximum times this upgrade can be applied
@export var max_level:int = 1
## The current level of this upgrade
@export var current_level:int = 0

## The upgrades that have to be unlocked for this to be available
@export var prerequisites:Array[GlobalUpgrade]


func is_unlocked() -> bool:
	return current_level > 0


func can_unlock() -> bool:
	for prerequisite in prerequisites:
		if not prerequisite.is_unlocked():
			return false
	return is_below_max_level()


func is_below_max_level():
	return current_level < max_level


func unlock():
	current_level += 1
