extends Area2D
class_name EnemyBase

@export var health: int = 1

func take_damage(amount: int = 1) -> void:
	health -= amount
	print("%s took %d damage! Health now: %d" % [name, amount, health])
	if health <= 0:
		die()

func die() -> void:
	print("%s died." % name)
	queue_free()
