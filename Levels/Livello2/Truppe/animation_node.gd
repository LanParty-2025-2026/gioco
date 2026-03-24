
extends Node

const labelDanno = preload("res://Levels/Livello2/DannoRicevuto/danno_ricevuto.tscn")

@onready var truppa: CharacterBody2D = $".."
var movimento: String = "movement_blu"
var attacco: String = "attack_blu"
var idle: String = "idle_blu"
var death: String = "death_blu"
var sprite: AnimatedSprite2D
var is_attacking: bool = false

var flash_da_utilizzare: String
func _ready() -> void:
	sprite = $"../AssemblatoreGruppo".elimina_animation(truppa.truppa_identità)
	if truppa.is_in_group("Nemico"):
		movimento = "movement_red"
		attacco = "attack_red"
		idle = "idle_red"
		death = "death_red"
	flash_da_utilizzare = determina_flash()
	
func _process(delta: float) -> void:
	# Solo gestisci l'animazione se non si sta già attaccando
	if truppa.can_move && not is_attacking:
		if truppa.velocity.x != 0:
			sprite.play(movimento)
		else:
			sprite.play(idle)

func attacco_signal() -> void:
	if not is_attacking && $"../RayCast2D".is_colliding() && truppa.can_move:
		is_attacking = true
		sprite.play(attacco)
		await sprite.animation_finished
		is_attacking = false


func _on_truppa_death() -> void:
	truppa.can_move = false
	
	$"../CollisionShape2D".disabled = true
	sprite.play(death)
	await sprite.animation_finished
	truppa.queue_free()



func preso_danno(danno:int) -> void:
	$"../AnimationPlayer".play(flash_da_utilizzare)
	istanzia_label(danno)

func determina_flash():
	var TipoTruppa: String = truppa.truppa_identità
	match TipoTruppa:
		"spada":
			return "hit_flash_spada"
		"lancia":
			return "hit_flash_lancia"
		"arco":
			return "hit_flash_arco"

func istanzia_label(danno:int):
	var labelIst = labelDanno.instantiate()
	labelIst.get_node("Control").danno_ricevuto = danno
	labelIst.position = Vector2(randf_range(truppa.position.x-20,truppa.position.x+20),randf_range(truppa.position.y-20,truppa.position.y+20))
	add_child(labelIst)
	
