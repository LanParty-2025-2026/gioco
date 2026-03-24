
extends CharacterBody2D

@export var vita: int = 30
@export var danno: int = 10
@export var velocità: int = 800
@export var direction: Vector2 

@export var truppa_identità: String

var can_move = true

var is_fighting: bool = false

signal preso_Danno
signal death
var GruppoAvversario: String = ""

func _ready() -> void:
	if is_in_group("Alleato"):
		GruppoAvversario = "Nemico"
	else:
		GruppoAvversario = "Alleato"
		



func _physics_process(delta: float) -> void:
	if !is_fighting && can_move:
		velocity = direction * velocità * delta
		move_and_slide()
	else:
		velocity = Vector2.ZERO

func prendiDanno(danno:int):
	vita -= danno
	preso_Danno.emit(danno)
	if vita<=0:
		kill()

func kill():
	death.emit()
