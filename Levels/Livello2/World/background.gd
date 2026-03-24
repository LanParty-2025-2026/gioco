
extends Node2D

@onready var carica_nuova_nuvola: Timer = $Timer

@export var velocita_scorrimento = 30
const nuvola = preload("res://Levels/Livello2/World/Nuvole/nuvola.tscn")

const cloud1 = preload("res://Levels/Livello2/BackGround/C2010.png")
const cloud2 = preload("res://Levels/Livello2/BackGround/C2011.png")
const cloud3 = preload("res://Levels/Livello2/BackGround/C2012.png")
const cloud4 = preload("res://Levels/Livello2/BackGround/C2013.png")

var immagini = [cloud1,cloud2,cloud3,cloud4]



func _process(delta: float) -> void:
	$ParallaxBackground.scroll_offset.x += velocita_scorrimento*delta

func crea_nuvola() -> void:
	var nuova_nuvola = nuvola.instantiate()
	nuova_nuvola.position = Vector2(-446,randf_range(37, 338))
	nuova_nuvola.texture = immagini.pick_random()
	nuova_nuvola.velocità = randi_range(100,240)
	add_child(nuova_nuvola)
	carica_nuova_nuvola.wait_time = randi_range(8,16)
