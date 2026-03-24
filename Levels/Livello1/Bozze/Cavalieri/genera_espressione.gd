
extends Node

# Configuration
@export var numeroMin: int = 1
@export var numeroMax: int = 12

@onready var espressione: Label = $"../Control/Espressione"
@onready var risultato: Label = $"../Control/Risultato"

# Difficulty levels and their probabilities
var difficulty_ranges = {
	"easy": {"range": [1, 5], "value": 1},
	"medium": {"range": [6, 8], "value": 2},
	"hard": {"range": [9, 10], "value": 3}
}

func get_difficulty() -> int:
	var roll = randi_range(1, 10)
	for difficulty in difficulty_ranges.values():
		if roll >= difficulty.range[0] and roll <= difficulty.range[1]:
			return difficulty.value
	return 1  # Default to easy if something goes wrong

func _ready() -> void:
	var current_difficulty = get_difficulty()
	get_parent().difficolta = current_difficulty
	generate_valid_expression(current_difficulty)

func generate_valid_expression(difficulty: int) -> void:
	var valid = false
	var attempts = 0
	var max_attempts = 10  # Prevent infinite loops
	
	while !valid and attempts < max_attempts:
		var numbers = select_numbers(difficulty)
		var expression_array = assemble_expression(numbers)
		var result = calculate_expression(expression_array)
		
		if is_valid_result(result):
			display_expression(expression_array, result)
			valid = true
		else:
			attempts += 1
	
	if !valid:
		# Fallback to a simple expression if we couldn't generate a valid one
		generate_fallback_expression()

func select_numbers(difficulty: int) -> Array:
	var numbers = []
	for i in range(difficulty + 1):
		numbers.append(int(randi_range(numeroMin, numeroMax)))
	return numbers

func assemble_expression(numbers: Array) -> Array:
	var expression = []
	var available_operators = ["+", "-", "*", "/"]
	var complex_operators = ["*", "/"]
	
	var complex_op_count = 0
	var max_complex_ops = 1
	
	for i in range(len(numbers) - 1):
		expression.append(int(numbers[i]))
		
		var valid_operators = available_operators.duplicate()
		if complex_op_count >= max_complex_ops:
			valid_operators = valid_operators.filter(func(op): return op not in complex_operators)
		
		var operator = valid_operators[randi() % len(valid_operators)]
		expression.append(operator)
		
		if operator in complex_operators:
			complex_op_count += 1
	
	expression.append(int(numbers[-1]))
	return expression

func is_valid_result(result) -> bool:
	if result == null:
		return false
	if typeof(int(result)) != TYPE_INT:
		return false
	if int(result) < 1:
		return false
	return true

func safe_convert_to_int(value) -> int:
	if typeof(value) == TYPE_STRING:
		if not value.is_valid_int():
			return 0
		return value.to_int()
	elif typeof(value) == TYPE_INT:
		return value
	elif typeof(value) == TYPE_FLOAT:
		return int(value)
	return 0

func calculate_expression(expr: Array):
	var calc_array = expr.duplicate()
	
	# First pass: Handle multiplication and division
	var i = 0
	while i < calc_array.size():
		if i + 2 >= calc_array.size():
			break
			
		var current_operator = str(calc_array[i + 1])
		if current_operator == "*" or current_operator == "/":
			var left = safe_convert_to_int(calc_array[i])
			var right = safe_convert_to_int(calc_array[i + 2])
			var result
			
			if current_operator == "*":
				result = left * right
			else:  # Division
				if right == 0 or left % right != 0:
					return null
				result = left / right
			
			# Replace the three items with the result
			calc_array[i] = result
			calc_array.remove_at(i + 1)  # Remove operator
			calc_array.remove_at(i + 1)  # Remove second number
		else:
			i += 2
	
	# Second pass: Handle addition and subtraction
	i = 0
	while i < calc_array.size():
		if i + 2 >= calc_array.size():
			break
			
		var current_operator = str(calc_array[i + 1])
		var left = safe_convert_to_int(calc_array[i])
		var right = safe_convert_to_int(calc_array[i + 2])
		var result
		
		if current_operator == "+":
			result = left + right
		elif current_operator == "-":
			result = left - right
			
		# Replace the three items with the result
		calc_array[i] = result
		calc_array.remove_at(i + 1)  # Remove operator
		calc_array.remove_at(i + 1)  # Remove second number
	
	return safe_convert_to_int(calc_array[0])

func display_expression(expr_array: Array, result: int) -> void:
	var expr_text = ""
	for item in expr_array:
		expr_text += str(item)
	
	espressione.text = expr_text
	risultato.text = str(result)
	get_parent().risultato = int(result)
	
	#var operazioni = FileAccess.open("res://operazioni.txt", FileAccess.READ_WRITE)
	#operazioni.seek_end()
	#operazioni.store_string(expr_text + " = " + str(result) + "\n")
	#operazioni.close()

func generate_fallback_expression() -> void:
	var num1 = int(randi_range(numeroMin, numeroMax))
	var num2 = int(randi_range(numeroMin, numeroMax))
	var expr_array = [num1, "+", num2]
	var result = num1 + num2
	display_expression(expr_array, result)
