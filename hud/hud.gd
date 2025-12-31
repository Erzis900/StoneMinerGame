class_name HUD extends CanvasLayer


func _on_gold_updated(amount: int) -> void:
	%GoldLabel.text = "Gold: %d" % amount
