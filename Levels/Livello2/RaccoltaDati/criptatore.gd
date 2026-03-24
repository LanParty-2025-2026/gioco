extends Node

const ENCRYPTION_KEY = "RotoloneBizoj84"

# Funzione per codificare in Base64
func encode_base64(input: String) -> String:
	return Marshalls.raw_to_base64(input.to_utf8_buffer())

# Funzione per decodificare da Base64
func decode_base64(input: String) -> String:
	return Marshalls.base64_to_raw(input).get_string_from_utf8()

func encrypt_file(input_path: String, output_path: String) -> void:
	print("Inizio cifratura...")
	
	var file = FileAccess.open(input_path, FileAccess.READ)
	if not file:
		print("Errore lettura file: ", FileAccess.get_open_error())
		return
		
	var content = file.get_as_text()
	file.close()
	
	# Prima cifra il contenuto
	var encrypted = ""
	var key_length = ENCRYPTION_KEY.length()
	
	for i in range(content.length()):
		var char_num = content.unicode_at(i)
		var key_char = ENCRYPTION_KEY.unicode_at(i % key_length)
		encrypted += char((char_num + key_char) % 65536)  # Usa modulo per mantenersi nel range Unicode
	
	# Poi codifica in Base64 per sicurezza nella scrittura
	var encoded = encode_base64(encrypted)
	
	var dir = OS.get_user_data_dir()
	var output_file = FileAccess.open(output_path, FileAccess.WRITE)
	if not output_file:
		print("Errore scrittura file: ", FileAccess.get_open_error())
		return
		
	output_file.store_string(encoded)
	output_file.close()
	print("File cifrato salvato in: ", output_path)

func decrypt_file(input_path: String, output_path: String) -> void:
	print("Inizio decifratura...")
	
	var file = FileAccess.open(input_path, FileAccess.READ)
	if not file:
		print("Errore lettura file: ", FileAccess.get_open_error())
		return
		
	var encoded_content = file.get_as_text()
	file.close()
	
	# Prima decodifica da Base64
	var encrypted = decode_base64(encoded_content)
	
	# Poi decifra il contenuto
	var decrypted = ""
	var key_length = ENCRYPTION_KEY.length()
	
	for i in range(encrypted.length()):
		var char_num = encrypted.unicode_at(i)
		var key_char = ENCRYPTION_KEY.unicode_at(i % key_length)
		var dec_char = (char_num - key_char + 65536) % 65536  # Aggiunge 65536 per gestire i numeri negativi
		decrypted += char(dec_char)
	
	var output_file = FileAccess.open(output_path, FileAccess.WRITE)
	if not output_file:
		print("Errore scrittura file: ", FileAccess.get_open_error())
		return
		
	output_file.store_string(decrypted)
	output_file.close()
	print("File decifrato salvato in: ", output_path)

# Test nel _ready
func cripta():
	var test_file = "res://RaccoltaDati/dati.txt"
	var encrypted_file = "res://RaccoltaDati/encrypted.txt"
	var decrypted_file = "res://RaccoltaDati/decrypted.txt"
	
	encrypt_file(test_file, encrypted_file)
	decrypt_file(encrypted_file, decrypted_file)
