extends Resource 
class_name UpgradeData

enum EntityType {MINER, LIFT}

@export var id: String
@export var display_name: String
@export var tiers: Array[UpgradeTier]
@export var entity: EntityType

var current_tier: int = 0
var is_maxed: bool = false

func get_cost() -> int:
	return tiers[current_tier].cost

func get_increase() -> float:
	return tiers[current_tier].increase

func get_entity_type() -> String:
	return EntityType.keys()[entity]
