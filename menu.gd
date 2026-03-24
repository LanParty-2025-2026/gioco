extends Node2D

@onready var start_button = $Canvas/StartButton
@onready var timer = $Canvas/StartButton/Timer

var username

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MenuNascosto.hide() # Replace with function body.
	$LineEdit.max_length = 12


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("combinazione"):
		if $MenuNascosto.visible:
			$MenuNascosto.hide()
		else:
			$MenuNascosto.show()
	



func _on_start_button_button_down() -> void:
	timer.start(0.3)
	 # Replace with function body.


func _on_timer_timeout() -> void: # Replace with function body.
	if username != null:
		get_parent().get_parent().username = username
		get_parent().get_parent().start_game()
	
	
	


func _on_line_edit_text_submitted(new_text: String) -> void:
	username = new_text
