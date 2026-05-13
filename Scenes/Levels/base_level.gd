extends Node2D


@onready var spawn_timer:Timer = $SpawnTimer

@onready var enemy_scene:PackedScene = load("res://Scenes/Enemies/base_enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_spawn_timer_timeout() -> void:
	var enemy = enemy_scene.instantiate()
	#$EnemyPath.add_child(enemy)
