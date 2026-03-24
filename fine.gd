extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	z_index = 500
	$punteggio.text  = "PUNTEGGIO FINALE :" + str(get_parent().get_parent().punteggio)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
