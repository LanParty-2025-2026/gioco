
extends Node

@onready var truppa: CharacterBody2D = $".."
@onready var ray_cast_2d: RayCast2D = $"../RayCast2D"


func _ready() -> void:
	if truppa.truppa_identità != "arco":
		queue_free()
	else:
		ray_cast_2d.target_position = Vector2(-100,-0.017)
		queue_free()
