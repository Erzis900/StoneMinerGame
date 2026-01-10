extends Resource
class_name UpgradeData

enum EntityType { MINER, LIFT }

@export var id: String
@export var display_name: String
@export var tiers_data: TiersData
@export var entity: EntityType
@export var required_level: int = 0

var current_tier: int = 0
var is_maxed: bool = false
var is_unlocked: bool = false


func get_cost() -> int:
	return tiers_data.tiers[current_tier].cost


func get_increase() -> float:
	return tiers_data.tiers[current_tier].increase


func get_entity_type() -> String:
	return EntityType.keys()[entity]
