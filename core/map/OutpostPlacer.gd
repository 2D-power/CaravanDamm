# res://core/map/OutpostPlacer.gd
class_name OutpostPlacer

static func place_outposts(map_data: MapData, rng: RandomNumberGenerator):
	for zone in map_data.zones:
		var count = rng.randi() % 5 + 2  # 2–6
		var points = _sample_points_in_polygon(zone.polygon, count, rng)
		zone.outposts = points

static func _sample_points_in_polygon(poly: PackedVector2Array, count: int, rng: RandomNumberGenerator) -> Array[Vector2]:
	# Рассчитываем bounding box вручную
	if poly.is_empty():
		return []

	var min_x = poly[0].x
	var max_x = poly[0].x
	var min_y = poly[0].y
	var max_y = poly[0].y

	for pt in poly:
		if pt.x < min_x: min_x = pt.x
		elif pt.x > max_x: max_x = pt.x
		if pt.y < min_y: min_y = pt.y
		elif pt.y > max_y: max_y = pt.y

	var bounds = Rect2(min_x, min_y, max_x - min_x, max_y - min_y)

	var result: Array[Vector2]
	var attempts = 0
	# --- ИСПРАВЛЕНО: Убрана попытка создать экземпляр Geometry2D ---
	while result.size() < count and attempts < count * 20:
		var pt = Vector2(
			rng.randf() * bounds.size.x + bounds.position.x,
			rng.randf() * bounds.size.y + bounds.position.y
		)
		# --- ИСПРАВЛЕНО: Вызов статического метода с правильными аргументами ---
		# point_in_polygon принимает Vector2 (точку) и PackedVector2Array (полигон)
		if Geometry2D.is_point_in_polygon(pt, poly):
			result.append(pt)
		attempts += 1

	# Если не хватает — докинем центр
	while result.size() < count:
		result.append(bounds.get_center())
	return result
