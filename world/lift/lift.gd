class_name Lift extends Area2D

# exports
@export var stats: LiftStats

# private
enum States { READY, UNLOADING, MOVING_DOWN, MOVING_UP, LOADING }
var state: States = States.READY
var direction: Vector2 = Vector2.DOWN
var stone: int = 0

# signals
signal ready_to_load(is_ready: bool)
signal unloaded(amount: int)
signal loaded

# children
@onready var unload_timer: Timer = $UnloadTimer
@onready var load_timer: Timer = $LoadTimer
@onready var progress_bar: TextureProgressBar = $ProgressBar
@onready var bag: Sprite2D = $BagSprite


func _ready() -> void:
	bag.hide()
	progress_bar.hide()

	sync_stats()


func sync_stats() -> void:
	load_timer.wait_time = stats.load_time
	unload_timer.wait_time = stats.unload_time
	progress_bar.max_value = stats.load_time


func _physics_process(delta: float) -> void:
	match state:
		States.MOVING_UP:
			move_up(delta)
		States.MOVING_DOWN:
			move_down(delta)
		States.LOADING:
			load_loot()

	add_debug_data()


func move_up(delta: float) -> void:
	position += direction * (stats.movement_speed - stats.movement_penalty) * delta


func move_down(delta: float) -> void:
	position += direction * stats.movement_speed * delta


func load_loot() -> void:
	progress_bar.value = load_timer.time_left


func add_debug_data() -> void:
	#Debug.add("Lift State", States.keys()[state])
	#Debug.add("Lift Stone", stone)
	pass


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


func _on_unload_timer_timeout() -> void:
	unloaded.emit(stone)
	stone = 0

	bag.hide()

	state = States.MOVING_DOWN
	change_move_direction()


func change_move_direction() -> void:
	direction.y *= -1


func _on_miner_loading_started(amount: int) -> void:
	stone = amount
	state = States.LOADING

	#print(load_timer.wait_time)

	progress_bar.show()
	load_timer.start()


func _on_load_timer_timeout() -> void:
	progress_bar.hide()
	bag.show()
	state = States.MOVING_UP
	change_move_direction()

	loaded.emit()


func _on_upgrade_manager_lift_upgrade_applied(upgrade: UpgradeData) -> void:
	stats.apply_upgrade(upgrade)

	sync_stats()
