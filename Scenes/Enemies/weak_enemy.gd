class_name WeakEnemy
extends BaseEnemy

@export var chromatic_offset:Vector2 = Vector2.ZERO

@onready var rect1:ColorRect = $RedSprite/ColorRect
@onready var rect2:ColorRect = $RedSprite/ColorRect2
@onready var rect3:ColorRect = $BlueSprite/ColorRect3
@onready var rect4:ColorRect = $BlueSprite/ColorRect4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	var time = Time.get_ticks_msec() / 1000.0
	# Oscillates alpha smoothly between 0.3 and 0.5
	var scale_amount:float = sin(time * 6.0) * 0.1
	rect1.scale.x = 1 + scale_amount
	rect1.scale.y = 1 + scale_amount
	rect2.scale.x = 1 - scale_amount
	rect2.scale.y = 1 - scale_amount
	rect3.scale.x = 1 + scale_amount
	rect3.scale.y = 1 + scale_amount
	rect4.scale.x = 1 - scale_amount
	rect4.scale.y = 1 - scale_amount

func _on_hit():
	$RedSprite.position -= chromatic_offset
	$BlueSprite.position += chromatic_offset
	await get_tree().create_timer(0.2).timeout
	$RedSprite.position += chromatic_offset
	$BlueSprite.position -= chromatic_offset
