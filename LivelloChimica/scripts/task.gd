extends Node2D
#Punti massimi che posso essere presi se la persona usa l'aiuto questi punti che vengono dati diminuiscono io davo 25 punti
#per task togliendo 10 punti per ogni volta che usavano l'aiuto
var puntiDaDare = 75
var lvl1 : String
var lvl2 : String
var counterlvl = 0
var base : String
var completato = false
var open = true
var p = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.text = base
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if completato == true and p == true:
		$Label.text = "completato"
		get_parent().punti += puntiDaDare
		get_parent().get_parent().get_parent().get_parent().addPunti(puntiDaDare)
		print(str(get_parent().punti) + " punti")
		$Button.hide()
		$Label2.hide()
		p = false
	pass


func _on_button_button_down() -> void:
	counterlvl = counterlvl + 1
	if(counterlvl == 1):
		$Label.text = $Label.text + " --> " +lvl1 
		puntiDaDare = puntiDaDare-35
	else:
		$Label.text = base + " --> " + lvl2
		puntiDaDare = puntiDaDare-25
		$Button.hide()
		$Label2.hide()
	pass # Replace with function body.


func _on_scomparsa_button_down() -> void:
	if(open):
		self.move_local_x(400)
		open = false;
	else:
		self.move_local_x(-400)
		open = true;
	pass # Replace with function body.
