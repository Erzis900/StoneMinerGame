extends PanelContainer
class_name UpgradeTile

@onready var name_label: Label = %NameLabel
@onready var cost_label: Label = %CostLabel
@onready var tier_label: Label = %TierLabel

signal buy_pressed(upgrade: UpgradeData)

var loaded_upgrade: UpgradeData


func setup(upgrade: UpgradeData) -> void:
	if upgrade.id == "max_hits":
		name_label.text = "+%d %s" % [upgrade.get_increase(), upgrade.display_name]
	else:
		name_label.text = "+%d%% %s" % [upgrade.get_increase(), upgrade.display_name]

	tier_label.text = "Tier: %d" % (upgrade.current_tier + 1)
	cost_label.text = "Cost: %d Gold" % upgrade.get_cost()

	loaded_upgrade = upgrade


func _on_buy_button_pressed() -> void:
	buy_pressed.emit(loaded_upgrade)
