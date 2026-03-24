extends Node


#I punti vengono mandati dallo script task.gd qui dove ce la racolta di tutti i punti poiche ogni scenario task manda dei punti quando completata
var elementi_completati = 0
var punti = 0

var element_scene = preload("res://LivelloChimica/scene/elemento.tscn")
var task_scene = preload("res://LivelloChimica/scene/task.tscn") 
# Punti di spawn
var tasks = ["Anidride carbonica",'Acqua',"Metano","Cloruro di sodio(sale da cucina)","Ammoniaca","Acido cloridrico"]
var taskTracker = []
var formulaLVL1 = {
	"Acqua" : "H2 + ?", 
	"Anidride carbonica" :  "C + ?", 
	"Metano" : "C? + H2", 
	"Cloruro di sodio(sale da cucina)" : "Na + ?",
	"Ammoniaca" : "NH2 + ?", 
	"Acido cloridrico" : "H + ?"
}
var formulaLVL2 = {
	"Acqua" : "H2 + O", 
	"Anidride carbonica" : "C + O2", 
	"Metano" : "CH2 + H2", 
	"Cloruro di sodio(sale da cucina)" : "Na + Cl",
	"Ammoniaca" :"NH2 + H", 
	"Acido cloridrico" : "H + Cl"
	}
var bho : Node2D
var assets = {
	"H": load("res://LivelloChimica/assets/Elementi/Idrogeno.png"), 
	"O" : load("res://LivelloChimica/assets/Elementi/Ossigeno.png"), 
	"C": load("res://LivelloChimica/assets/Elementi/Carbonio.png"), 
	"Cl" : load("res://LivelloChimica/assets/Elementi/Cloro.png"), 
	"N": load("res://LivelloChimica/assets/Elementi/Azoto.png"), 
	"S" : load("res://LivelloChimica/assets/Elementi/Zolfo.png"), 
	"K": load("res://LivelloChimica/assets/Elementi/Potassio.png"), 
	"Na" : load("res://LivelloChimica/assets/Elementi/Sodio.png"), 
	"Acqua" : load("res://LivelloChimica/assets/Task/Acqua.png"),
	"O2" : load("res://LivelloChimica/assets/CombinazioniIntermedie/O2.png"),
	"H2" : load("res://LivelloChimica/assets/CombinazioniIntermedie/H2.png"),
	"Anidride carbonica" : load("res://LivelloChimica/assets/Task/AnidrideCarbonica.png"),
	"Metano":load("res://LivelloChimica/assets/Task/Metano.png"),
	"Cloruro di sodio(sale da cucina)": load("res://LivelloChimica/assets/Task/sale.png"),
	"Ozono": load("res://LivelloChimica/assets/Task/Ozono.png"),
	"Monossido di carbonio/CO" : load("res://LivelloChimica/assets/CombinazioniIntermedie/CO.png"),
	"Cianuro/CN" : load("res://LivelloChimica/assets/CombinazioniIntermedie/CN.png"),
	"Metilene/CH2" : load("res://LivelloChimica/assets/CombinazioniIntermedie/CH2.png"),
	"Ione ammoniuro/NH2": load("res://LivelloChimica/assets/CombinazioniIntermedie/NH2.png"),
	"Ammoniaca":load("res://LivelloChimica/assets/CombinazioniIntermedie/Amoniaca.png"),
	"Acido cloridrico":load("res://LivelloChimica/assets/Task/AcidoTentativo.png"),
	"Cianuro di potassio":load("res://LivelloChimica/assets/Task/Maschera.png")
	}
var combinazioni = { 
	"Acqua": ["H2", "O"], #esiste
	"H2": ["H", "H"], #esiste
	"O2": ["O", "O"] , #esiste
	"Anidride carbonica" : ["C", "O2"], #esiste
	"Monossido di carbonio/CO" : ["C","O"], #esiste
	"Anidride carbonica2" : ["Monossido di carboni/CO","O"], #esiste
	"Metilene/CH2" : ["C", "H2"], #esiste
	"Metano" : ["Metilene/CH2","H2"], #esiste
	"Cloruro di sodio(sale da cucina)" : ["Na","Cl"], #esiste
	"Ammoniaca": ["Ione ammoniuro/NH2","H"], #esiste
	"Ione ammoniuro/NH2" : ["N","H2"],#esiste
	"Acido cloridrico" : ["H", "Cl"], #esiste
	"Ozono":["O2","O"], #esiste
	"Cianuro/CN": ["C","N"], #esiste
	"Cianuro di potassio": ["K","Cianuro/CN"], #esiste
	}
# Numero iniziale di elementi da spawnare
var initial_count = 10
var instance = element_scene.instantiate()
var instanceTasks = task_scene.instantiate()
var position : Vector2
func _ready():
	var b = RandomNumberGenerator.new().randi_range(0,5);
	var task1 = tasks[b];
	tasks.remove_at(b);
	b = RandomNumberGenerator.new().randi_range(0,4);
	var task2 = tasks[b];
	tasks.remove_at(b);
	b = RandomNumberGenerator.new().randi_range(0,3);
	var task3 = tasks[b];
	tasks.remove_at(b)
	b = RandomNumberGenerator.new().randi_range(0,2);
	var task4 = tasks[b];
	tasks.remove_at(b)
	taskTracker = [spawn_task(Vector2(0, 70), task1),spawn_task(Vector2(0, 140), task2),spawn_task(Vector2(0, 210), task3),spawn_task(Vector2(0, 280), task4) ]

func spawn_element(position: Vector2, name):
	instance = element_scene.instantiate()
	instance.global_position = position
	instance.name = "Element_" + str(instance.get_instance_id())
	instance.element_name = name
	if name in assets:
		instance.sprite = assets[name]
	else :
		instance.sprite = load("res://LivelloChimica/assets/icon2.svg")
	add_child(instance)
	for i in range(taskTracker.size()):
		print(taskTracker[i])
		bho = taskTracker[i]
		if bho.base == name:
			taskTracker[i].completato = true
			elementi_completati += 1
		
	if elementi_completati == 4 or $"../Control/Timer".is_stopped():
		print("Fine")
		
		
	

func spawn_task(posizione: Vector2, name) -> Node2D:
	instanceTasks = task_scene.instantiate()
	instanceTasks.lvl1 = formulaLVL1[name]
	instanceTasks.lvl2 = formulaLVL2[name]
	instanceTasks.base = name
	instanceTasks.position = posizione
	add_child(instanceTasks)
	return instanceTasks

func handle_collision(node1: Node2D, node2: Node2D) -> void: 
		print("Collision detected between elements with IDs: ", node1.element_name, " and ", node2.element_name)
		for new_element in combinazioni:
			var pair = combinazioni[new_element]
			if(node1.element_name == pair[0] and node2.element_name == pair[1]) or (node1.element_name == pair[1] and node2.element_name == pair[0]):
				node1.queue_free()
				node2.queue_free()
				spawn_element(node1.position, new_element)

func _on_s_button_down() -> void:
	spawn_element(Vector2(200,300), "S")
	pass # Replace with function body.

func _on_cl_button_down() -> void:
	spawn_element(Vector2(200,300), "Cl")
	pass # Replace with function body.

func _on_na_button_down() -> void:
	spawn_element(Vector2(200,300), "Na")
	pass # Replace with function body.

func _on_k_button_down() -> void: 
	spawn_element(Vector2(200,300), "K")
	pass # Replace with function body.

func _on_n_button_down() -> void:
	spawn_element(Vector2(200,300), "N")
	pass # Replace with function body.

func _on_c_button_down() -> void:
	spawn_element(Vector2(200,300), "C")
	pass # Replace with function body.

func _on_h_button_down() -> void:
	spawn_element(Vector2(200,300), "H")
	pass # Replace with function body.

func _on_o_button_down() -> void:
	spawn_element(Vector2(200,300), "O")
	pass # Replace with function body.



func _on_area_2d_mouse_entered() -> void:
	pass # Replace with function body.


func _on_area_2d_mouse_exited() -> void:
	pass # Replace with function body.
