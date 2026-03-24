extends Node2D

signal chiudiMenu
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_server_button_down() -> void:
	if get_parent().get_parent().get_parent().classe != null:
		hide()
		get_parent().get_parent().get_parent().crea_server()


func cambia_ip() -> void:
	get_parent().get_parent().get_parent().ip = $TextEdit.text
	
func cambia_classe() -> void:
	get_parent().get_parent().get_parent().classe = $TextEdit2.text
	
func cambia_n_players() -> void:
	get_parent().get_parent().get_parent().n_players = int($TextEdit3.text)

func _on_text_edit_text_submitted(new_text: String) -> void:
	hide() # Replace with function body.
	cambia_ip()


func _on_classe_text_submitted(new_text: String) -> void:
	get_parent().get_parent().get_parent().classe = new_text


func _on_text_edit_2_text_submitted(new_text: String) -> void:
	cambia_classe()


func _on_text_edit_text_changed(new_text: String) -> void:
	cambia_ip()


func _on_text_edit_2_text_changed(new_text: String) -> void:
	cambia_classe()


func _on_text_edit_3_text_changed(new_text: String) -> void:
	cambia_n_players()


func _on_text_edit_3_text_submitted(new_text: String) -> void:
	cambia_n_players()
