class_name ZipBombEnemy
extends BaseEnemy


signal children_add(count:int, type:BaseEnemy.ENEMY_TYPES, parent_progress:float)


@export var child_enemy_type:BaseEnemy.ENEMY_TYPES 


var cloaked_color = Color(0.047, 0.047, 0.047)


func _process(delta: float) -> void:
	super._process(delta)
	if is_cloaked:
		modulate = cloaked_color
	else:
		modulate = Color(1, 1, 1)


func die(is_at_end_of_path:bool = false):
	children_add.emit(5, child_enemy_type, progress)
		
	
	super.die(is_at_end_of_path)
