extends Node

var property_container: DebugPropertyContainer

func add(id: StringName, value) -> void:
	property_container.add_property(id, value)
