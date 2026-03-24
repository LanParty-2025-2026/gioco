extends Node2D

func fine_partita(tempo:int = 0, punteggio:int = 0, bricoCoin:int= 0, vittoria:bool = true):
	#add_child(menu.creaMenu(tempo, punteggio, bricoCoin, vittoria))
	

	pass

func prossimaScena():
	get_tree().reload_current_scene()

func esplodiTrucco():
	$Torri/Torre3.seiScarso()
