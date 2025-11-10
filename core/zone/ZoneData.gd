extends Node
class_name ZoneData

var polygon: PackedVector2Array = []
var points: Array[Vector2] = []
var color: Color = Color.WHITE

func _init(
	p_poly: PackedVector2Array = [],
	p_points: Array[Vector2] = [],
	p_color: Color = Color.WHITE
) -> void:
	polygon = p_poly.duplicate()
	points = p_points.duplicate()
	color = p_color

func contains_point(pos: Vector2) -> bool:
	return Geometry2D.is_point_in_polygon(pos, polygon)
