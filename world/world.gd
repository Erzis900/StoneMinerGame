class_name World extends Node2D

# private
var floating_text_manager: FloatingTextManager
var gold: int = 0
var sub_viewport_size: Vector2i

# signals
signal gold_amount_changed(amount: int)


func _on_lift_unloaded(amount: int) -> void:
	gold += amount

	var text_position = sub_viewport_size / 2
	floating_text_manager.display(text_position, "+%d Gold" % amount, 4.0)

	gold_amount_changed.emit(gold)


func _process(delta: float) -> void:
	Debug.add("Gold", gold)
