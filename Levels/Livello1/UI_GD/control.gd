
extends Control

# La LineEdit è fuori schermo intenzionalmente per nascondere il cursore lampeggiante.
# La SkinInput Label riflette visivamente il testo scritto.

@onready var input: LineEdit = $Input
@onready var testo_vis: Label = $SkinInput

func _ready() -> void:
	input.focus_mode = Control.FOCUS_ALL
	input.text_changed.connect(_on_input_text_changed)
	input.focus_exited.connect(_on_focus_exited)
	input.call_deferred("grab_focus")

func _on_input_text_changed(new_text: String) -> void:
	var solo_numeri = ""
	for carattere in new_text:
		if carattere.is_valid_int():
			solo_numeri += carattere
	if solo_numeri != new_text:
		input.set_text(solo_numeri)
		input.caret_column = solo_numeri.length()

func _on_focus_exited() -> void:
	input.call_deferred("grab_focus")

func _process(_delta: float) -> void:
	testo_vis.text = input.text

func resetInput() -> void:
	input.text = ""
	input.call_deferred("grab_focus")
