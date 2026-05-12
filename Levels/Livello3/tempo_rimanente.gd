extends ProgressBar

signal tempo_resettato
signal tempo_finito

@onready var tempo_rimanente: ProgressBar = $"."
@onready var assegnazione_risposte_domande: Node = $"../assegnazioneRisposteDomande"
@onready var checkrisposte: Node = $"../checkrisposte"

func _on_timer_timeout() -> void:
	tempo_rimanente.value += 0.15
	if value >= 100:
		tempo_rimanente.value = 0
		tempo_finito.emit()
		checkrisposte.risposta_giusta(false)
func resetta_tempo():
	tempo_rimanente.value = 0
	
