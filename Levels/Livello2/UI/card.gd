extends Control
class_name Card

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var image: Texture
@export var tipoCarta: String

@export var costo: int

@export var vita: int
@export var danno: int
@export var speed: int

@onready var GestoreGiocatore:Node = get_parent().get_parent().get_parent().get_node("%GestoreGiocatore")
func _ready() -> void:
	#$TextureRect.texture = image  #Riaggiungere una volta terminato
	$TextureRect/Label/Costo.text = str(costo)
	$TextureRect/Label/Vita.text = str(vita)
	$TextureRect/Label/Attacco.text = str(danno-2)+"~"+str(danno+2)
	$"TextureRect/Label/Velocità".text = str(speed/100)
	$TextureRect/Label/Immagini/image.texture = image
	
func _on_buy_mouse_entered() -> void:
	if !animation_player.is_playing():
		animation_player.play("ingrandimento")
	else:
		await animation_player.animation_finished
		animation_player.play("ingrandimento")
		
func _on_buy_mouse_exited() -> void:
	if !animation_player.is_playing():
		animation_player.play_backwards("ingrandimento")
	else:
		await animation_player.animation_finished
		animation_player.play_backwards("ingrandimento")
		

func _on_buy_pressed() -> void:
	var animazione = GestoreGiocatore.ControllaTruppa(self)
	if animazione:
		animation_player.play("comprato")
	else:
		animation_player.play("fondiEsauriti") 
