extends CharacterBody2D

@export var speed := 75
var attacking := false

func _physics_process(delta):
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
	



func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "attack":
		attacking = false
		# After attack ends, go back to idle (or run if moving)
		if velocity != Vector2.ZERO:
			$AnimatedSprite2D.play("run")
		else:
			$AnimatedSprite2D.play("idle")


func _on_animated_sprite_2d_frame_changed() -> void:
	var anim = $AnimatedSprite2D.animation
	var frame = $AnimatedSprite2D.frame
	
	if anim == "attack" and frame == 3:
		$swordSwing._on_attack()
