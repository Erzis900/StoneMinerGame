class_name World extends Node2D

# private
var floating_text_manager: FloatingTextManager
var gold: int = 0


func _on_lift_unloaded(amount: int) -> void:
	gold += amount

func _process(delta: float) -> void:
	Debug.add("Gold", gold)
