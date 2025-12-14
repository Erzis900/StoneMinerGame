class_name StoneWall extends Area2D

signal stone_dropped(amount: int)

func _on_miner_damage_dealt(damage: int) -> void:
	var stone = get_stone_amount(damage)
	stone_dropped.emit(stone)

func get_stone_amount(damage: int) -> int:
	return damage + 5
