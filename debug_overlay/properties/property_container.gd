class_name DebugPropertyContainer extends VBoxContainer

var properties: Array = []


func format_value(value) -> String:
	match typeof(value):
		TYPE_FLOAT:
			return "%.2f" % value
		TYPE_VECTOR2:
			return "[%.2f, %.2f]" % [value.x, value.y]
		_:
			return str(value)


func add_property(id: StringName, value) -> void:
	if !owner.is_debug:
		return

	var display_value: String = format_value(value)

	if properties.has(id):
		var target = find_child(id, false, false) as Label
		target.text = "%s: %s" % [id, display_value]
	else:
		var property = Label.new()
		add_child(property)
		property.name = id
		property.text = "%s: %s" % [id, display_value]
		properties.append(id)
