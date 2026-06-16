class_name UI
extends CanvasLayer

signal wave_started(number:int)
signal set_placing(tower_type:BaseTower.TowerTypes)


@onready var start_wave_container:Container = $PanelContainer/VBoxContainer/PanelContainer/HBoxContainer/StartWave
@onready var level_complete:Control = $LevelComplete
@onready var build_button:Control = $PanelContainer/VBoxContainer/PanelContainer/HBoxContainer/Build
@onready var tower_place_menu:TowerPlaceMenu = $TowerPlaceMenu
@onready var stop_build_button:Control = $PanelContainer/VBoxContainer/PanelContainer/HBoxContainer/StopBuild
@onready var currency_label:Label = $Currency/PanelContainer/Label
@onready var tower_info_display:Control = $TowerInfoDisplay
@onready var level_lost:Control = $LevelLost
@onready var terminal:TerminalLog = $PanelContainer/VBoxContainer/TerminalLog

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#start_wave_container.visible = not (Globals.is_wave_running or Globals.is_level_complete) and Globals.placing == 0 and not tower_place_menu.visible and Globals.is_start_wave_enabled
	level_complete.visible = Globals.is_level_complete and not level_lost.visible
	level_lost.visible = Globals.health <= 0
	build_button.visible = Globals.placing == 0 and not tower_place_menu.visible
	stop_build_button.visible = Globals.placing != 0 or tower_place_menu.visible
	
	currency_label.text = "Available Memory: " + str(Globals.currency) + "MB"


func _on_button_pressed() -> void:
	Globals.current_wave_number += 1
	Globals.is_wave_running = true
	wave_started.emit(Globals.current_wave_number)


func _on_placing_set(tower_type:BaseTower.TowerTypes):
	set_placing.emit(tower_type)


func _on_build_button_pressed() -> void:
	tower_place_menu.visible = true


func _on_stop_build_button_pressed() -> void:
	tower_place_menu.cancel_place()
	tower_place_menu.visible = not tower_place_menu.visible


func game_over():
	$LevelLost.refresh_message()


func add_log(message:String) -> void:
	terminal.add_log(message)


func add_warning(message:String) -> void:
	terminal.add_warning(message)


func add_error(message:String):
	terminal.add_error(message)


func _on_system_log_pressed() -> void:
	terminal.visible = not terminal.visible
