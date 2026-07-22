class_name BaseEnemy
extends PathFollow2D

enum ENEMY_TYPES {BASE_ENEMY, WEAK_ENEMY, ZIP_BOMB_ENEMY, ZERO_DAY_ENEMY}

signal enemy_killed(enemy_pid:int)
signal reached_end_of_path(enemy_pid:int, damage_dealt:int)

@export var enemy_type:ENEMY_TYPES
@export var move_speed:float = 500.0
@export var MAX_HEALTH:int = 3
@export var damage:int = 10
@export var is_cloaked:bool = false
@export var is_invulnerable:bool = false

@onready var health:float = MAX_HEALTH:
	set(value):
		health = value
		health_bar.set_progress(health / MAX_HEALTH)
@onready var health_bar:HealthBar = $HealthBar


var cloaked_color = Color(0.047, 0.047, 0.047)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#health_bar.max_value = MAX_HEALTH
	#health_bar.value = health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_cloaked:
		modulate = cloaked_color
	else:
		modulate = Color(1, 1, 1)
	progress += move_speed * delta
	if health <= 0:
		die()
	if progress_ratio == 1.0:
		Globals.health -= damage
		die(true)


func die(is_at_end_of_path:bool = false):
	var particles:GPUParticles2D = $GPUParticles2D
	if is_at_end_of_path:
		reached_end_of_path.emit(get_instance_id(), damage)
	else:
		enemy_killed.emit(get_instance_id())
	var sub_viewport_label:Label = $GPUParticles2D/TextParticle/Label
	sub_viewport_label.text = "0x%X%X" % [randi() % 15, randi() % 15]
	particles.restart()
	remove_child(particles)
	get_parent().add_child(particles)
	particles.global_position = global_position
	particles.finished.connect(particles.queue_free)
	queue_free()


func add_damage(damage:float):
	health -= damage
