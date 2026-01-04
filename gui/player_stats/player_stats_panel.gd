extends PanelContainer
class_name PlayerStatsPanel

@onready var movement_speed_label: Label = %MovementSpeedLabel
@onready var damage_label: Label = %DamageLabel
@onready var mining_speed_label: Label = %MiningSpeedLabel
@onready var max_hits_label: Label = %MaxHitsLabel
@onready var crit_chance_label: Label = %CritChanceLabel
@onready var crit_multi_label: Label = %CritMultiLabel


func _on_player_stats_updated(stats: MinerStats) -> void:
	movement_speed_label.text = "Movement Speed: %d px/s" % stats.movement_speed
	damage_label.text = "Damage: %d per hit" % stats.damage
	mining_speed_label.text = "Hit Time: %0.2f s" % (0.6 / stats.mining_speed)  # TODO: Get rid of magic value
	max_hits_label.text = "Maximum Hits: %d" % stats.max_hits
	crit_chance_label.text = "Critical Hit Chance: %d%%" % stats.crit_chance
	crit_multi_label.text = "Critical Hit Multiplier: 1.%dx" % stats.crit_multi
