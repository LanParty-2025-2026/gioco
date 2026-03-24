
extends Node

const Spada = preload("res://Levels/Livello2/Truppe/truppa.tscn")

@onready var card_container: Control = $"../UI/CardContainer"


func _on_timer_timeout() -> void:
	var carta = Card.new()
	var truppa = randi_range(0,10)
	if truppa <= 5:
		carta = card_container.get_node("Spada")
	elif truppa >= 6 && truppa <= 7:
		carta = card_container.get_node("Lancia")
	elif  truppa >= 8:
		carta = card_container.get_node("Arco")
	
	istanziaTruppa(carta)

func istanziaTruppa(card:Card):
	var posizioni = [$Posizionatore1,$Posizionatore2,$Posizionatore3]
	var istanzaSpada = Spada.instantiate()
	istanzaSpada.add_to_group("Nemico")
	
	istanzaSpada.truppa_identità = card.tipoCarta
	istanzaSpada.vita = card.vita
	istanzaSpada.danno = card.danno
	istanzaSpada.velocità = card.speed
	
	istanzaSpada.position = posizioni.pick_random().position
	if istanzaSpada.position == $Posizionatore1.position:
		istanzaSpada.z_index = 1
	elif istanzaSpada.position == $Posizionatore2.position:
		istanzaSpada.z_index = 2
	elif istanzaSpada.position == $Posizionatore3.position:
		istanzaSpada.z_index = 3
		
	
	get_parent().add_child(istanzaSpada)
