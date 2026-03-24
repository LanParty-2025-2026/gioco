extends Control
class_name menu

const MENU = preload("uid://ckyiqs8iaextm")

@onready var tempo_impiegato: Label = $Card/TempoTab/DescriptionTempo/containerdati/TempoImpiegato
@onready var bricoguadagnati: Label = $Card/CoinTab/DescriptionBricoCoin/containerdati/Bricoguadagnati
@onready var punteggioottenuto: Label = $Card/PointTab/Descriptionpunteggio/containerdati/punteggioottenuto
@onready var titolo: Label = $TitoloSprite/titolo

@onready var bottonedes: TextureButton = $bottonedes

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var menu_generale: Control = $"."

var tempo:int
var punteggio:int
var bricoCoin:int
var Vittoria:bool

func _ready() -> void:
	compila_scheda()

static func creaMenu(tempoInt:int,punteggioFun = 0, bricoCoinFun = 0, VittoriaFun:bool = true):
	var nuovo_menu = MENU.instantiate()
	nuovo_menu.tempo = tempoInt
	nuovo_menu.punteggio = punteggioFun
	nuovo_menu.bricoCoin = bricoCoinFun
	nuovo_menu.Vittoria = VittoriaFun
	return nuovo_menu


func compila_scheda():
 
	get_tree().paused = true
	$".".visible = true
	var text = func():
		if !self.Vittoria:
			return "sconfitta"
		return "vittoria"
	titolo.text = text.call()
	tempo_impiegato.text = str(self.tempo)
	bricoguadagnati.text = str(self.bricoCoin)
	punteggioottenuto.text = str(self.punteggio)
	self.global_position = Vector2(592,291)
	
	animation_player.play("apparizione")
	
func cancella_menu():
	get_tree().paused = false
	animation_player.play_backwards("apparizione")
	await animation_player.animation_finished
	if $"..".has_method("prossimaScena"):
		$"..".prossimaScena()
	else:
		print_rich("[color=orange] manca il metodo [color=aqua]prossimaScena()[color=orange], rinominare o cambiare percorso in [color=yellow] menu_vittoria.gd [color=aqua] riga 53-54")
	queue_free()

func _on_bottonedes_pressed() -> void:
	cancella_menu()
