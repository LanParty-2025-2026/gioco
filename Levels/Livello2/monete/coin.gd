
extends AnimatedSprite2D

var moneta_raccolta: bool = false
var speed: int = 110

@onready var gestore_giocatore: Node = get_parent().get_node("%GestoreGiocatore")

var target_position: Vector2 = Vector2(1021, 522) # Cambia questi valori con la posizione desiderata

func _process(delta: float) -> void:
	if !moneta_raccolta:
		position.y += speed * delta 
	else:
		# Calcoliamo la direzione verso il target
		var direction = (target_position - position).normalized()
		# Muoviamo la sprite verso il target
		position += direction * speed * delta
		
		if position.distance_to(target_position) < 30:
			gestore_giocatore.aggiungi_valuta(10)
			queue_free()

func _on_button_pressed() -> void:
	$AutoDistruzione.queue_free()
	$Button.queue_free()
	speed = 2000
	moneta_raccolta = true
	
