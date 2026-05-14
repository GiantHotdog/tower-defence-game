class_name BaseEnemy
extends PathFollow2D

@export var move_speed:float = 500.0
@export var MAX_HEALTH:int = 3

@onready var health:int = MAX_HEALTH
@onready var health_bar:TextureProgressBar = $HealthBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_bar.max_value = MAX_HEALTH
	health_bar.value = health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress += move_speed * delta
	health_bar.value = health
	if health <= 0:
		die()
	
func die():
	queue_free()
