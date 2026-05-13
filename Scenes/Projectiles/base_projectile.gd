extends Sprite2D
class_name BaseProjectile

@export var move_speed:float = 2000.0

var damage
var target:BaseEnemy = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var direction_to_target:Vector2 = global_position.direction_to(target.global_position) 
	rotation = direction_to_target.angle() + PI / 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction_to_target:Vector2 = global_position.direction_to(target.global_position) 
	rotation = direction_to_target.angle() + PI / 2
	var move_vector = Vector2.UP.rotated(rotation) * move_speed * delta
	position += move_vector


func _on_area_2d_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is BaseEnemy:
		var enemy:BaseEnemy = parent
		enemy.health -= damage
		queue_free()
