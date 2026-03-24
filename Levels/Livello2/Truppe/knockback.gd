
extends Node

@onready var knock_back: Timer = $KnockBack
@onready var truppa: CharacterBody2D = $".."
@onready var fight_node: Node = $"../FightNode"

var contatore = 0
@export var min_knockBack = 4
@export var max_knockBack = 6

var random_KnockBack_success = randi_range(min_knockBack,max_knockBack)

func KnockBack():
	fight_node.disabilita_combattimento()
	fight_node.disabilita_radar()
	knock_back.start()
	truppa.direction = -truppa.direction
	await knock_back.timeout
	fight_node.abilita_radar()
	truppa.direction = -truppa.direction
	

func _on_truppa_preso_danno(danno:int) -> void:
	contatore+=1
	if contatore >= random_KnockBack_success:
		KnockBack()
		random_KnockBack_success = randi_range(min_knockBack,max_knockBack)
		contatore = 0
