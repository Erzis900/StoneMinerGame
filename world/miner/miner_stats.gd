extends Resource
class_name MinerStats

@export var movement_speed: int = 64
@export var damage: int = 10
@export var max_hits: int = 3
@export var mining_speed: float = 1
@export var crit_chance: float = 80
@export var crit_multi: float = 50

signal updated(stats: MinerStats)


func apply_upgrade(upgrade: UpgradeData) -> void:
	var increase_factor = upgrade.get_increase() / 100 + 1
	match upgrade.id:
		"movement_speed":
			movement_speed = int(movement_speed * increase_factor)
		"damage":
			damage = int(damage * increase_factor)
		"mining_speed":
			mining_speed *= increase_factor
		"max_hits":
			max_hits += int(upgrade.get_increase())
		"crit_chance":
			crit_chance *= increase_factor
		"crit_multi":
			crit_multi *= increase_factor
		_:
			push_error("Upgrade not matched")
			return

	updated.emit(self)


func get_hit_data() -> HitData:
	var is_crit = randf() < crit_chance / 100
	var hit_damage = damage
	if is_crit:
		hit_damage = damage * (1.0 + crit_multi / 100)

	var result = HitData.new()
	result.damage = hit_damage
	result.is_crit = is_crit
	return result
