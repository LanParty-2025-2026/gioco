extends Node

signal partita_finita

@onready var bottone1: Label = $"../Button2/Label2"
@onready var bottone2: Label = $"../Button3/Label3"
@onready var bottone3: Label = $"../Button4/Label4"
@onready var bottone4: Label = $"../Button5/Label5"
@onready var domanda: Label = $"../Domanda"
@onready var checkrisposte: Node = $"../checkrisposte"

var dati: Dictionary
var domanda_corrente: int = 0

func _ready() -> void:
	dati = LettoreJson.load_json("res://Levels/Livello3/domande.json")
	carica_prossima_domande()

func carica_prossima_domande():
	if domanda_corrente >= 9:
		partita_finita.emit()
		return
	domanda_corrente +=1
	var domanda_corrente_string = str("domanda",domanda_corrente)
	var domanda_corrente_dati = dati.get(domanda_corrente_string)
	domanda.text = domanda_corrente_dati.domanda
	
	var risposte: Array = domanda_corrente_dati.risposte
	
	bottone1.text = risposte.pick_random()
	risposte.erase(bottone1.text)

	bottone2.text = risposte.pick_random()
	risposte.erase(bottone2.text)
	
	bottone3.text = risposte.pick_random()
	risposte.erase(bottone3.text)

	bottone4.text = risposte.pick_random()
	risposte.erase(bottone4.text)
	
	checkrisposte.pulsante_giusto = domanda_corrente_dati.rispostaCorretta
