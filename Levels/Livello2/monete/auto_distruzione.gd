
extends Node
@onready var coin: AnimatedSprite2D = $".."
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"

func _process(delta: float) -> void:
	if coin.global_position.y > 432:
		animation_player.play("dissipazione")
