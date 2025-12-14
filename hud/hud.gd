class_name HUD extends Control

@onready var gold_label: Label = $GoldLabel


func _on_gold_amount_changed(amount: int) -> void:
	gold_label.text = str(amount)
