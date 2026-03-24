
extends StaticBody2D


const torre_alleata = preload("res://Levels/Livello2/torri/Sprite_TowerBLUE.png")
const torre_nemica = preload("res://Levels/Livello2/torri/Sprite_TowerRED.png")

var vita: int = 500
var danno: int

var fatto = false

#------scuotimento------
var shake_intensity = 0.0  
var shake_duration = 0.0  
var shake_timer = 0.0
var shake_offset = Vector2.ZERO  

@onready var pos_init = global_position  

func _ready() -> void:
	if is_in_group("Nemico"):
		$Sprite2D.flip_h = true
		$Sprite2D.texture = torre_nemica
	else:
		$Sprite2D.texture = torre_alleata


func _process(delta: float) -> void:
	if shake_timer < shake_duration:
		shake_timer += delta
		var progress = shake_timer / shake_duration
		var current_intensity = shake_intensity * (1.0 - progress)
		shake_offset = Vector2(randf_range(-current_intensity, current_intensity),randf_range(-current_intensity, current_intensity))
	else:
		shake_offset = Vector2.ZERO  
	global_position = pos_init + shake_offset


func prendiDanno(danno: int):
	shake_intensity = 10.0  
	shake_duration = 0.2 
	shake_timer = 0.0

	vita -= danno
	aggiornaVita()
	if vita <= 0:
		esplodi()

func seiScarso():
	get_parent().get_parent().get_parent().get_parent().addPunti(50)
func esplodi():
	if !fatto:
		fatto = true
		$CollisionShape2D.disabled = true
		var vittoria = true
		if self.is_in_group("Alleato"):
			vittoria = false
			get_parent().get_parent().get_parent().get_parent().	load_level("res://morte.tscn")
		else:
			get_parent().get_parent().get_parent().get_parent().	load_level("res://vittoria.tscn")
		#funzione che calcola il punteggio 
		var dati = calcola_punteggio_finale($"../../LanPartyNode".tempoPassato,vittoria)
		
		#chiamata di fine partitas dal nodo principale
		#$"../..".fine_partita($"../../LanPartyNode".tempoPassato, dati[0], dati[1], vittoria)
		
		queue_free()

func aggiornaVita():
	$vita.text = str(vita) + "/" + str(500)


func calcola_punteggio_finale(tempo:int, vittoria: bool):
	# funzione chiamata per randomizzare i vari punteggi
	# qui si può effettuare i vari calcoli
	
	#---------------------------
	# qui si calcola il punteggio
	#-----------------------------
	
	print_rich("[color=green]heyyy se vuoi modificare i vari  punteggi devi andare nella funzione [color=yellow] calcola_punteggio_finale() [color=green] nel file  [color=yellow] res://torri/torre.gd")
	
	var max_punteggio: int = 500
	var min_punteggio: int = 50
	var min_bricoCoin: int = 300
	var max_bricoCoin: int = 600
	
	var punteggio := 0
	var bricoCoin := 0
	if tempo<80 && vittoria:
		get_parent().get_parent().get_parent().get_parent().addPunti(500)
	
	elif vittoria:
		get_parent().get_parent().get_parent().get_parent().addPunti(250)
	elif vita > 0:
		get_parent().get_parent().get_parent().get_parent().addPunti(50)
			

	
