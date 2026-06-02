class_name BaseLevel
extends Node2D

## The wave info - the number being the wave, the WaveInfo resource being the spawning delay and number 
@export var wave_info_dict:Dictionary[int, WaveInfo] = {}
## The amount of currency allocated at the start of the level
@export var starting_currency:int = 0
## Is this the tutorial level
@export var is_tutorial = false

@onready var base_enemy_scene:PackedScene = load("res://Scenes/Enemies/base_enemy.tscn")
@onready var weak_enemy_scene:PackedScene  = load("res://Scenes/Enemies/weak_enemy.tscn")

@onready var tower_map:TileMapLayer = $MapContainer/TowerLayer
@onready var tower_map_container:Node2D = $MapContainer
@onready var tower_info:TowerInfo = $UI/TowerInfoDisplay
@onready var path_revealer:PathRevealer = $EnemyPath/PathRevealer
@onready var enemy_path:Path2D = $EnemyPath
@onready var path_line:Line2D = $EnemyPath/VisualPath

var is_tower_info_open:bool = false
var enemies_in_current_wave:int = 0
var enemies_in_current_wave_killed:int = 0
var is_all_enemies_spawned:bool = false
var wave_info:WaveInfo

var towers_placed = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.is_level_complete = false
	path_line.clear_points()
	enemy_path.curve.bake_interval = 100
	path_line.points = enemy_path.curve.get_baked_points()
	path_line.antialiased = true
	Globals.currency = starting_currency
	if not is_tutorial:
		Globals.reset_selective_disable_variables()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	modulate_path()
	if enemies_in_current_wave == enemies_in_current_wave_killed and is_all_enemies_spawned and Globals.is_wave_running:
		Globals.is_wave_running = false
		if Globals.current_wave_number == wave_info_dict.size():
			Globals.is_level_complete = true
		Globals.currency += wave_info.wave_finish_currency_reward
		wave_info = null


func _unhandled_input(_event: InputEvent) -> void:
	if not Globals.is_level_complete:
		if Input.is_action_just_pressed("select_tower"):
			var local_click_pos: Vector2 = get_local_mouse_position()
			var clicked_cell: Vector2i = tower_map.local_to_map(tower_map.to_local(local_click_pos))
			var scene_node: Node = get_scene_node_at_cell(clicked_cell)
			if scene_node:
				if Globals.placing == 0:
					tower_info.tower_selected.emit(scene_node, self)
			elif Input.is_action_just_pressed("place_tower") and not is_tower_info_open:
				var tower_name:String = BaseTower.TowerTypes.keys()[Globals.placing]
				var cost = BaseTower.TowerCosts[tower_name]
				if Globals.currency - cost >= 0:
					Globals.currency -= cost
					# Since the enum of towers and the tileset of towers align, we can just pass the enum in directly
					tower_map.set_cell(clicked_cell, 0, Vector2i(0, 0), Globals.placing)					
					towers_placed += 1
			else:
				tower_info.tower_deselected.emit()


func modulate_path():
	var time = Time.get_ticks_msec() / 1000.0
	# Oscillates alpha smoothly between 0.5 and 0.7
	path_line.modulate.a = 0.5 + sin(time * 4.0) * 0.15


func get_scene_node_at_cell(cell_coords: Vector2i) -> Node:
	for child in tower_map.get_children():
		var child_cell: Vector2i = tower_map.local_to_map(child.position)
		if child_cell == cell_coords:
			return child
	return null


func _on_enemy_killed():
	enemies_in_current_wave_killed += 1


func add_enemy(enemy:BaseEnemy.ENEMY_TYPES):
	enemies_in_current_wave += 1
	match enemy:
		BaseEnemy.ENEMY_TYPES.BASE_ENEMY:
			var spawning:BaseEnemy = base_enemy_scene.instantiate()
			spawning.enemy_killed.connect(_on_enemy_killed)
			enemy_path.add_child(spawning)
		BaseEnemy.ENEMY_TYPES.WEAK_ENEMY:
			var spawning:BaseEnemy = weak_enemy_scene.instantiate()
			spawning.enemy_killed.connect(_on_enemy_killed)
			enemy_path.add_child(spawning)


func _on_wave_started(number: int) -> void:
	wave_info = wave_info_dict[number]
	enemies_in_current_wave = 0
	enemies_in_current_wave_killed = 0
	is_all_enemies_spawned = false
	wave_info.all_enemies_spawned.connect(_all_enemies_spawned)
	wave_info.start_wave(self)

func _all_enemies_spawned():
	is_all_enemies_spawned = true


func _on_placing_set(tower_type:BaseTower.TowerTypes):
	Globals.placing = tower_type
