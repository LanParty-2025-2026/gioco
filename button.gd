extends Button

var count = 2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if count > 0:
		get_parent().get_parent().rpc_id(1, "aggiornaListaServer")
		count = count - 1
	

func _on_button_down() -> void:
	get_parent().get_parent().rpc_id(1,"rimuoviListaServer",1)
	get_parent().get_parent().cambiaPersonaggio("1")

func _on_button_2_button_down() -> void:
	get_parent().get_parent().rpc_id(1,"rimuoviListaServer",2)
	get_parent().get_parent().cambiaPersonaggio("2")

func _on_button_3_button_down() -> void:
	get_parent().get_parent().rpc_id(1,"rimuoviListaServer",3)
	get_parent().get_parent().cambiaPersonaggio("3")

func _on_button_4_button_down() -> void:
	get_parent().get_parent().rpc_id(1,"rimuoviListaServer",4)
	get_parent().get_parent().cambiaPersonaggio("4")
