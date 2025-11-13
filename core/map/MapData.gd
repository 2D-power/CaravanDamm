# res://core/map/MapData.gd
class_name MapData

class Zone3D:
	var id: int
	var polygon: PackedVector2Array
	var outposts: Array[Vector2]
	var color: Color

	func _init(p_id: int, p_poly: PackedVector2Array, p_color: Color):
		id = p_id
		polygon = p_poly.duplicate()
		color = p_color

var zones: Array[Zone3D] = []

func get_outposts_in_world_space() -> Array[Vector3]:
	var result: Array[Vector3]
	for z in zones:
		for pt in z.outposts:
			result.append(Vector3(pt.x, 0.0, pt.y))
	return result
