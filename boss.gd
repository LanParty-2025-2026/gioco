extends CharacterBody2D

@onready var player
@onready var anims = $AnimatedSprite2D
var isHitted = false
var health = 3000
var is_attacking = false

var SPEED = 120.0
const JUMP_VELOCITY = -400.0
const ATTACK_RANGE = 80.0  # Distanza a cui il mostro può attaccare
const ATTACK_DAMAGE = 25   # Danno inflitto per attacco
var attack_cooldown = 1.5  # Tempo tra un attacco e l'altro
var can_attack = true      # Flag per controllare se può attaccare

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
		$rageStart.start()
		
		# Imposta il timer per il cooldown degli attacchi
		$AttackCooldown.wait_time = attack_cooldown
		$AttackCooldown.start()

func _physics_process(delta: float) -> void:
	if is_multiplayer_authority():
		if player != null && !is_attacking && !isHitted:  # Non inseguire mentre si attacca
			if player.dead == false:
				var direction = player.global_position - global_position
				var distance = direction.length()
				
				# Controlla se il giocatore è nel raggio d'attacco
				if distance < ATTACK_RANGE && can_attack:
					# Giocatore nel range: avvia attacco
					velocity = Vector2.ZERO  # Ferma il movimento
					attack()
				else:
					# Giocatore fuori range: continua a inseguire
					velocity = direction.normalized() * SPEED
					
				# Gestione dell'orientamento
				if direction.x > 0:
					anims.flip_h = false
				elif direction.x < 0:
					anims.flip_h = true
			else:
				# Cerca un nuovo giocatore se quello attuale è morto
				var distance = 100000
				for child in get_tree().get_nodes_in_group("players"):
					var tempPos = child.global_position - global_position
					if sqrt(tempPos.x * tempPos.x + tempPos.y * tempPos.y) < distance and child.dead == false:
						distance = sqrt(tempPos.x * tempPos.x + tempPos.y * tempPos.y)
						player = child
	move_and_slide()

# Funzione per gestire l'attacco
func attack():
	if !can_attack || is_attacking:
		return
		
	can_attack = false
	is_attacking = true
	anims.play("attack")
	$AttackCooldown.start()  # Riavvia il cooldown

# Chiamata quando l'animazione di attacco raggiunge il frame di impatto
func _on_animated_sprite_2d_frame_changed():
	if anims.animation == "attack" && anims.frame == 2:  # Sostituisci 2 con il frame di impatto
		perform_attack_impact()

# Esegue l'impatto dell'attacco
func perform_attack_impact():
	if player != null && !player.dead:
		var distance = global_position.distance_to(player.global_position)
		# Controlla se il giocatore è ancora nel range
		if distance < ATTACK_RANGE * 1.2:  # Con un po' di tolleranza
			player.rpc("sonoilPlayer", global_position)

# Gestisce la fine dell'animazione di attacco
func _on_animated_sprite_2d_animation_finished():
	if anims.animation == "attack":
		is_attacking = false
		anims.play("walk")  # Ritorna all'animazione di camminata

# Ripristina la possibilità di attaccare
func _on_attack_cooldown_timeout():
	can_attack = true

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
				tween.tween_property($AnimatedSprite2D, "modulate", Color(1, 0.4, 0.4), 0.15)
				tween.tween_property($AnimatedSprite2D, "modulate", Color(1, 1, 1), 0.3)
				var killed = damage(item.damage)
				if killed:
					var prop = area.get_parent().proprietario
					if prop != null and prop != "":
						var p = get_node_or_null("/root/World/"+prop)
						if p:
							p.addPunti(500)
				isHitted = false
				move_and_slide()
	elif area.name == "arma":
		var item = area.get_parent()
		if item.isAttacking == true:
			var knock = (global_position - item.global_position).normalized()
			knock = knock * 60
			rpc_id(1, "colpitoSf", knock, item.damage, area.get_parent().proprietario)

@rpc("any_peer")
func colpitoSf(knock, damage_amount, proprietario):
	isHitted = true
	if position.x + knock.x < 200 or position.x + knock.x  > 1000:
		knock.x = 0
	if  position.y + knock.y < 100 or position.y + knock.y > 548:
		knock.y = 0
	var tween = get_tree().create_tween()
	var sprite = get_node_or_null("AnimatedSprite2D")
	if sprite:
		tween.tween_property(sprite, "modulate", Color(1, 0.4, 0.4), 0.15)
		tween.tween_property(sprite, "modulate", Color(1, 1, 1), 0.3)
	var killed = damage(damage_amount)
	if killed and proprietario != null and proprietario != "":
		var p = get_node_or_null("/root/World/"+proprietario)
		if p:
			p.addPunti(500)
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
	queue_free()


func _on_rage_start_timeout() -> void:
	SPEED = 250
	$rageStop.start()


func _on_rage_stop_timeout() -> void:
	SPEED = 120
	$rageStart.start()	
