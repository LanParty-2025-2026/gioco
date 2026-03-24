extends Node2D

var vittoria:bool = true
var durata_partita:int = 4 #definisce quanti secon di deve durare masimo una partita
func termina_partita():
	#---------------------------
	# qui si calcola il punteggio
	#-----------------------------
	#var punteggio:int = int($Punteggio.text)*randi_range(9,12)
	#var bricoCoin = punteggio/randi_range(4,6)
	#add_child(menu.creaMenu(90, punteggio,bricoCoin, vittoria))
	pass

func prossimaScena():
	get_tree().quit()
