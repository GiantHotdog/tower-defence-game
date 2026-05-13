class_name BaseEnemy
extends PathFollow2D

@export var move_speed:float = 500.0
@export var MAX_HEALTH:int = 5

@onready var health:int = MAX_HEALTH


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress += move_speed * delta
	if health < 0:
		die()
	
func die():
	queue_free()
