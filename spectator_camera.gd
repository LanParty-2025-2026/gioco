extends Camera2D

# Label da aggiornare con le info del giocatore osservato (assegnata da world.gd)
var info_label: Label = null

# Secondi tra un cambio di POV e l'altro
var switch_interval: float = 5.0

var current_index: int = 0
var elapsed: float = 0.0

func _process(delta: float) -> void:
	elapsed += delta

	# Cambia giocatore ogni switch_interval secondi
	if elapsed >= switch_interval:
		elapsed = 0.0
		_prossimo_giocatore()

	_segui_giocatore()

func _segui_giocatore() -> void:
	var players = get_tree().get_nodes_in_group("players")
	if players.size() == 0:
		if info_label:
			info_label.text = "In attesa di giocatori..."
		return

	# Assicura che l'indice sia valido
	current_index = current_index % players.size()
	var target = players[current_index]

	if is_instance_valid(target):
		global_position = target.global_position
		if info_label:
			info_label.text = "POV: Giocatore " + target.name + \
				"  [" + str(current_index + 1) + "/" + str(players.size()) + "]"

func _prossimo_giocatore() -> void:
	var players = get_tree().get_nodes_in_group("players")
	if players.size() == 0:
		return
	current_index = (current_index + 1) % players.size()
