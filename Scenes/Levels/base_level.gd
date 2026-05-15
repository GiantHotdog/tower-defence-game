class_name BaseLevel
extends Node2D


@onready var spawn_timer:Timer = $SpawnTimer
@onready var enemy_scene:PackedScene = load("res://Scenes/Enemies/base_enemy.tscn")
@onready var tower_map:TileMapLayer = $TowerLayer
@onready var tower_info:TowerInfo = $UI/TowerInfoDisplay

var is_tower_info_open:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Globals.is_wave_running:
		if spawn_timer.time_left == 0:
			spawn_timer.start()
		if Input.is_action_just_pressed("select_tower"):
			var local_click_pos: Vector2 = get_local_mouse_position()
			var clicked_cell: Vector2i = tower_map.local_to_map(local_click_pos)
			var scene_node: Node = get_scene_node_at_cell(clicked_cell)
			if scene_node:
				tower_info.tower_selected.emit(scene_node, self)
			elif Input.is_action_just_pressed("place_tower") and not is_tower_info_open:
				tower_map.set_cell(clicked_cell, 0, Vector2i(0, 0), 1)
	else:
		spawn_timer.stop()

func _on_spawn_timer_timeout() -> void:
	var enemy = enemy_scene.instantiate()
	$EnemyPath.add_child(enemy)


func get_scene_node_at_cell(cell_coords: Vector2i) -> Node:
	for child in tower_map.get_children():
		var child_cell: Vector2i = tower_map.local_to_map(child.position)
		if child_cell == cell_coords:
			return child
	return null
