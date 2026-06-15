class_name BaseTower
extends Node2D

enum TargetMode {CLOSEST, FURTHEST, MOST_PROGRESS, LEAST_HEALTH, MOST_HEALTH}
enum TowerTypes {NONE, BASE_TOWER, LASER_TOWER, LOGIC_GATE, BUFFER_OVERFLOW, SIGTERM, TOWER_BLOCKER}
enum TowerCosts {NONE = 0, BASE_TOWER = 5, LASER_TOWER = 5, LOGIC_GATE = 10, BUFFER_OVERFLOW = 20, SIGTERM = 40, TOWER_BLOCKER = 0}

## The name of the tower, to be displayed in the info display
@export var display_name:String = "Base Tower"
## The number of shots fired per second
@export var attack_speed:float = 1.0
## The damage each shot deals
@export var damage:float = 1.0
## The radius (in px) of the area the tower can attack in 
@export var attack_range:float = 500.0

## The scene used to create projectiles
@export_file("*.tscn") var projectile_scene_path:String
## The targeting mode used by this tower
@export var target_mode:TargetMode = TargetMode.CLOSEST
## The speed that the turret rotates (in radians per second) when no enemy is in range
@export var turret_idle_rotation_speed:float = 1.0
## The type of tower that this is
@export var tower_type:TowerTypes = TowerTypes.BASE_TOWER

## An array that holds all upgrades applied to this tower
@export var upgrades:Array[Upgrade]

## An array that holds the information for all upgrade paths this tower can take
@export var upgrade_paths:Array[UpgradePath]

var can_attack = true
var enemies:Array[BaseEnemy]
var target:BaseEnemy = null
var is_attacking:bool = false

## Holds the calculted cumulative effect of all upgrades for each property
var cumulative_upgrade_dictionary:Dictionary[String, float] = {"range" : 1.0, "damage" : 1.0, "attack_speed": 1.0}

## Holds the range once all range upgrades have been applied
@onready var calculated_range = attack_range:
	set(value):
		calculated_range = value
		if range_circle:
			range_circle.attack_range = value
		attack_area_shape.radius = value
	

@onready var calculated_damage = damage:
	set(value):
		calculated_damage = value

@onready var calculated_attack_speed = attack_speed:
	set(value):
		calculated_attack_speed = value
		calculated_cooldown = 1 / value

@onready var calculated_cooldown = 1 / attack_speed:
	set(value):
		calculated_cooldown = value
		if attack_cooldown_timer:
			attack_cooldown_timer.wait_time = value

@onready var attack_cooldown_timer:Timer = $AttackCooldown
@onready var turret:Node2D = $Base/Turret
@onready var range_circle:RangeCircle = $RangeCircle
@onready var attack_area:Area2D = $AttackArea2D
@onready var attack_area_shape:CircleShape2D = $AttackArea2D/CollisionShape2D.shape
@onready var projectile_scene:Resource = load(projectile_scene_path)
@onready var ready_to_fire_turret_texture = load("res://Assets/kenney_tower-defense-top-down/PNG/Retina/towerDefense_tile206.png")
@onready var not_ready_to_fire_turret_texture = load("res://Assets/kenney_tower-defense-top-down/PNG/Retina/towerDefense_tile229.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Generate a unique attack shape upon instantiation
	var new_attack_area_shape = attack_area_shape.duplicate()
	$AttackArea2D/CollisionShape2D.shape = new_attack_area_shape
	attack_area_shape = $AttackArea2D/CollisionShape2D.shape
	
	calculate_upgrades()
	range_circle.attack_range = calculated_range
	attack_cooldown_timer.wait_time = calculated_cooldown
	attack_area_shape.radius = calculated_range
	
	# Make all the upgrade paths unique so progress isn't shared between towers
	for i in range(upgrade_paths.size()):
		upgrade_paths[i] = upgrade_paths[i].duplicate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	get_target()
	
	if not is_attacking:
		update_turret_rotation()
	if target:
		if can_attack:
			attack()
	if Input.is_action_just_pressed("upgrade"):
		var upgrade = Upgrade.new()
		upgrade.property = Upgrade.Properties.RANGE
		upgrade.scale = 2
		add_upgrade(upgrade)


func set_range_circle_visible(visiblity:bool):
	range_circle.visible = visiblity


func calculate_upgrades():
	# Reset the dictionary
	for key in cumulative_upgrade_dictionary:
		cumulative_upgrade_dictionary[key] = 1.0
	for upgrade:Upgrade in upgrades:
		if upgrade.property == Upgrade.Properties.RANGE:
			cumulative_upgrade_dictionary["range"] *= upgrade.scale
			calculated_range = cumulative_upgrade_dictionary["range"] * attack_range
		elif upgrade.property == Upgrade.Properties.DAMAGE:
			cumulative_upgrade_dictionary["damage"] *= upgrade.scale
			calculated_damage = cumulative_upgrade_dictionary["damage"] * damage
		elif upgrade.property == Upgrade.Properties.ATTACK_SPEED:
			cumulative_upgrade_dictionary["attack_speed"] *= upgrade.scale
			calculated_attack_speed = cumulative_upgrade_dictionary["attack_speed"] * attack_speed
	if upgrades.size() == 0:
		# There are no upgrades to apply
		calculated_range = attack_range
		calculated_damage = damage
		calculated_attack_speed = attack_speed


func get_target():
	match target_mode:
		TargetMode.CLOSEST:
			target = get_closest_enemy()
		TargetMode.FURTHEST:
			target = get_furthest_enemy()
		TargetMode.MOST_PROGRESS:
			target = get_most_progress_enemy()
		TargetMode.MOST_HEALTH:
			target = get_most_health_enemy()
		TargetMode.LEAST_HEALTH:
			target = get_least_health_enemy()


func attack():
	attack_cooldown_timer.start()
	turret.texture = not_ready_to_fire_turret_texture
	can_attack = false
	var projectile:BaseProjectile = projectile_scene.instantiate()
	projectile.target = target
	projectile.damage = calculated_damage
	projectile.global_position = global_position
	add_child(projectile)


func update_turret_rotation(delta:float = 1.0/60):
	if target:
		var direction_to_closest_enemy:Vector2 = global_position.direction_to(target.global_position)
		turret.rotation = direction_to_closest_enemy.angle() + PI / 2
	else:
		turret.rotation += turret_idle_rotation_speed * delta


func get_closest_enemy():
	var closest_node:BaseEnemy = null
	var closest_node_distance:float
	for enemy:BaseEnemy in enemies:
		# if there is currently no node, just fill in the basic one to avoid a crash by accessing its parameters later
		if not closest_node:
			closest_node = enemy
			closest_node_distance = global_position.distance_to(closest_node.global_position)
		elif closest_node_distance > global_position.distance_to(enemy.global_position):
			closest_node = enemy
			closest_node_distance = global_position.distance_to(closest_node.global_position)
	return closest_node


func get_furthest_enemy():
	var furthest_node:BaseEnemy = null
	var furthest_node_distance:float
	for enemy:BaseEnemy in enemies:
		# if there is currently no node, just fill in the basic one to avoid a crash by accessing its parameters later
		if not furthest_node:
			furthest_node = enemy
			furthest_node_distance = global_position.distance_to(furthest_node.global_position)
		elif furthest_node_distance < global_position.distance_to(enemy.global_position):
			furthest_node = enemy
			furthest_node_distance = global_position.distance_to(furthest_node.global_position)
	return furthest_node


func get_most_progress_enemy():
	var most_progress_node:BaseEnemy = null
	var most_progress_node_distance:float
	for enemy:BaseEnemy in enemies:
		# if there is currently no node, just fill in the basic one to avoid a crash by accessing its parameters later
		if not most_progress_node:
			most_progress_node = enemy
			most_progress_node_distance = enemy.progress
		elif enemy.progress > most_progress_node_distance:
			most_progress_node = enemy
			most_progress_node_distance = enemy.progress
	return most_progress_node


func get_most_health_enemy():
	var most_health_node:BaseEnemy = null
	var most_health_node_amount:float
	for enemy:BaseEnemy in enemies:
		# if there is currently no node, just fill in the basic one to avoid a crash by accessing its parameters later
		if not most_health_node:
			most_health_node = enemy
			most_health_node_amount = enemy.health
		elif enemy.health > most_health_node_amount:
			most_health_node = enemy
			most_health_node_amount = enemy.health
	return most_health_node


func get_least_health_enemy():
	var least_health_node:BaseEnemy = null
	var least_health_node_amount:float
	for enemy:BaseEnemy in enemies:
		# if there is currently no node, just fill in the basic one to avoid a crash by accessing its parameters later
		if not least_health_node:
			least_health_node = enemy
			least_health_node_amount = enemy.health
		elif enemy.health < least_health_node_amount:
			least_health_node = enemy
			least_health_node_amount = enemy.health
	return least_health_node


func add_upgrade(upgrade:Upgrade):
	upgrades.push_back(upgrade)
	calculate_upgrades()


func destroy_self():
	var parent = get_parent()
	
	# Check if the parent is a TileMapLayer or TileMap
	if parent is TileMapLayer:
		# Convert own position into the parent's map grid coordinates
		var cell_coords = parent.local_to_map(position)
		
		
		var tower_name:String = BaseTower.TowerTypes.keys()[tower_type]
		var cost = BaseTower.TowerCosts[tower_name]
		# refund the cost of this tower
		Globals.currency += cost
		
		# Tell the parent to clear this cell (this automatically frees this node)
		parent.set_cell(cell_coords, -1)


func _on_attack_cooldown_timeout() -> void:
	turret.texture = ready_to_fire_turret_texture
	can_attack = true
	update_turret_rotation()
	await get_tree().create_timer(1.0/60.0).timeout
	return

func _on_attack_area_2d_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is BaseEnemy:
		enemies.append(parent)
		target = get_target()


func _on_attack_area_2d_area_exited(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is BaseEnemy:
		enemies.erase(parent)
	target = get_target()
