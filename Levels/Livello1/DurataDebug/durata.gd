extends Label

var tempo: int = 0
@onready var durata: Label = $"."

func _on_timer_timeout() -> void:
	tempo+=1
	durata.text = "durata: "+str(tempo)
	if tempo>=$"..".durata_partita:
		$"..".termina_partita()
