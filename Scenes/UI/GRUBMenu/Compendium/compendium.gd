class_name Compendium
extends Control


@onready var tower_info_screen:CompendiumTowerInfoScreen = $TowerInfoScreen
@onready var enemy_info_screen:EnemyInfoScreen = $EnemyInfoScreen


var tower_pictures:Dictionary[BaseTower.TowerTypes, Texture2D] = {
	BaseTower.TowerTypes.LOGIC_GATE : preload("res://Assets/Towers/Logic gate.svg"),
	BaseTower.TowerTypes.BUFFER_OVERFLOW : preload("res://Assets/Towers/Buffer Overflow.svg"),
	BaseTower.TowerTypes.SIGTERM : preload("res://Assets/Towers/Logic gate.svg"),
	BaseTower.TowerTypes.DEFRAGMENTER : preload("res://Assets/Towers/Buffer Overflow.svg"),
	}

@onready var enemy_pictures:Dictionary[BaseEnemy.ENEMY_TYPES, Texture2D] = {
	BaseEnemy.ENEMY_TYPES.WEAK_ENEMY : %WeakEnemy.tower_icon,
	BaseEnemy.ENEMY_TYPES.ZIP_BOMB_ENEMY : %ZipBomb.tower_icon,
	}


var tower_bumf:Dictionary[BaseTower.TowerTypes, String] = {
	BaseTower.TowerTypes.LOGIC_GATE : """A [color=orange]medium attack speed, 
	single target[/color] defence program. Deals [color=orange]medium damage[/color] to malware. 
	Occupies a small amount of memory""",
	BaseTower.TowerTypes.BUFFER_OVERFLOW : """A [color=orange]low attack speed, 
	multi target Area Of Effect[/color] defence program. Deals [color=orange]high damage[/color] to groups of malware. 
	Occupies a moderate amount of memory""",
	BaseTower.TowerTypes.SIGTERM : """A [color=orange]very low attack speed, 
	single target sniper[/color] defence program. Deals [color=orange]very high damage[/color] to individual malware targets. 
	Occupies a large amount of memory""",
	BaseTower.TowerTypes.DEFRAGMENTER : """A [color=orange]supporting[/color] defence program. [color=orange]Reveals cloaked enemies[/color] 
	within its range. Occupies a low amount of memory"""
}


var enemy_bumf:Dictionary[BaseEnemy.ENEMY_TYPES, String] = {
	BaseEnemy.ENEMY_TYPES.WEAK_ENEMY : """Has no special properties. Infection progresses at a [color=orange]moderate rate[/color], and deals 
	[color=orange]medium damage[/color] to mainframe upon completion""",
	BaseEnemy.ENEMY_TYPES.ZIP_BOMB_ENEMY : """Moves [i]very[/i] slowly. [color=orange]Spawns 5 basic malware enemies[/color] when destroyed. 
	Deals a [color=orange]large amount[/color] of damage to mainframe upon infection completion """,
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_logic_gate_set_placing(_tower_type: BaseTower.TowerTypes) -> void:
	display_tower_info("[color=cyan]Logic gate[/color]", 
			{"attack_speed":1.5, "damage":1, "range":480, "cost":10}, 
			tower_bumf[BaseTower.TowerTypes.LOGIC_GATE], 
			tower_pictures[BaseTower.TowerTypes.LOGIC_GATE], 
			Color(0.0, 2.285, 4.006))


func _on_buffer_overflow_set_placing(_tower_type: BaseTower.TowerTypes) -> void:
	display_tower_info("[color=orange]Buffer Overflow[/color]", 
			{"attack_speed":0.333, "damage":5, "range":750, "cost":20}, 
			tower_bumf[BaseTower.TowerTypes.BUFFER_OVERFLOW], 
			tower_pictures[BaseTower.TowerTypes.BUFFER_OVERFLOW], 
			Color(4.0, 0.413, 0.0))


func _on_sigterm_set_placing(_tower_type: BaseTower.TowerTypes) -> void:
	display_tower_info("[color=red]SIGTERM[/color]", 
			{"attack_speed":0.25, "damage":10, "range":1200, "cost":40}, 
			tower_bumf[BaseTower.TowerTypes.SIGTERM], 
			tower_pictures[BaseTower.TowerTypes.SIGTERM], 
			Color(4.006, 0.0, 0.0))


func _on_defragmenter_set_placing(tower_type: BaseTower.TowerTypes) -> void:
	display_tower_info("[color=yellow]Defragmenter[/color]", 
			{"attack_speed":1, "damage":0, "range":750, "cost":15}, 
			tower_bumf[BaseTower.TowerTypes.DEFRAGMENTER], 
			tower_pictures[BaseTower.TowerTypes.DEFRAGMENTER], 
			Color(5.0, 5.0, 0.0))


func display_tower_info(tower_name:String, tower_stats:Dictionary[String, float], description:String, image:Texture2D, image_modulate:Color):
	tower_info_screen.visible = true
	tower_info_screen.set_tower_name(tower_name)
	description = description.remove_char(ord("\n"))
	description = description.remove_char(ord("	"))
	tower_info_screen.set_description(description)
	tower_info_screen.set_attack_speed(tower_stats["attack_speed"])
	tower_info_screen.set_damage(tower_stats["damage"])
	tower_info_screen.set_range(tower_stats["range"])
	tower_info_screen.set_cost(tower_stats["cost"])
	tower_info_screen.set_image(image, image_modulate)


#func generate_tower_description(attack_speed:float = 1, damage:float = 1, range:float = 1, cost = 1) -> String:
	#var return_string:String = """[indent]
#Base attack speed: {attack_speed} attacks per second ({attack_cooldown} seconds per attack)
#Base damage: {damage} damage per shot
#Base range: {range} pixels
#Program size: {cost} Megabytes
#
#"""
	#return_string = return_string.format(
		#{"attack_speed":"%.2f" % attack_speed,
		#"attack_cooldown": "%.2f" % (1 / attack_speed),
		#"damage":"%.2f" % damage,
		#"range":"%.2f" % range,
		#"cost":cost }
		#)
	#return return_string
	


func _on_exit_button_pressed() -> void:
	visible = false


func _on_weak_enemy_set_placing(_tower_type: BaseTower.TowerTypes) -> void:
	display_enemy_info("[color=ff00ff]Basic malware[/color]", 
			{"move_speed":500, "damage":10, "health":3}, 
			enemy_bumf[BaseEnemy.ENEMY_TYPES.WEAK_ENEMY], 
			enemy_pictures[BaseEnemy.ENEMY_TYPES.WEAK_ENEMY], 
			Color(5.0, 0.0, 1.5))


func display_enemy_info(enemy_name:String, enemy_stats:Dictionary[String, float], description:String, image:Texture2D, image_modulate:Color):
	enemy_info_screen.visible = true
	enemy_info_screen.set_tower_name(enemy_name)
	description = description.remove_char(ord("\n"))
	description = description.remove_char(ord("	"))
	enemy_info_screen.set_description(description)
	enemy_info_screen.set_move_speed(enemy_stats["move_speed"])
	enemy_info_screen.set_damage(enemy_stats["damage"])
	enemy_info_screen.set_health(enemy_stats["health"])
	#tower_info_screen.set_cost(tower_stats["cost"])
	enemy_info_screen.set_image(image, image_modulate)


func _on_zip_bomb_set_placing(tower_type: BaseTower.TowerTypes) -> void:
	display_enemy_info("[color=ff00ff]Zip bomb malware[/color]", 
			{"move_speed":200, "damage":50, "health":5}, 
			enemy_bumf[BaseEnemy.ENEMY_TYPES.ZIP_BOMB_ENEMY], 
			enemy_pictures[BaseEnemy.ENEMY_TYPES.ZIP_BOMB_ENEMY], 
			Color(5.0, 0.0, 1.5))
