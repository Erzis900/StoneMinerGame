class_name HUD extends Control

@onready var gold_label: Label = $GoldLabel


func _on_gold_updated(amount: int) -> void:
	gold_label.text = str(amount)
