extends Node3D
@export var map_size: Vector2 = Vector2(100, 100)
@export var min_zones: int = 8
@export var max_zones: int = 15

var zones: Array[Zone] = []
var navigation_points: PackedVector2Array = []

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
		zone.points = data.forposts
		add_child(zone)
		zones.append(zone)
		navigation_points.append_array(zone.points)
		navigation_points.append(zone.get_center_2d())
		for i in range(6):
			navigation_points.append(_random_point_in_polygon(zone.points))
			
	navigation_points = _remove_duplicate_points(navigation_points, 3.0)
	_place_player_castle()
	
func _random_point_in_polygon(poly: PackedVector2Array) -> Vector2:
	var bounds = Rect2()
	for p in poly:
		bounds = bounds.expand(p)
	return Vector2(
		randf_range(bounds.position.x, bounds.end.x),
		randf_range(bounds.position.y, bounds.end.y),
	)

func _remove_duplicate_points(points: PackedVector2Array, epsilon: float = 0.5) -> PackedVector2Array:
	var unique = PackedVector2Array()
	for p in points:
		var is_duplicate = false
		for u in unique:
			if p.distance_to(u) < epsilon:
				is_duplicate = true
				break
		if not is_duplicate:
			unique.append(p)
	return unique
	
func _place_player_castle():
	for zone in zones:
		var object = preload("res://scenes/buildings/PlayerCastle.tscn").instantiate() if zone.zone_type == Zone.ZoneType.PLAYER else preload("res://scenes/buildings/Forpost.tscn").instantiate()
		object.position = zone.get_center_3d()
		add_child(object)
		for fp in zone.points:
			var node_object = preload("res://scenes/buildings/Node.tscn").instantiate()
			node_object.position =  Vector3(fp.x, 0, fp.y)
			add_child(node_object)
	for nav_pt in navigation_points:
			var node_object = preload("res://scenes/buildings/Node.tscn").instantiate()
			node_object.position =  Vector3(nav_pt.x, 0, nav_pt.y)
			add_child(node_object)
	#var player_zone = zones.filter(func(z): return z.zone_type == Zone.ZoneType.PLAYER)[0]
	#if player_zone:
		#var castle = preload("res://scenes/buildings/PlayerCastle.tscn").instantiate()
		#castle.position = player_zone.get_center_3d()
		#add_child(castle)
		#
	#for zone in zones.filter(func(z): return z.zone_type != Zone.ZoneType.PLAYER):
		#var forpost = preload("res://scenes/buildings/Forpost.tscn").instantiate()
		#forpost.position = zone.get_center_3d()
		#add_child(forpost)
