
extends Node

#nodo che seleziona in base al gruppo di appartenenza quali tipi di valori assegnare
#alla truppa
#si autoDistrugge alla fine

@onready var RayCast: RayCast2D = $"../RayCast2D"
@onready var Sprite: AnimatedSprite2D = $"../AnimationNode".sprite
@onready var posizione_nemico: Marker2D = $PosizioneNemico
@onready var posizione_alleato: Marker2D = $PosizioneAlleato
@onready var truppa: CharacterBody2D = $".."


func _ready() -> void:
	truppa.GruppoAvversario.call()
	if get_parent().is_in_group("Nemico"):
		truppa.direction = Vector2(1,0)
		RayCast.position = posizione_nemico.position
		Sprite.flip_h = false
		RayCast.rotation = deg_to_rad(180)
		truppa.set_collision_layer_value(8,true)
		RayCast.set_collision_mask_value(7,true)
	else:
		truppa.direction = Vector2(-1,0)
		RayCast.rotation = deg_to_rad(0)
		RayCast.position = posizione_alleato.position
		Sprite.flip_h = true
		truppa.set_collision_layer_value(7,true)
		RayCast.set_collision_mask_value(8,true)
	$"..".scale = Vector2(1.35,1.35)
	queue_free()
	
func elimina_animation(tipo_truppa:String)->AnimatedSprite2D:
	match tipo_truppa:
		"spada":
			$"../Lancia".queue_free()
			$"../Arco".queue_free()
			return $"../Spada"
		"lancia":
			$"../Spada".queue_free()
			$"../Arco".queue_free()
			return $"../Lancia"
		"arco":
			$"../Spada".queue_free()
			$"../Lancia".queue_free()
			return $"../Arco"
	return null
