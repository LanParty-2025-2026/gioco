extends Control
var label = Label
var timer = Timer
var text : int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer = $Timer
	
	timer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
