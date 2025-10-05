extends EnemyBase

@export var speed: float = 250.0            # px/s
@export var stop_distance: float = 30.0    # 0 = aldrig stanna; >0 = stanna nära spelaren

@onready var damage_zone: Area2D = $DamageZone
@onready var damage_tick: Timer = $DamageTick

@onready var sprite: Sprite2D = $Sprite2D
@onready var flash_ani: AnimationPlayer = $Sprite2D/FlashAni

@onready var spawnRoar: AudioStreamPlayer2D = $spawnRoar

var player: Node2D
var player_hitbox: Area2D = null

func _ready() -> void:
	if spawnRoar:
		spawnRoar.play()
	player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		push_error("[Enemy] No node in group 'player' found. Put your player in the 'player' group.")

	# Damage-tick setup
	damage_tick.wait_time = 0.5
	damage_tick.one_shot = false
	if not damage_tick.timeout.is_connected(_on_damage_tick_timeout):
		damage_tick.timeout.connect(_on_damage_tick_timeout)

	# Lägg fienden i "enemy"-gruppen (för separation)
	if not is_in_group("enemy"):
		add_to_group("enemy")

func _process(delta: float) -> void:
	if player == null or not is_instance_valid(player) or is_dying:
		return

	# Enkel separation: mjuk push bort från andra fiender
	global_position += separation_push() * delta

	# Förfölj spelaren
	var to_player: Vector2 = player.global_position - global_position
	var dist: float = to_player.length()

	if stop_distance > 0.0 and dist <= stop_distance:
		return
	else:
		if dist > 0.0001:
			var dir: Vector2 = to_player / dist
			global_position += dir * speed * delta

func _on_damage_zone_area_entered(area: Area2D) -> void:
	if area.name == "HitBox" and area.get_parent().is_in_group("player"):
		player_hitbox = area
		damage_tick.start()

func _on_damage_tick_timeout() -> void:
	if player_hitbox and is_instance_valid(player_hitbox):
		var p: Node = player_hitbox.get_parent()
		if p.is_in_group("player") and p.has_method("apply_damage"):
			p.apply_damage(10)  # justera skadan här

func _on_damage_zone_area_exited(area: Area2D) -> void:
	if area == player_hitbox:
		player_hitbox = null
		damage_tick.stop()

# Mjuk separation (känns som kollision mellan fiender)
func separation_push(radius := 28.0, strength := 100.0) -> Vector2:
	var push := Vector2.ZERO
	for other in get_tree().get_nodes_in_group("enemy"):
		if other == self:
			continue
		if not other is Node2D:
			continue
		var o: Node2D = other
		var d := global_position.distance_to(o.global_position)
		if d > 0.0 and d < radius:
			push += (global_position - o.global_position).normalized() * (1.0 - d / radius)
	return push * strength
