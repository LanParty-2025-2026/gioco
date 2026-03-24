extends Label

@onready var animation_player: AnimationPlayer = $AnimationPlayer
#@onready var sprite: Node = $"../AnimationNode".sprite
#@onready var truppa: CharacterBody2D = $".."


var danno_ricevuto:int

func _ready() -> void:
	preso_danno(danno_ricevuto)

func preso_danno(danno:int= 0) -> void:
	text = str(danno)
	animation_player.play("DannoLabel")
	
