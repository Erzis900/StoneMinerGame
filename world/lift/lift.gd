class_name Lift extends Area2D

# exports
@export var movement_speed: float = 32
@export var movement_penalty: float = 4
@onready var bag: Sprite2D = $BagSprite

# private
enum States { READY, UNLOADING, MOVING_DOWN, MOVING_UP }
var state: States = States.READY
var direction: Vector2 = Vector2.DOWN
var stone: int = 0

# signals
signal ready_to_load(is_ready: bool)
signal unloaded(amount: int)

# children
@onready var unload_timer: Timer = $UnloadTimer


func _ready() -> void:
	bag.hide()


func _physics_process(delta: float) -> void:
	if state == States.MOVING_UP:
		move_up(delta)
	elif state == States.MOVING_DOWN:
		move_down(delta)

	add_debug_data()


func move_up(delta: float) -> void:
	position += direction * (movement_speed - movement_penalty) * delta


func move_down(delta: float) -> void:
	position += direction * movement_speed * delta


func add_debug_data() -> void:
	#Debug.add("Lift State", States.keys()[state])
	#Debug.add("Lift Stone", stone)
	Debug.add("Lift Speed", movement_speed)


func _on_lift_stoper_up_area_entered(_area: Area2D) -> void:
	state = States.UNLOADING
	unload_timer.start()


func _on_lift_stoper_down_area_entered(_area: Area2D) -> void:
	if state == States.MOVING_DOWN:
		state = States.READY
		ready_to_load.emit(true)


func _on_miner_request_lift_ready() -> void:
	if state == States.READY:
		ready_to_load.emit(true)
	else:
		ready_to_load.emit(false)


func _on_miner_loot_dumped(amount: int) -> void:
	stone = amount
	bag.show()

	state = States.MOVING_UP
	change_move_direction()


func _on_unload_timer_timeout() -> void:
	unload_timer.stop()
	unloaded.emit(stone)
	stone = 0

	bag.hide()

	state = States.MOVING_DOWN
	change_move_direction()


func change_move_direction() -> void:
	direction.y *= -1
