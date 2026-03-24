extends CharacterBody2D

@onready var player 
@onready var anims = $AnimatedSprite2D
@onready var area = $Area2D
var isHitted = false
var health = 10
var isAlive = true

const SPEED = 80.0
const JUMP_VELOCITY = -400.0

func _ready() -> void:
	if is_multiplayer_authority():
		var distance = 10000
		for child in get_tree().get_nodes_in_group("players"):
			var tempPos = child.global_position - global_position
			if sqrt(tempPos.x * tempPos.x + tempPos.y * tempPos.y) < distance and child.dead == false:
				distance = sqrt(tempPos.x * tempPos.x + tempPos.y * tempPos.y)
				player = child
			print(child)
		anims.play("walk")
		area.name = "nemico"
	
	
func _physics_process(delta: float) -> void:
	if is_multiplayer_authority() and isAlive:
		if player != null:
			if player.dead == false:
				var direction = player.global_position - global_position
				#print(direction)
				velocity = direction.normalized() * SPEED
				if direction.x > 0:
					anims.flip_h = false
				elif direction.x < 0:
					anims.flip_h = true
			else:
				velocity.x = 0
				velocity.y = 0
				var distance = 100000
				for child in get_tree().get_nodes_in_group("players"):
					var tempPos = child.global_position - global_position
					if sqrt(tempPos.x * tempPos.x + tempPos.y * tempPos.y) < distance and child.dead == false:
						distance = sqrt(tempPos.x * tempPos.x + tempPos.y * tempPos.y)
						player = child
				
					
		move_and_slide()




func _on_area_2d_area_entered(area: Area2D) -> void:
	print(area.name)
	if is_multiplayer_authority():
		if area.name == "arma" && !isHitted:
			var item = area.get_parent()
			if item.isAttacking == true:
				isHitted = true
				var knock = (global_position - item.global_position).normalized()
				knock = knock * 60
				#velocity = knock * 50
				if position.x + knock.x < 200 or position.x + knock.x  > 1000:
					knock.x = 0
				if  position.y + knock.y < 100 or position.y + knock.y > 548:
					knock.y = 0
				var tween = get_tree().create_tween()
				
				tween.tween_property($AnimatedSprite2D, "modulate", Color(1, 0.4, 0.4), 0.05)
				tween.tween_property(self, "position", position + knock, 0.1)
				tween.tween_property($AnimatedSprite2D, "modulate", Color(1, 1, 1), 0.3)
				var killed = damage(item.damage)
				if killed:
					var prop = area.get_parent().proprietario
					if prop != null and prop != "":
						var p = get_node_or_null("/root/World/"+prop)
						if p:
							p.addPunti(5)
				isHitted = false
				move_and_slide()
				
	elif area.name == "arma":
		
		var item = area.get_parent()
		if item.isAttacking == true:
			var knock = (global_position - item.global_position).normalized()
			knock = knock * 60
			rpc_id(1, "colpitoServer", knock, item.damage, area.get_parent().proprietario)
@rpc("any_peer")
func colpitoServer(knock, damage_amount, proprietario):
	if not isAlive:
		return
	isHitted = true
	if position.x + knock.x < 200 or position.x + knock.x  > 1000:
			knock.x = 0
	if  position.y + knock.y < 100 or position.y + knock.y > 548:
			knock.y = 0
	var tween = get_tree().create_tween()
	var sprite = get_node_or_null("AnimatedSprite2D")
	if sprite:
		tween.tween_property(sprite, "modulate", Color(1, 0.4, 0.4), 0.05)
		tween.tween_property(self, "position", position + knock, 0.1)
		tween.tween_property(sprite, "modulate", Color(1, 1, 1), 0.3)
	else:
		tween.tween_property(self, "position", position + knock, 0.1)
	var killed = damage(damage_amount)
	if killed and proprietario != null and proprietario != "":
		var p = get_node_or_null("/root/World/"+proprietario)
		if p:
			p.addPunti(5)
	isHitted = false
	move_and_slide()
	
	
		
func damage(damage) -> bool:
	var out = false
	
	print(damage)
	health = health - damage
	if health <= 0:
		death()
		out = true
	return out
		
		
func death():
	$Timer.start(2)
	isAlive = false
	visible = false
	for child in get_children():
		if child.name != "Timer" and child.name != "AnimatedSprite2D" and child.name != "MultiplayerSynchronizer":
			child.queue_free()


func _on_timer_timeout() -> void:
	get_parent().spawnaEnemy()
	queue_free()
	
