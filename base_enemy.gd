extends Area2D
class_name EnemyBase

@export var health: int = 10
@export var points: int = 10


@export var knockback_pixels: float = 30.0
@export var knockback_time: float = 0.12

signal givePoints
signal AddKill

var is_dying: bool = false  

func take_damage(amount: int = 1) -> void:
	health -= amount


	if has_node("HitSfx"):
		var sfx: AudioStreamPlayer2D = $HitSfx
	
		if sfx.playing:
			sfx.stop()
		sfx.play(0.0)


	var ap: AnimationPlayer = get_node_or_null("Sprite2D/FlashAni") as AnimationPlayer
	if ap:
		ap.stop()
		ap.play("hit")

	
	var pl: Node2D = get_tree().get_first_node_in_group("player") as Node2D
	if pl:
		var v: Vector2 = global_position - pl.global_position
		if v.length() > 0.001:
			var dir: Vector2 = v.normalized()
			var tw: Tween = create_tween()
			tw.tween_property(self, "global_position", global_position + dir * knockback_pixels, knockback_time) \
				.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)


	print("%s took %d damage! Health now: %d" % [name, amount, health])
	if health <= 0:
		die()

func die() -> void:

	if is_dying:
		return
	is_dying = true

	print("%s died2." % name)
	emit_signal("givePoints", points)
	emit_signal("AddKill")


	set_process(false)
	set_physics_process(false)

	var dmg_tick: Timer = get_node_or_null("DamageTick") as Timer
	if dmg_tick:
		dmg_tick.stop()
	var dz: Area2D = get_node_or_null("DamageZone") as Area2D
	if dz:
		dz.monitoring = false
		dz.set_deferred("monitoring", false)
	
	monitoring = false
	set_deferred("monitoring", false)


	var death_len: float = _play_death_sfx_one_shot()


	var flash_len: float = 0.18
	var tween_len: float = knockback_time
	var wait_time: float = max(flash_len, tween_len, death_len)

	if wait_time > 0.0:
		var t: SceneTreeTimer = get_tree().create_timer(wait_time)
		t.timeout.connect(func(): queue_free())
	else:
		queue_free()

func _play_death_sfx_one_shot() -> float:
	var src: AudioStreamPlayer2D = get_node_or_null("DeathSfx") as AudioStreamPlayer2D
	if src == null or src.stream == null:
		src = get_node_or_null("HitSfx") as AudioStreamPlayer2D
		if src == null or src.stream == null:
			return 0.0

	var one: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	one.stream = src.stream
	one.volume_db = src.volume_db
	one.pitch_scale = src.pitch_scale
	one.bus = src.bus
	one.global_position = global_position

	var root: Node = get_tree().current_scene
	if root == null:
		return 0.0
	root.add_child(one)
	one.play(0.0)

	var len: float = 0.0
	if one.stream and one.stream.has_method("get_length"):
		len = one.stream.get_length()

	if len > 0.0:
		var t: SceneTreeTimer = get_tree().create_timer(len)
		t.timeout.connect(func():
			if is_instance_valid(one):
				one.queue_free()
		)
	else:
		if one.has_signal("finished"):
			one.finished.connect(func():
				if is_instance_valid(one):
					one.queue_free()
			)

	return len
