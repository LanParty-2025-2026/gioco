
extends Node

const moneta = preload("res://Levels/Livello2/monete/coin.tscn")

func _on_timer_timeout() -> void:
	var coin = moneta.instantiate()
	coin.position = Vector2(randi_range(12,1146),-17)
	get_parent().add_child(coin)
	
