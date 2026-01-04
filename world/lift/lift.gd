class_name Lift extends Area2D

# exports
@export var movement_speed: float = 32
@export var movement_penalty: float = 4
@onready var bag: Sprite2D = $BagSprite

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


func _ready() -> void:
	bag.hide()
	progress_bar.hide()
	progress_bar.max_value = load_timer.wait_time


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
	position += direction * (movement_speed - movement_penalty) * delta


func move_down(delta: float) -> void:
	position += direction * movement_speed * delta


func load_loot() -> void:
	progress_bar.value = load_timer.time_left


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
	var increase_factor = upgrade.get_increase() / 100 + 1
	match upgrade.id:
		"lift_speed":
			movement_speed = int(movement_speed * increase_factor)
		"loading_speed":
			load_timer.wait_time *= (1 - upgrade.get_increase() / 100)
			progress_bar.max_value = load_timer.wait_time
			print(load_timer.wait_time)
		_:
			push_error("Upgrade not matched")
			return

	#updated.emit(self)
