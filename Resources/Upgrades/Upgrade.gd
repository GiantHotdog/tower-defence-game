class_name Upgrade
extends Resource

enum Properties {RANGE, DAMAGE, ATTACK_SPEED} 

@export var property:Properties
## The decimal value that the property on the affected tower will be multiplied by
@export var scale:float = 1.0
@export var cost:int = 10
@export var description:String = "An upgrade"
