extends Resource
class_name LiftStats

@export var movement_speed: float = 32
@export var movement_penalty: float = 4
@export var load_time: float = 1.0
@export var unload_time: float = 2.0

signal updated(stats: LiftStats)


func apply_upgrade(upgrade: UpgradeData) -> void:
	var increase_factor = upgrade.get_increase() / 100 + 1
	match upgrade.id:
		"lift_speed":
			movement_speed = int(movement_speed * increase_factor)
		"loading_speed":
			load_time *= (1 - upgrade.get_increase() / 100)
		"unloading_speed":
			unload_time *= (1 - upgrade.get_increase() / 100)
		_:
			push_error("Upgrade not matched")
			return

	updated.emit(self)
