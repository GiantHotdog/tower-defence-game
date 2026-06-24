class_name ZipBombEnemy
extends BaseEnemy


signal children_add(count:int, type:BaseEnemy.ENEMY_TYPES, parent_progress:float)


@export var child_enemy_type:BaseEnemy.ENEMY_TYPES 


func die(is_at_end_of_path:bool = false):
	children_add.emit(5, child_enemy_type, progress)
		
	
	super.die(is_at_end_of_path)
