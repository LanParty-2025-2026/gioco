extends Node2D

const port = 8888
var player = preload("res://player.tscn")
@onready var menu_node = $MenuContainer
@onready var level_node = $LevelContainer
@onready var timer = $Timer
@onready var timer2 = $Timer2
@onready var spawner = $MultiplayerSpawner
@onready var http_request = $HTTPRequest
var boss

var n_players = 4


var punteggio = 0

var ip_statico = ""

var arena = false
var selettore
var selettore2

var username 
var classe

var playerPronti = 0
var gioco_iniziato = false

var listaPersonaggi = [1,2,3,4]

var ip = "localhost"
var ciao = 0

var enet_peer = ENetMultiplayerPeer.new()
var is_host: bool = false

func _ready() -> void:
	# Carica il menu come sottoscena all'avvio
	load_menu()


	

func load_menu():
	# Rimuove qualsiasi sottoscena attuale
	if level_node.get_child_count() > 0:
		level_node.get_child(0).queue_free()

	# Carica il menu come sottoscena 
	var menu_scene = load("res://menu.tscn").instantiate()
	menu_node.add_child(menu_scene)

func start_game():

	# Rimuovi il menu
	
	for child in menu_node.get_children():
		child.queue_free()

	# Avvia il multiplayer

	# Carica il livello come sottoscena
	load_level("res://Levels/Lobby.tscn")
	crea_client()
	$Label.z_index = 220
	$Punteggio.z_index = 220
	
	
func load_level(level_path: String) -> void:
	# Rimuove il livello precedente, se esiste
	for child in level_node.get_children():
		child.queue_free()
	#if level_node.get_child_count() > 0:
	#	level_node.get_child(0).queue_free()


	# Carica il nuovo livello
	var level_scene = load(level_path).instantiate()
	level_node.add_child(level_scene)

func crea_server() -> void:
	# Crea un server e connetti i segnali
	enet_peer.create_server(port)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(spawna_client)

	$MenuContainer.queue_free()
	$LevelContainer.queue_free()

func crea_client() -> void:
	# Crea un client e lo connette al server
	enet_peer.create_client(ip, port)
	multiplayer.multiplayer_peer = enet_peer
	print(ip)
	selettore = load("res://selettorePersonaggio.tscn").instantiate()
	add_child(selettore)
	selettore.z_index = 150
	rpc_id(1, "aggiornaListaServer")

func scegliArma():
	selettore2 = load("res://selettoreArma.tscn").instantiate()
	add_child(selettore2)
	selettore2.z_index = 150


func spawna_client(id) -> void:
	if gioco_iniziato or ciao >= n_players:
		multiplayer.multiplayer_peer.disconnect_peer(id)
		return
	# Spawna un player con un ID univoco
	var new_player = player.instantiate()
	new_player.name = str(id)
	#new_player.position.x = 600
	#new_player.position.y = 324
	add_child(new_player)
	new_player.add_to_group("players")
	ciao = ciao + 1
	print(ciao)
	rpc("impostaClasse", classe)
	rpc("aggiorna_contatore", ciao)
	#if (ciao >= 2):
		#for i in range(1, 2):
			#print("ciao" + str(i))
			#timer.wait_time = 10.0  # Durata del livello in secondi
			#timer.one_shot = false
			#timer.start()
			#await timer.timeout
			#rpc("start" , "res://Levels/Combattimento"+str(i)+"/world/world.tscn")
			#timer.wait_time = 10.0  # Durata del livello in secondi
			#timer.one_shot = false
			#timer.start()
			#await timer.timeout
			#rpc("nascondi_player_locale")
			#rpc("start" , "res://Levels/Livello"+str(i+1)+"/world/world.tscn")
			#timer.wait_time = 10.0  # Durata del livello in secondi
			#timer.one_shot = false
			#timer.start()
			#await timer.timeout	
			#rpc("start" , "res://Levels/Livello"+str(i+2)+"/world/world.tscn")
			
			
			
@rpc
func impostaClasse(serverClasse):
	classe = serverClasse

@rpc
func start(livello) -> void:
	# Funzione che verrà chiamata dal server
	load_level(livello)
	# Esegui altre azioni con il messaggio ricevuto

	# Esegui altre azioni con il messaggio ricevu
@rpc
func aggiorna_contatore(contatore) -> void:
	$Label.set_text("Player: "+ str(contatore))
	
@rpc
func aggiorna_timer_client(tempo_rimasto: int) -> void:
	# Mostra il tempo rimanente a schermo nei client
	$Label.set_text(str(tempo_rimasto))
var _timer_rpc_acc: float = 0.0
func _process(delta: float) -> void:
	if timer.is_stopped():
		return
	_timer_rpc_acc += delta
	if _timer_rpc_acc >= 1.0:
		_timer_rpc_acc = 0.0
		var tempo_rimasto = int(timer.get_time_left())
		rpc("aggiorna_timer_client", tempo_rimasto)

@rpc
func nascondi_player_locale():
	var client_id = multiplayer.get_unique_id()  # Ottieni l'ID del client locale
	var player_node = get_node_or_null(str(client_id))  # Cerca il nodo con il suo ID

	if player_node:  # Se il nodo esiste, lo nasconde
		player_node.hide()
		player_node.enabled = false
		player_node.position.x = -100
		player_node.position.y = -100
		print("Il player locale è stato nascosto")
	else:
		print("Errore: Il player locale non è stato trovato")


func cambiaPersonaggio(personaggio):
	var client_id = multiplayer.get_unique_id()
	var player_node = get_node_or_null(str(client_id))
	player_node.personaggio = personaggio
	player_node.nameColor()
	player_node.show()
	for child in selettore.get_children():
		child.queue_free()
	scegliArma()
		
func cambiaArma(arma):
	var client_id = multiplayer.get_unique_id()
	var player_node = get_node_or_null(str(client_id))
	#player_node.show()
	var weapon = player_node.get_node("weapon")
	var tempA
	if arma == "1":
		tempA = load("res://Weapon"+arma+".tscn").instantiate()
		tempA.proprietario = str(client_id)
	else:
		tempA = load("res://Pistola.tscn").instantiate()
		tempA.proprietario = str(client_id)

	#tempA.position.x = player_node.position.x + 50
	#tempA.position.y = player_node.position.y
	if arma == "1":
		player_node.arma = "Corpo"
	else:
		player_node.arma = "Distanza"
	weapon.add_child(tempA)
	for child in selettore2.get_children():
		child.queue_free()
	rpc_id(1, "aggiornaContatore")
	addPunti(0)
	#spawner.spawn(tempA)
	
	
@rpc("any_peer")
func aggiornaContatore():
	playerPronti = playerPronti +1
	if gioco_iniziato:
		return
	if (playerPronti >= n_players):
		gioco_iniziato = true
		for i in range(1, 2):
			print("ciao" + str(i))
			timer.wait_time = 5.0
			timer.one_shot = false
			timer.start()
			await timer.timeout
			rpc("start" , "res://Levels/Combattimento1/world/world.tscn")
			timer.wait_time = 60.0  # Combattimento 1 (4 nemici)
			timer.one_shot = false
			timer.start()
			arena = true
			spawnaEnemy()
			spawnaEnemy()
			spawnaEnemy()
			spawnaEnemy()
			await timer.timeout
			arena = false
			for child in get_tree().get_nodes_in_group("enemyes"):
				child.queue_free()

			rpc("nascondi_player_locale")

			rpc("start" , "res://intermezzo.tscn")
			timer.wait_time = 6.0
			timer.one_shot = false
			timer.start()
			await timer.timeout
			rpc("start" , "res://Levels/Livello1/world/world.tscn")
			timer.wait_time = 150.0  # Livello 1 - matematica
			timer.one_shot = false
			timer.start()
			await timer.timeout
			rpc("start" , "res://intermezzo.tscn")
			timer.wait_time = 6.0
			timer.one_shot = false
			timer.start()
			await timer.timeout
			rpc("mostra_player_locale")
			rev()
			rpc("start" , "res://Levels/Combattimento1/world/world.tscn")
			timer.wait_time = 60.0  # Combattimento 2 (5 nemici)
			timer.one_shot = false
			timer.start()
			arena = true
			spawnaEnemy()
			spawnaEnemy()
			spawnaEnemy()
			spawnaEnemy()
			spawnaEnemy()
			await timer.timeout
			arena = false
			for child in get_tree().get_nodes_in_group("enemyes"):
				child.queue_free()

			rpc("nascondi_player_locale")
			rpc("start" , "res://intermezzo.tscn")
			timer.wait_time = 6.0
			timer.one_shot = false
			timer.start()
			await timer.timeout
			rpc("start" , "res://LivelloChimica/scene/minigiochi.tscn")
			timer.wait_time = 150.0  # Livello Chimica
			timer.one_shot = false
			timer.start()
			await timer.timeout
			rpc("start" , "res://intermezzo.tscn")
			timer.wait_time = 6.0
			timer.one_shot = false
			timer.start()
			await timer.timeout
			rpc("mostra_player_locale")
			rev()
			rpc("start" , "res://Levels/Combattimento1/world/world.tscn")
			timer.wait_time = 60.0  # Combattimento 3 (6 nemici)
			timer.one_shot = false
			timer.start()
			arena = true
			spawnaEnemy()
			spawnaEnemy()
			spawnaEnemy()
			spawnaEnemy()
			spawnaEnemy()
			spawnaEnemy()
			await timer.timeout
			arena = false
			for child in get_tree().get_nodes_in_group("enemyes"):
				child.queue_free()

			rpc("nascondi_player_locale")
			rpc("start" , "res://intermezzo.tscn")
			timer.wait_time = 6.0
			timer.one_shot = false
			timer.start()
			await timer.timeout
			rpc("start" , "res://Levels/Livello3/main.tscn")
			timer.wait_time = 120.0  # Livello 3 - Quiz UE
			timer.one_shot = false
			timer.start()
			await timer.timeout
			rpc("start" , "res://intermezzo.tscn")
			timer.wait_time = 6.0
			timer.one_shot = false
			timer.start()
			await timer.timeout
			rpc("start" , "res://Levels/Livello2/World/world.tscn")
			timer.wait_time = 150.0  # Livello 2 - battaglie torri
			timer.one_shot = false
			timer.start()
			await timer.timeout

			rpc("nuclearizzaTorri")
			rpc("start" , "res://intermezzo.tscn")
			timer.wait_time = 6.0
			timer.one_shot = false
			timer.start()
			await timer.timeout
			rpc("mostra_player_locale")
			rev()
			rpc("start" , "res://Levels/Combattimento1/world/world.tscn")
			timer.wait_time = 90.0  # Boss finale
			timer.one_shot = true
			timer.start()
			arena = true
			await get_tree().create_timer(8.0).timeout
			spawnaBoss()
			await timer.timeout
			boss.queue_free()
			arena = false
			for child in get_tree().get_nodes_in_group("enemyes"):
				child.queue_free()
			rpc("start" , "res://fine.tscn")
			rpc("aggiornaPunteggio")
			timer.stop()
func rev():
	for child in get_tree().get_nodes_in_group("players"):
		child.dead = false
		child.reviveSr()

@rpc
func nuclearizzaTorri():
	$LevelContainer.get_child(0).esplodiTrucco()
func spawna(pos, rot, damage):
	var client_id = multiplayer.get_unique_id()
	var forward = Vector2.RIGHT.rotated(rot).normalized()
	var velocity = forward * 800
	rpc_id(1,"spawnaServer", pos, rot, velocity, damage, str(client_id))
	
@rpc 
func aggiornaPunteggio():
	print(punteggio)
	var url = "http://classifica.gmasiero.it/studente"

	var headers = ["Content-Type: application/json"]
	var data = {
		"username": username,
		"punteggio": punteggio,
		"team": classe #sezione
		
	}
	var json_data = JSON.stringify(data)

	var err = http_request.request(url, headers, HTTPClient.METHOD_POST, json_data)
	if err != OK:
		print("Errore nell'invio: ", err)
	
func spawnaEnemy():
	var enemy = load("res://enemy.tscn")
	var generator = RandomNumberGenerator.new()
	
	var obj = enemy.instantiate()
	obj.position.x = generator.randi_range(50, 1150)
	obj.position.y = generator.randi_range(50, 598)
	obj.z_index = 140
	add_child(obj, true)
	obj.add_to_group("enemyes")
		

func spawnaBoss():
	boss = load("res://boss.tscn")
	var generator = RandomNumberGenerator.new()
	
	var obj = boss.instantiate()
	obj.position.x = generator.randi_range(50, 1150)
	obj.position.y = generator.randi_range(50, 598)
	obj.z_index = 140
	boss = obj
	add_child(obj, true)


@rpc("any_peer")
func spawnaServer(position, rotation, velocity, damage, proprietario):
	var obj = load("res://proiettile.tscn").instantiate()
	obj.position = position
	obj.rotation = rotation
	obj.velocity = velocity
	obj.damage = damage
	obj.proprietario = proprietario
	add_child(obj, true)
	print(obj.velocity)
	

func addPunti(punti):
	punteggio = punteggio + punti
	$Punteggio.text = "punteggio: " + str(punteggio)
		
	
@rpc
func mostra_player_locale():
	var client_id = multiplayer.get_unique_id()  # Ottieni l'ID del client locale
	var player_node = get_node_or_null(str(client_id))  # Cerca il nodo con il suo ID

	if player_node:  # Se il nodo esiste, lo nasconde
		player_node.position.x = 600
		player_node.position.y = 324
		player_node.show()
		player_node.enabled = true
		print("Il player locale è stato nascosto")
	else:
		print("Errore: Il player locale non è stato trovato")

@rpc("any_peer")
func aggiornaListaServer():
	rpc("aggiornaListaClient", listaPersonaggi)
	
@rpc("any_peer")
func rimuoviListaServer(elemento):
	listaPersonaggi[elemento-1] = 0
	print(listaPersonaggi)
	aggiornaListaServer()
	


@rpc	
func aggiornaListaClient(lista):
	listaPersonaggi = lista
	print(lista)
	for bottone in selettore.get_children():
		if listaPersonaggi[int(bottone.text)-1] != 0:
			print("presente")
		else:
			bottone.disabled = true
	
