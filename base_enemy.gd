extends Area2D
class_name EnemyBase

@export var health: int = 10
var points = 10
signal givePoints

func take_damage(amount: int = 1) -> void:
	health -= amount

	_play_flash_if_present()  # <-- LÄGG TILL DENNA RAD

	print("%s took %d damage! Health now: %d" % [name, amount, health])
	if health <= 0:
		die()

func _play_flash_if_present() -> void:
	# Försök hitta AnimationPlayer på den här instansen (barn: Sprite2D/FlashAni)
	var ap := get_node_or_null("Sprite2D/FlashAni") as AnimationPlayer
	if ap:
		ap.stop()        # starta om om den redan spelas
		ap.play("flash") # byt till rätt namn om din animation heter något annat

func die() -> void:
	print("%s died2." % name)
	emit_signal("givePoints", 10)
	queue_free()
