
extends Area2D

@export var vita: int = 100

@onready var progress_bar: ProgressBar = $ProgressBar

func prendiDanno(danno:int):
	$flash.play("flash")
	$Danno.play()
	vita -= danno
	progress_bar.value = vita

func Esplodi():
	if vita <= 0:
		$flash.play("RESET")
		$"..".vittoria = false
		get_parent().get_parent().get_parent().	load_level("res://morte.tscn")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("nemico"):
		body.get_node("sounds/arrive").play()
		await body.get_node("sounds/arrive").finished
		if is_instance_valid(body):
			prendiDanno(body.danno)
			body.queue_free()
			Esplodi()
