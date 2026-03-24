
extends Node

#!!!IA per tesrtare le funzinalità!!!!

@export var enable: bool = false  #abilita l'autoplay 
@export var FireRate: float = 2 #ogni quanto indovina un'espressione

@onready var timer: Timer = $Timer


@onready var input: LineEdit = $"../Input/Input"

@onready var cavalieri: Node = $"../GeneratoreDiCavalieri/Cavalieri"


func _ready() -> void:
	if enable:
		timer.wait_time = FireRate
		timer.timeout.connect(_on_timer_timeout)
	else:
		queue_free()
	

func _on_timer_timeout() -> void:
	fire()
	
	
func fire():
	if cavalieri.get_child_count() > 0 :
		input.text = str(cavalieri.get_child(0).risultato)

	
