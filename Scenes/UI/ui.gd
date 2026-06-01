extends CanvasLayer

signal wave_started(number:int)
signal set_placing(tower_type:BaseTower.TowerTypes)


@onready var start_wave_container:Container = $StartWave
@onready var level_complete:Control = $LevelComplete
@onready var build_button:Control = $Build
@onready var tower_place_menu:TowerPlaceMenu = $TowerPlaceMenu
@onready var stop_build_button:Control = $StopBuild
@onready var currency_label:Label = $Currency/PanelContainer/Label
@onready var tower_info_display:Control = $TowerInfoDisplay

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	start_wave_container.visible = not (Globals.is_wave_running or Globals.is_level_complete) and Globals.placing == 0 and not tower_place_menu.visible and Globals.is_start_wave_enabled
	level_complete.visible = Globals.is_level_complete
	build_button.visible = not tower_place_menu.visible and Globals.placing == 0 and not Globals.is_wave_running and not Globals.is_level_complete and not tower_info_display.visible
	stop_build_button.visible = Globals.placing != 0
	
	currency_label.text = "Currency: " + str(Globals.currency)


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
