extends Node


var is_wave_running:bool = false
var current_wave_number:int = 0
var is_level_complete:bool = false

var placing:BaseTower.TowerTypes = BaseTower.TowerTypes.NONE

var currency:int = 0

var health = 100

var levels_complete:Array[bool] = [false, false, false, false]

# This set of variables are used to selectively disable parts of the game,
# likely for tutorial purposes

var is_upgrades_enabled = true
var is_start_wave_enabled = true
var is_inspector_enabled = true


func _ready() -> void:
	load_config("preferences.cfg")


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
