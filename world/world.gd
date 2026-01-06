class_name World extends Node2D

@onready var upgrade_manager: UpgradeManager = $UpgradeManager
@onready var miner: Miner = $Miner

# private
var floating_text_manager: FloatingTextManager
var gold: int = 0
var sub_viewport_size: Vector2i

# signals
signal gold_updated(amount: int)


func _on_lift_unloaded(amount: int) -> void:
	gold += amount

	var text_position = sub_viewport_size / 2
	floating_text_manager.display(text_position, "+%d Gold" % amount, false, 4.0)

	gold_updated.emit(gold)


func _on_upgrade_buy_pressed(upgrade: UpgradeData) -> void:
	if upgrade.get_cost() <= gold:
		gold -= upgrade.get_cost()
		gold_updated.emit(gold)

		if upgrade.id == "max_hits":
			floating_text_manager.display(
				sub_viewport_size / 2, "+%d %s" % [upgrade.get_increase(), upgrade.display_name]
			)
		else:
			floating_text_manager.display(
				sub_viewport_size / 2, "+%d%% %s" % [upgrade.get_increase(), upgrade.display_name]
			)

		upgrade_manager.apply_upgrade(upgrade)
	else:
		floating_text_manager.display(sub_viewport_size / 2, "Not enough gold!")
