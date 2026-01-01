extends Control
class_name UpgradeGUI

@export var upgrade_tile_scene: PackedScene
@onready var upgrade_container: HBoxContainer = $UpgradeContainer

signal request_upgrades
signal buy_pressed(upgrade: UpgradeData)


func _ready() -> void:
	await get_tree().process_frame
	request_upgrades.emit()


func _on_response_upgrades(upgrades: Array[UpgradeData]) -> void:
	for child in upgrade_container.get_children():
		child.queue_free()

	for u in upgrades:
		if u.is_maxed:
			continue

		var tile = upgrade_tile_scene.instantiate() as UpgradeTile
		upgrade_container.add_child(tile)
		tile.setup(u)
		tile.buy_pressed.connect(_on_buy_pressed)


func _on_buy_pressed(upgrade: UpgradeData) -> void:
	buy_pressed.emit(upgrade)
