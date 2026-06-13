class_name BaseEnemy
extends PathFollow2D

enum ENEMY_TYPES {BASE_ENEMY, WEAK_ENEMY}

signal enemy_killed

@export var enemy_type:ENEMY_TYPES
@export var move_speed:float = 500.0
@export var MAX_HEALTH:int = 3
@export var damage:int = 10

@onready var health:float = MAX_HEALTH:
	set(value):
		health = value
		health_bar.set_progress(health / MAX_HEALTH)
		_on_hit()
@onready var health_bar:HealthBar = $HealthBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#health_bar.max_value = MAX_HEALTH
	#health_bar.value = health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress += move_speed * delta
	if health <= 0:
		die()
	if progress_ratio == 1.0:
		Globals.health -= damage
		die()


func die():
	var particles:GPUParticles2D = $GPUParticles2D
	enemy_killed.emit()
	var sub_viewport_label:Label = $GPUParticles2D/TextParticle/Label
	sub_viewport_label.text = "0x%X%X" % [randi() % 15, randi() % 15]
	print(sub_viewport_label.text)
	particles.restart()
	remove_child(particles)
	get_parent().add_child(particles)
	particles.global_position = global_position
	particles.finished.connect(particles.queue_free)
	queue_free()

func _on_hit():
	pass
