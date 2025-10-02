extends CharacterBody2D

@export var speed: float = 80.0          # pixlar/sekund
@export var stop_distance: float = 0.0    # 0 = stannar aldrig; >0 = stanna nära spelaren

var player: Node2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		push_error("[Enemy] Ingen nod i gruppen 'player' hittades. Lägg din spelare i gruppen 'player' eller använd NodePath-varianten.")

func _physics_process(delta: float) -> void:
	if player == null or not is_instance_valid(player):
		return

	var to_player: Vector2 = player.global_position - global_position
	var dist: float = to_player.length()

	if stop_distance > 0.0 and dist <= stop_distance:
		velocity = Vector2.ZERO
	else:
		var dir: Vector2 = (to_player / dist) if dist > 0.0001 else Vector2.ZERO
		velocity = dir * speed

	move_and_slide()

	# (valfritt) låt fienden rotera i färdriktningen:
	# if velocity.length() > 0.01:
	#     rotation = velocity.angle()
