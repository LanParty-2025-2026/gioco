extends Sprite2D


var velocità: int = 300

func _process(delta: float) -> void:
	position.x += velocità * delta





func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
