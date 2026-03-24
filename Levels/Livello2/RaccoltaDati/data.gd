extends Node

var truppe_posizionate:int = 0
var monete_raccolte:int = 0
var monete_cadute:int = 0
var valuta_spesa:int = 0 
var valuta_massima_raggiunta:int = 0


func write_to_file(content:String):

	var file = FileAccess.open("res://RaccoltaDati/dati.txt", FileAccess.READ_WRITE)
	if file:
		file.seek_end()
		file.store_string(content)
		
func componi():
	write_to_file("-------------------------\n")
	write_to_file("tempo: "+str($"../LanPartyNode/Tempo".text)+"\n")
	
	if get_parent().has_node("../Torri/Torre2"):
		write_to_file("vittoria: Alleato"+"\n")
	else:
		write_to_file("vittoria: Nemico"+"\n")
		
	write_to_file("truppe totali posizionate dal giocatore: "+str(truppe_posizionate)+"\n")
	write_to_file("truppe totali posizionate dal nemico: "+str(int($"../LanPartyNode/Tempo".text)/7)+"\n")
	
	write_to_file("stato potenziamento Production: "+str((
		$"../UI/Miglioramenti".next_upgrade_production-75)/50)+"\n")
	write_to_file("stato potenziamento Capacity: "+str((
		$"../UI/Miglioramenti".next_upgrade_capacity-75)/50)+"\n")

	write_to_file("monete_cadute: "+str(monete_cadute)+"\n")
	write_to_file("monete_raccolte: "+str(monete_raccolte)+"\n")
	
	write_to_file("valuta spesa: "+str(valuta_spesa)+"\n")
	write_to_file("valuta massima raggiunta: "+str(valuta_massima_raggiunta)+"\n")
	write_to_file("-------------------------"+"\n")
	$criptatore.cripta()
