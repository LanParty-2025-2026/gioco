
extends Node

#nodo responsabile del combattimento della truppa.
#indica se fermarsi e quanto velocemente attaccare

@onready var RayCast: RayCast2D = $"../RayCast2D"
@onready var timer: Timer = $Timer



func _physics_process(delta: float) -> void:
	#abilitatore di combattimento
	if RayCast.is_colliding() && !get_parent().is_fighting:
		abilita_combattimento() #imposta la truppa in modalità combattimento
		$"../AnimationNode".attacco_signal() #effettua un primo attacco senza delay
		abilitaTimer() #abilita i successivi attacchi con delay
	elif !RayCast.is_colliding():
		disabilita_combattimento() #se non ha nessuno davanti disabilita la modalità combact

func abilitaTimer():
	timer.start() #fa startare il timer per il signal

func attacca():
	$"../AnimationNode".attacco_signal()
	if RayCast.is_colliding():
		if is_instance_valid(RayCast.get_collider()):
			RayCast.get_collider().prendiDanno(get_parent().danno+randi_range(-2,3)) #effettua il danno
			abilitaTimer() # riabilita il danno per il prossimo attacco

func abilita_combattimento():
	get_parent().is_fighting = true

func disabilita_combattimento():
	get_parent().is_fighting = false

func abilita_radar():
	RayCast.enabled = true

func disabilita_radar():
	RayCast.enabled = false
