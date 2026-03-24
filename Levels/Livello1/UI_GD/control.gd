
extends Control

##DATI problemi tecnici dell'engine non è possibile togliere
#la barra che lampeggia durante la ascrittura
#per questo è stata utilizzata una label che riflette ciò che è scritto
#nell'input mentre quest'ultimo è invisibile

@onready var input: LineEdit = $Input
@onready var testo_vis: Label = $SkinInput

#permette di non staccare il focus di scrittura 
func _ready() -> void:  
	input.grab_focus()
	input.focus_exited.connect(_on_focus_exited)
	input.virtual_keyboard_type = LineEdit.KEYBOARD_TYPE_NUMBER
	input.text_changed.connect(_on_input_text_changed)

#permette di scrivere solo valori numerici
func _on_input_text_changed(new_text: String) -> void:
	var solo_numeri = ""
	for carattere in new_text:
		if carattere.is_valid_int():  
			solo_numeri += carattere
	input.set_text(solo_numeri)
	input.caret_column = solo_numeri.length()

#rimette il focus se si dovesse togliere 
func _on_focus_exited() -> void:
	input.grab_focus()
	
func _process(delta: float) -> void:
	aggiornaTesto()

#aggiorna la label contente l'input
func aggiornaTesto():
	testo_vis.text = input.text
	
func resetInput():
	input.text = ""
