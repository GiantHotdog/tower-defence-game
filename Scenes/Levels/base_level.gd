class_name BaseLevel
extends Node2D

signal wave_complete(wave_number:int)

## The wave info - the number being the wave, the WaveInfo resource being the spawning delay and number 
@export var wave_info_dict:Dictionary[int, WaveInfo] = {}
## The amount of currency allocated at the start of the level
@export var starting_currency:int = 0
## Is this the tutorial level
@export var is_tutorial = false

## The level ID, used to track if this level has been created
@export var level_id:int

@onready var base_enemy_scene:PackedScene = load("res://Scenes/Enemies/base_enemy.tscn")
@onready var weak_enemy_scene:PackedScene  = load("res://Scenes/Enemies/weak_enemy.tscn")
@onready var zip_bomb_enemy_scene:PackedScene = load("res://Scenes/Enemies/zip_bomb.tscn")

@onready var tower_map:TileMapLayer = $TowerLayer
@onready var place_assist_map:TileMapLayer = $PlacementAssistLayer
@onready var tower_info:TowerInfo = $UI/TowerInfoDisplay
@onready var path_revealer:PathRevealer = $EnemyPath/PathRevealer
@onready var enemy_path:Path2D = $EnemyPath
@onready var path_line:Line2D = $EnemyPath/VisualPath
@onready var ui:UI = $UI

var is_tower_info_open:bool = false
var enemies_in_current_wave:int = 0
var enemies_in_current_wave_killed:int = 0
var is_all_enemies_spawned:bool = false
var wave_info:WaveInfo

var towers_placed = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.current_wave_number = 0
	Globals.health = 100
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
	update_place_assist()
	modulate_path()
	if enemies_in_current_wave == enemies_in_current_wave_killed and is_all_enemies_spawned and Globals.is_wave_running:
		Globals.is_wave_running = false
		if Globals.current_wave_number == wave_info_dict.size():
			Globals.is_level_complete = true
			Globals.levels_complete[level_id] = true
		wave_complete.emit(wave_info_dict.find_key(wave_info))
		Globals.currency += wave_info.wave_finish_currency_reward
		wave_info = null
	
	if Globals.health <= 0:
		Globals.health = 0


func _unhandled_input(_event: InputEvent) -> void:
	if not Globals.is_level_complete:
		if Input.is_action_just_pressed("select_tower"):
			var local_click_pos: Vector2 = get_local_mouse_position()
			var clicked_cell: Vector2i = tower_map.local_to_map(tower_map.to_local(local_click_pos))
			var scene_node: Node = get_scene_node_at_cell(clicked_cell, tower_map)
			if scene_node:
				if Globals.placing == 0 and Globals.is_inspector_enabled and not scene_node is TowerBlocker:
					tower_info.tower_selected.emit(scene_node, self)
				elif Globals.placing != 0:
					ui.add_error("Cannot init process - memory location occupied")
			elif Input.is_action_just_pressed("place_tower") and can_place_tower(clicked_cell, true):
				var tower_name:String = BaseTower.TowerTypes.keys()[Globals.placing]
				var cost = BaseTower.TowerCosts[tower_name]
				
				if Globals.currency - cost >= 0:
					Globals.currency -= cost
					# Since the enum of towers and the tileset of towers align, we can just pass the enum in directly
					tower_map.set_cell(clicked_cell, 0, Vector2i(0, 0), Globals.placing)
					if Globals.placing:
						towers_placed += 1
				else:
					ui.add_error("Cannot init process - out of memory error")
			elif can_close_inspector():
				tower_info.tower_deselected.emit()


## This always returns true, so exists to be overridden by child classes
func can_close_inspector() -> bool:
	return true


func get_total_wave_count():
	return wave_info_dict.size()


func _on_enemy_reached_end_of_path(enemy_pid:int, enemy_damage:int):
	enemies_in_current_wave_killed += 1
	ui.add_error("Kernel corrupted [color=#ff00ff][PID: %d][/color][color=red][kernel health: %d%%][/color]" % [enemy_pid, Globals.health])


func update_place_assist():
	place_assist_map.clear()
	var mouse_pos:Vector2 = get_local_mouse_position()
	var cell:Vector2i = place_assist_map.local_to_map(place_assist_map.to_local(mouse_pos))
	place_assist_map.set_cell(cell, 0, Vector2i(0, 0), Globals.placing)
	#if can_place_tower(cell):
		#place_assist_map.modulate = Color(0, 3 , 0, .5)
	#else:
		#place_assist_map.modulate = Color(1, 1, 1, .5)


func can_place_tower(tower_pos:Vector2i, write_to_log:bool = false) -> bool:
	var node_at_pos: Node = get_scene_node_at_cell(tower_pos, tower_map)
	if node_at_pos:
		if write_to_log:
			ui.add_error("Cannot init process - memory location occupied")
		return false
	if is_tower_info_open:
		return false
	
	return true


func modulate_path():
	var time = Time.get_ticks_msec() / 1000.0
	path_line.modulate.a = 0.5 + sin(time * 4.0) * 0.15


func get_scene_node_at_cell(cell_coords: Vector2i, tilemap:TileMapLayer) -> Node:
	for child in tilemap.get_children():
		var child_cell: Vector2i = tilemap.local_to_map(child.position)
		if child_cell == cell_coords:
			return child
	return null


func _on_enemy_killed(enemy_pid:int):
	enemies_in_current_wave_killed += 1
	ui.add_log("Malware process [color=#ff00ff][PID: %s][/color] terminated" % enemy_pid)


func add_enemy(enemy:BaseEnemy.ENEMY_TYPES, modifiers:Dictionary[String, Variant] = {}) -> BaseEnemy:
	enemies_in_current_wave += 1
	var spawning:BaseEnemy = null
	match enemy:
		BaseEnemy.ENEMY_TYPES.BASE_ENEMY:
			spawning = base_enemy_scene.instantiate()
		BaseEnemy.ENEMY_TYPES.WEAK_ENEMY:
			spawning = weak_enemy_scene.instantiate()
		BaseEnemy.ENEMY_TYPES.ZIP_BOMB_ENEMY:
			spawning = zip_bomb_enemy_scene.instantiate()
			spawning.children_add.connect(_on_zip_bomb_enemy_children_add)
	if spawning:
		# Apply modifiers
		if "cloak" in modifiers.keys():
			spawning.is_cloaked = modifiers["cloak"]
		
		spawning.enemy_killed.connect(_on_enemy_killed)
		spawning.reached_end_of_path.connect(_on_enemy_reached_end_of_path)
		enemy_path.add_child(spawning)
	return spawning


func _on_zip_bomb_enemy_children_add(count:int, type:BaseEnemy.ENEMY_TYPES, parent_progress:float):
	for i in range(count):
		var rand_offset = randi_range(-120, 120)
		var child:BaseEnemy = add_enemy(type)
		child.progress = parent_progress + rand_offset


func _on_wave_started(number: int) -> void:
	ui.add_warning("Malware incursion [number %s] detected" % number)
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


func get_ui():
	return ui
