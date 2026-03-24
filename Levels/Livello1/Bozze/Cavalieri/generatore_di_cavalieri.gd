extends Node

const meteora = preload("uid://ctl0vvfcd3bg7")
@onready var timer: Timer = $Timer
@export var minSpawn: float = 1
@export var maxSpawn: float = 5

func selezioneWaitTime():#seleziona il tempo di spawn cavalieri 
	timer.wait_time = randf_range(minSpawn,maxSpawn)

func selezionaPosizione() -> Vector2:
	var posizioni = $Posizioni.get_children()
	return posizioni.pick_random().position
	

func summonMeteorite():#istanzia e crea il nemico
	var asteroideinst = meteora.instantiate()
	asteroideinst.position = selezionaPosizione()
	$Cavalieri.add_child(asteroideinst)


func _on_timer_timeout() -> void:#summona e selezina il prossimo wait time
	summonMeteorite()
	selezioneWaitTime()
