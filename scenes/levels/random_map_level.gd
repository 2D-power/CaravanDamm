extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var map = preload("res://scenes/map/GameMap.tscn").instantiate()
	add_child(map)
	map.generate_random()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
