extends Control
class_name UpgradeGUI

@export var upgrade_tile_scene: PackedScene
@onready var upgrade_container: HBoxContainer = %UpgradeContainer

signal buy_pressed(upgrade: UpgradeData)

var current_gold: int = 0


func _on_response_upgrades(upgrades: Array[UpgradeData]) -> void:
	for child in upgrade_container.get_children():
		child.queue_free()

	upgrades.sort_custom(_compare_upgrade_cost)

	for u in upgrades:
		if u.is_maxed or !u.is_unlocked:
			continue

		var tile = upgrade_tile_scene.instantiate() as UpgradeTile
		upgrade_container.add_child(tile)
		tile.setup(u)
		tile.buy_pressed.connect(_on_buy_pressed)
		tile.update_modulation(current_gold)


func _compare_upgrade_cost(a: UpgradeData, b: UpgradeData) -> bool:
	return a.get_cost() < b.get_cost()


func _on_buy_pressed(upgrade: UpgradeData) -> void:
	buy_pressed.emit(upgrade)


func _on_gold_updated(gold: int) -> void:
	current_gold = gold
	for upgrade in upgrade_container.get_children():
		upgrade.update_modulation(gold)
