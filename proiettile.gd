extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var area = $Area2D
var proprietario

var isAttacking = true
var damage = 0

func _ready() -> void:
	$Timer.start(5.0)
	await $Timer.timeout
	queue_free()

func _physics_process(delta: float) -> void:

	move_and_slide()
	area.name = "arma"


func _on_area_2d_area_entered(area: Area2D) -> void:
	queue_free()
