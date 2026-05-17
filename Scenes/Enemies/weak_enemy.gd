class_name WeakEnemy
extends BaseEnemy


@onready var rect1:ColorRect = $ColorRect
@onready var rect2:ColorRect = $ColorRect2

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
