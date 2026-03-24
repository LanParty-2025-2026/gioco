extends Control

var tempoPassato:int = 0
#@onready var tempo: Label = $Tempo
var secondi: int = 0
var minuti:int = 0 

func _on_timer_timeout() -> void:
	tempoPassato+=1
	secondi += 1
	if secondi == 60:
		minuti += 1
		secondi = 0

#	if secondi >= 0 && secondi <= 9:
#		tempo.text = str(minuti) + ":" + "0" + str(secondi)
#	else:
#		tempo.text = str(minuti) + ":" + str(secondi)
