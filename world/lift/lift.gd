class_name Lift extends Area2D

# exports
@export var movement_speed: float = 32

# private
enum States { READY, UNLOAD, MOVING }
var state: States = States.READY
var direction: Vector2 = Vector2.DOWN

# signals
signal response_lift_ready(is_ready: bool)

# children
@onready var unload_timer: Timer = $UnloadTimer


func _physics_process(delta: float) -> void:
	if state == States.MOVING:
		move(delta)

	add_debug_data()


func move(delta: float) -> void:
	position += direction * movement_speed * delta


func add_debug_data() -> void:
	Global.debug.add_property("Lift State", States.keys()[state])
	Global.debug.add_property("Lift Position", position)


func _on_lift_stoper_up_area_entered(area: Area2D) -> void:
	state = States.UNLOAD
	unload_timer.start()


func _on_lift_stoper_down_area_entered(area: Area2D) -> void:
	if state == States.MOVING:
		state = States.READY
		response_lift_ready.emit(true)


func _on_miner_request_lift_ready() -> void:
	if state == States.READY:
		response_lift_ready.emit(true)
	else:
		response_lift_ready.emit(false)


func _on_miner_loot_dumped() -> void:
	state = States.MOVING
	change_move_direction()


func _on_unload_timer_timeout() -> void:
	unload_timer.stop()
	state = States.MOVING
	change_move_direction()


func change_move_direction() -> void:
	direction.y *= -1
