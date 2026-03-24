extends Sprite2D

var isAttacking = false
@onready var area2D = $Area2D
var damage = 4
# Called when the node enters the scene tree for the first time.
var proprietario


func _ready() -> void:
	area2D.name = "arma"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
