extends Node

signal risposta_giusta_data
signal risposta_sbagliata_data

@onready var assegnazione_risposte_domande: Node = $"../assegnazioneRisposteDomande"
@onready var tempo_rimanente: ProgressBar = $"../tempoRimanente"

var pulsante_giusto: int

var risposte_giuste:int = 0
var risposte_sbagliate:int = 0

func _on_button_pressed(numero_pulsante: int) -> void:
	if numero_pulsante == pulsante_giusto:
		risposta_giusta(true)
	else:
		risposta_giusta(false)
	tempo_rimanente.resetta_tempo()
	assegnazione_risposte_domande.carica_prossima_domande()

func risposta_giusta(risultato: bool = true):
	if risultato:
		risposta_giusta_data.emit()
		risposte_giuste += 1
	else:
		risposta_sbagliata_data.emit()
		risposte_sbagliate +=1
