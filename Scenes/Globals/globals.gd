extends Node


var is_wave_running:bool = false
var current_wave_number:int = 0
var is_level_complete:bool = false

var placing:BaseTower.TowerTypes = BaseTower.TowerTypes.NONE

var currency:int = 0

var health = 100

var levels_complete:Array[bool] = [false, false, false, false]


var _experience:int = 0
var initial_level_experience_requirement:int = 20
var level_experience_requirement_multiplier:float = 1.2


# This set of variables are used to selectively disable parts of the game,
# likely for tutorial purposes

var is_upgrades_enabled = true
var is_start_wave_enabled = true
var is_inspector_enabled = true

var version:String = "0.0.0-DEV-BUILD"

var global_upgrades:ConfigFile

func _ready() -> void:
	if FileAccess.file_exists("version.txt"):
		var file = FileAccess.open("version.txt", FileAccess.READ)
		version = file.get_as_text()
		file.close()
	load_config("preferences.cfg")
	load_global_upgrades()
	#for xp in range(100):
		#print("XP:%d, Level:%d, XP gained within level:%d out of %d required" % [xp, calculate_level(xp), calculate_experience_within_level(calculate_level(xp), xp), calculate_experience_required_for_level_up(calculate_level(xp))])


func set_placing(tower_type:BaseTower.TowerTypes):
	placing = tower_type


func reset_selective_disable_variables():
	is_start_wave_enabled = true
	is_inspector_enabled = true
	is_upgrades_enabled = true


func load_config(filepath:String):
	var config:ConfigFile = get_config(filepath)
	var master_audio_volume = config.get_value("AudioSettings", "master_audio", 5)
	GlobalAudio.set_volume(master_audio_volume)
	var vsync = config.get_value("GraphicsSettings", "vsync_mode", 0)
	match vsync:
		0:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		1:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)


func load_global_upgrades(filepath:String = "global_upgrades.cfg"):
	global_upgrades = get_global_upgrades(filepath)
	_experience = global_upgrades.get_value("Experience", "Value", 0)


func get_global_upgrade_tier(upgrade_id:GlobalUpgrade.ValidIds) -> int:
	if global_upgrades:
		return global_upgrades.get_value("Upgrades", GlobalUpgrade.ValidIds.keys()[upgrade_id], 0)
	else:
		return 0


func set_global_upgrade_tier(upgrade_id:GlobalUpgrade.ValidIds, current_tier:int, filepath:String = "global_upgrades.cfg"):
	global_upgrades.set_value("Upgrades", GlobalUpgrade.ValidIds.keys()[upgrade_id], current_tier)
	global_upgrades.save("user://config/" + filepath)


func write_experience_gained_to_file(current_value:int, filepath:String = "global_upgrades.cfg"):
	global_upgrades.set_value("Experience", "Value", current_value)
	global_upgrades.save("user://config/" + filepath)


func get_config(filepath:String) -> ConfigFile:
	var dir = DirAccess.open("user://")
	if not dir.dir_exists("user://config/"):
		dir.make_dir_recursive("user://config/")
		
	var config:ConfigFile = ConfigFile.new()
	var err:Error = config.load("user://config/" + filepath)
	
	if err != OK:
		printerr("Error when loading configuration file: ", error_string(err))
	
	if err == ERR_FILE_NOT_FOUND:
		printerr("Creating default config file")
		# Initialise the default config
		config.set_value("AudioSettings", "master_audio", 5)
		config.set_value("GraphicsSettings", "vsync_mode", 0)
		config.save("user://config/" + filepath)
	
	config.load("user://config/" + filepath)
	return config


func write_config(filepath:String, section:String, key:String, value:Variant):
	var config:ConfigFile = get_config(filepath)
	config.set_value(section, key, value)
	config.save("user://config/" + filepath)


func get_global_upgrades(filepath:String = "global_upgrades.cfg") -> ConfigFile:
	var dir = DirAccess.open("user://")
	if not dir.dir_exists("user://config/"):
		dir.make_dir_recursive("user://config/")
		
	var global_upgrades_cfg:ConfigFile = ConfigFile.new()
	var err:Error = global_upgrades_cfg.load("user://config/" + filepath)
	
	if err != OK:
		printerr("Error when loading global upgrades file: ", error_string(err))
	
	if err == ERR_FILE_NOT_FOUND:
		printerr("Creating default global upgrades file")
		# Initialise the default config
		global_upgrades_cfg.set_value("Experience", "Value", 0)
		for key in GlobalUpgrade.ValidIds.keys():
			global_upgrades_cfg.set_value("Upgrades", key, false)
		global_upgrades_cfg.save("user://config/" + filepath)
	
	global_upgrades_cfg.load("user://config/" + filepath)
	return global_upgrades_cfg


func write_global_upgrades(filepath:String, section:String, key:String, value:Variant):
	var global_upgrades_cfg:ConfigFile = get_config(filepath)
	global_upgrades_cfg.set_value(section, key, value)
	global_upgrades_cfg.save("user://config/" + filepath)


func get_current_modifier_for(upgradeClass:GlobalUpgrade.UpgradeClass) -> float:
	if upgradeClass == GlobalUpgrade.UpgradeClass.XP_GAIN:
		return (
			1
			+ (0.1 * get_global_upgrade_tier(GlobalUpgrade.ValidIds.XP_GAIN_10_PC_INCREASE))
			+ (0.2 * get_global_upgrade_tier(GlobalUpgrade.ValidIds.XP_GAIN_20_PC_INCREASE))
		)
	elif upgradeClass == GlobalUpgrade.UpgradeClass.SIGTERM_COOLDOWN:
		return (
			1 
			- (0.1 * get_global_upgrade_tier(GlobalUpgrade.ValidIds.SIGTERM_COOLDOWN_10_PC_DECREASE))
		)
	elif upgradeClass == GlobalUpgrade.UpgradeClass.SIGTERM_RANGE:
		return (
			1 
			+ (0.15 * get_global_upgrade_tier(GlobalUpgrade.ValidIds.SIGTERM_RANGE_15_PC_INCREASE))
		)
	elif upgradeClass == GlobalUpgrade.UpgradeClass.LOGIC_GATE_COOLDOWN:
		return (
			1 
			- (0.2 * get_global_upgrade_tier(GlobalUpgrade.ValidIds.LOGIC_GATE_COOLDOWN_20_PC_DECREASE))
		)
	elif upgradeClass == GlobalUpgrade.UpgradeClass.LOGIC_GATE_RANGE:
		return (
			1 
			+ (0.1 * get_global_upgrade_tier(GlobalUpgrade.ValidIds.LOGIC_GATE_RANGE_10_PC_INCREASE))
		)
	return 1.0


func get_current_message_for(upgradeClass:GlobalUpgrade.UpgradeClass) -> String:
	if upgradeClass == GlobalUpgrade.UpgradeClass.XP_GAIN:
		return "x%.02f" % get_current_modifier_for(GlobalUpgrade.UpgradeClass.XP_GAIN)
	elif upgradeClass == GlobalUpgrade.UpgradeClass.SIGTERM_COOLDOWN:
		return "%.02f seconds" % (4 * get_current_modifier_for(GlobalUpgrade.UpgradeClass.SIGTERM_COOLDOWN))
	elif upgradeClass == GlobalUpgrade.UpgradeClass.SIGTERM_RANGE:
		return "%d px" % (1200 * get_current_modifier_for(GlobalUpgrade.UpgradeClass.SIGTERM_RANGE))
	elif upgradeClass == GlobalUpgrade.UpgradeClass.LOGIC_GATE_COOLDOWN:
		return "%.02f seconds" % (1 / 1.5 * get_current_modifier_for(GlobalUpgrade.UpgradeClass.LOGIC_GATE_COOLDOWN))
	elif upgradeClass == GlobalUpgrade.UpgradeClass.LOGIC_GATE_RANGE:
		return "%d px" % (480 * get_current_modifier_for(GlobalUpgrade.UpgradeClass.LOGIC_GATE_RANGE))
	return ""


func get_global_tower_upgrade_level(tower:BaseTower.TowerTypes, property:Upgrade.Properties) -> float:
	if tower == BaseTower.TowerTypes.SIGTERM:
		if property == Upgrade.Properties.ATTACK_SPEED:
			return 1.0 / get_current_modifier_for(GlobalUpgrade.UpgradeClass.SIGTERM_COOLDOWN)
		elif property == Upgrade.Properties.RANGE:
			return get_current_modifier_for(GlobalUpgrade.UpgradeClass.SIGTERM_RANGE)
	elif tower == BaseTower.TowerTypes.LOGIC_GATE:
		if property == Upgrade.Properties.ATTACK_SPEED:
			return 1.0 / get_current_modifier_for(GlobalUpgrade.UpgradeClass.LOGIC_GATE_COOLDOWN)
		elif property == Upgrade.Properties.RANGE:
			return get_current_modifier_for(GlobalUpgrade.UpgradeClass.LOGIC_GATE_RANGE)
	return 1.0


func add_experience(amount:int) -> void:
	_experience += amount


func set_experience(amount:int) -> void:
	_experience = amount
	write_experience_gained_to_file(amount)


func get_experience() -> int:
	return _experience


func calculate_level(current_experience:int = _experience) -> int:
	if current_experience <= 0:
		return 0
		
	var level: int = 0
	while current_experience >= calculate_experience_to_get_to_level(level + 1):
		level += 1
	return level


func calculate_experience_to_get_to_level(level:int = 0) -> int:
	if level <= 0:
		return 0
	
	if is_equal_approx(level_experience_requirement_multiplier, 1.0):
		return int(initial_level_experience_requirement * level)
	
	var sum = initial_level_experience_requirement * (pow(level_experience_requirement_multiplier, level) - 1) / (level_experience_requirement_multiplier - 1)
	return int(sum)


func calculate_experience_within_level(current_level:int = 0, current_experience:int = _experience) -> int:
	return current_experience - calculate_experience_to_get_to_level(current_level)
	

func calculate_experience_required_for_level_up(level:int):
	return initial_level_experience_requirement * pow(level_experience_requirement_multiplier, level)


func get_skill_points():
	return calculate_level()
