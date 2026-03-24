extends Node2D

var handled = 0  # Aggiungi la variabile "handled" per tenere traccia dello stato
@onready var compiti_e_indizi: Node2D = $Compiti
@onready var elementi: Node2D = $Elementi

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	compiti_e_indizi.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventMouseButton :
		if event.is_pressed() and event.as_text() == "Enter":  # Verifica se Enter è stato premuto
			if handled == 0:
				 # Azioni quando il tasto Enter è premuto la prima volta
				elementi.queue_free()
				compiti_e_indizi.show()
				handled += 1  # Incrementa "handled" per evitare che il codice venga eseguito più volte
			elif handled == 1:
			# Azioni quando il tasto Enter è premuto la seconda volta
				compiti_e_indizi.queue_free()
				handled += 1  # Incrementa "handled" per evitare ulteriori esecuzioni


func _on_area_2d_mouse_entered() -> void:
	pass # Replace with function body.
