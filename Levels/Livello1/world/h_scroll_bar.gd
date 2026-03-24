extends HScrollBar


func _on_value_changed(value: float) -> void:
	$"../../GeneratoreDiCavalieri".selezioneWaitTime()
	$"../../GeneratoreDiCavalieri".get_node("Timer").stop()
	$"../../GeneratoreDiCavalieri".get_node("Timer").start()
	$"../Label".text = "vel. spawn min: "+str(floor(value))
	$"../../GeneratoreDiCavalieri".minSpawn = value
	$"../../GeneratoreDiCavalieri".maxSpawn = value
