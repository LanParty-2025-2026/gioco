
extends Node

const colpo = preload("res://Levels/Livello1/Objects/colpo.tscn")

@onready var cavalieri: Node = $"../GeneratoreDiCavalieri/Cavalieri"
@onready var input: LineEdit = $"../Input/Input"
@onready var testo_vis: Label = $"../Input/SkinInput"
@onready var bersaglio_sprite: AnimatedSprite2D = %Bersaglio/Sprite2D
@onready var freccia: Sprite2D = %Bersaglio/Sprite2D2

#controlla ogni frame che nella casella input sia presente il valore corretto
func _process(delta: float) -> void:
	var cavalieriPresenti = cavalieri.get_children()
	for i in range(len(cavalieriPresenti)):
		if is_instance_valid(cavalieriPresenti[i]):
			if input.text == str(cavalieriPresenti[i].risultato) && !cavalieriPresenti[i].indovinato:
				arcoSparo(cavalieriPresenti[i].global_position)
				await get_tree().create_timer(0.25).timeout
				if is_instance_valid(cavalieriPresenti[i]):
					if input.text == str(cavalieriPresenti[i].risultato) && !cavalieriPresenti[i].indovinato:
						$"../Input".resetInput()
						istanziaProiettile(cavalieriPresenti[i])
						cavalieriPresenti[i].indovinato =  true
						cavalieriPresenti[i].velocità = cavalieriPresenti[i].velocità / 2
						if !bersaglio_sprite.is_playing():
							bersaglio_sprite.play("default")
							freccia.visible = false
							await bersaglio_sprite.animation_finished
							$loading.play()
							freccia.visible = true

				

			
			

#!!DEBUG!!
var cavalieriDistrutti = 0

#crea il proiettile e gli da i valori
func istanziaProiettile(nemico: CharacterBody2D):
	$sparo.play()
	print("colpo istanziato")
	var colpoINST = colpo.instantiate()
	colpoINST.position = %Bersaglio.position
	colpoINST.direzione = nemico.position
	colpoINST.bersaglio = nemico
	add_child(colpoINST)
		
		
	#!!RIMUOVERE DOPO DEBUG!!
	cavalieriDistrutti += 1
	get_parent().get_parent().get_parent().addPunti(10)
	#$"../Punteggio".text = "Punteggio: "+str(cavalieriDistrutti)

func arcoSparo(bersaglio: Vector2):
	bersaglio_sprite.look_at(bersaglio)
	bersaglio_sprite.rotation += deg_to_rad(90)
	freccia.look_at(bersaglio)
	freccia.rotation += deg_to_rad(45)
	
