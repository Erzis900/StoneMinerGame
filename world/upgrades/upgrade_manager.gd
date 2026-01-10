extends Node
class_name UpgradeManager

signal response_upgrades(upgrades: Array[UpgradeData])
signal miner_upgrade_applied(upgrade: UpgradeData)
signal lift_upgrade_applied(upgrade: UpgradeData)

@export var upgrades: Array[UpgradeData] = []


func apply_upgrade(upgrade: UpgradeData) -> void:
	match upgrade.get_entity_type():
		"MINER":
			miner_upgrade_applied.emit(upgrade)
		"LIFT":
			lift_upgrade_applied.emit(upgrade)

	increment_tier(upgrade)
	send_upgrades()


func increment_tier(upgrade: UpgradeData) -> void:
	if upgrade.current_tier >= upgrade.tiers_data.tiers.size() - 1:
		upgrade.is_maxed = true
	else:
		upgrade.current_tier += 1

	upgrades[find_upgrade_index(upgrade)] = upgrade


#func find_upgrade(id: String) -> UpgradeData:
#for u in upgrades:
#if u.id == id:
#return u
#
#return null


func find_upgrade_index(upgrade: UpgradeData) -> int:
	for i in upgrades.size():
		if upgrades[i].id == upgrade.id:
			return i
	return -1


func _on_level_updated(level: int) -> void:
	var unlocked_changed := false

	for i in upgrades.size():
		var u = upgrades[i]
		var was_unlocked = u.is_unlocked
		u.is_unlocked = level >= u.required_level

		if was_unlocked != u.is_unlocked:
			unlocked_changed = true
			upgrades[i] = u

	if unlocked_changed:
		send_upgrades()


func send_upgrades() -> void:
	response_upgrades.emit(upgrades)
