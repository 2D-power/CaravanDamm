extends Node
class_name LevelGenerator

static func generate_dummy_level() -> Array[ZoneData]:
	var poly = PackedVector2Array([
		Vector2(0, 0), 
		Vector2(200, 0), 
		Vector2(200, 200), 
		Vector2(0, 200), 
		])
	var pts = [Vector2(50, 50), Vector2(150, 150)]
	var zone = ZoneData.new(poly, pts, Color(0.3, 0.5, 0.8))
	return [zone]
