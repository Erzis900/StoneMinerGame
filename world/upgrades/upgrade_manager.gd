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


func increment_tier(upgrade: UpgradeData) -> void:
	if upgrade.current_tier >= upgrade.tiers.size() - 1:
		upgrade.is_maxed = true
	else:
		upgrade.current_tier += 1

	upgrades[find_upgrade_index(upgrade)] = upgrade
	response_upgrades.emit(upgrades)


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


func _on_request_upgrades() -> void:
	response_upgrades.emit(upgrades)
