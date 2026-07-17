class_name WaveInfo
extends Resource

signal all_enemies_spawned

@export var enemy_info:Dictionary[BaseEnemy.ENEMY_TYPES, EnemySpawnerInfo] = {}
@export var wave_finish_currency_reward:int = 10

var enemy_spawn_timers:Dictionary[BaseEnemy.ENEMY_TYPES, Timer]
var enemy_spawn_counts:Dictionary[BaseEnemy.ENEMY_TYPES, int]
var timers_finished:int = 0

func start_wave(level:BaseLevel):
	for enemy in enemy_info:
		var timer:Timer = Timer.new()
		timer.wait_time = enemy_info[enemy].enemy_spawn_interval
		enemy_spawn_timers[enemy] = timer
		enemy_spawn_counts[enemy] = 0
		timer.timeout.connect(_on_spawn_timer_timeout.bind(enemy, level))
		level.add_child(timer)
		timer.start()
		
func _on_spawn_timer_timeout(enemy:BaseEnemy.ENEMY_TYPES, level:BaseLevel):
	var modifiers:Dictionary[String, Variant] = {}
	modifiers["cloak"] = enemy_info[enemy].is_cloaked
	modifiers["invulnerable"] = enemy_info[enemy].is_invulnerable
	level.add_enemy(enemy, modifiers)
	enemy_spawn_counts[enemy] += 1
	if enemy_spawn_counts[enemy] >= enemy_info[enemy].enemy_count:
		enemy_spawn_timers[enemy].queue_free()
		timers_finished += 1
		if timers_finished == enemy_info.size():
			all_enemies_spawned.emit()
	
