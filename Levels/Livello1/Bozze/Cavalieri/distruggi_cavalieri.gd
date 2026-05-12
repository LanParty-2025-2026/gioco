
extends Node

const colpo = preload("res://Levels/Livello1/Objects/colpo.tscn")

@onready var cavalieri: Node = $"../GeneratoreDiCavalieri/Cavalieri"
@onready var input: LineEdit = $"../Input/Input"
@onready var testo_vis: Label = $"../Input/SkinInput"
@onready var bersaglio_sprite: AnimatedSprite2D = %Bersaglio/Sprite2D
@onready var freccia: Sprite2D = %Bersaglio/Sprite2D2

var _kill_in_progress: bool = false
var cavalieriDistrutti = 0

func _process(_delta: float) -> void:
	if _kill_in_progress:
		return
	var cavalieriPresenti = cavalieri.get_children()
	for cavaliere in cavalieriPresenti:
		if is_instance_valid(cavaliere) and not cavaliere.indovinato:
			if input.text == str(cavaliere.risultato):
				_kill_in_progress = true
				_esegui_kill(cavaliere)
				return

func _esegui_kill(cavaliere: CharacterBody2D) -> void:
	arcoSparo(cavaliere.global_position)
	await get_tree().create_timer(0.25).timeout
	if is_instance_valid(cavaliere) and not cavaliere.indovinato:
		if input.text == str(cavaliere.risultato):
			$"../Input".resetInput()
			istanziaProiettile(cavaliere)
			cavaliere.indovinato = true
			cavaliere.velocità = cavaliere.velocità / 2
			if not bersaglio_sprite.is_playing():
				bersaglio_sprite.play("default")
				freccia.visible = false
				await bersaglio_sprite.animation_finished
				$loading.play()
				freccia.visible = true
	_kill_in_progress = false

func istanziaProiettile(nemico: CharacterBody2D):
	$sparo.play()
	var colpoINST = colpo.instantiate()
	colpoINST.position = %Bersaglio.position
	colpoINST.direzione = nemico.position
	colpoINST.bersaglio = nemico
	add_child(colpoINST)
	cavalieriDistrutti += 1
	get_parent().get_parent().get_parent().addPunti(10)

func arcoSparo(bersaglio: Vector2):
	bersaglio_sprite.look_at(bersaglio)
	bersaglio_sprite.rotation += deg_to_rad(90)
	freccia.look_at(bersaglio)
	freccia.rotation += deg_to_rad(45)
