class_name HUD extends CanvasLayer


func _on_gold_updated(amount: int) -> void:
	%GoldLabel.text = "Gold: %d" % amount


func _on_level_updated(level: int) -> void:
	%LevelLabel.text = "Level: %d" % level


func _on_xp_updated(xp: int, max_xp: int) -> void:
	%XPLabel.text = "XP: %d / %d" % [xp, max_xp]
