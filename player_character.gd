extends CharacterBody2D

@export var speed := 75
var attacking := false
var dead := false   # <--- NEW

@export var max_health := 50
var health := max_health

@onready var swordSwing: Area2D = $swordSwing

signal health_changed
signal died

var score: int = 0
signal applyPoints

func add_points(amount: int):
	print("points2: ", amount)
	score += amount
	emit_signal("applyPoints", score)
	
func spend_gold(amount: int) -> bool:
	print("score: ", score)
	if amount > score:   # cost is higher than what you have
		print("not enough gold")
		return false
	else:
		print("Enough gold")
		score -= amount
		emit_signal("applyPoints", score)
		return true
		
func upgrade(thing, amount):
	match thing:
		"health":
			max_health += amount
		"speed":
			speed += amount
		"attack":
			swordSwing.attack+= amount
	

func _physics_process(delta):
	if dead:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	# Movement only works if not attacking
	if not attacking:
		var direction := Vector2.ZERO
		if Input.is_action_pressed("move_right"):
			direction.x += 1
		if Input.is_action_pressed("move_left"):
			direction.x -= 1
		if Input.is_action_pressed("move_down"):
			direction.y += 1
		if Input.is_action_pressed("move_up"):
			direction.y -= 1

		velocity = direction.normalized() * speed
		
		# Animation logic
		if velocity != Vector2.ZERO: 
			$AnimatedSprite2D.play("run")
		else:
			$AnimatedSprite2D.play("idle")
		
		# Flip sprite depending on direction
		if direction.x > 0:
			$AnimatedSprite2D.flip_h = false
			$swordSwing.scale.x = 1
			$CollisionShape2D.scale.x = 1
		elif direction.x < 0:
			$AnimatedSprite2D.flip_h = true
			$swordSwing.scale.x = -1
			$CollisionShape2D.scale.x = -1
	else:
		velocity = Vector2.ZERO

	move_and_slide()

	# Attack input
	if Input.is_action_just_pressed("attack") and not attacking:
		attacking = true
		$AnimatedSprite2D.play("attack")
		$swordSwing/Sound.play()


func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "death":
		# After death animation, reset state
		attacking = false
		$AnimatedSprite2D.play("idle")
		return

	if $AnimatedSprite2D.animation == "attack":
		attacking = false
		if velocity != Vector2.ZERO:
			$AnimatedSprite2D.play("run")
		else:
			$AnimatedSprite2D.play("idle")



func _on_animated_sprite_2d_frame_changed() -> void:

	var anim = $AnimatedSprite2D.animation
	var frame = $AnimatedSprite2D.frame
	
	if anim == "attack" and frame == 3:
		$swordSwing._on_attack()
	
	if anim == "death" and frame == 11:
		emit_signal("died")


func apply_damage(amount):
	if dead:
		return
	health -= amount
	var percent = float(health) / float(max_health)
	emit_signal("health_changed", percent * 100)
	if health <= 0:
		health = 0
		die()


func die():
	$AnimatedSprite2D.play("death")
	velocity = Vector2.ZERO
	attacking = true

func heal():
	health = max_health
	apply_damage(0)
	
