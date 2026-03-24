extends Node



func load_json(path: String):
	# Verifica l'esistenza del file
	if not FileAccess.file_exists(path):
		push_error("File non trovato!")
		return null
	
	# Apre il file e legge il contenuto
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		var error = FileAccess.get_open_error()
		push_error("Errore nell'apertura del file: ", error)
		return null
	
	# Parsing del contenuto JSON
	var content = file.get_as_text()
	var json = JSON.new()
	var parse_result = json.parse(content)
	
	if parse_result != OK:
		push_error("Errore nel parsing JSON alla linea ", json.get_error_line())
		push_error("Messaggio errore: ", json.get_error_message())
		return null
	
	return json.data
