extends Node3D
@export var map_size: Vector2 = Vector2(100, 100)
@export var min_zones: int = 8
@export var max_zones: int = 15

var zones: Array[Zone] = []

func generate_random():
	zones.clear()
	for child in get_children():
		if child is Zone:
			child.queue_free()
	var generator = MapGenerator.new()
	var zone_data = generator.generate(
		Rect2(-map_size / 2, map_size),
		randi_range(min_zones, max_zones)
	)
	for data in zone_data:
		var zone = preload("res://scenes/zone/Zone.tscn").instantiate()
		zone.points = data.points
		zone.zone_type = data.zone_type
		add_child(zone)
		zones.append(zone)
	_place_player_castle()
	

func _place_player_castle():
	var player_zone = zones.filter(func(z): return z.zone_type == Zone.ZoneType.PLAYER)[0]
	if player_zone:
		var castle = preload("res://scenes/buildings/PlayerCastle.tscn").instantiate()
		castle.position = player_zone.get_center_3d()
		add_child(castle)
