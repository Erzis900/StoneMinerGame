extends Node

@export var mining_particles: PackedScene


func _on_miner_wall_hit(position: Vector2) -> void:
	var particles_instance = mining_particles.instantiate()
	add_child(particles_instance)
	particles_instance.position = position
