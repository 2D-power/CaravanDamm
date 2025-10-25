extends Node2D

const ZoneScript = preload("res://Scripts/Nodes/zone_2d.gd")
var zone_scene = preload("res://Nodes/Zone2d.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	_create_zones()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func grid_to_world(grid_pos: Vector2) -> Vector2:
	return Vector2(
		(grid_pos.x - grid_pos.y) * 16,
		(grid_pos.x + grid_pos.y) * 8
	)

func _create_zones():
	var zones_count = randi_range(8, 15)
	var zone_types = []
	var occupied_cells = {}
	var zones = []
	
	var spiral_positions = _generate_spiral_positions(200)
	
	zone_types.append_array([ZoneScript.ZoneType.GREEN, ZoneScript.ZoneType.YELLOW, ZoneScript.ZoneType.ORANGE, ZoneScript.ZoneType.RED])
	var remaining = zones_count - 4
	for i in range(remaining):
		zone_types.append(randi() % 4)
		
	zone_types.shuffle()
	for zone_type in zone_types:
		var zone = zone_scene.instantiate()
		zone.zone_type = zone_type
		zone.generate_random_shape()
		var offset: Vector2
		
		#################### NEW рисуем по кругу
		var found = false
		for candidate_pos in spiral_positions:
			var colission = false
			for t in zone.tiles:
				var world_cell = t + candidate_pos
				if occupied_cells.has(world_cell):
					colission = true
					break
			if not colission:
				offset = candidate_pos
				found = true
				
		if not found:
			offset = spiral_positions.back()
		for t in zone.tiles:
			occupied_cells[t + offset] = true
		zone.position = grid_to_world(offset)
		add_child(zone)
		zones.append(zone)
		#################### NEW
		
		
		#
		#if zones.is_empty():
			#offset = Vector2(0, 0)
		#else:
			#var candidates = []
			#for cell in occupied_cells:
				#var neighbors = [
					#cell + Vector2(1, 0),
					#cell + Vector2(-1, 0),
					#cell + Vector2(0, 1),
					#cell + Vector2(0, -1),
				#]
				#for n in neighbors:
					#if not occupied_cells.has(n):
						#candidates.append(n)
			#candidates = candidates.duplicate()
			#candidates.sort()
			#var unique_candidates = []
			#var last = null
			#for c in candidates:
				#if c != last:
					#unique_candidates.append(c)
					#last = c
			#candidates = unique_candidates
			#var found = false
			#for candidate in candidates:
				## var proposed_offset = candidate - zone.tiles[0]
				#var random_tile = zone.tiles[randi() % zone.tiles.size()]
				#var proposed_offset = candidate - random_tile
				#var collision = false
				#for t in zone.tiles:
					#var world_cell = t + proposed_offset
					#if occupied_cells.has(world_cell):
						#collision = true
						#break
				#if not collision:
					#offset = proposed_offset
					#
					#break
			#if not found:
				#var max_i = -INF
				#for cell in occupied_cells:
					#max_i = max(max_i, cell.x)
					#offset = Vector2(max_i + 10, 0)
		#for t in zone.tiles:
			#occupied_cells[t + offset] = true
		#zone.position = grid_to_world(offset)
		#
		#add_child(zone)
		#zones.append(zone)
		
func _generate_spiral_positions(max_steps: int) -> Array:
	var positions = []
	var x = 0
	var y = 0
	var dx = 0
	var dy = -1
	var step = 0

	while step < max_steps:
		positions.append(Vector2(x, y))
		step += 1

		# Поворот по спирали (вправо при необходимости)
		if (x == y) or (x < 0 and x == -y) or (x > 0 and x == 1 - y):
			# Поворачиваем направление: (dx, dy) → (dy, -dx)
			var temp = dx
			dx = -dy
			dy = temp

		x += dx
		y += dy

	return positions
