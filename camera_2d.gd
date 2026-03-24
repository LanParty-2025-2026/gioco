extends Camera2D

@onready var player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.


  # percorso relativo al player

func _process(delta):
	if player != null:
		global_position = player.global_position
