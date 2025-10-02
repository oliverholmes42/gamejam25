extends EnemyBase

@export var speed: float = 80.0           # pixels/second
@export var stop_distance: float = 20    # 0 = never stop; >0 = stop near player

var player: Node2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		push_error("[Enemy] No node in group 'player' found. Put your player in the 'player' group or assign via NodePath.")

func _process(delta: float) -> void:
	if player == null or not is_instance_valid(player):
		return

	var to_player: Vector2 = player.global_position - global_position
	var dist: float = to_player.length()

	if stop_distance > 0.0 and dist <= stop_distance:
		return  # do nothing, enemy stays put
	else:
		var dir: Vector2 = (to_player / dist) if dist > 0.0001 else Vector2.ZERO
		global_position += dir * speed * delta
