extends EnemyBase

@export var speed: float = 80.0           # pixels/second
@export var stop_distance: float = 20     # 0 = never stop; >0 = stop near player
@onready var flash_ani: AnimationPlayer = $Sprite2D/FlashAni

@onready var damage_zone: Area2D = $DamageZone
@onready var damage_tick: Timer = $DamageTick

var player: Node2D
var player_hitbox: Area2D = null

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		push_error("[Enemy] No node in group 'player' found. Put your player in the 'player' group or assign via NodePath.")
	
	# Setup timer for frequent damage
	damage_tick.wait_time = 0.5  # every 0.5s (adjust to taste)
	damage_tick.one_shot = false
	damage_tick.timeout.connect(_on_damage_tick_timeout)

	# Lägg fienden i en grupp som separationen använder
	add_to_group("enemy")
	
func _process(delta: float) -> void:
	if player == null or not is_instance_valid(player):
		return

	# Mjuk separation så enemies inte går in i varandra
	global_position += separation_push() * delta

	var to_player: Vector2 = player.global_position - global_position
	var dist: float = to_player.length()

	if stop_distance > 0.0 and dist <= stop_distance:
		return  # do nothing, enemy stays put
	else:
		var dir: Vector2 = (to_player / dist) if dist > 0.0001 else Vector2.ZERO
		global_position += dir * speed * delta


func _on_damage_zone_area_entered(area: Area2D) -> void:
	if area.name == "HitBox" and area.get_parent().is_in_group("player"):
		player_hitbox = area
		damage_tick.start()


func _on_damage_tick_timeout() -> void:
	if player_hitbox and is_instance_valid(player_hitbox):
		var player = player_hitbox.get_parent()
		if player.is_in_group("player"):
			print("applying")
			player.apply_damage(3)


func _on_damage_zone_area_exited(area: Area2D) -> void:
	if area == player_hitbox:
		player_hitbox = null
		damage_tick.stop()


func _on_hurt_flash_timer_timeout() -> void:
	pass # Replace with function body.


func _on_knockback_timer_timeout() -> void:
	pass # Replace with function body.


func _on_i_frames_timer_timeout() -> void:
	pass # Replace with function body.


# --------- Mjuk separation (kollision-känsla) ----------
func separation_push(radius := 28.0, strength := 100.0) -> Vector2:
	var push := Vector2.ZERO
	for other in get_tree().get_nodes_in_group("enemy"):
		if other == self:
			continue
		if not other is Node2D:
			continue
		var d := global_position.distance_to(other.global_position)
		if d > 0.0 and d < radius:
			push += (global_position - other.global_position).normalized() * (1.0 - d / radius)
	return push * strength
