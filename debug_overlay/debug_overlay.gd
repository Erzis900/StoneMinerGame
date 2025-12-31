class_name DebugOverlay extends CanvasLayer

var is_debug: bool = false


func _ready() -> void:
	visible = is_debug
	Debug.property_container = %PropertyContainer


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("debug"):
		is_debug = !is_debug
		visible = is_debug
