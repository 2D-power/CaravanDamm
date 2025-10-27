class_name MapGenerator 
extends RefCounted

class ZoneData:
	var points: PackedVector2Array
	var zone_type: int
	
const MIN_TRIANGLES_PER_ZONE = 3

func generate(map_rect: Rect2, num_zones: int) -> Array[ZoneData]:
	var sites := PackedVector2Array()
	var center = map_rect.get_center()
	sites.append(center)
	
	for i in range(num_zones -1):
		sites.append(Vector2(
			randf_range(map_rect.position.x, map_rect.end.x),
			randf_range(map_rect.position.y, map_rect.end.y)
		))
	var result: Array[ZoneData] = []
	for i in range(sites.size()):
		var cell = _compute_voronoi_cell(sites, i, map_rect)
		if cell.size() >= 3:
			var zone_type = Zone.ZoneType.PLAYER if i == 0 else _random_zone_type()
			var zd = ZoneData.new()
			zd.points = cell
			zd.zone_type = zone_type
			result.append(zd)
	return result

func _compute_voronoi_cell(sites: PackedVector2Array, site_index: int, bounds: Rect2) -> PackedVector2Array :
	var cell = _rect_to_polygon(bounds)
	var site = sites[site_index]
	for i in range(sites.size()):
		if i == site_index:
			continue
		var other = sites[i]
		var mid = (site + other) / 2.0
		var normal = (other - site).normalized()
		cell = _clip_polygon_against_halfplane(cell, mid, normal)
		if cell.size() < 3:
			break
	return cell
	
func _clip_polygon_against_halfplane(poly: PackedVector2Array, point_on_line: Vector2, normal: Vector2) -> PackedVector2Array:
	if poly.size() == 0:
		return poly
	var new_poly = PackedVector2Array()
	var len = poly.size()
	
	for i in range(len):
		var current = poly[i]
		var next = poly[(i + 1) % len]
		
		var d1 = normal.dot(current - point_on_line)
		var d2 = normal.dot(next - point_on_line)
		
		var current_inside = d1 <= 0.0
		var next_inside = d2 <= 0.0
		if current_inside:
			new_poly.append(current)
		if current_inside != next_inside:
			var t = d1 / (d1 - d2)
			var intersection = current + t * (next - current)
			new_poly.append(intersection)
	return new_poly
		
	
	
func _rect_to_polygon(rect: Rect2) -> PackedVector2Array:
	return PackedVector2Array([
		rect.position,
		Vector2(rect.end.x, rect.position.y),
		rect.end,
		Vector2(rect.position.x, rect.end.y)
	])

	
func _random_zone_type() -> int:
	var arr = [ Zone.ZoneType.GREEN, Zone.ZoneType.YELLOW, Zone.ZoneType.ORANGE, Zone.ZoneType.RED]
	return arr[randi() % arr.size()]
