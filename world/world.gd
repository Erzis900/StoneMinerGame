class_name World extends Node2D

@onready var upgrade_manager: UpgradeManager = $UpgradeManager
@onready var miner: Miner = $Miner
@onready var lift: Lift = $Lift

# private
var gold: int = 1000

# signals
signal gold_updated(amount: int)


func _ready() -> void:
	miner.xp_manager.level_updated.connect(upgrade_manager._on_level_updated)


func _on_lift_unloaded(amount: int) -> void:
	gold += amount

	FText.display("+%d Gold" % amount, FText.default_position, false, 4.0)

	gold_updated.emit(gold)


func _on_upgrade_buy_pressed(upgrade: UpgradeData) -> void:
	if upgrade.get_cost() <= gold:
		gold -= upgrade.get_cost()
		gold_updated.emit(gold)

		if upgrade.id == "max_hits":
			FText.display("+%d %s" % [upgrade.get_increase(), upgrade.display_name])
		else:
			FText.display("+%d%% %s" % [upgrade.get_increase(), upgrade.display_name])

		upgrade_manager.apply_upgrade(upgrade)
	else:
		FText.display("Not enough gold!")
